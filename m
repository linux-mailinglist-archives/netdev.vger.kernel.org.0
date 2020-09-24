Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6D276568
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIXAuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:50:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6B7C0613CE;
        Wed, 23 Sep 2020 17:50:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fa1so706316pjb.0;
        Wed, 23 Sep 2020 17:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=eGHzvbP1qhon99xuRPsfSpWltcv1iK0A3ymOOE3QG2w=;
        b=uxjUocP1eub66soAgwu2xxnFf5sVhAa2nV1i7dZU/rRG/XxU8nPZEv53yX1DHWMrBz
         M4C/lzzuPVUscTEnznPnW/X2zW4oxXN9ZPiNGNpTWWM5FLVAaWqMsULaCv3kFzeIRIRv
         OaCimMjpXEsnvgEHWnuGR2HYWxzE8a/Gpy+BY1qw9s30+VxPfJfCNZXa9jOsedyppgKj
         /V59l247OPj8Rn2gBUasY+BxUCIqF+SxnKyne3GD0X+9Pb4V02M8OWU/NxxKOCcKI867
         IYRvUoA52lbTkVdpCrTcByVrSuiH1pULxY5tecFdPSDmvJRRAoJEpAP8VWDq7D8Z7Fad
         QKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=eGHzvbP1qhon99xuRPsfSpWltcv1iK0A3ymOOE3QG2w=;
        b=bTlICWbB1FqPK+/g4+9/F+fw9UXtRCMwbovqDWt96UlbsyD75HpxIOtMDDlSJWWyUP
         ClcRS89WEcNSU+9PD4lxw9Imb6clXTyLCOxy/cOQCVfMhdQ62frqtVde4bO6zhmUrARB
         lyek6BaBo89zkgZSf01TQRA0qCdJlOv5OE6Dp2mZFXWt1Ij3sa9rGVNTjYl1x9z6iouz
         Tt9D/SJYSKBCY8eCeUOBYGC7wPBuutFYj6x8fFCDhZ4Zi1NSQ8AtxgEbBAS6pVD+fo/E
         6oKKm+tn3VJ/BXbLBlSlvfpbC3LYMlfHlp1jLKTwlvBT7t+2BByDjP4F8t3LcqOLOJSq
         ddww==
X-Gm-Message-State: AOAM531jD4Wgq9ZpV8btp4h2tRm1AbnIyfXvpSM7ZfNfe8KxDvDgkLYw
        HwXBUwB9hO6F8Astq79lU7c=
X-Google-Smtp-Source: ABdhPJwEHNaj3ltTUt6E+6P/5Cur4YU90gZwXagj11ZglgyFPvIJ3sPEhwp0Uzkmn+JH8bGVrQUF/A==
X-Received: by 2002:a17:902:bc82:b029:d2:2988:43ef with SMTP id bb2-20020a170902bc82b02900d2298843efmr2219268plb.68.1600908615131;
        Wed, 23 Sep 2020 17:50:15 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id r2sm813629pga.94.2020.09.23.17.50.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:50:14 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 08/16] mptcp: remove addr and subflow in PM netlink
Date:   Thu, 24 Sep 2020 08:29:54 +0800
Message-Id: <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com> <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the remove announced addr and subflow logic in PM
netlink.

When the PM netlink removes an address, we traverse all the existing msk
sockets to find the relevant sockets.

We add a new list named anno_list in mptcp_pm_data, to record all the
announced addrs. In the traversing, we check if it has been recorded.
If it has been, we trigger the RM_ADDR signal.

We also check if this address is in conn_list. If it is, we remove the
subflow which using this local address.

Since we call mptcp_pm_free_anno_list in mptcp_destroy, we need to move
__mptcp_init_sock before the mptcp_is_enabled check in mptcp_init_sock.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm.c         |   7 ++-
 net/mptcp/pm_netlink.c | 122 +++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.c   |   9 +--
 net/mptcp/protocol.h   |   2 +
 net/mptcp/subflow.c    |   1 +
 5 files changed, 130 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index be4157279e15..f450bf0d49aa 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -26,7 +26,11 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id)
 {
-	return -ENOTSUPP;
+	pr_debug("msk=%p, local_id=%d", msk, local_id);
+
+	msk->pm.rm_id = local_id;
+	WRITE_ONCE(msk->pm.rm_addr_signal, true);
+	return 0;
 }
 
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 remote_id)
@@ -231,6 +235,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.status = 0;
 
 	spin_lock_init(&msk->pm.lock);
+	INIT_LIST_HEAD(&msk->pm.anno_list);
 
 	mptcp_pm_nl_data_init(msk);
 }
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f6f96bc2046b..97f9280f83fb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -177,6 +177,50 @@ static void check_work_pending(struct mptcp_sock *msk)
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
+static bool lookup_anno_list_by_saddr(struct mptcp_sock *msk,
+				      struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &msk->pm.anno_list, list) {
+		if (addresses_equal(&entry->addr, addr, false))
+			return true;
+	}
+
+	return false;
+}
+
+static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
+				     struct mptcp_pm_addr_entry *entry)
+{
+	struct mptcp_pm_addr_entry *clone = NULL;
+
+	if (lookup_anno_list_by_saddr(msk, &entry->addr))
+		return false;
+
+	clone = kmemdup(entry, sizeof(*entry), GFP_ATOMIC);
+	if (!clone)
+		return false;
+
+	list_add(&clone->list, &msk->pm.anno_list);
+
+	return true;
+}
+
+void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
+{
+	struct mptcp_pm_addr_entry *entry, *tmp;
+
+	pr_debug("msk=%p", msk);
+
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry_safe(entry, tmp, &msk->pm.anno_list, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct mptcp_addr_info remote = { 0 };
@@ -197,8 +241,10 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 					      msk->pm.add_addr_signaled);
 
 		if (local) {
-			msk->pm.add_addr_signaled++;
-			mptcp_pm_announce_addr(msk, &local->addr, false);
+			if (mptcp_pm_alloc_anno_list(msk, local)) {
+				msk->pm.add_addr_signaled++;
+				mptcp_pm_announce_addr(msk, &local->addr, false);
+			}
 		} else {
 			/* pick failed, avoid fourther attempts later */
 			msk->pm.local_addr_used = msk->pm.add_addr_signal_max;
@@ -567,6 +613,68 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 	return NULL;
 }
 
+static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
+				      struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_addr_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &msk->pm.anno_list, list) {
+		if (addresses_equal(&entry->addr, addr, false)) {
+			list_del(&entry->list);
+			kfree(entry);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
+				      struct mptcp_addr_info *addr,
+				      bool force)
+{
+	bool ret;
+
+	spin_lock_bh(&msk->pm.lock);
+	ret = remove_anno_list_by_saddr(msk, addr);
+	if (ret || force)
+		mptcp_pm_remove_addr(msk, addr->id);
+	spin_unlock_bh(&msk->pm.lock);
+	return ret;
+}
+
+static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
+						   struct mptcp_addr_info *addr)
+{
+	struct mptcp_sock *msk;
+	long s_slot = 0, s_num = 0;
+
+	pr_debug("remove_id=%d", addr->id);
+
+	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
+		struct sock *sk = (struct sock *)msk;
+		bool remove_subflow;
+
+		if (list_empty(&msk->conn_list)) {
+			mptcp_pm_remove_anno_addr(msk, addr, false);
+			goto next;
+		}
+
+		lock_sock(sk);
+		remove_subflow = lookup_subflow_by_saddr(&msk->conn_list, addr);
+		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow);
+		if (remove_subflow)
+			mptcp_pm_remove_subflow(msk, addr->id);
+		release_sock(sk);
+
+next:
+		sock_put(sk);
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -582,8 +690,8 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	entry = __lookup_addr_by_id(pernet, addr.addr.id);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "address not found");
-		ret = -EINVAL;
-		goto out;
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
 	}
 	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
 		pernet->add_addr_signal_max--;
@@ -592,9 +700,11 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 
 	pernet->addrs--;
 	list_del_rcu(&entry->list);
-	kfree_rcu(entry, rcu);
-out:
 	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
+	kfree_rcu(entry, rcu);
+
 	return ret;
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 26b9233f247c..b53e55826975 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1810,16 +1810,16 @@ static int mptcp_init_sock(struct sock *sk)
 	struct net *net = sock_net(sk);
 	int ret;
 
+	ret = __mptcp_init_sock(sk);
+	if (ret)
+		return ret;
+
 	if (!mptcp_is_enabled(net))
 		return -ENOPROTOOPT;
 
 	if (unlikely(!net->mib.mptcp_statistics) && !mptcp_mib_alloc(net))
 		return -ENOMEM;
 
-	ret = __mptcp_init_sock(sk);
-	if (ret)
-		return ret;
-
 	ret = __mptcp_socket_create(mptcp_sk(sk));
 	if (ret)
 		return ret;
@@ -2137,6 +2137,7 @@ static void mptcp_destroy(struct sock *sk)
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
 
+	mptcp_pm_free_anno_list(msk);
 	sk_sockets_allocated_dec(sk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ba253a6947b0..d1b1416797f8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -160,6 +160,7 @@ enum mptcp_pm_status {
 struct mptcp_pm_data {
 	struct mptcp_addr_info local;
 	struct mptcp_addr_info remote;
+	struct list_head anno_list;
 
 	spinlock_t	lock;		/*protects the whole PM data */
 
@@ -441,6 +442,7 @@ void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id);
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
+void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 141d555b7bd2..a1fefc965e17 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -437,6 +437,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 
 	skb_rbtree_purge(&mptcp_sk(sk)->out_of_order_queue);
 	mptcp_token_destroy(mptcp_sk(sk));
+	mptcp_pm_free_anno_list(mptcp_sk(sk));
 	inet_sock_destruct(sk);
 }
 
-- 
2.17.1

