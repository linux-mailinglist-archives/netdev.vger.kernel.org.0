Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CD9665641
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjAKIjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjAKIjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:39:33 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36824CE01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:39:31 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230111083929epoutp04cd9db01b2ddf0fad5c0ada9dde928ee3~5NGqw-Bso0440304403epoutp04i
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:39:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230111083929epoutp04cd9db01b2ddf0fad5c0ada9dde928ee3~5NGqw-Bso0440304403epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673426369;
        bh=ONhayONa6HwgnOTv3fqNiTJK2lTarAZHdeWEQ+flAxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lqg7aPJlVibtscgZxOUvGGwX232fxMRZ6vfT6zuxk60a3cwvLGK3lqUbJ5YA8/h6E
         c6Fp83ibErMgDyul0qFHndNUQqseU02ojMTkJ0LYzTB2I1dTILvUD8mYNMR84j+Z4G
         iZ++isydJWEJRAG/KtqZADh7FGKnQTp4VXiC1/Gk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230111083928epcas5p4ccaa913e2f24d06a17859f95c04a7be2~5NGqFjiJk2333923339epcas5p4-;
        Wed, 11 Jan 2023 08:39:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NsLhG6yfXz4x9Q5; Wed, 11 Jan
        2023 08:39:26 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.66.62806.EB57EB36; Wed, 11 Jan 2023 17:39:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230111075441epcas5p4f0b503484de61228e3ed71a4041cdd41~5Mfj8R1Yv1283912839epcas5p4y;
        Wed, 11 Jan 2023 07:54:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230111075441epsmtrp27e0a364a62dbf5da234f0faded0ccb1f~5Mfj6wCeT0511105111epsmtrp2O;
        Wed, 11 Jan 2023 07:54:41 +0000 (GMT)
X-AuditID: b6c32a4a-ea5fa7000000f556-04-63be75be963a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.44.10542.14B6EB36; Wed, 11 Jan 2023 16:54:41 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075439epsmtip1a8cc69f36db4e049171751bce716a3bb~5MfhrBTOo2452324523epsmtip1W;
        Wed, 11 Jan 2023 07:54:39 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH v2 1/4] dt-bindings: net: Add FSD EQoS device tree bindings
Date:   Wed, 11 Jan 2023 13:24:19 +0530
Message-Id: <20230111075422.107173-2-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230111075422.107173-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmpu6+0n3JBk/mWVj8fDmN0eLBvG1s
        FnPOt7BYzD9yjtXi6bFH7Bb3Fr1jteh78ZDZ4sK2PlaLy7vmsFnM+7uW1eLYAjGLb6ffMFos
        2vqF3eL/662MFg8/7GG3aN17hN3i9pt1rA6CHltW3mTyeNq/ld1j56y77B4LNpV6bFrVyeZx
        59oeNo/3+66yefRtWcXo8fTHXmaPLfs/M3p83iQXwB2VbZORmpiSWqSQmpecn5KZl26r5B0c
        7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JSSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4
        xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITuj7+4HpoI/yhVXWzayNDBukexi5OSQ
        EDCR2PVpF0sXIxeHkMBuRolJ588xQzifGCX+/33GBOF8ZpR4MukEE0zLqtZbUC27GCWeztgF
        1dLKJHH74UJGkCo2AV2J1mufwdpFBL4wSlxf08EO4jALnGOUWPeujw2kSljAW2LyxtMsIDaL
        gKpEx8eTYN28AnYSi+6eZIbYJy+xesMBMJtTwF7iz6NfYIMkBPZwSBy+ugCqyEVi4Y79bBC2
        sMSr41vYIWwpic/v9kLF0yU2H9nMCmHnSHQ0NUP12kscuDIH6AgOoOs0Jdbv0ocIy0pMPbUO
        7GdmAT6J3t9PoP7nldgxD8ZWk1j8qBPKlpFY++gT1HgPiU0/30DDaBKjxMuJjYwTGOVmIaxY
        wMi4ilEytaA4Nz212LTAKC+1HB5xyfm5mxjBaVfLawfjwwcf9A4xMnEwHmKU4GBWEuFdybkn
        WYg3JbGyKrUoP76oNCe1+BCjKTAAJzJLiSbnAxN/Xkm8oYmlgYmZmZmJpbGZoZI4b+rW+clC
        AumJJanZqakFqUUwfUwcnFINTPrLg9+3vCh/fSinUaHMXEgxYtlaCYsO9n9NrEUnFKTPfFXi
        mq22LOZ6TZrby1Irbo0/sY94pNP+arZdyQyqKQx35NDkmszZ3mHaycogUnjeZnf3xRj53KbM
        jyIzfuXpKYesf26/0+acxYlNUqVzutav4IydeIE/QidXaj7D5l3Nd9NVW+VO3Dje1KcUKZfK
        YiIewVSQOHeDZnDKl5Z1npufvjp1VqGtrZovfsX++ftXLjlm1+R0Pe9iS9KdB/InGAqjK3Rn
        XxC22nnyTv/G6qSriS6lJzdMODVxq9s5p6Vs95okNzYw1h8X5lh4faFOnt3ZJXPfS/9T8C+Q
        XyMW0L5oOptM9bt50YHSOTeUWIozEg21mIuKEwGDrxTARAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK5j9r5kg1/HTC1+vpzGaPFg3jY2
        iznnW1gs5h85x2rx9Ngjdot7i96xWvS9eMhscWFbH6vF5V1z2Czm/V3LanFsgZjFt9NvGC0W
        bf3CbvH/9VZGi4cf9rBbtO49wm5x+806VgdBjy0rbzJ5PO3fyu6xc9Zddo8Fm0o9Nq3qZPO4
        c20Pm8f7fVfZPPq2rGL0ePpjL7PHlv2fGT0+b5IL4I7isklJzcksSy3St0vgyui7+4Gp4I9y
        xdWWjSwNjFskuxg5OSQETCRWtd5i6WLk4hAS2MEocXx/NxNEQkbi5IMlzBC2sMTKf8/ZIYqa
        mSQmLbnBCJJgE9CVaL32GaxBRKCBSWL+7GwQm1ngCqPEkWcyILawgLfE5I2nWUBsFgFViY6P
        J8F6eQXsJBbdPQm1QF5i9YYDYDangL3En0e/2EFsIaCapr8fGScw8i1gZFjFKJlaUJybnlts
        WGCUl1quV5yYW1yal66XnJ+7iREcE1paOxj3rPqgd4iRiYPxEKMEB7OSCO9Kzj3JQrwpiZVV
        qUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDtzXI7H1845dykKFGx
        Sy0lFxoEN2xa3jzt38zIqlfLeFbfm73XYHt5r3PPxhVvmn/12TDK3345PdA22TjOsshcV1Lp
        4gN7/3N/zwi0eXY5t1xaez+Cg3da9L3+83kGwr5N8xZ4Pby9ULrk5MN70yTZF5QvXa/D5299
        tfUsv9NMmf+b9ZT1H5zSOrr1UtHXs6xBblzGHLwsGrdn9Tz6XqD/3iNI+0GPuYjkTMs7G3d/
        c963aGvnp0vv/5SVTJ0x4cJMj91/Wjd8++snlWyn7MytdZhhMsuiA1nPaib9N+7crhLx7bd9
        yNWTL51P3K9knDn3RsaixBjNhUZbHngpTzz1QXLOg4sPAybybTf/cdksTomlOCPRUIu5qDgR
        AH0bsgT4AgAA
X-CMS-MailID: 20230111075441epcas5p4f0b503484de61228e3ed71a4041cdd41
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111075441epcas5p4f0b503484de61228e3ed71a4041cdd41
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
        <CGME20230111075441epcas5p4f0b503484de61228e3ed71a4041cdd41@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add FSD Ethernet compatible in Synopsys dt-bindings document. Add FSD
Ethernet YAML schema to enable the DT validation.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../net/tesla,dwc-qos-ethernet-4.21.yaml      | 103 ++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2f909ffe2fe8..e8d53061fd35 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -89,6 +89,7 @@ properties:
         - snps,dwmac-5.10a
         - snps,dwxgmac
         - snps,dwxgmac-2.10
+        - tesla,dwc-qos-ethernet-4.21
 
   reg:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml b/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml
new file mode 100644
index 000000000000..d0dfc4a38d17
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/tesla,dwc-qos-ethernet-4.21.yaml
@@ -0,0 +1,103 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/tesla,dwc-qos-ethernet-4.21.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: FSD Ethernet Quality of Service Device Tree Bindings
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+maintainers:
+  - Sriranjani P <sriranjani.p@samsung.com>
+
+properties:
+  compatible:
+    const: tesla,dwc-qos-ethernet-4.21.yaml
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 4
+
+  clock-names:
+    minItems: 4
+    items:
+      - const: ptp_ref
+      - const: master_bus
+      - const: slave_bus
+      - const: tx
+      - const: rx
+      - const: master2_bus
+      - const: slave2_bus
+      - const: eqos_rxclk_mux
+      - const: eqos_phyrxclk
+      - const: dout_peric_rgmii_clk
+
+  rx-clock-skew:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+
+  iommus:
+    maxItems: 1
+
+  phy-mode:
+    $ref: ethernet-controller.yaml#/properties/phy-connection-type
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - rx-clock-skew
+  - iommus
+  - phy-mode
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/fsd-clk.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet_1: ethernet@14300000 {
+              compatible = "tesla,dwc-qos-ethernet-4.21";
+              reg = <0x0 0x14300000 0x0 0x10000>;
+              interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+              clocks =
+                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_PTP_REF_I>,
+                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_ACLK_I>,
+                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_HCLK_I>,
+                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_RGMII_CLK_I>,
+                       <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_RX_I>,
+                       <&clock_peric PERIC_BUS_D_PERIC_IPCLKPORT_EQOSCLK>,
+                       <&clock_peric PERIC_BUS_P_PERIC_IPCLKPORT_EQOSCLK>,
+                       <&clock_peric PERIC_EQOS_PHYRXCLK_MUX>,
+                       <&clock_peric PERIC_EQOS_PHYRXCLK>,
+                       <&clock_peric PERIC_DOUT_RGMII_CLK>;
+              clock-names =
+                            "ptp_ref",
+                            "master_bus",
+                            "slave_bus",
+                            "tx",
+                            "rx",
+                            "master2_bus",
+                            "slave2_bus",
+                            "eqos_rxclk_mux",
+                            "eqos_phyrxclk",
+                            "dout_peric_rgmii_clk";
+              pinctrl-names = "default";
+              pinctrl-0 = <&eth1_tx_clk>, <&eth1_tx_data>, <&eth1_tx_ctrl>,
+                          <&eth1_phy_intr>, <&eth1_rx_clk>, <&eth1_rx_data>,
+                          <&eth1_rx_ctrl>, <&eth1_mdio>;
+              rx-clock-skew = <&sysreg_peric 0x10 0x0>;
+              iommus = <&smmu_peric 0x0 0x1>;
+              phy-mode = "rgmii";
+    };
+
+...
-- 
2.17.1

