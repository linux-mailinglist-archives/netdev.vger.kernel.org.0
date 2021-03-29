Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6CB34D509
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhC2QZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:25:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231646AbhC2QZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617035113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbFIhCPku9MFTnIxaRhUC4X/zn411dNU5tYynxv/ZoU=;
        b=OKEbGMmBikCLaew/FcuGEdteEgxlMKvgTSHDil00nSByn+iENGeWGVMc7Oe753L5kXj/tT
        jC/NzwEusPA6WHWJ6jWZsxZ7AmtdeDl5/d0orgSEcCiK0OddYkLDW03hCC+E6BmsW4JxqM
        F9TKlYwhAFaTd+DWxqIjoIG4r7FWWh0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-S1ksDskhN9GR9fp4Eh5MCg-1; Mon, 29 Mar 2021 12:25:11 -0400
X-MC-Unique: S1ksDskhN9GR9fp4Eh5MCg-1
Received: by mail-ej1-f72.google.com with SMTP id bg7so6066668ejb.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mbFIhCPku9MFTnIxaRhUC4X/zn411dNU5tYynxv/ZoU=;
        b=Anadvr2oJH5d1yJxC/2ZIZhUjK98ravsJfqDixjUiUEY4K9nim0ilz/9b1L3FOrFjS
         r/6ycQ/tcD1/rLfAZW3sAzADblHr0Ydi1Tx+AbrEJ03aKIhRirsIQNgUSZBQqdhpcQJK
         zEHPqWDxOyZCIbuKvVZZJ4/3ocCKJKMibCoTamPnvRqX9vHwpg22d629MqGwrTjVaqwU
         J+mji/uR94NIxuKnsiPBmTkj9Um6+uZl7i33qm/iXZXOPB2966/flR1B6oLi/3xFRDIq
         +h1i3PyqtvzDwicZq25ToMeeIwVxppDMaD9Ud+yW4wsRveEjwpegO/KmXLcES6pErTFD
         Ktgg==
X-Gm-Message-State: AOAM533ZrtjNpx6xS7kjBrVVdri+/PUo9+wd5ccewNNu9XCFHPHq6ORO
        Zs/yil9tU9gKa7M0tmPB8L72PG1GX5vfrCmt5e9iA9SgcsIL78CJsJRko/dwYRX4rk2QJFIEE3B
        E+H5BcCR+ntNfgkhG
X-Received: by 2002:a50:ec96:: with SMTP id e22mr29345934edr.385.1617035110008;
        Mon, 29 Mar 2021 09:25:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywYRxi7n5QniEJaNO6UMg08JtWmwcuPYfyG7Lv1dtxhDjfWqUvGzbcye9KyF5FRMcPYikhkQ==
X-Received: by 2002:a50:ec96:: with SMTP id e22mr29345921edr.385.1617035109876;
        Mon, 29 Mar 2021 09:25:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cw14sm9522115edb.8.2021.03.29.09.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 09:25:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AC9F6181B24; Mon, 29 Mar 2021 18:25:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/1] xdp: fix xdp_return_frame() kernel BUG throw
 for page_pool memory model
In-Reply-To: <20210329170209.6db77c3d@carbon>
References: <20210329080039.32753-1-boon.leong.ong@intel.com>
 <20210329170209.6db77c3d@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 18:25:08 +0200
Message-ID: <87lfa6rkpn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 29 Mar 2021 16:00:39 +0800
> Ong Boon Leong <boon.leong.ong@intel.com> wrote:
>
>> xdp_return_frame() may be called outside of NAPI context to return
>> xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
>> napi_direct = false. For page_pool memory model, __xdp_return() calls
>> xdp_return_frame_no_direct() unconditionally and below false negative
>> kernel BUG throw happened under preempt-rt build:
>> 
>> [  430.450355] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/3884
>> [  430.451678] caller is __xdp_return+0x1ff/0x2e0
>> [  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E     5.12.0-rc2+ #45
>> 
>> So, this patch fixes the issue by adding "if (napi_direct)" condition
>> to skip calling xdp_return_frame_no_direct() if napi_direct = false.
>> 
>> Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_return_frame")
>> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
>> ---
>
> This looks correct to me.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
>
>>  net/core/xdp.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 05354976c1fc..4eaa28972af2 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>>  		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
>>  		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>>  		page = virt_to_head_page(data);
>> -		napi_direct &= !xdp_return_frame_no_direct();
>> +		if (napi_direct)
>> +			napi_direct &= !xdp_return_frame_no_direct();
>
> if (napi_direct && xdp_return_frame_no_direct())
> 	napi_direct = false;
>
> I wonder if this code would be easier to understand?

Yes, IMO it would! :)

-Toke

