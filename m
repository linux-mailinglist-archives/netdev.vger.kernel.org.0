Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B311748F1FA
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 22:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiANVS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 16:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiANVS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 16:18:58 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F2AC06161C
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 13:18:58 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id p1so19160815uap.9
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 13:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+un88kIUjelH0CuN5J/Cm9se9f65/4SawBptw+FBoO4=;
        b=C/qF2hWLgKzu2heihY5x4OQ67n2lvCXr/Knrdq/Nq3Yw87J+kbYsrXu0TkaUbqB30K
         dbjj7OejFqOmhiYF+d3yZvY7JYFXE//27ekIDcmkeKRh78zB69kYuC4p4CrhxkJxAWnC
         Ip2xHork7GSVFz2Op2hS+sdh/jPaoApcr57T6bGR0tpscTMpFl+JlWb6NcNeJv7KWLdE
         AeC9RCIr05nGMNpejJmHF8Kr5zERyY7CR6ob5r1NitcehKJriR9URokf7pb5ECrygJZi
         w1iJ1NUlQiOtYJHqLCrkt8RLZlZlzlDsRRO8GEWxwZj5LbKy8F9Nr2eoqinSMJ86/SLj
         Hk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+un88kIUjelH0CuN5J/Cm9se9f65/4SawBptw+FBoO4=;
        b=YtFDFEAk1UzErrkbWxJ2yB1zE1cwcCt5H5Ze5TsgkmwJYK+SNUiFhwxtAeQlPin16K
         OWzHB9Q3kRBHi0hBaFgAukGVwtvtLh5ENMgbCJU9jbufThWNWCPoY6LTFkYxlEOGgTpY
         F7PvSb8tRkOwNgDNThGygcCFP1hH7TgOqZEDT/jtg4j2tW9/B0hf0yVEcKfBdZ1Krev8
         i0CdGeF0bgr/YHtAVp8nfSnDzXs0kpyfIN/9tdjxJlm/TpOiJqLMroXigmqXPLk7kxSV
         Tsju09j54cePft6wfwJt8zAdE1GP6ihS4UMNQRHslXUPtOR1qqqNsNSgpy+i/3T1kAQn
         PfSw==
X-Gm-Message-State: AOAM5329RE5wUOHFTAeFuc1nXfs6PBl6qs5RSlNjhH8WxBs/5+MORSd1
        gUTiDYdZjtjFcueTa+1efx9Qk5FHwfcWeGNkaFu04g==
X-Google-Smtp-Source: ABdhPJx4VpDXouL4D2d/sau9k+vt4ooJD9EBc5fhoxcLAolx+OYYtBEeyBn1nLujOE1FvJpF3ep4p/z8PyCy+z3n/YM=
X-Received: by 2002:a05:6102:2451:: with SMTP id g17mr4964750vss.8.1642195137092;
 Fri, 14 Jan 2022 13:18:57 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
 <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com>
In-Reply-To: <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 14 Jan 2022 13:18:44 -0800
Message-ID: <CANP3RGfJ2G8P40hN2F=PGDYUc3pm84=SNppHp_J0V+YiDkLM_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > This is wrong.
> > > > CGROUP_INET_EGRESS bpf prog cannot arbitrary change packet data.

I agree with this sentiment, which is why the original proposal was
simply to add a helper which is only capable of modifying the
tos/tclass/dscp field, and not any arbitrary bytes.  (note: there
already is such a helper to set the ECN congestion notification bits,
so there's somewhat of a precedent)

> > > > The networking stack populated the IP header at that point.
> > > > If the prog changes it to something else it will be confusing other
> > > > layers of stack. neigh(L2) will be wrong, etc.
> > > > We can still change certain things in the packet, but not arbitrary bytes.
> > > >
> > > > We cannot change the DS field directly in the packet either.

This part I won't agree with.  In most cases there is no DSCP based
routing decision, in which case it seems perfectly reasonable to
change the DSCP bits here.  Indeed last I checked (though this was a
few years ago) the ipv4 tos routing code wasn't even capable of making
sane decisions, because it looks at the bottom 4 bits of the TOS
field, instead of the top 6 bits, ie. you can route on ECN bits, but
you can't route on the full DSCP field.  Additionally afaik the ipv6
tclass routing simply wasn't implemented.  However, I last had to deal
with this probably half a decade ago, on even older kernels, so
perhaps the situation has changed.

Additionally DSCP bits may affect transmit queue selection (for
something like wifi qos / traffic prioritization across multiple
transmit queues with different air-time behaviours - which can use
dscp), so ideally we need dscp to be set *before* the mq qdisc /
dispatch.  I think this implies it needs to happen before tc (though
again, I'm not too certain of the ordering here).

> > > > It can only be changed by changing its value in the socket.

Changing it directly in the socket has two problems:
- it becomes visible to userspace which is undesirable (ie. I've run
across userspace code which will set tos to A, then read it back and
exit/fail/crash if it doesn't see A)
- if the tos bits themselves are an input to the decision about what
tos bits to actually use, then this becomes recursive and basically
impossible to get right.  (for example ssh sets tos to different
values for interactive/bulk (ie. copy) traffic, so using application
selected tos to select wire tos is perfectly reasonable)

> > > Why is the DS field unchangeable, but ecn is changeable?
> >
> > Per spec the requirement is to modify the ds field of egress packets with DSCP value. Setting ds field on socket will not suffice here.
> > Another case is where device is a middle-man and needs to modify the packets of a connected tethered client with the DSCP value, using a sock will not be able to change the packet here.
>
> If DS field needs to be changed differently for every packet
> it's better to use TC layer for this task.
> qdiscs may send packets with different DSs to different queues.
