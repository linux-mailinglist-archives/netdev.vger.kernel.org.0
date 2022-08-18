Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299F659829F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbiHRL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244572AbiHRLzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:42 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12568AED8A;
        Thu, 18 Aug 2022 04:55:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qcgu2bvnq6l5gV4vB2Tf7QDkoxdJaiX+TayhCwEzJy9YVw3viA7+p/Fu0+fW2k7/hFyt6ZSdyXn6I9fb1WuUTlAS5nC6TGKyjFQLV6f2x+vlbdyo55Qoq6TjCVGC3Ct1fqtULCct/VMfTHdrS/3j6RSs0ITLgtQ7aESMzP169B5gPnkai586ZxGi3K6I0lkz0x0/oDukkJ1IAmCDkMSXlfvPNeHVmT+D5QGUfZzM3CmeUNTZGgLk/gjLEU3zfKHuRog47NyN6tyo1GUWNbQxWfPjg+M8Ek2XdDmI52Ga25tFsaP0ps+yF1sIE5IagMJjXOjo+coO0oCjHWCaqFoV5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1M1jniN5EjulC3/8H6f6y1oglPzgTJzDEhEsaUSQo4E=;
 b=BMvxwGTvrfvVkxGFRqK/lh5ZLFkw77tR8K+qzBhcaOoOU+uJ4Nc/G4iEAVX/+XGfCB3rU+9JTHtza8dU8ET6vLFEuKZf8ms0WxNRAUjv1BfI9neqk29FJwgEFtzjKIhdhEjjxZJNdwN+LcqXlpoo9ZYnG3YHDlJMv6b8JjnzwSOQeFP0DUKfrMa+NWQlbq/5Z9NArxB18LRsShhSkY/xvu68q/DV/dDEkfVpYAVFbo3bDLkwoc7DON/ADC4ooBeajBlkO8Vx1eX4Wm3XSFUSe4TUW5Km3zd44EXh73ivqGiE3796Reruv4//OBAITH4RT1oBkWZeGJzHYZIO2H+0kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1M1jniN5EjulC3/8H6f6y1oglPzgTJzDEhEsaUSQo4E=;
 b=eEqv4tcduceKnUJwy74bRc+fUm1JgUXN8RyJyFWxLjuJpInKjQFaPrL6VApHcYygTDxjJKojEujJyLDPnFuiI8RO2KFpiOJZpUkwg3qVMXmS0j4Wd4Gdz8cNEBaKA64V4ldsrldmFfWeGeR8psMaq9hO2JX1A/wZtkOErdIeEmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:27 +0000
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
Subject: [PATCH v4 net-next 01/10] dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to example
Date:   Thu, 18 Aug 2022 14:54:51 +0300
Message-Id: <20220818115500.2592578-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2fdff0f8-a0a8-4e46-aa4c-08da81108aad
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pA+tAXrvyJDb06JVFkpsq1Hveg6mnqxwmrnDi7UPGHXwlP8aEw4vLTmgsWUTsgshi3JAGXBnieMXRbvB4MKnu6I9Fhv3DAsXfs34HCl+g0UUFhKmbNyabq0wS7gqm0/k2yESFlGe7Q+iMZSH7BLfZXQEutaVrnNIE3XL2yAt8haxuim3AiItBOYo6zU6l4u5yqzVWZWVMUbU//KtmNh6c5ardvr56JlDvBcMm8VvR/gpn5BuUyOfn3NrcBpDWagmwqzFyUoz03cr+vDCP7n9OdL4NOGY+EwJHj8Fq5Q6URg3dyZHDLnQiMX5L7BK00A6tjYl9+oOSvTsT0gMv34r0sOVZ0qEEBYQWysw3wknvlWA4cO+8uOsWhkRoDk4QBz9E6tEy2+RpvV/TceqsCfQmkjvwDaeHDmjQvTuJyN6pKm1MT9gYgoHBjMn9Qlorw9fJOhSQCSrMeGyBje/48VjRurzrbXqAkZTLebpYZHkk7R3Tfa6ypJaOTBD+3B+3NGDw0eY41gHFPBAUNVefSRxuzhcEqMbIQe5t7IhOhKtU5R2JkbeOmUNDKkbDCa4V6xr/85oYTENm/NuHeE6+FBoHj/NXouDdSSIJ5t6bnHZLTCbdTXM7u/VYROZ//tOUFx7Ir1NGuDSUQLolTc3cFDekfxxYLThRSlmq3XJJvxa1uE4uS4Y7BXkxcQtY+GklTb9/iGJSUSy3OuDZv+VlFGfuYTVwBQe349XspSYGBrfNozd44xA0Qf1q27lZhYOeLlPassiCJV6Lr6qtbHLWtz4XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(4744005)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D/F8pkZwE9wYvv63uTYSJ2BfP05ODrGnfDX/iahnyyMsl3cbKcCkfjOp2Pwb?=
 =?us-ascii?Q?6u6eWqLgoKmnm8dAkgZn3J61I/vQs0Dwg9/rQfVC8/TcPo6NZ8ae6lajQk+K?=
 =?us-ascii?Q?GWGMoo56eKvauZLAe5eqtZKXo01mfYhGawhal72xV2sN5OcCvatkrbnf4I5Q?=
 =?us-ascii?Q?Mv9EXQFkf1PoM/3HTd8ZZsK6Zm0KnERDwgoHf1cYtfJn+yvUmUTI6u+4Xzej?=
 =?us-ascii?Q?RHpG4M7AvRHEBMr+De0A7w57lTVmaHoHDM/ey9ih3rJgXG0Cr5u9oCCdSpmN?=
 =?us-ascii?Q?ClQdsasjYf1JRZlau9jHmD5e1Fh1K8X/nlDmP36NCUkq7Gl+QTFzJx61tmuJ?=
 =?us-ascii?Q?uDRdsjWj2N1OkSA2fX/ovmtk7qtZ4XpgBfN57lTdopwe86U57TczyidMq+Ic?=
 =?us-ascii?Q?pxbyIy6vfFwde7qmGjCevu/1pBLvZ+bZvH+sbKlf9DRkaNAg8wfO18oLRnOv?=
 =?us-ascii?Q?0s45FWT9q5Ml8pESTXx/0KTh7URIMNfX33qyeUGxunDgMsJTKMrbOD8DuaxZ?=
 =?us-ascii?Q?vIQ1psTXVucSEAmrQPo2kcihwrTDMLhXjo22be2KxZ2/m7riyIZJsBdf1wJv?=
 =?us-ascii?Q?jt+VUMJI4jnrq1BEL1KhVb3N7LmqRzYKKqsXPY110I7c7FlMOcOs6L7Og7GR?=
 =?us-ascii?Q?BCGr/MYgI1LBdkyu95/sbRRxVh2ff3S+seTcXsMNblkorIp00aT9JbHmOA4n?=
 =?us-ascii?Q?0jbLg96VmexbdWEBLgIVAtWxRnlV2n1bLykYPLSSr/uc8g30fUajhIRHSSbk?=
 =?us-ascii?Q?sd29/WqxIWuxK19zNxIm5+Tvydt1PF0DOA4V8AlR+W3+btoX2HacTrZacZz6?=
 =?us-ascii?Q?sfV8opy3HNvFcr5wwmuZrfyYQEjnOGoEUsWFL2EctJ5z/qgXFHIjWIjw/uy2?=
 =?us-ascii?Q?ADSDgKRplKFIYXbQms7mIP7mOGEsqND+aIdvSlxuPFNH5kITKK2+RffT1PzF?=
 =?us-ascii?Q?eqiYIt4kuOiRLlkfJ0oeJXkN+sac32HclgOCtYW7xURWWbhnrrm0wbMvSzdO?=
 =?us-ascii?Q?wORHfiST39CSitWRm5M3ryyJhh6/326tpHPIYikHM/DB6XvEAFjR2YPE7ih2?=
 =?us-ascii?Q?D6Uv7uszLMF6j/qFUGcGTxMIMrPF1/PV6hSyuudq0cb/F+C/x+OHADTT+z0d?=
 =?us-ascii?Q?3OBgboS+REt3yTmWqlNTxq1T15HxWhxtwFq7W9Fw4O65ldCT+/nje9AdWmSR?=
 =?us-ascii?Q?fve1npBv8US9kKaERXuDgihN+ydloSyQZiICThjvDCXJxTp9giRxZvRfOWcu?=
 =?us-ascii?Q?2JvQVQq9KSdo8H+heLcyD9TvInBSy3LrDhG/EivJ70TijlxJoSRFsnOmPfvT?=
 =?us-ascii?Q?mtMzG6Kr8s2xuaT5XpapupnyJH8j+Ik1y1egBLr6I+gLpSK+Zdf1QCd9cshg?=
 =?us-ascii?Q?BzxAFfkK+urLMf8/UxEf1jwXJnNGGD3siRhPQPuZPjKaZaBHxCPSEqO+JISE?=
 =?us-ascii?Q?4jcoU1YiMXv/PHFL6K8gDpPUwyqwMLwLyL8oKItm6EHw+fnau7TMblKwr6x8?=
 =?us-ascii?Q?SNewqvBamtUlkyBZny9/KdTp3UT1eNcF3vyzsPddHNI2kEsIGgZFud2AxEeO?=
 =?us-ascii?Q?6yhlfsvCfCphZoItJzFNrNARvGFImTnDkF64ZWdPJhQ09ggZc8QqyjoqNQq6?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdff0f8-a0a8-4e46-aa4c-08da81108aad
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:27.4162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1c34tPxTzfyLUkv732GogtT55mLhRL+/6/jMgykIYD2oBF26x8292Mo6CTrxVmnbYjJ/wUojRlqV1YerTSSBsw==
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

Judging by xrs700x_phylink_get_caps(), I deduce that this switch
supports the RGMII modes on port 3, so state this phy-mode in the
example, such that users are encouraged to not rely on avoiding phylink
for this port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v2->v3: patch is new
v3->v4: none

 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 3f01b65f3b22..eb01a8f37ce4 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -63,6 +63,8 @@ examples:
                     reg = <3>;
                     label = "cpu";
                     ethernet = <&fec1>;
+                    phy-mode = "rgmii-id";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
-- 
2.34.1

