Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38761368F9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgAJI3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:30 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39189 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbgAJI3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:30 -0500
Received: by mail-lf1-f65.google.com with SMTP id y1so805257lfb.6
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dhuWFoLN+p/zW9CrUBh7lo8WyMSn75f3fT5RdnGMkpw=;
        b=k8KUTo3+/a8j1p7e1vMutnGVrS2UpyEGoz5HeZHhPmzRR8TGdo/Vw3ec/+mOl4xRWa
         lLNi2rEiI55sZa4w02Umxt/jvuUv+LxseviNlwjFu5eae7ry1W4P7FCOQSrRTgCenH9v
         f5IgrBYqv1oBEwiKPz8rOVgUvyXRycwnYob9PZxdj0biL233KqEnieKTw/YXKUGkWizZ
         WscDrv5iZhr/Zmgk7rC+oxvqiJdO5IPruG16akeXPnpgf/8y62fjll2OBfb8Wm6OCBhO
         PzWV16juKt56XQkQgKgRdZjxOJ3/9MPK+aRrJTRCVghYQAAWfInmYckQAnP0i2cUbGWX
         m4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dhuWFoLN+p/zW9CrUBh7lo8WyMSn75f3fT5RdnGMkpw=;
        b=DdjqWI9Y9Uk2VanrXTJkQXG+/Wmf2UMb0cpyzJcsco+BZ6eXA9djkt1cFQmzMVjLDb
         WGvMeVR7FsQL1RRfeMN2JsD/kAHmhD4AnPQr3rRjdATclT6auyJSg8NdLD/9kxOLmPst
         3AyebVuk03c7QokIhnwWYR+kVlPb7xdzkPLrzrgRHViN3J5ghD4pa4lhGwmAVUaQCOYx
         RENcSmINhfGu7tJwbw/FyFHeM7IO26vyac1nkvsTNa4cpvrjf/35n49K1Gnse1d9vetF
         iX6nsgICauHt99nXDyoO2yIGLLUKetB4epqkuWeUwyM1/Q3mQtE+9s9QsGDvE/ipihTQ
         g/0w==
X-Gm-Message-State: APjAAAV4cwsaJ/0U3PdGI8HHIYiG9/qlzRqdJmSC+DXfp/QJtmP1YTrT
        STj4SJoU8S2stirmsnc4fIyR882JuPurBQ==
X-Google-Smtp-Source: APXvYqwcDZ5YZlulFcUhud8askhKNoTgmO20ABf18AKXPogcog8fUA1uFY5jBhueYQikQE/DhzJEhA==
X-Received: by 2002:a19:c697:: with SMTP id w145mr1445216lff.54.1578644968247;
        Fri, 10 Jan 2020 00:29:28 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:27 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/9 v4] wan: ixp4xx_hss: fix compile-testing on 64-bit
Date:   Fri, 10 Jan 2020 09:28:29 +0100
Message-Id: <20200110082837.11473-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Change the driver to use portable integer types to avoid
warnings during compile testing:

drivers/net/wan/ixp4xx_hss.c:863:21: error: cast to 'u32 *' (aka 'unsigned int *') from smaller integer type 'int' [-Werror,-Wint-to-pointer-cast]
        memcpy_swab32(mem, (u32 *)((int)skb->data & ~3), bytes / 4);
                           ^
drivers/net/wan/ixp4xx_hss.c:979:12: error: incompatible pointer types passing 'u32 *' (aka 'unsigned int *') to parameter of type 'dma_addr_t *' (aka 'unsigned long long *') [-Werror,-Wincompatible-pointer-types]
                                              &port->desc_tab_phys)))
                                              ^~~~~~~~~~~~~~~~~~~~
include/linux/dmapool.h:27:20: note: passing argument to parameter 'handle' here
                     dma_addr_t *handle);
                                 ^

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Just resending with the rest
---
 drivers/net/wan/ixp4xx_hss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index ea6ee6a608ce..e7619cec978a 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -258,7 +258,7 @@ struct port {
 	struct hss_plat_info *plat;
 	buffer_t *rx_buff_tab[RX_DESCS], *tx_buff_tab[TX_DESCS];
 	struct desc *desc_tab;	/* coherent */
-	u32 desc_tab_phys;
+	dma_addr_t desc_tab_phys;
 	unsigned int id;
 	unsigned int clock_type, clock_rate, loopback;
 	unsigned int initialized, carrier;
@@ -858,7 +858,7 @@ static int hss_hdlc_xmit(struct sk_buff *skb, struct net_device *dev)
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
 	}
-	memcpy_swab32(mem, (u32 *)((int)skb->data & ~3), bytes / 4);
+	memcpy_swab32(mem, (u32 *)((uintptr_t)skb->data & ~3), bytes / 4);
 	dev_kfree_skb(skb);
 #endif
 
-- 
2.21.0

