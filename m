Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7341636B3AE
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhDZNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhDZNBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619442032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GEpTRPy40MEBUFi+Yc9OsnLT4rHJGc3ZMP0bWoETgcw=;
        b=YXrJz8OwA0AdoY9e+hLoyZqWS02RTjpgkuVBAYqMiBPPLvCb4JDC8DhtH6tqjvBbZEtc1+
        FqadQAUTy8q9aPhMHS0L38AHxdQs5tULQ2pXb1htRt/g9Eg9hcpIK3r8i9oyjrV5+xtCy1
        7nMFds3D3knyAr5J5LS6Ddl76Q3oE2M=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-FKgnWHL2OsSWHwccYslgDw-1; Mon, 26 Apr 2021 09:00:30 -0400
X-MC-Unique: FKgnWHL2OsSWHwccYslgDw-1
Received: by mail-ej1-f72.google.com with SMTP id g7-20020a1709065d07b029037c872d9cdcso10171434ejt.11
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GEpTRPy40MEBUFi+Yc9OsnLT4rHJGc3ZMP0bWoETgcw=;
        b=stEDosExOznb01heyMdjbCNM/bByLdHUI3hHsELdhEXK1VUCaZhlQc+ER9m/MHRWU3
         y685rKW3+tcBC1Uz5ifsy1e69ABrSWTi3ypyx5EKU4d/5LznW6N/HD90rI44ZF+rgpj/
         /bcYTuvT+qU0xJI5Z7F8uXhsC+RWYQ06LX94pF26sjYIjUYI0p0gofvwTlcUC57sfPhW
         T45nxQrSSO8ZhyGiv0IBPAPZCMJftpRGaD89EzEIzaSQRidLDQHsEM0IA9eA18jg3A+t
         MvborEu3WoTdqm5Mc/usSUILsDUOfGYx3mYArzG/VHDZk9/bhBRaEi8qvv/JWS4iydgB
         D8rQ==
X-Gm-Message-State: AOAM532P2CeLtnfRUGBbj5U1FP5uP1aeLvt2iIIsI+/EhsJdIN8QzUQm
        PFmkX49DwhvvNf3QvBiRR8ZnQ3eTWfumbf50kqMLL+bzjdrpc/LK3H8FiGIWFocoGze3xvfu55j
        k4ftikjHhNI7NNo/K
X-Received: by 2002:a17:906:705:: with SMTP id y5mr5385201ejb.261.1619442029110;
        Mon, 26 Apr 2021 06:00:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW5GJog/3Xe6Vg8Ay+d+x8d9ImPS5ZLoGu+i/a9SCGKNx6PtLiRE2Wddn0nTzXKDs+QO8CMQ==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr5385168ejb.261.1619442028894;
        Mon, 26 Apr 2021 06:00:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t1sm11525390eju.88.2021.04.26.06.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 06:00:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C6614180615; Mon, 26 Apr 2021 15:00:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
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
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210426114742.GU3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon> <20210426114014.GT3465@Leo-laptop-t470s>
 <20210426114742.GU3465@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Apr 2021 15:00:27 +0200
Message-ID: <87eeexciac.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Mon, Apr 26, 2021 at 07:40:28PM +0800, Hangbin Liu wrote:
>> On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:
>> > Decode: perf_trace_xdp_redirect_template+0xba
>> >  ./scripts/faddr2line vmlinux perf_trace_xdp_redirect_template+0xba
>> > perf_trace_xdp_redirect_template+0xba/0x130:
>> > perf_trace_xdp_redirect_template at include/trace/events/xdp.h:89 (discriminator 13)
>> > 
>> > less -N net/core/filter.c
>> >  [...]
>> >    3993         if (unlikely(err))
>> >    3994                 goto err;
>> >    3995 
>> > -> 3996         _trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
>> 
>> Oh, the fwd in xdp xdp_redirect_map broadcast is NULL...
>> 
>> I will see how to fix it. Maybe assign the ingress interface to fwd?
>
> Er, sorry for the flood message. I just checked the trace point code, fwd
> in xdp trace event means to_ifindex. So we can't assign the ingress interface
> to fwd.
>
> In xdp_redirect_map broadcast case, there is no specific to_ifindex.
> So how about just ignore it... e.g.

Yeah, just leaving the ifindex as 0 when tgt is unset is fine :)

-Toke

