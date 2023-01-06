Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310DC6601B3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbjAFOAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbjAFOAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:00:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922B977D0B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673013576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ld6skC87Efg95aZaTh35h3rM1PWHruwrzm5wBeouCCo=;
        b=A3j1JtP9i9S4zey3XiclTC9FwcsOs+uAobyB9kIjholI+3yhyRqqPzchlmXIszQQUtYFrz
        Dr30r1G9ckt+8ryOuojQo8FTS/9Iab0KrXNISBWbpYIX/VkKknXI3DpoF+6LXQfjuo6VkX
        XSmUV4P7Cxa4EIiIVGGNgiV6kqaGkSY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-QPBWjbfFP8iaXTdEMrky5Q-1; Fri, 06 Jan 2023 08:59:33 -0500
X-MC-Unique: QPBWjbfFP8iaXTdEMrky5Q-1
Received: by mail-ej1-f72.google.com with SMTP id sg39-20020a170907a42700b007c19b10a747so1185203ejc.11
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ld6skC87Efg95aZaTh35h3rM1PWHruwrzm5wBeouCCo=;
        b=VHOOyADY7PGhoWzYt6HNFvpShUMggF4bGdzy0EfRAHIG6ZclG3Pn7UeTSRNyggjX6m
         mOk9cbjXm6COIujuoLljiT65C2qo/wzMEGoqy5UPe3RndyEcVX7nZcnhQnRCR2ZoZf+g
         rC7biVRIh1nym6Zu/MZAr/MajrmLwpcBoJRL8LmfUVCLnom/AaIsen7+5OLvPC4/iRT8
         h9+dPHVsPql7e8W0aThqz7sBF86/bIZPpRCiGYyn+cpap9/C7fZseCkvS12ffpaTlbE0
         43vOQCM/c4WhogngAf7kFsZ6Np0O8Ko151sRjIi7E2aoNVuCf58sGfGGjrSznWdPSYfJ
         4pxw==
X-Gm-Message-State: AFqh2koMXKi69WgFm4UHr0AzSPMDKtLp5sDEl9//f8I+Ye5n/UnX3cWO
        wOcM4oPu93xZBJ6Uz9ITS9Loun8VbW75vJ12XoGaCx93+B4l/0CSFs7m7/cO3VKOZEyylM2+z+O
        NmqaS0Tllw2ixtfFH
X-Received: by 2002:a17:906:8d03:b0:83f:743e:86d with SMTP id rv3-20020a1709068d0300b0083f743e086dmr6820256ejc.14.1673013572498;
        Fri, 06 Jan 2023 05:59:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu/Ypg+zVVXXcX8tORlQQl+nbyb1LpahzhTJUDXGoEF4RRfu4eIbH86RVlS/sA+tygbzZ5Dag==
X-Received: by 2002:a17:906:8d03:b0:83f:743e:86d with SMTP id rv3-20020a1709068d0300b0083f743e086dmr6820247ejc.14.1673013572296;
        Fri, 06 Jan 2023 05:59:32 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b0084c6581c16fsm432981ejc.64.2023.01.06.05.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:59:31 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <aa334df4-e362-a6d6-87bf-fd6be16023ec@redhat.com>
Date:   Fri, 6 Jan 2023 14:59:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 05/24] page_pool: Start using netmem in allocation
 path.
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-6-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-6-willy@infradead.org>
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
> Convert __page_pool_alloc_page_order() and __page_pool_alloc_pages_slow()
> to use netmem internally.  This removes a couple of calls
> to compound_head() that are hidden inside put_page().
> Convert trace_page_pool_state_hold(), page_pool_dma_map() and
> page_pool_set_pp_info() to take a netmem argument.
> 
> Saves 83 bytes of text in __page_pool_alloc_page_order() and 98 in
> __page_pool_alloc_pages_slow() for a total of 181 bytes.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/trace/events/page_pool.h | 14 +++++------
>   net/core/page_pool.c             | 42 +++++++++++++++++---------------
>   2 files changed, 29 insertions(+), 27 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Question below.

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 437241aba5a7..4e985502c569 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
[...]
> @@ -421,7 +422,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>   		page = NULL;
>   	}
>   
> -	/* When page just alloc'ed is should/must have refcnt 1. */
> +	/* When page just allocated it should have refcnt 1 (but may have
> +	 * speculative references) */
>   	return page;

What does it mean page may have speculative references ?

And do I/we need to worry about that for page_pool?

--Jesper

