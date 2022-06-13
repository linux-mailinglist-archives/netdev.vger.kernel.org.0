Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CD5549EDF
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350670AbiFMUSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351233AbiFMUSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:18:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FDEC6E45;
        Mon, 13 Jun 2022 11:56:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so6822583pjg.5;
        Mon, 13 Jun 2022 11:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCJ7cmvnGGBiGv7CphvSCu8X+UNRINW1hedBXJL4gcw=;
        b=iKloXNWQJhg9MlZxBceZo87nHC7hP2hNky0Gcal1Lmtw71qpqJaXkMbTFuZWsQIxpE
         TW2FR3sbb/plbFVpEC5nr2GlpDedOX/rdUzLnoRHX6YgdVGdiZsOVBm9iDG4l6fyKHNh
         3OoAfPZyJJmnrrtD61DyHDjFkmdnxNeooV4g25m1SHDIkwCvJK5D9QiEFOx2I7eHwY31
         jeleoxBtnOeAAsj2iTYzjgvUSpPXPF3sbuX2RFl8Jp0BzhbLEzru9BY+2nKZfvmFwpq5
         Z0vbL8DmSG8gJaGE2Eykn0J3IpidBLAsFwx++mOMc/QI0Tu8u9CmziVAQbVLgSerwC/s
         I+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CCJ7cmvnGGBiGv7CphvSCu8X+UNRINW1hedBXJL4gcw=;
        b=VC3dsl3iJhBk5UXgqWVuZOdcLyD92ua5522YFEHNLOFW3RggqXGSlVTPmjdm4KGM+t
         SrFE//xswFdrMo5oz0ZbWTUZvq3eycLniEMc7EdyCEjjiEHN4729T5hPli2nOawQfdHO
         Wt5Crnk92mahnwK6HRX7lW0ur8giWgeKyR5cLHvAAG3q3LoRljm2yG7gQmROzEP5GFvV
         wi2RAKxYFqkNAAEBlXjT9RcG0XvBlTJRzW5XDKgvIQXMfB8ZskuUItAnR8pB+xxcLFqu
         9TGAF5J2rtSxEgfZ3/lfqb0hBV1TpHdyPMmMC+HITtbIJkSue6BI99UlhOigAvh/T9Vu
         U0Fw==
X-Gm-Message-State: AJIora8p2VQXv9cgQm5dM+lgkPLqlis2Qb/B9OeKiZEyjVKEdgwJzZFp
        QclS1h2OvWtOcFMUQAXuGVs=
X-Google-Smtp-Source: AGRyM1vtHkJvJoPKCPe3i3yKZq6MGnxbPDITLJpw5rg0Sx0qDhXCEWln255i3pBD+sS237JUbkF7hQ==
X-Received: by 2002:a17:90b:1e4f:b0:1e8:4e3c:e212 with SMTP id pi15-20020a17090b1e4f00b001e84e3ce212mr151628pjb.25.1655146610901;
        Mon, 13 Jun 2022 11:56:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:845d:7990:3e75:b8e3])
        by smtp.gmail.com with ESMTPSA id z4-20020a17090acb0400b001e0cc5b13c6sm7823869pjt.26.2022.06.13.11.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 11:56:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH stable-5.10] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
Date:   Mon, 13 Jun 2022 11:56:47 -0700
Message-Id: <20220613185647.439422-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

From: Eric Dumazet <edumazet@google.com>

commit 11825765291a93d8e7f44230da67b9f607c777bf upstream.

syzbot got a new report [1] finally pointing to a very old bug,
added in initial support for MTU probing.

tcp_mtu_probe() has checks about starting an MTU probe if
tcp_snd_cwnd(tp) >= 11.

But nothing prevents tcp_snd_cwnd(tp) to be reduced later
and before the MTU probe succeeds.

This bug would lead to potential zero-divides.

Debugging added in commit 40570375356c ("tcp: add accessors
to read/set tp->snd_cwnd") has paid off :)

While we are at it, address potential overflows in this code.

[1]
WARNING: CPU: 1 PID: 14132 at include/net/tcp.h:1219 tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
Modules linked in:
CPU: 1 PID: 14132 Comm: syz-executor.2 Not tainted 5.18.0-syzkaller-07857-gbabf0bb978e3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcp_snd_cwnd_set include/net/tcp.h:1219 [inline]
RIP: 0010:tcp_mtup_probe_success+0x366/0x570 net/ipv4/tcp_input.c:2712
Code: 74 08 48 89 ef e8 da 80 17 f9 48 8b 45 00 65 48 ff 80 80 03 00 00 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 aa b0 c5 f8 <0f> 0b e9 16 fe ff ff 48 8b 4c 24 08 80 e1 07 38 c1 0f 8c c7 fc ff
RSP: 0018:ffffc900079e70f8 EFLAGS: 00010287
RAX: ffffffff88c0f7f6 RBX: ffff8880756e7a80 RCX: 0000000000040000
RDX: ffffc9000c6c4000 RSI: 0000000000031f9e RDI: 0000000000031f9f
RBP: 0000000000000000 R08: ffffffff88c0f606 R09: ffffc900079e7520
R10: ffffed101011226d R11: 1ffff1101011226c R12: 1ffff1100eadcf50
R13: ffff8880756e72c0 R14: 1ffff1100eadcf89 R15: dffffc0000000000
FS:  00007f643236e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ab3f1e2a0 CR3: 0000000064fe7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_clean_rtx_queue+0x223a/0x2da0 net/ipv4/tcp_input.c:3356
 tcp_ack+0x1962/0x3c90 net/ipv4/tcp_input.c:3861
 tcp_rcv_established+0x7c8/0x1ac0 net/ipv4/tcp_input.c:5973
 tcp_v6_do_rcv+0x57b/0x1210 net/ipv6/tcp_ipv6.c:1476
 sk_backlog_rcv include/net/sock.h:1061 [inline]
 __release_sock+0x1d8/0x4c0 net/core/sock.c:2849
 release_sock+0x5d/0x1c0 net/core/sock.c:3404
 sk_stream_wait_memory+0x700/0xdc0 net/core/stream.c:145
 tcp_sendmsg_locked+0x111d/0x3fc0 net/ipv4/tcp.c:1410
 tcp_sendmsg+0x2c/0x40 net/ipv4/tcp.c:1448
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 __sys_sendto+0x439/0x5c0 net/socket.c:2119
 __do_sys_sendto net/socket.c:2131 [inline]
 __se_sys_sendto net/socket.c:2127 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:2127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f6431289109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f643236e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f643139c100 RCX: 00007f6431289109
RDX: 00000000d0d0c2ac RSI: 0000000020000080 RDI: 000000000000000a
RBP: 00007f64312e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff372533af R14: 00007f643236e300 R15: 0000000000022000

Fixes: 5d424d5a674f ("[TCP]: MTU probing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_input.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e267b2e33e5a7ab853c417631bbe2ffb2537029..54ed68e05b66a43edf5f53b795e512751561cb8b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2667,12 +2667,15 @@ static void tcp_mtup_probe_success(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	u64 val;
 
-	/* FIXME: breaks with very large cwnd */
 	tp->prior_ssthresh = tcp_current_ssthresh(sk);
-	tp->snd_cwnd = tp->snd_cwnd *
-		       tcp_mss_to_mtu(sk, tp->mss_cache) /
-		       icsk->icsk_mtup.probe_size;
+
+	val = (u64)tp->snd_cwnd * tcp_mss_to_mtu(sk, tp->mss_cache);
+	do_div(val, icsk->icsk_mtup.probe_size);
+	WARN_ON_ONCE((u32)val != val);
+	tp->snd_cwnd = max_t(u32, 1U, val);
+
 	tp->snd_cwnd_cnt = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_ssthresh = tcp_current_ssthresh(sk);
-- 
2.36.1.476.g0c4daa206d-goog

