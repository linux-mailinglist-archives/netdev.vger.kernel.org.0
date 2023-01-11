Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83C566564C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbjAKIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbjAKIkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:40:35 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17514DF7C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:39:54 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230111083952epoutp033ab3a41adfdf039d394b47bcf2346818~5NHAa7xPf2468324683epoutp03f
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:39:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230111083952epoutp033ab3a41adfdf039d394b47bcf2346818~5NHAa7xPf2468324683epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673426392;
        bh=GYUtz7RmzSMRjtnLPVcnYKzBv8JEBVMZmTiHNXrJ6do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEsTsQoT08D2X4z9mkjhcBi5N/JS7G9LpGVPGbxnbQviYEKU/6AqvdE6VHU4Pbbug
         kE6GzrBbnHEsQ9ewqetl6rYB/MVKYx+SLb+G/wGcnV0UvPAU1Z7BITnhvztvP1CXFV
         u7mxEUXxc1FRNnKUI0KfkjybP44yM3ybv3hXTVSQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230111083951epcas5p3156eb91e4bedf7987ef2792dbd61fc5b~5NG-osf2d2199521995epcas5p3C;
        Wed, 11 Jan 2023 08:39:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4NsLhk0RRdz4x9QC; Wed, 11 Jan
        2023 08:39:50 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.86.62806.5D57EB36; Wed, 11 Jan 2023 17:39:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075455epcas5p1951d1981f15d252e09281621ef5fbf15~5MfwFKw7t1496914969epcas5p17;
        Wed, 11 Jan 2023 07:54:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230111075454epsmtrp2ef56adee67b549e6d325771971c64f8f~5MfwCjB9g0511105111epsmtrp2f;
        Wed, 11 Jan 2023 07:54:54 +0000 (GMT)
X-AuditID: b6c32a4a-c43ff7000000f556-53-63be75d5142e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.44.10542.E4B6EB36; Wed, 11 Jan 2023 16:54:54 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075452epsmtip15228ef5deb24ba8a51b71278a4dd9a71~5Mftnm__l2673726737epsmtip1f;
        Wed, 11 Jan 2023 07:54:52 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        alim.akhtar@samsung.com, ravi.patel@samsung.com,
        Sriranjani P <sriranjani.p@samsung.com>,
        Jayati Sahu <jayati.sahu@samsung.com>
Subject: [PATCH v2 4/4] arm64: dts: fsd: Add Ethernet support for PERIC
 Block of FSD SoC
Date:   Wed, 11 Jan 2023 13:24:22 +0530
Message-Id: <20230111075422.107173-5-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230111075422.107173-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSbUxbVRjHPb3tbZkpuXQDziqyWtkQFqAdpbsY3swWdjNIRuIHDR/sLuVY
        GO1t7W1hI3HyqkCgEyeIBHmfrAhIaCnIy2CIbLJlLCKYBZxAJE4hg63gfJ8tF/Tb7/+c//M8
        5zznEWGSPlwqymYsyMzQejm+j+/6Miw0Ys56TavomlCQv/9cC8ilRhdONsyU8MmmyTsCcnVq
        RUhOTrfzyPutDwWk7cEyRt512QTk7FADTjb+3S0gp5oDyF9vrQOytX9LSD5d6wfk8uaIkCwd
        nRSSC+s9giQJ5bTf41Grl/qF1Bf13wup5j4r1ddZjlOL8yM4tXFtDqdszk5Arf42ilHOMTeg
        3H3Bac+m58RlIToTmWWI0RozsxldvDzlVc0JTYxaoYxQxpLH5TKGNqB4+cnUtIjkbL3nZXJZ
        Lq23ekJpNMvKoxLizEarBcmyjKwlXo5MmXqTyhTJ0gbWyugiGWR5WalQHIvxGM/mZA1ulAlM
        c4fPO3sbhAWg/FAF8BFBQgVrKwZxL0uIYQALRskKsM/DjwFcbHHwOOEG0D3eDPYyBuzdAu5g
        CMDtyrs4J0p5sGXGIfC6cCICls67d9IPEFsAftdVJvQKjNgGsOxmz45rP5EOu+paMC/zicOw
        bc3p6SESiYkEWLTFcO0Owc96x3csPkQi/Gvlj506kJgUwYrpeY8QesRJaH+bs++Hv9xwCjmW
        QvfDUZxjHXRMcneDhB6WFRVjHCfC8W8b+N6uGBEGPx+K4sLPw5rpHp6XMcIXVv35I4+Li+Fg
        4x4fgW0r5bscBLtXHu+Wp2Dl4pXdyX0A4FRnO/99EFz/f4tmADrBQWRiDTrExpiOMSjvv0/T
        Gg19YGd5w08PguWlzcgJwBOBCQBFmPyA2O4zopWIM+kL+chs1JitesROgBjP9Koxqb/W6Nl+
        xqJRqmIVKrVarYqNVivlgWLU36SVEDragnIQMiHzXh5P5CMt4J2qUmtl//BtRif62FG/tl1j
        e4n/Vm9Vpb/h1NVGm29I3oC9WFyTuvRNwK1K4hN0+lFyVChdlFLyTF5b4jQ6Wu23WSNt+6GO
        /6H7QcedsejAr3P16UVnzncu4L5L3apWTeBHjpxX3EcvPMnJUL5Wp6W7C193aVefvHvjumvm
        3v1z4cH0yG3p2QS/qOtdAwWXJIvFQRcdFy/Pjs0ePOEvutz7Dp0hiRkOCjUFBa49l+JX2UG9
        UP1GhoNRhs1/mpQ7nJodWhIGiq8uEmxyxnuolr25tb4WXXhb2XyuteN4Umahb+lXSQtd+bJ8
        Y0+1682QjRd/agrRBCS2P607UquLezSQLeezWbQyHDOz9L/c14NLRQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSnK5f9r5kg9UXzC1+vpzGaPFg3jY2
        iznnW1gs5h85x2rx9Ngjdosjp5YwWdxb9I7Vou/FQ2aLC9v6WC0u75rDZjHv71pWi2MLxCy+
        nX7DaLFo6xd2i/+vtzJaPPywh92ide8Rdovbb9axOgh5bFl5k8njaf9Wdo+ds+6yeyzYVOqx
        aVUnm8eda3vYPN7vu8rm0bdlFaPH0x97mT227P/M6PF5k1wAdxSXTUpqTmZZapG+XQJXxo73
        HawFV1UrtmyYw97A2CnfxcjJISFgIrF95VpWEFtIYAejxP41nhBxGYmTD5YwQ9jCEiv/PWfv
        YuQCqmlmkrjd8pMFJMEmoCvReu0zE4gtItDAJDF/djaIzSzwl1Fi7jptEFtYIELi966bYINY
        BFQlFr/ewtjFyMHBK2An0fQlD2K+vMTqDQfASjgF7CX+PPrFDnEPUMnfj4wTGPkWMDKsYpRM
        LSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjgwtrR2Me1Z90DvEyMTBeIhRgoNZSYR3Jeee
        ZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYykwPsS4L
        f2H5ePYvtwW1780Ud1YFPmh3v7Hs9PGkwNZdQnLzwuYGJoccPL9afmXZSl07lk4T31zrtszH
        f6QS2E/VPf0568KpJyaGD548kF/iPEerN1tWbJ7mlOMJPFc8df+tKLPgm7rz/7XVT2rlC+bc
        ZwqwZmNbsGXxgu/nNv0yiIt/zZek+itVxVr5o5/0wdnblhhPeFM+0U/ogWxzWVmkxdF9n/oD
        nq1gqdd9d7vwymyL8n4LjSv9v0v8zjGHcX6V8FzqzCx9dcoOaV+DOeeYbKPzwr5sPrzxnUDR
        kxl67ZqWcVM0FjSzzM3e4VvlfGpuIXNEX8Bh197MOZqv5BLNw00kzHy/nasIe7pUiaU4I9FQ
        i7moOBEAEw+DfPsCAAA=
X-CMS-MailID: 20230111075455epcas5p1951d1981f15d252e09281621ef5fbf15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111075455epcas5p1951d1981f15d252e09281621ef5fbf15
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
        <CGME20230111075455epcas5p1951d1981f15d252e09281621ef5fbf15@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP, one in
FSYS0 block and other in PERIC block.

Adds device tree node for Ethernet in PERIC Block and enables the same for
FSD platform.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts      |  9 ++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 56 ++++++++++++++++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 29 +++++++++++
 3 files changed, 94 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index ca0c1a28d562..2c0cbe775e04 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -39,6 +39,15 @@
 	};
 };
 
+&ethernet_1 {
+	status = "okay";
+
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
 &fin_pll {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
index 7ccc0738a149..c955bf159786 100644
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
index ade707cc646b..8807055807dd 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -33,6 +33,7 @@
 		spi1 = &spi_1;
 		spi2 = &spi_2;
 		eth0 = &ethernet_0;
+		eth1 = &ethernet_1;
 	};
 
 	cpus {
@@ -882,6 +883,34 @@
 			phy-mode = "rgmii";
 			status = "disabled";
 		};
+
+		ethernet_1: ethernet@14300000 {
+			compatible = "tesla,dwc-qos-ethernet-4.21";
+			reg = <0x0 0x14300000 0x0 0x10000>;
+			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_PTP_REF_I>,
+				 <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_ACLK_I>,
+				 <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_HCLK_I>,
+				 <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_RGMII_CLK_I>,
+				 <&clock_peric PERIC_EQOS_TOP_IPCLKPORT_CLK_RX_I>,
+				 <&clock_peric PERIC_BUS_D_PERIC_IPCLKPORT_EQOSCLK>,
+				 <&clock_peric PERIC_BUS_P_PERIC_IPCLKPORT_EQOSCLK>,
+				 <&clock_peric PERIC_EQOS_PHYRXCLK_MUX>,
+				 <&clock_peric PERIC_EQOS_PHYRXCLK>,
+				 <&clock_peric PERIC_DOUT_RGMII_CLK>;
+			clock-names = "ptp_ref", "master_bus", "slave_bus", "tx", "rx",
+				      "master2_bus", "slave2_bus", "eqos_rxclk_mux",
+				      "eqos_phyrxclk", "dout_peric_rgmii_clk";
+			pinctrl-names = "default";
+			pinctrl-0 = <&eth1_tx_clk>, <&eth1_tx_data>, <&eth1_tx_ctrl>,
+				    <&eth1_phy_intr>, <&eth1_rx_clk>, <&eth1_rx_data>,
+				    <&eth1_rx_ctrl>, <&eth1_mdio>;
+			local-mac-address = [00 00 00 00 00 00];
+			rx-clock-skew = <&sysreg_peric 0x10>;
+			iommus = <&smmu_peric 0x0 0x1>;
+			phy-mode = "rgmii";
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.17.1

