Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9983957AA9A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiGSXud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiGSXua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:50:30 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9146F25C57;
        Tue, 19 Jul 2022 16:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERPAiC4LOOy4PC14BDqzO74oDp2akDHpR2z/jsomPMpVvI8CJsGPGr1UwwmnWSYLS5C7PmElzR5RVkAeR4hQSLf1RGuP1LmC3qiX7B/x+PaJlU4Y9qQMTR5aDktYYhCo3XblwgXiu3D7AsmvJLRQyFdGtQXnGT3hIC5oVYUfeC5AB253RsmtusYeM+Dtv9kNZ7bCJpO0aHVaC5OamxSruCV9RiLtChjg+CV4GLP+fQtoA9xU3NBmSnpJ268r1veSyJjtxDCb79BCOMFdszDzx2JcSiz+PTF2tq4W/APa3JAp4Ve4emflWbj0Aofcdhhlw2QE/IHzjZjHR6o+eMl7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wThwakpFgpW6if1xxFDuJvsnxfSpFG1WdwhSDBloCQ=;
 b=dKsyYy8rpgj2lfQF8QwUQUJypU+SWgD53RredWf8DB1Xfm5Ee35fuO7AmcAlI9LK29ejqnM+HqYcIXdlzc/mbDH0TosQXa1Ke4kB5KAqOtcHQqBbKhvRxiKGkoLU9A7PjeS+HwLCAe9MHJGvwKgo1cb5BwxWEWxJ6VJhD9UrTEBE6yEExxxXSpQlpWCqDJ67vk4qbJetM6PB6D+1w57bmdtKWcYOjR5Zyem/sjaxGGilUoUB0Rl4N8MCuaDQzP2IqG22fNUN5LBEdtZwb5gWFgyE9lGng/KKtr3nOIxeIL+qWLllOCm3cC0NYwcnl9fi3Fez7cziZdkVvw9wTxUhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wThwakpFgpW6if1xxFDuJvsnxfSpFG1WdwhSDBloCQ=;
 b=qb8B3depuzjPAfxxdj35klFTjuGvCFq7zU/AMF+qHtEn54Xx2Ne7E9zFuZ9khPhyO3s9wH+1fD1ke4wBwhwQo0XE7asmwJ/g2GEA7w14NEV2ZORSJe++YzopebJuh5k3hGKMu32EAB5uPC4bvIKqFUXEJOhBEJ6Mfz0/HSQZSMgSWG0dMJpLrcadlSqE1pZOecv0TirIxREHU1r3Nhf9cyERO8BnKAxjOsun53QP3F1dAc8phTrAjiBemoNja7kvxETHmId5ENZR5yUM0S4InKKtaAn2qPXaKJucPgA+SwcAYgoR7+dsTr5R6aoVgt5ygra6Y0arKV3WYnDGRbSMmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:25 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:25 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH v2 01/11] net: dpaa: Fix <1G ethernet on LS1046ARDB
Date:   Tue, 19 Jul 2022 19:49:51 -0400
Message-Id: <20220719235002.1944800-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a50748dc-96af-46f1-ea19-08da69e1739c
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/KbhXJ+vRLenkZDnN+UrCy9fuIam1uL5RILYL5HdhD3pDj3+s3cPzIQ19KtdTwCSMxkqsqO61con+TjbWWnyeSdTBdbx5RcOstBDRstaLzKjxuis3d0uX6A8uYq4SBljIqLFB/eK7SoCePi6p6yEqNAvVfy0StRFO7kYordL5SW0WTEAYS3AeznqakR4XhDinIm1Ema069BnANmXtX8sPfYj3WSvglMPo43AOLVOjpWHXxmJXEwIG4aOfqUhNJmBbY+25+RmpWIkVwJ7vjewyL6mgHFU/+knDsu5paK8V5GIECSQw0rkAvfJMgsdDMM7Jk4YtQxQBUrb6w7uUzh8bcVzzeBwGEka+0AfbJB/qztmFnmwzPS6tQOocmjhWMuSymLnmZbM7WKM0NaNWcJX73+fTk+yq9UIyGviGPIbKhhwX98kdZUTqVCP//8QWBRO6aMERim2ohcqMqm26O6Ki7pbaGiYwFvK1+IISjtg+MtsCgI+mWKo9MtulQxkkrGYxO7AYP8sajtd7+ZbLvnA0o31qmEx9z5Nucg4hMEr+8/B219eVp1CfLzwNccft4KiPgFt+IgRavRVa9mL5dP2DT4Dl62Hui0yKzdx5xROoyol0GzcOQsBv156NEjn2/k2EQ/35befwO1wF9a6kdriribQE2MKAxiO4vdDxU5sQyc/tJsl3jXX+/pWR+kPaS8Ihxwo2RY6VN6D1MOVaTkbGEfLujDz2L5zi2+xmzNtbd4y3VLa9IkjgFTM6YXkhHDDYSGvjTjV3cVgtNiVa/BlnZp5jyxf9dhZt7zJ3tP/m0iOQEYgVEgDE2L/B+OrZu3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/aYL3dfiOyqtETHmRW+ytMUc1jhvhLWZVnvOrOXoAJR6uf92/rCpD7SeOvOp?=
 =?us-ascii?Q?o2yEVB4RwsT1aTysPC6SIL8w0ONpnGAZ3xYrpbq21GVeriQia+sh9knl6wnE?=
 =?us-ascii?Q?cqAUQICZKzp3sOm2t5l/kRELXBB0Uty1vHf4VTH3QXTy/WO9+ABFicHnwJv8?=
 =?us-ascii?Q?Xj6aEIymeSAUWA9PesgKJaM7AYpqaEsYf2ma97MDpoYQZpDDnvErZAIfi8Xx?=
 =?us-ascii?Q?x2WzEUIo2ytrdbUHk4IhmR4MwGipTUrS6fgVoOhIdaBlUhHfOL7ApLMRgAk3?=
 =?us-ascii?Q?nrY59Mre5Az+vW8UZMcBZwTSkEZWClEHWUwuZQDFMJ+5H+DA+JxKaxVdizE5?=
 =?us-ascii?Q?erHYzG874Pv/g3U0sSNQsMxRbfFmbWW5cba2NHScLXnJVEKVeq5PJiYusoC5?=
 =?us-ascii?Q?qIX0HBHDCGmMLo5Hh6Cq5NjvPRcL3osgSeXhibB11WRqyWSD7NY2ldOFn7nH?=
 =?us-ascii?Q?wDR0eVPclFLT//MpGKCxpmycFnrJEv7GUMwgPiz/liZtofUKWg9S6XFM+dII?=
 =?us-ascii?Q?rTd6uwoBrcJ72qHqQSOVOLMEdoMpiVqBOXln5/v4Q1b4OgJFa4461hZY5ho7?=
 =?us-ascii?Q?XxyhiJVd7kxcJAu/mf4bXMjC00WKbUMCuinmQzWDuVhAAjfjC7fKvlIvu80u?=
 =?us-ascii?Q?j6s8oU6HLNNkQm1KpKggDTB0Ehidj5NUlez+8BANhqhTF9fdW0ZJ5v701AJN?=
 =?us-ascii?Q?b3C28weAG0atlxR8oXy/6WDI1r8bBXofZ+O8jMRf4ohO4bHWCACs3N9xKcFE?=
 =?us-ascii?Q?UN2V18YOAzB0udRP/GcDXuV3w2RyDu9HQAd/uQi3jiO5RIscfEF6M2I9wpaW?=
 =?us-ascii?Q?fgFnQNY+yosXzDa4nWEYuoTZHlHJTZGAuhio/nL4IdPA+OTTeGP3URWCLyJ0?=
 =?us-ascii?Q?nJEfyqC0mrwTKBrzloghxkXCqd/QNYpLJA3hCmXbXECypEpVjlnB/n4IY95F?=
 =?us-ascii?Q?qLp1FKH4b74aHadAvwnYoeofMENvzTh8yoMbYewXwCHur+T9N5mrWhj05W58?=
 =?us-ascii?Q?9uFRHJOEgFiLIOdYpKbPDhyLsRVJVu8dbYNnn9ZX+FRE3NDpHjCmPvByp9qX?=
 =?us-ascii?Q?tE+YZ4ogqXRbR2aAm1hLZwBYwaKnSHcsg/t4N/+ruRrK8Jgk4ttbDBDpEbin?=
 =?us-ascii?Q?qm9AtlT74JyX1bLZnvbilSGjuBSNSuNtalbWPRE0l0OYssjqDqDH7DRMuxjy?=
 =?us-ascii?Q?0DUX3AIwFCsmVnXlgUD7Q5zhVPzTB6KOtHOu/l7XX0yyTEQd2CY0PVHKOdiW?=
 =?us-ascii?Q?zFycASs/fxaMcl+kvfvLcd6jGyQKVcP0iypnJUcUaiIM1kCmVmta3BsPq1yr?=
 =?us-ascii?Q?OY0IdrfxZuMPEiV6Zauqn7/k9785ZUF9K2xiiILhz7rkF1y5ggWiTZJ6+Frg?=
 =?us-ascii?Q?rb79mUas2aTlIGQyU7gJPojVtpFDuyl+zKNH/zkf3sOGwPqKDcixdUoqwoHl?=
 =?us-ascii?Q?vLh2IzlDkQzF7NC5+ppwhrfTZdAYLd+7imIPgC6TZ737Yi7TAyZGkgflm+Gg?=
 =?us-ascii?Q?CpDwxA9a5RHmuFxLFmbpUvqIJiy8Se24fvjrGn4nF80tdnLXWKxYfF/tXxiv?=
 =?us-ascii?Q?9dMiOeqKI0pWBhIyIIe4n9meGYdng6tCmZTte6lPskrsytrEDrzN0bwalvc6?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a50748dc-96af-46f1-ea19-08da69e1739c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:25.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PlD7akeWgDRnEkUR71wSbzf45JPyqVAzyz/KsYeC5rb/8IsNKIYOT7QnYHfdroIQeB/UJTw7Vci4r6+jUIoQfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in commit 73a21fa817f0 ("dpaa_eth: support all modes with
rate adapting PHYs"), we must add a workaround for Aquantia phys with
in-tree support in order to keep 1G support working. Update this
workaround for the AQR113C phy found on revision C LS1046ARDB boards.

Fixes: 12cf1b89a668 ("net: phy: Add support for AQR113C EPHY")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
In a previous version of this commit, I referred to an AQR115, however
on further inspection this appears to be an AQR113C. Confusingly, the
higher-numbered phys support lower data rates.

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..a770bab4d1ed 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2886,6 +2886,7 @@ static void dpaa_adjust_link(struct net_device *net_dev)
 
 /* The Aquantia PHYs are capable of performing rate adaptation */
 #define PHY_VEND_AQUANTIA	0x03a1b400
+#define PHY_VEND_AQUANTIA2	0x31c31c00
 
 static int dpaa_phy_init(struct net_device *net_dev)
 {
@@ -2893,6 +2894,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
 	struct mac_device *mac_dev;
 	struct phy_device *phy_dev;
 	struct dpaa_priv *priv;
+	u32 phy_vendor;
 
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
@@ -2905,9 +2907,11 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
+	phy_vendor = phy_dev->drv->phy_id & GENMASK(31, 10);
 	/* Unless the PHY is capable of rate adaptation */
 	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
-	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+	    (phy_vendor != PHY_VEND_AQUANTIA &&
+	     phy_vendor != PHY_VEND_AQUANTIA2)) {
 		/* remove any features not supported by the controller */
 		ethtool_convert_legacy_u32_to_link_mode(mask,
 							mac_dev->if_support);
-- 
2.35.1.1320.gc452695387.dirty

