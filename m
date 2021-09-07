Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A014029E4
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344787AbhIGNlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:41:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344752AbhIGNlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 09:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631022026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEyxhXA1nsSl2HrxYLUrYbEDotEGx7xbkdxp8TfXNp4=;
        b=are75rjXMhIRC8Y5htZW2/+90RCOl76RRc8Dw8YNQ1Pv8JAAZa9DLNXIi6eAwegjhbFGB1
        qdcjfuUmyq2ERD2/gqle6yQOLlOESExsKMjfkA/zJh/N3sf2q2cYNYFg3Q88Dky85YqC21
        sL0EUuUq3z5zeG43oYVDL05GSOfQ1MM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-babRN1ZVM0GtagubcCIO1g-1; Tue, 07 Sep 2021 09:40:25 -0400
X-MC-Unique: babRN1ZVM0GtagubcCIO1g-1
Received: by mail-wr1-f69.google.com with SMTP id z16-20020adfdf90000000b00159083b5966so2111674wrl.23
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 06:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEyxhXA1nsSl2HrxYLUrYbEDotEGx7xbkdxp8TfXNp4=;
        b=qo6uHZYjl+O5iMaaercT5/kI+rdQ0XQDeQ+uek5YNsrhXzeZ0IwrJXPlD1SUNZfVcD
         RHD/uwGPNG7sjKGp1uStRB2MS7HAXPDFSOKA0nkRA3UHFkXkswNe6Yp3Rnbu8PaZVszE
         oPzdq8zQ7TtcW6XKeFYl02w25RAEwmP+jlQFrrRKTVRSbQ/2tW1403c7qlkUeox1sYog
         EbrrA98kJVbtxtZKEO1FYsekgIQUTQlPsuzgn9QaDbtsOXuAZW6gK6rgd36l9PSyhIe4
         H61nzzMgC03sSkYsEe1/S7eGbSIYYloE1MawpNQ0IgUBqOF3zNw97McwS9EHyCz/+IbQ
         TG3A==
X-Gm-Message-State: AOAM532VQGhOtD3C1n/ne7SYryJp7m+YTouCCwdalKBczEtq0EI7S5Kt
        HGQ7K7pkQPeZNyUHYj2XCWXC3W92MseVS65hi+xZBx7sNSFJ7VPIdgVcCuz67s2PbSZWHpiqyJM
        4r2JitB0oo4m0XuXo
X-Received: by 2002:adf:9d47:: with SMTP id o7mr19321788wre.50.1631022023951;
        Tue, 07 Sep 2021 06:40:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypAJsoHicvmpgSyeJ8s5Au9SMTzDbIHPNihwTKs68MFHt48z6xj4j3BJhBVirF1LdYtzA9rg==
X-Received: by 2002:adf:9d47:: with SMTP id o7mr19321755wre.50.1631022023734;
        Tue, 07 Sep 2021 06:40:23 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id s13sm2382832wmc.47.2021.09.07.06.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 06:40:23 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v13 bpf-next 05/18] net: xdp: add
 xdp_update_skb_shared_info utility routine
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1631007211.git.lorenzo@kernel.org>
 <f46a84381037e76ff0e812abd77a0670d0d14767.1631007211.git.lorenzo@kernel.org>
Message-ID: <29fc47da-f9b3-9698-d58d-a06010945a21@redhat.com>
Date:   Tue, 7 Sep 2021 15:40:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f46a84381037e76ff0e812abd77a0670d0d14767.1631007211.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/09/2021 14.35, Lorenzo Bianconi wrote:
> Introduce xdp_update_skb_shared_info routine to update frags array
> metadata in skb_shared_info data structure converting to a skb from
> a xdp_buff or xdp_frame.
> According to the current skb_shared_info architecture in
> xdp_frame/xdp_buff and to the xdp multi-buff support, there is
> no need to run skb_add_rx_frag() and reset frags array converting the buffer
> to a skb since the frag array will be in the same position for xdp_buff/xdp_frame
> and for the skb, we just need to update memory metadata.
> Introduce XDP_FLAGS_PF_MEMALLOC flag in xdp_buff_flags in order to mark
> the xdp_buff or xdp_frame as under memory-pressure if pages of the frags array
> are under memory pressure. Doing so we can avoid looping over all fragments in
> xdp_update_skb_shared_info routine. The driver is expected to set the
> flag constructing the xdp_buffer using xdp_buff_set_frag_pfmemalloc
> utility routine.
> Rely on xdp_update_skb_shared_info in __xdp_build_skb_from_frame routine
> converting the multi-buff xdp_frame to a skb after performing a XDP_REDIRECT.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   include/net/xdp.h | 33 ++++++++++++++++++++++++++++++++-
>   net/core/xdp.c    | 17 +++++++++++++++++
>   2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index ed5ea784fd45..53cccdc9528c 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -67,7 +67,10 @@ struct xdp_txq_info {
>   };
>   
>   enum xdp_buff_flags {
> -	XDP_FLAGS_MULTI_BUFF	= BIT(0), /* non-linear xdp buff */
> +	XDP_FLAGS_MULTI_BUFF		= BIT(0), /* non-linear xdp buff */
> +	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(1), /* xdp multi-buff paged memory
> +						   * is under pressure
> +						   */
>   };
>   
>   struct xdp_buff {
> @@ -96,6 +99,16 @@ static __always_inline void xdp_buff_clear_mb(struct xdp_buff *xdp)
>   	xdp->flags &= ~XDP_FLAGS_MULTI_BUFF;
>   }
>   
> +static __always_inline bool xdp_buff_is_frag_pfmemalloc(struct xdp_buff *xdp)
> +{
> +	return !!(xdp->flags & XDP_FLAGS_FRAGS_PF_MEMALLOC);
> +}
> +
> +static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
> +{
> +	xdp->flags |= XDP_FLAGS_FRAGS_PF_MEMALLOC;
> +}
> +
>   static __always_inline void
>   xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>   {
> @@ -151,6 +164,11 @@ static __always_inline bool xdp_frame_is_mb(struct xdp_frame *frame)
>   	return !!(frame->flags & XDP_FLAGS_MULTI_BUFF);
>   }
>   
> +static __always_inline bool xdp_frame_is_frag_pfmemalloc(struct xdp_frame *frame)
> +{
> +	return !!(frame->flags & XDP_FLAGS_FRAGS_PF_MEMALLOC);
> +}
> +
>   #define XDP_BULK_QUEUE_SIZE	16
>   struct xdp_frame_bulk {
>   	int count;
> @@ -186,6 +204,19 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
>   	frame->dev_rx = NULL;
>   }
>   
> +static inline void
> +xdp_update_skb_shared_info(struct sk_buff *skb, u8 nr_frags,
> +			   unsigned int size, unsigned int truesize,
> +			   bool pfmemalloc)
> +{
> +	skb_shinfo(skb)->nr_frags = nr_frags;
> +
> +	skb->len += size;
> +	skb->data_len += size;
> +	skb->truesize += truesize;
> +	skb->pfmemalloc |= pfmemalloc;

Do we need to clear gso_type here as it is shared/union with 
xdp_frags_size ?
(see below ... it is already cleared before call)


> +}
> +
>   /* Avoids inlining WARN macro in fast-path */
>   void xdp_warn(const char *msg, const char *func, const int line);
>   #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index cc92ccb38432..504be3ce3ca9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -531,8 +531,20 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>   					   struct sk_buff *skb,
>   					   struct net_device *dev)
>   {
> +	unsigned int frag_size, frag_tsize;
>   	unsigned int headroom, frame_size;
>   	void *hard_start;
> +	u8 nr_frags;
> +
> +	/* xdp multi-buff frame */
> +	if (unlikely(xdp_frame_is_mb(xdpf))) {
> +		struct skb_shared_info *sinfo;
> +
> +		sinfo = xdp_get_shared_info_from_frame(xdpf);
> +		frag_tsize = sinfo->xdp_frags_tsize;
> +		frag_size = sinfo->xdp_frags_size;
> +		nr_frags = sinfo->nr_frags;
> +	}
>   
>   	/* Part of headroom was reserved to xdpf */
>   	headroom = sizeof(*xdpf) + xdpf->headroom;
> @@ -552,6 +564,11 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>   	if (xdpf->metasize)
>   		skb_metadata_set(skb, xdpf->metasize);
>   
> +	if (unlikely(xdp_frame_is_mb(xdpf)))
> +		xdp_update_skb_shared_info(skb, nr_frags,
> +					   frag_size, frag_tsize,
> +					   xdp_frame_is_frag_pfmemalloc(xdpf));
> +

There is a build_skb_around() call before this call, which via 
__build_skb_around() will clear top part of skb_shared_info.
(Thus, clearing gso_type not needed ... see above)

>   	/* Essential SKB info: protocol and skb->dev */
>   	skb->protocol = eth_type_trans(skb, dev);
>   


Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

