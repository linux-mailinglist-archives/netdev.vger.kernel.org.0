Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251A35F242D
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJBQ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 12:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJBQ6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 12:58:54 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FC626137;
        Sun,  2 Oct 2022 09:58:50 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c19so5499364qkm.7;
        Sun, 02 Oct 2022 09:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date;
        bh=OGJqFKqSFYwqZrqGf/iw+R3VrigrtXStRQYPWw9K/7Q=;
        b=CL6Eo1hstuVhiG5tXy5kTd0p4vAVOvcrGnCTZVLIi5J1izmL1qzNyjIgWVjcOOE82o
         9CZJUCCyZjM6o9eT1Uoc4OfZcTfBW+SPuVZGW0vBmlsug+VlpvCWPa0OD4GuCEuAT8Ev
         7oDsWKoXtI9jUP5/WVQXahesQiRJUCcxDQPorRQ17QQz/RYdEZ8uETkQlqLQZPdLC6uz
         sNyBxsbDji8i3oT2G7KiUK1jAZMpJ/D1JWkU+siBemNnt928KLN0Rx7I77iUOj2JVCjf
         EeMSWoC1dr3c7oxKtbYIYE170Hs0a0S9eWt3Ha5NBqQc4Zxck/h2PRhTCtXXZcuJ+OoY
         z0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OGJqFKqSFYwqZrqGf/iw+R3VrigrtXStRQYPWw9K/7Q=;
        b=jcJw9ELl+S601IUtEV7z9p/1M4JBbrwnBlM7V5oQSJy/Ba5xHBDPdR883HKWISd8wP
         aC9C+nqJc1UpeX6iQ8Za4GOYWFw94F/zXQMKcqy1dLf5KtUZ7Cv3dlea1B6X7jZUhJj9
         4Q9yCCTuQaf3OwjbK+FMs9gCP7sY7sZ4q9i6Q5kHYb7scPd1O1Mpp4PAZsRcrm/FxyWO
         mxpYixzdiblBkREDBu0VkWxD+oMEkoXYv61h3XoI2kfXTbn/1r4qUE160KJ0enAvHc9l
         HRsnxSAD3Zok7VdP44/OcLT6DE+m94gRksug8zNxMW/+zW3XvDKv41YmFSFlza/EvkAA
         80RQ==
X-Gm-Message-State: ACrzQf0C+Smkui5gMtiqy30bRkq8U3oVOqQyY6OhhCC3+F5H91NEqZ1j
        l4MuqrOqdnZALgPsAQOe2ZyfIoLbToo=
X-Google-Smtp-Source: AMsMyM6t8YYQL9rLTnTuQqcFWOsSWJivgkGNUtgNAcVuh+LsF9LfoffHOZcv6ESH/dqamdLxxOcjyg==
X-Received: by 2002:a05:620a:19a0:b0:6ce:d53b:809d with SMTP id bm32-20020a05620a19a000b006ced53b809dmr12183380qkb.482.1664729929683;
        Sun, 02 Oct 2022 09:58:49 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id s6-20020a05620a254600b0069fe1dfbeffsm8971148qko.92.2022.10.02.09.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 09:58:49 -0700 (PDT)
Date:   Sun, 2 Oct 2022 09:58:48 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: initialize online_mask unconditionally in
 __netif_set_xps_queue()
Message-ID: <YznDSKbiDI99Om23@yury-laptop>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
 <20221002151702.3932770-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221002151702.3932770-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 08:17:01AM -0700, Yury Norov wrote:
> If the mask is initialized unconditionally, it's possible to use bitmap
> API to traverse it, which is done in the following patch.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  net/core/dev.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 39a4cc7b3a06..266378ad1cf1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2542,7 +2542,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  			  u16 index, enum xps_map_type type)
>  {
>  	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL, *old_dev_maps = NULL;
> -	const unsigned long *online_mask = NULL;
> +	const unsigned long *online_mask;
>  	bool active = false, copy = false;
>  	int i, j, tci, numa_node_id = -2;
>  	int maps_sz, num_tc = 1, tc = 0;
> @@ -2565,9 +2565,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  
>  	if (type == XPS_RXQS) {
>  		nr_ids = dev->num_rx_queues;
> +		online_mask = bitmap_alloc(nr_ids, GFP_KERNEL);
> +		if (!online_mask)
> +			return -ENOMEM;

Oh god, I missed a line here while preparing the patch. It should be:

 +		online_mask = bitmap_alloc(nr_ids, GFP_KERNEL);
 +		if (!online_mask)
 +			return -ENOMEM;
 +              bitmap_fill(online_mask, nr_ids);

I'll send v2 after collecting the comments.

>  	} else {
> -		if (num_possible_cpus() > 1)
> -			online_mask = cpumask_bits(cpu_online_mask);
> +		online_mask = cpumask_bits(cpu_online_mask);
>  		nr_ids = nr_cpu_ids;
>  	}
>  
> @@ -2593,10 +2595,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  	     j < nr_ids;) {
>  		if (!new_dev_maps) {
>  			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
> -			if (!new_dev_maps) {
> -				mutex_unlock(&xps_map_mutex);
> -				return -ENOMEM;
> -			}
> +			if (!new_dev_maps)
> +				goto err_out;
>  
>  			new_dev_maps->nr_ids = nr_ids;
>  			new_dev_maps->num_tc = num_tc;
> @@ -2718,7 +2718,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  
>  out_no_maps:
>  	mutex_unlock(&xps_map_mutex);
> -
> +	if (type == XPS_RXQS)
> +		bitmap_free(online_mask);
>  	return 0;
>  error:
>  	/* remove any maps that we added */
> @@ -2733,8 +2734,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  		}
>  	}
>  
> +err_out:
>  	mutex_unlock(&xps_map_mutex);
> -
> +	if (type == XPS_RXQS)
> +		bitmap_free(online_mask);
>  	kfree(new_dev_maps);
>  	return -ENOMEM;
>  }
> -- 
> 2.34.1
