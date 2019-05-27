Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0B2ACCC
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 03:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfE0Bbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 21:31:36 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45074 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfE0Bbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 21:31:35 -0400
Received: by mail-ed1-f68.google.com with SMTP id g57so9355415edc.12;
        Sun, 26 May 2019 18:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DqMpY7GvF0ff0IzEGf6ToH+IeTipvCs7U+egaBCK/0c=;
        b=jIQe8dcq6hfjJasd7rpnQmT1ghPyu3p/8Su5QFmV4goM9hV+Nn7vuFkZ93vME+osiI
         KOQzACMGTs/oKFdNCQg/orA8VfHbNIc3YEGAiiG1PxMJMxU4gnzzebC2naOO4TMw3mnn
         GAr1sXbdu+qBeR1BF+PoCyreAi57GUdetoXpt2z/EpPcF5XKs+aYZ3ct2dr97kWtuxNL
         CeSwWoygSE4djLX/Ealr8p6k0zYXJrFjrmMmwYHMpVCDG6m29PysaLnnDEHp+h+ZTox4
         fQftEjcYWi9dQjQHtee30se68O1CwK9hCWWFF/A0glQLgiz5s8Ft+iF9LDhbgsrqryJ2
         No9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DqMpY7GvF0ff0IzEGf6ToH+IeTipvCs7U+egaBCK/0c=;
        b=Xqi5Zq4EwWvNxJ6BdDKPSRZAiahZytYFRJYSpbRq1CQgIaI5XubGBnbiPxj8rtfYls
         m3Xu3+gR88wFC1ZDAti+dGabJNeTrq394RkbacCmOMrqGHXMs3IJ6BI3T3pjtiQyRWDU
         8nCy4dXgtvPVghHbUTMYol7xpKv1EGeGqXXILXDhHbF+FlBcTB+xDQ1HLFVY8peTm0z/
         NhV0tmqFCCuQFI8wvo8Rs3fxj5vnJVQmddOY1FPJrv+Uuzec5GbZN/KNSVMPvzdDP8S+
         CZeGEKUMx08VZNgMBXs7CXdbinPQ9OxrGbyzP1qTjwOWhT/6twbVFpWHmFaaOAfjMy/G
         OW7w==
X-Gm-Message-State: APjAAAXISmem5T+S2nehu1YgGd1vaYcqeE7E59finRvqOzhxRKRFW4wr
        8axCnRorUnTAY4uUjZZdVxkVLor0jpPh4uvlv2M=
X-Google-Smtp-Source: APXvYqzIR1bAlrXqNU0Qu+lZ2SeGwcZMWRL3HkpFUZ5zOOOC8LaMk9YkapkJQTZ0XrImuiLusC3f53Wp5NeldX9gxuQ=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr80719301ejb.246.1558920692905;
 Sun, 26 May 2019 18:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com> <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com> <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
 <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com> <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
 <4032C02B-EA43-4540-8283-8466CDD0B8D2@appneta.com>
In-Reply-To: <4032C02B-EA43-4540-8283-8466CDD0B8D2@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 26 May 2019 20:30:56 -0500
Message-ID: <CAF=yD-KTJGYY-yf=+zwa8SyrCNAfZjqjomJ=B=yFcs+juDeShA@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 1:47 PM Fred Klassen <fklassen@appneta.com> wrote:
>
>
>
> > On May 25, 2019, at 8:20 AM, Willem de Bruijn <willemdebruijn.kernel@gm=
ail.com> wrote:
> >
> > On Fri, May 24, 2019 at 6:01 PM Fred Klassen <fklassen@appneta.com> wro=
te:
> >>
> >>
> >>
> >>> On May 24, 2019, at 12:29 PM, Willem de Bruijn <willemdebruijn.kernel=
@gmail.com> wrote:
> >>>
> >>> It is the last moment that a timestamp can be generated for the last
> >>> byte, I don't see how that is "neither the start nor the end of a GSO
> >>> packet=E2=80=9D.
> >>
> >> My misunderstanding. I thought TCP did last segment timestamping, not
> >> last byte. In that case, your statements make sense.
> >>
> >>>> It would be interesting if a practical case can be made for timestam=
ping
> >>>> the last segment. In my mind, I don=E2=80=99t see how that would be =
valuable.
> >>>
> >>> It depends whether you are interested in measuring network latency or
> >>> host transmit path latency.
> >>>
> >>> For the latter, knowing the time from the start of the sendmsg call t=
o
> >>> the moment the last byte hits the wire is most relevant. Or in absenc=
e
> >>> of (well defined) hardware support, the last byte being queued to the
> >>> device is the next best thing.
> >
> > Sounds to me like both cases have a legitimate use case, and we want
> > to support both.
> >
> > Implementation constraints are that storage for this timestamp
> > information is scarce and we cannot add new cold cacheline accesses in
> > the datapath.
> >
> > The simplest approach would be to unconditionally timestamp both the
> > first and last segment. With the same ID. Not terribly elegant. But it
> > works.
> >
> > If conditional, tx_flags has only one bit left. I think we can harvest
> > some, as not all defined bits are in use at the same stages in the
> > datapath, but that is not a trivial change. Some might also better be
> > set in the skb, instead of skb_shinfo. Which would also avoids
> > touching that cacheline. We could possibly repurpose bits from u32
> > tskey.
> >
> > All that can come later. Initially, unless we can come up with
> > something more elegant, I would suggest that UDP follows the rule
> > established by TCP and timestamps the last byte. And we add an
> > explicit SOF_TIMESTAMPING_OPT_FIRSTBYTE that is initially only
> > supported for UDP, sets a new SKBTX_TX_FB_TSTAMP bit in
> > __sock_tx_timestamp and is interpreted in __udp_gso_segment.
> >
>
> I don=E2=80=99t see how to practically TX timestamp the last byte of any =
packet
> (UDP GSO or otherwise). The best we could do is timestamp the last
> segment,  or rather the time that the last segment is queued. Let me
> attempt to explain.
>
> First let=E2=80=99s look at software TX timestamps which are for are gene=
rated
> by skb_tx_timestamp() in nearly every network driver=E2=80=99s xmit routi=
ne. It
> states:
>
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
>  * Ethernet MAC Drivers should call this function in their hard_xmit()
>  * function immediately before giving the sk_buff to the MAC hardware.
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
>
> That means that the sk_buff will get timestamped just before rather
> than just after it is sent. To truly capture the timestamp of the last
> byte, this routine routine would have to be called a second time, right
> after sending to MAC hardware. Then the user program would have
> sort out the 2 timestamps. My guess is that this isn=E2=80=99t something =
that
> NIC vendors would be willing to implement in their drivers.
>
> So, the best we can do is timestamp is just before the last segment.
> Suppose UDP GSO sends 3000 bytes to a 1500 byte MTU adapter.
> If we set SKBTX_HW_TSTAMP flag on the last segment, the timestamp
> occurs half way through the burst. But it may not be exactly half way
> because the segments may get queued much faster than wire rate.
> Therefore the time between segment 1 and segment 2 may be much
> much smaller than their spacing on the wire. I would not find this
> useful.

For measuring host queueing latency, a timestamp at the existing
skb_tx_timestamp() for the last segment is perfectly informative.

> I propose that we stick with the method used for IP fragments, which
> is timestamping just before the first byte is sent.

I understand that this addresses your workload. It simply ignores the
other identified earlier in this thread.

> Put another way, I
> propose that we start the clock in an automobile race just before the
> front of the first car crosses the start line rather than when the front
> of the last car crosses the start line.
>
> TX timestamping in hardware has even more limitations. For the most
> part, we can only do one timestamp per packet or burst.  If we requested
> a timestamp of only the last segment of a packet, we would have work
> backwards to calculate the start time of the packet, but that would
> only be be a best guess. For extremely time sensitive applications
> (such as the one we develop), this would not be practical.

Note that for any particularly sensitive measurements, a segment can
always be sent separately.

> We could still consider setting a flag that would allow the timestamping
> the last segment rather than the first. However since we cannot
> truly measure the timestamp of the last byte, I would question the value
> in doing so.
>
