Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D674BEAAB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiBUSOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:14:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiBUSLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:11:40 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6D13DDB
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:02:04 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2d62593ad9bso146722227b3.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gCnwk+1fZd2CNAqs8BK/DEcQnsMZ5KV6kM4CCv+XVUE=;
        b=Y41xGrzIr+L/F15uGmFs1ADcDgdKMDPg8RTj9wutV/T5sVvjPalRvyMbI/mE7H4Azd
         PfPgtKwe6aJ4FtAlBGRZWamLzZOd8Hn9HrkP1OQLqPp4AyychKcJgLeZW2naPUETbWkj
         AOyGODFYi+Mo17air25626pWvCec6oM/7UBJ04ywVrcgA86ohGAtOvfcQkb51Zr43fLB
         LUWoksIxfT6lbV6qwZf8njlVK2WvnTdlmkHsCO/fFWfst30HglsX/YEs9xPGgpIQnprI
         vbMdKKzPuuJ1RGbzxkSeqOiK1vM9CwvvflmCGNePgi95EbKMZILnS9wK4volIsp5wZK6
         xxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gCnwk+1fZd2CNAqs8BK/DEcQnsMZ5KV6kM4CCv+XVUE=;
        b=k6FoX/B9ofC21n3ZnpvO9zR1uNxuhHBCzfASPsCmI/KFSpjkKmjPqZZz2wHqPLXh5p
         OvepHDD0UuqHrZ4cFt1F2FKILDVQfCcr3qTGB/ZZgymjs1A9IJHk2wn7c33EaHspt0Va
         0gCVcwIjMLPEvUjSjfL+Eu9WYCZ+znYtHqnl3v4Wn+NJn81y4qoHB8iRnPDRapbNdFfJ
         54GtcKq0nn76UuO9AC66KeGYo/QtfgxWTlJ3OrDjynh6OvS84RbRjlf3wWYygjBVAIgL
         mxz7LCIF+d5Q7EbsyH96tw6hl7ehU+iaEkoo5ox1cn7BBESuXrpsxKYKPGfYRK3suItH
         zxAA==
X-Gm-Message-State: AOAM531wfFr3MY1TIOGJlG+UFkHWKSTP/RT/a1e46QlaEoLOC6u9d8wB
        AfmUwCYZnq71mXM07jbiQfQSrSXuDypXr54GJuaiyg==
X-Google-Smtp-Source: ABdhPJyFuzJXFuAgKnJy1SVe6M8VS3ba2FIQHRrucF8KaYmPL+i/iLg8UjHQ3oZu9UqtNJdybUgY3BGV5hrhcU2Hst0=
X-Received: by 2002:a81:993:0:b0:2d6:15f5:b392 with SMTP id
 141-20020a810993000000b002d615f5b392mr20619739ywj.489.1645466523677; Mon, 21
 Feb 2022 10:02:03 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com> <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
In-Reply-To: <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 10:01:52 -0800
Message-ID: <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
Subject: Re: Linux 5.17-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Woody Suwalski <wsuwalski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 9:56 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Feb 21, 2022 at 6:23 AM Woody Suwalski <wsuwalski@gmail.com> wrote:
> >
> > Compile failed like reported by Robert Gadson in
> > https://lkml.org/lkml/2022/2/20/341
> >
> > As a workaround:
> > nf_defrag_ipv6.patch
> > --- a/net/netfilter/xt_socket.c    2022-02-21 07:29:21.938263397 -0500
> > +++ b/net/netfilter/xt_socket.c    2022-02-21 07:40:16.730022272 -0500
> > @@ -17,11 +17,11 @@
> >   #include <net/inet_sock.h>
> >   #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
> >
> > -#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> > +//#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> >   #include <linux/netfilter_ipv6/ip6_tables.h>
> ...
>
> Hmm. That may fix the compile failure, but it looks somewhat broken to me.
>
> Other cases of nf_defrag_ipv6_disable() end up being protected by
>
>    #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
>
> at the use-point, not by just assuming it always exists even when
> CONFIG_NF_TABLES_IPV6 is off.
>
> So I think the proper fix is something along the lines of
>
>   --- a/net/netfilter/xt_socket.c
>   +++ b/net/netfilter/xt_socket.c
>   @@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct
> xt_mtdtor_param *par)
>    {
>         if (par->family == NFPROTO_IPV4)
>                 nf_defrag_ipv4_disable(par->net);
>   +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>         else if (par->family == NFPROTO_IPV6)
>                 nf_defrag_ipv6_disable(par->net);
>   +#endif
>    }
>
> instead. Entirely untested, because that's how I roll, but I suspect
> the netfilter people will know what to do.
>
> Added guilty parties and mailing list to the participants.
>
>                 Linus

I am pretty sure Pablo fixed this one week ago.

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=2874b7911132f6975e668f6849c8ac93bc4e1f35
