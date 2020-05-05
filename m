Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34A1C57DB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgEEODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729389AbgEEODU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EF2C061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so2492480wml.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=lSlyl4mOElbeeStRAJ4CWke7R4swrfRTDDvLBAB45QOvM4+7cfviB8IS+q8YjTZ9ER
         J/ERsLiOQHNV1mTXN3jPp9K18esFG4ne5yM9GcYpMm01CSVnE/W734lRVikO4BAQNJfp
         NIJ0jLuZD/AMpS3Co94mCUYYzA7Mbr3GSRHF0qswguqdE/7M72H1HNornTVQfgBDvMBf
         J2lJdqjGdfJQJZaUMRQJG+LjJd44f4bKZ6cbr2NR816aGdFW5ioRRvqPprprQr5Q4qDe
         0CAUeW3L2CkjgSaKgHc1XyVKlBJjesE4lOuflOL1uJe3/07Mw43PRohiyBdxf3FGLcgj
         LT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=Y/7JYutjsYIB0frKG+9ONLJEJ/jUwqiguP/09xlRtrlCdY2qJK/KZGe4YwmWs1Nfox
         LvMtkVF6Hf8J+Hxj/xD8qg8Guo6z3ulaWUbx9hnzfO9iBcoMPGway90cEp0pp5Vl1lr/
         THsXddOHMXSxRgv3uj9skSPiAblZTOc3XTLNqhqs041w4ui+ScBbfyZl19Gok/Q93LIj
         QN96Idr5gmWa98GhzcAZoJbeg16/HoHb/iWRu+fDSUrw6qqsYJ3isGdGLSIVNj7la7m3
         acD96tFdCknayJaqWkkVLsudoBy0kBFOK/9X2yV+0iF2qZgDM0VABLPxNNMIL+jibMLz
         31mA==
X-Gm-Message-State: AGi0PuaSOxuvNpPOEaV5q8ud+l6ncPUgjpZBiXU0FqwHTCwCMZBXO8f3
        fJXInMENObmpuOaV5Ea0HiOpbQ==
X-Google-Smtp-Source: APiQypKwmZMdeEmUAzcUU4K0jiEpe5kHCS1F6NfZ1/9dSidf/8PeL2h2zvcjETlSxePjjPJCHSUbNA==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr3689658wme.139.1588687398732;
        Tue, 05 May 2020 07:03:18 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:18 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 10/11] ARM64: dts: mediatek: add ethernet pins for pumpkin boards
Date:   Tue,  5 May 2020 16:02:30 +0200
Message-Id: <20200505140231.16600-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Setup the pin control for the Ethernet MAC.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 97d9b000c37e..4b1d5f69aba6 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -219,4 +219,19 @@ gpio_mux_int_n_pin {
 			bias-pull-up;
 		};
 	};
+
+	ethernet_pins_default: ethernet {
+		pins_ethernet {
+			pinmux = <MT8516_PIN_0_EINT0__FUNC_EXT_TXD0>,
+				 <MT8516_PIN_1_EINT1__FUNC_EXT_TXD1>,
+				 <MT8516_PIN_5_EINT5__FUNC_EXT_RXER>,
+				 <MT8516_PIN_6_EINT6__FUNC_EXT_RXC>,
+				 <MT8516_PIN_7_EINT7__FUNC_EXT_RXDV>,
+				 <MT8516_PIN_8_EINT8__FUNC_EXT_RXD0>,
+				 <MT8516_PIN_9_EINT9__FUNC_EXT_RXD1>,
+				 <MT8516_PIN_12_EINT12__FUNC_EXT_TXEN>,
+				 <MT8516_PIN_38_MRG_DI__FUNC_EXT_MDIO>,
+				 <MT8516_PIN_39_MRG_DO__FUNC_EXT_MDC>;
+		};
+	};
 };
-- 
2.25.0

