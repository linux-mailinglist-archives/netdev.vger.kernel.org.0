Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3568567C79
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiGFDNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiGFDNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F36730D;
        Tue,  5 Jul 2022 20:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdmCbJHeg3JBVh+XnJ0inZS3HEmqQAN7pq+7Mi9U+w+g9OLc3CJQJ6L/hKXI4lUSiNkD4tL4mVeNY/zJJCVfZJ36Lm+SibyTBLnyCYEAp+7eUEcTryBjn8iFOFDaev6ZenEKBkuD/UhEpFFhDpu/PrHZSiMRzUCmWpohD9znREsU1Hr+ERI2wth3NeJsYnMqyJN662sCZ2LAxUBMiqP/3jkP8ULtoyKUTYeGLaSdVkaKRg6JGCLzKmqJvri/tJ3l4sah2Gbr9ma41HAz0gC26galO89ZxsXRZywaa1jJR7+zvtzoUh8FTWz8z/LL26Sb1MAEFzt2DgprSfierAT1Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMLAsWXBl5u7qbJFvye/YDY//OIzhK+nPfyKUm5Z2zU=;
 b=P6+VsoxWdjrGAK5FtlNfMghuPbBRmQ4I0HJJerO3wcWnzB45RUY7Pev5X9KRPhQuTRIkAJJAapxyEYJ/Rj+iqI7H141lf0V1+SzDaE5dgWJaigo5gQsNJDGlolePioEFIDhlEmDsA5Pd7/zr4erXPUmn7PmpSli9WZQlpCopmxuEgIUEuZjF3onc5ihZDK4lGdZ3CsxWV5xi0cq3kT5J+ymWywe7Uvl1DHcoLLTVhgpLoJLK+DbfrlMjSO7V9dbajpIUy6nRM3w9RnrZHGSIVX/idQ7SIirHO5pahS8yG+lRd42Hi6X5erLaFeeSHQgno+YNm39RkaH1JAUQF+hCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMLAsWXBl5u7qbJFvye/YDY//OIzhK+nPfyKUm5Z2zU=;
 b=Z4Ay68NDD7JGUA/4RBx1oScdrClJmrP1zSpKkpdWDKv0yLDor2lBIxGEjgaq+8YZr2oMfNsl/8IDPPd+6rA0x3Jw26EirHa0oPYFcx11FZkTb5U6YE/k7+HPks7Jntx1YOlpvdyA+WZfacvJentWyReCHm2RoqV/UlPG4I69WOpC8/peZPy9djJb7pFO1xWPfkU5KJ6OBuU9mWODUTK2Y//QYSb5DxzxPrNokC8gi7Ps/gtLr/HL0PeM8ieVxSLcnmdZV4xmISEV3yimuA41A/SVI2ufs7s1uSb+FCMQZmIy2u6l/uzJjWhNh+QNctwcfALDrfj2gXtQ7mlEVydHKQ==
Received: from MWHPR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:301:4b::24) by BN7PR12MB2739.namprd12.prod.outlook.com
 (2603:10b6:408:31::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 03:13:36 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::3e) by MWHPR1401CA0014.outlook.office365.com
 (2603:10b6:301:4b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:35 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:34 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:31 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 5/9] dt-bindings: net: Add Tegra234 MGBE
Date:   Wed, 6 Jul 2022 08:42:55 +0530
Message-ID: <20220706031259.53746-6-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 072f0760-7c02-4a49-da3b-08da5efd83da
X-MS-TrafficTypeDiagnostic: BN7PR12MB2739:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3btshzxs89eUJvGZSZcHTraMo27ZQaz/mZerP+R+dGPAszMlmFUvQwhmtDqf?=
 =?us-ascii?Q?1yiUk/wmig/vUjoj9ppHi3EBS37gjxxzWsPzyBIDNdQ5pfWWBG4+13xKOqdt?=
 =?us-ascii?Q?FbdwSyz3fOAFuvShhobD6V5prFO1t2CMlqiaNZAVYxF6wuD6oe5KKG/b+D5B?=
 =?us-ascii?Q?lQL7b9XzZV+YUIozj0Hn+OrAPY45zVFXOVbpMr95VV8P48Wov5qwKeF2eTN3?=
 =?us-ascii?Q?CiSyCzlrGz72W65nob/tzygaVKILXJ/i3RgnQwGK3CBu1uYnGsfckJhmS9tr?=
 =?us-ascii?Q?1fsxpb8esswRoTCK82GbWjimHxvI/0fTgyKrlMQjdLQ7DzwZOUDBB96pbFIu?=
 =?us-ascii?Q?l+PU6D1Ozb0EjYcKLLowJFGvBcrCO15lwN6tuzu2gWoSSXv2ohKC3LKJllEU?=
 =?us-ascii?Q?0tHe8KTjIAHJvlwvvooOd6rJ7wHBrAvgCrinfu4HAp1cHpfKRrvfvXxBq23b?=
 =?us-ascii?Q?8sd0UPejA8IFSgGQUVexiXr2ix/cZhC6FZ0xQkeFgnmYTCBtinVmtp734C/M?=
 =?us-ascii?Q?CsyRtOHQNX9VOnz351zmElsPtXhN3AztVKq/MzJd8fNi42/OMN+apG0XkItm?=
 =?us-ascii?Q?hJYDy0+yV94pat32Squv65XrerdMFwSq+b2Y+ROcVoAyHVc0xHP6TToKfqZ7?=
 =?us-ascii?Q?e5axFsu7bqCTTNeKfvQy3G6KWzs4mhCNzmQMXSK9p6oSQIlJGb7ORvzmYwVQ?=
 =?us-ascii?Q?XedJTRGoc5wGDY9POAtCsA4t3fducKE7jmaXHIrHABxklAXItCQ8xLRwhS36?=
 =?us-ascii?Q?/gfVgbqeGLo0EnVoqo8JxpDcNcatT6aqXJomgG+mtLcrfllBWLvv/vwQS9Re?=
 =?us-ascii?Q?EAGbmAoRlEZlV4cjanKqqOOjTiueGxSYBlqQZDr5qI+4ZskgJR+K2KIH2Vao?=
 =?us-ascii?Q?mEWa9O0rJl2I2IZuyVu4Xhn32QKOFlsoloP+wXR5j9pPmoslqpc/xXHMtqWP?=
 =?us-ascii?Q?cS0ebs8tyTmwL8QsA886i+Fcv9fJYFre2kPVdprHAMQ=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(40470700004)(2906002)(966005)(478600001)(7696005)(54906003)(26005)(316002)(110136005)(107886003)(8936002)(7416002)(86362001)(1076003)(2616005)(70586007)(5660300002)(70206006)(36756003)(8676002)(4326008)(83380400001)(336012)(82740400003)(81166007)(36860700001)(82310400005)(186003)(426003)(47076005)(41300700001)(6666004)(40460700003)(40480700001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:35.7147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 072f0760-7c02-4a49-da3b-08da5efd83da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2739
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 167 ++++++++++++++++++
 1 file changed, 167 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
new file mode 100644
index 000000000000..1a45cd374b19
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -0,0 +1,167 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
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
+  phy-mode:
+    contains:
+      enum:
+        - uxgmii
+        - 10gbase-kr
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

