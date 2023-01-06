Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5483660813
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbjAFUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbjAFUS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:18:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA527687A8
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 12:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673036190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtMfxbZw88oPkeeCIwSBn+oySpGoEMlUBG5RLDl4Enc=;
        b=IJQ8AT11XR6feDlZv3gNGSf+4tByvXxNUHXaFgXs6CeRzxroqX+zcFpuuYZFS4emNLL5aF
        5KOaDp+UHfL2RGbPjgQ0rQaCCsMMK+3n0QOSaUNDyn/j62IivkaoYi5Nz+HoHPPImopTEe
        rjjN3W/Feovnpig3giDDEiGYZ0ENNhw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-d6FN8-clOqCDGAvyfNT_OQ-1; Fri, 06 Jan 2023 15:16:28 -0500
X-MC-Unique: d6FN8-clOqCDGAvyfNT_OQ-1
Received: by mail-ed1-f72.google.com with SMTP id l17-20020a056402255100b00472d2ff0e59so1904990edb.19
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 12:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LtMfxbZw88oPkeeCIwSBn+oySpGoEMlUBG5RLDl4Enc=;
        b=l3uPc7hDdyQJQ0yLquyKkWTTIYMBsmUlz32cbwcrIU4eSdjcMkUDjGcS2yPaZICQXJ
         BDDGVUz5RsHFfL/88T7dm9+nXxIF9IUF276EGy0olVHeIHnmfi2IWb89V6/P61xYy10l
         YKSeOUC0y9rboUjGhWnB4OPHfLxORM/UaLX5vKePeQva4AHw1AZM0CIIxyTZFMpsTPIc
         S734lmLTjbthU92k/0K5X6ZhyxetPDlhOESeU+hIlTaPWbKQ3y945cFVg2kR/80ppbRQ
         mWEbb+h62sDo+jjw5U+MYEpEbhapvERaT+hURQuVjD91sQdOQh96jNmGjwoyZbhAF5K1
         uwLQ==
X-Gm-Message-State: AFqh2kryhG4Tu2mnSHTvEbCBQoleBsaUA8eaWML2qNX5O+jtSt28gpzK
        bmZPUs/i5fmxvsuP6LfbaxEbdx0biorqsnA07YEUcoGe7BHM2O68BojPXG2Op4DaE2Bs1cHemby
        gRFQL3Q8OpF1fB8aI
X-Received: by 2002:a17:907:8b0a:b0:7c0:ae13:7407 with SMTP id sz10-20020a1709078b0a00b007c0ae137407mr54119120ejc.3.1673036187567;
        Fri, 06 Jan 2023 12:16:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXunGNhoiMU4SPZRLFuQA3rMs1nNEzaDJBII8I+LignqbvjiO8dWN/xUI0cMRUCyfuXbfuvo6Q==
X-Received: by 2002:a17:907:8b0a:b0:7c0:ae13:7407 with SMTP id sz10-20020a1709078b0a00b007c0ae137407mr54119107ejc.3.1673036187379;
        Fri, 06 Jan 2023 12:16:27 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id p5-20020a17090653c500b007ae32daf4b9sm709684ejo.106.2023.01.06.12.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 12:16:26 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c0f53cee-aaa7-2fe8-ff5b-0853085b6514@redhat.com>
Date:   Fri, 6 Jan 2023 21:16:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 17/24] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-18-willy@infradead.org>
 <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
 <Y7hR7KAzsOPsXrA1@casper.infradead.org>
In-Reply-To: <Y7hR7KAzsOPsXrA1@casper.infradead.org>
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



On 06/01/2023 17.53, Matthew Wilcox wrote:
> On Fri, Jan 06, 2023 at 04:49:12PM +0100, Jesper Dangaard Brouer wrote:
>> On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
>>> This function accesses the pagepool members of struct page directly,
>>> so it needs to become netmem.  Add page_pool_put_full_netmem() and
>>> page_pool_recycle_netmem().
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> ---
>>>    include/net/page_pool.h | 14 +++++++++++++-
>>>    net/core/page_pool.c    | 13 ++++++-------
>>>    2 files changed, 19 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>> index fbb653c9f1da..126c04315929 100644
>>> --- a/include/net/page_pool.h
>>> +++ b/include/net/page_pool.h
>>> @@ -464,10 +464,16 @@ static inline void page_pool_put_page(struct page_pool *pool,
>>>    }
>>>    /* Same as above but will try to sync the entire area pool->max_len */
>>> +static inline void page_pool_put_full_netmem(struct page_pool *pool,
>>> +		struct netmem *nmem, bool allow_direct)
>>> +{
>>> +	page_pool_put_netmem(pool, nmem, -1, allow_direct);
>>> +}
>>> +
>>>    static inline void page_pool_put_full_page(struct page_pool *pool,
>>>    					   struct page *page, bool allow_direct)
>>>    {
>>> -	page_pool_put_page(pool, page, -1, allow_direct);
>>> +	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
>>>    }
>>>    /* Same as above but the caller must guarantee safe context. e.g NAPI */
>>> @@ -477,6 +483,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>>>    	page_pool_put_full_page(pool, page, true);
>>>    }
>>> +static inline void page_pool_recycle_netmem(struct page_pool *pool,
>>> +					    struct netmem *nmem)
>>> +{
>>> +	page_pool_put_full_netmem(pool, nmem, true);
>>                                                ^^^^
>>
>> It is not clear in what context page_pool_recycle_netmem() will be used,
>> but I think the 'true' (allow_direct=true) might be wrong here.
>>
>> It is only in limited special cases (RX-NAPI context) we can allow
>> direct return to the RX-alloc-cache.
> 
> Mmm.  It's a c'n'p of the previous function:
> 
> static inline void page_pool_recycle_direct(struct page_pool *pool,
>                                              struct page *page)
> {
>          page_pool_put_full_page(pool, page, true);
> }
> 
> so perhaps it's just badly named?

Yes, I think so.

Can we name it:
  page_pool_recycle_netmem_direct

And perhaps add a comment with a warning like:
  /* Caller must guarantee safe context. e.g NAPI */

Like the page_pool_recycle_direct() function has a comment.

--Jesper

