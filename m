Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED0D663F85
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbjAJLvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbjAJLut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:50:49 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F50544C4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:50:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so27928438ejb.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BiHzBTbGMSuIpPbe0K2/KjSY8XsgIfVh0SpcqkalzUc=;
        b=wwrU+SElgLL8do+WFRBXJdGes+eH6xhL9flu/mxjsfZc4OjtKLZG87h2T0XLhEWqJ4
         lfL8Xh5NVlU14yB8htdazrbF5IzChQ6Tc4Hmr+K6mWasniBPPDWJ2q8EWg0i6fUnBr9P
         M+DgmAcfp5LWbilhedSWa95rRRPcAFGATtJURRab7GuylemTifA5PJcrtqGg9M8WHqmF
         n7VCem6qjiheA4oxVyxs+WRs5DK5HsZuKkhEVcyWN4vk1bmSGhnjpbw2nZBu7iWqXTfC
         i4u4Do7T/EfrMZIT4WW5gfYgpI47SNXvzOljfek5l2Ls4tRk90fHjS6YRAewSfV5CHvG
         udtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiHzBTbGMSuIpPbe0K2/KjSY8XsgIfVh0SpcqkalzUc=;
        b=nzQI2mlk/twXZK1r82C9gTNOaqVjfSpmEuaa30TWbpRFGWEi5eaiyqnnaKYnfjtr7m
         WJDpXO2zw/uVev9Z/DQzF6jB1sFCr6UCrXYI5XbzhuL2OM9XmfW39L+c9yEkGuDgHOnn
         JpwjtFezNsqHE+gZjDokbnKGXaeGX3euq+piGD03+4muRNT54qPzAYYc5HoYO/jIyx2r
         5TFwDV8D1qFw1uRCAmhiguMP63yS8IQIjFej+kDdkOhb5xQeVitUuQz4oW/Fmcnc5Yb5
         t8mDmJwrsv2jH8JMcHICYqAXCapYUl1DhVIoOXNMrudd6GvQLf1OWWo/AxeSyxlsBb7B
         +f8Q==
X-Gm-Message-State: AFqh2koT71hDq4F2D02s+SMZeRf9MwgQwnqzqxzKx+Fvzu+Oly6sDiuq
        Bhv4vAJxyAbKwSGkTJb6zO2GFDjSWnmGsvpH
X-Google-Smtp-Source: AMrXdXscyhAc9NjtqnFO5nOuFK3X5ZWRKKoCIdOCvkGTIeycC5K5JFadXUz+Sbq01EWOxJktj080Hw==
X-Received: by 2002:a17:907:d045:b0:7c1:5464:3360 with SMTP id vb5-20020a170907d04500b007c154643360mr80125660ejc.65.1673351447462;
        Tue, 10 Jan 2023 03:50:47 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm4870119ejy.187.2023.01.10.03.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 03:50:46 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:50:44 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 19/24] xdp: Convert to netmem
Message-ID: <Y71RFMQAbvZc5auI@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-20-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-20-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:26PM +0000, Matthew Wilcox (Oracle) wrote:
> We dereference the 'pp' member of struct page, so we must use a netmem
> here.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/xdp.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 844c9d99dc0e..7520c3b27356 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -375,17 +375,18 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>  void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  		  struct xdp_buff *xdp)
>  {
> +	struct netmem *nmem;
>  	struct page *page;
>
>  	switch (mem->type) {
>  	case MEM_TYPE_PAGE_POOL:
> -		page = virt_to_head_page(data);
> +		nmem = virt_to_netmem(data);
>  		if (napi_direct && xdp_return_frame_no_direct())
>  			napi_direct = false;
> -		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
> +		/* No need to check ((nmem->pp_magic & ~0x3UL) == PP_SIGNATURE)
>  		 * as mem->type knows this a page_pool page
>  		 */
> -		page_pool_put_full_page(page->pp, page, napi_direct);
> +		page_pool_put_full_netmem(nmem->pp, nmem, napi_direct);
>  		break;
>  	case MEM_TYPE_PAGE_SHARED:
>  		page_frag_free(data);
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

