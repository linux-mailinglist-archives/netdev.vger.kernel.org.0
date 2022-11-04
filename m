Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F186195E5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiKDMJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiKDMJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:09:25 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974D52D763
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:09:19 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221104120918epoutp01ea02601f491a5eb0a4bbb9c9c4974b87~kYGcmWKIl2210022100epoutp01t
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:09:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221104120918epoutp01ea02601f491a5eb0a4bbb9c9c4974b87~kYGcmWKIl2210022100epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667563758;
        bh=F/wrWKfkCJidaaPNHLM74M5Wux6bKyD0bMDJLStV66g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhSQXyXhSX/ccbArx8z3FBMs38N9X/sERgr3ilyKst5w0m4RM+c8XyhRo0dxth9RN
         twZW0QFApXnr+YET9R3To88aGeT2PpfrlAB1q0pL9HANtVHvSlNqQjDX7mqhPVrWy+
         AeMBITB8W/NjfQy6tw1b0LBgqyZ5hzrJn9MIIPKU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221104120917epcas5p4f597114d3c6e3153ad489682bb554a54~kYGbuJwjr1627316273epcas5p4n;
        Fri,  4 Nov 2022 12:09:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3fYk6HZnz4x9Q9; Fri,  4 Nov
        2022 12:09:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.FA.56352.1E005636; Fri,  4 Nov 2022 21:09:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2~kX9l-Zkjv3225732257epcas5p2d;
        Fri,  4 Nov 2022 11:59:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221104115909epsmtrp2acc49ee7ecc0240ba7990a4c3ea51519~kX9l_bseC1557415574epsmtrp24;
        Fri,  4 Nov 2022 11:59:09 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-38-636500e1e0c2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.B5.18644.D8EF4636; Fri,  4 Nov 2022 20:59:09 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115906epsmtip2607fac1197dfad2641569a9cda057fe2~kX9izY3w62474124741epsmtip2K;
        Fri,  4 Nov 2022 11:59:06 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jayati Sahu <jayati.sahu@samsung.com>
Subject: [PATCH 4/4] arm64: dts: fsd: Add Ethernet support for PERIC Block
 of FSD SoC
Date:   Fri,  4 Nov 2022 17:35:17 +0530
Message-Id: <20221104120517.77980-5-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104120517.77980-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmpu5DhtRkg6eLZCx+vpzGaDHnfAuL
        xfwj51gtnh57xG5x5NQSJot7i96xWvS9eMhscWFbH6vFpsfXWC0u75rDZtF17Qmrxby/a1kt
        ji0Qs/h2+g2jxaKtX9gt/r/eymhx5MwLZovWvUfYLW6/WcfqIOyxZeVNJo+n/VvZPXbOusvu
        sWBTqcemVZ1sHneu7WHz2Lyk3uP9vqtsHn1bVjF6HNxn6PH0x15mjy37PzN6fN4kF8AblW2T
        kZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/SmkkJZYk4p
        UCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE74+Wv
        fawF97UrZl2ZzNzAuFa5i5GTQ0LARGLpm2NMXYxcHEICuxkl2u9MZ4dwPjFKPOw7xgzhfGaU
        WHLmCgtMy6QPPVCJXYwSl9q7WCCcViaJ/RNWglWxCehKtF77DDZYROA60KzJN8AGMws0MUuc
        XrqCDaRKWCBc4vXX+UwgNouAqsT29X/ZQWxeAVuJBz/fskPsk5dYveEA0D4ODk4BO4mVK6RB
        5kgIXOGQuNjbxgxR4yJx8Xk/lC0s8er4FqheKYnP7/ayQdjpEpuPbGaFsHMkOpqaoertJQ5c
        mcMCMp9ZQFNi/S59iLCsxNRT68BOYxbgk+j9/YQJIs4rsWMejK0msfhRJ5QtI7H20Seo8R4S
        LZPuskFCZSKjxJaVB5gnMMrNQlixgJFxFaNkakFxbnpqsWmBcV5qOTzekvNzNzGCE7OW9w7G
        Rw8+6B1iZOJgPMQowcGsJML7aVtyshBvSmJlVWpRfnxRaU5q8SFGU2D4TWSWEk3OB+aGvJJ4
        QxNLAxMzMzMTS2MzQyVx3sUztJKFBNITS1KzU1MLUotg+pg4OKUamBLkZulNDnzOzvFxrf1K
        hWnrs+P/K/yZ+qVFwOTMaU1efb2SaE3O1R3LMlgcVhaceCB8I3iC0VSlrqvBWqEKkvqyn2WV
        I0701R2STDJw9/bRvJPJzaxi0rRPmuuF4xP+P+na/rtu8WxblLJiy7de2Zcr+PsOF1lNF/ui
        1avSyq5d62df5vA6jPVwce0z0f70kPzvDFNvx/PmhXZNY6++u6lWYa+YwPQr89rmbw6w3fos
        dO/HUq3mCMVLHavn5khbTf5yQMHT9xs/+3WxWUby0f8KJrYst0t///+3uLSMrrBV1bZPusf3
        n3BgX2umvmWdzOu5bLEfb5eenKnK69fLKtd2oG6PPGfE65TeunolluKMREMt5qLiRAAZdT5P
        VQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvG7vv5RkgzdrNC1+vpzGaDHnfAuL
        xfwj51gtnh57xG5x5NQSJot7i96xWvS9eMhscWFbH6vFpsfXWC0u75rDZtF17Qmrxby/a1kt
        ji0Qs/h2+g2jxaKtX9gt/r/eymhx5MwLZovWvUfYLW6/WcfqIOyxZeVNJo+n/VvZPXbOusvu
        sWBTqcemVZ1sHneu7WHz2Lyk3uP9vqtsHn1bVjF6HNxn6PH0x15mjy37PzN6fN4kF8AbxWWT
        kpqTWZZapG+XwJXx8tc+1oL72hWzrkxmbmBcq9zFyMkhIWAiMelDD3MXIxeHkMAORomGK03s
        EAkZiZMPljBD2MISK/89B4sLCTQzSXxdJg1iswnoSrRe+8wE0iwi8JBR4vznTlYQh1mgi1ni
        VdcOsG5hgVCJnk2XwWwWAVWJ7ev/gk3iFbCVePDzLdQ2eYnVGw4A1XBwcArYSaxcIQ1iCgGV
        zJ2vMYGRbwEjwypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCo0dLawbhn1Qe9Q4xM
        HIyHGCU4mJVEeD9tS04W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoR
        TJaJg1OqgWndgv3lPzQLhGeEWM94LjdB/Qv77Mhdiz4/Pabauq3y5wOFtXt1VZ+qfd9454wE
        2+G/8SHRHx+JRh4yT+juiQ5w1G9/oLanqrbp4+HfwXI/loXrWVorNP0qqZbfKx0W5FArNv21
        YLnY6tchrRl8eZcNo9wcjBP8hLMc4p9eD/rns1vUoOC44BoV8cvN5gEcvSXv/kbNe9atwnf2
        scE3h9WMyqdnyqlrxDOcZd/Na+hao2mnrJVTvjEx7MvJ+U7XZ9vPkHIS/yN2pmJlmELpucWP
        6/4vYtoQk+p20u/P5oNH3usWWu140CHhL1a/lkX34+aFu3s2HC1245nKeHeqht//PRYmkUuz
        Z/pmOPXLK7EUZyQaajEXFScCAEYGT3MJAwAA
X-CMS-MailID: 20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP, one in
FSYS0 block and other in PERIC block.

Adds device tree node for Ethernet in PERIC Block and enables the same for
FSD platform.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts      |  9 ++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 56 +++++++++++++++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 58 ++++++++++++++++++++++
 3 files changed, 123 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 42bf25c680e2..328db875667a 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -39,6 +39,15 @@
 	};
 };
 
+&ethernet_1 {
+	status = "okay";
+
+	fixed-link {
+		speed=<1000>;
+		full-duplex;
+	};
+};
+
 &fin_pll {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
index 8c7e43085a2b..94ef5392ad9c 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -395,6 +395,62 @@
 		samsung,pin-pud = <FSD_PIN_PULL_UP>;
 		samsung,pin-drv = <FSD_PIN_DRV_LV1>;
 	};
+
+	eth1_tx_clk: eth1-tx-clk-pins {
+		samsung,pins = "gpf2-0";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_DOWN>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_tx_data: eth1-tx-data-pins {
+		samsung,pins = "gpf2-1", "gpf2-2", "gpf2-3", "gpf2-4";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_tx_ctrl: eth1-tx-ctrl-pins {
+		samsung,pins = "gpf2-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_phy_intr: eth1-phy-intr-pins {
+		samsung,pins = "gpf2-6";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	eth1_rx_clk: eth1-rx-clk-pins {
+		samsung,pins = "gpf3-0";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_rx_data: eth1-rx-data-pins {
+		samsung,pins = "gpf3-1", "gpf3-2", "gpf3-3", "gpf3-4";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_rx_ctrl: eth1-rx-ctrl-pins {
+		samsung,pins = "gpf3-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth1_mdio: eth1-mdio-pins {
+		samsung,pins = "gpf3-6", "gpf3-7";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
 };
 
 &pinctrl_pmu {
diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index 2495928b71dc..e63c1f8fa6ca 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -33,6 +33,7 @@
 		spi1 = &spi_1;
 		spi2 = &spi_2;
 		eth0 = &ethernet_0;
+		eth1 = &ethernet_1;
 	};
 
 	cpus {
@@ -898,6 +899,63 @@
 			status = "disabled";
 			phy-mode = "rgmii";
 		};
+
+		ethernet_1: ethernet@14300000 {
+			compatible = "tesla,dwc-qos-ethernet-4.21";
+			reg = <0x0 0x14300000 0x0 0x10000>;
+			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+			clocks =
+				/* ptp ref clock */
+				<&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_PTP_REF_I>,
+				/* aclk clocks */
+				<&clock_peric PERIC_EQOS_TOP_IPCLKPORT_ACLK_I>,
+				/* hclk clocks */
+				<&clock_peric PERIC_EQOS_TOP_IPCLKPORT_HCLK_I>,
+				/* rgmii clocks */
+				<&clock_peric PERIC_EQOS_TOP_IPCLKPORT_RGMII_CLK_I>,
+				/* rxi clocks */
+				<&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_RX_I>,
+				/* eqos d-bus clocks */
+				<&clock_peric PERIC_BUS_D_PERIC_IPCLKPORT_EQOSCLK>,
+				/* eqos p-bus clocks */
+				<&clock_peric PERIC_BUS_P_PERIC_IPCLKPORT_EQOSCLK>,
+				/* eqos peric clock mux */
+				<&clock_peric PERIC_EQOS_PHYRXCLK_MUX>,
+				/* eqos peric phy rxclock */
+				<&clock_peric PERIC_EQOS_PHYRXCLK>,
+				/* internal peric rgmii clk */
+				<&clock_peric PERIC_DOUT_RGMII_CLK>;
+			clock-names =
+				/* ptp ref clocks */
+				"ptp_ref",
+				/* aclk clocks */
+				"master_bus",
+				/* hclk clocks */
+				"slave_bus",
+				/* rgmii clk */
+				"tx",
+				/* rxi clocks */
+				"rx",
+				/* eqos dbus clocks */
+				"master2_bus",
+				/* eqos pbus clocks */
+				"slave2_bus",
+				/* rgmii clock mux */
+				"eqos_rxclk_mux",
+				/* rgmii phy rx clock */
+				"eqos_phyrxclk",
+				/* internal peric rgmii clk */
+				"dout_peric_rgmii_clk";
+			pinctrl-names = "default";
+			pinctrl-0 = <&eth1_tx_clk>, <&eth1_tx_data>, <&eth1_tx_ctrl>,
+				<&eth1_phy_intr>, <&eth1_rx_clk>, <&eth1_rx_data>,
+				<&eth1_rx_ctrl>, <&eth1_mdio>;
+			local-mac-address = [45 54 48 31 4d 43];
+			rx-clock-skew = <&sysreg_peric 0x10 0x0>;
+			iommus = <&smmu_peric 0x0 0x1>;
+			status = "disabled";
+			phy-mode = "rgmii";
+		};
 	};
 };
 
-- 
2.17.1

