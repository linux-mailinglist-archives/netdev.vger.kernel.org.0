Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9630A3A9C4E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhFPNoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhFPNog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:44:36 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E845C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e33so2007580pgm.3
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXTM1b8THyqa8qKiYLuOS+TIsDovpLQlIiaOcv8qsm8=;
        b=qfPLGL/llb3MI9Drm+HvlE90hj1JmbyBGTrni3bJlA4FDw6G0OU7DBd3aq/zDZXi3y
         H+Avkmn4RM5+dmsLWpvkr3v90visTB1oFsNAH6uInWwPVqOS4alw04LGqj94+SRMEnSj
         M9Z/11bEx2Ox/UTAU+WE+27CyGdMjTOvuxN3ZlXBf83UbsgQICQv5Wutn/66TGcbs9+o
         wXUMuY+l3/5tgmlTti6XcNw4UO0kHoSbhoADWPXir9ZOwx8hbZ6dDPcM6UAc0qKu2xki
         RqC5rTDEOlMoKNuKwvSYvM7zJCrbhqsax/mJtUSn8iHcEa0RzpPYojw22Pc529NPPe6c
         aVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXTM1b8THyqa8qKiYLuOS+TIsDovpLQlIiaOcv8qsm8=;
        b=jKeIImlJw8YpGxOEG0qmHqyc4jRbgGKRRmZ1GOSD09VNf24ns2M9E7Prs30BgSqbZX
         PMon/nCuDfebKYymgWWQfPcWG9eQQWVGBM1kE47pfjvmAmmXwaAM9n5PE59G8RTQKOiM
         B+ZQOR3HQNxKE22RiEs9y2kvzNMdiWsBVvYvUN5VgHp7mhb480nXha1zfc320LvXdQ+x
         2JkkIjCXMWJWdL9V0Z4OROz7XUL1RyPH8JfPtxSDO0hKbwVqPmDGPHlNysNwlgr98wlp
         trwH9QTUF7sarqjT/Pd3Go2BRizQAo6nJOwMCbHcBtzs+sJikGugyZopukYInuj4K9Ir
         Lb9w==
X-Gm-Message-State: AOAM531n/UOMR095nLQSz+UmBHdxhmQVg/k+JcrdwUy+iYFIjAOmdMex
        BsCmRgEiSs0k1mBI8yWLYD0=
X-Google-Smtp-Source: ABdhPJyeDtmAarHCtYnpDu/tPJKUAO5XNsZR6KHRqJDUnoqeQ83wpxQXC/OEhPquKY/rJvrjXGWUhQ==
X-Received: by 2002:a65:46c8:: with SMTP id n8mr5150306pgr.301.1623850948752;
        Wed, 16 Jun 2021 06:42:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e857:405b:92df:8194])
        by smtp.gmail.com with ESMTPSA id e6sm5764467pjl.3.2021.06.16.06.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 06:42:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 2/2] net/packet: annotate accesses to po->ifindex
Date:   Wed, 16 Jun 2021 06:42:02 -0700
Message-Id: <20210616134202.3661456-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210616134202.3661456-1-eric.dumazet@gmail.com>
References: <20210616134202.3661456-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Like prior patch, we need to annotate lockless accesses to po->ifindex
For instance, packet_getname() is reading po->ifindex (twice) while
another thread is able to change po->ifindex.

KCSAN reported:

BUG: KCSAN: data-race in packet_do_bind / packet_getname

write to 0xffff888143ce3cbc of 4 bytes by task 25573 on cpu 1:
 packet_do_bind+0x420/0x7e0 net/packet/af_packet.c:3191
 packet_bind+0xc3/0xd0 net/packet/af_packet.c:3255
 __sys_bind+0x200/0x290 net/socket.c:1637
 __do_sys_bind net/socket.c:1648 [inline]
 __se_sys_bind net/socket.c:1646 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1646
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888143ce3cbc of 4 bytes by task 25578 on cpu 0:
 packet_getname+0x5b/0x1a0 net/packet/af_packet.c:3525
 __sys_getsockname+0x10e/0x1a0 net/socket.c:1887
 __do_sys_getsockname net/socket.c:1902 [inline]
 __se_sys_getsockname net/socket.c:1899 [inline]
 __x64_sys_getsockname+0x3e/0x50 net/socket.c:1899
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 25578 Comm: syz-executor.5 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e91a36bdd1abaf18a679b914ae0d722d42c9369b..330ba68828e7dbabf4d4d6b76e7cb664253c432e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3187,11 +3187,11 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		if (unlikely(unlisted)) {
 			dev_put(dev);
 			po->prot_hook.dev = NULL;
-			po->ifindex = -1;
+			WRITE_ONCE(po->ifindex, -1);
 			packet_cached_dev_reset(po);
 		} else {
 			po->prot_hook.dev = dev;
-			po->ifindex = dev ? dev->ifindex : 0;
+			WRITE_ONCE(po->ifindex, dev ? dev->ifindex : 0);
 			packet_cached_dev_assign(po, dev);
 		}
 	}
@@ -3505,7 +3505,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 	uaddr->sa_family = AF_PACKET;
 	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	rcu_read_lock();
-	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
+	dev = dev_get_by_index_rcu(sock_net(sk), READ_ONCE(pkt_sk(sk)->ifindex));
 	if (dev)
 		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
@@ -3520,16 +3520,18 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_ll *, sll, uaddr);
+	int ifindex;
 
 	if (peer)
 		return -EOPNOTSUPP;
 
+	ifindex = READ_ONCE(po->ifindex);
 	sll->sll_family = AF_PACKET;
-	sll->sll_ifindex = po->ifindex;
+	sll->sll_ifindex = ifindex;
 	sll->sll_protocol = READ_ONCE(po->num);
 	sll->sll_pkttype = 0;
 	rcu_read_lock();
-	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
+	dev = dev_get_by_index_rcu(sock_net(sk), ifindex);
 	if (dev) {
 		sll->sll_hatype = dev->type;
 		sll->sll_halen = dev->addr_len;
@@ -4108,7 +4110,7 @@ static int packet_notifier(struct notifier_block *this,
 				}
 				if (msg == NETDEV_UNREGISTER) {
 					packet_cached_dev_reset(po);
-					po->ifindex = -1;
+					WRITE_ONCE(po->ifindex, -1);
 					if (po->prot_hook.dev)
 						dev_put(po->prot_hook.dev);
 					po->prot_hook.dev = NULL;
@@ -4620,7 +4622,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
 			   ntohs(READ_ONCE(po->num)),
-			   po->ifindex,
+			   READ_ONCE(po->ifindex),
 			   po->running,
 			   atomic_read(&s->sk_rmem_alloc),
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
-- 
2.32.0.272.g935e593368-goog

