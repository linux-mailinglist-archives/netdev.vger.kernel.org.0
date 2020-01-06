Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D349130E1F
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgAFHq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:46:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42602 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAFHqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:46:54 -0500
Received: by mail-lj1-f194.google.com with SMTP id y4so35624868ljj.9
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 23:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e685hBrrlZX2mjYfufkypUT+yx3nY8NJkE+aCQS1zME=;
        b=tbgYq+guXXfQe5u/vSIhiR8s8P8iNXqW11yHQtSvDaSlayBjMaxceCuSMFrwtOQGPZ
         +4iIfumxroBc6h91oHJqcUK4tKNhNKbEvKW+OcCYJItXdKfptWX8djMXetXvhFga/qTJ
         ZcEGmYA8CC22mKGavO67hoDabagp3XGL9LV5TNGxU0A1L4h29r2QQAi9lkMPysD7c/Fy
         mH9jnN20/caj46wkhoDFbREdKjJFcTfs16XnLiZ/puObltr/m1wQV5/rPEVm9+wARzYp
         SWLQhd0wJufCwQJj3aftOsOMTpxgqSrEJGUwjktkG9vYzHsjqQ64wPCzQfi0Zi607ovh
         QKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e685hBrrlZX2mjYfufkypUT+yx3nY8NJkE+aCQS1zME=;
        b=UYF6xEjUbnMX2dXkFMARRb3wEoznumN8MyvSdBjEGjNvdFHHrIfnuahx5hWiSZdMpX
         HrZ9aWlEAfHUArF93lXxXitbZYgQu1EubR6vOv7A5vHamA+ARZ8Hfta9qz06oM/y7IjQ
         Iz+GWQr7O7uJyMdi8icO2SZYwAd54xHKmPgm3KS/4w2pNQ6aMz44L0r9UJ1Pv8/7BpzA
         PQSR/8wb6v3rufhMHv9UZOUt8h6z/bPsM+2esCFa0ra/IJ7AHV0B5jEyOAJzSX8+QZGh
         QPrjfMb8Rsr4wq/zEZd3k3cKa7iw87xYudeS9YrVmgIRaBjkdc/yD2R5OIznCk9rTNEi
         dCNQ==
X-Gm-Message-State: APjAAAWeITTba4JuNYIo8vYKtg5AutWqlPl6PFoN1CtBD5kT+l4OZd9+
        reGooiKkb5d2ZDOuvV7uX+tDZZRu6OlEDQ==
X-Google-Smtp-Source: APXvYqxvlezhFGg8rT+D9hs2cZQBPb1r6nf1+tPXrgb5RUZkfW4tuQMc5bpVmOLw8n4VxDVYbQm48Q==
X-Received: by 2002:a2e:7009:: with SMTP id l9mr59867887ljc.96.1578296812975;
        Sun, 05 Jan 2020 23:46:52 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id n14sm28625551lfe.5.2020.01.05.23.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 23:46:52 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/9 v3] wan: ixp4xx_hss: fix compile-testing on 64-bit
Date:   Mon,  6 Jan 2020 08:46:39 +0100
Message-Id: <20200106074647.23771-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200106074647.23771-1-linus.walleij@linaro.org>
References: <20200106074647.23771-1-linus.walleij@linaro.org>
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
ChanegLog v2->v3:
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

