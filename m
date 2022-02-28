Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD934C63C9
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiB1H3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiB1H33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:29:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D43DD20F6C
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646033330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJAAwICrukBSLCM4rklcyDHw6GKglRYZwBEkvhGyaDg=;
        b=hcn9Tf675IYzU4sdxKLbiTJKZDYH/wdWAz+FE2edSb9ssLlXrRQYamy3qUdXX0Now0Gi7Y
        NZWt38Ur6Ccj8EUq0lvYJTHdL3RxDDPuStXwrIZJzVf48fsUXMSTrO1t1XOSCe7T2eBnee
        E3UurD107hk8WKRDMliVBoFx0K2OP6E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-r19gDRypOcSk24y6pXyBew-1; Mon, 28 Feb 2022 02:28:46 -0500
X-MC-Unique: r19gDRypOcSk24y6pXyBew-1
Received: by mail-ed1-f71.google.com with SMTP id m12-20020a056402510c00b00413298c3c42so5322973edd.15
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:28:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=QJAAwICrukBSLCM4rklcyDHw6GKglRYZwBEkvhGyaDg=;
        b=TW3lik0kVdbHJ2Tga/qi8V5XzCOJi4Skpp7GyzeaiOBTRIsV6WjFgWEaLuvSsinTdm
         h916fQrBhx8XIvj4lBpREFVEGeqX9AmANO7wlCq79fPsx0Yy5C0RbQqCsA5om4HBUOt9
         xJq1bSV7Dd1JTfLqUe887uhwktVadVg9RJyUWOHc4QyJPXd6IzIAHf5YfVQFsR/YLamD
         7AfVlz/lVJiEzv93kt/BAUbFnSDG6W9UGBNjy4KvBGX1bLPoc6LA4iBZfh7WNT0pJgga
         hccqMhmum6kBJsj7UW4sFilKPMg9PCsNMf3QzycuTEptaHKbH6xxxJBkcuOtv+n9bxD1
         HLsg==
X-Gm-Message-State: AOAM533ivQYn1374SJq0M8oK9WD2LI/3pkwhrvduk1zp471g3FIVtuZr
        vRK/RsG3wDYKA/nfEzQKFvLGc8XUjSNkXnTmbmDp4PxlZ0Gupo8082xyL3eLJtbFLVP6rM6Giid
        0Mvj5lP0Jbbd6ACsQ
X-Received: by 2002:a05:6402:26c1:b0:412:8942:64a3 with SMTP id x1-20020a05640226c100b00412894264a3mr18333069edd.1.1646033325686;
        Sun, 27 Feb 2022 23:28:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6sZ4tHgAkv4j9WUkA1OHNq6ytifqxnu8rLMDZJyffBFkq82p4XobGhtiVUiTS4hYNFvFknA==
X-Received: by 2002:a05:6402:26c1:b0:412:8942:64a3 with SMTP id x1-20020a05640226c100b00412894264a3mr18333058edd.1.1646033325476;
        Sun, 27 Feb 2022 23:28:45 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906940700b006b86e95dc1fsm4091722ejx.41.2022.02.27.23.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 23:28:44 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
Date:   Mon, 28 Feb 2022 08:28:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com>
In-Reply-To: <1645810914-35485-5-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/02/2022 18.41, Joe Damato wrote:
> +#ifdef CONFIG_PAGE_POOL_STATS
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow_high_order) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empty) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refill) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waive) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cached) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cache_full) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring_full) },
> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_released_ref) },
> +#endif

The naming: "page_pool_rec_xxx".
What does the "rec" stand for?

Users of ethtool -S stats... will they know "rec" is "recycle" ?

p.s. we need acks from driver maintainer(s).

--Jesper

