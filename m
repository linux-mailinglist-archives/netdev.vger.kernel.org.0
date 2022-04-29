Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8B5154DD
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiD2Txq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiD2Txp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:53:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC2563E1;
        Fri, 29 Apr 2022 12:50:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lyn4CQhLGMz2tbDpmxqntWocx9k/CZNdAmaZnwBjYFv9LWotEAF6+osSap5d64B5/CCrOyq3B9WRb7qhTXYsTdAP95oVJyjLJHKbsdGBPhwt6PyA/wuHCxbp4Kgj1ylr4f65tgSO83miVJIfjiCBXrtE4Xwhl1GPv2jZ0vOsUd7q8rmfY/kn4oIkQv4JOk5AEA6HZniecziYtzA9yeK/mR6wXxn0kemoaXd5j3QFkiStfZeP8zFJtRZ6scdDkJ4qW13XZUVkCO216Ur7eY3DyTnwf/5+2cqrBBicNXWAYeiIvrH7xCbpJU2DCSP37QEEBEGHHHP7Uqp6STYdklXp9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZA6lvmCDi75ZvjyVeG49wjQho+pu1dXW2kirs38MG8=;
 b=gnHXMCzolMeigo9GSqJTLRmcIjwex9mRSnqjtOIxpaw8bQo/cxgOTvbG6MqpaSIdnG6jD/AKRfrBqCHJCv44tJl/SJLpDvVX71k60yA3zNcHkjoA7oKxJ+5FLabfRP4e6QZVNz7JsP7YylM6xQT0tDX/rPq53/E64Qb+m4d7Okt2XzH7KqLhyHROhfQCmAU2weOJd/lLFZ8I6zt3f2ruNeRSH1SRavX1D8hxl5FpQzoAdc7HYy75Qz7bk5aU11NSOnAHRmQJ5uaFj9inobo60mPi3/T7AY5NJdRDUuaiPt26WCbV6TJ2uQXYv7bKSBzOg3Hc3xctuZ3NlJ0FxV5L3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZA6lvmCDi75ZvjyVeG49wjQho+pu1dXW2kirs38MG8=;
 b=oov9HxsF/0B87tVLwg6g+/a1vj2nVo2pjcp59/oE6aD44GvwyiQwj+mCT/ZyjMeUX/pVUZCHTGGQ+LJesP1GUeWPiryyq1vN9a8WgsMg73APjBPaNeJQojZPT7yuvUh70cSOpzadcqgoay5hIKkaUSA48BUZtdNg6//BHu+8DHY=
Received: from DM6PR07CA0112.namprd07.prod.outlook.com (2603:10b6:5:330::27)
 by BN7PR02MB4225.namprd02.prod.outlook.com (2603:10b6:406:f8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 19:50:22 +0000
Received: from DM3NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::ff) by DM6PR07CA0112.outlook.office365.com
 (2603:10b6:5:330::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Fri, 29 Apr 2022 19:50:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT037.mail.protection.outlook.com (10.13.4.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 19:50:20 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Apr 2022 12:50:04 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Apr 2022 12:50:04 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=52258 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nkWcu-000DCy-3z; Fri, 29 Apr 2022 12:50:04 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 3349A6052A; Sat, 30 Apr 2022 01:19:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>, Shravya Kumbham <shravya.kumbham@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 2/2] net: emaclite: Add error handling for of_address_to_resource()
Date:   Sat, 30 Apr 2022 01:19:30 +0530
Message-ID: <1651261770-6025-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651261770-6025-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651261770-6025-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d0bb0d-42f4-487b-dd2a-08da2a197e28
X-MS-TrafficTypeDiagnostic: BN7PR02MB4225:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB42257D0FAE78CA0391284E4FC7FC9@BN7PR02MB4225.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNVuN0jA00uq2d7OkYttrePuAz1CkSShJaEo6qEKsVDS59MFVDMGTBayKxXybHJTNDiYUjrsNJ1K3rhun3LHBDIYvE05bTFMF0+TNNKN76HBmQwtvqidsZqfucmdnCgtkk/dqo9xLhehMgpVXJsMDBY3Fxl++lnUDoEuRAeJKID1//s/yxqqTQpfC50TERqTyItctfJRfUq2gdBEEMyPSD5jMvI31R+Lxa9rueDpv1H4qmdzoBIJxCVDwypR9krocEOW8y2daAKprBGOIuAycUOSIu1PKmtH589oT9igWm2mJx8uBhTi6xPn957JnI+PLZ8mA7Y3XnJ/rCT4AhBRcolLb08tB7fQqzN7lrkLfX29vzc0cWx7OK110NGZUtkySXRCtbDxfQhAOy16qoj0yAiEbW2yPFdrja95Tw6kD17GmMNp7gjLyTv1z8j08/J0IymvK5XMS20dVe8j2AG7CYSA6IhNKU98lqtJ+UFO7QyS/0Jd7LHYJddWZVYp5MIiwebq9vbrCxmPZbB+mHhA9WB7tdBIDsgY5GgJq17FjruX/VlzEvk99HXMP/65Zkuazwba9f64fF1MmLXscln527vRpkazdVQfTIqlP6oCJtPREhGHZbLagGDJX1W7wPbKL7rQAgGiTvAFxaikIRqaH8T8CtzogPO8MVgQ97NJz8hU4jqD1F38EFc12LKyb1rl0m6uWbSmBAKsbCBKP71djQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(42186006)(6266002)(26005)(110136005)(5660300002)(8936002)(7636003)(54906003)(40460700003)(316002)(70206006)(4326008)(356005)(508600001)(8676002)(6666004)(70586007)(82310400005)(186003)(47076005)(426003)(336012)(36756003)(2616005)(83380400001)(107886003)(36860700001)(2906002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 19:50:20.4565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d0bb0d-42f4-487b-dd2a-08da2a197e28
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT037.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4225
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

Fixes: e0a3bc65448c ("net: emaclite: Support multiple phys connected to one MDIO bus")
Addresses-Coverity: Event check_return value.
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Changes for v2:
Move ret further down to align with RXT as suggested by Andrew.
Add Fixes tag.
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index f9cf86e26936..016a9c4f2c6c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -803,10 +803,10 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 {
 	struct mii_bus *bus;
-	int rc;
 	struct resource res;
 	struct device_node *np = of_get_parent(lp->phy_node);
 	struct device_node *npp;
+	int rc, ret;
 
 	/* Don't register the MDIO bus if the phy_node or its parent node
 	 * can't be found.
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
2.7.4

