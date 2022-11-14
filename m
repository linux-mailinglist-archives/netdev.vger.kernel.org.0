Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303076273E2
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 01:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiKNAhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 19:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKNAhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 19:37:52 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286EFE0A1;
        Sun, 13 Nov 2022 16:37:51 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id n205so10068498oib.1;
        Sun, 13 Nov 2022 16:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5UY/Q6C2fq/bjN/a67GjfDWWNNwphWU/lYcCBI/HwL0=;
        b=J2H3fe3gO/vA3TI8LwOFu6t5Ll/lmzpJKzKC3pnYOaIr5HSl9yJDXmTbE3y/9HSo7+
         GbPsOhEgzhdrOr9+M+sZAILvMKqtIR8zZvDIO/ikx+xwmOQKouvqS8q/VY05WTcVHZbf
         winj4I7ajqlyIqdoxScwGFg/Zr1LcZftg4PWTwtjR3UigLhlpjBIrT3Phx0bYp9CsjT2
         KRsae2UZa4vvOnstfxCOOCLfVVnhGM6w2T4Xal1NEVEyE7fxpgjyZFej6TgmE9e10Dhy
         5yxWZUabfrlZVlZUNF4tNXk7uKgYhAVKa4RFL6KCS5dS+Y64zrQTSiRItGzEz3xq3W5P
         LFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UY/Q6C2fq/bjN/a67GjfDWWNNwphWU/lYcCBI/HwL0=;
        b=vtakt/cSJpkQHK5P4AzZyhba0vwKGa2FZvBZhfyshu3jQ5+l1K5dD54ZL/V5NUoMop
         bhq8VRpNxDNUN56VrT8nYXWzSGSwWFFzkKYfMwOOoRXVBYYiltS/FMzIYs4zrn0bwRvu
         OlkA4Iw7B030bC3iljyzzlcyiMeNdM9KbcSo18n80L6n2kIgsxaUnWe7SN2ARkCn64+C
         st/ATDKdTinmGTAcp2uHAg4XsjWKOyorT1Rcnp7v+gtriaNCYWs43/LdBoU5g4OOi7+J
         MEnv9AmTdhUB5wFMSvXBaakr1R8j19iBGrZl5HTSEoztsmHvT5nyuJUVJTBLKQC0+Y+I
         DbCw==
X-Gm-Message-State: ANoB5pkLx0OFGiqNImEykDQ4XsSwAt9W2zXQuj8c5fqDRabNj8S2siBf
        /b6l5TQG2kC9KHQYtM+tKViGEqDhMUA2sP98ktI=
X-Google-Smtp-Source: AA0mqf4swdDI+THG8OPmYWVnP133zdd8/rlN5GBRpFqYaD3AWg09+ePZH2sTamx9Jamr1EEck29dI4QgSWG2O4pShSc=
X-Received: by 2002:a05:6808:3ab:b0:35a:8bcb:1b30 with SMTP id
 n11-20020a05680803ab00b0035a8bcb1b30mr4716677oie.88.1668386270465; Sun, 13
 Nov 2022 16:37:50 -0800 (PST)
MIME-Version: 1.0
References: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
 <20221111092047.7d33bcd3@hermes.local> <CAAvyFNhkn2Zv16RMWGCtQh4SpjJX56q8gyEL3Mz6Ru+Ef=SJfA@mail.gmail.com>
 <20221111161120.770b9db2@hermes.local> <CANn89i+sj9w+W3Mx-UsmaWzq_GcLwr=FQkHC61_2eBbvpVQQ1g@mail.gmail.com>
In-Reply-To: <CANn89i+sj9w+W3Mx-UsmaWzq_GcLwr=FQkHC61_2eBbvpVQQ1g@mail.gmail.com>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Mon, 14 Nov 2022 10:37:39 +1000
Message-ID: <CAAvyFNiKzVnL9EujP3VyCWFrvc5ZrpN=cJsTE95fFAMLU2yRLg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add listening address to SYN flood message
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
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

On Sat, 12 Nov 2022 at 10:14, Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Nov 11, 2022 at 4:11 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Sat, 12 Nov 2022 10:59:52 +1100
> > Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
> >
> > > On Sat, 12 Nov 2022 at 04:20, Stephen Hemminger
> > > <stephen@networkplumber.org> wrote:
> > > >
> > > > On Fri, 11 Nov 2022 14:59:32 +1100
> > > > Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
> > > >
> > > > > +         xchg(&queue->synflood_warned, 1) == 0) {
> > > > > +             if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > > > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
> > > > > +                                     proto, &sk->sk_v6_rcv_saddr,
> > > > > +                                     sk->sk_num, msg);
> > > > > +             } else {
> > > > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
> > > > > +                                     proto, &sk->sk_rcv_saddr,
> > > > > +                                     sk->sk_num, msg);
> > > >
> > > > Minor nit, the standard format for printing addresses would be to use colon seperator before port
> > > >
> > > >                 if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > > >                         net_info_ratelimited("%s: Possible SYN flooding on [%pI6c]:%u. %s.\n",
> > > >                                         proto, &sk->sk_v6_rcv_saddr, sk->sk_num, msg);
> > > >                 } else {
> > > >                         net_info_ratelimited("%s: Possible SYN flooding on %pI4:%u. %s.\n",
> > > >                                         proto, &sk->sk_rcv_saddr, sk->sk_num, msg);
> > >
> > > I considered this too, though Eric suggested "IP.port" to match tcpdump.
> >
> > That works, if it happens I doubt it matters.
>
> Note that "ss dst" really needs the [] notation for IPv6
>
> ss -t dst "[::1]"
> State                  Recv-Q             Send-Q
>     Local Address:Port                            Peer Address:Port
>          Process
> CLOSE-WAIT             1                  0
>             [::1]:50584                                  [::1]:ipp
>
> So we have inconsistency anyway...
>
> As you said, no strong opinion.

Following an RFC and ss filter paste is a good reason, I'll do a v3.

Jamie
