Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C1B4D37B0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiCIR30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbiCIR3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:15 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C52385677;
        Wed,  9 Mar 2022 09:28:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibPECsVUCTr/kXi9Y6I1IGfmVpikg7+ARDCIqVIhJ2RXTGNuH9tBoOiw4Js8Ura+ilRm9KyxbG4xF1tAEl/5rgU0S1UIy314Ky+PkMR0JKvMOQ+y10tGAnB34oHlugE+yi9uXXqX1rpmcVfkt2qtBOpMaImh9AV9M1rZdFa0PXoZ3HHWDwBDH1n6URL57ghlAfyeDEEmX3Z4BtoFbjDjPwCNKe+ktz2jiG8Zo6xQs7OW/bIHI5gT8DbMJ2vjCwxATq7QbCj52FNOcEU3KwE4FOdnacs6NaCeviKJUtjhD2yvT9qm81otRyxmluj9RgEtGUrMtxMNEmziPOByWN6epg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FucX9JaTRUg9FLv9x1Deve101OdcvTTWCjSRueZfDTQ=;
 b=FCssuogeOLH/sKNpVbcvOzVCNXM2OEAYhpKjzgFFa0zAsM1FDlQA3fp2Yq8Tv1ZzN9FHVpHbEO0xEjCbyeU+q098Fxf0RYfhcF/JZaasclaRJqQTOpiIQxq671uFXT1afFar5JXADBd8cBJMdzjoMIm48VcfnbX8qNgCIDiEh6eZUDvuUUs3TvJBXzFeKvCqHxnxtEZRpruuS44+69rj4BfJH4aibOMB1MxpL3tgRz06fTu73nhXHm23BdCaWbQ1CqC908YFU0nBBzCPLaYM2Yj5BswLNgd4yKMo6Fa0NLl/T/Fri2U53jKWxPvaWFj7Syx6gieURYBmM8YremGsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FucX9JaTRUg9FLv9x1Deve101OdcvTTWCjSRueZfDTQ=;
 b=gJSnbuGOjovjNT+UPXPCDg6KcEER/Rfbzuyb88+JQTAIcULvBWiGBgrUeJZrjtZOaoWm/MC4s2R5SnZkHpVCodP1PWQoYpTQFcGoP5GjIcpoPj1q1QNwl9ab3riUUEop+WWZrL6Vjm6rbhdhSGm2rt9YVdoHSaTcKX2mfBQQZlQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:08 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/8] dt-bindings: phy: add the "fsl,lynx-28g" compatible
Date:   Wed,  9 Mar 2022 19:27:42 +0200
Message-Id: <20220309172748.3460862-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c935750-eace-4061-3cb0-08da01f22d85
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB942211C96F351DD63B54D3B0E00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fvu32VT0HmqRQGvoJ24r/ARdQqV8psybu+7Zn5WGvcavRS023FxsxbyisFNrmNG7aQL9JiFjUu3Nmj2gJI4E/MMVd8NAdvaqgiBUNc2E6DCdeR583dpexkd2vgg6nd0ThQRhrlQe7la2kQSIypiSIVb2W2WRKm3b3tKKZdWVOT5iKzhbfSZM9YiP9vDW2KSb+1lMO0y/WcfsEp6XPMzl4wVo1qWAxSX7DZ+yZ+sZuGn8R6YjJ6Bn3O+30ZGr6Mmd5UXjWxp0f4j6rUIbhnD9JC+h7eH0t4ZeQPCHN29soiFOtZ0BqPYksLRREJgz+8l+4+i+xvMdq/CwjncFoU9V9I0sEdQ27rwTXNBLfwP1Z18ZeV41Ceza4XizzfBBWxqashEki1aJcHnbN0GYVAp6lY80++Qxkp8UgtmLGD+aDM1IYwTXiliUkTCrZUEP0vhtcjiWqjiKUeNdjj9UbcBaZoDRGMun8cOiuokWe+ytp3ET66mY1nrZ1Oedvab5zGz7tHE62l5RjvzxTgjHREbsivo7D+8ARKP2UnwNY6uwdSV3DqpUWGSxvYf4FEhmMT87TZisg5rS7i8WvIdnSYlajmJuHz8KEl0H/QpqxFzsSxg/NJ3f1lHW8wLBVF4a2cEDI5IIi0NO1MTCPu3wLyuwEQ5Bz4PMpt2EkMsI2gwlw0O9jlSitiUi1FXRBCtLOtOfSyBF/eS52erabxkNs6WFIhR+OP031Vrxlx+5xOFeaRycEZqWG9eIHvyDdLh21goHBQGJpuqmc0bsXox3aMgqbq23kHiRJXG7mY1ahx/igTMDfm2wRHecdmjW24SmxOqxEb2scWlmRRTjUlTZiodrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(966005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(8676002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rzh86WKoqczlG9PJKg2z1CRFQPWuiVe39OfXrg890mXpekDIhIVhxVW4MZCj?=
 =?us-ascii?Q?Yd+0UE38/+n6tPSrnTV960ImFtLyCmazIDDvgGEo5WsLF0l2tx2Hoe8YdBep?=
 =?us-ascii?Q?UlnZU+Wh0kJfmoO91ciaksfAmUzJDCiUWpHZOaRvSx19xjFf9PO7klDeIY7J?=
 =?us-ascii?Q?N6jJBY8o8E9daBgitGS7bH+93ln5mFfJbmH4RSY1TD6fGdG8MSpvG409DRxi?=
 =?us-ascii?Q?4VwOOmH6xY9nGqT7btkj/mQGXmwZxjKL/CjqGT0og/9wIcjDbaFvIQFFkqXs?=
 =?us-ascii?Q?OE4Dv3T0G1dwbyp6zrdKw5V/W+KdkvuH0rq6xufOYqKCwHzDL95j8oTKthCB?=
 =?us-ascii?Q?0Yx7X3ERHyYShLAsfy87C22ZXKggW2sk3Nf64GlFY9VvqB4nm6KntXQpKbcT?=
 =?us-ascii?Q?vCK64e5C1X6GqMFWVZ9Znk1Ac0oD0DVmk2GEb43smcJcxmPqJIkHEidYY0Cn?=
 =?us-ascii?Q?UB/3uhEotGFlYu1tpNQL6eKzuBMylr8l44w0SWhtumOVpes5QmHB/XOlvLdJ?=
 =?us-ascii?Q?ijp1/XEmT+fTStmUN2wNKWWi2rQo/uVfiVKflo/c3BKq7OwcziCcQ/M0b32a?=
 =?us-ascii?Q?0BKBSkfXes+hYlKjh+/hknYbE5W/tDA9Jyu68rMpq1TcL3zLTQRWKzhYaz/s?=
 =?us-ascii?Q?aSsUEkZBUrflP762mVU6w9s+V6pXS2NNG6c8O1mfABsidV+anrRRwGhx76Rc?=
 =?us-ascii?Q?sZrgWe82ylLMLd1iSeYw/opljoYrIq8VtSEXo59BTA/UJbd0awrhNapMeV4b?=
 =?us-ascii?Q?95EIXBr2uuEuGgHh5kXf+ueMV1Mip9i0Trb8nDZPbeiKkgoYj+5wz/vmIJE0?=
 =?us-ascii?Q?B+3516CHsNCFIPDOr99zAuq4kz9+BJdG9Zqa5VP53BwzKoti8fgUtZNw19+u?=
 =?us-ascii?Q?vQWvzlNsD85HlQ7UpTsNzU+QjVolPDtLyCS7JiMEsRezV2L0VXaD91ypeo21?=
 =?us-ascii?Q?gQjFePDmL9bBBe72mMsH6MVWQh7l2DE9GikQM0+4pe/7QDMj7eElw/oYkNLd?=
 =?us-ascii?Q?PMUoTIMPwYvZKxv0GieBIqfqf6We4MqzMNHZxwzFDh8ix5E0zGDCbMdqLHGX?=
 =?us-ascii?Q?obyK4FDI2K3lXDOfUX0bSQrHDHeA7L+YQ/5A8w26DVgnBaH2DEsQ4+HAnxhA?=
 =?us-ascii?Q?Mqpi0H6I4TIBg2dEKxg9y1Cb3N0nF5X9pMMitNKnhy6JJsnQHZ3zme1NQ0jn?=
 =?us-ascii?Q?5XZ6DxdyOK2Gix9n2F9WrPiSe4PbUlRX0UlAAIWQb8Sj1JNFYPFagkgTYKKg?=
 =?us-ascii?Q?3TcsAV6RBjoDKEAQyp1mlvfF8u2N624VHgWY0LejIA8cwQkSQuT/J3YH4/kE?=
 =?us-ascii?Q?PpsJKsFCU8ggJgvXKfuDWMPoGhvH9AVyUVg5uOkN7+rvsCLgANwp2nI/39hC?=
 =?us-ascii?Q?2T6rZ00fbYvMqTlNBVYjEDEOtv6IyvpU4z1fqJRujbxfMn6PanQjMglzWKuH?=
 =?us-ascii?Q?YkhE/ATeWGoHFaibPQZ3LsP8vWCzPJrY7mDxN2uTQfYg7pQNMtyeHMdqkCoE?=
 =?us-ascii?Q?XUh3Qpn8eTVJ1PYSt/0z323B3fGdXTpMPV/owCdiIvazqrdJGMJ6j9eFSH2J?=
 =?us-ascii?Q?5f+ZyQwf0CeqKKNZUgyG7ItQc1Kc3fT9W7Poht1aoBgDQGcDfWUp/O0dDHLy?=
 =?us-ascii?Q?GfW70oOQfJcYwTCuqVfmQ4I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c935750-eace-4061-3cb0-08da01f22d85
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:08.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDJduhZ5lI3lImqoQtuR5enT4V9L355y2s4arg/OanOUyGjgsBLImRDoi55V3N62ERYeVnhnAXeIHdJ1VqKgEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
driver on Layerscape based SoCs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 71 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 72 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
new file mode 100644
index 000000000000..03e7ba99301f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
@@ -0,0 +1,71 @@
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
+    const: 0
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
+    serdes_1: serdes_phy@1ea0000 {
+        compatible = "fsl,lynx-28g";
+        reg = <0x00 0x1ea0000 0x0 0x1e30>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        #phy-cells = <1>;
+
+        serdes1_lane_a: phy@0 {
+                reg = <0>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_b: phy@1 {
+                reg = <1>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_c: phy@2 {
+                reg = <2>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_d: phy@3 {
+                reg = <3>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_e: phy@4 {
+                reg = <4>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_f: phy@5 {
+                reg = <5>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_g: phy@6 {
+                reg = <6>;
+                #phy-cells = <0>;
+        };
+        serdes1_lane_h: phy@7 {
+                reg = <7>;
+                #phy-cells = <0>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index dd42305b050c..888d07ddc128 100644
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

