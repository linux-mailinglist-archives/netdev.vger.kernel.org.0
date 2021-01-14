Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005792F56BF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbhANBwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbhANADP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:03:15 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B258C0617A3;
        Wed, 13 Jan 2021 16:00:56 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d20so3671358otl.3;
        Wed, 13 Jan 2021 16:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mGiErg+ThYhjWzfJKnXdQRNk0z0ukbTIuJfIBkdLLsE=;
        b=u6Rv08CrjYqViokdKv3Cs89TSAvgNXGYiu6KR890EA17H/weflue0aXuZyeqg/Isd+
         JM38L6fB57Dg1c/WuI4T5mH38tk/V5+YZ71jhYFpKyKMEPDEJ/Shq6vXYn1Q1EBQYzta
         CKWqt9yGuQB/M60iLfxz71I3rLiqNL2F8Y46Xo9va3mibZvbTIquveycgR12gr4tg512
         ixoz8jkiCqN1YN++fnMB5BA2tuGFr+3Yi0PNpus1MC2I138nfV2PVuUJOeN90Q0bEGmk
         Q+y9j88mTmgXI/DfOPz1IOEbpTpn7yQcDgL1QdIE9hNv9qYbujXBnUmGmhoOz/r3Ke84
         fyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mGiErg+ThYhjWzfJKnXdQRNk0z0ukbTIuJfIBkdLLsE=;
        b=Iq3t5ZO19DmAuvz5+uSyY0BiB1e0uNf/FgpWr36leJ7hADOasC6h6HiFMLhmBoXxmX
         mVZeSIXsEc5z78LRs9zgpq9qhYRd5a7stJ+VAHVemLhB+106hzLIaJDKWX0SBg9rAOdV
         jOrSxB6E9o74AGKmXi6T6GhM1Y9VK1/lM0OM0tWpftcJhbTNDKLPy84Cwwk2lR0vkk0c
         hI5Xqdd8dx0QKuG4SVDFXJVxKLvV5D5ophIG6zDZbRowwUlwFquwYMoQ4vibyBv60cCi
         XiBNifz9BBuRySc6pqCaYexn31rt0B7sltVlWtvQItt1SfyM0ZQir4DR2xlbjMf7Vt0j
         YOtA==
X-Gm-Message-State: AOAM531zXXNPyLOI5yehl72z81Shd0YazChGFKSuSOkqC11jWKQMBhxM
        g259fB/KVoptcyTPYgdCr18=
X-Google-Smtp-Source: ABdhPJwVpLoN9CpJaBT6XzB0NbYNabCy/Lwx23VZ6afNzNxZHP8GbzkU/CESQPNtyHNBV71GjDZQag==
X-Received: by 2002:a9d:1720:: with SMTP id i32mr2935345ota.84.1610582455787;
        Wed, 13 Jan 2021 16:00:55 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id n16sm762288oov.23.2021.01.13.16.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:00:55 -0800 (PST)
Date:   Wed, 13 Jan 2021 16:00:53 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>
Subject: Re: [PATCH] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210114000053.GA3738@localhost.localdomain>
References: <20210113201201.GC2274@localhost.localdomain>
 <CANn89iJh1_fCm93B0w2VAzCLPUTSow85JMBQT3sy=0sALbXhrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJh1_fCm93B0w2VAzCLPUTSow85JMBQT3sy=0sALbXhrQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Eric:

Yes, that is a good point! I have been discussing with Neal and Yuchung also
and will work on revising the patch.

Thanks.   -- Enke

On Wed, Jan 13, 2021 at 09:44:11PM +0100, Eric Dumazet wrote:
> On Wed, Jan 13, 2021 at 9:12 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > From: Enke Chen <enchen@paloaltonetworks.com>
> >
> > The TCP session does not terminate with TCP_USER_TIMEOUT when data
> > remain untransmitted due to zero window.
> >
> > The number of unanswered zero-window probes (tcp_probes_out) is
> > reset to zero with incoming acks irrespective of the window size,
> > as described in tcp_probe_timer():
> >
> >     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
> >     as long as the receiver continues to respond probes. We support
> >     this by default and reset icsk_probes_out with incoming ACKs.
> >
> > This counter, however, is the wrong one to be used in calculating the
> > duration that the window remains closed and data remain untransmitted.
> > Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> > actual issue.
> >
> > In this patch a separate counter is introduced to track the number of
> > zero-window probes that are not answered with any non-zero window ack.
> > This new counter is used in determining when to abort the session with
> > TCP_USER_TIMEOUT.
> >
> 
> I think one possible issue would be that local congestion (full qdisc)
> would abort early,
> because tcp_model_timeout() assumes linear backoff.
> 
> Neal or Yuchung can further comment on that, it is late for me in France.
> 
> packetdrill test would be :
> 
>    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
> 
>    +0 < S 0:0(0) win 0 <mss 1460>
>    +0 > S. 0:0(0) ack 1 <mss 1460>
> 
>   +.1 < . 1:1(0) ack 1 win 65530
>    +0 accept(3, ..., ...) = 4
> 
>    +0 setsockopt(4, SOL_TCP, TCP_USER_TIMEOUT, [3000], 4) = 0
>    +0 write(4, ..., 24) = 24
>    +0 > P. 1:25(24) ack 1
>    +.1 < . 1:1(0) ack 25 win 65530
>    +0 %{ assert tcpi_probes == 0, tcpi_probes; \
>          assert tcpi_backoff == 0, tcpi_backoff }%
> 
> // install a qdisc dropping all packets
>    +0 `tc qdisc delete dev tun0 root 2>/dev/null ; tc qdisc add dev
> tun0 root pfifo limit 0`
>    +0 write(4, ..., 24) = 24
>    // When qdisc is congested we retry every 500ms therefore in theory
>    // we'd retry 6 times before hitting 3s timeout. However, since we
>    // estimate the elapsed time based on exp backoff of actual RTO (300ms),
>    // we'd bail earlier with only 3 probes.
>    +2.1 write(4, ..., 24) = -1
>    +0 %{ assert tcpi_probes == 3, tcpi_probes; \
>          assert tcpi_backoff == 0, tcpi_backoff }%
>    +0 close(4) = 0
> 
> > Cc: stable@vger.kernel.org
> > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > Reported-by: William McCall <william.mccall@gmail.com>
> > Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> > ---
> >  include/linux/tcp.h   | 5 +++++
> >  net/ipv4/tcp.c        | 1 +
> >  net/ipv4/tcp_input.c  | 3 ++-
> >  net/ipv4/tcp_output.c | 2 ++
> >  net/ipv4/tcp_timer.c  | 5 +++--
> >  5 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index 2f87377e9af7..c9415b30fa67 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -352,6 +352,11 @@ struct tcp_sock {
> >
> >         int                     linger2;
> >
> > +       /* While icsk_probes_out is for unanswered 0 window probes, this
> > +        * counter is for 0-window probes that are not answered with any
> > +        * non-zero window (nzw) acks.
> > +        */
> > +       u8      probes_nzw;
> >
> >  /* Sock_ops bpf program related variables */
> >  #ifdef CONFIG_BPF
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index ed42d2193c5c..af6a41a5a5ac 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2940,6 +2940,7 @@ int tcp_disconnect(struct sock *sk, int flags)
> >         icsk->icsk_rto = TCP_TIMEOUT_INIT;
> >         icsk->icsk_rto_min = TCP_RTO_MIN;
> >         icsk->icsk_delack_max = TCP_DELACK_MAX;
> > +       tp->probes_nzw = 0;
> >         tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
> >         tp->snd_cwnd = TCP_INIT_CWND;
> >         tp->snd_cwnd_cnt = 0;
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index c7e16b0ed791..4812a969c18a 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3377,13 +3377,14 @@ static void tcp_ack_probe(struct sock *sk)
> >  {
> >         struct inet_connection_sock *icsk = inet_csk(sk);
> >         struct sk_buff *head = tcp_send_head(sk);
> > -       const struct tcp_sock *tp = tcp_sk(sk);
> > +       struct tcp_sock *tp = tcp_sk(sk);
> >
> >         /* Was it a usable window open? */
> >         if (!head)
> >                 return;
> >         if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
> >                 icsk->icsk_backoff = 0;
> > +               tp->probes_nzw = 0;
> >                 inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
> >                 /* Socket must be waked up by subsequent tcp_data_snd_check().
> >                  * This function is not for random using!
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index f322e798a351..1b64cdabc299 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -4084,10 +4084,12 @@ void tcp_send_probe0(struct sock *sk)
> >                 /* Cancel probe timer, if it is not required. */
> >                 icsk->icsk_probes_out = 0;
> >                 icsk->icsk_backoff = 0;
> > +               tp->probes_nzw = 0;
> >                 return;
> >         }
> >
> >         icsk->icsk_probes_out++;
> > +       tp->probes_nzw++;
> >         if (err <= 0) {
> >                 if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
> >                         icsk->icsk_backoff++;
> > diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> > index 6c62b9ea1320..87e9f5998b8e 100644
> > --- a/net/ipv4/tcp_timer.c
> > +++ b/net/ipv4/tcp_timer.c
> > @@ -349,6 +349,7 @@ static void tcp_probe_timer(struct sock *sk)
> >
> >         if (tp->packets_out || !skb) {
> >                 icsk->icsk_probes_out = 0;
> > +               tp->probes_nzw = 0;
> >                 return;
> >         }
> >
> > @@ -360,8 +361,8 @@ static void tcp_probe_timer(struct sock *sk)
> >          * corresponding system limit. We also implement similar policy when
> >          * we use RTO to probe window in tcp_retransmit_timer().
> >          */
> > -       if (icsk->icsk_user_timeout) {
> > -               u32 elapsed = tcp_model_timeout(sk, icsk->icsk_probes_out,
> > +       if (icsk->icsk_user_timeout && tp->probes_nzw) {
> > +               u32 elapsed = tcp_model_timeout(sk, tp->probes_nzw,
> >                                                 tcp_probe0_base(sk));
> >
> >                 if (elapsed >= icsk->icsk_user_timeout)
> > --
> > 2.29.2
> >
