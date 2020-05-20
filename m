Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533F51DB189
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgETL0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgETLZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F083C08C5C3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w64so2462222wmg.4
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=gskof8By63+0KDD0DdUs0emDDhPZad4DsU+WhXpPPj2iCFcQBV8IAhix7s9OuBI8sF
         FviIaCv4wlLAN0CX1SzhYWJ+ytJkU63OctfconMXzNUhgqh7/eP3s0pp6d2lO6riWM5i
         QzEFy9o8v3BFNvOjfiNOt7hPupLGEitK5tSVjVytErQ0Uf4A6a6Cc6pqURjYroF0xGFj
         JXLWZ7fMxCFLTDWF239HN5D+wphw1HGN5u0IEseg2S4FYh+M38w8DPk/n7Xn2jIWWb80
         laDuvRZpyjA5gIkZnU/Sp7NnoG+Nl+P6F1Pm0n4hY2wZEewn93GLh3Fo9KXPaRRgL/g/
         NHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=libeA0ehvEVHeattuxNCDJj+HK3TX7INLd4GEhACzafTscx+Z4cMR1MJdY3jt9MUVD
         6ModWYVXnVvs4/TfB9zHzmWeIH4Q0la/uITbj/EbEI+MgsQYDRi7n5x1H2iO5716EJD+
         8kqiBWJWPRUiBIxwk8+MZoiuv8Aq5lH2ZFFT4kIZH8R1RBMQg48j600pmuzxTt+FYvqb
         OjtvHN94Zzey23MZh3U91SmkpLwNOck6Hi6E+iEMTmJyA8kheU+JK47KsfvJqZ5/0Phq
         czp4m5osR6vkPpopbeLGuTGYMcYkbq8uSKGxAyUwaLiDu0pxlX+evoPIy0l8Deo2aLZj
         +r3w==
X-Gm-Message-State: AOAM530yUTAW39JSdsl/6+zZQiZGZSGuuzfbnaM45ERkGi9R8pf0OsqU
        RqpmymYcQ+hVJXhyLYKdqMnaYg==
X-Google-Smtp-Source: ABdhPJz0ZhvCEVA3BYC4i510rBDYS5vNUPdwWlMfTD8jHQeyLe6hAQkKC4vL1pXZbA/yRsghalkFmw==
X-Received: by 2002:a1c:b60b:: with SMTP id g11mr4282669wmf.49.1589973947229;
        Wed, 20 May 2020 04:25:47 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:46 -0700 (PDT)
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
Subject: [PATCH v4 10/11] ARM64: dts: mediatek: add ethernet pins for pumpkin boards
Date:   Wed, 20 May 2020 13:25:22 +0200
Message-Id: <20200520112523.30995-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520112523.30995-1-brgl@bgdev.pl>
References: <20200520112523.30995-1-brgl@bgdev.pl>
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

