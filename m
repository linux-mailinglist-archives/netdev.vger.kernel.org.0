Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F11351445
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 13:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhDALLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 07:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234207AbhDALLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 07:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617275433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EeOJX2ut1yR1JpGJMK7VkaOeY20GXea4Wy+TEDh9VU8=;
        b=AT0fDHpAuxOErp1fT6TaJ83eW+uf8WcfMZuPUKUcmUUh/YdXkGn9xRkJUICOfNtmVIHW8C
        SnAEqk8TidyYLl92WYD6dPna6EZkI1BQ+Xskx26/iMVMJEypAJVyAebPBm6Ow95xljRRHX
        6OHLvF0F9k4cspVCMMG9NmEcb1p08rc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-IRNJK-L_Nrux0Lsk3TO2VQ-1; Thu, 01 Apr 2021 07:10:32 -0400
X-MC-Unique: IRNJK-L_Nrux0Lsk3TO2VQ-1
Received: by mail-ed1-f72.google.com with SMTP id r19so2667370edv.3
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 04:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EeOJX2ut1yR1JpGJMK7VkaOeY20GXea4Wy+TEDh9VU8=;
        b=H+E8r74xLfkhUKIb1Nv6W3YV6sIydUygvBYFTHR5r1xVn4E5LoXsPDZdF4UPPNGhMv
         t7QqUIIdi22BV+oCvlZm0nG81KiMXQgJnwp8Ydr1TIVMABjxWOnrY6OO2yK7b7t/ssqh
         afbQttXY7Y7DPvlMXPaAYdpq6ZQ6wAwW+aBqplGHCHuE8F8O0y8GA7wi0gHSOE65ShlA
         kU7Xv8a5dvNCTnYPm1LeNThIqqDS4l/FnxK9wIHPVF/v27LYJlcNDEW7KJ5mUWawQZxs
         0MYp0h9H2tadNIxoUtZA2FHus8wuCFXOqd557NfROujPsN8ODiiIOdBAQT9n1DhPwP0x
         p3kg==
X-Gm-Message-State: AOAM532NlkVfKzQ+f3kT0viXRj8IIXdbkGbKYrGlNBDWoyjqnKyzuyPc
        cAhtJcRUud6S9LC4rj9VNU4mFNqLeFwF3sKvJdrJmS9fXtZz01p56jvRT8CFQup604+pI3ar+RY
        M6OXI84ObDDcgufy2
X-Received: by 2002:a17:906:ecaa:: with SMTP id qh10mr8507490ejb.425.1617275431190;
        Thu, 01 Apr 2021 04:10:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH/c17591YFQbsgmwGp7V0SjnoOBrfMHcajy8KjCCnk1H7QqgOkJGEEFnEo3CF9P6ujhIzGQ==
X-Received: by 2002:a17:906:ecaa:: with SMTP id qh10mr8507458ejb.425.1617275430886;
        Thu, 01 Apr 2021 04:10:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id gq9sm2689327ejb.62.2021.04.01.04.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 04:10:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 888D1180290; Thu,  1 Apr 2021 13:10:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210401043004.GE2900@Leo-laptop-t470s>
References: <20210325092733.3058653-1-liuhangbin@gmail.com>
 <20210325092733.3058653-3-liuhangbin@gmail.com> <87lfa3phj6.fsf@toke.dk>
 <20210401043004.GE2900@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 01 Apr 2021 13:10:29 +0200
Message-ID: <87k0pmntui.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Wed, Mar 31, 2021 at 03:41:17PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> > @@ -1491,13 +1492,20 @@ static __always_inline int __bpf_xdp_redirect_=
map(struct bpf_map *map, u32 ifind
>> >  		 */
>> >  		ri->map_id =3D INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
>> >  		ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
>> > -		return flags;
>> > +		return flags & BPF_F_ACTION_MASK;
>> >  	}
>> >=20=20
>> >  	ri->tgt_index =3D ifindex;
>> >  	ri->map_id =3D map->id;
>> >  	ri->map_type =3D map->map_type;
>> >=20=20
>> > +	if ((map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||
>> > +	     map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) &&
>> > +	    (flags & BPF_F_BROADCAST)) {
>> > +		ri->flags =3D flags;
>>=20
>> This, combined with this:
>>=20
>> [...]
>>=20
>> > +	if (ri->flags & BPF_F_BROADCAST) {
>> > +		map =3D READ_ONCE(ri->map);
>> > +		WRITE_ONCE(ri->map, NULL);
>> > +	}
>> > +
>> >  	switch (map_type) {
>> >  	case BPF_MAP_TYPE_DEVMAP:
>> >  		fallthrough;
>> >  	case BPF_MAP_TYPE_DEVMAP_HASH:
>> > -		err =3D dev_map_enqueue(fwd, xdp, dev);
>> > +		if (ri->flags & BPF_F_BROADCAST)
>> > +			err =3D dev_map_enqueue_multi(xdp, dev, map,
>> > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
>> > +		else
>> > +			err =3D dev_map_enqueue(fwd, xdp, dev);
>>=20
>> Means that (since the flags value is never cleared again) once someone
>> has done a broadcast redirect, that's all they'll ever get until the
>> next reboot ;)
>
> How about just get the ri->flags first and clean it directly. e.g.
>
> flags =3D ri->flags;
> ri->flags =3D 0;

That would fix the "until next reboot" issue, but would still render
bpf_clear_redirect_map() useless. So you still need to check ri->map and
if you do that you don't actually need to clear the flag field as long
as it is set correctly whenever the map pointer is.

> With this we don't need to add an extra field ri->exclude_ingress as you
> mentioned later.

The ri->exclude_ingress would be *instead* of the flags field. You could
of course also just keep the flags field, but turning it into a bool
makes it obvious that only one of the bits is actually used (and thus
easier to see that it's correct to not clear it).

> People may also need the flags field in future.

In which case they can add it back at that time :)

>> Also, the bpf_clear_redirect_map() call has no effect since the call to
>> dev_map_enqueue_multi() only checks the flags and not the value of the
>> map pointer before deciding which enqueue function to call.
>>=20
>> To fix both of these, how about changing the logic so that:
>>=20
>> - __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag is
>>   set (and clears it if the flag isn't set!)
>
> OK
>>=20
>> - xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map
>>   unconditionally and then dispatches to dev_map_enqueue_multi() if the
>>   read resulted in a non-NULL pointer
>>=20
>> Also, it should be invalid to set the broadcast flag with a map type
>> other than a devmap; __bpf_xdp_redirect_map() should check that.
>
> The current code only do if (unlikely(flags > XDP_TX)) and didn't check t=
he
> map type. I also only set the map when there has devmap + broadcast flag.
> Do you mean we need a more strict check? like
>
> if (unlikely((flags & ~(BPF_F_ACTION_MASK | BPF_F_REDIR_MASK)) ||
> 	      (map->map_type !=3D BPF_MAP_TYPE_DEVMAP &&
> 	       map->map_type !=3D BPF_MAP_TYPE_DEVMAP_HASH &&
> 	       flags & BPF_F_REDIR_MASK)))

Yeah, that's what I meant, but when you type it out that does seem like
a bit too many checks.

However, I think we can do something different: Since Bj=C3=B6rn has
helpfully split out the helper functions for the different map types, we
can add another argument to __bpf_xdp_redirect_map() which is the mask
of valid flag values. With this, dev_{hash_,}map_redirect() can include
BPF_F_REDIR_MASK in the valid flags, and {xsk,cpu}_map_redirect() can
leave them out. That makes the code do the right thing without actually
adding any more checks in the fast path :)

(You'd still need to AND the return value with BPF_F_ACTION_MASK when
returning, of course).

-Toke

