Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90E8286769
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgJGScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgJGScQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:32:16 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DB8C061755;
        Wed,  7 Oct 2020 11:32:16 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s19so1438703plp.3;
        Wed, 07 Oct 2020 11:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uxYIsJejZhZlTz7r0IDJ2tdPi63eWXzl7YwoWGSJXPg=;
        b=UZtc234NXbrwxHWCjqwEo9T3EMNaPH7lw7RGTIkZne7mR/KARlHz3nofcSOLlmd/dB
         6iShSnqVYMTSjRkZ5ld/eIdILBeyLUPztA7aeK+VJ55Dzz+B3y8LEwj8B1EB7ZAQ6qhX
         s+7aecPppLJucNEg4LSidKH9Vs/mBBnuF18ILrtaBLcNBeAn9dQIlf/QM1Lrbh4x6u3J
         T/8QZZnbGrzzcsfXGgOwc3Pb8XBN33kM74NVtcOFnHA7kUOvOJCqDJzvTxykNR498y80
         FYPJGe5oE+4mt6UjYjcXDJri5NQcUP8a1XcGTIDYIn04cnNWe5TSh72oKnLYWBb9W/in
         gIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uxYIsJejZhZlTz7r0IDJ2tdPi63eWXzl7YwoWGSJXPg=;
        b=CkPsn6bAomUyf+4a7uM/ic9w0FsyygUg0+iy0+y4hr/TbtAWmTv14tukO84nuxhgG/
         BUfqQfzrFfVu8qLjSblPgzo0sWcdbabVcfFtOWD/00q+1zmSepUsoP6ABTQO3moV/4Y+
         MIx3KvpY6jBXNjeCTKEiExYHSCNnezCEfsuiTngq5wJO7jBw+HiO6A9hN+evi4ZdRUbs
         FqmIOOhPwyEShSBaNFA3ZkRJ2xbQmKZqI8VS5lFegK7AEn7bCHP8F43qEq6aU+f6n2uk
         a/W/bmGyPyXxyTqiTdDmxlKomOUfxt33JItJgzcgLQMREQzgcJNORb5+tpeuyvAM4TLb
         ldIg==
X-Gm-Message-State: AOAM533wCfn1yH8Nbo1Rv70xi+XSwKgZPTpBq3XEV7hdBAnnJzH60Bj4
        pulveF9LG1a5I8jaxXoMnAwIoGspnzU=
X-Google-Smtp-Source: ABdhPJxSaveU+veCZGwQTNJHYUcCVB2SN33zDEJarpJvTl1Zb2ACB+N7njXpXWQN0zwaifJ0WWzi4w==
X-Received: by 2002:a17:902:8d86:b029:d1:9237:6dfd with SMTP id v6-20020a1709028d86b02900d192376dfdmr3990036plo.22.1602095535810;
        Wed, 07 Oct 2020 11:32:15 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:889d:9966:a55c:ddce])
        by smtp.gmail.com with ESMTPSA id o15sm4541522pfd.16.2020.10.07.11.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 11:32:15 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] drivers/net/wan/hdlc_fr: Move the skb_headroom check out of fr_hard_header
Date:   Wed,  7 Oct 2020 11:32:03 -0700
Message-Id: <20201007183203.445775-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the skb_headroom check out of fr_hard_header and into pvc_xmit.
This has two benefits:

1. Originally we only do this check for skbs sent by users on Ethernet-
emulating PVC devices. After the change we do this check for skbs sent on
normal PVC devices, too.
(Also add a comment to make it clear that this is only a protection
against upper layers that don't take dev->needed_headroom into account.
Such upper layers should be rare and I believe they should be fixed.)

2. After the change we can simplify the parameter list of fr_hard_header.
We no longer need to use a pointer to pointers (skb_p) because we no
longer need to replace the skb inside fr_hard_header.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 4dfdbca54296..409e5a7ad8e2 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -271,10 +271,8 @@ static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 }
 
 
-static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
+static int fr_hard_header(struct sk_buff *skb, u16 dlci)
 {
-	struct sk_buff *skb = *skb_p;
-
 	if (!skb->dev) { /* Control packets */
 		switch (dlci) {
 		case LMI_CCITT_ANSI_DLCI:
@@ -316,13 +314,6 @@ static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
 		}
 
 	} else if (skb->dev->type == ARPHRD_ETHER) {
-		if (skb_headroom(skb) < 10) {
-			struct sk_buff *skb2 = skb_realloc_headroom(skb, 10);
-			if (!skb2)
-				return -ENOBUFS;
-			dev_kfree_skb(skb);
-			skb = *skb_p = skb2;
-		}
 		skb_push(skb, 10);
 		skb->data[3] = FR_PAD;
 		skb->data[4] = NLPID_SNAP;
@@ -429,8 +420,21 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
+	/* We already requested the header space with dev->needed_headroom.
+	 * So this is just a protection in case the upper layer didn't take
+	 * dev->needed_headroom into consideration.
+	 */
+	if (skb_headroom(skb) < 10) {
+		struct sk_buff *skb2 = skb_realloc_headroom(skb, 10);
+
+		if (!skb2)
+			goto drop;
+		dev_kfree_skb(skb);
+		skb = skb2;
+	}
+
 	skb->dev = dev;
-	if (fr_hard_header(&skb, pvc->dlci))
+	if (fr_hard_header(skb, pvc->dlci))
 		goto drop;
 
 	dev->stats.tx_bytes += skb->len;
@@ -498,9 +502,9 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	memset(skb->data, 0, len);
 	skb_reserve(skb, 4);
 	if (lmi == LMI_CISCO) {
-		fr_hard_header(&skb, LMI_CISCO_DLCI);
+		fr_hard_header(skb, LMI_CISCO_DLCI);
 	} else {
-		fr_hard_header(&skb, LMI_CCITT_ANSI_DLCI);
+		fr_hard_header(skb, LMI_CCITT_ANSI_DLCI);
 	}
 	data = skb_tail_pointer(skb);
 	data[i++] = LMI_CALLREF;
-- 
2.25.1

