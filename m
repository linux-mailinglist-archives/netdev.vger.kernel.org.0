Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A705659FEEB
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiHXP51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237329AbiHXP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:57:26 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65CF7CAB5
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:57:24 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id g21so12998382qka.5
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=/m+rtiJz+Qm4rT8k/BiFXo4fPF2q05ZqBWM0XiA75/0=;
        b=Vyk5Fw1XPHckfc43FSeuMv2sTJb3b2hgvhNNDfSvsVjp8VTiR9drO4cIuVqTYO6sbJ
         I77P+FlTX3w1b5Qj3eYqYctLsa5oZHO3FeqpqyzYb1wUZFBH+mMEj8HP3Q1H+MaNqPOm
         vIA7vpz1lAO7zNUUZYNawhP1MGTyHX0xztLghX7APs4eFsFvSD8GjK7uCle9OM+6Kwhq
         gGcBkQOVpYL8NnYgGoLwh1nBQrvV/LY66N62hJ0enjODOgXlFx+xQXwxxlY/JO/Pf+8E
         uqbvyfBJ2qw+ysPR2PBK5H2sIlSDPa9wo9aljxbr2nn5Sqz29ZyQSLkC8ydCw6PgNPuZ
         uvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=/m+rtiJz+Qm4rT8k/BiFXo4fPF2q05ZqBWM0XiA75/0=;
        b=mDDUvh4gpiKotGEEPtcM0JN5mrjP8N2i1WidQkD/lkgGaiQE7gpDBEefTiUoTx3JTg
         CjgM63EiCXg/mdZOMfI5U9DZYtN0lliJoxrd9xb0JdjH3zvpvqTbt19OrtvPiIZ55lo1
         2UJDj5+sT8UiHy+0KLa9cm8MGcM4nRPr6CF0EcVzUw520KQP0OhK3qUC09Gx1t3XBkpu
         56y/bpHWVzBOzXpvna9Ws6hOhbGLsGkzqldtJYl/ZPF4DPjKkz5xk1esPSYKiD2b4tSh
         He62tBaQQ5/UHLxOYtK8K6olCu51ONKZA5o9G+MD5Xk39skd3rq04aaQDXZzBnU72KaG
         bbjg==
X-Gm-Message-State: ACgBeo2OZgOLLyIoMXeqtfyEtJr3z9ItteZEu8k3bHFCBgZAfWjtqCQk
        DIWu749FhI655/L1hTECnGDqjEMLsWs=
X-Google-Smtp-Source: AA6agR6VZOWG0qBcr8GIQrX1j14IchVmGax1nl1xE7LV5tbmom3reWydWUEmJEkpAyaAmxM5G1HlNA==
X-Received: by 2002:a05:620a:2592:b0:6b2:7b63:9772 with SMTP id x18-20020a05620a259200b006b27b639772mr20385515qko.119.1661356643323;
        Wed, 24 Aug 2022 08:57:23 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id bs13-20020ac86f0d000000b0031ef67386a5sm12688203qtb.68.2022.08.24.08.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 08:57:22 -0700 (PDT)
Subject: Re: [PATCH 4/x] sunhme: switch to devres
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <7e286518-2f01-6042-4d23-94d8846774db@gmail.com>
 <1754323.ZfhJiG4Tka@daneel.sf-tec.de> <3192215.44csPzL39Z@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <812378b7-80ed-e966-248c-d00a3377a333@gmail.com>
Date:   Wed, 24 Aug 2022 11:57:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3192215.44csPzL39Z@eto.sf-tec.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/22 11:45 AM, Rolf Eike Beer wrote:
> Am Montag, 1. August 2022, 17:14:39 CEST schrieb Rolf Eike Beer:
>> Am Freitag, 29. Juli 2022, 02:33:01 CEST schrieb Sean Anderson:
>>> On 7/28/22 3:52 PM, Rolf Eike Beer wrote:
>>>> Am 2022-07-27 05:58, schrieb Sean Anderson:
>>>>> On 7/26/22 11:49 PM, Sean Anderson wrote:
>>>>>> This looks good, but doesn't apply cleanly. I rebased it as follows:
>>>> Looks like what my local rebase has also produced.
>>>>
>>>> The sentence about the leak from the commitmessage can be dropped then,
>>>> as this leak has already been fixed.
>>>>
>>>>>> diff --git a/drivers/net/ethernet/sun/sunhme.c
>>>>>> b/drivers/net/ethernet/sun/sunhme.c index eebe8c5f480c..e83774ffaa7a
>>>>>> 100644
>>>>>> --- a/drivers/net/ethernet/sun/sunhme.c
>>>>>> +++ b/drivers/net/ethernet/sun/sunhme.c
>>>>>> @@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_dev
>>>>>> *pdev, qp->happy_meals[qfe_slot] = dev;
>>>>>>
>>>>>>        }
>>>>>>
>>>>>> -    hpreg_res = pci_resource_start(pdev, 0);
>>>>>> -    err = -ENODEV;
>>>>>>
>>>>>>        if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
>>>>>>        
>>>>>>            printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI
>>>>>>            device
>>>>>>
>>>>>> base address.\n"); goto err_out_clear_quattro;
>>>>>>
>>>>>>        }
>>>>>>
>>>>>> -    if (pci_request_regions(pdev, DRV_NAME)) {
>>>>>> +
>>>>>> +    if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
>>>>>> +                  pci_resource_len(pdev, 0),
>>>>>> +                  DRV_NAME)) {
>>>>>
>>>>> Actually, it looks like you are failing to set err from these *m
>>>>> calls, like what
>>>>> you fixed in patch 3. Can you address this for v2?
>>>>
>>>> It returns NULL on error, there is no error code I can set.
>>>
>>> So it does. A quick grep shows that most drivers return -EBUSY.
>>
>> Sure, I just meant that there is no error code I can pass on. I can change
>> that to -EBUSY if you prefer that, currently it just returns -ENODEV as the
>> old code has done before.
> 
> Ping?

I think -EBUSY is a good return here.

I have a WIP at [1] of some logging cleanups on top of your commits.

--Sean

[1] https://github.com/Forty-Bot/linux/commits/hme_base
