Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0B23623EF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbhDPPaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343665AbhDPPaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618586985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/fY6tH910Gj68UulmclLZyMHebVkIaSbNLEKphOx3ns=;
        b=AV9RV12s6YoMCi5yL2p6nUY1xchSxD6z2lRkvgsLimgwJAoBwsmrBfSfc/TDiJzt+2ab0x
        vjhz7dek3mzEr+b+P0imqeOLlHZLL69WBi69rRQlP0Wjnfy2YOyI7z6E3os0apEhbSBEqC
        F6+xf/rEiEJ0w6xm8c8XgKO12z2rses=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-dAEZ8Z6kN9OFQR0qlC_I6w-1; Fri, 16 Apr 2021 11:29:41 -0400
X-MC-Unique: dAEZ8Z6kN9OFQR0qlC_I6w-1
Received: by mail-ej1-f70.google.com with SMTP id c18-20020a17090603d2b029037c77ad778eso2139222eja.1
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 08:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/fY6tH910Gj68UulmclLZyMHebVkIaSbNLEKphOx3ns=;
        b=AqWtkzFToEnekFJ/6lL0cWy4KpgRJAZQOjj9VXu+E5mkUiJCWGHF9sqj9mJe2Vk5im
         LBCGHSlpEyNU3h3dmiaD4rYN9XiViKFLlL6PBYmSMBKLOxv4KmXnGu1KM1MXENiyz8kf
         Tp7zQuUM+4Vygj+J8oZfcQ3J5JiJlFDL26DQTZxzqlGTspOuu0uFCKynZpWUgUORDyMT
         gNHoTxrbAv20f2GpOx8xfQQfAGDhxymkb/9p3+H+3nYXbDUbL/158rOTUycA+4pI3SIs
         /EpLuND42hOgGR5Z9gazR/ui9Ua87wboINBBqloYF8iiOspixcTSPoLxALWeuxDz6l6Z
         byxQ==
X-Gm-Message-State: AOAM530tK34JoezWRRNQpoK8JyB7L5RmpUr9BlFsHotSN/oC0JAxwFb4
        Z8X93+4vFcsoFtAJmKU0zH/EdwY/ZV8ztw7b8vlGFuKMqJEUhh19+lXVNKhb5HGTrBbnEonfcyX
        q6gYexHgCajV44DBY
X-Received: by 2002:a17:906:98c1:: with SMTP id zd1mr8877887ejb.447.1618586980068;
        Fri, 16 Apr 2021 08:29:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSLT565+usWHKQNUVyqqR8zbITBTxKBQnRXeBHp/ieQEbb/tjF/BkDib2r28T1N4L/4stqNg==
X-Received: by 2002:a17:906:98c1:: with SMTP id zd1mr8877855ejb.447.1618586979651;
        Fri, 16 Apr 2021 08:29:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b8sm5940522edu.41.2021.04.16.08.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 08:29:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 952411806B2; Fri, 16 Apr 2021 17:29:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
In-Reply-To: <d9b5f599380d32a28026d5a758cc46edf2ba23d8.camel@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
 <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
 <87v98vtsgg.fsf@toke.dk>
 <d9b5f599380d32a28026d5a758cc46edf2ba23d8.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 16 Apr 2021 17:29:37 +0200
Message-ID: <87blaegsda.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Fri, 2021-04-09 at 16:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Paolo Abeni <pabeni@redhat.com> writes:
>>=20
>> > Currently the veth device has the GRO feature bit set, even if
>> > no GRO aggregation is possible with the default configuration,
>> > as the veth device does not hook into the GRO engine.
>> >=20
>> > Flipping the GRO feature bit from user-space is a no-op, unless
>> > XDP is enabled. In such scenario GRO could actually take place, but
>> > TSO is forced to off on the peer device.
>> >=20
>> > This change allow user-space to really control the GRO feature, with
>> > no need for an XDP program.
>> >=20
>> > The GRO feature bit is now cleared by default - so that there are no
>> > user-visible behavior changes with the default configuration.
>> >=20
>> > When the GRO bit is set, the per-queue NAPI instances are initialized
>> > and registered. On xmit, when napi instances are available, we try
>> > to use them.
>>=20
>> Am I mistaken in thinking that this also makes XDP redirect into a veth
>> work without having to load an XDP program on the peer device? That's
>> been a long-outstanding thing we've been meaning to fix, so that would
>> be awesome! :)
>
> I have not experimented that, and I admit gross ignorance WRT this
> argument, but AFAICS the needed bits to get XDP redirect working on
> veth are the ptr_ring initialization and the napi instance available.
>
> With this patch both are in place when GRO is enabled, so I guess XPD
> redirect should work, too (modulo bugs for untested scenario).

OK, finally got around to testing this; it doesn't quite work with just
your patch, because veth_xdp_xmit() still checks for rq->xdp_prog
instead of rq->napi. Fixing this indeed enabled veth to be an
XDP_REDIRECT target without an XDP program loaded on the peer. So yay!
I'll send a followup fixing that check.

So with this we seem to have some nice improvements in both
functionality and performance when GRO is turned on; so any reason why
we shouldn't just flip the default to on?

-Toke

