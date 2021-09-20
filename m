Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135F24127B3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbhITVFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:05:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhITVDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 17:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632171714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJhRY3ScCS/OW3g/SnAzyATsFxCUBetBM+BcPbwPq1A=;
        b=Ig9od6hSHj+Qq/98u4oxKqL1PU/QgfyCSMFdbqHoq3dd6dQOcjmFBVHOepX/MuFBUwnNod
        Xj1dIdKt132HbYk6o2tCJsQ2F73te1BXJftaasqIJOG5l+HBzzCOeV1PjldroLOq3nY0/L
        nO5gtwuBvefyzmZWsJKfu4WWshby3Xk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-4X0JDoJwOMmSdC3egBnbtA-1; Mon, 20 Sep 2021 17:01:53 -0400
X-MC-Unique: 4X0JDoJwOMmSdC3egBnbtA-1
Received: by mail-ed1-f71.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso3034835edw.10
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 14:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FJhRY3ScCS/OW3g/SnAzyATsFxCUBetBM+BcPbwPq1A=;
        b=hE7ydLMNsyndnrm4orvyMKwMogLniTagukshzFMeUf/Ghrt48JZhyjFEEUpHsiItAU
         FRM/K+OVRiD0Aocl0KIRJy5UjfA02eue4LSMXRqvVpayJv+NLuBQmN3tJKFN7+e1h4x2
         3vFYtUgnYGilPrfFgc6kmn7HPaJzP0g6+/aB6aUGwsAEreGt04j3eybirkAw8WwCET6Z
         RO+muXdoku2ji3zbw3nxxMWWJJg8y33cAOs8Ij/oLB+OWB21zFFqCpqkqkPq86CUhEbd
         6aiDqDJxFAqmOm4JVf8leOmi2eNv22xIWv1lYxAH1FB53AQKNV56uGHpgZrYlaBX4mT+
         e+7Q==
X-Gm-Message-State: AOAM533PHx6UYTvOALFqYeyihbR+bBIEhZLGth4/2KBzdMf41Jz6wEJr
        awj8+ddbIsrRIIPkbzUoAOV4SCwUl9aMqzM6zCd1+f/Tk+1eKzQA8SDl6D0kxSrgK64idS1dACU
        ebtIBUpfmK7R23JAU
X-Received: by 2002:a17:906:5acb:: with SMTP id x11mr29714562ejs.514.1632171710988;
        Mon, 20 Sep 2021 14:01:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsrOkvmwXPPtt6w9FAHvV7gkFkoag2FKG/BEtVNHX9WDhrUGDvH76vd0eBRRdpEvhdQF7SIA==
X-Received: by 2002:a17:906:5acb:: with SMTP id x11mr29714442ejs.514.1632171709572;
        Mon, 20 Sep 2021 14:01:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 90sm7471394edc.36.2021.09.20.14.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:01:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8016D18034A; Mon, 20 Sep 2021 23:01:48 +0200 (CEST)
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
In-Reply-To: <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 20 Sep 2021 23:01:48 +0200
Message-ID: <87lf3r3qrn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 18 Sep 2021 13:53:35 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> I'm OK with a bpf_header_pointer()-type helper - I quite like the
>> in-kernel version of this for SKBs, so replicating it as a BPF helper
>> would be great. But I'm a little worried about taking a performance hit.
>>=20
>> I.e., if you do:
>>=20
>> ptr =3D bpf_header_pointer(pkt, offset, len, stack_ptr)
>> *ptr =3D xxx;
>>=20
>> then, if the helper ended up copying the data into the stack pointer,
>> you didn't actually change anything in the packet, so you need to do a
>> writeback.
>>=20
>> Jakub suggested up-thread that this should be done with some kind of
>> flush() helper. But you don't know whether the header_pointer()-helper
>> copied the data, so you always need to call the flush() helper, which
>> will incur overhead. If the verifier can in-line the helpers that will
>> lower it, but will it be enough to make it negligible?
>
> Depends on the assumptions the program otherwise makes, right?
>
> For reading I'd expect a *layout-independent* TC program would=20
> replace approximately:
>
> ptr =3D <some_ptr>;
> if (ptr + CONST >=3D md->ptr_end)
> 	if (bpf_pull_data(md, off + CONST))
> 		return DROP;
> 	ptr =3D <some_ptr>;
> 	if (ptr + CONST >=3D md->ptr_end)
> 		return DROP; /* da hell? */
> }
>
> With this (pre-inlining):
>
> ptr =3D bpf_header_pointer(md, offset, len, stack);
> if (!ptr)
> 	return DROP;
>
> Post-inlining (assuming static validation of args to prevent wraps):
>
> if (md->ptr + args->off + args->len < md->ptr_end)
> 	ptr =3D md->ptr + args->off;
> else
> 	ptr =3D __bpf_header_pointer(md, offset, len, stack);
> if (!ptr)
> 	return DROP;
>
> But that's based on guesswork so perhaps I'm off base.

Yeah, that's more or less what I was thinking...

> Regarding the flush() I was expecting that most progs will not modify
> the packet (or at least won't modify most headers they load) so no
> point paying the price of tracking changes auto-magically.

... but I guess my mental model assumed that packet writes would be just
as frequent as reads, in which case it would be a win if you could amend
your example like:

> In fact I don't think there is anything infra can do better for
> flushing than the prog itself:
>
> 	bool mod =3D false;
>
> 	ptr =3D bpf_header_pointer(...);
> 	...
> 	if (some_cond(...)) {
> 		change_packet(...);
> 		mod =3D true;
> 	}
> 	...
> 	if (mod)

to have an additional check like:

if (mod && ptr =3D=3D stack)

(or something to that effect). No?

-Toke

> 		bpf_header_pointer_flush();
>
>
> is simple enough.. to me.

