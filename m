Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E9131AD53
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBMRL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhBMRLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:11:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320DEC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:11:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d13so1475879plg.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2iOQUmUv0avPT+iSMRUEZU7+gozMspWbyiyqrj7Aq+0=;
        b=Laotg1P2KUFJ4zgkWQWkIIu0JkHOEdF0CcRwBhu1gyGaKjcVVnN5HGQZK0npnbCdFH
         7HZyCBU2YzW7uGuVVkPq0CpVz/4dSLJSsTN9kwMEM4ggYH3ZuXyeIrukbmMYxu3KB5SC
         XtSdlzzZjD5iF/tVN2vt/U+Zcv5gVM9SAh+ovHKewbj0yM6cUAMEmmdM0E9S2CIHOeH/
         vxvHSPnhYFc/cQfe8kq3lIq+DBANP5TbvpoFIB+Xg/2R9Qg3Z3cZCSqgwUD99sEz2qZr
         W/JKBu4bagwAa+Dwfc5fb/wperfxKSgD6+pqBqY1q0+xMlHPzm19aULcojDH6nQP9jOW
         +Tcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2iOQUmUv0avPT+iSMRUEZU7+gozMspWbyiyqrj7Aq+0=;
        b=BZ6UkZAC+rHIHyd5hYnHjkOeA2IM2cfbsY5l1yDNMlOXUjzERXyV31ziwcz/QFq6dO
         pQpS8Wavv7L6cytO0hFxhlogVQIHv3AHl8ymME+7h1IVRaH30/JPceIbxwdz0jM1pA8V
         1Kj9qgWRQ3u+rCRqQyTw6WGdcrc9OmCS77F9yZhHcEPfiC6OmPrJFgfiMxspiUGVEXs0
         1U12iFi+lBtDtz4Jkq5DqJiiPyVIrHi8CSWR/Xt4afpDnLit8n3INVlSvwT1sGNplOg7
         t645qn7nFpHYIEG+O3IFZvzIYZQoh8utuH9zaf/4GbEBko61Va5JnKklLNq/ciOf+MpR
         /tAg==
X-Gm-Message-State: AOAM533TkQbl6d9q9F5F1cCIvgLCvJFgKSI0LfHFOJRHeqb8Y4KHc/Qk
        n4XXSjSZr+grZT4jKB4SL3/3s8BAF1V6mlctsG3nRw==
X-Google-Smtp-Source: ABdhPJwW/yr8wYdIuhcIN535JJW+jrA0RK1hPbdxzTOHHe0VIDxaQS/GeAyGfnQ+FXflADfbCTVZWdl3qLj4uh2ShOk=
X-Received: by 2002:a17:90a:ee97:: with SMTP id i23mr7791419pjz.85.1613236262349;
 Sat, 13 Feb 2021 09:11:02 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
 <20210212232214.2869897-3-eric.dumazet@gmail.com> <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
 <CANn89iJ-Y9avDrs3Jbx93J8zwMFfrY8Pq1LAL6tYWDvtcfdWKg@mail.gmail.com> <CANn89iK7U69XKZVFS2PXUSZhck5xaRE-hkxVe7Q1pbaE8m1cZw@mail.gmail.com>
In-Reply-To: <CANn89iK7U69XKZVFS2PXUSZhck5xaRE-hkxVe7Q1pbaE8m1cZw@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Sat, 13 Feb 2021 09:10:51 -0800
Message-ID: <CAOFY-A2nCvCeradTLOaGDR7aYKkuxNPXjjKpcJR9KFyfdMLvDA@mail.gmail.com>
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

On Sat, Feb 13, 2021 at 12:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Feb 13, 2021 at 8:50 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Feb 13, 2021 at 1:30 AM Wei Wang <weiwan@google.com> wrote:
> > >
> >
> > > >  void tcp_data_ready(struct sock *sk)
> > > >  {
> > > > -       const struct tcp_sock *tp = tcp_sk(sk);
> > > > -       int avail = tp->rcv_nxt - tp->copied_seq;
> > > > -
> > > > -       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> > > > -           !sock_flag(sk, SOCK_DONE) &&
> > >
> > > Seems "!sock_flag(sk, SOCK_DONE)" is not checked in
> > > tcp_epollin_read(). Does it matter?
> > >
> >
> >
> > Yes, probably, good catch.
> >
> > Not sure where tcp_poll() gets this, I have to double check.
>
> It gets the info from sk->sk_hutdown & RCV_SHUTDOWN
>
> tcp_find() sets both sk->sk_shutdown |= RCV_SHUTDOWN and
> sock_set_flag(sk, SOCK_DONE);
>
> This seems to suggest tcp_fin() could call sk->sk_data_ready() so that
> we do not have to test for this unlikely condition in tcp_data_ready()

When a thread is subsequently then woken up due to sk_data_ready(),
and it calls tcp_stream_is_readable() but we had lowat > 1 set, is
there a chance of that thread then thinking that the stream is not
readable, despite SOCK_DONE being set? This is assuming that the check
is not added to the refactored logic.

Note that on a related note if the tcp memory pressure check (for
system-wide pressure) is added just to the original code in
tcp_data_ready() but not added to tcp_stream_is_readable() we had this
kind of issue (sk_data_ready() was called but tcp_stream_is_readable()
returned false).

-Arjun

-Arjun
