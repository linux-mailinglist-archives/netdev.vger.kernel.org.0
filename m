Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF23249158
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgHRXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:04:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39705 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgHRXEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:04:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 367155C00B4;
        Tue, 18 Aug 2020 19:04:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 18 Aug 2020 19:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        mime-version:content-transfer-encoding:content-type:to:cc
        :subject:from:date:message-id:in-reply-to; s=fm1; bh=s447vzKSC6N
        k6U0PnYdqn64Yu8wSd2wJsvuvxYFx1cY=; b=BzSKlFPKVGg9Y9R8yFSnRmyGH5l
        6A054HQDQn8WtC6vu2I/I2QzqlAiSTP79y8pmw9NE+B/5f3GsRJ5eVFbLTqAREHA
        O0dgORF2w9LyvVnG6h0S0QM63MR2I+xpk76/PgtK3TSEoVlE7FgHi+e8hWItFaO4
        jcyuNh9/wpHnvXU8BRzW4DLokmGXf1M+ONg1+v53dtmxMq+R2lObIwrhZHK+cbDy
        9cLgqc5lKvQ60lC2hYzi4YsbPzgjltPiFAI3cXWK1HLEf3VuEVnVdU4teol49bjJ
        aFpbDtO8+i5TMGtsTqDyU17wjuWj/VlFGuz9zYZflPZnVGrUMxbB+BOcYxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=s447vzKSC6Nk6U0PnYdqn64Yu8wSd2wJsvuvxYFx1cY=; b=UYKUPLZS
        SjH21t8mBKrfnn8oH6Y8U3KwWUiX3j15Ne99JFOmejSHhVJ3NEBjCcGb16x/Ftq1
        1wLA57yXtTufyr7Bb1hpcr4EehdvKp0ZtI2/Ge/5KhJYGj+2A/jaq2B8LwWEDOBS
        xb/w72+b0I1r/6/m+493b/UP+hLeUR2OIK3u0yp3qnOh0AvMDDRR3cBCtLSCuxXI
        BjBgWKqB5oy4NQbOQij+USfidS7jSaH+jUrMFbkODITYaDLsg02+I2GZg8WSIjux
        b6y285FiReouXB6h8ka+lwZSp29k576k/zH0VCOI7Nw/8GyBx22XHotuLyNWS4fT
        3u2y3VA0+3f/Rg==
X-ME-Sender: <xms:dF48XxKaD9Ft2ZI8_HORNRJP26xHgMdI9O5gaCrMESu8GtuYbXl6Dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtjedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpegggfgtvffuhfffkfgjsehtqhertddttdej
    necuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgiihiieqne
    cuggftrfgrthhtvghrnheptdehtdffkeehtddtfffgfeeuieehffejledvtddvuddufeei
    hfffheejhfevhfdtnecukfhppeejfedrleefrddvgeejrddufeegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiih
    ii
X-ME-Proxy: <xmx:dF48X9LhnvSIIC4cp7-VD2O9hh6QPmsQa8nL_c-e4VJuhv3epoh3yQ>
    <xmx:dF48X5sqgScGMbbwNOxE2R4jKGf3-owXV1ulgxqvO55k_UUY-qVgNg>
    <xmx:dF48XybSDdTYlmjh_iSzJpgk1_wRdodhsea-ymJ8ahPNtq8m6HQ9yw>
    <xmx:dV48X9Onv29TOMsVahJVrU9842W3tuyeS6YeHEfsNsIQrKNPu-7v8w>
Received: from localhost (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD5A93280059;
        Tue, 18 Aug 2020 19:04:19 -0400 (EDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     =?utf-8?q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        <bimmy.pujari@intel.com>, "bpf" <bpf@vger.kernel.org>,
        "Networking" <netdev@vger.kernel.org>, <mchehab@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, <ashkan.nikravesh@intel.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
From:   "Daniel Xu" <dxu@dxuuu.xyz>
Date:   Tue, 18 Aug 2020 16:03:30 -0700
Message-Id: <C50HXCDHGYOH.2U5EIN8JAWHRZ@maharaja>
In-Reply-To: <CANP3RGcVidrH6Hbne-MZ4YPwSbtF9PcWbBY0BWnTQC7uTNjNbw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

On Tue Aug 18, 2020 at 2:19 PM PDT, Maciej =C5=BBenczykowski wrote:
> On Tue, Aug 18, 2020 at 2:11 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > On Mon Jul 27, 2020 at 10:01 PM PDT, Andrii Nakryiko wrote:
> > > On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
> > > >
> > > > From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> > > >
> > > > The existing bpf helper functions to get timestamp return the time
> > > > elapsed since system boot. This timestamp is not particularly usefu=
l
> > > > where epoch timestamp is required or more than one server is involv=
ed
> > > > and time sync is required. Instead, you want to use CLOCK_REALTIME,
> > > > which provides epoch timestamp.
> > > > Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
> > > >
> > >
> > > This doesn't seem like a good idea. With time-since-boot it's very
> > > easy to translate timestamp into a real time on the host.
> >
> > For bpftrace, we have a need to get millisecond-level precision on
> > timestamps. bpf has nanosecond level precision via
> > bpf_ktime_get[_boot]_ns(), but to the best of my knowledge userspace
> > doesn't have a high precision boot timestamp.
> >
> > There's /proc/stat's btime, but that's second-level precision. There's
> > also /proc/uptime which has millisecond-level precision but you need to
> > make a second call to get current time. Between those two calls there
> > could be some unknown delta. For millisecond we could probably get away
> > with calculating a delta and warning on large delta but maybe one day
> > we'll want microsecond-level precision.
> >
> > I'll probably put up a patch to add nanoseconds to btime (new field in
> > /proc/stat) to see how it's received. But either this patch or my patch
> > would work for bpftrace.
> >
> > [...]
> >
> > Thanks,
> > Daniel
>
> Not sure what problem you're trying to solve and thus what exactly you
> need... but you can probably get something very very close with 1 or 2
> of clock_gettime(CLOCK_{BOOTTIME,MONOTONIC,REALTIME}) possibly in a
> triple vdso call sandwich and iterated a few times and picking the one
> with smallest delta between 1st and 3rd calls. And then assuming the
> avg of 1st and 3rd matches the 2nd.
> ie.
>
> 5 times do:
> t1[i] =3D clock_gettime(REALTIME)
> t2[i] =3D clock_gettime(BOOTTIME)
> t3[i] =3D clock_gettime(REALTIME)
>
> pick i so t3[i] - t1[i] is smallest
>
> t2[i] is near equivalent to (t1[i] + t3[i]) / 2
>
> which basically gives you a REAL to BOOT offset.

I tried out the triple vdso sandwich and I got pretty good results
(~30ns ballpark). Thanks for the tip.

Daniel
