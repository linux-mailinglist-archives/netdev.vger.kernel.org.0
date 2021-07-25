Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3DC3D4E24
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGYOKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 10:10:21 -0400
Received: from smtpbg128.qq.com ([106.55.201.39]:39141 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231128AbhGYOKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 10:10:20 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2021 10:10:19 EDT
X-QQ-mid: bizesmtp44t1627224156tk1hi3xv
Received: from localhost.localdomain (unknown [125.70.163.19])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 25 Jul 2021 22:42:34 +0800 (CST)
X-QQ-SSF: 0100000000800090B000B00A0000000
X-QQ-FEAT: 5gms5Di3ODilk7bZB1FAqNg7OrSrWZuX4IoQP5HGl6VzbmzPVkXoD7Y/1hmWv
        zVG0r+KHtjO767QifZNqHl0ccXJmBtpi8sqiUWs3bFUf+phU0RAwKIVZRfcZ/MFRDAF6C4e
        +uWBAIv54Mawpgm79M0bWp41cZ+4w9zRImrci9yZejpcMj9RsJTBp5ficv5VmlBLFv+4FU8
        AnkR2mbD4fhgOsnv9nasdUEraXrKzWYG5u3tl8dqUfAvpkgIJmmLZGP9LEq54+wwDa6kDzG
        IGZnpgFcVc5JWEMviQtu1wSnKdPM8/hfpsW17V15UdHyNPNn1IPOQVyoyj07/0MGf69w==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     khalasa@piap.pl
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: ixp4xx_hss: use dma_pool_zalloc
Date:   Sun, 25 Jul 2021 22:42:21 +0800
Message-Id: <20210725144221.24391-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dma_pool_zalloc combines dma_pool_alloc/memset. Therefore, the
dma_pool_alloc/memset can be replaced with dma_pool_zalloc which is
more compact.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wan/ixp4xx_hss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 3c51ab239fb2..2cebbfca0bd1 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -975,11 +975,10 @@ static int init_hdlc_queues(struct port *port)
 			return -ENOMEM;
 	}
 
-	port->desc_tab = dma_pool_alloc(dma_pool, GFP_KERNEL,
+	port->desc_tab = dma_pool_zalloc(dma_pool, GFP_KERNEL,
 					&port->desc_tab_phys);
 	if (!port->desc_tab)
 		return -ENOMEM;
-	memset(port->desc_tab, 0, POOL_ALLOC_SIZE);
 	memset(port->rx_buff_tab, 0, sizeof(port->rx_buff_tab)); /* tables */
 	memset(port->tx_buff_tab, 0, sizeof(port->tx_buff_tab));
 
-- 
2.32.0

