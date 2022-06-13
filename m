Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0340547DA6
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 04:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiFMClg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 22:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiFMClf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 22:41:35 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF996148;
        Sun, 12 Jun 2022 19:41:33 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d14so5306859eda.12;
        Sun, 12 Jun 2022 19:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VIQNGBkTrWXTaBxTRL5CQ1HE6TT8Zgl5qKdfXg9T5Xw=;
        b=C46YuerUT9pefViyXxvGPguXgiAyKAg6yBC86NkXMiCgm1Ai9ttqZx6PFq+G9xzYn1
         EdgfLD8UtE7GHTcH0w0njkPDgVifs687a+HgErSs1bu8Nto/+ieFp7TGS8h1/TErYu2s
         1M5lDdB7s+M8TyugQKdF5XZFZqUn2hq0jtUNuEctdL36OCQUXCnDX2S1Wgk1xIzNmvyG
         ZqO+lqfVU4D0rp+0W7X7g7jAGUQaupSHJcDSkXQjG8VR02TcRdhQ2AWYMK/tL3q+YdQV
         m3jvYQtZfJA2ZCiuIFfywJuBZ/s3ovyOTGfyBU6X0h+SmBKMbe3aew6pbEhc/TflW3Zo
         xUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VIQNGBkTrWXTaBxTRL5CQ1HE6TT8Zgl5qKdfXg9T5Xw=;
        b=ZhQHNOjoYpfede2KaFcrP938R49Q5vAPhfiYXqV4DyMpfwFho1slC1HV0aVD7vPrH7
         D6fkL3W6NzhmktpTqqSfFuCYqagsEaaHYRMVSNszv12v/4MnNvz3EdTEf3HTE/EQPEFW
         TuMit8gvJ2oIIEc9c42OvNx25C0E+RRlXfaFnG7T97WXlQB+m2Sf3iEA/VowrglRIycg
         gwyw3/XnUT74CExCs+yWLgnTGLDCa/tjrxmw5A4OwzZVoD1OlU2ET0MzsBxXDPIIfDsJ
         /lhHQVzGedjaAJRublSOAdmaf3PoUQvxT4nFQGnf1U3KSO06fhzg5/bJvRGAPXcWx/tF
         Mc2Q==
X-Gm-Message-State: AOAM531h5MKuMTnblWOu2BLORAJ4wn/G7oiukcFQ1tmyOn1/kNgDz5mc
        QqrE4dpncS6TljPnxv3842B6uogHBc3S4O74fWo=
X-Google-Smtp-Source: ABdhPJyIgYREbRZFqigq7Ks9oD7zSsD+12++rxOGHKiIPNOJ3+SNEu5ugMN9uhquAqXWyuLb3yfZ2Q55JZCVD4rk3C4=
X-Received: by 2002:a05:6402:5114:b0:42f:b5f3:1f96 with SMTP id
 m20-20020a056402511400b0042fb5f31f96mr51765249edd.260.1655088092009; Sun, 12
 Jun 2022 19:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220610034204.67901-1-imagedong@tencent.com> <20220610034204.67901-8-imagedong@tencent.com>
 <CANn89iKV63NRJ4om+_+JB+MCe6MKRVX3qS=0LwCUJ5z86jyrDA@mail.gmail.com>
In-Reply-To: <CANn89iKV63NRJ4om+_+JB+MCe6MKRVX3qS=0LwCUJ5z86jyrDA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 13 Jun 2022 10:41:20 +0800
Message-ID: <CADxym3an7YynHoEn6asiZ=V588BBp+3+ycg_zpexkbUmdcd+bg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 7/9] net: tcp: add skb drop reasons to tcp tw
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
        netdev <netdev@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Fri, Jun 10, 2022 at 5:04 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 8:45 PM <menglong8.dong@gmail.com> wrote:
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
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > Reported-by: Eric Dumazet <edumazet@google.com>
>
> I have suggested that consume_skb() could be an alias of
> kfree_skb_reason(skb, SKB_NOT_DROPPED),
> or something like that.
>
> In order to avoid silly constructs all over the places :
>
> if (reason)
>    kfree_skb_reason(skb, reason);
> else
>   consume_skb(skb);
>
> ->
>
> kfree_skb_reason(skb, reason);
>

This seems to be a good idea in some cases. However, I
am a little worried about that SKB_NOT_DROPPED can
be passed to kfree_skb_reason() by mistake, which happened
before. (Maybe I'm just overly worried, as this can be avoided
during we coding)

> > ---
> > v2:
> > - skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
> >   it (Eric Dumazet)
> > ---
> >  include/net/dropreason.h |  6 ++++++
> >  include/net/tcp.h        |  7 ++++---
> >  net/ipv4/tcp_ipv4.c      |  9 ++++++++-
> >  net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++----
> >  net/ipv6/tcp_ipv6.c      |  8 +++++++-
> >  5 files changed, 45 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/net/dropreason.h b/include/net/dropreason.h
> > index 86e89d3022b5..3c6f8e0f7f16 100644
> > --- a/include/net/dropreason.h
> > +++ b/include/net/dropreason.h
> > @@ -258,6 +258,12 @@ enum skb_drop_reason {
> >          * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
> >          */
> >         SKB_DROP_REASON_TCP_REQQFULLDROP,
> > +       /**
> > +        * @SKB_DROP_REASON_TIMEWAIT: socket is in time-wait state and all
> > +        * packet that received will be treated as 'drop', except a good
> > +        * 'SYN' packet
> > +        */
> > +       SKB_DROP_REASON_TIMEWAIT,
> >         /**
> >          * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
> >          * used as a real 'reason'
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
> > index 804fc5e0203e..e7bd2f410a4a 100644
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
> > @@ -2150,11 +2151,17 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
> > +               if (!drop_reason) {
> > +                       consume_skb(skb);
> > +                       return 0;
> > +               }
>
> Sorry, this is the kind of change which makes the whole exercise
> source of numerous problems later
> when backports are needed.
>
> You are sending patches today, but we are not sure you will be willing
> to spend days of work and tests to validate
> future backports with conflicts.

With making kfree_skb_reason(skb, SKB_NOT_DROPPED) consume_skb(skb),
it seems that the code here doesn't need to be changed anymore.


>
> >                 break;
> >         case TCP_TW_RST:
> >                 tcp_v4_send_reset(sk, skb);
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
> > index 0d2ba9d90529..41551a3b679b 100644
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
> > @@ -1815,11 +1816,16 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> >                         refcounted = false;
> >                         goto process;
> >                 }
> > +               SKB_DR_SET(drop_reason, TCP_FLAGS);
> >         }
> >                 /* to ACK */
> >                 fallthrough;
> >         case TCP_TW_ACK:
> >                 tcp_v6_timewait_ack(sk, skb);
> > +               if (!drop_reason) {
> > +                       consume_skb(skb);
> > +                       return 0;
> > +               }
> >                 break;
> >         case TCP_TW_RST:
> >                 tcp_v6_send_reset(sk, skb);
> > --
> > 2.36.1
> >
