Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8465582720
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiG0MzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiG0MzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:55:16 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAEE6334
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:55:12 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 7so30163776ybw.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDS4U7YZir5p4zlbI6RrrDKS2N15hBPZ4NARzWVf2YQ=;
        b=mIoonCupdv/HrZ03ZrYqiC6N+b8MSQD3uxcwGCx4TraziWkw2ae1HZ8gwCJhlI1tNz
         NgeQuZY7qv/pDRc7uKofJcatWvUnttbo4PBlqmYoY5XFaPGfVgdHfbSQNx8oSKHCN4ew
         3+lHrSoTvaPPuJosLTJz81om03Bk5k8WWsqeFXsWOaWEW6FZs9kALFeqnMdM/lQkRj3F
         TjmPkSjX82tns8PJy3ytI0/YZpCH1pmKsdUGR57zuGmHwwwBEzp3LQH83k6cLP7VYkHQ
         tQ9809bc8YyC8pMemDaZPOZ1hcQkc/Q3lFvd/uVV9iG+iq4kHHpcHs1iTB8xVJvyAsLO
         FkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDS4U7YZir5p4zlbI6RrrDKS2N15hBPZ4NARzWVf2YQ=;
        b=vdBfYcRrz7a8hy8QSW7AnnpYqZcrR+FMOhzIp6tBD/b+7FpHWQyhxDPfH+p/EcVbh1
         xTFOrTc9MDL6oxy56IfuoMbJF+gksJgkyJBi3IgIbv41nB8DeV1TYKHC5OFa+dmsYBHL
         RnLwGxsUU4ZYejRocBnfGvmy6S5JeXhzOsCENZlVJZDSaOc2lz56bT0F4UCm9/myu97k
         tzBfeCqoOUeLrhU9bQ1NKkSE81M/L/Q4BSlDUaBO21hJL0VtjnOwwvY+fau+pcpEUw2j
         96yyNzOxNUtjvsgNnOq2SWYSxtVcKXlLYK6TQURVgiRptrWhVkqEy5AHzxOaEbi5mJkI
         ewYg==
X-Gm-Message-State: AJIora8bXmfhg3U3MTHaVYTX8t2SL7GdAiINCZRgI+NQlgnyFtcoYiHi
        j0YaN8exDZaS/PL9oLFacNCql9bZmSrnL840fl2Whg==
X-Google-Smtp-Source: AGRyM1s2avB+ZTwPekjHu6X6nyLlsJcIU32qG2qoGiW4ffIRbuQaA4BC2N0FEUcOoKuO5fu2aHVhsnYnvp8WgpO5qCU=
X-Received: by 2002:a25:ab84:0:b0:671:748b:ffab with SMTP id
 v4-20020a25ab84000000b00671748bffabmr5761866ybi.427.1658926511036; Wed, 27
 Jul 2022 05:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220721151041.1215017-1-marek@cloudflare.com>
 <20220721151041.1215017-2-marek@cloudflare.com> <CANn89iKi2yaw=H-E8e9iet-gwr9vR6SmN9hibHF-5nT44K+e+g@mail.gmail.com>
 <CAJPywTKf1FdCRt2DZz3H+yhXqdFQ2tq9eNC4jtNHb0SgLwGfgA@mail.gmail.com>
In-Reply-To: <CAJPywTKf1FdCRt2DZz3H+yhXqdFQ2tq9eNC4jtNHb0SgLwGfgA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jul 2022 14:54:59 +0200
Message-ID: <CANn89i++56L396Mhr1LxL3UN6D9uPMGsp5yaDTY5n4bhuir_BQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] RTAX_INITRWND should be able to bring the
 rcv_ssthresh above 64KiB
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     Lawrence Brakmo <brakmo@fb.com>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 1:19 PM Marek Majkowski <marek@cloudflare.com> wrote:
>
> On Fri, Jul 22, 2022 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Jul 21, 2022 at 5:10 PM Marek Majkowski <marek@cloudflare.com> wrote:
> > >
> > > We already support RTAX_INITRWND / initrwnd path attribute:
> > >
> > >  $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024
> > >
> > > However normally, the initial advertised receive window is limited to
> > > 64KiB by rcv_ssthresh, regardless of initrwnd. This patch changes
> > > that, bumping up rcv_ssthresh to value derived from initrwnd. This
> > > allows for larger initial advertised receive windows, which is useful
> > > for specific types of TCP flows: big BDP ones, where there is a lot of
> > > data to send immediately after the flow is established.
> > >
> > > There are three places where we initialize sockets:
> > >  - tcp_output:tcp_connect_init
> > >  - tcp_minisocks:tcp_openreq_init_rwin
> > >  - syncookies
> > >
> > > In the first two we already have a call to `tcp_rwnd_init_bpf` and
> > > `dst_metric(RTAX_INITRWND)` which retrieve the bpf/path initrwnd
> > > attribute. We use this value to bring `rcv_ssthresh` up, potentially
> > > above the traditional 64KiB.
> > >
> > > With higher initial `rcv_ssthresh` the receiver will open the receive
> > > window more aggresively, which can improve large BDP flows - large
> > > throughput and latency.
> > >
> > > This patch does not cover the syncookies case.
> > >
> > > Signed-off-by: Marek Majkowski <marek@cloudflare.com>
> > > ---
> > >  include/net/inet_sock.h  |  1 +
> > >  net/ipv4/tcp_minisocks.c |  8 ++++++--
> > >  net/ipv4/tcp_output.c    | 10 ++++++++--
> > >  3 files changed, 15 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> > > index daead5fb389a..bc68c9b70942 100644
> > > --- a/include/net/inet_sock.h
> > > +++ b/include/net/inet_sock.h
> > > @@ -89,6 +89,7 @@ struct inet_request_sock {
> > >                                 no_srccheck: 1,
> > >                                 smc_ok     : 1;
> > >         u32                     ir_mark;
> > > +       u32                     rcv_ssthresh;

Please move this in struct tcp_request_sock

> >
> > Why do we need to store this value in the request_sock ?
> >
> > It is derived from a route attribute and MSS, all this should be
> > available when the full blown socket is created.
> >
> > It would also work even with syncookies.
>
> Eric,
>
> Thanks for the feedback. For some context, I published a blog post
> explaining this work in detail [1].
>
> https://blog.cloudflare.com/when-the-window-is-not-fully-open-your-tcp-stack-is-doing-more-than-you-think/
>
> I understand the suggestion is to move tcp_rwnd_init_bpf +
> RTAX_INITRWND lookup from `tcp_openreq_init_rwin` into
> `tcp_create_openreq_child`.
>
> I gave it a try (patch: [2]), but I don't think this will work under
> all circumstances. The issue is that we need to advertise *some*
> window in the SYNACK packet, before creating the full blown socket.
>
> With RTAX_INITRWND it is possible to move the advertised window up, or
> down.
>
> In the latter case, of reducing the window, at the SYNACK moment we
> must know if the window is reduced under 64KiB. This is what happens
> right now, we can _reduce_ window with RTAX_INITRWND to small values,
> I guess down to 1 MSS. This smaller window is then advertised in the
> SYNACK.
>
> If we move RTAX_INITRWND lookup into the later
> `tcp_create_openreq_child` then it will be too late, we won't know the
> correct window size on SYNACK stage. We will likely end up sending
> large window on SYNACK and then a small window on subsequent ACK,
> violating TCP.
>
> There are two approaches here. First, keep the semantics and allow
> RTAX_INITRWND to _reduce_ the initial window.
>
> In this case there are four ways out of this:
>
> 1) Keep it as proposed, that indeed requires some new value in
> request_sock. (perhaps maybe it could be it smaller than u32)
>
> 2) Send the SYNACK with small/zero window, since we haven't done the
> initrwnd lookup at this stage, but that would be at least
> controversial, and also adds one more RTT to the common case. I don't
> think this is acceptable.
>
> 3) Do two initrwnd lookups. One in the `tcp_openreq_init_rwin` to
> figure out if the window is smaller than 64KiB, second one in
> `tcp_create_openreq_child` to figure out if the suggested window is
> larger than 64KiB.

I think syncookies can be handled, if you look at cookie_v6_check() &
cookie_v4_check()
after their calls to cookie_tcp_reqsk_alloc()

>
> 4) Abort the whole approach and recycle Ivan's
> bpf_setsockopt(TCP_BPF_RCV_SSTHRESH) approach [3]. But I prefer the route
> attribute approach, seems easier to use and more flexible.
>
> But, thinking about it, I don't think we could ever support reducing
> initial receive window in the syncookie case. Only (3) - two initrwnd
> lookups - could be made to work, but even that is controversial.
>
> However the intention of RTAX_INITRWND as far as I understand was to
> _increase_ rcv_ssthresh, back in the days when it started from 10MSS
> (so I was told).

That was before we fixed DRS and that we made initial RWIN 65535, the
max allowed value in a SYN , SYNACK packet.
But yes...

>
> So, we could change the semantics of RTAX_INITRWND to allow only
> *increasing* the window - and disallow reducing it. With such an
> approach indeed we could make the code as you suggested, and move the
> route attribute lookup away from minisocks into `tcp_create_openreq_child`.
>
> Marek
>
> [1] https://blog.cloudflare.com/when-the-window-is-not-fully-open-your-tcp-stack-is-doing-more-than-you-think/
> [2] https://gist.github.com/majek/13848c050a3dc218ed295364ee717879
> [3] https://lore.kernel.org/bpf/20220111192952.49040-1-ivan@cloudflare.com/t/
