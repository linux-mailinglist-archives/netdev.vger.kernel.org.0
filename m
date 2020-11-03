Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8611C2A467E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgKCNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 08:31:36 -0500
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:52127
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729244AbgKCNbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 08:31:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1hafhJ9C46N4dBLS4mIqXTKzbOXzTxwerL/jGEeBHnhT+cF8eJBApuPblGbXIcrNN5jwvXMzMpSm7TsWda+txsI3tppIjXvS2GTcos0X6+IEIatFliTHK4O/7E+yw4smGV+brXVs37GgX3/zG19DDBWsoodhICyoEnReZBYQ0Dfg4G2+jUdr9bAeTOT+sTxB0ujSeCf+6/kqufKt3YeT2w3ddzSDKiHCZuuirDwpgL2yb+wOGybPBwoxvX+uSoKH1U1H6KdPTFrYzjaKkS3yhpXf+TPVW8O7giOcTDD/KU87xjX7ZoLvFpYiJWwOcH4Adu+nmBZ7jnJDtgdNidAOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSdXhSGpxQt4ANsCFtrlXaZfNepTnqri8pCZZAzBYBw=;
 b=ID1IP3PvgaRqrrh5SFeNth2N6i4hStYDvUWw+p60yz6G2RfeM88zR36t3Ac4fDT6yf4cXGNkdnmbi1DeZoGdaTVH/hR68GNqNqke6B1RNpfHFsJ5CiFew8JAlYLCss1ug7g8FTRUmAtHyygi5zp1oe/xiAVQH9wfpYu/jTHt8nB9Qh5ahd4WuNevSMhBN39UWfnhWH3GAbBekb92f694/ukWlK+0Mi6eG2/nU9UP/9e7lEa7Gai00GDX3SgVx0DU5Vip1+oPkfSAfUrpYEsNKbhHUm/u/2GCNIlGGfBLn9FiRZ4CYULisIOXMTMVfw2PeAh6wS5ULMvF5dBvPEs8rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSdXhSGpxQt4ANsCFtrlXaZfNepTnqri8pCZZAzBYBw=;
 b=OcYMNYs+FLlu2zVTSNmoULQG8FyAByZ0DHxFLgwamPJcoXdBBcHpVywg8r/3JN6xDFXa9tVpM4l+DTzCTiKUtAZUXQrkohlPu/Opd+oL1CEPKlgxAh+e60w9ceLpi1nk5sDzI08byyNr/+rIwLsHGOaucOO+XRUHyCAXXcSIUds=
Received: from SN4PR0201CA0070.namprd02.prod.outlook.com
 (2603:10b6:803:20::32) by MW2PR02MB3689.namprd02.prod.outlook.com
 (2603:10b6:907:7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 13:31:31 +0000
Received: from SN1NAM02FT025.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:20:cafe::e3) by SN4PR0201CA0070.outlook.office365.com
 (2603:10b6:803:20::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Tue, 3 Nov 2020 13:31:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT025.mail.protection.outlook.com (10.152.72.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Tue, 3 Nov 2020 13:31:30 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 3 Nov 2020 05:31:10 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Tue, 3 Nov 2020 05:31:09 -0800
Envelope-to: git@xilinx.com,
 michal.simek@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=34647 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1kZwOz-000620-3L; Tue, 03 Nov 2020 05:31:09 -0800
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 4157612137D; Tue,  3 Nov 2020 19:01:08 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next] net: emaclite: Add error handling for of_address_ and phy read functions
Date:   Tue, 3 Nov 2020 19:01:05 +0530
Message-ID: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c8e41f-2de1-4f4f-fcc0-08d87ffcc61a
X-MS-TrafficTypeDiagnostic: MW2PR02MB3689:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3689A950790B2B4FDE2352BCC7110@MW2PR02MB3689.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9iUfGcXMNe7kREyRGoYtHbNi8BfrqNtFxtsxDBkpbA/PBuy42qJSZWKnOHoAsNmlf7UdbXisZF5G8+uprQ/3f6bNndz3gHoOViG4wEfCeTaK+5ZFLFXlljTF70Vj4gB54hU+8rg2O58EXhLgQpEFp3J4JJCqdSCz9cvRjr+EAKgFAVXQ155oRw/pYPbeOcF0V0rY2wsVUZ3z4xBkmRnAxSVU/gR8krjLp/2+dBwf8wRo4oM7sS2nkR74fZsDAbBNP9Cu07yNRMvUo/VWo09BpM21AQvoSKabqNALFw3zUKXyWpE2+ug/lza3qVd6UCkc4/mu41+JO0HBaR4fXoApZwgpSaPSRNRGbkCbJHv+3b4RndK9PPniph6cA2WJArUEl+l54n4XwJJkiwQXci0VzZ8zPY2GTJ5oJ4egT01J5A=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966005)(110136005)(336012)(316002)(54906003)(426003)(26005)(42186006)(47076004)(6636002)(70586007)(2616005)(70206006)(107886003)(36906005)(5660300002)(82310400003)(4326008)(186003)(6666004)(83380400001)(7636003)(6266002)(8676002)(356005)(36756003)(82740400003)(8936002)(478600001)(2906002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 13:31:30.4269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c8e41f-2de1-4f4f-fcc0-08d87ffcc61a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT025.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

Add ret variable, conditions to check the return value and it's error
path for of_address_to_resource() and phy_read() functions.

Addresses-Coverity: Event check_return value.
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5b..fc5ccd1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -820,7 +820,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 {
 	struct mii_bus *bus;
-	int rc;
+	int rc, ret;
 	struct resource res;
 	struct device_node *np = of_get_parent(lp->phy_node);
 	struct device_node *npp;
@@ -834,7 +834,13 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	}
 	npp = of_get_parent(np);
 
-	of_address_to_resource(npp, 0, &res);
+	ret = of_address_to_resource(npp, 0, &res);
+	if (ret) {
+		dev_err(dev, "%s resource error!\n",
+			dev->of_node->full_name);
+		of_node_put(lp->phy_node);
+		return ret;
+	}
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
 		phydev = of_phy_find_device(lp->phy_node);
@@ -923,7 +929,7 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
+		int bmcr;
 
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
@@ -945,6 +951,13 @@ static int xemaclite_open(struct net_device *dev)
 
 		/* Restart auto negotiation */
 		bmcr = phy_read(lp->phy_dev, MII_BMCR);
+		if (bmcr < 0) {
+			dev_err(&lp->ndev->dev, "phy_read failed\n");
+			phy_disconnect(lp->phy_dev);
+			lp->phy_dev = NULL;
+
+			return bmcr;
+		}
 		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
 		phy_write(lp->phy_dev, MII_BMCR, bmcr);
 
-- 
2.7.4

