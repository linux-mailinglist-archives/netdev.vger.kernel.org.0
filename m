Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A52A2A1207
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgJaAiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgJaAis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85A7C0613D5;
        Fri, 30 Oct 2020 17:38:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so6677578pfn.12;
        Fri, 30 Oct 2020 17:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8h2JMek6rlGihOwl8Mu+I5wUSstGoce0/ReWhGN5UM8=;
        b=lPoWcfM3PQHA3MLFteK5Nm9rTGO3e+PsDLnKI55LxhPU6CpG1tlPefWuxMpHm1L6pf
         P6VvoUbGlH8S6RjeqTFCFfCqQ0uB2sqFJuk1GeHx0DcWa+cI6CAq/LLLPDBQLZQ+chw8
         44J1cV95PQqhtQ92Kyz+aW3tkOfiVTrVZ6tcObAeFxpRd2calk5Ojuy2PxrEfpZhlpTU
         vuhb0lbQb6jex1d+KQnn79zf4ZxQGEMcYzQuuLjwyZxuamytaeE48l3JMoqazd8BiDTR
         PXO7b1UTqYiGZL81cNkgMTZlie/ByimwgEz8h7rQOjWaoDhPifMrFhuoGDnbohrGA6x8
         CC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8h2JMek6rlGihOwl8Mu+I5wUSstGoce0/ReWhGN5UM8=;
        b=SHiIDpp7NQAiVopYoxD8sVDYNE6fbhmthy7Jn2pGubEvBQhSBM0m99HIhdgltGpf65
         l8zMMDwrU1bg/UZwjTs5lNOpQkhWuM25c7WHwTL6rg+TZ3myqA5j3yC6RzawL04aZcOH
         e8JBwJRLqV03bocyujrtzCoNsBn32z3OBfmj2mMX8M2eXz9tN5OHS5nqjc7NQq0oNOLt
         deLCAwuIiY778EknZ759z3jUyUMHXnCLoCxO39icVVQXKwMqrzFGLR8nkkRM8f2mNMca
         m/jYM0C3JkUU5gYg9IMRP09Ub6isso8Iwu5YiGJBjTeLxJX/JPmV2n4k0Ekn22XiibKt
         gQeQ==
X-Gm-Message-State: AOAM531X3l9x30nOBtGsO4kwqb4MJJjW5+fU8rYiQwZyBhmB9+pLAoLb
        gYvBkbgfR8Cvepl5z5XdItbSMqLYQm8=
X-Google-Smtp-Source: ABdhPJz93pwC9Cfj6AJbt35aEErZO9ySXAJMkaGyij1NbL7bJkZ/ltoTVJSh+BjbMXFOZqgCeReM5w==
X-Received: by 2002:a63:e54a:: with SMTP id z10mr4004701pgj.297.1604104724374;
        Fri, 30 Oct 2020 17:38:44 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:43 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v5 2/5] net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
Date:   Fri, 30 Oct 2020 17:37:28 -0700
Message-Id: <20201031003731.461437-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031003731.461437-1-xie.he.0141@gmail.com>
References: <20201031003731.461437-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eth_type_trans function is called when we receive frames carrying
Ethernet frames. This function expects a non-NULL pointer as an argument,
and assigns it directly to skb->dev.

However, the code handling other types of frames first assigns the pointer
to "dev", and then at the end checks whether the value is NULL, and if it
is not NULL, assigns it to skb->dev.

The two flows are different. Mixing them in this function makes the code
messy. It's better that we convert the second flow to align with how
eth_type_trans does things.

So this patch changes the code to: first make sure the pointer is not
NULL, then assign it directly to skb->dev. "dev" is no longer needed until
the end where we use it to update stats.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 4db0e01b96a9..71ee9b60d91b 100644
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
2.27.0

