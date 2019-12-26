Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4265D12AE82
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLZUhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:37:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54669 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfLZUhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:37:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so6623511wmj.4;
        Thu, 26 Dec 2019 12:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BlpoftZGGt5ZxOkzr3Ne9r9WJXqLw/2Ls5n+O9xqa34=;
        b=TXs0SardSpGDFiz51f0yVTJjcIODkle3g80fyVa23yKt5iYDgaTARfMq5JqsWOYcui
         I0JWzavDBYEDVd/pZWQffFwZitdT62trvturTiFl1DbZf8dNd9hbEtIYWe0R5YHeuu8f
         g0xpHZwRUmAQFuK5M23+3b6MnlvJJEw9u+1hhitRu51ByYFg777JWBBNPng3WUoMsUZ/
         cdtAKSaZwkU46Nt8w3SIojkAYAGmSsAYqcFeK0UM8Jnohtdd2BCMrnfM9+NJP6Y1/KmC
         8yhQAW8mu1n01I7STIjjolKGOsCSm4yjumqawxwTZChQpViGIZj0HDhu3C/XQOqADZls
         7T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BlpoftZGGt5ZxOkzr3Ne9r9WJXqLw/2Ls5n+O9xqa34=;
        b=rT3hfeIb1CcS7UcWg5/OTDiYXhHj0YBN/pBJd7ZRaKIqo7Ekbo8FQXH43XD7uIIGAc
         ud8BmhpK2M0Q7yzsAIZr/VygYBrPbafspbgiAxI2u6y22lBjqg9jm6/8tYJOqgHqFjus
         Xd3Ja5LTbGzvJAOcI9/LFknhDl97UrRUuQArBjWOEcWl03sRxl33EIUoGaafdxz6oeX9
         p++4wZelcSz9UZP8mbkdhyWN5Bg64MYRAag6hXXCao5H51F5HZMn8+xjoFeUBFfC3zDU
         4E/fihLFqLUw66D5/RizdYy8HUBwv8PP7EhFttMEhg5kFfcB9WZfqFG9e0Nz1RFU78c+
         5EZg==
X-Gm-Message-State: APjAAAWCy3JuZFnjyzZXWYIQxWYI+NwQsQAxbHoKPbMjKE5ztPCNfHfm
        XxGue7WB9yq6OtU8oRHAvH4=
X-Google-Smtp-Source: APXvYqxExgvLmz+gPYWg6NWhbJXHwBZLfEIvVZDWTQrIG6tV/S5JlL+7XfMsoQbMEZbc/nVRgwahbA==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr16019186wmk.68.1577392632618;
        Thu, 26 Dec 2019 12:37:12 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q3sm32911665wrn.33.2019.12.26.12.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 12:37:12 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, jianxin.pan@amlogic.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC v1 1/2] net: stmmac: dwmac-meson8b: use FIELD_PREP instead of open-coding it
Date:   Thu, 26 Dec 2019 21:36:54 +0100
Message-Id: <20191226203655.4046170-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
References: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use FIELD_PREP() to shift a value to the correct offset based on a
bitmask instead of open-coding the logic.
No functional changes.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 0e2fa14f1423..1483761ab1e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2016 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -32,7 +33,6 @@
 #define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
-#define PRG_ETH0_TXDLY_SHIFT		5
 #define PRG_ETH0_TXDLY_MASK		GENMASK(6, 5)
 
 /* divider for the result of m250_sel */
@@ -261,7 +261,8 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 					PRG_ETH0_INVERTED_RMII_CLK, 0);
 
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TXDLY_MASK,
-					tx_dly_val << PRG_ETH0_TXDLY_SHIFT);
+					FIELD_PREP(PRG_ETH0_TXDLY_MASK,
+						   tx_dly_val));
 
 		/* Configure the 125MHz RGMII TX clock, the IP block changes
 		 * the output automatically (= without us having to configure
-- 
2.24.1

