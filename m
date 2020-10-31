Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2E2A120D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgJaAix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgJaAiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:51 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF65C0613D5;
        Fri, 30 Oct 2020 17:38:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id p21so145876pju.0;
        Fri, 30 Oct 2020 17:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w5CwQphJvfpbmXP3zNNqueP0Pdz1yc1mU4gwObshUtc=;
        b=ke4x5VI4T+/Zrg/OX1gA3I+Pq6rPgnyJwCJwwVNRdkcPKU1krfkAvrfpK1CFezuxFH
         utGcPUNHoFTHCWuV9DFTaJGZ7kzek7OTorxWM6fSLH/94VnDwGOvHpfqVp+WA4swh+mr
         l3IKmdGGna/vUvOpbQSqQyFDkPdI6vX2yBvvBHFqE63I2iJYtdQet82RleJ6aOMUvqd7
         Rmpc5VpsYi7X4shcAbUl3GBIHrlOSk4yxIkASOjFhR0Gy9IddDrmAE8tCOUp483V9BPA
         qPnNAaul0Wmrw4NtNM9gUTxq+w3Na07h297jH/ewPm2vwfQqMP8zQxR992EKWgjUg9Ih
         I06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w5CwQphJvfpbmXP3zNNqueP0Pdz1yc1mU4gwObshUtc=;
        b=ZgTO1HDeM3Hj+duo6wnvksHAz2Zpx5FPpWktRdg6pueSZJNKC6SvRBFwakigltJ2Jj
         EoQraMigGKDa8pkziHj9B00d9f/A5Gs0JXp6z8JcwOI4hsUFnmkck85G9xwfTtG4MWVc
         c8Cx1ZRN18ETIoqAXdgWMOAUYOCrn+CD+y9T89KQ6UgkaCBTyI8mJYBlRkHQGHXCrHeZ
         c8xaO323yihnmNYAzAET36OWGrIL761SPjcTXqHFN0D3rF0SrPoMsZLle9lm+1s52Fbo
         elxcUpTgTyE+75dj/0LGvVL/s9BFnuW+uABtHCk6zU9EsNk3nDam3fcJBgkc1XCA4r6R
         xDqw==
X-Gm-Message-State: AOAM531AL5zOFsNF7ILuOXsJwE0VqI85bg15U8qmYxrSyCc3j3yeRcCF
        GICzao//xFcYo9grCe8w1UQ=
X-Google-Smtp-Source: ABdhPJwozCjap6b54P8DP2L71pEUmXXYz0dZqsOVttZVEMJk+MiHTrMeAu52PVZHREvQLLfFL6uANg==
X-Received: by 2002:a17:90a:6301:: with SMTP id e1mr5890706pjj.131.1604104731116;
        Fri, 30 Oct 2020 17:38:51 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:50 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v5 5/5] net: hdlc_fr: Add support for any Ethertype
Date:   Fri, 30 Oct 2020 17:37:31 -0700
Message-Id: <20201031003731.461437-6-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031003731.461437-1-xie.he.0141@gmail.com>
References: <20201031003731.461437-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the fr_rx function to make this driver support any Ethertype
when receiving skbs on normal (non-Ethernet-emulating) PVC devices.
(This driver is already able to handle any Ethertype when sending.)

Originally in the fr_rx function, the code that parses the long (10-byte)
header only recognizes a few Ethertype values and drops frames with other
Ethertype values. This patch replaces this code to make fr_rx support
any Ethertype. This patch also creates a new function fr_snap_parse as
part of the new code.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 75 +++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 98444f1d8cc3..0720f5f92caa 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -871,6 +871,45 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 	return 0;
 }
 
+static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
+{
+	/* OUI 00-00-00 indicates an Ethertype follows */
+	if (skb->data[0] == 0x00 &&
+	    skb->data[1] == 0x00 &&
+	    skb->data[2] == 0x00) {
+		if (!pvc->main)
+			return -1;
+		skb->dev = pvc->main;
+		skb->protocol = *(__be16 *)(skb->data + 3); /* Ethertype */
+		skb_pull(skb, 5);
+		skb_reset_mac_header(skb);
+		return 0;
+
+	/* OUI 00-80-C2 stands for the 802.1 organization */
+	} else if (skb->data[0] == 0x00 &&
+		   skb->data[1] == 0x80 &&
+		   skb->data[2] == 0xC2) {
+		/* PID 00-07 stands for Ethernet frames without FCS */
+		if (skb->data[3] == 0x00 &&
+		    skb->data[4] == 0x07) {
+			if (!pvc->ether)
+				return -1;
+			skb_pull(skb, 5);
+			if (skb->len < ETH_HLEN)
+				return -1;
+			skb->protocol = eth_type_trans(skb, pvc->ether);
+			return 0;
+
+		/* PID unsupported */
+		} else {
+			return -1;
+		}
+
+	/* OUI unsupported */
+	} else {
+		return -1;
+	}
+}
 
 static int fr_rx(struct sk_buff *skb)
 {
@@ -945,35 +984,19 @@ static int fr_rx(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		skb_reset_mac_header(skb);
 
-	} else if (skb->len > 10 && data[3] == FR_PAD &&
-		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
-		u16 oui = ntohs(*(__be16*)(data + 6));
-		u16 pid = ntohs(*(__be16*)(data + 8));
-		skb_pull(skb, 10);
-
-		switch ((((u32)oui) << 16) | pid) {
-		case ETH_P_ARP: /* routed frame with SNAP */
-		case ETH_P_IPX:
-		case ETH_P_IP:	/* a long variant */
-		case ETH_P_IPV6:
-			if (!pvc->main)
-				goto rx_drop;
-			skb->dev = pvc->main;
-			skb->protocol = htons(pid);
-			skb_reset_mac_header(skb);
-			break;
-
-		case 0x80C20007: /* bridged Ethernet frame */
-			if (!pvc->ether)
+	} else if (data[3] == FR_PAD) {
+		if (skb->len < 5)
+			goto rx_error;
+		if (data[4] == NLPID_SNAP) { /* A SNAP header follows */
+			skb_pull(skb, 5);
+			if (skb->len < 5) /* Incomplete SNAP header */
+				goto rx_error;
+			if (fr_snap_parse(skb, pvc))
 				goto rx_drop;
-			skb->protocol = eth_type_trans(skb, pvc->ether);
-			break;
-
-		default:
-			netdev_info(frad, "Unsupported protocol, OUI=%x PID=%x\n",
-				    oui, pid);
+		} else {
 			goto rx_drop;
 		}
+
 	} else {
 		netdev_info(frad, "Unsupported protocol, NLPID=%x length=%i\n",
 			    data[3], skb->len);
-- 
2.27.0

