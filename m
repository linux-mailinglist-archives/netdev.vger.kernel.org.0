Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6DB5E5F23
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiIVJ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiIVJ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:57:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A748D58AC
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:57:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso461225wmk.2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TX+dZFKc01rzMEgsWJ5WshpFDtmg9ORNYvjpFUtfE7U=;
        b=wrbiuc31HYkBNQTsgI2G+/Oy6SygApb1Gh45M7m6bKMrSjJ2jz03iPH4gGLoc/KH4R
         JeLNtg6Glds/tAa/5pHssmv9X/lwD/04j12/cLOYi6SpG3+qU8HG1XKJcZoZokg9lWSl
         jyaVgjkTw2MGlx97EuyxqeolFlRCkSA3xhhbzT1auFqu9TbuHDVsTE7bjOdgz1kjCATt
         5VXu0CIMpN2Qy5w/1u27Axoo/vwnosicUW5x69YtPRVEv4g+3P/ePsxy6Ib8byTGg7RV
         ItjUHqFN5lbmChFkLX8UqlRPoIiFboAzcIYGJNcB2xyiuKzWfbWAVCxOCwkasH45/oQ5
         kQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TX+dZFKc01rzMEgsWJ5WshpFDtmg9ORNYvjpFUtfE7U=;
        b=ky5Z58bcTuvz2DJe7U08tFQUZJhWcC0gmnvGbTOTlPh7Uiyu98ZTHahTLx+5rmM5bx
         o78ZDGj1ZL8Prwv1LlngRZwEp7VeMZu2axed393gMryQbN8tz8gldt97Gdub+OjGwB7w
         4ZPMx/JA8p3d77rEnXgOzx5OOiMshVoIAe9kaj4lScPg7udiSv5T/79MzA/IHgYo05xm
         xOSM7EysEO9R34n6BX5H5S+6ocDm9/8vQpMh2UYOwXts3KxJqhpf9PV9v9QBdmQeUQHT
         ZZilVj0LCwe3PhPnDlRO3UIaqKmqgaI59JdBvYuvjrngBxw2LnjvqWH6WUttt5hTjHnr
         TWoQ==
X-Gm-Message-State: ACrzQf3GRVrhQ2B7bBeaN/btrmUWN4hG1veCB0db9eH9cQ9Cy+crSO+o
        qA+aWxJj8np8PWmo7jZH1Scanw==
X-Google-Smtp-Source: AMsMyM6i6UfcSL8Kwei3PzQZYMd+09H2UCH5uPAZ58h/kYqOTqoT/Xto/7pTCxlRgy/goVe7ATBGYA==
X-Received: by 2002:a1c:4b03:0:b0:3b4:74d3:b4c5 with SMTP id y3-20020a1c4b03000000b003b474d3b4c5mr1721728wma.96.1663840619776;
        Thu, 22 Sep 2022 02:56:59 -0700 (PDT)
Received: from hades ([46.103.15.185])
        by smtp.gmail.com with ESMTPSA id l30-20020a05600c1d1e00b003a62400724bsm6408472wms.0.2022.09.22.02.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:56:58 -0700 (PDT)
Date:   Thu, 22 Sep 2022 12:56:56 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, mtahhan@redhat.com,
        mcroce@microsoft.com
Subject: Re: [PATCH net-next] xdp: improve page_pool xdp_return performance
Message-ID: <YywxaOL0G9QAMzjA@hades>
References: <166377993287.1737053.10258297257583703949.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166377993287.1737053.10258297257583703949.stgit@firesoul>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

On Wed, Sep 21, 2022 at 07:05:32PM +0200, Jesper Dangaard Brouer wrote:
> During LPC2022 I meetup with my page_pool co-maintainer Ilias. When
> discussing page_pool code we realised/remembered certain optimizations
> had not been fully utilised.
> 
> Since commit c07aea3ef4d4 ("mm: add a signature in struct page") struct
> page have a direct pointer to the page_pool object this page was
> allocated from.
> 
> Thus, with this info it is possible to skip the rhashtable_lookup to
> find the page_pool object in __xdp_return().
> 
> The rcu_read_lock can be removed as it was tied to xdp_mem_allocator.
> The page_pool object is still safe to access as it tracks inflight pages
> and (potentially) schedules final release from a work queue.
> 
> Created a micro benchmark of XDP redirecting from mlx5 into veth with
> XDP_DROP bpf-prog on the peer veth device. This increased performance
> 6.5% from approx 8.45Mpps to 9Mpps corresponding to using 7 nanosec
> (27 cycles at 3.8GHz) less per packet.

Thanks for the detailed testing

> 
> Suggested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/xdp.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 24420209bf0e..844c9d99dc0e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -375,19 +375,17 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>  void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  		  struct xdp_buff *xdp)
>  {
> -	struct xdp_mem_allocator *xa;
>  	struct page *page;
>  
>  	switch (mem->type) {
>  	case MEM_TYPE_PAGE_POOL:
> -		rcu_read_lock();
> -		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
> -		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>  		page = virt_to_head_page(data);
>  		if (napi_direct && xdp_return_frame_no_direct())
>  			napi_direct = false;
> -		page_pool_put_full_page(xa->page_pool, page, napi_direct);
> -		rcu_read_unlock();
> +		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
> +		 * as mem->type knows this a page_pool page
> +		 */
> +		page_pool_put_full_page(page->pp, page, napi_direct);
>  		break;
>  	case MEM_TYPE_PAGE_SHARED:
>  		page_frag_free(data);
> 
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
