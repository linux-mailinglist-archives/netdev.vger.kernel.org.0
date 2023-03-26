Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2AC6C96BC
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjCZQRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 12:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCZQRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 12:17:22 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377A049CA;
        Sun, 26 Mar 2023 09:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679847437; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=HqVc5rLyGwFRIUua8+qsRzxjbw98PRJdF7LTUihsqE2MuDYaWJ4IYG2K7ybAAmXJRs
    caaPhn4AkGat1vmR+7FWG+dHoHww5z02aF49u7d04QZ9Y4GQbWW7sPXcZEkW8jMSaAct
    qdhQmSC7x+mRiFd1TZAhsNAplIophh7wCj45HGg9pU/FU2i5zJ9N0kQeD/151Dd3Xv1J
    3C2oV6Spxl3jVn3XPgfh8ZC92fFAgRX/1fH72DQL9SOS8Y1LrZEk8KPdsRsJsvQpEIkY
    gaj4X2r7kD+IliG63j1oaLHRmXpkkWA1G6ltih1sBujDh+oVJaOrTbSKGdqZ2GCR95p5
    kBRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679847437;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=jPn7qiKnVAHlho1+QPL3JiQ1DbaASQpXMMWBmuI+0qE=;
    b=cfn+uEL8Ae8tsuKQR4j6ZIj9pChGvnjrNGJogq/E9GsUJ4f5fhd2wDzwZ7P9NG0qUK
    QumDRnS5C9/i86gJgDibRfBtRl6JrTQSHf15R+UTmrMUma5oGtdCLvrsgOVvNtwKdp5Q
    gIuZ7CBpPx4SbvDahirhAUkpLaKq4I+ekB4LOPuG7pmweENu5ibXuQ+r04cIa++I5f0M
    RE0MAkrGNn5KRXDzV4mFGBEkTFsQqp4B7nM6rHXjfrfGKdu+oZC/OKdq1F4x4yagruWA
    cEj+Mm5utp3wRv9hRnGLcFjvYIluzt+sNkYroRXGAdWYTP7RlPLUP28YD9NXJ9623k7U
    OSDA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679847437;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=jPn7qiKnVAHlho1+QPL3JiQ1DbaASQpXMMWBmuI+0qE=;
    b=ISIlt39OAp6CmKbl33i8k4QtfiYR4bbUQgv143gZRsQRbD+RR6d+meldOihyI2/KQn
    fAKlZYdCFpGIpussX+zGrzBsW3rYsug3JbWhjIKiRDX6z9GUfU/gnzNfcHhe50v279F0
    OVhvJGbu/hDxhetflg+N25PPf+QO/FRace0w53DcKQ9NH80dkADPT/084iz48cCwdgr1
    t6MkRcwDKTCWXAdz/H0e6bp0mzwBow+HeS9nb6ujAluAdZARKzzvO6tualZeLoNG8AEW
    WlIaWs/cCD6J46WYm8eou0ACGKgUefqzdFwTGJ4BQkvcufRaygQ7xjVu0cdyihcGZIdW
    BR9A==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id n9397fz2QGHHSed
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 26 Mar 2023 18:17:17 +0200 (CEST)
Message-ID: <81ebf23b-f539-5782-2abd-8db8a232bb72@hartkopp.net>
Date:   Sun, 26 Mar 2023 18:17:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
Content-Language: en-US
To:     "Dae R. Jeong" <threeearcat@gmail.com>
Cc:     mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZB/93xJxq/BUqAgG@dragonet>
 <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
 <ZCAytf0CpfAhjUSe@dragonet>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <ZCAytf0CpfAhjUSe@dragonet>
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

Hi Dae,

On 26.03.23 13:55, Dae R. Jeong wrote:
>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>> index 9bc344851704..0b95c0df7a63 100644
>> --- a/net/can/isotp.c
>> +++ b/net/can/isotp.c
>> @@ -912,13 +912,12 @@ static enum hrtimer_restart
>> isotp_txfr_timer_handler(struct hrtimer *hrtimer)
>>   		isotp_send_cframe(so);
>>
>>   	return HRTIMER_NORESTART;
>>   }
>>
>> -static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
>> size)
>> +static int isotp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t
>> size)
>>   {
>> -	struct sock *sk = sock->sk;
>>   	struct isotp_sock *so = isotp_sk(sk);
>>   	u32 old_state = so->tx.state;
>>   	struct sk_buff *skb;
>>   	struct net_device *dev;
>>   	struct canfd_frame *cf;
>> @@ -1091,10 +1090,22 @@ static int isotp_sendmsg(struct socket *sock, struct
>> msghdr *msg, size_t size)
>>   		wake_up_interruptible(&so->wait);
>>
>>   	return err;
>>   }
>>
>> +static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
>> size)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	int ret;
>> +
>> +	lock_sock(sk);
>> +	ret = isotp_sendmsg_locked(sk, msg, size);
>> +	release_sock(sk);
>> +
>> +	return ret;
>> +}
>> +
>>   static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t
>> size,
>>   			 int flags)
>>   {
>>   	struct sock *sk = sock->sk;
>>   	struct sk_buff *skb;
> 
> Hi, Oliver.
> 
> It seems that the patch should address the scenario I was thinking
> of. But using a lock is always scary for a newbie like me because of
> the possibility of causing other problems, e.g., deadlock. If it does
> not cause other problems, it looks good for me.

Yes, I feel you!

We use lock_sock() also in the notifier which is called when someone 
removes the CAN interface.

But the other cases for e.g. set_sockopt() and for sendmsg() seem to be 
a common pattern to lock concurrent user space calls.

> Or although I'm not sure about this, what about getting rid of
> reverting so->tx.state to old_state?
> 
> I think the concurrent execution of isotp_sendmsg() would be
> problematic when reverting so->tx.state to old_state after goto'ing
> err_out.
Your described case in the original post indeed shows that this might 
lead to a problem.

> There are two locations of "goto err_out", and
> iostp_sendmsg() does nothing to the socket before both of "goto
> err_out". So after goto'ing err_out, it seems fine for me even if we
> do not revert so->tx.state to old_state.
> 
> If I think correctly, this will make cmpxchg() work, and prevent the
> problematic concurrent execution. Could you please check the patch
> below?

Hm, interesting idea.

But in which state will so->tx.state be here:

/* wait for complete transmission of current pdu */
err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
if (err)
	goto err_out;


Should we better set the tx.state in the error case?

if (err) {
	so->tx.state = ISOTP_IDLE;
	goto err_out;
}

Best regards,
Oliver

(..)

> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 9bc344851704..4630fad13803 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -918,7 +918,6 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   {
>   	struct sock *sk = sock->sk;
>   	struct isotp_sock *so = isotp_sk(sk);
> -	u32 old_state = so->tx.state;
>   	struct sk_buff *skb;
>   	struct net_device *dev;
>   	struct canfd_frame *cf;
> @@ -1084,9 +1083,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   
>   err_out_drop:
>   	/* drop this PDU and unlock a potential wait queue */
> -	old_state = ISOTP_IDLE;
> +	so->tx.state = ISOTP_IDLE;
>   err_out:
> -	so->tx.state = old_state;
>   	if (so->tx.state == ISOTP_IDLE)
>   		wake_up_interruptible(&so->wait);
>   
