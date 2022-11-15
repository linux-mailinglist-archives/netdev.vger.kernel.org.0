Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ADD6295D3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbiKOK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiKOK31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:29:27 -0500
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F9D1D0D3;
        Tue, 15 Nov 2022 02:29:26 -0800 (PST)
Received: by mail-qv1-f50.google.com with SMTP id w10so9532079qvr.3;
        Tue, 15 Nov 2022 02:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyWvwU9qjTDyVNHbJm/iJ/vqWlCu7gf1x9mYXMP0o0s=;
        b=U1gV9147mao2eWxw/DJT6PSoHL0HYZR5mE90ZaJVYYM9PtKPuiQlXgaAwVg3iEEFKr
         8ajiepuZ5CD89iSP/+QKt5qEih+TroXpxqIycInG83cyozLJyiN68GaYpvLD1oXZ81JP
         fVDFKcSR5KeSCJq9DRUusBcJIe1XxUcq3kOS11gg8XpV1NQohnrrYkSLO6tGG4uZRpvN
         nMtWyZHI+SYbHsTR7aQ9ZTU1laXQjthqQOUr/FDZy5NqDxhweOllQB07jlakd5QeneLh
         uxKmWohGehz4jUjEhucfAy2bmBHaUZOeG3ZFekNrrElLx1CHLnNEistB8M7g4TBjJsWo
         FdrQ==
X-Gm-Message-State: ANoB5pkK3CjbOeiXFEuYBXJdz/5cFjnQ4DXvlkFQQvcYcOGEmRVJwAxG
        ufgFS/WRPKn48XO1znkCItK8IO6IGuQO/Q==
X-Google-Smtp-Source: AA0mqf6Kl1TO+9DrcPFL66vwbqOU/7GQg4lDgu/aeyumvh2dvxgoBbJ9RSWLfnjXF8eD9+25o1Xwng==
X-Received: by 2002:a05:6214:2dc7:b0:4bb:754f:e974 with SMTP id nc7-20020a0562142dc700b004bb754fe974mr16089739qvb.2.1668508165617;
        Tue, 15 Nov 2022 02:29:25 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id i18-20020a05620a405200b006fa84082b6dsm8119048qko.128.2022.11.15.02.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 02:29:25 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id 136so1019384ybn.1;
        Tue, 15 Nov 2022 02:29:24 -0800 (PST)
X-Received: by 2002:a25:18c5:0:b0:6de:6183:c5c3 with SMTP id
 188-20020a2518c5000000b006de6183c5c3mr16199179yby.89.1668508164385; Tue, 15
 Nov 2022 02:29:24 -0800 (PST)
MIME-Version: 1.0
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
 <Y20Bxc1gQ8nrFsvA@lunn.ch> <CAAvyFNg1F8ixrgy0YeL-TT5xLmk8N7dD=ZMLQ6VxsjHb_PU9bg@mail.gmail.com>
 <Y217ikkZzXKKGix4@lunn.ch>
In-Reply-To: <Y217ikkZzXKKGix4@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 15 Nov 2022 11:29:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU4_BACY_7M8rQxPt+_A64Oz8O9PoAkFQfsP2yaWFUM6g@mail.gmail.com>
Message-ID: <CAMuHMdU4_BACY_7M8rQxPt+_A64Oz8O9PoAkFQfsP2yaWFUM6g@mail.gmail.com>
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Nov 10, 2022 at 11:42 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Nov 11, 2022 at 08:20:18AM +1100, Jamie Bainbridge wrote:
> > On Fri, 11 Nov 2022 at 00:51, Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Thu, Nov 10, 2022 at 09:21:06PM +1100, Jamie Bainbridge wrote:
> > > > The SYN flood message prints the listening port number, but on a system
> > > > with many processes bound to the same port on different IPs, it's
> > > > impossible to tell which socket is the problem.
> > > >
> > > > Add the listen IP address to the SYN flood message. It might have been
> > > > nicer to print the address first, but decades of monitoring tools are
> > > > watching for the string "SYN flooding on port" so don't break that.
> > > >
> > > > Tested with each protcol's "any" address and a host address:
> > > >
> > > >  Possible SYN flooding on port 9001. IP 0.0.0.0.
> > > >  Possible SYN flooding on port 9001. IP 127.0.0.1.
> > > >  Possible SYN flooding on port 9001. IP ::.
> > > >  Possible SYN flooding on port 9001. IP fc00::1.
> > > >
> > > > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > > > ---
> > > >  net/ipv4/tcp_input.c | 16 +++++++++++++---
> > > >  1 file changed, 13 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > > index 0640453fce54b6daae0861d948f3db075830daf6..fb86056732266fedc8ad574bbf799dbdd7a425a3 100644
> > > > --- a/net/ipv4/tcp_input.c
> > > > +++ b/net/ipv4/tcp_input.c
> > > > @@ -6831,9 +6831,19 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
> > > >               __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
> > > >
> > > >       if (!queue->synflood_warned && syncookies != 2 &&
> > > > -         xchg(&queue->synflood_warned, 1) == 0)
> > > > -             net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
> > > > -                                  proto, sk->sk_num, msg);
> > > > +         xchg(&queue->synflood_warned, 1) == 0) {
> > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > +             if (sk->sk_family == AF_INET6) {
> > >
> > > Can the IS_ENABLED() go inside the if? You get better build testing
> > > that way.
> > >
> > >      Andrew
> >
> > Are you sure? Why would the IS_ENABLED() be inside of a condition
> > which isn't compiled in? If IPv6 isn't compiled in then the condition
> > would never evaluate as true, so seems pointless a pointless
> > comparison to make? People not compiling in IPv6 have explicitly asked
> > *not* to have their kernel filled with a bunch of "if (family ==
> > AF_INET6)" haven't they?
> >
> > There are many other examples of this pattern of "IS_ENABLED()" first
> > and "if (family == AF_INET6)" inside it, but I can't see any of the
> > inverse which I think you're suggesting, see:
> >
> >  grep -C1 -ERHn "IS_ENABLED\(CONFIG_IPV6\)" net | grep -C1 "family == AF_INET6"
> >
> > Please let me know if I've misunderstood?
>
> So what i'm suggesting is
>
>                if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
>                        net_info_ratelimited("%s: Possible SYN flooding on port %d. IP %pI6c. %s.  Check SNMP counters.\n",
>                                        proto, sk->sk_num,
>                                        &sk->sk_v6_rcv_saddr, msg);
>                 }

Unfortunately the IPv6-specific members are not defined if
CONFIG_IPV6=n. Patch sent.

https://lore.kernel.org/netdev/d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
