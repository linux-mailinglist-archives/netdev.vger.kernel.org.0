Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C4858B5DD
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiHFOLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHFOLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:21 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9211A22;
        Sat,  6 Aug 2022 07:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvCrBkRkXUBdtksnjMN9/tdwPyRM6MgvJ6roMyRz4Z3mVAgCHfMp3Pbv+KqxvqygWlBjCmi6hE4EoUylrmvxaY1OGwHb9CdVdN6dSuLwYMOeko2cyYbOJBWve6U0OT+07k5eSL4YSKyOGj/hPkyWiesjoTi5Mu9oR+O5T+pblyV4k49qZnTCUZxvKJA0SHo4Hg6xSpf1/sfxyvmfxIEku2KDmm6zigVTcMSHcUYn/zH4DG55/w1dUo/yEzUiQ4otPYAv+rkfNYYmJkwZzU/HJ6Naz1Q/yY8Rws7KwAhXxh28/PRxt6L4qKSEYUa2ZgM7i0ZkLJNm7x6RNWOYhRgA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FCTLrpXcpumu3j7inS5BXnNP8394/sXya3Ht9LhiuU=;
 b=aY/tW/G1wr7BOZlMC0qYzNnitJfeDtEgr5dzFAbqqQChpkMXMxF95ER4/IHKrQ53uW0VyOXKvGPY+SJoDtV4ihLVL0DxpWcMSjSOnrX/65czdCZq227ZSOIIs+IcvIVG+7IoGWr2PjFtuJvti8DdxmGt/tt8wSbMWFy4LfoBjUW5BQHGCY5cDbEeGQhgF1IVCptBfgCTvHd3jHKy5t1XBjNwuqIh2bWUDRcNNjHALQ78F7yazN5p/hQALaxozm9LbKVltn6lcxz6fRn3sdzHGWkKJxVwVYocFE4Ce72lctSkBcKmfCYE0I0LSVq83/zxy1eCfbtxBaF93Ntry82uLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FCTLrpXcpumu3j7inS5BXnNP8394/sXya3Ht9LhiuU=;
 b=NhsB/+w5HxpK95yfpakbjZoxQ7c0dEIjHZ5zlxE7MBPw0gVXslM07ZzeM0VKK1+7GzIFXcZTwgDRFhaq1cpqJ988iF4VGu9BsPPC0ODKw5dYGzkbtz6S/xwp+D91GABSgtTliEyJQ6z+JKy4ABWDRfGSXCPCe2frHLgPr7X8hhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:16 +0000
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
Subject: [RFC PATCH v3 net-next 01/10] dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to example
Date:   Sat,  6 Aug 2022 17:10:50 +0300
Message-Id: <20220806141059.2498226-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0c84877e-2140-404c-daa9-08da77b58700
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wEQ4E0H2Q1b0sD/HLyqKfcO7ZAGdDjnA9c6nYvlhVgpa1jFdUdiMG/WPDAtJE07C/+SdMdxXhTwWf78r8aqb9lVVDiv5u9rSaOVUluKYBgwJJJSl5ItEYdLoj1/Pyu70f6l4ObnGsa+wg7OWEbfjhNQZ2vD4NMElQBD2m8r7eK7VeyzOe6md6r+a49q+VxESOhwGxUUKIoTgUut/Ktgcvgj60M6T2BPHzZGtHVn0XoWY3rmYkIpwwlF0U+RI7kNk4cX7zQxW7UfrtM8OydUYe4Txz4A2KWLotDVIEat1JTGSYUwPQxHS7/Eck5IVCUq2gYZPE0Gv7wvGw4TjvGb4OtbsUiverNSLDRVPgdGk7LCcVJbykZfo+hEQTpM7Sb8M0LGojEApMh8JLqLdUbtJOS0VvgxhxVh7Rly/9xDcI5+zrA990Dc0KSt/Zs0kkmOvJPztMJrP+IsrKwbuGIZfsblBJFg+07Uw+rKdEKvYHROfQiPkFblilGutshXbJD/3WeG5t9zWsk8X31KVtlaQWMtUInv1Cu21xqLenG/zKEqdQH5xKMKS4qeX4B35mVxki3H5HBa7n6+tbteMkRy968gvGKthQCKi7HKTg8tZck7L4rQeuZ7qmnXamiClHBdIKPE/fDgWKbiXUSOH/Apx+yYNxmPdYKEak9mMKPplFibCRemQhrEOXALarcz+NH1VU7IWJiroalg0ok1Ec7Wv4QWjDmYn81zMHLRmsKUopXx894ZPXNCz1S6ivvsW6ElwYL9mRf/nkt5ZtvobV1OzW0MTSHs3nKv+u1VNoXBEFw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(4744005)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Q3Kb/TJ1AHPFIp2I4/ZLMz7GYxOeDCyebZxjTa39tUH5aCw/k4JRo9gQMPq?=
 =?us-ascii?Q?vS5Juo2d+jWrLOZV0mxkMOKvGzmCrnXCNeq6roJ2jq5LUa7HOCsQV9AUxp7w?=
 =?us-ascii?Q?bbmDwOrkHiz9qKMheCJH6n/il5RYJF77FpOxQXghoH7naXwqbNja5yRtiNHp?=
 =?us-ascii?Q?7+MgJFLg+Sjllg7JOGU66hddZdXVJ54WoAGYP3HGuPZVfGADfxR+rIwdd75m?=
 =?us-ascii?Q?/zf5yqWl8pcib5fOKUE+BE2IupIoDR7gvJ/4MJRCaliIQR+so/lURqVbkkaE?=
 =?us-ascii?Q?vfWXPKlfGBGvIhvAk8DxMqFd6l6vp9yoRQdIREo7yoc8DOkf/FKb+bLfYzOo?=
 =?us-ascii?Q?XqEzKOkkIWvldfW9yvDrvt1tbd4RYaTNxYqpCKOnoG2rp56nRGiT293ev7b3?=
 =?us-ascii?Q?Ld+68QmwcZOn/BUKggY1vV11776XyseuU3OkhCicqpC7DmFi6HIUNT+4rafP?=
 =?us-ascii?Q?bSl0xdUA5/lgQRGOnPIxwaAorIXlVUHIJUjRR1NOuaLqeNGaebjsZr0KRDzp?=
 =?us-ascii?Q?CqCS0Yj5+f8RAOfY/gV62Tx3HpVF+gwgnhtcLmFv7zkbg9DwRqDWDeu1GkRb?=
 =?us-ascii?Q?FiXXCd0DGidt4PZKWW8FOXQkO32UFyDePOPfCmlr3vPoA4gr+SW5Gjj0ca3u?=
 =?us-ascii?Q?wEOeD4/9EiEzvLb+uDFU5tYqz2bFm8pKeLlVeGKQ5/ojywMdcCEva5OIo+GI?=
 =?us-ascii?Q?ueVydA261NzC9CCevB6B2F/0zSnA46S2mPUtKfvWgmCEVDAZqrjmCTMiHYS2?=
 =?us-ascii?Q?ef2sTZ6H7caMK3GMiN0NJFRWPNFtnqMGNDO63m5909FChtsQK6MYACFM+wl9?=
 =?us-ascii?Q?GysV16cTTZaYJS7iK+7riZRYYNFyI7psCNoeexSBGcPdQApRhUvXVfEfBV2V?=
 =?us-ascii?Q?6yDKSS6S83zVqBeYuks4dRtMjRyyYhpU87A0ipMYQN+ZQ2KVaRk2ITG7yEId?=
 =?us-ascii?Q?E8J6iuJ/bzwO/tqkJxZkz/IC9p0JLFDMNgH01kZ8/L8v6rAHD/hmMEasKpkG?=
 =?us-ascii?Q?J+OO/5lXgW7t4bj9jEr0/2NhudKIDEPrJoJmyy/Y1OOLXs3mk7BCd6QSHiJd?=
 =?us-ascii?Q?Qs5isy2G58JhqeBxGe6icwvnjo7YHEfY/iWfc198ql0uV7ViYah+jc2RqDTH?=
 =?us-ascii?Q?bJMmUKw2yuzrGnIkCAe2+Uqusw3oORr/sX6PIsJXIf0ZVmKovbN67KCYlij2?=
 =?us-ascii?Q?Oc407lOjs4KXaqFmk1k2ynoxfv7ZrYZzEy64Wx34oaggiRTYbPoLJciMsWxr?=
 =?us-ascii?Q?i2EvmL22JbnKvqrwYoZqd3U7EEXQdxT7rc+GQ+zuLAO8o9bpVPNCiJM2t6OG?=
 =?us-ascii?Q?kuYHAszU1IRud8D/VP/8pR2mW9ZQC+FlqhXKyUOlt5BioCprNUyY3qHa7exI?=
 =?us-ascii?Q?y0y9vSWjVHa/S0jM6EWJUtrOau3l9fekvi4aGL0eMEffPS4b8uNROLz6jb7E?=
 =?us-ascii?Q?URZgOBhUoqP50OUZ02Y0Urioq19wANh3xhc57ZlNNqEsXqrA4o4MThJnHNyz?=
 =?us-ascii?Q?RY1mQwgMFKqJfNTKBwByKEgrh7BZCPParcgayrcd9aju6wXHx8DIvMMcsTqa?=
 =?us-ascii?Q?AEuxRQ68cVNV9fZKGWhL8NqFya+YDYOBu02Gr0vpIInSdz/jG18FDioD+xnZ?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c84877e-2140-404c-daa9-08da77b58700
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:16.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqtZ6usxK4PvLT+sA0W/1M8bU7/gZCTOXc3dohbLv/xeo9Sr8aZtbzmJ1SaPtDFXdpmRGL42cKMNwB2V8saF8Q==
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

Judging by xrs700x_phylink_get_caps(), I deduce that this switch
supports the RGMII modes on port 3, so state this phy-mode in the
example, such that users are encouraged to not rely on avoiding phylink
for this port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

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

