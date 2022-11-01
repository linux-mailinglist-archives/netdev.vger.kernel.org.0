Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2362615380
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKAUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAUwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:52:06 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6F1AD8C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 13:52:04 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id l2so5435203qtq.11
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbFgxpL2eDVtsTmYVTQF59QBf2g2dn88VIr3Sqq6Hfo=;
        b=b503HqCZbgKcjJivfpaqMA5HptPZjeY8Z3JHAUpNfCzAxXZnJRo+jti8NzIa2marfs
         p1BRlgO1NmKTyZdEyLZkLJc2U7D4IxwtBG4Mz3v53SE0e3Gr0s/gp0oMkOJ9U/Ny3bbp
         j9pl7jcWjjLKlxqR1zqjDzl1Ko1z8GbGb2YUPUnsFdXsI/0iWwqj0PD9if2WEAKh0Tdo
         ZwVVqbXnTDK41aVJcF9rSOmA3ubIuEJHbUgqIydAfHTG7S7pFy+klniZyRMFs/TwCLXZ
         6u/xnnOHhiPyJ+LzTkvkHDAncyBVkBCFrGjgDg9T5dgYY5+5WWPczIjQAJKXTmoiv2Ic
         JRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbFgxpL2eDVtsTmYVTQF59QBf2g2dn88VIr3Sqq6Hfo=;
        b=2A6OXPRSK5SsNzkCIWGqSO2ZoNQrB6aJ9BF3P+QpbnGKHE237iy7vRA2oqXmW55e/B
         OfUkONLGurSOKPgS2zIexIQC9Xt/ncfs8xdxI4lUYX7tq6XjON+vioE/Iewrw7Q3TrcO
         fXTGHY4Gjdx83cFV0eNBEzo4F3zn0HbRUp95RvkxW7TNrt7NuhjHUxeuIFMpRwsM2TCK
         ZYIry0w2NhupuEKvdfKJil7FCkelAh66EApwdBGih3yOieCRDbImVDV+qUE73gGp0bYx
         Zcla70YMv0ebdmweFbMyKiuaHywRTyxi8ErShH5QvjJ7diSCOl0o0vCWVtF3dI3kR5S8
         M3Ag==
X-Gm-Message-State: ACrzQf2ZT+IOwRhU9QX2aej3AwVXALcXPmFeeHtZp1JtKr/yJhV/6ZYB
        0F0umZIwyuSrylplCtBsVERKmbQs1SQ=
X-Google-Smtp-Source: AMsMyM7LBfpdP9KBJY0QmEWpRebmSDKpRFU0hrRnhzu2FYhtcbWGvepvMUz0yxoc1OBtFo7rtvwT0w==
X-Received: by 2002:ac8:5f51:0:b0:3a5:c72:2334 with SMTP id y17-20020ac85f51000000b003a50c722334mr17037392qta.346.1667335923186;
        Tue, 01 Nov 2022 13:52:03 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:99d6:8644:5e17:79a])
        by smtp.gmail.com with ESMTPSA id i3-20020a05620a404300b006cbc6e1478csm7020982qko.57.2022.11.01.13.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:52:02 -0700 (PDT)
Date:   Tue, 1 Nov 2022 13:52:00 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Message-ID: <Y2GG8EBUExowl8nQ@pop-os.localdomain>
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 07:30:44PM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> sk->sk_receive_queue is protected by skb queue lock, but for KCM
> sockets its RX path takes mux->rx_lock to protect more than just
> skb queue, so grabbing skb queue lock is not necessary when
> mux->rx_lock is already held. But kcm_recvmsg() still only grabs
> the skb queue lock, so race conditions still exist.
> 
> Close this race condition by taking mux->rx_lock in kcm_recvmsg()
> too. This way is much simpler than enforcing skb queue lock
> everywhere.
> 

After a second thought, this actually could introduce a performance
regression as struct kcm_mux can be shared by multiple KCM sockets.

So, I am afraid we have to use the skb queue lock, fortunately I found
an easier way (comparing to Paolo's) to solve the skb peek race.

Zhengchao, could you please test the following patch?

Thanks!

---------------->

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
 
