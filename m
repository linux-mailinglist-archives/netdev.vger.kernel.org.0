Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A9596EA7
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbiHQMjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiHQMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F44B89834
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660739985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JwKPyzScM59FLZHLxOO0xf1R9fwVOLoeTkdmVolB6/w=;
        b=cpEd3QT70rNULPG1l3YfMu+1mzW7JzAkCncblMiKv2AOCN1ZqkPgdsrS2fkr65kigQaIXR
        u8UX0ViLYfzoXC44WoVAcHBV7fLV7Gdggp+oktP2plT+/MsMfARdIEfnv98r61+Vi5XJzA
        e7kTSXKU9s3ntd0zmCf+ZtoMlfOfWis=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-3frAc4o6N0C7ubHWphhw9Q-1; Wed, 17 Aug 2022 08:39:43 -0400
X-MC-Unique: 3frAc4o6N0C7ubHWphhw9Q-1
Received: by mail-lj1-f198.google.com with SMTP id z7-20020a2ebe07000000b0025e5c7d6a2eso4181771ljq.20
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc;
        bh=JwKPyzScM59FLZHLxOO0xf1R9fwVOLoeTkdmVolB6/w=;
        b=2Md3At3xv5zsljh6IKEX6Yd6ThXt9T6DNQtsm4nUvoH7jRmUPSBlKfi1mJ5L2eMvze
         RRqQWgdWZ6ndNmBWGC8x0RTiGn9qVvcD1NSBGRsycaJ5CRa3hkeT7Fpm0X9PvN+moU4b
         XfmQa7ekrbiqbL0PahYOwS0ouN5CSWVXMYBtfieQHn4lUqVyZtws7+q9kJHt7zRqMszP
         PkeWHwLGwr/DyzXGkwjrhT2vA0WlbESGEZn5TGB9dj7Sgk0lbfX5r/TOp0nwSdwBWkSU
         yrq5Jnu0MWCOnXP5PrZBDFZdtgIaKa2yqxq/5mQnvEjs0YxaLyuGNRRP4o5ravvXzSye
         8x8A==
X-Gm-Message-State: ACgBeo1ia6/V2TeXAG/r5flU7SqXes4IWve1jsNh1f1am6ghiXC9hae7
        cJPaYSHg8WaqlZ+bb1FqZwHannR1UppYaRcq9bFRGvwxR//s8npbWRU7M4ImexhV9HghQEwThIZ
        BPSeQVL5RlinhBoHs
X-Received: by 2002:ac2:4f03:0:b0:48b:2179:5249 with SMTP id k3-20020ac24f03000000b0048b21795249mr9740395lfr.356.1660739981903;
        Wed, 17 Aug 2022 05:39:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR58xHZn9gJ2qlq86ZhVT+Zb4shOgNxCPnvgwc1PTXkQDRKcSy3JRIL52Sr6r7ctMoqTNstOoQ==
X-Received: by 2002:ac2:4f03:0:b0:48b:2179:5249 with SMTP id k3-20020ac24f03000000b0048b21795249mr9740386lfr.356.1660739981715;
        Wed, 17 Aug 2022 05:39:41 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id a24-20020a19ca18000000b0048a7ce3ff84sm1663398lfg.285.2022.08.17.05.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 05:39:41 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1a22e7e9-e6ef-028f-dffa-e954207dc24d@redhat.com>
Date:   Wed, 17 Aug 2022 14:39:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 bpf-next] xdp: report rx queue index in xdp_frame
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
References: <3923222d836b104232ee70eef34ce2aa454ef9db.1660721856.git.lorenzo@kernel.org>
In-Reply-To: <3923222d836b104232ee70eef34ce2aa454ef9db.1660721856.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/08/2022 09.40, Lorenzo Bianconi wrote:
> Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_info
> pointer. xdp_frame queue_index is currently used in cpumap code to convert
> the xdp_frame into a xdp_buff and allow the ebpf program attached to the
> map entry to differentiate traffic according to the receiving hw queue.
> xdp_frame size is not increased adding queue_index since an alignment
> padding in the structure is used to insert queue_index field.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

(Sorry, I replied to v1 and not this v2.)

I'm still unsure about this change, because the XDP-hints will also
contain the rx_queue number.  And placing it in XDP-hints automatically
makes it avail for AF_XDP consumers.

I do think it is relevant for the BPF-prog to get access to the rx_queue
index, because it can be used for scaling the workload.


> ---
> Changes since v1:
> - rebase on top of bpf-next
> ---
>   include/net/xdp.h   | 2 ++
>   kernel/bpf/cpumap.c | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 04c852c7a77f..3567866b0af5 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -172,6 +172,7 @@ struct xdp_frame {
>   	struct xdp_mem_info mem;
>   	struct net_device *dev_rx; /* used by cpumap */
>   	u32 flags; /* supported values defined in xdp_buff_flags */
> +	u32 queue_index;
>   };
>   
>   static __always_inline bool xdp_frame_has_frags(struct xdp_frame *frame)
> @@ -301,6 +302,7 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
>   
>   	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
>   	xdp_frame->mem = xdp->rxq->mem;
> +	xdp_frame->queue_index = xdp->rxq->queue_index;
>   
>   	return xdp_frame;
>   }
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index b5ba34ddd4b6..48003450c98c 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -228,7 +228,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>   
>   		rxq.dev = xdpf->dev_rx;
>   		rxq.mem = xdpf->mem;
> -		/* TODO: report queue_index to xdp_rxq_info */
> +		rxq.queue_index = xdpf->queue_index;
>   
>   		xdp_convert_frame_to_buff(xdpf, &xdp);
>   

