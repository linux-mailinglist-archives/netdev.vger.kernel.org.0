Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F01E4F42A8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386735AbiDEOZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380573AbiDEOQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68668AFB2A
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 06:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azvmiUh+/dFI8v+3SQr0ihCgP4dAaSj/8MnAViPhi+0=;
        b=Z1gBXUrkx9BzdDsZfht8pK9INw6SKDxnfR6oQyki/q3vQTNP1ntl1QzZ/HLWq33s1ED8AJ
        UCkdzHel0iUmVIoDQD7q5Ps+4R8QLqQIbCD1xHaQHPxhBnjHGZjSejnNQKjVVWhgkjc8Ql
        MJ43neq0BLSMhY5kRNdxRGsqzZwtccs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-TdE6TToEPAO9GRTCoTVajQ-1; Tue, 05 Apr 2022 09:00:28 -0400
X-MC-Unique: TdE6TToEPAO9GRTCoTVajQ-1
Received: by mail-ed1-f69.google.com with SMTP id v5-20020aa7d645000000b0041ce08ab5afso1341893edr.6
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 06:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=azvmiUh+/dFI8v+3SQr0ihCgP4dAaSj/8MnAViPhi+0=;
        b=AHwq/AI3HgwKCjM1K1eiew/qofwX87FZiNaD49UbgyQv3cC3IW3kRsdwD3ly5g8N+m
         GPeLO7CcnzUvgHHssU1hqOLqZddobHz7t2lOiEVGD2NK94WQ6ukEtX1d/8j+0040O/os
         6W/ibcbivHD7xMzMvzfOkxsB9TNh92hChs0LIynIDPZE38V7zYRxBmEmF4v4ACCtN9uX
         0mDIEBCu86uiIF05iktsPDuIEyvm1M8K7cZX/Vv1VqKmHUOT1Q5IpxfvKskJqk0IG+82
         /wD4qdDKgi2v1EcwaAW/tpgSkSj0pPc8GZEzAge7N0MJyEWBP3mG+gF7/CSVM2ev9Vh3
         ctdg==
X-Gm-Message-State: AOAM530kQiP0xKIeAKHkarTq6WsFcYGp474aavi3Y5OJzpkD5Uql19uf
        x5tYdXDjr5DLyE5P956UYK9CMDuMmrbKJdviTSZG87oGYmnsC6QpP2SHpE8/p1X6W2vOoIhk5Me
        cpn/0hjpMSckvumTR
X-Received: by 2002:a05:6402:51c6:b0:419:8269:f33d with SMTP id r6-20020a05640251c600b004198269f33dmr3433836edd.264.1649163626821;
        Tue, 05 Apr 2022 06:00:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4dz3DTx2/UEbFiJXnLOy01NscM9Mvf8IaOKzmIFuOKHuprPdRu+9YHI0N77kS5wEuOM9Jfw==
X-Received: by 2002:a05:6402:51c6:b0:419:8269:f33d with SMTP id r6-20020a05640251c600b004198269f33dmr3433807edd.264.1649163626569;
        Tue, 05 Apr 2022 06:00:26 -0700 (PDT)
Received: from [192.168.2.20] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c7c3000000b00410d407da2esm6329516eds.13.2022.04.05.06.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:00:26 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fdc503fa-9ecb-113f-4dd6-774765c3b2ba@redhat.com>
Date:   Tue, 5 Apr 2022 15:00:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, maximmi@nvidia.com,
        alexandr.lobakin@intel.com
Subject: Re: [PATCH bpf-next 02/10] xsk: diversify return codes in
 xsk_rcv_check()
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220405110631.404427-3-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2022 13.06, Maciej Fijalkowski wrote:
> Inspired by patch that made xdp_do_redirect() return values for XSKMAP
> more meaningful, return -ENXIO instead of -EINVAL for socket being
> unbound in xsk_rcv_check() as this is the usual value that is returned
> for such event. In turn, it is now possible to easily distinguish what
> went wrong, which is a bit harder when for both cases checked, -EINVAL
> was returned.

I like this as it makes it easier to troubleshoot.
Could you update the description to explain how to debug this easily.
E.g. via this bpftrace one liner:


  bpftrace -e 'tracepoint:xdp:xdp_redirect* {@err[-args->err] = count();}'


> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

>   net/xdp/xsk.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f75e121073e7..040c73345b7c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -217,7 +217,7 @@ static bool xsk_is_bound(struct xdp_sock *xs)
>   static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
>   {
>   	if (!xsk_is_bound(xs))
> -		return -EINVAL;
> +		return -ENXIO;
>   
>   	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>   		return -EINVAL;
> 

