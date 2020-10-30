Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B389529FB49
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgJ3CaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgJ3CaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:11 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0069C0613CF;
        Thu, 29 Oct 2020 19:30:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x13so3971825pfa.9;
        Thu, 29 Oct 2020 19:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIZS4htOoo4rnqCYlSkF4xOfl6ObrKYt6xUCei1ECWY=;
        b=o4iPEbAieJ75MepEPc+iiWkr13LVENIVgzrejTHiQ3x1lJeKCOUFWWq/EQO9baDUL8
         AAYUC4QaUl1MsKk3R6lKA3ln2JmYNCK8eQeSkxiSIk72ExHOlSYFjjaUHsNWfvm1jtVF
         hAVz/5YLVtb4ETI+xDApd8UCFhLhOdcRLt3lueb24CNzgX7+YPcVphv2OTIDawuRRnXS
         x0XIR8MCgqg8VG00kC/p1O3MHM/ESpW1AXXmMYIqG8tD3+QY69j3KvMIhfqP6hGV0Z3z
         i6D0lyLo+Fq3x7C0tbnE50hj+tcDncBDlZ+aT3w5NwpKIO8bK5gNHSqWQllB4TXwRRFk
         YBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIZS4htOoo4rnqCYlSkF4xOfl6ObrKYt6xUCei1ECWY=;
        b=HanGgQZOM8yE8Y2Z5dr/HyCqySJ6Ruv76xx9ZfeAqWXUrOAi8K64d7bKjwroQBNMBR
         zQE+ul+3g4Thiv+Op0V1VUg444GuWPQ0LKc+sbnJw3ghl89mF7zLS6koploXrSy35X6z
         lZGKFXo7l3Hy2Q+510EytRXsBVrEyodXOrW/5j9soLAliJMvLGxo9uozAyzOETPOxz5H
         1KWIXuiUU3lGDushd8Id0cyPuXcRpjDomhYltKJOQWVwML/FYwCoFYFJWLd0ex40ZI7Y
         jyWJAVzpdzye97hDGAyG4kragBGB6zml5A0DWGPd02DTnnKJ+omNynu2kVBC+kvXTvRE
         AIuA==
X-Gm-Message-State: AOAM532cFPMfi4+kVJAfs+gNJyNFNRlHL9S+MaKh1bPwuf5DEvhFMQ61
        QBUA5yPyrwC13IVUBXpk5MigJGzXdvA=
X-Google-Smtp-Source: ABdhPJzWx97/Kvfsg5VBwdd8Kf6Zu5aZBHVm+Xw8wAvmNR92sLKaicMrm1lcI5exADyJg4ZM3I6WCQ==
X-Received: by 2002:aa7:9622:0:b029:160:7bc:4d00 with SMTP id r2-20020aa796220000b029016007bc4d00mr7240809pfg.51.1604025011230;
        Thu, 29 Oct 2020 19:30:11 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:30:10 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 2/5] net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
Date:   Thu, 29 Oct 2020 19:28:36 -0700
Message-Id: <20201030022839.438135-3-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030022839.438135-1-xie.he.0141@gmail.com>
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
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
2.27.0

