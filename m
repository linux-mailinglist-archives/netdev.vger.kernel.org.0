Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2B9665646
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbjAKIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjAKIjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:39:47 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC01CE01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:39:45 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230111083944epoutp0364a7b650f11e2302502698f8b30a50e7~5NG4pvrqe2504525045epoutp03E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:39:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230111083944epoutp0364a7b650f11e2302502698f8b30a50e7~5NG4pvrqe2504525045epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1673426384;
        bh=f9smmLCOqFE2KCf2+DJ62v325XYkLVMURMdq+eNi7vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWYf646F7jq2UZqcvh53E9JylVuOuvYs53lr7Sqb0SDxAC+zMJHobqcpaSfEJHhVa
         5J9lMi6JTRLcbycXsvKI2Hh5hbsN5dqcXYslyOclYImLijtWxERazualbTmEBuL37i
         HzivQnyi2a9Y2UWkIfnZ/ftsL6dYZl1Gh1fhzYZs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230111083943epcas5p3cc19051f43cd1a0374434939f13762e1~5NG4B6MTO1517015170epcas5p38;
        Wed, 11 Jan 2023 08:39:43 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NsLhY64Fvz4x9Q1; Wed, 11 Jan
        2023 08:39:41 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.86.62806.DC57EB36; Wed, 11 Jan 2023 17:39:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230111075450epcas5p3f13b94bfeaa66d386aa51f87ca4ec5bf~5MfsQId9t1265312653epcas5p3Q;
        Wed, 11 Jan 2023 07:54:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230111075450epsmtrp1af1a853510c08fb2cd9c8116eb933f43~5MfsN_Nt32456324563epsmtrp1l;
        Wed, 11 Jan 2023 07:54:50 +0000 (GMT)
X-AuditID: b6c32a4a-ea5fa7000000f556-3e-63be75cd9135
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.44.10542.A4B6EB36; Wed, 11 Jan 2023 16:54:50 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230111075448epsmtip1f775f424c05e85603964146cdbd332c8~5Mfp56O2Y2673726737epsmtip1e;
        Wed, 11 Jan 2023 07:54:48 +0000 (GMT)
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
Subject: [PATCH v2 3/4] arm64: dts: fsd: Add Ethernet support for FSYS0
 Block of FSD SoC
Date:   Wed, 11 Jan 2023 13:24:21 +0530
Message-Id: <20230111075422.107173-4-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230111075422.107173-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe0xTVxzHc+5tbwusy11RdySi7DIXYQNaV9iBgLiMLHcTtYnbzGBJuSsn
        hdHX+nC6yUI2YIi8F5eIrBLAZDBAU1pEHsoAkYCWPbSiTuQ5YBpXad10G24tLdt/n9/vfH/P
        8xOSYhsVJszVmrBBy6kZKpjXORi1LeaK+bxS4miToMdLXwE0ZemkUN14IQ+dHHLw0fzwjAAN
        jTYRaLLhPh9VLE6T6PvOCj76qbuOQpaVNj4art+Afh+7B1CD3SNA/9y1AzTt6hWgor4hAbp1
        r52/U8zamm8Q7HylXcCeq70tYOutZtbacoRif3b2Uuxv569RbIWtBbDzj/pI1nbBDVi3dbM8
        JCMvOQdz2dgQgbVKXXauVpXC7NqneE0RnyCRxkgT0StMhJbT4BQmLV0e83qu2jsZE3GAU5u9
        LjlnNDJxO5INOrMJR+TojKYUBuuz1XqZPtbIaYxmrSpWi01JUolke7xXmJWXc/doIdBXRh7s
        +6ICFIDC8FIQJIS0DA6cWOb7WEz3APiNK7IUBHt5GUDHL6d5/gc3gPfLD6wFNC24CL+oG8A7
        Y7d4fqOIgLOFj4FPRdExsMjpXlWtoz0AXm8tEfgMkn4IYMlI+2rBUDoDjlv+IHzMo7fCxv4f
        KR+L6B1w2V1D+Ottgd+e6Sd9HESnwr9n/lxNBOkhIZxacZN+URpcWOnh+zkU/nrJJvBzGFyq
        LA6wCnYMdQQ0aljy2eeB2FTYf7XOO4PQ210UPN0d53eHw2Oj7as9kPTTsPyvuUA/IthlWeMX
        YOPMkQBvgm0zy4H0LCz7roPyr6UGwNmVckEV2Fz7f4l6AFrARqw3alTYGK/frsUf/fdtSp3G
        ClbPN/rNLjA95YodAIQQDAAoJJl1ouagXqVYlM0d+hgbdAqDWY2NAyDeu8BqMmy9Uue9f61J
        IZUlSmQJCQmyxJcTpMyzImw/qRTTKs6E8zDWY8NaHCEMCisgdpdXpBc8lbRv4vDU+/KLI1tE
        1z+oySosO/bSu6FXR6J4J8iy0r0a98RKWmTTqU+fiBedpUQlfsu2cUMQMf2JfI8AnZqsbGw5
        3po89pyDd82jcI4erC7OsgV7qhVZLsvRuQe3QZTddTO4cVPK25mH6lKbM5slvR2ecwtMh8je
        IKPXKw8781FulYdrTfqyanbXXkXVlfDLrp2X8y40xe1Bwv29iIpWWC5GvYFD0vcXN/HujHw4
        iPXlBdsGfxiOeDU9MiT5LF/+SBdckN/6omZBVnWpdvbhVM/X+UvvPHjv7E1rqCNTNz5y4/mJ
        M4vHk52OyWes1a0ZxJMJVWyYbLFLP8fwjDmcNJo0GLl/AVZJcJ1HBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnK5X9r5kg9lXjCx+vpzGaPFg3jY2
        iznnW1gs5h85x2rx9Ngjdosjp5YwWdxb9I7Vou/FQ2aLC9v6WC0u75rDZjHv71pWi2MLxCy+
        nX7DaLFo6xd2i/+vtzJaPPywh92ide8Rdovbb9axOgh5bFl5k8njaf9Wdo+ds+6yeyzYVOqx
        aVUnm8eda3vYPN7vu8rm0bdlFaPH0x97mT227P/M6PF5k1wAdxSXTUpqTmZZapG+XQJXxuvu
        FsaCfuWKve19jA2MLbJdjJwcEgImEkuef2DqYuTiEBLYwSixbmYLK0RCRuLkgyXMELawxMp/
        z9khipqZJPrOvGcDSbAJ6Eq0XvvMBGKLCDQwScyfnQ1iMwv8ZZSYu04bxBYWiJA4OHEK2CAW
        AVWJxQcugfXyCthJfPo8iQligbzE6g0HwGo4Bewl/jz6xQ5iCwHVNP39yDiBkW8BI8MqRsnU
        guLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg6NDS2sG4Z9UHvUOMTByMhxglOJiVRHhXcu5J
        FuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoGJ30eRh0fc
        XD+Hz3Biqe2v8/Ln/D43Pmnl4mctUWg757BDYlHKxVyxPbGSv94d35NorPPE6on+gfkMVWGL
        jiYZ+ryeoKR2J272koP8F822v1cRuHy0df3JFywbd17WlUgwKpjmsjdqWX0Py8nUv1GqxUGh
        Ir9Mt1i/t9R6s97/nP3O0gozg9Vql186v+CqV7kz+YuJv0NuRtCs0yGN7at+NJT1NJ98mHXi
        qqLwlSYh23WuSx9H175O5LXX1D6xJizJKWZBzNoLp1I6Zat/v6kRevg5vqtH5e/ELL1V7Ht/
        fZ+qVMiwZ4b67qNO7S0c7A/O++qxWdoLe4fEP1h9t3fqzN3PJ36fNvWnjGTKwRVKLMUZiYZa
        zEXFiQD7fdpl/QIAAA==
X-CMS-MailID: 20230111075450epcas5p3f13b94bfeaa66d386aa51f87ca4ec5bf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230111075450epcas5p3f13b94bfeaa66d386aa51f87ca4ec5bf
References: <20230111075422.107173-1-sriranjani.p@samsung.com>
        <CGME20230111075450epcas5p3f13b94bfeaa66d386aa51f87ca4ec5bf@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts      |  9 ++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 56 ++++++++++++++++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 22 +++++++++
 3 files changed, 87 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 1db6ddf03f01..ca0c1a28d562 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -30,6 +30,15 @@
 	};
 };
 
+&ethernet_0 {
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
index d0abb9aa0e9e..7ccc0738a149 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -64,6 +64,62 @@
 		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
 		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
 	};
+
+		eth0_tx_clk: eth0-tx-clk-pins {
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
index f35bc5a288c2..ade707cc646b 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -32,6 +32,7 @@
 		spi0 = &spi_0;
 		spi1 = &spi_1;
 		spi2 = &spi_2;
+		eth0 = &ethernet_0;
 	};
 
 	cpus {
@@ -860,6 +861,27 @@
 			clocks = <&clock_fsys0 UFS0_MPHY_REFCLK_IXTAL26>;
 			clock-names = "ref_clk";
 		};
+
+		ethernet_0: ethernet@15300000 {
+			compatible = "tesla,dwc-qos-ethernet-4.21";
+			reg = <0x0 0x15300000 0x0 0x10000>;
+			interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_CLK_PTP_REF_I>,
+				 <&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_ACLK_I>,
+				 <&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_HCLK_I>,
+				 <&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_RGMII_CLK_I>,
+				 <&clock_fsys0 FSYS0_EQOS_TOP0_IPCLKPORT_CLK_RX_I>;
+			clock-names = "ptp_ref", "master_bus", "slave_bus", "tx", "rx";
+			pinctrl-names = "default";
+			pinctrl-0 = <&eth0_tx_clk>, <&eth0_tx_data>, <&eth0_tx_ctrl>,
+				    <&eth0_phy_intr>, <&eth0_rx_clk>, <&eth0_rx_data>,
+				    <&eth0_rx_ctrl>, <&eth0_mdio>;
+			local-mac-address = [00 00 00 00 00 00];
+			rx-clock-skew = <&sysreg_fsys0 0x0>;
+			iommus = <&smmu_fsys0 0x0 0x1>;
+			phy-mode = "rgmii";
+			status = "disabled";
+		};
 	};
 };
 
-- 
2.17.1

