Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E52178D12
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbgCDJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:07:20 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37903 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDJHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:07:19 -0500
Received: by mail-qt1-f193.google.com with SMTP id e20so797915qto.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 01:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tOpmSt9sLdLB/r3Ii7FPgJfG6o177dUkbEbhHWalFfU=;
        b=tUFjfljolIP2oMYMge5W4693kSY95ptx+o5+JK2bb3kTibaqM3kxuFy34aQ/C197Ea
         LdWs0CjdJxRZR/7eKdeZ3UYtapWPUb5OMspiIWR6GJ6McAhLK+Ml16xDsGAvPxLdHJsN
         5hBCTkWVEy7IkzaNwq3OpLRmQxReClyITW5EUTqpEvXeoqE7/7n5r8PTtu80o8iTIEO4
         JJBypeniu1rEuoNmxMUF35fZSbnoTh62ELAvR5opjBqTr3nw+YYQASJ/G2qAy5od1dGi
         s/62Nk55q5nQZMrcxL/9md/sTwOTxU88UkSfQnzdXPEqvHDJzXNQdNIbxPu6QkTDcMtw
         syxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tOpmSt9sLdLB/r3Ii7FPgJfG6o177dUkbEbhHWalFfU=;
        b=pW5hTAuSZaUdWZNEWfegVtQgpzIgwU0cQI9MNnpTqRSPwNviPtREJCcRUGdAgi4IBq
         x5lnB7/gG9zaYzLTXNm/2o8sn/6HpjfFa3zslAPtmHM9QHik67xpt2c0choQoZ8Po5Ip
         MVoXrnRJKeE1BwQOsLVWXMs0sg4LRHeq0wsRYaJzMpOZEWLFQBvZblTMrYa3EfNHgk1q
         XSZazOwoKSTDj1wIqHYNQUh+nR+fpH847Fmqqdi0RSwN7FcuDAvOOzvg0Hp1zD0i9SNO
         hby1cGQQhvZgTnY0w6ducEKX+y06h2pC/aAzyN4iX7naiHwGSn1cIdo3lsXZPDOQxfKR
         GhMA==
X-Gm-Message-State: ANhLgQ0Zakly63QHPwChwVidPigx1fgO44B3BsPV1dAAXldmKovFzZNB
        PTv7W215yC6v3cdbf6m9cb8=
X-Google-Smtp-Source: ADFU+vvdymPmPU50iBx9ZcAUdZfM6XK2BdSkF+PU/fbGxbUxPySYdRO4qrumJARAIpY5OW6jPj7r1g==
X-Received: by 2002:ac8:7210:: with SMTP id a16mr1533692qtp.167.1583312838158;
        Wed, 04 Mar 2020 01:07:18 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a141sm13903736qkb.50.2020.03.04.01.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:07:17 -0800 (PST)
Date:   Wed, 4 Mar 2020 17:07:10 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 08:44:29AM +0100, Rafał Miłecki wrote:
> > Hi Rafał,
> > 
> > When review the code, I got confused. On the latest net code, we only
> > add the allrouter address to multicast list in function
> > 1) ipv6_add_dev(), which only called when there is no idev. But link down and
> >     up would not re-create idev.
> > 2) dev_forward_change(), which only be called during forward change, this
> >     function will handle add/remove allrouter address correctly.
> 
> Sharp eye! You're right, I tracked (with just a pr_info) all usages of
> in6addr_linklocal_allrouters and none gets triggered during my testing
> routine. I'm wondering if I should start blaming my OpenWrt user space
> now.

Yeah...Hope you could help dig more.
> 
> 
> > So I still don't know how you could added the ff02::2 on same dev multi times.
> > Does just do `ip link set $dev down; ip link set $dev up` reproduce your
> > problem? Or did I miss something?
> 
> A bit old-fashioned with ifconfig but basically yes, that's my test:
> 
> iw phy phy0 interface add mon-phy0 type monitor

What does this step do? Is there a corresponding command for ip link?

> for i in $(seq 1 10); do ifconfig mon-phy0 up; ifconfig mon-phy0 down; done
> iw dev mon-phy0 del

The other cmd looks normal. BTW, I have create a new patch. The previous one
will leak ff01::1, ff02::1, ff01::2 as the link up will not re-add them.

The new patch will join and leave all node/route address when link up/down
instead of store them. But I don't think it could resolve your issue as the
code logic is not changed. If you like, you can have a try.

Thanks
Hangbin

From 9cf504dc30198133e470ea783c3fa53a8f56a20a Mon Sep 17 00:00:00 2001
From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 3 Mar 2020 20:58:39 +0800
Subject: [PATCH] ipv6/mcast: join and leave allnodes, allrouters addresses
 when link up/down

This patch fixes two issues:

1) When link up with IPv6 forwarding enabled, we forgot to join
sitelocal_allrouters(ff01::2) and interfacelocal_allrouters(ff05::2),
like what we do in function dev_forward_change()

2) When link down, there is no listener for the allnodes, allrouters
addresses. So we should remove them instead of storing the info in
idev->mc_tomb.

To fix these two issue, I add two new functions ipv6_mc_join_localaddr()
and ipv6_mc_leave_localaddr() to handle these addresses. And just join
leave the group in ipv6_mc_{up, down}.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 22 +++++++---------------
 net/ipv6/mcast.c    | 45 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 164c71c54b5c..8e39f569beaa 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -449,16 +449,6 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	/* protected by rtnl_lock */
 	rcu_assign_pointer(dev->ip6_ptr, ndev);
 
-	/* Join interface-local all-node multicast group */
-	ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
-
-	/* Join all-node multicast group */
-	ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
-
-	/* Join all-router multicast group if forwarding is set */
-	if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
-		ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
-
 	return ndev;
 
 err_release:
@@ -481,7 +471,7 @@ static struct inet6_dev *ipv6_find_idev(struct net_device *dev)
 			return idev;
 	}
 
-	if (dev->flags&IFF_UP)
+	if (dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
 		ipv6_mc_up(idev);
 	return idev;
 }
@@ -795,7 +785,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 	dev = idev->dev;
 	if (idev->cnf.forwarding)
 		dev_disable_lro(dev);
-	if (dev->flags & IFF_MULTICAST) {
+	if (dev->flags & IFF_UP && dev->flags & IFF_MULTICAST) {
 		if (idev->cnf.forwarding) {
 			ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
 			ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allrouters);
@@ -3554,7 +3544,8 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			}
 
 			if (!IS_ERR_OR_NULL(idev)) {
-				if (idev->if_flags & IF_READY) {
+				if (idev->if_flags & IF_READY &&
+				    dev->flags & IFF_MULTICAST) {
 					/* device is already configured -
 					 * but resend MLD reports, we might
 					 * have roamed and need to update
@@ -3839,8 +3830,9 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	/* Step 5: Discard anycast and multicast list */
 	if (how) {
 		ipv6_ac_destroy_dev(idev);
-		ipv6_mc_destroy_dev(idev);
-	} else {
+		if (dev->flags & IFF_MULTICAST)
+			ipv6_mc_destroy_dev(idev);
+	} else if (dev->flags & IFF_MULTICAST){
 		ipv6_mc_down(idev);
 	}
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index eaa4c2cc2fbb..1512ca906b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2529,11 +2529,44 @@ void ipv6_mc_remap(struct inet6_dev *idev)
 
 /* Device going down */
 
+static void ipv6_mc_join_localaddr(struct inet6_dev *idev)
+{
+	struct net_device *dev;
+
+	dev = idev->dev;
+
+	/* Join interface-local all-node multicast group */
+	ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
+
+	/* Join all-node multicast group */
+	ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
+
+	/* Join all-router multicast group if forwarding is set */
+	if (idev->cnf.forwarding) {
+		ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allrouters);
+		ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+		ipv6_dev_mc_inc(dev, &in6addr_sitelocal_allrouters);
+	}
+}
+
+static void ipv6_mc_leave_localaddr(struct inet6_dev *idev)
+{
+	__ipv6_dev_mc_dec(idev, &in6addr_interfacelocal_allnodes);
+	__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allnodes);
+
+	if (idev->cnf.forwarding) {
+		__ipv6_dev_mc_dec(idev, &in6addr_interfacelocal_allrouters);
+		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
+		__ipv6_dev_mc_dec(idev, &in6addr_sitelocal_allrouters);
+	}
+}
+
 void ipv6_mc_down(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *i;
 
 	/* Withdraw multicast list */
+	ipv6_mc_leave_localaddr(idev);
 
 	read_lock_bh(&idev->lock);
 
@@ -2564,7 +2597,7 @@ void ipv6_mc_up(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *i;
 
-	/* Install multicast list, except for all-nodes (already installed) */
+	ipv6_mc_join_localaddr(idev);
 
 	read_lock_bh(&idev->lock);
 	ipv6_mc_reset(idev);
@@ -2603,16 +2636,6 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 	ipv6_mc_down(idev);
 	mld_clear_delrec(idev);
 
-	/* Delete all-nodes address. */
-	/* We cannot call ipv6_dev_mc_dec() directly, our caller in
-	 * addrconf.c has NULL'd out dev->ip6_ptr so in6_dev_get() will
-	 * fail.
-	 */
-	__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allnodes);
-
-	if (idev->cnf.forwarding)
-		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
-
 	write_lock_bh(&idev->lock);
 	while ((i = idev->mc_list) != NULL) {
 		idev->mc_list = i->next;
-- 
2.19.2

