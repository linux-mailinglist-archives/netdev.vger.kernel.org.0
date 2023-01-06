Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897666603AF
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjAFPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbjAFPuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:50:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F8D728BA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673020156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lph/2wsjDRNRXrE8+YsS+8Yp4KSw6iLMLjz/fi7DRbI=;
        b=fXSOK7SlVyEum1cu+m4auCkIF3odS/dpHDtZzkq9QFfKyHKrXK26DBOQLN+rOLt/cwY6b1
        uDLYWiUIF+FEmTTrGeHIJnOfuAnDcXN9CYUdLbqgES9o37jfb3YzOXlGX4ZofDGP9mJ/Bs
        4nBg5Smq8WwkaR7FfUZjaTsdoTzuX1k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-sllK89gsPsG6vchN6pkqRQ-1; Fri, 06 Jan 2023 10:49:15 -0500
X-MC-Unique: sllK89gsPsG6vchN6pkqRQ-1
Received: by mail-ej1-f70.google.com with SMTP id qa18-20020a170907869200b007df87611618so1378734ejc.1
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:49:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lph/2wsjDRNRXrE8+YsS+8Yp4KSw6iLMLjz/fi7DRbI=;
        b=OlnM2ur27OlusgWczXi7yZgyFWvo9Kd1nR6mwxU81Y1IGUS4MSfpHIDJAM0BiHza5L
         4Qhba36LjypU6dwrkQBka4bMDFYYUudtCVgoLRHPIB42YLldCp4rAKMSG4bgedzhBE21
         seZ2CHPlghnKhYNAMCba5yycT/xLqzrSHKH90UKhYqaucL0SOGgFDf0ufeRKelhNWYvR
         ypqwbHCqqFX7XprN9nr6ldFjpFrwDnYJL00H5KLvgHB3ln3a556kQTPojkYJmDNjvhah
         bUpxc+jSHSph/FCZbO0QntcktaL45Dxzk4wfR+C53wZgEar+0XgxJACqLk1lr6UdoRAd
         J4WQ==
X-Gm-Message-State: AFqh2kqhOePGyZu1sL8JPcQEYKHV3i4H3eHNUeKNEVd85hReZHKFCv/Q
        kcTgSpW/cWIx09V+CZ9fjpKgk98U8UaLWcEpE1mUNRcfm0I4F5mQ8GllsB2PCaJzI761KgWLHAf
        1SEEF+/NYmr/OYBNI
X-Received: by 2002:a17:907:93d5:b0:83c:cca7:64a7 with SMTP id cp21-20020a17090793d500b0083ccca764a7mr43083838ejc.73.1673020154026;
        Fri, 06 Jan 2023 07:49:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtFhILVowoAPgDM9eOXXnIu0iYLSGX2Jdz4LjUL/Xlzhf+9fa98zmq4soh027TXtbOfrhRx3g==
X-Received: by 2002:a17:907:93d5:b0:83c:cca7:64a7 with SMTP id cp21-20020a17090793d500b0083ccca764a7mr43083822ejc.73.1673020153797;
        Fri, 06 Jan 2023 07:49:13 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id a23-20020aa7d757000000b0046f77031d40sm602537eds.10.2023.01.06.07.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:49:13 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
Date:   Fri, 6 Jan 2023 16:49:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 17/24] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-18-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-18-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> This function accesses the pagepool members of struct page directly,
> so it needs to become netmem.  Add page_pool_put_full_netmem() and
> page_pool_recycle_netmem().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/net/page_pool.h | 14 +++++++++++++-
>   net/core/page_pool.c    | 13 ++++++-------
>   2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index fbb653c9f1da..126c04315929 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -464,10 +464,16 @@ static inline void page_pool_put_page(struct page_pool *pool,
>   }
>   
>   /* Same as above but will try to sync the entire area pool->max_len */
> +static inline void page_pool_put_full_netmem(struct page_pool *pool,
> +		struct netmem *nmem, bool allow_direct)
> +{
> +	page_pool_put_netmem(pool, nmem, -1, allow_direct);
> +}
> +
>   static inline void page_pool_put_full_page(struct page_pool *pool,
>   					   struct page *page, bool allow_direct)
>   {
> -	page_pool_put_page(pool, page, -1, allow_direct);
> +	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
>   }
>   
>   /* Same as above but the caller must guarantee safe context. e.g NAPI */
> @@ -477,6 +483,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>   	page_pool_put_full_page(pool, page, true);
>   }
>   
> +static inline void page_pool_recycle_netmem(struct page_pool *pool,
> +					    struct netmem *nmem)
> +{
> +	page_pool_put_full_netmem(pool, nmem, true);
                                               ^^^^

It is not clear in what context page_pool_recycle_netmem() will be used,
but I think the 'true' (allow_direct=true) might be wrong here.

It is only in limited special cases (RX-NAPI context) we can allow
direct return to the RX-alloc-cache.

--Jesper
(cut rest of patch which looked fine)

