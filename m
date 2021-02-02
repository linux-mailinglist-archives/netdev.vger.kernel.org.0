Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC630B8C8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhBBHju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhBBHjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:39:47 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2F8C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 23:39:07 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id p15so17480483ilq.8
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 23:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85NsmGnH/h3mLA0zAWTg0SwIn6rv4xQMSg4dfNfOOg0=;
        b=r9AE9WpYxgNYObsdQ/v27iJW9mlWO9JptihPaLdst+eZKz9/RrA//O0zhtuOflT7hj
         kYgqZpJdnvk2Gmt4hGaIOPQsS50Z7UAI+Spnrf7eLAU99Gmju5UiUuy+j6VuS9cOnUyv
         Uh81T/3MBoDysp4Vv6B/Wns4GjLWntADl8CnqYsq9S/vR6pUYg6ra5a5baOtzHXCBRgw
         42xrQMl9fmBTcNSE4G98rAjT6Lplpi72Okec0yayTJcx/Ebg7a/o8IptzCkEmG6z/drw
         Mlzdd4x82J02GdFWKYo+1Q+P4VnDH2rdIh2gg1XKiDNvzrLzXKjR2UW7vuAov/8E7Cv5
         XN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85NsmGnH/h3mLA0zAWTg0SwIn6rv4xQMSg4dfNfOOg0=;
        b=X6YcqIfBv7Z3kzck6nF4lDn3ePO0XJmjLBiZ25msUO7GReDSYLfaNjGUMJMj6pVCgc
         UQMfOFkIEEaxKPk/2wZYwAxOy9+s/uLNa/cRMMNxnuweHUV5Z6GkzE2w9tnl/vvFHJCa
         cyTZTktNNC5iJVECwA9z+rfB/XIskgnKUlN4xxp8NcBFy7FP9qeufwyFehRaI0CJBHbS
         pWOHb4NzYze5xG93SULGpb38kricLuJGCtadpulmL9iSddvEfgWzD5Y2U9aENrDfmpAp
         xIfaowyGHn4W+xNHQJjSaVVk59JRptJivTDP+GbG4z/kN+BLohrTxMgtsxXrmRIel+X7
         8b5A==
X-Gm-Message-State: AOAM5308uUIE3oKlZrAicepgAcdGitZYPdBJE0m0LrZGfzznGPUMmG+n
        02BNWmgAZ6LwuuKbkLSU4Y+BBj1ZSoCP5bHuuOF+Eg==
X-Google-Smtp-Source: ABdhPJxZ5xKZocCFKKR0FLJJMW9X/kaMQHot8dr8dNSwrWHiRmz5RqxSQwKbFaTu3EgxXjOT9IGM0YlK8KunUVzPprQ=
X-Received: by 2002:a05:6e02:1d0e:: with SMTP id i14mr15081260ila.69.1612251546890;
 Mon, 01 Feb 2021 23:39:06 -0800 (PST)
MIME-Version: 1.0
References: <20210129001210.344438-1-hari@netflix.com> <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Feb 2021 08:38:55 +0100
Message-ID: <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariharan Ananthakrishnan <hari@netflix.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 11:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 29 Jan 2021 00:12:10 +0000 Hariharan Ananthakrishnan wrote:
> > Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
> > distinguish AF_INET and AF_INET6 families.
> >
> > The following tcp tracepoints are updated:
> > tcp:tcp_destroy_sock
> > tcp:tcp_rcv_space_adjust
> > tcp:tcp_retransmit_skb
> > tcp:tcp_send_reset
> > tcp:tcp_receive_reset
> > tcp:tcp_retransmit_synack
> > tcp:tcp_probe
> >
> > Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
> > Signed-off-by: Brendan Gregg <bgregg@netflix.com>
>
> Eric, any thoughts?


I do not use these tracepoints in production scripts, but I wonder if
existing tools could break after this change ?

Or do we consider tracepoints format is not part of the ABI and can be
arbitrarily changed by anyone ?
