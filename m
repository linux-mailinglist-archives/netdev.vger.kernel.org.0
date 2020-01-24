Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15E71488F7
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392641AbgAXOcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:32:00 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41209 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392623AbgAXOb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:31:59 -0500
Received: by mail-ed1-f66.google.com with SMTP id c26so2477831eds.8
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 06:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SlkMNqBX85gDf9V5bDVS9pSkjWiCCWHI2OfvHB05OIo=;
        b=CEo/G2Fs/xex2x4Y2zWM9P7r9Fru29Oqer2hP6FA4UGkXW4v7SxJPZNOfzSy2H+ofn
         e6h2PgEX3fSK5m+eFysi+HuyBNOphrE74RFeiSS/bm394PBnEhazL6lMsLns8j4mXHFE
         IzrGsH4gzeRmtQ/oKPWqCVlVJTLhoOfzNA6pgGckrETBSciwgjy6fz246kMH1y8EFIyK
         lyOvENnjAFLiGrPsJ0wABiCatLADMi3ic4TgnExd9wWvQhuf9ApYb3evQsK9N/p9lHAp
         bpFMcOCl5QEzl6k7uSIO2G/w00s7cRlnF8EvpwjqJ2Bm4ihznZBl9x27mt3S520j5ofG
         qr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SlkMNqBX85gDf9V5bDVS9pSkjWiCCWHI2OfvHB05OIo=;
        b=Z8D2f8ogTR+1XixT2E9kBjXvEAQofE6wiP8Ok8jVWX9/51sYvHLEg0XsjcI01uxiH1
         zp1EFi9V5PzBstbqRcq6K1iNXgVaNj55PBXW6/M+04wbWMFX8+m31sIbSpdkr9F2Hltj
         na3QQd9iRBjQOYxMs3k/L3rwlje1VnlpZa/UYObLtDy9JSOJ1VBLPAMTB8vQIbYnT2YI
         bSuINzIbFZcVzSOn3zytHYrd9qusG2lh1p/rHxlWD/SI0BMv+M7nCZLEly2TVbb3Ul8z
         OJkJaZeTW6mQJMZ4QeUrd3EqRxzEE6oa/KtkK/7m3O8OlvkgQEUKDQU2LMHk/TI55HCt
         66Pw==
X-Gm-Message-State: APjAAAXqWDVvMYqLKEajsF3W1frzFMLIPH9Vr0fAbZ0i4JH5nXQC+2Ld
        mkar6GGOe90ahnbF1hKSwY6zDxFxzy19w1cU3L1BvHfC
X-Google-Smtp-Source: APXvYqy0MQmSWWJrAos6yHHVr/W4QLZ6MKwgRIlJWfdAS47LHsd1cS5ak3e2dOc1e1PR7XWxY8g5OVJBcFJ0n6kRl1w=
X-Received: by 2002:a50:eb95:: with SMTP id y21mr2774082edr.212.1579876316852;
 Fri, 24 Jan 2020 06:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk>
 <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
 <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
 <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk>
In-Reply-To: <87r1zpgosp.fsf@toke.dk>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 24 Jan 2020 06:31:45 -0800
Message-ID: <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 1:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Daniel Borkmann <daniel@iogearbox.net> writes:
>
> > On 1/23/20 7:06 PM, Luigi Rizzo wrote:
> >> On Thu, Jan 23, 2020 at 10:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >>> Luigi Rizzo <lrizzo@google.com> writes:
> >>>> On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
> >>>>>> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>>>>> Luigi Rizzo <lrizzo@google.com> writes:
> >>>>>>>
> >>>>>>>> Add a netdevice flag to control skb linearization in generic xdp=
 mode.
> >>>>>>>> Among the various mechanism to control the flag, the sysfs
> >>>>>>>> interface seems sufficiently simple and self-contained.
> >>>>>>>> The attribute can be modified through
> >>>>>>>>      /sys/class/net/<DEVICE>/xdp_linearize
> >>>>>>>> The default is 1 (on)
> >>>>>>
> >>>>>> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
> >>>>>>
> >>>>>>> Erm, won't turning off linearization break the XDP program's abil=
ity to
> >>>>>>> do direct packet access?
> >>>>>>
> >>>>>> Yes, in the worst case you only have eth header pulled into linear
> >>>>>> section. :/
> >>>>>
> >>>>> In which case an eBPF program could read/write out of bounds since =
the
> >>>>> verifier only verifies checks against xdp->data_end. Right?
> >>>>
> >>>> Why out of bounds? Without linearization we construct xdp_buff as fo=
llows:
> >>>>
> >>>> mac_len =3D skb->data - skb_mac_header(skb);
> >>>> hlen =3D skb_headlen(skb) + mac_len;
> >>>> xdp->data =3D skb->data - mac_len;
> >>>> xdp->data_end =3D xdp->data + hlen;
> >>>> xdp->data_hard_start =3D skb->data - skb_headroom(skb);
> >>>>
> >>>> so we shouldn't go out of bounds.
> >>>
> >>> Hmm, right, as long as it's guaranteed that the bit up to hlen is
> >>> already linear; is it? :)
> >>
> >> honest question: that would be skb->len - skb->data_len, isn't that
> >> the linear part by definition ?
> >
> > Yep, that's the linear part by definition. Generic XDP with ->data/->da=
ta_end is in
> > this aspect no different from tc/BPF where we operate on skb context. O=
nly linear part
> > can be covered from skb (unless you pull in more via helper for the
> > latter).
>
> OK, but then why are we linearising in the first place? Just to get
> sufficient headroom?

Looking at the condition in the if() it is both to make sufficient
headroom available and have
linear data so the bpf code can access all the packet data.

My motivation for this change is that enforcing those guarantees has
significant cost
(even for native xdp in the cases I mentioned - mtu > 1 page, hw LRO,
header split),
and this is an interim solution to make generic skb usable without too
much penalty.

In the long term I think it would be good if the xdp program could
express its requirements
at load time ("i just need header, I need at least 18 bytes of
headroom..") and have the
netdev or nic driver reconfigure as appropriate.

cheers
luigi
