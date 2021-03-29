Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECCC34D92C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhC2Umn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhC2UmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:42:10 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34224C061574;
        Mon, 29 Mar 2021 13:42:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j9so12415447wrx.12;
        Mon, 29 Mar 2021 13:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YsyGDYfvXwEJDtWChaMM7lgQPGvMlpmnsSX15I+kaJU=;
        b=gq5ltCRyG/204YJ6mgRFKoCcplb1FAG7fPgKrj9s0BC7lIDU/bIQke5qmvRzdqwW43
         jgXbE8H6G86d5w+tMZgHP9hRic4nLK68VwhdFmc+5e19pJplTkuLTjkqi5VCz2LqG/V3
         C52kFXzkchR6OZh8jl9m9tItS981lVoxn0HMVBpIZ09ONkf9XvJTkWjzntj40ecELwyq
         cUBDUkl3Jl37SBe18WkOwqjHI/SyEfJWaC/zWMRfoEtRQZXm3zHL/J4ChU5RMNxhM2uC
         3GDxldMm3iYB/qsLb5P5EuPvxHmF+1nYg7ALKg2qXWT2OQJVRRBkSIPE0SL2dUxJKkHg
         XzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YsyGDYfvXwEJDtWChaMM7lgQPGvMlpmnsSX15I+kaJU=;
        b=OkwZFRYwJtOmaWIqsPzMR3K17gwVzN8mib16Vs3GbVqUWqA/422odunUicdydu4DDr
         iYfGrze/TRQkklB9O01WKR5aNy28LANNKa+HuvVW1wMmMeWcNJIirqmDI/AdImyWawfW
         HkfcS5goF+QOGdZsOwFdplGFeB2mKyQTCeO4kqeD7eu2yPaAVwU3dz3r43r/bSxHYWG+
         +ncLp9HA91YQBAJ8KG9+rQjxj1Nb9Ybh+0bLJPBXrgB8MJLGDY4cTYNo+erNPEoARw2P
         0RaARTrM98d9vd39ErU95HdUjhZTzIj66d0/tR8NJTUmXTHKvlF8Yb7tHmvcdb9RZD4o
         xMZA==
X-Gm-Message-State: AOAM533mIeQY83vFwu8nAnHAfsmaZeSNiAaACKkR8ZHO3b9E1jq8zokx
        w/QNEeRJFMx5Swm3BnGtTNc=
X-Google-Smtp-Source: ABdhPJyM5JkhN0/IBQC7lI2hStdvflNBUPMnix67gZGRbbzqlV+SFWDzOsfd2xkHYiyQ7pRORPvceg==
X-Received: by 2002:adf:e64d:: with SMTP id b13mr30457895wrn.204.1617050528949;
        Mon, 29 Mar 2021 13:42:08 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id 135sm540850wma.44.2021.03.29.13.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 13:42:08 -0700 (PDT)
Subject: Re: [syzbot] WARNING in xfrm_alloc_compat (2)
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        syzbot <syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <000000000000ceb65005beb18c8f@google.com>
 <06c56a34-b7c6-f397-568d-3cdf6b044858@arista.com>
 <a4f2d6c8-b4cf-c993-d0b4-952c16b2317d@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <e675bba0-b14d-1448-172e-e3ed66c2c9ef@gmail.com>
Date:   Mon, 29 Mar 2021 21:42:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <a4f2d6c8-b4cf-c993-d0b4-952c16b2317d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/21 9:31 PM, Eric Dumazet wrote:
> 
> 
> On 3/29/21 9:57 PM, Dmitry Safonov wrote:
[..]
>>> ------------[ cut here ]------------
>>> unsupported nla_type 356
>>
>> This doesn't seem to be an issue.
>> Userspace sent message with nla_type 356, which is > __XFRM_MSG_MAX, so
>> this warning is expected. I've added it so when a new XFRM_MSG_* will be
>> added, to make sure that there will be translations to such messages in
>> xfrm_compat.ko (if the translation needed).
>> This is WARN_ON_ONCE(), so it can't be used as DOS.
>>
>> Ping me if you'd expect something else than once-a-boot warning for
>> this. Not sure how-to close syzkaller bug, docs have only `invalid' tag,
>> which isn't `not-a-bug'/`expected' tag:
>> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
>>
> 
> You should not use WARN_ON_ONCE() for this case (if user space can trigger it)
> 
> https://lwn.net/Articles/769365/
> 
> <quote>
> Greg Kroah-Hartman raised the problem of core kernel API code that will use WARN_ON_ONCE() to complain about bad usage; that will not generate the desired result if WARN_ON_ONCE() is configured to crash the machine. He was told that the code should just call pr_warn() instead, and that the called function should return an error in such situations. It was generally agreed that any WARN_ON() or WARN_ON_ONCE() calls that can be triggered from user space need to be fixed. 
> </quote>

Yeah, fair enough, I've already thought after sending the reply that
WARN_ON*() prints registers and that may be unwanted.
I'll cook a patch to convert this and other WARNs in the module.

I wish there was something like pr_warn_backtrace_once(), but I guess
it's fine without dumpstack(), after all.

Thanks,
         Dmitry
