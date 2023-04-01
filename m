Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55966D33DF
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 22:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDAUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 16:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjDAUmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 16:42:03 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5318D27800
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 13:41:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i5so103131959eda.0
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680381717;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1A4phOOM2IGtqfxs9yelWrHm0e8wi2R2pJf3N4Tslj4=;
        b=USMRqW7ZHurxqMNsmv45v91USk2IrvG4LnCK43Ooo+2cdOdSusVUHdFL+0XAlZ6RF2
         2PKRHQrh1HrmGIBdMm0nQLt7RvRvBQydDQ6It1TQ7frvHjBNvNb6lEQFCRMfrTB5hqXb
         ORiNn1rzlen17BmkYU1HTR+0NbXti7qENjeLyXsgy8uWsA0WWsq7yi5w0ADa1rxEwskT
         HhVJJz63rOts+U6Bp8OPMycS/nXv1kH1bNv9dp361Dn4FPlkjIpgKTr3N8h2SY4uAb51
         ZYghp1gRDjAfTPSSZRqKUyCq0ggfcn/Vom8icz+35U3uaKlSt15k52+Hrsq7p06XH+gz
         tvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680381717;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1A4phOOM2IGtqfxs9yelWrHm0e8wi2R2pJf3N4Tslj4=;
        b=lBrrSrHZ0ZpDwWDdFlEWrneJ5UBzlHW196WcDOi1C1IoEkQh4f949Sbk7RDpAeANEW
         7w7tZrMLKt5M/LdWtlTXgCZ9ceSIAs7EATdgFYmeLDvF+no0mptxg4nqjh1HOZCyKisJ
         PoWIUxPhwsy76/FkpI5js4ZqO6rMamAA66qBwGbs66g+cjvhTeKUb7iM68EH97JXbFqP
         SVexIeKGHom1gMtNBJE/EHqy9iWeezQlneyllB1D0RMLd3Mt8m0sKL4boB/hx6hrBsPn
         UJ+gTNMDt2eVsinmEX0DFrUtyZGTBLvaDSCd2TlhNkNuT/nN5rBpvcrniXHnHMPUC3pt
         Y9pA==
X-Gm-Message-State: AAQBX9dZkr5URYA3QYdkonQ9xFVsV+QDL5YBM8mpoB0fPfEfAcRbHHck
        nbWFrVxdcP8DamQkYdVKDT8=
X-Google-Smtp-Source: AKy350Zmzxc9hJAKu7NCe0ylFAB8sVZGn52JIQ7gx/RpgSHioMAe/KigJdrZF9yIGZqbMg9O03Z0gQ==
X-Received: by 2002:a17:907:6e04:b0:930:3916:df17 with SMTP id sd4-20020a1709076e0400b009303916df17mr42967429ejc.0.1680381716461;
        Sat, 01 Apr 2023 13:41:56 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bda6:2000:35bd:7a7:441f:cb1? (dynamic-2a01-0c23-bda6-2000-35bd-07a7-441f-0cb1.c23.pool.telefonica.de. [2a01:c23:bda6:2000:35bd:7a7:441f:cb1])
        by smtp.googlemail.com with ESMTPSA id bt23-20020a170906b15700b009477a173744sm2450883ejb.38.2023.04.01.13.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 13:41:56 -0700 (PDT)
Message-ID: <4ba26f4a-4bdb-1852-7406-6f6f723986ad@gmail.com>
Date:   Sat, 1 Apr 2023 22:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Alexander Duyck <alexander.duyck@gmail.com>
References: <20230401051221.3160913-1-kuba@kernel.org>
 <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
 <20230401115854.371a5b4c@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
In-Reply-To: <20230401115854.371a5b4c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.04.2023 20:58, Jakub Kicinski wrote:
> On Sat, 1 Apr 2023 17:18:12 +0200 Heiner Kallweit wrote:
>>> +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond) \
>>> +	({								\
>>> +		int _res;						\
>>> +									\
>>> +		_res = -1;						\  
>>
>> One more question: Don't we need a read memory barrier here to ensure
>> get_desc is up-to-date?
> 
> CC: Alex, maybe I should not be posting after 10pm, with the missing v2
> and sparse CC list.. :|
> 
> I was thinking about this too yesterday. AFAICT this implementation
> could indeed result in waking even tho the queue is full on non-x86.
> That's why the drivers have an extra check at the start of .xmit? :(
> 
> I *think* that the right ordering would be:
> 
> WRITE cons
> mb()  # A
> READ stopped
> rmb() # C
> READ prod, cons
> 
> And on the producer side (existing):
> 
> WRITE prod
> READ prod, cons
> mb()  # B
> WRITE stopped
> READ prod, cons
> 
> But I'm slightly afraid to change it, it's been working for over 
> a decade :D
> 
> One neat thing that I noticed, which we could potentially exploit 
> if we were to touch this code is that BQL already has a smp_mb() 
> on the consumer side. So on any kernel config and driver which support
> BQL we can use that instead of adding another barrier at #A.
> 
To me it seems ixgbe relies on this BQL-related barrier in
netdev_tx_completed_queue, maybe unintentionally.

I wonder whether we should move the smp_mb() from __netif_tx_queue_try_wake
to __netif_tx_queue_maybe_wake, before accessing get_desc.
Answer may depend on whether there's any use case where drivers would
call the "try" version directly, instead of the "may" version.
And, just thinking out loud, maybe add a flag to the macro to disable
the smp_mb() call, for cases where the driver has the required barrier
already. Setting this flag may look like this.

bool disable_barrier_in_may_wake = IS_ENABLED(CONFIG_BQL);

However this is quite some effort just to avoid a duplicated barrier.

> It would actually be a neat optimization because right now, AFAICT,
> completion will fire the # A -like barrier almost every time.
> 
>>> +		if (likely(get_desc > start_thrs))			\
>>> +			_res = __netif_tx_queue_try_wake(txq, get_desc,	\
>>> +							 start_thrs,	\
>>> +							 down_cond);	\
>>> +		_res;							\
>>> +	})

