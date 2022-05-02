Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C456516B42
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383570AbiEBHb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 03:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383580AbiEBHby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 03:31:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D753CA45;
        Mon,  2 May 2022 00:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEH3BHiHRamMcXTGZaK/A2VulcVZCPEWp91tL4ASP2Ut19DUF0LTLRHHjlod0LR9y3JG9/58WRdbeHnxQfeGRdW5esMRXKmS3WkXlRjBxUVfCnDtOXvLvPIjYYuXcayjIN73tO1whzIO+mDDnifxN5EFVRTZQ/7S9h130gXCjKvhjXpNm0bETb7iJRSIv6ySwFDYALrJaLpvoyHObDci8VvN8fPYmBM14KxPFwdiYaV9n6FKIDIlMCBSyPC52QN1mr9Y2b3vovcm4nQmqSmIjcjyFFZJOeDh0zRFZmHz7Y1EIR1OSfXWlV/4ejDeC05TzOTzZL4UN8K0Df7NaUy+0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWkA1nlE39S1veXrCKBJ7z0FBNkd79hY7EuKYalnTLI=;
 b=UQ66157gLy0nBqmZLOLwM7AAaJE0NAX4L0UB/y8dGscUPae9og7fPIpJ3zReiBL57Lk9k+pSQVSPrnwi/Uvio0VMMC13Prfj70jTdlvqxXmlpPeuNBEOIvIvnhSvWHPR/KrbbPNveQHi8X7S/RJMBlH2Tf+q06xlR7dFM8WOAVGE3PNGAZP7G/EhvfnAh6FviKKhBvjA7N5FkalBd6NvV4T6fOLIt0juwRm8lOz9iElCG9YHn0v0xCR+sFilW/XfMSYuZjn4fEL7gmf1FWPth4ZXWTVMkRcSaqLrUuQQxQkyxZBLxT353epYt4ARq/cy5Nqa0MEE8NC/LWKcNa7Yvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWkA1nlE39S1veXrCKBJ7z0FBNkd79hY7EuKYalnTLI=;
 b=Rr7dRaSNTAVHwcwhN9n9liZjcbeSb+J+Xesyf4KzQDCPO3tRPtTIVJB6r8/NrPzhon3/OfwNR/dl+y7Mzk8tvSdr5/Bi8GslXhrzy+LSrws5hMwtK7tzmrSrJ9haDEKpl5EVde845mINPTlY9GxdGHLNeZfmelXczgDx7G6o8VE=
Received: from DM6PR11CA0060.namprd11.prod.outlook.com (2603:10b6:5:14c::37)
 by CH2PR02MB6295.namprd02.prod.outlook.com (2603:10b6:610:f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 07:28:21 +0000
Received: from DM3NAM02FT045.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::fb) by DM6PR11CA0060.outlook.office365.com
 (2603:10b6:5:14c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 2 May 2022 07:28:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT045.mail.protection.outlook.com (10.13.4.189) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Mon, 2 May 2022 07:28:21 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 2 May 2022 00:28:19 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 2 May 2022 00:28:19 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=56285 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nlQTj-00011c-Gp; Mon, 02 May 2022 00:28:19 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 8C6066109B; Mon,  2 May 2022 12:57:52 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>, Shravya Kumbham <shravya.kumbham@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v3 2/2] net: emaclite: Add error handling for of_address_to_resource()
Date:   Mon, 2 May 2022 12:57:50 +0530
Message-ID: <1651476470-23904-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f733c80-5de5-4735-e52b-08da2c0d55cb
X-MS-TrafficTypeDiagnostic: CH2PR02MB6295:EE_
X-Microsoft-Antispam-PRVS: <CH2PR02MB629534D6CF89D285A4B84837C7C19@CH2PR02MB6295.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZguWEAlP+HfFtYcjbNyTx/f+QtJsJVHrEpeSnxVOLe/RwOnauIeM+jHQh+ukYAvKTxUp2JPgB3HfyIxMGueEbwia3oJ5CSP+rVP4KxbIGSIgx9e7WWU5E2QVnIn65cmxQQrWc7lusqcJ23+H8OYI19JeDaiYP4sJJzOaz6lpFupseGPKPBt3FFMDFIlpYzfgJR8JpbszEb3ICkmn6tbdzuRdENzeAvfl00AoIQY2YFXRuriIArLLDKvekkBbSxLMdvep6sCtpTzJpyk3MlR47Qtj5hfjFd8fX5pbrpWIxBZyDzV48ngHa6XlheKbiQ9Rr0kVDkErtEPjQxIfvM16io2MevE8DMNraJb/lPp3rN0YLiduns/JRN2OBrlusWs8hAYOwP5sXya/HaqITnEpF2OiL7HHbMocAfdKGk9iqgUt1gERF8pbhBDC10pH9Vz4ufu3WM65tosJY2hnHOsEpuYekx2nDaYyPp9YJdAHvZIIdY1JIYyDC5zAdClKMNBOrIoDTT7VdGAkPWJJY57N9CXXayzLxq5XZzsHnvaRGkXnvIpRT1pQ+jL1PC9zMQplkH5L3A2LQY8Zr9F3eC1IMo9zBnyOkwYnDAglfGDryElwzjWqu3dianA8iAe1+izeW7wQh0gMjsYsQLGzhHkaPn4f0q4q9BAvMDSIKZybwHJ9yYTQGYRLMoD9777g+mYJln1iLqjkIG/O6V85fNszg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(42186006)(82310400005)(54906003)(110136005)(316002)(70586007)(5660300002)(8936002)(70206006)(508600001)(8676002)(4326008)(26005)(83380400001)(36860700001)(40460700003)(36756003)(107886003)(7636003)(2616005)(2906002)(186003)(356005)(6266002)(426003)(47076005)(336012)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 07:28:21.1188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f733c80-5de5-4735-e52b-08da2c0d55cb
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT045.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6295
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Changes for v3:
- Fix conflict on net.

Changes for v2:
- Move ret further down to align with RXT as suggested by Andrew.
- Add Fixes tag.
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index f7394a5160cf..d770b3ac3f74 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -823,10 +823,10 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
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
@@ -836,8 +836,14 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
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
 		phydev = of_phy_find_device(lp->phy_node);
@@ -846,6 +852,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 				 "MDIO of the phy is not registered yet\n");
 		else
 			put_device(&phydev->mdio.dev);
+		of_node_put(np);
 		return 0;
 	}
 
@@ -858,6 +865,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	bus = mdiobus_alloc();
 	if (!bus) {
 		dev_err(dev, "Failed to allocate mdiobus\n");
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -870,6 +878,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	bus->parent = dev;
 
 	rc = of_mdiobus_register(bus, np);
+	of_node_put(np);
 	if (rc) {
 		dev_err(dev, "Failed to register mdio bus.\n");
 		goto err_register;
-- 
2.7.4

