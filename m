Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE1C313C01
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhBHR7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbhBHR6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:58:14 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E51CC061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:57:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t25so10734009pga.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=87dKznQF9BcYTx3/CoiSqxSJWajDfwYuHToW7R6j35o=;
        b=Ul5YYv8Auddi05Aa3L6Y/12fLRcPRb2skehxwUcZnExujS05lBt8LEIp38czcUh8tc
         iUZGW2okgQIKJIDbHxr/TY1z+kddVieE5yElAS3B5jxX/AUiH01M8iJ/uh+obyHMVWLO
         5L+DCKPYgbvm3d/o4hcR2bR1Y7OTz2EhwnHmvou4YN3xeU1un4ExQMDp6dUT+RMgNLpS
         ESXwh9AD2a6Drl+HzmG7bTMVPhtlZtA36Oyed4UdhPCq9I3I1EjHfL7adjXR4qJprXJe
         NjHB+X/2DhUsGyqF69mOjrRJNrS6RjYQSi7caigs9/I/yZXKvRY6mw9jyZVeaFEi0JbK
         hV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=87dKznQF9BcYTx3/CoiSqxSJWajDfwYuHToW7R6j35o=;
        b=d9pkAVxSWF7gS3Bjq4i1PWPrKESAAsRIfuJ/8u/7q/aHqXsX257/dH3Hd1NVJVaMcV
         Nb/fj1u33LUWoVf8BKaepzzbrlZiTB3D/zzniOXCyCLNB791B+ti+KWlknl9Sk7Kd9sc
         FXY5BkfvTBauv1+WPU1JKE4nVcctKT+h7TPWUHun59ngLZowAn2z5PZOw+Cow6JTcHgo
         3Z64myJ/kUpAyaTYCdrzvDYsy7en7zEXJejFbPgg3Dn2KTpEyo98o+POBVCHefHaUYRx
         8pTnLwIv8qhL8BVJnZLaLFcClRXX+ZKYAeinQ1vCjI5ApOR3oPo3DPl5MVFkYz4tvNxq
         TLDg==
X-Gm-Message-State: AOAM53371ZTJ0BSM3UrROIvBALGXFcm3fLsgAzEKRNW62JKfdUkXQM/4
        zWKRrbNVvhKq6Qnf2Ea7pNJcs3WzSjI=
X-Google-Smtp-Source: ABdhPJzFY1S3A4kOvme9MpeURG8tgSkhgv/OdYdqo3TxwKBVb6QxQIHYIjTakRTUTob7wL2b8cISwg==
X-Received: by 2002:a63:ed42:: with SMTP id m2mr4032723pgk.95.1612807079071;
        Mon, 08 Feb 2021 09:57:59 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id x141sm18629732pfc.128.2021.02.08.09.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:57:58 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com,
        ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, yoshfuji@linux-ipv6.org, edumazet@google.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, alex.aring@gmail.com,
        linmiaohe@huawei.com, praveen5582@gmail.com, rdunlap@infradead.org,
        willemb@google.com, rdias@singlestore.com,
        matthieu.baerts@tessares.net, paul@paul-moore.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 6/8] mld: convert ipv6_mc_socklist to list macros
Date:   Mon,  8 Feb 2021 17:57:48 +0000
Message-Id: <20210208175748.5628-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct ipv6_mc_socklist doesn't use list API so that code
shape is a little bit different from others.
So it converts ipv6_mc_socklist to use list API so it would
improve readability.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   1 +
 include/linux/ipv6.h                          |   2 +-
 include/net/if_inet6.h                        |   2 +-
 net/dccp/ipv6.c                               |   4 +-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/mcast.c                              | 190 +++++++++---------
 net/ipv6/tcp_ipv6.c                           |   4 +-
 net/sctp/ipv6.c                               |   2 +-
 8 files changed, 105 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 19dc7dc054a2..729d9de9db62 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1204,6 +1204,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		newsk->sk_v6_rcv_saddr = treq->ir_v6_loc_addr;
 		inet6_sk(newsk)->saddr = treq->ir_v6_loc_addr;
 		newnp->ipv6_fl_list = NULL;
+		INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 		newnp->pktoptions = NULL;
 		newsk->sk_bound_dev_if = treq->ir_iif;
 		newinet->inet_opt = NULL;
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 9d1f29f0c512..66533e42a758 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -282,7 +282,7 @@ struct ipv6_pinfo {
 	__u32			dst_cookie;
 	__u32			rx_dst_cookie;
 
-	struct ipv6_mc_socklist	__rcu *ipv6_mc_list;
+	struct list_head	ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
 	struct ipv6_fl_socklist __rcu *ipv6_fl_list;
 
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 096c0554d199..babf19c27b29 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -90,7 +90,7 @@ struct ipv6_mc_socklist {
 	struct in6_addr		addr;
 	int			ifindex;
 	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
-	struct ipv6_mc_socklist __rcu *next;
+	struct list_head	list;
 	rwlock_t		sflock;
 	struct ip6_sf_socklist	*sflist;
 	struct rcu_head		rcu;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1f73603913f5..3a6332b9b845 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -430,7 +430,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		newsk->sk_backlog_rcv = dccp_v4_do_rcv;
 		newnp->pktoptions  = NULL;
 		newnp->opt	   = NULL;
-		newnp->ipv6_mc_list = NULL;
+		INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 		newnp->ipv6_ac_list = NULL;
 		newnp->ipv6_fl_list = NULL;
 		newnp->mcast_oif   = inet_iif(skb);
@@ -497,7 +497,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	/* Clone RX bits */
 	newnp->rxopt.all = np->rxopt.all;
 
-	newnp->ipv6_mc_list = NULL;
+	INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 	newnp->ipv6_ac_list = NULL;
 	newnp->ipv6_fl_list = NULL;
 	newnp->pktoptions = NULL;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index ace6527171bd..ae3a1865189f 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -207,6 +207,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 
 	inet_sk(sk)->pinet6 = np = inet6_sk_generic(sk);
 	np->hop_limit	= -1;
+	INIT_LIST_HEAD(&np->ipv6_mc_list);
 	np->mcast_hops	= IPV6_DEFAULT_MCASTHOPS;
 	np->mc_loop	= 1;
 	np->mc_all	= 1;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 21f3bbec5568..f4fc29fcdf48 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -85,7 +85,7 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta);
-static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
+static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
 			    struct inet6_dev *idev);
 static int __ipv6_dev_mc_inc(struct net_device *dev,
 			     const struct in6_addr *addr, unsigned int mode);
@@ -109,11 +109,6 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
  *	socket join on multicast group
  */
 
-#define for_each_mc_rcu(np, mc)				\
-	for (mc = rcu_dereference((np)->ipv6_mc_list);	\
-	     mc;					\
-	     mc = rcu_dereference(mc->next))
-
 static void mca_get(struct ifmcaddr6 *mc)
 {
 	refcount_inc(&mc->mca_refcnt);
@@ -142,10 +137,10 @@ static int unsolicited_report_interval(struct inet6_dev *idev)
 static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 			       const struct in6_addr *addr, unsigned int mode)
 {
-	struct net_device *dev = NULL;
-	struct ipv6_mc_socklist *mc_lst;
 	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
+	struct net_device *dev = NULL;
 	int err;
 
 	ASSERT_RTNL();
@@ -153,22 +148,17 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
 
-	rcu_read_lock();
-	for_each_mc_rcu(np, mc_lst) {
+	list_for_each_entry(mc_lst, &np->ipv6_mc_list, list) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
-		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-			rcu_read_unlock();
+		    ipv6_addr_equal(&mc_lst->addr, addr))
 			return -EADDRINUSE;
-		}
 	}
-	rcu_read_unlock();
 
 	mc_lst = sock_kmalloc(sk, sizeof(struct ipv6_mc_socklist), GFP_KERNEL);
-
 	if (!mc_lst)
 		return -ENOMEM;
 
-	mc_lst->next = NULL;
+	INIT_LIST_HEAD(&mc_lst->list);
 	mc_lst->addr = *addr;
 
 	if (ifindex == 0) {
@@ -202,8 +192,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 		return err;
 	}
 
-	mc_lst->next = np->ipv6_mc_list;
-	rcu_assign_pointer(np->ipv6_mc_list, mc_lst);
+	list_add_rcu(&mc_lst->list, &np->ipv6_mc_list);
 
 	return 0;
 }
@@ -227,7 +216,6 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct ipv6_mc_socklist *mc_lst;
-	struct ipv6_mc_socklist __rcu **lnk;
 	struct net *net = sock_net(sk);
 
 	ASSERT_RTNL();
@@ -235,25 +223,22 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
 
-	for (lnk = &np->ipv6_mc_list;
-	     (mc_lst = rtnl_dereference(*lnk)) != NULL;
-	      lnk = &mc_lst->next) {
+	list_for_each_entry(mc_lst, &np->ipv6_mc_list, list) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
 			struct net_device *dev;
 
-			*lnk = mc_lst->next;
-
 			dev = __dev_get_by_index(net, mc_lst->ifindex);
 			if (dev) {
 				struct inet6_dev *idev = __in6_dev_get(dev);
 
-				(void) ip6_mc_leave_src(sk, mc_lst, idev);
+				ip6_mc_leave_src(sk, mc_lst, idev);
 				if (idev)
 					__ipv6_dev_mc_dec(idev, &mc_lst->addr);
 			} else
-				(void) ip6_mc_leave_src(sk, mc_lst, NULL);
+				ip6_mc_leave_src(sk, mc_lst, NULL);
 
+			list_del_rcu(&mc_lst->list);
 			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
 			kfree_rcu(mc_lst, rcu);
 			return 0;
@@ -297,27 +282,27 @@ static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
 
 void __ipv6_sock_mc_close(struct sock *sk)
 {
+	struct ipv6_mc_socklist *mc_lst, *tmp;
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
 
 	ASSERT_RTNL();
 
-	while ((mc_lst = rtnl_dereference(np->ipv6_mc_list)) != NULL) {
+	list_for_each_entry_safe(mc_lst, tmp, &np->ipv6_mc_list, list) {
 		struct net_device *dev;
 
-		np->ipv6_mc_list = mc_lst->next;
-
 		dev = __dev_get_by_index(net, mc_lst->ifindex);
 		if (dev) {
 			struct inet6_dev *idev = __in6_dev_get(dev);
 
-			(void) ip6_mc_leave_src(sk, mc_lst, idev);
+			ip6_mc_leave_src(sk, mc_lst, idev);
 			if (idev)
 				__ipv6_dev_mc_dec(idev, &mc_lst->addr);
-		} else
-			(void) ip6_mc_leave_src(sk, mc_lst, NULL);
+		} else {
+			ip6_mc_leave_src(sk, mc_lst, NULL);
+		}
 
+		list_del_rcu(&mc_lst->list);
 		atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
 		kfree_rcu(mc_lst, rcu);
 	}
@@ -327,23 +312,27 @@ void ipv6_sock_mc_close(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 
-	if (!rcu_access_pointer(np->ipv6_mc_list))
-		return;
 	rtnl_lock();
+	if (list_empty(&np->ipv6_mc_list)) {
+		rtnl_unlock();
+		return;
+	}
+
 	__ipv6_sock_mc_close(sk);
 	rtnl_unlock();
 }
 
 int ip6_mc_source(int add, int omode, struct sock *sk,
-	struct group_source_req *pgsr)
+		  struct group_source_req *pgsr)
 {
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct in6_addr *source, *group;
+	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
-	struct ipv6_mc_socklist *mc;
 	struct ip6_sf_socklist *psl;
 	struct inet6_dev *idev;
 	int leavegroup = 0;
+	bool found = false;
 	int mclocked = 0;
 	int i, j, rv;
 	int err;
@@ -363,33 +352,35 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 
 	err = -EADDRNOTAVAIL;
 
-	for_each_mc_rcu(inet6, mc) {
-		if (pgsr->gsr_interface && mc->ifindex != pgsr->gsr_interface)
+	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+		if (pgsr->gsr_interface && mc_lst->ifindex != pgsr->gsr_interface)
 			continue;
-		if (ipv6_addr_equal(&mc->addr, group))
+		if (ipv6_addr_equal(&mc_lst->addr, group)) {
+			found = true;
 			break;
+		}
 	}
-	if (!mc) {		/* must have a prior join */
+	if (!found) {		/* must have a prior join */
 		err = -EINVAL;
 		goto done;
 	}
 	/* if a source filter was set, must be the same mode as before */
-	if (mc->sflist) {
-		if (mc->sfmode != omode) {
+	if (mc_lst->sflist) {
+		if (mc_lst->sfmode != omode) {
 			err = -EINVAL;
 			goto done;
 		}
-	} else if (mc->sfmode != omode) {
+	} else if (mc_lst->sfmode != omode) {
 		/* allow mode switches for empty-set filters */
 		ip6_mc_add_src(idev, group, omode, 0, NULL, 0);
-		ip6_mc_del_src(idev, group, mc->sfmode, 0, NULL, 0);
-		mc->sfmode = omode;
+		ip6_mc_del_src(idev, group, mc_lst->sfmode, 0, NULL, 0);
+		mc_lst->sfmode = omode;
 	}
 
-	write_lock(&mc->sflock);
+	write_lock(&mc_lst->sflock);
 	mclocked = 1;
 
-	psl = mc->sflist;
+	psl = mc_lst->sflist;
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -442,7 +433,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 			sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
 		}
 		psl = newpsl;
-		mc->sflist = psl;
+		mc_lst->sflist = psl;
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -459,7 +450,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
 	if (mclocked)
-		write_unlock(&mc->sflock);
+		write_unlock(&mc_lst->sflock);
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 	if (leavegroup)
@@ -472,11 +463,12 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 {
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *newpsl, *psl;
+	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
 	const struct in6_addr *group;
-	struct ipv6_mc_socklist *mc;
 	struct inet6_dev *idev;
 	int leavegroup = 0;
+	bool found = false;
 	int i, err;
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
@@ -502,13 +494,15 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	for_each_mc_rcu(inet6, mc) {
-		if (mc->ifindex != gsf->gf_interface)
+	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+		if (mc_lst->ifindex != gsf->gf_interface)
 			continue;
-		if (ipv6_addr_equal(&mc->addr, group))
+		if (ipv6_addr_equal(&mc_lst->addr, group)) {
+			found = true;
 			break;
+		}
 	}
-	if (!mc) {		/* must have a prior join */
+	if (!found) {		/* must have a prior join */
 		err = -EINVAL;
 		goto done;
 	}
@@ -537,17 +531,17 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
 	}
 
-	write_lock(&mc->sflock);
-	psl = mc->sflist;
+	write_lock(&mc_lst->sflock);
+	psl = mc_lst->sflist;
 	if (psl) {
-		ip6_mc_del_src(idev, group, mc->sfmode,
+		ip6_mc_del_src(idev, group, mc_lst->sfmode,
 			       psl->sl_count, psl->sl_addr, 0);
 		sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
 	} else
-		ip6_mc_del_src(idev, group, mc->sfmode, 0, NULL, 0);
-	mc->sflist = newpsl;
-	mc->sfmode = gsf->gf_fmode;
-	write_unlock(&mc->sflock);
+		ip6_mc_del_src(idev, group, mc_lst->sfmode, 0, NULL, 0);
+	mc_lst->sflist = newpsl;
+	mc_lst->sfmode = gsf->gf_fmode;
+	write_unlock(&mc_lst->sflock);
 	err = 0;
 done:
 	read_unlock_bh(&idev->lock);
@@ -560,13 +554,14 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 		  struct sockaddr_storage __user *p)
 {
+	struct ipv6_pinfo *inet6 = inet6_sk(sk);
+	struct ipv6_mc_socklist *mc_lst;
+	struct net *net = sock_net(sk);
 	int err, i, count, copycount;
 	const struct in6_addr *group;
-	struct ipv6_mc_socklist *mc;
-	struct inet6_dev *idev;
-	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *psl;
-	struct net *net = sock_net(sk);
+	struct inet6_dev *idev;
+	bool found = false;
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
@@ -587,16 +582,18 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	 * so reading the list is safe.
 	 */
 
-	for_each_mc_rcu(inet6, mc) {
-		if (mc->ifindex != gsf->gf_interface)
+	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+		if (mc_lst->ifindex != gsf->gf_interface)
 			continue;
-		if (ipv6_addr_equal(group, &mc->addr))
+		if (ipv6_addr_equal(group, &mc_lst->addr)) {
+			found = true;
 			break;
+		}
 	}
-	if (!mc)		/* must have a prior join */
+	if (!found)		/* must have a prior join */
 		goto done;
-	gsf->gf_fmode = mc->sfmode;
-	psl = mc->sflist;
+	gsf->gf_fmode = mc_lst->sfmode;
+	psl = mc_lst->sflist;
 	count = psl ? psl->sl_count : 0;
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
@@ -604,7 +601,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
 	/* changes to psl require the socket lock, and a write lock
-	 * on mc->sflock. We have the socket lock so reading here is safe.
+	 * on mc_lst->sflock. We have the socket lock so reading here is safe.
 	 */
 	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_in6 *psin6;
@@ -628,23 +625,25 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct ipv6_mc_socklist *mc;
+	struct ipv6_mc_socklist *mc_lst;
+	bool rv = true, found = false;
 	struct ip6_sf_socklist *psl;
-	bool rv = true;
 
 	rcu_read_lock();
-	for_each_mc_rcu(np, mc) {
-		if (ipv6_addr_equal(&mc->addr, mc_addr))
+	list_for_each_entry_rcu(mc_lst, &np->ipv6_mc_list, list) {
+		if (ipv6_addr_equal(&mc_lst->addr, mc_addr)) {
+			found = true;
 			break;
+		}
 	}
-	if (!mc) {
+	if (!found) {
 		rcu_read_unlock();
 		return np->mc_all;
 	}
-	read_lock(&mc->sflock);
-	psl = mc->sflist;
+	read_lock(&mc_lst->sflock);
+	psl = mc_lst->sflist;
 	if (!psl) {
-		rv = mc->sfmode == MCAST_EXCLUDE;
+		rv = mc_lst->sfmode == MCAST_EXCLUDE;
 	} else {
 		int i;
 
@@ -652,12 +651,12 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 			if (ipv6_addr_equal(&psl->sl_addr[i], src_addr))
 				break;
 		}
-		if (mc->sfmode == MCAST_INCLUDE && i >= psl->sl_count)
+		if (mc_lst->sfmode == MCAST_INCLUDE && i >= psl->sl_count)
 			rv = false;
-		if (mc->sfmode == MCAST_EXCLUDE && i < psl->sl_count)
+		if (mc_lst->sfmode == MCAST_EXCLUDE && i < psl->sl_count)
 			rv = false;
 	}
-	read_unlock(&mc->sflock);
+	read_unlock(&mc_lst->sflock);
 	rcu_read_unlock();
 
 	return rv;
@@ -2463,22 +2462,25 @@ static void mld_join_group(struct ifmcaddr6 *mc)
 	spin_unlock_bh(&mc->mca_lock);
 }
 
-static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
+static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
 			    struct inet6_dev *idev)
 {
 	int err;
 
-	write_lock_bh(&iml->sflock);
-	if (!iml->sflist) {
+	write_lock_bh(&mc_lst->sflock);
+	if (!mc_lst->sflist) {
 		/* any-source empty exclude case */
-		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode, 0, NULL, 0);
+		err = ip6_mc_del_src(idev, &mc_lst->addr, mc_lst->sfmode,
+				     0, NULL, 0);
 	} else {
-		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode,
-				iml->sflist->sl_count, iml->sflist->sl_addr, 0);
-		sock_kfree_s(sk, iml->sflist, IP6_SFLSIZE(iml->sflist->sl_max));
-		iml->sflist = NULL;
-	}
-	write_unlock_bh(&iml->sflock);
+		err = ip6_mc_del_src(idev, &mc_lst->addr, mc_lst->sfmode,
+				     mc_lst->sflist->sl_count,
+				     mc_lst->sflist->sl_addr, 0);
+		sock_kfree_s(sk, mc_lst->sflist,
+			     IP6_SFLSIZE(mc_lst->sflist->sl_max));
+		mc_lst->sflist = NULL;
+	}
+	write_unlock_bh(&mc_lst->sflock);
 	return err;
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d093ef3ef060..b6cb600fd02a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1242,7 +1242,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		newtp->af_specific = &tcp_sock_ipv6_mapped_specific;
 #endif
 
-		newnp->ipv6_mc_list = NULL;
+		INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 		newnp->ipv6_ac_list = NULL;
 		newnp->ipv6_fl_list = NULL;
 		newnp->pktoptions  = NULL;
@@ -1311,7 +1311,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	   First: no IPv4 options.
 	 */
 	newinet->inet_opt = NULL;
-	newnp->ipv6_mc_list = NULL;
+	INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 	newnp->ipv6_ac_list = NULL;
 	newnp->ipv6_fl_list = NULL;
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index c3e89c776e66..4842e538a988 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -754,7 +754,7 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 	newnp = inet6_sk(newsk);
 
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
-	newnp->ipv6_mc_list = NULL;
+	INIT_LIST_HEAD(&newnp->ipv6_mc_list);
 	newnp->ipv6_ac_list = NULL;
 	newnp->ipv6_fl_list = NULL;
 
-- 
2.17.1

