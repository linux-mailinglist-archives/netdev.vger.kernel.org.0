Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09835BE7A0
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfIYViB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 17:38:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45212 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfIYViB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 17:38:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id q7so16583pgi.12;
        Wed, 25 Sep 2019 14:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZccWoHs0aZ7q3rRGAukQCFv+3XXyFmALCfYZzOtaP3U=;
        b=eL09BxT48UtYPUKD39Szei4FINUzf9IfnaIA+aXUeoEWEY0srk5x0jHyCWHCTryHRr
         e9McwamGNp4TbGVT36kh5Dt+LvRL3j1YMIS+Pa8NSf7UDMRQ/0sXYbmxPOUmpbkRPkyQ
         yoVAHKbZTAYTCeyoa5sdixdLxaK7u+ScgS/Oc+4512908PO842zTk2VPzRj/x+mZP3B7
         hF2u8f7DR/ScMj8ANUXqlfCSwcgwEFaOIljZjrGBLQuTfTQi62mEw+eSME/hOxO8vYxT
         l8x4WqkkfRIoJB0fPBxsV/jz51KeyO2QQBIQ4ZwNXZo/Hjtnh8kJbcTXrzExvWvUhvON
         V9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZccWoHs0aZ7q3rRGAukQCFv+3XXyFmALCfYZzOtaP3U=;
        b=BpFoPc3DaaeHyMYE6WqHMsZHIgzWpReczHnXxAP+IZ8vKvntGP/C79rD0hYA6gWdwa
         MNLRRwhz9MjAGeeUMvhaFqtfV9xljyUbkth6DzheC2Cx2tyBC9orEwkAf22OLeXSYu4R
         57xtQPjmJlCnMLDgXL6vs0ub+HYMgPH+DV8CBBg1YX3YmduvNgiGObxrLSeG5fgHwIMG
         BZj9eGHBIpHtWOn5Iu2VlWtb8SwpvWQoedAnzN9aqQCZ6UsrZEWyhIY4qFu4BBVfhLv0
         1H/OSLSUwsNtGihxnSjets2ulefLR898s1jaLVelN9YL5ptmttSOo/MNeBJpz42QD35N
         IRBA==
X-Gm-Message-State: APjAAAX3unXuqrIXanJKB46grLsk1PyNZI+xu4QTaoyfubMIstaKQAMN
        c+l//9cmvY1CE2AuIgtCqk0WBuWF
X-Google-Smtp-Source: APXvYqy5EC/MPkIuEx5ZvT6ACo/QPHTMP0hx/Lw8kMfRH8DToRdLOanXABcaXgVj2063J3WYqQTvqQ==
X-Received: by 2002:aa7:9d8e:: with SMTP id f14mr374658pfq.217.1569447480344;
        Wed, 25 Sep 2019 14:38:00 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j10sm36291pjn.3.2019.09.25.14.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 14:37:59 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Properly check reference count flag before taking
 reference
To:     Petr Vorel <pvorel@suse.cz>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190923144612.29668-1-Jason@zx2c4.com>
 <20190923150600.GA27191@dell5510>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <222450f1-d0ab-f7ac-5331-b631ef78ec15@gmail.com>
Date:   Wed, 25 Sep 2019 14:37:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923150600.GA27191@dell5510>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/19 8:06 AM, Petr Vorel wrote:
> Hi,
> 
>> People are reporting that WireGuard experiences erratic crashes on 5.3,
>> and bisected it down to 7d30a7f6424e. Casually flipping through that
>> commit I noticed that a flag is checked using `|` instead of `&`, which in
>> this current case, means that a reference is never incremented, which
>> would result in the use-after-free users are seeing. This commit changes
>> the `|` to the proper `&` test.
> 
>> Cc: stable@vger.kernel.org
>> Fixes: 7d30a7f6424e ("Merge branch 'ipv6-avoid-taking-refcnt-on-dst-during-route-lookup'")
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> 
> NOTE: this change was added in d64a1f574a29 ("ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic")
> 
> Kind regards,
> Petr
> 

This was fixed earlier I think

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=7b09c2d052db4b4ad0b27b97918b46a7746966fa

>> ---
>>  net/ipv6/ip6_fib.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
>> index 87f47bc55c5e..6e2af411cd9c 100644
>> --- a/net/ipv6/ip6_fib.c
>> +++ b/net/ipv6/ip6_fib.c
>> @@ -318,7 +318,7 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>>  	if (rt->dst.error == -EAGAIN) {
>>  		ip6_rt_put_flags(rt, flags);
>>  		rt = net->ipv6.ip6_null_entry;
>> -		if (!(flags | RT6_LOOKUP_F_DST_NOREF))
>> +		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
>>  			dst_hold(&rt->dst);
>>  	}
