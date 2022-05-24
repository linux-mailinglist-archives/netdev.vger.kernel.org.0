Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7EB533313
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 23:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbiEXVkc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 May 2022 17:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiEXVkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 17:40:24 -0400
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD87CB1D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 14:40:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1653427343; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=kqM4+zIYq7/2DiNmY1b/2BUBM7CawdxeHcYf2GLk1PZ3EwHkzorjAsqoQa9il+fnqqrFtkHi1QLzQrdqtHUQeEeK5+bYmp2Tbw5Y0NX5Ire1Iavm4lZHDWZtcsCiMmkTpsGt4nr7cdTNAAG9LwgSSKFhKefrH6BT2poKaBKBSZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1653427343; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=p78ImhfqTFopguatUP5w6vRv8Q5bGiDPqYuQUSvDOYo=; 
        b=N78zQsuV7d3OmTg7HQwYpF2M6PEkJraykhYRvjXZvNGjklgzOs0FMDoOxReAN9Ia3JaisU9qFc47uE4DAwNP7EyAzckycdibreXlGIWBhv0DlOG+pQNuBzgM/zan3+VYdUFNbW3qpMXDDpPiUPBDSZDLQT+QqLTzwZo4M/orsVs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from localhost.localdomain (port-92-194-239-176.dynamic.as20676.net [92.194.239.176]) by mx.zoho.eu
        with SMTPS id 1653427342834591.1104242641796; Tue, 24 May 2022 23:22:22 +0200 (CEST)
From:   Bastian Germann <bage@debian.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Bastian Germann <bage@debian.org>
Message-ID: <20220524212155.16944-4-bage@debian.org>
Subject: [PATCH v2 3/3] arm64: allwinner: a64: enable Bluetooth On Pinebook
Date:   Tue, 24 May 2022 23:21:54 +0200
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220524212155.16944-1-bage@debian.org>
References: <20220524212155.16944-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

Pinebook has an RTL8723CS WiFi + BT chip, BT is connected to UART1
and uses PL5 as device wake GPIO, PL6 as host wake GPIO the I2C
controlling signals are connected to R_I2C bus.

Enable it in the device tree.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
[add uart-has-rtscts]
Signed-off-by: Bastian Germann <bage@debian.org>
---
 .../boot/dts/allwinner/sun50i-a64-pinebook.dts      | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
index 63571df24da4..70d823f8c837 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -406,6 +406,19 @@ &uart0 {
 	status = "okay";
 };
 
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+	uart-has-rtscts;
+	status = "okay";
+
+	bluetooth {
+		compatible = "realtek,rtl8723cs-bt";
+		device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_LOW>; /* PL5 */
+		host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
+	};
+};
+
 &usb_otg {
 	dr_mode = "host";
 };
-- 
2.36.1


