Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478F45982B0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiHRL4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244578AbiHRLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:43 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D12AAF49A;
        Thu, 18 Aug 2022 04:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggyw1RLqqi/UTbFfX7xi0svdR5leas6UkJP0HSJKKge/zlhNLkv477PflvDpPm3pZH7eM7OefrrnK4pXaoYoWpok3IX3zAwLcR+Rh9qj31y+zx9RNRsYcIA/Yy5MzLxEiJ5R8NgdER02vBQ9AvVgUC3Uj2jacADBIprw7lGIKgM1akJafFR20IF0H5VTPYrhbvWZ6DZyCSAK7jTxCf0OpwHNfNVa8rdqu0CEu3ozrVPQoVK0fpnwjaf+rmtG2/3fIIgX1TrEs/TT7nH+IW0I4FZgX9s4lIHmyS3KNe+Br1PGeALMxT8WdTa8vRfKE0tTSIQv6dCO0NyXV0vrC/GAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lk4V9U1BE4xzO5GEAYrMiA9GFIDfN5XxSLbfTSAuItU=;
 b=FtQph/bEBjTnaJDQldRCfZ2mKLipdW0D5v+1NvWatNEbEGIFVN8il7a1uGQC2r6TM1eg/Pnxdb4LoicMPueCKJrf9Nevs+3XtntTgv+eFI0KU6WrNfjtJzEmzmSCTOKAJLFZOIohdFj+FW6uLU3I/Bvo18cW3o6GkjKyd8B1EeYDRUNpbbTxcyU/ovQZDvZ+FqDG4TAzIB6LGx9WTlnuNJ7NdTd71ovTTocbt5KtW1pN8uETRTEASbfRmnTgoPheagDJwU1NIInu6RDi/R/pzOeGRc83wllH0H6PbAj/X7Y6z3ad/l9Sb4LoRWjyed6RnofsRocbY45wNrhDkGLm4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lk4V9U1BE4xzO5GEAYrMiA9GFIDfN5XxSLbfTSAuItU=;
 b=WRKMVwo39YgSBoC4wwvnn7cu1YJ4Lf4AEmBGi4u1Ru2KMn2r51UqvfnInxjfAE3a/tGZ03b25qR6dd/jD8RvH87jyQkBzyAKC/QxNifxtH1s8yXNq+66uXGVJeWgxOCt53eriCJpHhr5lK8IiGGIb+M+EOXQF2IC8ZErXuZKwUo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 net-next 02/10] dt-bindings: net: dsa: hellcreek: add missing CPU port phy-mode/fixed-link to example
Date:   Thu, 18 Aug 2022 14:54:52 +0300
Message-Id: <20220818115500.2592578-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75437749-3a27-43fe-34a9-08da81108d0b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m7RLArY7WbLUckhSzegZZcdupBxkwLYxMsHiCyWJ9U3ycYzf46iAAI+v3EBYriWDNz+sTEkmBlivl0ztqUxEqqXurDabJB1lXgEbseNy6NFQxAeGXgLEH7KcR2Xj/mr9WEH6r6GWx9N72xvRCF6b4WRcxUuPCzj7pdA8I8l/lHbBXYQcd3u4Iypi4ld9LfYxlhyoYn1Ob9fxwh1KdYLyLeTKhHT0Bx9EVqLosfXhmlYGuEffKiKjkMm+SKjp5EyLmYHWZpHR+hn20wC7DaN7+46a4Kq7D+kzowVfQoBQr3Hd2IUQ0FWUcLmQApDXCHnYrWmztrjIwp4y1Q7OiNc7oWn0RvXG/eWNbH/4P90gzUce6xjgsg7K/7D3/LT/NXoPhcKE4yh1n49NvE4EwCvqYY+nFugBPpRdb/p9MjfgxtTc1uFxHbo0nYysaqy00dFhvOz1bMrt8a2rxeAQd316BOAW8bZTvVNCB3vJ2nTKupaBZKGNHmZHc8HQo74A8yjffmt1EypL0QZI/sVmFW5Mlda1hiCyLSewI5awB2YvSI4KbSfyryFsEioaVXmeVtZHc7TLLyFG81zAzVjWjfaWDUF+D7fswmd0RexH/sNL7jrenrB8Ie3FrI9Bm+EoaXKSvdxFWMVhzR9JgUFZhBIXW1ZjTHZApbLOHA/HEG6zVjJvewmv1flqRjVQpjjsGQa8hkDoKnJ5ImRNju055s4ZHL2t4i0u3yjlB5MHqEO3hcPRuMK83ek8QEliYpStJREXL4k69MixVqlxCPZjkQuZPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JeLgKQa2xHrIMieI03qagXxR2IdwlJjoqMNPEjwKtIjqyy7vG5jLbhwT6UlW?=
 =?us-ascii?Q?6icEv4RVyGxgQjKEaF2q+cb8jTCpFxZ1bWazKMoY3ctToAIErDjqiUNtQIXx?=
 =?us-ascii?Q?pkkzEhnxGuRZhbSA4Jk8OzLg1kGab4bR9GZtKD4Eh5N5cqky8RzJ/xzfrh/W?=
 =?us-ascii?Q?6R27FNky+ps1fIqZD65rUxZWEJ8ytMDxOiPz3ptpWxpAIdWs1wC9OjN3/QNq?=
 =?us-ascii?Q?jALqwEuYqV8PfmFoGRSZIgz9BWHjF+CD6ChPvf4XxDwt9C6PXZa+nYzMDhJQ?=
 =?us-ascii?Q?ZxJhFPvNKjLANhVp82UI84XVddFC2Aw4jMZCWROpqM1mtctXOivSa9oU9KpY?=
 =?us-ascii?Q?ZMyObF+3Hf6TP3Gm9y9zm17iHuQOSdKTAwI1IHKAY83FW28h362QDMz6x3uE?=
 =?us-ascii?Q?4jEwJPbybPP6tlRf/kzsARJaeMGGL8kGdHJBA7CEClMplYiSN374BEALXmEA?=
 =?us-ascii?Q?kyMywxq1M0m2uU28Zr+2L4Y3fFskgW5PNfFDZm3Fvli/YAgHjWflCQnzwrZW?=
 =?us-ascii?Q?BK3TM1FKInpkbwMI7tyNYFvZA4q2EHUXzYu3XXxdePmLBFnIqB74J5GR41m4?=
 =?us-ascii?Q?G/6EbrJ7tIV6Cgh05+J5o7II1gk2PQZImDx+bvjXX6xAuwr+kTB6CmGvdbl8?=
 =?us-ascii?Q?UUbSBWb5JLMbsvI2EyH1206GmEOApTJZ6ZcMq/+/SyJAWW5gZ9vA571BmP2n?=
 =?us-ascii?Q?AoGCkFtpPl6T4zrckwiVmjiBS7n2zVuuhnUCYy+41rDDazp5sSi+MAYHjHAt?=
 =?us-ascii?Q?rFf7J6auBnEURfdRHDG2fLNKwHLIAoPBDHn4geNo9fLlJjmfvc5TTkTewEAP?=
 =?us-ascii?Q?wskXDXaTosS8A2XjqVMJtP+cBDeHO1ImFVWX25F2F9/J203SdSgg5I3PuxE+?=
 =?us-ascii?Q?msknRYBj8A+C8UrEZu0DmF0L9mTJYuW9xn8YVRfIkljjBUnmr3/pu1xNf8lG?=
 =?us-ascii?Q?pJ6fJ+1bPMY0DmcJtzkCE9kcmJjGcjdi6h61JrmSj+qbGU1PpIPTSY9Omxr4?=
 =?us-ascii?Q?1c5N5gru5gEkHjEE4dQ5SOO8pptgNAN/ASTMIYbzfx89Ep9XAYFNywtdZJzm?=
 =?us-ascii?Q?oqDlQHHSw3R9DGS7rJaXwwoPGNnRBGjmD6bNJugAgrLbQPEk0+D/zmw1Kpmf?=
 =?us-ascii?Q?ZmtqoWDFN8dDX8lYqt49cvMV3pQGnIdRgS9ASidgR1PLF/qEM/5hr2xmNpe6?=
 =?us-ascii?Q?NsZWm/vCbQOIS8/21FSZSjVnR7ZyIvzVuKTOuw+DG5UZIZIjK/7kGV8+ZbZK?=
 =?us-ascii?Q?Idk2JJrV8C63hnh6mH6SGalugaX0f9NC0C/nrLGYsjcPcUwcaNMVgc7shHRr?=
 =?us-ascii?Q?C6e3gqswBVvKQsPLhdeCKVu6vN2JGKKY15caItuK6fpo7Z86s+6EBrYyqHvl?=
 =?us-ascii?Q?ldNTZqzXaerbBdMi2i1siXHaqzjSyaY0bHq34jzhj5++G9/ITNFYpXIsz/5M?=
 =?us-ascii?Q?DiGO+My6ODPz8zeDxOVXA36Ria77Z2D9Zzhuaa5he0L2pjE4rnjwobQL4rBX?=
 =?us-ascii?Q?zEkOFY9fy4zXYWu3uYq59OaNCM/c3YY0E5zrKRodQEFjQq9kr/Nh+uq+71L5?=
 =?us-ascii?Q?WtCS0/MxZHWfjGu5UwRmE0kptEc7PTgQ4oWbuxjs5yhKRv9ZE2sNjHoBy9FD?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75437749-3a27-43fe-34a9-08da81108d0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:31.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l87psGM4j5Kg81Sij1/06ijJbTBjdF3MuyQNzzpEkIcZZ4oTFYhFSA4jdsjfVwUw54QY0G1lna7/RH8OLL2uXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at hellcreek_phylink_get_caps(), I see that depending on whether
is_100_mbits is set, speeds of 1G or of 100M will be advertised. The
de1soc_r1_pdata sets is_100_mbits to true.

The PHY modes declared in the capabilities are MII, RGMII and GMII. GMII
doesn't support 100Mbps, and as for RGMII, it would be a bit implausible
to me to support this PHY mode but limit it to only 25 MHz. So I've
settled on MII as a phy-mode in the example, and a fixed-link of
100Mbps.

As a side note, there exists such a thing as "rev-mii", because the MII
protocol is asymmetric, and "mii" is the designation for the MAC side
(expected to be connected to a PHY), and "rev-mii" is the designation
for the PHY side (expected to be connected to a MAC). I wonder whether
"mii" or "rev-mii" should actually be used here, since this is a CPU
port and presumably connected to another MAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v2->v3: patch is new
v3->v4: none

 .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml   | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 228683773151..1ff44dd68a61 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -93,6 +93,12 @@ examples:
                     reg = <0>;
                     label = "cpu";
                     ethernet = <&gmac0>;
+                    phy-mode = "mii";
+
+                    fixed-link {
+                        speed = <100>;
+                        full-duplex;
+                    };
                 };
 
                 port@2 {
-- 
2.34.1

