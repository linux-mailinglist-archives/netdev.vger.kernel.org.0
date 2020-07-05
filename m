Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F3D214F04
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgGETvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgGETvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 15:51:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69290C061794;
        Sun,  5 Jul 2020 12:51:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so10539794pgm.11;
        Sun, 05 Jul 2020 12:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1DM6xVZWZJvMpDAjz6LICmJeK1B/WJSbpsotDSZl8bo=;
        b=SPAw+UuKw/tc6ApBfi4rN3P+pttZynhKwUcVcFYKjqUkKctxLFn2VoCr3QEqTlxy5R
         djmSMDePYrzvTBaL/umG7PRUYgOxbs4YQ/m6cuXJJaNtYQQR16mIctgtJWtODWsHmraR
         0+BOXSMK0BcPHEjbXtycUdTyDmdqDnFR1DKlmc35OCN3YoRhkL3/Bq67iC1LLv6A/kHa
         hJ/GXUO0R6ruDn2rnEBGEnq4AUJQ22b9Kpb9yS8j017V61tVXi1bDChx/dA5yU/1EZjX
         M8VeCKdMKCOdiv8S7QzUWSUnx05TiL1CXExHk49vefmlzzmDMEwdA4rowrrPRElSyUZ1
         lloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1DM6xVZWZJvMpDAjz6LICmJeK1B/WJSbpsotDSZl8bo=;
        b=GUqKUCy6bszKGsl65awK7MVEjK9u4YnNWowyCnhsCaAKXOdbv70VhffXiKLLH0NY9o
         1d8gZDW3lUIUlTpmeSIpClT/7hqKNUnya19fCtm9JPKvOrOY8tyqXJvt24zlkVuvyb0y
         dmDUJ4c92tgAwjqB2E6K2JTWvGAskS/uF5o8djnzMI+p9LJ4dIyaKemcL3ZJbvqUYYJ+
         VpuIjH2oCpqOjbbOZgtMzYJJ46ZcLhZ4+n5BGpc0kHSjfaslXXFFiKN6T29T5SwK4Kvm
         JgW9ZNFoOH9WxP4NILiy1UjOh5PiPr1v72y4WXq8YZqV/zQQeWRF1VnfJHG3Hd4JP/+w
         YLFQ==
X-Gm-Message-State: AOAM533ZhvgVddogdm04NAWznHjU0t1nfAUjTjpUDvvjx1yRSNnw3ajg
        VsAo6+jEDLelpVkZrNdB7PM=
X-Google-Smtp-Source: ABdhPJywhEIbbZJi+sfs9qoPVmo6wP+zmVvWXONJnb9edBcUmKAyA7A9x6PsWAfDc8TF7Hc/tKx3Vg==
X-Received: by 2002:a65:5c08:: with SMTP id u8mr7911082pgr.184.1593978693025;
        Sun, 05 Jul 2020 12:51:33 -0700 (PDT)
Received: from anarsoul-thinkpad.lan (216-71-213-236.dyn.novuscom.net. [216.71.213.236])
        by smtp.gmail.com with ESMTPSA id g9sm16072879pfm.151.2020.07.05.12.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 12:51:32 -0700 (PDT)
From:   Vasily Khoruzhick <anarsoul@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 3/3] arm64: allwinner: a64: enable Bluetooth On Pinebook
Date:   Sun,  5 Jul 2020 12:51:10 -0700
Message-Id: <20200705195110.405139-4-anarsoul@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705195110.405139-1-anarsoul@gmail.com>
References: <20200705195110.405139-1-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pinebook has an RTL8723CS WiFi + BT chip, BT is connected to UART1
and uses PL5 as device wake GPIO, PL6 as host wake GPIO the I2C
controlling signals are connected to R_I2C bus.

Enable it in the device tree.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 .../arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
index 64b1c54f87c0..e63ff271be4e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -408,6 +408,18 @@ &uart0 {
 	status = "okay";
 };
 
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
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
2.27.0

