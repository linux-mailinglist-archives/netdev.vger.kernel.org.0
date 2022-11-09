Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EAE622939
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiKIKy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiKIKx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:53:29 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068E329374
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:53:07 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221109105306epoutp03a11f25961557dffb3daef843b043e6ac~l5SWE4C621577715777epoutp03B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:53:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221109105306epoutp03a11f25961557dffb3daef843b043e6ac~l5SWE4C621577715777epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991186;
        bh=Q6BHJdR6aS4iKNUC0tRGmigh4Q1WQwSFXsmGUpYpx2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+buqMoVUZqAyHNPEzJj3ACarHHEiEWMx0hQ0P83T9IoktSAOrzbsW3lnbhat5/Fn
         grTEscG1uRSnRNPS1ue45MXRPXHD2zEGpUJyPbRC5Zi5Nv4gLWR+h0EO864S9cjovb
         XRHhZWT+3JT240GpwarH4cbPj+Ul5lzg3OYjnSxQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221109105305epcas5p17532a6c782358399222b39d937fc4db6~l5SVT0-hP2960629606epcas5p16;
        Wed,  9 Nov 2022 10:53:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4N6hdW0bZcz4x9Q0; Wed,  9 Nov
        2022 10:53:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.47.39477.E868B636; Wed,  9 Nov 2022 19:53:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100258epcas5p2966d5e93e00d2a5b4e4a3096dc5a5ec6~l4mkq3E610099800998epcas5p2o;
        Wed,  9 Nov 2022 10:02:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221109100258epsmtrp13f9cbd29c59c6f43412c937460af35d4~l4mkoVdDo0841808418epsmtrp11;
        Wed,  9 Nov 2022 10:02:58 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-ea-636b868ee48f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.79.18644.2DA7B636; Wed,  9 Nov 2022 19:02:58 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100255epsmtip2908f98b958431ee5b65144ed4c6d3ae5~l4mh0TTZs1844418444epsmtip2a;
        Wed,  9 Nov 2022 10:02:55 +0000 (GMT)
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
Subject: [PATCH v2 4/6] arm64: dts: fsd: Add MCAN device node
Date:   Wed,  9 Nov 2022 15:39:26 +0530
Message-Id: <20221109100928.109478-5-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTf1CTdRzH+z7Psx9A4x4B8dtK203B4AI2HesLB+WV1VOhR8bB0aFrtz3H
        OMa2tpGK17ES0HFsgzM5I9SBKD8PxkDil0ZDxaADWqUQRAzlUvKQHFmZeG08UP+9Pu97vz+f
        708uHjLI5nNzNEZar5GrhexAomswKjrGWpKrEFn6EJo908VGro6LHFQ9VkSgs1dGWWj+2hwH
        We94cDTeZWUh560bLNT050kceRYy0Pe91Wx0auwyhtpqPyPQNXs4ejhyD6Dai8sc5Fnq56Cq
        8W4WKr50hYOm7rWy0KOaQQKdn+lh7QqnOhsnMcruzKd+d08BytlkZlPTN/rZVEddIWVbEVH3
        L//IpqydTYB68ulpDuV1bkkNej83SUXLlbReQGsUWmWOJjtZ+M57stdk8VKROEacgF4SCjTy
        PDpZuDslNeaNHLVvq0LBR3J1vk9KlRsMwriXk/TafCMtUGkNxmQhrVOqdRJdrEGeZ8jXZMdq
        aGOiWCTaEe8zfpCr+tw6i+u82w/91brZBNoFpSCAC0kJdAxXglIQyA0h+wB0nHuAM8UDAL8d
        OUYwhRfAoaFGznpkotuxFukF0GJaxpiiGINzU26W38Umo+Ets301HkY2Y7DT61mN4GQVBuuO
        /kT4XaFkMuwxTa/2JcgIWOoewf3MI5Pgzfo2FjPvedjsGPDpXG6Az++pETHyNBfazx9ieDes
        r7ARDIfChaHOtaXy4V1byRorYPcT81pLFbRX9AOGX4EDP1QT/vY4GQXbeuMYeTM8OdyK+Rkn
        g6Hln9sYo/Ng95l13gbveMtZ/qh/lGU0lJEp6K72spgzKQfQPNpBlIMtVf9PsAPQBJ6hdYa8
        bNoQr9uhoQ/+d2kKbZ4TrL7m6Le7gWd2KdYFMC5wAcjFhWG8oBdyFSE8pfxwAa3XyvT5atrg
        AvG+06vA+RsVWt930BhlYkmCSCKVSiUJO6Vi4SbeuVPRihAyW26kc2laR+vXcxg3gG/C9LeV
        X6VPqk4fO6LMtIUFTM1lVhaAvdfJsZK5uz1VrpVfIv8QdN5fzIxwltae7WpJbpfd7D+QEV7d
        8uZSlPzxcuXBjUPbHIL5q8UnBsQXKhsf21yVGwKa3fWWq22RrAuHa/iSwoxL+1s+TKlty1Id
        T8HoPREpS+qU1I81v9rS1fvME72v9zyajLk+L3l2kfO12f3bcNHEN4RqZNdCfdqmV2MH48AG
        tgy2NDgk40eaFM+lp8n2lRWY6maGv1v8GT1sfqrKwg9qTiscP/5lX9nOt9gqU9T2hvYVXmLR
        1r8PHM2abDDvYYeRL0aWnBC9OyMKfnpZmlm2P+ELVeDWT/ZmJQYTFiFhUMnF0bjeIP8XKD1v
        sFYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvO6lquxkg4tfeC0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxsy+B8wFn9UrfqyTbWDcqNDFyMkhIWAicWPHBsYuRi4OIYEdjBJz
        7z5khkhISUw585IFwhaWWPnvOTtEUTOTxIVly8GK2AS0JB53LmABSYgI7GaSeNs9F6yKWWAR
        k8TLK71gVcICthI7G+6wg9gsAqoSXZdOg8V5BWwkri9fzwqxQl5i9YYDQHEODk6g+ocLDUDC
        QkAlz28vYpzAyLeAkWEVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZw/Ghp7WDcs+qD
        3iFGJg7GQ4wSHMxKIrzcGtnJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5N
        LUgtgskycXBKNTBxTH3lutkm3f24+EL5v5v5ap2rSqds1Tm57XrV68D9H6xYWvZefOO70YD9
        2sHX/i3ex5U0bp6xULxkuviGyr1zq1tshNYwzLxz/nPEEcfyzpUxb7fGmqRZXbI7paji5lGy
        Y+KWe70xGaFTPq14afjjYDjrzh8Gs5rOcCltD9L7v4ZV9Jr4xdn/Jnya/iJymfjNfJ2obdVX
        zV/kffnW0KnZ+vT99VevLi4sWTVl6o/Uw7GVIRPkvXa1bX/VsL4st+T/osk7Jk5JslFN1Uh4
        H7Tr8U/jWm0nM6n4roRP+oICTGd9go4rVR3g3mry9fLWCJsX/2qNnd9JFc16mNE+ecOthkpl
        7uw93MGfRCZ6rP8frcRSnJFoqMVcVJwIAGTZsyUOAwAA
X-CMS-MailID: 20221109100258epcas5p2966d5e93e00d2a5b4e4a3096dc5a5ec6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100258epcas5p2966d5e93e00d2a5b4e4a3096dc5a5ec6
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100258epcas5p2966d5e93e00d2a5b4e4a3096dc5a5ec6@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MCAN device node and enable the same for FSD platform.
This also adds the required pin configuration for the same.

Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
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
index 3d8ebbfc27f4..154fd3fc5895 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -765,6 +765,74 @@
 			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		m_can0: can@14088000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14088000 0x0 0x0200>,
+				<0x0 0x14080000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can0_bus>;
+			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can1: can@14098000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x14098000 0x0 0x0200>,
+				<0x0 0x14090000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can1_bus>;
+			clocks = <&clock_peric PERIC_MCAN1_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN1_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can2: can@140a8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140a8000 0x0 0x0200>,
+				<0x0 0x140a0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can2_bus>;
+			clocks = <&clock_peric PERIC_MCAN2_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN2_IPCLKPORT_CCLK>;
+			clock-names = "hclk", "cclk";
+			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+			status = "disabled";
+		};
+
+		m_can3: can@140b8000 {
+			compatible = "bosch,m_can";
+			reg = <0x0 0x140b8000 0x0 0x0200>,
+				<0x0 0x140b0000 0x0 0x8000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			pinctrl-names = "default";
+			pinctrl-0 = <&m_can3_bus>;
+			clocks = <&clock_peric PERIC_MCAN3_IPCLKPORT_PCLK>,
+				<&clock_peric PERIC_MCAN3_IPCLKPORT_CCLK>;
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

