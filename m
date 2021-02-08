Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3904C313C08
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhBHSAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbhBHR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:59:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80726C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:58:30 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e12so8236844pls.4
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kK0uNANfn1a1IfQOCpu0I+YpRPDpVqCi2JCznRa/yIY=;
        b=aBhwpL97+/I10Jm8MIfvEZnPqP+szGSnE3bdCq7uv1kQ0jGRU/0tciwsdFg9R8rYVS
         ManszoWGF2F/9qdqyiOny0JqOYRpT2JSTV7Qo9/W8mDRDNHwoA3mAGcVEoBNwO05X07c
         nRD79YuYmKxXtpstR94yl/Mj0AQdSO8nAdo00Ishk9MzD3bMYcGj5wTaldmd4PddJYLp
         aGddOVW01L6cLX0oSkLoi4HCHmOi7QOvl+Vrg7ppSDSR6i3AoDNPrM3qCxEoNsQGFBiU
         asLyeR5oecVtEhIqqVYwgDe0h8vkao33aX+nZ6ZMSeY5hm+YSmJ7fob+mjdyF3KnEpGb
         3H0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kK0uNANfn1a1IfQOCpu0I+YpRPDpVqCi2JCznRa/yIY=;
        b=GNVVkw/s2nxccUTn/iAOHTyefJnxej5lod5hN4NPADkvQpzN3OkmfYMwnu4V9IFkb/
         Fb12sRTGTMIuyiSqXnr//2+fy+L69fCPPm1jE3Syg+foyGYcPAcInoNb+Rue22N0VkEZ
         h9kXQRFYMruLbmMP2KCiBpZkfqVKqdl/c8Ib9oMNOFtbBK0wnan82FVX0Xs+WTkFhK3r
         rDgyWTshz1Nz5zYdIF+QkUHh6e3F5mZgm1hLO6DtMHqjcAbrUkArdnaQXGMC9HEmAZ6a
         fFjqF6F17069w203qbIk2aVDLPh0Cnsn+yzLvAC+d1z/5yG0dWyy0rRgIRQ4CsOvARDc
         OHDA==
X-Gm-Message-State: AOAM530D/BvSWm8JiZeVxRuXvYItG1rjwo/Kxu0VM4SeftLafNYKKtpw
        uOMPMsUEW7eJN8P8fEDlxhs=
X-Google-Smtp-Source: ABdhPJwobNyMH3NFQPhl/GC8f8eH6u+qERgMKy4my38pTByzDMLD4gVle4wtfVUS7VBqNb4V8fxAew==
X-Received: by 2002:a17:902:c602:b029:e2:8422:ffbc with SMTP id r2-20020a170902c602b02900e28422ffbcmr17538032plr.78.1612807109909;
        Mon, 08 Feb 2021 09:58:29 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 194sm17016069pfu.165.2021.02.08.09.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:58:29 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
Date:   Mon,  8 Feb 2021 17:58:20 +0000
Message-Id: <20210208175820.5690-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct ip6_sf_socklist doesn't use list API so that code
shape is a little bit different from others.
So it converts ip6_sf_socklist to use list API so it would
improve readability.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/if_inet6.h  |  19 +-
 include/uapi/linux/in.h |   4 +-
 net/ipv6/mcast.c        | 387 +++++++++++++++++++++++++---------------
 3 files changed, 256 insertions(+), 154 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index babf19c27b29..6885ab8ec2e9 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -13,6 +13,7 @@
 #include <net/snmp.h>
 #include <linux/ipv6.h>
 #include <linux/refcount.h>
+#include <linux/types.h>
 
 /* inet6_dev.if_flags */
 
@@ -76,23 +77,19 @@ struct inet6_ifaddr {
 };
 
 struct ip6_sf_socklist {
-	unsigned int		sl_max;
-	unsigned int		sl_count;
-	struct in6_addr		sl_addr[];
+	struct list_head	list;
+	struct in6_addr		sl_addr;
+	struct rcu_head		rcu;
 };
 
-#define IP6_SFLSIZE(count)	(sizeof(struct ip6_sf_socklist) + \
-	(count) * sizeof(struct in6_addr))
-
-#define IP6_SFBLOCK	10	/* allocate this many at once */
-
 struct ipv6_mc_socklist {
 	struct in6_addr		addr;
 	int			ifindex;
-	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
+	bool			sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct list_head	list;
+	struct list_head	sflist;
 	rwlock_t		sflock;
-	struct ip6_sf_socklist	*sflist;
+	atomic_t		sl_count;
 	struct rcu_head		rcu;
 };
 
@@ -101,7 +98,7 @@ struct ip6_sf_list {
 	struct in6_addr		sf_addr;
 	unsigned long		sf_count[2];	/* include/exclude counts */
 	unsigned char		sf_gsresp;	/* include in g & s response? */
-	unsigned char		sf_oldin;	/* change state */
+	bool			sf_oldin;	/* change state */
 	unsigned char		sf_crcount;	/* retrans. left to send */
 };
 
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 7d6687618d80..97024873afd0 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -160,8 +160,8 @@ struct in_addr {
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
 
-#define MCAST_EXCLUDE	0
-#define MCAST_INCLUDE	1
+#define MCAST_EXCLUDE	false
+#define MCAST_INCLUDE	true
 
 /* These need to appear somewhere around here */
 #define IP_DEFAULT_MULTICAST_TTL        1
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index f4fc29fcdf48..45b683b15835 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -80,13 +80,18 @@ static int sf_setstate(struct ifmcaddr6 *mc);
 static void sf_markstate(struct ifmcaddr6 *mc);
 static void ip6_mc_clear_src(struct ifmcaddr6 *mc);
 static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
-			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
-			  int delta);
+			  int sfmode, const struct in6_addr *psfsrc, int delta);
+static void ip6_mc_del_src_bulk(struct inet6_dev *idev,
+				struct ipv6_mc_socklist *mc_lst,
+				struct sock *sk);
 static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
-			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
-			  int delta);
-static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
-			    struct inet6_dev *idev);
+			  int sfmode, const struct in6_addr *psfsrc, int delta);
+static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
+			       struct list_head *head,
+			       struct sockaddr_storage *list,
+			       struct sock *sk);
+static void ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
+			     struct inet6_dev *idev);
 static int __ipv6_dev_mc_inc(struct net_device *dev,
 			     const struct in6_addr *addr, unsigned int mode);
 
@@ -178,8 +183,9 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 
 	mc_lst->ifindex = dev->ifindex;
 	mc_lst->sfmode = mode;
+	atomic_set(&mc_lst->sl_count, 0);
 	rwlock_init(&mc_lst->sflock);
-	mc_lst->sflist = NULL;
+	INIT_LIST_HEAD(&mc_lst->sflist);
 
 	/*
 	 *	now add/increase the group membership on the device
@@ -334,7 +340,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	int leavegroup = 0;
 	bool found = false;
 	int mclocked = 0;
-	int i, j, rv;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -365,89 +370,70 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		goto done;
 	}
 	/* if a source filter was set, must be the same mode as before */
-	if (mc_lst->sflist) {
+	if (!list_empty(&mc_lst->sflist)) {
 		if (mc_lst->sfmode != omode) {
 			err = -EINVAL;
 			goto done;
 		}
 	} else if (mc_lst->sfmode != omode) {
 		/* allow mode switches for empty-set filters */
-		ip6_mc_add_src(idev, group, omode, 0, NULL, 0);
-		ip6_mc_del_src(idev, group, mc_lst->sfmode, 0, NULL, 0);
+		ip6_mc_add_src(idev, group, omode, NULL, 0);
+		ip6_mc_del_src(idev, group, mc_lst->sfmode, NULL, 0);
 		mc_lst->sfmode = omode;
 	}
 
 	write_lock(&mc_lst->sflock);
 	mclocked = 1;
 
-	psl = mc_lst->sflist;
 	if (!add) {
-		if (!psl)
-			goto done;	/* err = -EADDRNOTAVAIL */
-		rv = !0;
-		for (i = 0; i < psl->sl_count; i++) {
-			rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
-			if (rv == 0)
+		found = false;
+		list_for_each_entry(psl, &mc_lst->sflist, list) {
+			if (ipv6_addr_equal(&psl->sl_addr, source)) {
+				found = true;
 				break;
+			}
 		}
-		if (rv)		/* source not found */
+		if (!found)
 			goto done;	/* err = -EADDRNOTAVAIL */
 
 		/* special case - (INCLUDE, empty) == LEAVE_GROUP */
-		if (psl->sl_count == 1 && omode == MCAST_INCLUDE) {
+		if (atomic_read(&mc_lst->sl_count) == 1 &&
+		    omode == MCAST_INCLUDE) {
 			leavegroup = 1;
 			goto done;
 		}
 
 		/* update the interface filter */
-		ip6_mc_del_src(idev, group, omode, 1, source, 1);
+		ip6_mc_del_src(idev, group, omode, &psl->sl_addr, 1);
 
-		for (j = i+1; j < psl->sl_count; j++)
-			psl->sl_addr[j-1] = psl->sl_addr[j];
-		psl->sl_count--;
+		list_del_rcu(&psl->list);
+		atomic_dec(&mc_lst->sl_count);
 		err = 0;
 		goto done;
 	}
 	/* else, add a new source to the filter */
 
-	if (psl && psl->sl_count >= sysctl_mld_max_msf) {
+	if (atomic_read(&mc_lst->sl_count) >= sysctl_mld_max_msf) {
 		err = -ENOBUFS;
 		goto done;
 	}
-	if (!psl || psl->sl_count == psl->sl_max) {
-		struct ip6_sf_socklist *newpsl;
-		int count = IP6_SFBLOCK;
 
-		if (psl)
-			count += psl->sl_max;
-		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(count), GFP_ATOMIC);
-		if (!newpsl) {
-			err = -ENOBUFS;
-			goto done;
-		}
-		newpsl->sl_max = count;
-		newpsl->sl_count = count - IP6_SFBLOCK;
-		if (psl) {
-			for (i = 0; i < psl->sl_count; i++)
-				newpsl->sl_addr[i] = psl->sl_addr[i];
-			sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
-		}
-		psl = newpsl;
-		mc_lst->sflist = psl;
-	}
-	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
-	for (i = 0; i < psl->sl_count; i++) {
-		rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
-		if (rv == 0) /* There is an error in the address. */
+	list_for_each_entry(psl, &mc_lst->sflist, list)
+		if (ipv6_addr_equal(&psl->sl_addr, source))
 			goto done;
+
+	psl = sock_kmalloc(sk, sizeof(struct ip6_sf_socklist), GFP_ATOMIC);
+	if (!psl) {
+		err = -ENOBUFS;
+		goto done;
 	}
-	for (j = psl->sl_count-1; j >= i; j--)
-		psl->sl_addr[j+1] = psl->sl_addr[j];
-	psl->sl_addr[i] = *source;
-	psl->sl_count++;
+	atomic_inc(&mc_lst->sl_count);
+	psl->sl_addr = *source;
+	list_add_rcu(&psl->list, &mc_lst->sflist);
+
 	err = 0;
 	/* update the interface list */
-	ip6_mc_add_src(idev, group, omode, 1, source, 1);
+	ip6_mc_add_src(idev, group, omode, &psl->sl_addr, 1);
 done:
 	if (mclocked)
 		write_unlock(&mc_lst->sflock);
@@ -462,14 +448,14 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		    struct sockaddr_storage *list)
 {
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
-	struct ip6_sf_socklist *newpsl, *psl;
 	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
 	const struct in6_addr *group;
 	struct inet6_dev *idev;
 	int leavegroup = 0;
 	bool found = false;
-	int i, err;
+	LIST_HEAD(head);
+	int err;
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
@@ -506,40 +492,19 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		err = -EINVAL;
 		goto done;
 	}
-	if (gsf->gf_numsrc) {
-		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(gsf->gf_numsrc),
-							  GFP_ATOMIC);
-		if (!newpsl) {
-			err = -ENOBUFS;
-			goto done;
-		}
-		newpsl->sl_max = newpsl->sl_count = gsf->gf_numsrc;
-		for (i = 0; i < newpsl->sl_count; ++i, ++list) {
-			struct sockaddr_in6 *psin6;
 
-			psin6 = (struct sockaddr_in6 *)list;
-			newpsl->sl_addr[i] = psin6->sin6_addr;
-		}
-		err = ip6_mc_add_src(idev, group, gsf->gf_fmode,
-			newpsl->sl_count, newpsl->sl_addr, 0);
-		if (err) {
-			sock_kfree_s(sk, newpsl, IP6_SFLSIZE(newpsl->sl_max));
-			goto done;
-		}
-	} else {
-		newpsl = NULL;
-		ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
-	}
+	if (gsf->gf_numsrc)
+		err = ip6_mc_add_src_bulk(idev, gsf, &head, list, sk);
+	else
+		err = ip6_mc_add_src(idev, group, gsf->gf_fmode, NULL, 0);
+
+	if (err)
+		goto done;
 
 	write_lock(&mc_lst->sflock);
-	psl = mc_lst->sflist;
-	if (psl) {
-		ip6_mc_del_src(idev, group, mc_lst->sfmode,
-			       psl->sl_count, psl->sl_addr, 0);
-		sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
-	} else
-		ip6_mc_del_src(idev, group, mc_lst->sfmode, 0, NULL, 0);
-	mc_lst->sflist = newpsl;
+	ip6_mc_del_src_bulk(idev, mc_lst, sk);
+	atomic_set(&mc_lst->sl_count, gsf->gf_numsrc);
+	list_splice(&head, &mc_lst->sflist);
 	mc_lst->sfmode = gsf->gf_fmode;
 	write_unlock(&mc_lst->sflock);
 	err = 0;
@@ -548,6 +513,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	rcu_read_unlock();
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, gsf->gf_interface, group);
+
 	return err;
 }
 
@@ -557,11 +523,11 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ipv6_mc_socklist *mc_lst;
 	struct net *net = sock_net(sk);
-	int err, i, count, copycount;
 	const struct in6_addr *group;
 	struct ip6_sf_socklist *psl;
 	struct inet6_dev *idev;
 	bool found = false;
+	int err, i;
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
@@ -593,27 +559,31 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	if (!found)		/* must have a prior join */
 		goto done;
 	gsf->gf_fmode = mc_lst->sfmode;
-	psl = mc_lst->sflist;
-	count = psl ? psl->sl_count : 0;
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 
-	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
-	gsf->gf_numsrc = count;
-	/* changes to psl require the socket lock, and a write lock
-	 * on mc_lst->sflock. We have the socket lock so reading here is safe.
-	 */
-	for (i = 0; i < copycount; i++, p++) {
+	i = 0;
+	read_lock(&mc_lst->sflock);
+	list_for_each_entry(psl, &mc_lst->sflist, list) {
 		struct sockaddr_in6 *psin6;
 		struct sockaddr_storage ss;
 
+		if (i >= gsf->gf_numsrc)
+			break;
+
 		psin6 = (struct sockaddr_in6 *)&ss;
 		memset(&ss, 0, sizeof(ss));
 		psin6->sin6_family = AF_INET6;
-		psin6->sin6_addr = psl->sl_addr[i];
-		if (copy_to_user(p, &ss, sizeof(ss)))
+		psin6->sin6_addr = psl->sl_addr;
+		if (copy_to_user(p, &ss, sizeof(ss))) {
+			read_unlock(&mc_lst->sflock);
 			return -EFAULT;
+		}
+		p++;
+		i++;
 	}
+	gsf->gf_numsrc = i;
+	read_unlock(&mc_lst->sflock);
 	return 0;
 done:
 	read_unlock_bh(&idev->lock);
@@ -641,19 +611,20 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		return np->mc_all;
 	}
 	read_lock(&mc_lst->sflock);
-	psl = mc_lst->sflist;
-	if (!psl) {
+
+	found = false;
+	if (list_empty(&mc_lst->sflist)) {
 		rv = mc_lst->sfmode == MCAST_EXCLUDE;
 	} else {
-		int i;
-
-		for (i = 0; i < psl->sl_count; i++) {
-			if (ipv6_addr_equal(&psl->sl_addr[i], src_addr))
+		list_for_each_entry_rcu(psl, &mc_lst->sflist, list) {
+			if (ipv6_addr_equal(&psl->sl_addr, src_addr)) {
+				found = true;
 				break;
+			}
 		}
-		if (mc_lst->sfmode == MCAST_INCLUDE && i >= psl->sl_count)
+		if (mc_lst->sfmode == MCAST_INCLUDE && !found)
 			rv = false;
-		if (mc_lst->sfmode == MCAST_EXCLUDE && i < psl->sl_count)
+		if (mc_lst->sfmode == MCAST_EXCLUDE && found)
 			rv = false;
 	}
 	read_unlock(&mc_lst->sflock);
@@ -900,7 +871,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			mc->mca_users++;
 			write_unlock_bh(&idev->lock);
-			ip6_mc_add_src(idev, &mc->mca_addr, mode, 0, NULL, 0);
+			ip6_mc_add_src(idev, &mc->mca_addr, mode, NULL, 0);
 			in6_dev_put(idev);
 			return 0;
 		}
@@ -2171,16 +2142,16 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *mc, int sfmode,
 }
 
 static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
-			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
-			  int delta)
+			  int sfmode, const struct in6_addr *psfsrc, int delta)
 {
 	struct ifmcaddr6 *mc;
 	bool found = false;
 	int changerec = 0;
-	int i, err;
+	int i, err, rv;
 
 	if (!idev)
 		return -ENODEV;
+
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
@@ -2204,13 +2175,16 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 		mc->mca_sfcount[sfmode]--;
 	}
 	err = 0;
-	for (i = 0; i < sfcount; i++) {
-		int rv = ip6_mc_del1_src(mc, sfmode, &psfsrc[i]);
+	i = 0;
+
+	if (psfsrc) {
+		rv = ip6_mc_del1_src(mc, sfmode, psfsrc);
 
 		changerec |= rv > 0;
 		if (!err && rv < 0)
 			err = rv;
 	}
+
 	if (mc->mca_sfmode == MCAST_EXCLUDE &&
 	    mc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
 	    mc->mca_sfcount[MCAST_INCLUDE]) {
@@ -2231,6 +2205,71 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	return err;
 }
 
+static void ip6_mc_del_src_bulk(struct inet6_dev *idev,
+				struct ipv6_mc_socklist *mc_lst,
+				struct sock *sk)
+{
+	struct in6_addr *mca = &mc_lst->addr;
+	struct ip6_sf_socklist *psl, *tmp;
+	int sfmode = mc_lst->sfmode;
+	struct ifmcaddr6 *mc;
+	bool found = false;
+	int changerec = 0;
+	int i, rv;
+
+	if (!idev)
+		return;
+
+	read_lock_bh(&idev->lock);
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		/* MCA not found?? bug */
+		read_unlock_bh(&idev->lock);
+		return;
+	}
+	spin_lock_bh(&mc->mca_lock);
+	sf_markstate(mc);
+	if (!mc->mca_sfcount[sfmode]) {
+		spin_unlock_bh(&mc->mca_lock);
+		read_unlock_bh(&idev->lock);
+		return;
+	}
+	mc->mca_sfcount[sfmode]--;
+	i = 0;
+
+	list_for_each_entry_safe(psl, tmp, &mc_lst->sflist, list) {
+		rv = ip6_mc_del1_src(mc, sfmode, &psl->sl_addr);
+		list_del_rcu(&psl->list);
+		atomic_sub(sizeof(*psl), &sk->sk_omem_alloc);
+		kfree_rcu(psl, rcu);
+
+		changerec |= rv > 0;
+	}
+
+	if (mc->mca_sfmode == MCAST_EXCLUDE &&
+	    mc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
+	    mc->mca_sfcount[MCAST_INCLUDE]) {
+		struct ip6_sf_list *psf;
+
+		/* filter mode change */
+		mc->mca_sfmode = MCAST_INCLUDE;
+		mc->mca_crcount = idev->mc_qrv;
+		idev->mc_ifc_count = mc->mca_crcount;
+		list_for_each_entry(psf, &mc->mca_source_list, list)
+			psf->sf_crcount = 0;
+		mld_ifc_event(mc->idev);
+	} else if (sf_setstate(mc) || changerec) {
+		mld_ifc_event(mc->idev);
+	}
+	spin_unlock_bh(&mc->mca_lock);
+	read_unlock_bh(&idev->lock);
+}
+
 /*
  * Add multicast single-source filter to the interface list
  */
@@ -2353,14 +2392,14 @@ static int sf_setstate(struct ifmcaddr6 *mc)
 /*
  * Add multicast source filter list to the interface list
  */
+
 static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
-			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
-			  int delta)
+			  int sfmode, const struct in6_addr *psfsrc, int delta)
 {
 	struct ifmcaddr6 *mc;
 	bool found = false;
 	int isexclude;
-	int i, err;
+	int err = 0;
 
 	if (!idev)
 		return -ENODEV;
@@ -2383,19 +2422,99 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	isexclude = mc->mca_sfmode == MCAST_EXCLUDE;
 	if (!delta)
 		mc->mca_sfcount[sfmode]++;
-	err = 0;
-	for (i = 0; i < sfcount; i++) {
-		err = ip6_mc_add1_src(mc, sfmode, &psfsrc[i]);
+
+	if (psfsrc)
+		err = ip6_mc_add1_src(mc, sfmode, psfsrc);
+
+	if (err) {
+		if (!delta)
+			mc->mca_sfcount[sfmode]--;
+	} else if (isexclude != (mc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
+		struct ip6_sf_list *psf;
+
+		/* filter mode change */
+		if (mc->mca_sfcount[MCAST_EXCLUDE])
+			mc->mca_sfmode = MCAST_EXCLUDE;
+		else if (mc->mca_sfcount[MCAST_INCLUDE])
+			mc->mca_sfmode = MCAST_INCLUDE;
+		/* else no filters; keep old mode for reports */
+
+		mc->mca_crcount = idev->mc_qrv;
+		idev->mc_ifc_count = mc->mca_crcount;
+		list_for_each_entry(psf, &mc->mca_source_list, list)
+			psf->sf_crcount = 0;
+		mld_ifc_event(idev);
+	} else if (sf_setstate(mc)) {
+		mld_ifc_event(idev);
+	}
+
+	spin_unlock_bh(&mc->mca_lock);
+	read_unlock_bh(&idev->lock);
+	return err;
+}
+
+static int ip6_mc_add_src_bulk(struct inet6_dev *idev, struct group_filter *gsf,
+			       struct list_head *head,
+			       struct sockaddr_storage *list,
+			       struct sock *sk)
+{
+	struct ip6_sf_socklist *psl, *tmp;
+	const struct in6_addr *group;
+	int sfmode = gsf->gf_fmode;
+	struct ifmcaddr6 *mc;
+	bool found = false;
+	int isexclude;
+	int i, err = 0;
+
+	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
+
+	if (!idev)
+		return -ENODEV;
+
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		if (ipv6_addr_equal(group, &mc->mca_addr)) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		/* MCA not found?? bug */
+		return -ESRCH;
+	}
+	spin_lock_bh(&mc->mca_lock);
+
+	sf_markstate(mc);
+	isexclude = mc->mca_sfmode == MCAST_EXCLUDE;
+	mc->mca_sfcount[sfmode]++;
+
+	for (i = 0; i < gsf->gf_numsrc; i++, ++list) {
+		struct sockaddr_in6 *psin6;
+
+		psl = sock_kmalloc(sk, sizeof(struct ip6_sf_socklist),
+				   GFP_ATOMIC);
+		if (!psl) {
+			err = -ENOBUFS;
+			break;
+		}
+		INIT_LIST_HEAD(&psl->list);
+		psin6 = (struct sockaddr_in6 *)list;
+		psl->sl_addr = psin6->sin6_addr;
+
+		err = ip6_mc_add1_src(mc, gsf->gf_fmode, &psl->sl_addr);
 		if (err)
 			break;
+
+		list_add_tail(&psl->list, head);
 	}
+
 	if (err) {
-		int j;
+		mc->mca_sfcount[sfmode]--;
 
-		if (!delta)
-			mc->mca_sfcount[sfmode]--;
-		for (j = 0; j < i; j++)
-			ip6_mc_del1_src(mc, sfmode, &psfsrc[j]);
+		list_for_each_entry_safe(psl, tmp, head, list) {
+			list_del(&psl->list);
+			atomic_sub(sizeof(*psl), &sk->sk_omem_alloc);
+			kfree(psl);
+		}
 	} else if (isexclude != (mc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
 		struct ip6_sf_list *psf;
 
@@ -2414,7 +2533,7 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 	} else if (sf_setstate(mc))
 		mld_ifc_event(idev);
 	spin_unlock_bh(&mc->mca_lock);
-	read_unlock_bh(&idev->lock);
+
 	return err;
 }
 
@@ -2462,26 +2581,12 @@ static void mld_join_group(struct ifmcaddr6 *mc)
 	spin_unlock_bh(&mc->mca_lock);
 }
 
-static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
-			    struct inet6_dev *idev)
+static void ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *mc_lst,
+			     struct inet6_dev *idev)
 {
-	int err;
-
 	write_lock_bh(&mc_lst->sflock);
-	if (!mc_lst->sflist) {
-		/* any-source empty exclude case */
-		err = ip6_mc_del_src(idev, &mc_lst->addr, mc_lst->sfmode,
-				     0, NULL, 0);
-	} else {
-		err = ip6_mc_del_src(idev, &mc_lst->addr, mc_lst->sfmode,
-				     mc_lst->sflist->sl_count,
-				     mc_lst->sflist->sl_addr, 0);
-		sock_kfree_s(sk, mc_lst->sflist,
-			     IP6_SFLSIZE(mc_lst->sflist->sl_max));
-		mc_lst->sflist = NULL;
-	}
+	ip6_mc_del_src_bulk(idev, mc_lst, sk);
 	write_unlock_bh(&mc_lst->sflock);
-	return err;
 }
 
 static void mld_leave_group(struct ifmcaddr6 *mc)
-- 
2.17.1

