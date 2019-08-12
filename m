Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03461895B8
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 05:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHLDNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 23:13:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40355 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHLDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 23:13:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so4205184wrl.7;
        Sun, 11 Aug 2019 20:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+9TcJmCyP6rN2U8Lg8Wc8otcBPuVICv1EHiB5XYncw=;
        b=j+S+ynAHfG+mHqqkndQTqxRqucCRT8etd2uvxE/pIfl8kdR2BYygV2CDldbsgIWruv
         veBtNyhOaZJylCqX7Aal3EPTfXN+2QEGTtJAPU5E+6JFABMbCouiHaf7Q2GgsAXwXxuW
         LFNq8iRKzUlKicAUdDl6LL/CfJZdLSWZ8xktA1nPk3P9fTwPtRB3Llw2QSzg2t8mn8JN
         7FA9KCDQ+D4qGsx+OjiImP2OsVgpgwqXpZWFrE5MEyDfoOVTKro07f4u96Bhl4P+kjaN
         zRhnE7JJaxgbOBBscxRvTpnsbPcX9wylER3ZMZM86o9GtVH8COTO01+Jq2HQ+ie65x/5
         seMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+9TcJmCyP6rN2U8Lg8Wc8otcBPuVICv1EHiB5XYncw=;
        b=lqAnJZs4tRNWJhZFmGJw5HMOf4DXSsx7Hy0zAIdCLg7wuIRfR25TfGoVFcwY/6S/xl
         rsGYphiyHthoCTTkToCq8D/8Esz8xJNBZtEDnFU8JxMyCp82FXUoFHVfMFjyRse38bhV
         SKY6R7YGdsQJpXMcLQki3AjEmBeccQR56TGQ0sg1Hs3MlL4cjKCS3ASOLiNlhm8VERRF
         /kEDmx8WF6IyMYoReEXqqNF1M2AwrYR7bRpwdRA9skT7EZehsdEdwkSHgUJ4NMmgAFno
         271Byw7e9W7L6VcFCWfqzV+ZhVYWuzNkyopR6qxhQuQfj3T55yNkcKzJR7ekwzY9YNRf
         bVgA==
X-Gm-Message-State: APjAAAU11pTiz+Mess6NDjKwId3A2CB+YgPPFH3yzur4aPI0WLW3G70j
        mMMNG1VCfjthUaxH6HTh4n7pi8knNDM=
X-Google-Smtp-Source: APXvYqxLeh1TjWK8tS0O9f6DOvpumrK5nSykgEUH/NO/+RxtZNeI1nm8mgr/XAT4X5fVNyyAOLKkdA==
X-Received: by 2002:adf:e504:: with SMTP id j4mr37234678wrm.222.1565579632024;
        Sun, 11 Aug 2019 20:13:52 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id x20sm229783183wrg.10.2019.08.11.20.13.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 11 Aug 2019 20:13:51 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx
Date:   Sun, 11 Aug 2019 20:13:45 -0700
Message-Id: <20190812031345.41157-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0.rc2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

drivers/net/ethernet/toshiba/tc35815.c:1507:30: warning: use of logical
'&&' with constant operand [-Wconstant-logical-operand]
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                  ^  ~~~~~~~~~~~~
drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: use '&' for a
bitwise operation
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                  ^~
                                                  &
drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: remove constant to
silence this warning
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                 ~^~~~~~~~~~~~~~~
1 warning generated.

Explicitly check that NET_IP_ALIGN is not zero, which matches how this
is checked in other parts of the tree. Because NET_IP_ALIGN is a build
time constant, this check will be constant folded away during
optimization.

Fixes: 82a9928db560 ("tc35815: Enable StripCRC feature")
Link: https://github.com/ClangBuiltLinux/linux/issues/608
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/toshiba/tc35815.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 8479a440527b..12466a72cefc 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1504,7 +1504,7 @@ tc35815_rx(struct net_device *dev, int limit)
 			pci_unmap_single(lp->pci_dev,
 					 lp->rx_skbs[cur_bd].skb_dma,
 					 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
+			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN != 0)
 				memmove(skb->data, skb->data - NET_IP_ALIGN,
 					pkt_len);
 			data = skb_put(skb, pkt_len);
-- 
2.23.0.rc2

