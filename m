Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3271758B5E1
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiHFOL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiHFOLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:22 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F293A101FF;
        Sat,  6 Aug 2022 07:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1+UaWA6vs3fopxECGuhdEZAYpNI6DfveXSRePfXNPmz+S3ccPVJodMKP9n3niYWzwoETpa7xXsLRzii/NyzNIlpcRAODdBnWwyu2JgXnEq0LjN1JBXWWj0vwZzej0Z5vpmPk5L5fhvN2Hft/Zlys512aQNPQ6d/YhcEfes7bByL8yQLhcHBlpSSGqcPyRe9jW0neISwppbujvgwFyI0w442ZWCwEmb1nz+QZhXCdMDJ0b0o14f9TLszzce3DL9ds28wCaNYkafkpPkUT34UjCHUEXgRFslDH+6e/lHbkcFarAgKXHQ3pwEzKz6YDgJkSnk7IBmV8qbEbvKdw7OoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvv8DJU2hb6rKuyc2RUsxiY7kG8HaPbXYwe5Sk/NrL0=;
 b=n5ptDbSi2dfEfsOAe1euIbI3wb+ORuBsrruWdSxX3zixbP6CE05245ZkDgaeUKy3PVC5nCv1Olr7Mt24+YSevalP9rrBj5OMDjdbgIWsUM7i0W1/7m33FbWegHSOK0DF63fuJEe/LxdKL6fP4UatVdkU0Y/SZpZzFPoXdMzNQAoHY7ODGzIXZ3RnDIOXnC9t2l6bEBUWeoBvZ5Lwga97LjGxLDDpb8zobowipoMlJ8dTweBtQO+NlSs41IjM0v0qI5rcEWPrUfgGZAaxtrHihg5Rc7yvC41cabq3HIPLu7Z8MwvKXlGaxhWm1fNUNMQv9YiA1vxAybA5Wr9oZauYNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvv8DJU2hb6rKuyc2RUsxiY7kG8HaPbXYwe5Sk/NrL0=;
 b=P4F6epy/Jc5B6dyOWugq6Lq1lpSaZ4y++K0Hh/q627i8mDPryJLiHUifV+0VH/EUNMxapYNtxKv7dGnnPqWkxkTX/mThxWuNBsd1eNFqLy8iSZPdW0ZNU/iHq7+tUQ6TG+UKAhe8tDEv6cQgVsaJsG/ym+C6TcVYOj6DVJmF17o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:18 +0000
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
        linux-renesas-soc@vger.kernel.org
Subject: [RFC PATCH v3 net-next 02/10] dt-bindings: net: dsa: hellcreek: add missing CPU port phy-mode/fixed-link to example
Date:   Sat,  6 Aug 2022 17:10:51 +0300
Message-Id: <20220806141059.2498226-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0016.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a15bbee-f854-4965-3b9b-08da77b5884c
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +S/XBZ6ApUPptcsYjhZbEaJiwaGttkpJ2HQOUA7bP0lbVWg2hdRXcDDxl+EVONwF29DyfwP0H69eFxmc2kJ6GBn5mnNDBtG4G6LEuHKiiVBSABZe7LyDc/4R0eliaqdp1Bo++NS3lsa2ZbXJSZg2xhjOGbiAgojgdHU0/kEs7fqnF+h9NeP3oBQ9TYRoPyp4gmGEYdIKeYkzSszQi0kvcrTd5l1G/OId8KVlFEV6f1qWxvvIEf876VwVx5SfH7K0qQkIigqRavkeEjKbXdGCLp92r3ZMdkvFvdlcNVeBd6tcHJYa76zWkcbBWdokstzFc+l0L9LSMWu0s/LcVd/amnUj+s7Fd8EzSTC7cDXK3JlhUatG3YU85M1ZDusakDbJd6VDnUsD3elbjdfxCZ6tg4JTiAzq6Sow73LEF/N8Cnc6hrIW6qOBWZyw9++cz+n2J0ajx1gXefq4iA2jbBDb74mpkw3jAx2IQK/G1x6dI5/ptY5LtEPa5jEnEilp9Wii2xtKXQ0tPP+n1yd76E3365JCyH4sQynsw6v23dMCiFBOjPhGsOtRLaFJgud8zfl97MT6hX3gCQ9d1CPa+uTkHZO7YPVIZwVpWjd7Wmcte8n3qFM5lXlUab99Ag5K8sKWKh1aGjykE2dUFej9utyMEdGhAdTGWrPME3UNqYeu05p+dUIWgSOynbvQSr2nfAgJkh+iy0ie2D+wyyOwvSfpzzZwKaAaUR7CtFn6dEc/xtIyKTD69eXtJ+lyXPKjPXMQ7GgXzIr6L2ZJoWPtFPQ3+l+Np9FrUTDWbUH8BY92iJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aBJNKlyexdUYhyuYHDQElT+w4nA62Slz+np3s9xuStk/IdtekyS5VMyCHFBN?=
 =?us-ascii?Q?iEsl+qZeJauMg1YbyE9/+6eMtILnXsgpDs4y4SaQEZzBeRBGKz7OAPMt58Xv?=
 =?us-ascii?Q?3SG+iVHe8CDrVtXU6FzSEn5zOisGjRkvZBWks2Xsbjn6Hhpvk8Wq3m08pP9j?=
 =?us-ascii?Q?XsHYYo6dH81tFXOnOO7yW566/NlsoNWj42f7sue/XYSUrnG5Cm5oV20ycPor?=
 =?us-ascii?Q?lI6kTXpQY0B2QOwrDt/ibGSIuod9H0iFEvaeuhu3NpAOH3TeG9foLP4dfgXR?=
 =?us-ascii?Q?8xtArI7UxawaV+Lkni6+jEcei7RCCb3Qo6GlfLMWnTvbFVjcEVJnSo2wTngm?=
 =?us-ascii?Q?rzuBhnR6FiedPPvAV4ufJbEwmuXea7z7iaBFkB+z46jPfL0pNIGJGDkgC8lZ?=
 =?us-ascii?Q?vv5QewW95hw0yS3hAg8ZOrd7FDd+KREqHXTkKKhO/tBGXBh0aMdMvhQatErA?=
 =?us-ascii?Q?pcVZ8t2e3RnbFFtDlrF+ZH3WiokC8KojRzV0znqjj3mX+vf0GJN5QsvEwkOq?=
 =?us-ascii?Q?PP47wUoI9psjbnHP6YJI7X2LyC/2bV6gg5xG7gf4dze95ugMhtLbghfDJiTu?=
 =?us-ascii?Q?Gz51WWD1vVb7htvhXzkN/MCfhqi9uKIgO93DihYeVX0b8TsKWxFomf1ZCsm+?=
 =?us-ascii?Q?SDy4WFkM2y0yCIXGTen3ur3be6OkWj7OFTNYP5nY5l1Ilorayqr3maJHEmt4?=
 =?us-ascii?Q?rDKfBGP5i4B6JoAgrqc+EOQkoyVcttgIFy4fXWJo3xTE/xnxjQ1uRwgoWQBq?=
 =?us-ascii?Q?i9b+mgt9HcYlb4rdJWqkJfPEHRkbVr18zEpiRMPLMze35h/nfRd692QcvCTK?=
 =?us-ascii?Q?5yDP55NKbn+sAowp6kfSxlK0AWUvJjjTVO/zV49WYjFBJ7uN9IbxbOZ16xcj?=
 =?us-ascii?Q?f3RDFR7BAUT9pv2rvySnJM+cYO8QRtzn5uBvRvyWR9Awabs8xLkbC+gCUzf0?=
 =?us-ascii?Q?0AwEidlcC3l1B/vJheuixbOEo/HOcXBbkZa1WV4RCqCw0aGTySFKHqUsE68t?=
 =?us-ascii?Q?lcjCFMbgmdvrp24DKOR2tCj31uyx+9ltYXdZ56cR/Tp2x/z+9Yxk9Wt/FYMy?=
 =?us-ascii?Q?26RzO9D1ny+t9F1UjYIj2XzCsZKOZ9h9Y82uI5ubTE1tAv85hsY+sJ/Rfapi?=
 =?us-ascii?Q?nFW1Azigshk/rPT3RZYFsdMIe91i68s2QVw8fV569Sitx+nYQG17lG5x/wm4?=
 =?us-ascii?Q?MOICGDlNhcDEVbc7YPAf3+9kCrfMBQO4pFMjZDfO6AirKhSZNo7GhvgNZHV8?=
 =?us-ascii?Q?MgzGmgDE79g7BoTislnbKtoQOImkrne0CCs6spFFTaEbklAKrRJPnqkSLGj4?=
 =?us-ascii?Q?V6Bv5nNFUr8agzNWP3NfkGi8KoTJWbJZygVVOFJm9XeP2QSMLeb+/24boFEY?=
 =?us-ascii?Q?3v2K1N6b8evAC7wRWTFKXw+RKKrR/z0Aap7oeaK71DFo7bPDXwyLdwfxlGRm?=
 =?us-ascii?Q?HVAFCs+CwsLyFJSXLBZomcMnaongXegXKC6PDR0h2XNkfCbEnHuJ3AqyUR+M?=
 =?us-ascii?Q?POG3MDpo2nw5t0kDv2mtsVEIOhml51KeBz5+kR9XRqeg5xNbz+mnoDB3B7y2?=
 =?us-ascii?Q?masZQzZ3gPpcQzycc0C4Fne1eXqpB845k15uDwtChVd1TlYcWvnBs1viQBnm?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a15bbee-f854-4965-3b9b-08da77b5884c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:18.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/0CZXWiRgmHb3JmQB36TB6PxggFzTDPi8jiQ7WAC5dlqdqDgt8pKpEQBOWikYzEcK3eOXuBHOzJ/Sd/VEGF7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
v2->v3: patch is new

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

