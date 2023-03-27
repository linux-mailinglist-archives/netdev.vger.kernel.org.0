Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CD96C9972
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 03:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjC0B6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 21:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC0B6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 21:58:36 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B14C37;
        Sun, 26 Mar 2023 18:58:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a16so6270725pjs.4;
        Sun, 26 Mar 2023 18:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679882312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjmUW5IisW2GWYy+PxnI3Bi0lsrMsX8ocUsfSaOhCyo=;
        b=WixHUlX/hYnaWWj5sw3xrgqurQGEGntBs6MIlZLXVl8IU9yOM7X+6txDnoh9zC6ldj
         X/wMby3DoEf+RjlGceqBnSUi2GOgA1IAjt32LJUgzE3WZw3ye2RGWMsxYQY80xbUk4OK
         dS6FLZ1cZ+Y89wNewGmUsTtiIgnifd7Ro6C9cotSMntovUwzTkBdB6BL0o5Q2FljQpf3
         aVSqo++ybvR8512hQSDNAIed3fs7phCpBc7iLxBLluxznNEawob4r42XaSSXUQQoph1j
         ibxUEYJRZ2UwJOcrOMCNjp4hexRwkjw28QlKwlLOxAHQqkRCFJr8L16aKZLsv+xMGQHr
         W/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679882312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjmUW5IisW2GWYy+PxnI3Bi0lsrMsX8ocUsfSaOhCyo=;
        b=Bf9RlKUXfl5Gisywn6iCJR89WssebIGpIcihT+d0tnqQ1D7iWr2oNL/RrAmo/dOnxI
         Tu5b+KddirLR4aAvoeDWS1GiKF1Z6lF5AqxKzll0Fuan92062XY6SdbVdlsBtJzwS/gY
         CIwQTyhY4uq5t6VCGsV+fZhiqmfynWYSCN9Jjtq2PVdL5AOdajz8Jd4GjetJQWY51hI5
         oRAW6CvXtPLXHTab3X2HxZVj1iyrf6IiSCClTjtPCDq9EQ4jeyXDD3J6/3VieBghGq9A
         dgE6M5utSA6VOUbXcqOohVPwKGnG8fPsS+GA9hD9HiobQG4LAFm5OItBKQIVLXhRhJOo
         kNUw==
X-Gm-Message-State: AAQBX9c5TijfaXlBtagbCXiu2LBtgHv7N3x3TQu0hXpIYn2Ij23Zbqnj
        5sr9BJvUpm5XLq+cFD1odzg=
X-Google-Smtp-Source: AKy350Z3zNguzhGHpgATQ8MDf0wd9rCZgBSx26nl8J2OHV3dYBp2fVoJa4zU1w1V3CPYh6oSPmALOg==
X-Received: by 2002:a17:902:ba88:b0:19e:25b4:7740 with SMTP id k8-20020a170902ba8800b0019e25b47740mr8682259pls.28.1679882312213;
        Sun, 26 Mar 2023 18:58:32 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id b20-20020a170902d89400b001a217a7a11csm5175006plz.131.2023.03.26.18.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 18:58:31 -0700 (PDT)
Date:   Mon, 27 Mar 2023 10:58:27 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
Message-ID: <ZCD4Q2rHnQokUxbe@dragonet>
References: <ZB/93xJxq/BUqAgG@dragonet>
 <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
 <ZCAytf0CpfAhjUSe@dragonet>
 <81ebf23b-f539-5782-2abd-8db8a232bb72@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81ebf23b-f539-5782-2abd-8db8a232bb72@hartkopp.net>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 06:17:17PM +0200, Oliver Hartkopp wrote:
> Hi Dae,
> 
> On 26.03.23 13:55, Dae R. Jeong wrote:
> > > diff --git a/net/can/isotp.c b/net/can/isotp.c
> > > index 9bc344851704..0b95c0df7a63 100644
> > > --- a/net/can/isotp.c
> > > +++ b/net/can/isotp.c
> > > @@ -912,13 +912,12 @@ static enum hrtimer_restart
> > > isotp_txfr_timer_handler(struct hrtimer *hrtimer)
> > >   		isotp_send_cframe(so);
> > > 
> > >   	return HRTIMER_NORESTART;
> > >   }
> > > 
> > > -static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
> > > size)
> > > +static int isotp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t
> > > size)
> > >   {
> > > -	struct sock *sk = sock->sk;
> > >   	struct isotp_sock *so = isotp_sk(sk);
> > >   	u32 old_state = so->tx.state;
> > >   	struct sk_buff *skb;
> > >   	struct net_device *dev;
> > >   	struct canfd_frame *cf;
> > > @@ -1091,10 +1090,22 @@ static int isotp_sendmsg(struct socket *sock, struct
> > > msghdr *msg, size_t size)
> > >   		wake_up_interruptible(&so->wait);
> > > 
> > >   	return err;
> > >   }
> > > 
> > > +static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
> > > size)
> > > +{
> > > +	struct sock *sk = sock->sk;
> > > +	int ret;
> > > +
> > > +	lock_sock(sk);
> > > +	ret = isotp_sendmsg_locked(sk, msg, size);
> > > +	release_sock(sk);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >   static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> > > size,
> > >   			 int flags)
> > >   {
> > >   	struct sock *sk = sock->sk;
> > >   	struct sk_buff *skb;
> > 
> > Hi, Oliver.
> > 
> > It seems that the patch should address the scenario I was thinking
> > of. But using a lock is always scary for a newbie like me because of
> > the possibility of causing other problems, e.g., deadlock. If it does
> > not cause other problems, it looks good for me.
> 
> Yes, I feel you!
> 
> We use lock_sock() also in the notifier which is called when someone removes
> the CAN interface.
> 
> But the other cases for e.g. set_sockopt() and for sendmsg() seem to be a
> common pattern to lock concurrent user space calls.


Yes, I see lock_sock() is a common pattern in *_sendmsg(). One thing I
wonder is whether sleeping (i.e., wait_event_*) after lock_sock() is
safe or not, as lock_sock() seems to have mutex_lock() semantics.

Perhaps we may need to unlock - wait_event - lock in istop_sendmsg()?
If so, we also need to consider various possible thread interleaving
cases.


> > Or although I'm not sure about this, what about getting rid of
> > reverting so->tx.state to old_state?
> > 
> > I think the concurrent execution of isotp_sendmsg() would be
> > problematic when reverting so->tx.state to old_state after goto'ing
> > err_out.
> Your described case in the original post indeed shows that this might lead
> to a problem.
> 
> > There are two locations of "goto err_out", and
> > iostp_sendmsg() does nothing to the socket before both of "goto
> > err_out". So after goto'ing err_out, it seems fine for me even if we
> > do not revert so->tx.state to old_state.
> > 
> > If I think correctly, this will make cmpxchg() work, and prevent the
> > problematic concurrent execution. Could you please check the patch
> > below?
> 
> Hm, interesting idea.
> 
> But in which state will so->tx.state be here:
> 
> /* wait for complete transmission of current pdu */
> err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> if (err)
> 	goto err_out;
> 
> 
> Should we better set the tx.state in the error case?
> 
> if (err) {
> 	so->tx.state = ISOTP_IDLE;
> 	goto err_out;
> }
> 
> Best regards,
> Oliver
> 
> (..)

Hmm... my original thought was that 1) isotp_sendmsg() waiting the
event (so->tx.state == ISTOP_IDLE) does not touch anything related to
the socket as well as the sending process yet, so 2) this
isotp_sendmsg() does not need to change the tx.state if it returns an
error due to a signal. I'm not sure that we need to set tx.state in
this case. Do we still need to do it?


Best regards,
Dae R. Jeong.
