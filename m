Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8F55745A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiFWHrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiFWHrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:47:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD346C80;
        Thu, 23 Jun 2022 00:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIvB4K6pkKT4GeIdFs/bFHQNJ141b6Om2f9DaTjj+qEnuC1qI29alQvZ2TwVKZnwM7hvUX2Me0nsCEJ8/xDrnZTWYWuqW7Jrolcsso3jydH8CZZgYWf+QPYfehDjLmso1ITSnIxKzAD2TIwfNBpQqqtYZJBZW+M5Jb6a6ofEDQFpuFgA0rsltLo5C9yRlmXRSdsg+3fm+GnDkfVCuv2o15PtSY/zlpCCygYa40XR9CegRYl5xc94uKyHMm8u8UIU3uPLrOnQ+QHXM4XhFR+yQluVNUfU8jtFjcpfJxX/ApcsYZ70hdct/LTTMuibSejZ0uQB4nkIlECFe/h1lYmQtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yhk3hp7hjepb2xa+n2NzA4x4tKhYugOi3tiW/eNWHEw=;
 b=ZS7cKRjwmV5cubtBwrrShMYYonCb1anU46CRWdf7N+ukr1Xx8SRs0QHpC1642AOsgUaUK2b6GYAxMObTPU4d4XLRQmwr7aZCp+HWNMjY632XBy79VID9HE4xrMKL8bDqr8lsBJyEx3fGOOvvsIpjj738431ejuKZgPMsEgXk4zB/5AUWIAvvQsWMII5Ycb8z/7ORUTW6KnCOtya/SC5PwaaRQdCBzMhRIw9moVA8BEUuj/5WtNdkTfzbtSTbb51SZHAwVNd9U7KIO8xnI07ObtfQVxnK+yO5IQK88ask10VZPT0dvW1Kb3cArz2eNGlNB6UwVvPElYrRAmyybT/scg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yhk3hp7hjepb2xa+n2NzA4x4tKhYugOi3tiW/eNWHEw=;
 b=dZraAHjlNMweNpCdNVjceXB3BsDMm1HQcNXXGGAoHxEhGYSwgHOGrWxZeBATS7oMkks9V7VtPQfZuvVjVdZoUSZ1kx+AuIjW1+aAg+hNQzbLXOo/S1oAPZj3OJgizcNXh71PVK1VtIVmooKuNM6PmDOZbVCz43EC5LurTIpIRvd6eEluM7s995sZ+gtUci003j9LbIA8RQM+zfq/eFOlBP/ePoWCQWPByS/mmZj+BOlsqjckrRjmU6/eaTbJ3Uppy4vX7lmL0ZCs40ZQ3pe8GqmVcbO8OUthTLGWSQwcjCL93dA5Mow7bvBD/4Wp+EvKPsexH1fXhsiPFNOZS+GOxw==
Received: from DM5PR07CA0136.namprd07.prod.outlook.com (2603:10b6:3:13e::26)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 07:46:58 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::29) by DM5PR07CA0136.outlook.office365.com
 (2603:10b6:3:13e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Thu, 23 Jun 2022 07:46:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:46:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:46:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:55 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:52 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
Date:   Thu, 23 Jun 2022 13:16:11 +0530
Message-ID: <20220623074615.56418-5-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daafccdf-de69-4465-b360-08da54ec8cca
X-MS-TrafficTypeDiagnostic: BY5PR12MB3955:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB39557ECC7FE8B515B966E880AFB59@BY5PR12MB3955.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM7LZT/rMtmOrMcO6CxSLJ9bBt1ZlTfQ+2/wbCrxv4rKGrPfhSsdTFtqKbAPl7y3CWeyoUtNUSKJ5fMlnsmF8o6h5NIAsLgsnV9mNFZ7b1EAkjwxya2NVczl9PAQVtIhwTgHhPrg0PoUE3DIYpu7J4SmeNSRjEW3Y8rZqYSGU1TF6BP++JZ+sHUiu3tfQu63X4BNLhZtK7TZCTT4GVbY2biCU0v3KcU4XQVcjyWvcIIk9jWssjL2HLQ+R/zru5xghQVp9WDIIOrDyLZ6YqeRks73Nav25DrrjoM4GRHF1ybhzrp12R4+8b5nF5jkW1z79m74G+gKLcjDzJE4L1l4FuZslR426hVZ6CT4pJdQwcKOLLeLzQi4gB8NPElUgVOyjfX6NvdjfbFArg1nAc2WmSJIQ1/FNFlI4l9Qz1bw6uUVhxeJdE3g4b4ZdWtN3AFAPjRWa8lT53ZiNYBXuz5XVgkfMhUDYU6KEm7Gwl5kRrr8rUbT+DlwFKu8Ul7xGsfcQrm3ejTGvyD6hS372O8cx0+b4qdmEgbR6FyI1sL0hSfd5YZVGdqlnxaiAN6YTHQ+N2MiURNQ5c6nfl8HeL4OhZO3tJfS+4tiCSw1FjOfCHT4BzjfAcrIvOd+DHdLW6r5S1Au+FeQ5wuNWxNhmC22dHMzH8H2X3D5JyOmvcBR2rCFmZ8Bm91E04qbBvv1NTQbUNCqj6kYc0OUOdP7wkCbmKvuyyYfF1grZfXOaX6NrdgxkmM6mDj39tTI5GG4t3ivvS0T68NrCTqq2AE6jcz+WATG9aRZP7BJ9V2H3KcGSzHBNT2xERp3TbOQcBF5IkMDJ19C3womjFLHLv7ttO7Dh68A5Mkuv4cTCrKN5QEiSzM2sKehGkKFw6FoOk++ykeyZ8HsCEuHLWKbLd13X7Z05krD1R+995q/tv7lDX+Qqds=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(40470700004)(46966006)(966005)(110136005)(8936002)(316002)(26005)(4326008)(356005)(40480700001)(86362001)(41300700001)(478600001)(2906002)(5660300002)(8676002)(54906003)(36756003)(107886003)(70206006)(2616005)(70586007)(336012)(83380400001)(40460700003)(1076003)(186003)(47076005)(82310400005)(82740400003)(81166007)(36860700001)(7696005)(426003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:46:57.6362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daafccdf-de69-4465-b360-08da54ec8cca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device-tree binding documentation for the Tegra234 MGBE ethernet
controller.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 163 ++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
new file mode 100644
index 000000000000..d6db43e60ab8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -0,0 +1,163 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Tegra234 MGBE Device Tree Bindings
+
+maintainers:
+  - Thierry Reding <treding@nvidia.com>
+  - Jon Hunter <jonathanh@nvidia.com>
+
+properties:
+
+  compatible:
+    const: nvidia,tegra234-mgbe
+
+  reg:
+    minItems: 3
+    maxItems: 3
+
+  reg-names:
+    items:
+      - const: hypervisor
+      - const: mac
+      - const: xpcs
+
+  interrupts:
+    minItems: 1
+
+  interrupt-names:
+    items:
+      - const: common
+
+  clocks:
+    minItems: 12
+    maxItems: 12
+
+  clock-names:
+    minItems: 12
+    maxItems: 12
+    contains:
+      enum:
+        - mgbe
+        - mac
+        - mac-divider
+        - ptp-ref
+        - rx-input-m
+        - rx-input
+        - tx
+        - eee-pcs
+        - rx-pcs-input
+        - rx-pcs-m
+        - rx-pcs
+        - tx-pcs
+
+  resets:
+    minItems: 2
+    maxItems: 2
+
+  reset-names:
+    contains:
+      enum:
+        - mac
+        - pcs
+
+  interconnects:
+    items:
+      - description: memory read client
+      - description: memory write client
+
+  interconnect-names:
+    items:
+      - const: dma-mem # read
+      - const: write
+
+  iommus:
+    maxItems: 1
+
+  power-domains:
+    items:
+      - description: MGBE power-domain
+
+  phy-handle: true
+
+  phy-mode: true
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+    description:
+      Creates and registers an MDIO bus.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - power-domains
+  - phy-handle
+  - phy-mode
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/tegra234-clock.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/memory/tegra234-mc.h>
+    #include <dt-bindings/power/tegra234-powergate.h>
+    #include <dt-bindings/reset/tegra234-reset.h>
+
+    ethernet@6800000 {
+        compatible = "nvidia,tegra234-mgbe";
+        reg = <0x06800000 0x10000>,
+              <0x06810000 0x10000>,
+              <0x068a0000 0x10000>;
+        reg-names = "hypervisor", "mac", "xpcs";
+        interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "common";
+        clocks = <&bpmp TEGRA234_CLK_MGBE0_APP>,
+                 <&bpmp TEGRA234_CLK_MGBE0_MAC>,
+                 <&bpmp TEGRA234_CLK_MGBE0_MAC_DIVIDER>,
+                 <&bpmp TEGRA234_CLK_MGBE0_PTP_REF>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT_M>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT>,
+                 <&bpmp TEGRA234_CLK_MGBE0_TX>,
+                 <&bpmp TEGRA234_CLK_MGBE0_EEE_PCS>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_INPUT>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
+                 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
+        clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+                      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+                      "rx-pcs", "tx-pcs";
+        resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
+                 <&bpmp TEGRA234_RESET_MGBE0_PCS>;
+        reset-names = "mac", "pcs";
+        interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEARD &emc>,
+                        <&mc TEGRA234_MEMORY_CLIENT_MGBEAWR &emc>;
+        interconnect-names = "dma-mem", "write";
+        iommus = <&smmu_niso0 TEGRA234_SID_MGBE>;
+        power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEA>;
+
+        phy-handle = <&mgbe0_phy>;
+        phy-mode = "usxgmii";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            mgbe0_phy: phy@0 {
+                compatible = "ethernet-phy-ieee802.3-c45";
+                reg = <0x0>;
+
+                #phy-cells = <0>;
+            };
+        };
+    };
-- 
2.17.1

