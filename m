Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6206C2961DD
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368722AbgJVPrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 11:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 11:47:32 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ECFC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 08:47:31 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id b3so1137900vsc.5
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 08:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6wvMv9Md2sSISoTclu+OgN5pXWov5G9guga5hBIc0wQ=;
        b=gOKBP9RfR0J6spY0h+J1wwptmSHuhhgdGBCrZ8OQCzxjZSVacZrLyi/YHNZqg3ZFvL
         5eKF1/rfHjqg0M6k3SFe31VmAqEVJXgwH6VCvt+8L6AKOaJOySX0e+N/inpkYFNRKyxz
         GIkcocPL18TNP5OyUcGF7d09GCOyHMke09VfjMoCBdI+pqXFMitTjZLZHqL28zYxqbcx
         am+CSji6WlsjxcTLVJwIjbdqY+wsg/cDqYZ1ePrf/MpGtwQZagQqokUHm+jjS2c87dDL
         0fY48TVSyOe+rrzc1eD1aMfq65tgYM2vs9tful4bI+Nyga4gFt1nivt50j1a46u3sCbu
         WZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6wvMv9Md2sSISoTclu+OgN5pXWov5G9guga5hBIc0wQ=;
        b=Rfb7PfPxt5b0yvh9MMmdO475YyCsz+8p2hfn011v66pXf92QvDSkL5KKiYq/Y28MNq
         95YXH8xIgAoidy/s/7189kpFY/DTGqb4aur32Th75iHrjcKaH1DVwSB0Xwv/hCuaZ5TT
         yI+Y3qbK6hpwh3KA5Xsmd9Rux90pxPFCvcn1YpySWgILGySk48P8E6pZ3ryGf1FqH8bZ
         q+mb42WTgDPWaOLsHxalpYs1pZB1jSWq7rahEX3a71soJvaErfQcTekiHcMCQIaPer79
         PTVHRE1iKUehO4j7qcSuvioF8bh7bAqjFBSPIA6lOyEdF/Qn8mwHurjQp1Oecz37hLTB
         0Izw==
X-Gm-Message-State: AOAM533hhlzC6ttLSPkUPkDqMlimUDhgOXaeZgubdgXUGAYOC3DgROVL
        MvPw5cGH8ODsEkWOi74rbb24POFWO9k=
X-Google-Smtp-Source: ABdhPJzndwFvxTSUHmFW+2hYMMFdMZWLSFQaq77p42jEg3AksepZuTS7jL8OCWXYrtPYqwfFuU6fow==
X-Received: by 2002:a67:eb48:: with SMTP id x8mr2449727vso.11.1603381649575;
        Thu, 22 Oct 2020 08:47:29 -0700 (PDT)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id z1sm277233vkf.41.2020.10.22.08.47.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 08:47:27 -0700 (PDT)
Received: by mail-ua1-f42.google.com with SMTP id y1so579611uac.13
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 08:47:26 -0700 (PDT)
X-Received: by 2002:ab0:668a:: with SMTP id a10mr1750523uan.108.1603381645605;
 Thu, 22 Oct 2020 08:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201021042005.736568-1-liuhangbin@gmail.com> <20201021042005.736568-3-liuhangbin@gmail.com>
 <CA+FuTSdCG4yVDb85M=fChfrkU9=F7j88TJujJy_y0pv-Ks_MwQ@mail.gmail.com> <20201022091205.GN2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20201022091205.GN2531@dhcp-12-153.nay.redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 22 Oct 2020 11:46:50 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfQrSqDau=e7-MXNannZ8kCqKizEMX5KZD4OzNVkyMeiA@mail.gmail.com>
Message-ID: <CA+FuTSfQrSqDau=e7-MXNannZ8kCqKizEMX5KZD4OzNVkyMeiA@mail.gmail.com>
Subject: Re: [PATCHv2 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 5:12 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Hi Willem,
>
> Thanks for the comments, see replies below.
>
> On Wed, Oct 21, 2020 at 10:02:55AM -0400, Willem de Bruijn wrote:
> > > +       is_frag = (ipv6_find_hdr(skb, &offs, NEXTHDR_FRAGMENT, NULL, NULL) == NEXTHDR_FRAGMENT);
> > > +
> >
> > ipv6_skip_exthdr already walks all headers. Should we not already see
> > frag_off != 0 if skipped over a fragment header? Analogous to the test
> > in ipv6_frag_rcv below.
>
> Ah, yes, I forgot we can use this check.
>
> > > +       nexthdr = hdr->nexthdr;
> > > +       offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > > +       if (offset >= 0 && frag_off == htons(IP6_MF) && (offset + 1) > skb->len) {
> >
> > Offset +1 does not fully test "all headers through an upper layer
> > header". You note the caveat in your commit message. Perhaps for the
> > small list of common protocols at least use a length derived from
> > nexthdr?
>
> Do you mean check the header like
>
> if (nexthdr == IPPROTO_ICMPV6)
>         offset = offset + seizeof(struct icmp6hdr);
> else if (nexthdr == ...)
>         offset = ...
> else
>         offset += 1;
>
> if (frag_off == htons(IP6_MF) && offset > skb->len) {
>         icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
>         return -1;
> }
>
> Another questions is how to define the list, does TCP/UDP/SCTP/ICMPv6 enough?

Exactly. But only if it's possible without adding a ton of #include's.
It is best effort.

If feasible, TCP + UDP alone would suffice to cover most traffic.
