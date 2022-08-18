Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB15982BC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbiHRL4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244183AbiHRLzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:45 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BBDAED80;
        Thu, 18 Aug 2022 04:55:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfwqE8HMI9JqPK+Wgc8ZwK/7LsbZrnd8ApbXEeS3LbCLEQDODv+Rf7MSp10eHZGpTheivMXVrv/laz4eDB7gH7rhFAoo+kHT6Xf4NmThKjx5C+W4opnOKpQD/nWnRmw1uprKrfH0n+OTtk/qkHAb8BEOkfOG/57TzKegguWJC0QKsK+nObgxPQ/H7LRgkNXnJCpS1wL2PplC0CnyU+rzXhg2LQVLhFFhp1aif/kTMiHJcWI0a6rsVSrnx5w/sgQ2kXpFg+Ru9Qq9jLj8vAXBk0ehnhXNWNSBZrsYAmuJM99iOOY2FCyDDmT+OR6h0O8Rx0VLmzcJ6XNfIC157+6P+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcaJG6VT+wgJ+tKlM570tWrdQz90KeQmjBBJk9y9Jv4=;
 b=RmVzoqR31izyrEZJ2JUn3ltOmowI7YeolCgz6jPg70NkaXBPsOnTveKGqmKttQr9+t8DcAWTphE2G6Re2x5bH/VHoazs6S3+oLa8ALd+fJszUowPyldRKb0AtS6bxHlmBnjFlj8MF7y5cVvHQKqYk5b9NdLUCoyHOK9778hI6vtwWO1wJtPrWnksGfOCWdOljvcnz1VRv/GK91fLOuDbjxzvN/pPF+Vqp43IudwATlZLwA0wC+Es+7gC6fnifIOUbfmAI2kEiSNivr4KRkSWoZUYT+Kfke0oX7vH0s9gS1EWMTKkl1ZYSwUZcTSzsYoLhYIBgb96CruYnUVr5vzcIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcaJG6VT+wgJ+tKlM570tWrdQz90KeQmjBBJk9y9Jv4=;
 b=m4ghcZN6RyZxZ8trF617XiYK/vwxV9k5S49zbt+hSpzhGczHhuRsAItxiLlzhn+P1nnxtREFmHKlVv2/CmG4uPJp2R24UsXgwvYFEIl98cAR0kBdAD87b/HAGHSQLRDA3CoSG0TNONi74zTvpM4L/3NRLWUk4aSwLqeM1LUGVNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:38 +0000
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
Subject: [PATCH v4 net-next 04/10] dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to example
Date:   Thu, 18 Aug 2022 14:54:54 +0300
Message-Id: <20220818115500.2592578-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f0b3cc92-f798-467d-8aa8-08da81109164
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+r/jMCoqI3Tka4hzd0vb1tN/+A3jlamcy5SzBgEsdjzuqnhHZhzatZC1AWuU7e+Q4TFBtm2cCgI0PEhd4Q0wBnvJZ/dL560tbjXNeLucREjP4GsPwL9wd6B3PkoYLq4HAOiy19CmrN3CTCmXnDS9z3Sn4COsI+g7P00errcn202CUozx5Zjyn7f5ExJZ+a1ygD0HDmrsSlkakA4qr7QneHeh2PN1k5Wjl+fO27vRJvsgo0hNzjgVrLXvKL5tqWcoi7nCDndmHy9HrGHHU+pZ6yg5iCWz5LFFIeBqySeaqC84oyLsBMU88Eml+K0dH0k3RXttHDj0D4mFJq0sYNYyZ4LR4u1O4A+WYC7/1Avwq5AnwXV+hszOELxDMMCYQaKMuH/MW7Az/KGC9nTArQFthSNsXWTNbuNnINm9fgq3pdiU0Yg2AE/Rwk8Ny/IOMuFz1uvNsvQpz5uZXVTcYSO1UtRTUW+6X85Ja9Pum31bWhMSNGURWvripnTNYdibsEGLA8IFeBGbDODyzD1VHvPYJOWYTP54AhYIwDiJpsfw4WMgzdkkdoZFW1bh7FdWkiBuVfXPG2RLoQPSa62zEf4obQqM3uWPq8ev/DNiEsDZy2vPA2Co3kSpnRex3DKH7DDpjbU9Gj8L+NhIkn43YnvxYgR25yJBv19eqbw3v2nIYBQd2VwWSt3J9CIImTV3QNj+tP7pEEx4wXKRyImh2dQJmrBPWmVkiWl4SSWBZmo3Se7/xWyzfwTEk98AS0ChhHd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vWGiWsKQFoAJnz3bqY2aEebZ4wPWUC6e4lRt0EktAe7QVqWEOhI3nj+jsAIq?=
 =?us-ascii?Q?mabb+/rW/w77HybPcT0e1I+qk6tnPewrlTDuQf9V3HXgz09uOXIbZfa3Js37?=
 =?us-ascii?Q?13iSW5DuJy6QakyzW1eFy5+QHT9/26VGmxJu+Qh3KjtTapbZVKfj7umVwdV8?=
 =?us-ascii?Q?1vYLeDI8DceuUh8WFI+5zFdAPJaK6N8M42CDLaaGOM5yrWQ6AR5Wh2gmUySR?=
 =?us-ascii?Q?8PDDwIBjfAqn7/Rr5lsePn7cCOIdJ5hH8ZK+Zrxq1YAG7dVWPuPsepAyntad?=
 =?us-ascii?Q?h35/b8IQQ6wT+TROkG0KBA42HGXe0oN6RjBE/9AE8uPLFfdnazVJvcTBSNKN?=
 =?us-ascii?Q?YHrpu+18Wp8O97FH3ZH/hhXei3m6SqGFuZUyO6VJdQbS2RxDJGqlvhK25Yp/?=
 =?us-ascii?Q?PzkyLmgD3r2bdS2DqVrPEKuyX6afdvBCzPf8g+gkibP7CxtA2/N1nT9bZrtc?=
 =?us-ascii?Q?bAxqkqqOVsMpJDKep7vvSND3yS+9KXNICGEaimlXIq+nfrbKWIkG+/pkwrVS?=
 =?us-ascii?Q?WaqBsCg3CqkT4Pe/CbLKVeiviFgMwjjgg32fFQClIYB29CzNndlF22j1fWyF?=
 =?us-ascii?Q?WjuVUUiC0v/s4CO8eYF/4BZEsXgktT/Pgq8WnJ9D1mUdf4X57giN7dgY9FEO?=
 =?us-ascii?Q?g+/MXncPXmGqnvVLtZpv4kph55XgURbIAGZA+eYoVPauIsu+pBl/ZLOX/k32?=
 =?us-ascii?Q?SwZTrSXkLiZc78PeGak2bH0RaRrCNCsXql40Rmq3jJggEUs6ByS1R2xWOn45?=
 =?us-ascii?Q?0Mxpqsf6ZW13V7wY3ocWl59JHTMj926rRmNLGPyUXQrfu4wP8MCEsf94l0zq?=
 =?us-ascii?Q?+atO0tNNIKYg9LyQwAxbus2Pp33Zji9dZ5V2SGfg1ODufyQItWKgNLQH49l7?=
 =?us-ascii?Q?cG32B3zAskevVxusEkBCL+gBthcwc1SisIyIw0ktu06i7+t2cBnCf8Cl5OFm?=
 =?us-ascii?Q?EhL9IqY9OzBCSSwEiql2LX0wFBc9JM3jME/mMxdIhaJenOgxdQNbt6HkWiGG?=
 =?us-ascii?Q?RwB177XMoAQCU8cVzKYiJu0AZIW+OaeQNzJDqYLFCdrrcCG4+GcgSOLuS6ap?=
 =?us-ascii?Q?/FVtlIHctAH6oFJNQ2xW8vwo2wyQHxZk4uwz0OLVVBb1Rs7QRS4tuErynyoA?=
 =?us-ascii?Q?xFEI02v/JszZghafMpDBdQ7quvkLTvNt+MeaOBnJM/N5hyoyCiL+7bxl67VG?=
 =?us-ascii?Q?3g7qdrwWo7Ezr5E/FO5YfnMYa/DOGuBCEfR8L0eqpQF0FlYcLqciGBcX3Dph?=
 =?us-ascii?Q?6k0wht6NkN46CskvsfjhmB+5qMAHOSj29iz78FNAft/IdJyHZ9dusbZ9OmKM?=
 =?us-ascii?Q?TjClHoL63VOKRQf/aaKfqAk0RHY9Ot7CsS2nfOXNuTke2MdgzRcED+0fwbvq?=
 =?us-ascii?Q?Dhv/KDjpm2ciUhpjjg04PtCXO4WVn/in4wcKc914+4UpCSdWbnNjC8yuOL/h?=
 =?us-ascii?Q?cEgw6h2N+vA9QP3phcqbwnoMTg0hkBowYFo+XJbLAjr5zW7POhZ/H1rcaie6?=
 =?us-ascii?Q?fJAyMzozxNPm6Nl85UaanarWLPjihEBrIc8OppNzEFBAV6vLGyGL5ztmcB7J?=
 =?us-ascii?Q?jDPMi6oCWU8cpeK6Z2uw9rSho7S7ucKhLZ1DRPbeS79tOuuu28SIhFOFTNO8?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b3cc92-f798-467d-8aa8-08da81109164
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:38.6497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDxw5z0e3XQe4ehuYIGwVV+ji7OHjdxfaeYDDP9hLEmHoC/vLZ32QvdXSDw0sPOW8Zb21Np2baDi2UxFRfYe/A==
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

The ksz_switch_chips[] element for KSZ9477 says that port 5 is an xMII
port and it supports speeds of 10/100/1000. The device tree example does
declare a fixed-link at 1000, and RGMII is the only one of those modes
that supports this speed, so use this phy-mode.

The microchip,ksz8565 compatible string is not supported by the
microchip driver, however on Microchip's product page it says that there
are 5 ports, 4 of which have internal PHYs and the 5th is an
MII/RMII/RGMII port. It's a bit strange that this is port@6, but it is
probably just the way it is. Select an RGMII phy-mode for this one as
well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v2->v3: patch is new
v3->v4: none

 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 6bbd8145b6c1..456802affc9d 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -109,6 +109,8 @@ examples:
                     reg = <5>;
                     label = "cpu";
                     ethernet = <&eth0>;
+                    phy-mode = "rgmii";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
@@ -146,6 +148,8 @@ examples:
                     reg = <6>;
                     label = "cpu";
                     ethernet = <&eth0>;
+                    phy-mode = "rgmii";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
-- 
2.34.1

