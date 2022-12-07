Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8841645802
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLGKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLGKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:36:08 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752BD2EF38
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:36:07 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221207103606epoutp04efcc70619b493c70d349303bee163985~ufHfarO252848728487epoutp04J
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:36:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221207103606epoutp04efcc70619b493c70d349303bee163985~ufHfarO252848728487epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670409366;
        bh=zxEW4aRMNY+I/kBJaywdBjCo9sOxx8Km7j9aqHAo5dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NP5oCXm9d4Rg8XsxXuAA2Ph3hzvezKN3sJqiI/uh8UFkh4ZMA/CX+O847EAYZE3WX
         EaqwHl5u3qOMklsfGQ5ew93jxcKTVUx9rcdk3Zr+AY2YSfN40kVhj4dVhukXqT2vIT
         lb2OVM6VWF8Qse5X8nnwcijM3r7773kmYFxePNYc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221207103604epcas5p46ed071591a8b7c3a61aeda1c5a48b667~ufHd6SGaR3205632056epcas5p4H;
        Wed,  7 Dec 2022 10:36:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4NRtwy4dX8z4x9Pw; Wed,  7 Dec
        2022 10:36:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.25.39477.29C60936; Wed,  7 Dec 2022 19:36:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221207100700epcas5p408c436aaaf0edd215b54f36f500cd02c~ueuFbrcTq2723727237epcas5p4F;
        Wed,  7 Dec 2022 10:07:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221207100700epsmtrp29aab399730057e716faf8a2cf6acba50~ueuFZKJUG0757407574epsmtrp25;
        Wed,  7 Dec 2022 10:07:00 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-fb-63906c9259a3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.FD.14392.3C560936; Wed,  7 Dec 2022 19:06:59 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221207100657epsmtip2cef9b724734c821be031ee8ed03931c2~ueuClidVI0667806678epsmtip2f;
        Wed,  7 Dec 2022 10:06:56 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        Vivek Yadav <vivek.2311@samsung.com>
Subject: [Patch v4 2/2] arm64: dts: fsd: Add MCAN device node
Date:   Wed,  7 Dec 2022 15:36:32 +0530
Message-Id: <20221207100632.96200-3-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207100632.96200-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTe1BUVRyec+/dB8TqDVAOFLhzR1JogF3bpUNC6OTInWiKgZweY8Kdy20X
        WXa3fZBEo2RRwAzPtBAXWIhtYiFAXiGwPsDQrFGSRwHagGARISIrYA+wXRbqv+98v++b7/f7
        nXOEuGcv30+YojZwOjWjovjuRHtvUFBIiaqIlfx8nkLjFe181NPSJkCm6x8RqPLSNR6603db
        gAqmJ3DU317AQ82TwzxkXT6Jo4mZ19BAp4mPSq+fw1Bj9QkC9Zm3oqXvZwGqbnsgQBPz3QJU
        1t/BQ9m2SwI0NtvAQ39V9RLI8stZ3p6tdGvtCEabm430/RtjgG625vLpm8PdfLql5hhduCKh
        750b4tMFrVZArx4vF9D25oC4x95MjVRyTDKnE3NqVpOcolZEUbEJiS8kysMl0hBpBHqWEquZ
        NC6K2vdSXMj+FJVjVEqczqiMDiqO0eupsOcjdRqjgRMrNXpDFMVpk1VamTZUz6TpjWpFqJoz
        PCeVSHbJHcKkVOVqXjGmLd1xZOjOKSILdG3LA25CSMrg7EIbngfchZ5kF4DZo8uYs+BJLgBY
        uxjvKiwB2JlbIthwVE63810FG4APbGeBy5GNwdm5TCfmk8FwMtdMOEXeZB0GW+0TwHnAyTIM
        1nw4SjhVXmQUvH1xzJEnFBJkIJxret9Ji8jdsPXLOsKVtg3WNV3AndiNjIQLtwrXeoXkuBCO
        LNWui/ZBy+rwOvaCM5db11v1g/Y5G9+FWdixmstzYSU0F3cDF46GFwZNhLMHnAyCjZ1hLtof
        nrzasLYKnNwE8/+ewly8CHZUbODtcNpexHNanVH517xcNA07LDUC14IKASyurMCLQEDZ/wlm
        AKzAl9Pq0xScXq7dpebe/e/SWE1aM1h7zcEvdoCJ8fnQHoAJQQ+AQpzyFk2fyWc9RclMxnuc
        TpOoM6o4fQ+QO9ZXjPttYTWO76A2JEplERJZeHi4LOKZcCnlI7KcyGE9SQVj4FI5TsvpNnyY
        0M0vC4Npo4Y/DiQ8pcmtvuXjEbNi+jUk8ElbY0YSpT9y8dEbv0e/+rhNnhIdZpxZeFt8d/P5
        5fIIot90l/WfnR7d/vUNt8i44EmPgys+AzHx4qwx83evbKp/S6DzbR+x3Hs4cjjp0QfeO56O
        /fanU2xJZuCnl0tNe/3Zbjltz+eP2E0HF31HFUU5LbIz8i9+6Mt5OaGpcHj1sDuJW1p8/Tqb
        Yit+PH3/ECOqXqx655NMZcKBo17uMVduCsoGJVXs/NwT8d9kDO4t23LF2hU29M9x0nT1qz0e
        5fFM7DHrUnrb1Mf16aaZ14nTRxcyd/8W0LC5lBc05bNz5yGPLvZzxUBC/Gd5f7bUpz6kCL2S
        kQbjOj3zL6CbkghWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvO7h1AnJBmtO21g8mLeNzeLQ5q3s
        FnPOt7BYzD9yjtXi6bFH7BZ9Lx4yW1zY1sdqsenxNVaLVd+nMls8fBVucXnXHDaLGef3MVms
        XzSFxeLYAjGLb6ffMFos2vqF3eLhhz3sFrMu7GC1aN17hN3i9pt1rBa/Fh5msVh6byerg5jH
        lpU3mTwWbCr1+HjpNqPHplWdbB53ru1h89i8pN6j/6+Bx/t9V9k8+rasYvT41zSX3ePzJrkA
        7igum5TUnMyy1CJ9uwSujH9dE5kKZqhXXH06k6WBcbd8FyMnh4SAicT8F9vYQGwhgd2MElfm
        lELEpSSmnHnJAmELS6z895y9i5ELqKaZSWJm9wdmkASbgJbE484FLCAJEYHdTBJvu+eCVTEL
        LGKSeHmlF6xKWMBW4tHB20xdjBwcLAKqEu821ICEeQWsJbYsWw21QV5i9YYDYOWcAjYSn+72
        M0NcZC3x79czxgmMfAsYGVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgTHj5bmDsbt
        qz7oHWJk4mA8xCjBwawkwvtiY2+yEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tS
        s1NTC1KLYLJMHJxSDUwHYh7w9q0WvFrTXXZT4zPDo+U/3tQHfOoSnvk50VrSlW2vYdyUDj6u
        pbPyFnYVfpgeeDfDXPbxLt37s4Q+nipQ1bcLziw3uC+csjHuxvnzDr2MKaEfrsuc2ViowebP
        OH+rQ4FhSNWbe8tC/K//ig3nnedtW5sy75WoVavXiWky3fMXiyRpZV674OZUuIazZMaf10bu
        rur7rr1r/9puf1l71sd/J0/K7/ZgOjbh1HJTcb9iXvnkW3eapsxTmrVr1YPlxS+NGwIXK58R
        4+r65nBWuGmW8bebC58GJad+P9r81fPcSznG44msZzNezDibz7Jshslc8RW2Fmed/i719lO1
        cU1dtEa2oL7KrpJ9qr8SS3FGoqEWc1FxIgAnLSt5DgMAAA==
X-CMS-MailID: 20221207100700epcas5p408c436aaaf0edd215b54f36f500cd02c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221207100700epcas5p408c436aaaf0edd215b54f36f500cd02c
References: <20221207100632.96200-1-vivek.2311@samsung.com>
        <CGME20221207100700epcas5p408c436aaaf0edd215b54f36f500cd02c@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MCAN device node and enable the same for FSD platform.
This also adds the required pin configuration for the same.

Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd-evb.dts      | 16 +++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 28 +++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 68 ++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd-evb.dts b/arch/arm64/boot/dts/tesla/fsd-evb.dts
index 1db6ddf03f01..af3862e9fe3b 100644
--- a/arch/arm64/boot/dts/tesla/fsd-evb.dts
+++ b/arch/arm64/boot/dts/tesla/fsd-evb.dts
@@ -34,6 +34,22 @@
 	clock-frequency = <24000000>;
 };
 
+&m_can0 {
+	status = "okay";
+};
+
+&m_can1 {
+	status = "okay";
+};
+
+&m_can2 {
+	status = "okay";
+};
+
+&m_can3 {
+	status = "okay";
+};
+
 &serial_0 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
index d0abb9aa0e9e..bb5289ebfef3 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -339,6 +339,34 @@
 		samsung,pin-pud = <FSD_PIN_PULL_UP>;
 		samsung,pin-drv = <FSD_PIN_DRV_LV1>;
 	};
+
+	m_can0_bus: m-can0-bus-pins {
+		samsung,pins = "gpd0-0", "gpd0-1";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can1_bus: m-can1-bus-pins {
+		samsung,pins = "gpd0-2", "gpd0-3";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can2_bus: m-can2-bus-pins {
+		samsung,pins = "gpd0-4", "gpd0-5";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
+
+	m_can3_bus: m-can3-bus-pins {
+		samsung,pins = "gpd0-6", "gpd0-7";
+		samsung,pin-function = <FSD_PIN_FUNC_2>;
+		samsung,pin-pud = <FSD_PIN_PULL_UP>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
+	};
 };
 
 &pinctrl_pmu {
diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index f35bc5a288c2..dfdb32514887 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -755,6 +755,74 @@
 			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		m_can0: can@14088000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14088000 0x0 0x0200>,
+			      <0x0 0x14080000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can0_bus>;
+			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
+				 <&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can1: can@14098000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14098000 0x0 0x0200>,
+			      <0x0 0x14090000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can1_bus>;
+			clocks = <&clock_peric PERIC_MCAN1_IPCLKPORT_PCLK>,
+				 <&clock_peric PERIC_MCAN1_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can2: can@140a8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140a8000 0x0 0x0200>,
+			      <0x0 0x140a0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can2_bus>;
+			clocks = <&clock_peric PERIC_MCAN2_IPCLKPORT_PCLK>,
+				 <&clock_peric PERIC_MCAN2_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can3: can@140b8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140b8000 0x0 0x0200>,
+			      <0x0 0x140b0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can3_bus>;
+			clocks = <&clock_peric PERIC_MCAN3_IPCLKPORT_PCLK>,
+				 <&clock_peric PERIC_MCAN3_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
 		spi_0: spi@14140000 {
 			compatible = "tesla,fsd-spi";
 			reg = <0x0 0x14140000 0x0 0x100>;
-- 
2.17.1

