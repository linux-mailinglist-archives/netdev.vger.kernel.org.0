Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E4D147D1F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgAXJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:57:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730166AbgAXJ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579859836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOQFLw8BcRnGH3tPybZqnyO5fEFSe9x+PHPVjPXoSW0=;
        b=U6VoGApdjueYT9kTbfvl56xBQ9gZpXXFkWTus4oNbutalWza/LUeV2pmmQbWOohfeEBAtR
        Vcr7LSvOQll3FbKRKbg/G9S2gxr433D/d/+eYfxu4XPmIq04Ja/1UBoveWKtivAxTsINz7
        6ao5eUtxWk2Aq5Evzp7useQrDlJRyAE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-wRNlebp1Mlisv0UpZM-hYw-1; Fri, 24 Jan 2020 04:57:14 -0500
X-MC-Unique: wRNlebp1Mlisv0UpZM-hYw-1
Received: by mail-lj1-f199.google.com with SMTP id f11so508505ljn.6
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 01:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vOQFLw8BcRnGH3tPybZqnyO5fEFSe9x+PHPVjPXoSW0=;
        b=hpVHwiG/zYj3sWS115pEhUMQRJ0CTTAsfQvr/GiCe51VsqYqfP7kfYxnATMURIqrCQ
         595D2Z8kOZMW6WIUhdZiMdu98tnmlL4k0q/24/p8Cy+h9yCKvlKC/OmpHUf0eUjIM0iK
         oLTOwPgX+iOUZa0fW7WI3rVCD6vLGNPFlH+Y0V5WlRbeyCEILdwJuIqDFNa7rkKPkQcM
         0nt8iXopkxjzHrvtH8UE5urQsNYZ5EPSx9bgI6NGKRKAqYoEBTjubq3TyfThmdSVvacr
         TYRu16PhD/iaN1zdGrKs1HDMkn1k2vgcqo25tdOenI87a4JgnQ/fpVA0UWe1I1VuJRSl
         WD1Q==
X-Gm-Message-State: APjAAAUfg3rIlNd1pzjip2TDY+ttePPWM6oND1EdNbtuEbvX/vNVMWcD
        ofQURMvNafigzCmF2iuwE//I175Bg8UAgwaaiHVQ+LQpdp8rGUSAEicvlmY1EVpxT37LuYq7JG7
        k7ukmegsKSPd61LyN
X-Received: by 2002:a2e:9e85:: with SMTP id f5mr1906711ljk.132.1579859833096;
        Fri, 24 Jan 2020 01:57:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCHcOMahfOgcEWj09dxoJ66hMP+ArheKTB3f81IWDigvvEH5cBo/gM7u9JzHn4fCnO8Eqrjw==
X-Received: by 2002:a2e:9e85:: with SMTP id f5mr1906694ljk.132.1579859832778;
        Fri, 24 Jan 2020 01:57:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a15sm2704877ljn.50.2020.01.24.01.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:57:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 081EB180073; Fri, 24 Jan 2020 10:57:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Luigi Rizzo <lrizzo@google.com>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk> <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com> <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com> <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 10:57:10 +0100
Message-ID: <87r1zpgosp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 1/23/20 7:06 PM, Luigi Rizzo wrote:
>> On Thu, Jan 23, 2020 at 10:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>>> Luigi Rizzo <lrizzo@google.com> writes:
>>>> On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>>>> On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>>>> Luigi Rizzo <lrizzo@google.com> writes:
>>>>>>>
>>>>>>>> Add a netdevice flag to control skb linearization in generic xdp m=
ode.
>>>>>>>> Among the various mechanism to control the flag, the sysfs
>>>>>>>> interface seems sufficiently simple and self-contained.
>>>>>>>> The attribute can be modified through
>>>>>>>>      /sys/class/net/<DEVICE>/xdp_linearize
>>>>>>>> The default is 1 (on)
>>>>>>
>>>>>> Needs documentation in Documentation/ABI/testing/sysfs-class-net.
>>>>>>
>>>>>>> Erm, won't turning off linearization break the XDP program's abilit=
y to
>>>>>>> do direct packet access?
>>>>>>
>>>>>> Yes, in the worst case you only have eth header pulled into linear
>>>>>> section. :/
>>>>>
>>>>> In which case an eBPF program could read/write out of bounds since the
>>>>> verifier only verifies checks against xdp->data_end. Right?
>>>>
>>>> Why out of bounds? Without linearization we construct xdp_buff as foll=
ows:
>>>>
>>>> mac_len =3D skb->data - skb_mac_header(skb);
>>>> hlen =3D skb_headlen(skb) + mac_len;
>>>> xdp->data =3D skb->data - mac_len;
>>>> xdp->data_end =3D xdp->data + hlen;
>>>> xdp->data_hard_start =3D skb->data - skb_headroom(skb);
>>>>
>>>> so we shouldn't go out of bounds.
>>>
>>> Hmm, right, as long as it's guaranteed that the bit up to hlen is
>>> already linear; is it? :)
>>=20
>> honest question: that would be skb->len - skb->data_len, isn't that
>> the linear part by definition ?
>
> Yep, that's the linear part by definition. Generic XDP with ->data/->data=
_end is in
> this aspect no different from tc/BPF where we operate on skb context. Onl=
y linear part
> can be covered from skb (unless you pull in more via helper for the
> latter).

OK, but then why are we linearising in the first place? Just to get
sufficient headroom?

-Toke

