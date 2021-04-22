Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D56368650
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbhDVSC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236665AbhDVSC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619114543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UiSCDWiCcxogQPyM41lba/4yMV2E3N32U8ri3J8j1cM=;
        b=Q/LtmRtnZRDXhHBlPxK6Mf4Nj6dJS683aO+/ip7uFRcpOvt/O9/Xsux0zuCZ8OZKSuvoq3
        3ZgqKt2YFVMAnNCDZhTpmqtmuEfUuuc03j4oQVJ+B9RPa6VhQ0otoqJgWu4kQ2N9Eaop8v
        B0Nj8JA2M/L1mTtyPh0f17BgOliQiaw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-NxCrNRfQML6gJTfyap70Iw-1; Thu, 22 Apr 2021 14:02:21 -0400
X-MC-Unique: NxCrNRfQML6gJTfyap70Iw-1
Received: by mail-ed1-f70.google.com with SMTP id i18-20020aa7c7120000b02903853032ef71so8267165edq.22
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UiSCDWiCcxogQPyM41lba/4yMV2E3N32U8ri3J8j1cM=;
        b=bFDXDtHpkcjcrxuzyluGxkpjtjLRBsxiehBHX57cjEFQyDVJD9lpZzeqLyecJMcuHm
         v9KuMJhvFTYewkHY5b9zj+lTuOUd53DjAqX0leXy9ppziSMYApiR1/Rz+EbYTbXw+DMe
         u4NClnlTQn7no0p/fLk5Yd4kieN87qmnphwaW8eDVhfLPIZIsD6aaNn26gXLbjz679Lx
         kWROft+xuv6ABXmT30XioubkDflMds35mndfXHPcOrM009HFO06SttWRZ1gny1Npv1k3
         TTh0dp2fc1xRe6Amuhv3Jyptnj6KFK2BhnoWl8TvGYuIt3z7Tx9hGD4MGfkTYcGncsJA
         FxDg==
X-Gm-Message-State: AOAM531kdXzAxGfVbd2NBSNmW+VZ9lrfRtQiwOAgdZRYRWUo+JvMKYq/
        Pb2LCzvM3dvQwEomyEc8QmcIgn8zgq1g0EseuEP00iQIKhlSxmBlhabbMTqoGZTvpCRUAQjZ1DC
        s2X2wKlzpkqd8/zNR
X-Received: by 2002:a17:906:e4b:: with SMTP id q11mr4754942eji.540.1619114540131;
        Thu, 22 Apr 2021 11:02:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8XKaKia5stbB08EnaxvjcY2SollztTAf5E7LHRtMtWSlkj9DA9wbjv4tm+Ea1zUBL92lcmw==
X-Received: by 2002:a17:906:e4b:: with SMTP id q11mr4754911eji.540.1619114539666;
        Thu, 22 Apr 2021 11:02:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id he35sm2333304ejc.2.2021.04.22.11.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:02:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 538D2180675; Thu, 22 Apr 2021 20:02:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210422185332.3199ca2e@carbon>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-3-liuhangbin@gmail.com>
 <20210422185332.3199ca2e@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Apr 2021 20:02:18 +0200
Message-ID: <87a6pqfb9x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 22 Apr 2021 15:14:52 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index cae56d08a670..afec192c3b21 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
> [...]
>>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>>  		    struct bpf_prog *xdp_prog)
>>  {
>> @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>>  	enum bpf_map_type map_type = ri->map_type;
>>  	void *fwd = ri->tgt_value;
>>  	u32 map_id = ri->map_id;
>> +	struct bpf_map *map;
>>  	int err;
>>  
>>  	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
>> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>>  	case BPF_MAP_TYPE_DEVMAP:
>>  		fallthrough;
>>  	case BPF_MAP_TYPE_DEVMAP_HASH:
>> -		err = dev_map_enqueue(fwd, xdp, dev);
>> +		map = xchg(&ri->map, NULL);
>
> Hmm, this looks dangerous for performance to have on this fast-path.
> The xchg call can be expensive, AFAIK this is an atomic operation.

Ugh, you're right. That's my bad, I suggested replacing the
READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange is
what it's doing, but I failed to consider the performance implications
of the atomic operation. Sorry about that, Hangbin! I guess this should
be changed to:

+		map = READ_ONCE(ri->map);
+		if (map) {
+			WRITE_ONCE(ri->map, NULL);
+			err = dev_map_enqueue_multi(xdp, dev, map,
+						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+		} else {
+			err = dev_map_enqueue(fwd, xdp, dev);
+		}

(and the same for the generic-XDP path, of course)

-Toke

