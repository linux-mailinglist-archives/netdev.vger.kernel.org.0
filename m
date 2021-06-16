Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09E3A9C4D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhFPNoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhFPNod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:44:33 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C24C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i34so1985066pgl.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FhTyZ1cXYSs6bORtOYAkFXifoja7i8pW27ktzI2Fid4=;
        b=BElRxcr4Wtf9GWI7fjTug2kfMPnPXVwYd/eiTIhm9Gd5VrvRsMLOTe+l8ax278pUXT
         9Xojcv+wPipiAdOj1RqzFHMd2eraAxEBDFc8idfnJU8cKQysfVQMpcoxTN4/AihjS7Bz
         vAx0LcEYFMVNbzRWxSECm7GSO1Zw/VoGKahGT6fiFVZ9j430nI5O66jQB9NqsUXnlTpw
         sxZvo/iCxVs4/M0F307eR10LzUoImSBziPETHGUrwrLm6+nNxVe9StWcK+zgDvQil1eI
         rl9SbmMAANMzLlVXjBU3DAnWyoVqZIykztBO+4ZNd5Z22MyQyXEm06OUfkpw0ScfE61T
         zHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FhTyZ1cXYSs6bORtOYAkFXifoja7i8pW27ktzI2Fid4=;
        b=pSfVxMdrC4aQosyvF9pRri/wTOb79VgplM7qi/Rvst1UiXWGk5l4iOVRCgAe6fjnkt
         Xlx7a2N9qUIwvgEjj6eeI1x5QKLLCvpnu1yNtNY6o59D3Te1QiU0nU/1jy7XTqs6F5oM
         tYcBlKNR7uqD7AqJwjqWiltXGLfuy0zTzKXzfP3jHK7hgGim0+yI0boV1hi31Fc0oB3N
         pswmHXafoowxngG3UdDZs6joxvwvKq58zHj0BR53whcvjlL8S7mF085sTXp8vCvQm9hQ
         WhJi4xOZsZY/qXNm21b0ZMM+ukyCHbxnEm5Vv0YYeRvWSeA5E+P3Y/zOe7axY1sF8rgp
         nuMA==
X-Gm-Message-State: AOAM531DWPk4nu8h0mYYqk7F0N1M/sdm0H4m1I40egtCHa89d+MQltcF
        FXhacdPmhjCgAE6M2tS8dCc=
X-Google-Smtp-Source: ABdhPJyPc+PPt6CmY60YRXL6NAcvmqBrRxA2u+oC9du2TrdrQ+7p9RZqnErUnoQYn6XQWCYcKz/jFQ==
X-Received: by 2002:a63:ff22:: with SMTP id k34mr5074059pgi.336.1623850946863;
        Wed, 16 Jun 2021 06:42:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e857:405b:92df:8194])
        by smtp.gmail.com with ESMTPSA id e6sm5764467pjl.3.2021.06.16.06.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 06:42:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 1/2] net/packet: annotate accesses to po->bind
Date:   Wed, 16 Jun 2021 06:42:01 -0700
Message-Id: <20210616134202.3661456-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210616134202.3661456-1-eric.dumazet@gmail.com>
References: <20210616134202.3661456-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tpacket_snd(), packet_snd(), packet_getname() and packet_seq_show()
can read po->num without holding a lock. This means other threads
can change po->num at the same time.

KCSAN complained about this known fact [1]
Add READ_ONCE()/WRITE_ONCE() to address the issue.

[1] BUG: KCSAN: data-race in packet_do_bind / packet_sendmsg

write to 0xffff888131a0dcc0 of 2 bytes by task 24714 on cpu 0:
 packet_do_bind+0x3ab/0x7e0 net/packet/af_packet.c:3181
 packet_bind+0xc3/0xd0 net/packet/af_packet.c:3255
 __sys_bind+0x200/0x290 net/socket.c:1637
 __do_sys_bind net/socket.c:1648 [inline]
 __se_sys_bind net/socket.c:1646 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1646
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888131a0dcc0 of 2 bytes by task 24719 on cpu 1:
 packet_snd net/packet/af_packet.c:2899 [inline]
 packet_sendmsg+0x317/0x3570 net/packet/af_packet.c:3040
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2433
 __do_sys_sendmsg net/socket.c:2442 [inline]
 __se_sys_sendmsg net/socket.c:2440 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2440
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x1200

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 24719 Comm: syz-executor.5 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 74e6e45a8e8435a556ce813c410a1f4146dd05b6..e91a36bdd1abaf18a679b914ae0d722d42c9369b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2683,7 +2683,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	}
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
-		proto	= po->num;
+		proto	= READ_ONCE(po->num);
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2896,7 +2896,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
-		proto	= po->num;
+		proto	= READ_ONCE(po->num);
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -3171,7 +3171,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 			/* prevents packet_notifier() from calling
 			 * register_prot_hook()
 			 */
-			po->num = 0;
+			WRITE_ONCE(po->num, 0);
 			__unregister_prot_hook(sk, true);
 			rcu_read_lock();
 			dev_curr = po->prot_hook.dev;
@@ -3181,7 +3181,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 		}
 
 		BUG_ON(po->running);
-		po->num = proto;
+		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
 		if (unlikely(unlisted)) {
@@ -3526,7 +3526,7 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
 
 	sll->sll_family = AF_PACKET;
 	sll->sll_ifindex = po->ifindex;
-	sll->sll_protocol = po->num;
+	sll->sll_protocol = READ_ONCE(po->num);
 	sll->sll_pkttype = 0;
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
@@ -4414,7 +4414,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	was_running = po->running;
 	num = po->num;
 	if (was_running) {
-		po->num = 0;
+		WRITE_ONCE(po->num, 0);
 		__unregister_prot_hook(sk, false);
 	}
 	spin_unlock(&po->bind_lock);
@@ -4449,7 +4449,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	spin_lock(&po->bind_lock);
 	if (was_running) {
-		po->num = num;
+		WRITE_ONCE(po->num, num);
 		register_prot_hook(sk);
 	}
 	spin_unlock(&po->bind_lock);
@@ -4619,7 +4619,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   s,
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
-			   ntohs(po->num),
+			   ntohs(READ_ONCE(po->num)),
 			   po->ifindex,
 			   po->running,
 			   atomic_read(&s->sk_rmem_alloc),
-- 
2.32.0.272.g935e593368-goog

