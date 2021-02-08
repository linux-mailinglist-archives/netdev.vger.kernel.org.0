Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676DE313BB9
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhBHR4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbhBHRyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:54:03 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634F2C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:53:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e12so8228799pls.4
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sIoJfBY6gvII0G/ajcUNA3OL6aOnfe4EVuUO638/0Qs=;
        b=NFIO5lzab0Twjl8rbevlgBgWh/fH/tZ5s5+K7M4cl6e0vV6y1e8nsoP8i/uPSLF+TC
         CT2BLhCoKHscgMyFhyBrWZRVZ/9Kl/v8wa1xv2uxq0ZEWuNgnggCfD3y5kEgFHE2baCo
         QuxK0roOYRSNL8VvjDNMmIbnYFs/+yXIEtXfTXB/3spIH6XFptxxwXkRWlbFQ8cr9lvV
         1yNVKWtgACii8B93UE8c67thvMTjsMFh43UD+0kMX2Ed5wwymkxzGScebZyt8cpyDCwX
         CrfxJzRYv1KcBUrf96P8iYpOtEljkpA9IKoxJIHEMJRszEzemnN8jmMShzzQZmWgLxVw
         9YCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sIoJfBY6gvII0G/ajcUNA3OL6aOnfe4EVuUO638/0Qs=;
        b=pprAIJG+HHii6ZVfpc/K0EEFG8Skj5i8AdOdQM3hKqVKR9M7ibCXOwy15onV1xDVRF
         dVtr7IN4l49yyD/eRH1fXJSvLEUsrgNXlphdklQksLqNkD/KhijnMnCt+02wOAf3Q095
         7L6Xkqss4As2ZX4zKN/CkJeyzVt+1m7AGjVOROdIgsJA58unj/0QMqT0hKS7UUvb6Gro
         /kNcyww4rhdNF2zE/TSUAGuHoJIL/1Eae/hx3ejylLY7IzyIdj5F2CDXPKIm7F2CUETV
         W1wEkXdB7PRPVTJtPf9oRXnnQfpFX+/+O6mUs6ya0g8jRfpe5H9giLGrJTFcHIhGqTqJ
         b5bw==
X-Gm-Message-State: AOAM530l3RQ0KiYrYkORThLz2IXL3WF6gKDUZHlzlA7vCWtJtAQb/PuQ
        6p96DCSviQ9ZDHFHBGY1k9w=
X-Google-Smtp-Source: ABdhPJwKwskGOGQ6pjhLoe8iNTvP6I1DKosPTJuRfuSEbi3YL6WFoUWjDTv95RjD/YPAgiicwqXBXg==
X-Received: by 2002:a17:902:b08f:b029:dc:8ac6:a147 with SMTP id p15-20020a170902b08fb02900dc8ac6a147mr17514694plr.84.1612806801497;
        Mon, 08 Feb 2021 09:53:21 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id y5sm17094933pfp.42.2021.02.08.09.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:52:52 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        yoshfuji@linux-ipv6.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 1/8] mld: convert ifmcaddr6 to list macros
Date:   Mon,  8 Feb 2021 17:52:07 +0000
Message-Id: <20210208175207.4962-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct ifmcaddr6 doesn't use list API so that code shape is
a little bit different from others.
So it converts ifmcaddr6 to use list API so it would improve readability.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/s390/net/qeth_l3_main.c |   2 +-
 include/net/if_inet6.h          |   9 +-
 net/batman-adv/multicast.c      |   2 +-
 net/ipv6/addrconf.c             |   7 +-
 net/ipv6/addrconf_core.c        |   3 +-
 net/ipv6/mcast.c                | 999 ++++++++++++++++----------------
 6 files changed, 523 insertions(+), 499 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index dd441eaec66e..e49abdeff69c 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1099,7 +1099,7 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	tmp.is_multicast = 1;
 
 	read_lock_bh(&in6_dev->lock);
-	for (im6 = in6_dev->mc_list; im6 != NULL; im6 = im6->next) {
+	list_for_each_entry(im6, in6_dev->mc_list, list) {
 		tmp.u.a6.addr = im6->mca_addr;
 
 		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 8bf5906073bc..1262ccd5221e 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -114,7 +114,7 @@ struct ip6_sf_list {
 struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
 	struct inet6_dev	*idev;
-	struct ifmcaddr6	*next;
+	struct list_head	list;
 	struct ip6_sf_list	*mca_sources;
 	struct ip6_sf_list	*mca_tomb;
 	unsigned int		mca_sfmode;
@@ -164,10 +164,9 @@ struct inet6_dev {
 	struct net_device	*dev;
 
 	struct list_head	addr_list;
-
-	struct ifmcaddr6	*mc_list;
-	struct ifmcaddr6	*mc_tomb;
-	spinlock_t		mc_lock;
+	struct list_head	mc_list;
+	struct list_head	mc_tomb_list;
+	spinlock_t		mc_tomb_lock;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 854e5ff28a3f..1a9ad5a9257b 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -455,7 +455,7 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 	}
 
 	read_lock_bh(&in6_dev->lock);
-	for (pmc6 = in6_dev->mc_list; pmc6; pmc6 = pmc6->next) {
+	list_for_each_entry(pmc6, &in6_dev->mc_list, list) {
 		if (IPV6_ADDR_MC_SCOPE(&pmc6->mca_addr) <
 		    IPV6_ADDR_SCOPE_LINKLOCAL)
 			continue;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f2337fb756ac..e9fe0eee5768 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5110,13 +5110,14 @@ static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = idev->mc_list; ifmca;
-		     ifmca = ifmca->next, ip_idx++) {
+		list_for_each_entry(ifmca, &idev->mc_list, list) {
 			if (ip_idx < s_ip_idx)
-				continue;
+				goto next2;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);
 			if (err < 0)
 				break;
+next2:
+			ip_idx++;
 		}
 		break;
 	case ANYCAST_ADDR:
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index c70c192bc91b..b55f85dcfd74 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -250,7 +250,8 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 	struct net_device *dev = idev->dev;
 
 	WARN_ON(!list_empty(&idev->addr_list));
-	WARN_ON(idev->mc_list);
+	WARN_ON(!list_empty(&idev->mc_list));
+	WARN_ON(!list_empty(&idev->mc_tomb_list));
 	WARN_ON(timer_pending(&idev->rs_timer));
 
 #ifdef NET_REFCNT_DEBUG
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6c8604390266..508c007df84f 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -69,24 +69,19 @@ static int __mld2_query_bugs[] __attribute__((__unused__)) = {
 
 static struct in6_addr mld2_all_mcr = MLD2_ALL_MCR_INIT;
 
-static void igmp6_join_group(struct ifmcaddr6 *ma);
-static void igmp6_leave_group(struct ifmcaddr6 *ma);
+static void igmp6_join_group(struct ifmcaddr6 *mc);
+static void igmp6_leave_group(struct ifmcaddr6 *mc);
 static void igmp6_timer_handler(struct timer_list *t);
 
-static void mld_gq_timer_expire(struct timer_list *t);
-static void mld_ifc_timer_expire(struct timer_list *t);
 static void mld_ifc_event(struct inet6_dev *idev);
-static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
-static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
-static void mld_clear_delrec(struct inet6_dev *idev);
 static bool mld_in_v1_mode(const struct inet6_dev *idev);
-static int sf_setstate(struct ifmcaddr6 *pmc);
-static void sf_markstate(struct ifmcaddr6 *pmc);
-static void ip6_mc_clear_src(struct ifmcaddr6 *pmc);
-static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
+static int sf_setstate(struct ifmcaddr6 *mc);
+static void sf_markstate(struct ifmcaddr6 *mc);
+static void ip6_mc_clear_src(struct ifmcaddr6 *mc);
+static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta);
-static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
+static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta);
 static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
@@ -113,10 +108,23 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
  *	socket join on multicast group
  */
 
-#define for_each_pmc_rcu(np, pmc)				\
-	for (pmc = rcu_dereference(np->ipv6_mc_list);		\
-	     pmc != NULL;					\
-	     pmc = rcu_dereference(pmc->next))
+#define for_each_mc_rcu(np, mc)				\
+	for (mc = rcu_dereference((np)->ipv6_mc_list);	\
+	     mc;					\
+	     mc = rcu_dereference(mc->next))
+
+static void mca_get(struct ifmcaddr6 *mc)
+{
+	refcount_inc(&mc->mca_refcnt);
+}
+
+static void mca_put(struct ifmcaddr6 *mc)
+{
+	if (refcount_dec_and_test(&mc->mca_refcnt)) {
+		in6_dev_put(mc->idev);
+		kfree(mc);
+	}
+}
 
 static int unsolicited_report_interval(struct inet6_dev *idev)
 {
@@ -145,7 +153,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 		return -EINVAL;
 
 	rcu_read_lock();
-	for_each_pmc_rcu(np, mc_lst) {
+	for_each_mc_rcu(np, mc_lst) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
 			rcu_read_unlock();
@@ -328,15 +336,15 @@ void ipv6_sock_mc_close(struct sock *sk)
 int ip6_mc_source(int add, int omode, struct sock *sk,
 	struct group_source_req *pgsr)
 {
-	struct in6_addr *source, *group;
-	struct ipv6_mc_socklist *pmc;
-	struct inet6_dev *idev;
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
-	struct ip6_sf_socklist *psl;
+	struct in6_addr *source, *group;
 	struct net *net = sock_net(sk);
-	int i, j, rv;
+	struct ipv6_mc_socklist *mc;
+	struct ip6_sf_socklist *psl;
+	struct inet6_dev *idev;
 	int leavegroup = 0;
-	int pmclocked = 0;
+	int mclocked = 0;
+	int i, j, rv;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -354,33 +362,33 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 
 	err = -EADDRNOTAVAIL;
 
-	for_each_pmc_rcu(inet6, pmc) {
-		if (pgsr->gsr_interface && pmc->ifindex != pgsr->gsr_interface)
+	for_each_mc_rcu(inet6, mc) {
+		if (pgsr->gsr_interface && mc->ifindex != pgsr->gsr_interface)
 			continue;
-		if (ipv6_addr_equal(&pmc->addr, group))
+		if (ipv6_addr_equal(&mc->addr, group))
 			break;
 	}
-	if (!pmc) {		/* must have a prior join */
+	if (!mc) {		/* must have a prior join */
 		err = -EINVAL;
 		goto done;
 	}
 	/* if a source filter was set, must be the same mode as before */
-	if (pmc->sflist) {
-		if (pmc->sfmode != omode) {
+	if (mc->sflist) {
+		if (mc->sfmode != omode) {
 			err = -EINVAL;
 			goto done;
 		}
-	} else if (pmc->sfmode != omode) {
+	} else if (mc->sfmode != omode) {
 		/* allow mode switches for empty-set filters */
 		ip6_mc_add_src(idev, group, omode, 0, NULL, 0);
-		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
-		pmc->sfmode = omode;
+		ip6_mc_del_src(idev, group, mc->sfmode, 0, NULL, 0);
+		mc->sfmode = omode;
 	}
 
-	write_lock(&pmc->sflock);
-	pmclocked = 1;
+	write_lock(&mc->sflock);
+	mclocked = 1;
 
-	psl = pmc->sflist;
+	psl = mc->sflist;
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -432,7 +440,8 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
 		}
-		pmc->sflist = psl = newpsl;
+		psl = newpsl;
+		mc->sflist = psl;
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -448,8 +457,8 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
-	if (pmclocked)
-		write_unlock(&pmc->sflock);
+	if (mclocked)
+		write_unlock(&mc->sflock);
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 	if (leavegroup)
@@ -460,12 +469,12 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		    struct sockaddr_storage *list)
 {
-	const struct in6_addr *group;
-	struct ipv6_mc_socklist *pmc;
-	struct inet6_dev *idev;
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *newpsl, *psl;
 	struct net *net = sock_net(sk);
+	const struct in6_addr *group;
+	struct ipv6_mc_socklist *mc;
+	struct inet6_dev *idev;
 	int leavegroup = 0;
 	int i, err;
 
@@ -492,13 +501,13 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	for_each_pmc_rcu(inet6, pmc) {
-		if (pmc->ifindex != gsf->gf_interface)
+	for_each_mc_rcu(inet6, mc) {
+		if (mc->ifindex != gsf->gf_interface)
 			continue;
-		if (ipv6_addr_equal(&pmc->addr, group))
+		if (ipv6_addr_equal(&mc->addr, group))
 			break;
 	}
-	if (!pmc) {		/* must have a prior join */
+	if (!mc) {		/* must have a prior join */
 		err = -EINVAL;
 		goto done;
 	}
@@ -524,20 +533,20 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		}
 	} else {
 		newpsl = NULL;
-		(void) ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
+		ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
 	}
 
-	write_lock(&pmc->sflock);
-	psl = pmc->sflist;
+	write_lock(&mc->sflock);
+	psl = mc->sflist;
 	if (psl) {
-		(void) ip6_mc_del_src(idev, group, pmc->sfmode,
-			psl->sl_count, psl->sl_addr, 0);
+		ip6_mc_del_src(idev, group, mc->sfmode,
+			       psl->sl_count, psl->sl_addr, 0);
 		sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
 	} else
-		(void) ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
-	pmc->sflist = newpsl;
-	pmc->sfmode = gsf->gf_fmode;
-	write_unlock(&pmc->sflock);
+		ip6_mc_del_src(idev, group, mc->sfmode, 0, NULL, 0);
+	mc->sflist = newpsl;
+	mc->sfmode = gsf->gf_fmode;
+	write_unlock(&mc->sflock);
 	err = 0;
 done:
 	read_unlock_bh(&idev->lock);
@@ -552,7 +561,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 {
 	int err, i, count, copycount;
 	const struct in6_addr *group;
-	struct ipv6_mc_socklist *pmc;
+	struct ipv6_mc_socklist *mc;
 	struct inet6_dev *idev;
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *psl;
@@ -577,16 +586,16 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	 * so reading the list is safe.
 	 */
 
-	for_each_pmc_rcu(inet6, pmc) {
-		if (pmc->ifindex != gsf->gf_interface)
+	for_each_mc_rcu(inet6, mc) {
+		if (mc->ifindex != gsf->gf_interface)
 			continue;
-		if (ipv6_addr_equal(group, &pmc->addr))
+		if (ipv6_addr_equal(group, &mc->addr))
 			break;
 	}
-	if (!pmc)		/* must have a prior join */
+	if (!mc)		/* must have a prior join */
 		goto done;
-	gsf->gf_fmode = pmc->sfmode;
-	psl = pmc->sflist;
+	gsf->gf_fmode = mc->sfmode;
+	psl = mc->sflist;
 	count = psl ? psl->sl_count : 0;
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
@@ -594,7 +603,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
 	/* changes to psl require the socket lock, and a write lock
-	 * on pmc->sflock. We have the socket lock so reading here is safe.
+	 * on mc->sflock. We have the socket lock so reading here is safe.
 	 */
 	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_in6 *psin6;
@@ -623,7 +632,7 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 	bool rv = true;
 
 	rcu_read_lock();
-	for_each_pmc_rcu(np, mc) {
+	for_each_mc_rcu(np, mc) {
 		if (ipv6_addr_equal(&mc->addr, mc_addr))
 			break;
 	}
@@ -723,7 +732,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
  */
 static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 {
-	struct ifmcaddr6 *pmc;
+	struct ifmcaddr6 *mc;
 
 	/* this is an "ifmcaddr6" for convenience; only the fields below
 	 * are actually used. In particular, the refcnt and users are not
@@ -731,98 +740,91 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	 * for deleted items allows change reports to use common code with
 	 * non-deleted or query-response MCA's.
 	 */
-	pmc = kzalloc(sizeof(*pmc), GFP_ATOMIC);
-	if (!pmc)
+	mc = kzalloc(sizeof(*mc), GFP_ATOMIC);
+	if (!mc)
 		return;
 
 	spin_lock_bh(&im->mca_lock);
-	spin_lock_init(&pmc->mca_lock);
-	pmc->idev = im->idev;
+	spin_lock_init(&mc->mca_lock);
+	INIT_LIST_HEAD(&mc->list);
+	mc->idev = im->idev;
 	in6_dev_hold(idev);
-	pmc->mca_addr = im->mca_addr;
-	pmc->mca_crcount = idev->mc_qrv;
-	pmc->mca_sfmode = im->mca_sfmode;
-	if (pmc->mca_sfmode == MCAST_INCLUDE) {
+	mc->mca_addr = im->mca_addr;
+	mc->mca_crcount = idev->mc_qrv;
+	mc->mca_sfmode = im->mca_sfmode;
+	if (mc->mca_sfmode == MCAST_INCLUDE) {
 		struct ip6_sf_list *psf;
 
-		pmc->mca_tomb = im->mca_tomb;
-		pmc->mca_sources = im->mca_sources;
+		mc->mca_tomb = im->mca_tomb;
+		mc->mca_sources = im->mca_sources;
 		im->mca_tomb = im->mca_sources = NULL;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
-			psf->sf_crcount = pmc->mca_crcount;
+		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
+			psf->sf_crcount = mc->mca_crcount;
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	spin_lock_bh(&idev->mc_lock);
-	pmc->next = idev->mc_tomb;
-	idev->mc_tomb = pmc;
-	spin_unlock_bh(&idev->mc_lock);
+	spin_lock_bh(&idev->mc_tomb_lock);
+	list_add(&mc->list, &idev->mc_tomb_list);
+	spin_unlock_bh(&idev->mc_tomb_lock);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 {
-	struct ifmcaddr6 *pmc, *pmc_prev;
+	struct ifmcaddr6 *mc = NULL, *tmp = NULL;
+	struct in6_addr *mca = &im->mca_addr;
 	struct ip6_sf_list *psf;
-	struct in6_addr *pmca = &im->mca_addr;
+	bool found = false;
 
-	spin_lock_bh(&idev->mc_lock);
-	pmc_prev = NULL;
-	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
-		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
+	spin_lock_bh(&idev->mc_tomb_lock);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
+		if (ipv6_addr_equal(&mc->mca_addr, mca)) {
+			list_del(&mc->list);
+			found = true;
 			break;
-		pmc_prev = pmc;
-	}
-	if (pmc) {
-		if (pmc_prev)
-			pmc_prev->next = pmc->next;
-		else
-			idev->mc_tomb = pmc->next;
+		}
 	}
-	spin_unlock_bh(&idev->mc_lock);
+	spin_unlock_bh(&idev->mc_tomb_lock);
 
 	spin_lock_bh(&im->mca_lock);
-	if (pmc) {
-		im->idev = pmc->idev;
+	if (found) {
+		im->idev = mc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
-			swap(im->mca_tomb, pmc->mca_tomb);
-			swap(im->mca_sources, pmc->mca_sources);
+			swap(im->mca_tomb, mc->mca_tomb);
+			swap(im->mca_sources, mc->mca_sources);
 			for (psf = im->mca_sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = idev->mc_qrv;
 		} else {
 			im->mca_crcount = idev->mc_qrv;
 		}
-		in6_dev_put(pmc->idev);
-		ip6_mc_clear_src(pmc);
-		kfree(pmc);
+		in6_dev_put(mc->idev);
+		ip6_mc_clear_src(mc);
+		kfree(mc);
 	}
 	spin_unlock_bh(&im->mca_lock);
 }
 
 static void mld_clear_delrec(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *pmc, *nextpmc;
+	struct ifmcaddr6 *mc, *tmp;
 
-	spin_lock_bh(&idev->mc_lock);
-	pmc = idev->mc_tomb;
-	idev->mc_tomb = NULL;
-	spin_unlock_bh(&idev->mc_lock);
-
-	for (; pmc; pmc = nextpmc) {
-		nextpmc = pmc->next;
-		ip6_mc_clear_src(pmc);
-		in6_dev_put(pmc->idev);
-		kfree(pmc);
+	spin_lock_bh(&idev->mc_tomb_lock);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
+		list_del(&mc->list);
+		ip6_mc_clear_src(mc);
+		in6_dev_put(mc->idev);
+		kfree(mc);
 	}
+	spin_unlock_bh(&idev->mc_tomb_lock);
 
 	/* clear dead sources, too */
 	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
 		struct ip6_sf_list *psf, *psf_next;
 
-		spin_lock_bh(&pmc->mca_lock);
-		psf = pmc->mca_tomb;
-		pmc->mca_tomb = NULL;
-		spin_unlock_bh(&pmc->mca_lock);
+		spin_lock_bh(&mc->mca_lock);
+		psf = mc->mca_tomb;
+		mc->mca_tomb = NULL;
+		spin_unlock_bh(&mc->mca_lock);
 		for (; psf; psf = psf_next) {
 			psf_next = psf->sf_next;
 			kfree(psf);
@@ -831,19 +833,6 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 	read_unlock_bh(&idev->lock);
 }
 
-static void mca_get(struct ifmcaddr6 *mc)
-{
-	refcount_inc(&mc->mca_refcnt);
-}
-
-static void ma_put(struct ifmcaddr6 *mc)
-{
-	if (refcount_dec_and_test(&mc->mca_refcnt)) {
-		in6_dev_put(mc->idev);
-		kfree(mc);
-	}
-}
-
 static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 				   const struct in6_addr *addr,
 				   unsigned int mode)
@@ -858,6 +847,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 
 	mc->mca_addr = *addr;
 	mc->idev = idev; /* reference taken by caller */
+	INIT_LIST_HEAD(&mc->list);
 	mc->mca_users = 1;
 	/* mca_stamp should be updated upon changes */
 	mc->mca_cstamp = mc->mca_tstamp = jiffies;
@@ -880,14 +870,13 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 static int __ipv6_dev_mc_inc(struct net_device *dev,
 			     const struct in6_addr *addr, unsigned int mode)
 {
-	struct ifmcaddr6 *mc;
 	struct inet6_dev *idev;
+	struct ifmcaddr6 *mc;
 
 	ASSERT_RTNL();
 
 	/* we need to take a reference on idev */
 	idev = in6_dev_get(dev);
-
 	if (!idev)
 		return -EINVAL;
 
@@ -898,7 +887,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 		return -ENODEV;
 	}
 
-	for (mc = idev->mc_list; mc; mc = mc->next) {
+	list_for_each_entry(mc, &idev->mc_list, list) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			mc->mca_users++;
 			write_unlock_bh(&idev->lock);
@@ -915,8 +904,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 		return -ENOMEM;
 	}
 
-	mc->next = idev->mc_list;
-	idev->mc_list = mc;
+	list_add(&mc->list, &idev->mc_list);
 
 	/* Hold this for the code below before we unlock,
 	 * it is already exposed via idev->mc_list.
@@ -926,7 +914,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 
 	mld_del_delrec(idev, mc);
 	igmp6_group_added(mc);
-	ma_put(mc);
+	mca_put(mc);
 	return 0;
 }
 
@@ -941,29 +929,28 @@ EXPORT_SYMBOL(ipv6_dev_mc_inc);
  */
 int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
-	struct ifmcaddr6 *ma, **map;
+	struct ifmcaddr6 *mc, *tmp;
 
 	ASSERT_RTNL();
 
 	write_lock_bh(&idev->lock);
-	for (map = &idev->mc_list; (ma = *map) != NULL; map = &ma->next) {
-		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
-			if (--ma->mca_users == 0) {
-				*map = ma->next;
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
+		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
+			if (--mc->mca_users == 0) {
+				list_del(&mc->list);
 				write_unlock_bh(&idev->lock);
-
-				igmp6_group_dropped(ma);
-				ip6_mc_clear_src(ma);
-
-				ma_put(ma);
+				igmp6_group_dropped(mc);
+				ip6_mc_clear_src(mc);
+				mca_put(mc);
 				return 0;
 			}
+
 			write_unlock_bh(&idev->lock);
 			return 0;
 		}
 	}
-	write_unlock_bh(&idev->lock);
 
+	write_unlock_bh(&idev->lock);
 	return -ENOENT;
 }
 
@@ -990,19 +977,22 @@ EXPORT_SYMBOL(ipv6_dev_mc_dec);
 bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 			 const struct in6_addr *src_addr)
 {
+	bool rv = false, found = false;
 	struct inet6_dev *idev;
 	struct ifmcaddr6 *mc;
-	bool rv = false;
 
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
 		read_lock_bh(&idev->lock);
-		for (mc = idev->mc_list; mc; mc = mc->next) {
-			if (ipv6_addr_equal(&mc->mca_addr, group))
+		list_for_each_entry(mc, &idev->mc_list, list) {
+			if (ipv6_addr_equal(&mc->mca_addr, group)) {
+				found = true;
 				break;
+			}
 		}
-		if (mc) {
+
+		if (found) {
 			if (src_addr && !ipv6_addr_any(src_addr)) {
 				struct ip6_sf_list *psf;
 
@@ -1076,44 +1066,44 @@ static void mld_dad_stop_timer(struct inet6_dev *idev)
  *	IGMP handling (alias multicast ICMPv6 messages)
  */
 
-static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
+static void igmp6_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 {
 	unsigned long delay = resptime;
 
 	/* Do not start timer for these addresses */
-	if (ipv6_addr_is_ll_all_nodes(&ma->mca_addr) ||
-	    IPV6_ADDR_MC_SCOPE(&ma->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
+	if (ipv6_addr_is_ll_all_nodes(&mc->mca_addr) ||
+	    IPV6_ADDR_MC_SCOPE(&mc->mca_addr) < IPV6_ADDR_SCOPE_LINKLOCAL)
 		return;
 
-	if (del_timer(&ma->mca_timer)) {
-		refcount_dec(&ma->mca_refcnt);
-		delay = ma->mca_timer.expires - jiffies;
+	if (del_timer(&mc->mca_timer)) {
+		refcount_dec(&mc->mca_refcnt);
+		delay = mc->mca_timer.expires - jiffies;
 	}
 
 	if (delay >= resptime)
 		delay = prandom_u32() % resptime;
 
-	ma->mca_timer.expires = jiffies + delay;
-	if (!mod_timer(&ma->mca_timer, jiffies + delay))
-		refcount_inc(&ma->mca_refcnt);
-	ma->mca_flags |= MAF_TIMER_RUNNING;
+	mc->mca_timer.expires = jiffies + delay;
+	if (!mod_timer(&mc->mca_timer, jiffies + delay))
+		refcount_inc(&mc->mca_refcnt);
+	mc->mca_flags |= MAF_TIMER_RUNNING;
 }
 
 /* mark EXCLUDE-mode sources */
-static bool mld_xmarksources(struct ifmcaddr6 *pmc, int nsrcs,
+static bool mld_xmarksources(struct ifmcaddr6 *mc, int nsrcs,
 			     const struct in6_addr *srcs)
 {
 	struct ip6_sf_list *psf;
 	int i, scount;
 
 	scount = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
 			/* skip inactive filters */
 			if (psf->sf_count[MCAST_INCLUDE] ||
-			    pmc->mca_sfcount[MCAST_EXCLUDE] !=
+			    mc->mca_sfcount[MCAST_EXCLUDE] !=
 			    psf->sf_count[MCAST_EXCLUDE])
 				break;
 			if (ipv6_addr_equal(&srcs[i], &psf->sf_addr)) {
@@ -1122,25 +1112,25 @@ static bool mld_xmarksources(struct ifmcaddr6 *pmc, int nsrcs,
 			}
 		}
 	}
-	pmc->mca_flags &= ~MAF_GSQUERY;
+	mc->mca_flags &= ~MAF_GSQUERY;
 	if (scount == nsrcs)	/* all sources excluded */
 		return false;
 	return true;
 }
 
-static bool mld_marksources(struct ifmcaddr6 *pmc, int nsrcs,
+static bool mld_marksources(struct ifmcaddr6 *mc, int nsrcs,
 			    const struct in6_addr *srcs)
 {
 	struct ip6_sf_list *psf;
 	int i, scount;
 
-	if (pmc->mca_sfmode == MCAST_EXCLUDE)
-		return mld_xmarksources(pmc, nsrcs, srcs);
+	if (mc->mca_sfmode == MCAST_EXCLUDE)
+		return mld_xmarksources(mc, nsrcs, srcs);
 
 	/* mark INCLUDE-mode sources */
 
 	scount = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1152,10 +1142,10 @@ static bool mld_marksources(struct ifmcaddr6 *pmc, int nsrcs,
 		}
 	}
 	if (!scount) {
-		pmc->mca_flags &= ~MAF_GSQUERY;
+		mc->mca_flags &= ~MAF_GSQUERY;
 		return false;
 	}
-	pmc->mca_flags |= MAF_GSQUERY;
+	mc->mca_flags |= MAF_GSQUERY;
 	return true;
 }
 
@@ -1333,10 +1323,10 @@ static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 int igmp6_event_query(struct sk_buff *skb)
 {
 	struct mld2_query *mlh2 = NULL;
-	struct ifmcaddr6 *ma;
 	const struct in6_addr *group;
 	unsigned long max_delay;
 	struct inet6_dev *idev;
+	struct ifmcaddr6 *mc;
 	struct mld_msg *mld;
 	int group_type;
 	int mark = 0;
@@ -1416,31 +1406,31 @@ int igmp6_event_query(struct sk_buff *skb)
 
 	read_lock_bh(&idev->lock);
 	if (group_type == IPV6_ADDR_ANY) {
-		for (ma = idev->mc_list; ma; ma = ma->next) {
-			spin_lock_bh(&ma->mca_lock);
-			igmp6_group_queried(ma, max_delay);
-			spin_unlock_bh(&ma->mca_lock);
+		list_for_each_entry(mc, &idev->mc_list, list) {
+			spin_lock_bh(&mc->mca_lock);
+			igmp6_group_queried(mc, max_delay);
+			spin_unlock_bh(&mc->mca_lock);
 		}
 	} else {
-		for (ma = idev->mc_list; ma; ma = ma->next) {
-			if (!ipv6_addr_equal(group, &ma->mca_addr))
+		list_for_each_entry(mc, &idev->mc_list, list) {
+			if (!ipv6_addr_equal(group, &mc->mca_addr))
 				continue;
-			spin_lock_bh(&ma->mca_lock);
-			if (ma->mca_flags & MAF_TIMER_RUNNING) {
+			spin_lock_bh(&mc->mca_lock);
+			if (mc->mca_flags & MAF_TIMER_RUNNING) {
 				/* gsquery <- gsquery && mark */
 				if (!mark)
-					ma->mca_flags &= ~MAF_GSQUERY;
+					mc->mca_flags &= ~MAF_GSQUERY;
 			} else {
 				/* gsquery <- mark */
 				if (mark)
-					ma->mca_flags |= MAF_GSQUERY;
+					mc->mca_flags |= MAF_GSQUERY;
 				else
-					ma->mca_flags &= ~MAF_GSQUERY;
+					mc->mca_flags &= ~MAF_GSQUERY;
 			}
-			if (!(ma->mca_flags & MAF_GSQUERY) ||
-			    mld_marksources(ma, ntohs(mlh2->mld2q_nsrcs), mlh2->mld2q_srcs))
-				igmp6_group_queried(ma, max_delay);
-			spin_unlock_bh(&ma->mca_lock);
+			if (!(mc->mca_flags & MAF_GSQUERY) ||
+			    mld_marksources(mc, ntohs(mlh2->mld2q_nsrcs), mlh2->mld2q_srcs))
+				igmp6_group_queried(mc, max_delay);
+			spin_unlock_bh(&mc->mca_lock);
 			break;
 		}
 	}
@@ -1452,8 +1442,8 @@ int igmp6_event_query(struct sk_buff *skb)
 /* called with rcu_read_lock() */
 int igmp6_event_report(struct sk_buff *skb)
 {
-	struct ifmcaddr6 *ma;
 	struct inet6_dev *idev;
+	struct ifmcaddr6 *mc;
 	struct mld_msg *mld;
 	int addr_type;
 
@@ -1486,13 +1476,13 @@ int igmp6_event_report(struct sk_buff *skb)
 	 */
 
 	read_lock_bh(&idev->lock);
-	for (ma = idev->mc_list; ma; ma = ma->next) {
-		if (ipv6_addr_equal(&ma->mca_addr, &mld->mld_mca)) {
-			spin_lock(&ma->mca_lock);
-			if (del_timer(&ma->mca_timer))
-				refcount_dec(&ma->mca_refcnt);
-			ma->mca_flags &= ~(MAF_LAST_REPORTER|MAF_TIMER_RUNNING);
-			spin_unlock(&ma->mca_lock);
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		if (ipv6_addr_equal(&mc->mca_addr, &mld->mld_mca)) {
+			spin_lock(&mc->mca_lock);
+			if (del_timer(&mc->mca_timer))
+				refcount_dec(&mc->mca_refcnt);
+			mc->mca_flags &= ~(MAF_LAST_REPORTER | MAF_TIMER_RUNNING);
+			spin_unlock(&mc->mca_lock);
 			break;
 		}
 	}
@@ -1500,7 +1490,7 @@ int igmp6_event_report(struct sk_buff *skb)
 	return 0;
 }
 
-static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
+static bool is_in(struct ifmcaddr6 *mc, struct ip6_sf_list *psf, int type,
 		  int gdeleted, int sdeleted)
 {
 	switch (type) {
@@ -1508,15 +1498,15 @@ static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
 	case MLD2_MODE_IS_EXCLUDE:
 		if (gdeleted || sdeleted)
 			return false;
-		if (!((pmc->mca_flags & MAF_GSQUERY) && !psf->sf_gsresp)) {
-			if (pmc->mca_sfmode == MCAST_INCLUDE)
+		if (!((mc->mca_flags & MAF_GSQUERY) && !psf->sf_gsresp)) {
+			if (mc->mca_sfmode == MCAST_INCLUDE)
 				return true;
 			/* don't include if this source is excluded
 			 * in all filters
 			 */
 			if (psf->sf_count[MCAST_INCLUDE])
 				return type == MLD2_MODE_IS_INCLUDE;
-			return pmc->mca_sfcount[MCAST_EXCLUDE] ==
+			return mc->mca_sfcount[MCAST_EXCLUDE] ==
 				psf->sf_count[MCAST_EXCLUDE];
 		}
 		return false;
@@ -1527,31 +1517,31 @@ static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
 	case MLD2_CHANGE_TO_EXCLUDE:
 		if (gdeleted || sdeleted)
 			return false;
-		if (pmc->mca_sfcount[MCAST_EXCLUDE] == 0 ||
+		if (mc->mca_sfcount[MCAST_EXCLUDE] == 0 ||
 		    psf->sf_count[MCAST_INCLUDE])
 			return false;
-		return pmc->mca_sfcount[MCAST_EXCLUDE] ==
+		return mc->mca_sfcount[MCAST_EXCLUDE] ==
 			psf->sf_count[MCAST_EXCLUDE];
 	case MLD2_ALLOW_NEW_SOURCES:
 		if (gdeleted || !psf->sf_crcount)
 			return false;
-		return (pmc->mca_sfmode == MCAST_INCLUDE) ^ sdeleted;
+		return (mc->mca_sfmode == MCAST_INCLUDE) ^ sdeleted;
 	case MLD2_BLOCK_OLD_SOURCES:
-		if (pmc->mca_sfmode == MCAST_INCLUDE)
+		if (mc->mca_sfmode == MCAST_INCLUDE)
 			return gdeleted || (psf->sf_crcount && sdeleted);
 		return psf->sf_crcount && !gdeleted && !sdeleted;
 	}
 	return false;
 }
 
-static int
-mld_scount(struct ifmcaddr6 *pmc, int type, int gdeleted, int sdeleted)
+static int mld_scount(struct ifmcaddr6 *mc, int type, int gdeleted,
+		      int sdeleted)
 {
 	struct ip6_sf_list *psf;
 	int scount = 0;
 
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
-		if (!is_in(pmc, psf, type, gdeleted, sdeleted))
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+		if (!is_in(mc, psf, type, gdeleted, sdeleted))
 			continue;
 		scount++;
 	}
@@ -1585,21 +1575,23 @@ static void ip6_mc_hdr(struct sock *sk, struct sk_buff *skb,
 
 static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 {
+	u8 ra[8] = { IPPROTO_ICMPV6, 0,
+		     IPV6_TLV_ROUTERALERT, 2,
+		     0, 0, IPV6_TLV_PADN, 0 };
 	struct net_device *dev = idev->dev;
-	struct net *net = dev_net(dev);
-	struct sock *sk = net->ipv6.igmp_sk;
-	struct sk_buff *skb;
-	struct mld2_report *pmr;
-	struct in6_addr addr_buf;
-	const struct in6_addr *saddr;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	unsigned int size = mtu + hlen + tlen;
+	struct net *net = dev_net(dev);
+	const struct in6_addr *saddr;
+	struct in6_addr addr_buf;
+	struct mld2_report *pmr;
+	struct sk_buff *skb;
+	unsigned int size;
+	struct sock *sk;
 	int err;
-	u8 ra[8] = { IPPROTO_ICMPV6, 0,
-		     IPV6_TLV_ROUTERALERT, 2, 0, 0,
-		     IPV6_TLV_PADN, 0 };
 
+	size = mtu + hlen + tlen;
+	sk = net->ipv6.igmp_sk;
 	/* we assume size > sizeof(ra) here */
 	/* limit our allocations to order-0 page */
 	size = min_t(int, size, SKB_MAX_ORDER(0, 0));
@@ -1639,21 +1631,22 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 static void mld_sendpack(struct sk_buff *skb)
 {
 	struct ipv6hdr *pip6 = ipv6_hdr(skb);
-	struct mld2_report *pmr =
-			      (struct mld2_report *)skb_transport_header(skb);
+	struct net *net = dev_net(skb->dev);
 	int payload_len, mldlen;
+	struct mld2_report *pmr;
 	struct inet6_dev *idev;
-	struct net *net = dev_net(skb->dev);
-	int err;
-	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct flowi6 fl6;
+	int err;
+
+	pmr = (struct mld2_report *)skb_transport_header(skb);
 
 	rcu_read_lock();
 	idev = __in6_dev_get(skb->dev);
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
 	payload_len = (skb_tail_pointer(skb) - skb_network_header(skb)) -
-		sizeof(*pip6);
+		      sizeof(*pip6);
 	mldlen = skb_tail_pointer(skb) - skb_transport_header(skb);
 	pip6->payload_len = htons(payload_len);
 
@@ -1695,19 +1688,20 @@ static void mld_sendpack(struct sk_buff *skb)
 	goto out;
 }
 
-static int grec_size(struct ifmcaddr6 *pmc, int type, int gdel, int sdel)
+static int grec_size(struct ifmcaddr6 *mc, int type, int gdel, int sdel)
 {
-	return sizeof(struct mld2_grec) + 16 * mld_scount(pmc,type,gdel,sdel);
+	return sizeof(struct mld2_grec) + 16 * mld_scount(mc, type, gdel, sdel);
 }
 
-static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
-	int type, struct mld2_grec **ppgr, unsigned int mtu)
+static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *mc,
+				  int type, struct mld2_grec **ppgr,
+				  unsigned int mtu)
 {
 	struct mld2_report *pmr;
 	struct mld2_grec *pgr;
 
 	if (!skb) {
-		skb = mld_newpack(pmc->idev, mtu);
+		skb = mld_newpack(mc->idev, mtu);
 		if (!skb)
 			return NULL;
 	}
@@ -1715,7 +1709,7 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	pgr->grec_type = type;
 	pgr->grec_auxwords = 0;
 	pgr->grec_nsrcs = 0;
-	pgr->grec_mca = pmc->mca_addr;	/* structure copy */
+	pgr->grec_mca = mc->mca_addr;	/* structure copy */
 	pmr = (struct mld2_report *)skb_transport_header(skb);
 	pmr->mld2r_ngrec = htons(ntohs(pmr->mld2r_ngrec)+1);
 	*ppgr = pgr;
@@ -1724,18 +1718,20 @@ static struct sk_buff *add_grhead(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 #define AVAILABLE(skb)	((skb) ? skb_availroom(skb) : 0)
 
-static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
-	int type, int gdeleted, int sdeleted, int crsend)
+static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
+				int type, int gdeleted, int sdeleted,
+				int crsend)
 {
-	struct inet6_dev *idev = pmc->idev;
-	struct net_device *dev = idev->dev;
-	struct mld2_report *pmr;
-	struct mld2_grec *pgr = NULL;
 	struct ip6_sf_list *psf, *psf_next, *psf_prev, **psf_list;
 	int scount, stotal, first, isquery, truncate;
+	struct inet6_dev *idev = mc->idev;
+	struct mld2_grec *pgr = NULL;
+	struct mld2_report *pmr;
+	struct net_device *dev;
 	unsigned int mtu;
 
-	if (pmc->mca_flags & MAF_NOREPORT)
+	dev = idev->dev;
+	if (mc->mca_flags & MAF_NOREPORT)
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -1749,7 +1745,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 	stotal = scount = 0;
 
-	psf_list = sdeleted ? &pmc->mca_tomb : &pmc->mca_sources;
+	psf_list = sdeleted ? &mc->mca_tomb : &mc->mca_sources;
 
 	if (!*psf_list)
 		goto empty_source;
@@ -1759,7 +1755,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	/* EX and TO_EX get a fresh packet, if needed */
 	if (truncate) {
 		if (pmr && pmr->mld2r_ngrec &&
-		    AVAILABLE(skb) < grec_size(pmc, type, gdeleted, sdeleted)) {
+		    AVAILABLE(skb) < grec_size(mc, type, gdeleted, sdeleted)) {
 			if (skb)
 				mld_sendpack(skb);
 			skb = mld_newpack(idev, mtu);
@@ -1772,7 +1768,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 		psf_next = psf->sf_next;
 
-		if (!is_in(pmc, psf, type, gdeleted, sdeleted) && !crsend) {
+		if (!is_in(mc, psf, type, gdeleted, sdeleted) && !crsend) {
 			psf_prev = psf;
 			continue;
 		}
@@ -1780,8 +1776,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 		/* Based on RFC3810 6.1. Should not send source-list change
 		 * records when there is a filter mode change.
 		 */
-		if (((gdeleted && pmc->mca_sfmode == MCAST_EXCLUDE) ||
-		     (!gdeleted && pmc->mca_crcount)) &&
+		if (((gdeleted && mc->mca_sfmode == MCAST_EXCLUDE) ||
+		     (!gdeleted && mc->mca_crcount)) &&
 		    (type == MLD2_ALLOW_NEW_SOURCES ||
 		     type == MLD2_BLOCK_OLD_SOURCES) && psf->sf_crcount)
 			goto decrease_sf_crcount;
@@ -1803,7 +1799,7 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 			scount = 0;
 		}
 		if (first) {
-			skb = add_grhead(skb, pmc, type, &pgr, mtu);
+			skb = add_grhead(skb, mc, type, &pgr, mtu);
 			first = 0;
 		}
 		if (!skb)
@@ -1832,49 +1828,49 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 		if (type == MLD2_ALLOW_NEW_SOURCES ||
 		    type == MLD2_BLOCK_OLD_SOURCES)
 			return skb;
-		if (pmc->mca_crcount || isquery || crsend) {
+		if (mc->mca_crcount || isquery || crsend) {
 			/* make sure we have room for group header */
 			if (skb && AVAILABLE(skb) < sizeof(struct mld2_grec)) {
 				mld_sendpack(skb);
 				skb = NULL; /* add_grhead will get a new one */
 			}
-			skb = add_grhead(skb, pmc, type, &pgr, mtu);
+			skb = add_grhead(skb, mc, type, &pgr, mtu);
 		}
 	}
 	if (pgr)
 		pgr->grec_nsrcs = htons(scount);
 
 	if (isquery)
-		pmc->mca_flags &= ~MAF_GSQUERY;	/* clear query state */
+		mc->mca_flags &= ~MAF_GSQUERY;	/* clear query state */
 	return skb;
 }
 
-static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
+static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *mc)
 {
 	struct sk_buff *skb = NULL;
 	int type;
 
 	read_lock_bh(&idev->lock);
-	if (!pmc) {
-		for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-			if (pmc->mca_flags & MAF_NOREPORT)
+	if (!mc) {
+		list_for_each_entry(mc, &idev->mc_list, list) {
+			if (mc->mca_flags & MAF_NOREPORT)
 				continue;
-			spin_lock_bh(&pmc->mca_lock);
-			if (pmc->mca_sfcount[MCAST_EXCLUDE])
+			spin_lock_bh(&mc->mca_lock);
+			if (mc->mca_sfcount[MCAST_EXCLUDE])
 				type = MLD2_MODE_IS_EXCLUDE;
 			else
 				type = MLD2_MODE_IS_INCLUDE;
-			skb = add_grec(skb, pmc, type, 0, 0, 0);
-			spin_unlock_bh(&pmc->mca_lock);
+			skb = add_grec(skb, mc, type, 0, 0, 0);
+			spin_unlock_bh(&mc->mca_lock);
 		}
 	} else {
-		spin_lock_bh(&pmc->mca_lock);
-		if (pmc->mca_sfcount[MCAST_EXCLUDE])
+		spin_lock_bh(&mc->mca_lock);
+		if (mc->mca_sfcount[MCAST_EXCLUDE])
 			type = MLD2_MODE_IS_EXCLUDE;
 		else
 			type = MLD2_MODE_IS_INCLUDE;
-		skb = add_grec(skb, pmc, type, 0, 0, 0);
-		spin_unlock_bh(&pmc->mca_lock);
+		skb = add_grec(skb, mc, type, 0, 0, 0);
+		spin_unlock_bh(&mc->mca_lock);
 	}
 	read_unlock_bh(&idev->lock);
 	if (skb)
@@ -1904,94 +1900,90 @@ static void mld_clear_zeros(struct ip6_sf_list **ppsf)
 
 static void mld_send_cr(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *pmc, *pmc_prev, *pmc_next;
 	struct sk_buff *skb = NULL;
+	struct ifmcaddr6 *mc, *tmp;
 	int type, dtype;
 
 	read_lock_bh(&idev->lock);
-	spin_lock(&idev->mc_lock);
+	spin_lock(&idev->mc_tomb_lock);
 
 	/* deleted MCA's */
-	pmc_prev = NULL;
-	for (pmc = idev->mc_tomb; pmc; pmc = pmc_next) {
-		pmc_next = pmc->next;
-		if (pmc->mca_sfmode == MCAST_INCLUDE) {
+	list_for_each_entry_safe(mc, tmp, &idev->mc_tomb_list, list) {
+		if (mc->mca_sfmode == MCAST_INCLUDE) {
 			type = MLD2_BLOCK_OLD_SOURCES;
 			dtype = MLD2_BLOCK_OLD_SOURCES;
-			skb = add_grec(skb, pmc, type, 1, 0, 0);
-			skb = add_grec(skb, pmc, dtype, 1, 1, 0);
+			skb = add_grec(skb, mc, type, 1, 0, 0);
+			skb = add_grec(skb, mc, dtype, 1, 1, 0);
 		}
-		if (pmc->mca_crcount) {
-			if (pmc->mca_sfmode == MCAST_EXCLUDE) {
+		if (mc->mca_crcount) {
+			if (mc->mca_sfmode == MCAST_EXCLUDE) {
 				type = MLD2_CHANGE_TO_INCLUDE;
-				skb = add_grec(skb, pmc, type, 1, 0, 0);
+				skb = add_grec(skb, mc, type, 1, 0, 0);
 			}
-			pmc->mca_crcount--;
-			if (pmc->mca_crcount == 0) {
-				mld_clear_zeros(&pmc->mca_tomb);
-				mld_clear_zeros(&pmc->mca_sources);
+			mc->mca_crcount--;
+			if (mc->mca_crcount == 0) {
+				mld_clear_zeros(&mc->mca_tomb);
+				mld_clear_zeros(&mc->mca_sources);
 			}
 		}
-		if (pmc->mca_crcount == 0 && !pmc->mca_tomb &&
-		    !pmc->mca_sources) {
-			if (pmc_prev)
-				pmc_prev->next = pmc_next;
-			else
-				idev->mc_tomb = pmc_next;
-			in6_dev_put(pmc->idev);
-			kfree(pmc);
-		} else
-			pmc_prev = pmc;
+		if (mc->mca_crcount == 0 && !mc->mca_tomb &&
+		    !mc->mca_sources) {
+			list_del(&mc->list);
+			in6_dev_put(mc->idev);
+			kfree(mc);
+		}
 	}
-	spin_unlock(&idev->mc_lock);
+	spin_unlock(&idev->mc_tomb_lock);
 
 	/* change recs */
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		spin_lock_bh(&pmc->mca_lock);
-		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		spin_lock_bh(&mc->mca_lock);
+		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
 			type = MLD2_BLOCK_OLD_SOURCES;
 			dtype = MLD2_ALLOW_NEW_SOURCES;
 		} else {
 			type = MLD2_ALLOW_NEW_SOURCES;
 			dtype = MLD2_BLOCK_OLD_SOURCES;
 		}
-		skb = add_grec(skb, pmc, type, 0, 0, 0);
-		skb = add_grec(skb, pmc, dtype, 0, 1, 0);	/* deleted sources */
+		skb = add_grec(skb, mc, type, 0, 0, 0);
+		skb = add_grec(skb, mc, dtype, 0, 1, 0);	/* deleted sources */
 
 		/* filter mode changes */
-		if (pmc->mca_crcount) {
-			if (pmc->mca_sfmode == MCAST_EXCLUDE)
+		if (mc->mca_crcount) {
+			if (mc->mca_sfmode == MCAST_EXCLUDE)
 				type = MLD2_CHANGE_TO_EXCLUDE;
 			else
 				type = MLD2_CHANGE_TO_INCLUDE;
-			skb = add_grec(skb, pmc, type, 0, 0, 0);
-			pmc->mca_crcount--;
+			skb = add_grec(skb, mc, type, 0, 0, 0);
+			mc->mca_crcount--;
 		}
-		spin_unlock_bh(&pmc->mca_lock);
+		spin_unlock_bh(&mc->mca_lock);
 	}
 	read_unlock_bh(&idev->lock);
 	if (!skb)
 		return;
-	(void) mld_sendpack(skb);
+	mld_sendpack(skb);
 }
 
 static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 {
+	u8 ra[8] = { IPPROTO_ICMPV6, 0,
+		     IPV6_TLV_ROUTERALERT,
+		     2, 0, 0, IPV6_TLV_PADN, 0 };
+	const struct in6_addr *snd_addr, *saddr;
+	int err, len, payload_len, full_len;
+	int hlen = LL_RESERVED_SPACE(dev);
+	int tlen = dev->needed_tailroom;
 	struct net *net = dev_net(dev);
-	struct sock *sk = net->ipv6.igmp_sk;
+	struct in6_addr addr_buf;
 	struct inet6_dev *idev;
+	struct dst_entry *dst;
 	struct sk_buff *skb;
 	struct mld_msg *hdr;
-	const struct in6_addr *snd_addr, *saddr;
-	struct in6_addr addr_buf;
-	int hlen = LL_RESERVED_SPACE(dev);
-	int tlen = dev->needed_tailroom;
-	int err, len, payload_len, full_len;
-	u8 ra[8] = { IPPROTO_ICMPV6, 0,
-		     IPV6_TLV_ROUTERALERT, 2, 0, 0,
-		     IPV6_TLV_PADN, 0 };
 	struct flowi6 fl6;
-	struct dst_entry *dst;
+	struct sock *sk;
+
+	sk = net->ipv6.igmp_sk;
 
 	if (type == ICMPV6_MGM_REDUCTION)
 		snd_addr = &in6addr_linklocal_allrouters;
@@ -2074,7 +2066,7 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 static void mld_send_initial_cr(struct inet6_dev *idev)
 {
 	struct sk_buff *skb;
-	struct ifmcaddr6 *pmc;
+	struct ifmcaddr6 *mc;
 	int type;
 
 	if (mld_in_v1_mode(idev))
@@ -2082,14 +2074,14 @@ static void mld_send_initial_cr(struct inet6_dev *idev)
 
 	skb = NULL;
 	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		spin_lock_bh(&pmc->mca_lock);
-		if (pmc->mca_sfcount[MCAST_EXCLUDE])
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		spin_lock_bh(&mc->mca_lock);
+		if (mc->mca_sfcount[MCAST_EXCLUDE])
 			type = MLD2_CHANGE_TO_EXCLUDE;
 		else
 			type = MLD2_ALLOW_NEW_SOURCES;
-		skb = add_grec(skb, pmc, type, 0, 0, 1);
-		spin_unlock_bh(&pmc->mca_lock);
+		skb = add_grec(skb, mc, type, 0, 0, 1);
+		spin_unlock_bh(&mc->mca_lock);
 	}
 	read_unlock_bh(&idev->lock);
 	if (skb)
@@ -2122,14 +2114,14 @@ static void mld_dad_timer_expire(struct timer_list *t)
 	in6_dev_put(idev);
 }
 
-static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
-	const struct in6_addr *psfsrc)
+static int ip6_mc_del1_src(struct ifmcaddr6 *mc, int sfmode,
+			   const struct in6_addr *psfsrc)
 {
 	struct ip6_sf_list *psf, *psf_prev;
 	int rv = 0;
 
 	psf_prev = NULL;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
 			break;
 		psf_prev = psf;
@@ -2140,78 +2132,83 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 	}
 	psf->sf_count[sfmode]--;
 	if (!psf->sf_count[MCAST_INCLUDE] && !psf->sf_count[MCAST_EXCLUDE]) {
-		struct inet6_dev *idev = pmc->idev;
+		struct inet6_dev *idev = mc->idev;
 
 		/* no more filters for this source */
 		if (psf_prev)
 			psf_prev->sf_next = psf->sf_next;
 		else
-			pmc->mca_sources = psf->sf_next;
-		if (psf->sf_oldin && !(pmc->mca_flags & MAF_NOREPORT) &&
+			mc->mca_sources = psf->sf_next;
+		if (psf->sf_oldin && !(mc->mca_flags & MAF_NOREPORT) &&
 		    !mld_in_v1_mode(idev)) {
 			psf->sf_crcount = idev->mc_qrv;
-			psf->sf_next = pmc->mca_tomb;
-			pmc->mca_tomb = psf;
+			psf->sf_next = mc->mca_tomb;
+			mc->mca_tomb = psf;
 			rv = 1;
-		} else
+		} else {
 			kfree(psf);
+		}
 	}
 	return rv;
 }
 
-static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
+static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta)
 {
-	struct ifmcaddr6 *pmc;
-	int	changerec = 0;
-	int	i, err;
+	struct ifmcaddr6 *mc;
+	bool found = false;
+	int changerec = 0;
+	int i, err;
 
 	if (!idev)
 		return -ENODEV;
 	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
+			found = true;
 			break;
+		}
 	}
-	if (!pmc) {
+	if (!found) {
 		/* MCA not found?? bug */
 		read_unlock_bh(&idev->lock);
 		return -ESRCH;
 	}
-	spin_lock_bh(&pmc->mca_lock);
-	sf_markstate(pmc);
+	spin_lock_bh(&mc->mca_lock);
+	sf_markstate(mc);
 	if (!delta) {
-		if (!pmc->mca_sfcount[sfmode]) {
-			spin_unlock_bh(&pmc->mca_lock);
+		if (!mc->mca_sfcount[sfmode]) {
+			spin_unlock_bh(&mc->mca_lock);
 			read_unlock_bh(&idev->lock);
 			return -EINVAL;
 		}
-		pmc->mca_sfcount[sfmode]--;
+		mc->mca_sfcount[sfmode]--;
 	}
 	err = 0;
 	for (i = 0; i < sfcount; i++) {
-		int rv = ip6_mc_del1_src(pmc, sfmode, &psfsrc[i]);
+		int rv = ip6_mc_del1_src(mc, sfmode, &psfsrc[i]);
 
 		changerec |= rv > 0;
 		if (!err && rv < 0)
 			err = rv;
 	}
-	if (pmc->mca_sfmode == MCAST_EXCLUDE &&
-	    pmc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
-	    pmc->mca_sfcount[MCAST_INCLUDE]) {
+	if (mc->mca_sfmode == MCAST_EXCLUDE &&
+	    mc->mca_sfcount[MCAST_EXCLUDE] == 0 &&
+	    mc->mca_sfcount[MCAST_INCLUDE]) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
-		pmc->mca_sfmode = MCAST_INCLUDE;
-		pmc->mca_crcount = idev->mc_qrv;
-		idev->mc_ifc_count = pmc->mca_crcount;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+		mc->mca_sfmode = MCAST_INCLUDE;
+		mc->mca_crcount = idev->mc_qrv;
+		idev->mc_ifc_count = mc->mca_crcount;
+		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
-		mld_ifc_event(pmc->idev);
-	} else if (sf_setstate(pmc) || changerec)
-		mld_ifc_event(pmc->idev);
-	spin_unlock_bh(&pmc->mca_lock);
+		mld_ifc_event(mc->idev);
+	} else if (sf_setstate(mc) || changerec) {
+		mld_ifc_event(mc->idev);
+	}
+	spin_unlock_bh(&mc->mca_lock);
 	read_unlock_bh(&idev->lock);
 	return err;
 }
@@ -2219,13 +2216,13 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 /*
  * Add multicast single-source filter to the interface list
  */
-static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
-	const struct in6_addr *psfsrc)
+static int ip6_mc_add1_src(struct ifmcaddr6 *mc, int sfmode,
+			   const struct in6_addr *psfsrc)
 {
 	struct ip6_sf_list *psf, *psf_prev;
 
 	psf_prev = NULL;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
 		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
 			break;
 		psf_prev = psf;
@@ -2239,36 +2236,37 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
 		if (psf_prev) {
 			psf_prev->sf_next = psf;
 		} else
-			pmc->mca_sources = psf;
+			mc->mca_sources = psf;
 	}
 	psf->sf_count[sfmode]++;
 	return 0;
 }
 
-static void sf_markstate(struct ifmcaddr6 *pmc)
+static void sf_markstate(struct ifmcaddr6 *mc)
 {
+	int mca_xcount = mc->mca_sfcount[MCAST_EXCLUDE];
 	struct ip6_sf_list *psf;
-	int mca_xcount = pmc->mca_sfcount[MCAST_EXCLUDE];
 
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
-		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
 			psf->sf_oldin = mca_xcount ==
 				psf->sf_count[MCAST_EXCLUDE] &&
 				!psf->sf_count[MCAST_INCLUDE];
 		} else
 			psf->sf_oldin = psf->sf_count[MCAST_INCLUDE] != 0;
+	}
 }
 
-static int sf_setstate(struct ifmcaddr6 *pmc)
+static int sf_setstate(struct ifmcaddr6 *mc)
 {
+	int mca_xcount = mc->mca_sfcount[MCAST_EXCLUDE];
 	struct ip6_sf_list *psf, *dpsf;
-	int mca_xcount = pmc->mca_sfcount[MCAST_EXCLUDE];
-	int qrv = pmc->idev->mc_qrv;
+	int qrv = mc->idev->mc_qrv;
 	int new_in, rv;
 
 	rv = 0;
-	for (psf = pmc->mca_sources; psf; psf = psf->sf_next) {
-		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
+	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
 			new_in = mca_xcount == psf->sf_count[MCAST_EXCLUDE] &&
 				!psf->sf_count[MCAST_INCLUDE];
 		} else
@@ -2277,7 +2275,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 			if (!psf->sf_oldin) {
 				struct ip6_sf_list *prev = NULL;
 
-				for (dpsf = pmc->mca_tomb; dpsf;
+				for (dpsf = mc->mca_tomb; dpsf;
 				     dpsf = dpsf->sf_next) {
 					if (ipv6_addr_equal(&dpsf->sf_addr,
 					    &psf->sf_addr))
@@ -2288,7 +2286,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 					if (prev)
 						prev->sf_next = dpsf->sf_next;
 					else
-						pmc->mca_tomb = dpsf->sf_next;
+						mc->mca_tomb = dpsf->sf_next;
 					kfree(dpsf);
 				}
 				psf->sf_crcount = qrv;
@@ -2300,7 +2298,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 			 * add or update "delete" records if an active filter
 			 * is now inactive
 			 */
-			for (dpsf = pmc->mca_tomb; dpsf; dpsf = dpsf->sf_next)
+			for (dpsf = mc->mca_tomb; dpsf; dpsf = dpsf->sf_next)
 				if (ipv6_addr_equal(&dpsf->sf_addr,
 				    &psf->sf_addr))
 					break;
@@ -2309,9 +2307,9 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 				if (!dpsf)
 					continue;
 				*dpsf = *psf;
-				/* pmc->mca_lock held by callers */
-				dpsf->sf_next = pmc->mca_tomb;
-				pmc->mca_tomb = dpsf;
+				/* mc->mca_lock held by callers */
+				dpsf->sf_next = mc->mca_tomb;
+				mc->mca_tomb = dpsf;
 			}
 			dpsf->sf_crcount = qrv;
 			rv++;
@@ -2323,35 +2321,39 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 /*
  * Add multicast source filter list to the interface list
  */
-static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
+static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 			  int sfmode, int sfcount, const struct in6_addr *psfsrc,
 			  int delta)
 {
-	struct ifmcaddr6 *pmc;
-	int	isexclude;
-	int	i, err;
+	struct ifmcaddr6 *mc;
+	bool found = false;
+	int isexclude;
+	int i, err;
 
 	if (!idev)
 		return -ENODEV;
+
 	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
+	list_for_each_entry(mc, &idev->mc_list, list) {
+		if (ipv6_addr_equal(mca, &mc->mca_addr)) {
+			found = true;
 			break;
+		}
 	}
-	if (!pmc) {
+	if (!found) {
 		/* MCA not found?? bug */
 		read_unlock_bh(&idev->lock);
 		return -ESRCH;
 	}
-	spin_lock_bh(&pmc->mca_lock);
+	spin_lock_bh(&mc->mca_lock);
 
-	sf_markstate(pmc);
-	isexclude = pmc->mca_sfmode == MCAST_EXCLUDE;
+	sf_markstate(mc);
+	isexclude = mc->mca_sfmode == MCAST_EXCLUDE;
 	if (!delta)
-		pmc->mca_sfcount[sfmode]++;
+		mc->mca_sfcount[sfmode]++;
 	err = 0;
 	for (i = 0; i < sfcount; i++) {
-		err = ip6_mc_add1_src(pmc, sfmode, &psfsrc[i]);
+		err = ip6_mc_add1_src(mc, sfmode, &psfsrc[i]);
 		if (err)
 			break;
 	}
@@ -2359,72 +2361,72 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		int j;
 
 		if (!delta)
-			pmc->mca_sfcount[sfmode]--;
+			mc->mca_sfcount[sfmode]--;
 		for (j = 0; j < i; j++)
-			ip6_mc_del1_src(pmc, sfmode, &psfsrc[j]);
-	} else if (isexclude != (pmc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
+			ip6_mc_del1_src(mc, sfmode, &psfsrc[j]);
+	} else if (isexclude != (mc->mca_sfcount[MCAST_EXCLUDE] != 0)) {
 		struct ip6_sf_list *psf;
 
 		/* filter mode change */
-		if (pmc->mca_sfcount[MCAST_EXCLUDE])
-			pmc->mca_sfmode = MCAST_EXCLUDE;
-		else if (pmc->mca_sfcount[MCAST_INCLUDE])
-			pmc->mca_sfmode = MCAST_INCLUDE;
+		if (mc->mca_sfcount[MCAST_EXCLUDE])
+			mc->mca_sfmode = MCAST_EXCLUDE;
+		else if (mc->mca_sfcount[MCAST_INCLUDE])
+			mc->mca_sfmode = MCAST_INCLUDE;
 		/* else no filters; keep old mode for reports */
 
-		pmc->mca_crcount = idev->mc_qrv;
-		idev->mc_ifc_count = pmc->mca_crcount;
-		for (psf = pmc->mca_sources; psf; psf = psf->sf_next)
+		mc->mca_crcount = idev->mc_qrv;
+		idev->mc_ifc_count = mc->mca_crcount;
+		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
 		mld_ifc_event(idev);
-	} else if (sf_setstate(pmc))
+	} else if (sf_setstate(mc))
 		mld_ifc_event(idev);
-	spin_unlock_bh(&pmc->mca_lock);
+	spin_unlock_bh(&mc->mca_lock);
 	read_unlock_bh(&idev->lock);
 	return err;
 }
 
-static void ip6_mc_clear_src(struct ifmcaddr6 *pmc)
+static void ip6_mc_clear_src(struct ifmcaddr6 *mc)
 {
 	struct ip6_sf_list *psf, *nextpsf;
 
-	for (psf = pmc->mca_tomb; psf; psf = nextpsf) {
+	for (psf = mc->mca_tomb; psf; psf = nextpsf) {
 		nextpsf = psf->sf_next;
 		kfree(psf);
 	}
-	pmc->mca_tomb = NULL;
-	for (psf = pmc->mca_sources; psf; psf = nextpsf) {
+	mc->mca_tomb = NULL;
+	for (psf = mc->mca_sources; psf; psf = nextpsf) {
 		nextpsf = psf->sf_next;
 		kfree(psf);
 	}
-	pmc->mca_sources = NULL;
-	pmc->mca_sfmode = MCAST_EXCLUDE;
-	pmc->mca_sfcount[MCAST_INCLUDE] = 0;
-	pmc->mca_sfcount[MCAST_EXCLUDE] = 1;
+	mc->mca_sources = NULL;
+	mc->mca_sfmode = MCAST_EXCLUDE;
+	mc->mca_sfcount[MCAST_INCLUDE] = 0;
+	mc->mca_sfcount[MCAST_EXCLUDE] = 1;
 }
 
 
-static void igmp6_join_group(struct ifmcaddr6 *ma)
+static void igmp6_join_group(struct ifmcaddr6 *mc)
 {
 	unsigned long delay;
 
-	if (ma->mca_flags & MAF_NOREPORT)
+	if (mc->mca_flags & MAF_NOREPORT)
 		return;
 
-	igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
+	igmp6_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 
-	delay = prandom_u32() % unsolicited_report_interval(ma->idev);
+	delay = prandom_u32() % unsolicited_report_interval(mc->idev);
 
-	spin_lock_bh(&ma->mca_lock);
-	if (del_timer(&ma->mca_timer)) {
-		refcount_dec(&ma->mca_refcnt);
-		delay = ma->mca_timer.expires - jiffies;
+	spin_lock_bh(&mc->mca_lock);
+	if (del_timer(&mc->mca_timer)) {
+		refcount_dec(&mc->mca_refcnt);
+		delay = mc->mca_timer.expires - jiffies;
 	}
 
-	if (!mod_timer(&ma->mca_timer, jiffies + delay))
-		refcount_inc(&ma->mca_refcnt);
-	ma->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
-	spin_unlock_bh(&ma->mca_lock);
+	if (!mod_timer(&mc->mca_timer, jiffies + delay))
+		refcount_inc(&mc->mca_refcnt);
+	mc->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
+	spin_unlock_bh(&mc->mca_lock);
 }
 
 static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
@@ -2446,15 +2448,15 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 	return err;
 }
 
-static void igmp6_leave_group(struct ifmcaddr6 *ma)
+static void igmp6_leave_group(struct ifmcaddr6 *mc)
 {
-	if (mld_in_v1_mode(ma->idev)) {
-		if (ma->mca_flags & MAF_LAST_REPORTER)
-			igmp6_send(&ma->mca_addr, ma->idev->dev,
-				ICMPV6_MGM_REDUCTION);
+	if (mld_in_v1_mode(mc->idev)) {
+		if (mc->mca_flags & MAF_LAST_REPORTER)
+			igmp6_send(&mc->mca_addr, mc->idev->dev,
+				   ICMPV6_MGM_REDUCTION);
 	} else {
-		mld_add_delrec(ma->idev, ma);
-		mld_ifc_event(ma->idev);
+		mld_add_delrec(mc->idev, mc);
+		mld_ifc_event(mc->idev);
 	}
 }
 
@@ -2491,31 +2493,31 @@ static void mld_ifc_event(struct inet6_dev *idev)
 
 static void igmp6_timer_handler(struct timer_list *t)
 {
-	struct ifmcaddr6 *ma = from_timer(ma, t, mca_timer);
+	struct ifmcaddr6 *mc = from_timer(mc, t, mca_timer);
 
-	if (mld_in_v1_mode(ma->idev))
-		igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
+	if (mld_in_v1_mode(mc->idev))
+		igmp6_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 	else
-		mld_send_report(ma->idev, ma);
+		mld_send_report(mc->idev, mc);
 
-	spin_lock(&ma->mca_lock);
-	ma->mca_flags |=  MAF_LAST_REPORTER;
-	ma->mca_flags &= ~MAF_TIMER_RUNNING;
-	spin_unlock(&ma->mca_lock);
-	ma_put(ma);
+	spin_lock(&mc->mca_lock);
+	mc->mca_flags |=  MAF_LAST_REPORTER;
+	mc->mca_flags &= ~MAF_TIMER_RUNNING;
+	spin_unlock(&mc->mca_lock);
+	mca_put(mc);
 }
 
 /* Device changing type */
 
 void ipv6_mc_unmap(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *i;
+	struct ifmcaddr6 *mc, *tmp;
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
 	read_lock_bh(&idev->lock);
-	for (i = idev->mc_list; i; i = i->next)
-		igmp6_group_dropped(i);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
+		igmp6_group_dropped(mc);
 	read_unlock_bh(&idev->lock);
 }
 
@@ -2528,14 +2530,14 @@ void ipv6_mc_remap(struct inet6_dev *idev)
 
 void ipv6_mc_down(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *i;
+	struct ifmcaddr6 *mc, *tmp;
 
 	/* Withdraw multicast list */
 
 	read_lock_bh(&idev->lock);
 
-	for (i = idev->mc_list; i; i = i->next)
-		igmp6_group_dropped(i);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
+		igmp6_group_dropped(mc);
 
 	/* Should stop timer after group drop. or we will
 	 * start timer again in mld_ifc_event()
@@ -2559,15 +2561,15 @@ static void ipv6_mc_reset(struct inet6_dev *idev)
 
 void ipv6_mc_up(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *i;
+	struct ifmcaddr6 *mc, *tmp;
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
 	read_lock_bh(&idev->lock);
 	ipv6_mc_reset(idev);
-	for (i = idev->mc_list; i; i = i->next) {
-		mld_del_delrec(idev, i);
-		igmp6_group_added(i);
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
+		mld_del_delrec(idev, mc);
+		igmp6_group_added(mc);
 	}
 	read_unlock_bh(&idev->lock);
 }
@@ -2577,10 +2579,11 @@ void ipv6_mc_up(struct inet6_dev *idev)
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
 	write_lock_bh(&idev->lock);
-	spin_lock_init(&idev->mc_lock);
+	spin_lock_init(&idev->mc_tomb_lock);
 	idev->mc_gq_running = 0;
 	timer_setup(&idev->mc_gq_timer, mld_gq_timer_expire, 0);
-	idev->mc_tomb = NULL;
+	INIT_LIST_HEAD(&idev->mc_tomb_list);
+	INIT_LIST_HEAD(&idev->mc_list);
 	idev->mc_ifc_count = 0;
 	timer_setup(&idev->mc_ifc_timer, mld_ifc_timer_expire, 0);
 	timer_setup(&idev->mc_dad_timer, mld_dad_timer_expire, 0);
@@ -2594,7 +2597,7 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 
 void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *i;
+	struct ifmcaddr6 *mc, *tmp;
 
 	/* Deactivate timers */
 	ipv6_mc_down(idev);
@@ -2611,12 +2614,11 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
 
 	write_lock_bh(&idev->lock);
-	while ((i = idev->mc_list) != NULL) {
-		idev->mc_list = i->next;
-
+	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
+		list_del(&mc->list);
 		write_unlock_bh(&idev->lock);
-		ip6_mc_clear_src(i);
-		ma_put(i);
+		ip6_mc_clear_src(mc);
+		mca_put(mc);
 		write_lock_bh(&idev->lock);
 	}
 	write_unlock_bh(&idev->lock);
@@ -2624,14 +2626,14 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 
 static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 {
-	struct ifmcaddr6 *pmc;
+	struct ifmcaddr6 *mc;
 
 	ASSERT_RTNL();
 
 	if (mld_in_v1_mode(idev)) {
 		read_lock_bh(&idev->lock);
-		for (pmc = idev->mc_list; pmc; pmc = pmc->next)
-			igmp6_join_group(pmc);
+		list_for_each_entry(mc, &idev->mc_list, list)
+			igmp6_join_group(mc);
 		read_unlock_bh(&idev->lock);
 	} else
 		mld_send_report(idev, NULL);
@@ -2671,57 +2673,64 @@ struct igmp6_mc_iter_state {
 
 static inline struct ifmcaddr6 *igmp6_mc_get_first(struct seq_file *seq)
 {
-	struct ifmcaddr6 *im = NULL;
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 	struct net *net = seq_file_net(seq);
+	struct ifmcaddr6 *mc;
 
 	state->idev = NULL;
 	for_each_netdev_rcu(net, state->dev) {
 		struct inet6_dev *idev;
+
 		idev = __in6_dev_get(state->dev);
 		if (!idev)
 			continue;
+
 		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
-		if (im) {
+		list_for_each_entry(mc, &idev->mc_list, list) {
 			state->idev = idev;
-			break;
+			return mc;
 		}
 		read_unlock_bh(&idev->lock);
 	}
-	return im;
+	return NULL;
 }
 
-static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr6 *im)
+static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr6 *mc)
 {
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
-	im = im->next;
-	while (!im) {
-		if (likely(state->idev))
+	list_for_each_entry_continue(mc, &state->idev->mc_list, list)
+		return mc;
+
+	mc = NULL;
+
+	while (!mc) {
+		if (state->idev)
 			read_unlock_bh(&state->idev->lock);
 
 		state->dev = next_net_device_rcu(state->dev);
 		if (!state->dev) {
 			state->idev = NULL;
-			break;
+			return NULL;
 		}
 		state->idev = __in6_dev_get(state->dev);
 		if (!state->idev)
 			continue;
 		read_lock_bh(&state->idev->lock);
-		im = state->idev->mc_list;
+		mc = list_first_entry_or_null(&state->idev->mc_list,
+					      struct ifmcaddr6, list);
 	}
-	return im;
+	return mc;
 }
 
 static struct ifmcaddr6 *igmp6_mc_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct ifmcaddr6 *im = igmp6_mc_get_first(seq);
-	if (im)
-		while (pos && (im = igmp6_mc_get_next(seq, im)) != NULL)
+	struct ifmcaddr6 *mc = igmp6_mc_get_first(seq);
+
+	if (mc)
+		while (pos && (mc = igmp6_mc_get_next(seq, mc)) != NULL)
 			--pos;
-	return pos ? NULL : im;
+	return pos ? NULL : mc;
 }
 
 static void *igmp6_mc_seq_start(struct seq_file *seq, loff_t *pos)
@@ -2733,10 +2742,10 @@ static void *igmp6_mc_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *igmp6_mc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct ifmcaddr6 *im = igmp6_mc_get_next(seq, v);
+	struct ifmcaddr6 *mc = igmp6_mc_get_next(seq, v);
 
 	++*pos;
-	return im;
+	return mc;
 }
 
 static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
@@ -2754,16 +2763,16 @@ static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
 
 static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 {
-	struct ifmcaddr6 *im = (struct ifmcaddr6 *)v;
+	struct ifmcaddr6 *mc = (struct ifmcaddr6 *)v;
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
 	seq_printf(seq,
 		   "%-4d %-15s %pi6 %5d %08X %ld\n",
 		   state->dev->ifindex, state->dev->name,
-		   &im->mca_addr,
-		   im->mca_users, im->mca_flags,
-		   (im->mca_flags&MAF_TIMER_RUNNING) ?
-		   jiffies_to_clock_t(im->mca_timer.expires-jiffies) : 0);
+		   &mc->mca_addr,
+		   mc->mca_users, mc->mca_flags,
+		   (mc->mca_flags & MAF_TIMER_RUNNING) ?
+		   jiffies_to_clock_t(mc->mca_timer.expires - jiffies) : 0);
 	return 0;
 }
 
@@ -2778,51 +2787,61 @@ struct igmp6_mcf_iter_state {
 	struct seq_net_private p;
 	struct net_device *dev;
 	struct inet6_dev *idev;
-	struct ifmcaddr6 *im;
+	struct ifmcaddr6 *mc;
 };
 
 #define igmp6_mcf_seq_private(seq)	((struct igmp6_mcf_iter_state *)(seq)->private)
 
 static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 {
-	struct ip6_sf_list *psf = NULL;
-	struct ifmcaddr6 *im = NULL;
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
 	struct net *net = seq_file_net(seq);
+	struct ip6_sf_list *psf = NULL;
+	struct ifmcaddr6 *mc = NULL;
 
 	state->idev = NULL;
-	state->im = NULL;
+	state->mc = NULL;
 	for_each_netdev_rcu(net, state->dev) {
 		struct inet6_dev *idev;
+
 		idev = __in6_dev_get(state->dev);
 		if (unlikely(idev == NULL))
 			continue;
 		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
-		if (likely(im)) {
-			spin_lock_bh(&im->mca_lock);
-			psf = im->mca_sources;
+		mc = list_first_entry_or_null(&idev->mc_list,
+					      struct ifmcaddr6, list);
+		if (likely(mc)) {
+			spin_lock_bh(&mc->mca_lock);
+			psf = mc->mca_sources;
 			if (likely(psf)) {
-				state->im = im;
+				state->mc = mc;
 				state->idev = idev;
 				break;
 			}
-			spin_unlock_bh(&im->mca_lock);
+			spin_unlock_bh(&mc->mca_lock);
 		}
 		read_unlock_bh(&idev->lock);
 	}
 	return psf;
 }
 
-static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_sf_list *psf)
+static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq,
+					      struct ip6_sf_list *psf)
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
 
 	psf = psf->sf_next;
 	while (!psf) {
-		spin_unlock_bh(&state->im->mca_lock);
-		state->im = state->im->next;
-		while (!state->im) {
+		spin_unlock_bh(&state->mc->mca_lock);
+		list_for_each_entry_continue(state->mc, &state->idev->mc_list, list) {
+			spin_lock_bh(&state->mc->mca_lock);
+			psf = state->mc->mca_sources;
+			goto out;
+		}
+
+		state->mc = NULL;
+
+		while (!state->mc) {
 			if (likely(state->idev))
 				read_unlock_bh(&state->idev->lock);
 
@@ -2835,12 +2854,13 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 			if (!state->idev)
 				continue;
 			read_lock_bh(&state->idev->lock);
-			state->im = state->idev->mc_list;
+			state->mc = list_first_entry_or_null(&state->idev->mc_list,
+							     struct ifmcaddr6, list);
 		}
-		if (!state->im)
+		if (!state->mc)
 			break;
-		spin_lock_bh(&state->im->mca_lock);
-		psf = state->im->mca_sources;
+		spin_lock_bh(&state->mc->mca_lock);
+		psf = state->mc->mca_sources;
 	}
 out:
 	return psf;
@@ -2849,6 +2869,7 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 static struct ip6_sf_list *igmp6_mcf_get_idx(struct seq_file *seq, loff_t pos)
 {
 	struct ip6_sf_list *psf = igmp6_mcf_get_first(seq);
+
 	if (psf)
 		while (pos && (psf = igmp6_mcf_get_next(seq, psf)) != NULL)
 			--pos;
@@ -2865,6 +2886,7 @@ static void *igmp6_mcf_seq_start(struct seq_file *seq, loff_t *pos)
 static void *igmp6_mcf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct ip6_sf_list *psf;
+
 	if (v == SEQ_START_TOKEN)
 		psf = igmp6_mcf_get_first(seq);
 	else
@@ -2877,9 +2899,10 @@ static void igmp6_mcf_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
-	if (likely(state->im)) {
-		spin_unlock_bh(&state->im->mca_lock);
-		state->im = NULL;
+
+	if (likely(state->mc)) {
+		spin_unlock_bh(&state->mc->mca_lock);
+		state->mc = NULL;
 	}
 	if (likely(state->idev)) {
 		read_unlock_bh(&state->idev->lock);
@@ -2900,7 +2923,7 @@ static int igmp6_mcf_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq,
 			   "%3d %6.6s %pi6 %pi6 %6lu %6lu\n",
 			   state->dev->ifindex, state->dev->name,
-			   &state->im->mca_addr,
+			   &state->mc->mca_addr,
 			   &psf->sf_addr,
 			   psf->sf_count[MCAST_INCLUDE],
 			   psf->sf_count[MCAST_EXCLUDE]);
-- 
2.17.1

