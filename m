Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03B528272A
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 00:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgJCWlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 18:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgJCWlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 18:41:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F41C0613D0;
        Sat,  3 Oct 2020 15:41:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so732646pfp.13;
        Sat, 03 Oct 2020 15:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dO66K4BodXcN3osd35WZPCm1CN9PU88SIY4ROPYVfzI=;
        b=bMLKCTI69rLKJk+u6BnR5a2vB+Vpl9ogZ0tz/Z3IliV+lbiJjNfReMtnPzBOuHLqb3
         NFLS+ibL4/Vp1smzokZNc1xcVgoJWbSwaVpQSuL9h37fA1v+XBUrJx3rTeui2Nf5XdKg
         Z6StGJrHxmR+sVvrqVtq43iVG/21/fgXzjyq0kty2K+rYuY0TziKYsPejKYmJD8cBPpb
         zhUVanyyxc0uE0DUh5nvRXfbBcGYwls+u0koJC6JotKC+80gwVeahIy8vASU2UXf53Zc
         q+ONgUqDWHhodH4lT6kwsP+fd+AnS1ZpuqeKzxKVlCh/sgnJl7jzxo2tEr/Y/J6++fG5
         JABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dO66K4BodXcN3osd35WZPCm1CN9PU88SIY4ROPYVfzI=;
        b=stXq38t81A0YN7k+8qL+vjWVWxTM3hMA6AyL8Z+s0cTFxwz3XQotZRA4zf3fjTku7u
         Hcfmu0WQ8ohgCfv70FONwUcYqh6AUF5AmTctMSviuUKyVp6/iUp5wr9m18C7C7OB2WiG
         cZj8Lsx6QR1wsYNW3UvUSlxL9YhF+UwntI9wy5Hu8e371bd8ZN7FlpS7L/nzVPtYJmxf
         VijEzLZreAWpE5yN8IWNvIbO0rHIbgQBFGI/cvdxgk6Acw/ux8RNqvPW7CXVOR8pOSQp
         3qKxNhjJHd+IlUE/fv6xEO1O3t8T2jWl8BZz0csyPpmc3EZGuox0UBA4navT5PA9M+jd
         7IKQ==
X-Gm-Message-State: AOAM5311KKObX/8hWg6Jx/RA/i2ywWP3UdLLo3Pw0eKAjW4BryAXbqYA
        oeikhw/Sac5OLNL9CZRtxpo=
X-Google-Smtp-Source: ABdhPJwDyRmHGgrvgAyfjUnIwraZxptnmhKcMf8nHNmhPmM3CkVJVdr3q7dCKlhjgTq+cWYIB+90tw==
X-Received: by 2002:a63:c052:: with SMTP id z18mr8061427pgi.103.1601764882641;
        Sat, 03 Oct 2020 15:41:22 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:12f:64be:90c0:b4c2])
        by smtp.gmail.com with ESMTPSA id gp8sm5577889pjb.3.2020.10.03.15.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 15:41:22 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] drivers/net/wan/hdlc_fr: Improvements to the code of pvc_xmit
Date:   Sat,  3 Oct 2020 15:41:05 -0700
Message-Id: <20201003224105.74234-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Keep the code for the normal (non-error) flow at the lowest
indentation level. And use "goto drop" for all error handling.

2. Replace code that pads short Ethernet frames with a "__skb_pad" call.

3. Change "dev_kfree_skb" to "kfree_skb" in error handling code.
"kfree_skb" is the correct function to call when dropping an skb due to
an error. "dev_kfree_skb", which is an alias of "consume_skb", is for
dropping skbs normally (not due to an error).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 54 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 3a44dad87602..4dfdbca54296 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -416,38 +416,36 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct pvc_device *pvc = dev->ml_priv;
 
-	if (pvc->state.active) {
-		if (dev->type == ARPHRD_ETHER) {
-			int pad = ETH_ZLEN - skb->len;
-			if (pad > 0) { /* Pad the frame with zeros */
-				int len = skb->len;
-				if (skb_tailroom(skb) < pad)
-					if (pskb_expand_head(skb, 0, pad,
-							     GFP_ATOMIC)) {
-						dev->stats.tx_dropped++;
-						dev_kfree_skb(skb);
-						return NETDEV_TX_OK;
-					}
-				skb_put(skb, pad);
-				memset(skb->data + len, 0, pad);
-			}
-		}
-		skb->dev = dev;
-		if (!fr_hard_header(&skb, pvc->dlci)) {
-			dev->stats.tx_bytes += skb->len;
-			dev->stats.tx_packets++;
-			if (pvc->state.fecn) /* TX Congestion counter */
-				dev->stats.tx_compressed++;
-			skb->dev = pvc->frad;
-			skb->protocol = htons(ETH_P_HDLC);
-			skb_reset_network_header(skb);
-			dev_queue_xmit(skb);
-			return NETDEV_TX_OK;
+	if (!pvc->state.active)
+		goto drop;
+
+	if (dev->type == ARPHRD_ETHER) {
+		int pad = ETH_ZLEN - skb->len;
+
+		if (pad > 0) { /* Pad the frame with zeros */
+			if (__skb_pad(skb, pad, false))
+				goto drop;
+			skb_put(skb, pad);
 		}
 	}
 
+	skb->dev = dev;
+	if (fr_hard_header(&skb, pvc->dlci))
+		goto drop;
+
+	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	if (pvc->state.fecn) /* TX Congestion counter */
+		dev->stats.tx_compressed++;
+	skb->dev = pvc->frad;
+	skb->protocol = htons(ETH_P_HDLC);
+	skb_reset_network_header(skb);
+	dev_queue_xmit(skb);
+	return NETDEV_TX_OK;
+
+drop:
 	dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1

