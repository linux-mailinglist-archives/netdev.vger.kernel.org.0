Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D331B878A
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgDYPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 11:55:54 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:54085 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgDYPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 11:55:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3AC8E5803BD;
        Sat, 25 Apr 2020 11:55:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 25 Apr 2020 11:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=ILg74KFQ4/u/i
        LEbpVIGKPDUn0lqkuyVDFTjVVQFF4M=; b=MyWUkHZZ+Mcwdt7tPDh4nOqgZAEVt
        n8SU2n8ZR81Fv2JQ69Dyg1uEdGkMtEKpm/soc219ggCkilM6/1D9+OtmqfPOenjB
        ldoLtqTsxpA3l58j2j2ws+Qsm4ncs+ahXHyZGwqLceD/yhD67JU+9FsvbJJ0KH0H
        xKUJHUyoJjfvhIlvyuaPQBgQcyettaIm/ENgjGOFgP+fgXERqdExYTLQQvVQ3oZV
        qCIkbphLwFFe8aJ50Ie2LVfwUjbiiN6EUeCKBKsMIpfGk9Xp/ZhqrJHuekKCLYaY
        dduUrgJQ+SKwcqcQ2dEDydxkN8MCTy8Vkjd+XDRq0iFdlnkPfiOoL5EYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ILg74KFQ4/u/iLEbpVIGKPDUn0lqkuyVDFTjVVQFF4M=; b=UCDRN4Jd
        LJ1aMZu0e0azt1QAd15mpQLEvkm7c3u+0gP103CIaOw4Q/XGpCcOEGGWyMJifCLg
        9ohqiYsQi429Ig1oFNTzBFbW7VW/5MSqi2GRDxWR6smw/FieTf3ZS8BFdRFihbi+
        50WCmvYm5421efcI5PBTNEhlHYua0qS7FC5QP1biymBNhbukf3tm84In2sOVExAh
        GHl83AiZau8VJG05cv33yS4Of5eeOLPnRa0VbVUNsSBGGwqZRoTAq5tPACtbRGKN
        JyzCbsnjkiymVnm4+scLO6k6toz5ie3GpFcSOEJ2WAC2mCqstpej7t2ACneO7mug
        luZ/F72ZAiQlhg==
X-ME-Sender: <xms:eV2kXi1pBLxDckTlLq0uQuE8lEyDr8jXdaOXJDDd04dyCcx-e5eu_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheeggdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:eV2kXqZrTsq_qRbUyCTF_6XuyPLGUjZ7BuDwiXHBjViahgBFV0hl6w>
    <xmx:eV2kXm_x8CUI9jrkObOTtn3Yguxfh63r73e5LW3bdkcDWa5Q8iVRJg>
    <xmx:eV2kXgZpYVI4tGkPcpJv3AmtMpyCUSWeZFa-C0lng4L1-U64Se0jcw>
    <xmx:fV2kXi4qQrktnCVTQ7Iav98OQI_z_ThFrs3_xuZPYpAYfcQBnE1LSw>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 921A03280067;
        Sat, 25 Apr 2020 11:55:36 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [DO-NOT-MERGE][PATCH v4 3/3] arm64: allwinner: Enable Bluetooth and WiFi on sopine baseboard
Date:   Sat, 25 Apr 2020 08:55:31 -0700
Message-Id: <20200425155531.2816584-3-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200425155531.2816584-1-alistair@alistair23.me>
References: <20200425155531.2816584-1-alistair@alistair23.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sopine board has an optional RTL8723BS WiFi + BT module that can be
connected to UART1. Add this to the device tree so that it will work
for users if connected.

Signed-off-by: Alistair Francis <alistair@alistair23.me>
---
 .../allwinner/sun50i-a64-sopine-baseboard.dts | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index 2f6ea9f3f6a2..34357ba143cb 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
@@ -42,6 +42,11 @@ reg_vcc1v8: vcc1v8 {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 	};
+
+	wifi_pwrseq: wifi_pwrseq {
+		compatible = "mmc-pwrseq-simple";
+		reset-gpios = <&r_pio 0 2 GPIO_ACTIVE_LOW>; /* PL2 */
+	};
 };
 
 &ac_power_supply {
@@ -103,6 +108,17 @@ ext_rgmii_phy: ethernet-phy@1 {
 	};
 };
 
+&mmc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	vmmc-supply = <&reg_dldo4>;
+	vqmmc-supply = <&reg_eldo1>;
+	mmc-pwrseq = <&wifi_pwrseq>;
+	non-removable;
+	bus-width = <4>;
+	status = "okay";
+};
+
 &mmc2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc2_pins>;
@@ -174,6 +190,19 @@ &uart0 {
 	status = "okay";
 };
 
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+	uart-has-rtscts = <1>;
+	status = "okay";
+
+	bluetooth {
+		compatible = "realtek,rtl8723bs-bt";
+		device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
+		host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
+	};
+};
+
 /* On Pi-2 connector */
 &uart2 {
 	pinctrl-names = "default";
-- 
2.26.0

