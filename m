Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480046348F7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiKVVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiKVVMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:12:31 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31726E9D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:12:27 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s5so22314586edc.12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LiJPTtNBXY5lhaOhCcN8eCHMZ+ykoBBHSWuDo0YtH9k=;
        b=8BzZEW+GpWjfoA2jDCk2XgBIuTqCXEYGhvtI2dMtEmXET/pY6ajsFLYPHWBdm6cjcS
         61XS1AhGNhsiazdY8jbmmyHVqZUsc5/O/fr7Rmv+9hcwva7P7QiAWNqABnyDjra5clXd
         Q3bdwZqPI5DvUGKgJXNkNTsNcgfUiByD8nQa7jMPaC9DSP8Dvv6DC6zSa7ZPPG9nb1+X
         jjZn22XEc/xuxpvP2T1kz5UJUUdBlpNN7X1wAV3EDXS5voMRjByT0mPATUx5OtJkBt4s
         HU9BwBKyy9QSmL/xoChZKGq7cBKgSscm80npAN+/qb9G4bA82Ooj/v7k/xg1Fkrzm90C
         8bWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LiJPTtNBXY5lhaOhCcN8eCHMZ+ykoBBHSWuDo0YtH9k=;
        b=BC6Rw/TyxLZ72rGDWKxrgDAfbzUiCXHb5vfNUumtveapkqr1PNE1tNX3NaiUDtP2ZF
         KMS3lfNFHPhdojusQPbkCYHFoFnRI/zlRt5qGKrDgQu1DmzXK2MVVMvDErMkfm9zXWWk
         zviDyi7VmO1pwgJBBWHHxYyx4dPyuTCbK19p5Tc/hxCCRCQxg/ANJgoiLstmEOI5LpeS
         SlZ+KD4W44uvAutfYQLgHkoQYs0BSG+G4v7xicMqy0N6ebavuk5Qb2IbhrNq5msGS8v/
         Vi35Xv6NPbK/gGfkxCLcSB/IjT2rnjPIrYyKvUcZbL82lH0gqX5VJtFc8rKeu3d4S8Gx
         fEyA==
X-Gm-Message-State: ANoB5plrZYlmkx7CA09aD7qqOEohTJUcVCN1dSbfgXq/KZTjHYb8JnOS
        kgl9jCU60FRYQo4Ke/ieLBXIlT5gte7rssS8
X-Google-Smtp-Source: AA0mqf7aknnAyeTvjcufOtAurfTLSW+/2fuCYb1DjvTp8y+EVrAzwEIb/u3mVWH5kO8i+BjjYEmmrg==
X-Received: by 2002:aa7:d799:0:b0:469:ede4:8219 with SMTP id s25-20020aa7d799000000b00469ede48219mr3919123edq.132.1669151545535;
        Tue, 22 Nov 2022 13:12:25 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id w18-20020a056402129200b00467c3cbab6fsm2739853edv.77.2022.11.22.13.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 13:12:25 -0800 (PST)
Message-ID: <0e7bb31c-ca92-dac2-4d29-5eb2d3327b26@blackwall.org>
Date:   Tue, 22 Nov 2022 23:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 2/2] bonding: fix link recovery in mode 2 when
 updelay is nonzero
Content-Language: en-US
To:     Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <cover.1668800711.git.jtoppins@redhat.com>
 <cb89b92af89973ee049a696c362b4a2abfdd9b82.1668800711.git.jtoppins@redhat.com>
 <38fbc36783d583f805f30fb3a55a8a87f67b59ac.camel@redhat.com>
 <1fe036eb-5207-eccd-0cb3-aa22f5d130ce@redhat.com>
 <5718ba71a8755040f61ed7b2f688b1067ca56594.camel@redhat.com>
 <e1150971-ec16-0421-a13a-d6d2a0a66348@redhat.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <e1150971-ec16-0421-a13a-d6d2a0a66348@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2022 17:37, Jonathan Toppins wrote:
> On 11/22/22 09:45, Paolo Abeni wrote:
>> On Tue, 2022-11-22 at 08:36 -0500, Jonathan Toppins wrote:
>>> On 11/22/22 05:59, Paolo Abeni wrote:
>>>> Hello,
>>>>
>>>> On Fri, 2022-11-18 at 15:30 -0500, Jonathan Toppins wrote:
>>>>> Before this change when a bond in mode 2 lost link, all of its slaves
>>>>> lost link, the bonding device would never recover even after the
>>>>> expiration of updelay. This change removes the updelay when the bond
>>>>> currently has no usable links. Conforming to bonding.txt section 13.1
>>>>> paragraph 4.
>>>>>
>>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>>
>>>> Why are you targeting net-next? This looks like something suitable to
>>>> the -net tree to me. If, so could you please include a Fixes tag?
>>>>
>>>> Note that we can add new self-tests even via the -net tree.
>>>>
>>>
>>> I could not find a reasonable fixes tag for this, hence why I targeted
>>> the net-next tree.
>>
>> When in doubt I think it's preferrable to point out a commit surely
>> affected by the issue - even if that is possibly not the one
>> introducing the issue - than no Fixes as all. The lack of tag will make
>> more difficult the work for stable teams.
>>
>> In this specific case I think that:
>>
>> Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")
>>
>> should be ok, WDYT? if you agree would you mind repost for -net?
>>
>> Thanks,
>>
>> Paolo
>>
> 
> Yes that looks like a good one. I will repost to -net a v2 that includes changes to reduce the number of icmp echos sent before failing the test.
> 
> Thanks,
> -Jon
> 

One minor nit - could you please change "mode 2" to "mode balance-xor" ?
It saves reviewers some grepping around the code to see what is mode 2.
Obviously one has to dig in the code to see how it's affected, but still
it is a bit more understandable. It'd be nice to add more as to why the link is not recovered,
I get it after reading the code, but it would be nice to include a more detailed explanation in the
commit message as well.

Thanks,
 Nik

