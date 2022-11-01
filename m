Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8C6149EF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiKALvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiKALvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:51:01 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649596346
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZaOJl8iyWK6Gdsd5ACxZMu+bCCTRbUoU1m3aoIeqwHCZapQu0P4TGolY3pH9uV5QBFZOwAfhfT/dXOil0JgMN1dbDtaIkc02u+8XH43wivar8nwQ10OLz+pbEGbnxqgroshjKMxu80cIOONO8PCCcMTKOaN/vejE1ylxFlDDIme/6EaHWrNOvl1lPLMOuE15AJRzUl+5A5ghLiB/BnIpu/caPg74/db+oxTRZFlKxH0M9k2hRX9c1/szHETVPe1Si4JSmnlsKaK6M5wzFNzhQLMQwEWJ7cDmDf7R9RkSiWqW/55cLAsmiJKKpTWsVfIUtHLGVvS0bKwBH6PEQhqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkfQsMcOF1Byf5KgKN3z+tYc08KgWQ+l4YooQgLoNRc=;
 b=bhpTbeUY2GWd8K3Z8fsoPkkY8EOkFCaqhF9n6yqDePfN416Uv/HZBk4Gg9KWvqOYZ6u6c3Sb5B+Sy0OYepA6DC653QxT0sVrZD5s7RK3ilYC6jKYJOXlteRhym3JY/Hggaj+tz9PCo81x/4TCbNx6nnMVed26AKcelscYVRrOeXF3T3Uxr7eJgLzGI1XjhnR4sPgrcvgLjKA3zx7TGu9xK5S/byV20leWEg45W03Orqdlm8RFdNVvjaTwGEbOjndHsN1etDBSMWwn8IHLlvFw5GaKnh08FKaA+uAlZ4xwbGD/zecMbfXvX6zBT6MtgrtgdtK6gDoBIZR+TwmiqJK3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkfQsMcOF1Byf5KgKN3z+tYc08KgWQ+l4YooQgLoNRc=;
 b=DEXxTYnz6LX0JT5mOxTNy2Jf7dNof67bj4fsyYtT3TSQUg4Nbp7VsB7VWKLdcE0SNhYDjkCzhvZPA7x2geM4Imier/sxvmNh3aaK7ElIzkYi4M5XaOTMU4oU+1XEo4L5BJLEB+mOO70sApEdlQZCm0TfVnGHwlir4xO8fV86Fg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8453.eurprd04.prod.outlook.com (2603:10a6:20b:410::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:48:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:48:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/4] Remove phylink_validate() from Felix DSA driver
Date:   Tue,  1 Nov 2022 13:48:02 +0200
Message-Id: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0057.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 3208d6e2-2f10-4536-f2fc-08dabbfefb35
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5JYPetroDmMN5Wkpu1lN64M9hQ73oE/PUPI0iENjhAO2uudII+GiBSmaKqBOERUYlSY0MInMsKE/f6guLDBV8GgR+utdH7eWzgkDu2ezhGtczk22kyqnJG8HN+l1DFFxH5ttfXGmD5/kaMhAJcS/XcJi9nY6SQDbk9+3Eaauw49vDSjN2Wx6jYai506qV0L47KdBtt9xebgWbjNOAP9hIZ4pY+VQaDNKjMneA5N3ugPOOtU1HHELerjDYiFy/tqPQA4OXwZ/V2NnhsbxH2UaEtUtF2xgqAc2sblLtDwx+jYYvE+J1jaq8eECxrE3Wu3t+DtsB0wV+cVzKkZoo6zp6UuGC2fbT3/5lkJ3uhIhaLJq2HkE9HmXVPP4E0GIEidcUAbdqnFE+I2v1ULlVEh1bMQdEG9K0ReZjOq9ITcUbeV7VL6avrSZ7upGDzKxETluWKWgjuJHbPdTgqDqcYVnidW+i+8+PCOuSVSqHRoNmE2Tl1RSAec5wyrnpSB0hbaYHtsNy/B2v8DxmDuIWD6yawJm78phcza7pIF5mqqidyz8lnKfSpR676hbB3gQweywAJIBS7xE3MM8gs+OAE+yc4poLi/hD/5WraNeLtXB8PEMyEeF8UqzVQiPXjxYp0xf9O+TL451L1CPROBSeklJYL3GrhYUFprTaptfM7e6UWWhs4vOl1u9ZZwoEUNJBXdu67VMe5g0pVIyqJaUDRoAcR6NmeqqRZXi5eaHqbNzmj9Kl2yJ066Yj8oI0u+1IjN2OCdqHm8uEQPGmNUmI2Zkpfi52U/hMP7sTeJ+/BTIhg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(6486002)(41300700001)(26005)(478600001)(44832011)(7416002)(5660300002)(966005)(2616005)(2906002)(6512007)(83380400001)(6666004)(36756003)(54906003)(6916009)(8936002)(66946007)(52116002)(8676002)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(38100700002)(38350700002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rwjPjb6wjtq1vLadCYM4/H6c2OqZHYKnkv+1bkrwZp2sKUG4COGj30U7vn9X?=
 =?us-ascii?Q?JeoWhiwIGB41+0KHq+3os0msuFP2ArEQfyUvr2dOjNFiviRHEQ4+M5Z5NdP1?=
 =?us-ascii?Q?RJzkWtQsQqRgmGDI8aKx9XwUY0ThYF1v6twbGnNAQURYxZYzz65SSJXKvYkY?=
 =?us-ascii?Q?QzQjWZOhzH1ioWK8Tfw8SRK6VznWWmYTVVr8p25lcg0UmtDkaJSiy7kLzRe2?=
 =?us-ascii?Q?vRtydvu/1BCHAi0jzbyKGFkgyUehuYE1nuSkpaPX+iu3FF8QxMKxVDkNgaR/?=
 =?us-ascii?Q?SmIuk+yYS0OQTppnJGFfFmjYUJaglOACU5yvEfcK9/Q9Eu0tnOfsaU15K4N7?=
 =?us-ascii?Q?0/dB45CYdEyeh9zmGP/KfuTltMj65iJR5RGPHI0jATXIWRwWPCoO7U9tpGbG?=
 =?us-ascii?Q?speezACxDmXMX3Jj7kwhwX+kJPT6zaLXIMRwDmrv8YYlkERkq3hyqL42Bejb?=
 =?us-ascii?Q?+L7308cg3IofWVl4j2DpypC06HlD8pOGoV8Ct0ToY1sF5AWKWjP3+mR1fwUM?=
 =?us-ascii?Q?TsU8BWbUlefFi1uyUXNYJu1ILBt/LEUbhVCBLX2uxwm+QCvokDp1U6zlYHhz?=
 =?us-ascii?Q?5t4pyD3gXvCAQK+zZx/mp9+oy6ernXFo80rb26pA2vOMoz/SNTFLeOh62QM5?=
 =?us-ascii?Q?jWv2RYPmFGK9xIe8xBf400R9wA+iHL5FBbzE3xmhEeuyfMu5goPRDc25WTdm?=
 =?us-ascii?Q?PlOYBYfwo9qTs9ArsT78mEufaf4D5icrJOzS7kxgSAT+EOqTbrtfom+o5PeA?=
 =?us-ascii?Q?2VIgQOA4F6oEFJSI4WFcHGxHAkqoPjVEA/mK5ZJ/3XYvBFOlHjpTEqrREEqN?=
 =?us-ascii?Q?o7ijML1UozfwOWOQ4CAtMigliQzlbooFGi8lVfF/3ggEnIQDdkj3mGaF6LRz?=
 =?us-ascii?Q?Wb5VfFPeIiBKe7RZ46p3DRERxm8k2+ft8sQkgd1snz6GsD1v0WAA8SgNLQ5d?=
 =?us-ascii?Q?4Dp2OZaov0cEjhg6LTRVmfrNO1Rj5jMARadzMAkC1OJbUJO5KxGgWP94t6hF?=
 =?us-ascii?Q?W8h72yogpxkwjKQn5cMYWVJZkf+qOBNf9maMS4/WVM6wDboli3nvIYYWA+6L?=
 =?us-ascii?Q?UrqftpVhgXLvEsEBRxDPAGRSxyeYzeB8o5bPS7Yrqh0R7sXvzJw3ETVFLJ38?=
 =?us-ascii?Q?m9zP3iHJYWCgEz5PXCPs2ctL0eW9X4c/yei6zV+SKTnufX/y2iv3zyZU1LBe?=
 =?us-ascii?Q?zQUj9hIvQB8Cf9xUg1dSUhruedtyaTbbNmtojTBnct2512W7jZkale8sKCeh?=
 =?us-ascii?Q?o/tiel1rIxRj4kd9hRFTDGzWCSpzv/PxhdJjhoyG/mi4nOTOCCJwte0blr5d?=
 =?us-ascii?Q?A0Nc8O2LgbzcMmB1NwPtjnYT1gikxMiyXtnZ/qylt0bbPnH/0ElECMAgUehn?=
 =?us-ascii?Q?V2JEem+KLx2uaGNRHPdXdFkvjAmMrEdUIe2BCHcCJSVpH8FQfo/23tN5qvgG?=
 =?us-ascii?Q?+efDYFPU6vPC6tXPdDenrzhCwrclIokM7i0Dvfu08PHjfsFNh3X2yzJm5+/1?=
 =?us-ascii?Q?TzXUjctW+s2P9zmsioGyAnATXMn/nOYNLq//fPdx1QIX+0ifcMCfkoVjxcMW?=
 =?us-ascii?Q?0puISuIRSVj1+0C+Y66QWzTSUIaRqeIc6w6oqdv3ogXyYrGBGMKArix4bq4k?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3208d6e2-2f10-4536-f2fc-08dabbfefb35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:48:23.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeTPRY+EofPrROYdsxj+lZtOkYE0E70clFW+iH9hjsHlcsyiGgNoZAXhvGBYeKg95RZhiLfDw8ic5EJkM9AEMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix DSA driver still uses its own phylink_validate() procedure
rather than the (relatively newly introduced) phylink_generic_validate()
because the latter did not cater for the case where a PHY provides rate
matching between the Ethernet cable side speed and the SERDES side
speed (and does not advertise other speeds except for the SERDES speed).

This changed with Sean Anderson's generic support for rate matching PHYs
in phylib and phylink:
https://patchwork.kernel.org/project/netdevbpf/cover/20220920221235.1487501-1-sean.anderson@seco.com/

Building upon that support, this patch set makes Linux understand that
the PHYs used in combination with the Felix DSA driver (SCH-30841 riser
card with AQR412 PHY, used with SERDES protocol 0x7777 - 4x2500base-x,
plugged into LS1028A-QDS) do support PAUSE rate matching. This requires
Aquantia PHY driver support for new PHY IDs.

To activate the rate matching support in phylink, config->mac_capabilities
must be populated. Coincidentally, this also opts the Felix driver into
the generic phylink validation.

Next, code that is no longer necessary is eliminated. This includes the
Felix driver validation procedures for VSC9959 and VSC9953, the
workaround in the Ocelot switch library to leave RX flow control always
enabled, as well as DSA plumbing necessary for a custom phylink
validation procedure to be propagated to the hardware driver level.

Many thanks go to Sean Anderson for providing generic support for rate
matching.

Vladimir Oltean (4):
  net: phy: aquantia: add AQR112 and AQR412 PHY IDs
  net: dsa: felix: use phylink_generic_validate()
  net: mscc: ocelot: drop workaround for forcing RX flow control
  net: dsa: remove phylink_validate() method

 drivers/net/dsa/ocelot/felix.c           | 16 +++-------
 drivers/net/dsa/ocelot/felix.h           |  3 --
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 30 ------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 27 ----------------
 drivers/net/ethernet/mscc/ocelot.c       |  6 ++--
 drivers/net/phy/aquantia_main.c          | 40 ++++++++++++++++++++++++
 include/net/dsa.h                        |  3 --
 net/dsa/port.c                           | 18 +----------
 8 files changed, 47 insertions(+), 96 deletions(-)

-- 
2.34.1

