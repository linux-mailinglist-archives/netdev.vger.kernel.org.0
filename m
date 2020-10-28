Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B025D29D966
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389744AbgJ1Wyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388439AbgJ1Wyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:54:35 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76B6C0613CF;
        Wed, 28 Oct 2020 15:54:34 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z23so1326835oic.1;
        Wed, 28 Oct 2020 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UEQBkEXiJOfBE5LzS0jxlJBj5IlPjaXUmPkuEF50Xpo=;
        b=E3cy/fT07MNJXvIqKs8Ay+Od40l7u8VQgFHMmrPTYIcEtp91rFYrJRtfCN5Yi9pQ7q
         lAtrmR6EKuawCWn84aNM9AKjn6apJcLp0iEJIM7Ttjj0sIKdbVi3u/xn7qAKb8C1A7h6
         OawNqGyneFTjh/XxH5iIR4Awd/W4HCEU3L9LlLOO9WyUYerQqlLriqDn7MCj9HAKayXV
         t8vYy8CPHfeNYDW5NcHH/3nC0Sg+eruF5qO6R8trzqeXzskpbgMgtLl2yvYS2Nv7h761
         zVD1IIOTWUzxW9t/NEkuM8rT2KYmppvgFxJxwH2Lmm6S3KrAsnLcltyt50eGFLYjcEn1
         mXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UEQBkEXiJOfBE5LzS0jxlJBj5IlPjaXUmPkuEF50Xpo=;
        b=U49ryd3OBmaQLmnxsU8yuNdjsBhL25hh0hhmkW1LjeWRETdOEjlIY+nCq3IBIP0Al3
         lA1d89dkncvx5/KncjcEFqYEqs+246yJdLvacCi1YLm3YUFba5gZm+OsynhwsAatQBzx
         7N0SeMR/gFvUAHVpY6V3mgXIqNPyjxC3aWokYR2DlHWKS+G8Q/VQQqBh3pebWb/Sk1J2
         1wx+74OGnHZNfElEmO3PBFQUqBrURhynydGzWFeMgt9zxzVpI3JxKa6kZwZfnJw2Wvyp
         WVmSwwQne8yoUohdADBXnyt5zV8wfK6ZXKZT45THpiGmM6evLE6I8DW1jii/p1WEVxOi
         b+6g==
X-Gm-Message-State: AOAM531L4Js5CzTHy08H9sXQVUSMIkaZWcYKjGW2o4QFL3M3WvW+OV48
        GBDEfxO1p9+AhANyaf2SN7B7C8JpHsU=
X-Google-Smtp-Source: ABdhPJwZHZX2/Z3qoeSvLZlJdb/IZ4Y4uUPQVCXbUpXEyHQTg3krOYoj3p5ikKw2CzqOuXw9wKn67Q==
X-Received: by 2002:a17:90b:17c4:: with SMTP id me4mr6438096pjb.120.1603882676309;
        Wed, 28 Oct 2020 03:57:56 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a46c:8b86:395a:7a3d])
        by smtp.gmail.com with ESMTPSA id 65sm557863pge.37.2020.10.28.03.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:57:55 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next 2/4] net: hdlc_fr: Change the use of "dev" in fr_fx to make the code cleaner
Date:   Wed, 28 Oct 2020 03:57:03 -0700
Message-Id: <20201028105705.460551-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028105705.460551-1-xie.he.0141@gmail.com>
References: <20201028105705.460551-1-xie.he.0141@gmail.com>
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

The two flows are different. Letting them co-exist in this function makes
the code messy. It's better that we convert the second flow to align with
how eth_type_trans does things.

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

