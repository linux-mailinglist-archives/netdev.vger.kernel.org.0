Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195F22A09E7
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgJ3Pcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgJ3Pce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:32:34 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB59FC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:32:34 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id 52so1835772uaj.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qmZi/piocyrZeQVaa3aCb0CCeYlB9CuL/jETIHR05Jk=;
        b=o/bxphdoFWd5rGObHTl6YAcXiKTAdRvdLlOEtABHCu9l0r8WLorVo9ceVToCIZUIlD
         O02JeZAY35Ly4gDTtsMm8idElloAXa0wEGVV3w+sG+Tqbn84RqAiMchs74+3jFDTRkOB
         D47jwbhwPclcYFaCnekSU5f2iJPcUjDB4PEasIj0uN+bPU/04EOSG+VAZFKsGZRDbU9c
         jPAIrzq7Ed/pdI8JlE/dhDa9NI+kZmz33/wexPqlCOAt6Rk9sPn1z2pKn4FnldpM+YSP
         KehW/p49VhChQHzXfCGw8fIkMc8vk7Ne6cgvu0PCdgAWXUlQmZBDuoZ7nUbeKBEqCl9K
         Nb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmZi/piocyrZeQVaa3aCb0CCeYlB9CuL/jETIHR05Jk=;
        b=PHIMp7cvJjkFExNdMiDHXx3nGl4z0G1q4iT9Thb+F30UH+6TvMO7cSUHVV/w8lWrAb
         34UwkSh4IqXW2R8BcBD68eJk+myHJY3EYtJ/naW96f8Y+jHn3R0Xef/3R5zekNL2/1hq
         OItR8EKVO6smqr5T8qoZT5Oie/SvwtbgHMw7luhJ3Xi5YRc38xcG8nUCVCQVT52Hl7Nq
         qkUGmdJ+4cXiHo/GG/GLR4wYpLRhaUDgTjEOpIk968ywaRjX/V4lnFMPoehmkDFwA8nc
         fAxeh7YFXK5dIB8ljqO5MokfmBVeTMgzmuLe6r6Cc+K2PBPf7AtahzDXfCLCIpeMXLN9
         8YzA==
X-Gm-Message-State: AOAM533d4QZ01tS61c3EBOmyiniRlete65bnca/OEdy4cP//M3lFWQIa
        n2XSgZUBso726G+tjOfZulvRy0GLq8g=
X-Google-Smtp-Source: ABdhPJyYaPFNvQonFjZCptTA+8ig4CmIS8muJKFcyKU85ZbuXsSJex6RUdsItfCl6rVDYj/Ol3c55w==
X-Received: by 2002:ab0:20d5:: with SMTP id z21mr1773473ual.84.1604071953348;
        Fri, 30 Oct 2020 08:32:33 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id t71sm752626vkb.7.2020.10.30.08.32.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 08:32:32 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id v27so1844861uau.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:32:31 -0700 (PDT)
X-Received: by 2002:ab0:5447:: with SMTP id o7mr1943106uaa.37.1604071951491;
 Fri, 30 Oct 2020 08:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com> <20201027022833.3697522-3-liuhangbin@gmail.com>
 <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com> <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 11:31:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfSUE8M+TuKkBQbEL7L5Bfd=wrZHEqQ67nWZy8oex1JCw@mail.gmail.com>
Message-ID: <CA+FuTSfSUE8M+TuKkBQbEL7L5Bfd=wrZHEqQ67nWZy8oex1JCw@mail.gmail.com>
Subject: Re: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "Georg Kohmann (geokohma)" <geokohma@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 5:57 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Oct 27, 2020 at 07:57:06AM +0000, Georg Kohmann (geokohma) wrote:
> > > +   /* RFC 8200, Section 4.5 Fragment Header:
> > > +    * If the first fragment does not include all headers through an
> > > +    * Upper-Layer header, then that fragment should be discarded and
> > > +    * an ICMP Parameter Problem, Code 3, message should be sent to
> > > +    * the source of the fragment, with the Pointer field set to zero.
> > > +    */
> > > +   nexthdr = hdr->nexthdr;
> > > +   offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > > +   if (offset >= 0) {
> > > +           /* Check some common protocols' header */
> > > +           if (nexthdr == IPPROTO_TCP)
> > > +                   offset += sizeof(struct tcphdr);
> > > +           else if (nexthdr == IPPROTO_UDP)
> > > +                   offset += sizeof(struct udphdr);
> > > +           else if (nexthdr == IPPROTO_ICMPV6)
> > > +                   offset += sizeof(struct icmp6hdr);
> > > +           else
> > > +                   offset += 1;
> > > +
> > > +           if (frag_off == htons(ip6_mf) && offset > skb->len) {
> >
> > This do not catch atomic fragments (fragmented packet with only one fragment). frag_off also contains two reserved bits (both 0) that might change in the future.
>
> Thanks, I also didn't aware this scenario.

Sorry, what are atomic fragments?

Do you mean packets with a fragment header that encapsulates the
entire packet? If so, isn't that handled in the branch right above?
("/* It is not a fragmented frame */"). That said, the test based on
IP6_OFFSET LGTM.
