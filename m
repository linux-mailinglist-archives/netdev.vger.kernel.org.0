Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313BE5120C8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbiD0Rey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbiD0Rew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:34:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCEBC90CD
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:31:36 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dk23so4800221ejb.8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=ZKeXEe0W6Z+vkH+QlEJyQqlgzwSZRHDrj9AwFxpc9Nk=;
        b=Fs0Sync5A/JO6lfQQ+IcUPYHMolmh5oJWMH1a+xMGJHM3KclFV6YIPgvowQfggR1hT
         ti0/28ib5xy525vw/QQJrQcj9w2HCC/NeHTAtbPc7GCUyMulOO7FWAxB7LTxGlH8ipoC
         5di6VU2abHM4hR9aM2xqS8Xl4WGGFC0PqTn4q8IeyWtT0+B/ryi3da3zKL45EW7UwEF4
         0NvwZVWQ0A/QUxxlLFKEH3ZdPJy7DwUEvMuVFqatOTI5JPAEMFgHpulMTfuYETxgVkv0
         TUJ4B6QbxQ1c1NAnDOZpINAb5Idz2oAImd0nWXMDghJi8g2UcSMEc3F6273Ses+wfOLN
         7LIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZKeXEe0W6Z+vkH+QlEJyQqlgzwSZRHDrj9AwFxpc9Nk=;
        b=v7pNyc5JJbEas+MeijvbifURBq0aQZM+kB71MBGw0UYCkaCde24JYnfS5UoGQGSTWu
         yCI9uRWh1F2fMy0ylYKDn5ERQrf+jVm5ddosCTAsaVJQjmwUsLkA5Vrx+1wM7MTVfWCt
         sPgZ16jMl+398K5oynnVJVXcaP7vdSn3TV2/2ODDTky/UPihLJXaaiU/1MATU8qj99X/
         v6oJqODzTWAs8HrBDii9ls/a3tYrIvBz4pXKN4b7nk5CAoneoRuM02+EPlQnTxGakzr4
         4Sw+ErXi0JXgPY6A+Ia9Dx5skQDBdeb+DjgSfRstalnOgjfvztki3Sh+io/r9DDoKEih
         ObVA==
X-Gm-Message-State: AOAM530KcqNZ/XLNnGDqoxtk+TuTf+cBJw5Hs5wst9F128f4mjPpzc7k
        paYXe6it8DJeZSqFeDgKmuQ=
X-Google-Smtp-Source: ABdhPJwqSc2G7y78wQJbvPycjFDRHKJaw1PDUWMnSw0lOmUvEd6fCQ7xlujCCs4ETC92ZP9+tah7fg==
X-Received: by 2002:a17:906:544e:b0:6f3:bd59:1a93 with SMTP id d14-20020a170906544e00b006f3bd591a93mr6848772ejp.421.1651080695064;
        Wed, 27 Apr 2022 10:31:35 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id m11-20020a50cc0b000000b00425f85effbfsm3902519edi.58.2022.04.27.10.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 10:31:34 -0700 (PDT)
Message-ID: <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
Date:   Wed, 27 Apr 2022 19:31:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20220427125658.3127816-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.04.2022 14:56, Alexander Lobakin wrote:
> From: Rafał Miłecki <zajec5@gmail.com>
> Date: Wed, 27 Apr 2022 14:04:54 +0200
> 
>> I noticed years ago that kernel changes touching code - that I don't use
>> at all - can affect network performance for me.
>>
>> I work with home routers based on Broadcom Northstar platform. Those
>> are SoCs with not-so-powerful 2 x ARM Cortex-A9 CPU cores. Main task of
>> those devices is NAT masquerade and that is what I test with iperf
>> running on two x86 machines.
>>
>> ***
>>
>> Example of such unused code change:
>> ce5013ff3bec ("mtd: spi-nor: Add support for XM25QH64A and XM25QH128A").
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce5013ff3bec05cf2a8a05c75fcd520d9914d92b
>> It lowered my NAT speed from 381 Mb/s to 367 Mb/s (-3,5%).
>>
>> I first reported that issue it in the e-mail thread:
>> ARM router NAT performance affected by random/unrelated commits
>> https://lkml.org/lkml/2019/5/21/349
>> https://www.spinics.net/lists/linux-block/msg40624.html
>>
>> Back then it was commit 5b0890a97204 ("flow_dissector: Parse batman-adv
>> unicast headers")
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9316a9ed6895c4ad2f0cde171d486f80c55d8283
>> that increased my NAT speed from 741 Mb/s to 773 Mb/s (+4,3%).
>>
>> ***
>>
>> It appears Northstar CPUs have little cache size and so any change in
>> location of kernel symbols can affect NAT performance. That explains why
>> changing unrelated code affects anything & it has been partially proven
>> aligning some of cache-v7.S code.
>>
>> My question is: is there a way to find out & force an optimal symbols
>> locations?
> 
> Take a look at CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B[0]. I've been
> fighting with the same issue on some Realtek MIPS boards: random
> code changes in random kernel core parts were affecting NAT /
> network performance. This option resolved this I'd say, for the cost
> of slightly increased vmlinux size (almost no change in vmlinuz
> size).
> The only thing is that it was recently restricted to a set of
> architectures and MIPS and ARM32 are not included now lol. So it's
> either a matter of expanding the list (since it was restricted only
> because `-falign-functions=` is not supported on some architectures)
> or you can just do:
> 
> make KCFLAGS=-falign-functions=64 # replace 64 with your I-cache size
> 
> The actual alignment is something to play with, I stopped on the
> cacheline size, 32 in my case.
> Also, this does not provide any guarantees that you won't suffer
> from random data cacheline changes. There were some initiatives to
> introduce debug alignment of data as well, but since function are
> often bigger than 32, while variables are usually much smaller, it
> was increasing the vmlinux size by a ton (imagine each u32 variable
> occupying 32-64 bytes instead of 4). But the chance of catching this
> is much lower than to suffer from I-cache function misplacement.

Thank you Alexander, this appears to be helpful! I decided to ignore
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B for now and just adjust CFLAGS
manually.


1. Without ce5013ff3bec and with -falign-functions=32
387 Mb/s

2. Without ce5013ff3bec and with -falign-functions=64
377 Mb/s

3. With ce5013ff3bec and with -falign-functions=32
384 Mb/s

4. With ce5013ff3bec and with -falign-functions=64
377 Mb/s


So it seems that:
1. -falign-functions=32 = pretty stable high speed
2. -falign-functions=64 = very stable slightly lower speed


I'm going to perform tests on more commits but if it stays so reliable
as above that will be a huge success for me.
