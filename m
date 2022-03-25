Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CECB4E6CF7
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 04:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356577AbiCYEAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 00:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiCYEAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 00:00:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BAC49C8F
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:58:32 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bx5so6465044pjb.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GS+H7nOIQTh/xA8uaV5UmyaObvrVeR9v+bzdkYPss1I=;
        b=XjFhZ++BOBmOrw3209FUUnyVK7r+agag1om80q3aGqlZhJl4rr4vq4RBxrPqEHsZ+M
         7Blj7DRtlR6H8+PpwDXfAlHmsC5lgPNbFSw2+QlU70uPUgV07XmE4P7zW0UeAlinMPXK
         fCQga/Jrfx9OIT2Oo4Bh5GvDc6c9evf4uBm3fXN4eGuHj2j2asO9H4fmv7l16Gvludpj
         VKOaBPlfnM2LLIiWsH2MFNEbmi+5aS5hiYBR8JJYAQJrCq6UDG+L6yAWqNovcYw6uxtp
         8dYETI4Z/oFdPzS/WR1HXcYpC84X8FR8U+4q+SYe9Pnh7Y7YdJ07HPjlsIpyQE2/yLrC
         1d9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GS+H7nOIQTh/xA8uaV5UmyaObvrVeR9v+bzdkYPss1I=;
        b=tujEzbDtPpZ4lc0DVvI2GusNGMXBhAzTdqNCBSPwPXw1km23tpXFguKs95EkXQDo5l
         qdPjwaVUJDZkq9Tlku9vTvVKTxYiwN6UOmr5xETlPRpR+UwpnIHniWkidb3R2it3DV+m
         BOinLXjfnVqoN2n/tRfQLRo2XjZjYolIHHqnTtdWMVKSQqHol8Cx4idrbPFTnIbM0Gwk
         1FYxTvMdYs4/XEpZfWK6bNwwSsQBMADNwjfHU3OzTNTuoDfWNqYt2Tb1oTqgRX7jcdKx
         skaNNv8uBWM6OEMe/xhC8hxuB6XIQl9q2idSnOfWmu8yacbZIuqEpd6ASZnsrgkonicQ
         lzOA==
X-Gm-Message-State: AOAM5302VeZdGLbw1GIDQ4qmlpzBQA5wIJY9ufgS60UqZ2Vfn30puWmF
        PyLuSeaibvyXt5jR1MguFaU=
X-Google-Smtp-Source: ABdhPJxD1d2psigLRIY7YndKyzCQAcpI3owpaXMj6bS1y0ETl4icNaOYOQiARHN//NrLvpbf8ofOcw==
X-Received: by 2002:a17:902:cec9:b0:154:7dd3:c944 with SMTP id d9-20020a170902cec900b001547dd3c944mr9634615plg.97.1648180712086;
        Thu, 24 Mar 2022 20:58:32 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3df1:3ed5:ad16:dfd6])
        by smtp.gmail.com with ESMTPSA id u126-20020a637984000000b0038147b4f53esm3761225pgc.93.2022.03.24.20.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 20:58:31 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?q?=E8=B5=B5=E5=AD=90=E8=BD=A9?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: [PATCH net] llc: only change llc->dev when bind() succeeds
Date:   Thu, 24 Mar 2022 20:58:27 -0700
Message-Id: <20220325035827.360418-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

My latest patch, attempting to fix the refcount leak in a minimal
way turned out to add a new bug.

Whenever the bind operation fails before we attempt to grab
a reference count on a device, we might release the device refcount
of a prior successful bind() operation.

syzbot was not happy about this [1].

Note to stable teams:

Make sure commit b37a46683739 ("netdevice: add the case if dev is NULL")
is already present in your trees.

[1]
general protection fault, probably for non-canonical address 0xdffffc0000000070: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
CPU: 1 PID: 3590 Comm: syz-executor361 Tainted: G        W         5.17.0-syzkaller-04796-g169e77764adc #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:llc_ui_connect+0x400/0xcb0 net/llc/af_llc.c:500
Code: 80 3c 02 00 0f 85 fc 07 00 00 4c 8b a5 38 05 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 80 03 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a9 07 00 00 49 8b b4 24 80 03 00 00 4c 89 f2 48
RSP: 0018:ffffc900038cfcc0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880756eb600 RCX: 0000000000000000
RDX: 0000000000000070 RSI: ffffc900038cfe3e RDI: 0000000000000380
RBP: ffff888015ee5000 R08: 0000000000000001 R09: ffff888015ee5535
R10: ffffed1002bdcaa6 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900038cfe37 R14: ffffc900038cfe38 R15: ffff888015ee5012
FS:  0000555555acd300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 0000000077db6000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __sys_connect_file+0x155/0x1a0 net/socket.c:1900
 __sys_connect+0x161/0x190 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f016acb90b9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd417947f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f016acb90b9
RDX: 0000000000000010 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007f016ac7d0a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f016ac7d130
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:llc_ui_connect+0x400/0xcb0 net/llc/af_llc.c:500

Fixes: 764f4eb6846f ("llc: fix netdevice reference leaks in llc_ui_bind()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: 赵子轩 <beraphin@gmail.com>
Cc: Stoyan Manolov <smanolov@suse.de>
---
 net/llc/af_llc.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c86256064743523f0621f21d5d023956cf1df9a0..7f555d2e5357f0429c9828c31c218ead260e43a2 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -275,6 +275,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 {
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
+	struct net_device *dev = NULL;
 	struct llc_sap *sap;
 	int rc = -EINVAL;
 
@@ -286,16 +287,15 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 		goto out;
 	rc = -ENODEV;
 	if (sk->sk_bound_dev_if) {
-		llc->dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
-		if (llc->dev && addr->sllc_arphrd != llc->dev->type) {
-			dev_put(llc->dev);
-			llc->dev = NULL;
+		dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
+		if (dev && addr->sllc_arphrd != dev->type) {
+			dev_put(dev);
+			dev = NULL;
 		}
 	} else
-		llc->dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
-	if (!llc->dev)
+		dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
+	if (!dev)
 		goto out;
-	netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KERNEL);
 	rc = -EUSERS;
 	llc->laddr.lsap = llc_ui_autoport();
 	if (!llc->laddr.lsap)
@@ -304,6 +304,12 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 	sap = llc_sap_open(llc->laddr.lsap, NULL);
 	if (!sap)
 		goto out;
+
+	/* Note: We do not expect errors from this point. */
+	llc->dev = dev;
+	netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KERNEL);
+	dev = NULL;
+
 	memcpy(llc->laddr.mac, llc->dev->dev_addr, IFHWADDRLEN);
 	memcpy(&llc->addr, addr, sizeof(llc->addr));
 	/* assign new connection to its SAP */
@@ -311,10 +317,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc = 0;
 out:
-	if (rc) {
-		dev_put_track(llc->dev, &llc->dev_tracker);
-		llc->dev = NULL;
-	}
+	dev_put(dev);
 	return rc;
 }
 
@@ -337,6 +340,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	struct sockaddr_llc *addr = (struct sockaddr_llc *)uaddr;
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
+	struct net_device *dev = NULL;
 	struct llc_sap *sap;
 	int rc = -EINVAL;
 
@@ -352,25 +356,27 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	rc = -ENODEV;
 	rcu_read_lock();
 	if (sk->sk_bound_dev_if) {
-		llc->dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
-		if (llc->dev) {
+		dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
+		if (dev) {
 			if (is_zero_ether_addr(addr->sllc_mac))
-				memcpy(addr->sllc_mac, llc->dev->dev_addr,
+				memcpy(addr->sllc_mac, dev->dev_addr,
 				       IFHWADDRLEN);
-			if (addr->sllc_arphrd != llc->dev->type ||
+			if (addr->sllc_arphrd != dev->type ||
 			    !ether_addr_equal(addr->sllc_mac,
-					      llc->dev->dev_addr)) {
+					      dev->dev_addr)) {
 				rc = -EINVAL;
-				llc->dev = NULL;
+				dev = NULL;
 			}
 		}
-	} else
-		llc->dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
+	} else {
+		dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
 					   addr->sllc_mac);
-	dev_hold_track(llc->dev, &llc->dev_tracker, GFP_ATOMIC);
+	}
+	dev_hold(dev);
 	rcu_read_unlock();
-	if (!llc->dev)
+	if (!dev)
 		goto out;
+
 	if (!addr->sllc_sap) {
 		rc = -EUSERS;
 		addr->sllc_sap = llc_ui_autoport();
@@ -402,6 +408,12 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 			goto out_put;
 		}
 	}
+
+	/* Note: We do not expect errors from this point. */
+	llc->dev = dev;
+	netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KERNEL);
+	dev = NULL;
+
 	llc->laddr.lsap = addr->sllc_sap;
 	memcpy(llc->laddr.mac, addr->sllc_mac, IFHWADDRLEN);
 	memcpy(&llc->addr, addr, sizeof(llc->addr));
@@ -412,10 +424,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 out_put:
 	llc_sap_put(sap);
 out:
-	if (rc) {
-		dev_put_track(llc->dev, &llc->dev_tracker);
-		llc->dev = NULL;
-	}
+	dev_put(dev);
 	release_sock(sk);
 	return rc;
 }
-- 
2.35.1.1021.g381101b075-goog

