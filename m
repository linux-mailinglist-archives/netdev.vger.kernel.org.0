Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E898711F391
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 19:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLNSrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 13:47:31 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35701 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNSra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 13:47:30 -0500
Received: by mail-ed1-f65.google.com with SMTP id f8so1846769edv.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 10:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vrETjnwW232XNiqxchBhwlrX/Os/5+pvBPEKjH6APyw=;
        b=Hausmj15Gi7p+Ns3Y88HW/JgcHxxsFByZX31xGATdkgDMn2LzyJVmD+25JmsLn3qN6
         jh1LGBR/diZTDiuJJBx/Y112xPagGnx6fPmx4uz1H+vmL2fY2uTv3pkB0rho8or5wiA+
         zW0TrcgSYFszrChp5Hi7lNG4HK6TjCHEQZ74JGU7v8MhYrpdabUUCb/vmSstuC6K7CH9
         NOhhpXFZQTk+5NtyGUMCNU2o+1rbAwlH4KnJGkxrv9Zt1vLpl9ZnClnzJAKsbaNNrAYx
         ZMAEmtl+3bs7gnj0Unm4ur4hq72/Bv3NLwzwasKN1dUobPmTodsaXP8jx80lQsju+8Dg
         OVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vrETjnwW232XNiqxchBhwlrX/Os/5+pvBPEKjH6APyw=;
        b=caiGYbwrt5ODnzy7OjG2k4P1QnBjUkyWo2xUWvBcv/DXtNAu22ibx7QV7KmcC3gZTG
         XHtT8SzHVXhKO/gzds4c6b96SdFb1ImF9wjfRfC0hfMmHD4lxFp6K7Tb/ldqm5E9CBav
         n18EbYUaTuvR4bJTC9xL0GtdolWsQKfMBwl4MsCm2hp9fSsLFUWSui/1vboGIljfn0ug
         ACWOeP5uSRukuhXuUa1cH9YFYUOStZbV8vNUR/0+VfHOwtupPlAOqcwtxXN9zMA179K9
         cVlxBipfE2As/2xLeQdJyBpvBZJtYZ3XS9nG4u0TijhW36LAI9Es4Z1iKO4XAhh14+fM
         mfSQ==
X-Gm-Message-State: APjAAAWbmLeMiYlzu3iOyFO7VEqltRisSl83sZKBEotUrag2v2jTF6UZ
        FvvCuq+JvpwBd5c26WZeSvgGLsXMK2puINtvKOre1NqMPfc=
X-Google-Smtp-Source: APXvYqy1acHr1xRKMCF8mZjf2OSFnT1QFYPTy/hRdIcN18n9XSmDPxd3HY10T4W3v5lr0ZcRk/OhS5Oxxh04xvjWeLk=
X-Received: by 2002:aa7:db04:: with SMTP id t4mr1799332eds.122.1576349248782;
 Sat, 14 Dec 2019 10:47:28 -0800 (PST)
MIME-Version: 1.0
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-3-git-send-email-tom@herbertland.com> <20191006130030.rv4tjcu2qkk7baf6@netronome.com>
In-Reply-To: <20191006130030.rv4tjcu2qkk7baf6@netronome.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 10:47:17 -0800
Message-ID: <CALx6S36wkNaWhHhgkTs12Zphm+u6OZjWucrUkByYxBZA2aGE+w@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 2/7] ipeh: Move generic EH functions to exthdrs_common.c
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 6:00 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 03, 2019 at 02:57:59PM -0700, Tom Herbert wrote:
> > From: Tom Herbert <tom@quantonium.net>
> >
> > Move generic functions in exthdrs.c to new exthdrs_common.c so that
> > exthdrs.c only contains functions that are specific to IPv6 processing,
> > and exthdrs_common.c contains functions that are generic. These
> > functions include those that will be used with IPv4 extension headers.
> > Generic extension header related functions are prefixed by ipeh_.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
>
> ...
>
> > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > index 25aab67..b8843c1 100644
> > --- a/net/dccp/ipv6.c
> > +++ b/net/dccp/ipv6.c
> > @@ -515,7 +515,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
> >       if (!opt)
> >               opt = rcu_dereference(np->opt);
> >       if (opt) {
> > -             opt = ipv6_dup_options(newsk, opt);
> > +             opt = ipeh_dup_options(newsk, opt);
> >               RCU_INIT_POINTER(newnp->opt, opt);
> >       }
> >       inet_csk(newsk)->icsk_ext_hdr_len = 0;
> > diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> > index ae1344e..700fcea 100644
> > --- a/net/ipv6/Kconfig
> > +++ b/net/ipv6/Kconfig
> > @@ -3,9 +3,13 @@
> >  # IPv6 configuration
> >  #
> >
> > +config EXTHDRS
> > +     bool
> > +
> >  #   IPv6 as module will cause a CRASH if you try to unload it
> >  menuconfig IPV6
> >       tristate "The IPv6 protocol"
> > +     select EXTHDRS
> >       default y
> >       ---help---
> >         Support for IP version 6 (IPv6).
>
> Hi Tom,
>
> could you expand on the motivation for this new Kconfig symbol.
> It seems that at this time exthdrs_common.o could simply depend on IPV6.
>
It anticipates other uses cases of extension headers, in particular
IPv4 extension headers
(https://tools.ietf.org/html/draft-herbert-ipv4-hbh-destopt-00)

> Otherwise this patch seems fine to me.
>
> > diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
> > index df3919b..0bcab81 100644
> > --- a/net/ipv6/Makefile
> > +++ b/net/ipv6/Makefile
> > @@ -44,6 +44,7 @@ obj-$(CONFIG_IPV6_SIT) += sit.o
> >  obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
> >  obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
> >  obj-$(CONFIG_IPV6_FOU) += fou6.o
> > +obj-$(CONFIG_EXTHDRS) += exthdrs_common.o
> >
> >  obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
> >  obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
>
> ...
