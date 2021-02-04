Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208E930FAE9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbhBDSK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbhBDSJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:09:43 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12405C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:09:02 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id a7so4182000qkb.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dII9IIRXpw0+Sf1kJ+DC0cxApiP7JAi6pstgREz5soo=;
        b=cCthBWOJp4hPsOPGMOfY67BHO0hNO9037tGb3hhlxS1UD5C75DT05p5s6tVzOdtuuK
         mMDqC9LZtJf90+k5UwHVp44s8iKVGa1D2c9REn1RRTBOK1REUuk121z9mGP40HCCXEiA
         2hfwzbkoGM9FXJSScEapNSa9Dupe+N+KoDkMzPXg0PPPvIwGXoZJWeB2ZO2zevChiZKS
         WTCjyJeNYF7yu/tj/7JTcYwbGaaiVDkaqsGfTJQmzIeONu72O+QHGy0q/+AHI3eS36Y4
         MVzABqX+u6wXlBBAWFfNoK28IP+JeKBz0Vl6RtDSbJvAbbJxfkPWuywzHn5n59m07b4H
         HWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dII9IIRXpw0+Sf1kJ+DC0cxApiP7JAi6pstgREz5soo=;
        b=JQZXCCs1YLUENl+z9YFuxtZD3cH3C5j1HuViVW1l4+4w4MU+U/6FTtoDyCwaoanfj2
         nSoX5s70dNwQR/vWz9DsSde/uVY+Z1ciM80x5/ykDr6HsCEo9NfPmNcjTKvPNlzalldh
         G+12QMD5s2U9JI5/oy3a08R1wdVlbaWC+bMJSm1kDoW2eoZzGZ6BuJn2PHs7N+Cu2PmX
         79zxjQlBE3g9flgw35pmj7Wb+fmj/y5imRnB/eilTe388nSYPs2aHbdNa1r8sq7JHccU
         dnHeuimwxmEdPGPUtcom8zR7Xsv09S3bqNUMPZGOfEwTPfJuPC9ImSqsYnCz/9WLGLXO
         aGNA==
X-Gm-Message-State: AOAM531GGwc/OvubuOOKVNnpvJOrAwlaa+tdX22JP6XcRBT6ng14CIDq
        6HwQx031j+FCfAapkopsYA5eimJ+SB4aMw==
X-Google-Smtp-Source: ABdhPJwfOdFA0FEdK4efv53WisgHCrkEVagZECnR3jAyPaWYIymhhVNGDZqgRKZI9kHiFGjBhcrCbg==
X-Received: by 2002:ae9:ef01:: with SMTP id d1mr368534qkg.85.1612462141170;
        Thu, 04 Feb 2021 10:09:01 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id n24sm5074008qtv.26.2021.02.04.10.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:08:59 -0800 (PST)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
 <20210204140450.GS3158@orbyte.nwl.cc>
 <0cab775c-cd3c-f3a0-7680-570cc92eb96e@mojatatu.com>
 <20210204145006.GT3158@orbyte.nwl.cc>
 <7d5e31b1-0348-e617-0d3e-5acee7796361@mojatatu.com>
 <20210204165020.GU3158@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <109629bd-7762-d199-6965-172077f406b6@mojatatu.com>
Date:   Thu, 4 Feb 2021 13:08:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210204165020.GU3158@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-04 11:50 a.m., Phil Sutter wrote:
> On Thu, Feb 04, 2021 at 10:28:26AM -0500, Jamal Hadi Salim wrote:
>> On 2021-02-04 9:50 a.m., Phil Sutter wrote:
>>> On Thu, Feb 04, 2021 at 09:34:01AM -0500, Jamal Hadi Salim wrote:
>>>> On 2021-02-04 9:04 a.m., Phil Sutter wrote:
>>>>> Jamal,
>>>>>
>>>>> On Thu, Feb 04, 2021 at 08:19:55AM -0500, Jamal Hadi Salim wrote:
>>>>>> I couldnt tell by inspection if what used to work before continues to.
>>>>>> In particular the kernel version does consider the divisor when folding.
>>>>>
>>>>> That's correct. And so does tc. What's the matter?
>>>>>
>>>>
>>>> tc assumes 256 when undefined. Maybe man page needs to be
>>>> updated to state we need divisor specified otherwise default
>>>> is 256.
>>>
>>> tc-u32.8 mentions the default in 'sample' option description. Specifying
>>> divisor is mandatory when creating a hash table, so that path is
>>> covered, too. I still don't get how this is related to my patch, though.
>>>
>>
>> It is a general comment related to this code (that you are modifying).
>> You mentioned divisor in your earlier email as part of the syntax for
>> sample. So it made me wonder:
>> Does the bucket placement assume a specific number of buckets in a
>> table? Example if i had a hash table with 4 buckets, would the sample
>> then pick the correct bucket? Would it be also correct for 32 buckets,
>> etc. Or it didnt matter before and it doesnt matter now.
> 
> My patch doesn't change how divisor is applied. And yes, with a smaller
> than 256 buckets hash table, specifying the divisor along with sample is
> necessary.
> 

Sorry - hadnt looked at the man page earlier. I think the text added is
sufficient. I am wondering why we made the divisor optional to begin
with.

cheers,
jamal
