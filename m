Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807DC26CF02
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgIPWnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIPWm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:42:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9A0C0612F2;
        Wed, 16 Sep 2020 14:25:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so108657pjb.5;
        Wed, 16 Sep 2020 14:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2SL8leUcQ+GFmuhnu/vBMX/sD7AIUfW+Lu4/oT5nM4=;
        b=jU8TZVQaKvpoZn48V0fPVDESmoUOlJvSmXcM1jzqxATMguMtTvqeIFOs54NVItQQhT
         13gwhrZ7QICZsC0xEXBjbTadwGXs//4htc3xHHQ72Yt2IYiieW9dID7IA6FI195Cdr0a
         RXegAC2bOd+Yam+0aYytWTUaATxJR2K716+dSDw2HWWDscPXbnd+uvwcN2kbUMrl3TlC
         TkxiYGJt4rZ6vW86UN39aiIBEKfeVj3IHc4gYo8AdrCf7M5+BmmTJ3TYPlXQvQvaV8+t
         lwxoYvmwYsmkjzDRXp2O3x20V1VAAvy2v2wZJ9SjlOn3m/GHGvqhfjK1EfaSLSBW5K2P
         uogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2SL8leUcQ+GFmuhnu/vBMX/sD7AIUfW+Lu4/oT5nM4=;
        b=GJWed8LyiTcC/1zLpHM8BMhve6JjkJLg0Mj5fZG1TOYsM3doDV5gWLAXLcOzHRwAkW
         Q8hhEEUPET+B4FndVbZ71kliKdnUMmOLx4Grc7eC/EKFPbUicD8EJ4Y6R5qNZKZyMT+d
         iqETUouOP9H0+yf+3f4MP1X71hEK6Faq6VmBqoet2PPD2mEoyvMnS7bx5YkviHifLS2I
         hv2ndHRJzlm05BrQP4g1P/zL71LGIBWhbCTT7I8Exq9Xu1YQLFrWNUz5HRS8T78tcM+4
         uVr5MESMcn41upiWT3/JQALDX7PhpkwzTVPDA+9NG2y44fWLRkmK0Y/MJxVi1kG84kht
         ZF2A==
X-Gm-Message-State: AOAM532s4Kgyoqx4xiMLwbLryd/skZNM5rXr5ClQXaUjbCWJfmJOVJQe
        jWgJrF9M8587JpQVlHh2ohvp2N1zgA8=
X-Google-Smtp-Source: ABdhPJwS6OC7psK9Il6Mr4+SqNhi5ewz3ZqrsJza3JzAgB1Sr3fBuMUQ4imuCBxyZ0Zkjg8QnKBWvw==
X-Received: by 2002:a17:90a:a58d:: with SMTP id b13mr5668930pjq.49.1600291512914;
        Wed, 16 Sep 2020 14:25:12 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:29a5:9632:a091:4adb])
        by smtp.gmail.com with ESMTPSA id kt18sm3510088pjb.56.2020.09.16.14.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:25:12 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: [PATCH net] drivers/net/wan/hdlc: Set skb->protocol before transmitting
Date:   Wed, 16 Sep 2020 14:25:07 -0700
Message-Id: <20200916212507.528223-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets skb->protocol before transmitting frames on the HDLC
device, so that a user listening on the HDLC device with an AF_PACKET
socket will see outgoing frames' sll_protocol field correctly set and
consistent with that of incoming frames.

1. Control frames in hdlc_cisco and hdlc_ppp

When these drivers send control frames, skb->protocol is not set.

This value should be set to htons(ETH_P_HDLC), because when receiving
control frames, their skb->protocol is set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, which then calls
cisco_type_trans or ppp_type_trans. The skb->protocol of control frames
is set to htons(ETH_P_HDLC) so that the control frames can be received
by hdlc_rcv in hdlc.c, which calls cisco_rx or ppp_rx to process the
control frames.

2. hdlc_fr

When this driver sends control frames, skb->protocol is set to internal
values used in this driver.

When this driver sends data frames (from upper stacked PVC devices),
skb->protocol is the same as that of the user data packet being sent on
the upper PVC device (for normal PVC devices), or is htons(ETH_P_802_3)
(for Ethernet-emulating PVC devices).

However, skb->protocol for both control frames and data frames should be
set to htons(ETH_P_HDLC), because when receiving, all frames received on
the HDLC device will have their skb->protocol set to htons(ETH_P_HDLC).

When receiving, hdlc_type_trans in hdlc.h is called, and because this
driver doesn't provide a type_trans function in struct hdlc_proto,
all frames will have their skb->protocol set to htons(ETH_P_HDLC).
The frames are then received by hdlc_rcv in hdlc.c, which calls fr_rx
to process the frames (control frames are consumed and data frames
are re-received on upper PVC devices).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 drivers/net/wan/hdlc_fr.c    | 3 +++
 drivers/net/wan/hdlc_ppp.c   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 444130655d8e..cb5898f7d68c 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -118,6 +118,7 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	skb_put(skb, sizeof(struct cisco_packet));
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 12b35404cd8e..d6cfd51613ed 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -433,6 +433,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (pvc->state.fecn) /* TX Congestion counter */
 				dev->stats.tx_compressed++;
 			skb->dev = pvc->frad;
+			skb->protocol = htons(ETH_P_HDLC);
+			skb_reset_network_header(skb);
 			dev_queue_xmit(skb);
 			return NETDEV_TX_OK;
 		}
@@ -555,6 +557,7 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	skb_put(skb, i);
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 
 	dev_queue_xmit(skb);
diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 16f33d1ffbfb..64f855651336 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -251,6 +251,7 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 
 	skb->priority = TC_PRIO_CONTROL;
 	skb->dev = dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
 	skb_queue_tail(&tx_queue, skb);
 }
-- 
2.25.1

