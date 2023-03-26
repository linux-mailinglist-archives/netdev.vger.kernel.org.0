Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43816C93F8
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 13:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjCZLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 07:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCZLSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 07:18:38 -0400
X-Greylist: delayed 185 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Mar 2023 04:18:35 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC6861A2
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 04:18:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679829326; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=gvu1PBAcSOcdZPWgnTBkS9BB1pOOBAACHG9/bgqKMFIldg/1sW601ARmglHmrTBmjQ
    HcGZzXBiuYJDvcC6oPGjUlTKJP2w7dSTVnSciSkP3XxMTJbMaDvfHIU2BK1GpSjDGKxa
    GIj2o7wEj110krhxJ+cdLoJa3oPHatW+hN3+OzOKg1cQ2m4/KkSj4kEfCgQ0EYOR0Hzg
    NG9/CuvqFe7WRxSTJHeGLpWxHgC2Ze2oSwtDZditZNUN7mU8m97UGKN4qp7r0nahAiMb
    y79+5XrJqCFHKOTTnxj7NJIX6FKgNyp2qM1FD5PU7MNI9HajDECRzuyUugvKe2UtMMXa
    vMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679829326;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=gzuaxz9sjVMiVIadcyYNO7aKkqVL68IqsYnkniUFExE=;
    b=hR0+gnFh+36P9UAQ7jYo2mBf9D+AdQmapfxIq0cakYruLANmKa50FC09Q5Yan+vkPb
    YaTBcMfx6XV8tHpaGlT8+K1jMNSeM7iwi/2ynWW0ovANcnZ6GaPj0DUTNHceAxY0bRYX
    dAks3MzRCNt1qvMRraFv0Wz+ZtkA3DXy76GjzbZxhv46n+Uwpqj45Te3hOl0nFNoFr/S
    SxkFG0o3y7ehL7vztvPsHVBB+y1CEBKixE4yz1lTXBxct54OB4TxZwJ94/nIUFoTvMsk
    lGwltJ7R4tGsXMySJAbCzu9QDOzW+0HI7BKKhVkiT0iDSRcyz22bCRFc6Z7dhiq029u7
    ihzA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679829326;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=gzuaxz9sjVMiVIadcyYNO7aKkqVL68IqsYnkniUFExE=;
    b=G77sLgJXgLbkC7ThmA9oavxAxgxvy/lVIf+oB+tvUqger4/RufrwN2rvi/k8Shq/CE
    AV0E0OijEEW7TKVaDmCkYXBgjJiDdxj8vxf9YU6AMMTwQfkx3bHGsvteZVFk0eLZIJOi
    wmX1V1+nCr1Bd86dfp9WALprZeI6jVXGLQVWp6GiU4uJBwTcL1QWsdcLn31aCqhFtJvc
    tny5nOO5hLBWKh4t9FUO4P9v7fvJypNPubebfHx/kJRuwCdlysD4U4EWaDlvwfjgQtS6
    HDPKrwkvbHO4JRME1S6xdbdnjcNWshhtro5H2n326hSG+9yOHfAZ/o+T7cY5JcVRsF46
    lLEg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id n9397fz2QBFQSDP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 26 Mar 2023 13:15:26 +0200 (CEST)
Message-ID: <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
Date:   Sun, 26 Mar 2023 13:15:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
To:     "Dae R. Jeong" <threeearcat@gmail.com>, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZB/93xJxq/BUqAgG@dragonet>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <ZB/93xJxq/BUqAgG@dragonet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 26.03.23 10:10, Dae R. Jeong wrote:
> Hi,
> 
> I am curious about the error handling logic in isotp_sendmsg() which
> looks a bit unclear to me.
> 
> I was looking the `WARNING in isotp_tx_timer_handler` warning [1],
> which was firstly addressed by a commit [2] but reoccured even after
> the commit.
> [1]: https://syzkaller.appspot.com/bug?id=4f492d593461a5e44d76dd9322e179d13191a8ef
> [2]: c6adf659a8ba can: isotp: check CAN address family in isotp_bind()
> 
> I thought that the warning is caused by the concurrent execution of
> two isotp_sendmsg() as described below (I'm not 100% sure though).
> 
> CPU1                             CPU2
> isotp_sendmsg()                  isotp_sendmsg()
> -----                            -----
> old_state = so->tx.state; // ISOTP_IDLE
> 
>                                   cmpxchg(&so->tx.state, ISTOP_IDLE, ISOTP_SENDING) // success
> 							     ...
> 							     so->tx.state = ISTOP_WAIT_FIRST_FC;
> 							     hrtimer_start(&so->txtimer);
> 
> cmpxchg(&so->tx.state, ISTOP_IDLE, ISOTP_SENDING) // failed
> // if MSG_DONTWAIT is set in msg->msg_flags or
> // a signal is delivered during wait_event_interruptible()
> goto err_out;
> err_out:
>      so->tx.state = old_state; // ISTOP_IDLE
> 
>                                   isotp_tx_timer_handler()
> 								 -----
> 								 switch (so->tx.state) {
> 								 default:
> 								     WARN_ONCE();
> 								 }
> 
> Then, a commit [3] changed the logic of tx timer, and removed the
> WARN_ONCE() statement. So I thought that the issue is completely
> handled.
> [3]: 4f027cba8216 can: isotp: split tx timer into transmission and timeout
> 
> But even after [3] is applied, I found a warning that seems related
> occurred [4] (in the kernel commit: 478a351ce0d6).
> [4]: https://syzkaller.appspot.com/bug?id=11d0e5f6fef53a0ea486bbd07ddd3cba66132150
> 
> So I wonder whether the `err_out` logic in isotp_sendmsg() is safe.
> For me, it looks like isotp_sendmsg() can change so->tx.state to
> ISTOP_IDLE at any time. It may not be a problem if all other locations
> are aware of this. Is this an intended behavior?
> 
> Thank you in advance.

Thank you for picking this up!

In fact I was not aware of the possibility of a concurrent execution of 
isotp_sendmsg() and thought cmpxchg() would just make it ...

But looking at other *_sendmsg() implementations a lock_sock() seems to 
be a common pattern to handle concurrent syscalls, see:

git grep -p lock_sock net | grep sendmsg

What do you think about adopting this to isotp_sendmsg()? See patch below.

Best regards,
Oliver

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..0b95c0df7a63 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -912,13 +912,12 @@ static enum hrtimer_restart 
isotp_txfr_timer_handler(struct hrtimer *hrtimer)
  		isotp_send_cframe(so);

  	return HRTIMER_NORESTART;
  }

-static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, 
size_t size)
+static int isotp_sendmsg_locked(struct sock *sk, struct msghdr *msg, 
size_t size)
  {
-	struct sock *sk = sock->sk;
  	struct isotp_sock *so = isotp_sk(sk);
  	u32 old_state = so->tx.state;
  	struct sk_buff *skb;
  	struct net_device *dev;
  	struct canfd_frame *cf;
@@ -1091,10 +1090,22 @@ static int isotp_sendmsg(struct socket *sock, 
struct msghdr *msg, size_t size)
  		wake_up_interruptible(&so->wait);

  	return err;
  }

+static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, 
size_t size)
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	lock_sock(sk);
+	ret = isotp_sendmsg_locked(sk, msg, size);
+	release_sock(sk);
+
+	return ret;
+}
+
  static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, 
size_t size,
  			 int flags)
  {
  	struct sock *sk = sock->sk;
  	struct sk_buff *skb;



