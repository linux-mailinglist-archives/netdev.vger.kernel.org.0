Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8F1A06DF
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgDGF6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:58:50 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47509 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbgDGF6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:58:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6806B58030C;
        Tue,  7 Apr 2020 01:58:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Apr 2020 01:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=j0hiybRWpWmn4
        RFlXkM4Nvl4eLWofEJym1lENDbvopU=; b=fzFRDfdn9v8eMnVl8iT7MynBqAS7Z
        okMUoO2leumP0WFnxOmlJN0ax8p0/tDS/H/BeAKje4ULvIe6sfO6vVMY1TYLSONZ
        BlQBJ5o+QXvNRU0UixXbFxKDf4oxpgPwmQ+RJ6wrkKi1T1Loo1FMiaY975GwutbO
        C1fL+AWFxL3Ox7Bd+tdQaibXuLjvoM495YCZA4n0iZVWBNGti6c854Ik0d8uvKoi
        AYMMiNff+1cHb4C7Qbpe3K5mqraDf2tnp5dxDxceKFHKB6kHw6cNHJDWX1sg26+E
        29pCKYZcpMdVWJoIwnD1lUHF62RrCKCiRDwIuZ14ua7ig6suAX87PBocA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=j0hiybRWpWmn4RFlXkM4Nvl4eLWofEJym1lENDbvopU=; b=RZ3NC15S
        6n2oFqaKn8j1/5yiru9oXGDSqQlt6pAoqUNX8YlDUL0eyiGG0qPkdeoHq1MEy0bK
        8qE5uR3lIOHfWZq3zRProqQxvm2YphnnwtNxgsmdhGTNxYPciYTRM5xUBhrTFa7V
        jCEtD0029ZuWAGTmzjOytKXs70lk5lrjnTLlFghTITzy27zkuptxYqCYX71Se030
        qOc+gBbIaHdeCvb/GnEtflhJCTFY3NpNko/bBsIv3S59MsrBd2CTHuIehXwdB39l
        oUnf5vpSIpGKCubiKYZaEk/+Rw+yy2KPzUE+LkVeLOV1uEFroMrINIlaJPLpbIvf
        dOYN1j6MHQj0IQ==
X-ME-Sender: <xms:lxaMXvsmFnSGvBb0DBILmQD_iruZgzBOoaorzpbJIwKkc7vXqGJI6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghi
    rhesrghlihhsthgrihhrvdefrdhmvgeqnecukfhppeejfedrleefrdekgedrvddtkeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishht
    rghirhesrghlihhsthgrihhrvdefrdhmvg
X-ME-Proxy: <xmx:lxaMXjfRdmjaeSUQ-_foCoeQEjT2DUq9cH7API2izHpdw6phnOaPbA>
    <xmx:lxaMXuaARqcMIIPBjAvGULjtqfWrXT3n9beNUjY97zebZmt0sKE1AQ>
    <xmx:lxaMXs4QoxsT-W4VJYbB8KXl4oiHzjWccqlmTOLkCiWDinjxWS_2XA>
    <xmx:mBaMXtFfF4rIiaxzDaVxIs6NYgvNgVVRa9caWph7Nazh_511BZ0W-Q>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 738AC3280064;
        Tue,  7 Apr 2020 01:58:46 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v2 3/3] arm64: allwinner: Enable Bluetooth and WiFi on sopine baseboard
Date:   Mon,  6 Apr 2020 22:58:37 -0700
Message-Id: <20200407055837.3508017-3-alistair@alistair23.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200407055837.3508017-1-alistair@alistair23.me>
References: <20200407055837.3508017-1-alistair@alistair23.me>
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
 .../allwinner/sun50i-a64-sopine-baseboard.dts | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
index 2f6ea9f3f6a2..f4be1bc56b07 100644
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
@@ -174,6 +184,19 @@ &uart0 {
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
2.25.1

