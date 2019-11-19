Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B4910260F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfKSOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:11:11 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46239 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfKSOLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:11:10 -0500
Received: by mail-yb1-f196.google.com with SMTP id v15so8788590ybp.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 06:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijUbIX4chLkFkxKo3MttA1UYqVGKu6vSAm+4CZ4GrEo=;
        b=vFtgOOMXRnW7LdPn7Lm2GWTJRq1lUVRVxnlXAOnQuaAdFINsuao+BsZrOLFZJ9fN5Y
         U6W4vwJuY6T1W8zq5fbNUABBQowQSwJySXrCsAp9TsQKBlBDtvzwDgO21jAOmvva33lv
         U79z+MgtipCF+e/EkuCwNVo8Yd6WDju2oeOCNyc1ujjdOPHbRjfcjaHpokAOMsmbC8bX
         9lhWQUx4oU8cheWkI9iBEB8P7wsu2QjnDb3USe/VEwY6XzZbh7ZmQeKcTtBOvce0G3h+
         YeWl6ZJSTAdCTAQ6zJCZkYmGH0vyjwOApGzFvUTUfgO3WoN15LV7Q/CPnXIOb4/myD2T
         TrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijUbIX4chLkFkxKo3MttA1UYqVGKu6vSAm+4CZ4GrEo=;
        b=JaOaFacSx5OMT/dmWI8KXuBT0hVOgZhcZvyNj7JofTJ0Q6gUvan6VTI5UVPBg/ywFQ
         MBsUHmnF34ZTcfYTBmvQ7IuH7Rt/g3VBieBUqwhjcCq4Oyb7ncs3uKGGBGEILZI9mW0u
         JPRsyCep3n+xh6QKyP3WnMlQmOesTdj23uxNnUTBVvMLdup/nvdHLISZbIiRPkIliMa4
         /X3jmjrLRpG4GmytfQXRPkPBPp1kfgNAaIf0nbVT+NODcxrJE+Y7yHr7joaRWF0ZVxWk
         zUGVFgEwHRwFJd6hoGV0/Nj0sQb2yjEuCF74Mc8u9pMUnic3ZXNNOIpGfIEjrwnyg/a5
         1mPw==
X-Gm-Message-State: APjAAAVwPpMl2F2URIeMh+oKM2pL3wVEKofcGtsHF7uJxH4yvG4wRPEQ
        TqfbjGM3iv7EWazErd5nDUbO8Gmz
X-Google-Smtp-Source: APXvYqysa14+Tsg2RceNxuHh9X30dqz0hmGG7Hh41pEVH4baADpEGc1zwxxOO8etRxsKNqGkQD/Ynw==
X-Received: by 2002:a25:4b04:: with SMTP id y4mr30389988yba.478.1574172669090;
        Tue, 19 Nov 2019 06:11:09 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id j67sm9342584ywf.71.2019.11.19.06.11.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 06:11:08 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id g38so8790174ybe.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 06:11:07 -0800 (PST)
X-Received: by 2002:a25:b901:: with SMTP id x1mr28185294ybj.443.1574172667158;
 Tue, 19 Nov 2019 06:11:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574071944.git.pabeni@redhat.com> <643f2b258e275e915fa96ef0c635f9c5ff804c9d.1574071944.git.pabeni@redhat.com>
 <CA+FuTSf_GL2gfGnDnZiVzHpjbV6+bw25Pi-FMNdUGH4np9=N3Q@mail.gmail.com> <cb69bcc246e06a1a53287db571df1b98f82807d2.camel@redhat.com>
In-Reply-To: <cb69bcc246e06a1a53287db571df1b98f82807d2.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 19 Nov 2019 09:10:29 -0500
X-Gmail-Original-Message-ID: <CA+FuTSft+v5me2htnqFhG20uJgOkahd9g6bE66Yzb6-pVn5gsQ@mail.gmail.com>
Message-ID: <CA+FuTSft+v5me2htnqFhG20uJgOkahd9g6bE66Yzb6-pVn5gsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 4:59 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2019-11-18 at 15:29 -0500, Willem de Bruijn wrote:
> > On Mon, Nov 18, 2019 at 6:03 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > When doing RX batch packet processing, we currently always repeat
> > > the route lookup for each ingress packet. If policy routing is
> > > configured, and IPV6_SUBTREES is disabled at build time, we
> > > know that packets with the same destination address will use
> > > the same dst.
> > >
> > > This change tries to avoid per packet route lookup caching
> > > the destination address of the latest successful lookup, and
> > > reusing it for the next packet when the above conditions are
> > > in place. Ingress traffic for most servers should fit.
> > >
> > > The measured performance delta under UDP flood vs a recvmmsg
> > > receiver is as follow:
> > >
> > > vanilla         patched         delta
> > > Kpps            Kpps            %
> > > 1431            1664            +14
> >
> > Since IPv4 speed-up is almost half and code considerably more complex,
> > maybe only do IPv6?
>
> uhmm... I would avoid that kind of assimmetry, and I would not look
> down on a 8% speedup, if possible.

Okay, that's fair.

> > > @@ -104,9 +127,18 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
> > >                 skb = l3mdev_ip6_rcv(skb);
> > >                 if (!skb)
> > >                         continue;
> > > -               ip6_rcv_finish_core(net, sk, skb);
> > > +               ip6_rcv_finish_core(net, sk, skb, hint);
> > >                 dst = skb_dst(skb);
> > >                 if (curr_dst != dst) {
> > > +                       if (ip6_can_cache_route_hint(net)) {
> > > +                               _hint.refdst = skb->_skb_refdst;
> > > +                               memcpy(&_hint.daddr, &ipv6_hdr(skb)->daddr,
> > > +                                      sizeof(_hint.daddr));
> > > +                               hint = &_hint;
> > > +                       } else {
> > > +                               hint = NULL;
> > > +                       }
> >
> > not needed. ip6_can_cache_route_hit is the same for all iterations of
> > the loop (indeed, compile time static), so if false, hint is never
> > set.
>
> I think this is needed, instead: if CONFIG_MULTIPLE_TABLES=y,
> fib6_has_custom_rules can change at runtime - from 'false' to 'true'.
> If we don't reset 'hint', we could end-up with use-after-free.

Uhm, of course, this is not compile time static at all. I clearly
missed a part.

But such a config change does not expect instantaneous effect on
packets in flight, like those in the recv rcu critical section? In
which case it should be safe to treat all skbs in the list the same.

I would need to read that code more closely to be certain, and the
current solution errs on the side of caution, so is definitely fine as
is, of course.
