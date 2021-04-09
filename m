Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D134F35A44E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhDIRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhDIRCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:02:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1FC061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 10:02:41 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l1so3042322plg.12
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 10:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DP/y74zkxqibGPnNtCkCKMUKyvdYj2OOG2QBo4zvAiE=;
        b=mv21gwKl/JjtByH/edFKIcMeWXHsCC7MFQ++bjbHHh4JPitSsGIbjC7ctHpTYzIGbd
         I2j7r6NwYCTLHPpMrNyqmwNb1YHJAl+pa1bIsBpteIxxJ+uXVM9LS1F7kPCX08N7y/Rv
         dPFKPtZssYTQTI9OCiiPQvcwzO1qFfyuXuxcty0KtJMsQKWMVkYe5PzzZA+N/nxkmBJm
         t35ECeeAw3f9gBDyttXDxxOQinjdfoJeBi3ZO4sNjkTW0UPWV1bWOvK5rvEq8n4RXM+B
         yIuFPc5G4D+8jbX9YanzsWRftwvBkoZ+SZJ91NsCiMHbmmCKEu8ROEOa5dVJGYQsWW8k
         GpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DP/y74zkxqibGPnNtCkCKMUKyvdYj2OOG2QBo4zvAiE=;
        b=GhtBiNHhR+ERDpnwUotcMKd2ZEVgCtjH+vhIsgX10nPXH2CVy7DodGh9WRzz4PI30A
         7Qwh4ry5h8taiHTk0aqeeBHPXda+NX+YHb5baoQPTctYyqQ3YgZSLzzA48q0rLsBpBif
         ebThkZm1FFg2/DzAqstegQ5nyST96OX5t2oHcUBVnTHlJkHDfzRDZQWy6rWtdgGWKbSu
         f/3hiqnm2UxQHb9D424FJosWUesLJUn7aFv595u07TEtaZ16Yh5g8KrcDy6KdkpgL7OR
         NPkVC454wzveZSn4WpKzipKpx2sAepg20JZ3lTakN8rx1C/Cx2z0f4Pl+9gCPzOMNaP8
         aUVg==
X-Gm-Message-State: AOAM530UttQlV70+oOLqijfK2pzDcbM7WqccZqXaw4L51dRh2TXeytSv
        JHjbLFTgFj92aWsQefI+QJ4=
X-Google-Smtp-Source: ABdhPJyXaT+MgveKDuFwM5GMR/9k21dEjb49zU/vM2GmjI2cuNYQSRY8McL7bTcGIkjCCkCftWdrMw==
X-Received: by 2002:a17:90b:1b46:: with SMTP id nv6mr14942061pjb.45.1617987760970;
        Fri, 09 Apr 2021 10:02:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:dbf:152b:ea58:1a81])
        by smtp.gmail.com with ESMTPSA id x2sm3581662pgb.89.2021.04.09.10.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 10:02:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Sauvik Saha <ssaha@codeaurora.org>
Subject: [PATCH net-next] Revert "tcp: Reset tcp connections in SYN-SENT state"
Date:   Fri,  9 Apr 2021 10:02:37 -0700
Message-Id: <20210409170237.274904-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commit e880f8b3a24a73704731a7227ed5fee14bd90192.

1) Patch has not been properly tested, and is wrong [1]
2) Patch submission did not include TCP maintainer (this is me)

[1]
divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8426 Comm: syz-executor478 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__tcp_select_window+0x56d/0xad0 net/ipv4/tcp_output.c:3015
Code: 44 89 ff e8 d5 cd f0 f9 45 39 e7 0f 8d 20 ff ff ff e8 f7 c7 f0 f9 44 89 e3 e9 13 ff ff ff e8 ea c7 f0 f9 44 89 e0 44 89 e3 99 <f7> 7c 24 04 29 d3 e9 fc fe ff ff e8 d3 c7 f0 f9 41 f7 dc bf 1f 00
RSP: 0018:ffffc9000184fac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff87832e76 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87832e14 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff92000309f5c R14: 0000000000000000 R15: 0000000000000000
FS:  00000000023eb300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc2b5f426c0 CR3: 000000001c5cf000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcp_select_window net/ipv4/tcp_output.c:264 [inline]
 __tcp_transmit_skb+0xa82/0x38f0 net/ipv4/tcp_output.c:1351
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 tcp_send_active_reset+0x475/0x8e0 net/ipv4/tcp_output.c:3449
 tcp_disconnect+0x15a9/0x1e60 net/ipv4/tcp.c:2955
 inet_shutdown+0x260/0x430 net/ipv4/af_inet.c:905
 __sys_shutdown_sock net/socket.c:2189 [inline]
 __sys_shutdown_sock net/socket.c:2183 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2201
 __do_sys_shutdown net/socket.c:2209 [inline]
 __se_sys_shutdown net/socket.c:2207 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2207
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: e880f8b3a24a ("tcp: Reset tcp connections in SYN-SENT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Sauvik Saha <ssaha@codeaurora.org>
---
 net/ipv4/tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 627a472161fbcc7a2070993d2cda513dd18f08c7..e14fd0c50c10222b4b6b078b21e0b076343febff 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2888,7 +2888,7 @@ static inline bool tcp_need_reset(int state)
 {
 	return (1 << state) &
 	       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT | TCPF_FIN_WAIT1 |
-		TCPF_FIN_WAIT2 | TCPF_SYN_RECV | TCPF_SYN_SENT);
+		TCPF_FIN_WAIT2 | TCPF_SYN_RECV);
 }
 
 static void tcp_rtx_queue_purge(struct sock *sk)
@@ -2954,7 +2954,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 		 */
 		tcp_send_active_reset(sk, gfp_any());
 		sk->sk_err = ECONNRESET;
-	}
+	} else if (old_state == TCP_SYN_SENT)
+		sk->sk_err = ECONNRESET;
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-- 
2.31.1.295.g9ea45b61b8-goog

