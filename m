Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A4A3F02
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfH3UbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:31:23 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35249 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfH3UbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:31:22 -0400
Received: by mail-yw1-f65.google.com with SMTP id g19so2833480ywe.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 13:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l/iPmsSBHs9lOfu7eMgFdgNEiV7J8NZo4ayRAw+YCog=;
        b=Hv5csSP9dTUuDjQt6nUPn2RB5k3zM35uiE892cyi2gCbDBAICfeqWhPA+3wEpXxEuh
         Cyekp4vyFEgyBoqi1G8E2fUnC31uM0NvDM6KmGSqUPkXwJixdvEMRRPSXO8ejPJusw7A
         TrJo8nc2HFrOSesY0KXWdRvtwlbahYMI9QBr4qeVoUDXrkRFf0j1Mi1OjW/FEtp/wNIv
         v4JGwI4vp0ETUQHcnD8B3rmCvQGutyp2QOgSNg6cIIvwOg2C580ER8zK3LCLsHg+e8fl
         MUr8L0QXf7CIgFx8IeE7pZtA1e207LBoEkEyZfNn2BAqdZ5m5cuXfj6ol8VuqHkBQNBC
         hQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l/iPmsSBHs9lOfu7eMgFdgNEiV7J8NZo4ayRAw+YCog=;
        b=FUmTzq+fGFJ3ucj+XXb04cZLUoOIGRn/LTyGUytbi1b/IzPjrtuwW/5UriLojXPZM1
         Lrf0GrnuVAkVeRgf3hQISA/2oSrEKO4qo/pcK9j/GSJ7gz61hdROc57WMCNUOf8PzE6z
         rJLNI3lGRdS52MEtCzBbnbm/rZKsTlFaiWXkQaV3AnutI+3f2D8QFfQ2BO7o7CkA7+eb
         b5iE0mrKFQrLW3BeFvUKwLHrzQzCXGhRGQjQwYX4JZAvTCp0KEMl4z++j81i/xlrs0Zd
         tXL5awz6uOOJZy1Zv3yqWf3CDLbGnLBeWjFiet0nV8IG2M67jUW+LvYeDkPAkOciEuHY
         lCGA==
X-Gm-Message-State: APjAAAXDW1tjacgvpNlcksxCFU4t5+MpIxuD3D4hpqaD4e38GVyrO+Bt
        jJM0GIEuIHzVWOu31fkE6irU42T3
X-Google-Smtp-Source: APXvYqyx3zcG7db1P7pc8kUW4gwnMG5FOW8nIbB2Z9wzNcd/TAFU4bSqL8XFXIcNbR3MeHLO6TCcXQ==
X-Received: by 2002:a81:310e:: with SMTP id x14mr3697621ywx.430.1567197079534;
        Fri, 30 Aug 2019 13:31:19 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id a201sm1324267ywa.19.2019.08.30.13.31.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 13:31:17 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id t15so2934998ybg.7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 13:31:17 -0700 (PDT)
X-Received: by 2002:a25:254e:: with SMTP id l75mr12583871ybl.441.1567197076556;
 Fri, 30 Aug 2019 13:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
In-Reply-To: <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Aug 2019 16:30:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
Message-ID: <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Steve Zabele <zabele@comcast.net>,
        Network Development <netdev@vger.kernel.org>,
        shum@canndrew.org, vladimir116@gmail.com, saifi.khan@strikr.in,
        Daniel Borkmann <daniel@iogearbox.net>, on2k16nm@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/29/19 9:26 PM, Willem de Bruijn wrote:
>
> > SO_REUSEPORT was not intended to be used in this way. Opening
> > multiple connected sockets with the same local port.
> >
> > But since the interface allowed connect after joining a group, and
> > that is being used, I guess that point is moot. Still, I'm a bit
> > surprised that it ever worked as described.
> >
> > Also note that the default distribution algorithm is not round robin
> > assignment, but hash based. So multiple consecutive datagrams arriving
> > at the same socket is not unexpected.
> >
> > I suspect that this quick hack might "work". It seemed to on the
> > supplied .c file:
> >
> >                   score = compute_score(sk, net, saddr, sport,
> >                                         daddr, hnum, dif, sdif);
> >                   if (score > badness) {
> >   -                       if (sk->sk_reuseport) {
> >   +                       if (sk->sk_reuseport && !sk->sk_state !=
> > TCP_ESTABLISHED) {

This won't work for a mix of connected and connectionless sockets, of
course (even ignoring the typo), as it only skips reuseport on the
connected sockets.

> >
> > But a more robust approach, that also works on existing kernels, is to
> > swap the default distribution algorithm with a custom BPF based one (
> > SO_ATTACH_REUSEPORT_EBPF).
> >
>
> Yes, I suspect that reuseport could still be used by to load-balance incoming packets
> targetting the same 4-tuple.
>
> So all sockets would have the same score, and we would select the first socket in
> the list (if not applying reuseport hashing)

Can you elaborate a bit?

One option I see is to record in struct sock_reuseport if any port in
the group is connected and, if so, don't return immediately on the
first reuseport_select_sock hit, but continue the search for a higher
scoring connected socket.

Or do return immediately, but do this refined search in
reuseport_select_sock itself, as it has a reference to all sockets in the
group in sock_reuseport->socks[]. Instead of the straightforward hash.

Steve, Re: your point on a scalable QUIC server. That is an
interesting case certainly. Opening a connected socket per flow adds
both memory and port table pressure. I once looked into an SO_TXONLY
udp socket option that does not hash connected sockets into the port
table. In effect receiving on a small set of listening sockets (e.g.,
one per cpu) and sending over separate tx-only sockets. That still
introduces unnecessary memory allocation. OTOH it amortizes some
operations, such as route lookup.

Anyway, that does not fix the immediate issue you reported when using
SO_REUSEPORT as described.
