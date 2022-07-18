Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48B578673
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiGRPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiGRPcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:32:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C7822B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTJL9rG48ginNahonFg0QahBiP23pusEMtBrkQfszsOR4YDOv4Nl5FmgORLUoWxeW6v8kMwvaq2c1J5m3iRpwMTWznF6A4HZBnm5buClXTVlnbHf1ExikchYe5CxVbk8N4cXkkJ7LKfrY+LLnjKLMLrGQxwudby7Llt4hBvbW/hNdRVgJmdYpg/kDkDXiHH/YrWInpEglK8NdyUOJ0/gp4PvPbsh6QK4vW6PDImZrNJgASI9nNmB1QvnKfVBf6f9L9nzXVzgzRBNNOvxa168EfHCP1b/koGXGwxg8B8az2YyaktTrCXP8ujEAyoOtIFyVM9Q3wuVkwi2hWE74d3ZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=WVpG1mz+KKkFKZweY+voCSZqRN6UKLtOnqDPwe5PIQAE5ad6sVp0sRdVa5O2Ir0u1riP+HeHslomVyalurBYY1fyVeNodfMTFziPuf2x7lQ6SamlmC6Zk57LHj3TwUsTzHnazsGJJb6MPLAk5DMPUgu1hdJD3pujPfq4Dsd/bs28f/NHmt5OUxGu3dmr5OjOrH6F3P2gUH+B8U7oFF58iVeQ0b4aG7bbn+mGVpHdjZ5/mZL+jZfnZTyj0UnBVwdAuehdAwwQVqLhQLMrlhVqVTm+dqANhtuy1AZIzJCXLOnJqs4PLPTzAV332ZIGTIsk19TzuDEqMTto3xHHL8QfRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=jRNvx5FgfK5q0EL6ZNRtqKRSn5FTmU56llUyOa36+hq3+3Ry4mhBCIqdtZpVyPmRok7Hx9IECytvBdX08HJwG/P8Ng9EIV2OOzwz1aeG96XyzjvJ+m0QcTTldqr+YydR1YMu+MkUuUBC0xMSsrpWEFcc0ivq5JW5gk+uAA98/8meNNQYAP0hPTY8rQ7I8apqkzOOdMffvWPglNkQPe+UuJ0xL3uCJ3K6YTTKqz4Y8i1+WkDIvuaXdGgt06hCMHZ1W59f6m2bvFBBJ8cySE1XCNojMyoyYGghrOySOXaqfYpAYPqryAMtxJ0asN8RrG0hsvJfwwRoYNZ0G88+4kPi9A==
Received: from BN9PR03CA0240.namprd03.prod.outlook.com (2603:10b6:408:f8::35)
 by MN0PR12MB5764.namprd12.prod.outlook.com (2603:10b6:208:377::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 15:32:52 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::45) by BN9PR03CA0240.outlook.office365.com
 (2603:10b6:408:f8::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:51 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:48 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:48 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:47 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 05/10] sfc: add basic ethtool ops to ef100 reps
Date:   Mon, 18 Jul 2022 16:30:11 +0100
Message-ID: <2168a9e9a0fd349dfc60e3c18b1b3406c944b5aa.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44299139-5bae-42c9-b43c-08da68d2c719
X-MS-TrafficTypeDiagnostic: MN0PR12MB5764:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G9G2dvS+b1G5w4vrKrrPwNMVPCuXxHzi/vfJN4l/iLudT0XOeKCvD8Oj7W2D1wWe38Wjk+x9PLI415xWNqAHxbKMOMnRhZij7JmOa43N6jjXPjAqhwjNFfYfVV5vf078vsHK9rXQEFB0nBYUvSGNMFZNB0N4aZriHJOn1GJGaFJiUJsBHT/b8Q8mN6E7im1SkBUqZveawAuwozHr+6+jP9gWEjK05w8fJiZlrTut9fwtziMFu3a2T4whEOdIBikN869XgpA++wVUbWATxa51G9hWZiuaQotNmglQmreRSvHpHnShooeIS4pWUWOJvr+XdduFYPxGV/owWouncPtnt3s00X0SBMjGwxQESLALCn+dWJs+KTTsDIzSWX9Q3i5p9pq9NL0jzJ0fJsScdksxkwwfH747g6Uvi8Bsv3CybKVRKu4C0e+IpTCCy1Ciy7QaA145D1hZZfClOORxwzAAYigW4IkQobl7qp1pO4SyotXEcNxY7aRJfN/rOFMWMaGjZHcMbb4toIkPME2GLWeNuTffJNXpTApovLVNltIKGZwf6kESn11VaD0s5zPHYv2dGOyfwuMsC+hlSTQ6+8sC0N4tb2OJBg2+XMekgzLtQLkElR9GM4+IDrPCELGOjDy2w4TwjnxQ4gSjhIy7+6LtUGqiOvCQbLFjag3KL3QGXHtPJWWEQNOatYVP+lCuLYLE+iJ8uq+oB3saWTNCY55eWtspwWkfwgX2OXsYKYOes4mR+cq7qyUYloeObkGGj7jXbrLmr/WTNikiNkQJkZh+G8bA7MH8hMhgQnsE1AGFfEZeKNdsz57n489Xr65DjoGeW7HQ2yMwKdWJ9tWP3XEapB8EdssWLYeE+0M9J56ZEes=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(40470700004)(46966006)(316002)(54906003)(110136005)(4326008)(2906002)(9686003)(26005)(55446002)(6666004)(2876002)(8676002)(41300700001)(5660300002)(36756003)(8936002)(186003)(336012)(47076005)(70586007)(40480700001)(82740400003)(82310400005)(83170400001)(40460700003)(42882007)(70206006)(478600001)(356005)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:51.8336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44299139-5bae-42c9-b43c-08da68d2c719
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5764
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
