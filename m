Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B09247DE
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 08:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfEUGPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 02:15:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40566 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbfEUGPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 02:15:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id 15so1496120wmg.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 23:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wVURcngxHaUKK2/6DcO63462w2MMfQtg1uggxqLYhQw=;
        b=dEUklpcSZJw0JKdU1qOtpFIq2HjB90fX/plfKjqUeat+/giiCHodVyp/Z1mw23OH6S
         aOSs2njV6rbNgWJnxwjlGJkXDbNb5q4WWJetyHRVEbmJD68d0K3NteaH+L5XSBibmaGb
         xbu4cHE+H9CRpnI5uKtMEVYmVRTJaMiwQc/qi9AxQsw5g+ZrLfYAJQFbOE36O6Q7zgrw
         fn3E4uq/VlR13yQFfML58qqB4m1989AOXRi0SWVPwLb4t1//Ahcz1F3PNjQckfgH11tj
         JaqQJv2HuxFMrJ9mxazFaJSriCE+9mFFFHemZHfkIBSkeWxKfdhPasGJ3aRzBC7w5Q1f
         dwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wVURcngxHaUKK2/6DcO63462w2MMfQtg1uggxqLYhQw=;
        b=apXUkbgRSa0V/eymGPZrK+WmAAWNL2jlERfTlyJbSbztqPF3Kb6vcYYMCZGmOsjVu0
         YRbrD9JLX7CERt9GR6W1j3Gy94ZVYcEqZY0bP7W4BtC4qd2yQ7Y3uLJXHb92Vzk6Zyzo
         UleAHL45eDDrk5K36YBHS6BkQVFtJszlq4lSnv0ezCmTY7Sz2qZ0TgIs7/BsitTrC3tY
         DVDRVgFHXexlEDNjHNGbb0+BV/O7QqU8nmGOMazhRTat/wxDhr9arILM+H6et+rlAauH
         bsvxHWlC7vNXGCIUOmgtYxTGtEYkLzU9gVtCMSzco46bi+2qgo1lE0F8lHWb96TMYx2L
         0IOw==
X-Gm-Message-State: APjAAAUrFHh73t+GKwJoYVPLAXyshejzYlmW+e3md0sryk8EcrVU8LwK
        iDI93xlVTDy39e8zg71MLaL+zA==
X-Google-Smtp-Source: APXvYqx0iy748Edu6ClBYQEDwgmMkaq7Im/sFwn2kAs5W3W6NItdo3My9kmAFcXEZSwBc2FCIG8f8Q==
X-Received: by 2002:a1c:6342:: with SMTP id x63mr2082200wmb.58.1558419337178;
        Mon, 20 May 2019 23:15:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t13sm43781124wra.81.2019.05.20.23.15.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 23:15:36 -0700 (PDT)
Date:   Tue, 21 May 2019 08:15:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190521061536.GB2210@nanopsycho.orion>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho>
 <20190520090405.69b419e5@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520090405.69b419e5@hermes.lan>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 20, 2019 at 06:04:05PM CEST, stephen@networkplumber.org wrote:
>On Mon, 20 May 2019 11:11:05 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
>> >When a device is stacked like (team, bonding, failsafe or netvsc) the
>> >XDP generic program for the parent device is not called.  In these
>> >cases, the rx handler changes skb->dev to its own in the receive
>> >handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
>> >do_xdp_generic if necessary before starting another round.
>> >
>> >Review of all the places RX_HANDLER_ANOTHER is returned
>> >show that the current devices do correctly change skb->dev.
>> >
>> >There was an older patch that got abandoned that did the
>> >same thing, this is just a rewrite.
>> >
>> >Suggested-by: Jason Wang <jasowang@redhat.com>
>> >Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
>> >Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>> >Acked-by: Jason Wang <jasowang@redhat.com>
>> >---
>> > net/core/dev.c | 10 ++++++++++
>> > 1 file changed, 10 insertions(+)
>> >
>> >diff --git a/net/core/dev.c b/net/core/dev.c
>> >index b6b8505cfb3e..240d0b2de1a8 100644
>> >--- a/net/core/dev.c
>> >+++ b/net/core/dev.c
>> >@@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>> > 			ret = NET_RX_SUCCESS;
>> > 			goto out;
>> > 		case RX_HANDLER_ANOTHER:
>> >+			if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> >+				struct bpf_prog *xdp_prog;
>> >+
>> >+				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
>> >+				ret = do_xdp_generic(xdp_prog, skb);
>> >+				if (ret != XDP_PASS) {
>> >+					ret = NET_RX_SUCCESS;
>> >+					goto out;
>> >+				}
>> >+			}  
>> 
>> I'm always scarred of changes like this. The history tells us that this
>> codepaths are very fragile. It took us non-trivial efford to fix bonding
>> here, not to mention vlans (that was pain).
>> 
>> The reason for troubles was often fact that different flows were treated
>> differently (vlan accel/non-accel).
>> 
>> This patch calls do_xdp_generic for master device in different point in
>> the receive patch comparing to lower device. Would it be possible to
>> unify this? E.g. by moving do_xdp_generice() call from
>> netif_rx_internal()/netif_receive_skb_internal() here,
>> to the beginning of __netif_receive_skb_core()?
>> 
>
>I am trying that now. But one problem is that it would break the case
>where XDP was being run on one leg of a bridge. For example if eth1 is
>part of br0; then it would no longer be possible to run XDP on eth1.

I don't see why not. The xdp is still run in __netif_receive_skb_core()
before goto another_round.

I was thinking about patch similar to this:

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..4c3fdda85544 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		/* Consider XDP consuming the packet a success from
-		 * the netdev point of view we do not want to count
-		 * this as an error.
-		 */
-		if (ret != XDP_PASS)
-			return NET_RX_SUCCESS;
-	}
-
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4858,6 +4841,19 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	__this_cpu_inc(softnet_data.processed);
 
+	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		int ret2;
+
+		preempt_disable();
+		rcu_read_lock();
+		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		rcu_read_unlock();
+		preempt_enable();
+
+		if (ret2 != XDP_PASS)
+			return NET_RX_DROP;
+	}
+
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
@@ -5178,19 +5174,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		if (ret != XDP_PASS)
-			return NET_RX_DROP;
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
@@ -5224,21 +5207,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 	}
 	list_splice_init(&sublist, head);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		preempt_disable();
-		rcu_read_lock();
-		list_for_each_entry_safe(skb, next, head, list) {
-			xdp_prog = rcu_dereference(skb->dev->xdp_prog);
-			skb_list_del_init(skb);
-			if (do_xdp_generic(xdp_prog, skb) == XDP_PASS)
-				list_add_tail(&skb->list, &sublist);
-		}
-		rcu_read_unlock();
-		preempt_enable();
-		/* Put passed packets back on main list */
-		list_splice_init(&sublist, head);
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
