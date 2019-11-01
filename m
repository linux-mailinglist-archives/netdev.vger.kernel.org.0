Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB59EC36A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKANCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42641 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKANCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:34 -0400
Received: by mail-lf1-f67.google.com with SMTP id z12so7175164lfj.9
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWrGmW+JKfE+kYfM3N9oChJLu02yWLmRgyqdy1iXI+Y=;
        b=zPuFRVJFf0nZV1hHZgd/tJ25N032iYOUBU/EDromfHD8lfw/iOGoTgArGujay2ZHph
         08ejTwvWXxXD3Kt1EOpeBQ1mzpV1sX5gid7mDVtgIcvQLBMIOzNvz1+/GX8tk3hTxf6e
         0xfQbjMhmHrhQOMkxbMCEZKna8lAHv5EwZwai3tToi4N/IR8op+iQWJtmZ/dswzQfkEo
         F+0yR/Hlay4H4JrRLk/tDUkUirVAV0a9TBuvTh1t9VAsGoSmSnKMOHiK90/l9chuoc3y
         KBHSHtRUjaIT8jFhQr6iNrSWW+zFh8URcHNqItgR3m20fl33FhxvXOv+xZB2F+FoIHYh
         a+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWrGmW+JKfE+kYfM3N9oChJLu02yWLmRgyqdy1iXI+Y=;
        b=akatH+obobldXIllxK4826yb7VyyyfIvRIEcT2X0c8ftecGqUcndJQnW1OC1l5/d52
         szYPKXiEAVIwdzyeBFW2RcWz0WXSkcyoRg1bkEQb072q18cfj8LhjuHesyHXAZBixdc1
         fq8Uoh35DWUBCx8xzB4tquCghXtdJTveMtkGbhS12ByonNrEy3pWAd+5i59oghuwiPbB
         KijXIa8VP0p1XU8v4sPAfjhYbvQwldJvPios4nSR2qnLN37HWca8r2AS2+asRjlFzDMP
         JrjZV+dB8frxpbm5boWcl8Tzec/6gstA5N8Bgf3ohK3wW649FkCT1YTc2B+jXeXtV00u
         67BA==
X-Gm-Message-State: APjAAAXUpiPxvYc87P/wu7sb/r5potuYt3g0Cv2+/klXN8GRI5UxMzzN
        oQNFfFPJBJn1JbF7NOqwY2Ml9x31g58uRQ==
X-Google-Smtp-Source: APXvYqyx9xCsIqhZGzBB+hiusl/KzyGGof21JXoBcuFzjOGWBuiLu94lAfVtAluBBvQMsdqp/JPCqA==
X-Received: by 2002:a19:da1a:: with SMTP id r26mr1536302lfg.60.1572613351412;
        Fri, 01 Nov 2019 06:02:31 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:30 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 01/10 v2] wan: ixp4xx_hss: fix compile-testing on 64-bit
Date:   Fri,  1 Nov 2019 14:02:15 +0100
Message-Id: <20191101130224.7964-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
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

