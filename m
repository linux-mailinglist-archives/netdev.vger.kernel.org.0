Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55E259829E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244248AbiHRL4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbiHRLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:43 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC5CAE9DA;
        Thu, 18 Aug 2022 04:55:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUBCc+r0s2PshXrgfGs8la4WZ37fyqguJ03f3Bo+GafQaaC3ok9Rl39LoUecmJe9f86OxMi0Flo6QbQDkzABETnLyn8W5/1eqLtEeb5xIrp+EAwogDHoapVaDC7Hw8FSaHVD1paurPZ9E4N3DsK3IGdnAjV3ZeY7fKG8+tkjz9QjbsdM813zJxOuYosUvmw8pF7zqeUnOP/PoxMdLnWOOqrFSRZ1h+UVb1EufwtOMz0naxavpB40U4cXkG0clz9W0zEA63oZRkptGpxetfpVQBx4qgbmanfYH4xrQh4RLMgKihC48DD+ZkPgigyOauxVuJKzQiVvAaAfb/e3AOHw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP1p0rXH+4IFzsw/Axokb/H9MT49deX/rumq78oTGYI=;
 b=Hxbs3Cb3EXRDX2Rb4aowI0DyRghh5wTMCCY00FRrYY/SCRmXKRouzNjNSscUx8kYFuyHBYCBYGXM84A+huCOjsHA+FSJ7stakiDkeJ6/goQ6vu67hUA5Dh4fkPX3u23dmDqhwu+f//76uhxJsuo4Kz/FitSFWYAAQIbtdCOyUquODiQg8Hepbq7ILR5j+7id3T8+CLHY3nLWccU0n2JocLG9rPpOpAinDb1l4+HIv7yY+enAQVgdJhgj70TmdQionm2Q/cdumFODe9keR4nFW3Ko7O3yF3AkJVExjgnZcx+03BRmwwqtww/4yUO3a5KGlfiKusfRJr7RrdSGO+s5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP1p0rXH+4IFzsw/Axokb/H9MT49deX/rumq78oTGYI=;
 b=F4djOz+YX41hmmkfnTR37AxhhXb2OkOvlYK40B1mkTgLpUjwTtlySk2Jubwb6zY83OTBfPPu+0kX1XulwDagPxWQoDDQuJw2d6iJQhk8TOeTqmCdZDClLcR1Dl7NaKPCpuV0RX5IM4fKbz3GryUOkVM9fxSDHsq9KnsBHsbb8Mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:35 +0000
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
Subject: [PATCH v4 net-next 03/10] dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
Date:   Thu, 18 Aug 2022 14:54:53 +0300
Message-Id: <20220818115500.2592578-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1a3b461d-1881-475f-10d1-08da81108f39
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNIPrTx0laU3FTVq7fLQIpNCokUX6HZECDQaWXiKywHSAHrCQtf+Sadgd+yxTg2ie1Q/41Oyv5kh8RnOMz05H6+OJmA0p66k4ZGmz8ZIG7ys1ndsk64Q0jIKVKMG7j9SYBvQfZ5JEVxCjuGvYOoyyty+L3QtKh2gR0oUtm6PcJQY5wZCHOa0Z7u1EN9poZ85C+OkjggT8CzvuOsimfuEYaUsA47w2FGKAgQannSjYWEBCsTl7nzvBzPYxmvEYMeL2JREUsUv1DBzVMC7ZXz5TB3CqQB4JhZ3TPk1J6G/tZiLArBIp83gYFY9bEPc/SPA1eKU6JRyBkmk2UtV1tlqdeI4wrTIO+LLBGfrhW2Kgz5/4dP3IOM2teKCLcP5UA/6SZQmOEMRZtsNJaH9l3osphgviiy/TmgouDllglMfBWAXbZ8fbbRl8jSoc+f34EZI3dxOKY7XSPAYrr7sdonQMLv2/1S4UBCSv6AqS61gomkGgIDn3YB/4HVn3LT3UOAnt0ZHvH+24Bbc2BVbOdZV3EFV+7Lr4u0lh19m/ShkI55RQin7g75cESffU0FFTtSo4KsqMsw++wYdxivROD/jgVzvsIAXOwz9b6ejz8S4uyFgY3XPcGfbFObr9y/CUr/v3vESsRRTwH81+9cgjUIQss5fMjnjmubl2iHsbmhG52pyv3Q+WKUbLafp7nUZDu+H0VU3AJF7HGdRSunleiCrpsdYPi/CqPOolz4sAi05oOjOiICiQfsGlCIMndOZC0r3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBGEWVb9K7LUYMsK3hJTI6PitCVVT5PyO4FSBwDZZNqWHIwOei4ltRLlVuHr?=
 =?us-ascii?Q?msT2vueiYA8Ju+QhlIeDfTPXK5N6BEAYL6iKLRFlolMHcCqZrMBgIlnX4jdl?=
 =?us-ascii?Q?GFJdXnAa4X4vLLY1Zrfow+dSvPIsdVAAQwOUwChHSocDcc/iS0FgExPXTPCx?=
 =?us-ascii?Q?Xog7A2Nc+JPMHZvRmT4bvjR2fA8aS84sK51N+40pekxP1ucHH7koV7rSeaFL?=
 =?us-ascii?Q?VaI/VLZ1sH8AWn+y6dtfoWyUQ0ynha/V+ohxXHy614Hh40BJI0XJCc34+g5+?=
 =?us-ascii?Q?70x9IuBaQ0ryp5slCPfGW0vdyeyQz7FapSC4nYfG2B0hzOKjw23srd3a2iHa?=
 =?us-ascii?Q?8ydxy1f1reR8tLiVoFurblop+oH7QAMwKQcknVqUY1dwewC6GuViFx6bGQWA?=
 =?us-ascii?Q?udjZJPGAWJSQw0fqpUU5XgpayA+a5QuOgC/RPDG/1ULSZpe4kvTEjU9H1HSn?=
 =?us-ascii?Q?U71cMV1hjitbKm4n54beH11wQMXIG0Wm0nnwo8D1inpidlK2XocOvjpbRm8l?=
 =?us-ascii?Q?9z/E2K+wfHEnOtex1SfAPnS3nGeiR3JoWVyCIXgLH/QsG2euDXAGsDZ0SSBi?=
 =?us-ascii?Q?SUHEOl3Gmgh6EvZvL2odqhX6h4JdKZ7BI4iuZ4H/BpL6aVVfvA3A5oGYBRtB?=
 =?us-ascii?Q?/oh1EPkZQyTL8dHZnCg2Mpek2TMgIH8MQ2gjYZWhbE4krOajDaUNds+ChXJg?=
 =?us-ascii?Q?nEvwuPmdvFvmQlLpPbmnrz4GyciV8nBbXTtW6p6+awDQ5h0kufyhBxZcDzi1?=
 =?us-ascii?Q?zUTNSmR4V88Sl7NknZODwiaJzZvjYN+Tb6TFDaI0p1/GKSKW7ZYHkG5Ev083?=
 =?us-ascii?Q?1Qf5MDCPPXXPJFyN6AN2faW8gSBi0luWbAQ72+9MPZfays5Tuj/Bd6iURvqV?=
 =?us-ascii?Q?t1y+/YrFqgfI1divQ9AqRzxfAQQNtRKizGmcGnbP6ygYFNg1U3NhNEi5sXgV?=
 =?us-ascii?Q?OwxXqDy0Vm7wTjW4cRv/JB9AQ/eA8aagtUlq8IuTSC8NDI4ed27HBMKRHMZw?=
 =?us-ascii?Q?Bxvlk0gPwWT8nHY826Luka1A483VeUnqeNwqlNP4UJoZClomkc2p3RGOb+CM?=
 =?us-ascii?Q?VNErLcpOEhL2W1qmSWV7bpXm7ka3nsOEftFvRydIq+zugeZqUrTtg1QEq9JL?=
 =?us-ascii?Q?HEL2wJXsxswNJgPsKYUFUV6vmC/SxSGzwORXSYpC+IvAg/DlUL3YmhnbfQ7d?=
 =?us-ascii?Q?WcqOk6HjFua/cWpKWAWjGjrGEECqMDSYSPVnU7YWOZxdurRUGetY5IRWlRzD?=
 =?us-ascii?Q?HM5UdBsLCoucZgxrykkFRRdVVtgszTSqFDx+8muNhoKzGfTRZYs8a93v6tJm?=
 =?us-ascii?Q?fWWf6J6rKzQo8FhnY0/WUdjUQJHBGPEpnqP0JvxOMqhrrofxoQHS1Q4IXLqd?=
 =?us-ascii?Q?s1dmiEFrT+dlIW8TVs/QSpK90eDIOSZO4kpQgsBgFt4HODA4q6GqYe6GEUhZ?=
 =?us-ascii?Q?dqs9muyCCuQtZ0KZuG5aBwWjigSmcUrWzWmvmUehKohMPs4fOqAzoSjcfjOb?=
 =?us-ascii?Q?f1nKE36uhWqleXg/fZKN3r7+blPT7aESaD97KnHx9iPKOd3uFIYdVRkDDu2D?=
 =?us-ascii?Q?TXZaGSFaA5Bkl7DEJ8vC2GLZ3kvuCj9emVJPcHXsPxvI7pNqOAHtnY/qFsqI?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3b461d-1881-475f-10d1-08da81108f39
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:35.0250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1RdgAFNWK24w+AeJRBRg23wFwdTG3NbfU36rwCChtj+0CdsoSbX935XydxJkGp3B0Hvypms6L0Hn0QK68at0g==
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

Looking at b53_srab_phylink_get_caps() I get no indication of what PHY
modes does port 8 support, since it is implemented circularly based on
the p->mode retrieved from the device tree (and in PHY_INTERFACE_MODE_NA
it reports nothing to supported_interfaces).

However if I look at the b53_switch_chips[] element for BCM58XX_DEVICE_ID,
I see that port 8 is the IMP port, and SRAB means the IMP port is
internal to the SoC. So use phy-mode = "internal" in the example.

Note that this will make b53_srab_phylink_get_caps() go through the
"default" case and report PHY_INTERFACE_MODE_INTERNAL to
supported_interfaces, which is probably a good thing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v2->v3: patch is new
v3->v4: none

 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 23114d691d2a..2e01371b8288 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -254,6 +254,8 @@ examples:
                     ethernet = <&amac2>;
                     label = "cpu";
                     reg = <8>;
+                    phy-mode = "internal";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
-- 
2.34.1

