Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35470332A32
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhCIPT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhCIPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:19:08 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8712AC06174A;
        Tue,  9 Mar 2021 07:19:08 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id w7so3238535pll.8;
        Tue, 09 Mar 2021 07:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujBTFVqKiDtMsUz1Y0DEYGU/7qEPuVXJSfA0pereZLY=;
        b=c53w5nrfKxvb2DDwLr3DBdM9MTuZgwdsu8HMnTSiXeMxIJj2H+4SegPXbFi0cA5TQ8
         Seu8vVQ3bchm2KzWnoa157oEZ85aHJS4Y+CwBDkxKvR5mXa+kWSGAjYNUnVotux4KNAY
         finnpT5TS2IdHs4oBuqB7wh7CMAa1fzlWApl68pFap3m06UOpDyJWUuAz7z45zDNMNrx
         54qh5eHuw7McWKPJMqeKzQKn9SWmIammYDa3t6cSLLr48RjThvrJ2HbHaycJrK9SC86s
         0c+QUPPDvF98DepaRomcFH8oSAlgiNRkRODf5qEcCFFq7bfYiHOkkUXV3b7XbBMyipQ/
         ZH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujBTFVqKiDtMsUz1Y0DEYGU/7qEPuVXJSfA0pereZLY=;
        b=ICXSb8NYmz8DmoXKwfLRatPq0H91TK7VhGhavCIPl8zKE3dv9MVCDz9XAEE8nkr3yv
         Txq0KTR4b+qA5J1NUVL2OyLCCyrYEYcS4inTIRi4qElKFjMK316wDX1+YDV00mkaoeaJ
         Y/NnAbGUx0/yUy5cnnvaOxalCOsNH+r8eBiCQq6aWTzYt942xL7rI+Xrc8fD1Qu4wmnj
         3N7bkRdOx+IH3+EmULRMxgrjTyR6OqcohTF8Hdlk95lqlbVN7ECrRlp9EI1I+5ruqK4G
         27ypBLdH4o/PFLSl4JrGXXt79YBSv4LGsdx0cycYYDss5YdYhZRriiGEYoD05bbVSvhh
         zEPw==
X-Gm-Message-State: AOAM530kmmwJ2V4QgGZrx/CXGsFKI/nH55YdMKD/v+J/fYBElz6nGNpk
        lq1k7AbyNsdIPM9KlVymRmA=
X-Google-Smtp-Source: ABdhPJz3zP6V8okVdtrz9ho5DNj/SEHMrN601qx5CxtDRoU04ONYGH92HFcWejxNI4dEciwuzBKNzA==
X-Received: by 2002:a17:90a:29a3:: with SMTP id h32mr5386815pjd.209.1615303148070;
        Tue, 09 Mar 2021 07:19:08 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id y15sm15835282pgi.31.2021.03.09.07.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 07:19:07 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, mkubecek@suse.cz, dsahern@kernel.org,
        zhudi21@huawei.com, johannes.berg@intel.com,
        marcelo.leitner@gmail.com, dong.menglong@zte.com.cn,
        ast@kernel.org, yhs@fb.com, rdunlap@infradead.org,
        yangyingliang@huawei.com, 0x7f454c46@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: netlink: remove netlink_broadcast_filtered
Date:   Tue,  9 Mar 2021 23:18:34 +0800
Message-Id: <20210309151834.58675-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

It seems that 'netlink_broadcast_filtered()' is not used anywhere
besides 'netlink_broadcast()'. In order to reduce function calls,
just remove it.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/linux/netlink.h  |  4 ----
 net/netlink/af_netlink.c | 22 ++--------------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 0bcf98098c5a..277f33e64bb3 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -160,10 +160,6 @@ bool netlink_strict_get_check(struct sk_buff *skb);
 int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
 int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
 		      __u32 group, gfp_t allocation);
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
-			       __u32 portid, __u32 group, gfp_t allocation,
-			       int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-			       void *filter_data);
 int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
 int netlink_register_notifier(struct notifier_block *nb);
 int netlink_unregister_notifier(struct notifier_block *nb);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dd488938447f..b462fdc87e9b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1405,8 +1405,6 @@ struct netlink_broadcast_data {
 	int delivered;
 	gfp_t allocation;
 	struct sk_buff *skb, *skb2;
-	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
-	void *tx_data;
 };
 
 static void do_one_broadcast(struct sock *sk,
@@ -1460,11 +1458,6 @@ static void do_one_broadcast(struct sock *sk,
 			p->delivery_failure = 1;
 		goto out;
 	}
-	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
-		kfree_skb(p->skb2);
-		p->skb2 = NULL;
-		goto out;
-	}
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
@@ -1487,10 +1480,8 @@ static void do_one_broadcast(struct sock *sk,
 	sock_put(sk);
 }
 
-int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid,
-	u32 group, gfp_t allocation,
-	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
-	void *filter_data)
+int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
+		      u32 group, gfp_t allocation)
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
@@ -1509,8 +1500,6 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	info.allocation = allocation;
 	info.skb = skb;
 	info.skb2 = NULL;
-	info.tx_filter = filter;
-	info.tx_data = filter_data;
 
 	/* While we sleep in clone, do not allow to change socket list */
 
@@ -1536,14 +1525,7 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb, u32 portid
 	}
 	return -ESRCH;
 }
-EXPORT_SYMBOL(netlink_broadcast_filtered);
 
-int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
-		      u32 group, gfp_t allocation)
-{
-	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
-		NULL, NULL);
-}
 EXPORT_SYMBOL(netlink_broadcast);
 
 struct netlink_set_err_data {
-- 
2.30.1

