Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B935C627A4F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiKNKSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbiKNKSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:18:32 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10575DC3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:18:28 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id g7so18486129lfv.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXn72dLjj0Hw2Xv+5Ps52SCriy8lUcytBZtYjK3WV/c=;
        b=ILMvbwxvzgmd3zdouit5TTTK8q45EAKgkrPDn4fGVKMV3SE8gPsuJlxSN6whml9IJF
         x4A1OITYUl233BMSaUVsbvjNe1B2Tpy88kCbonNjAnTk1KGhZRemnPsSiw000dO4P0wV
         kKlJ64hz5UtfkTClJPHYKfShf0i5MGrJ8jqms69oCbic4tFGKfKAcNRUffLEHSCqj5Pj
         fDr2bvETYKNL35lGXRH5GoWVjA4F8FSkkg6XOqvpdjqeko+FiKSlTrRgcBakzYO1jysF
         fo8o6JfKuCILPvJlbchLYR+mzuS5welXOYVToeyi08cIoAXWrC+gAI4edouLIKnBhjRU
         uGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXn72dLjj0Hw2Xv+5Ps52SCriy8lUcytBZtYjK3WV/c=;
        b=ZkF2pZselQyqTrGtnCJRB3M5W7AjxDO9yEzTQV6lYjdxQbjSxf1kUbKP8PK6dcBfRE
         6akvdvhbKniPtnlruHkuO2c0yR33Dzk6o6G6hjtsbN0aDn+bNxBFl50sO7T0lIfoEsMy
         f1RpWLyxR9YHjw+AidIvhqNrKFGCUtpwzNmwkZEpPLssCIb7iu8Zdm7c0ZJc0xPeWjEu
         2R/umq+ll6gPAKd34BoCUFj1tgHzgPdkT+Pxzv+4MO0T8FWb0iVfkXOwCQKt8fXsRouT
         oX1KHs7roA2A7tvFqYI1sO7hyI2b4+5FIdfRjvhUXP1mYf9BBYK42mNp4J0dWtQvA93W
         Ws1w==
X-Gm-Message-State: ANoB5plXRmMg4oY+LhLnikPj+jgUwZMXu0ztGKrMQ+d4cCwCBvYQ/d3V
        zSpI2ii2zi7niYthtdTVwgmZCYHhJVkAtFD2
X-Google-Smtp-Source: AA0mqf5fBDpKtJZ5fPeSfbRC4NyyJOHlV9EiaS+Obx93k5niI89ACe2oAKKX0ZCMvqwfIUZQQsmHQg==
X-Received: by 2002:ac2:5f8a:0:b0:4a7:648d:a7a6 with SMTP id r10-20020ac25f8a000000b004a7648da7a6mr3694646lfe.588.1668421107191;
        Mon, 14 Nov 2022 02:18:27 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id l10-20020a056512110a00b00494813c689dsm1763509lfg.219.2022.11.14.02.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 02:18:26 -0800 (PST)
Message-ID: <a0fedaae-7245-a5fa-b29e-5fb036d7d147@linaro.org>
Date:   Mon, 14 Nov 2022 11:18:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci
 devices
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>, bongsu.jeon@samsung.com
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
References: <20221104170422.979558-1-dvyukov@google.com>
 <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
 <CACT4Y+aVXi5hWNMrYavfhmhr3+FVyJoq8KhzrLp1gJFiSCxpxg@mail.gmail.com>
 <20221108004316epcms2p63ff537496ef759cb0c734068bd58855c@epcms2p6>
 <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p5>
 <CACT4Y+ZdkFV0--A2i3Q9H9_OnTzgfWVHJUJT13x0O3xNz3kiyQ@mail.gmail.com>
 <20221109003457epcms2p558755edeebc687dba23195ce5b1935c7@epcms2p5>
 <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CACT4Y+YQB_HU-fwwUHd=NBX5PM2ADhcfgO7QBwRXD7gZVGg=vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 01:42, Dmitry Vyukov wrote:
> On Tue, 8 Nov 2022 at 16:35, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
>>>>>> On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
>>>>>>> The current virtual nci driver is great for testing and fuzzing.
>>>>>>> But it allows to create at most one "global" device which does not allow
>>>>>>> to run parallel tests and harms fuzzing isolation and reproducibility.
>>>>>>> Restructure the driver to allow creation of multiple independent devices.
>>>>>>> This should be backwards compatible for existing tests.
>>>>>>
>>>>>> I totally agree with you for parallel tests and good design.
>>>>>> Thanks for good idea.
>>>>>> But please check the abnormal situation.
>>>>>> for example virtual device app is closed(virtual_ncidev_close) first and then
>>>>>> virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
>>>>>> (there would be problem in virtual_nci_send because of already destroyed mutex)
>>>>>> Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.
>>>>>
>>>>> I assumed nci core must stop calling into a driver at some point
>>>>> during the driver destruction. And I assumed that point is return from
>>>>> nci_unregister_device(). Basically when nci_unregister_device()
>>>>> returns, no new calls into the driver must be made. Calling into a
>>>>> driver after nci_unregister_device() looks like a bug in nci core.
>>>>>
>>>>> If this is not true, how do real drivers handle this? They don't use
>>>>> global vars. So they should either have the same use-after-free bugs
>>>>> you described, or they handle shutdown differently. We just need to do
>>>>> the same thing that real drivers do.
>>>>>
>>>>> As far as I see they are doing the same what I did in this patch:
>>>>> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/fdp/i2c.c#L343
>>>>> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/usb.c#L354
>>>>>
>>>>> They call nci_unregister_device() and then free all resources:
>>>>> https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/nfc/nfcmrvl/main.c#L186
>>>>>
>>>>> What am I missing here?
>>>>
>>>> I'm not sure but I think they are little different.
>>>> nfcmrvl uses usb_driver's disconnect callback function and fdp's i2c uses i2c_driver's remove callback function for unregister_device.
>>>> But virtual_ncidev just uses file operation(close function) not related to driver.
>>>> so Nci simulation App can call close function at any time.
>>>> If Scheduler interrupts the nci core code right after calling virtual_nci_send and then
>>>> other process or thread calls virtual_nci_dev's close function,
>>>> we need to handle this problem in virtual nci driver.
>>>
>>> Won't the same issue happen if nci send callback is concurrent with
>>> USB/I2C driver disconnect?
>>>
>>> I mean something internal to the USB subsystem cannot affect what nci
>>> subsystem is doing, unless the USB driver calls into nci and somehow
>>> notifies it that it's about to destroy the driver.
>>>
>>> Is there anything USB/I2C drivers are doing besides calling
>>> nci_unregister_device() to ensure that there are no pending nci send
>>> calls? If yes, then we should do the same in the virtual driver. If
>>> not, then all other drivers are the subject to the same use-after-free
>>> bug.
>>>
>>> But I assumed that nci_unregister_device() ensures that there are no
>>> in-flight send calls and no future send calls will be issued after the
>>> function returns.
>>
>> Ok, I understand your mention. you mean that nci_unregister_device should prevent
>> the issue using dev lock or other way. right?
> 
> Yes.
> 
>> It would be better to handle the issue in nci core if there is.
> 
> And yes.
> 
> Krzysztof, can you confirm this is the case (nci core won't call
> ops->send callback after nci_unregister_device() returns)?

You asked me like I would know. :) I took the NFC subsystem, to bring it
a bit to shape, but I did not write any of this code and I don't
actually know - until I analyze the code as we all do...

Best regards,
Krzysztof

