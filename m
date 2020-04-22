Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A41B35C6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDVDxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:53:46 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:40837 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgDVDxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:53:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4C4E25803F4;
        Tue, 21 Apr 2020 23:53:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 21 Apr 2020 23:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=ILg74KFQ4/u/i
        LEbpVIGKPDUn0lqkuyVDFTjVVQFF4M=; b=Wv97607xPWtRVGaOEQH8OktWOwXs+
        V7yXLHTFOj6OqTwSz1IzFUzbG65S6h0sTrevJ/K2FFkZTA6Xd/T9XihviBgTmJCL
        CBmgWTiuzJtUNW9GZFYHfhYxvCo9Z6hYbmmxh5uTpPS02yDV61PkgPSiM9PUXj+l
        ofsciwklmnohoDNyaDjjNt7MmleGtYA3NWCCV5Qtcpm11sMNIY+kLyRsis97Vp48
        GBzhdcS6FS16RgyOmqtRyfC0/gTIPwlAf9jZ+dgNM60hduOOYbSDxd60b6IX1VT2
        BiI1fDzWYOkcdD4ZGNLXd6HoKCBgvESWv9oGjzouKXIjDd7BPa2s+YWgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ILg74KFQ4/u/iLEbpVIGKPDUn0lqkuyVDFTjVVQFF4M=; b=SPdn04y7
        5O+FwlwSZUaBva56KCa1KdMuTWgrJm3rcHYFu/JB2041cQDHwzNLJlvFVGHcNm/W
        RL9mziBXzOh3u6jmffwMQ609Axegcua8e5a7RhcBfBXoc9mM4Pss+jt2G+vcYPAH
        MAWDgRESzjQeUDhf+Kr71gknujjBwWoJK5DLIfkKvhSF34/USfi7CO5K/caHrF8k
        TkHx4BBHCfGs5TigGnfkulpkh3xTirRmvr4BF89qdxeNDQ2SygemahWN8I+sgtZZ
        4sPKYtqRmpL6KqpfWo+djDR5CIjb2nlSt95GgkkeCSdkM8egNSSnzHsh7O8oFeZD
        Ddc60Fu86RfIdw==
X-ME-Sender: <xms:x7-fXkSt4UKXIs5uFgWnvjkfbVK8Tg71eoRgD3E4W9gAHMF9kNnZOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:x7-fXnDncP3mNbJS1YMLwjAoi4JfRM1SyxLBCkB60khr9oxH98G0bw>
    <xmx:x7-fXjjK1Kzi1L6oHfe17353xipTLo7ca0YaKqYmmFKLSTHl3xK2uA>
    <xmx:x7-fXgNgMfQ4r1Gs6Y2ugYwrdHjFif162-1j6GV8F-u7GCyie11Ktg>
    <xmx:x7-fXrIPz1i6BgJrX98EgeIL5aN7oiFIpfjnaDdW0wJevP7yCXn2Rg>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id D31483280063;
        Tue, 21 Apr 2020 23:53:41 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [DO-NOT-MERGE][PATCH v4 3/3] arm64: allwinner: Enable Bluetooth and WiFi on sopine baseboard
Date:   Tue, 21 Apr 2020 20:53:33 -0700
Message-Id: <20200422035333.1118351-3-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200422035333.1118351-1-alistair@alistair23.me>
References: <20200422035333.1118351-1-alistair@alistair23.me>
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

