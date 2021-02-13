Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D05F31AD5F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMRW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:22:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0A6C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:21:47 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gb24so1358695pjb.4
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Phu0L2Fzp1n1Ml2yc3skpHl5JVxECvTOZ8tA4mPIUo=;
        b=Rofhja5PJ7QnhPPoyWBWrBFJPgKLRuhxjQrkpl2GhEPg9Yjrolkeo9cB1EqZ8R9bqV
         DgHwpEOVC3r33MDJKSSPtO7mYmPHOMlWQBAKA3ZMD5MhxaQrAU9a77GyMI53Aq7aWuEs
         eQCUcUEFaf/qnsb0cfAS0gLd+NMeC/C6h4Ur0vOYS+HMyAIi29blXI7cqSK56u3wf3n7
         dTXtrRZrlfEKDkg9WAL4b9ajA2Q2u0DwLhhF5bN2KQ3eEBM2MaWmHUnUYfbembpCoPPw
         A8p8cAQUEONX13/APNr/cUbVgdd2lniWX21o6jMkCSyOFnMQBS8HwpL0XXROjpJSHCaC
         4LjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Phu0L2Fzp1n1Ml2yc3skpHl5JVxECvTOZ8tA4mPIUo=;
        b=ZCCfhDCILgeD9gIro56Fk3QS8mDPV2sKwX35UIIEYq2upSVct6VXXw1xALc06Gx6Jn
         /Bo6DG6ky849mWahx1KpJ4jB2u+YZLDmI5c9ta1x4uBZkM1DfMpoKl8HoExNMJg+Y8Mx
         5PuQbSqGUltO00WdxGIszXcFTYMe3uIAkdE7VUehyR9UmVXbbig6JuLUfKTBNxQkQEaP
         GSMkoHYGJBEgrNNWpbcK1h0d5cm32s5RMHS2AcZbZ0kBcT7Fc9NLCOFuxTdAoewGhS83
         w0c7QVVd7l/BVEJkyjdfpJkfq6s6snKOpNxqdECgNKIT1f7uaO/OBcQTIa9jI7dyNHJR
         rWeQ==
X-Gm-Message-State: AOAM533JWFXxI+Xba78Hv6E4mamvpgngmIGcwxBiU2Cm/1CZxbSl786m
        xKOjdPFd6k6Ztzg2rsvxb0ymK1oppKXx2WzPqvZLtA==
X-Google-Smtp-Source: ABdhPJwYYoSnqlVbz50wHHHg3hWhFV51qUV+dQMjH+v7Xh+tzWCw1wqbJxQVAdck0Mh+LQzps6Qc4SwUDi6PtMBVMtM=
X-Received: by 2002:a17:902:7296:b029:e3:419a:d3b6 with SMTP id
 d22-20020a1709027296b02900e3419ad3b6mr1502345pll.15.1613236907025; Sat, 13
 Feb 2021 09:21:47 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
 <20210212232214.2869897-3-eric.dumazet@gmail.com> <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
 <CANn89iJ-Y9avDrs3Jbx93J8zwMFfrY8Pq1LAL6tYWDvtcfdWKg@mail.gmail.com>
 <CANn89iK7U69XKZVFS2PXUSZhck5xaRE-hkxVe7Q1pbaE8m1cZw@mail.gmail.com> <CAOFY-A2nCvCeradTLOaGDR7aYKkuxNPXjjKpcJR9KFyfdMLvDA@mail.gmail.com>
In-Reply-To: <CAOFY-A2nCvCeradTLOaGDR7aYKkuxNPXjjKpcJR9KFyfdMLvDA@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Sat, 13 Feb 2021 09:21:36 -0800
Message-ID: <CAOFY-A2ixQ3zzmnbcp0tkLoDspSMkenB_bkGJhek+bVT0tENWw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: factorize logic into tcp_epollin_ready()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 9:10 AM Arjun Roy <arjunroy@google.com> wrote:
>
> On Sat, Feb 13, 2021 at 12:05 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Feb 13, 2021 at 8:50 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Sat, Feb 13, 2021 at 1:30 AM Wei Wang <weiwan@google.com> wrote:
> > > >
> > >
> > > > >  void tcp_data_ready(struct sock *sk)
> > > > >  {
> > > > > -       const struct tcp_sock *tp = tcp_sk(sk);
> > > > > -       int avail = tp->rcv_nxt - tp->copied_seq;
> > > > > -
> > > > > -       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> > > > > -           !sock_flag(sk, SOCK_DONE) &&
> > > >
> > > > Seems "!sock_flag(sk, SOCK_DONE)" is not checked in
> > > > tcp_epollin_read(). Does it matter?
> > > >
> > >
> > >
> > > Yes, probably, good catch.
> > >
> > > Not sure where tcp_poll() gets this, I have to double check.
> >
> > It gets the info from sk->sk_hutdown & RCV_SHUTDOWN
> >
> > tcp_find() sets both sk->sk_shutdown |= RCV_SHUTDOWN and
> > sock_set_flag(sk, SOCK_DONE);
> >
> > This seems to suggest tcp_fin() could call sk->sk_data_ready() so that
> > we do not have to test for this unlikely condition in tcp_data_ready()
>
> When a thread is subsequently then woken up due to sk_data_ready(),
> and it calls tcp_stream_is_readable() but we had lowat > 1 set, is
> there a chance of that thread then thinking that the stream is not
> readable, despite SOCK_DONE being set? This is assuming that the check
> is not added to the refactored logic.
>
> Note that on a related note if the tcp memory pressure check (for
> system-wide pressure) is added just to the original code in
> tcp_data_ready() but not added to tcp_stream_is_readable() we had this
> kind of issue (sk_data_ready() was called but tcp_stream_is_readable()
> returned false).
>

Disregard,  I just saw your followup patch. So I guess it's fine.

-Arjun
