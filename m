Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6F5761CD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbiGOMgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiGOMgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6597479E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cl9OM9OusEuts9fn0JKFMXcPsBChxi9MQxeQLQMEHtoSR7+kluBtMXjTJgXnqy1xb5bvzkQOepBAFpGZmf2q6YJjePq9mE/mLXPeK71unBP8u4qICX5/ApXTRAJdUnPDtoR6fL4KItmCTfgpKPHMuGbfShbrcTSgUxwlh3JEc6jbX21cRJRvQIkbXIsqu9y/V8R9vtkBitEhIPKvo10GYTBjuFfflrn+pL15JCToNuKJJ9hEd4mm761KHgONm2PPwenP9+TKEECYRaVusK+yp9KAVRCkoqZ0boRhmKYIcNIzGpEjMk7/A+rNNdYfXqud9EIyGsrp5P6jzaojTjIUzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=esB8anPvl4jKcLec3bkkrBZ/ANupfQtsVMGTIzXAKn/ehbOZwUI4KAQmrewlhO79OSLUl3rLq2dCUuFrGhQN7/CZYzoo5FDB3ZiC1YFZl/fmX6g+wAwL/z59J6dtOXERMV8DIAqFt81DvGzFOqMxFdUR5vN7woXXutgPlN8Kv4OSD8dv9MwBpHdp0Tjuc8CSRgms9yJ9IdvLbqqn8UrraUgIMhBptyl6TOUCq7+pNBXuCx/0AJxdCdoKtjQtXI6CTxtY4BWPt+ymt7ezCi4s6uWxgOya8Smsh39mM2MItwGGhkb52StqgL7di8y48giMg4badtjdGLfOuG7/u2Y28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=iHtPEpIvWF498nyvZkXekJ7ztJwb6LPBa0w95ej84llYJjFzg1ir1XkUmCbd8sFmiTS5bHyAuFXEs+uIdzNnCbiLAOFOvcMRo+glkRWsvG0YS1ZcVazhILip83sjuYumP6kiz6GkbeTo+b6p9ONOwmGAr7q81hZLMpZXxNeWnO6E8W5hjP/jMbLOGd/zmZd8saTPuIKRhUVXTS1i6zAq9ubMm7xxhyrHtp0qEElRz+XKPP3/THx3c9uwbq9elH5ltXN9kDT/RuzmK3pbHz8nrvzbLh9I36ztD+8uI95zY57L43Rr9hdxkxx5yBF3EViaVWQuF+sk7vNNPYChtXvKIg==
Received: from MW4P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::35)
 by CH2PR12MB3863.namprd12.prod.outlook.com (2603:10b6:610:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 12:36:16 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::8c) by MW4P222CA0030.outlook.office365.com
 (2603:10b6:303:114::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:15 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:14 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:13 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:12 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 05/10] sfc: add basic ethtool ops to ef100 reps
Date:   Fri, 15 Jul 2022 13:33:27 +0100
Message-ID: <aff14274511d2ed9ec36b6c67a3d90aca63d5d41.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c21623-adc4-4498-c272-08da665e9be7
X-MS-TrafficTypeDiagnostic: CH2PR12MB3863:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mdzbs0KuUhYb28bcPVVG8Wcp+ltvp3Q/BM1pVoRmePRJNOxNAXg+4bo4lPSA/D0xnfrDl/fKy8sPIXA1shMz/mY/7+BUxhT/5NpxIBdifm2tgBKgK/v1vg/KigdXdIx2br/SpbMOSMQlGOeMds6FK0BpF89YsCMQoP7rMwLEUuj4xVvi7cgJ2Yc3cZviO42wtsT3/13xlX4dioXiFRr6v/qcWQ/LHFxVZo2JZun3CI3uKXCO53M8JYc85mxA9pZZNh3aTqJJcqM+lO0f7vBdo60c+di0vMC9IS7VEH7hcz/lp2uos44clIyFSq+FnRXo1jEfaBqfw3e38k5F4wKfU/YCShgdOBUv2wzmnBVQLgCKHP0zf4a2qM2eAwzRNJwLIMj/mMVNBbTovTOblY81iNQ787NC7kSHUBOwHXsDSnGhUDR741NGDGrX/V2VriKm+HExsWjVc6RwMdk2Oo3XYbQkgnwcYjB3ixhSP69iIYOtpUW4Gg4TTZY3RK21n72BM/e/nv4V7kADDHu1pXzzrELpGh06Ri6N7s1y5oCtqQUcQbUByXvWGgWs65MyVBGiY+v2qZBobHtdNEA43ErXwrV4gA8CcO164T86lMxbuPksBOejlG8puyfmaW/IWBt1Orj5ATxOQD9X4GCQULUZyJnjSu41TFx3QFqPCG9sjXd8NdW1xsXlTNBToG5WQzTZXPly7wpdWggUmkBLyFeW0ZArBe1Aos+sI0xHfCXotZBdI0Lv02BxPZSUz4EolaQhIQual/vUlHQ3YAx0/ObmYJOj0E1H+oVDGWtOpNTz9S2SIxUIqqnLQ98JwKe6wCDIOZUft4aCIOzcglwYx09LOo0Mq3ezvhd4Y/SBkQVq9cU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(36840700001)(46966006)(40470700004)(55446002)(316002)(70586007)(4326008)(478600001)(186003)(356005)(42882007)(8676002)(54906003)(110136005)(70206006)(9686003)(41300700001)(6666004)(82310400005)(40460700003)(26005)(2876002)(36860700001)(36756003)(40480700001)(5660300002)(8936002)(2906002)(47076005)(81166007)(82740400003)(83170400001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:15.3087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c21623-adc4-4498-c272-08da665e9be7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3863
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index f10c25d6f134..1121bf162b2f 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -12,6 +12,8 @@
 #include "ef100_rep.h"
 #include "ef100_nic.h"
 
+#define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
+
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
 {
 	efv->parent = efx;
@@ -26,7 +28,31 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 };
 
+static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
+				      struct ethtool_drvinfo *drvinfo)
+{
+	strscpy(drvinfo->driver, EFX_EF100_REP_DRIVER, sizeof(drvinfo->driver));
+}
+
+static u32 efx_ef100_rep_ethtool_get_msglevel(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	return efv->msg_enable;
+}
+
+static void efx_ef100_rep_ethtool_set_msglevel(struct net_device *net_dev,
+					       u32 msg_enable)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	efv->msg_enable = msg_enable;
+}
+
 static const struct ethtool_ops efx_ef100_rep_ethtool_ops = {
+	.get_drvinfo		= efx_ef100_rep_get_drvinfo,
+	.get_msglevel		= efx_ef100_rep_ethtool_get_msglevel,
+	.set_msglevel		= efx_ef100_rep_ethtool_set_msglevel,
 };
 
 static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
