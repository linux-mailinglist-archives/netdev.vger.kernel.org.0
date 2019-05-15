Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F061FA03
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 20:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfEOSb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 14:31:57 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:39211 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEOSb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 14:31:56 -0400
Received: by mail-it1-f196.google.com with SMTP id 9so1770245itf.4
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 11:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LbBIxyME8HMS97r/RXbhi9kQgmNpcQdTLFJzANcqaUw=;
        b=VAa6uuR7X3xeMcn2GtBhTKZaYSYAn0e+pPDmY+jCzzwI5M0KACt2pYaviSKTgcseAo
         hk9NRkhUZ5VfHOkaL8HrepeMe0jKbLpSWpC0EOwB4mcehynlac51mMFGMZETVfx1hHAW
         kHpfP05Du0PBzgoE8HT8rChXXyIqGbCI/C2N8x4m0XLLQBuoA/mjWZKrfcH4IkLS+tSK
         uN3WhTKKPo1hRAjh3yTRgw2M/mpJ6w2n/17pWA5hLBZ92NMpFV1MmYaTeVxjzdaw7mvI
         GCAV4D9KG4DiHDwEo4Etagfu9RPfGoAVaGjFuULActFyAqzfEsJ6TWlz8aKE0WQdhfnc
         OXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LbBIxyME8HMS97r/RXbhi9kQgmNpcQdTLFJzANcqaUw=;
        b=sBxWnwYjg9gS1gx6wWHqhxwc3F62/HaMMBLHg2MnA1CIvlY6L7yJ9TAW2KQ+3bM7PK
         4nVW4E0RiWLBvQX0mUa472X/htlK+3ZNrqjlhUmRy8D9G/6BWma+l/Kb4p5qFo0Y4wab
         3z4OZ/Nu+HfWZWbT5z9ztvuhNCPgRZ39r1i47epDlq9g7sWbOitolLTkvmKb/4sZmogP
         oNqQiJFJDCeYxd6kcb6i9PUuv8lz/2RwIKYFbaK8o0egcKLXvg9Nhop9I0wXqWnChz3O
         fSC+s9UXi6JQVxNtVQrPz+MFBSer8N8tsMOMkhZUKCuDz1gOvVZIhMLEsrz0wsxTT1ER
         qDNw==
X-Gm-Message-State: APjAAAW4WubSPkAcdQrUJtiooTh/2zao2psGiITy6ijJS2C5eCAPAMnL
        C4nIR7DQVHUfajOG8ml7IgEVQe2qKHSk5A4vX2QWAg==
X-Google-Smtp-Source: APXvYqw7CA20tnoFjRDRh11ZqmCJO/0mn3pK0KevyvHWAjUnnJAL4sjVPP84YGe+TfR0oZC3mXD8sUxT7V/Zj7VQ01k=
X-Received: by 2002:a24:5fc2:: with SMTP id r185mr10415820itb.43.1557945115580;
 Wed, 15 May 2019 11:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
 <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com> <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
 <20190514163308.2f870f27@redhat.com> <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
 <20190515180604.sgz4omfwhcgfn6t3@kafai-mbp>
In-Reply-To: <20190515180604.sgz4omfwhcgfn6t3@kafai-mbp>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 11:31:44 -0700
Message-ID: <CAEA6p_CneEoUMx+=QOm7sp2iW=1uSoHeOHYPChHqBEqahCa6tQ@mail.gmail.com>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
To:     Martin Lau <kafai@fb.com>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 11:06 AM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, May 14, 2019 at 12:33:25PM -0700, Wei Wang wrote:
> > I think the bug is because when creating exceptions, src_addr is not
> > always set even though fib6_info is in the subtree. (because of
> > rt6_is_gw_or_nonexthop() check)
> > However, when looking up for exceptions, we always set src_addr to the
> > passed in flow->src_addr if fib6_info is in the subtree. That causes
> > the exception lookup to fail.
> > I will make it consistent.
> > However, I don't quite understand the following logic in ip6_rt_cache_alloc():
> >         if (!rt6_is_gw_or_nonexthop(ort)) {
> >                 if (ort->fib6_dst.plen != 128 &&
> >                     ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
> >                         rt->rt6i_flags |= RTF_ANYCAST;
> > #ifdef CONFIG_IPV6_SUBTREES
> >                 if (rt->rt6i_src.plen && saddr) {
> >                         rt->rt6i_src.addr = *saddr;
> >                         rt->rt6i_src.plen = 128;
> >                 }
> > #endif
> >         }
> > Why do we need to check that the route is not gateway and has next hop
> > for updating rt6i_src? I checked the git history and it seems this
> > part was there from very early on (with some refactor in between)...
> I also failed to understand the RTF_GATEWAY check.  The earliest related
> commit seems to be c440f1609b65 ("ipv6: Do not depend on rt->n in ip6_pol_route().")
>
> How was it working when the exception route was in the tree?
>
When adding all exception route to the main routing tree, because
route cache has dest_addr as /128, the longest prefix match will
always match the /128 route entry.

> >
> >
> > From: Stefano Brivio <sbrivio@redhat.com>
> > Date: Tue, May 14, 2019 at 7:33 AM
> > To: Mikael Magnusson
> > Cc: Wei Wang, David Ahern, Linux Kernel Network Developers, Martin KaFai Lau
> >
> > > On Mon, 13 May 2019 23:12:31 -0700
> > > Wei Wang <weiwan@google.com> wrote:
> > >
> > > > Thanks Mikael for reporting this issue. And thanks David for the bisection.
> > > > Let me spend some time to reproduce it and see what is going on.
> > >
> > > Mikael, by the way, once this is sorted out, it would be nice if you
> > > could add your test as a case in tools/testing/selftests/net/pmtu.sh --
> > > you could probably reuse all the setup parts that are already
> > > implemented there.
> > >
> > > --
> > > Stefano
