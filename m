Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA52858B5E2
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiHFOL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiHFOLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:24 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1699411A22;
        Sat,  6 Aug 2022 07:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6ofdbtBj/uACmla/9F7DBv7MYXpbGSBidgcmtuHOP9mAxWHMiuR0ixv3bN15BpkeuNNKI7x/PwUuYEAcBuHg/86MeWqJmdtBX1Z2JRtG+ANzYA0ktdkSPN/jbJSLp+4Mmr3tG3PZcVNyStfQgGGbbrZuhDDBlR3a8AftJ2IRXD9hb7CcBaXNL+/E8SYjedBWDLErmDXzuGFOU7aCtUUM5Ag5DdDwbhAS6p1SqV9vautuFHcQB94o2MB2XaNhTqAEBA7Z7E669tCddcfDIjPZByOCRkwtSnNVOOjqC7VwL3lAeRo5N5IP6aJVemn7k1a0TvR08oD0mSHlPoCde4LKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SiC3GdpfMgHxIwiL/EgDiU+2X32cJeETN6FuoGGm+s=;
 b=aOsLqLnbWt4jsvuQKeF3pmbGc7SMmXiPY/+Mxdg6/kM82yzWBSarclRjb7dKnhtI7PyNH8H0kQ9UZAJSnpPDqnHEmInn9NvxqUEofqF+P1ZVcJKX5VHyLLRJTBIyiwLINwtRfJHFEVlzE1u6mjW6uJ+2okr6qCPElBC5qlk44rLCktb4Z3aFLQUVM2A5e5BVp4Q9USYrIv22oQabHqT9FIJBqjCoj7xN/3DUtO4IcctwQpVNyInd4IWuY7g2DLE3i+W5y41f/bEeac/lNY/OeBiC8tqMtwKrBTyIDWl1g9+H9r+RrzHD8jM+0UP5uZla3WDr8kSn1iNuY3+fgrBAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SiC3GdpfMgHxIwiL/EgDiU+2X32cJeETN6FuoGGm+s=;
 b=PhMZVftnPhhOWsXinEcW2kMNVbe0f31mG6lbhKB7wIkz4NsQEIGMj8z8pXm8xq/nvHKSrIZQ+hSqxQtYCUhMrqgTtq4q/WswqRx4bdYX48+tXfE6kkIXhhltyvQlFP285yt8SyjjTXP/rN01dDHMhgXvcake6AcJiAIqa3Fqo4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:20 +0000
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
Subject: [RFC PATCH v3 net-next 03/10] dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
Date:   Sat,  6 Aug 2022 17:10:52 +0300
Message-Id: <20220806141059.2498226-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a1557ba9-bbad-424c-00cd-08da77b5897b
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVvkzUOr5iYcATlcDqHrYYWaEHb6DwKDaw4NXb5n++Rum+92nXJ7drzYYevv+IEF3yHP5Qn7mf58Tbcyix8vsS2oFO1D8JSIip49ltPMsHCEz3BXZuXQ39hTuM0n+J5CFg6ZGEb13++4xrNPmtpmgs1CDvzHN45OKxAKcYj5GL93rJK2AWB6zfFChAYH9bvf+sr/H3LL2l2P+yifcU7F+849XQlE3wA+YCyTSrPA/wKeQE/txedX3IReXRENcyvSxJI1VNNRlfsdxEyjO28tPBQEzyPlC/pNkL/PvF74YBu5vSLPMASNJsBMmY2NAwOhBMYNjxF45Z4w4LqsBoZLq/YCxgrsueuz8qXXi47w5u+6qrDvqjLzr+cmos9tJ8nCD+K96Gi+G4sABMnYEAUQnAXyOMaA6PeI/OZmtGrdMpZhu+oJJ24HEkYi6lJKL7sP7B4ycWGbr0ksGH7DRlxmAjV14C41tlXv2SieDBB7iJaosuMOcrbZ7hrgChIWgKiGahQyM3TxdZCLN6lM5uuDmYlpkTJwWRAei7xa44pdHaOfHeIiKOAtN/BguXRyCt+ojsIkXBCbC2ezxjCwS/bSPOkzVGnHNK3/6wYW+myEwDfgwq2X+4UowFqrpyiVI9quVUxkcj3WLOe8NN8b+gTCTn73mbAxLLpnUy3gp20pzap1zMzCpwueuwvL/lkmjaiTX3HGDiC+lrH5p3W88ENeV8/ISl+7fIjGeroK2qZGKKdpJruJ0AtTDDajfCiIfO/gYy+8qgAlQdvH7gsTnJG9Ix0kjwv24mWdjhCtEMd4Adg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lg+4GdL7RduS06REPuEDDjoN3xT2lyhOKur0SbSrlOqVllufZ1U+LQkI6dfG?=
 =?us-ascii?Q?2ekcK/TK7o4M77/LisIBlBLgYObQgQ2R+ladyXI7BBgA+Qx1QDM4m6soW5hr?=
 =?us-ascii?Q?VamyGU23bDW0wtNsjnxN28qitKL5anU3SxpcTz9YqmS7uZwOxWZD5JPsKS4W?=
 =?us-ascii?Q?im6KxtLwrQLP8HPz2p2nfq3V4b5utOwr/zfY9shcuqvHotfp/8W7b6cOfyAN?=
 =?us-ascii?Q?T/gMWeN/lQUeyQ0KxvGzILCEQP54pHJS1PkA0Wmyw4hwJYtVlH9d9+UN4x8X?=
 =?us-ascii?Q?kha24R4jF9rPSpfjPUCXGi+Xo82AWM2WKzcYz10W7zMO9ADQ74l3uKTh7aAO?=
 =?us-ascii?Q?2K96o/aPN9wdHnjJXIfbiuitSnvIDDzDKzWl9xIQW8hyUKexrqHyebN6qK3F?=
 =?us-ascii?Q?AjrRifEtI09n4KuLZUZFLknwl7E8+zm2jxETpzXonY8+OqPo93dIYBOzMcTT?=
 =?us-ascii?Q?tfGfAhpaZAudtx5Y8Pe0/tYOtx6SDqMgyjoRRyVWftzrAacM05sMitikHXTB?=
 =?us-ascii?Q?LL3hhFo7NozYfAR4rFUZkPJIWEJ3npZ/ortEtJfNypcPWz0nQ1hZCA/PWSZg?=
 =?us-ascii?Q?YZzC9J1VKdVmiWpXUMDMw6V2IjrHADbz3IZmLUjHPHAAXNcZRTfI4OzK1qpZ?=
 =?us-ascii?Q?DnN6l4HuneHTlTIXggTnoPEpXzezC2mOFKFXvEaBS3R65VFhxUs1X+3Ss60p?=
 =?us-ascii?Q?iy1qjMz9SjcUMofEKrDEMocMk5f29bL9jltamwoBipTpolP7qN1ucfMeboun?=
 =?us-ascii?Q?rmyDTXQRe4Cns6fANVujGuZOinRdV+QCEYHa/OYYcpXTskq8eZfFH4ksygUC?=
 =?us-ascii?Q?d6wrpSo+Pi1X/mMKgg7sNNIkT6yvZ4wCUsY3X/xTbCN/lhC9xsMbmiSBZx77?=
 =?us-ascii?Q?nD8kkzYduXlwZ+tRL+5AQc4cThz+hquq1mEXsTNR6OhVRaJmJDoeSbc3TPDS?=
 =?us-ascii?Q?QlVsMAA21gw/vnxI0MKMYD9wrHaPsD4Bpu1xhAuv2PVhYKHoIEkhcaGvoUGN?=
 =?us-ascii?Q?ZyIbMUCcZ+Bnv3ySY/wIyJ/lJdXYCzmQZr/a3Vfmv00XIN0nb4ueiyW8WtKG?=
 =?us-ascii?Q?oMhPmMDO7zSXNujkoIMotP9/wXgrf6PZEWW7FLkgb/6uwFwRVTSr1890EGVc?=
 =?us-ascii?Q?C4/9hk1aknWPO7/EmCAcHIMXYg4q1CC1NR/5qfJxr+0klAQwRdIaW4oZqhPH?=
 =?us-ascii?Q?fJFTeEvQBWEi1l7fNANNS6D6wb3xqG5gUIb8oDMtnoK14/XymEMl7cNIrOdN?=
 =?us-ascii?Q?yMs8v3VsNfQ7UPW32YrVDIt2cXjiL50vghBup/JvSUIBVP8r0cfe7XGB5kCf?=
 =?us-ascii?Q?Mt1J3MazRmRV2HDNLPD4vPFIhdBnu7GFBW+VYrC2TILEwlOEufP8pOifZ98r?=
 =?us-ascii?Q?YBow3XAyfMTiWjLpJ/NxfS0/ARe9T17M7pNElbRMdbYWWls7nVuJk9yT3/DV?=
 =?us-ascii?Q?L2ZSY2xg1nfadunFtnrC2KRD/3IPXJlpLdhgxhm4vIvlEs4nMYnuyivqjckQ?=
 =?us-ascii?Q?kkkHVRZPe+VUxwT8zZwpKmB5xGp3eGgyVBbk6UFp75jdvKogoHbq5bNq+5GC?=
 =?us-ascii?Q?KkzUm/JIrk8Nc+Cn5/lczMylripW7hpFdEhn+GcDMCgsRTeIIUrqco0OQMY2?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1557ba9-bbad-424c-00cd-08da77b5897b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:20.8640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48A+TqYegfn+Il3WM9bdrwc2F43L/hDc9Vcp+jDs4PvT/xanGxIiV9xuSlJak+oCvu+Ms0QZyC6ZNGp9xVkgSQ==
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
---
v2->v3: patch is new

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

