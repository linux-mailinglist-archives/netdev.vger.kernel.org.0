Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6D62698AE
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgINWNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgINWNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:13:43 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1DCC06174A;
        Mon, 14 Sep 2020 15:13:42 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s19so999300ybc.5;
        Mon, 14 Sep 2020 15:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RglK90z0a3hBYnR6IDE3hTgXU5PR2qc3m3JzZSIHXEE=;
        b=WF+Tg8zxtyrao/CwpX5gyb6UeGKrgNQGSWbA+RWUHIQued+PwD1BcQIUUfteaGfVBi
         O2WlvV4PVa5HOp01iHKbSva9Yv2/s0qOF48xyUdjw+hxbJV9v7bkET/VqQkJxJ3ViQ/I
         Ob4obTCB5uX2btl6KaC2bjv98UHkxSwq9h7wvaBsVPyHZIgRy2RxbGhp9hXPR83j37ip
         cU9JB7UEtC/5q0ofqPXM519g9ghBDw7GTzmJm/dfNatdmaspPlZvdUCpmlsI+bMfCYtg
         /rvhHYYTrMLYiVBcZdwRGr70JIF3SioNQeVXLHj2mahuPl3wiIXIsUWS1mwaXDtJ9mJh
         3R6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RglK90z0a3hBYnR6IDE3hTgXU5PR2qc3m3JzZSIHXEE=;
        b=YvoMMu8jrJygBz66CJCwrGC7lVftiLqpKRgrPKqx1kCkC+NFdxXG6N/3tFj80I0hiO
         AWr5E6SDJGcMTO9yME+ddxkmtYF09L2ftYslRpagJcPI76uLZVXde8zNImDsBqdEB2bd
         kpQrH1RF8qZwtKlTKLMs+RaijsnxZWiuM4l9pBpwiQT+xuxb4a5+tDpFwmaRduRuu3MY
         xSLpaNFSWMr/xA4QGIGyXtG14xFIkzj8BzxzXtSyIM8tN1oq363DSVWHZ/M7D00W5cEE
         MdvdwXBX4f33FMd9cCj4y0EOkkd3m5OEHcDWHJBkBYeRL+0/yMBqwErsHDPvv8XsHh5F
         IugQ==
X-Gm-Message-State: AOAM533kqP7MZ1z7KE3assJhsaGXOAwPCGpISZuHPI/P5hHU8xBCqGOc
        bwamO0dGfFCueJYRZAOsIaBmZq4BkeSAJx31rfQ=
X-Google-Smtp-Source: ABdhPJz+Rr4zt5euw9s6DupxpOtAgiiDAXem4HuNapVvUp7m3R0+L27kNPJyawdySJn5s+jhU5PA5bDXGiQcYYyBWjo=
X-Received: by 2002:a25:e655:: with SMTP id d82mr24894623ybh.347.1600121621869;
 Mon, 14 Sep 2020 15:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net> <CAPhsuW74oqvhySsVqLKrtz9r-EJxHrXza0gSGK2nm6GnKjmakQ@mail.gmail.com>
In-Reply-To: <CAPhsuW74oqvhySsVqLKrtz9r-EJxHrXza0gSGK2nm6GnKjmakQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 15:13:31 -0700
Message-ID: <CAEf4Bza3yEmxEOXoS-sFBCBXju4O_z4XhC2Um+FM-3F793kz-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] bpf: expose is_mptcp flag to bpf_tcp_sock
To:     Song Liu <song@kernel.org>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:21 AM Song Liu <song@kernel.org> wrote:
>
> On Fri, Sep 11, 2020 at 8:07 AM Nicolas Rybowski
> <nicolas.rybowski@tessares.net> wrote:
> >
> > is_mptcp is a field from struct tcp_sock used to indicate that the
> > current tcp_sock is part of the MPTCP protocol.
> >
> > In this protocol, a first socket (mptcp_sock) is created with
> > sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
> > isn't directly on the wire. This is the role of the subflow (kernel)
> > sockets which are classical tcp_sock with sk_protocol set to
> > IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
> > sockets is the is_mptcp field from tcp_sock.
> >
> > Such an exposure in BPF is thus required to be able to differentiate
> > plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
> > programs.
> >
> > The choice has been made to silently pass the case when CONFIG_MPTCP is
> > unset by defaulting is_mptcp to 0 in order to make BPF independent of
> > the MPTCP configuration. Another solution is to make the verifier fail
> > in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
> > '#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
> > will not run if MPTCP is not set.
> >
> > An example use-case is provided in
> > https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples
> >
> > Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> > ---
> >  include/uapi/linux/bpf.h       | 1 +
> >  net/core/filter.c              | 9 ++++++++-
> >  tools/include/uapi/linux/bpf.h | 1 +
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 7dd314176df7..7d179eada1c3 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4060,6 +4060,7 @@ struct bpf_tcp_sock {
> >         __u32 delivered;        /* Total data packets delivered incl. rexmits */
> >         __u32 delivered_ce;     /* Like the above but only ECE marked packets */
> >         __u32 icsk_retransmits; /* Number of unrecovered [RTO] timeouts */
> > +       __u32 is_mptcp;         /* Is MPTCP subflow? */
>
> Shall we have an __u32 flags, and make is_mptcp a bit of it?
>

Bitfields are slow and more annoying to rewrite in verifier, so having
an __u32 field is actually good.

> Thanks,
> Song
> [...]
