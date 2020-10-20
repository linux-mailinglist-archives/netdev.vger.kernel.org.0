Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B432941E9
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408951AbgJTSI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:08:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387945AbgJTSI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603217306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYbzd59+8jONE13NYNfdI5cI4F2XnnmBUm6WJUpf2+Y=;
        b=e5tW68SnQBrapSQ+aSpsabUaiYVcBz0X1d1JJlA0x9v+T33AQE6XIy7T50IEKU2MXE2egJ
        HWgIKxHl62p00yq7S9aLfX17pTaKSGU35ojo+xtW33SUkXiPFl5XH2j1CsU04y8OCbHSV3
        L06egdGqu4Ae2LTJDkI6C0ER98UoJcI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-mMIGnk4jNsqtkglJTnMybg-1; Tue, 20 Oct 2020 14:08:24 -0400
X-MC-Unique: mMIGnk4jNsqtkglJTnMybg-1
Received: by mail-wr1-f69.google.com with SMTP id n14so1120934wrp.1
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tYbzd59+8jONE13NYNfdI5cI4F2XnnmBUm6WJUpf2+Y=;
        b=lCyM4PcYcDz5ltU+pcWJSWHdzXO83y5yJH63qA9V3m7aYrO6Ogl0rA0LGbFBEhxpwF
         z2qUpoS8SqE7gMSiotZOsl1xUMrINictaa8XWLod68x8lRxbjIp9SRyU9+XR/55oTrAd
         mfYkEqyo/gXYhkXQD8MFOkNE3iE0g2QsD+AYhWdMWukwK7lxtw9FVryhMyeF90H/cFa/
         7TlkLCYrToKtGo7FNV16QUWEzB6cBJHgqEimmmwyqXGcicpzMXEPZJ/L/Q82pif5odiF
         1EXUwdQiCU+pFZCQ5lfgLO9S/nKaPglhs61P+aalZde8sGVLfgAjmP/Zw41agdGrBvdb
         my8w==
X-Gm-Message-State: AOAM531AeZyFaLzBNfNxC47TadRTmu+wD7PRdyJPIAQrqOv2CwnK37EM
        cVd/knOsTkyA7cucE9Tz2ZLoHhhySKW3DQQlatzgOvkKjyI+jy52wOiYL/QXw3grJbU6TWOhgc/
        iTPsjzqaFR+LQkH5Y
X-Received: by 2002:a1c:111:: with SMTP id 17mr4108854wmb.126.1603217303472;
        Tue, 20 Oct 2020 11:08:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa63yJUlYyrfh0gQEOGZzuXPBWt8Hvi3B9kOjcKh2ifmZqEME33JbT8bSoi85kfyilhjgH6w==
X-Received: by 2002:a1c:111:: with SMTP id 17mr4108817wmb.126.1603217302918;
        Tue, 20 Oct 2020 11:08:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 24sm3699630wmg.8.2020.10.20.11.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 11:08:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DD5DA1838FA; Tue, 20 Oct 2020 20:08:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
In-Reply-To: <d6967cfe-fd0e-268a-5526-dd03f0e476e6@iogearbox.net>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <d6967cfe-fd0e-268a-5526-dd03f0e476e6@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Oct 2020 20:08:21 +0200
Message-ID: <87tuuo22ju.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/20/20 12:51 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> [...]
>>   BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u6=
4, flags)
>> @@ -2455,8 +2487,8 @@ int skb_do_redirect(struct sk_buff *skb)
>>   		return -EAGAIN;
>>   	}
>>   	return flags & BPF_F_NEIGH ?
>> -	       __bpf_redirect_neigh(skb, dev) :
>> -	       __bpf_redirect(skb, dev, flags);
>> +		__bpf_redirect_neigh(skb, dev, flags & BPF_F_NEXTHOP ? &ri->nh : NULL=
) :
>> +		__bpf_redirect(skb, dev, flags);
>>   out_drop:
>>   	kfree_skb(skb);
>>   	return -EINVAL;
>> @@ -2504,16 +2536,25 @@ static const struct bpf_func_proto bpf_redirect_=
peer_proto =3D {
>>   	.arg2_type      =3D ARG_ANYTHING,
>>   };
>>=20=20=20
>> -BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
>> +BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, =
params,
>> +	   int, plen, u64, flags)
>>   {
>>   	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>>=20=20=20
>> -	if (unlikely(flags))
>> +	if (unlikely((plen && plen < sizeof(*params)) || flags))
>> +		return TC_ACT_SHOT;
>> +
>> +	if (unlikely(plen && (params->unused[0] || params->unused[1] ||
>> +			      params->unused[2])))
>
> small nit: maybe fold this into the prior check that already tests non-ze=
ro plen
>
> if (unlikely((plen && (plen < sizeof(*params) ||
>                         (params->unused[0] | params->unused[1] |
>                          params->unused[2]))) || flags))
>          return TC_ACT_SHOT;

Well that was my first thought as well, but I thought it was uglier.
Isn't the compiler smart enough to make those two equivalent?

Anyway, given Jakub's comment, I guess this is moot anyway, as we should
just get rid of the member, no?

-Toke

