Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2C59B8B1
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 07:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiHVFT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 01:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiHVFT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 01:19:26 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD4C25587;
        Sun, 21 Aug 2022 22:19:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z187so9260721pfb.12;
        Sun, 21 Aug 2022 22:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=giyJvb5MceZvmd+O7/+oUKyqv96Z2OFMCAAIUudAKGg=;
        b=Xyg+c3MLt+j8GVAFZFpwninxt4lQlSHMK//4kJAKEPIHIHid6x6susbixn211WqNG/
         NpFzsY9hHF3bgVg6K0n+dMoJfyv753nns2sP4NOyRixOG8ixWot0Ot8PnK+zHABUs3b7
         IMfo1mrvQIzw2rBIhWpLbv8JBHN79TjG0bC0bw7LGgjA/gZhOX9E2qQvLvo+ef6giAIE
         f/cL7m/dYpWm5H+HwCcvk/9skMNPp2e8WM3F9yGd8S2ipbQK2OVXWbo3rXiOgYd7ZbfW
         4+tL1jwXHbeHr623zr4tStyNXcIfbN0fPggNqudDiBk0b8sQg9z5Wn28FrJFNwUR2AAN
         7bQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=giyJvb5MceZvmd+O7/+oUKyqv96Z2OFMCAAIUudAKGg=;
        b=6wLUn2VC3WybkXr/IugGMR5Cf3B716NpoIchqFxHeDiT3WEyHdgG2YICT6XuD285Ex
         34cKEc9nbBZgYTCjumgIcfsiCBXbJl7mOmiosadZiMSs4lBuauSYy1CFZ5gYeLZ8ZDZJ
         Ogx/GBaCrcwpfxZP8GYqqaUFGq00YVEntVCTIqKEMMJZO0QqsmU8hPF+P3uXtYZS471N
         KI/JtAHpcsXkRMtYweUAJxiW92qQg2JB/39GrRyhp0QCliQbRE+psqAj+yLEk4acIlVf
         fUpqXWQ4WYM/O3XdauIXHp1aBDB5QwAcxhErG48CzaSrtjz9UOG0cW+Pf0YDPhX1w+w0
         cnNQ==
X-Gm-Message-State: ACgBeo0BrjHN7dR/hJaEcG0GiHgVx5+tCBAZYbimIlRoMr2K8xQ1pQQY
        7janTB+4dpJNQ3lyjm2vbIk=
X-Google-Smtp-Source: AA6agR7YaKl/EFWBRm94AS2E4wLWUVRtwJh5qzuhEq/OkUV9lHc9qUF9gFkqO8X+fv/G2DiMxPO6dw==
X-Received: by 2002:a05:6a00:1393:b0:536:5b8a:c35b with SMTP id t19-20020a056a00139300b005365b8ac35bmr8330817pfg.5.1661145564683;
        Sun, 21 Aug 2022 22:19:24 -0700 (PDT)
Received: from localhost ([36.112.86.8])
        by smtp.gmail.com with ESMTPSA id y9-20020a634b09000000b004114cc062f0sm6387798pga.65.2022.08.21.22.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 22:19:24 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     khalid.masum.92@gmail.com
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com, paskripkin@gmail.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Date:   Mon, 22 Aug 2022 13:19:07 +0800
Message-Id: <20220822051907.104443-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAABMjtHJX6Rm1Ndg+bECbERWkFYdWbDDYd1-5bVFTu-qwKW=sA@mail.gmail.com>
References: <CAABMjtHJX6Rm1Ndg+bECbERWkFYdWbDDYd1-5bVFTu-qwKW=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 at 00:42, Khalid Masum <khalid.masum.92@gmail.com> wrote:
>
> On Sun, Aug 21, 2022 at 9:58 PM Khalid Masum <khalid.masum.92@gmail.com> wrote:
> >
> > On Sun, Aug 21, 2022 at 6:58 PM Hawkins Jiawei <yin31149@gmail.com> wrote:
> > >
> > The interruptible version fails to acquire the lock. So why is it okay to
> > force it to acquire the mutex_lock since we are in the interrupt context?
>
> Sorry, I mean, won't the function lose its ability of being interruptible?
> Since we are forcing it to acquire the lock.
> > >                         return sock_intr_errno(*timeo);
> > > +               }
> > >         }
> > >  }
> >
> > thanks,
> >   -- Khalid Masum
Hi, Khalid

In my opinion, _intr in rxrpc_wait_for_tx_window_intr() seems referring
that, the loop in function should be interrupted when a signal
arrives(Please correct me if I am wrong):
> /*
>  * Wait for space to appear in the Tx queue or a signal to occur.
>  */
> static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
> 					 struct rxrpc_call *call,
> 					 long *timeo)
> {
> 	for (;;) {
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		if (rxrpc_check_tx_space(call, NULL))
> 			return 0;
> 
> 		if (call->state >= RXRPC_CALL_COMPLETE)
> 			return call->error;
> 
> 		if (signal_pending(current))
> 			return sock_intr_errno(*timeo);
> 
> 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
> 		mutex_unlock(&call->user_mutex);
> 		*timeo = schedule_timeout(*timeo);
> 		if (mutex_lock_interruptible(&call->user_mutex) < 0)
> 			return sock_intr_errno(*timeo);
> 	}
> }

To be more specific, when a signal arrives,
rxrpc_wait_for_tx_window_intr() should know when executing
mutex_lock_interruptible() and get a non-zero value. Then
rxrpc_wait_for_tx_window_intr() should be interrupted, which means
function should be returned.

So I think, acquiring mutex_lock() seems won't effect its ability
of being interruptible.(Please correct me if I am wrong).

What's more, when the kernel return from
rxrpc_wait_for_tx_window_intr(), it will only handles the error case
before unlocking the call->user_mutex, which won't cost a long time.
So I think it seems Ok to acquire the call->user_mutex when
rxrpc_wait_for_tx_window_intr() is interrupted by a signal.


On Mon, 22 Aug 2022 at 03:18, Khalid Masum <khalid.masum.92@gmail.com> wrote:
>
> Maybe we do not need to lock since no other timer_schedule needs
> it.
>
> Test if this fixes the issue.
> ---
> diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
> index 1d38e279e2ef..640e2ab2cc35 100644
> --- a/net/rxrpc/sendmsg.c
> +++ b/net/rxrpc/sendmsg.c
> @@ -51,10 +51,8 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
>                         return sock_intr_errno(*timeo);
>
>                 trace_rxrpc_transmit(call, rxrpc_transmit_wait);
> -               mutex_unlock(&call->user_mutex);
>                 *timeo = schedule_timeout(*timeo);
> -               if (mutex_lock_interruptible(&call->user_mutex) < 0)
> -                       return sock_intr_errno(*timeo);
> +               return sock_intr_errno(*timeo);
>         }
>  }
>
> --
> 2.37.1
>

If it is still improper to patch this bug by acquiring the
call->user_mutex, I wonder if it is better to check before unlocking the lock
in rxrpc_do_sendmsg(), because kernel will always unlocking the call->user_mutex
in the end of the rxrpc_do_sendmsg():
> int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
> 	__releases(&rx->sk.sk_lock.slock)
> 	__releases(&call->user_mutex)
> {
> 	...
> out_put_unlock:
> 	mutex_unlock(&call->user_mutex);
> error_put:
> 	rxrpc_put_call(call, rxrpc_call_put);
> 	_leave(" = %d", ret);
> 	return ret;
> 
> error_release_sock:
> 	release_sock(&rx->sk);
> 	return ret;
> }
