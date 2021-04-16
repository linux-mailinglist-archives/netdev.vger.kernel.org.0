Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65E9362797
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbhDPSUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:20:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236112AbhDPSUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618597189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Rg473Jfl5bMjFNj4KOIAigsUlJm5lacZtqrbLYBKso=;
        b=N7SLWjejz+gP1cIi18c5NFkyiI0JM/tE51R0XoyFYUNEQTeLI6JezkqZMpOF093T2hbaav
        O7caRIFv3POCkmj2GezQW98aq/MPrUAwoy3XM89B8FnWunG/Q4A22LSSrwf0oDOwaDOOzw
        3yBQyTfWm+eswpw1Bg6CczgMk3xC/R0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-eecSMXTlNMyJS7ZVjbECTg-1; Fri, 16 Apr 2021 14:19:45 -0400
X-MC-Unique: eecSMXTlNMyJS7ZVjbECTg-1
Received: by mail-ed1-f69.google.com with SMTP id co5-20020a0564020c05b02903825bcdad12so7414677edb.0
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8Rg473Jfl5bMjFNj4KOIAigsUlJm5lacZtqrbLYBKso=;
        b=NH1IgI0Q/RMdtu6HYsmb1TkimUPZ/+XSVbSD72fiQnF80Yt1I/POmPRIB7HSPXvFGr
         PkOTa3wMyBxPt4pGCGZ3vq4T/obJexe/bo4aCHaCuPJWldtJQrLMNNwGpWt5YZFyMeYF
         A7LQE9P5hGT2VrDjwn3lxYQvbKeg1bUsm5120AVxODQxTHhTzM+s/WFTdXDXjV6iBUho
         LEB1DGpY0ugRYCbR/aOVMBHafpw2FH+uhYkLW9ASBfo3vuhhIrrnAyy/cgQtmSclt+Nb
         eCBBlHMS21QqNqTiuG6/ukxLYSru1Ztb5566li62G3qe5nZ2+a8tU13+SL6SGdoqfBRa
         q/7Q==
X-Gm-Message-State: AOAM5315bUTMUClRv2sSnlOSkC3B1O175rghB4/RxO4DA+9SDyafkezP
        ctH++rHO+dV8e+eiYaUkCtbn/s+ZcrVUF+LTkdyZLd6lFxfoF0ZJIYNC0Uy2VcmN+cmCzMAEUjX
        vp6kYDx2R/RlcJTUZ
X-Received: by 2002:a17:906:170f:: with SMTP id c15mr9547722eje.358.1618597184338;
        Fri, 16 Apr 2021 11:19:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl/Lz5LA8GVyt2djw8aha/cB27VbHUh3F5vpjhGqGtM21ZiSze9dzOrb2SdJ/Ydg8Tj4gBSA==
X-Received: by 2002:a17:906:170f:: with SMTP id c15mr9547693eje.358.1618597183905;
        Fri, 16 Apr 2021 11:19:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h15sm4789940ejs.72.2021.04.16.11.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 11:19:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 76E161806B2; Fri, 16 Apr 2021 20:19:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
In-Reply-To: <9111f5868bac3d3d4de52263f6df8da051cdfcf9.camel@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
 <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
 <87v98vtsgg.fsf@toke.dk>
 <d9b5f599380d32a28026d5a758cc46edf2ba23d8.camel@redhat.com>
 <87blaegsda.fsf@toke.dk>
 <9111f5868bac3d3d4de52263f6df8da051cdfcf9.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 16 Apr 2021 20:19:42 +0200
Message-ID: <871rbagkht.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Fri, 2021-04-16 at 17:29 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Paolo Abeni <pabeni@redhat.com> writes:
>>=20
>> > On Fri, 2021-04-09 at 16:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> > > Paolo Abeni <pabeni@redhat.com> writes:
>> > >=20
>> > > > Currently the veth device has the GRO feature bit set, even if
>> > > > no GRO aggregation is possible with the default configuration,
>> > > > as the veth device does not hook into the GRO engine.
>> > > >=20
>> > > > Flipping the GRO feature bit from user-space is a no-op, unless
>> > > > XDP is enabled. In such scenario GRO could actually take place, but
>> > > > TSO is forced to off on the peer device.
>> > > >=20
>> > > > This change allow user-space to really control the GRO feature, wi=
th
>> > > > no need for an XDP program.
>> > > >=20
>> > > > The GRO feature bit is now cleared by default - so that there are =
no
>> > > > user-visible behavior changes with the default configuration.
>> > > >=20
>> > > > When the GRO bit is set, the per-queue NAPI instances are initiali=
zed
>> > > > and registered. On xmit, when napi instances are available, we try
>> > > > to use them.
>> > >=20
>> > > Am I mistaken in thinking that this also makes XDP redirect into a v=
eth
>> > > work without having to load an XDP program on the peer device? That's
>> > > been a long-outstanding thing we've been meaning to fix, so that wou=
ld
>> > > be awesome! :)
>> >=20
>> > I have not experimented that, and I admit gross ignorance WRT this
>> > argument, but AFAICS the needed bits to get XDP redirect working on
>> > veth are the ptr_ring initialization and the napi instance available.
>> >=20
>> > With this patch both are in place when GRO is enabled, so I guess XPD
>> > redirect should work, too (modulo bugs for untested scenario).
>>=20
>> OK, finally got around to testing this; it doesn't quite work with just
>> your patch, because veth_xdp_xmit() still checks for rq->xdp_prog
>> instead of rq->napi. Fixing this indeed enabled veth to be an
>> XDP_REDIRECT target without an XDP program loaded on the peer. So yay!
>> I'll send a followup fixing that check.
>
> Thank you for double checking!
>
>> So with this we seem to have some nice improvements in both
>> functionality and performance when GRO is turned on; so any reason why
>> we shouldn't just flip the default to on?
>
> Uhmmm... patch 3/4 should avoid the GRO overhead for most cases where
> we can't leverage the aggregation benefit, but I'm not 110% sure that
> enabling GRO by default will not cause performance regressions in some
> scenarios.
>
> It this proves to be always a win we can still change the default
> later, I think.

Alright, sure, let's hold off on that and revisit once this has had some
more testing :)

-Toke

