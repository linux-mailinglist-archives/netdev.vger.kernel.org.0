Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653A6516B43
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbiEBHbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 03:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383566AbiEBHbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 03:31:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B56B3A5FA;
        Mon,  2 May 2022 00:28:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eq67EqpW0Y7cUfDCnpnymyjhXzu8TMguVngMvQQOy2s4wqUYN6ccqHSY6FKLCzGAJMxd+qAhvsX/YSoUOs60bisMyqmiyztUNoeBouR+Bh9OY6IIZrimx4n9LBTJCv0TR20+51GwFzVKV5AefkNxOd79DeH2hxdrsgSYOC2vuy0pvgyQ4mFQfZLd/qbypcPdATQYc4LS2oR/RPg+mRkbRRlIYB3AT+GFTyWu1pV6QhbESdtdENPmVwZk78SRzK/otMPaWRFEh2hwWOMSYbdRQsMaDjw/Ts2++VcA/S/r7MwHXpp48upAVfuVhgO0jrLgBqxvfSs5kLsbLakvvOLxTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpmbxnG9S3RumvROmQ8xGs+5GmBGFdy0Y77CKX9WBOg=;
 b=imYjOYl0rTUGQtqnKjTdYZhLcUIi73G2slgFg00TO6WtgnV0zS6jLqS9aw4a+R5G5SlmgngtH6y1/8aTvOyNHw08A3vu+UQDfEo0mZVBxXCoZUAD0PsDFIDOWIVeCY4dE179IwNkFl+2hHc/Gf2tS/xYN48K+Bh7Vnyn/PIiyzU2JdC9P2FZJAXNn0EORSAzNdw/yIEi0QwIVTjc5ywmXK/iz7AwxqrrnhL448n6MPGe5WT6inVVudRMW3YHqxJAoLCSNLKaoPFmy7AQyn3jwURkNxU1vSUhiEvHHtDMFefFDzumaWu1t/RB7MZ6MpcxINHWzsok0o2XiQialUAl5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpmbxnG9S3RumvROmQ8xGs+5GmBGFdy0Y77CKX9WBOg=;
 b=nKyL6FZq4fa12IWOHGQslWOP6frsaalTw5bmPCTeMJUrt6XKT004xf+t6ESU1Enduug5RERKN5t+SoPwgIpPLZLaVeEaonQyfojGv51nAwaAldG2tqbe11WdOHmq5WzTTNi0Rg5M5UJ6wD2+dsGPOdjiFbxV20/BMoWLDKYfQPs=
Received: from DS7PR03CA0147.namprd03.prod.outlook.com (2603:10b6:5:3b4::32)
 by DM6PR02MB5033.namprd02.prod.outlook.com (2603:10b6:5:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 07:28:09 +0000
Received: from DM3NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::4f) by DS7PR03CA0147.outlook.office365.com
 (2603:10b6:5:3b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 2 May 2022 07:28:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT035.mail.protection.outlook.com (10.13.4.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Mon, 2 May 2022 07:28:08 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 2 May 2022 00:28:06 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 2 May 2022 00:28:06 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=56284 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nlQTW-00010u-Dx; Mon, 02 May 2022 00:28:06 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 86F3861099; Mon,  2 May 2022 12:57:52 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>, Shravya Kumbham <shravya.kumbham@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v3 1/2] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Mon, 2 May 2022 12:57:49 +0530
Message-ID: <1651476470-23904-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1224cadf-622c-4fba-699b-08da2c0d4e4c
X-MS-TrafficTypeDiagnostic: DM6PR02MB5033:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB5033FC495622324AAD00C214C7C19@DM6PR02MB5033.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ADYlX7dUTBlBPaNiycrS48/LV9k2dLmJGfJ3r2Onw8esUVfw4oHgHnoWry2gEmQ1lmw5UXui6jjOWZAvPyNl4Rj1HWAGwwPLATSDjGTVvRG9KUanS00J1NxCxHx0NvAoFXZvsFbCLRQn02CGbA6SmviHp2U36nhFDL9VJwH4PdEw21u2ODk9jJtsLgXriPFuSXHqoMHVmfAyokw6axMmaFt86DSRNpunv/RKbF0r5f9QUlyLeMhWW4Qll0T1kQavctWoks4w9WPCBgUxuQ2YX158vCBFkZWt4KMJzXaYyEYIsj3jmBH7UpgFKcngOIaiPdMYsgcmctNJDGJbWtByXDKBnjS26fZfM4Pha9vaL/F/K8x41z8WeC/hTUrQ9I9K//MP33OJE+PJd1dGCyL+FT9Av8V8M4fIot6mg4aJQ64h+hngAOaa3ahTIkU+N+na0P4YHZYmQXCgzyyvwNLy/dFzKgCXV5ebEOYlrmvO0C8fQgiLgvqFwhSWJ7WZVB75EIxNf9fU1o3ZaMpiofdGsKShYA2PJjGoqrTf0Y3uCjASt7nYTbsDjsZSQnzpFJttCb84pO5xvcnri55fUgtnaoqALrKxlCqn+x5G4FAOUC/92RMyieyKmFPYAtPS6yEEdZpSSdbaeChH9LKAvlTloJLXKPS3qIM9iM8nYGFOxV6veja4ylK1rY9vVcDd1tYveUz+wRSzLaHWUiEB6K4+g==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(107886003)(356005)(316002)(70586007)(8676002)(4326008)(70206006)(508600001)(42186006)(6666004)(36860700001)(26005)(6266002)(7636003)(186003)(336012)(54906003)(47076005)(110136005)(40460700003)(426003)(8936002)(83380400001)(5660300002)(36756003)(82310400005)(2906002)(2616005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 07:28:08.5236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1224cadf-622c-4fba-699b-08da2c0d4e4c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT035.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5033
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Changes for v3:
- None

Changes for v2:
- Added Andrew's Reviewed-by tag.
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 57a24f62e353..f7394a5160cf 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -926,8 +926,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -938,19 +936,6 @@ static int xemaclite_open(struct net_device *dev)
 
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

