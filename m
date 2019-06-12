Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB94312E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbfFLUzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:55:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44820 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388884AbfFLUzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:55:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id b17so18357769wrq.11;
        Wed, 12 Jun 2019 13:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0gOm2m0FcFm0g2Vu1nMDa1FWBplL205hnC9G0QkNJn4=;
        b=PVbTsHM8Lo4nt76wMAIAfEbubaSWW3E0Qj3br9RFOJ6iWLRfEpbZvMYz+C6raOn0xT
         sw31E9CscgBhseKPDD3i9rZp2WU3QwAK2IFDDBRokBOCBNtNmC5IyL2lgSyQm9F2b4K4
         3OpBJ7vO18UWVF2P28uS7uoXnBr2uI9fz9dcQhjC/QdNfUXEcdnu0BrN9CPBdG+aeP/2
         o6yCdljaT7Y/fsFWzTt38oUxqmkpAPhPiB1/byI6SRXwJD8viZbFoSYHbosr0twf5HPc
         e9g7QXByNlkzhzhHDHF34BHVPcjvOLA5QpY2P3xuwtkrdQnUasp3U3dpzRmQ4M55uyDg
         STbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0gOm2m0FcFm0g2Vu1nMDa1FWBplL205hnC9G0QkNJn4=;
        b=DGge9qH38V2XkoE/Xjo4Cz4YOdYJ/dVQcOtH8ghWjYJIxMaDhoSPrUPuTztM81zKNL
         MqIDh9ZRF7pl4YWz1EH3nr0OhBsIfDK+WJtTCAqBrloZ8rkgZrQ9/a/WebgwojDydZ1/
         liGGDzO/SpeBR06ihEKlh+nY0Ak3MJHMnG60toj1ZvGN7jsQn9PTkYtoq8xcx3Bz+9gA
         2WiBvMWOVV7RaRH/37xRnusg+K6vzisQpDJmJ24rQt1nvE4T490Ybouku5l5m0FCpRxb
         9e/DOLh4dNDRtiXDsUNowsKdbfDN+a5afaECXfmTWRc1dNU4EFQ1sWeyVhONGj7lPxsN
         4aWw==
X-Gm-Message-State: APjAAAX2dB0ZLPTBgYtKbHK7ET7CxboWvq475EBsztAmqWMAFJ7VrrjH
        2/DaaPFhUf+cvYVdJreErzY=
X-Google-Smtp-Source: APXvYqxJtE16FbiaSYF5C2/1//jLjeLpLRpC+YK6aMthR7a6zgoGvDdLPDxwxYUQjYo+eC0cvD7odQ==
X-Received: by 2002:adf:ce88:: with SMTP id r8mr5037854wrn.42.1560372946253;
        Wed, 12 Jun 2019 13:55:46 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33dd:a400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id s7sm3445793wmc.2.2019.06.12.13.55.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:55:45 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 1/4] arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
Date:   Wed, 12 Jun 2019 22:55:26 +0200
Message-Id: <20190612205529.19834-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
References: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Odroid-N2 schematics show that the following pins are used for the
reset and interrupt lines:
- GPIOZ_14 is the PHY interrupt line
- GPIOZ_15 is the PHY reset line

The GPIOZ_14 and GPIOZ_15 pins are special. The datasheet describes that
they are "3.3V input tolerant open drain (OD) output pins". This means
the GPIO controller can drive the output LOW to reset the PHY. To
release the reset it can only switch the pin to input mode. The output
cannot be driven HIGH for these pins.
This requires configuring the reset line as GPIO_OPEN_DRAIN because
otherwise the PHY will be stuck in "reset" state (because driving the
pin HIGH seems to result in the same signal as driving it LOW).

The reset line works together with a pull-up resistor (R143 in the
Odroid-N2 schematics). The SoC can drive GPIOZ_14 LOW to assert the PHY
reset. However, since the SoC can't drive the pin HIGH (to release the
reset) we switch the mode to INPUT and let the pull-up resistor take
care of driving the reset line HIGH.

Switch to GPIOZ_15 for the PHY reset line instead of using GPIOZ_14
(which actually is the interrupt line).
Move from the "snps" specific resets to the MDIO framework's
reset-gpios because only the latter honors the GPIO flags.
Use the GPIO flags (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN) to match with
the pull-up resistor because this will:
- drive the output LOW to reset the PHY (= active low)
- switch the pin to INPUT mode so the pull-up will take the PHY out of
  reset

Fixes: 51d116557b2044 ("arm64: dts: meson-g12a-x96-max: Add Gigabit Ethernet Support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index 98bc56e650a0..de58d7817836 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -176,6 +176,10 @@
 		reg = <0>;
 		max-speed = <1000>;
 		eee-broken-1000t;
+
+		reset-assert-us = <10000>;
+		reset-deassert-us = <30000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 	};
 };
 
@@ -186,9 +190,6 @@
 	phy-mode = "rgmii";
 	phy-handle = <&external_phy>;
 	amlogic,tx-delay-ns = <2>;
-	snps,reset-gpio = <&gpio GPIOZ_14 0>;
-	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
 };
 
 &pwm_ef {
-- 
2.22.0

