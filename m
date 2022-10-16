Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B865FFD2E
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 05:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJPDtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 23:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJPDt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 23:49:28 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD335103A;
        Sat, 15 Oct 2022 20:49:25 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id j6-20020a4ab1c6000000b004809a59818cso2265939ooo.0;
        Sat, 15 Oct 2022 20:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=czow1ipa103W49LbnWlq2qNcsuRw50/PJGnNo72V8l0=;
        b=a5m8EzP0VV9naavlGrtqVCCzKpYVN6BAsWdWU4lnhnA5yninROUIxw8jhEn1hvBf35
         Pnn+y9HQyR1ogM+nizq83BYFGHtap7C0mmiv8f1BMTd0ILPxcNSoIGENhUvl+4bCxtKz
         fy2hWF0shhZ0/nza3NJFwlMUuWrIv8nHez6csHrYY6XR80yyqEvF3/lOJry7iOfXdNd3
         OkHuso+XLfzg0i937ktFgYEaykK7A9IQ3Bme+LzO1kaeHm1DsnQ+GkSXXYI2bO2HNsYT
         gQQqwg3Zk77FPcYjGFZ0PsbHMwa6KJJRWNd30Eelvzu9nP7TkS8inslqyJt1IEz212CP
         09RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czow1ipa103W49LbnWlq2qNcsuRw50/PJGnNo72V8l0=;
        b=g0ohdiCgBvfMszF7qjzDphpEKuqoOKHk+dGCMEFYKZ0W1Lv3LMFkRjgjALZuWnoXDo
         kxU7ORe7KyebZSLqVcDacbrxtwQZ/LOFI132j+zckDTZXeboDkXiz8TT2hdV0W0AroV3
         rOGxMJiJ6BAnEssHklYiWUzJXuXMCjYM/uOyXS7/mnaR5TPn00O7MRrZPKDfNH/j+VMG
         wEJcEUFji9nNwEQK/PdxND5KUKxK614Gfh8sf5BtusncyPVGMV9/ziUSt6dhproOurnx
         9GHIIoc6yGoRQAg3MtTW/ciFf8P/PDxE5qGsHMv8oCmRXGcslzsOXapFLs+EuzKAQFME
         BwIQ==
X-Gm-Message-State: ACrzQf0B0p0O+YfEYeixEymUatfUM6Fwn7FoZytz+kSqteFv6DwUHyg1
        9+RzECDH0xLhSVnBdfQdfGQ=
X-Google-Smtp-Source: AMsMyM4/FlDNe/A5LhDZ4L9e8uIt4VogPrwTcK2fveqfeW9FJ+ylQRaj5VlSTuIwPOj0Xf/pFdvQtw==
X-Received: by 2002:a4a:4f84:0:b0:480:8515:ff8d with SMTP id c126-20020a4a4f84000000b004808515ff8dmr1922646oob.31.1665892164987;
        Sat, 15 Oct 2022 20:49:24 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p21-20020a0568301d5500b00661aaf69780sm3227113oth.10.2022.10.15.20.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Oct 2022 20:49:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3e3e23a4-574a-166f-78fe-9113abec4d6b@roeck-us.net>
Date:   Sat, 15 Oct 2022 20:49:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] Revert "cpumask: fix checking valid cpu range"
Content-Language: en-US
To:     Guo Ren <guoren@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
References: <20221015130548.3634468-1-guoren@kernel.org>
 <20221015165017.GA1034513@roeck-us.net>
 <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/22 19:58, Guo Ren wrote:
> On Sun, Oct 16, 2022 at 12:50 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Sat, Oct 15, 2022 at 09:05:48AM -0400, guoren@kernel.org wrote:
>>> From: Guo Ren <guoren@linux.alibaba.com>
>>>
>>> This reverts commit 78e5a3399421ad79fc024e6d78e2deb7809d26af.
>>>
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
>>>
>>> Let's back this out and retry with a larger clean up in -next.
>>>
>>
>> Unfortunately the revert triggers (or exposes ?) another backtrace.
> This should be fixed by another Revert patch.
> 
> https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60
> 
> Please have a try.
> 

Yes, I already tested that one and confirmed that it fixes the warning below.
Thanks for the pointer.

Guenter

>>
>> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x194/0x976
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-12199-g277163563de8 #1
>> Hardware name: riscv-virtio,qemu (DT)
>> epc : __netif_set_xps_queue+0x194/0x976
>> ra : __netif_set_xps_queue+0x3b0/0x976
>> epc : c089a664 ra : c089a880 sp : c2515c60
>> gp : c1d8e760 tp : c2578040 t0 : c364f980
>> t1 : 00000000 t2 : 00001fff s0 : c2515cd0
>> s1 : c2515ce4 a0 : c364f940 a1 : 00000000
>> a2 : c364f940 a3 : 00000000 a4 : c364f950
>> a5 : c364f890 a6 : 00000003 a7 : 00000000
>> s2 : 00000001 s3 : c1d382c0 s4 : 00000000
>> s5 : 00000000 s6 : 00000000 s7 : c364f880
>> s8 : 00000000 s9 : 00000001 s10: 00000001
>> s11: 00000000 t3 : 00000018 t4 : 7fd38a0e
>> t5 : 00000007 t6 : c3639470
>> status: 00000120 badaddr: 00000000 cause: 00000003
>> [<c074548a>] virtnet_set_affinity+0x13a/0x1a2
>> [<c07478de>] virtnet_probe+0x884/0xfdc
>> [<c063ce9a>] virtio_dev_probe+0x1d6/0x354
>> [<c0683d6e>] really_probe+0x82/0x214
>> [<c0683f58>] __driver_probe_device+0x58/0xa2
>> [<c0683fd2>] driver_probe_device+0x30/0xaa
>> [<c0684596>] __driver_attach+0x56/0x11c
>> [<c0681f26>] bus_for_each_dev+0x52/0x90
>> [<c06837c0>] driver_attach+0x1a/0x22
>> [<c068331a>] bus_add_driver+0x148/0x1b6
>> [<c0684d70>] driver_register+0x52/0xea
>> [<c063c924>] register_virtio_driver+0x1a/0x28
>> [<c0c2428e>] virtio_net_driver_init+0x7a/0xa6
>> [<c0002824>] do_one_initcall+0x5e/0x2e2
>> [<c0c01130>] kernel_init_freeable+0x298/0x306
>> [<c0aa0ac2>] kernel_init+0x1e/0x10e
>> [<c0003ad8>] ret_from_exception+0x0/0x10
>> irq event stamp: 106012
>> hardirqs last  enabled at (106011): [<c0aa9284>] _raw_spin_unlock_irqrestore+0x54/0x62
>> hardirqs last disabled at (106012): [<c0007534>] __trace_hardirqs_off+0xc/0x14
>> softirqs last  enabled at (105764): [<c0886392>] napi_get_frags_check+0x0/0x50
>> softirqs last disabled at (105758): [<c0886392>] napi_get_frags_check+0x0/0x50
>>
>> This is the result of commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
>> usage in netif_attrmask_next{,_and}").
>>
>> Guenter
> 
> 
> 

