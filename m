Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECE0588704
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiHCFtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiHCFtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:49:01 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9356B58B56;
        Tue,  2 Aug 2022 22:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb5TPqb+tqFyrp2E8MKdgAj6JOcaVL/uonRROyUcTkVlRt/u49WLqWRUCiuGBdvpVlgv/VoZ9YUg8bW8Dydf1LgAKXOCSqhZYU353Q8G1/lpLwOnsIODQ89wP2z8pLqOy/J+O8wn5L5kiNvoOw3xOiqckW3Sz6Y4H1VzpdPdw4TohjVTV89FajHLMWTktlbKZZrk73M0MTePFCjNRk799+BrFgmPnEvExqRSA6DGrNASGz3i7x3u4XaAaezPyvFLeaTsefDSn9inqiWcmpoTEChH6qXQJ44DWZClUOqHshT6m2KCuExsCFFH/sXMCID2bfwtTehfj8s12NwXJx44aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//7Nv24w/7I33yqXFqyK8T5I7UxWaF0l+WTbSq0/CQA=;
 b=Kb5Z4WlMwzZyOTEU24G7QBQAI0FclRP4beWLsJU9hJDAx3sfQC3V9mGfZsqCPO3d03bBRSsq50h990PW+uStyOcSj+4pp3yyZZoA7X0vgsX/TuQXmdvIowySLhfjo+wDxkLKtlx3FUS4Hd8h0+qjosI0665AJTWaBDDHKaS9XYxiy67e4CBTrJVApu7SAbRkUgHYFEymaNpFIlf8skNCthhLUbl6wnHevfWmmnZ5xwfawghDF9uLt0XtcSATGS6OSi8qT6NEwECoxmRpgDleUyW7kIGPvYi/Drufe2DxzE2+3Q8UygFTDTwfjgwTLr1vJ8Xr/lj93NuUIP5q5c8l3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//7Nv24w/7I33yqXFqyK8T5I7UxWaF0l+WTbSq0/CQA=;
 b=zGW/nRKuYezIA91ByD7d7oldcRDLqVb8lyIownNDJ3bdTB646aL6vkXj3Tcv82Q9cKLuTSwsQcNldL/7HVkVDn5aMdzhGtAPIlVPkeKRGXSOYdt/I10fSaH6YPhGA1B8yhmHfYI1NXBo2D5S7c2RlTJc+UgKn+Ljo4BrBzEZD3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v15 mfd 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Tue,  2 Aug 2022 22:47:27 -0700
Message-Id: <20220803054728.1541104-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c66b5a7-3f1d-4ea5-a4af-08da7513b6c3
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhwMwKoZ9NM8/YY/Grq8p2qa9Fb/3UQ3m/tMlpaf19WIUPUkkEmZApdrXGOTT3ShIeHzjqUAqgjXQjJZbMVMU1ZmvFbJBMRJv83S9PqcUZ86TLMttkHmrKJlYbqd42r4VnH4kNkJ4nndjt1TmpuYcXaXRJpPW2gVXl42a1TR2oyNsrBvpld6XwMhhu2QFX0i/h2kyz9eu8BmcZcfQFGx1jid/b45sGBACRwLI5NXxTaaLB9becibg1HoE/XxTb96ZfKxxC0xYjr5nbjRmAQt6CkLtbWEvG0jBY5QKMGGdSftTkhQra5xvPI7ZnI5NwEYA6pHGHFWTG9n8E5La5VoRD3CSPsTFmTnh/t5ujl1ujAkYDLSePbIgwE4vC5QF/mWCi0CcI25p0Mk20lJ0ZyqoiOigjIhH6d4Wca4QXJlZcYOH7TcCbejF2cOcLP2F811Tg0kPw7+NOBZcB/xMgWzKzR3F9ptTlcMmSmR5QpFgBV+LjvGOceIqJuuy9TCGKWA6FQf0V2U8aCYjtlAH6bwWxEL4VojSK0IS51eqSdqBDYzxSAPn6bPEtUDLcFWY1JzSP8Vqw0X3hVToW9zBSzLuLFGwfdCEKV8sb30nVWGJK3rEPvl46d0uatEITY91/YDE7pQDRpCA0eVJ2DIYoYeGj0Mbzi3PjvhSOstTXh4YAErc+llYzYoDiKKlPpYH21ZbjUpZsUBKecM531swI40Dm9DmF+KdKTWtN7pnVl1wU4XB+gMUk07PbS2WnCHRLjbDt57V+KEbjOHPWldibBlMpY3ToE9katDgtNNdu6jlYUvKpvwUp5ddGpUbEo5L8G4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(966005)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8HgznvTmR1SP5MEfx0Xqw+AD93kHIwc026AFbFK5xaVke1wxNrsTdFPOwhn7?=
 =?us-ascii?Q?hNi40l00a2N73++46xRx3fUBfvzNAPf5BU6rEK3/c7ob79UusPrQ2Y1A3LQH?=
 =?us-ascii?Q?s/s4zTiATKo8G+LQm7x9wUnY+/NZVPA7k9oQviiOssIQZo2A5vF0CQlZXKeg?=
 =?us-ascii?Q?j92rkBOd8ZKH7J/F2Z3IyCkY99DJCTWmR9B0EQNOYWub7POK2wjF5SVovv0f?=
 =?us-ascii?Q?nY9vgSbo9pxBlqR1iyHNWL/ECSjjCkhsTrujLwKXxBdHA+E9p2pEHPi++9OS?=
 =?us-ascii?Q?AwI2iLvqS0uTlNK1GaY//X8cUgg3f+BkaIPuRKoU8jrFRQv3P9hh8fvsSWxw?=
 =?us-ascii?Q?7Zd+r7Lyp/DxxwiMG1iTOVzg7Hc3TnNtf1+NYwmGMcmHDyVkinHDlvQwyy7s?=
 =?us-ascii?Q?lsGREjcRQZTu0fqhfP4BkaFrynefoijv66rFBy8qfSXhijsnzHJc9BhR4lFP?=
 =?us-ascii?Q?pLcXlJACGyAydo/rrxOxpUP0XKWwdtVJ8B7RZffVC1WKUX6fFO2cJejqiqZZ?=
 =?us-ascii?Q?rsghKLT/JfXyvI1uY/F8KHJ5mhcm2WNRDDLJTbGK1R3wITcfr03SJIKr9xBF?=
 =?us-ascii?Q?k0kD8Sdzc+nZ8Y1E8Jk3oV6UKCFAeY+qE1XP6w8DoQkkV2ncmdyAxUYBXg4g?=
 =?us-ascii?Q?aElnSXto5WTsFM+6FLCvHfMs88+JtLEc3DtX9MvUIr6KDjCnySv0/geA7SZa?=
 =?us-ascii?Q?v+Ny01YEaW2FXZIXdc++XjJiUR6YAYmk6PZ562Xeb45qYMQex9Ika262AYF/?=
 =?us-ascii?Q?jlWe7KDw5W2/cUmls+59EMT2fJLpF/jIg7FR0A7rsS3SNQSwft6KeAPmWNl1?=
 =?us-ascii?Q?6xEQJ0s3oJ9mFGuWLcW8ke/EP6AeUeC/A9CSoZynedVwrOEmkOEJ9R6vPyYv?=
 =?us-ascii?Q?Im4mRORm1o5bl1cyo4R/1Ji5u/ln5bieE/BiAqqO19s0v++2Lp6GjJScohMB?=
 =?us-ascii?Q?gMLcqE7OAKXXPPiv0yHobIKAerSPNXVdMNRKU4N6IPmROw4SiyR0G+CCsoyX?=
 =?us-ascii?Q?A12yYAxs381nb7Ys1hVBIynY6xsVZqe6TCotNZixQXLHOGAdPaTJfMHsioIJ?=
 =?us-ascii?Q?txIA3yD6lIxfI1obVWGJR4gDiLogjYiqGAFE9b4HHSWuH+JYwrYPXDWSnXUa?=
 =?us-ascii?Q?8Ar5cq+xKPvo8Z6vZTbReV/Vgs0zfcWFz1BtxIWFRuj8wkS8Gw34DXCOW1pH?=
 =?us-ascii?Q?dA9Ppmip1vX/ZaXS4HL/uE3ZpN3jhVcf2lNd4TyKymAw93HNg6zogeLGsULw?=
 =?us-ascii?Q?hf3HvlFWjw+4LN+LnlLbyv9Dpha6uCftlGsABNQg0LFvRd6/+beuCtswvdAw?=
 =?us-ascii?Q?UdORLny3qGddA9sUQWUEztFUJPNge9HrnekejMvD90F5uSU4nEsZFkXQ22+V?=
 =?us-ascii?Q?6MEqSMLBerv0/JYXFlWa5auB535AQ8O/aKKWmuo3YGf0XkvF8X5NUR1DCKke?=
 =?us-ascii?Q?VfDZcq7X5Am1imxVdPR3+9FHeWUMSRTSCK9f2/mfuq9MxOrhM0EtAmIjA4qW?=
 =?us-ascii?Q?ztf+Jw33fjmes979rj2+2apeS0SteacxsASFTzTy1Hx1pSLXdWOufc3zZRH2?=
 =?us-ascii?Q?h8H9ZEjUyXF7CdlsJhUII/R6H23eMqnjbj+XJdl2jdS0t2FTkxHxGNOYT1FD?=
 =?us-ascii?Q?nrt3wYvJfQ3YgINTn29K1Mo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c66b5a7-3f1d-4ea5-a4af-08da7513b6c3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:55.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Su9IZyJ+ACoZV09kIxas6hN6J0FJHEuGzEjd3gHsoDvi7QvF9Km5Gk17rU8x9QxNxPX6UOvz6ZijjJQq8MvOMTAITDJkrco4GhH1zXPxWDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index f781caceeb38..5e798c42fa08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14470,6 +14470,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

