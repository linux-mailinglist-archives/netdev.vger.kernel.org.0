Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C59412900
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 00:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhITWsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 18:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhITWqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 18:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632177888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88myFipFm8d9WOhx1IFB6Guq2ZeY3SG01w4pCHkyA34=;
        b=T6cdAB9juDX2L4FYINTtFFDL3SKxjKl+k5sjkzdThDAwZo0s5qqkMk7/oIWBdm4g4wprLd
        PRUSFDX1IqCRBxRbsA3VGnilgVwYgyhBbKRgHWU+4T1x6SUsGVoZ1UbPwtIbZoUBvXA7fL
        U0DSF0kQqAImoENueu0RFaVx4udmUrw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-BZI4_bTBNQWLelCu_sOuJw-1; Mon, 20 Sep 2021 18:44:47 -0400
X-MC-Unique: BZI4_bTBNQWLelCu_sOuJw-1
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so17075874ede.16
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 15:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=88myFipFm8d9WOhx1IFB6Guq2ZeY3SG01w4pCHkyA34=;
        b=tVLLss4Fj/4mvOg/AKCAaq2zg6J1OOCJ8wB4jtv0wIqfIfOrDiDSDjnZ1GCsNLQGWY
         gmrU9jKu15pxVbQTpUc90ZUsoqVxO+0I6T9WTVEW92dxtCP1AHn2uTrl9rykhnVptnDc
         B6D0jqVdKyFWAON9TjRM4Y++8n8kTLhr//wQQx0w08KRqSpuoiEV6+be9BrbJqA57xnR
         xP6DKsIX7otqpt8tK3Sd9RrZOTqTjDHU25o+6OQktexXaeZgVWkxh1hsiLnIQ12QI8D0
         APRhD6io8VcIwkh+1nbly+pLXbz/wbXv15Ai7DYLF/Desg1XtqpFJ00gGbj26lSWiuTa
         0fGQ==
X-Gm-Message-State: AOAM533RSU8Ci5IpWiUT3JUI76pxyyzSwoQ14e442QW/4fWB0JzaFiIP
        lySlcR9ZCXd0zlNapSakQ33du80B9ecnWzml/wgNtvmyBMaXXat6L+BlNDu5a5NgIy+K9u7YrgW
        tbE9axrI165gVT4k6
X-Received: by 2002:aa7:d796:: with SMTP id s22mr31425858edq.244.1632177884748;
        Mon, 20 Sep 2021 15:44:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn8J8095oX5BZbYaGcX5Q3GbYfvkzwEVzVGgxABFhUkQ1CIV1Gnyv300MTM8BH9dOuc9RY2w==
X-Received: by 2002:aa7:d796:: with SMTP id s22mr31425774edq.244.1632177883590;
        Mon, 20 Sep 2021 15:44:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g1sm3035713edv.25.2021.09.20.15.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 15:44:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 26EED18034A; Tue, 21 Sep 2021 00:44:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk>
 <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
 <8735q25ccg.fsf@toke.dk>
 <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lf3r3qrn.fsf@toke.dk>
 <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Sep 2021 00:44:42 +0200
Message-ID: <87ilyu50kl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 20 Sep 2021 23:01:48 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > In fact I don't think there is anything infra can do better for
>> > flushing than the prog itself:
>> >
>> > 	bool mod =3D false;
>> >
>> > 	ptr =3D bpf_header_pointer(...);
>> > 	...
>> > 	if (some_cond(...)) {
>> > 		change_packet(...);
>> > 		mod =3D true;
>> > 	}
>> > 	...
>> > 	if (mod)=20=20
>>=20
>> to have an additional check like:
>>=20
>> if (mod && ptr =3D=3D stack)
>>=20
>> (or something to that effect). No?
>
> Good point. Do you think we should have the kernel add/inline this
> optimization or have the user do it explicitly.

Hmm, good question. On the one hand it seems like an easy optimisation
to add, but on the other hand maybe the caller has other logic that can
better know how/when to omit the check.

Hmm, but the helper needs to check it anyway, doesn't it? At least it
can't just blindly memcpy() if the source and destination would be the
same...

> The draft API was:
>
> void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,=20
>                            u32 offset, u32 len, void *stack_buf)
>
> Which does not take the ptr returned by header_pointer(), but that's
> easy to add (well, easy other than the fact it'd be the 6th arg).

I guess we could play some trickery with stuffing offset/len/flags into
one or two u64s to save an argument or two?

> BTW I drafted the API this way to cater to the case where flush()
> is called without a prior call to header_pointer(). For when packet
> trailer or header is populated directly from a map value. Dunno if
> that's actually useful, either.

Ah, didn't think of that; so then it really becomes a generic
xdp_store_bytes()-type helper? Might be useful, I suppose. Adding
headers is certainly a fairly common occurrence, but dunno to what
extent they'd be copied wholesale from a map (hadn't thought about doing
that before either).

-Toke

