Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E324841F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfFQNew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:34:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39239 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfFQNev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:34:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so5844033pgc.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Now6OMzM6OwlkMFs1nAbCLQOAu56TiMqtI6Ie3PB/VY=;
        b=fbpnd9B5YhkDZcrs9vHc7VZN8NQJHwd2tOZTYp312NDDeT72kSQmHcwEumD0OSMrvV
         /K6xA2XO7hVnbGtMeN5XPoJkthmLRRjJvNpQS0UIJlLCzlAP3EKb9+td2Pxu5I9V4np8
         IzheEtRmebj7QI6gN4Kmk5pdjdTW4THlMNi2BDrTQhNWzErQCFiTvSBmifaDvG5t3ZH0
         tWWLm2PoJyFBOpSOfQrvzkWdkJhVgWByFsr++l92EQ9lB+mnRjoY9nzHd6SHMWlZ+Km+
         k2Qu54xvcv9krQ+rsi0unfBuKoPXkxD+l1IOA9N/ETi32d7l0H12Vp6kTv9SelOiQwMi
         1Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Now6OMzM6OwlkMFs1nAbCLQOAu56TiMqtI6Ie3PB/VY=;
        b=obd+OBZpDIrYFWVzPJDprxmMojUmWyeF4dQ9JoSiGhJPyTNd28DvRYQTdEW8zbUjCx
         RUbe9Lgy74L1QkOzBlPrriJf8Jh40AryTHFhzSshvaflejkf4A6pyslIlkATN3i/5e/J
         SxLN87BsyUK4EZnDIGuUVigPf7xeUv2nXe19PLrvlwCEB3lExzsftZo9HnO5O0LKxD94
         KB0+oxhLeRQTt6cxGpBxzxW9K2etDmIdAPG2iNDjs0Eq63ykT09gCLf7Hyj0hiloUWdJ
         5Dib1Cg7Jhv3WhCrD3pQ4T+PpXzySVo8HDhsiTbG1VJgEwDJfJQdFm2wltOqAeAVpwmz
         er5A==
X-Gm-Message-State: APjAAAWBUQwJKujUwJwPsCGZkrUoIcgBMVwwyMbOHIhEuOAo1ypUpY3+
        t8u1A2A92/WF8THKZyVm13dK4Q8i
X-Google-Smtp-Source: APXvYqze/DTZrCJjnvR/aEnVuNXaYQztY0RNDAYjwHi84n7IuWBkCmH0A6Ktq0OWVDe7+MIM2Yb3ug==
X-Received: by 2002:a65:5003:: with SMTP id f3mr48264273pgo.336.1560778490173;
        Mon, 17 Jun 2019 06:34:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm18142388pff.153.2019.06.17.06.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:34:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH net 3/3] tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
Date:   Mon, 17 Jun 2019 21:34:15 +0800
Message-Id: <789f1fa42423024861f811c237738a236605d35d.1560778340.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <92d40ac2577045f09a1d3ee79c7fed73fbdbde1a.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
 <89113721df2e1ea6f2ea9ecffe4024588f224dc3.1560778340.git.lucien.xin@gmail.com>
 <92d40ac2577045f09a1d3ee79c7fed73fbdbde1a.1560778340.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udp_tunnel(6)_xmit_skb() called by tipc_udp_xmit() expects a tunnel device
to count packets on dev->tstats, a perpcu variable. However, TIPC is using
udp tunnel with no tunnel device, and pass the lower dev, like veth device
that only initializes dev->lstats(a perpcu variable) when creating it.

Later iptunnel_xmit_stats() called by ip(6)tunnel_xmit() thinks the dev as
a tunnel device, and uses dev->tstats instead of dev->lstats. tstats' each
pointer points to a bigger struct than lstats, so when tstats->tx_bytes is
increased, other percpu variable's members could be overwritten.

syzbot has reported quite a few crashes due to fib_nh_common percpu member
'nhc_pcpu_rth_output' overwritten, call traces are like:

  BUG: KASAN: slab-out-of-bounds in rt_cache_valid+0x158/0x190
  net/ipv4/route.c:1556
    rt_cache_valid+0x158/0x190 net/ipv4/route.c:1556
    __mkroute_output net/ipv4/route.c:2332 [inline]
    ip_route_output_key_hash_rcu+0x819/0x2d50 net/ipv4/route.c:2564
    ip_route_output_key_hash+0x1ef/0x360 net/ipv4/route.c:2393
    __ip_route_output_key include/net/route.h:125 [inline]
    ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2651
    ip_route_output_key include/net/route.h:135 [inline]
  ...

or:

  kasan: GPF could be caused by NULL-ptr deref or user memory access
  RIP: 0010:dst_dev_put+0x24/0x290 net/core/dst.c:168
    <IRQ>
    rt_fibinfo_free_cpus net/ipv4/fib_semantics.c:200 [inline]
    free_fib_info_rcu+0x2e1/0x490 net/ipv4/fib_semantics.c:217
    __rcu_reclaim kernel/rcu/rcu.h:240 [inline]
    rcu_do_batch kernel/rcu/tree.c:2437 [inline]
    invoke_rcu_callbacks kernel/rcu/tree.c:2716 [inline]
    rcu_process_callbacks+0x100a/0x1ac0 kernel/rcu/tree.c:2697
  ...

The issue exists since tunnel stats update is moved to iptunnel_xmit by
Commit 039f50629b7f ("ip_tunnel: Move stats update to iptunnel_xmit()"),
and here to fix it by passing a NULL tunnel dev to udp_tunnel(6)_xmit_skb
so that the packets counting won't happen on dev->tstats.

Reported-by: syzbot+9d4c12bfd45a58738d0a@syzkaller.appspotmail.com
Reported-by: syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com
Reported-by: syzbot+c4c4b2bb358bb936ad7e@syzkaller.appspotmail.com
Reported-by: syzbot+0290d2290a607e035ba1@syzkaller.appspotmail.com
Reported-by: syzbot+a43d8d4e7e8a7a9e149e@syzkaller.appspotmail.com
Reported-by: syzbot+a47c5f4c6c00fc1ed16e@syzkaller.appspotmail.com
Fixes: 039f50629b7f ("ip_tunnel: Move stats update to iptunnel_xmit()")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/udp_media.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 7fc02d8..1405ccc 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -176,7 +176,6 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 			goto tx_error;
 		}
 
-		skb->dev = rt->dst.dev;
 		ttl = ip4_dst_hoplimit(&rt->dst);
 		udp_tunnel_xmit_skb(rt, ub->ubsock->sk, skb, src->ipv4.s_addr,
 				    dst->ipv4.s_addr, 0, ttl, 0, src->port,
@@ -195,10 +194,9 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 		if (err)
 			goto tx_error;
 		ttl = ip6_dst_hoplimit(ndst);
-		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb,
-					   ndst->dev, &src->ipv6,
-					   &dst->ipv6, 0, ttl, 0, src->port,
-					   dst->port, false);
+		err = udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
+					   &src->ipv6, &dst->ipv6, 0, ttl, 0,
+					   src->port, dst->port, false);
 #endif
 	}
 	return err;
-- 
2.1.0

