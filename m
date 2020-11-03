Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225512A3D2F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgKCHK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:26 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67442C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:26 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id 1so8153316ple.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dibpCTFspvW/4xr+M6WRNfc+h/zPS3TVICoj/xJH1iI=;
        b=tAr8Ubt6R2Qet43sFuuaUWUGW5QHQQKPHO+P8UivK400PZ2Imn24qkST3uuWz2Cz5p
         NgNA4pFhHE4zluix0H+bsUQaJJeGQydl0h8AhhR9X5UqIfuxWdYnpO5xukoZykqBOHxr
         FdZFROBzRlzfPlLCAdBSasVnQxvMe2yEHlh5Z0spYSwR7MC8v1NugtLHmo29fyyPkyS/
         QCh9ffTmn7LsFA7CabrRIlT0nzSHE3ypkQ4qRbXscEIqnglh0cC0Wi/9yIwb7iBuTBjk
         VrsEnDItlHxsL03IuVYeP9dukpX6PjtbzJ8VD4Fv1bvi4qCVDAm3Mc0goR/Vb3Zs0VA7
         DgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dibpCTFspvW/4xr+M6WRNfc+h/zPS3TVICoj/xJH1iI=;
        b=V7iHO1EduFjHI2HtSU0KSTC6BwILyL8FPB0I/OQ8VDcLtCKVB1pUfD+Vp0JS1IdS1E
         0/No+DuwWFs/HS5QhbZaEBv0gR+QPse8w84Y/sGCwq3bwNpSeVrWGullr9BPrv6bzoQc
         334iNvBIiShK9MUMG8yCDoabEP6ApOD+UG9dJl2LDxLnI7SsheHZb1yAndrbZUM5h8/M
         sKyDWebQ9rc1OUhUVLbCkBYTOJpzQjA4F36YWmwLvH5kAbhipj5lNgiHsqSy7dwmcnsH
         KF2Vw9VU/tVBZapGKyybWijpJ0vDB0jK586K+M+NW6z3XqtVLrTwsNJBqt5WId+gjUBD
         +CAQ==
X-Gm-Message-State: AOAM532NRVQwBnoeIAvlrNECIRYLY73HAqqj4upLoOKuHRpWP9nXKHXK
        W+Gyzv1RsjfrfzQ8IvXsjGo=
X-Google-Smtp-Source: ABdhPJxTmH+dlFOJjhyGispvMXdmIPrASrqPcPl/9W70UWIE2jzOirQAoxKj5k/Kfsa1VKXvbgVowQ==
X-Received: by 2002:a17:902:c14b:b029:d6:ab18:108d with SMTP id 11-20020a170902c14bb02900d6ab18108dmr16912534plj.20.1604387425833;
        Mon, 02 Nov 2020 23:10:25 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:25 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 3/8] net: mac80211: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:42 +0530
Message-Id: <20201103070947.577831-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2a21226fb518..2a3b0ee65637 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1795,7 +1795,7 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
-void ieee80211_tx_pending(unsigned long data);
+void ieee80211_tx_pending(struct tasklet_struct *t);
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
@@ -2146,7 +2146,7 @@ void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
 void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
 			      struct txq_info *txqi);
-void ieee80211_wake_txqs(unsigned long data);
+void ieee80211_wake_txqs(struct tasklet_struct *t);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 523380aed92e..48ab05186610 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -220,9 +220,9 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 	       BSS_CHANGED_ERP_SLOT;
 }
 
-static void ieee80211_tasklet_handler(unsigned long data)
+static void ieee80211_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -733,16 +733,12 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		skb_queue_head_init(&local->pending[i]);
 		atomic_set(&local->agg_queue_stop[i], 0);
 	}
-	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
-		     (unsigned long)local);
+	tasklet_setup(&local->tx_pending_tasklet, ieee80211_tx_pending);
 
 	if (ops->wake_tx_queue)
-		tasklet_init(&local->wake_txqs_tasklet, ieee80211_wake_txqs,
-			     (unsigned long)local);
+		tasklet_setup(&local->wake_txqs_tasklet, ieee80211_wake_txqs);
 
-	tasklet_init(&local->tasklet,
-		     ieee80211_tasklet_handler,
-		     (unsigned long) local);
+	tasklet_setup(&local->tasklet, ieee80211_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8ba10a48ded4..a50c0edb1153 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4406,9 +4406,10 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 /*
  * Transmit all pending packets. Called from tasklet.
  */
-void ieee80211_tx_pending(unsigned long data)
+void ieee80211_tx_pending(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     tx_pending_tasklet);
 	unsigned long flags;
 	int i;
 	bool txok;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 49342060490f..a25e47750ed9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -386,9 +386,10 @@ _ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
 	rcu_read_unlock();
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+void ieee80211_wake_txqs(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     wake_txqs_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-- 
2.25.1

