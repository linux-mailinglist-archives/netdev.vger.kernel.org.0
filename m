Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE458B5E8
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiHFOMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiHFOLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:48 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AA71274A;
        Sat,  6 Aug 2022 07:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/95ortvAc2yCQkssPKXLrDFqtTP8125/fDqcapjDpWFXRZk4VPxmWnOa+rCwSFzquR/75rOe1CKIFzIiYIPLHp+R3rOULuZnhq8EnHW1PhdxR2XUcfmYDs7qgOAD1BkCa2NHuT7k5qcfAp1lPLAaU+0SDcZ7Tvn6bCgHj16/L20XS+kg/cmtStPNwhjEYN/SkOBKBKTisth8wlBNw4V0enIGxRW7b/xNDHdOOIkamIgw9Qs6pY4s+bUQpRQXFSnjnC6yHvLra7cCyLE1fxwz1tP22SK1EStK/0I1eh7vFM5uDz7fPnzn2vRQx3i4U32wfGVGTIRO8Ko43HiUJDQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coyMylyqtZn46B199q2ydgh4rdZLG/ugusg8F87Hoe0=;
 b=KJBa283nr42XZXGHKwwxfbUNyaR97gMX63KVm2axT8V7RBj9sffDwvEu2F5Fp3fnSeuZ4j+WEUFOaG4Bp9Idw5jTekMES12/AfkqKkRK0ouYiI5NSVIb3+bocyFJfbYSG6Zg7eyU/WhZA3V5+H/kvxmxLV1bnxXAxvdaZT7azpZvEKeg5njmpvtpdgwKc6gy4vxy4vo4wxX64rmLQyyKauzPgJsuaYTLGsdcdy8elw7FwnvDMznPj1fn6OnWSRfMgjHCIRN+SVM2gVgSOlg6F0o6Dshk3k2LXjIosVCjtXpmqLzRN9JWOSHWcB0kh81i54VDiaAawWn5/+lj1KUizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coyMylyqtZn46B199q2ydgh4rdZLG/ugusg8F87Hoe0=;
 b=f7A7qKECZAWGF4ezGGbsoDcwII63HKaTzhgPunZ+WMIeOwW0KqIroBGO4v0/e2cBBIDjSRjeVTeNJ/ulA8KzD4rEl7iGteufSdEKeUeGE7438i4+WYsb2Bk5tr09raXJvw1QcETDjwbRyITs3aznHhQPbuqVlYLcHsEg9/+S/48=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:36 +0000
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
Subject: [RFC PATCH v3 net-next 05/10] dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to example
Date:   Sat,  6 Aug 2022 17:10:54 +0300
Message-Id: <20220806141059.2498226-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 60d6784a-53c9-4032-7308-08da77b590e9
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVQtc91uY+Z7Yr3TlZbTGrvyH9JvHaRbED3MOvroO2rkelEbQe3dsLHASz9eZsOU6JiNfOkx86ooAJ03/W9ZlOetP/3RbPl2rHOvgYAphgtxTYomrTpEMN9f/9ReSTHLdKQFiotM0oACvjSazWzgoFsO2UnIuxp5pJNlMaE5hNLkjNM/kF5dJ++aAQZzkBPuoq0T6u4M1ieqFWMIHTPsMpnTOo3efdxG7uwNZYr93QtnH+2uivCQzm9QWL5Or7tLWgC4fIBYI8YTZY2RQ6DOjZlMiZgIh5LwP85viJPs0bFaBkn3Gq9aiVQ0G/sLdA7B1ciRRKdya9T99waHdH9/NDr8wjPpMSEL8f/ak6Gt/tbm3P7wHe9XExqzNrGZKyKr9KxVB1u7sIYamgk9se1mJ0m6kuj9pR7IjFpJTfpQD037Pak9pw8+lE1Qdkotkx3W9NGWc2zUeduRkRxUUli7q18IXpFBjXRhcliG6vJYwIUSB2Udenx/szjrCC4irHTkolJl9F6VGatDEeNbxy8OCf+R7XJkpO5Jj5CziSupT17Pm7ZrMYwizjWK8Rukn2YEdc+uI2E+9jQaoykgMMofcKRn7FK6WNn8wVZL8foaGvMSr17KOVmf4uNAxji+CHXZpZ+7PhEPJEWXp0odj45mlNcuHAdF0Cls8U1WI8ZHeDHWsCibcj/v/vakL0Jqouz4LyaQdg/vKJ3CIO4SmSPTAfv7JlrZee3JyldiRU24amwZ9TE9cmsQwTm6fawIN0dkaKdOBKDPBnNR4X43vlBVrJbHg3jTW0ZZakYsKKiPJFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7jIlb6vcY1/uB9doH9D+Q6PucGFAHGsy+yYdQqaX152wKjCSOuA70GnXChTn?=
 =?us-ascii?Q?KGOWhL3qykr80TqW4UxxxmTTYg+Vbee1uuJvxm4VtFixWsvhazLNpWYDx1+g?=
 =?us-ascii?Q?/Zd8e/1r+c/RNSSPa9CgNyZDashLiHDcgX9eRNWRj/EsUbNclRhvfROkC7o3?=
 =?us-ascii?Q?updztfpS4aHHcMhcYZRCgQ01ex4/DY3KJPRF+w7zQQffORRfOLBLNIAtTvns?=
 =?us-ascii?Q?pV7ShSh4uZwnBLd8zfz6FMk7SMbcFrVPahLH+aaanUE4yhcSflKx1vzgh8kM?=
 =?us-ascii?Q?tvvu5GIOkoqwkr3J9DNF6zzvFTnxA1HDTv4kSXnGBHDQ8LeOCR193oPODxZO?=
 =?us-ascii?Q?v0I1gNOr8VExQISF28QlUKP+NtsngubPwBe9hQag8oiuBoFrs3l6wwdDc5om?=
 =?us-ascii?Q?2NEu2NJUnjJ27W/AUDd0UlXA/XZuiyXRkITAhwc157dwADhkm+ZWnKCdBkh/?=
 =?us-ascii?Q?nmkimHODxzJ6w+7Kf2gJnqcVRwgLgcg23IrtS/mvQ2Hqm72i4si9owm7hwk2?=
 =?us-ascii?Q?ESpfyEnTx4+NdDkzo8CKXGy4qBtpRgze9NGUiaLw4KQ+mZKgepFNTf05hLYt?=
 =?us-ascii?Q?IRIuEqCxnDLhgPIlBxAVr9JbyKwqQVA8QBq8iOVrns+M8B/UeAc13zKZgMjh?=
 =?us-ascii?Q?4TAP9CDvWYVab0GHj3+ndUwNioVuy8KuADIRyutxwUeWMQAmJsnieA1HZQzS?=
 =?us-ascii?Q?DKwrLwRxKbU/TSzoOYevneKSYRlrlWQYZ8+9HfW1ITBWwHwPqEk7lADDTeZJ?=
 =?us-ascii?Q?d6NO4gKe3kL3YANzHjr4naQv5zNQWYgSgSt/ZAGTf9a/CfLPUtllxqzyjHXS?=
 =?us-ascii?Q?0Q+AleRUwaHpvSA6sD+cBrYVk9g+hErvfmMoAZnEwggu/wMxm8oLxv/IuHB5?=
 =?us-ascii?Q?0mPzwTznf+KMpnqZiKq1JiojCNIyQlRuoqOaw/wq2PzuYc1TXpH7jNzUl6p3?=
 =?us-ascii?Q?UnxMsrzr5fRgW21ikDgii0RXb+3nGgeYSHcxBQxpoaHuTJZ5zMspFLVGkaqy?=
 =?us-ascii?Q?fCpqwg1/YFj2IOiiZkOvtRRL7Lpt1pn/8Gdy+2br3VinRWBrogosZvjhae0b?=
 =?us-ascii?Q?Mjk0r3TL/RfMZ/e0LX3pj6MkatG9iJIBWhNdN/nWuVMXdJ8A9revdTy4xcug?=
 =?us-ascii?Q?DgPfykXqvuDtbjvXXAU+yn485pdxWn55tNcXi+uL5Eq/wpraJo0c1/Mxe4k/?=
 =?us-ascii?Q?5d5KetMgDOC7SxerpnW6xtksNGnQ4htZc89rgRAIetZkIZDKdOLzcpyzVGvt?=
 =?us-ascii?Q?cgt9tugQEx25poOxlyn4zPgYCkJDUWNNPvyzGbCFctgADoO8TCYPNFDiaweN?=
 =?us-ascii?Q?SEqGEiIUz3hLL8Jt/5bAbpxbkFyvOMzT/jMaz6Kcqr8NBjt59WceMYqwP5CM?=
 =?us-ascii?Q?8osOFUrYZK+cvejPZGoAaHyOCCJ1YrYOMXgKZSEv/9mQ0gr+uVFKCQm2zyzv?=
 =?us-ascii?Q?/4bUqqzXkB4WrnarmI2950TxASMj3LMv83wlR19ouVRDhgRSPhnL9jQ0U0gh?=
 =?us-ascii?Q?ttlb4QozMoBss9DLU6JouMskn1OO9DKMy537wWJfAD58Id5Z62Ryr7W7NLFq?=
 =?us-ascii?Q?WZ8KSvA4wEyfbC7dofq4/aV2cYQ6y54HrY6hYDFe19UTA5Dwk03YJZXIxbtc?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d6784a-53c9-4032-7308-08da77b590e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:36.1911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SM07VcehSEXBWdb4vJ9R2lNPFXCJ/QfahcSyQrfH78p5DQKsskisNDtQVs54h1OCOtJ5p1pawGYZ+CH5orKYlA==
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

To prevent warnings during "make dt_bindings_check" after dsa-port.yaml
will make phylink properties mandatory, add phy-mode = "internal" to the
example.

This new property is taken straight out of the SoC dtsi at
arch/arm/boot/dts/r9a06g032.dtsi, so it seems likely that only the
example needs to be fixed, rather than DT blobs in circulation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

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

