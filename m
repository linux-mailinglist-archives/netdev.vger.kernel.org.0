Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90C2FE326
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfKOQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:47:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44437 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfKOQr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:47:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id f19so6245552pgk.11
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 08:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=rA/OyNn/5C3vWkcMMT/52cdRUsmI42ncfKCQzZoGt9o=;
        b=AFa88gROQR91AQAPQuSaMKHt1Z/jT3JEKGhnMVmNQVGAAq/EuE/Xhy6roCCznMa9kq
         OjedwOMohgD8oP7joAYwRAqgPKggnhjuYrnoAKrlptcuzjLG8vnVT7Bwc4gkbOdSJcaS
         Oz48384rRGnq7240+UkNNyzlawkVjkPTorF4q3hFLV0C2FnekqO20lKDn9nH+yogVVFO
         sI8HKHE4SyQIBVZmNhk2SjBfVyWn/yv6Q30rpss70kL7Pwee8I78XNXf/q9AEqyr1UZV
         rLGNFFdG19S86AGjk4RmByyyTt9GZK9s3O0IUfgqCemNfcZr0wte4QJAfsf2zp/dtwy7
         iutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=rA/OyNn/5C3vWkcMMT/52cdRUsmI42ncfKCQzZoGt9o=;
        b=KyEA9nvqTftoUz2rWYQqcL0hETayJCkFKkT+VW7VR/RoqLmHXhUhFj3ncvMUvPl5+E
         tfcmHtuoO4o3wmUM2sphs0MA3PocJzlXAK9BU1R1yeipTP+CqSAH3ujAnhjV9L32mGcl
         suz2SJjrpO+68f+cEQmIu3l/1Iwdmf+Z42lfrhgPZsyPjJPaOl/BwZ9UuoDN/f2b1/6Y
         xtx8exW09nSHsGbI/OBC8ryNygD6BuExIaeqBG4ecXf0i53Mpb/uSZJyJTOmRP3ZSV23
         ExyZZoX8gXA10gOdjl0BEzxLjCG4sqJEDCTvSYZgLb3Ps/9Q5hgX36t5hiAdEBAzwGrw
         +zrA==
X-Gm-Message-State: APjAAAXVF7jyP0K0c5HPH6nLttHWuWkn2LVw5XPjrIvCS3wekmMaS6fx
        yjzeRTzj5CsDQW7P4BkW6e0=
X-Google-Smtp-Source: APXvYqxbdNjzpThSVKaWYXPcMFMYO7IeiTd+eXg2sWFtKTiG+vt20EDtd5wpr2VgzhersDN90tPHOQ==
X-Received: by 2002:a63:e407:: with SMTP id a7mr16784803pgi.92.1573836447211;
        Fri, 15 Nov 2019 08:47:27 -0800 (PST)
Received: from [172.20.54.79] ([2620:10d:c090:200::2:83d7])
        by smtp.gmail.com with ESMTPSA id e11sm11016042pff.104.2019.11.15.08.47.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 08:47:26 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc:     "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Date:   Fri, 15 Nov 2019 08:47:25 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <86A76A45-2CF5-46C4-A7CF-0EC3CB79944B@gmail.com>
In-Reply-To: <20191115080352.GA45399@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
 <20191114224309.649dfacb@carbon> <20191115070551.GA99458@apalos.home>
 <20191115074743.GB10037@localhost.localdomain>
 <20191115080352.GA45399@PC192.168.49.172>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 2019, at 0:03, Ilias Apalodimas wrote:

> Hi Lorenzo,
>
>>>>>>>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
>>>>>>>>> (then it can also be gated on having DMA_MAP enabled)
>>>>>>>>
>>>>>>>> You mean instead of the u8?
>>>>>>>> As you pointed out on your V2 comment of the mail, some cards 
>>>>>>>> don't
>>>>>>>> sync back to device.
>>>>>>>>
>>>>>>>> As the API tries to be generic a u8 was choosen instead of a 
>>>>>>>> flag
>>>>>>>> to cover these use cases. So in time we'll change the semantics 
>>>>>>>> of
>>>>>>>> this to 'always sync', 'dont sync if it's an skb-only queue' 
>>>>>>>> etc.
>>>>>>>>
>>>>>>>> The first case Lorenzo covered is sync the required len only 
>>>>>>>> instead
>>>>>>>> of the full buffer
>>>>>>>
>>>>>>> Yes, I meant instead of:
>>>>>>> +		.sync = 1,
>>>>>>>
>>>>>>> Something like:
>>>>>>>         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
>>>>>>>
>>>>
>>>> I actually agree and think we could use a flag. I suggest
>>>> PP_FLAG_DMA_SYNC_DEV to indicate that this DMA-sync-for-device.
>>>>
>>>> Ilias notice that the change I requested to Lorenzo, that 
>>>> dma_sync_size
>>>> default value is 0xFFFFFFFF (-1).  That makes dma_sync_size==0 a 
>>>> valid
>>>> value, which you can use in the cases, where you know that nobody 
>>>> have
>>>> written into the data-area.  This allow us to selectively choose it 
>>>> for
>>>> these cases.
>>>
>>> Okay, then i guess the flag is a better fit for this.
>>> The only difference would be that the sync semantics will be done on 
>>> 'per
>>> packet' basis,  instead of 'per pool', but that should be fine for 
>>> our cases.
>>
>> Ack, fine for me.
>> Do you think when checking for PP_FLAG_DMA_SYNC_DEV we should even 
>> verify
>> PP_FLAG_DMA_MAP? Something like:
>>
>> if ((pool->p.flags & (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)) ==
>>     (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV))
>> 	page_pool_dma_sync_for_device();
>>
>> Regards,
>> Lorenzo
>
> I think it's better to do the check once on the pool registration and 
> maybe
> refuse to allocate the pool? Syncing without mapping doesn't really 
> make sense

+1.
-- 
Jonathan
