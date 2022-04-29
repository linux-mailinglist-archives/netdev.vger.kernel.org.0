Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC05154DB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380403AbiD2TxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiD2TxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:53:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2080.outbound.protection.outlook.com [40.107.212.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5AD5558;
        Fri, 29 Apr 2022 12:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3RFGKjB83QjIf9mI4OMPAg9CiUovMYkwZpBOwUdFMwmwevAqPl0mIPvU4U7+7vGVTXHIRsSjJu1csmj9wbpetsioM10tMqb6BkL9dQ/PCv+zQipcyabiejbKlRGvhKd9/E0hmvv6Xm47WnOoc+dx3GuolHfWi9hZtnYrtQrcPIV0vR6shS4ZO4RPe7PENQIUF2FTyVJmoyP20T5Vhhl9hyj5bFnt1NkC4fQPbZh5WNNV6Jea6qSg8ak2Qbqs18oVzZjXiafMgy4f25ER2RZqMAEy0XEzLM/SlaKW+7o6KK9Q1huIZoTb7FkYZROrY1l8/QgeahI3aiGv8mjtvihQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+/J3sfzB+6eEVfy3NYiutKXrrL3UBdKxLPpEIP40rI=;
 b=VHZnFrO+z30x5DVjD/m4WIBE/e44amSANfK7Ot/9FBSQDND7WU9dCPxtsCJcVkYw0kDi/wKHEl9pMC38o0R4fYEe4sFtU3iM7rdEZuRBHHIMXWKVYwAu8cK0BPD/3tE7IQ18RoEBG3N08EbUOtP8S0FVJE52jUvGWEQh7EKXeKQpZ4uTYZUBDOxLQDgAlwA64nSOZuAWoVkuc8it5BRWH0cHstyurJKX1QLPcLgAs/5+XPofnq+URzRefoppd3UL9ZoY7bOKcj/X+LM/KwzP5xMLp7u9Ym9KWTVxx+BGqAdIWgvyVZ/5x+y7tK9czMj9rzNH47ekx5+tGUwzbisPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+/J3sfzB+6eEVfy3NYiutKXrrL3UBdKxLPpEIP40rI=;
 b=kAz45G64dCrf46uD9amU4oQkwvFDM60TPJNxOQg9UNYF2lYg9mMEMeeZDyNT52DdqZ6/BCM596r7yPmAiZLnn4IAcS+p4lWytXtOaefTHAjpUi/bAv5jJfVlGcx7X3hQTahX1ayiGoo6DIKbXoTBoPk8kLm48tUAR/Kt7x7/zhY=
Received: from DM6PR11CA0064.namprd11.prod.outlook.com (2603:10b6:5:14c::41)
 by PH0PR02MB7175.namprd02.prod.outlook.com (2603:10b6:510:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 19:49:53 +0000
Received: from DM3NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::c9) by DM6PR11CA0064.outlook.office365.com
 (2603:10b6:5:14c::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Fri, 29 Apr 2022 19:49:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT016.mail.protection.outlook.com (10.13.4.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 19:49:52 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Apr 2022 12:49:51 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Apr 2022 12:49:51 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=52257 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nkWch-000D9i-0t; Fri, 29 Apr 2022 12:49:51 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 2C71260523; Sat, 30 Apr 2022 01:19:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>, Shravya Kumbham <shravya.kumbham@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 1/2] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Sat, 30 Apr 2022 01:19:29 +0530
Message-ID: <1651261770-6025-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651261770-6025-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651261770-6025-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60709ede-d749-4c55-9dce-08da2a196da6
X-MS-TrafficTypeDiagnostic: PH0PR02MB7175:EE_
X-Microsoft-Antispam-PRVS: <PH0PR02MB7175F46A486D209BD4E67E3AC7FC9@PH0PR02MB7175.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRRjusLNb0s4ghkDeyy0brOxTJI4TTbYXns2fJG0aO2tADrkm0YIG8zJd3qzpc58/x3p+Dn5eyYITqu4qbLvFBeTF2pz+K3ihHp4OzO28J6xhZkW72cPYWEfSHPJlB+YRBNIwbHVt2Y2ADVXIYpsiXgtmGQBMZTnv1VXel7ixUFMPeHV0PVRdTFQlfJ20uiTBv+owIFJg2zI84Jsw18uWGls82udX3xG0+BZfshhtxAXpm6nCb7c7XOJ2ipJEMfx8hH441g2G3nV+yQVjSn5gbn96ob5yA90ePUVeTC0ubCmFigsU+Sc8kwCyGd5uT5L6o1qnWKuipVDl/tLAfrpTj0foKcRQEfz7bsxu0qCpD1/6w/hTplhIpR+VDOrEn0Dc9RAhU4MEMGAm66RwPJUd0S181OHMxLtNCeixDTiyOBJL3RAvjsB3ELN+oUFi2PB5nPwIm6YNk1oJqAjNN0kPjqQRypW4KQFW4ttyYfmuzoo2lcaIahPkFk0/svIufrIxAYt1dxP/6VyHFvHcGSKSgtjBEDHk5I7LU/rcvyfy8ItFm6aIaI26O4pdbdnprJK9yQcBRCXj4g0ccO89e33vgvcS7ohwiFaHwpBUNuPe6GVSnjtq8JdA28teSzYhaOEDVO86Clyve46mQgL6GbjA7rkk5QHShoQIGxLL9wikkYG5/36ClKXNBKndUFp7+k7IRykBpm7mQOb4F6AI4kElQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(70586007)(336012)(426003)(8936002)(40460700003)(47076005)(186003)(4326008)(26005)(7636003)(8676002)(36756003)(6266002)(107886003)(83380400001)(2616005)(5660300002)(54906003)(110136005)(82310400005)(2906002)(316002)(356005)(6666004)(508600001)(36860700001)(42186006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 19:49:52.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60709ede-d749-4c55-9dce-08da2a196da6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT016.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7175
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes for v2:
Added Andrew's Reviewed-by tag.
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 7a86ae82fcc1..f9cf86e26936 100644
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
2.7.4

