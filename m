Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB743A2E79
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFJOqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJOqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:46:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA2C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:44:16 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c12so1812411pfl.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OGcWnzzmAPnW0QJNQUtzfbxHu7uuiEfSj9pwZ9L2/tM=;
        b=eS8xqeRMfj2P/NdXy5MGczOlZMnVl/Zzr7GLT0sJb6m6iuzPav68gOnfIcYp8NlYRS
         AMRudujWjGo9T1e0Xr6UCbMKuR40JDtCiRQHdB8Pz8nr8Pwtm7yYEanWHiwtbw1Onv9K
         WamdBNFz3k1M1k4QptTPhG2aLC7s4jbON9hfVxB406fNEmjgPwyElJ8y/gzRjwap+Sdb
         0RMClLQ3kBO2yBxZyozLDBFRA+n4eEK4lh9od3A36z/+cZaEbanVmlUmATqjwyGaVmKL
         BOXojv5wPeXuP8iQ9OWdy60GpAChvODHvsyG25ZTmk/gTph8ILj4ydX7drSeCinYoeQT
         wmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OGcWnzzmAPnW0QJNQUtzfbxHu7uuiEfSj9pwZ9L2/tM=;
        b=Cs6fmJ6p7nnRDqeIxoU+m1NWP0+b87pjITFzkGPR1JedUs5fsmD26hwiLK96nmpcrQ
         rvzLzIV/mn5aMTlbMOGLX9IXcTuINHSLyL1ccZujabJwWEK7+rVziM1CCXpbcQy9t0W1
         8+ukT+9jBpkpxVE3URv/k6gB6Bd0ipvMGixegGNZ7WmJrhzr+XnVAN4rxJ9Jf5L9lUAf
         brX7E6ALjjn1+aconKTL2UpHC8GMHui67M1ni+OsKPpI3KbQHaHVyX/bTcW9zITKMqCX
         YVPIt58BiY38H+xBoCFqwBWDemOsbuKn0lJle/TtHadnLgIseHpdHJ2I7JOT4/nVv6kG
         kEEA==
X-Gm-Message-State: AOAM532C64Jps439EW0qliq7I3f4dsNyRz0IjkFs3MbQY3p0PKcajQIm
        2k5kdkPWZVjQuQ3vIGaNJGY=
X-Google-Smtp-Source: ABdhPJxNzccBRRasy9KmkQ9y0VSnWAKgE950XUWbHD8AXLvk0vYj2FqmI1EqtKcssqbbjFe5yJWiMQ==
X-Received: by 2002:a63:db01:: with SMTP id e1mr5372385pgg.38.1623336256420;
        Thu, 10 Jun 2021 07:44:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6f4:90b5:5614:38a0])
        by smtp.gmail.com with ESMTPSA id w63sm2660511pfw.153.2021.06.10.07.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 07:44:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] inet: annotate date races around sk->sk_txhash
Date:   Thu, 10 Jun 2021 07:44:11 -0700
Message-Id: <20210610144411.1414221-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

UDP sendmsg() path can be lockless, it is possible for another
thread to re-connect an change sk->sk_txhash under us.

There is no serious impact, but we can use READ_ONCE()/WRITE_ONCE()
pair to document the race.

BUG: KCSAN: data-race in __ip4_datagram_connect / skb_set_owner_w

write to 0xffff88813397920c of 4 bytes by task 30997 on cpu 1:
 sk_set_txhash include/net/sock.h:1937 [inline]
 __ip4_datagram_connect+0x69e/0x710 net/ipv4/datagram.c:75
 __ip6_datagram_connect+0x551/0x840 net/ipv6/datagram.c:189
 ip6_datagram_connect+0x2a/0x40 net/ipv6/datagram.c:272
 inet_dgram_connect+0xfd/0x180 net/ipv4/af_inet.c:580
 __sys_connect_file net/socket.c:1837 [inline]
 __sys_connect+0x245/0x280 net/socket.c:1854
 __do_sys_connect net/socket.c:1864 [inline]
 __se_sys_connect net/socket.c:1861 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1861
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88813397920c of 4 bytes by task 31039 on cpu 0:
 skb_set_hash_from_sk include/net/sock.h:2211 [inline]
 skb_set_owner_w+0x118/0x220 net/core/sock.c:2101
 sock_alloc_send_pskb+0x452/0x4e0 net/core/sock.c:2359
 sock_alloc_send_skb+0x2d/0x40 net/core/sock.c:2373
 __ip6_append_data+0x1743/0x21a0 net/ipv6/ip6_output.c:1621
 ip6_make_skb+0x258/0x420 net/ipv6/ip6_output.c:1983
 udpv6_sendmsg+0x160a/0x16b0 net/ipv6/udp.c:1527
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:642
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xbca3c43d -> 0xfdb309e0

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 31039 Comm: syz-executor.2 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/sock.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2fc513aa114c0f4bd7554ca08655d0daf63f4544..7a7058f4f265c3e6aaad75b507ccb808bf110c65 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1934,7 +1934,8 @@ static inline u32 net_tx_rndhash(void)
 
 static inline void sk_set_txhash(struct sock *sk)
 {
-	sk->sk_txhash = net_tx_rndhash();
+	/* This pairs with READ_ONCE() in skb_set_hash_from_sk() */
+	WRITE_ONCE(sk->sk_txhash, net_tx_rndhash());
 }
 
 static inline bool sk_rethink_txhash(struct sock *sk)
@@ -2206,9 +2207,12 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 
 static inline void skb_set_hash_from_sk(struct sk_buff *skb, struct sock *sk)
 {
-	if (sk->sk_txhash) {
+	/* This pairs with WRITE_ONCE() in sk_set_txhash() */
+	u32 txhash = READ_ONCE(sk->sk_txhash);
+
+	if (txhash) {
 		skb->l4_hash = 1;
-		skb->hash = sk->sk_txhash;
+		skb->hash = txhash;
 	}
 }
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

