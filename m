Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A32A1935
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgJaSLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:11:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0032DC0617A6;
        Sat, 31 Oct 2020 11:11:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so1343555pfz.6;
        Sat, 31 Oct 2020 11:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ZRH0OzxUypIK1b/aMoXuBb/y6XgbaeCstQDTI1G9UY=;
        b=IxcElbdFkcgYTe6k5qR9zKCQIVmdby5pRjYwJHfUt8FX6IqcRrItr8NLtmziwXY/az
         mIcslyNeCzKTAeqbf9m9U8Cdp9CUAOgbkxtZp2KUL7GMRXjpjVsFg42FPxqcGlPzlsCb
         o+Lj+jQB96evj9xQ+MmuK2MncvEAOvNGQc1vqP5dIlCfhXqJlR2364QR194JkGUpj0GV
         MMiWJdG1DYTatcJ+3LmIGcekERg/0sTrB8mnO2t7e1u2d3rbzbg7REfhJSZbbJWuTymJ
         1Ea1kbNOdudZWAJl7FsTXT6p2oEsXUvUj9+NPQg6T1JO/zv8/RRlNkAT1KECaHxRFwIv
         Yp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ZRH0OzxUypIK1b/aMoXuBb/y6XgbaeCstQDTI1G9UY=;
        b=Rn4ECjh3QCEv0xj3aGA15Bh+GPxINthikEWJifOmyqKakBsaaKHvLFdV+CHd2kkexR
         8IyjWOaytoRSPQ1YWc36qIVpm3ELccPuon39BFNVWNm0gBYHSR9YonhLcFFQOnRQtmBQ
         iA4B3cVjjdOqq1IqicummqfrvNn5fbmgdPcVR0RPNwetKv2wsR08cPSOsmxveURzLxH6
         J+BfxJRjUCv/NfkV/elA+cRAwCfwi2DeiARAXqARHFOw+lDMDvhsGFC7SKh18qJFgdic
         kjWB5P3ljKzYI1FRQHG7c/ECuP8JmmoXsKAN61asw9Oqt++pFkxRmxis6QysSTolQKlw
         TcNQ==
X-Gm-Message-State: AOAM533sLdegeCbyvI/w7ccweUMdyJTj5fanqYfYrJNSU8NBFSooG6Sb
        yejWIMUa13kgB91+EL/SLZwbBDF3jOs=
X-Google-Smtp-Source: ABdhPJwQwxMlTnslt1Tz2wnT9qcZhKp5jlmk1AqCMGi2QNa7eiDd5oj+nqLVOa67EPEDIBdJPRFUzg==
X-Received: by 2002:a62:7b47:0:b029:18a:ab71:7821 with SMTP id w68-20020a627b470000b029018aab717821mr4321187pfc.3.1604167893479;
        Sat, 31 Oct 2020 11:11:33 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:11:33 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 2/5] net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
Date:   Sat, 31 Oct 2020 11:10:40 -0700
Message-Id: <20201031181043.805329-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
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

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

