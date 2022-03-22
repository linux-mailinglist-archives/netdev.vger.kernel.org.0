Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139184E4851
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiCVVhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbiCVVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:37:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A0D6252
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:35:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qa43so38851494ejc.12
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3f9gOqodXg2DfxJMkma6JKgLENjNywgG1bzM+q07pGA=;
        b=W6pHo66zFqoLpEUOJK1YlIdKV63yTZ025pdAgsdj8huJ4FQUtPZPg6gddugaKmGYx3
         ZSrzAY8ndyKuOsV0R/3ef1w4sDrTaSNhCajIkfYIUEK9ClHvIwGt0QCXC6w3e8JUAKnW
         Ae5SKC4oKcl1YHQUYvj3yb0jX9sl0i9GrOVAIPzlQMHiGNum4DJC7lWCtvoe8lAVid1Q
         i2s2+IoFlt9o6sgRo2He9NrV3ZyB4mKi/OIgw0M50Bbzd3jqK1hLdKS+pu5iocA9ndFT
         BBavFOBtKemz9KRAtrL/v2ZJr9HCd20A66G+jaa/BKRcZlpW4CV7gvIZ0ScV7qPZxIbW
         7GEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3f9gOqodXg2DfxJMkma6JKgLENjNywgG1bzM+q07pGA=;
        b=gAiz5dMl3hhqMH7KVEJ0/eDyz5oiujCvPSSYCNPjcPQf+qtMR6gNK6FCnu84XGAf7P
         KEwX9vakkveFV+/2TazW3EgpfW8pu5TphXxqDEoASY/sPXyXcXclmu4+vWMKcGttiCd6
         hVMrYY+qQRi32Ud5UrtjEjjClHJ35PQ5ON5F7dqolDVSkelK4eYhY20S8I4rpNe9ZpnN
         KwNXWKwCCRIj0PYDyXHVL83raoG/hkBc2UyI6+Y7SZ661sFtGgz0ymM7Rl+lVUKzbyDD
         xFSlf8RtO/hGZY0/S2AZ/2NAnG8ReRT2DYi7RvBKzEzL0jhUiMCBh6PvBgAt73YFrjXm
         3SxA==
X-Gm-Message-State: AOAM53344/DHxPDhBdwY1yLVJA9PZvufku8CciSlW3OcvDmD6xWz8AXv
        6sXIIjI+Er/jB0Vg25ONNbpIOPGibRmmSQ==
X-Google-Smtp-Source: ABdhPJw3ucB6D4gmyfF6QGuIK9DymeouyoTCQpcJFJagJg3tVezAoPSnt2QQhvqG4CsVzSQ9+vZeqw==
X-Received: by 2002:a17:907:7da6:b0:6e0:5b7c:e3f9 with SMTP id oz38-20020a1709077da600b006e05b7ce3f9mr883559ejc.239.1647984938406;
        Tue, 22 Mar 2022 14:35:38 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id og49-20020a1709071df100b006db0dcf673esm9051572ejc.27.2022.03.22.14.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:35:37 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] ipv6: fix locking issues with loops over idev->addr_list
Date:   Tue, 22 Mar 2022 22:34:08 +0100
Message-Id: <20220322213406.55977-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

idev->addr_list needs to be protected by idev->lock. However, it is not
always possible to do so while iterating and performing actions on
inet6_ifaddr instances. For example, multiple functions (like
addrconf_{join,leave}_anycast) eventually call down to other functions
that acquire the idev->lock. The current code temporarily unlocked the
idev->lock during the loops, which can cause race conditions. Moving the
locks up is also not an appropriate solution as the ordering of lock
acquisition will be inconsistent with for example mc_lock.

This solution adds an additional field to inet6_ifaddr that is used
to temporarily add the instances to a temporary list while holding
idev->lock. The temporary list can then be traversed without holding
idev->lock. This change was done in two places. In addrconf_ifdown, the
list_for_each_entry_safe variant of the list loop is also no longer
necessary as there is no deletion within that specific loop.

The remaining loop in addrconf_ifdown that unlocks idev->lock in its
loop body is of no issue. This is because that loop always gets the
first entry and performs the delete and condition check under the
idev->lock.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---

This was previously discussed in the mailing thread of
[PATCH v2] ipv6: acquire write lock for addr_list in dev_forward_change

 include/net/if_inet6.h |  7 +++++++
 net/ipv6/addrconf.c    | 29 +++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index f026cf08a8e8..a17f29f75e9a 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -64,6 +64,13 @@ struct inet6_ifaddr {
 
 	struct hlist_node	addr_lst;
 	struct list_head	if_list;
+	/*
+	 * Used to safely traverse idev->addr_list in process context
+	 * if the idev->lock needed to protect idev->addr_list cannot be held.
+	 * In that case, add the items to this list temporarily and iterate
+	 * without holding idev->lock. See addrconf_ifdown and dev_forward_change.
+	 */
+	struct list_head	if_list_aux;
 
 	struct list_head	tmp_list;
 	struct inet6_ifaddr	*ifpub;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..72790d1934c7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -800,6 +800,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 {
 	struct net_device *dev;
 	struct inet6_ifaddr *ifa;
+	LIST_HEAD(tmp_addr_list);
 
 	if (!idev)
 		return;
@@ -818,14 +819,23 @@ static void dev_forward_change(struct inet6_dev *idev)
 		}
 	}
 
+	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa->flags&IFA_F_TENTATIVE)
 			continue;
+		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
+	}
+	read_unlock_bh(&idev->lock);
+
+	while (!list_empty(&tmp_addr_list)) {
+		ifa = list_first_entry(&tmp_addr_list, struct inet6_ifaddr, if_list_aux);
+		list_del(&ifa->if_list_aux);
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else
 			addrconf_leave_anycast(ifa);
 	}
+
 	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 				     NETCONFA_FORWARDING,
 				     dev->ifindex, &idev->cnf);
@@ -3730,10 +3740,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
 	struct net *net = dev_net(dev);
 	struct inet6_dev *idev;
-	struct inet6_ifaddr *ifa, *tmp;
+	struct inet6_ifaddr *ifa;
 	bool keep_addr = false;
 	bool was_ready;
 	int state, i;
+	LIST_HEAD(tmp_addr_list);
 
 	ASSERT_RTNL();
 
@@ -3822,16 +3833,23 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 		write_lock_bh(&idev->lock);
 	}
 
-	list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list) {
+	list_for_each_entry(ifa, &idev->addr_list, if_list) {
+		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
+	}
+	write_unlock_bh(&idev->lock);
+
+	while (!list_empty(&tmp_addr_list)) {
 		struct fib6_info *rt = NULL;
 		bool keep;
 
+		ifa = list_first_entry(&tmp_addr_list, struct inet6_ifaddr, if_list_aux);
+		list_del(&ifa->if_list_aux);
+
 		addrconf_del_dad_work(ifa);
 
 		keep = keep_addr && (ifa->flags & IFA_F_PERMANENT) &&
 			!addr_is_local(&ifa->addr);
 
-		write_unlock_bh(&idev->lock);
 		spin_lock_bh(&ifa->lock);
 
 		if (keep) {
@@ -3862,15 +3880,14 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 			addrconf_leave_solict(ifa->idev, &ifa->addr);
 		}
 
-		write_lock_bh(&idev->lock);
 		if (!keep) {
+			write_lock_bh(&idev->lock);
 			list_del_rcu(&ifa->if_list);
+			write_unlock_bh(&idev->lock);
 			in6_ifa_put(ifa);
 		}
 	}
 
-	write_unlock_bh(&idev->lock);
-
 	/* Step 5: Discard anycast and multicast list */
 	if (unregister) {
 		ipv6_ac_destroy_dev(idev);
-- 
2.35.1

