Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E6286D17
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 05:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgJHDTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 23:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 23:19:53 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C38AC061755;
        Wed,  7 Oct 2020 20:19:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z5so4372950ilq.5;
        Wed, 07 Oct 2020 20:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=12Ohgsb8MdluAyFnYSu/ivuZxO+BZjEffQYvTHhSSj8=;
        b=dpPIX4yrE2w2tIUQb3jhdIAfIgI+JNNAtsZjHLqEt1aKUGn1jJrlKmVohDy1ivaGiZ
         WSEJZzlUr4CyrEx5GtK4Hz2xy6CJCiRILz/LF3gd1kPDnlGvYrbjWkxoUj9HVcaPWSiB
         QxcI2/smJPJBkHD3avDhDyVm4f7N4h/rKfANzo5bSRnWXZlB/XySyiwESNoMp6YpC7Nr
         EoMYLxelRWO9cGSJ79JkOj1Tjpxky7HOmN3qmKWNLGE6fHy9Poo7dOcogjG+cIFUyC58
         FNmukjYkxhUBG40u1Sf7RivQ5sEokQ2Vvgaz4oMd4Tm8omvqpQMAXjcYKNY7Qz/A6kw9
         vyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=12Ohgsb8MdluAyFnYSu/ivuZxO+BZjEffQYvTHhSSj8=;
        b=n5YCgyGwJ78cRnSdYBAmT3amMwLc5uZ83W0pghfVu/9cg24eCp395KoPpSUP27AjKd
         BhqY6jgayWmVzxWtVvZxwCh4RIsNtsAb0LoniuPOQ5vhZjiq5I3kcr766Optr3+KFfGV
         qPzYAHTpWovdYvVJW5YxX0OnZ1PISBHP2LaJNqEvY/F0/xuRINYFQCSCNcO7cBe3AtPK
         gI58OOWFGy0XHI1YG9IZ6ftZgNdiKlXQJ+Eu9sMltjhX9V0ZStSsF7IREoFqNXJm5ppS
         oJNwrz6ykLVuO8Tg4dNxj/EZ9WYGPyuYAqwiRqTAVMQeAWAXUilgdf4ssiAd0iZuA7UF
         B6aQ==
X-Gm-Message-State: AOAM5316yLw8dEktAFBeXXv/QVM0NAckjGy7ASY2yrGxIa74/UdKKGz9
        8QDkOdBy42/I4j9nbtDtMmcbU7CgPXzH/w==
X-Google-Smtp-Source: ABdhPJxgeGq3PNw4FCspmsLuagv1ulzThmDqzv43RKXadjIp5fizAbpoUIU5H/meky+bM/Ypyot3XQ==
X-Received: by 2002:a92:4188:: with SMTP id o130mr4766050ila.27.1602127192579;
        Wed, 07 Oct 2020 20:19:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c18sm2051602ild.35.2020.10.07.20.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 20:19:51 -0700 (PDT)
Date:   Wed, 07 Oct 2020 20:19:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Message-ID: <5f7e854b111fc_2acac2087e@john-XPS-13-9370.notmuch>
In-Reply-To: <CANP3RGdcqmcrxWDKPsZ8A0+qK1hzD0tZvRFsVMPvSCNDk+LrHA@mail.gmail.com>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208778070.798237.16265441131909465819.stgit@firesoul>
 <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
 <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
 <CANP3RGdcqmcrxWDKPsZ8A0+qK1hzD0tZvRFsVMPvSCNDk+LrHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej =C5=BBenczykowski wrote:
> On Wed, Oct 7, 2020 at 3:37 PM John Fastabend <john.fastabend@gmail.com=
> wrote:
> >
> > Daniel Borkmann wrote:
> > > On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
> > > [...]
> > > >   net/core/dev.c |   24 ++++++++++++++++++++++--
> > > >   1 file changed, 22 insertions(+), 2 deletions(-)
> >
> > Couple high-level comments. Whats the problem with just letting the d=
river
> > consume the packet? I would chalk it up to a buggy BPF program that i=
s
> > sending these packets. The drivers really shouldn't panic or do anyth=
ing
> > horrible under this case because even today I don't think we can be
> > 100% certain MTU on skb matches set MTU. Imagine the case where I cha=
nge
> > the MTU from 9kB->1500B there will be some skbs in-flight with the la=
rger
> > length and some with the shorter. If the drivers panic/fault or other=
wise
> > does something else horrible thats not going to be friendly in genera=
l case
> > regardless of what BPF does. And seeing this type of config is all do=
ne
> > async its tricky (not practical) to flush any skbs in-flight.
> >
> > I've spent many hours debugging these types of feature flag, mtu
> > change bugs on the driver side I'm not sure it can be resolved by
> > the stack easily. Better to just build drivers that can handle it IMO=
.
> >
> > Do we know if sending >MTU size skbs to drivers causes problems in re=
al
> > cases? I haven't tried on the NICs I have here, but I expect they sho=
uld
> > be fine. Fine here being system keeps running as expected. Dropping t=
he
> > skb either on TX or RX side is expected. Even with this change though=

> > its possible for the skb to slip through if I configure MTU on a live=

> > system.
> =

> I wholeheartedly agree with the above.
> =

> Ideally the only >mtu check should happen at driver admittance.
> But again ideally it should happen in some core stack location not in
> the driver itself.

Ideally maybe, but IMO we should just let the skb go to the driver
and let the driver sort it out. Even if this means pushing the packet
onto the wire then the switch will drop it or the receiver, etc. A
BPF program can do lots of horrible things that should never be
on the wire otherwise. MTU is just one of them, but sending corrupted
payloads, adding bogus headers, checksums etc. so I don't think we can
reasonable protect against all of them.

Of course if the driver is going to hang/panic then something needs
to be done. Perhaps a needs_mtu_check feature flag, although thats
not so nice either so perhaps drivers just need to handle it themselves.
Also even today the case could happen without BPF as best I can tell
so the drivers should be prepared for it.

> However, due to both gso and vlan offload, even this is not trivial to =
do...
> The mtu is L3, but drivers/hardware/the wire usually care about L2...
> (because ultimately that's what gets received and must fit in receive b=
uffers)=
