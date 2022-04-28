Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60C5139D3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350034AbiD1Qbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiD1Qbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:31:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A427ABF64;
        Thu, 28 Apr 2022 09:28:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtAsWsxLvghSgDqBYs6k2r2Uh0pbj3QxHzvMzbKIr9xc9N/yrB551kwI4gMTNPkUOsCkBSc0VL0fCaKmMksnUD+SeukQnY/C2GJukBWJT6D+pzPcfZHUTeYy1rwXWwA5tIeKDTy52GWwZQJBYhjzON8Ruhrb/I3DApbnvcWzKhHPP5iruJfe6O5D7Xs/4n+P6Gv/b0smW/Kuni3ANNU1zl//zlpOlkCpFp9HorI3e96NnnNTq9GoqvXHQzZE8LCYgwdJJvQBaZ4attxR1UPCCt/VxaDGJKyMdmK8T/2FvXgUWKxvTKzIQndjSJ7Qnux60cH4tugGHl+gBZRymwEQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRio9Aqnt9lfwYAJ5VgcwBMIrZIy3/GrpNieuzUald8=;
 b=IHY2pClgzLtwDJdCjMg+FgkIuU2g4+Hm2si0BdF3xxV6EomR3dG4k1Di/QbPkU2TY/FHJw3HyHQK8rr2mpVIEuSwM6WsceZKBk/LBQxglbg9qyLhv7hGbA839Ck62o0rL4otm24wMRV7Q30MKdl752runTYd2yR477B9y/ZTf/g7US/1r5lJ67ias6EcWve7GEiQfLC4iv7kczc9kSvjpxdFz4AIQ36FIm8Btg1wTfQ1KH/IxYiJzjcHDECFcty3rYnMdQ0TnlGM306z4/u46USxNG3aYYvR78YNP1iauyJh8W5ztKHSCb6gl2KpJXU/GYgtElsm1PqH4gJJH7u+Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRio9Aqnt9lfwYAJ5VgcwBMIrZIy3/GrpNieuzUald8=;
 b=DLnFAJCufgNr4hjjT3nDtny5yldWVIoFpaqhVxzz1UyWih1d3hQ8nWmggk7h5knLZvbhEBNGQAih0mmfhGcHT/XVbEe6OCjgBPqhAKJSDtExXdGfpLCxWzkhVdATLv1ynL5QkOaLXKzpY6UvIoRRXk38vODn/ZoF5xKFFOoBdVU=
Received: from DM6PR06CA0078.namprd06.prod.outlook.com (2603:10b6:5:336::11)
 by BYAPR02MB5669.namprd02.prod.outlook.com (2603:10b6:a03:9a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 16:28:17 +0000
Received: from DM3NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::c2) by DM6PR06CA0078.outlook.office365.com
 (2603:10b6:5:336::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Thu, 28 Apr 2022 16:28:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT020.mail.protection.outlook.com (10.13.4.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 16:28:16 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Apr 2022 09:28:15 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Apr 2022 09:28:15 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=50304 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nk702-000H01-UZ; Thu, 28 Apr 2022 09:28:15 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 1CA4960500; Thu, 28 Apr 2022 21:58:01 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 1/2] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Thu, 28 Apr 2022 21:57:57 +0530
Message-ID: <1651163278-12701-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d3df69f-7537-4907-5753-08da2934198a
X-MS-TrafficTypeDiagnostic: BYAPR02MB5669:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB5669ECB11045A9FD622BF08FC7FD9@BYAPR02MB5669.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fMc6CbXFGuh/PWVZ/Co2X4mjlsYIMeo/LMwV1kmvWTwHL8/gtULePNVL8VAcP26tAXqvJg2VS9/uWBr5YgH0sD+souWHP9si1xY0T6atW2L3z/wDMKCWan7gRfjsbC5QJ8NGS/j8I4ND9pCLQcvyVnfJhzajpNqus1ObFFy8JtlyhhF85tXoZ9dVNzwqyBbFBjtjLba0lFdRB0id7aUmcUNO/nqBrU+u2AQrWvx9TAXa0yRN4LkyDmsSKSlejQQBev4EHy4shdbbOfU2AZVY6CEBG7kZzbB5HVgAAP62iGR+cz1xHXy6iACei0rsSMYH/MBVCgGHX4pzjlvSUviURa2InFVos9GfMqrPWK0ZuasZgzu4Vz71FPpdxxE5KeP+tR2DGe0HTTKdyooI6dUSEgMG5KbyrBcP2/0UtOlYIXmP7LpG30m/AygGBBS17RawJP24BEe2dDAcWAv/X7TEi9C+qX8bW18jj9nlKdtCRLgvpHFA+vyEnpIC3uOrWeQOud36tfYhJ7pUOTUsTmlwJsZHMiZA2SmxMBHNMbqxLrX3CK0+XMim6mdSaKDJZmXbEhY7fr9lupDtNveowBWNjzCfiMOnyMZuz51jiwYv72VK6RrQ1s9oecRnAiA7ov0XbNyVmnVXJ4yTdXxNC6NYF+LakYj8Q8Cs5s05QguuBVXNYlD9OtzxNN8dE5hx5rvPNli7DgQI/4la67ipMMkzFA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(70586007)(6666004)(2616005)(186003)(7636003)(107886003)(82310400005)(26005)(42186006)(356005)(47076005)(8676002)(6266002)(36756003)(336012)(6636002)(110136005)(40460700003)(426003)(316002)(8936002)(2906002)(83380400001)(54906003)(5660300002)(4326008)(508600001)(36860700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 16:28:16.8787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3df69f-7537-4907-5753-08da2934198a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT020.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

In xemaclite_open() function we are setting the max speed of
emaclite to 100Mb using phy_set_max_speed() function so,
there is no need to write the advertising registers to stop
giga-bit speed and the phy_start() function starts the
auto-negotiation so, there is no need to handle it separately
using advertising registers. Remove the phy_read and phy_write
of advertising registers in xemaclite_open() function.

Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 7a86ae8..f9cf86e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -907,8 +907,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -919,19 +917,6 @@ static int xemaclite_open(struct net_device *dev)
 
 		/* EmacLite doesn't support giga-bit speeds */
 		phy_set_max_speed(lp->phy_dev, SPEED_100);
-
-		/* Don't advertise 1000BASE-T Full/Half duplex speeds */
-		phy_write(lp->phy_dev, MII_CTRL1000, 0);
-
-		/* Advertise only 10 and 100mbps full/half duplex speeds */
-		phy_write(lp->phy_dev, MII_ADVERTISE, ADVERTISE_ALL |
-			  ADVERTISE_CSMA);
-
-		/* Restart auto negotiation */
-		bmcr = phy_read(lp->phy_dev, MII_BMCR);
-		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
-		phy_write(lp->phy_dev, MII_BMCR, bmcr);
-
 		phy_start(lp->phy_dev);
 	}
 
-- 
1.7.1

