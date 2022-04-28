Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B155139D4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbiD1QcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349411AbiD1QcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:32:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F604ABF42;
        Thu, 28 Apr 2022 09:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6MwMJNimY+cbju1LT89lPK4plhXSVDcVQXj4fmD7tENhEbTbBtnvBZ7Xi7NaP/lRpUqGUC3OFwKBMJUnpDDQMA5tG8eemG8Zcg1Q6S7Fdr1+OcAnFuQuhNibkcTTnCwwUlSi3somD0O7Siyumc0qZMu9WlYFEgAUGulKGT1qRY2Q1l0ygv8ALn3P2fcQjhgJG4LxLhEykY0MObTP/m2g6h7nr0r25tiGz56gqigsjfFMfJvX8V7UMNB6HFu2OHvAKXpYeB1kZOPc2LfahnhsBB/mUp8BFFAqMfYDVyoQOr01uy5e8eG4JIq0/Bj2bBkYVWrkmwgsCQ2axyeYsxThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpk6xWWnC0w56/WGt8wDFjPihVI0LeOVanmVBweZGP8=;
 b=X22+uoKuY5TBc3/LTR9d5Yfx3maLAFT5oWHeputWieiKBrD4C9/0UccdlWVnq1YvVKYF8G4xgbNjvVw9/KUpydjFKwi2k2UoZat1l9k03HJIuk3W4MKT7j00SUM8wQe/vNDl1fYiSZMDwBsVHVeLiXgQuAnIpp2v4A+2nKNWFvCOU+P3dyGsxeGt7Ij7/6X/26logv+kiQoe818cu4syQC4BaKXH2PA7ZTtO4K++DqR8zW+OAqrAQu12SU+sWKiIoYfBfZc0NNfPOw+4Xkc1Rclp+5Aod+Mf4GZiKhu8+VFgofgwqa5iEkUeeYVEThav3Ou0V+SYOz3VI4uWfbeYGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpk6xWWnC0w56/WGt8wDFjPihVI0LeOVanmVBweZGP8=;
 b=E0xPVtUyi5Nyx5GUf6AI2CxZ0mXg0jPYURSE6mkoRMPdSeZFKxlrevQvD30citg0iHLlAepI55n+vF9jmXxS1pOo8JctZf4tKfe8QJJJbJ8MeOFjL5lLDWxTPMNud0qxXUdw2LrmVZvHtAJE3zq53M7IhRUD8SclD3uBKLYdGLQ=
Received: from BN8PR15CA0028.namprd15.prod.outlook.com (2603:10b6:408:c0::41)
 by BY5PR02MB6388.namprd02.prod.outlook.com (2603:10b6:a03:1b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 16:28:46 +0000
Received: from BN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::c7) by BN8PR15CA0028.outlook.office365.com
 (2603:10b6:408:c0::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23 via Frontend
 Transport; Thu, 28 Apr 2022 16:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT036.mail.protection.outlook.com (10.13.2.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 16:28:45 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Apr 2022 09:28:28 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Apr 2022 09:28:28 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=50305 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nk70G-0009gp-1O; Thu, 28 Apr 2022 09:28:28 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 222A36052A; Thu, 28 Apr 2022 21:58:01 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 2/2] net: emaclite: Add error handling for of_address_to_resource()
Date:   Thu, 28 Apr 2022 21:57:58 +0530
Message-ID: <1651163278-12701-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d8562c3-b0a1-4b78-04d4-08da29342ae1
X-MS-TrafficTypeDiagnostic: BY5PR02MB6388:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB638875F09EC3B9D6A41E5F3AC7FD9@BY5PR02MB6388.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9QL+f0qbrnfDj/9YxtlkZlKyn/A/CSKU3fT+sn74fOCmDC6uVSSkJUnN0WmvuigBc/gUTzP09AZDivRvDxKZ+NvAL9Afo5rx4a5zggmg+luliVirJWm3C4j7CwcO77hy1gtHZDcbW6AkyiSi/PuRmfD/tVLRq217Bo5ELJ8rMZ62omu7+vgOXI/OVRpkLySBZcvKuaMSSWA373Ol1dYynN8iTrTwp8Ct46FWzLBZR/wR9IjceknS52CakpTXSVKFzGcK7GnsbJHRVcT/O75ihC/g3trjBG1FVcogqwhnSbR5ogAVYuMZqg3yMgkB0rKaCIh4p/UrK9nhIkQFwW0HvwhZaSUmU6y3+qkZXm6QODnPq1/wT747b/t7vK3NEiWtkR3MAJZ++/SzN2AFYA93OXZjBNXO6l+kymw/7ht3Qa0lzw+ZnjpEY596GB/PTlhM6Vx1LwBXPH8v7vX0JXxIQSKCfPOt89pw4NazLMJGqJPsaQP0w/VJn4vPlE+dSKr2Zxmt0w2oBGI6PKw3lq5Hy2xbuDSj7F7VPqnziWCeGGUjMQwLqX6pocpAY2BlF6LFEDRvAvNfn48RpPpG+OlpPCbLpTr45amjoQUSijV8YFiwx80HU96pxWy2iWMBFuMcWTKhbGmPUSSO/G7KYphr/EZufACS3dGlPk1jOFyWGIJCzLGJ7HOmtOpssJHrngYMpTV6UAgsb3G8Yw6IIY7BSA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(36860700001)(107886003)(54906003)(42186006)(336012)(2616005)(426003)(186003)(47076005)(26005)(356005)(7636003)(40460700003)(83380400001)(6266002)(508600001)(82310400005)(2906002)(5660300002)(6666004)(8936002)(6636002)(316002)(4326008)(70206006)(36756003)(8676002)(70586007)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 16:28:45.9368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8562c3-b0a1-4b78-04d4-08da29342ae1
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT036.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6388
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

check the return value of of_address_to_resource() and also add
missing of_node_put() for np and npp nodes.

Addresses-Coverity: Event check_return value.
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index f9cf86e..c281423 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -803,7 +803,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 {
 	struct mii_bus *bus;
-	int rc;
+	int rc, ret;
 	struct resource res;
 	struct device_node *np = of_get_parent(lp->phy_node);
 	struct device_node *npp;
@@ -816,8 +816,14 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 		return -ENODEV;
 	}
 	npp = of_get_parent(np);
-
-	of_address_to_resource(npp, 0, &res);
+	ret = of_address_to_resource(npp, 0, &res);
+	of_node_put(npp);
+	if (ret) {
+		dev_err(dev, "%s resource error!\n",
+			dev->of_node->full_name);
+		of_node_put(np);
+		return ret;
+	}
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
 
@@ -827,6 +833,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 				 "MDIO of the phy is not registered yet\n");
 		else
 			put_device(&phydev->mdio.dev);
+		of_node_put(np);
 		return 0;
 	}
 
@@ -839,6 +846,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	bus = mdiobus_alloc();
 	if (!bus) {
 		dev_err(dev, "Failed to allocate mdiobus\n");
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -851,6 +859,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	bus->parent = dev;
 
 	rc = of_mdiobus_register(bus, np);
+	of_node_put(np);
 	if (rc) {
 		dev_err(dev, "Failed to register mdio bus.\n");
 		goto err_register;
-- 
1.7.1

