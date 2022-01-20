Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F071495372
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiATRlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiATRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:41:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFEFC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:41:17 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h12so6552764pjq.3
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3kUUwNCowam3fr3kqfY4+RrU0g99dQWocs2HHaQODEY=;
        b=DUeJl+28uWZiMTg2yNf0fdPbWO6/GZcGfplndEVPy0YECaLtAD4OdUrKsT0Lxm9ltq
         uVNJOEDY2KcONovJqTDu/YAN4llT01l9bL/rgX7RpsdzKlOi/okuqiGuUrnr9JyVkMHV
         jx1RNTutAASdCHZP1IhT8GgHylcSzG0khsNehRP/F0Ljd8VZEeqES7kl6XgzhTnwK6GV
         54Zsf85IuiMGHA97uTmJqSdws6NYk0OHgalKaRM/4ARlOtFv9RLPNkR/z46GPzG26Prh
         5uQOv8KNVefulYmPyhPhxBR7ThBf2ogZgimCzRJYad25m+sUaa36xadGGfelCs/ridfM
         917Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3kUUwNCowam3fr3kqfY4+RrU0g99dQWocs2HHaQODEY=;
        b=sXyXkfAh12wzGrCZE+N3b1OOueHg3fsAnM8XyIGXNbB/ZJvCLvdDo2snb3ZkUZW4FL
         F0eIUt6EYqWyA3L5gg9yRVKC2jksdK3meF6CZClviUr1VJHrjVRM2FSq0hgWupA5ittN
         gNYCZ6bHwSVCFohbwPddn9dnhQrDZksQqNv0AZ9ICqa86AskCeXM7jQ6PzEYuwCVT6yO
         /jotSdgD9YdnLNj1WRj/uI+OAC+IZaiWQXCs6PSk5w2wVKDQEZU2tZT4F5bowanHMo9T
         32ZFc1I2rQizwd2sNwdKok7M7u+lA5pO37Qtptx5S4AanKCmPVwN6beCx53b7RW+mfpW
         jftQ==
X-Gm-Message-State: AOAM531QNlyzpD0aftCQ61pc82Behc3UFc/2fr2JjjocU7Q6H8s5rKnu
        3J3CocKzUCn3dPi9USoac1s=
X-Google-Smtp-Source: ABdhPJwkrDrTNG3NKcq2utCutWjYxJV+kbz+vOdZEGylHjcHy7dMWUQkheCHp5YrMzqEub1yHd4aOA==
X-Received: by 2002:a17:902:d50d:b0:14a:4ed2:2a18 with SMTP id b13-20020a170902d50d00b0014a4ed22a18mr149594plg.44.1642700477293;
        Thu, 20 Jan 2022 09:41:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ae92:8e2f:dc6d:1317])
        by smtp.gmail.com with ESMTPSA id v4sm8885540pjo.27.2022.01.20.09.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:41:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ipv6: annotate accesses to fn->fn_sernum
Date:   Thu, 20 Jan 2022 09:41:12 -0800
Message-Id: <20220120174112.1126644-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

struct fib6_node's fn_sernum field can be
read while other threads change it.

Add READ_ONCE()/WRITE_ONCE() annotations.

Do not change existing smp barriers in fib6_get_cookie_safe()
and __fib6_update_sernum_upto_root()

syzbot reported:

BUG: KCSAN: data-race in fib6_clean_node / inet6_csk_route_socket

write to 0xffff88813df62e2c of 4 bytes by task 1920 on cpu 1:
 fib6_clean_node+0xc2/0x260 net/ipv6/ip6_fib.c:2178
 fib6_walk_continue+0x38e/0x430 net/ipv6/ip6_fib.c:2112
 fib6_walk net/ipv6/ip6_fib.c:2160 [inline]
 fib6_clean_tree net/ipv6/ip6_fib.c:2240 [inline]
 __fib6_clean_all+0x1a9/0x2e0 net/ipv6/ip6_fib.c:2256
 fib6_flush_trees+0x6c/0x80 net/ipv6/ip6_fib.c:2281
 rt_genid_bump_ipv6 include/net/net_namespace.h:488 [inline]
 addrconf_dad_completed+0x57f/0x870 net/ipv6/addrconf.c:4230
 addrconf_dad_work+0x908/0x1170
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:359
 ret_from_fork+0x1f/0x30

read to 0xffff88813df62e2c of 4 bytes by task 15701 on cpu 0:
 fib6_get_cookie_safe include/net/ip6_fib.h:285 [inline]
 rt6_get_cookie include/net/ip6_fib.h:306 [inline]
 ip6_dst_store include/net/ip6_route.h:234 [inline]
 inet6_csk_route_socket+0x352/0x3c0 net/ipv6/inet6_connection_sock.c:109
 inet6_csk_xmit+0x91/0x1e0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0x1323/0x1840 net/ipv4/tcp_output.c:1402
 tcp_transmit_skb net/ipv4/tcp_output.c:1420 [inline]
 tcp_write_xmit+0x1450/0x4460 net/ipv4/tcp_output.c:2680
 __tcp_push_pending_frames+0x68/0x1c0 net/ipv4/tcp_output.c:2864
 tcp_push+0x2d9/0x2f0 net/ipv4/tcp.c:725
 mptcp_push_release net/mptcp/protocol.c:1491 [inline]
 __mptcp_push_pending+0x46c/0x490 net/mptcp/protocol.c:1578
 mptcp_sendmsg+0x9ec/0xa50 net/mptcp/protocol.c:1764
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:643
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 kernel_sendmsg+0x97/0xd0 net/socket.c:745
 sock_no_sendpage+0x84/0xb0 net/core/sock.c:3086
 inet_sendpage+0x9d/0xc0 net/ipv4/af_inet.c:834
 kernel_sendpage+0x187/0x200 net/socket.c:3492
 sock_sendpage+0x5a/0x70 net/socket.c:1007
 pipe_to_sendpage+0x128/0x160 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x207/0x500 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x94/0xd0 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x80/0xa0 fs/splice.c:936
 splice_direct_to_actor+0x345/0x650 fs/splice.c:891
 do_splice_direct+0x106/0x190 fs/splice.c:979
 do_sendfile+0x675/0xc40 fs/read_write.c:1245
 __do_sys_sendfile64 fs/read_write.c:1310 [inline]
 __se_sys_sendfile64 fs/read_write.c:1296 [inline]
 __x64_sys_sendfile64+0x102/0x140 fs/read_write.c:1296
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000026f -> 0x00000271

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 15701 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

The Fixes tag I chose is probably arbitrary, I do not think
we need to backport this patch to older kernels.

Fixes: c5cff8561d2d ("ipv6: add rcu grace period before freeing fib6_node")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/ip6_fib.h |  2 +-
 net/ipv6/ip6_fib.c    | 23 +++++++++++++----------
 net/ipv6/route.c      |  2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index a9a4ccc0cdb5fd637094b0b5533a109ee3f60702..40ae8f1b18e502cece9f11b3a60c9cc30c2e1a5e 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -282,7 +282,7 @@ static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
 	fn = rcu_dereference(f6i->fib6_node);
 
 	if (fn) {
-		*cookie = fn->fn_sernum;
+		*cookie = READ_ONCE(fn->fn_sernum);
 		/* pairs with smp_wmb() in __fib6_update_sernum_upto_root() */
 		smp_rmb();
 		status = true;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 463c37dea449749ac0feedeb731b628b75133bba..413f66781e50de62d6b20042d84798e7da59165a 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -112,7 +112,7 @@ void fib6_update_sernum(struct net *net, struct fib6_info *f6i)
 	fn = rcu_dereference_protected(f6i->fib6_node,
 			lockdep_is_held(&f6i->fib6_table->tb6_lock));
 	if (fn)
-		fn->fn_sernum = fib6_new_sernum(net);
+		WRITE_ONCE(fn->fn_sernum, fib6_new_sernum(net));
 }
 
 /*
@@ -590,12 +590,13 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 		spin_unlock_bh(&table->tb6_lock);
 		if (res > 0) {
 			cb->args[4] = 1;
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = READ_ONCE(w->root->fn_sernum);
 		}
 	} else {
-		if (cb->args[5] != w->root->fn_sernum) {
+		int sernum = READ_ONCE(w->root->fn_sernum);
+		if (cb->args[5] != sernum) {
 			/* Begin at the root if the tree changed */
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = sernum;
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
@@ -1345,7 +1346,7 @@ static void __fib6_update_sernum_upto_root(struct fib6_info *rt,
 	/* paired with smp_rmb() in fib6_get_cookie_safe() */
 	smp_wmb();
 	while (fn) {
-		fn->fn_sernum = sernum;
+		WRITE_ONCE(fn->fn_sernum, sernum);
 		fn = rcu_dereference_protected(fn->parent,
 				lockdep_is_held(&rt->fib6_table->tb6_lock));
 	}
@@ -2174,8 +2175,8 @@ static int fib6_clean_node(struct fib6_walker *w)
 	};
 
 	if (c->sernum != FIB6_NO_SERNUM_CHANGE &&
-	    w->node->fn_sernum != c->sernum)
-		w->node->fn_sernum = c->sernum;
+	    READ_ONCE(w->node->fn_sernum) != c->sernum)
+		WRITE_ONCE(w->node->fn_sernum, c->sernum);
 
 	if (!c->func) {
 		WARN_ON_ONCE(c->sernum == FIB6_NO_SERNUM_CHANGE);
@@ -2543,7 +2544,7 @@ static void ipv6_route_seq_setup_walk(struct ipv6_route_iter *iter,
 	iter->w.state = FWS_INIT;
 	iter->w.node = iter->w.root;
 	iter->w.args = iter;
-	iter->sernum = iter->w.root->fn_sernum;
+	iter->sernum = READ_ONCE(iter->w.root->fn_sernum);
 	INIT_LIST_HEAD(&iter->w.lh);
 	fib6_walker_link(net, &iter->w);
 }
@@ -2571,8 +2572,10 @@ static struct fib6_table *ipv6_route_seq_next_table(struct fib6_table *tbl,
 
 static void ipv6_route_check_sernum(struct ipv6_route_iter *iter)
 {
-	if (iter->sernum != iter->w.root->fn_sernum) {
-		iter->sernum = iter->w.root->fn_sernum;
+	int sernum = READ_ONCE(iter->w.root->fn_sernum);
+
+	if (iter->sernum != sernum) {
+		iter->sernum = sernum;
 		iter->w.state = FWS_INIT;
 		iter->w.node = iter->w.root;
 		WARN_ON(iter->w.skip);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e6de94203c130c0a6fc6abca623790738df1e4fa..f4884cda13b92e72d041680cbabfee2e07ec0f10 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2802,7 +2802,7 @@ static void ip6_link_failure(struct sk_buff *skb)
 			if (from) {
 				fn = rcu_dereference(from->fib6_node);
 				if (fn && (rt->rt6i_flags & RTF_DEFAULT))
-					fn->fn_sernum = -1;
+					WRITE_ONCE(fn->fn_sernum, -1);
 			}
 		}
 		rcu_read_unlock();
-- 
2.34.1.703.g22d0c6ccf7-goog

