Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E922929D6
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgJSO4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:56:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgJSO4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603119400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zzRjkH6KuUAJRoVsyHJMgTyrA2tp7W2lnqVTp/M173Q=;
        b=KDdStr1MzjkxSYdEor65CUYSMFgBOwilIrqrEgVwn8FQOQiGAryKlOq67+RR+e6MTGOd0+
        j0JjTwfili1BhPibysBW6ZDvFp9G//Tnfnnb6Mi5WxNTT62p4akmT3orihGQngyouOasRe
        pqQpNgLXOGSi8wFcd+LHPPymSH/K80o=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-fFXC4Y7WPDm2RrtCtlLJbA-1; Mon, 19 Oct 2020 10:56:39 -0400
X-MC-Unique: fFXC4Y7WPDm2RrtCtlLJbA-1
Received: by mail-ej1-f72.google.com with SMTP id z25so4782676ejd.2
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 07:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zzRjkH6KuUAJRoVsyHJMgTyrA2tp7W2lnqVTp/M173Q=;
        b=oH9NdHzEQlrcFdL/3eWmcrHloNjs707FHsz3RD7RXlDZRw135nWrrz8PiEurW5jmHQ
         Ble2wFpLjuWDhNQRRVKwOiKdxHyIj63mtv7ZqP7UtLj/bfKqJ7+SBhp4CQewUTwy6unf
         HLo88DkEH8V5taXv/4aPf0h2Auys62GK4wgCtbX0BHUK3v4BTXXHibsyMMjcgk/e60LN
         zl7q3c3nn2DSMshti6bx02AMNtoQAFWWLiRcPV6YJmkyF25xKL/SQq+TpADULbWsG//A
         EJRiM5pKpi/unFzvPSKFYVayJy80q7U8uMbn0SLNj9BylwGlU472DHWqSQ7LX9guUSWn
         SnzA==
X-Gm-Message-State: AOAM531gilYLSu6xbDrzcsk8uGGab3IUbYXzXeLdw5UIwyVPJ/phlUKX
        yoEOKKNcdM3n5vm4GS2lD0uSlFvEHV//e0yliwryu3G4dpXsG602gd5C5O6QzGhadS2C8bbySjO
        yPVeb+YPjCQH7rpMO
X-Received: by 2002:a17:906:5596:: with SMTP id y22mr263895ejp.189.1603119397494;
        Mon, 19 Oct 2020 07:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2mGHzKLRikYIHfXiOt36XjJtisRhF9xbPb038BBqCsjpTPOENXQ1UyegqYNKTxkoNdmPKFQ==
X-Received: by 2002:a17:906:5596:: with SMTP id y22mr263875ejp.189.1603119397108;
        Mon, 19 Oct 2020 07:56:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id fx11sm303944ejb.77.2020.10.19.07.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 07:56:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 207A41837DD; Mon, 19 Oct 2020 16:56:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
In-Reply-To: <3d90f3aa-fc09-983f-0e5d-81e889d03b54@iogearbox.net>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
 <3d90f3aa-fc09-983f-0e5d-81e889d03b54@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Oct 2020 16:56:36 +0200
Message-ID: <87tuuqe02j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/15/20 5:46 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> Based on the discussion in [0], update the bpf_redirect_neigh() helper to
>> accept an optional parameter specifying the nexthop information. This ma=
kes
>> it possible to combine bpf_fib_lookup() and bpf_redirect_neigh() without
>> incurring a duplicate FIB lookup - since the FIB lookup helper will retu=
rn
>> the nexthop information even if no neighbour is present, this can simply=
 be
>> passed on to bpf_redirect_neigh() if bpf_fib_lookup() returns
>> BPF_FIB_LKUP_RET_NO_NEIGH.
>>=20
>> [0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iog=
earbox.net/
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Overall looks good from what I can tell, just small nits below on top of
> David's feedback:
>
> [...]
>> -static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_devi=
ce *dev)
>> +static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_devi=
ce *dev,
>> +				   struct bpf_nh_params *nh)
>>   {
>>   	const struct iphdr *ip4h =3D ip_hdr(skb);
>>   	struct net *net =3D dev_net(dev);
>>   	int err, ret =3D NET_XMIT_DROP;
>> -	struct rtable *rt;
>> -	struct flowi4 fl4 =3D {
>> -		.flowi4_flags	=3D FLOWI_FLAG_ANYSRC,
>> -		.flowi4_mark	=3D skb->mark,
>> -		.flowi4_tos	=3D RT_TOS(ip4h->tos),
>> -		.flowi4_oif	=3D dev->ifindex,
>> -		.flowi4_proto	=3D ip4h->protocol,
>> -		.daddr		=3D ip4h->daddr,
>> -		.saddr		=3D ip4h->saddr,
>> -	};
>>=20=20=20
>> -	rt =3D ip_route_output_flow(net, &fl4, NULL);
>> -	if (IS_ERR(rt))
>> -		goto out_drop;
>> -	if (rt->rt_type !=3D RTN_UNICAST && rt->rt_type !=3D RTN_LOCAL) {
>> -		ip_rt_put(rt);
>> -		goto out_drop;
>> -	}
>> +	if (!nh->nh_family) {
>> +		struct rtable *rt;
>> +		struct flowi4 fl4 =3D {
>> +			.flowi4_flags =3D FLOWI_FLAG_ANYSRC,
>> +			.flowi4_mark =3D skb->mark,
>> +			.flowi4_tos =3D RT_TOS(ip4h->tos),
>> +			.flowi4_oif =3D dev->ifindex,
>> +			.flowi4_proto =3D ip4h->protocol,
>> +			.daddr =3D ip4h->daddr,
>> +			.saddr =3D ip4h->saddr,
>> +		};
>> +
>> +		rt =3D ip_route_output_flow(net, &fl4, NULL);
>> +		if (IS_ERR(rt))
>> +			goto out_drop;
>> +		if (rt->rt_type !=3D RTN_UNICAST && rt->rt_type !=3D RTN_LOCAL) {
>> +			ip_rt_put(rt);
>> +			goto out_drop;
>> +		}
>>=20=20=20
>> -	skb_dst_set(skb, &rt->dst);
>> +		skb_dst_set(skb, &rt->dst);
>> +		nh =3D NULL;
>> +	}
>>=20=20=20
>> -	err =3D bpf_out_neigh_v4(net, skb);
>> +	err =3D bpf_out_neigh_v4(net, skb, dev, nh);
>>   	if (unlikely(net_xmit_eval(err)))
>>   		dev->stats.tx_errors++;
>>   	else
>> @@ -2355,7 +2383,8 @@ static int __bpf_redirect_neigh_v4(struct sk_buff =
*skb, struct net_device *dev)
>>   }
>>   #endif /* CONFIG_INET */
>>=20=20=20
>> -static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device =
*dev)
>> +static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device =
*dev,
>> +				struct bpf_nh_params *nh)
>>   {
>>   	struct ethhdr *ethh =3D eth_hdr(skb);
>>=20=20=20
>> @@ -2370,9 +2399,9 @@ static int __bpf_redirect_neigh(struct sk_buff *sk=
b, struct net_device *dev)
>>   	skb_reset_network_header(skb);
>>=20=20=20
>>   	if (skb->protocol =3D=3D htons(ETH_P_IP))
>> -		return __bpf_redirect_neigh_v4(skb, dev);
>> +		return __bpf_redirect_neigh_v4(skb, dev, nh);
>>   	else if (skb->protocol =3D=3D htons(ETH_P_IPV6))
>> -		return __bpf_redirect_neigh_v6(skb, dev);
>> +		return __bpf_redirect_neigh_v6(skb, dev, nh);
>>   out:
>>   	kfree_skb(skb);
>>   	return -ENOTSUPP;
>> @@ -2455,8 +2484,8 @@ int skb_do_redirect(struct sk_buff *skb)
>>   		return -EAGAIN;
>>   	}
>>   	return flags & BPF_F_NEIGH ?
>> -	       __bpf_redirect_neigh(skb, dev) :
>> -	       __bpf_redirect(skb, dev, flags);
>> +		__bpf_redirect_neigh(skb, dev, &ri->nh) :
>> +		__bpf_redirect(skb, dev, flags);
>>   out_drop:
>>   	kfree_skb(skb);
>>   	return -EINVAL;
>> @@ -2504,16 +2533,23 @@ static const struct bpf_func_proto bpf_redirect_=
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
>>   		return TC_ACT_SHOT;
>>=20=20=20
>>   	ri->flags =3D BPF_F_NEIGH;
>>   	ri->tgt_index =3D ifindex;
>>=20=20=20
>> +	BUILD_BUG_ON(sizeof(struct bpf_redir_neigh) !=3D sizeof(struct bpf_nh_=
params));
>> +	if (plen)
>> +		memcpy(&ri->nh, params, sizeof(ri->nh));
>> +	else
>> +		ri->nh.nh_family =3D 0; /* clear previous value */
>
> I'd probably just add an internal flag and do ...
>
>    ri->flags =3D BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0);
>
> ... instead of above clearing, and skb_do_redirect() then becomes:
>
>    __bpf_redirect_neigh(skb, dev, flags & BPF_F_NEXTHOP ? &ri->nh : NULL)
>
> ... which would then also avoid this !nh->nh_family check where you later=
 on
> set nh =3D NULL to pass it onwards.

Ah yes, excellent idea! Will fix :)

-Toke

