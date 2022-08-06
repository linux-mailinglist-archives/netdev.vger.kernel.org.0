Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C258B5EB
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHFOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiHFOLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:53 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792A212089;
        Sat,  6 Aug 2022 07:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIubBo218Ne4bCUV+JssS6qxdOJc9Yjc+cz4lhdndbnNTp84h2Qbk1VNT3zUkht9c+CQGNdscoY6bcjeXOTMoj/cjX+p8KEcl3eOBBPRv5zOSY0MC3fPEwFprhsJ3u5/tAa8bx3pTRhzQORMGBFCr/LB2tluH5e7NSZ6Aays9k3LOLtKTbvxfSFTuOp1Mi58bw4ptUq9AmszIILuyCOgrgQjF+WVF6yvD2xw9t2NW+QdeOAbPvsqxq98kwRuKTFbFQH2IO5IkC0fASF2Yw8kmn7xogLbgXCXtmtQVSoKGQttDz2z/ywfuWliWWARd/LZ5i+ohj2vQIP4hSMgnXgVBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOECcxE/wuitMXPLospeENTd0YtUoIuYKlSSxSnhZrA=;
 b=kFLqzpeeiQtaBcxCdkJCpP1q+K6UE/YJFPDnjS/40+LzJ+wM0eCw8gtJwWutcgNYjvq9yu+hYEf5W4TwIi1EJisZeSfqrvuIBX5oaEiMnJftnyR/Wu7dGOq7uMGmwWCdDGFQOPY/VUGQHHpt3Ap3GVlOP6L74tBTe02nAA7/Ofw4YXmJHb5gRp6fPe+yaky6ekmegeZWwBk/eZfc5/PxtVSquOU5k+pjE0TKvilP6VVXe2k3XQfwEg6yzbLsPbN1mkPBRJ3LfyIgmsbH5pcb6bwglsn8+Y1nxl6s+clGHa0KdQFbUhnyr8NbK5lFON1Mw0ohKJStCTOIEIslnGSI/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOECcxE/wuitMXPLospeENTd0YtUoIuYKlSSxSnhZrA=;
 b=StWNPtRn+L04WNdQp/qGW/fMoF2TNCmLpYvjhPLvgkFP1n5Rb00zYglquqW3ZGvLEfZlgb9yYnuiD3nJ113obPs6saHmcoUJjX5kHNTuX+28zA1hbWMy19LLfn7VDwtFq3Rjf/W6GXUyNRU3Fv/dUuDwappxZWvvrVlh1LPj8Cc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:39 +0000
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
Subject: [RFC PATCH v3 net-next 06/10] dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
Date:   Sat,  6 Aug 2022 17:10:55 +0300
Message-Id: <20220806141059.2498226-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7f187b93-569f-4d5d-d70f-08da77b59469
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4a2Z1sbR+AnN8em4BBJb2Koi3zKp0HwP8X+Q1t2dzT9y4bBg67acSj3JXsjXDj5RiGitf9N4yw2DrVP+h5o3ejIgveTnUmAGasNLkDDrt9g+OaSzQiwcxSJAu+EGhNd5v7tH+6diKuWswaUv9DQbCwY+TqgQSMD+zWFQXl64B36mEDOk+XBUqSZAEu4vkMEUIF1LJcIg4M8QpMvqMioYx5qbcGP1/UZ8WG2QNi/V2F+FHNS4wQAP8xQFi/Z4FgmwvodMpiTYhjpGs0DDZ9yCB3beUBnKk9amQftSkO7c/sLxTXP+3/JHVmy9y4pRKfoSYCXahQr53hAfGS8NxJXg1Bs8GD79QUPQJ6g4iiC0K7/4LBe+jhQfRS6UyWLakxCRT8h17yQMRnPfnMRuQh0v0AQ5edBqdQbTmqVxrKtIP1acfZjWy3BXiiynIB/B00sw4BhjCvxq6LCSQ3F3Rg6BU9Bz4Jey466PkZOZcEbCI9B7NqGjyAou1iEJd7QkLMhCfvWZmzuHYFfywg6q/+0S8Rhb6C1/lD0mH2t2yYst+4cLdNbO5hWhhL7PIauFn+dGJ+bdmkwz/Tr5uJ3e0NTa3idAB17EJ/3ocOvU53gB6K4V/7xdsh6tE35X1OLGNw7FaYJNl2OBfDnToZu/GhYLQ8UfcLZmDin0ICWgTtMpe12qd8ha6v3iloOts6ZbKo839I7VBoSsH/a8u4xARb1v7/uenn6OsnYW5jdyc4g68/TvqPcpdM/YnuLm6rCghbiGIdIkOquFSW4eykAjoGUyE59H0zoFF/d5oCJXre8WpUE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rdKZ7enVYRGPbnnebOw2wy1xVlt5NWpinKCUPyP0YBGZoYFoYYO2ltWecZuA?=
 =?us-ascii?Q?GOElEiaKPHSvFxBLMnZ2KuApXZG3Vg+vRjk/A7WHXfY/d9nKkvHlBupimD0J?=
 =?us-ascii?Q?3Uc3oPz+w76fOyVafmKsH6msoisO8Ot5mCBTltGMEGLply7XMtXnyWPMXVN7?=
 =?us-ascii?Q?EeKnpYrkzxEPDpHKyWd1l3dJr5Br/SEfDPx/4vmCQCbK3p0rixujCmit30jF?=
 =?us-ascii?Q?hVPaq0nVtVPMoNpwQBo7j2IQJhvoVht9M+qm1BUInjimt0S4YnCfFIurE3Ij?=
 =?us-ascii?Q?1bh2Ym28s6zhmtv6iA3sFwxQmNfvR4RGOyaABFwpJxrd6olNUFsBlOPchEVT?=
 =?us-ascii?Q?BYdOuVZFmn55YQbMiKx1FxMQgxF3QdukLVhJ2K08aDYaB/WBy6LzHcfFd4Rg?=
 =?us-ascii?Q?oGbHguZ7h2HyBH8AgAzZkKH4gBNZ2s9b1GcpjR0cIJmwcXX8W6hK5uhw2PRT?=
 =?us-ascii?Q?09Aduoc0fp47SLfiZpS9oyPf+XLPaMVaaTqGEX5EXKp5W0+lDNCgaMsyDCGR?=
 =?us-ascii?Q?naogdb9i6T841fhG5rUH5WML4wZ7piR3hQQnuCEyJycmlxEYA020x9DkcvLI?=
 =?us-ascii?Q?1G/0VsJBDE78XRqiF2o+3OMJcRnPYAJIDt0GUSeCydMAJ41CihYyylpOaqNC?=
 =?us-ascii?Q?4TzvZ2VPuYXlCjX/VmoWRNl2u2rQx2KVvbjACpubTepM96RTTIYyjjUM1MBg?=
 =?us-ascii?Q?b7478eZqHo2pJDAVQkPjSxbQEIX8utICzqUZmP2YMYLyMUi3ToV20UJUTDQj?=
 =?us-ascii?Q?I7NNRX52UAsuNP8NhQGgXsILrvcKM3UYyDEyThdZOp6FqO2lrI3FBljXTboQ?=
 =?us-ascii?Q?T1VgW9tUW80SmRCIS7lTJBgQr3XLcPqf2rlTHWDS48r6njKjINtItLfyrtDy?=
 =?us-ascii?Q?Ur3rxutg1Xe1iFfGLe0B08+QVOQcR3oaSAz8BIgosHqxN/2m9HhsVCSj2m6+?=
 =?us-ascii?Q?0+/S7+LWV6G87lhaS5trY6nAnxQxsxP64SbkJosOhI2YlIGIGkuM3O9ISWVi?=
 =?us-ascii?Q?MZHAbMQhQngZstKbkiwcVXdvZnv03fdhpGCEbE+XjxkwRyAaa2pNwcjvNYeM?=
 =?us-ascii?Q?2ujfPEy1p0V1bYk8XJIVZKaF89AQgh68WJK7/TiXubmVxiH7nkijn/HEU/vh?=
 =?us-ascii?Q?KlwSj7coBdrG1HgdDJWF7PviN/kLpDtcfLXkWVaVL+mjJupmZSPHLHnReeM9?=
 =?us-ascii?Q?okODQGyCB4LPRhW6e9iwfVlfyuoQkl6JxiwNfO02kYpJvkPuUWswEc+Otfdt?=
 =?us-ascii?Q?468Idqa0fmu9Vpu4nvEshAk0EhbwmLQiwhMp0hkOj4FCnby9MrZ4Xnd/NNfu?=
 =?us-ascii?Q?lH5H6MCm4nH9rImgSVoFcqIENJuH/VSJtkaj4XNkq1AqShn/gtU09Kh11z57?=
 =?us-ascii?Q?cSrvZOzkGf5XS8d2hPhTh4ggHHtbKTG7UA9IXc/bGLc+wOOG7LeyXZpB8Cwb?=
 =?us-ascii?Q?3KlK/JyHg15ecR2cVM/m+cQdRpV7EGJ+UZ8kQj2AL5XglcQMvYALLjumkMST?=
 =?us-ascii?Q?pt8vbgzg7NNIHMfe/i3XvCVkuDDWwMcQD0Gwxqtk0o0LZguQN/+XI/o7rD5l?=
 =?us-ascii?Q?N7qEjKdgX3T7ZrHfJvzDB1httQy7wz0Or4vq+Md1Wd7MRBz4dYvwN8cU2GRT?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f187b93-569f-4d5d-d70f-08da77b59469
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:39.1440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcEFgH8M1UP3ImMZcMvXi1H+iW8dznkkPf2gSsWHyIMd2MPXOE1FdUxMuWIqIJffwfJKvmh3Onej2iTci6RQng==
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

It is desirable that new DSA drivers are written to expect that all
their ports register with phylink, and not rely on the DSA core's
workarounds to skip this process.

To that end, DSA is being changed to warn existing drivers when such DT
blobs are in use, and to opt new drivers out of the workarounds.

Introduce another layer of validation in the DSA DT schema, and assert
that CPU and DSA ports must have phylink-related properties present.

Suggested-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 .../devicetree/bindings/net/dsa/dsa-port.yaml   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 09317e16cb5d..10ad7e71097b 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -76,6 +76,23 @@ properties:
 required:
   - reg
 
+# CPU and DSA ports must have phylink-compatible link descriptions
+if:
+  oneOf:
+    - required: [ ethernet ]
+    - required: [ link ]
+then:
+  allOf:
+    - required:
+        - phy-mode
+    - oneOf:
+        - required:
+            - fixed-link
+        - required:
+            - phy-handle
+        - required:
+            - managed
+
 additionalProperties: true
 
 ...
-- 
2.34.1

