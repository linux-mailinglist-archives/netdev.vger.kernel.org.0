Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3186195DF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiKDMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiKDMIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:08:55 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A192D1F3
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:08:53 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221104120852epoutp0480b9591ee85e73e7fc3a66ce98399925~kYGEugBSF0512305123epoutp04a
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:08:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221104120852epoutp0480b9591ee85e73e7fc3a66ce98399925~kYGEugBSF0512305123epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667563732;
        bh=5EeNE8lf7xpmShtco5wFgIBJumjTcSZflJH1YkpwoXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7BAG03jT1tbUKoehlcaHZb6xiDDfXwsN22I1i8WUIyUY71QHEajsp6MBxFnVrmO3
         CG5ipKFt0j0PxhYLSz6UkdmBAgycrm0PrF3L4UKJIdMwCY+H1yubuxBeD7OJqekf90
         kBAUq1RpVaLSro55wKIovjLkaCV7UBelMY9atQxk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221104120851epcas5p261b0e6c8a4db5996c602a749de452cd6~kYGDoD95a0274902749epcas5p2A;
        Fri,  4 Nov 2022 12:08:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4N3fYD5kmVz4x9Q6; Fri,  4 Nov
        2022 12:08:48 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.57.01710.7C005636; Fri,  4 Nov 2022 21:08:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115902epcas5p209442971ba9f4cb001a933bda3c50b25~kX9fVtraV2154621546epcas5p2U;
        Fri,  4 Nov 2022 11:59:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221104115902epsmtrp25a60b1eb4238618d795f82e69e65fddd~kX9fUpgF81549915499epsmtrp2B;
        Fri,  4 Nov 2022 11:59:02 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-af-636500c78842
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.1D.14392.68EF4636; Fri,  4 Nov 2022 20:59:02 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115859epsmtip29d442538bcd0af376001989c62be6b81~kX9cwDlCl1901719017epsmtip2I;
        Fri,  4 Nov 2022 11:58:59 +0000 (GMT)
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
Subject: [PATCH 3/4] arm64: dts: fsd: Add Ethernet support for FSYS0 Block
 of FSD SoC
Date:   Fri,  4 Nov 2022 17:35:16 +0530
Message-Id: <20221104120517.77980-4-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104120517.77980-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTe0xTVxze6e1tL5iauyLuwJiwO2STBWwHlAOCI86Yiy4ZzmwuJEvXtXeF
        tLRNH9vckmnkJVVh6OaMI6yrHaMYHistE2cFKdNI1UnE4gvWVhgIDLBMMjMIo1zc/vu+7/f9
        zu9xziEwYRcvlijWGBm9RqameJHcDs+mV1IuP8PIRYcGMtGThycAqvutjIu+672Oo9FLQT7q
        7bNx0LB1GkfV4wEM3eioxpHjgQ9HN8/V8ZDZN4Kj+sVmHF2yrEfz3imArK6/+Ghp0gVQ79Vx
        DJW7e/no3lQLnhdFO+13OPRojYtPd54a4tMWh4l2NFXx6Pu+8zy63bafnrlwi0dXO5sAffGC
        mB79243Rzq45QM85NhQIClU5RYxMwegTGI1cqyjWKHOpXXukb0gzJCJxijgLZVIJGlkJk0tt
        f7MgZUexenlMKuFjmdq0LBXIDAZq89YcvdZkZBKKtAZjLsXoFGpdui7VICsxmDTKVA1jzBaL
        RK9lLBs/UBVVfGvl6gaSPr0yWY0dAN54MyAISKbD8zOxZhBJCMlfAOwr+xNnSQjAh1NeLkvm
        Aby5WIeZQcRKxsSD0tWAG8DuYzbAknIONNvH8bCLR6bAct8cJxxYRw4CGDh+mx8mGHkQg94f
        GnlhVxS5FzYcCRchCC65Edbejw/LAjIX9t8a4rLl4uGZtm4sbIkgt0J74/PhYyB5m4CzE7ZV
        z3a4uGTHWRwFJy47+SyOhXPTbh6LlbC9t33Vo4aHDpaujvM67B6oW2kBIzfB1nObWfkF+HVf
        CyeMMXItPPrPCIfVBfBs/VOcBE8Hq1ZxHGwOhnB2pzT0D6exO6kFsK6+FfsSbDj1fwULAE0g
        htEZSpSMIUMn1jCf/Hdpcm2JA6y85OT8s2DIP5vaAzgE6AGQwKh1glCHXC4UKGT7PmP0Wqne
        pGYMPSBjeXu1WGy0XLv8FTRGqTg9S5QukUjSs9IkYuo5wemTyXIhqZQZGRXD6Bj90zwOERF7
        gNPSkv+sSv0N5Wr7w1RpiahaEObMj3i4V+qPe0JTc7usLzt/jldH9/lj7DZiTZfP/O7k6KOd
        0oW+1jVHMHVSIDE4uBRQyhP9ghP2awNpjd+3q2Z/rUGOsruWfljj+eJkw5DFr/68IyRVcts6
        sxscuoqm6Rh+8PravHs7aeHo4Y9mCnf74kQ/ZTV5pyoiegbdPwoqQ7a0LZ7ETGlQOSYZ8/Cz
        6ILO9x/R6+VF/e858756aziRQ2x57K3q6Wwe046NIK52PqBTWPcfzt6xe5vC/WRb2TsXrx1d
        2BtZWbZnccGV+rb4asnju4V35kvzWxnXh9HYq2demvk97sbwix0b91FcQ5FMnIzpDbJ/ATdI
        sZ9SBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvG7bv5Rkg78bZS1+vpzGaDHnfAuL
        xfwj51gtnh57xG5x5NQSJot7i96xWvS9eMhscWFbH6vFpsfXWC0u75rDZtF17Qmrxby/a1kt
        ji0Qs/h2+g2jxaKtX9gt/r/eymhx5MwLZovWvUfYLW6/WcfqIOyxZeVNJo+n/VvZPXbOusvu
        sWBTqcemVZ1sHneu7WHz2Lyk3uP9vqtsHn1bVjF6HNxn6PH0x15mjy37PzN6fN4kF8AbxWWT
        kpqTWZZapG+XwJXRNnsRS8EVtYqTr/uYGxhPy3cxcnJICJhIvHrczNLFyMUhJLCbUeL2jH5W
        iISMxMkHS5ghbGGJlf+es0MUNTNJ9E0+yQiSYBPQlWi99pkJJCEi8JBR4vznTlYQh1mgi1ni
        VdcOsHZhgVCJnq+/2boYOThYBFQlJt4BW80rYCtx8epdFogN8hKrNxxgBinhFLCTWLlCGsQU
        AiqZO19jAiPfAkaGVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwVGjpbmDcfuqD3qH
        GJk4GA8xSnAwK4nwftqWnCzEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC
        1CKYLBMHp1QDk+Xqy0dFljwNkTRUkNNJrgy6bd170MMqYPnX326xm4yc+Iuf7O/Z+sHs6bOn
        SVuP3j6VsPldkHzZ0o/B87J+TpE8c11r2XdfKdeO5xdqtB7tPSb98rLh45MWnheqVXhK9pRn
        Mq/c9WWtwLIYzw83M4xi5sRdDN/myJ1n98aI4fnsNeE/TiXzTBbYuKqUZ0UUn654wa5PJzNt
        cme96NztqPTsf5b1jdBim5t5dzqkJ21U3VJ7oe0U30dHhneG6dNv6tSlKTIyW4QkOKfuk/z/
        wnad+Y+S1Vcaj2cE/phzQNCqbnPWxZbSM+zbE2LZ3impq9seyCzZ0mOkKvD2ShCb3w/JNYdY
        VX3XssfIqd/PVmIpzkg01GIuKk4EAO9c1vQJAwAA
X-CMS-MailID: 20221104115902epcas5p209442971ba9f4cb001a933bda3c50b25
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115902epcas5p209442971ba9f4cb001a933bda3c50b25
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115902epcas5p209442971ba9f4cb001a933bda3c50b25@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FSD SoC contains two instances of Synopsys DWC QoS Ethernet IP, one
in FSYS0 block and other in PERIC block.

Adds device tree node for Ethernet in FSYS0 Block and enables the same for
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
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 56 ++++++++++++++++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 38 +++++++++++++++
 3 files changed, 103 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 1db6ddf03f01..42bf25c680e2 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -30,6 +30,15 @@
 	};
 };
 
+&ethernet_0 {
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
index d0abb9aa0e9e..8c7e43085a2b 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -64,6 +64,62 @@
 		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
 		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
 	};
+
+	eth0_tx_clk: eth0-tx-clk-pins {
+		samsung,pins = "gpf0-0";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_DOWN>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_tx_data: eth0-tx-data-pins {
+		samsung,pins = "gpf0-1", "gpf0-2", "gpf0-3", "gpf0-4";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_tx_ctrl: eth0-tx-ctrl-pins {
+		samsung,pins = "gpf0-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_phy_intr: eth0-phy-intr-pins {
+		samsung,pins = "gpf0-6";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	eth0_rx_clk: eth0-rx-clk-pins {
+		samsung,pins = "gpf1-0";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_rx_data: eth0-rx-data-pins {
+		samsung,pins = "gpf1-1", "gpf1-2", "gpf1-3", "gpf1-4";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_rx_ctrl: eth0-rx-ctrl-pins {
+		samsung,pins = "gpf1-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV6>;
+	};
+
+	eth0_mdio: eth0-mdio-pins {
+		samsung,pins = "gpf1-6", "gpf1-7";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
 };
 
 &pinctrl_peric {
diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index f35bc5a288c2..2495928b71dc 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -32,6 +32,7 @@
 		spi0 = &spi_0;
 		spi1 = &spi_1;
 		spi2 = &spi_2;
+		eth0 = &ethernet_0;
 	};
 
 	cpus {
@@ -860,6 +861,43 @@
 			clocks = <&clock_fsys0 UFS0_MPHY_REFCLK_IXTAL26>;
 			clock-names = "ref_clk";
 		};
+
+		ethernet_0: ethernet@15300000 {
+			compatible = "tesla,dwc-qos-ethernet-4.21";
+			reg = <0x0 0x15300000 0x0 0x10000>;
+			interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+			clocks =
+				/* ptp ref clock */
+				<&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_CLK_PTP_REF_I>,
+				/* aclk clocks */
+				<&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_ACLK_I>,
+				/* hclk clocks */
+				<&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_HCLK_I>,
+				/* rgmii clocks */
+				<&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_RGMII_CLK_I>,
+				/* rxi clocks */
+				<&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_CLK_RX_I>;
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
+				"rx";
+			pinctrl-names = "default";
+			pinctrl-0 = <&eth0_tx_clk>, <&eth0_tx_data>, <&eth0_tx_ctrl>,
+				<&eth0_phy_intr>, <&eth0_rx_clk>, <&eth0_rx_data>,
+				<&eth0_rx_ctrl>, <&eth0_mdio>;
+			local-mac-address = [45 54 48 30 4d 43];
+			rx-clock-skew = <&sysreg_fsys0 0x0 0x2>;
+			iommus = <&smmu_fsys0 0x0 0x1>;
+			status = "disabled";
+			phy-mode = "rgmii";
+		};
 	};
 };
 
-- 
2.17.1

