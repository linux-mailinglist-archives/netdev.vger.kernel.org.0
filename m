Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639DB4D6A48
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiCKWso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiCKWsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:09 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150048.outbound.protection.outlook.com [40.107.15.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE4C14A22A;
        Fri, 11 Mar 2022 14:23:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhwKIn/fGcVKsIwT+gaAFVwAJjyGEPfpDqAtwCOPFaHokslc0gfzuv3kYVMz3IhMqnH14Gl5Q4T7f6L6iMfa0BK0V/GE0l87t9woTpcse+xCT//xex85MdrsAfXTnAc4AP/+NH5/CnW9U8qXVEFExv4F7tVJAVcisTnZ1p6eEz7oqiWdaj+wO2ikDKjEuKJlv4rmyf9QsOy+XfRqqTKmPV/kDsEzknOOX5yEQups8MLI2/s0Fz7ufHqPJhgKFGJQQQcicHgQeABXV/D15ASTfny631Lxm6aionQzIslGrCv1Z0zRAgBof0p7Yi37tNgn78SET0RISluO5PhSgQ8gSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8EvRziBrhfuptUtj43jWxg/4cPm3VS8CTFAgkO707k=;
 b=QSLl5G4ofqoaJZ76xOpcmuxkIZIi6tS2bX2oZYvthXFAkkD5EEhTdJ2wU+BERf9mxF24vSAobuNmTgqkzSVyZUtcCIyozXpwjwX43LVBCNiDX0pR0qml3LRbjBG0oZ8oRtj+s/a13mOTJqpi1p5tjoFMU3LqkEIkSSkPdr+4IPF5mjPLJWFu8Sy2xOj5lFC2l/1sFl8mfPWFeQ9PGmK1/CX8sifgzic4vIHYnmxjtksQWn9aEtkrxm5pZ3K/n7gGLWwYvBDF2rFKL4vE8czqHboFU/qJDCuQJGy685XZkf3d+Q+Ce/KCLchloIotSwtZGANMxPR1dVfwkBNsYm70RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8EvRziBrhfuptUtj43jWxg/4cPm3VS8CTFAgkO707k=;
 b=RM0M2zb4v5N4oxxqr3n3PwF1ASSmkJmGF9dXXMlj00ZXQfAqnsrnMDxK3VvixCAFpaewxw3JXcFNYUlndy63AtWYkfws5rp6OYFTslu/8EYmgV3ajb8k9WLYvfhIkqS/wHTuQwc9E+Ukye+tQPnie0axNwVOyUaQQ2bAKe2BF4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB8845.eurprd04.prod.outlook.com (2603:10a6:102:20c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Fri, 11 Mar
 2022 21:23:31 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH net-next v5 2/8] dt-bindings: phy: add bindings for Lynx 28G PHY
Date:   Fri, 11 Mar 2022 23:22:22 +0200
Message-Id: <20220311212228.3918494-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd1c1b4a-b0fd-4435-fed2-08da03a56482
X-MS-TrafficTypeDiagnostic: PAXPR04MB8845:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8845A6F580E0B8A88FE548BFE00C9@PAXPR04MB8845.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZafM8Jw+L6E95u6DnAbdXx740Ul8SUS6/JRoIozZfSj8Uo0XkWnpXBP9/dTcJnIYi+LYun3PUN50B/+NCjAK4Nvls7nBhNIrc7RBdWpQ+1vxXyunqFFJ3KbJ70+C2PMGjCL8VQRIlNCcevVUMMIsaiS5oMmfhei5YM28TrmWqDXoeTZd2u7h2aXVci2FQlmVoOPH0Uiuii6Oob6AhX29Sci8bws6VbKGJJieOxUhunqN+J32ytg8lcjzE9GlJHsLMyMj64E8aBSCx6DK2/BzWu0aEZuZsy1zhLc0bAAiGmcvMyzlHlNsH6zo+q5mzbIskAEFV4pNapTywhGM32Z4CCnrjdra8fLiWvcuRPGjBWfsntxjRdWds/eV5pBC4LKugBBj9gRHaKKZvJ/r8KYw4c5qJG1UZ7WiTYi5cWTSuymITY/QMoX84mcFWKZLY46j9wf+a0kLmUvsb5v6ohwEgK1LQqS4qXPBzsv+I6WT4Y1Z+v8eWnT3U3MpzpIOV1hYarV9LCJpCT7y1nCYt2QNfbETbzhhT+J6/UNKVTB8oWc442fRsGEnI7qkP/D+4FDtW/tHUbdG9cUw/qR6hKA/QmqYW2mD2nvCdiSq4cI/J3zd79e60zmsGlze2pGJs9LwtswyCvPoRQwQOHzZlFq5eX4XNvHQSViiBEFaunAUqiuIFACWBr5MhfAMJ3sIe49rA06kIf2yO1wM7o0DZJ5A5O1cGwEW09llLe2jGGFPOBUq1IRNfzPD9XOW79koepMrTqk8R4OzPLUuZAzz5nUKY2M3zChnFScfv/BU2dvZAXmlAT14WJU8/o1l2NrP5YXaXYw6Ed1fVZxLaUOpVh14QXSG1Ur5ahSmBfzM4bb1vs5Yhbn0tPM/5O25CfkZM0M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(4326008)(66556008)(8676002)(66946007)(36756003)(316002)(54906003)(38350700002)(38100700002)(6666004)(6512007)(8936002)(26005)(186003)(508600001)(5660300002)(1076003)(7416002)(2616005)(6486002)(966005)(44832011)(2906002)(52116002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?js/6PpcJQClMXNZ6hwWwzOFJoN+ND1RQsTrByEP0XEDB4uOCV9+UruDFDoWS?=
 =?us-ascii?Q?iV4oz8V+9KLLgJsByAQ9HV6XZxBaDoVHFDyg1IWB7I9/vYl7xqfwqHeDIEDw?=
 =?us-ascii?Q?jRvOoVxUVXxvBZVW7PEOltN03b8oMDmAuLOExp9QGCnvqoKQubm5WVDSNKXt?=
 =?us-ascii?Q?befHxN4uSz6PQxxuXBUvpNYc1xcJnj1ahZMVelMwseD6Tks73Y4C78359Om4?=
 =?us-ascii?Q?O5fYklTm4IUX0HSOFgekBJb+Vp95wh8K0NAabAgpfpm2FpMXROdPGWrBMeCF?=
 =?us-ascii?Q?aBTAzlRqhH71p4R+I2YH6i3n1G8RLoCSR+chwei9mKfutcZf1vBG64VAkl74?=
 =?us-ascii?Q?/u+ckPaloS8Bjhjku05tBMwqEkNp7FA6Jic3v7VgMYEcY7HwSbbQEjdecoxK?=
 =?us-ascii?Q?VQ0yF892RLreI+7YMjgeoMHhBcxDaTGByBO/wC49COViRAPgWEXeDnTQHD8O?=
 =?us-ascii?Q?HgbANmPgOAtkgGKaei1UttNh9X7iUVW4knsQFG4fce/gABOde1DuenLXSh2z?=
 =?us-ascii?Q?PKJ4AwJa9ymBIiozFemY6byFrsvaJZAmvb0zmIad3ExL7ZCAiY5nhx02D9bL?=
 =?us-ascii?Q?8Xy2cxsa+mSYOXzeLPu+E3JNIhX5yzT36jgrNjmTomMnPVqebs8umXtq9xCq?=
 =?us-ascii?Q?Raile42MeydqtGrAR5aJYfg4yYvFAIe7FGul1B9CNBbNHHSPX8Otbn+6Xhqi?=
 =?us-ascii?Q?lIO0jFUXANNayz9U5T9PpgSvaphtjRuwl1lv99nP8xb3BWode63HgNGXSrVQ?=
 =?us-ascii?Q?D3k96CPz3Hft/77h3VJVFTneGfajUlGLHOz6g+Ph8thmmtmWRZclmjJ4AAr9?=
 =?us-ascii?Q?u1h67X3Mo7hoAbCY7/ClSevr9+o1uOViYseJLRJqM3wF7pwdffyTewyaUlFY?=
 =?us-ascii?Q?kHgJhLRWH4GqYzj68WHrIUeVYjTAVBb2Y6q7ZVLcUQKS1YlDYj/Hyrnt3YMO?=
 =?us-ascii?Q?G4kVfalCaT73LPSAtvI9l/g/JDsog4VId/39nCYX3hRyJPn+wU5RvwMsw6RV?=
 =?us-ascii?Q?zHKqJO3tjhr28yVf8xBg40VR7R3g8wUVMj2WxdyiiK0k3tXDKh4i6KG9D9sV?=
 =?us-ascii?Q?YYpuhpmwz4aGZMNLNUuRxivOKes8OHSzsUDK98vZXE+yVlzsnGHZ1UXwC1I5?=
 =?us-ascii?Q?tXusYBUSBYwaWmo7BFKI1zqT5UKfdjFHmuqH5Edy2glVcBMze1wRdIgOy0YI?=
 =?us-ascii?Q?E19MvD1h/xV5oWyogby3H+mG+kTS3q+NMJswMA0v/cc4okj2r2IZCifSXNq3?=
 =?us-ascii?Q?eyCvQCRNY+W76PBtgTc3oCWDDO6bQLfmmJFWRdxQFqYQ0KMBqhPJbNYCPz09?=
 =?us-ascii?Q?PxYkJN8jsBsYYtMq4DxAM1z7R3vnLE2TjfrA8sG5CbG+ATNcUE/739LGF1E6?=
 =?us-ascii?Q?NPzeGGxlN5u3ZrKYW+xLh3XSEdD/Wa4dFC0GxoiSwM9ZZxPOK/ZebXaCJyhT?=
 =?us-ascii?Q?EEFlYr6zKnBUWDEp6ulx/9NyfothbyRt2sqQyNNbN8/XHyIET2Rhhw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1c1b4a-b0fd-4435-fed2-08da03a56482
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:31.8558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/yKnvPLKSVW1mmLHh2eiPp3Xwu6ZLFzBLVXSOjTuVI+jeSYLXcYyHfAuttHZpwXJZdxAsrodK4f/FBSzpmbDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding for the Lynx 28G SerDes PHY driver used on
Layerscape based SoCs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
Changes in v2:
	- none
Changes in v3:
	- 2/8: fix 'make dt_binding_check' errors
Changes in v4:
	- 2/8: remove the lane DT nodes
Changes in v5:
	- 2/8: use phy as the name of the DT node in the example

.../devicetree/bindings/phy/fsl,lynx-28g.yaml | 40 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
new file mode 100644
index 000000000000..4d91e2f4f247
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/fsl,lynx-28g.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale Lynx 28G SerDes PHY binding
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - fsl,lynx-28g
+
+  reg:
+    maxItems: 1
+
+  "#phy-cells":
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      serdes_1: phy@1ea0000 {
+        compatible = "fsl,lynx-28g";
+        reg = <0x0 0x1ea0000 0x0 0x1e30>;
+        #phy-cells = <1>;
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 3e76c8cd8a3a..3aa185235a52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11340,6 +11340,7 @@ LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 F:	drivers/phy/freescale/phy-fsl-lynx-28g.c
 
 LYNX PCS MODULE
-- 
2.33.1

