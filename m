Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F8C2A193E
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgJaSMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:12:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F02C0617A6;
        Sat, 31 Oct 2020 11:12:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 133so7714639pfx.11;
        Sat, 31 Oct 2020 11:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jz6x+g+xbqRpPTzzyKWaisQhdh5VoS5Zw+hJtNIjDSU=;
        b=Wbylnzq3WLJpP9giv3tONeDQu6NBOEsxnRLPldc5hJISiPhq1CVWhCKOKptQhxCCrE
         rEizpfuepS759FTRhxMJ0ukacbKfMX98wIE4Ot2FuvdiBOYI5rNTtXF40wdX6t4Jbj8i
         SmZVaoJ1SbIO1uzhKAU0i+/NNyK0oQo55iiA4BjmcwBEJ6X9S20Y9ulwE4aLwZMx0BB8
         kWqZq19WTBgXGn8QNRhy8xfX36rkkhOJJzG21H1XmKY1GKyGiVBBiPjujAA2YP/yDSh4
         aMIL4z3fgcDBf4YyDKFb4cnxEPEut3tLKL+7Pgi0lSstV7OHgskgCdyMiDX/knbNwhpw
         iksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jz6x+g+xbqRpPTzzyKWaisQhdh5VoS5Zw+hJtNIjDSU=;
        b=NuVHDVjEMTkqz8SpEIHG4mk3d/N8yhZwO8Oq2SOw0aQGpa5b5PPQspH6MDev1K3T7P
         7GyG8hfBl5CfkQXQhxIZdoIjaesBL1vz52PAvtpVbWURJtGw+LsALI6pOTQGUjRvZgI+
         nsLMsqLakJuBn+7VukpLHNd70D2O3NU4DHtPd9p7CQD7nIXavISROFjtwH7PwpOY553E
         WC5t6sPRMJy9u8oW/FtaS+FpBR/OAWkD/7iTriP06h8uAayq4ePGZrd0IOLgnZRj3axH
         8QnWdSNwccxQeZYM8Zqw9oHze8AOKMdDy9pzxFjLk3MkiwkrNFNRs6FJFR3FrdVG1BlU
         Tb8w==
X-Gm-Message-State: AOAM533xPlOyofj7ApeY4BbBwf1Stc85on1oKQ328VTB6IhEX03B57bn
        RfVlW23zRTvd3BKGbnHgK10=
X-Google-Smtp-Source: ABdhPJxs6lTpBPQ0vGfBF254AcR8omT9nNEqrInpWYRBnFsDt2ZDWMqzrPYLBJUsWuEcri7IuYo1Fw==
X-Received: by 2002:aa7:8815:0:b029:163:c712:81ad with SMTP id c21-20020aa788150000b0290163c71281admr14762157pfo.74.1604167932871;
        Sat, 31 Oct 2020 11:12:12 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:12:12 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 5/5] net: hdlc_fr: Add support for any Ethertype
Date:   Sat, 31 Oct 2020 11:10:43 -0700
Message-Id: <20201031181043.805329-6-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
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

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

