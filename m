Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA463D23
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfGIVOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:14:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55135 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:14:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so183573wme.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 14:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BVgDE9EsWjVM3bqmvwfPChhBvjPtL3gYpX7TM72N+sA=;
        b=EXZ1HQzbMDtPfA7Q8fsaHbaNfjIsYBwDpX1G8PimVAvWnYbr84zWuKBsFtSrLS2tyi
         5LAwHMGTe8hP1/FGpZfT2s8M/tkzrIyf1KJRNhOm1oqfwJW4nUNliSkn2tHhlTHLuMJS
         cBDigzkXdOduUdsNcImmkbY+8zOLSsfVqemhAULeDCglwo/li9g3sG4tBIp+ZmO4aqdb
         Rr5x5Ae4Z8EGqMSGpbg2fkeiwRh08vm/O/yxMX4saDRlgdr/+HXxtwYD3ot+11jwLoVM
         1H7psQJD2JhqvMWTw3NmDCqTlW11fPSqqOmEkYzKACp4TP9p7QZuiX92D/HceWbIbicb
         bJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BVgDE9EsWjVM3bqmvwfPChhBvjPtL3gYpX7TM72N+sA=;
        b=GT8Wi46kGuXM6RfOTPOX5O6Y9lzMddADw7d2HWJGw3tZ7YhahQvTnPnae0dzlEyV+k
         1fy0Lcp8Jsg9k0IWbqLqywg9DZA2//k5pUmt695llfGEV/cwp7EegxTJr+x8tbpllmW2
         ow7bW6Z9zHI89ZYNc+5LG65CFtdxm+pByAL0bBpMSoIi3LsYImZL4a+8UG1OrRmELqUS
         8UX3pTJBgQ7YVnZKtmYp2MnvHWTYD56WVPayo1TFp5L1ZpqEskFNPK+ieYkBwQiPExsA
         CC+1LId5YeiuBmK5t8Y+jRupD+GmFsy0EvXrtZJP5iLiEkFa6G/25TF82r9oDCnKG9fh
         4r2g==
X-Gm-Message-State: APjAAAVlIyiwRUJfSrInpupAAKVEAKfOhRU+7Vcu2BrMi+qmNoak3rRJ
        f2Q34qLffoC1ZtHzYbfdo9VyrP0aiFM=
X-Google-Smtp-Source: APXvYqy7d1dJyPel1KIKxwO4ud8wmCRmI5B7t6ZJUcw84VG5XuawWW5hQibNYuZTSbTgrmbzF0MWuw==
X-Received: by 2002:a1c:a5c2:: with SMTP id o185mr1416602wme.172.1562706892283;
        Tue, 09 Jul 2019 14:14:52 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id c1sm51464wrh.1.2019.07.09.14.14.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 14:14:51 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 1/2] net: netsec: remove superfluous if statement
Date:   Wed, 10 Jul 2019 00:14:48 +0300
Message-Id: <1562706889-15471-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While freeing tx buffers the memory has to be unmapped if the packet was
an skb or was used for .ndo_xdp_xmit using the same arguments. Get rid
of the unneeded extra 'else if' statement

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index c3a4f86f56ee..7f9280f1fb28 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -654,12 +654,12 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 		eop = (entry->attr >> NETSEC_TX_LAST) & 1;
 		dma_rmb();
 
-		if (desc->buf_type == TYPE_NETSEC_SKB)
+		/* if buf_type is either TYPE_NETSEC_SKB or
+		 * TYPE_NETSEC_XDP_NDO we mapped it
+		 */
+		if (desc->buf_type != TYPE_NETSEC_XDP_TX)
 			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
 					 DMA_TO_DEVICE);
-		else if (desc->buf_type == TYPE_NETSEC_XDP_NDO)
-			dma_unmap_single(priv->dev, desc->dma_addr,
-					 desc->len, DMA_TO_DEVICE);
 
 		if (!eop)
 			goto next;
-- 
2.20.1

