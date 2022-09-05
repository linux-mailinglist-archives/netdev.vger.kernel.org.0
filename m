Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBE5AD745
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiIEQWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiIEQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:22:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2116.outbound.protection.outlook.com [40.107.102.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF7E5B077;
        Mon,  5 Sep 2022 09:21:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1FVmPjJ/sAro5JylIQUXKkN8eTdbnk+evz+ebbANord2MBlA2vb7sxaB2eAx8/LNZqpaQstz7h85Ggei3V7DefyhHN8ojbCl8F05qbVy440KJ8oOnQJ34qsoOrCJdOyVZQhTE2HKxqJ0WwC+D042KIyvkYCYDf817wZ96vYiXAeVhO0drTsZU+1SWo8jQoOXXWGg/Jpb9NcGNbzX3fAO/pak2ETdCs9f+NyKbP/Le2PdSqxV4hOr/nlKdUWZ2s6a6vZ2XZxQijdcmfVSX/K7Fx3k7sq6o3AJnA5Z/SsRPvKLPvMJRz+hMB0sWuPzHndMQvFd6oPa7M9NUUI4wPB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ugWM/t7mNaTvEKz3aMsWhD90NlTeDCnSdjabF2ck04=;
 b=UdiYEV2yfsEGavP1Nxr93yEexyTD7eOtzJLSUBNcFZnv9sPnsmx9xSfu1zCdgBe9IPqmN4IDYjv2xHwEf2tOmoUP3NnWQpRQ+iKBRfu8d/4TeIpybpK2Ny27v49D9fOWpARIHaVeREKfRe4HQnAMcm84UGxBzRNGxORStw+Sbz6Sn4iNasbsUFgqGWdzvS7y37mW+tPtUV6NkOLeljcepRBcEA5X+M79rKH+Xq6Zutt8QJNQymuO6WOddeN/eg7FsE0Q2DNKlAhRFDI9jewIu4PXbkFxDmjEJWuVYE83fiWu2FighRdxTUEj0hKx2get8R+8F1UyhZVDK3R5L94jBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ugWM/t7mNaTvEKz3aMsWhD90NlTeDCnSdjabF2ck04=;
 b=V5rYyjNaEMi4sTpTccdHKYceO1aH4ucf1X7NeQGDH1ZO344diDylLwmF3GWUWC5Ff6n9xKF2InjqEXvxhRBN+aABB3BH5IOUVr3/xHfnvrb9JThJPge3akCov5nY1b+k00CNZ0Ole2999oixc6UiB3k6YQjSUk0KJOOG20OxTQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com, Rob Herring <robh@kernel.org>
Subject: [RESEND PATCH v16 mfd 7/8] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Mon,  5 Sep 2022 09:21:31 -0700
Message-Id: <20220905162132.2943088-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c342be6f-6947-4521-cd6e-08da8f5abfa0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwFzavfRLdZFKsALKivFhOQC8Vdj3xamA5a+gd5XdFXmIhZm/shPQxveTtJsGsPV5FKu72FcwDqC2e3EwaW7jGSFg6o3Q2Fiak+cBZzYtbnxIjDvNc3/T7ESujuavX/wNkLFS0Pzmd6uu4dlSAYMoXRfJAm+nS3+oQO9fmKegnp2/KYHjuBwo9IX0WWW76Ao/cJ6bWiq2uNHJbs7gAkcaGHJ4HBOBySPU9gbUlvlVItavza81BdhpAz0rDNNn9kuEV2/zYo5afO7vttAPKeBhQTvR7ThdYAxuazBIogmkZC+m6zFa3jN7lMKRXfJVQZN9oiU1+ZgQNB8ToH40BU7dTunD0bPMfA3deko/A0l0Riz9U8bMn9pdH1L8XvFhv7kUY4MLEZkHvAqGZK/OwnCD/CZFSUPKEWdqjKHTh//OlrHJJPSwNX9Q+GNUVcDnK5fv8avNw42Mn0umAlvahRpY1Vo879o+kqcSFZKNMvtCemC6ZejsbKVGmd97m6+UhVzpEVpqVkkWeAE48hT1x8qmgz41LPENtPjd9zqgXZ0vBpGjMXhxLNah5xxqaNLrJA7UWeVnz+AXJ6F/uitj2xvY+9sGVzjyejRiiWRtm7wPb1EncqHv1jCsuqA2CzRx/6bXhqNHb/y93F8dVdCfVQTE1B1wyXthY62D5K/8XGxaqEzQuXBmEYmz0MyJm4cGplpw8PNIiqTg6mWoLLI7Bvy8PBy+JUC5O0dGKKJMXf4R1Uhk+ncLm0w/2IBlwM63VnK8tNcEV0BEGoExLBA+JUh798/SBKInRiJM7Ale8RE36Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(966005)(41300700001)(6666004)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nYwG7/gf6BgKDtvQ/lg6HI/Om4JocBOJo6isRL8y1sYDgK8XZSOhxKdiN4fl?=
 =?us-ascii?Q?0iAtHxLmLBMFh0+Qat2RHd3Sgp3BUgJqs77NEO2aEwZtxZzOGZ93h6sZh+0/?=
 =?us-ascii?Q?h/KBlAEPowV7jA/w870EZqgiDaldhDs4cVtKLl4UwdxqIO5GYvba687lze1y?=
 =?us-ascii?Q?/eXXVs1P301iNIrW2eMjlMXp029SLcEXiEOtnuguxhp3VIU8YwQnFGb/0UF8?=
 =?us-ascii?Q?vwpPOrrTmdaPKcs2RF7pStGXs7fQEadUDjXYNpqE+vxedih9HiFvQ6vM8QHU?=
 =?us-ascii?Q?IAbiUOYnM4roW9+PY0koKvVh2Zutp21FFxeMtHDTBejqXnJk74okDvZU47w6?=
 =?us-ascii?Q?x8bboBbGhvldsf38VDHuw1pCoXv2zrM0GQGVOMyeFecKE7oGcuZoVlIG/ZVo?=
 =?us-ascii?Q?lxSakFfNLjxlOdKwcm8QS+nFY3Q6JKn8azOp2Qx+4D2Rc0NqU5rtDHXyo9wK?=
 =?us-ascii?Q?zK4VwU9d8ByOD+vQjz64E/hPfkLCrOESEb2imD0ZRCmGf1xHdcLmfUZXI8gv?=
 =?us-ascii?Q?oktzP0RsPe6jQsOf4Vl1x1O77fpdmu80VEo8tku4IhxRr+skwmkqD6d96/0B?=
 =?us-ascii?Q?vP/5Bbr4fXp9zQFXPD4Je8L9djmUx9aWlrFfIfHFLTo/fZi9TzwYo5jQ4VET?=
 =?us-ascii?Q?LWBs0aNJo+6iJ1I/XCDE8d3r5y2MZm/0KvniY/wKkZpkzU2gMlIGjPxk5qFw?=
 =?us-ascii?Q?Cq0PelDXt4s7bvSrYDYMPnk9wiWCYZDArkfTayXMVYOlnbwuPvynLWPrXXCj?=
 =?us-ascii?Q?+WGjsC6iYJOLRTuG1SolEhQ9B0msva/T9k7F21+vjHKioh29sOUyuSHXtQzC?=
 =?us-ascii?Q?O3RH4ZrutnKig8gdGhIiVYCDXvUPsrVL+WiW3ABJRyycannrkG+gPP2nIRj8?=
 =?us-ascii?Q?BT9AQ7Avg6CQq4Eewli1A0q5HdXAj9rfBXU1bcDrlglzWd1uQX8FZnhAV8bK?=
 =?us-ascii?Q?AciCKGi3LwJe8Nn8uFtIY4wptlqDecsKh/gS7N6jJohmBFYlNwNglnxDIPy7?=
 =?us-ascii?Q?MnzLFgDwmHMgYT4utVPrdn3d6GaHPO74oH018uYMin2BcJGsb0O7sJN+jcTF?=
 =?us-ascii?Q?k54FaUUzefTetdD50GsmoXjqtmEIVyu1SfK3wU1lYf0lLl+LFSYmsPv17n46?=
 =?us-ascii?Q?hK6+1YFmMF9sxV/G6/PVCy9EO7WnxckmyufQZuMdnvwOGx9t3s8ccB7ir+rG?=
 =?us-ascii?Q?AJsabwTBI9EPjm7GGdefqO0EqhH8vvYBbWJM2AA2S58/0HsgdJdDNAH+nO2/?=
 =?us-ascii?Q?zXJw0a8AGwu2UmjHRDZaft19Fmc3pF/7TT6bODZCvUreMfoR0gAtcjzJxvqn?=
 =?us-ascii?Q?RAsRgHi2P4VPgW6KcLOX0nY5KulTWx3OtzUSjbHOIfVsYpDj5znZD1657r2o?=
 =?us-ascii?Q?TB8sjaI8UguV/jL2gm9K+bHLIcBgaTNAtKoY2ez1o2Ykrq0BQwgof2e95Y6U?=
 =?us-ascii?Q?BkE5qdab123LJaFHnor7OYQON1/s10/Nqd6zNjT7mJXNK+R/EW6ny8Hcmqid?=
 =?us-ascii?Q?VZMDu3K0McipXWF1I2CzsPH2JGu0Ndq/9racYYQfpRDNDZVtXygt+n+/beWQ?=
 =?us-ascii?Q?32zS6tRgKvuB9SViX+5cnrJ4jA9osqxU6EIic64wh2cl8yTJpJ2AJvLvw8kH?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c342be6f-6947-4521-cd6e-08da8f5abfa0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:55.2724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0w3oh/xXNNBEecXHvVaPmreE/l4iQ9T0KDH6hG3V2UA30BXwKZVGi97Wu0TiJnP5JKcAnCijXB0f/kj6Mur+UwZlO5bdGR4ajE2dTcGkF2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
VSC7512.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

(No changes since v14)

v14
    * Add Vladimir Reviewed tag

---
 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
new file mode 100644
index 000000000000..8bf45a5673a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -0,0 +1,160 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/mfd/mscc,ocelot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ocelot Externally-Controlled Ethernet Switch
+
+maintainers:
+  - Colin Foster <colin.foster@in-advantage.com>
+
+description: |
+  The Ocelot ethernet switch family contains chips that have an internal CPU
+  (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switches have
+  the option to be controlled externally, which is the purpose of this driver.
+
+  The switch family is a multi-port networking switch that supports many
+  interfaces. Additionally, the device can perform pin control, MDIO buses, and
+  external GPIO expanders.
+
+properties:
+  compatible:
+    enum:
+      - mscc,vsc7512
+
+  reg:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+  spi-max-frequency:
+    maxItems: 1
+
+patternProperties:
+  "^pinctrl@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/mscc,ocelot-pinctrl.yaml
+
+  "^gpio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/microchip,sparx5-sgpio.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-sgpio
+
+  "^mdio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/net/mscc,miim.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-miim
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
+  - spi-max-frequency
+
+additionalProperties: false
+
+examples:
+  - |
+    ocelot_clock: ocelot-clock {
+          compatible = "fixed-clock";
+          #clock-cells = <0>;
+          clock-frequency = <125000000>;
+      };
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        soc@0 {
+            compatible = "mscc,vsc7512";
+            spi-max-frequency = <2500000>;
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            mdio@7107009c {
+                compatible = "mscc,ocelot-miim";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x7107009c 0x24>;
+
+                sw_phy0: ethernet-phy@0 {
+                    reg = <0x0>;
+                };
+            };
+
+            mdio@710700c0 {
+                compatible = "mscc,ocelot-miim";
+                pinctrl-names = "default";
+                pinctrl-0 = <&miim1_pins>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x710700c0 0x24>;
+
+                sw_phy4: ethernet-phy@4 {
+                    reg = <0x4>;
+                };
+            };
+
+            gpio: pinctrl@71070034 {
+                compatible = "mscc,ocelot-pinctrl";
+                gpio-controller;
+                #gpio-cells = <2>;
+                gpio-ranges = <&gpio 0 0 22>;
+                reg = <0x71070034 0x6c>;
+
+                sgpio_pins: sgpio-pins {
+                    pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
+                    function = "sg0";
+                };
+
+                miim1_pins: miim1-pins {
+                    pins = "GPIO_14", "GPIO_15";
+                    function = "miim";
+                };
+            };
+
+            gpio@710700f8 {
+                compatible = "mscc,ocelot-sgpio";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                bus-frequency = <12500000>;
+                clocks = <&ocelot_clock>;
+                microchip,sgpio-port-ranges = <0 15>;
+                pinctrl-names = "default";
+                pinctrl-0 = <&sgpio_pins>;
+                reg = <0x710700f8 0x100>;
+
+                sgpio_in0: gpio@0 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <0>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+
+                sgpio_out1: gpio@1 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <1>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+            };
+        };
+    };
+
+...
+
diff --git a/MAINTAINERS b/MAINTAINERS
index e0732e9f9090..a5df3b0b9601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14744,6 +14744,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

