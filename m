Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20DF3AAF6
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfFISGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:06:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38531 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbfFISGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so6885730wrs.5;
        Sun, 09 Jun 2019 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6l+94PYyR5Sk//+/Av+qY/UlCTL0ZemTkfdZsKsuI8=;
        b=SdWX2T5SmsidfZY0juvRr2RV/3P4zrsZFer61k+iFahxhK3NUrLNV7vJqaiiediw4R
         rcD5gjK4F36aGP9zl93OjqUlTqKa+yOuFb1zRg53a0+wk8GFvnBaH8M8tYUWFnkcMhES
         z6g3IjTPw7r0iQvIRiH4U10mEqwsFgh48Epr6t8L1JT2H0LP+CQmVdEwJdC9x/2+GFfe
         ovcWvCt7k9lSwAFW8Ms2DOuzngbf6sdjnjZzkBh4CFHgf+kYTWgHWQ8Lg8qcWOqPJ8R/
         CDsDEoFU29qpw66hFva8GSiCmvLelz82KUglM9YxxtwJTYRITd8hm+1Gx2C1LtklqYtl
         dWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6l+94PYyR5Sk//+/Av+qY/UlCTL0ZemTkfdZsKsuI8=;
        b=Oqo+yiyiaJuMcTrU6yY8aRC2r+10l3A50pKylkmDTeqG7paKFRVaXEsNlkONuY0a13
         Ih3O0XakNB3c5/1Ynf/2OOklvFRIH5gR4Q3/P4zGzCqnTrqakxOLRAPgK17L9xhOAm+X
         GDQHe2gnaFTKBGa4gTXElU/h92WAbQHerQ1h/Uh4bZp7DAq3N8i6JZFg763XKqJ79WOm
         7MAdoXgNA4cILjbdeL3x7jMwadFdg74xex9yXWnfAO4Gj4Kpesguy+G6lKzRrTpOoWyK
         yn6ZmwM9TxnftgyY9TYj2hPhvSmZo+pUxEINh0uRZX2w0IAAY1Xlqb6STPFwD+McolFF
         7QSw==
X-Gm-Message-State: APjAAAUxWEg0y7ThASdF5JogpkrV27LJ1NsFuzvfFnXyIA9s31LeAx2r
        jh4ZhLMlyOm01M7DJ14DEAzeiqd+
X-Google-Smtp-Source: APXvYqwvHItbEUzIdxb67KT8Bn7m2rjiaeTPe7nvO5ksWV2HWlyxwGJBfFo9q42FP5gCm25H0bJ3Yg==
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr7811983wrr.8.1560103602460;
        Sun, 09 Jun 2019 11:06:42 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:41 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 5/5] arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
Date:   Sun,  9 Jun 2019 20:06:21 +0200
Message-Id: <20190609180621.7607-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY reset line and interrupt line are swapped on the X96 Max
compared to the Odroid-N2 schematics. This means:
- GPIOZ_14 is the interrupt line (on the Odroid-N2 it's the reset line)
- GPIOZ_15 is the reset line (on the Odroid-N2 it's the interrupt line)

Also the GPIOZ_14 and GPIOZ_15 pins are special. The datasheet describes
that they are "3.3V input tolerant open drain (OD) output pins". This
means the GPIO controller can drive the output LOW to reset the PHY. To
release the reset it can only switch the pin to input mode. The output
cannot be driven HIGH for these pins.
This requires configuring the reset line as GPIO_OPEN_SOURCE because
otherwise the PHY will be stuck in "reset" state (because driving the
pin HIGH seeems to result in the same signal as driving it LOW).

Switch to GPIOZ_15 for the reset GPIO with the correct flags and drop
the "snps,reset-active-low" property as this is now encoded in the
GPIO_OPEN_SOURCE flag.

Fixes: 51d116557b2044 ("arm64: dts: meson-g12a-x96-max: Add Gigabit Ethernet Support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index 98bc56e650a0..c93b639679c0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -186,9 +186,8 @@
 	phy-mode = "rgmii";
 	phy-handle = <&external_phy>;
 	amlogic,tx-delay-ns = <2>;
-	snps,reset-gpio = <&gpio GPIOZ_14 0>;
+	snps,reset-gpio = <&gpio GPIOZ_15 GPIO_OPEN_SOURCE>;
 	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
 };
 
 &pwm_ef {
-- 
2.21.0

