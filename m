Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C94F1DE631
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgEVMHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729726AbgEVMHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:37 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DD3C08C5C1
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:36 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so8418655wmb.4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=DVsXn2eYoFofqn541LZ4MfkWal+3Vy9fBdI9yAspaG2zAyqASOY0tqc4Nv4/+Bi62Z
         tUfQjSY+FHNzvALMKzVBCmTkLM740jnrTT30ToZZZzw5iGAWEdQKVrwkIiexpGELhLeO
         zrU088OFMx4gG4ErEwJxSrWOubMuE+9AUwAWJEOXRKSN2g6OXzZp/iTxw8DRAJlYedqz
         ngTmIuwLXT5hVEDSTz+QlHrw5qnO6fDzlZdtpPnREpOR9PzLcfhal6JyMl/WxmqcCCde
         fOpT0KAuZcee9ng8kIq8noqAJrKMD/yd0N+cE/pHu7NboS6Ct6ENqOoOjSo3cOcQ3Qx1
         gWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=HJL1F6xfQyGgxBRX0aiGQ5G00xSgzSfo0e48/tllflzo/RBdeAR1DEK+I/c7dEIZ8j
         cxYXJdepOIQbm9ft/c/bDExZk99HPId5JmBXEg93aqPHBNqnO7mcHk3gwyoMOHNeoHvA
         Wi3n/nTRZdyAaLJP/ufT5pSYZxeJnWsMY+HfE7hKOTP7eQinP9d6cTttoNa30z83drAw
         x6gRK4R4FX7gY3yrRpnusEgEnQrxRtkhRFk3xPf/wNKKWM1A0Hvf1DbSCobzXjeHb64b
         VHJDgFThAMbWcUlBDAPB6D2aXOAcmCC8EUMWGvoCrfzolNuS/ph5Gjh3wTabybEmoG0m
         JImg==
X-Gm-Message-State: AOAM530NPL8ioXzBShaN/JD79SchOt1KATAu63mTfVppp8i/WNUBKofp
        tKLgYmlcHjNS4jrMb7ybrnBtdA==
X-Google-Smtp-Source: ABdhPJy2dPeRTy6mlLX5UEd/lcC8TWwiaJ2T7GRkUXTF72jg1Gp3bgoI92xKzRbwpRCpK5LJsVLcOg==
X-Received: by 2002:a7b:c767:: with SMTP id x7mr13670227wmk.181.1590149254930;
        Fri, 22 May 2020 05:07:34 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:34 -0700 (PDT)
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
Subject: [PATCH v5 10/11] ARM64: dts: mediatek: add ethernet pins for pumpkin boards
Date:   Fri, 22 May 2020 14:06:59 +0200
Message-Id: <20200522120700.838-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
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

