Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB98C57BDCC
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240910AbiGTSbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiGTSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C61709A3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1yWbo33zmoshvFeDkSIUhrspW9rmyqqDjjxxXGCZWrLUHWPiWCwK3bF2nwWoBh3D8YOxUVWab2uWaMS8mcCYdgDtr3UI/+SDNg1AxeQXufh1B3cIRJa3gMOvvoQc4ayEOiOxBsRYjb2tmkCpPm+sycUpdaMrmFxc9MONr7+QLz/vF4OYja/liTw69gaSaE/LTPZc7/7AaqR9fbPDLeNE+n6FUIMzqikHQd9M+/sivBaqQooRFdl3cIDqyitTYJ6ey2pFIuP5gbJTaIj7i6ZCPLsWtRahlnWXlbM040Wch9FXQTEE+zamIKIOQIYZZms8e9Ih1cJtYFol5kJha+WIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=AC7KcnyVgLtJGl5Bmy2DPTgGIHrj7vPyMr3M0W977Yai+3D60sq+VMls5ECf6V6276oMqPN26wFsuE0z3a9CHEjddRFb5sdXXLbUaa73mVW6tQtG0C92nxzy6DtLuf3H1tpMgRudjlkCw+A99r8KKTkuUvxNWay2PB5ykzM2ss77HimAyXVkAakdKWMIJlbeQNZ/4RheJNJkVohga1uEUdDQ+J4Hns6xo49ri/p1dH+pWhE1NaoRbR3lTB+tDA/cNRpZlZiAN1As0+tfd8aBAHautK3mWMknOjrMjAuS1cz4kevxH9uF+8ra5+PPs9f7emgqrXmFPeggXzXleGPsSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=pGnbNXjzzRTDJfG6fjhkWW2C8VhsLyMaO7/qtM0S5M+ToT5dDkJBDE4TQi3Ir6lHPrnjLImfwmMwnGHVtdkRmf1NQ4LN1HylGyOJr7RwKZOVw8iUSJzaVWIGWlKNBMJ7EnFY+u3AKozKpQ9lz8s3Iy3403Nyy47zUFjmzRHjvP0dHLj/gZ+O+jcPbxlZ/LgeHwwGSfFAbqz+PWtYe9yWn5OGN/o7bUzenvNH05jgXYw8neSSKs3hyjrd5YO6Dz5xv8NA/QL/OvE20XMBQ4p64FNAt0TTz8pIOXN4Uuwjkx5v3S5FO6pkzahUySyE4GH5hS2AHSiW0hw3RtcuDSeIXA==
Received: from DM6PR02CA0120.namprd02.prod.outlook.com (2603:10b6:5:1b4::22)
 by SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Wed, 20 Jul
 2022 18:31:01 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::e2) by DM6PR02CA0120.outlook.office365.com
 (2603:10b6:5:1b4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:01 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:31:00 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:31:00 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:59 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 05/10] sfc: add basic ethtool ops to ef100 reps
Date:   Wed, 20 Jul 2022 19:29:32 +0100
Message-ID: <2168a9e9a0fd349dfc60e3c18b1b3406c944b5aa.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6ab28fd-2bad-4608-9898-08da6a7dff64
X-MS-TrafficTypeDiagnostic: SN1PR12MB2448:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dA1B9uaALD1ZjbvLmyvJUuAO3duaGRnZeFZA5LeMbdcUWP0ta+ZNaNtysou0HvzdthGikHrCeP0xNb/aqILM1hUXcsmNM7XwRu7iEVOvDx2HeNPPiUaLDI/D4DSguoRVyNflDst7/pv0ypdOMJeW077SLV9WiJ19II0mnJzKmc/R/692Lq9h2+RGvJD8dbdpqoDcgDxXjYXugMtfxSEOU6rhN1OK2aUpvcVge0t+XmRJHBV4bGd6lrc8dVw8rITGapZq+1IM476QEgTnfiLOen2DYa7PYHzlTVvZujD3+UVXk1c3GF9Am00Q0gxsx35Ehor46T8j2Xw8WYEvFp/VA9YWCLpmg2Ck1rBOOeewMnIQ+J0VI8z90Fv+Qgrki8SzfCQ41mu8a48HN9s2qK4QXIdil7I9WW3l1xw3oDNEhhi5biz8ku3FVNrnXJfMEB20+mpXnZV4MaJRtt2XfISL/oNGzsnH9t40WdWo9nfh2mK+dHHPxezdE9Cf/bl/bNllm2LJzGySMLztpZHiGg+pZYGyymKskQwmqaypRb0KppYXiArAP4wtkadQXRPfBUoRBtmGvRtv1Gl5nlPZ2aJs0Dy07Pxw8YA/97WKb04hgMRtzFqe7Aqh/0gqKrw3qBI7NNtUDBUAwHYiWJLX3GoIVuH8Gv6FrB7lLYWmzCTEC8f4unNvBOEmAQlmKYF01XiocpHiHozwB0ddZYBLiebmE136fOl/sXY9dZeZ2YEjZfZdGmCgXmOli5s4SRqhDXTbLFYDoCYUCCSf2BscTky3MZMQK/6jqkl6vsQ0tGOP+WTAIBAKcx2zekQsLGZ2ULH5W0s2cBJi3lJq16rtA6Lkhg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(40470700004)(186003)(42882007)(40480700001)(110136005)(4326008)(8676002)(336012)(70586007)(54906003)(47076005)(70206006)(9686003)(36756003)(26005)(2906002)(6666004)(2876002)(55446002)(478600001)(82310400005)(8936002)(36860700001)(40460700003)(5660300002)(316002)(81166007)(41300700001)(356005)(82740400003)(83170400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:01.3491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ab28fd-2bad-4608-9898-08da6a7dff64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2448
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
