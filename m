Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671329D8AF
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388243AbgJ1Wfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387530AbgJ1Wej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:34:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D0DC0613CF;
        Wed, 28 Oct 2020 15:34:39 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h21so1217372iob.10;
        Wed, 28 Oct 2020 15:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9mzi0JBUWMjjpbb/aO3F5Bvz2ioWTlLDQ0MTMYGD0gk=;
        b=A1/dBuGTNsdbhqUwe1pmvgkSyAMym/wvYPt6+WyE1l8CC5VtgLIT4qzDJpclvl9wB7
         w2KzQkFH7YNGpJR9kUbnHJUEgSTCOB8sJ7d6P9Yg2zwtPGmFYLKsRFb1Uf5hT4C0PKLR
         P2YeNqZLufSHfwwzc+s5esdbIVWyA85zED2VXBniTwX7KM/rdQuhRWy7yjzKwvLfxPow
         pdZ8diRBT109Ye7tyY8znxlEUmyAPPdpG8zmjwOFmwU/sTLnf5NyWI3Ig2icuI+ZqZpw
         n/7Y7ZNW/z80L2IXNp0krtsDj82SxmQleD18iRj8Ghy2STXc7JwqUC73qw3TPNP7KUph
         jvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9mzi0JBUWMjjpbb/aO3F5Bvz2ioWTlLDQ0MTMYGD0gk=;
        b=STZMYFVqwYMXr2z8+8lg5kKicCAsshulaMpDM9kMlOPQ6WEoqRwkMZ4/qkor1SCtTS
         u29Msi+D7CNoSvPvfN57gUSFD9A8qDV8XNA+6LbMiNOOxQQEkmajSGdydA7oYn4HUXFB
         TcuJjHB2itvgWp0ZZoIX5XI8PzMueZuokEWZ6t7Gh9Q7PPnk+GXhuJfGTnGwqqhHtYXx
         uOwmnc4oWjx/E9+/NtevSypJMKljhn+3zMQFPKkLLQz/MXL+LWGHvghnz3kM7mvfIDVR
         5lIBGFHJkEdTU6rDn4GYBLXkUCDT7LuY+3MgmJokJzWo8Z2CdTDA5at+YZy0Lhz+bRAK
         BT4A==
X-Gm-Message-State: AOAM530Xqz5ATKIMRxG5Ac51iI7Vd+gvFDZyoLKXAQGYASVnjYWOBx3l
        Kfe/qLT7FkTA7m2uK9uQ8Tj4s77WGr8=
X-Google-Smtp-Source: ABdhPJynfIJJQrGHTggTvKAqZJZ0Y3W3B63/F4iYZ6dbXOSsQ23wwBiQwNbG3ngRM7xzu44FjZXGPw==
X-Received: by 2002:a63:6243:: with SMTP id w64mr6307831pgb.228.1603891188228;
        Wed, 28 Oct 2020 06:19:48 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id r8sm7058032pgn.30.2020.10.28.06.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:19:47 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2 2/4] net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
Date:   Wed, 28 Oct 2020 06:18:05 -0700
Message-Id: <20201028131807.3371-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028131807.3371-1-xie.he.0141@gmail.com>
References: <20201028131807.3371-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eth_type_trans function is called when we receive frames carrying
Ethernet frames. This function expects a non-NULL pointer as a argument,
and assigns it directly to skb->dev.

However, the code handling other types of frames first assigns a pointer
to "dev", and then at the end checks whether the value is NULL, and if it
is not NULL, assigns it to skb->dev.

The two flows are different. Mixing them in this function makes the code
messy. It's better that we convert the second flow to align with how
eth_type_trans does things.

So this patch changes the code to: first make sure the pointer is not
NULL, then assign it directly to skb->dev. "dev" is no longer needed until
the end where we use it to update stats.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index c774eff44534..ac65f5c435ef 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -880,7 +880,7 @@ static int fr_rx(struct sk_buff *skb)
 	u8 *data = skb->data;
 	u16 dlci;
 	struct pvc_device *pvc;
-	struct net_device *dev = NULL;
+	struct net_device *dev;
 
 	if (skb->len <= 4 || fh->ea1 || data[2] != FR_UI)
 		goto rx_error;
@@ -930,13 +930,17 @@ static int fr_rx(struct sk_buff *skb)
 	}
 
 	if (data[3] == NLPID_IP) {
+		if (!pvc->main)
+			goto rx_drop;
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
-		dev = pvc->main;
+		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
 
 	} else if (data[3] == NLPID_IPV6) {
+		if (!pvc->main)
+			goto rx_drop;
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
-		dev = pvc->main;
+		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
 
 	} else if (skb->len > 10 && data[3] == FR_PAD &&
@@ -950,13 +954,16 @@ static int fr_rx(struct sk_buff *skb)
 		case ETH_P_IPX:
 		case ETH_P_IP:	/* a long variant */
 		case ETH_P_IPV6:
-			dev = pvc->main;
+			if (!pvc->main)
+				goto rx_drop;
+			skb->dev = pvc->main;
 			skb->protocol = htons(pid);
 			break;
 
 		case 0x80C20007: /* bridged Ethernet frame */
-			if ((dev = pvc->ether) != NULL)
-				skb->protocol = eth_type_trans(skb, dev);
+			if (!pvc->ether)
+				goto rx_drop;
+			skb->protocol = eth_type_trans(skb, pvc->ether);
 			break;
 
 		default:
@@ -970,17 +977,13 @@ static int fr_rx(struct sk_buff *skb)
 		goto rx_drop;
 	}
 
-	if (dev) {
-		dev->stats.rx_packets++; /* PVC traffic */
-		dev->stats.rx_bytes += skb->len;
-		if (pvc->state.becn)
-			dev->stats.rx_compressed++;
-		skb->dev = dev;
-		netif_rx(skb);
-		return NET_RX_SUCCESS;
-	} else {
-		goto rx_drop;
-	}
+	dev = skb->dev;
+	dev->stats.rx_packets++; /* PVC traffic */
+	dev->stats.rx_bytes += skb->len;
+	if (pvc->state.becn)
+		dev->stats.rx_compressed++;
+	netif_rx(skb);
+	return NET_RX_SUCCESS;
 
 rx_error:
 	frad->stats.rx_errors++; /* Mark error */
-- 
2.25.1

