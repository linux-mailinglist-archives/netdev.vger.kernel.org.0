Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419A113861E
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbgALMFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:00 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44343 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALMFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:00 -0500
Received: by mail-lj1-f194.google.com with SMTP id u71so6894802lje.11
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EODcaJRQXmFcyQ4tIXq+nJE+xf1l1Q4c7kVyoIFc93g=;
        b=XQZ+u6huv+xQkWR+C8jCna/YUqnMFqIyCSDPPfIuUDOAiBdUlK5OxHnIeEVVSxSIll
         qQAxCxTY77/x6alkhIVxWS93V22fiKDnuc6DZ0j4C0LkCnYPZ/SrVOK/ffo9z04ZMPHI
         DvDiA3h0PCL3xRLmaxbftaZNOATdc3P3zNmpD6dc/IkZpSy59UVlzJEYyNdu6zR9Hmca
         YErkpfD22aKGfoh6L9m8P0JBKuZJHHmltZbV42g1e/1ORNbjBXYMz6eX37fHrVvLYvbN
         kpFS57pCkkNw9XDdpLU9wDjEmkxUTZsBXZYEainJfJJN3GdV3NSmCj+yfm2PbHBD2POJ
         sGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EODcaJRQXmFcyQ4tIXq+nJE+xf1l1Q4c7kVyoIFc93g=;
        b=aXtg+kJ0CG97oLV36yROZm6+nSC9JgCkk58BDkgvCW31Rw0gZ/QFhN/4v2auvSoXi/
         g29DMZvuuOPHi5Wr4oGED5+ixbfOGoF4W6YaBjozRkEykrBHFD8HEDUomjOSTRWeLSiB
         tZWAo7B97I23dr6c5v6/zzYBmvSTZ/WY0AzBZr0VtcSNeSK5ffwEL+qAiDJ7NMEGgOSr
         yPCwZkCpXRWrzmVozA8trxMq3QoI7CFeOSj37G5UNtCv3ec9c9C+hINNQgV8sFxrHlVg
         YBe1dR4S4A1xAWoPcd1WXEVl0Y/1ab8FLUuKBUJ0TD0zQVnwLuCoa8irSa1JRLwLc9ON
         RAWA==
X-Gm-Message-State: APjAAAXdyoUFojpPz3dGTM85HEhCJ1/puVcVOBVtaqZ2Bbc679OG2Pyc
        ccozXXLm6Ml/67OVKTl7beJ0L0aX+cnUAA==
X-Google-Smtp-Source: APXvYqynqMBKG/Ov+XJA4meaHup9OgY3q0C6CJnz1dZuMUgPGSqzBdTn7Z9SRmHPkjWFVcOffsoVfA==
X-Received: by 2002:a2e:9510:: with SMTP id f16mr7689048ljh.249.1578830697801;
        Sun, 12 Jan 2020 04:04:57 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:04:57 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/9 v5] wan: ixp4xx_hss: fix compile-testing on 64-bit
Date:   Sun, 12 Jan 2020 13:04:42 +0100
Message-Id: <20200112120450.11874-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
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
ChangeLog v4->v5:
- Renase onto the net-next tree
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

