Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29C2637401
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKXIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXIeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:34:31 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98529CEB9C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:34:30 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso697767wmp.5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zj4NhMK7lgVr35uv6hX/qOHJfhM9Zlz7dniSF3tfYz4=;
        b=Ohlp8kfWYxftoKRV7H+GzTOJEBznaZO5xCcGD7zEnZc5S8MM5Unq7/RiSyZPjaRWGM
         iLsdAgDTFLOocpogosIRlTSSIHa8Awhfg1Z9OuM8BqCaUnO8KeK59bRjffRfHD83fxYN
         9wAqHXONNcmEs/XmxN6ETCg9ZGRPj1t1h8TKl0wwezc/kpZtRkCRqPlBE/7PrFX6rM50
         /Vx8/t/8rgD/W3YyCSsnVspCj4+2YDJJZZjX5gAeFHXeKXGpdAHXg5yox/iQkZ8ABsDR
         sq8UapwRKls0YqqpdsyTbADZhEyceCmOge+UCKYUr71JMJ+053MsJ47bOoGjD521UYoa
         dSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zj4NhMK7lgVr35uv6hX/qOHJfhM9Zlz7dniSF3tfYz4=;
        b=nWynwA2LNjd/6arIBTsZUGIReBjnENCT4iLWlyt2pUDKVP6cOUGYlvjBk2Fu+9J+SQ
         +yQKFZf0TxTS30Ha4rQl2RixAehfmQ1B8qHExqV1FkLZmyd5Uigs5K0Uhonek7pg7YvM
         alHa2nhxrVcgyAzgH+9KI0fBnHAPdgcuIukfoh9rsFrNIb7si5K4yt0vBWO8OOYA4qG3
         hEht4tPnp5w2NNlWmIjNNYpr+kcAltv+uwtPr8ogykdOCh5+nPJOW+5f9RBou2uUl4dr
         bIShazqPWxLHOtmhBNHDDvDWbl3U9UQv4fykeoRgNZPCyhOAw0w2fKzI2KY4PBnljSFc
         Eu0w==
X-Gm-Message-State: ANoB5plYAEFwBShyT6V2wKEHuubTVUdNr3asbPgdxRootF3AFJbPEYWp
        a1xeUmZ2i7Fz0XRcDp93hQfaQGjMZUM=
X-Google-Smtp-Source: AA0mqf5M0Nb7jXr3r4ejhTd0DyGdpoA1zuJEdjbwiYfbojrn+FqAe4/CHLAvcpFFxVzVgwNwPkB+pg==
X-Received: by 2002:a05:600c:3108:b0:3cf:8058:43b8 with SMTP id g8-20020a05600c310800b003cf805843b8mr10487403wmo.95.1669278869081;
        Thu, 24 Nov 2022 00:34:29 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d66c2000000b002362f6fcaf5sm674035wrw.48.2022.11.24.00.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:34:28 -0800 (PST)
Date:   Thu, 24 Nov 2022 08:34:26 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 2/6] sfc: Use kmap_local_page() instead of
 kmap_atomic()
Message-ID: <Y38skj5oq2IYUB2D@gmail.com>
Mail-Followup-To: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
 <20221123205219.31748-3-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123205219.31748-3-anirudh.venkataramanan@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 12:52:15PM -0800, Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
> kmap_atomic() and kunmap_atomic() with kmap_local_page() and kunmap_local()
> respectively.
> 
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
> to check if the code being executed between the map/unmap implicitly
> depends on page-faults and/or preemption being disabled. If yes, then code
> to disable page-faults and/or preemption should also be added for
> functional correctness. That however doesn't appear to be the case here,
> so just kmap_local_page() is used.
> 
> Also note that the page being mapped is not allocated by the driver, and so
> the driver doesn't know if the page is in normal memory. This is the reason
> kmap_local_page() is used as opposed to page_address().
> 
> I don't have hardware, so this change has only been compile tested.
> 
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
> v1 -> v2: Update commit message
> ---
>  drivers/net/ethernet/sfc/tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index c5f88f7..4ed4082 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -207,11 +207,11 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
>  		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
>  		u8 *vaddr;
>  
> -		vaddr = kmap_atomic(skb_frag_page(f));
> +		vaddr = kmap_local_page(skb_frag_page(f));
>  
>  		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + skb_frag_off(f),
>  					   skb_frag_size(f), copy_buf);
> -		kunmap_atomic(vaddr);
> +		kunmap_local(vaddr);
>  	}
>  
>  	EFX_WARN_ON_ONCE_PARANOID(skb_shinfo(skb)->frag_list);
> -- 
> 2.37.2
