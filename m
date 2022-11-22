Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEFA634F90
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiKWFbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbiKWFbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:31:02 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D60EED71B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:31:00 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221123053056epoutp02b9d7c7dc2686631394033be52e17747a~qH7D2BYNJ0984409844epoutp02J
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:30:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221123053056epoutp02b9d7c7dc2686631394033be52e17747a~qH7D2BYNJ0984409844epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669181456;
        bh=zxEW4aRMNY+I/kBJaywdBjCo9sOxx8Km7j9aqHAo5dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3xv1MSVXXMVKmGc9pQXYtr6a95+WWRkh6SqcfB6rMvYKEX+jK4SfPgIvLBlhwY4E
         ATXqsm1mG+PA57j+xLZ/6neI5dPeAlujkW5bBMwCy5Yz6UMQNP0oWpsAXu+uZ72mgE
         rxG9oazgZuDoBtEIYSU8h5avtNs2YQyVUWXMFJs0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221123053056epcas5p1301c275ddcbdaea62ae9a8108af57075~qH7DYM08H2401924019epcas5p1T;
        Wed, 23 Nov 2022 05:30:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NH8qL1yPqz4x9Q3; Wed, 23 Nov
        2022 05:30:54 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.77.56352.D00BD736; Wed, 23 Nov 2022 14:30:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4~p4ov8AEnc2771827718epcas5p2b;
        Tue, 22 Nov 2022 10:50:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221122105027epsmtrp169d1cede51b1841bb5ee1c8979606b4e~p4ov6-EoG0938009380epsmtrp1z;
        Tue, 22 Nov 2022 10:50:27 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-5d-637db00d7ce5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.8B.18644.379AC736; Tue, 22 Nov 2022 19:50:27 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221122105024epsmtip16d9c1b80cccb7f2649509e879aa615ed~p4osxvLtU0765207652epsmtip1c;
        Tue, 22 Nov 2022 10:50:24 +0000 (GMT)
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
Subject: [PATCH v3 2/2] arm64: dts: fsd: Add MCAN device node
Date:   Tue, 22 Nov 2022 16:24:55 +0530
Message-Id: <20221122105455.39294-3-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221122105455.39294-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTe0xTVxz23Ht7Wx4lN4XhsdmguWFjMoFWW3ZwoAYZuz4SMf6xbMsGtVwo
        oa+0xW06xDA0gQQKIltFVMS68VgQy6tFIKwobLKJPGRDGBYEwxxTB45lE8igt27/fd+X7zu/
        xzlHgItcpFiQqTOzRp1SQ5O+RGvP5ojIgMYclfTauB9yX2glkauphY8qB/IJdPHGbR6a7Z3m
        o+K5KRzdaS3mIfuDUR6q+6scR1OP3kXD7ZUksg50Yehq9RkC9VYFo6X+eYCqW57x0dTTDj6q
        uOPgoZOdN/hofL6Bh/651EOgK5NO3q5gprl2DGOq7NnMH0PjgLHXFZDMxGgHyTTZchnLipR5
        0nWXZIqb6wCzmneezyzaQ5L93s+KU7PKNNYoYXUqfVqmLiOe3ncoZXeKIkYqi5TFojdpiU6p
        ZePpxP3JkUmZmrVRackRpSZ7TUpWmkx09I44oz7bzErUepM5nmYNaRqD3BBlUmpN2bqMKB1r
        3i6TSrcq1oypWerVwlLMYA3/5O7sWeIEuB5aCAQCSMnh/YLUQuArEFHXARx8vgA4sgDgSsEV
        giOLAC79eB4rBD6exEihy+tqB/Abp4PPkZMY/LJxhL/uIqkI+KCgyhMPouox2Lw45YngVAUG
        bZ/fI9ZdgVQ8vDja6zmXoF6Fc+UuYr0rIfUWbOjI4MqFwvrGbnwd+1BxsPsnB5/T3QK4XCLm
        cCKcts7zOBwIH/U1ez1i+KvllBeroGO1wOtRw6rSDsDhnbB7pNJTFqc2w6vt0Zz8Ciy/1eDp
        DKcCYNHzGe/0Qui48AKHwbnFEh63RzEsuh3IyQy8/62NXMciygLgxOWdJSCk4v8CVQDUgU2s
        waTNYE0KwzYd+/F/d6bSa+3A85gj9jnAtPtplAtgAuACUIDTQcLcPZ+pRMI05adHWaM+xZit
        YU0uoFhbXikufkmlX/sNOnOKTB4rlcfExMhjt8XI6I3Cy9YIlYjKUJrZLJY1sMYXOUzgIz6B
        ffS7TnFanSzxm24/Z2ftxJCzevLtWwcOBU7udb8RYLEGDfQM5B9tjTq3UBN4Kkl4/HWnMZV2
        ni1OoGb63mPrl1O/sgUNTbAz7Yq4vYeBo1xM8iNnfcPcTdeGc8byQ7ZOlHUHh7ujBrSnB8eP
        Bfcd3+R+UkF/kb59S+az4bbdO9J+e7hSu1yzS97sr4XmtvQNbXGdY/49P/grQjeCxLDahK7w
        oj3RzpYjH+A3a8DDzg9Xo79v0luXbvaXTf/d+XK8Zlke/fi7XzLztrwmtNgOJ7X22L+2lB37
        ef7PKXWKPRdJ1Hmj70ReGlclBt07aJh/HOrYgAZn3TnpCZi/kew/uEwTJrVSFoEbTcp/ATB8
        jQJVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnG7xyppkg5cXNS0ezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxr+uiUwFM9Qrrj6dydLAuFu+i5GTQ0LAROJK1yHGLkYuDiGBHYwS
        TctnM0EkpCSmnHnJAmELS6z895wdoqiZSeLFjkusIAk2AS2Jx50LWEASIgK7mSTeds8Fq2IW
        WMQk8fJKLzNIlbCArcT8a8fAxrIIqEq8mHoIqIODg1fAWmLdnnSIDfISqzccACvnFLCROHB9
        BzuILQRU8nheA9MERr4FjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI0hLawfj
        nlUf9A4xMnEwHmKU4GBWEuGt96xJFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJ
        anZqakFqEUyWiYNTqoGJ74xhUvql0GlLffw2sX46ujHQasZelb63Ul7bZn85dePP0gXlq3sX
        qD9bz8zUrRsruXOqeVtYmn3Nf9OXSwtLj89/5ng6tz179fUm++nqh9bvCvBvfytVeWf2rGXn
        pBVy0s8fitdut35tbOR5X4N118cvwSJMEzmn5roX7IrYESv/uulyileM2/6iW3ZyVW9PflKt
        Pi4bcWcPR9199pNp/2yWrGV5fuX67Z6dPWkGfVNOLZwoIaSwxzc9qaJ6m/BC0yM3t/q9K9zR
        Vmczveb81TNKdc5SbeJZy3l/MZ5b7bD92eFVB5u4GnqDXnwOPuIxcarG5O0KTaLnLqdf1TpZ
        FyO8/WiNdu8//h1vnW/8UGIpzkg01GIuKk4EAGRmXl4PAwAA
X-CMS-MailID: 20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4
References: <20221122105455.39294-1-vivek.2311@samsung.com>
        <CGME20221122105027epcas5p2237c5bc9ab02cf12f6e0f603c5bb90c4@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

