Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB19161EB3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfGHMoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:44:01 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:57989 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGHMoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:44:01 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1McpaE-1iJFW62XGk-00ZtDI; Mon, 08 Jul 2019 14:43:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] gve: fix unused variable/label warnings
Date:   Mon,  8 Jul 2019 14:43:39 +0200
Message-Id: <20190708124350.3470436-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:S/ae/5cCIlLZy2P1ieZaaFoYa69iCghJUGFf5fcsn7fCDHbu6Cn
 eKV/yEsddC2eLLeiizg2FnbASjNsXi9SJ01K5hkqNPItpP+1oyOB2DJzErX0SlbcweeX7bn
 2UuofxKAcRnr/MOgR4yAhgdXQv6bfkrGhjJHjk9enX5MWBRLqlaF6vgn/ixCdGLia55zb8S
 we2HT1M2EfrQrZWQFn3yA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3sBU26XYjZk=:TSUoBCXF85Vkyoh8NS40p4
 SYa/u7gFnTKZS+DxWNmXmlN6q18T30Q2DE9SZcddYSdDvWd9FlaQOhsu0x3VxHXoyUPgQraVK
 zSHEXG648ad6IuBwKe42MtUi2Yge5ExtiX4FAmWP0TKBPUo1ElCHAiTBrM2inVoj1mLfJIEaO
 CU+E6xZe68Hny5ej+VC+g/grcvYSSGzt1VCAPdKrcI7j8JjQYf3stNQxguoXFVRdRoEPID0Rw
 ZzRxdHHW14cBBTKLUV3uLZ2fjwAX/Fp3yMQ1NwQd1FVUhek6+qsixsucKN7mr0SHwvjk0xWTF
 VOQx6e+Su/A8DapkTLgEYbeNVvEtKt+A3jjdNZJ0Tp/9Gymc7G1HKyURlxqeKslcpbpVlrtyv
 +XAS648Ecud2A/Etudg2cBwVw5/XXMF2S5o5X3PAbUO+LvqYBK+v9S4ZuTif00UeMPE+QKFWi
 OYXouCuugM/udHw0XD4TydXCX0hyYbIuc21dC5TP3dXb89RI9yZaJmKaueZ6tWLLuwQcwrQsp
 5qemmJpglNMax9VMKMrrsJ1nruxHV+yFCtipY0QOH1s6VcndvNvdjTeNuYb6NC/XnLifLZQMT
 a6D6MsX+kTdpQRS0UybIGs6IQcWeqkZOUJj3S/c8d0HUQ47VUcZ8zqmn8RXqQHSHvF8I8pjnK
 kbs+n1RN1HhTvkp2wy8AlMTzW19LakA3Xb6+RFbw/9yrnP6z1scz/qqFryPBSc5DoKwjaJIs3
 qSKsRxfz5qH14Y5ISOEw5U/1rNZCedlmc3JKMQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On unusual page sizes, we get harmless warnings:

drivers/net/ethernet/google/gve/gve_rx.c:283:6: error: unused variable 'pagecount' [-Werror,-Wunused-variable]
drivers/net/ethernet/google/gve/gve_rx.c:336:1: error: unused label 'have_skb' [-Werror,-Wunused-label]

Change the preprocessor #if to regular if() to avoid this.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 66 ++++++++++++------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 84e0ecce14c4..c1aeabd1c594 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -297,41 +297,41 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	 * it so that we can return it to the device.
 	 */
 
-#if PAGE_SIZE == 4096
-	if (len <= priv->rx_copybreak) {
-		/* Just copy small packets */
-		skb = gve_rx_copy(dev, napi, page_info, len);
-		goto have_skb;
-	}
-	if (unlikely(!gve_can_recycle_pages(dev))) {
-		skb = gve_rx_copy(dev, napi, page_info, len);
-		goto have_skb;
-	}
-	pagecount = page_count(page_info->page);
-	if (pagecount == 1) {
-		/* No part of this page is used by any SKBs; we attach
-		 * the page fragment to a new SKB and pass it up the
-		 * stack.
-		 */
-		skb = gve_rx_add_frags(dev, napi, page_info, len);
-		if (!skb)
-			return true;
-		/* Make sure the kernel stack can't release the page */
-		get_page(page_info->page);
-		/* "flip" to other packet buffer on this page */
-		gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
-	} else if (pagecount >= 2) {
-		/* We have previously passed the other half of this
-		 * page up the stack, but it has not yet been freed.
-		 */
-		skb = gve_rx_copy(dev, napi, page_info, len);
+	if (PAGE_SIZE == 4096) {
+		if (len <= priv->rx_copybreak) {
+			/* Just copy small packets */
+			skb = gve_rx_copy(dev, napi, page_info, len);
+			goto have_skb;
+		}
+		if (unlikely(!gve_can_recycle_pages(dev))) {
+			skb = gve_rx_copy(dev, napi, page_info, len);
+			goto have_skb;
+		}
+		pagecount = page_count(page_info->page);
+		if (pagecount == 1) {
+			/* No part of this page is used by any SKBs; we attach
+			 * the page fragment to a new SKB and pass it up the
+			 * stack.
+			 */
+			skb = gve_rx_add_frags(dev, napi, page_info, len);
+			if (!skb)
+				return true;
+			/* Make sure the kernel stack can't release the page */
+			get_page(page_info->page);
+			/* "flip" to other packet buffer on this page */
+			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
+		} else if (pagecount >= 2) {
+			/* We have previously passed the other half of this
+			 * page up the stack, but it has not yet been freed.
+			 */
+			skb = gve_rx_copy(dev, napi, page_info, len);
+		} else {
+			WARN(pagecount < 1, "Pagecount should never be < 1");
+			return false;
+		}
 	} else {
-		WARN(pagecount < 1, "Pagecount should never be < 1");
-		return false;
+		skb = gve_rx_copy(dev, napi, page_info, len);
 	}
-#else
-	skb = gve_rx_copy(dev, napi, page_info, len);
-#endif
 
 have_skb:
 	/* We didn't manage to allocate an skb but we haven't had any
-- 
2.20.0

