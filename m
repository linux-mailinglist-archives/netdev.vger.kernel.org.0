Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA105313BBD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhBHR4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhBHRyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:54:45 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE77C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:54:03 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b145so10196205pfb.4
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B7fQD3v69CLjaOLuf7nxZ3nJdmMrCYjpSCXAVRHVFtI=;
        b=MIjfgvCQxn0tYbGT1SAVb6P3BudCRiur5HgC8ApSQWNRnG4ICTP8XggUFFXp0E1CbR
         jg5qwyWAHHVC28+NwLN/jH6ZdOOEk584aQODnj4OKGExb37fDhAIzTVoPncKiWSd0Yq3
         YOjXinIRJHn7/d9PqMcv4bDMIV6cbPy8vVwLCr9iZjZNk0+wXqKkYBaKEVHGixdLEPS6
         E3SiCWIMbSBVFxz1e1e5+2HD5iinHTdC4PmU45DinXTh3LVzmARUamQwFOLySzjn7urm
         V/grxRWx0CWRhfPKmoCYh93LelE+zQIK96Yum/0gdTNaUpLQVs7HhumiaDUf1jAHQtKr
         lmdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B7fQD3v69CLjaOLuf7nxZ3nJdmMrCYjpSCXAVRHVFtI=;
        b=W9KgK46Di1nJnFiE8MIX8brRxcoAGqtMQWObb6gpFBcZV4BZyeAXlA8lDfc+ojQgiD
         yDK04TXcz/onNNrVjyB57WzAi2QOh+iiUcvl8eCjqJm7oxm5K6AAvIItKrY6IRs9wpW0
         prbydr8im7rF4EKS0JqkEu+iUUutJulrq/CdcX74rmwbt91Y4eFuMmDJpkQZBl4WmNmB
         rpoPZFuyRq1FBXOzSruDj+ZpCU6uaamkDGlrK2mMNPGesRovEdxfzkkko/ztx1Xxa+0X
         t8RfWuHQh9poqX0KNV5lj5qXODIFfovH5HL3Wv82DlOlKmlYDdtka1vky+deqTk4csB/
         5XNA==
X-Gm-Message-State: AOAM531+PgcoK9iyQXHnYW8iQCBpS1jbNFwllPkfFWOqGGbihlnahyi2
        YNt/hDnqZGvnjgnlErwYhHjCmU8d3Oc=
X-Google-Smtp-Source: ABdhPJzEUC8K5S5GKiliC8OFH2A3MjNhovndc4+WerWBCm1ZmY05HXlY0nDi7ZLcAnPbeAnqEEoPzA==
X-Received: by 2002:aa7:9e89:0:b029:1d2:7d49:9bac with SMTP id p9-20020aa79e890000b02901d27d499bacmr19235621pfq.21.1612806843238;
        Mon, 08 Feb 2021 09:54:03 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id r1sm19075483pfh.2.2021.02.08.09.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:54:02 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 2/8] mld: convert ip6_sf_list to list macros
Date:   Mon,  8 Feb 2021 17:53:56 +0000
Message-Id: <20210208175356.5060-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct ip6_sf_list doesn't use list API so that code shape is
a little bit different from others.
So it converts ip6_sf_list to use list API so it would improve readability.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/if_inet6.h |   6 +-
 net/ipv6/mcast.c       | 267 +++++++++++++++++++++++------------------
 2 files changed, 155 insertions(+), 118 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 1262ccd5221e..cd17b756a2a5 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -97,7 +97,7 @@ struct ipv6_mc_socklist {
 };
 
 struct ip6_sf_list {
-	struct ip6_sf_list	*sf_next;
+	struct list_head	list;
 	struct in6_addr		sf_addr;
 	unsigned long		sf_count[2];	/* include/exclude counts */
 	unsigned char		sf_gsresp;	/* include in g & s response? */
@@ -115,8 +115,8 @@ struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
 	struct inet6_dev	*idev;
 	struct list_head	list;
-	struct ip6_sf_list	*mca_sources;
-	struct ip6_sf_list	*mca_tomb;
+	struct list_head	mca_source_list;
+	struct list_head	mca_tomb_list;
 	unsigned int		mca_sfmode;
 	unsigned char		mca_crcount;
 	unsigned long		mca_sfcount[2];
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 508c007df84f..9c4dc4c2ff01 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -747,6 +747,8 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	spin_lock_bh(&im->mca_lock);
 	spin_lock_init(&mc->mca_lock);
 	INIT_LIST_HEAD(&mc->list);
+	INIT_LIST_HEAD(&mc->mca_tomb_list);
+	INIT_LIST_HEAD(&mc->mca_source_list);
 	mc->idev = im->idev;
 	in6_dev_hold(idev);
 	mc->mca_addr = im->mca_addr;
@@ -755,10 +757,10 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	if (mc->mca_sfmode == MCAST_INCLUDE) {
 		struct ip6_sf_list *psf;
 
-		mc->mca_tomb = im->mca_tomb;
-		mc->mca_sources = im->mca_sources;
-		im->mca_tomb = im->mca_sources = NULL;
-		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
+		list_splice_init(&im->mca_tomb_list, &mc->mca_tomb_list);
+		list_splice_init(&im->mca_source_list, &mc->mca_source_list);
+
+		list_for_each_entry(psf, &mc->mca_source_list, list)
 			psf->sf_crcount = mc->mca_crcount;
 	}
 	spin_unlock_bh(&im->mca_lock);
@@ -773,6 +775,8 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	struct ifmcaddr6 *mc = NULL, *tmp = NULL;
 	struct in6_addr *mca = &im->mca_addr;
 	struct ip6_sf_list *psf;
+	LIST_HEAD(source_list);
+	LIST_HEAD(tomb_list);
 	bool found = false;
 
 	spin_lock_bh(&idev->mc_tomb_lock);
@@ -789,9 +793,14 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	if (found) {
 		im->idev = mc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
-			swap(im->mca_tomb, mc->mca_tomb);
-			swap(im->mca_sources, mc->mca_sources);
-			for (psf = im->mca_sources; psf; psf = psf->sf_next)
+			list_splice_init(&im->mca_tomb_list, &tomb_list);
+			list_splice_init(&im->mca_source_list, &source_list);
+			list_splice_init(&mc->mca_tomb_list, &im->mca_tomb_list);
+			list_splice_init(&mc->mca_source_list, &im->mca_source_list);
+			list_splice_init(&tomb_list, &mc->mca_tomb_list);
+			list_splice_init(&source_list, &mc->mca_source_list);
+
+			list_for_each_entry(psf, &im->mca_source_list, list)
 				psf->sf_crcount = idev->mc_qrv;
 		} else {
 			im->mca_crcount = idev->mc_qrv;
@@ -819,16 +828,14 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 	/* clear dead sources, too */
 	read_lock_bh(&idev->lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
-		struct ip6_sf_list *psf, *psf_next;
+		struct ip6_sf_list *psf, *tmp;
+		LIST_HEAD(mca_list);
 
 		spin_lock_bh(&mc->mca_lock);
-		psf = mc->mca_tomb;
-		mc->mca_tomb = NULL;
+		list_splice_init(&mc->mca_tomb_list, &mca_list);
 		spin_unlock_bh(&mc->mca_lock);
-		for (; psf; psf = psf_next) {
-			psf_next = psf->sf_next;
+		list_for_each_entry_safe(psf, tmp, &mca_list, list)
 			kfree(psf);
-		}
 	}
 	read_unlock_bh(&idev->lock);
 }
@@ -848,6 +855,8 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 	mc->mca_addr = *addr;
 	mc->idev = idev; /* reference taken by caller */
 	INIT_LIST_HEAD(&mc->list);
+	INIT_LIST_HEAD(&mc->mca_source_list);
+	INIT_LIST_HEAD(&mc->mca_tomb_list);
 	mc->mca_users = 1;
 	/* mca_stamp should be updated upon changes */
 	mc->mca_cstamp = mc->mca_tstamp = jiffies;
@@ -995,18 +1004,22 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 		if (found) {
 			if (src_addr && !ipv6_addr_any(src_addr)) {
 				struct ip6_sf_list *psf;
+				bool found_psf = false;
 
 				spin_lock_bh(&mc->mca_lock);
-				for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
-					if (ipv6_addr_equal(&psf->sf_addr, src_addr))
+				list_for_each_entry(psf, &mc->mca_source_list, list) {
+					if (ipv6_addr_equal(&psf->sf_addr, src_addr)) {
+						found_psf = true;
 						break;
+					}
 				}
-				if (psf)
+				if (found_psf) {
 					rv = psf->sf_count[MCAST_INCLUDE] ||
-						psf->sf_count[MCAST_EXCLUDE] !=
-						mc->mca_sfcount[MCAST_EXCLUDE];
-				else
+					     psf->sf_count[MCAST_EXCLUDE] !=
+					     mc->mca_sfcount[MCAST_EXCLUDE];
+				} else {
 					rv = mc->mca_sfcount[MCAST_EXCLUDE] != 0;
+				}
 				spin_unlock_bh(&mc->mca_lock);
 			} else
 				rv = true; /* don't filter unspecified source */
@@ -1097,7 +1110,7 @@ static bool mld_xmarksources(struct ifmcaddr6 *mc, int nsrcs,
 	int i, scount;
 
 	scount = 0;
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1130,7 +1143,7 @@ static bool mld_marksources(struct ifmcaddr6 *mc, int nsrcs,
 	/* mark INCLUDE-mode sources */
 
 	scount = 0;
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
 		if (scount == nsrcs)
 			break;
 		for (i = 0; i < nsrcs; i++) {
@@ -1540,7 +1553,7 @@ static int mld_scount(struct ifmcaddr6 *mc, int type, int gdeleted,
 	struct ip6_sf_list *psf;
 	int scount = 0;
 
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
 		if (!is_in(mc, psf, type, gdeleted, sdeleted))
 			continue;
 		scount++;
@@ -1722,12 +1735,13 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 				int type, int gdeleted, int sdeleted,
 				int crsend)
 {
-	struct ip6_sf_list *psf, *psf_next, *psf_prev, **psf_list;
 	int scount, stotal, first, isquery, truncate;
 	struct inet6_dev *idev = mc->idev;
+	struct ip6_sf_list *psf, *tmp;
 	struct mld2_grec *pgr = NULL;
 	struct mld2_report *pmr;
 	struct net_device *dev;
+	struct list_head *head;
 	unsigned int mtu;
 
 	dev = idev->dev;
@@ -1745,9 +1759,12 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 
 	stotal = scount = 0;
 
-	psf_list = sdeleted ? &mc->mca_tomb : &mc->mca_sources;
+	if (sdeleted)
+		head = &mc->mca_tomb_list;
+	else
+		head = &mc->mca_source_list;
 
-	if (!*psf_list)
+	if (list_empty(head))
 		goto empty_source;
 
 	pmr = skb ? (struct mld2_report *)skb_transport_header(skb) : NULL;
@@ -1761,17 +1778,13 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 			skb = mld_newpack(idev, mtu);
 		}
 	}
+
 	first = 1;
-	psf_prev = NULL;
-	for (psf = *psf_list; psf; psf = psf_next) {
+	list_for_each_entry_safe(psf, tmp, head, list) {
 		struct in6_addr *psrc;
 
-		psf_next = psf->sf_next;
-
-		if (!is_in(mc, psf, type, gdeleted, sdeleted) && !crsend) {
-			psf_prev = psf;
+		if (!is_in(mc, psf, type, gdeleted, sdeleted) && !crsend)
 			continue;
-		}
 
 		/* Based on RFC3810 6.1. Should not send source-list change
 		 * records when there is a filter mode change.
@@ -1798,10 +1811,12 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 			first = 1;
 			scount = 0;
 		}
+
 		if (first) {
 			skb = add_grhead(skb, mc, type, &pgr, mtu);
 			first = 0;
 		}
+
 		if (!skb)
 			return NULL;
 		psrc = skb_put(skb, sizeof(*psrc));
@@ -1812,15 +1827,11 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *mc,
 decrease_sf_crcount:
 			psf->sf_crcount--;
 			if ((sdeleted || gdeleted) && psf->sf_crcount == 0) {
-				if (psf_prev)
-					psf_prev->sf_next = psf->sf_next;
-				else
-					*psf_list = psf->sf_next;
+				list_del(&psf->list);
 				kfree(psf);
 				continue;
 			}
 		}
-		psf_prev = psf;
 	}
 
 empty_source:
@@ -1880,21 +1891,22 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *mc)
 /*
  * remove zero-count source records from a source filter list
  */
-static void mld_clear_zeros(struct ip6_sf_list **ppsf)
+static void mld_clear_zeros(struct ifmcaddr6 *mc)
 {
-	struct ip6_sf_list *psf_prev, *psf_next, *psf;
+	struct ip6_sf_list *psf, *tmp;
 
-	psf_prev = NULL;
-	for (psf = *ppsf; psf; psf = psf_next) {
-		psf_next = psf->sf_next;
+	list_for_each_entry_safe(psf, tmp, &mc->mca_tomb_list, list) {
 		if (psf->sf_crcount == 0) {
-			if (psf_prev)
-				psf_prev->sf_next = psf->sf_next;
-			else
-				*ppsf = psf->sf_next;
+			list_del(&psf->list);
 			kfree(psf);
-		} else
-			psf_prev = psf;
+		}
+	}
+
+	list_for_each_entry_safe(psf, tmp, &mc->mca_source_list, list) {
+		if (psf->sf_crcount == 0) {
+			list_del(&psf->list);
+			kfree(psf);
+		}
 	}
 }
 
@@ -1915,19 +1927,21 @@ static void mld_send_cr(struct inet6_dev *idev)
 			skb = add_grec(skb, mc, type, 1, 0, 0);
 			skb = add_grec(skb, mc, dtype, 1, 1, 0);
 		}
+
 		if (mc->mca_crcount) {
 			if (mc->mca_sfmode == MCAST_EXCLUDE) {
 				type = MLD2_CHANGE_TO_INCLUDE;
 				skb = add_grec(skb, mc, type, 1, 0, 0);
 			}
+
 			mc->mca_crcount--;
-			if (mc->mca_crcount == 0) {
-				mld_clear_zeros(&mc->mca_tomb);
-				mld_clear_zeros(&mc->mca_sources);
-			}
+			if (mc->mca_crcount == 0)
+				mld_clear_zeros(mc);
 		}
-		if (mc->mca_crcount == 0 && !mc->mca_tomb &&
-		    !mc->mca_sources) {
+
+		if (mc->mca_crcount == 0 &&
+		    list_empty(&mc->mca_tomb_list) &&
+		    list_empty(&mc->mca_source_list)) {
 			list_del(&mc->list);
 			in6_dev_put(mc->idev);
 			kfree(mc);
@@ -2117,33 +2131,32 @@ static void mld_dad_timer_expire(struct timer_list *t)
 static int ip6_mc_del1_src(struct ifmcaddr6 *mc, int sfmode,
 			   const struct in6_addr *psfsrc)
 {
-	struct ip6_sf_list *psf, *psf_prev;
+	struct ip6_sf_list *psf;
+	bool found = false;
 	int rv = 0;
 
-	psf_prev = NULL;
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
-		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
+		if (ipv6_addr_equal(&psf->sf_addr, psfsrc)) {
+			found = true;
 			break;
-		psf_prev = psf;
+		}
 	}
-	if (!psf || psf->sf_count[sfmode] == 0) {
+
+	if (!found || psf->sf_count[sfmode] == 0) {
 		/* source filter not found, or count wrong =>  bug */
 		return -ESRCH;
 	}
+
 	psf->sf_count[sfmode]--;
 	if (!psf->sf_count[MCAST_INCLUDE] && !psf->sf_count[MCAST_EXCLUDE]) {
 		struct inet6_dev *idev = mc->idev;
 
 		/* no more filters for this source */
-		if (psf_prev)
-			psf_prev->sf_next = psf->sf_next;
-		else
-			mc->mca_sources = psf->sf_next;
+		list_del_init(&psf->list);
 		if (psf->sf_oldin && !(mc->mca_flags & MAF_NOREPORT) &&
 		    !mld_in_v1_mode(idev)) {
 			psf->sf_crcount = idev->mc_qrv;
-			psf->sf_next = mc->mca_tomb;
-			mc->mca_tomb = psf;
+			list_add(&psf->list, &mc->mca_tomb_list);
 			rv = 1;
 		} else {
 			kfree(psf);
@@ -2202,7 +2215,7 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 		mc->mca_sfmode = MCAST_INCLUDE;
 		mc->mca_crcount = idev->mc_qrv;
 		idev->mc_ifc_count = mc->mca_crcount;
-		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
+		list_for_each_entry(psf, &mc->mca_source_list, list)
 			psf->sf_crcount = 0;
 		mld_ifc_event(mc->idev);
 	} else if (sf_setstate(mc) || changerec) {
@@ -2219,24 +2232,24 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *mca,
 static int ip6_mc_add1_src(struct ifmcaddr6 *mc, int sfmode,
 			   const struct in6_addr *psfsrc)
 {
-	struct ip6_sf_list *psf, *psf_prev;
+	struct ip6_sf_list *psf;
+	bool found = false;
 
-	psf_prev = NULL;
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
-		if (ipv6_addr_equal(&psf->sf_addr, psfsrc))
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
+		if (ipv6_addr_equal(&psf->sf_addr, psfsrc)) {
+			found = true;
 			break;
-		psf_prev = psf;
+		}
 	}
-	if (!psf) {
+
+	if (!found) {
 		psf = kzalloc(sizeof(*psf), GFP_ATOMIC);
 		if (!psf)
 			return -ENOBUFS;
 
 		psf->sf_addr = *psfsrc;
-		if (psf_prev) {
-			psf_prev->sf_next = psf;
-		} else
-			mc->mca_sources = psf;
+		INIT_LIST_HEAD(&psf->list);
+		list_add_tail(&psf->list, &mc->mca_source_list);
 	}
 	psf->sf_count[sfmode]++;
 	return 0;
@@ -2247,7 +2260,7 @@ static void sf_markstate(struct ifmcaddr6 *mc)
 	int mca_xcount = mc->mca_sfcount[MCAST_EXCLUDE];
 	struct ip6_sf_list *psf;
 
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
 		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
 			psf->sf_oldin = mca_xcount ==
 				psf->sf_count[MCAST_EXCLUDE] &&
@@ -2263,53 +2276,67 @@ static int sf_setstate(struct ifmcaddr6 *mc)
 	struct ip6_sf_list *psf, *dpsf;
 	int qrv = mc->idev->mc_qrv;
 	int new_in, rv;
+	bool found;
 
 	rv = 0;
-	for (psf = mc->mca_sources; psf; psf = psf->sf_next) {
+	list_for_each_entry(psf, &mc->mca_source_list, list) {
+		found = false;
+
 		if (mc->mca_sfcount[MCAST_EXCLUDE]) {
 			new_in = mca_xcount == psf->sf_count[MCAST_EXCLUDE] &&
 				!psf->sf_count[MCAST_INCLUDE];
-		} else
+		} else {
 			new_in = psf->sf_count[MCAST_INCLUDE] != 0;
+		}
+
 		if (new_in) {
-			if (!psf->sf_oldin) {
-				struct ip6_sf_list *prev = NULL;
+			if (psf->sf_oldin)
+				continue;
 
-				for (dpsf = mc->mca_tomb; dpsf;
-				     dpsf = dpsf->sf_next) {
-					if (ipv6_addr_equal(&dpsf->sf_addr,
-					    &psf->sf_addr))
-						break;
-					prev = dpsf;
-				}
-				if (dpsf) {
-					if (prev)
-						prev->sf_next = dpsf->sf_next;
-					else
-						mc->mca_tomb = dpsf->sf_next;
-					kfree(dpsf);
+			list_for_each_entry(dpsf, &mc->mca_tomb_list, list) {
+				if (ipv6_addr_equal(&dpsf->sf_addr,
+						    &psf->sf_addr)) {
+					found = true;
+					break;
 				}
-				psf->sf_crcount = qrv;
-				rv++;
 			}
+
+			if (found) {
+				list_del(&dpsf->list);
+				kfree(dpsf);
+			}
+			psf->sf_crcount = qrv;
+			rv++;
 		} else if (psf->sf_oldin) {
 			psf->sf_crcount = 0;
 			/*
 			 * add or update "delete" records if an active filter
 			 * is now inactive
 			 */
-			for (dpsf = mc->mca_tomb; dpsf; dpsf = dpsf->sf_next)
+			list_for_each_entry(dpsf, &mc->mca_tomb_list, list) {
 				if (ipv6_addr_equal(&dpsf->sf_addr,
-				    &psf->sf_addr))
+						    &psf->sf_addr)) {
+					found = true;
 					break;
-			if (!dpsf) {
+				}
+			}
+
+			if (!found) {
 				dpsf = kmalloc(sizeof(*dpsf), GFP_ATOMIC);
 				if (!dpsf)
 					continue;
-				*dpsf = *psf;
+
+				INIT_LIST_HEAD(&dpsf->list);
+				dpsf->sf_addr = psf->sf_addr;
+				dpsf->sf_count[MCAST_INCLUDE] =
+					psf->sf_count[MCAST_INCLUDE];
+				dpsf->sf_count[MCAST_EXCLUDE] =
+					psf->sf_count[MCAST_EXCLUDE];
+				dpsf->sf_gsresp = psf->sf_gsresp;
+				dpsf->sf_oldin = psf->sf_oldin;
+				dpsf->sf_crcount = psf->sf_crcount;
 				/* mc->mca_lock held by callers */
-				dpsf->sf_next = mc->mca_tomb;
-				mc->mca_tomb = dpsf;
+				list_add(&dpsf->list, &mc->mca_tomb_list);
 			}
 			dpsf->sf_crcount = qrv;
 			rv++;
@@ -2376,7 +2403,7 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 
 		mc->mca_crcount = idev->mc_qrv;
 		idev->mc_ifc_count = mc->mca_crcount;
-		for (psf = mc->mca_sources; psf; psf = psf->sf_next)
+		list_for_each_entry(psf, &mc->mca_source_list, list)
 			psf->sf_crcount = 0;
 		mld_ifc_event(idev);
 	} else if (sf_setstate(mc))
@@ -2388,18 +2415,18 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *mca,
 
 static void ip6_mc_clear_src(struct ifmcaddr6 *mc)
 {
-	struct ip6_sf_list *psf, *nextpsf;
+	struct ip6_sf_list *psf, *tmp;
 
-	for (psf = mc->mca_tomb; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
+	list_for_each_entry_safe(psf, tmp, &mc->mca_tomb_list, list) {
+		list_del(&psf->list);
 		kfree(psf);
 	}
-	mc->mca_tomb = NULL;
-	for (psf = mc->mca_sources; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
+
+	list_for_each_entry_safe(psf, tmp, &mc->mca_source_list, list) {
+		list_del(&psf->list);
 		kfree(psf);
 	}
-	mc->mca_sources = NULL;
+
 	mc->mca_sfmode = MCAST_EXCLUDE;
 	mc->mca_sfcount[MCAST_INCLUDE] = 0;
 	mc->mca_sfcount[MCAST_EXCLUDE] = 1;
@@ -2812,7 +2839,8 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 					      struct ifmcaddr6, list);
 		if (likely(mc)) {
 			spin_lock_bh(&mc->mca_lock);
-			psf = mc->mca_sources;
+			psf = list_first_entry_or_null(&mc->mca_source_list,
+						       struct ip6_sf_list, list);
 			if (likely(psf)) {
 				state->mc = mc;
 				state->idev = idev;
@@ -2830,12 +2858,20 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq,
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
 
-	psf = psf->sf_next;
+	list_for_each_entry_continue(psf, &state->mc->mca_source_list, list)
+		return psf;
+
+	psf = NULL;
 	while (!psf) {
 		spin_unlock_bh(&state->mc->mca_lock);
 		list_for_each_entry_continue(state->mc, &state->idev->mc_list, list) {
 			spin_lock_bh(&state->mc->mca_lock);
-			psf = state->mc->mca_sources;
+			psf = list_first_entry_or_null(&state->mc->mca_source_list,
+						       struct ip6_sf_list, list);
+			if (!psf) {
+				spin_unlock_bh(&state->mc->mca_lock);
+				continue;
+			}
 			goto out;
 		}
 
@@ -2860,7 +2896,8 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq,
 		if (!state->mc)
 			break;
 		spin_lock_bh(&state->mc->mca_lock);
-		psf = state->mc->mca_sources;
+		psf = list_first_entry_or_null(&state->mc->mca_source_list,
+					       struct ip6_sf_list, list);
 	}
 out:
 	return psf;
-- 
2.17.1

