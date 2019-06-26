Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6ABD56D9B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfFZP0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:26:38 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40663 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZP0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:26:38 -0400
Received: by mail-yb1-f194.google.com with SMTP id i14so1553777ybp.7
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XfjlVMwF0WQKYDv1T73goQqIukRnDM3pfKw0I5l2Sf8=;
        b=KGPe6vjc99roGrkdfgmJKJrV17zQh+uRLHoX5TTVMoNWRIYNzYac68YHh8o1d+Jhok
         PB6OUG2062TOJZrvUARkMM0YAZOqfNxpVawOK5jClqnsJVSlYVctx41GLo6Rx1NzZTdl
         L29gdaHOz8IVhdspVG/AcVOhrmOLtUXR8SFE3YSQrucAXK7pAr/dx1IVD2b84XE0Wilu
         63m9g9sqEnh6yLdRWov2gWCuUKBHcw8kPb3BG62rxooPCKhUAd2+HuW7MRMJHvrR7pV1
         6SQEETofhBb95DtUwxC5lJYfmDb8PTgKMV0h4q2bwy6S5L7x+Q1GF9iIbEnJ2wCLKVkA
         8AiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XfjlVMwF0WQKYDv1T73goQqIukRnDM3pfKw0I5l2Sf8=;
        b=Vwz3qJZpOa4MwgqUfIH9wohitcb6rhw02cRGE1WNOPijxd58Dm5iCJF/AgEEqF4njX
         IvKgHrF7FSPa6eOVzN3Gw44nnCuhQltyYuBiDz2lDuh+riHPEYDWicB5b0zDx9YRx/fy
         ZtbaYSGBBu6lVGz8CahZHr3CPdvc3N0g9fGozMS1j7DmCXY591ZQkw4dDnDpLqi3a5Sq
         aD/xwxk2DKEx9HjeK5aGHNruDpEitMkF6An+kw7tkPuvldOUV9BQ3Kj25JNlWDnL931I
         P2obUQqTlkKawDyzC25d6MiOWp2ik6WlL4NIMrNKmc064oDnOv3EaCx7Ljreu/dqRLps
         WATA==
X-Gm-Message-State: APjAAAVcusSvxZ9PFnchsZbJRn2L9vGhGxwiU6TLVrFtlAZmPV6Ipp0u
        q9TXK5hO025N+IAho90ZoJNXcgdn
X-Google-Smtp-Source: APXvYqxP2mupeSrxInq0nuzSxT3VFGB89GGffvSzgSmfHnfP0QdiaG2saFdAcGpmPAZzJ5uTfk5RCA==
X-Received: by 2002:a25:bb42:: with SMTP id b2mr2837119ybk.199.1561562796542;
        Wed, 26 Jun 2019 08:26:36 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id p17sm4637828ywp.96.2019.06.26.08.26.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:26:36 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id t2so1354574ywe.10
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:26:36 -0700 (PDT)
X-Received: by 2002:a0d:c0c4:: with SMTP id b187mr2917900ywd.389.1561562482454;
 Wed, 26 Jun 2019 08:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190623070649.18447-1-sameehj@amazon.com> <20190623070649.18447-2-sameehj@amazon.com>
 <20190623162133.6b7f24e1@carbon> <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
 <20190626103829.5360ef2d@carbon> <87a7e4d0nj.fsf@toke.dk> <20190626164059.4a9511cf@carbon>
 <87h88cbdbe.fsf@toke.dk>
In-Reply-To: <87h88cbdbe.fsf@toke.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 11:20:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
Message-ID: <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>
> > On Wed, 26 Jun 2019 13:52:16 +0200
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> >
> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >>
> >> > On Tue, 25 Jun 2019 03:19:22 +0000
> >> > "Machulsky, Zorik" <zorik@amazon.com> wrote:
> >> >
> >> >> =EF=BB=BFOn 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" <brouer@redh=
at.com> wrote:
> >> >>
> >> >>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:
> >> >>
> >> >>     > This commit implements the basic functionality of drop/pass l=
ogic in the
> >> >>     > ena driver.
> >> >>
> >> >>     Usually we require a driver to implement all the XDP return cod=
es,
> >> >>     before we accept it.  But as Daniel and I discussed with Zorik =
during
> >> >>     NetConf[1], we are going to make an exception and accept the dr=
iver
> >> >>     if you also implement XDP_TX.
> >> >>
> >> >>     As we trust that Zorik/Amazon will follow and implement XDP_RED=
IRECT
> >> >>     later, given he/you wants AF_XDP support which requires XDP_RED=
IRECT.
> >> >>
> >> >> Jesper, thanks for your comments and very helpful discussion during
> >> >> NetConf! That's the plan, as we agreed. From our side I would like =
to
> >> >> reiterate again the importance of multi-buffer support by xdp frame=
.
> >> >> We would really prefer not to see our MTU shrinking because of xdp
> >> >> support.
> >> >
> >> > Okay we really need to make a serious attempt to find a way to suppo=
rt
> >> > multi-buffer packets with XDP. With the important criteria of not
> >> > hurting performance of the single-buffer per packet design.
> >> >
> >> > I've created a design document[2], that I will update based on our
> >> > discussions: [2] https://github.com/xdp-project/xdp-project/blob/mas=
ter/areas/core/xdp-multi-buffer01-design.org
> >> >
> >> > The use-case that really convinced me was Eric's packet header-split=
.

Thanks for starting this discussion Jesper!

> >> >
> >> >
> >> > Lets refresh: Why XDP don't have multi-buffer support:
> >> >
> >> > XDP is designed for maximum performance, which is why certain driver=
-level
> >> > use-cases were not supported, like multi-buffer packets (like jumbo-=
frames).
> >> > As it e.g. complicated the driver RX-loop and memory model handling.
> >> >
> >> > The single buffer per packet design, is also tied into eBPF Direct-A=
ccess
> >> > (DA) to packet data, which can only be allowed if the packet memory =
is in
> >> > contiguous memory.  This DA feature is essential for XDP performance=
.
> >> >
> >> >
> >> > One way forward is to define that XDP only get access to the first
> >> > packet buffer, and it cannot see subsequent buffers. For XDP_TX and
> >> > XDP_REDIRECT to work then XDP still need to carry pointers (plus
> >> > len+offset) to the other buffers, which is 16 bytes per extra buffer=
.
> >>
> >> Yeah, I think this would be reasonable. As long as we can have a
> >> metadata field with the full length + still give XDP programs the
> >> ability to truncate the packet (i.e., discard the subsequent pages)
> >
> > You touch upon some interesting complications already:
> >
> > 1. It is valuable for XDP bpf_prog to know "full" length?
> >    (if so, then we need to extend xdp ctx with info)
>
> Valuable, quite likely. A hard requirement, probably not (for all use
> cases).

Agreed.

One common validation use would be to drop any packets whose header
length disagrees with the actual packet length.

> >  But if we need to know the full length, when the first-buffer is
> >  processed. Then realize that this affect the drivers RX-loop, because
> >  then we need to "collect" all the buffers before we can know the
> >  length (although some HW provide this in first descriptor).
> >
> >  We likely have to change drivers RX-loop anyhow, as XDP_TX and
> >  XDP_REDIRECT will also need to "collect" all buffers before the packet
> >  can be forwarded. (Although this could potentially happen later in
> >  driver loop when it meet/find the End-Of-Packet descriptor bit).

Yes, this might be quite a bit of refactoring of device driver code.

Should we move forward with some initial constraints, e.g., no
XDP_REDIRECT, no "full" length and no bpf_xdp_adjust_tail?

That already allows many useful programs.

As long as we don't arrive at a design that cannot be extended with
those features later.

> >
> >
> > 2. Can we even allow helper bpf_xdp_adjust_tail() ?
> >
> >  Wouldn't it be easier to disallow a BPF-prog with this helper, when
> >  driver have configured multi-buffer?
>
> Easier, certainly. But then it's even easier to not implement this at
> all ;)
>
> >  Or will it be too restrictive, if jumbo-frame is very uncommon and
> >  only enabled because switch infra could not be changed (like Amazon
> >  case).

Header-split, LRO and jumbo frame are certainly not limited to the Amazon c=
ase.

> I think it would be preferable to support it; but maybe we can let that
> depend on how difficult it actually turns out to be to allow it?
>
> >  Perhaps it is better to let bpf_xdp_adjust_tail() fail runtime?
>
> If we do disallow it, I think I'd lean towards failing the call at
> runtime...

Disagree. I'd rather have a program fail at load if it depends on
multi-frag support while the (driver) implementation does not yet
support it.
