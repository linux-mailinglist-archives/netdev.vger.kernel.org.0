Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EB94DCA95
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiCQP6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiCQP6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:58:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F63320DB33
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:56:57 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dr20so11369102ejc.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIvP/sjfCCOaSecPV1e4U9S9D1AxhN2Mn1BcGkEBp70=;
        b=ZRP6UiTeC2MKUhfRkrz/p7+HudAQbpQQIZVIP9ojsN2JCyRxQ6ZLsoNp7mnYW3f1HO
         LsbLhyQn0DQ2hGvGUmTuTU08cHYAJxzWFt+XqGOe02nFejd7lzye7vUYsOQBazki3YxW
         /RWIxOuomUf/gl7ndDr2u/1b9ilrJOuYxEOqJB58ouUnrqPk5jyDkFXi5hdP6pSvzeb+
         Qx2rcoTjTK8EiMD6qHJe0RoTiDiKZToqBA3ClJyaiOzNbLzkIz9R+z00ndwD10ZBrf5z
         PrV/ezlgn2Oq8wq6hd/pD3hbgBxLo+tDfnd1CW5QDQ+H3ps00vLISjwulZMRLIHBUXRZ
         xs6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIvP/sjfCCOaSecPV1e4U9S9D1AxhN2Mn1BcGkEBp70=;
        b=wwPdiW0EHtuZjG9XKz1HKUulCj/FOPwGmMUhgZpVbhlDZXmaG4ZU+5zzNV6DTkBNBc
         R3t/T2m5u7im2v4NIccPaf4U9rCFwDXg38GYBp7gYL8C42EqSY9B28I4iA5rb6EXuWAo
         jQlMR/8CgjtS8wgnoF6hUlLQqnZxRJAGFexAZtvLhx6EVaVwWfo7Htx2/AQkMDoKIb5Z
         GnZDGFpvU39tfFenPl4mdJYmMrpFVqzxNC/lm23SPdCEPgXyPGaBmv2/LsYVzoE4UYSW
         r19IdHeQ+iM/QkK2SDnfHZG/1e18BsocsDnvGlzotax7R1mCbDjls/YDrUrajZdyp32F
         MSLA==
X-Gm-Message-State: AOAM531NhCDk+KpUPEIFuDR3HCfe/Qjyew5Id9I3IqHqNOIUiOjmn/FV
        9Mi0uwbRPthqSBoGfe/7If/EGPzQriUlVw==
X-Google-Smtp-Source: ABdhPJzL+Ey/NboFUiTxC99sXhsyf0JUhfq0qhbbrC3vMlbTI/GIWpEJVVXi0oTvf3FINMzrVF7Puw==
X-Received: by 2002:a17:907:7255:b0:6df:6b81:3872 with SMTP id ds21-20020a170907725500b006df6b813872mr5086423ejc.461.1647532615579;
        Thu, 17 Mar 2022 08:56:55 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906395600b006cec40b9cf0sm2558790eje.92.2022.03.17.08.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 08:56:55 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH v2] ipv6: acquire write lock for addr_list in dev_forward_change
Date:   Thu, 17 Mar 2022 16:56:37 +0100
Message-Id: <20220317155637.29733-1-dossche.niels@gmail.com>
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

No path towards dev_forward_change (common ancestor of paths is in
addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
We need to hold the lock during the whole loop in dev_forward_change.
__ipv6_dev_ac_{inc,dec} both acquire the write lock on idev->lock in
their function body. Since addrconf_{join,leave}_anycast call to
__ipv6_dev_ac_inc and __ipv6_dev_ac_dec respectively, we need to move
the responsibility of locking upwards.

This patch moves the locking up. For __ipv6_dev_ac_dec, there is one
place where the caller can directly acquire the idev->lock, that is in
ipv6_dev_ac_dec. The other caller is addrconf_leave_anycast, which now
needs to be called under idev->lock, and thus it becomes the
responsibility of the callers of addrconf_leave_anycast to hold that
lock. For __ipv6_dev_ac_inc, there are also 2 callers, one is
ipv6_sock_ac_join, which can acquire the lock during the call to
__ipv6_dev_ac_inc. The other caller is addrconf_join_anycast, which now
needs to be called under idev->lock, and thus it becomes the
responsibility of the callers of addrconf_join_anycast to hold that
lock.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---

Changes in v2:
 - Move the locking upwards

 net/ipv6/addrconf.c | 21 ++++++++++++++++-----
 net/ipv6/anycast.c  | 37 ++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..69e9f81e2045 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -818,6 +818,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 		}
 	}
 
+	write_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa->flags&IFA_F_TENTATIVE)
 			continue;
@@ -826,6 +827,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 		else
 			addrconf_leave_anycast(ifa);
 	}
+	write_unlock_bh(&idev->lock);
 	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 				     NETCONFA_FORWARDING,
 				     dev->ifindex, &idev->cnf);
@@ -2191,7 +2193,7 @@ void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr)
 	__ipv6_dev_mc_dec(idev, &maddr);
 }
 
-/* caller must hold RTNL */
+/* caller must hold RTNL and write lock idev->lock */
 static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
 {
 	struct in6_addr addr;
@@ -2204,7 +2206,7 @@ static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
 	__ipv6_dev_ac_inc(ifp->idev, &addr);
 }
 
-/* caller must hold RTNL */
+/* caller must hold RTNL and write lock idev->lock */
 static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
 {
 	struct in6_addr addr;
@@ -3857,8 +3859,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 			__ipv6_ifa_notify(RTM_DELADDR, ifa);
 			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
 		} else {
-			if (idev->cnf.forwarding)
+			if (idev->cnf.forwarding) {
+				write_lock_bh(&idev->lock);
 				addrconf_leave_anycast(ifa);
+				write_unlock_bh(&idev->lock);
+			}
 			addrconf_leave_solict(ifa->idev, &ifa->addr);
 		}
 
@@ -6136,16 +6141,22 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 				&ifp->addr, ifp->idev->dev->name);
 		}
 
-		if (ifp->idev->cnf.forwarding)
+		if (ifp->idev->cnf.forwarding) {
+			write_lock_bh(&ifp->idev->lock);
 			addrconf_join_anycast(ifp);
+			write_unlock_bh(&ifp->idev->lock);
+		}
 		if (!ipv6_addr_any(&ifp->peer_addr))
 			addrconf_prefix_route(&ifp->peer_addr, 128,
 					      ifp->rt_priority, ifp->idev->dev,
 					      0, 0, GFP_ATOMIC);
 		break;
 	case RTM_DELADDR:
-		if (ifp->idev->cnf.forwarding)
+		if (ifp->idev->cnf.forwarding) {
+			write_lock_bh(&ifp->idev->lock);
 			addrconf_leave_anycast(ifp);
+			write_unlock_bh(&ifp->idev->lock);
+		}
 		addrconf_leave_solict(ifp->idev, &ifp->addr);
 		if (!ipv6_addr_any(&ifp->peer_addr)) {
 			struct fib6_info *rt;
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index dacdea7fcb62..f3017ed6f005 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -136,7 +136,9 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 			goto error;
 	}
 
+	write_lock_bh(&idev->lock);
 	err = __ipv6_dev_ac_inc(idev, addr);
+	write_unlock_bh(&idev->lock);
 	if (!err) {
 		pac->acl_next = np->ipv6_ac_list;
 		np->ipv6_ac_list = pac;
@@ -280,41 +282,35 @@ static struct ifacaddr6 *aca_alloc(struct fib6_info *f6i,
 
 /*
  *	device anycast group inc (add if not found)
+ *	caller must hold write lock idev->lock
  */
 int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr)
 {
 	struct ifacaddr6 *aca;
 	struct fib6_info *f6i;
 	struct net *net;
-	int err;
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&idev->lock);
-	if (idev->dead) {
-		err = -ENODEV;
-		goto out;
-	}
+	if (idev->dead)
+		return -ENODEV;
 
 	for (aca = idev->ac_list; aca; aca = aca->aca_next) {
 		if (ipv6_addr_equal(&aca->aca_addr, addr)) {
 			aca->aca_users++;
-			err = 0;
-			goto out;
+			return 0;
 		}
 	}
 
 	net = dev_net(idev->dev);
 	f6i = addrconf_f6i_alloc(net, idev, addr, true, GFP_ATOMIC);
 	if (IS_ERR(f6i)) {
-		err = PTR_ERR(f6i);
-		goto out;
+		return PTR_ERR(f6i);
 	}
 	aca = aca_alloc(f6i, addr);
 	if (!aca) {
 		fib6_info_release(f6i);
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	aca->aca_next = idev->ac_list;
@@ -324,7 +320,6 @@ int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr)
 	 * it is already exposed via idev->ac_list.
 	 */
 	aca_get(aca);
-	write_unlock_bh(&idev->lock);
 
 	ipv6_add_acaddr_hash(net, aca);
 
@@ -334,13 +329,11 @@ int __ipv6_dev_ac_inc(struct inet6_dev *idev, const struct in6_addr *addr)
 
 	aca_put(aca);
 	return 0;
-out:
-	write_unlock_bh(&idev->lock);
-	return err;
 }
 
 /*
  *	device anycast group decrement
+ *	caller must hold write lock idev->lock
  */
 int __ipv6_dev_ac_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
@@ -348,7 +341,6 @@ int __ipv6_dev_ac_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&idev->lock);
 	prev_aca = NULL;
 	for (aca = idev->ac_list; aca; aca = aca->aca_next) {
 		if (ipv6_addr_equal(&aca->aca_addr, addr))
@@ -356,18 +348,15 @@ int __ipv6_dev_ac_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 		prev_aca = aca;
 	}
 	if (!aca) {
-		write_unlock_bh(&idev->lock);
 		return -ENOENT;
 	}
 	if (--aca->aca_users > 0) {
-		write_unlock_bh(&idev->lock);
 		return 0;
 	}
 	if (prev_aca)
 		prev_aca->aca_next = aca->aca_next;
 	else
 		idev->ac_list = aca->aca_next;
-	write_unlock_bh(&idev->lock);
 	ipv6_del_acaddr_hash(aca);
 	addrconf_leave_solict(idev, &aca->aca_addr);
 
@@ -381,10 +370,16 @@ int __ipv6_dev_ac_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 static int ipv6_dev_ac_dec(struct net_device *dev, const struct in6_addr *addr)
 {
 	struct inet6_dev *idev = __in6_dev_get(dev);
+	int ret;
 
 	if (!idev)
 		return -ENODEV;
-	return __ipv6_dev_ac_dec(idev, addr);
+
+	write_lock_bh(&idev->lock);
+	ret = __ipv6_dev_ac_dec(idev, addr);
+	write_unlock_bh(&idev->lock);
+
+	return ret;
 }
 
 void ipv6_ac_destroy_dev(struct inet6_dev *idev)
-- 
2.35.1

