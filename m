Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B93B7406
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhF2OPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhF2OPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:15:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE719C061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:12:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i4so10974781plt.12
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZZqhGa5pypvC4pR1ai5TUXyYwA9BO+X2hTdTOvad1GQ=;
        b=IhIBdtxmbcXKB6WuolK4lXcotIi9xSLt9antokWbSj0s//ZKSGMr/7knH3bbXN4Ov7
         NCgqnh3qWRCAFx8T/C2uNGEMeUhKfuu20JKRG00su1RX6x4U17rDKOafCQjWiXl9CnTs
         1BZj7LmGEjCspU2OwTEwt3i1iTjla2115QbRIlmmvIzN4JxlcMevjgi84l5305J4PSk9
         j0evE8wa/e8sM/QE05wz5XMNvMTkpnfBhBbZQaWbU0aaXN5EFwdOIcA149lTcoeUDpbp
         69gOHxMGQrD/DrW1SZM6mOxzOpL+3Ld48ECSBFVnjWUYdxSw5EQ42QUIo2ALcAUOn5YF
         IPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZZqhGa5pypvC4pR1ai5TUXyYwA9BO+X2hTdTOvad1GQ=;
        b=QbHOFeSWxSZSd0DM2yJYGijHplufa+NPxSfntSZsXTtMeTDAl8qaLzIhLuBi9jBbak
         e13LTIHmzj1r1hGq9AVdqzxMUQ8F2x256umKhBvJDLxGbPtaiS4hLxnPxyTeS6o75kBl
         uOw8+y3tYb41HrRPJBCDC7qv92+FFrj1FcID3QDWDU6LqzVqRO4xpM6lHCGRPT9Hy5Mj
         0rkciBw2/GZ9tkk1fh0KvRsy88o+P3SJc/kcyEc6qfDEOkNKemNfosx0e/yw9Ese28f/
         NOUJ5vH6G+N77a2Pn8Cn6LqYlN5ZqK1G0njb2JfS322s3JhK5abfUk5AwGadPXXpJjsr
         XVkw==
X-Gm-Message-State: AOAM532VPt6jCkpx+X5jwkkMdpMw6tfCLahZqyTMpqNBWUOIwT4nfKVu
        41l3IGIes6OUo9uwqSMoNnU=
X-Google-Smtp-Source: ABdhPJxqMqjUvqXOnEjvCBMyzye1taDYl16Oo+cg5k95l1TteN6nKgjP5IsKBLq4mJklwFwfFUpJMw==
X-Received: by 2002:a17:90b:360d:: with SMTP id ml13mr14080491pjb.121.1624975970454;
        Tue, 29 Jun 2021 07:12:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6838:b492:569f:2a9a])
        by smtp.gmail.com with ESMTPSA id c68sm17739998pfc.75.2021.06.29.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:12:49 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: annotate data race around sk_ll_usec
Date:   Tue, 29 Jun 2021 07:12:45 -0700
Message-Id: <20210629141245.1278533-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_ll_usec is read locklessly from sk_can_busy_loop()
while another thread can change its value in sock_setsockopt()

This is correct but needs annotations.

BUG: KCSAN: data-race in __skb_try_recv_datagram / sock_setsockopt

write to 0xffff88814eb5f904 of 4 bytes by task 14011 on cpu 0:
 sock_setsockopt+0x1287/0x2090 net/core/sock.c:1175
 __sys_setsockopt+0x14f/0x200 net/socket.c:2100
 __do_sys_setsockopt net/socket.c:2115 [inline]
 __se_sys_setsockopt net/socket.c:2112 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2112
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88814eb5f904 of 4 bytes by task 14001 on cpu 1:
 sk_can_busy_loop include/net/busy_poll.h:41 [inline]
 __skb_try_recv_datagram+0x14f/0x320 net/core/datagram.c:273
 unix_dgram_recvmsg+0x14c/0x870 net/unix/af_unix.c:2101
 unix_seqpacket_recvmsg+0x5a/0x70 net/unix/af_unix.c:2067
 ____sys_recvmsg+0x15d/0x310 include/linux/uio.h:244
 ___sys_recvmsg net/socket.c:2598 [inline]
 do_recvmmsg+0x35c/0x9f0 net/socket.c:2692
 __sys_recvmmsg net/socket.c:2771 [inline]
 __do_sys_recvmmsg net/socket.c:2794 [inline]
 __se_sys_recvmmsg net/socket.c:2787 [inline]
 __x64_sys_recvmmsg+0xcf/0x150 net/socket.c:2787
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x00000101

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 14001 Comm: syz-executor.3 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/busy_poll.h | 2 +-
 net/core/sock.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 73af4a64a5999660127dab0a4d111e50eeadf1b5..40296ed976a9778ceb239b99ad783cb99b8b92ef 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -38,7 +38,7 @@ static inline bool net_busy_loop_on(void)
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
 {
-	return sk->sk_ll_usec && !signal_pending(current);
+	return READ_ONCE(sk->sk_ll_usec) && !signal_pending(current);
 }
 
 bool sk_busy_loop_end(void *p, unsigned long start_time);
diff --git a/net/core/sock.c b/net/core/sock.c
index 946888afef880342cc08940e6bad1f295a985dd8..d27fdc2adf9c953fab3e25368150fb1412c7b249 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1172,7 +1172,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			if (val < 0)
 				ret = -EINVAL;
 			else
-				sk->sk_ll_usec = val;
+				WRITE_ONCE(sk->sk_ll_usec, val);
 		}
 		break;
 	case SO_PREFER_BUSY_POLL:
-- 
2.32.0.93.g670b81a890-goog

