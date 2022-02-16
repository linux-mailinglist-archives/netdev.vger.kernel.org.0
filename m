Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732A54B7D3A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbiBPCMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:12:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343554AbiBPCLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2FE13F70
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977502; x=1676513502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NkdAJIGsRLn1vhb0YgFtbfCD2pFe2pKEMJ57wn90ubg=;
  b=QF9ULc5ysxWB6Bxh2XPj3xeCjewiyF/KSIEPMchND4dUOFDq6YJKnHqR
   PlPkdxLHhS78Jf7Vo5/PltZWq3d2/uODnNtXkOyMlsyxfxoezQmxRErIX
   T69GJ8l6TZ9xzFt5NOWOaXye27RgAoGPK2PfITz0Q/15DLNBtzgyzDw/A
   ymbb+N4LqAbuWSVqf883KAlWouUirh0yXCZ8DnnAzJKLqpUo2mxYY6M3E
   dJZ0zZAD/7JGm3N/CcUYjjpg1cXezRiCNoaxG74tnZ3KOGYqFZvuHThFb
   dIjYDn9+DQIPs6pp6Dj0KcqWNPFStksXgqDKH6gjzISLl5UkwbNAzbG/7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909081"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909081"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088824"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: constify a bunch of of helpers
Date:   Tue, 15 Feb 2022 18:11:28 -0800
Message-Id: <20220216021130.171786-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
References: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

A few pm-related helpers don't touch arguments which lacking
the const modifier, let's constify them.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         |  4 ++--
 net/mptcp/pm_netlink.c | 42 +++++++++++++++++++++---------------------
 net/mptcp/protocol.h   | 18 +++++++++---------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index ef6e4adeb0e5..8755b81896de 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -219,7 +219,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 }
 
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
-			      struct mptcp_addr_info *addr)
+			      const struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
 
@@ -275,7 +275,7 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 
 /* path manager helpers */
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
 			      bool *drop_other_suboptions)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e4fd54fff1d2..9aeee30e50ba 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -120,7 +120,7 @@ static void remote_address(const struct sock_common *skc,
 }
 
 static bool lookup_subflow_by_saddr(const struct list_head *list,
-				    struct mptcp_addr_info *saddr)
+				    const struct mptcp_addr_info *saddr)
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_addr_info cur;
@@ -138,7 +138,7 @@ static bool lookup_subflow_by_saddr(const struct list_head *list,
 }
 
 static bool lookup_subflow_by_daddr(const struct list_head *list,
-				    struct mptcp_addr_info *daddr)
+				    const struct mptcp_addr_info *daddr)
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_addr_info cur;
@@ -157,10 +157,10 @@ static bool lookup_subflow_by_daddr(const struct list_head *list,
 
 static struct mptcp_pm_addr_entry *
 select_local_address(const struct pm_nl_pernet *pernet,
-		     struct mptcp_sock *msk)
+		     const struct mptcp_sock *msk)
 {
+	const struct sock *sk = (const struct sock *)msk;
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
-	struct sock *sk = (struct sock *)msk;
 
 	msk_owned_by_me(msk);
 
@@ -190,7 +190,7 @@ select_local_address(const struct pm_nl_pernet *pernet,
 }
 
 static struct mptcp_pm_addr_entry *
-select_signal_address(struct pm_nl_pernet *pernet, struct mptcp_sock *msk)
+select_signal_address(struct pm_nl_pernet *pernet, const struct mptcp_sock *msk)
 {
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
 
@@ -214,16 +214,16 @@ select_signal_address(struct pm_nl_pernet *pernet, struct mptcp_sock *msk)
 	return ret;
 }
 
-unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk)
+unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk)
 {
-	struct pm_nl_pernet *pernet;
+	const struct pm_nl_pernet *pernet;
 
-	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+	pernet = net_generic(sock_net((const struct sock *)msk), pm_nl_pernet_id);
 	return READ_ONCE(pernet->add_addr_signal_max);
 }
 EXPORT_SYMBOL_GPL(mptcp_pm_get_add_addr_signal_max);
 
-unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk)
+unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk)
 {
 	struct pm_nl_pernet *pernet;
 
@@ -232,7 +232,7 @@ unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk)
 }
 EXPORT_SYMBOL_GPL(mptcp_pm_get_add_addr_accept_max);
 
-unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk)
+unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk)
 {
 	struct pm_nl_pernet *pernet;
 
@@ -241,7 +241,7 @@ unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk)
 }
 EXPORT_SYMBOL_GPL(mptcp_pm_get_subflows_max);
 
-unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk)
+unsigned int mptcp_pm_get_local_addr_max(const struct mptcp_sock *msk)
 {
 	struct pm_nl_pernet *pernet;
 
@@ -264,8 +264,8 @@ bool mptcp_pm_nl_check_work_pending(struct mptcp_sock *msk)
 }
 
 struct mptcp_pm_add_entry *
-mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
-				struct mptcp_addr_info *addr)
+mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
+				const struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_add_entry *entry;
 
@@ -346,7 +346,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr, bool check_id)
+		       const struct mptcp_addr_info *addr, bool check_id)
 {
 	struct mptcp_pm_add_entry *entry;
 	struct sock *sk = (struct sock *)msk;
@@ -364,7 +364,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock *msk,
 }
 
 static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
-				     struct mptcp_pm_addr_entry *entry)
+				     const struct mptcp_pm_addr_entry *entry)
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
@@ -410,8 +410,8 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 	}
 }
 
-static bool lookup_address_in_vec(struct mptcp_addr_info *addrs, unsigned int nr,
-				  struct mptcp_addr_info *addr)
+static bool lookup_address_in_vec(const struct mptcp_addr_info *addrs, unsigned int nr,
+				  const struct mptcp_addr_info *addr)
 {
 	int i;
 
@@ -493,9 +493,9 @@ __lookup_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *info,
 }
 
 static int
-lookup_id_by_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
+lookup_id_by_addr(const struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_addr_entry *entry;
+	const struct mptcp_pm_addr_entry *entry;
 	int ret = -1;
 
 	rcu_read_lock();
@@ -1281,7 +1281,7 @@ int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
 }
 
 static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
-				      struct mptcp_addr_info *addr)
+				      const struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_add_entry *entry;
 
@@ -1296,7 +1296,7 @@ static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 }
 
 static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
-				      struct mptcp_addr_info *addr,
+				      const struct mptcp_addr_info *addr,
 				      bool force)
 {
 	struct mptcp_rm_list list = { .nr = 0 };
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e381054910d0..86910f20486a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -742,7 +742,7 @@ void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
-			      struct mptcp_addr_info *addr);
+			      const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
@@ -753,10 +753,10 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr, bool check_id);
+		       const struct mptcp_addr_info *addr, bool check_id);
 struct mptcp_pm_add_entry *
-mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
-				struct mptcp_addr_info *addr);
+mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
+				const struct mptcp_addr_info *addr);
 int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
 					 u8 *flags, int *ifindex);
 
@@ -815,7 +815,7 @@ static inline int mptcp_rm_addr_len(const struct mptcp_rm_list *rm_list)
 	return TCPOLEN_MPTCP_RM_ADDR_BASE + roundup(rm_list->nr - 1, 4) + 1;
 }
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
 			      bool *drop_other_suboptions);
@@ -829,10 +829,10 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 				     const struct mptcp_rm_list *rm_list);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk);
-unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
-unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
-unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_local_addr_max(const struct mptcp_sock *msk);
 
 void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_sockopt_sync_locked(struct mptcp_sock *msk, struct sock *ssk);
-- 
2.35.1

