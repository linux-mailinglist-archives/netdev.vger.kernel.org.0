Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415BAB2756
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389815AbfIMV3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:29:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36108 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389780AbfIMV3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:29:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so33390751wrd.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 14:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3d5qjKGs//+pI/zPgFvwTuhOyl9TdygDvNJJy6z0MJQ=;
        b=kcGjqp/++sfNgeGqE97KLoYLPwrKc8oFM+FwqCc2Bw0EPffnU7c6GvSMX6BX001O4j
         BtekP/GLDYfF0r492xI4xWi05SkYayKQGygkXOREdQcW9usFLUHis2tG6QjrCcPVY5at
         nia2UGy8lGWztJkqkly8EOk1sRbg+KqP36npco2VUO7xr5PyXjtFtBPVhb9Hrfp1m2Ag
         bf72eboxUGLvlgpjx1F/DiK+EltIM0IcIUbAVDy+xrNrFVKqDgNSpO3Km5c1nwMnIh3n
         xnzBzvnREjNDS5YDN6LjmXRC1SLYqymsTIydT0bIJYfkSU3tWvyRfmHFdAEQqk83gHtw
         UAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3d5qjKGs//+pI/zPgFvwTuhOyl9TdygDvNJJy6z0MJQ=;
        b=LY4i9mTWiF0p/nOX1IZquSOGB9c4yE+OCZavL72sr1+nJ4NYXBr0pFXMAXXJypaQWm
         PQm0y4DvT0fn+jJjKeOG9Pu6VArpKeoGZNXzZsNrvW8mS8C99TumV6MVZd87cJ0lEgYM
         6Rg6r2F5TBbEkqNj29xqqRrgaUKtS0ZmF1dTZpdnLEd03G0QnuTsIe3sB6pn6tSX+Zjb
         4IZgbaAfiZuyajgw602kP1aMN5MzNaDX8w7u/Rkccl+fA43+Vyj9MCFKmat8qRHEQzXi
         amDfg5WVeQnBRxn/+VQ9egGMUfoMHYvm9K4lfJyFaPYNWFOQ/vzS2izaBhCj5CRtXt/7
         p6BA==
X-Gm-Message-State: APjAAAX13A9ABp6M+txrxbCv/X053nEk08UAzG/YAYyEi2xGIhjj475p
        Z3x906CcZDnSYO/pBhHae+ZAB/r8Q5W8oy3JMbH2Fw==
X-Google-Smtp-Source: APXvYqwS0PvT0zpMbN3dlL91wfXWjpYCurT5RK1nV+pU4DK84kPxcQvphQz4HCKBCowCE0VPUIxN2qarSsQgbgB3XFQ=
X-Received: by 2002:adf:ee05:: with SMTP id y5mr5351983wrn.291.1568410151729;
 Fri, 13 Sep 2019 14:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190913193629.55201-1-tph@fb.com> <20190913193629.55201-2-tph@fb.com>
 <CADVnQymKS6-jztAbLu_QYWiPYMqoTf5ODzSg3UPJxH+vBt=bmw@mail.gmail.com>
In-Reply-To: <CADVnQymKS6-jztAbLu_QYWiPYMqoTf5ODzSg3UPJxH+vBt=bmw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 13 Sep 2019 14:28:33 -0700
Message-ID: <CAK6E8=ddxo+yg2tTiZm5YEbfPkeVkeZOGwB33+Qfb4Qfj4yDJA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 2:02 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Sep 13, 2019 at 3:36 PM Thomas Higdon <tph@fb.com> wrote:
> >
> > Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> > performance problems --
> > > (1) Usually when we're diagnosing TCP performance problems, we do so
> > > from the sender, since the sender makes most of the
> > > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > > From the sender-side the thing that would be most useful is to see
> > > tp->snd_wnd, the receive window that the receiver has advertised to
> > > the sender.
> >
> > This serves the purpose of adding an additional __u32 to avoid the
> > would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> >
> > Signed-off-by: Thomas Higdon <tph@fb.com>
> > ---
> > changes from v3:
> >  - changed from rcv_wnd to snd_wnd
> >
> >  include/uapi/linux/tcp.h | 1 +
> >  net/ipv4/tcp.c           | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index 20237987ccc8..240654f22d98 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -272,6 +272,7 @@ struct tcp_info {
> >         __u32   tcpi_reord_seen;     /* reordering events seen */
> >
> >         __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
> > +       __u32   tcpi_snd_wnd;        /* Remote peer's advertised recv window size */
> >  };
>
> Thanks for adding this!
>
> My run of ./scripts/checkpatch.pl is showing a warning on this line:
>
> WARNING: line over 80 characters
> #19: FILE: include/uapi/linux/tcp.h:273:
> +       __u32   tcpi_snd_wnd;        /* Remote peer's advertised recv
> window size */
>
> What if the comment is shortened up to fit in 80 columns and the units
> (bytes) are added, something like:
>
>         __u32   tcpi_snd_wnd;        /* peer's advertised recv window (bytes) */
just a thought: will tcpi_peer_rcv_wnd be more self-explanatory?
>
> neal
