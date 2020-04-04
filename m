Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6CA19E79E
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgDDUtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 16:49:05 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49399 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgDDUtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 16:49:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C58A15801D5;
        Sat,  4 Apr 2020 16:49:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 04 Apr 2020 16:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=y+MayVaAZgHOI
        lJXNt5L435nPg8iLvxccPaJPfrhuPo=; b=tMTQIJ5raaK5IuRxdLbBoSYMZALaL
        Iq8ZFYiIkW7rBJqSfIuwPqw1Q6TT2HuPrvJ4SkOyuY5k+SilkNqyUHtuJXnWeWLB
        2IamNBQCKiE+MBuLZCB7jD87/9LVv40/zIGoO6u7f0T8g0e1b3yJNDACFg5mEP7B
        VkPLAsQEu5b8WJNedIqd+4ceD6BEr9pVqvpDVhPhVwt8O8oLDyTy98MpsTWGE6Ci
        VJrFR/EQuh0d8qarSBUnRD7ZuOF4A2sqKhsNJG2v8dinhV2Psc0KorG49hG3cFrx
        QCO4h6qHfbjrvI9kS3HFx7c33OjEJt6ZOsjP7VNFWLZSFSxA4RoTJ/pFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=y+MayVaAZgHOIlJXNt5L435nPg8iLvxccPaJPfrhuPo=; b=pmUuBKcK
        dEepWgAj4A0QdI5qXWlX1iXiSgBJ9ah4sgE1mZE0gHTASCUlERdEt5QErMlz69z1
        WxNBjK4CZdu8iQwq3xr/2Cyt+3GGOaDbTsTqy73Tfxp0pCLdvaytHnQI/czdnDBu
        ESJehiJqoIecu/xBRv1upDZNliViVyjvl1hadRhJPG6bDYexFA44tZuzwGpcJ1iO
        Gte2RlUkF5duJzzDll7iboaQjyHfsG5JwuovkN8iwdfq6ANNl7yZNbx41T/SIeJx
        BxjvnEDLPehen5XQ+wozcHuqKy+vgCRxlvxqFlGSExJCF/tmt/YB23PnqOEEfSrL
        m5qt0wF6xapWBg==
X-ME-Sender: <xms:v_KIXgi8iHOd3bwVkUQCdsNn5gJyHsv9pLnrGBlk3E-FRrjdyl4jIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdekgdduheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomheptehlihhsthgrihhrucfhrhgrnhgtihhsuceorghlihhsthgr
    ihhrsegrlhhishhtrghirhdvfedrmhgvqeenucfkphepjeefrdelfedrkeegrddvtdekne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihhs
    thgrihhrsegrlhhishhtrghirhdvfedrmhgv
X-ME-Proxy: <xmx:v_KIXg_2fVXNkTZpam5CFaIimV2h8LC6E5xmVc2Q31EpamvsFRVofQ>
    <xmx:v_KIXvRHLX_cuNePAerAHbSr4mPIm8swSZqmkpCGqZjq768ijFqmNA>
    <xmx:v_KIXns4wNbjkTYyC4-77KK52fsVTZNJcOI0pbXhfFLPU4vqehF2_Q>
    <xmx:v_KIXpiVepmvyARkPgFeksdSxhxfrOhhaj3Q1HNyO6BLykBi5NQJYA>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76D603280063;
        Sat,  4 Apr 2020 16:49:02 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH 3/3] arm64: allwinner: Enable Bluetooth and WiFi on sopine baseboard
Date:   Sat,  4 Apr 2020 13:48:50 -0700
Message-Id: <20200404204850.405050-3-alistair@alistair23.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200404204850.405050-1-alistair@alistair23.me>
References: <20200404204850.405050-1-alistair@alistair23.me>
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
 .../allwinner/sun50i-a64-sopine-baseboard.dts | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index 2f6ea9f3f6a2..5fd370b1e34e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
@@ -103,6 +103,16 @@ ext_rgmii_phy: ethernet-phy@1 {
 	};
 };
 
+&mmc1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	vmmc-supply = <&reg_dldo4>;
+	vqmmc-supply = <&reg_eldo1>;
+	non-removable;
+	bus-width = <4>;
+	status = "okay";
+};
+
 &mmc2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc2_pins>;
@@ -174,6 +184,20 @@ &uart0 {
 	status = "okay";
 };
 
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+	status = "okay";
+
+	bluetooth {
+		compatible = "realtek,rtl8723bs-bt";
+		reset-gpios = <&r_pio 0 4 GPIO_ACTIVE_LOW>; /* PL4 */
+		device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
+		host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
+		firmware-postfix = "pine64";
+	};
+};
+
 /* On Pi-2 connector */
 &uart2 {
 	pinctrl-names = "default";
-- 
2.25.1

