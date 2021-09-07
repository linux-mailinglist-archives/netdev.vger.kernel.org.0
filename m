Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65DD402AED
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhIGOka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232105AbhIGOk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 10:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631025562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWg0sqChxjVCKWuzF+VAVos/r0t2VNxT/zhEmY7OWok=;
        b=SGzuN0SAoqGQgWeNEF7vhEY/JQXboy739lHXU1/gc2Bt1NKOaARmbVc/xeyZ0JItRmL/oK
        +PA8O9VS3oMuNQoMtfAP0Q7HiwZxkEp+A61W5Idv7XnkMTCpCjSERihADILPpkoIbjs6FY
        3Aism/EWUmnXG2vyxCCMtBliuyo13pc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-N32pzCTQMRKwlolqZpOmLg-1; Tue, 07 Sep 2021 10:39:21 -0400
X-MC-Unique: N32pzCTQMRKwlolqZpOmLg-1
Received: by mail-wr1-f71.google.com with SMTP id v6-20020adfe4c6000000b001574f9d8336so2177268wrm.15
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 07:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tWg0sqChxjVCKWuzF+VAVos/r0t2VNxT/zhEmY7OWok=;
        b=V7clcFq8lg7GNnNSEsUd+EjGJSwHcOak6VDplMSudx1t1ywLDORiI5EaeLSkO0OElq
         y/k9rSLzirxm50oqeNuRzLDhgelkfRnfMtxYWMkdAxp4aPjUoaHid9+fM/y3W9xeD0sI
         mzj96UwBRzC8mMahoLpCEwSnRno4yqW8186cZLe4scR6Ar0DZtJciNK4ckylkU/gqdj1
         RLglQ8NypV4jXO2A4Mlhxyn83QLFZ2qjstWCuoJS6xi7umNGuNhmefyhk7YsLqAAmzl9
         GkWakXlOxVBImgChPjgGrAmXSS/UC2WbHUnSCNiTdfpfkbHyMlcQkDd6vWAh3Osonzpx
         +i1A==
X-Gm-Message-State: AOAM530A46L887WHM6MkGbm307s/5ux/gT2UMG0EjJKHVLKUnE9dQ236
        i/wnmV3QeWl62y6KngyYkDcn2w3H4v/Xz1kFmw+plAG2QzL1HLnc1T13dY2YZvn87lkLJpg6Nge
        pXjRSxFRfV9nK2tAQ
X-Received: by 2002:a1c:98d5:: with SMTP id a204mr4491132wme.52.1631025560694;
        Tue, 07 Sep 2021 07:39:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcwRg64MAs790alfvMBbhipE3LrcecqWOOt1yvyCs7bsrGU1KOjLIdRDzSWgQj8A7fuMKrdg==
X-Received: by 2002:a1c:98d5:: with SMTP id a204mr4491089wme.52.1631025560389;
        Tue, 07 Sep 2021 07:39:20 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id s12sm11340851wru.41.2021.09.07.07.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 07:39:19 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v13 bpf-next 01/18] net: skbuff: add size metadata to
 skb_shared_info for xdp
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1631007211.git.lorenzo@kernel.org>
 <1721d45800a333a46c2cdde0fd25eb6f02f49ecf.1631007211.git.lorenzo@kernel.org>
Message-ID: <2bfd067e-a5aa-29ad-7b3c-0f8af61422ad@redhat.com>
Date:   Tue, 7 Sep 2021 16:39:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1721d45800a333a46c2cdde0fd25eb6f02f49ecf.1631007211.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/09/2021 14.35, Lorenzo Bianconi wrote:
> Introduce xdp_frags_tsize field in skb_shared_info data structure
> to store xdp_buff/xdp_frame truesize (xdp_frags_tsize will be used
> in xdp multi-buff support). In order to not increase skb_shared_info
> size we will use a hole due to skb_shared_info alignment.
> Introduce xdp_frags_size field in skb_shared_info data structure
> reusing gso_type field in order to store xdp_buff/xdp_frame paged size.
> xdp_frags_size will be used in xdp multi-buff support.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   include/linux/skbuff.h | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6bdb0db3e825..1abeba7ef82e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -522,13 +522,17 @@ struct skb_shared_info {
>   	unsigned short	gso_segs;
>   	struct sk_buff	*frag_list;
>   	struct skb_shared_hwtstamps hwtstamps;
> -	unsigned int	gso_type;
> +	union {
> +		unsigned int	gso_type;
> +		unsigned int	xdp_frags_size;
> +	};
>   	u32		tskey;
>   
>   	/*
>   	 * Warning : all fields before dataref are cleared in __alloc_skb()
>   	 */
>   	atomic_t	dataref;
> +	unsigned int	xdp_frags_tsize;

I wonder if we could call this variable: xdp_frags_truesize.

As while reviewing patches I had to focus my eyes extra hard to tell the 
variables xdp_frags_size and xdp_frags_tsize from each-other.

--Jesper

