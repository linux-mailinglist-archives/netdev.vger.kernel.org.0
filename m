Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208EE59829C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244277AbiHRL4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbiHRLzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:48 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ED27FE57;
        Thu, 18 Aug 2022 04:55:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVXHlM9071+bi1D+HxZ0uqBiO4EvU67w8UwVq9M0CjnahXVQ01llZXUKa7/i3CKQ36Syyjc70N6MWFuPmcJUsKXb56MkqUIER7N/krkpOPgvCMCnVszpAyYCfkJ421WKdCqqgqdYiJ6QlleeEcO1LPu1pg64UB/krGj27TEk8ndeWPD0R7qbkXg5Xf3W9l9AO2OGi1ZcQIyZGa10X6ZyWDxR63b0SMFyzeq++CiWxBILFZuWqRXSSdPF2KcSmDltPDbUd18NPRcPlfd9BtpWVx+79kMJ+hBpcs2Y3EgH8LswmWhQb0453eBQbe3BfRGibGnIEuLQSpNmMetEb4AlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYX2yy354CEUAEetif6y5kKV8fKywyEk65II4f9zoCU=;
 b=PHd1N+U4ymbNY7gMWZFhJNCh3BJ1FXM9vhTkRQ07haGp+U6GyMwND9z/yYG/KwNNrSeNCaLfSK8Nxp+6pFFHeDytCh91wd4eeX2GhwDRETUytQ81mMp1cJyJx2Yw/y+jypCp4XnDq5JN6xP+LZ1UHqFjG6SR80uVM2YHYPM5YnuuXu/tEZjbG5mywaUFfNRKO/M/mpFriLWCJ+XDUMgkdBJHhzxWYlYV9fhI8sJs+cEl5oZ1e1mwbkQZR2mR3XyRmqXUrmq4Ca87SGa5SvA1NpSxaQS3QateAPhw+5kAH3OA2Vn/4UZjggKFywtGaak5QNJliqutCnOzWYsbtCHQiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYX2yy354CEUAEetif6y5kKV8fKywyEk65II4f9zoCU=;
 b=iK93g4HLFpPnZzYAsXi3ov75KE2I/NoYxXl+2oXxd7llbih73QEUXxPuVZuTC4tXcPk393I67GpGZSM/Kf9KpIHWIqf6PzUj3WwooTL6WuEIH5QJfobclWZzs/fmNsC9MMiCCiHf9t1NvmBcCd3wXunKfI+2LdQsY/rvZMs48dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:42 +0000
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
Subject: [PATCH v4 net-next 05/10] dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to example
Date:   Thu, 18 Aug 2022 14:54:55 +0300
Message-Id: <20220818115500.2592578-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 346eec36-b9e5-447c-047b-08da81109390
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzerO7/kdyFIYBAzsm4oMXEtonRUvtKQGfZFDfvdvNyVjxN6LkGdaQa2+ewcL3ajvfplkmQWC0utj++SaUz9vnY1Tuz9/Cy+UJHvVntPadvRKq8jzmrwyTHTDW4+sjoALseLvCoqR/bwnE15KPIi1k8+nvr5vSELHQ3sfnioEORVrYF3/SqzOK7lWIEvtwgNCDuINs23gDExau2uCHrZCsgfA2+W5uotnPzuPNp61z44sv3EMkEU6TsxaTWg5JCO3N1XGC7NlJnv3veYKiTTXJGK1zbw/R630avgl3hixu+NGcrxWtFkMOSY5BiH497E/O8Zqu1VdhAcyQBH8RlXohvk+i75yAOS30Qe9/aaGDz9dZcC85++E/6mshVWz6XExYXwSa3k+XE99/5dB4c41spzHB9VMTfWl70/byNoebeFXhtFE+oXW1yezWo3N66fJskHOT0IBQnFFA1uOVaZFSzPQM9VSkQa2XpTQlFBp/1dl7MCAKEr1HcxOHCysjEsAqEqvaVtW4o5/qDDcSXEoeZXjOZeI5no/xcw1S5Ow2QCIi9GbLqJJZ/fC2elpB5rDuui0k+CGV4rS8hBs/qGlIDM6wUtpFTZHg90YK2fGYTPeU/pV8rtm/KiXsVdWVgxXjbAUJB+d7EwFvrNajY1r+31999fDmTxyRKAg460sJqZP8PRqxM9KRNAFN0naa5yg16Ss+KbxrxE3y3IqPCFNeUJOshMij7fK5nhBuOzJwg4y8m5jWar3Km7uogA88QT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LCCAdjN9BDOMs8ZuYWUIH+yhrEvkA7uCVOAKGGrftStV0KP1GWSSPu4ANSUI?=
 =?us-ascii?Q?oPIMLq4VzL0Eewct9xkzzbbFthy0jnm7+yb0+05lcXOol/DUgHyDbPuPiZCF?=
 =?us-ascii?Q?YdM8chyIerqS/zinbKNlZUOZRA7/QLNWV6lFL5IehfbN6j7sH0LRziWzO47I?=
 =?us-ascii?Q?ukiuTcOnlF5NCDWJX63gmk0tmZie+on1gsQvwrJVVjy4vPpMsNC5TaFLP4F3?=
 =?us-ascii?Q?tT+0WNF6uaNhrHIAOCtBlVG6IbQ/ldsl1Xj5C734JUrxu21kv1u1mAK7Ad5m?=
 =?us-ascii?Q?/5+EoWeXYDxCIwlwK2J3WanMZtrbD51Ch1y++0EQiDIkaOjFl2v4kO5KatQK?=
 =?us-ascii?Q?tbPL5DLsbjIClREg7cTYAarX+QYPy2jUCKPt2daALp7/ChkV/XQ/4l0YY1Xu?=
 =?us-ascii?Q?G1XfqBz1wq40IQiUXSrlzJep3mCZ67imyHFrWXIYMfmp37EwcWuOzsTjdzwC?=
 =?us-ascii?Q?XN2HIaXaRVPwTv0Oh4S5aHwRAIOO52c9RZpd5IdxmyoT46up90fbjHFeYQJE?=
 =?us-ascii?Q?TXzrImVE311wGbJpu9ZQM8remDYm/UNWfMZ5K91JZP6fw+ALOsNwQRbKwMqx?=
 =?us-ascii?Q?pXqgdYmjkJt33SnLK5cPhsV+O0KBO03agnRKUQKLPJYfWwJyfAfe0hD7fiF4?=
 =?us-ascii?Q?ZUKLnAQ2/kgB1JchIBBMNRg/7vQ/YB+GFgWsrNPZqsIIi+XVOyyhVgk3S16g?=
 =?us-ascii?Q?rR4HMih6xAAkWlpyybwBVW1hRV4MnEZPr00S5XbMZsT6fMA25yirORHnt5jB?=
 =?us-ascii?Q?AsENW9f/dpWpoD047rs/xL6u+mRQhiyvCmu5fdKhzyA1HXFSc/djNK1OxMDt?=
 =?us-ascii?Q?8Y7QBFdXMXMtCmzif9E9S7dI1wO4OX4XQO9ZJWBcbhcXW0bs/vJIByri+QWy?=
 =?us-ascii?Q?NTQiMv3Ejlrfk8aHxV/gq+40dlAK9CNphc3oGTrGJM2LPEkWpFW9GNcUr9eL?=
 =?us-ascii?Q?wxXORYcRjXnhoq7ZUj3VaBuC+VKI6G87E9qOnzKhTu2Rl7qb8VQRTOwQ7VGQ?=
 =?us-ascii?Q?aB4H8wz+dIXwVXA+mhkU20BXaecV85e98LpikmCw6JYLqyUo3NxN2ZL47z2+?=
 =?us-ascii?Q?a8s1nDXyEYh2s21SM4xj3dW+xT1vy4azflrj9P6iKO5/dXS2rhecUK3wXGtl?=
 =?us-ascii?Q?xPxExcMuHxSMOnbNbsQKzHCyWOmXxse7LFdPLPmxlvbh+DmC2cHfqbYHCaW4?=
 =?us-ascii?Q?6unNY8SLxstZ5cJxldIbn+0qtghhNmHbGE1j1Imh+3456Nc+IQDJJBxuaURS?=
 =?us-ascii?Q?vporxsUc1YU8+0YBa7y64szaHWFY3KJj73VyAMmfnCm89ZyPZpBycxFpVJH5?=
 =?us-ascii?Q?1tam+Fx+K2CHCr1ei0KoQyZWUiFOpkrK7MorLR7HjWteWmst2G2g/MIytETI?=
 =?us-ascii?Q?XqX9kBT7rDiagk2mJ0h5xodLZgCtx7KjUkloQBkbyyf6U7xE50trx8Kuoegz?=
 =?us-ascii?Q?1KzSeUhtasvYxip4rgJgO+Obwwo1ToOmA+I1kiauJWfRa3xXjqwAiDxjT0F7?=
 =?us-ascii?Q?DSWvNWElvTukkLg6SAuGQBRqGAD5ii3aCpqbNlXLpjMWnA4W3le6JKQKxzrV?=
 =?us-ascii?Q?DrrGnuuR5Dj/21pVtArZ6/MOkR5yESnmgdEccw1voyi2dD92JWQbMB4xVQ69?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 346eec36-b9e5-447c-047b-08da81109390
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:42.3370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SN7gBcdteRD/l7/vy7ccMxa8Qz+n5/TLT/0HRPsbI5AsYAi3wnkblkYgz3kPvjMsQp/y0xrn0ZecAJDuG2uq6g==
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

To prevent warnings during "make dt_bindings_check" after dsa-port.yaml
will make phylink properties mandatory, add phy-mode = "internal" to the
example.

This new property is taken straight out of the SoC dtsi at
arch/arm/boot/dts/r9a06g032.dtsi, so it seems likely that only the
example needs to be fixed, rather than DT blobs in circulation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v2->v3: patch is new
v3->v4: none

 .../devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml         | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 4d428f5ad044..14a1f0b4c32b 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -131,6 +131,8 @@ examples:
                 reg = <4>;
                 ethernet = <&gmac2>;
                 label = "cpu";
+                phy-mode = "internal";
+
                 fixed-link {
                   speed = <1000>;
                   full-duplex;
-- 
2.34.1

