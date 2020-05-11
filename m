Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9478F1CDE38
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgEKPIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730376AbgEKPIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97818C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id m24so8797914wml.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=seBpYegPZMs/leR6JMfg7RpttvfOQmjhwYGL5XqCrl0ivqZ8SgNJfl5MrK6SNZU0x7
         s+P+5zxeVYMfWsvU+TruIPRs58u2N7gNKpF12dehHxew8uZn0wyQlXvRs81sH/cUAU/A
         kDiLytEcupQFinP/tSVSDYeJHqjKGk/S/swcSaT9uPiZDBURaYvEzFY1KQfq187G//Gn
         fP7p4AVjZ9rbwczBJGBw15zMRSFOqPTKu+IA1dWJoqAajrlxLUjrFo00xOd0Oskl6NXS
         vFI181kFNL42vS94eYWzxhtiRzUpW9BwFO6iLc+Bp3c1tgfqYpiA57PqAjvUSUmXKZ85
         b5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=ShJqbEiVEQiEDJw71tlUtYrvt6QdCFMEPIqG54iin47mKh5TSUqvMh1FksbzfTfGtO
         cWlgf8x7QMcXKWBXYy2PIglu7RZxmYaDP0cwmvia7o6jM1r79SOqsFiTCBv4dvgx0o+8
         ZF7vZf84J/SHY0glKoPQ+rgC2GJj1xAPfYKFrYYHqNDy+3aQs4/huIBmXUzzVgTS7P1T
         YQik06jsHu3f3Tijfinytp2t5kT26VcSNmTwJ6i7mGj2x++9PYeTZWKweX1UVHHDVCOF
         wdDIvnAA0rC1TVYrExXxikmZ9DFvSQl4LxELUFbgXizgxjzSZluHhjqxVDahctCZryGf
         qKew==
X-Gm-Message-State: AGi0PuY6WvLYV+qw2iREIEXB7EvLIjHqEy28hTk3zHectIxe6OhgkdOs
        JN7yiMbDme/r796Kj7EC6HjnMQ==
X-Google-Smtp-Source: APiQypIPr9fJcUgRNwzXEgdam3rXk6Or+HXAPoKGbi/pvrOEjCYCARRhvNo55PBWgkqCWw6ysRwOhw==
X-Received: by 2002:a1c:2e91:: with SMTP id u139mr31309130wmu.18.1589209720425;
        Mon, 11 May 2020 08:08:40 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:39 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 14/14] ARM64: dts: mediatek: enable ethernet on pumpkin boards
Date:   Mon, 11 May 2020 17:07:59 +0200
Message-Id: <20200511150759.18766-15-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add remaining properties to the ethernet node and enable it.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../boot/dts/mediatek/pumpkin-common.dtsi      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 4b1d5f69aba6..dfceffe6950a 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -167,6 +167,24 @@ &uart0 {
 	status = "okay";
 };
 
+&ethernet {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_pins_default>;
+	phy-handle = <&eth_phy>;
+	phy-mode = "rmii";
+	mac-address = [00 00 00 00 00 00];
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		eth_phy: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
 &usb0 {
 	status = "okay";
 	dr_mode = "peripheral";
-- 
2.25.0

