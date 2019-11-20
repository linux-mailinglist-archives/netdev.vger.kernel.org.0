Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D31104390
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfKTSmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:42:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38050 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfKTSmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:42:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id q18so181877pls.5
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 10:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=GsndgZbkO9+HcdbJnEXp/EJ5InPgj0aLpbzZc/Z2+C4=;
        b=qV2kq1fafXm0YfbMR0Y07OgPg7xv8eVuoTIFPb6KRSqQr4YddD+5Ddj/cexIaPJ5LK
         Hqvqx5lCGuSNIr0AOUiKSUAI+2hTdXwbTCEipcLUWgmgM8tyMEI0a3aKV/BAmmhmekLj
         Oewr+RZh9BJEHmf+wEcai4MrpHu7V90Y8jRYWSctaD/aHOlzXk2zQqHnga7gIHzZ/VmX
         sEFHTw2OisawOPgNy2pMZCXWbm/OAGfSEXjoKf4RlKQm10e/o7mnQKkyq+XVS2faZTgJ
         4P9q3hnDnvyNGtzU7SHXjvlWei/6hk2ddnb/vuzqwsgK7R4VL7jW24MrNBdCWzn3YIMw
         RC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=GsndgZbkO9+HcdbJnEXp/EJ5InPgj0aLpbzZc/Z2+C4=;
        b=bUbVbe7pDn2YqzgKoQ1M1nYoYblUH5fIp2NnL/+Wtq3Xlg6B+HKu71TnVcR3quGjrM
         /CURte0TSxLXqGw6yU/kVCztLA8POJ5Wo1U8Ifiq3qNriO+Pdn6qQ2jFDuNWUPzga+HW
         bhY2oUtZAO4LR2DLTgdzicxTAJVBVRWhGNVnLDcolJrt81GdfPF8biPujuC6aqTdkYvb
         jaJ+Ej1VTz/FoBhYNCDMJFQv6GDpq9wNKnesVY0RxArl7gE1kE/JpWlyRrG+iccKJ2Hw
         lfrikRWtqoYVC+8vNzEYyoSgFDb4RUiKvrOKjhplVMwuF7F026LIJHmC7JvPmVIB+bdc
         IE+Q==
X-Gm-Message-State: APjAAAUnkZGJRhio7Ot5k8fjggIUKf0W8RKQIgjL7UFfbtZWwvNCUUQL
        w6X9gjyi2MSvVnoN5ML5ywM=
X-Google-Smtp-Source: APXvYqz3ehkmwC2h80g4G21iXJtftZVIa/xDegN6HgXQ7rdgC3z6tPgJ2Gk+1EBF3sWmgP4jBVQejQ==
X-Received: by 2002:a17:902:1:: with SMTP id 1mr4322027pla.338.1574275368575;
        Wed, 20 Nov 2019 10:42:48 -0800 (PST)
Received: from [172.26.111.194] ([2620:10d:c090:180::ee2d])
        by smtp.gmail.com with ESMTPSA id r22sm90812pfg.54.2019.11.20.10.42.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 10:42:48 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: Re: [PATCH v5 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Date:   Wed, 20 Nov 2019 10:42:47 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <3DD728CA-CF0B-4F26-AF64-4E1C357D0F0C@gmail.com>
In-Reply-To: <20191120184901.59306f16@carbon>
References: <cover.1574261017.git.lorenzo@kernel.org>
 <4a22dd0ef91220748c4d3da366082a13190fb794.1574261017.git.lorenzo@kernel.org>
 <20191120184901.59306f16@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Nov 2019, at 9:49, Jesper Dangaard Brouer wrote:

> On Wed, 20 Nov 2019 16:54:18 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
>> Introduce the following parameters in order to add the possibility to 
>> sync
>> DMA memory for device before putting allocated pages in the page_pool
>> caches:
>> - PP_FLAG_DMA_SYNC_DEV: if set in page_pool_params flags, all pages 
>> that
>>   the driver gets from page_pool will be DMA-synced-for-device 
>> according
>>   to the length provided by the device driver. Please note 
>> DMA-sync-for-CPU
>>   is still device driver responsibility
>> - offset: DMA address offset where the DMA engine starts copying rx 
>> data
>> - max_len: maximum DMA memory size page_pool is allowed to flush. 
>> This
>>   is currently used in __page_pool_alloc_pages_slow routine when 
>> pages
>>   are allocated from page allocator
>> These parameters are supposed to be set by device drivers.
>>
>> This optimization reduces the length of the DMA-sync-for-device.
>> The optimization is valid because pages are initially
>> DMA-synced-for-device as defined via max_len. At RX time, the driver
>> will perform a DMA-sync-for-CPU on the memory for the packet length.
>> What is important is the memory occupied by packet payload, because
>> this is the area CPU is allowed to read and modify. As we don't track
>> cache-lines written into by the CPU, simply use the packet payload 
>> length
>> as dma_sync_size at page_pool recycle time. This also take into 
>> account
>> any tail-extend.
>>
>> Tested-by: Matteo Croce <mcroce@redhat.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> [...]
>> @@ -281,8 +309,8 @@ static bool __page_pool_recycle_direct(struct 
>> page *page,
>>  	return true;
>>  }
>>
>> -void __page_pool_put_page(struct page_pool *pool,
>> -			  struct page *page, bool allow_direct)
>> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
>> +			  unsigned int dma_sync_size, bool allow_direct)
>>  {
>>  	/* This allocator is optimized for the XDP mode that uses
>>  	 * one-frame-per-page, but have fallbacks that act like the
>> @@ -293,6 +321,10 @@ void __page_pool_put_page(struct page_pool 
>> *pool,
>>  	if (likely(page_ref_count(page) == 1)) {
>>  		/* Read barrier done in page_ref_count / READ_ONCE */
>>
>> +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>> +			page_pool_dma_sync_for_device(pool, page,
>> +						      dma_sync_size);
>> +
>>  		if (allow_direct && in_serving_softirq())
>>  			if (__page_pool_recycle_direct(page, pool))
>>  				return;
>
> I am slightly concerned this touch the fast-path code. But at-least on
> Intel, I don't think this is measurable.  And for the ARM64 board it
> was a huge win... thus I'll accept this.

For the next series:

The "in_serving_softirq()" check shows up on profiling.  I'd
like to remove this and just have a "direct" flag, where the
caller takes the responsibility of the correct context.
-- 
Jonathan
