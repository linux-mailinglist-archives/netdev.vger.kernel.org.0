Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF6ADE160
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfJUAKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40513 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id i15so1128614lfo.7
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hqHu8s6QOiWYaaMGUw3zthI3ATM9j5J6bRTqf/L3OEI=;
        b=hdofXcDzV9c8/JVe9WftNKsBEY6LkDmAQNJT/1p4gbRDFU+akneahydrCfADj8Es/e
         lVLhXdvqDvBvDiX8kc/oKeQ5aX6Rp8C7JB0cHiyp4Xc58rztjUedgdFU13RPvUzvZ8uZ
         ts06KN1/FeNJD1PTTnoHoovWx0EDziysM13WaUxQ+TRcM+whYLQrInjXdjTv3sApPMi+
         0CgwRU3nO1n4TNFRmOaY44gYMtHGGjeKZ0Ve5cGxkNl/fg6JQVNbwfx4wcEV+DFxXzHB
         9ZZsfF8sT2GeOMfW4lePZFK/L/A5SkX7RKph0M6BA4XVJ8jckL5+YTbH7f7TFWp9JFEZ
         kDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hqHu8s6QOiWYaaMGUw3zthI3ATM9j5J6bRTqf/L3OEI=;
        b=i2+Ig7as3VBB6ma31zDfzm9Zm/4NUEokht72Uf62dBBhPc5JC2OFz3TwCl+iHdeLvN
         bE0KKfSQqO6o1RtsIfx0Ja6ttBbbVmSE5plWdvVprOnZr1NIVum985dwti/Tfe21XBKh
         3zFSfuLf2oqAzVTCxGlQ8jUhEcvWRlBDPeSWlGceKaaSeuQ1ndY62tQeO3G+CKfkrnAu
         kJnVZU55GoOncha5G6OcL74CshiirXde0XsML4UhAI2lFRHX/AuACJ9IamXmc876RWVt
         oeLyJySN0eZZMNeSAh6OorDMAAanLJtcSGn5+COxJBC+la4c2GnI9IN4tGMhY1Sn2/69
         SJzg==
X-Gm-Message-State: APjAAAW8rhRfzy2vQ/b+SmIbLZmTrEI75W5uLOJt4kyvdpV4ggHXFy0M
        VK4r2bXijlL51wk3msgSoDlwqWmqvww=
X-Google-Smtp-Source: APXvYqxXtqVlWyN4byonn5oSvGkwTTS1xhBPcYcyvmc9GHtik6xQPj+ToZ+mlV6he/M3u0sjPiX31Q==
X-Received: by 2002:a19:4f0b:: with SMTP id d11mr2288071lfb.51.1571616600131;
        Sun, 20 Oct 2019 17:10:00 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:09:55 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/10] wan: ixp4xx_hss: fix compile-testing on 64-bit
Date:   Mon, 21 Oct 2019 02:08:15 +0200
Message-Id: <20191021000824.531-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
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

