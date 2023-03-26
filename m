Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D26C9412
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjCZLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 07:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 07:55:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DF583F7;
        Sun, 26 Mar 2023 04:55:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d22so3557716pgw.2;
        Sun, 26 Mar 2023 04:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679831739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vsYGOymIbMSq5ihk9SuqlxpucBCe9zjjmBH5HRFqBCg=;
        b=l4p6+eOrU7k86ZduHmI74sr3jysctIspXDm3jPFiE+RphBbnU37VvH9OcbAa0f/tlA
         KRNAH3TXAF+YqV3eXTwPRo+dgNrzmDASAKLqFgKV5YDLdmPb6Unj6EKmIRYqjdcnfoAp
         9LJXrTgcOgt8w59n8un0HQ9MXtM1Spxl0uhEdR+n6W+1hswDERfb6vCjzVflwkoxnSJ+
         SaH3iFkJpW22AisYe72UPiGGdVS5hTSHVOcS7PpHitS4HAZ5Ua2PTGuvrgbsUc2506z6
         XItnXw1pD/I+KvXbLsQWeaAL5uRRcQ1Em3qDy9//WJnX/PExbbWJdd85pwTFA6DTKhMd
         nCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679831739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsYGOymIbMSq5ihk9SuqlxpucBCe9zjjmBH5HRFqBCg=;
        b=gYYHIWn+jAdBGLNdRj2vu/WHNIKCVMpLjROWPIhttf0EBLl0/vv9gnKdMBLFFhwh4W
         PCj0hFLa1B+YBmEk5wkOhzrk13HJlIoPj/qf9G3I6+oQp1V6oovDck4girkBLEjg/eTM
         /VXvOchCrz60O73ga1oFCSnq66npeEGOsnWX74GhcorG2m12uCxrSrPV5Knsnjiv7EpN
         74vnLaLIqK6Eus84SSLvF/nJwIDQuVoxhKIC/Xsyw7MHcWX9Uy3ynRzgUbo/I5C1aHtt
         BNvA3i2AUbaaF08lFL1ozFvVofmmlSh7YV+iImNgzFnrL+EMK/opm81XPafuZfrTgNix
         ueEQ==
X-Gm-Message-State: AAQBX9edvaE/iYQJARW8uTOYqxvkH3HplXCZ4mKc/1yPSlA9zkj9NoqX
        wF8MLmo8GE77g+MyhnwojGo=
X-Google-Smtp-Source: AKy350YIygudPBos2qj5kYSo8mydY+Z4LoKpnQErBoVo6LWD0SpDtNzdR0PMPNS+IfhxqytoB9Ibzw==
X-Received: by 2002:a62:4ec9:0:b0:628:9b4:a6a3 with SMTP id c192-20020a624ec9000000b0062809b4a6a3mr7804668pfb.2.1679831738997;
        Sun, 26 Mar 2023 04:55:38 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78dd8000000b0062d7d3d7346sm414071pfr.20.2023.03.26.04.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 04:55:38 -0700 (PDT)
Date:   Sun, 26 Mar 2023 20:55:33 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
Message-ID: <ZCAytf0CpfAhjUSe@dragonet>
References: <ZB/93xJxq/BUqAgG@dragonet>
 <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 9bc344851704..0b95c0df7a63 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -912,13 +912,12 @@ static enum hrtimer_restart
> isotp_txfr_timer_handler(struct hrtimer *hrtimer)
>  		isotp_send_cframe(so);
> 
>  	return HRTIMER_NORESTART;
>  }
> 
> -static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
> size)
> +static int isotp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t
> size)
>  {
> -	struct sock *sk = sock->sk;
>  	struct isotp_sock *so = isotp_sk(sk);
>  	u32 old_state = so->tx.state;
>  	struct sk_buff *skb;
>  	struct net_device *dev;
>  	struct canfd_frame *cf;
> @@ -1091,10 +1090,22 @@ static int isotp_sendmsg(struct socket *sock, struct
> msghdr *msg, size_t size)
>  		wake_up_interruptible(&so->wait);
> 
>  	return err;
>  }
> 
> +static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t
> size)
> +{
> +	struct sock *sk = sock->sk;
> +	int ret;
> +
> +	lock_sock(sk);
> +	ret = isotp_sendmsg_locked(sk, msg, size);
> +	release_sock(sk);
> +
> +	return ret;
> +}
> +
>  static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> size,
>  			 int flags)
>  {
>  	struct sock *sk = sock->sk;
>  	struct sk_buff *skb;

Hi, Oliver.

It seems that the patch should address the scenario I was thinking
of. But using a lock is always scary for a newbie like me because of
the possibility of causing other problems, e.g., deadlock. If it does
not cause other problems, it looks good for me.

Or although I'm not sure about this, what about getting rid of
reverting so->tx.state to old_state?

I think the concurrent execution of isotp_sendmsg() would be
problematic when reverting so->tx.state to old_state after goto'ing
err_out. There are two locations of "goto err_out", and
iostp_sendmsg() does nothing to the socket before both of "goto
err_out". So after goto'ing err_out, it seems fine for me even if we
do not revert so->tx.state to old_state.

If I think correctly, this will make cmpxchg() work, and prevent the
problematic concurrent execution. Could you please check the patch
below?

Best regards,
Dae R. Jeong.

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9bc344851704..4630fad13803 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -918,7 +918,6 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
-	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
@@ -1084,9 +1083,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 err_out_drop:
 	/* drop this PDU and unlock a potential wait queue */
-	old_state = ISOTP_IDLE;
+	so->tx.state = ISOTP_IDLE;
 err_out:
-	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)
 		wake_up_interruptible(&so->wait);
 
