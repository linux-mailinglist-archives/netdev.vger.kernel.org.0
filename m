Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E915D51EF72
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiEHTGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377188AbiEHS5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2111.outbound.protection.outlook.com [40.107.220.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12048A1B1;
        Sun,  8 May 2022 11:53:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTxbK/ZMYUJQknanyiufCI+unS+S0pzG+qj6NZoJLh6YfCrXZh2tq7fcQW1qeJq7I6hYxkmdUiw+7tDD9Tt0pQolB/nkPt4DkY2Fb4WGh7cqpRG8g5bny+YslrHkZExSoXz2eFHUI4APVK4EHn8iVAU9fH0ZO2DWs+/XEGVvJBjkNby31SWUS/lzEf0/i2m937/PvAVIKmiGWJxA6aGsmCfDIisdepZhDWUWI6E/QiGi6F5wEOZIgOJ3hj1+X2FNWtA5irvA5q4VeKA30w+xx/1WWnRUckym8id+VlVWqTOvAJ/samWli/upLbTsKqJ4z3hFXaV9R2u5xKZxUCtJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFkQ0OKEFLYVgq8FFL3lOp7a1XD65RKQBAXNAqoZEYk=;
 b=LmBjtxC1HGNbs5vBgeKaFwv6GUitxChDVK3HaWcV0+D3Hghdp3bmr7gg00C1lWZcENnQB+rPJP5OZ2xr4ADOhOUAi30d9J4X/JfU62ZGxucQ47Q1dC9fz59/IM3mN8Xrse8i2n0i52p/EPAlbztA9km+sRegLcBf3hBTK/Vz8FbgKBr+qKjGnm93HiBim2LvCs5s1FEapmkxtq7JtS8Gmhywy/v7QUI/CUNRuQcvbRp7dDx2Uk1Z7Bw6SE8zz5vV+PczCm+XoX2ZbKPhqTkMXLYLj78jAoBYY/9+hq4cyeDo+/BABV8CrTvVwRLoBmTxg1WVCopcl0W+BjF/2fcyGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFkQ0OKEFLYVgq8FFL3lOp7a1XD65RKQBAXNAqoZEYk=;
 b=PqbNA4bVcM5M+wqPPRQIkdXXEsc8aCRhh9/q9AZxoza6q1E8/7BkkguaNgIffOU2yJgLfSPUl0PJGAZdFGbFYvdDBOER0yK6gvegFbz/GElyJCvYJDxh75PexZMrdylkUkfq4yyhp/7BsDr6IcY+QdZ1AzrVih+Iyi3Msgao6sw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:53:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 12/16] net: mscc: ocelot: expose stats layout definition to be used by other drivers
Date:   Sun,  8 May 2022 11:53:09 -0700
Message-Id: <20220508185313.2222956-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16a2075b-a1c1-452f-b5f1-08da31241a3e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672E6A8BC9C77925157FF91A4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hj4BlolD3AYhYRGh9T5KDWOfB9tcta9zL3gBXOfFAzKTM+rqabduD8nOWGuiER4X7YYUjqSn67wx5/3HEYhr3cvd7AaUQj3xz9Ch2wCr1ergkC9sRNUUrLptcDfUCXaqpcl/bRtevNiW2rx0357aqebeZ67UeG3O/XQAfg5kxIEw1tGe29xwexlMkFpNAhVcvEGnZPriRfTT9CcHcIxLjzz07DAUPCs3AC+RLC4E4H2uIvNvG8339QE6qSXg1RhaZDLQ2rdF/bQUtOM9C8xR/AZB1kufbTiItsd8+agcyH/tAcpSMR/F5I2eGMEGyABx9+CmzZaVVW16wwtd5Y8KO6pYaq3a2iosLiscTUdh2FUEth8y3nzq/EhASayZMoHx2Pu46XGax8p/46lAml9nH8/p2Ko7peGMcezU9a4aILjJbJRBHnSFqJpjYksJYpTmHJeeySi49SVDZ8B+ZIpwTRiWTuGzXnn9V/4HQr2ktbUyYpuADrnqXzdmHU06IFIXI0seQfbmbzJkmv9PLzxbgaP3SnqeSbjt2r3lxZMR8HRH7BtghxNKJ6XRjg/Rrtqfu75RQOQQkK6rzL5q2qpWy7C/A/40qjKd+bf/FGmXvL53iVaKgb+y6U9xTNcpPLTyeSyNW+IfGG1fDOjoazgXTTEdV9ZA9MVs0s9kzRfsKbUxm5it1PTd3XNuNor9g+CB61mtm9bhpLRsgKBij+XEgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(30864003)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijvRkMjzOb2c9zX3t5qw9sybjBMIJJYe00VdI84jJD1+FAIJ9ElQa8LEayDq?=
 =?us-ascii?Q?bpIOvvargzuhLuLlv9s+rbVRIl/0xJ+JMUfGzTlYtL8BYDuiaPh5N7BUDSb/?=
 =?us-ascii?Q?n5JwV/AXnNnrgG9+zZq462nghwGr/syqxdRyW1ah0DTCc1668sDyQDfP8Fbu?=
 =?us-ascii?Q?4lb2Z4P28Pnv24e32tBE6qlORUU1JLimthjZsIyworn1Oi2BsEbYyNJVBJPt?=
 =?us-ascii?Q?3e3FfXmuvF4iet3uD5IyuUJRIdj8XKgB84xwICVSetHlQXEokndSBhdIrymR?=
 =?us-ascii?Q?V5luUW9Plhkb3yrpuS5MljKo015IZELM2jvg8dTdEjaAdktj8zDR+zQ8PIb7?=
 =?us-ascii?Q?RkeGL5rzrThlPmpdnL8RiYs2c2FoivW6jsPT4yPSECBRAlDXOcbjhgO5ktKq?=
 =?us-ascii?Q?rwHoGi/EQO1QG8CqWcwqDv8HaVftaQrkOr+8AyBEAiV0DmVu49o46iN3ucru?=
 =?us-ascii?Q?y4hoUkXH93nJwyFxZFlZ6GduK7XgnXhEMVOON5uLYM7qxRFzn3cXYJmDiwr1?=
 =?us-ascii?Q?10ClGyHtijPnr+/rjhC2snnxmOuOezSx8Ss6+8/3YJEVmZozCyZosmT360k4?=
 =?us-ascii?Q?foJCYQsJ2YtGVogN9NTBJr4UOBw7+G+arEpUKAcOMEugV3Da/Q71eZxm9GX6?=
 =?us-ascii?Q?eKQ3o98Jz7C0p/E7E1/ZHrkHHnSdPMnicqdw9Q+G/yS3uV3nwmzhn+ijrT6Z?=
 =?us-ascii?Q?T3m1iGn5jYqCvuk9zIj/yeAROsUSHqD33qC0mjyEeyP1iFslgq5uqtK74C89?=
 =?us-ascii?Q?hmJNJokkWX/UV8fH6X1gx3X4zG90rlbcXEonM3OXp2ki8krFcWNkymY7OCOC?=
 =?us-ascii?Q?ouTjippLWkBdl4U0XNF1oXkAgEd1dBsDuD2CxC8U5apmMP6fRDLSh7sh2R8t?=
 =?us-ascii?Q?rJLk+wOGF21vo0BDRVfJLfAC7H4x082yH+9CN40IhnTyTDCmIgptAKyngw1K?=
 =?us-ascii?Q?hZs7jMR1d8uH9JZm4a0QjjnpuffGRqDUmECEkZrZ2FLi7UNHAIwIuUsptzrj?=
 =?us-ascii?Q?l45DyxmEEuJah9tuPotxXVFWyegFP4m0CYCuMZLZw5NGaipmzccQ5w7GerVR?=
 =?us-ascii?Q?c5NXehF5ymkeZZIPpSQyng7UNbLDwDMMs3eDH3AU3Cpd+33ARrDJGMycBoZD?=
 =?us-ascii?Q?+66+vpS5kodZ6LWml116hI5hhCz3RzvuzOfLxvnyW2YLV8v9w6O04fW2cvC0?=
 =?us-ascii?Q?xtab5gjmC6RmcMegUbf9DvcFbUm+Dg9jqGm52Gxvf3cF8uYl/lJgjNkJSFql?=
 =?us-ascii?Q?f209os4PYt9DcCdmyxNGEZoTlUicSSQ7ghpJOpunmurCnfdd77sh0zfKPIvC?=
 =?us-ascii?Q?SHjcyHcxaoi105OSwzqygbP+eBdSg++0drJWar9Cel66wxU0QxG4+3NgGvIb?=
 =?us-ascii?Q?gs2q6tYQ1BNHmYBOY3NT25t4CrN9ShokZFYP8x1fvhN7z+MSDSauxnfDy9fg?=
 =?us-ascii?Q?CUHZKBAYfoQIPh1NYA0rsNChon4jSz206np3JlMia0zRGQuX7uYZh3Rn0pUl?=
 =?us-ascii?Q?I5ytTUuOt0tqA5Ze73L/IrCwFFp+LSQdL66qSVDLAQQzUv7ZlI/JF+35Swa+?=
 =?us-ascii?Q?CTiUiW5xztbdPadUuNrAWBSietCsF1mxR3WQrcWzubRGLmgv6IzPrmoF/czF?=
 =?us-ascii?Q?Xco9tfCCGcsOJ2+LJtauiHM48qcj14XBe6l1hacSWb/pgaH7q7pzgGt9N55a?=
 =?us-ascii?Q?uWSJZZpbfxWyxehr2knyhFokVNmzk3xsQprqoLrrwoUQ11dv87lXQ1LP7lp3?=
 =?us-ascii?Q?2GyC/VtKu2EFusZryaO42bhRUzMAo25qXnucHKQ1IltUKflIlT8O?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a2075b-a1c1-452f-b5f1-08da31241a3e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:55.7903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjqq1lZI6Kahj3+mkPpZ8lZh2RncqMus9NW2sXyNduJyZ+DwjNV6S2o7PfHdSAlNl8wQ5qjfvG26rEL70QFjsSYtHlfyEawTihP1EhHuPH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats_layout array is common between several different chips,
some of which can only be controlled externally. Export this structure so
it doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 99 +---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 97 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  3 +
 3 files changed, 101 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index a13fec7247d6..7673ed76358b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -38,103 +38,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[] = {
-	{ .name = "rx_octets", .offset = 0x00, },
-	{ .name = "rx_unicast", .offset = 0x01, },
-	{ .name = "rx_multicast", .offset = 0x02, },
-	{ .name = "rx_broadcast", .offset = 0x03, },
-	{ .name = "rx_shorts", .offset = 0x04, },
-	{ .name = "rx_fragments", .offset = 0x05, },
-	{ .name = "rx_jabbers", .offset = 0x06, },
-	{ .name = "rx_crc_align_errs", .offset = 0x07, },
-	{ .name = "rx_sym_errs", .offset = 0x08, },
-	{ .name = "rx_frames_below_65_octets", .offset = 0x09, },
-	{ .name = "rx_frames_65_to_127_octets", .offset = 0x0A, },
-	{ .name = "rx_frames_128_to_255_octets", .offset = 0x0B, },
-	{ .name = "rx_frames_256_to_511_octets", .offset = 0x0C, },
-	{ .name = "rx_frames_512_to_1023_octets", .offset = 0x0D, },
-	{ .name = "rx_frames_1024_to_1526_octets", .offset = 0x0E, },
-	{ .name = "rx_frames_over_1526_octets", .offset = 0x0F, },
-	{ .name = "rx_pause", .offset = 0x10, },
-	{ .name = "rx_control", .offset = 0x11, },
-	{ .name = "rx_longs", .offset = 0x12, },
-	{ .name = "rx_classified_drops", .offset = 0x13, },
-	{ .name = "rx_red_prio_0", .offset = 0x14, },
-	{ .name = "rx_red_prio_1", .offset = 0x15, },
-	{ .name = "rx_red_prio_2", .offset = 0x16, },
-	{ .name = "rx_red_prio_3", .offset = 0x17, },
-	{ .name = "rx_red_prio_4", .offset = 0x18, },
-	{ .name = "rx_red_prio_5", .offset = 0x19, },
-	{ .name = "rx_red_prio_6", .offset = 0x1A, },
-	{ .name = "rx_red_prio_7", .offset = 0x1B, },
-	{ .name = "rx_yellow_prio_0", .offset = 0x1C, },
-	{ .name = "rx_yellow_prio_1", .offset = 0x1D, },
-	{ .name = "rx_yellow_prio_2", .offset = 0x1E, },
-	{ .name = "rx_yellow_prio_3", .offset = 0x1F, },
-	{ .name = "rx_yellow_prio_4", .offset = 0x20, },
-	{ .name = "rx_yellow_prio_5", .offset = 0x21, },
-	{ .name = "rx_yellow_prio_6", .offset = 0x22, },
-	{ .name = "rx_yellow_prio_7", .offset = 0x23, },
-	{ .name = "rx_green_prio_0", .offset = 0x24, },
-	{ .name = "rx_green_prio_1", .offset = 0x25, },
-	{ .name = "rx_green_prio_2", .offset = 0x26, },
-	{ .name = "rx_green_prio_3", .offset = 0x27, },
-	{ .name = "rx_green_prio_4", .offset = 0x28, },
-	{ .name = "rx_green_prio_5", .offset = 0x29, },
-	{ .name = "rx_green_prio_6", .offset = 0x2A, },
-	{ .name = "rx_green_prio_7", .offset = 0x2B, },
-	{ .name = "tx_octets", .offset = 0x40, },
-	{ .name = "tx_unicast", .offset = 0x41, },
-	{ .name = "tx_multicast", .offset = 0x42, },
-	{ .name = "tx_broadcast", .offset = 0x43, },
-	{ .name = "tx_collision", .offset = 0x44, },
-	{ .name = "tx_drops", .offset = 0x45, },
-	{ .name = "tx_pause", .offset = 0x46, },
-	{ .name = "tx_frames_below_65_octets", .offset = 0x47, },
-	{ .name = "tx_frames_65_to_127_octets", .offset = 0x48, },
-	{ .name = "tx_frames_128_255_octets", .offset = 0x49, },
-	{ .name = "tx_frames_256_511_octets", .offset = 0x4A, },
-	{ .name = "tx_frames_512_1023_octets", .offset = 0x4B, },
-	{ .name = "tx_frames_1024_1526_octets", .offset = 0x4C, },
-	{ .name = "tx_frames_over_1526_octets", .offset = 0x4D, },
-	{ .name = "tx_yellow_prio_0", .offset = 0x4E, },
-	{ .name = "tx_yellow_prio_1", .offset = 0x4F, },
-	{ .name = "tx_yellow_prio_2", .offset = 0x50, },
-	{ .name = "tx_yellow_prio_3", .offset = 0x51, },
-	{ .name = "tx_yellow_prio_4", .offset = 0x52, },
-	{ .name = "tx_yellow_prio_5", .offset = 0x53, },
-	{ .name = "tx_yellow_prio_6", .offset = 0x54, },
-	{ .name = "tx_yellow_prio_7", .offset = 0x55, },
-	{ .name = "tx_green_prio_0", .offset = 0x56, },
-	{ .name = "tx_green_prio_1", .offset = 0x57, },
-	{ .name = "tx_green_prio_2", .offset = 0x58, },
-	{ .name = "tx_green_prio_3", .offset = 0x59, },
-	{ .name = "tx_green_prio_4", .offset = 0x5A, },
-	{ .name = "tx_green_prio_5", .offset = 0x5B, },
-	{ .name = "tx_green_prio_6", .offset = 0x5C, },
-	{ .name = "tx_green_prio_7", .offset = 0x5D, },
-	{ .name = "tx_aged", .offset = 0x5E, },
-	{ .name = "drop_local", .offset = 0x80, },
-	{ .name = "drop_tail", .offset = 0x81, },
-	{ .name = "drop_yellow_prio_0", .offset = 0x82, },
-	{ .name = "drop_yellow_prio_1", .offset = 0x83, },
-	{ .name = "drop_yellow_prio_2", .offset = 0x84, },
-	{ .name = "drop_yellow_prio_3", .offset = 0x85, },
-	{ .name = "drop_yellow_prio_4", .offset = 0x86, },
-	{ .name = "drop_yellow_prio_5", .offset = 0x87, },
-	{ .name = "drop_yellow_prio_6", .offset = 0x88, },
-	{ .name = "drop_yellow_prio_7", .offset = 0x89, },
-	{ .name = "drop_green_prio_0", .offset = 0x8A, },
-	{ .name = "drop_green_prio_1", .offset = 0x8B, },
-	{ .name = "drop_green_prio_2", .offset = 0x8C, },
-	{ .name = "drop_green_prio_3", .offset = 0x8D, },
-	{ .name = "drop_green_prio_4", .offset = 0x8E, },
-	{ .name = "drop_green_prio_5", .offset = 0x8F, },
-	{ .name = "drop_green_prio_6", .offset = 0x90, },
-	{ .name = "drop_green_prio_7", .offset = 0x91, },
-	OCELOT_STAT_END
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -169,7 +72,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	int ret;
 
 	ocelot->map = ocelot_regmap;
-	ocelot->stats_layout = ocelot_stats_layout;
+	ocelot->stats_layout = vsc7514_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 847e64d11075..2b75753da4e2 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,103 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct ocelot_stat_layout vsc7514_stats_layout[] = {
+	{ .name = "rx_octets", .offset = 0x00, },
+	{ .name = "rx_unicast", .offset = 0x01, },
+	{ .name = "rx_multicast", .offset = 0x02, },
+	{ .name = "rx_broadcast", .offset = 0x03, },
+	{ .name = "rx_shorts", .offset = 0x04, },
+	{ .name = "rx_fragments", .offset = 0x05, },
+	{ .name = "rx_jabbers", .offset = 0x06, },
+	{ .name = "rx_crc_align_errs", .offset = 0x07, },
+	{ .name = "rx_sym_errs", .offset = 0x08, },
+	{ .name = "rx_frames_below_65_octets", .offset = 0x09, },
+	{ .name = "rx_frames_65_to_127_octets", .offset = 0x0A, },
+	{ .name = "rx_frames_128_to_255_octets", .offset = 0x0B, },
+	{ .name = "rx_frames_256_to_511_octets", .offset = 0x0C, },
+	{ .name = "rx_frames_512_to_1023_octets", .offset = 0x0D, },
+	{ .name = "rx_frames_1024_to_1526_octets", .offset = 0x0E, },
+	{ .name = "rx_frames_over_1526_octets", .offset = 0x0F, },
+	{ .name = "rx_pause", .offset = 0x10, },
+	{ .name = "rx_control", .offset = 0x11, },
+	{ .name = "rx_longs", .offset = 0x12, },
+	{ .name = "rx_classified_drops", .offset = 0x13, },
+	{ .name = "rx_red_prio_0", .offset = 0x14, },
+	{ .name = "rx_red_prio_1", .offset = 0x15, },
+	{ .name = "rx_red_prio_2", .offset = 0x16, },
+	{ .name = "rx_red_prio_3", .offset = 0x17, },
+	{ .name = "rx_red_prio_4", .offset = 0x18, },
+	{ .name = "rx_red_prio_5", .offset = 0x19, },
+	{ .name = "rx_red_prio_6", .offset = 0x1A, },
+	{ .name = "rx_red_prio_7", .offset = 0x1B, },
+	{ .name = "rx_yellow_prio_0", .offset = 0x1C, },
+	{ .name = "rx_yellow_prio_1", .offset = 0x1D, },
+	{ .name = "rx_yellow_prio_2", .offset = 0x1E, },
+	{ .name = "rx_yellow_prio_3", .offset = 0x1F, },
+	{ .name = "rx_yellow_prio_4", .offset = 0x20, },
+	{ .name = "rx_yellow_prio_5", .offset = 0x21, },
+	{ .name = "rx_yellow_prio_6", .offset = 0x22, },
+	{ .name = "rx_yellow_prio_7", .offset = 0x23, },
+	{ .name = "rx_green_prio_0", .offset = 0x24, },
+	{ .name = "rx_green_prio_1", .offset = 0x25, },
+	{ .name = "rx_green_prio_2", .offset = 0x26, },
+	{ .name = "rx_green_prio_3", .offset = 0x27, },
+	{ .name = "rx_green_prio_4", .offset = 0x28, },
+	{ .name = "rx_green_prio_5", .offset = 0x29, },
+	{ .name = "rx_green_prio_6", .offset = 0x2A, },
+	{ .name = "rx_green_prio_7", .offset = 0x2B, },
+	{ .name = "tx_octets", .offset = 0x40, },
+	{ .name = "tx_unicast", .offset = 0x41, },
+	{ .name = "tx_multicast", .offset = 0x42, },
+	{ .name = "tx_broadcast", .offset = 0x43, },
+	{ .name = "tx_collision", .offset = 0x44, },
+	{ .name = "tx_drops", .offset = 0x45, },
+	{ .name = "tx_pause", .offset = 0x46, },
+	{ .name = "tx_frames_below_65_octets", .offset = 0x47, },
+	{ .name = "tx_frames_65_to_127_octets", .offset = 0x48, },
+	{ .name = "tx_frames_128_255_octets", .offset = 0x49, },
+	{ .name = "tx_frames_256_511_octets", .offset = 0x4A, },
+	{ .name = "tx_frames_512_1023_octets", .offset = 0x4B, },
+	{ .name = "tx_frames_1024_1526_octets", .offset = 0x4C, },
+	{ .name = "tx_frames_over_1526_octets", .offset = 0x4D, },
+	{ .name = "tx_yellow_prio_0", .offset = 0x4E, },
+	{ .name = "tx_yellow_prio_1", .offset = 0x4F, },
+	{ .name = "tx_yellow_prio_2", .offset = 0x50, },
+	{ .name = "tx_yellow_prio_3", .offset = 0x51, },
+	{ .name = "tx_yellow_prio_4", .offset = 0x52, },
+	{ .name = "tx_yellow_prio_5", .offset = 0x53, },
+	{ .name = "tx_yellow_prio_6", .offset = 0x54, },
+	{ .name = "tx_yellow_prio_7", .offset = 0x55, },
+	{ .name = "tx_green_prio_0", .offset = 0x56, },
+	{ .name = "tx_green_prio_1", .offset = 0x57, },
+	{ .name = "tx_green_prio_2", .offset = 0x58, },
+	{ .name = "tx_green_prio_3", .offset = 0x59, },
+	{ .name = "tx_green_prio_4", .offset = 0x5A, },
+	{ .name = "tx_green_prio_5", .offset = 0x5B, },
+	{ .name = "tx_green_prio_6", .offset = 0x5C, },
+	{ .name = "tx_green_prio_7", .offset = 0x5D, },
+	{ .name = "tx_aged", .offset = 0x5E, },
+	{ .name = "drop_local", .offset = 0x80, },
+	{ .name = "drop_tail", .offset = 0x81, },
+	{ .name = "drop_yellow_prio_0", .offset = 0x82, },
+	{ .name = "drop_yellow_prio_1", .offset = 0x83, },
+	{ .name = "drop_yellow_prio_2", .offset = 0x84, },
+	{ .name = "drop_yellow_prio_3", .offset = 0x85, },
+	{ .name = "drop_yellow_prio_4", .offset = 0x86, },
+	{ .name = "drop_yellow_prio_5", .offset = 0x87, },
+	{ .name = "drop_yellow_prio_6", .offset = 0x88, },
+	{ .name = "drop_yellow_prio_7", .offset = 0x89, },
+	{ .name = "drop_green_prio_0", .offset = 0x8A, },
+	{ .name = "drop_green_prio_1", .offset = 0x8B, },
+	{ .name = "drop_green_prio_2", .offset = 0x8C, },
+	{ .name = "drop_green_prio_3", .offset = 0x8D, },
+	{ .name = "drop_green_prio_4", .offset = 0x8E, },
+	{ .name = "drop_green_prio_5", .offset = 0x8F, },
+	{ .name = "drop_green_prio_6", .offset = 0x90, },
+	{ .name = "drop_green_prio_7", .offset = 0x91, },
+	OCELOT_STAT_END
+};
+
 const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 9b40e7d00ec5..d2b5b6b86aff 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,8 +8,11 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
 extern const u32 vsc7514_ana_regmap[];
-- 
2.25.1

