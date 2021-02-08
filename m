Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F7313C43
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhBHSEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhBHSAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:00:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC02C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:00:03 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u15so8255991plf.1
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7g0N8h/aQvIOfGXyYANd1dLUX1crVgLsMLSNLT5F9jo=;
        b=rkNLsNgusBcI460qKCNWD6FX1rjH7MD9VdaoQMkpRypHOGn2eLR9yemLp4Je2azDHS
         i3ip9dmb5o0bBhZ/b3l31APBRhhDATC+r5lbx32vdM8msmS9KMOETZR97XaZUHs+PdUV
         +pE+miMb7azwUnqXrNp0zE1jSEVNc1IXE6R42YAcjFzEV/cG9u02WLCsC235AVscuCpR
         EBLVFtFooducHuqsaxHPJK2rNLbiRYzKq5KSZmQ/OLJWANlf6chubp6P5Ms+a9MTY5PL
         76TkBlvKqHb5R8O+tw/GOH3OtMrwyvdSPqqZtY19lL5LcZ6eVLv8/RPUywrtF1CjmbeG
         31EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7g0N8h/aQvIOfGXyYANd1dLUX1crVgLsMLSNLT5F9jo=;
        b=MFR4DLWTGcCSkVx1n93f4k7SfQZmlQ0NFDtD0zK8F25sgB4j5eDyDqt/V3IkGkfgc3
         1AL8UT4rGWC/KgiwZ+GCoJ+jgQg08ulc1nB1Ob/J/DtLsIgYlviGqSTffsV/RU/KK0EM
         x8A4kfQ6pFdRLP4iG+kg0B28++wKhQuqI/HAPa6SNciA1Az/9fZST+bOpyG/coivDwEr
         2TLkdBkRNuIWuXoj8/f/1N0SlNd0agGs+FH/aC27s06Jd0eR9j1AsK8KIr1pIyXZ68pR
         LfvxzYTBUyyBGgznL10xfwnwcRrWFz5RQjuruAHWl1hjVzcoU/gwmCmlqlHFbZUJgmf8
         UiFg==
X-Gm-Message-State: AOAM531o1+Vn4+l9uB+4Tq9U3oiYMirhJCiJRSXL8a1RtE+p2fLhgp8K
        RcH+Ffxw7KamToR67FBSZzM=
X-Google-Smtp-Source: ABdhPJxEJbvz8ZUGxLKIvuvUdSgRHLW567Ys39JwJMEUGvW2DmGZhEXkXdo3qgUmBhFi3eVghCGvhQ==
X-Received: by 2002:a17:902:edcd:b029:df:d2b1:ecf0 with SMTP id q13-20020a170902edcdb02900dfd2b1ecf0mr17636359plk.15.1612807202644;
        Mon, 08 Feb 2021 10:00:02 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id e21sm18661279pgv.74.2021.02.08.09.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:00:01 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        yoshfuji@linux-ipv6.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 8/8] mld: change context of mld module
Date:   Mon,  8 Feb 2021 17:59:52 +0000
Message-Id: <20210208175952.5880-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MLD module's context is atomic although most logic is called from
control-path, not data path. Only a few functions are called from
datapath, most of the functions are called from the control-path.
Furthermore, MLD's response is not processed immediately because
MLD protocol is using delayed response.
It means that If a query is received, the node should have a delay
in response At this point, it could change the context.
It means most of the functions can be implemented as the sleepable
context so that mld functions can use sleepable functions.

Most resources are protected by spinlock and rwlock so the context
of mld functions is atomic. So, in order to change context, locking
scenario should be changed.
It switches from spinlock/rwlock to mutex and rcu.

Some locks are deleted and added.
1. ipv6->mc_socklist->sflock is deleted
This is rwlock and it is unnecessary.
Because it protects ipv6_mc_socklist-sflist but it is now protected
by rtnl_lock().

2. ifmcaddr6->mca_work_lock is added.
This lock protects ifmcaddr6->mca_work.
This workqueue can be used by both control-path and data-path.
It means mutex can't be used.
So mca_work_lock(spinlock) is added.

3. inet6_dev->mc_tomb_lock is deleted
This lock protects inet6_dev->mc_bom_list.
But it is protected by rtnl_lock().

4. inet6_dev->lock is used for protecting workqueues.
inet6_dev has its own workqueues(mc_gq_work, mc_ifc_work, mc_delrec_work)
and it can be started and stop by both control-path and data-path.
So, mutex can't be used.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/s390/net/qeth_l3_main.c |   6 +-
 include/net/if_inet6.h          |  29 +-
 net/batman-adv/multicast.c      |   4 +-
 net/ipv6/addrconf.c             |   4 +-
 net/ipv6/mcast.c                | 785 ++++++++++++++++----------------
 5 files changed, 411 insertions(+), 417 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index e49abdeff69c..085afb24482e 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1098,8 +1098,8 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	tmp.disp_flag = QETH_DISP_ADDR_ADD;
 	tmp.is_multicast = 1;
 
-	read_lock_bh(&in6_dev->lock);
-	list_for_each_entry(im6, in6_dev->mc_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(im6, in6_dev->mc_list, list) {
 		tmp.u.a6.addr = im6->mca_addr;
 
 		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
@@ -1117,7 +1117,7 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 			 qeth_l3_ipaddr_hash(ipm));
 
 	}
-	read_unlock_bh(&in6_dev->lock);
+	rcu_read_unlock();
 
 out:
 	return 0;
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 6885ab8ec2e9..0a8478b96ef1 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -88,7 +88,6 @@ struct ipv6_mc_socklist {
 	bool			sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct list_head	list;
 	struct list_head	sflist;
-	rwlock_t		sflock;
 	atomic_t		sl_count;
 	struct rcu_head		rcu;
 };
@@ -96,17 +95,19 @@ struct ipv6_mc_socklist {
 struct ip6_sf_list {
 	struct list_head	list;
 	struct in6_addr		sf_addr;
-	unsigned long		sf_count[2];	/* include/exclude counts */
+	atomic_t		incl_count;	/* include count */
+	atomic_t		excl_count;	/* exclude count */
 	unsigned char		sf_gsresp;	/* include in g & s response? */
 	bool			sf_oldin;	/* change state */
 	unsigned char		sf_crcount;	/* retrans. left to send */
+	struct rcu_head		rcu;
 };
 
-#define MAF_TIMER_RUNNING	0x01
-#define MAF_LAST_REPORTER	0x02
-#define MAF_LOADED		0x04
-#define MAF_NOREPORT		0x08
-#define MAF_GSQUERY		0x10
+enum mca_enum {
+	MCA_TIMER_RUNNING,
+	MCA_LAST_REPORTER,
+	MCA_GSQUERY,
+};
 
 struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
@@ -116,14 +117,18 @@ struct ifmcaddr6 {
 	struct list_head	mca_tomb_list;
 	unsigned int		mca_sfmode;
 	unsigned char		mca_crcount;
-	unsigned long		mca_sfcount[2];
-	struct delayed_work	mca_work;
-	unsigned int		mca_flags;
+	atomic_t		mca_incl_count;
+	atomic_t		mca_excl_count;
+	struct delayed_work	mca_work;		/* Protected by mca_work_lock */
+	spinlock_t		mca_work_lock;
+	unsigned long		mca_flags;
+	bool			mca_noreport;
+	bool			mca_loaded;
 	int			mca_users;
 	refcount_t		mca_refcnt;
-	spinlock_t		mca_lock;
 	unsigned long		mca_cstamp;
 	unsigned long		mca_tstamp;
+	struct rcu_head		rcu;
 };
 
 /* Anycast stuff */
@@ -163,7 +168,6 @@ struct inet6_dev {
 	struct list_head	addr_list;
 	struct list_head	mc_list;
 	struct list_head	mc_tomb_list;
-	spinlock_t		mc_tomb_lock;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
@@ -178,6 +182,7 @@ struct inet6_dev {
 	struct delayed_work	mc_gq_work;	/* general query work */
 	struct delayed_work	mc_ifc_work;	/* interface change work */
 	struct delayed_work	mc_dad_work;	/* dad complete mc work */
+	struct delayed_work	mc_delrec_work;
 
 	struct ifacaddr6	*ac_list;
 	rwlock_t		lock;
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 1a9ad5a9257b..3d36e6924000 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -454,8 +454,7 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		return 0;
 	}
 
-	read_lock_bh(&in6_dev->lock);
-	list_for_each_entry(pmc6, &in6_dev->mc_list, list) {
+	list_for_each_entry_rcu(pmc6, &in6_dev->mc_list, list) {
 		if (IPV6_ADDR_MC_SCOPE(&pmc6->mca_addr) <
 		    IPV6_ADDR_SCOPE_LINKLOCAL)
 			continue;
@@ -484,7 +483,6 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		hlist_add_head(&new->list, mcast_list);
 		ret++;
 	}
-	read_unlock_bh(&in6_dev->lock);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e9fe0eee5768..3138fe9c4829 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5110,7 +5110,7 @@ static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		list_for_each_entry(ifmca, &idev->mc_list, list) {
+		list_for_each_entry_rcu(ifmca, &idev->mc_list, list) {
 			if (ip_idx < s_ip_idx)
 				goto next2;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);
@@ -6094,10 +6094,8 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 
 static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 {
-	rcu_read_lock_bh();
 	if (likely(ifp->idev->dead == 0))
 		__ipv6_ifa_notify(event, ifp);
-	rcu_read_unlock_bh();
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 45b683b15835..5fd87659dcef 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -90,8 +90,6 @@ static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
 			       struct list_head *head,
 			       struct sockaddr_storage *list,
 			       struct sock *sk);
-static void ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
-			     struct inet6_dev *idev);
 static int __ipv6_dev_mc_inc(struct net_device *dev,
 			     const struct in6_addr *addr, unsigned int mode);
 
@@ -123,7 +121,7 @@ static void mca_put(struct ifmcaddr6 *mc)
 {
 	if (refcount_dec_and_test(&mc->mca_refcnt)) {
 		in6_dev_put(mc->idev);
-		kfree(mc);
+		kfree_rcu(mc, rcu);
 	}
 }
 
@@ -173,8 +171,9 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 			dev = rt->dst.dev;
 			ip6_rt_put(rt);
 		}
-	} else
+	} else {
 		dev = __dev_get_by_index(net, ifindex);
+	}
 
 	if (!dev) {
 		sock_kfree_s(sk, mc_lst, sizeof(*mc_lst));
@@ -184,7 +183,6 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	mc_lst->ifindex = dev->ifindex;
 	mc_lst->sfmode = mode;
 	atomic_set(&mc_lst->sl_count, 0);
-	rwlock_init(&mc_lst->sflock);
 	INIT_LIST_HEAD(&mc_lst->sflist);
 
 	/*
@@ -238,11 +236,11 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 			if (dev) {
 				struct inet6_dev *idev = __in6_dev_get(dev);
 
-				ip6_mc_leave_src(sk, mc_lst, idev);
+				ip6_mc_del_src_bulk(idev, mc_lst, sk);
 				if (idev)
 					__ipv6_dev_mc_dec(idev, &mc_lst->addr);
 			} else
-				ip6_mc_leave_src(sk, mc_lst, NULL);
+				ip6_mc_del_src_bulk(NULL, mc_lst, sk);
 
 			list_del_rcu(&mc_lst->list);
 			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
@@ -255,10 +253,9 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 }
 EXPORT_SYMBOL(ipv6_sock_mc_drop);
 
-/* called with rcu_read_lock() */
-static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
-					     const struct in6_addr *group,
-					     int ifindex)
+static struct inet6_dev *ip6_mc_find_dev(struct net *net,
+					 const struct in6_addr *group,
+					 int ifindex)
 {
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
@@ -270,19 +267,23 @@ static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
 			dev = rt->dst.dev;
 			ip6_rt_put(rt);
 		}
-	} else
-		dev = dev_get_by_index_rcu(net, ifindex);
+	} else {
+		dev = __dev_get_by_index(net, ifindex);
+	}
 
 	if (!dev)
-		return NULL;
+		goto out;
+
 	idev = __in6_dev_get(dev);
 	if (!idev)
-		return NULL;
-	read_lock_bh(&idev->lock);
-	if (idev->dead) {
-		read_unlock_bh(&idev->lock);
-		return NULL;
-	}
+		goto out;
+
+	if (idev->dead)
+		goto out;
+
+	in6_dev_hold(idev);
+	dev_hold(dev);
+out:
 	return idev;
 }
 
@@ -301,11 +302,11 @@ void __ipv6_sock_mc_close(struct sock *sk)
 		if (dev) {
 			struct inet6_dev *idev = __in6_dev_get(dev);
 
-			ip6_mc_leave_src(sk, mc_lst, idev);
+			ip6_mc_del_src_bulk(idev, mc_lst, sk);
 			if (idev)
 				__ipv6_dev_mc_dec(idev, &mc_lst->addr);
 		} else {
-			ip6_mc_leave_src(sk, mc_lst, NULL);
+			ip6_mc_del_src_bulk(NULL, mc_lst, sk);
 		}
 
 		list_del_rcu(&mc_lst->list);
@@ -328,6 +329,16 @@ void ipv6_sock_mc_close(struct sock *sk)
 	rtnl_unlock();
 }
 
+/* special case - (INCLUDE, empty) == LEAVE_GROUP */
+bool mld_check_leave_group(struct ipv6_mc_socklist *mc_lst, int omode)
+{
+	if (atomic_read(&mc_lst->sl_count) == 1 && omode == MCAST_INCLUDE)
+		return true;
+	else
+		return false;
+}
+
+/* called with rtnl_lock */
 int ip6_mc_source(int add, int omode, struct sock *sk,
 		  struct group_source_req *pgsr)
 {
@@ -339,25 +350,23 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	struct inet6_dev *idev;
 	int leavegroup = 0;
 	bool found = false;
-	int mclocked = 0;
 	int err;
 
+	ASSERT_RTNL();
+
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
 	group = &((struct sockaddr_in6 *)&pgsr->gsr_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, pgsr->gsr_interface);
-	if (!idev) {
-		rcu_read_unlock();
+	idev = ip6_mc_find_dev(net, group, pgsr->gsr_interface);
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = -EADDRNOTAVAIL;
 
-	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+	list_for_each_entry(mc_lst, &inet6->ipv6_mc_list, list) {
 		if (pgsr->gsr_interface && mc_lst->ifindex != pgsr->gsr_interface)
 			continue;
 		if (ipv6_addr_equal(&mc_lst->addr, group)) {
@@ -369,6 +378,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		err = -EINVAL;
 		goto done;
 	}
+
 	/* if a source filter was set, must be the same mode as before */
 	if (!list_empty(&mc_lst->sflist)) {
 		if (mc_lst->sfmode != omode) {
@@ -382,9 +392,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		mc_lst->sfmode = omode;
 	}
 
-	write_lock(&mc_lst->sflock);
-	mclocked = 1;
-
 	if (!add) {
 		found = false;
 		list_for_each_entry(psl, &mc_lst->sflist, list) {
@@ -396,9 +403,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		if (!found)
 			goto done;	/* err = -EADDRNOTAVAIL */
 
-		/* special case - (INCLUDE, empty) == LEAVE_GROUP */
-		if (atomic_read(&mc_lst->sl_count) == 1 &&
-		    omode == MCAST_INCLUDE) {
+		if (mld_check_leave_group(mc_lst, omode)) {
 			leavegroup = 1;
 			goto done;
 		}
@@ -422,7 +427,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		if (ipv6_addr_equal(&psl->sl_addr, source))
 			goto done;
 
-	psl = sock_kmalloc(sk, sizeof(struct ip6_sf_socklist), GFP_ATOMIC);
+	psl = sock_kmalloc(sk, sizeof(struct ip6_sf_socklist), GFP_KERNEL);
 	if (!psl) {
 		err = -ENOBUFS;
 		goto done;
@@ -435,10 +440,9 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, &psl->sl_addr, 1);
 done:
-	if (mclocked)
-		write_unlock(&mc_lst->sflock);
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
+
+	in6_dev_put(idev);
+	dev_put(idev->dev);
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, pgsr->gsr_interface, group);
 	return err;
@@ -457,6 +461,8 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	LIST_HEAD(head);
 	int err;
 
+	ASSERT_RTNL();
+
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
@@ -465,13 +471,10 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	    gsf->gf_fmode != MCAST_EXCLUDE)
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
+	idev = ip6_mc_find_dev(net, group, gsf->gf_interface);
 
-	if (!idev) {
-		rcu_read_unlock();
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = 0;
 
@@ -480,7 +483,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+	list_for_each_entry(mc_lst, &inet6->ipv6_mc_list, list) {
 		if (mc_lst->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(&mc_lst->addr, group)) {
@@ -501,16 +504,14 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	if (err)
 		goto done;
 
-	write_lock(&mc_lst->sflock);
 	ip6_mc_del_src_bulk(idev, mc_lst, sk);
 	atomic_set(&mc_lst->sl_count, gsf->gf_numsrc);
 	list_splice(&head, &mc_lst->sflist);
 	mc_lst->sfmode = gsf->gf_fmode;
-	write_unlock(&mc_lst->sflock);
 	err = 0;
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
+	in6_dev_put(idev);
+	dev_put(idev->dev);
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, gsf->gf_interface, group);
 
@@ -527,28 +528,20 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	struct ip6_sf_socklist *psl;
 	struct inet6_dev *idev;
 	bool found = false;
-	int err, i;
+	int err = 0, i;
+
+	ASSERT_RTNL();
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
-
-	if (!idev) {
-		rcu_read_unlock();
+	idev = ip6_mc_find_dev(net, group, gsf->gf_interface);
+	if (!idev)
 		return -ENODEV;
-	}
 
-	err = -EADDRNOTAVAIL;
-	/* changes to the ipv6_mc_list require the socket lock and
-	 * rtnl lock. We have the socket lock and rcu read lock,
-	 * so reading the list is safe.
-	 */
-
-	list_for_each_entry_rcu(mc_lst, &inet6->ipv6_mc_list, list) {
+	list_for_each_entry(mc_lst, &inet6->ipv6_mc_list, list) {
 		if (mc_lst->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(group, &mc_lst->addr)) {
@@ -556,14 +549,14 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 			break;
 		}
 	}
-	if (!found)		/* must have a prior join */
+	if (!found) {		/* must have a prior join */
+		err = -EADDRNOTAVAIL;
 		goto done;
+	}
+
 	gsf->gf_fmode = mc_lst->sfmode;
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 
 	i = 0;
-	read_lock(&mc_lst->sflock);
 	list_for_each_entry(psl, &mc_lst->sflist, list) {
 		struct sockaddr_in6 *psin6;
 		struct sockaddr_storage ss;
@@ -576,21 +569,20 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 		psin6->sin6_family = AF_INET6;
 		psin6->sin6_addr = psl->sl_addr;
 		if (copy_to_user(p, &ss, sizeof(ss))) {
-			read_unlock(&mc_lst->sflock);
-			return -EFAULT;
+			err = -EFAULT;
+			goto done;
 		}
 		p++;
 		i++;
 	}
 	gsf->gf_numsrc = i;
-	read_unlock(&mc_lst->sflock);
-	return 0;
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
+	in6_dev_put(idev);
+	dev_put(idev->dev);
 	return err;
 }
 
+/* atomic context */
 bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr)
 {
@@ -610,7 +602,6 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		rcu_read_unlock();
 		return np->mc_all;
 	}
-	read_lock(&mc_lst->sflock);
 
 	found = false;
 	if (list_empty(&mc_lst->sflist)) {
@@ -627,7 +618,6 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		if (mc_lst->sfmode == MCAST_EXCLUDE && found)
 			rv = false;
 	}
-	read_unlock(&mc_lst->sflock);
 	rcu_read_unlock();
 
 	return rv;
@@ -642,15 +632,13 @@ static void mld_group_added(struct ifmcaddr6 *mc)
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	spin_lock_bh(&mc->mca_lock);
-	if (!(mc->mca_flags&MAF_LOADED)) {
-		mc->mca_flags |= MAF_LOADED;
+	if (!mc->mca_loaded) {
+		mc->mca_loaded = true;
 		if (ndisc_mc_map(&mc->mca_addr, buf, dev, 0) == 0)
 			dev_mc_add(dev, buf);
 	}
-	spin_unlock_bh(&mc->mca_lock);
 
-	if (!(dev->flags & IFF_UP) || (mc->mca_flags & MAF_NOREPORT))
+	if (!(dev->flags & IFF_UP) || mc->mca_noreport)
 		return;
 
 	if (mld_in_v1_mode(mc->idev)) {
@@ -678,24 +666,22 @@ static void mld_group_dropped(struct ifmcaddr6 *mc)
 	    IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	spin_lock_bh(&mc->mca_lock);
-	if (mc->mca_flags&MAF_LOADED) {
-		mc->mca_flags &= ~MAF_LOADED;
+	if (mc->mca_loaded) {
+		mc->mca_loaded = false;
 		if (ndisc_mc_map(&mc->mca_addr, buf, dev, 0) == 0)
 			dev_mc_del(dev, buf);
 	}
 
-	spin_unlock_bh(&mc->mca_lock);
-	if (mc->mca_flags & MAF_NOREPORT)
+	if (mc->mca_noreport)
 		return;
 
 	if (!mc->idev->dead)
 		mld_leave_group(mc);
 
-	spin_lock_bh(&mc->mca_lock);
+	spin_lock_bh(&mc->mca_work_lock);
 	if (cancel_delayed_work(&mc->mca_work))
 		mca_put(mc);
-	spin_unlock_bh(&mc->mca_lock);
+	spin_unlock_bh(&mc->mca_work_lock);
 }
 
 /*
@@ -711,12 +697,11 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	 * for deleted items allows change reports to use common code with
 	 * non-deleted or query-response MCA's.
 	 */
-	mc = kzalloc(sizeof(*mc), GFP_ATOMIC);
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return;
 
-	spin_lock_bh(&im->mca_lock);
-	spin_lock_init(&mc->mca_lock);
+	spin_lock_init(&mc->mca_work_lock);
 	INIT_LIST_HEAD(&mc->list);
 	INIT_LIST_HEAD(&mc->mca_tomb_list);
 	INIT_LIST_HEAD(&mc->mca_source_list);
@@ -729,16 +714,13 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		struct ip6_sf_list *psf;
 
 		list_splice_init(&im->mca_tomb_list, &mc->mca_tomb_list);
-		list_splice_init(&im->mca_source_list, &mc->mca_source_list);
+		list_splice_init_rcu(&im->mca_source_list, &mc->mca_source_list,
+				     synchronize_rcu);
 
 		list_for_each_entry(psf, &mc->mca_source_list, list)
 			psf->sf_crcount = mc->mca_crcount;
 	}
-	spin_unlock_bh(&im->mca_lock);
-
-	spin_lock_bh(&idev->mc_tomb_lock);
 	list_add(&mc->list, &idev->mc_tomb_list);
-	spin_unlock_bh(&idev->mc_tomb_lock);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
@@ -750,7 +732,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	LIST_HEAD(tomb_list);
 	bool found = false;
 
-	spin_lock_bh(&idev->mc_tomb_lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, mca)) {
 			list_del(&mc->list);
@@ -758,16 +739,16 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 			break;
 		}
 	}
-	spin_unlock_bh(&idev->mc_tomb_lock);
 
-	spin_lock_bh(&im->mca_lock);
 	if (found) {
 		im->idev = mc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
 			list_splice_init(&im->mca_tomb_list, &tomb_list);
-			list_splice_init(&im->mca_source_list, &source_list);
+			list_splice_init_rcu(&im->mca_source_list, &source_list,
+					     synchronize_rcu);
 			list_splice_init(&mc->mca_tomb_list, &im->mca_tomb_list);
-			list_splice_init(&mc->mca_source_list, &im->mca_source_list);
+			list_splice_init_rcu(&mc->mca_source_list, &im->mca_source_list,
+					     synchronize_rcu);
 			list_splice_init(&tomb_list, &mc->mca_tomb_list);
 			list_splice_init(&source_list, &mc->mca_source_list);
 
@@ -778,37 +759,32 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		}
 		in6_dev_put(mc->idev);
 		ip6_mc_clear_src(mc);
+		/* tomb_list's mc doesn't need kfree_rcu() */
 		kfree(mc);
 	}
-	spin_unlock_bh(&im->mca_lock);
 }
 
 static void mld_clear_delrec(struct inet6_dev *idev)
 {
+	struct ip6_sf_list *psf, *psf_tmp;
 	struct ifmcaddr6 *mc, *tmp;
+	LIST_HEAD(mca_list);
+
+	ASSERT_RTNL();
 
-	spin_lock_bh(&idev->mc_tomb_lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
 		list_del(&mc->list);
 		ip6_mc_clear_src(mc);
 		in6_dev_put(mc->idev);
 		kfree(mc);
 	}
-	spin_unlock_bh(&idev->mc_tomb_lock);
 
 	/* clear dead sources, too */
-	read_lock_bh(&idev->lock);
-	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
-		struct ip6_sf_list *psf, *tmp;
-		LIST_HEAD(mca_list);
-
-		spin_lock_bh(&mc->mca_lock);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
 		list_splice_init(&mc->mca_tomb_list, &mca_list);
-		spin_unlock_bh(&mc->mca_lock);
-		list_for_each_entry_safe(psf, tmp, &mca_list, list)
-			kfree(psf);
-	}
-	read_unlock_bh(&idev->lock);
+
+	list_for_each_entry_safe(psf, psf_tmp, &mca_list, list)
+		kfree(psf);
 }
 
 static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
@@ -817,7 +793,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 {
 	struct ifmcaddr6 *mc;
 
-	mc = kzalloc(sizeof(*mc), GFP_ATOMIC);
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return NULL;
 
@@ -832,14 +808,20 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 	/* mca_stamp should be updated upon changes */
 	mc->mca_cstamp = mc->mca_tstamp = jiffies;
 	refcount_set(&mc->mca_refcnt, 1);
-	spin_lock_init(&mc->mca_lock);
+	spin_lock_init(&mc->mca_work_lock);
 
 	mc->mca_sfmode = mode;
-	mc->mca_sfcount[mode] = 1;
+	if (mode == MCAST_INCLUDE) {
+		atomic_set(&mc->mca_incl_count, 1);
+		atomic_set(&mc->mca_excl_count, 0);
+	} else {
+		atomic_set(&mc->mca_incl_count, 0);
+		atomic_set(&mc->mca_excl_count, 1);
+	}
 
 	if (ipv6_addr_is_ll_all_nodes(&mc->mca_addr) ||
 	    IPV6_ADDR_MC_SCOPE(&mc->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
-		mc->mca_flags |= MAF_NOREPORT;
+		mc->mca_noreport = true;
 
 	return mc;
 }
@@ -860,9 +842,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 	if (!idev)
 		return -EINVAL;
 
-	write_lock_bh(&idev->lock);
 	if (idev->dead) {
-		write_unlock_bh(&idev->lock);
 		in6_dev_put(idev);
 		return -ENODEV;
 	}
@@ -870,7 +850,6 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			mc->mca_users++;
-			write_unlock_bh(&idev->lock);
 			ip6_mc_add_src(idev, &mc->mca_addr, mode, NULL, 0);
 			in6_dev_put(idev);
 			return 0;
@@ -879,18 +858,16 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 
 	mc = mca_alloc(idev, addr, mode);
 	if (!mc) {
-		write_unlock_bh(&idev->lock);
 		in6_dev_put(idev);
 		return -ENOMEM;
 	}
 
-	list_add(&mc->list, &idev->mc_list);
+	list_add_rcu(&mc->list, &idev->mc_list);
 
 	/* Hold this for the code below before we unlock,
 	 * it is already exposed via idev->mc_list.
 	 */
 	mca_get(mc);
-	write_unlock_bh(&idev->lock);
 
 	mld_del_delrec(idev, mc);
 	mld_group_added(mc);
@@ -913,24 +890,20 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&idev->lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			if (--mc->mca_users == 0) {
-				list_del(&mc->list);
-				write_unlock_bh(&idev->lock);
+				list_del_rcu(&mc->list);
 				mld_group_dropped(mc);
 				ip6_mc_clear_src(mc);
 				mca_put(mc);
 				return 0;
 			}
 
-			write_unlock_bh(&idev->lock);
 			return 0;
 		}
 	}
 
-	write_unlock_bh(&idev->lock);
 	return -ENOENT;
 }
 
@@ -964,74 +937,82 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
-		read_lock_bh(&idev->lock);
-		list_for_each_entry(mc, &idev->mc_list, list) {
+		list_for_each_entry_rcu(mc, &idev->mc_list, list) {
 			if (ipv6_addr_equal(&mc->mca_addr, group)) {
 				found = true;
 				break;
 			}
 		}
 
-		if (found) {
-			if (src_addr && !ipv6_addr_any(src_addr)) {
-				struct ip6_sf_list *psf;
-				bool found_psf = false;
-
-				spin_lock_bh(&mc->mca_lock);
-				list_for_each_entry(psf, &mc->mca_source_list, list) {
-					if (ipv6_addr_equal(&psf->sf_addr, src_addr)) {
-						found_psf = true;
-						break;
-					}
-				}
-				if (found_psf) {
-					rv = psf->sf_count[MCAST_INCLUDE] ||
-					     psf->sf_count[MCAST_EXCLUDE] !=
-					     mc->mca_sfcount[MCAST_EXCLUDE];
-				} else {
-					rv = mc->mca_sfcount[MCAST_EXCLUDE] != 0;
+		if (!found)
+			goto out;
+
+		if (src_addr && !ipv6_addr_any(src_addr)) {
+			struct ip6_sf_list *psf;
+			bool found_psf = false;
+
+			list_for_each_entry_rcu(psf, &mc->mca_source_list, list) {
+				if (ipv6_addr_equal(&psf->sf_addr, src_addr)) {
+					found_psf = true;
+					break;
 				}
-				spin_unlock_bh(&mc->mca_lock);
-			} else
-				rv = true; /* don't filter unspecified source */
+			}
+			if (found_psf) {
+				rv = atomic_read(&psf->incl_count) ||
+				     atomic_read(&psf->excl_count) !=
+				     atomic_read(&mc->mca_excl_count);
+			} else {
+				rv = atomic_read(&mc->mca_excl_count) != 0;
+			}
+		} else {
+			rv = true; /* don't filter unspecified source */
 		}
-		read_unlock_bh(&idev->lock);
 	}
+out:
 	rcu_read_unlock();
 	return rv;
 }
 
+/* atomic context */
 static void mld_gq_start_work(struct inet6_dev *idev)
 {
 	unsigned long tv = prandom_u32() % idev->mc_maxdelay;
 
+	write_lock_bh(&idev->lock);
 	idev->mc_gq_running = 1;
 	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work,
 			      msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_gq_stop_work(struct inet6_dev *idev)
 {
+	write_lock_bh(&idev->lock);
 	idev->mc_gq_running = 0;
 	if (cancel_delayed_work(&idev->mc_gq_work))
 		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 {
 	unsigned long tv = prandom_u32() % delay;
 
+	write_lock_bh(&idev->lock);
 	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work,
 			      msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_ifc_stop_work(struct inet6_dev *idev)
 {
+	write_lock_bh(&idev->lock);
 	idev->mc_ifc_count = 0;
 	if (cancel_delayed_work(&idev->mc_ifc_work))
 		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
@@ -1049,10 +1030,25 @@ static void mld_dad_stop_work(struct inet6_dev *idev)
 		__in6_dev_put(idev);
 }
 
+static void mld_clear_delrec_start_work(struct inet6_dev *idev)
+{
+	write_lock_bh(&idev->lock);
+	if (!mod_delayed_work(mld_wq, &idev->mc_delrec_work, 0))
+		in6_dev_hold(idev);
+	write_unlock_bh(&idev->lock);
+}
+
+static void mld_clear_delrec_stop_work(struct inet6_dev *idev)
+{
+	write_lock_bh(&idev->lock);
+	if (cancel_delayed_work(&idev->mc_delrec_work))
+		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
+}
+
 /*
- *	MLD handling (alias multicast ICMPv6 messages)
+ * MLD handling (alias multicast ICMPv6 messages)
  */
-
 static void mld_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 {
 	unsigned long delay = resptime;
@@ -1073,7 +1069,7 @@ static void mld_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 	if (!mod_delayed_work(mld_wq, &mc->mca_work,
 			      msecs_to_jiffies(delay)))
 		mca_get(mc);
-	mc->mca_flags |= MAF_TIMER_RUNNING;
+	set_bit(MCA_TIMER_RUNNING, &mc->mca_flags);
 }
 
 /* mark EXCLUDE-mode sources */
@@ -1084,14 +1080,14 @@ static bool mld_xmarksources(struct ifmcaddr6 *mc, int nsrcs,
 	int i, scount;
 
 	scount = 0;
-	list_for_each_entry(psf, &mc->mca_source_list, list) {
+	list_for_each_entry_rcu(psf, &mc->mca_source_list, list) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
 			/* skip inactive filters */
-			if (psf->sf_count[MCAST_INCLUDE] ||
-			    mc->mca_sfcount[MCAST_EXCLUDE] !=
-			    psf->sf_count[MCAST_EXCLUDE])
+			if (atomic_read(&psf->incl_count) ||
+			    atomic_read(&mc->mca_excl_count) !=
+			    atomic_read(&psf->excl_count))
 				break;
 			if (ipv6_addr_equal(&srcs[i], &psf->sf_addr)) {
 				scount++;
@@ -1099,7 +1095,8 @@ static bool mld_xmarksources(struct ifmcaddr6 *mc, int nsrcs,
 			}
 		}
 	}
-	mc->mca_flags &= ~MAF_GSQUERY;
+
+	clear_bit(MCA_GSQUERY, &mc->mca_flags);
 	if (scount == nsrcs)	/* all sources excluded */
 		return false;
 	return true;
@@ -1117,7 +1114,7 @@ static bool mld_marksources(struct ifmcaddr6 *mc, int nsrcs,
 	/* mark INCLUDE-mode sources */
 
 	scount = 0;
-	list_for_each_entry(psf, &mc->mca_source_list, list) {
+	list_for_each_entry_rcu(psf, &mc->mca_source_list, list) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1129,10 +1126,10 @@ static bool mld_marksources(struct ifmcaddr6 *mc, int nsrcs,
 		}
 	}
 	if (!scount) {
-		mc->mca_flags &= ~MAF_GSQUERY;
+		clear_bit(MCA_GSQUERY, &mc->mca_flags);
 		return false;
 	}
-	mc->mca_flags |= MAF_GSQUERY;
+	set_bit(MCA_GSQUERY, &mc->mca_flags);
 	return true;
 }
 
@@ -1246,6 +1243,7 @@ static void mld_update_qri(struct inet6_dev *idev,
 	idev->mc_qri = msecs_to_jiffies(mldv2_mrc(mlh2));
 }
 
+/* atomic context */
 static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
 			  unsigned long *max_delay, bool v1_query)
 {
@@ -1287,7 +1285,7 @@ static int mld_process_v1(struct inet6_dev *idev, struct mld_msg *mld,
 	/* cancel the interface change work */
 	mld_ifc_stop_work(idev);
 	/* clear deleted report items */
-	mld_clear_delrec(idev);
+	mld_clear_delrec_start_work(idev);
 
 	return 0;
 }
@@ -1306,7 +1304,7 @@ static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 	return 0;
 }
 
-/* called with rcu_read_lock() */
+/* atomic context */
 int mld_event_query(struct sk_buff *skb)
 {
 	struct mld2_query *mlh2 = NULL;
@@ -1391,42 +1389,40 @@ int mld_event_query(struct sk_buff *skb)
 		return -EINVAL;
 	}
 
-	read_lock_bh(&idev->lock);
 	if (group_type == IPV6_ADDR_ANY) {
-		list_for_each_entry(mc, &idev->mc_list, list) {
-			spin_lock_bh(&mc->mca_lock);
+		list_for_each_entry_rcu(mc, &idev->mc_list, list) {
+			spin_lock_bh(&mc->mca_work_lock);
 			mld_group_queried(mc, max_delay);
-			spin_unlock_bh(&mc->mca_lock);
+			spin_unlock_bh(&mc->mca_work_lock);
 		}
 	} else {
-		list_for_each_entry(mc, &idev->mc_list, list) {
+		list_for_each_entry_rcu(mc, &idev->mc_list, list) {
 			if (!ipv6_addr_equal(group, &mc->mca_addr))
 				continue;
-			spin_lock_bh(&mc->mca_lock);
-			if (mc->mca_flags & MAF_TIMER_RUNNING) {
+			spin_lock_bh(&mc->mca_work_lock);
+			if (test_bit(MCA_TIMER_RUNNING, &mc->mca_flags)) {
 				/* gsquery <- gsquery && mark */
 				if (!mark)
-					mc->mca_flags &= ~MAF_GSQUERY;
+					clear_bit(MCA_GSQUERY, &mc->mca_flags);
 			} else {
 				/* gsquery <- mark */
 				if (mark)
-					mc->mca_flags |= MAF_GSQUERY;
+					set_bit(MCA_GSQUERY, &mc->mca_flags);
 				else
-					mc->mca_flags &= ~MAF_GSQUERY;
+					clear_bit(MCA_GSQUERY, &mc->mca_flags);
 			}
-			if (!(mc->mca_flags & MAF_GSQUERY) ||
+			if (!(test_bit(MCA_GSQUERY, &mc->mca_flags)) ||
 			    mld_marksources(mc, ntohs(mlh2->mld2q_nsrcs), mlh2->mld2q_srcs))
 				mld_group_queried(mc, max_delay);
-			spin_unlock_bh(&mc->mca_lock);
+			spin_unlock_bh(&mc->mca_work_lock);
 			break;
 		}
 	}
-	read_unlock_bh(&idev->lock);
 
 	return 0;
 }
 
-/* called with rcu_read_lock() */
+/* atomic context */
 int mld_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev;
@@ -1462,18 +1458,17 @@ int mld_event_report(struct sk_buff *skb)
 	 *	Cancel the work for this group
 	 */
 
-	read_lock_bh(&idev->lock);
-	list_for_each_entry(mc, &idev->mc_list, list) {
+	list_for_each_entry_rcu(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, &mld->mld_mca)) {
-			spin_lock(&mc->mca_lock);
+			spin_lock_bh(&mc->mca_work_lock);
 			if (cancel_delayed_work(&mc->mca_work))
 				mca_put(mc);
-			mc->mca_flags &= ~(MAF_LAST_REPORTER | MAF_TIMER_RUNNING);
-			spin_unlock(&mc->mca_lock);
+			clear_bit(MCA_LAST_REPORTER, &mc->mca_flags);
+			clear_bit(MCA_TIMER_RUNNING, &mc->mca_flags);
+			spin_unlock_bh(&mc->mca_work_lock);
 			break;
 		}
 	}
-	read_unlock_bh(&idev->lock);
 	return 0;
 }
 
@@ -1485,30 +1480,30 @@ static bool is_in(struct ifmcaddr6 *mc, struct ip6_sf_list *psf, int type,
 	case MLD2_MODE_IS_EXCLUDE:
 		if (gdeleted || sdeleted)
 			return false;
-		if (!((mc->mca_flags & MAF_GSQUERY) && !psf->sf_gsresp)) {
+		if (!(test_bit(MCA_GSQUERY, &mc->mca_flags) && !psf->sf_gsresp)) {
 			if (mc->mca_sfmode == MCAST_INCLUDE)
 				return true;
 			/* don't include if this source is excluded
 			 * in all filters
 			 */
-			if (psf->sf_count[MCAST_INCLUDE])
+			if (atomic_read(&psf->incl_count))
 				return type == MLD2_MODE_IS_INCLUDE;
-			return mc->mca_sfcount[MCAST_EXCLUDE] ==
-				psf->sf_count[MCAST_EXCLUDE];
+			return atomic_read(&mc->mca_excl_count) ==
+				atomic_read(&psf->excl_count);
 		}
 		return false;
 	case MLD2_CHANGE_TO_INCLUDE:
 		if (gdeleted || sdeleted)
 			return false;
-		return psf->sf_count[MCAST_INCLUDE] != 0;
+		return atomic_read(&psf->incl_count) != 0;
 	case MLD2_CHANGE_TO_EXCLUDE:
 		if (gdeleted || sdeleted)
 			return false;
-		if (mc->mca_sfcount[MCAST_EXCLUDE] == 0 ||
-		    psf->sf_count[MCAST_INCLUDE])
+		if (!atomic_read(&mc->mca_excl_count) ||
+		    atomic_read(&psf->incl_count))
 			return false;
-		return mc->mca_sfcount[MCAST_EXCLUDE] ==
-			psf->sf_count[MCAST_EXCLUDE];
+		return atomic_read(&mc->mca_excl_count) ==
+			atomic_read(&psf->excl_count);
 	case MLD2_ALLOW_NEW_SOURCES:
 		if (gdeleted || !psf->sf_crcount)
 			return false;
@@ -1719,7 +1714,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 	unsigned int mtu;
 
 	dev = idev->dev;
-	if (mc->mca_flags & MAF_NOREPORT)
+	if (mc->mca_noreport)
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -1801,8 +1796,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 decrease_sf_crcount:
 			psf->sf_crcount--;
 			if ((sdeleted || gdeleted) && psf->sf_crcount == 0) {
-				list_del(&psf->list);
-				kfree(psf);
+				list_del_rcu(&psf->list);
+				kfree_rcu(psf, rcu);
 				continue;
 			}
 		}
@@ -1825,8 +1820,11 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 	if (pgr)
 		pgr->grec_nsrcs = htons(scount);
 
-	if (isquery)
-		mc->mca_flags &= ~MAF_GSQUERY;	/* clear query state */
+	if (isquery) {
+		spin_lock_bh(&mc->mca_work_lock);
+		clear_bit(MCA_GSQUERY, &mc->mca_flags);	/* clear query state */
+		spin_unlock_bh(&mc->mca_work_lock);
+	}
 	return skb;
 }
 
@@ -1835,29 +1833,23 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *mc)
 	struct sk_buff *skb = NULL;
 	int type;
 
-	read_lock_bh(&idev->lock);
 	if (!mc) {
 		list_for_each_entry(mc, &idev->mc_list, list) {
-			if (mc->mca_flags & MAF_NOREPORT)
+			if (mc->mca_noreport)
 				continue;
-			spin_lock_bh(&mc->mca_lock);
-			if (mc->mca_sfcount[MCAST_EXCLUDE])
+			if (atomic_read(&mc->mca_excl_count))
 				type = MLD2_MODE_IS_EXCLUDE;
 			else
 				type = MLD2_MODE_IS_INCLUDE;
 			skb = add_grec(skb, mc, type, 0, 0, 0);
-			spin_unlock_bh(&mc->mca_lock);
 		}
 	} else {
-		spin_lock_bh(&mc->mca_lock);
-		if (mc->mca_sfcount[MCAST_EXCLUDE])
+		if (atomic_read(&mc->mca_excl_count))
 			type = MLD2_MODE_IS_EXCLUDE;
 		else
 			type = MLD2_MODE_IS_INCLUDE;
 		skb = add_grec(skb, mc, type, 0, 0, 0);
-		spin_unlock_bh(&mc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -1871,15 +1863,15 @@ static void mld_clear_zeros(struct ifmcaddr6 *mc)
 
 	list_for_each_entry_safe(psf, tmp, &mc->mca_tomb_list, list) {
 		if (psf->sf_crcount == 0) {
-			list_del(&psf->list);
-			kfree(psf);
+			list_del_rcu(&psf->list);
+			kfree_rcu(psf, rcu);
 		}
 	}
 
 	list_for_each_entry_safe(psf, tmp, &mc->mca_source_list, list) {
 		if (psf->sf_crcount == 0) {
-			list_del(&psf->list);
-			kfree(psf);
+			list_del_rcu(&psf->list);
+			kfree_rcu(psf, rcu);
 		}
 	}
 }
@@ -1890,9 +1882,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 	struct ifmcaddr6 *mc, *tmp;
 	int type, dtype;
 
-	read_lock_bh(&idev->lock);
-	spin_lock(&idev->mc_tomb_lock);
-
 	/* deleted MCA's */
 	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
 		if (mc->mca_sfmode == MCAST_INCLUDE) {
@@ -1921,12 +1910,10 @@ static void mld_send_cr(struct inet6_dev *idev)
 			kfree(mc);
 		}
 	}
-	spin_unlock(&idev->mc_tomb_lock);
 
 	/* change recs */
 	list_for_each_entry(mc, &idev->mc_list, list) {
-		spin_lock_bh(&mc->mca_lock);
-		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
+		if (atomic_read(&mc->mca_excl_count)) {
 			type = MLD2_BLOCK_OLD_SOURCES;
 			dtype = MLD2_ALLOW_NEW_SOURCES;
 		} else {
@@ -1945,9 +1932,7 @@ static void mld_send_cr(struct inet6_dev *idev)
 			skb = add_grec(skb, mc, type, 0, 0, 0);
 			mc->mca_crcount--;
 		}
-		spin_unlock_bh(&mc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
 	if (!skb)
 		return;
 	mld_sendpack(skb);
@@ -2061,17 +2046,14 @@ static void mld_send_initial_cr(struct inet6_dev *idev)
 		return;
 
 	skb = NULL;
-	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
-		spin_lock_bh(&mc->mca_lock);
-		if (mc->mca_sfcount[MCAST_EXCLUDE])
+		if (atomic_read(&mc->mca_excl_count))
 			type = MLD2_CHANGE_TO_EXCLUDE;
 		else
 			type = MLD2_ALLOW_NEW_SOURCES;
 		skb = add_grec(skb, mc, type, 0, 0, 1);
-		spin_unlock_bh(&mc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
+
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -2094,6 +2076,7 @@ static void mld_dad_work(struct work_struct *work)
 					      struct inet6_dev,
 					      mc_dad_work);
 
+	rtnl_lock();
 	mld_send_initial_cr(idev);
 	if (idev->mc_dad_count) {
 		idev->mc_dad_count--;
@@ -2101,6 +2084,18 @@ static void mld_dad_work(struct work_struct *work)
 			mld_dad_start_work(idev,
 					   unsolicited_report_interval(idev));
 	}
+	rtnl_unlock();
+	in6_dev_put(idev);
+}
+
+static void mld_clear_delrec_work(struct work_struct *work)
+{
+	struct inet6_dev *idev = container_of(to_delayed_work(work),
+					      struct inet6_dev,
+					      mc_delrec_work);
+	rtnl_lock();
+	mld_clear_delrec(idev);
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
@@ -2118,24 +2113,32 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *mc, int sfmode,
 		}
 	}
 
-	if (!found || psf->sf_count[sfmode] == 0) {
+	if (!found)
 		/* source filter not found, or count wrong =>  bug */
 		return -ESRCH;
+
+	if (sfmode == MCAST_INCLUDE) {
+		if (!atomic_read(&psf->incl_count))
+			return -ESRCH;
+		atomic_dec(&psf->incl_count);
+	} else {
+		if (!atomic_read(&psf->excl_count))
+			return -ESRCH;
+		atomic_dec(&psf->excl_count);
 	}
 
-	psf->sf_count[sfmode]--;
-	if (!psf->sf_count[MCAST_INCLUDE] && !psf->sf_count[MCAST_EXCLUDE]) {
+	if (!atomic_read(&psf->incl_count) && !atomic_read(&psf->excl_count)) {
 		struct inet6_dev *idev = mc->idev;
 
 		/* no more filters for this source */
 		list_del_init(&psf->list);
-		if (psf->sf_oldin && !(mc->mca_flags & MAF_NOREPORT) &&
-		    !mld_in_v1_mode(idev)) {
+		if (psf->sf_oldin && !mld_in_v1_mode(idev) &&
+		    !mc->mca_noreport) {
 			psf->sf_crcount = idev->mc_qrv;
 			list_add(&psf->list, &mc->mca_tomb_list);
 			rv = 1;
 		} else {
-			kfree(psf);
+			kfree_rcu(psf, rcu);
 		}
 	}
 	return rv;
@@ -2152,27 +2155,27 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	if (!idev)
 		return -ENODEV;
 
-	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
 			found = true;
 			break;
 		}
 	}
-	if (!found) {
-		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
+
+	if (!found)
 		return -ESRCH;
-	}
-	spin_lock_bh(&mc->mca_lock);
+
 	sf_markstate(mc);
 	if (!delta) {
-		if (!mc->mca_sfcount[sfmode]) {
-			spin_unlock_bh(&mc->mca_lock);
-			read_unlock_bh(&idev->lock);
-			return -EINVAL;
+		if (sfmode == MCAST_INCLUDE) {
+			if (!atomic_read(&mc->mca_incl_count))
+				return -EINVAL;
+			atomic_dec(&mc->mca_incl_count);
+		} else {
+			if (!atomic_read(&mc->mca_excl_count))
+				return -EINVAL;
+			atomic_dec(&mc->mca_excl_count);
 		}
-		mc->mca_sfcount[sfmode]--;
 	}
 	err = 0;
 	i = 0;
@@ -2186,8 +2189,8 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	}
 
 	if (mc->mca_sfmode == MCAST_EXCLUDE &&
-	    mc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
-	    mc->mca_sfcount[MCAST_INCLUDE]) {
+	    !atomic_read(&mc->mca_excl_count) &&
+	    atomic_read(&mc->mca_incl_count)) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
@@ -2200,8 +2203,7 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	} else if (sf_setstate(mc) || changerec) {
 		mld_ifc_event(mc->idev);
 	}
-	spin_unlock_bh(&mc->mca_lock);
-	read_unlock_bh(&idev->lock);
+
 	return err;
 }
 
@@ -2215,32 +2217,32 @@ static void ip6_mc_del_src_bulk(struct inet6_dev *idev,
 	struct ifmcaddr6 *mc;
 	bool found = false;
 	int changerec = 0;
-	int i, rv;
+	int rv;
 
 	if (!idev)
 		return;
 
-	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
 			found = true;
 			break;
 		}
 	}
-	if (!found) {
-		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
+	if (!found)
 		return;
-	}
-	spin_lock_bh(&mc->mca_lock);
+
 	sf_markstate(mc);
-	if (!mc->mca_sfcount[sfmode]) {
-		spin_unlock_bh(&mc->mca_lock);
-		read_unlock_bh(&idev->lock);
-		return;
+	if (sfmode == MCAST_INCLUDE) {
+		if (!atomic_read(&mc->mca_incl_count))
+			return;
+
+		atomic_dec(&mc->mca_incl_count);
+	} else {
+		if (!atomic_read(&mc->mca_excl_count))
+			return;
+
+		atomic_dec(&mc->mca_excl_count);
 	}
-	mc->mca_sfcount[sfmode]--;
-	i = 0;
 
 	list_for_each_entry_safe(psl, tmp, &mc_lst->sflist, list) {
 		rv = ip6_mc_del1_src(mc, sfmode, &psl->sl_addr);
@@ -2249,11 +2251,12 @@ static void ip6_mc_del_src_bulk(struct inet6_dev *idev,
 		kfree_rcu(psl, rcu);
 
 		changerec |= rv > 0;
+		cond_resched();
 	}
 
 	if (mc->mca_sfmode == MCAST_EXCLUDE &&
-	    mc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
-	    mc->mca_sfcount[MCAST_INCLUDE]) {
+	    !atomic_read(&mc->mca_excl_count) &&
+	    atomic_read(&mc->mca_incl_count)) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
@@ -2266,8 +2269,6 @@ static void ip6_mc_del_src_bulk(struct inet6_dev *idev,
 	} else if (sf_setstate(mc) || changerec) {
 		mld_ifc_event(mc->idev);
 	}
-	spin_unlock_bh(&mc->mca_lock);
-	read_unlock_bh(&idev->lock);
 }
 
 /*
@@ -2287,36 +2288,42 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *mc, int sfmode,
 	}
 
 	if (!found) {
-		psf = kzalloc(sizeof(*psf), GFP_ATOMIC);
+		psf = kzalloc(sizeof(*psf), GFP_KERNEL);
 		if (!psf)
 			return -ENOBUFS;
 
+		atomic_set(&psf->incl_count, 0);
+		atomic_set(&psf->excl_count, 0);
 		psf->sf_addr = *psfsrc;
 		INIT_LIST_HEAD(&psf->list);
-		list_add_tail(&psf->list, &mc->mca_source_list);
+		list_add_tail_rcu(&psf->list, &mc->mca_source_list);
 	}
-	psf->sf_count[sfmode]++;
+
+	if (sfmode == MCAST_INCLUDE)
+		atomic_inc(&psf->incl_count);
+	else
+		atomic_inc(&psf->excl_count);
 	return 0;
 }
 
 static void sf_markstate(struct ifmcaddr6 *mc)
 {
-	int mca_xcount = mc->mca_sfcount[MCAST_EXCLUDE];
+	int mca_xcount = atomic_read(&mc->mca_excl_count);
 	struct ip6_sf_list *psf;
 
 	list_for_each_entry(psf, &mc->mca_source_list, list) {
-		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
+		if (atomic_read(&mc->mca_excl_count)) {
 			psf->sf_oldin = mca_xcount ==
-				psf->sf_count[MCAST_EXCLUDE] &&
-				!psf->sf_count[MCAST_INCLUDE];
+				atomic_read(&psf->excl_count) &&
+				!atomic_read(&psf->incl_count);
 		} else
-			psf->sf_oldin = psf->sf_count[MCAST_INCLUDE] != 0;
+			psf->sf_oldin = atomic_read(&psf->incl_count) != 0;
 	}
 }
 
 static int sf_setstate(struct ifmcaddr6 *mc)
 {
-	int mca_xcount = mc->mca_sfcount[MCAST_EXCLUDE];
+	int mca_xcount = atomic_read(&mc->mca_excl_count);
 	struct ip6_sf_list *psf, *dpsf;
 	int qrv = mc->idev->mc_qrv;
 	int new_in, rv;
@@ -2326,11 +2333,11 @@ static int sf_setstate(struct ifmcaddr6 *mc)
 	list_for_each_entry(psf, &mc->mca_source_list, list) {
 		found = false;
 
-		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
-			new_in = mca_xcount == psf->sf_count[MCAST_EXCLUDE] &&
-				!psf->sf_count[MCAST_INCLUDE];
+		if (atomic_read(&mc->mca_excl_count)) {
+			new_in = mca_xcount == atomic_read(&psf->excl_count) &&
+				!atomic_read(&psf->incl_count);
 		} else {
-			new_in = psf->sf_count[MCAST_INCLUDE] != 0;
+			new_in = atomic_read(&psf->incl_count) != 0;
 		}
 
 		if (new_in) {
@@ -2366,20 +2373,19 @@ static int sf_setstate(struct ifmcaddr6 *mc)
 			}
 
 			if (!found) {
-				dpsf = kmalloc(sizeof(*dpsf), GFP_ATOMIC);
+				dpsf = kmalloc(sizeof(*dpsf), GFP_KERNEL);
 				if (!dpsf)
 					continue;
 
 				INIT_LIST_HEAD(&dpsf->list);
 				dpsf->sf_addr = psf->sf_addr;
-				dpsf->sf_count[MCAST_INCLUDE] =
-					psf->sf_count[MCAST_INCLUDE];
-				dpsf->sf_count[MCAST_EXCLUDE] =
-					psf->sf_count[MCAST_EXCLUDE];
+				atomic_set(&dpsf->incl_count,
+					   atomic_read(&psf->incl_count));
+				atomic_set(&dpsf->excl_count,
+					   atomic_read(&psf->excl_count));
 				dpsf->sf_gsresp = psf->sf_gsresp;
 				dpsf->sf_oldin = psf->sf_oldin;
 				dpsf->sf_crcount = psf->sf_crcount;
-				/* mc->mca_lock held by callers */
 				list_add(&dpsf->list, &mc->mca_tomb_list);
 			}
 			dpsf->sf_crcount = qrv;
@@ -2404,38 +2410,41 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	if (!idev)
 		return -ENODEV;
 
-	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
 			found = true;
 			break;
 		}
 	}
-	if (!found) {
-		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
+	if (!found)
 		return -ESRCH;
-	}
-	spin_lock_bh(&mc->mca_lock);
 
 	sf_markstate(mc);
 	isexclude = mc->mca_sfmode == MCAST_EXCLUDE;
-	if (!delta)
-		mc->mca_sfcount[sfmode]++;
+	if (!delta) {
+		if (sfmode == MCAST_INCLUDE)
+			atomic_inc(&mc->mca_incl_count);
+		else
+			atomic_inc(&mc->mca_excl_count);
+	}
 
 	if (psfsrc)
 		err = ip6_mc_add1_src(mc, sfmode, psfsrc);
 
 	if (err) {
-		if (!delta)
-			mc->mca_sfcount[sfmode]--;
-	} else if (isexclude != (mc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
+		if (!delta) {
+			if (sfmode == MCAST_INCLUDE)
+				atomic_dec(&mc->mca_incl_count);
+			else
+				atomic_dec(&mc->mca_excl_count);
+		}
+	} else if (isexclude != (atomic_read(&mc->mca_excl_count) != 0)) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
-		if (mc->mca_sfcount[MCAST_EXCLUDE])
+		if (atomic_read(&mc->mca_excl_count))
 			mc->mca_sfmode = MCAST_EXCLUDE;
-		else if (mc->mca_sfcount[MCAST_INCLUDE])
+		else if (atomic_read(&mc->mca_incl_count))
 			mc->mca_sfmode = MCAST_INCLUDE;
 		/* else no filters; keep old mode for reports */
 
@@ -2448,8 +2457,6 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 		mld_ifc_event(idev);
 	}
 
-	spin_unlock_bh(&mc->mca_lock);
-	read_unlock_bh(&idev->lock);
 	return err;
 }
 
@@ -2481,17 +2488,19 @@ static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
 		/* MCA not found?? bug */
 		return -ESRCH;
 	}
-	spin_lock_bh(&mc->mca_lock);
 
 	sf_markstate(mc);
 	isexclude = mc->mca_sfmode == MCAST_EXCLUDE;
-	mc->mca_sfcount[sfmode]++;
+	if (sfmode == MCAST_INCLUDE)
+		atomic_inc(&mc->mca_incl_count);
+	else
+		atomic_inc(&mc->mca_excl_count);
 
 	for (i = 0; i < gsf->gf_numsrc; i++, ++list) {
 		struct sockaddr_in6 *psin6;
 
 		psl = sock_kmalloc(sk, sizeof(struct ip6_sf_socklist),
-				   GFP_ATOMIC);
+				   GFP_KERNEL);
 		if (!psl) {
 			err = -ENOBUFS;
 			break;
@@ -2508,20 +2517,24 @@ static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
 	}
 
 	if (err) {
-		mc->mca_sfcount[sfmode]--;
+		if (sfmode == MCAST_INCLUDE)
+			atomic_dec(&mc->mca_incl_count);
+		else
+			atomic_dec(&mc->mca_excl_count);
 
 		list_for_each_entry_safe(psl, tmp, head, list) {
 			list_del(&psl->list);
 			atomic_sub(sizeof(*psl), &sk->sk_omem_alloc);
 			kfree(psl);
+			cond_resched();
 		}
-	} else if (isexclude != (mc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
+	} else if (isexclude != (atomic_read(&mc->mca_excl_count) != 0)) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
-		if (mc->mca_sfcount[MCAST_EXCLUDE])
+		if (atomic_read(&mc->mca_excl_count))
 			mc->mca_sfmode = MCAST_EXCLUDE;
-		else if (mc->mca_sfcount[MCAST_INCLUDE])
+		else if (atomic_read(&mc->mca_incl_count))
 			mc->mca_sfmode = MCAST_INCLUDE;
 		/* else no filters; keep old mode for reports */
 
@@ -2532,7 +2545,6 @@ static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
 		mld_ifc_event(idev);
 	} else if (sf_setstate(mc))
 		mld_ifc_event(idev);
-	spin_unlock_bh(&mc->mca_lock);
 
 	return err;
 }
@@ -2544,16 +2556,18 @@ static void ip6_mc_clear_src(struct ifmcaddr6 *mc)
 	list_for_each_entry_safe(psf, tmp, &mc->mca_tomb_list, list) {
 		list_del(&psf->list);
 		kfree(psf);
+		cond_resched();
 	}
 
 	list_for_each_entry_safe(psf, tmp, &mc->mca_source_list, list) {
-		list_del(&psf->list);
-		kfree(psf);
+		list_del_rcu(&psf->list);
+		kfree_rcu(psf, rcu);
+		cond_resched();
 	}
 
 	mc->mca_sfmode = MCAST_EXCLUDE;
-	mc->mca_sfcount[MCAST_INCLUDE] = 0;
-	mc->mca_sfcount[MCAST_EXCLUDE] = 1;
+	atomic_set(&mc->mca_incl_count, 0);
+	atomic_set(&mc->mca_excl_count, 1);
 }
 
 
@@ -2561,14 +2575,14 @@ static void mld_join_group(struct ifmcaddr6 *mc)
 {
 	unsigned long delay;
 
-	if (mc->mca_flags & MAF_NOREPORT)
+	if (mc->mca_noreport)
 		return;
 
 	mld_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 
 	delay = prandom_u32() % unsolicited_report_interval(mc->idev);
 
-	spin_lock_bh(&mc->mca_lock);
+	spin_lock_bh(&mc->mca_work_lock);
 	if (cancel_delayed_work(&mc->mca_work)) {
 		mca_put(mc);
 		delay = mc->mca_work.timer.expires - jiffies;
@@ -2577,22 +2591,16 @@ static void mld_join_group(struct ifmcaddr6 *mc)
 	if (!mod_delayed_work(mld_wq, &mc->mca_work,
 			      msecs_to_jiffies(delay)))
 		mca_get(mc);
-	mc->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
-	spin_unlock_bh(&mc->mca_lock);
-}
 
-static void ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
-			     struct inet6_dev *idev)
-{
-	write_lock_bh(&mc_lst->sflock);
-	ip6_mc_del_src_bulk(idev, mc_lst, sk);
-	write_unlock_bh(&mc_lst->sflock);
+	set_bit(MCA_TIMER_RUNNING, &mc->mca_flags);
+	set_bit(MCA_LAST_REPORTER, &mc->mca_flags);
+	spin_unlock_bh(&mc->mca_work_lock);
 }
 
 static void mld_leave_group(struct ifmcaddr6 *mc)
 {
 	if (mld_in_v1_mode(mc->idev)) {
-		if (mc->mca_flags & MAF_LAST_REPORTER)
+		if (test_bit(MCA_LAST_REPORTER, &mc->mca_flags))
 			mld_send(&mc->mca_addr, mc->idev->dev,
 				 ICMPV6_MGM_REDUCTION);
 	} else {
@@ -2607,7 +2615,9 @@ static void mld_gq_work(struct work_struct *work)
 					      struct inet6_dev, mc_gq_work);
 
 	idev->mc_gq_running = 0;
+	rtnl_lock();
 	mld_send_report(idev, NULL);
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
@@ -2616,20 +2626,26 @@ static void mld_ifc_work(struct work_struct *work)
 	struct inet6_dev *idev = container_of(to_delayed_work(work),
 					      struct inet6_dev, mc_ifc_work);
 
+	rtnl_lock();
 	mld_send_cr(idev);
+
 	if (idev->mc_ifc_count) {
 		idev->mc_ifc_count--;
 		if (idev->mc_ifc_count)
 			mld_ifc_start_work(idev,
 					   unsolicited_report_interval(idev));
 	}
+	rtnl_unlock();
 	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)
 {
+	ASSERT_RTNL();
+
 	if (mld_in_v1_mode(idev))
 		return;
+
 	idev->mc_ifc_count = idev->mc_qrv;
 	mld_ifc_start_work(idev, 1);
 }
@@ -2639,15 +2655,17 @@ static void mld_mca_work(struct work_struct *work)
 	struct ifmcaddr6 *mc = container_of(to_delayed_work(work),
 					    struct ifmcaddr6, mca_work);
 
+	rtnl_lock();
 	if (mld_in_v1_mode(mc->idev))
 		mld_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 	else
 		mld_send_report(mc->idev, mc);
+	rtnl_unlock();
 
-	spin_lock_bh(&mc->mca_lock);
-	mc->mca_flags |=  MAF_LAST_REPORTER;
-	mc->mca_flags &= ~MAF_TIMER_RUNNING;
-	spin_unlock_bh(&mc->mca_lock);
+	spin_lock_bh(&mc->mca_work_lock);
+	set_bit(MCA_LAST_REPORTER, &mc->mca_flags);
+	clear_bit(MCA_TIMER_RUNNING, &mc->mca_flags);
+	spin_unlock_bh(&mc->mca_work_lock);
 	mca_put(mc);
 }
 
@@ -2659,14 +2677,16 @@ void ipv6_mc_unmap(struct inet6_dev *idev)
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
-	read_lock_bh(&idev->lock);
+	ASSERT_RTNL();
+
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
 		mld_group_dropped(mc);
-	read_unlock_bh(&idev->lock);
 }
 
 void ipv6_mc_remap(struct inet6_dev *idev)
 {
+	ASSERT_RTNL();
+
 	ipv6_mc_up(idev);
 }
 
@@ -2676,10 +2696,9 @@ void ipv6_mc_down(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *mc, *tmp;
 
-	/* Withdraw multicast list */
-
-	read_lock_bh(&idev->lock);
+	ASSERT_RTNL();
 
+	/* Withdraw multicast list */
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
 		mld_group_dropped(mc);
 
@@ -2689,7 +2708,7 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	mld_ifc_stop_work(idev);
 	mld_gq_stop_work(idev);
 	mld_dad_stop_work(idev);
-	read_unlock_bh(&idev->lock);
+	mld_clear_delrec_stop_work(idev);
 }
 
 static void ipv6_mc_reset(struct inet6_dev *idev)
@@ -2709,21 +2728,21 @@ void ipv6_mc_up(struct inet6_dev *idev)
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
-	read_lock_bh(&idev->lock);
+	ASSERT_RTNL();
+
 	ipv6_mc_reset(idev);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
 		mld_del_delrec(idev, mc);
 		mld_group_added(mc);
 	}
-	read_unlock_bh(&idev->lock);
 }
 
 /* IPv6 device initialization. */
 
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
-	write_lock_bh(&idev->lock);
-	spin_lock_init(&idev->mc_tomb_lock);
+	ASSERT_RTNL();
+
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	INIT_LIST_HEAD(&idev->mc_tomb_list);
@@ -2731,8 +2750,8 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 	idev->mc_ifc_count = 0;
 	INIT_DELAYED_WORK(&idev->mc_ifc_work, mld_ifc_work);
 	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
+	INIT_DELAYED_WORK(&idev->mc_delrec_work, mld_clear_delrec_work);
 	ipv6_mc_reset(idev);
-	write_unlock_bh(&idev->lock);
 }
 
 /*
@@ -2743,6 +2762,8 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *mc, *tmp;
 
+	ASSERT_RTNL();
+
 	/* Deactivate works */
 	ipv6_mc_down(idev);
 	mld_clear_delrec(idev);
@@ -2757,15 +2778,11 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 	if (idev->cnf.forwarding)
 		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
 
-	write_lock_bh(&idev->lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
-		list_del(&mc->list);
-		write_unlock_bh(&idev->lock);
+		list_del_rcu(&mc->list);
 		ip6_mc_clear_src(mc);
 		mca_put(mc);
-		write_lock_bh(&idev->lock);
 	}
-	write_unlock_bh(&idev->lock);
 }
 
 static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
@@ -2775,12 +2792,11 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 	ASSERT_RTNL();
 
 	if (mld_in_v1_mode(idev)) {
-		read_lock_bh(&idev->lock);
 		list_for_each_entry(mc, &idev->mc_list, list)
 			mld_join_group(mc);
-		read_unlock_bh(&idev->lock);
-	} else
+	} else {
 		mld_send_report(idev, NULL);
+	}
 }
 
 static int ipv6_mc_netdev_event(struct notifier_block *this,
@@ -2829,12 +2845,10 @@ static inline struct ifmcaddr6 *mld_mc_get_first(struct seq_file *seq)
 		if (!idev)
 			continue;
 
-		read_lock_bh(&idev->lock);
-		list_for_each_entry(mc, &idev->mc_list, list) {
+		list_for_each_entry_rcu(mc, &idev->mc_list, list) {
 			state->idev = idev;
 			return mc;
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return NULL;
 }
@@ -2843,15 +2857,12 @@ static struct ifmcaddr6 *mld_mc_get_next(struct seq_file *seq, struct ifmcaddr6
 {
 	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
-	list_for_each_entry_continue(mc, &state->idev->mc_list, list)
+	list_for_each_entry_continue_rcu(mc, &state->idev->mc_list, list)
 		return mc;
 
 	mc = NULL;
 
 	while (!mc) {
-		if (state->idev)
-			read_unlock_bh(&state->idev->lock);
-
 		state->dev = next_net_device_rcu(state->dev);
 		if (!state->dev) {
 			state->idev = NULL;
@@ -2860,9 +2871,8 @@ static struct ifmcaddr6 *mld_mc_get_next(struct seq_file *seq, struct ifmcaddr6
 		state->idev = __in6_dev_get(state->dev);
 		if (!state->idev)
 			continue;
-		read_lock_bh(&state->idev->lock);
-		mc = list_first_entry_or_null(&state->idev->mc_list,
-					      struct ifmcaddr6, list);
+		mc = list_first_or_null_rcu(&state->idev->mc_list,
+					    struct ifmcaddr6, list);
 	}
 	return mc;
 }
@@ -2897,10 +2907,8 @@ static void mld_mc_seq_stop(struct seq_file *seq, void *v)
 {
 	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -2911,11 +2919,11 @@ static int mld_mc_seq_show(struct seq_file *seq, void *v)
 	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
 	seq_printf(seq,
-		   "%-4d %-15s %pi6 %5d %08X %ld\n",
+		   "%-4d %-15s %pi6 %5d %08lX %ld\n",
 		   state->dev->ifindex, state->dev->name,
 		   &mc->mca_addr,
 		   mc->mca_users, mc->mca_flags,
-		   (mc->mca_flags & MAF_TIMER_RUNNING) ?
+		   (test_bit(MCA_TIMER_RUNNING, &mc->mca_flags)) ?
 		   jiffies_to_clock_t(mc->mca_work.timer.expires - jiffies) : 0);
 	return 0;
 }
@@ -2951,21 +2959,17 @@ static inline struct ip6_sf_list *mld_mcf_get_first(struct seq_file *seq)
 		idev = __in6_dev_get(state->dev);
 		if (unlikely(idev == NULL))
 			continue;
-		read_lock_bh(&idev->lock);
-		mc = list_first_entry_or_null(&idev->mc_list,
-					      struct ifmcaddr6, list);
+		mc = list_first_or_null_rcu(&idev->mc_list,
+					    struct ifmcaddr6, list);
 		if (likely(mc)) {
-			spin_lock_bh(&mc->mca_lock);
-			psf = list_first_entry_or_null(&mc->mca_source_list,
-						       struct ip6_sf_list, list);
+			psf = list_first_or_null_rcu(&mc->mca_source_list,
+						     struct ip6_sf_list, list);
 			if (likely(psf)) {
 				state->mc = mc;
 				state->idev = idev;
 				break;
 			}
-			spin_unlock_bh(&mc->mca_lock);
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return psf;
 }
@@ -2975,29 +2979,23 @@ static struct ip6_sf_list *mld_mcf_get_next(struct seq_file *seq,
 {
 	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 
-	list_for_each_entry_continue(psf, &state->mc->mca_source_list, list)
+	list_for_each_entry_continue_rcu(psf, &state->mc->mca_source_list, list)
 		return psf;
 
 	psf = NULL;
 	while (!psf) {
-		spin_unlock_bh(&state->mc->mca_lock);
-		list_for_each_entry_continue(state->mc, &state->idev->mc_list, list) {
-			spin_lock_bh(&state->mc->mca_lock);
-			psf = list_first_entry_or_null(&state->mc->mca_source_list,
-						       struct ip6_sf_list, list);
-			if (!psf) {
-				spin_unlock_bh(&state->mc->mca_lock);
+		list_for_each_entry_continue_rcu(state->mc,
+						 &state->idev->mc_list, list) {
+			psf = list_first_or_null_rcu(&state->mc->mca_source_list,
+						     struct ip6_sf_list, list);
+			if (!psf)
 				continue;
-			}
 			goto out;
 		}
 
 		state->mc = NULL;
 
 		while (!state->mc) {
-			if (likely(state->idev))
-				read_unlock_bh(&state->idev->lock);
-
 			state->dev = next_net_device_rcu(state->dev);
 			if (!state->dev) {
 				state->idev = NULL;
@@ -3006,15 +3004,13 @@ static struct ip6_sf_list *mld_mcf_get_next(struct seq_file *seq,
 			state->idev = __in6_dev_get(state->dev);
 			if (!state->idev)
 				continue;
-			read_lock_bh(&state->idev->lock);
-			state->mc = list_first_entry_or_null(&state->idev->mc_list,
-							     struct ifmcaddr6, list);
+			state->mc = list_first_or_null_rcu(&state->idev->mc_list,
+							   struct ifmcaddr6, list);
 		}
 		if (!state->mc)
 			break;
-		spin_lock_bh(&state->mc->mca_lock);
-		psf = list_first_entry_or_null(&state->mc->mca_source_list,
-					       struct ip6_sf_list, list);
+		psf = list_first_or_null_rcu(&state->mc->mca_source_list,
+					     struct ip6_sf_list, list);
 	}
 out:
 	return psf;
@@ -3054,14 +3050,10 @@ static void mld_mcf_seq_stop(struct seq_file *seq, void *v)
 {
 	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 
-	if (likely(state->mc)) {
-		spin_unlock_bh(&state->mc->mca_lock);
+	if (likely(state->mc))
 		state->mc = NULL;
-	}
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -3075,12 +3067,12 @@ static int mld_mcf_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq, "Idx Device                Multicast Address                   Source Address    INC    EXC\n");
 	} else {
 		seq_printf(seq,
-			   "%3d %6.6s %pi6 %pi6 %6lu %6lu\n",
+			   "%3d %6.6s %pi6 %pi6 %6u %6u\n",
 			   state->dev->ifindex, state->dev->name,
 			   &state->mc->mca_addr,
 			   &psf->sf_addr,
-			   psf->sf_count[MCAST_INCLUDE],
-			   psf->sf_count[MCAST_EXCLUDE]);
+			   atomic_read(&psf->incl_count),
+			   atomic_read(&psf->excl_count));
 	}
 	return 0;
 }
@@ -3144,6 +3136,7 @@ static int __net_init mld_net_init(struct net *net)
 	}
 
 	inet6_sk(net->ipv6.igmp_sk)->hop_limit = 1;
+	net->ipv6.igmp_sk->sk_allocation = GFP_KERNEL;
 
 	err = inet_ctl_sock_create(&net->ipv6.mc_autojoin_sk, PF_INET6,
 				   SOCK_RAW, IPPROTO_ICMPV6, net);
-- 
2.17.1

