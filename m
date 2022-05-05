Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA251C421
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbiEEPqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiEEPqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:46:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E378532E2
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:43:00 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i19so9478286eja.11
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 08:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=oyJTCgpcbukbN6nWJxDfM/9kevQmboqq6kbPUDKFx0A=;
        b=HDOXgUep6gz+hRPc0XKeMU8CRWY51WCwaNdERbXG1icY9JnlscGBf6MdnPUQbfXb9M
         h2CkK8/TM5dFQnlIhTGSuaBob1j07SmAB3ArFM/UEaXXfIrCgZnfvpLMj6R0E2JXQD/u
         9RhQGU4084VZxidT5nkKqp6YJXnXv18u4o0qtxcEkNhLk5n3Y9ove7TxgUa1VD3mmqSk
         vdcUjGeSp1nVoovuECBMq1hF89pMZTuomNk6dN+AgUJvwSQf1azc7HpmO+hzrq/OU28D
         fvHu0ZCkUTvZgsoqzO2pMJq0KKt/BEsOxY/Fs7mjOzDPDOuhby2zf3nC52XdlxXwV78J
         x3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oyJTCgpcbukbN6nWJxDfM/9kevQmboqq6kbPUDKFx0A=;
        b=aLfw/MEMdE+aF/ZVt5YODpV9EhaLQHwyaRtXR4dfUksgTPyA3UVYNp83ZED9ujisGX
         8YpmPEd7eNMbkf31Ld8iLJmxou3l9Q9VbKV8pAfiL0qSzK17hcvsbqAImPaQu3MpxULZ
         /Spn6kUsnnEF0WnXty3zSANU/fWA26nsqeXZE27eZoCqS0iWKqdEauF6rUW2Yjqlm2ER
         tYJPozSqy6opgydEnaEy27Uoxa9WAJBJTv/eqquCmnMhm8SHaPWgMKJbtMSVr3fhzT5m
         mupzsnKHXhbTip+Z3/Wj+7rnBRE4Vm+418tbPQYRCWTYcfvLTZ0EkDoCmWzxdKQbhnyd
         sBUA==
X-Gm-Message-State: AOAM5309Q2KJQIZXK6mGRqv/2j5stRN/zYIIMuTdamOxKiMEAm61ceDg
        MEtZtJfK0Sdhk54JkkxFTEs=
X-Google-Smtp-Source: ABdhPJzLqbVkLhe82x2L01b9MzAU4rx7YjptLMSkoZ2NZQ3GX0arXAlTvF6H1uyhgsN8DLIaeXwUrw==
X-Received: by 2002:a17:906:9743:b0:6d8:632a:a42d with SMTP id o3-20020a170906974300b006d8632aa42dmr27441594ejy.157.1651765378619;
        Thu, 05 May 2022 08:42:58 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id bx8-20020a0564020b4800b0042617ba639bsm980959edb.37.2022.05.05.08.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 08:42:58 -0700 (PDT)
Message-ID: <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com>
Date:   Thu, 5 May 2022 17:42:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2022 16:49, Arnd Bergmann wrote:
> On Wed, Apr 27, 2022 at 7:31 PM Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 27.04.2022 14:56, Alexander Lobakin wrote:
> 
>> Thank you Alexander, this appears to be helpful! I decided to ignore
>> CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B for now and just adjust CFLAGS
>> manually.
>>
>>
>> 1. Without ce5013ff3bec and with -falign-functions=32
>> 387 Mb/s
>>
>> 2. Without ce5013ff3bec and with -falign-functions=64
>> 377 Mb/s
>>
>> 3. With ce5013ff3bec and with -falign-functions=32
>> 384 Mb/s
>>
>> 4. With ce5013ff3bec and with -falign-functions=64
>> 377 Mb/s
>>
>>
>> So it seems that:
>> 1. -falign-functions=32 = pretty stable high speed
>> 2. -falign-functions=64 = very stable slightly lower speed
>>
>>
>> I'm going to perform tests on more commits but if it stays so reliable
>> as above that will be a huge success for me.
> 
> Note that the problem may not just be the alignment of a particular
> function, but also how different function map into your cache.
> The Cortex-A9 has a 4-way set-associative L1 cache of 16KB, 32KB or
> 64KB, with a line size of 32 bytes. If you are unlucky and you get
> five different functions that are frequently called and are a multiple
> functions are exactly the wrong spacing that they need more than
> four ways, calling them in sequence would always evict the other
> ones. The same could of course happen if the problem is the D-cache
> or the L2.
> 
> Can you try to get a profile using 'perf record' to see where most
> time is spent, in both the slowest and the fastest versions?
> If the instruction cache is the issue, you should see how the hottest
> addresses line up.

Your explanation sounds sane of course.

If you take a look at my old e-mail
ARM router NAT performance affected by random/unrelated commits
https://lkml.org/lkml/2019/5/21/349
https://www.spinics.net/lists/linux-block/msg40624.html

you'll see that most used functions are:
v7_dma_inv_range
__irqentry_text_end
l2c210_inv_range
v7_dma_clean_range
bcma_host_soc_read32
__netif_receive_skb_core
arch_cpu_idle
l2c210_clean_range
fib_table_lookup

Is there a way to optimize kernel for optimal cache usage of selected
(above) functions?


Meanwhile I was testing -fno-reorder-blocks which some OpenWrt folks
reported as worth trying. It's another randomness. It stabilizes NAT
performance across some commits and breaks stability across others.
