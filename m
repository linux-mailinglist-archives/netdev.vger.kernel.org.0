Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCF6187E1
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiKCSqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKCSqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:46:31 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FC619C36
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 11:46:29 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s4so1816125qtx.6
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aXY1lIR6Oeh72A9WHYtvry4LC/dg2Hz0Zvhe7R9kqbk=;
        b=KJ8xho+tOAa8yoGpeWyD4cJbETY/Iu/USq9OGrxeVIU9Pb5ECUJeQbmUeERcWGAq1A
         HdUiL8pQ+m+EYpv+SLR78I3ODBgrmKsInord6w7XOWgdjpnA9FmBWrvClA9b3cd6euV7
         5CCdCKLttRTw+FskRvHxD3JtXK4lKm3Wfy5BBPO5RdYWI5qfe+GAFwLo5KfZC9npBrxD
         nco4zuN3C3S786JpMOeezvrbASjmUE7CyOVwmrztu/ayO68K/8Am+yKl8+4SrMc8T3vu
         j1hgSMTWCg22tcB/me6yVZaaf4HLydFdAyI/LFNry+CsHNDQQ82Ib34PITpftkaxHO8H
         Xmaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aXY1lIR6Oeh72A9WHYtvry4LC/dg2Hz0Zvhe7R9kqbk=;
        b=J9S30/vHEPWTePMqjW5o1rW3LqXyem3VmDOTovJpOSXHi2Fg3B3MHhzXmenLeO+StI
         WCTh0feunRAeRcBqECg8qFErbXv0/JzO9M9UAKmex/q6shHfk7WovRD+3RQkDyJ12RDo
         3JkSlM+U2vOnzN7mNT0e+Cxb/R71YLED4gJjO5+6Yqx9oFqRe4unLi4hz43OIgCxGa8K
         XFXMHei4Dzdk7aic+tFIQ4nplrBix/7MUYV9UR8YK5nXNS5ZDa88L4LsMEX4er0aKKTQ
         cyJea8hFKsJCqRuDBMne8PErSb22oCR1YyMl/Pha+vJlpeoLXtvS/NAOY8FIHfE8Zp+6
         lSSQ==
X-Gm-Message-State: ACrzQf1bUi07R9l4IkMaXqzYtY3Dn5vgMOToy4uTd3QN1SWdtkrdQFo3
        cChFos6n7vGkfiLE2eU7jbvArUu1pSU=
X-Google-Smtp-Source: AMsMyM6qmd85GHb3+oAaPRv2Io/ook1G6+yTdcVuVZ/YZVZq+QG6LSSAra0IxYlLayo6ffUZaY9B+g==
X-Received: by 2002:a05:622a:15c8:b0:39c:ea8a:82e3 with SMTP id d8-20020a05622a15c800b0039cea8a82e3mr26128003qty.146.1667501188712;
        Thu, 03 Nov 2022 11:46:28 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:4d91:6911:634f:5b22])
        by smtp.gmail.com with ESMTPSA id x25-20020a05620a0b5900b006bb82221013sm1259343qkg.0.2022.11.03.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 11:46:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, Cong Wang <cong.wang@bytedance.com>,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [Patch net v2] kcm: close race conditions on sk_receive_queue
Date:   Thu,  3 Nov 2022 11:46:20 -0700
Message-Id: <20221103184620.359451-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk->sk_receive_queue is protected by skb queue lock, but for KCM
sockets its RX path takes mux->rx_lock to protect more than just
skb queue. However, kcm_recvmsg() still only grabs the skb queue
lock, so race conditions still exist.

We can teach kcm_recvmsg() to grab mux->rx_lock too but this would
introduce a potential performance regression as struct kcm_mux can
be shared by multiple KCM sockets. So we have to enforce skb queue
lock in requeue_rx_msgs() and handle skb peek case carefully in
kcm_wait_data(). Fortunately, skb_recv_datagram() already handles
it nicely and is widely used by other sockets, we can just switch
to skb_recv_datagram() after getting rid of the unnecessary sock
lock in kcm_recvmsg() and kcm_splice_read().

I ran the original syzbot reproducer for 30 min without seeing any
issue.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com
Reported-by: shaozhengchao <shaozhengchao@huawei.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/kcm/kcmsock.c | 58 +++++------------------------------------------
 1 file changed, 6 insertions(+), 52 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index a5004228111d..890a2423f559 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -222,7 +222,7 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1085,53 +1085,17 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
@@ -1162,14 +1126,11 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1179,7 +1140,6 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1187,11 +1147,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1219,13 +1175,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 
-- 
2.34.1

