Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7E3527CF9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiEPEzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiEPEzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:55:08 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF2D201BA;
        Sun, 15 May 2022 21:55:06 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id m20so26284624ejj.10;
        Sun, 15 May 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvR8kKQlWVcSVw4+q0gCkTvpa3x0ZNg1H46Z+x5/Me0=;
        b=BP1xrYzmSNe0SoX1TWfH8qAfYTDKrCfvrnn+vo3sFoDc186oZ7tVlRpK0j8/bgMX6z
         3H9lVDtghdKUV7gCoiwFpAelRqoaIrj/kthuTlaZdLmfMt90GbuZAD5+TSLTfxciTEuJ
         ORmh4xve+8GV12a2KG4Etpc3Lzv0DbiBpJO2Ceg2BVJgg2mppp3mHNMj33E0z7fi1G88
         AzscfMh5zej24ejM6yT+YK7keSP6TED+NSv4bgrj9BSTfcqU1SFhqIg7ya7iVgeDcSLT
         H2cfhodlltn7o+lWu6ChlbcvXu7nz1keAwNV/Fp5n/TcUn5JJe4VP8MJ9HINI5SmOos7
         QvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvR8kKQlWVcSVw4+q0gCkTvpa3x0ZNg1H46Z+x5/Me0=;
        b=BYBImWqzc6EezJ1SHqiShtANjAqYeVWpfkvQC4WcjBd9ElNLS0Y+fp2zOcQbLHAEUy
         WzTW76ikJV/CP2zlNtXksq8cHDmsWWq86mnAN4cIzivWQqgWq57KuW7ewL0TC7t4aoCX
         Gq+QI/zKe+VGO/T3RIsrl3AaHkhE5xqkgVCniO/ONspBMzZzPf4sxklPdQDl+FCxfnKz
         m9kiAHnCCCnoqTHF2ZgdVYgQP2rEcT6MBfglmOI9ZDNo64np5obXcYPUItdRis7MSxew
         ZM5L9wU4glLlKUt4iLTHloc2pou5PImhii5NUCEno8UxkAOhCFOetZQb/uhBLZzCYTHs
         ECpg==
X-Gm-Message-State: AOAM531ME4pMiJLBOBtHbQ/8uWfmDs2BdiM/sP78nZ/URVqVaReJsf2R
        lxo/d24mXPu7ba+mk4oC5Sc02ENqSRHR85lu3ZI=
X-Google-Smtp-Source: ABdhPJw7XXXaNgY14xms797wkt5OICCXjhm9UnlR+gvNbTthjFrQ1RFaRZ8prOof8DCbTrjbQotpXh7lzVqVJkH666s=
X-Received: by 2002:a17:907:1b0c:b0:6fe:25bf:b3e5 with SMTP id
 mp12-20020a1709071b0c00b006fe25bfb3e5mr5880927ejc.689.1652676904716; Sun, 15
 May 2022 21:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220516034519.184876-1-imagedong@tencent.com>
 <20220516034519.184876-9-imagedong@tencent.com> <CANn89iLxVgZfBA98DcAphxV1_scH2dx2Upc=XZ7+t0DWj8WNdg@mail.gmail.com>
In-Reply-To: <CANn89iLxVgZfBA98DcAphxV1_scH2dx2Upc=XZ7+t0DWj8WNdg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 16 May 2022 12:54:53 +0800
Message-ID: <CADxym3aTPAukW1FHZVxTRg0NYN=uBL5axo6W2YtLxiDyh3b8HA@mail.gmail.com>
Subject: Re: [PATCH net-next 8/9] net: tcp: add skb drop reasons to tcp tw
 code path
To:     Eric Dumazet <edumazet@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 12:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, May 15, 2022 at 8:46 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In order to get the reasons of skb drops, add a function argument of
> > type 'enum skb_drop_reason *reason' to tcp_timewait_state_process().
> >
> > In the origin code, all packets to time-wait socket are treated as
> > dropping with kfree_skb(), which can make users confused. Therefore,
> > we use consume_skb() for the skbs that are 'good'. We can check the
> > value of 'reason' to decide use kfree_skb() or consume_skb().
> >
> > The new reason 'TIMEWAIT' is added for the case that the skb is dropped
> > as the socket in time-wait state.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h   |  5 +++++
> >  include/net/tcp.h        |  7 ++++---
> >  net/ipv4/tcp_ipv4.c      | 11 +++++++++--
> >  net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++----
> >  net/ipv6/tcp_ipv6.c      | 10 ++++++++--
> >  5 files changed, 46 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 4578bbab5a3e..8d18fc5a5af6 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -560,6 +560,10 @@ struct sk_buff;
> >   * SKB_DROP_REASON_TCP_REQQFULLDROP
> >   *     request queue of the listen socket is full, corresponding to
> >   *     LINUX_MIB_TCPREQQFULLDROP
> > + *
> > + * SKB_DROP_REASON_TIMEWAIT
> > + *     socket is in time-wait state and all packet that received will
> > + *     be treated as 'drop', except a good 'SYN' packet
> >   */
> >  #define __DEFINE_SKB_DROP_REASON(FN)   \
> >         FN(NOT_SPECIFIED)               \
> > @@ -631,6 +635,7 @@ struct sk_buff;
> >         FN(TCP_ABORTONDATA)             \
> >         FN(LISTENOVERFLOWS)             \
> >         FN(TCP_REQQFULLDROP)            \
> > +       FN(TIMEWAIT)                    \
> >         FN(MAX)
> >
> >  /* The reason of skb drop, which is used in kfree_skb_reason().
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 082dd0627e2e..88217b8d95ac 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -380,9 +380,10 @@ enum tcp_tw_status {
> >  };
> >
> >
> > -enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
> > -                                             struct sk_buff *skb,
> > -                                             const struct tcphdr *th);
> > +enum tcp_tw_status
> > +tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> > +                          const struct tcphdr *th,
> > +                          enum skb_drop_reason *reason);
> >  struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
> >                            struct request_sock *req, bool fastopen,
> >                            bool *lost_race);
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 708f92b03f42..9174ee162633 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -2134,7 +2134,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >                 inet_twsk_put(inet_twsk(sk));
> >                 goto csum_error;
> >         }
> > -       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
> > +       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
> > +                                          &drop_reason)) {
> >         case TCP_TW_SYN: {
> >                 struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
> >                                                         &tcp_hashinfo, skb,
> > @@ -2150,12 +2151,18 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >                         refcounted = false;
> >                         goto process;
> >                 }
> > +               /* TCP_FLAGS or NO_SOCKET? */
> > +               SKB_DR_SET(drop_reason, TCP_FLAGS);
> >         }
> >                 /* to ACK */
> >                 fallthrough;
> >         case TCP_TW_ACK:
> >                 tcp_v4_timewait_ack(sk, skb);
> > -               break;
> > +               refcounted = false;
> > +               if (drop_reason)
> > +                       goto discard_it;
> > +               else
> > +                       goto put_and_return;
> >         case TCP_TW_RST:
> >                 tcp_v4_send_reset(sk, skb);
> >                 inet_twsk_deschedule_put(inet_twsk(sk));
> > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > index 1a21018f6f64..329724118b7f 100644
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -83,13 +83,15 @@ tcp_timewait_check_oow_rate_limit(struct inet_timewait_sock *tw,
> >   */
> >  enum tcp_tw_status
> >  tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> > -                          const struct tcphdr *th)
> > +                          const struct tcphdr *th,
> > +                          enum skb_drop_reason *reason)
> >  {
> >         struct tcp_options_received tmp_opt;
> >         struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
> >         bool paws_reject = false;
> >
> >         tmp_opt.saw_tstamp = 0;
> > +       *reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >         if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
> >                 tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
> >
> > @@ -113,11 +115,16 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> >                         return tcp_timewait_check_oow_rate_limit(
> >                                 tw, skb, LINUX_MIB_TCPACKSKIPPEDFINWAIT2);
> >
> > -               if (th->rst)
> > +               if (th->rst) {
> > +                       SKB_DR_SET(*reason, TCP_RESET);
> >                         goto kill;
> > +               }
> >
> > -               if (th->syn && !before(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt))
> > +               if (th->syn && !before(TCP_SKB_CB(skb)->seq,
> > +                                      tcptw->tw_rcv_nxt)) {
> > +                       SKB_DR_SET(*reason, TCP_FLAGS);
> >                         return TCP_TW_RST;
> > +               }
> >
> >                 /* Dup ACK? */
> >                 if (!th->ack ||
> > @@ -143,6 +150,9 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> >                 }
> >
> >                 inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
> > +
> > +               /* skb should be free normally on this case. */
> > +               *reason = SKB_NOT_DROPPED_YET;
> >                 return TCP_TW_ACK;
> >         }
> >
> > @@ -174,6 +184,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> >                          * protocol bug yet.
> >                          */
> >                         if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
> > +                               SKB_DR_SET(*reason, TCP_RESET);
> >  kill:
> >                                 inet_twsk_deschedule_put(tw);
> >                                 return TCP_TW_SUCCESS;
> > @@ -216,11 +227,14 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> >                 if (isn == 0)
> >                         isn++;
> >                 TCP_SKB_CB(skb)->tcp_tw_isn = isn;
> > +               *reason = SKB_NOT_DROPPED_YET;
> >                 return TCP_TW_SYN;
> >         }
> >
> > -       if (paws_reject)
> > +       if (paws_reject) {
> > +               SKB_DR_SET(*reason, TCP_RFC7323_PAWS);
> >                 __NET_INC_STATS(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
> > +       }
> >
> >         if (!th->rst) {
> >                 /* In this case we must reset the TIMEWAIT timer.
> > @@ -232,9 +246,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> >                 if (paws_reject || th->ack)
> >                         inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
> >
> > +               SKB_DR_OR(*reason, TIMEWAIT);
> >                 return tcp_timewait_check_oow_rate_limit(
> >                         tw, skb, LINUX_MIB_TCPACKSKIPPEDTIMEWAIT);
> >         }
> > +       SKB_DR_SET(*reason, TCP_RESET);
> >         inet_twsk_put(tw);
> >         return TCP_TW_SUCCESS;
> >  }
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 27c51991bd54..5c777006de3d 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -1795,7 +1795,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> >                 goto csum_error;
> >         }
> >
> > -       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
> > +       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
> > +                                          &drop_reason)) {
> >         case TCP_TW_SYN:
> >         {
> >                 struct sock *sk2;
> > @@ -1815,12 +1816,17 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> >                         refcounted = false;
> >                         goto process;
> >                 }
> > +               SKB_DR_SET(drop_reason, TCP_FLAGS);
> >         }
> >                 /* to ACK */
> >                 fallthrough;
> >         case TCP_TW_ACK:
> >                 tcp_v6_timewait_ack(sk, skb);
> > -               break;
> > +               refcounted = false;
> > +               if (drop_reason)
> > +                       goto discard_it;
> > +               else
> > +                       goto put_and_return;
>
> My brain exploded.
> I guarantee you that whoever is going to look at this code in one year
> will be completely lost.
> Adding so much complexity is crazy.
>

Yeah, I'm almost lost while adding this code.

> About: refcounted = false ;
>
> This is not going to be used id "goto discard_it;" is taken.
>
> If the "goto put_and_return;" is taken, this boils down to:
>
> return ret ? -1 : 0;
>
> Are you sure ret is even initialized at this point ?
>

About this part, it seems it's my mistake. The correct code
should be:

        case TCP_TW_ACK:
                tcp_v6_timewait_ack(sk, skb);
-               break;
+               if (drop_reason) {
+                       goto discard_it;
+               } else {
+                       consume_skb(skb); /* free skb here */
+                       return 0;
+               }

As you said, it's a little complex.

> Why are we doing this ? We were doing "return 0;"
>
> Also, where is skb freed ?
>
> Are you calling tcp_v6_timewait_ack(sk, skb) after skb has been freed ???
>
>



>
>
> >         case TCP_TW_RST:
> >                 tcp_v6_send_reset(sk, skb);
> >                 inet_twsk_deschedule_put(inet_twsk(sk));
> > --
> > 2.36.1
> >
