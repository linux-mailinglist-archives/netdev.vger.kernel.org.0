Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84504624CCE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiKJVUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKJVUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:20:34 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C7657B4B;
        Thu, 10 Nov 2022 13:20:30 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y203so3163192pfb.4;
        Thu, 10 Nov 2022 13:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EqwM4gwAeNfGSn+/i30R0momCaUlYOIuUeVEKpk6Aqw=;
        b=lFA8i0GGzeYM4wrmg5464SiWgnCaVDIe63FDXcjVFkKLT3hUN4RSN/krm4vWh4+Ef2
         IVv86gAn+c6kvVFUKiNleko3mRjq0Ozh6uzDTWDNfUCw1Sc4iWlereD5QrvAOwYYMpx8
         x6BJSAWrBXpYlC0bdIr9YF+kmYSiixd54c6HGRVbZufmXQ4st20bmPrNuiu1qy7LlNZ9
         pnx1ZL8h+ixmUANnnPysjB7lWUXdtyMlhy876AxHdFNT6lkzPALTS7ANgqNMznvtN1qx
         WdHbI+F2Y9hLDLN7XJpZQMM8X6fRrMor9zi7LpQVRCcqYM1Q+U34Fe+JzdV8Jrl+F1lx
         WNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EqwM4gwAeNfGSn+/i30R0momCaUlYOIuUeVEKpk6Aqw=;
        b=4j7Rgoqz7iW5VFNUZwCKFn8AWsHZ9iAvdiRoKIvEwmLNX8gk3SvyeoiSI9XDkyV2Th
         spAWwmuAxtqSCiUo6mNw2yJwm+NS0glzrewsRzI25j4ZgNTCRl0e8f6ce0ScAbQeDkRX
         mTNrogLzrexh8sCcrbPkzGt1SPQPGYuFT6KXrx5YmTW8B5F/UERAHUEst7D8mFFTKJsS
         ZSbr9BdY0d0wp87QcyWTSno3lxP7mdsm9qecW1Vo7mkL8I59YpW9bSn6ECWYo7X7VmIw
         RuHrQvD7HDnyKmKe4MV0mfwWclseS8efGqTTb8G4kQawfeNR/4AFQqJFNVv8RXHG7WjR
         aybA==
X-Gm-Message-State: ACrzQf0im49oLOQ4M8s6WKm+ZF6+/+amaIDxupNSCkbrUgAVoZb9iTk8
        ffVK9yYwNEkzbMOAkOzRccJdNbZc6owhjGTVRE4=
X-Google-Smtp-Source: AMsMyM5QV4gBZkBeX4WEs89XOexMNHYQNng5q1/u5pkwDePHJu3uFlhXxA4SzvHEvvISi9XC2WPpJ8xd46Ye2TW9Rj0=
X-Received: by 2002:a63:1314:0:b0:46e:bb92:3de1 with SMTP id
 i20-20020a631314000000b0046ebb923de1mr3322351pgl.240.1668115229756; Thu, 10
 Nov 2022 13:20:29 -0800 (PST)
MIME-Version: 1.0
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
 <Y20Bxc1gQ8nrFsvA@lunn.ch>
In-Reply-To: <Y20Bxc1gQ8nrFsvA@lunn.ch>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Fri, 11 Nov 2022 08:20:18 +1100
Message-ID: <CAAvyFNg1F8ixrgy0YeL-TT5xLmk8N7dD=ZMLQ6VxsjHb_PU9bg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Nov 2022 at 00:51, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Nov 10, 2022 at 09:21:06PM +1100, Jamie Bainbridge wrote:
> > The SYN flood message prints the listening port number, but on a system
> > with many processes bound to the same port on different IPs, it's
> > impossible to tell which socket is the problem.
> >
> > Add the listen IP address to the SYN flood message. It might have been
> > nicer to print the address first, but decades of monitoring tools are
> > watching for the string "SYN flooding on port" so don't break that.
> >
> > Tested with each protcol's "any" address and a host address:
> >
> >  Possible SYN flooding on port 9001. IP 0.0.0.0.
> >  Possible SYN flooding on port 9001. IP 127.0.0.1.
> >  Possible SYN flooding on port 9001. IP ::.
> >  Possible SYN flooding on port 9001. IP fc00::1.
> >
> > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > ---
> >  net/ipv4/tcp_input.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 0640453fce54b6daae0861d948f3db075830daf6..fb86056732266fedc8ad574bbf799dbdd7a425a3 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -6831,9 +6831,19 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
> >               __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
> >
> >       if (!queue->synflood_warned && syncookies != 2 &&
> > -         xchg(&queue->synflood_warned, 1) == 0)
> > -             net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
> > -                                  proto, sk->sk_num, msg);
> > +         xchg(&queue->synflood_warned, 1) == 0) {
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +             if (sk->sk_family == AF_INET6) {
>
> Can the IS_ENABLED() go inside the if? You get better build testing
> that way.
>
>      Andrew

Are you sure? Why would the IS_ENABLED() be inside of a condition
which isn't compiled in? If IPv6 isn't compiled in then the condition
would never evaluate as true, so seems pointless a pointless
comparison to make? People not compiling in IPv6 have explicitly asked
*not* to have their kernel filled with a bunch of "if (family ==
AF_INET6)" haven't they?

There are many other examples of this pattern of "IS_ENABLED()" first
and "if (family == AF_INET6)" inside it, but I can't see any of the
inverse which I think you're suggesting, see:

 grep -C1 -ERHn "IS_ENABLED\(CONFIG_IPV6\)" net | grep -C1 "family == AF_INET6"

Please let me know if I've misunderstood?

Jamie
