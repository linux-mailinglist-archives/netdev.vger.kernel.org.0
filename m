Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3FF29D8DD
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389021AbgJ1Wk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388993AbgJ1Wjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:39:45 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FB5C0613CF;
        Wed, 28 Oct 2020 15:39:45 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o3so691986pgr.11;
        Wed, 28 Oct 2020 15:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=54O1P5r41ZqmIzJz6Cd1KDy/NA/5HzTXzjDHY93KBEk=;
        b=XCF4m1HVkmRrcltQqxsijiiFPKHfs8kk0Us3sHpeOY/zbvnvF2P6UdvDNC0ufURVpr
         yUImZSALFkl24OnsWQ8+Jzmj7kDfw+Wb5qw79bnFenwOUEfx5u9UV1s8JOSxNIa6ye/k
         u3tNDsFBy7fROx8vBAv5LLDKzBjHr+S5Q7LqbNYRNfOGLkMnRnS7ertbSm5RGywo+8kS
         8vHdH13sIBinxU9yhNptNDsdq+AOsCUACtk8Ix71buxhj7r2yVuL+kaSJgVUwz31tHva
         hjvxwmFWpmy73p7B7hhY5BYnVTscT5O5GaFE2gmHqZDBmr9ewss0Tx+vWav302UdVwnl
         4+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54O1P5r41ZqmIzJz6Cd1KDy/NA/5HzTXzjDHY93KBEk=;
        b=M8YbS7WbZRz5PxGYX23NzCP2HpT6Hu8YdYeZosKmqAcDElvNPltn64K+I1JRjVwm5b
         d7l4mJNVowjkcoGg3omc5HZ8LyZSdkGXbHmzD/mmN1FrC3tnUcT20ldJayOYnbMRu7tH
         BO8Jsw4QrNhqn0FlBAMs3K9zLJugRQGw7lHjStrevMCxZrNHvBBLK8cD3Ze4EN3KoD+f
         8a6v+TBv/iealJbCLqjWA9VWqMLsAk4sTqjfa3v1Ju+gv/cZ9i9rEpxtHfUKaH5WNHXW
         mC4yYLNtwcbGEUvlU/tvjJ/JD2JANoRQYgklFnHA8jsL4xETLt1jiv5fzm18euM8auRu
         KuDg==
X-Gm-Message-State: AOAM5312MZ6OrOI+cQZqKi/ymbSOt954a0Ujz/imKlyw61M4l+aWAJLm
        dcxsZpbm9iR9dsyB66GSCYikfQ9H8d4=
X-Google-Smtp-Source: ABdhPJyBAjlVX65T+li+CFU0JXEgGicV+Sjvsba5+EbiJIIkuOAE3M/ABnYGs0iLE/3JcW97Natz/Q==
X-Received: by 2002:aa7:83c9:0:b029:158:11ce:4672 with SMTP id j9-20020aa783c90000b029015811ce4672mr7279936pfn.23.1603891201731;
        Wed, 28 Oct 2020 06:20:01 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id r8sm7058032pgn.30.2020.10.28.06.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:20:01 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
Date:   Wed, 28 Oct 2020 06:18:07 -0700
Message-Id: <20201028131807.3371-5-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028131807.3371-1-xie.he.0141@gmail.com>
References: <20201028131807.3371-1-xie.he.0141@gmail.com>
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

Also add skb_reset_mac_header before we pass an skb (received on normal
PVC devices) to upper layers. Because we don't use header_ops for normal
PVC devices, we should hide the header from upper layer code in this case.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 76 ++++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 3639c2bfb141..e95efc14bc97 100644
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
@@ -935,6 +974,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
+		skb_reset_mac_header(skb);
 
 	} else if (data[3] == NLPID_IPV6) {
 		if (!pvc->main)
@@ -942,35 +982,21 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
+		skb_reset_mac_header(skb);
 
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
2.25.1

