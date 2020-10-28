Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063B329D412
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgJ1Vsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgJ1VsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:00 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D4C0613CF;
        Wed, 28 Oct 2020 14:48:00 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id f7so1145551oib.4;
        Wed, 28 Oct 2020 14:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A/cW/YFtK1RV+lsW86culRjQ8dc+fqZrnk+DqtqcbRM=;
        b=fvc9YZagg7e0AUWWuX4JxuRgCLq0vsNScsRdPpL4l+36rDx6K3L2V0MeNdBe1QPG9l
         wpmam7+A7lxg70omTP5YKHdZdiAvb1nFewEYSAcgMO1YAzlyruNcTxmkxifJvRdp7+BK
         AHM+jhJG4KaWenvTa5/2+quzyrQaXXdqM0efkiFm1cO7Dr1BC5/22x142PQsTkyD/OLM
         irxipl6cEVRCtBkIQatL9xUovDsAVmSWR2jKN2PPIyltFKfnawTYpTcQi1pEL4ZOFZmE
         Xcfu9ACDw5ur6pNeo7Vv5LX68bMkyu/Hyj+9upUXU4L0No12GtlCx2ONx31kxRKpbVV3
         BrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A/cW/YFtK1RV+lsW86culRjQ8dc+fqZrnk+DqtqcbRM=;
        b=akLm1pTYShcBAP0EXBF7Fy76+MamA29tFo30NoPUG4ChieFjO30a2GxNEugES2p9zl
         VNP521u1sL/jgLh0ddlR6rCiH8rf9B99Y/rZ8Tq1FcKTz8FaXT5t8fL2qL5dc5cinZdW
         mjHTOMBlBwKmHHaDZXjcy5biEmP0UJX9aNyPte0WDBgcfyS7hTFJFTe4iFQfavEi+y+I
         Q4wV/6SFWXH1X5rg71nHFH5Me4/89vNKd3i4Qo4opsROqH223hUV4W2MZtdud5S/Pj0S
         ZkR/iBCGmglUSaK+uXS//9rb6mSG1cfVVB+Ifp1/6Ve5rQhESF1m6QyVnHFRlYTGkPua
         8ayw==
X-Gm-Message-State: AOAM532oX0cgD/b2xHs+9Fh3ekfNJBfBKD/Qq1NA7pOyJWkA6K4LdN9j
        cA3ru2Xa63muHQCLBwB91/YH0FXl1PY=
X-Google-Smtp-Source: ABdhPJxWHcqu45Kcbd0ePFmJfXLdgetqSZap1gd/5TZTPWFANxYYv8CuQhVlBPXIYelDzr6MBiF0Ug==
X-Received: by 2002:a17:90a:530c:: with SMTP id x12mr243701pjh.187.1603910603853;
        Wed, 28 Oct 2020 11:43:23 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id y27sm309785pfr.122.2020.10.28.11.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:43:23 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3 2/4] net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
Date:   Wed, 28 Oct 2020 11:43:08 -0700
Message-Id: <20201028184310.7017-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028184310.7017-1-xie.he.0141@gmail.com>
References: <20201028184310.7017-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eth_type_trans function is called when we receive frames carrying
Ethernet frames. This function expects a non-NULL pointer as an argument,
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

