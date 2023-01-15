Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981E466B436
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 22:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjAOVi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 16:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAOViS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 16:38:18 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4951B555;
        Sun, 15 Jan 2023 13:38:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xn6DxxvJCgWTgJBDAUiOzPuB12AsRW4BG1SjKMMrQKqWFdGdxqCPw3rNvhu6GeHtpq2GrpZTsnEgDXP5LxvtFwCk+CbE2lp9ByjiLutHmH/TZs4wqkp7Wx2RbRkzlNyMuSJJCiu7PCwYS4KRDp7c1Q+sIpqDnIxJMqW4+zkSzEha9aFoCYyXGwSUuxfwUEWlK+eu1GJVmFgC5WUCEm7ys95wWIjAM7wdiY0ZnlMMgKbdM7aHeguhT2CqF9z1WOalviah2/r7iph/+Lhy1AHNtyDEIc/bXGBw/TUTxfmlZynAkIkb8itXIyPTF9lBJFT6MursetO6m8Mc+wGB3TdTdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pHnSVvnYc1fuLFjMyl2/Ut5FQtAdStr7PJnGlkXIg8=;
 b=KWiY3Xi/RecRtP0XUs7PkHPla9v19C0ZM3KTMwYNQFmlWbeljEtksgBm7QNqzGBqRtdf1YMM4rMSO4fiuNjhnT/Rqancbruerq2ECLNEEfcFt2RqWam8eE7FQ6rbE3vpL57ECuhGe8IdC6RI+nXX8hnBB3Kn2BvJ0JPy2tNds2J8U/r05tdyMcTESOCNs51cJ3zVI15ZqEWvDtYE6juz2IoALCzzjTIcprjNTbf+HBxFKuvnNcLtdq6idgX7r5xzCtDci8Vwlmpd0JI69clUsI+FN7RW30LNqxXTYoYoCwpikp3/i5uxgNWzFCaWaGtqPZPcB8nUiBkPfFoOroNH0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pHnSVvnYc1fuLFjMyl2/Ut5FQtAdStr7PJnGlkXIg8=;
 b=Q8wjxylCwTpC/yl26ctj3TfoHxbW98fLl5B42W/tBkRq2KHocyCx8IbqOUxnGZK2E26NBiu+aFW+Tpccu6hc/xsgWAaf+1w+E1FF88XX/6ZaEczSo4zsCNBsS+ugVxKC1GoUXzN4ObwEcSJwEBIzQp8WDymAQG4BlyepN5bU8cTonMxn4PUTSjS4nAWX565zmHYSKXb/+cAVzPO51SNK74sBu/EwzPI//zzHRPMV0fZaqnoLrDbBOoQqQPYrm0e82x1JRQxixvz7xZx98hJfpCZKiUpCS4W6Dr+9OXTKBWd9Uacui4/ONRokwyR3EeHU29G08H3T4u3mEOWVQxmR5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DU0PR08MB9607.eurprd08.prod.outlook.com (2603:10a6:10:449::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Sun, 15 Jan
 2023 21:38:13 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Sun, 15 Jan 2023
 21:38:13 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     andrew@lunn.ch, wei.fang@nxp.com, shenwei.wang@nxp.com,
        xiaoning.wang@nxp.com, linux-imx@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com,
        pierluigi.passaro@gmail.com
Subject: [PATCH v2] net: fec: manage corner deferred probe condition
Date:   Sun, 15 Jan 2023 22:38:04 +0100
Message-Id: <20230115213804.26650-1-pierluigi.p@variscite.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0148.eurprd07.prod.outlook.com
 (2603:10a6:802:16::35) To AM6PR08MB4376.eurprd08.prod.outlook.com
 (2603:10a6:20b:bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR08MB4376:EE_|DU0PR08MB9607:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b02d3a-b427-4649-a4b3-08daf740ce23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iklxuLpSu5DuyUzcTnvhNeff8oKtAiyudeAZ226N+oNUebSoTwPbbV+FUiNQGP7YVL02kW/li9hUwlLaNmbyQVTLfZQKyReTQFTOmRDGTURkv592rqNr9TDXPwVjdTaQ7t3uyIZfAFMFcqGYi52tPokhIxaFavN4CgmkiUhn3txVJuC5kgV7fRvlgsHidQUq6b/4eSBtmnHhSD4uHUHakNgMpVp40+KRGogI7S+NPAQVW+Ireiue3lye3QhxtHUdCQ9BfTikheVdEt8zuHTEBnmjPPrFtVVIuNRvwTV2LksUbh7UIa1Iezpio/EKySMxzu9OpYrraORGHU27ssUOkCxNW/Le9F9mzMpYdFe91DICEyWU+pj3v1gbfNLslIEk5oPoU/iMV0EiSgeHvJbkvqGCpxMNL0AdOO7ntjD+l4BgfHNvN/3cPsF6Wejdp/YqGSILtid6TSv+29aQPpLi8+uCj15BCAKrBqZIHozOcy43ndgVbV1VRDQUV9ajunX2f0kn13CWk7eGPC4+zn9I2f6m3G2YwGGtV+e5arnkv52l2eXZAALUUfMT9oSWdCRwrXWpTaG7v/dSnaaE2BFQR3uRfrHSeBXeCD5zh9vQlYCBX9BSqQxPdN2WMwqBd8sUvmRsBSClHbDIZ0FSGrTE/xdnzcddL/cu45FWVReUVOPIye0G61Xlnf1mdJEZQ3qkV73ahLlluyqoqIID9tpS0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39850400004)(396003)(136003)(451199015)(36756003)(66946007)(8676002)(66476007)(66556008)(4326008)(7416002)(41300700001)(5660300002)(186003)(8936002)(83380400001)(26005)(478600001)(6512007)(6666004)(6486002)(6506007)(1076003)(316002)(52116002)(2616005)(921005)(86362001)(2906002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9yrxfr/9JiX2cP8SUY5ERZVM0rO+CC0XQ9olqqCDnabrJj3vKmBDeCkHN8p2?=
 =?us-ascii?Q?S4E0BZD8BGlB8o7swPtdA1ODKuSrem4YfhlU3NQRr7B5VmUYsSdMFsCQSuRF?=
 =?us-ascii?Q?AWzFKKs+epZrjUCjzDA0pQ7GVXiVduJcZy5g30sdnmSWv5wLEYHfrH5u1wJV?=
 =?us-ascii?Q?Wqv/KD03SrhUks72J+1zULLMkKP5Axt02VY7GVtTXUJqXusyoWKxCGM8ilJg?=
 =?us-ascii?Q?mpip/9yDjOQUctHEvR4sTrORsC32gzL2FgAZAFBbuJleNuSggSz+Gd1lFr2Z?=
 =?us-ascii?Q?xNL/akEmNrhIBB1mAxBClvfPcayl0Bb9Sr6XAxS48R+PjiBAVLOOB8SEHln4?=
 =?us-ascii?Q?hiV6XHvu9cD/aBreUohQNwqtxF2PdoGKwV5spk8DDeN7hRSWlzEb1xK+tdca?=
 =?us-ascii?Q?ZEqCs/4pDZGIKUes7YNDzM0uaLca5OU0SGXZW1M96fls93zB/3sYZS4EbKG7?=
 =?us-ascii?Q?W/5jGt097N1HzKlo63aBMyxqPSCPGL9Xboff+GYDp2DBi09afLSC2DUPVHrI?=
 =?us-ascii?Q?j0bb9qe6rA6X5U8QKfTcQjdl/SxKxHOhbZUhmKLXKuvEpRSVpMoHbn5NXulX?=
 =?us-ascii?Q?mg+38K6bdkBrGdM3FwE+l/V8y1NCJENJ7swQMh6b1YUbJUgs5Kn1z1rLuSS5?=
 =?us-ascii?Q?1myqtq55HX3TtYSloyrEIEjch2ggnPFjiT+5hdH5iQvVtBfBM4hpHTo0sLPO?=
 =?us-ascii?Q?ec6EUTvbnbYkLi7Mwtm3bK2pi6wZfVbTHM9Pn/SsYoQzlouHNnlqU07lgIhg?=
 =?us-ascii?Q?V18yhwiE7oZuNRwzR9f/t414KUWtjd7yGSfvb8M26gJ59WBcKC5pxW1IqoZ0?=
 =?us-ascii?Q?KMkxA2j/rX9VsVy/EaNn7p7sqL4LWSpn8GGMILqCuCEPyXO2nYQfLSpTJiRr?=
 =?us-ascii?Q?6fIyTKX5kDyeBlxVGfN8lAulcxKiDchG6iX0MMIW48+ClWJEF/kGyvTo0wri?=
 =?us-ascii?Q?IbK/EyzBd3L3lCk8wV8wTM0dGbxCgTX0Gr4RN4JiGmi84rdvlMZzbewdG7Rm?=
 =?us-ascii?Q?iL2hINWpN9ZHDFETohgiPoWhFnIdc0p3VWcCvQWUZHXbIge37UqSw0YFtM/A?=
 =?us-ascii?Q?M+nwlv3mofz5ZW3TuB940Op0GK3b2AzJqpDAr+aVyKBOpIUAN25y7VdXJQ8u?=
 =?us-ascii?Q?ImNCszsLDMg0mK6vzifG36nr6YoN048FtQb+n/29vfrqGGYIBBAXrqy76mu6?=
 =?us-ascii?Q?ZVZUUY6VNC+16bIyi0wtTpTyWUApLSEgOGWCQvhyIHKR2hioQf0wMAkLN2T4?=
 =?us-ascii?Q?Hd9LdeFJVvDrhjD1XPMoAJVxvicnvfJFGiINHAqDBOYW1V9dr16v352aCTD9?=
 =?us-ascii?Q?YpkUdpJBnvXRnd820EIhNELmpjIyMiPPJbaYKN3GJWT6954kPeAOh4Z7Zs72?=
 =?us-ascii?Q?46nZcijsOtWfH9Tk2jfZstr+afA71uIEgcJM+WGs3jfpMJmZE4zYh/yNkV53?=
 =?us-ascii?Q?rqT8mLx0D2vvqWB9nfUqjaPU7J+8LNAZNsNwebsxHBa+VxKM0osJ8dTjfW17?=
 =?us-ascii?Q?EN0j4iIM4QRM/ydAIzHfOwOOaBQ/y0xQD/CnCFVnUDwlfTtAEKdhdxU44PaP?=
 =?us-ascii?Q?GVSYmEGQeHNGsXevtS+84sPFiUAV3W44T4EtmicDkN6DMWkqwkcvwwoDqHFW?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b02d3a-b427-4649-a4b3-08daf740ce23
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 21:38:13.6162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/QAxQo+iN4/mo4roD5PyzDd+nW+dlh1bai83MYTEIsukQSULfYCQv8cGS7MhjAZhM5SOKZo7VxPvDU1sa/pTY06zCblT9LRphEbuWmVAH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9607
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For dual fec interfaces, external phys can only be configured by fec0.
When the function of_mdiobus_register return -EPROBE_DEFER, the driver
is lately called to manage fec1, which wrongly register its mii_bus as
fec0_mii_bus.
When fec0 retry the probe, the previous assignement prevent the MDIO bus
registration.
Use a static boolean to trace the orginal MDIO bus deferred probe and
prevent further registrations until the fec0 registration completed
succesfully.

Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 644f3c963730..b4ca3bd4283f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2284,6 +2284,18 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	int err = -ENXIO;
 	u32 mii_speed, holdtime;
 	u32 bus_freq;
+	static bool wait_for_mdio_bus = false;
+
+	bus_freq = 2500000; /* 2.5MHz by default */
+	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+	if (node) {
+		wait_for_mdio_bus = false;
+		of_property_read_u32(node, "clock-frequency", &bus_freq);
+		suppress_preamble = of_property_read_bool(node,
+							  "suppress-preamble");
+	}
+	if (wait_for_mdio_bus)
+		return -EPROBE_DEFER;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -2311,14 +2323,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	bus_freq = 2500000; /* 2.5MHz by default */
-	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
-	if (node) {
-		of_property_read_u32(node, "clock-frequency", &bus_freq);
-		suppress_preamble = of_property_read_bool(node,
-							  "suppress-preamble");
-	}
-
 	/*
 	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
 	 *
@@ -2389,6 +2393,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
+	if (err == -EPROBE_DEFER)
+		wait_for_mdio_bus = true;
 	if (err)
 		goto err_out_free_mdiobus;
 	of_node_put(node);
-- 
2.37.2

