Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2523F4454E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfFMQnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:24 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39041 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbfFMGpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 02:45:05 -0400
Received: by mail-lf1-f68.google.com with SMTP id p24so14144597lfo.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 23:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R0IfDsjWsEWniMzX5vTmMT31F8tbMfvwkjStHp8GaZM=;
        b=R6tQrwn27wzsoGaSC0ymvLUmMKlJ6vAmfG24is72ND3CKt+HIH76CtCnu6I0KqWjCV
         Ss0YhtPsVWth7G0u6rL7o0ogS0590LNWW8t9DL+wRvCCGf3puRBAAS2CtvuxkkW88gDW
         QxYgy+qNQmfSgOAcx5i5ZRE2n7ziErO26K9aKTQcmTh2i8U3nQHXFGkmX5dOg+5ssTdE
         kdetX/PbOsKD4jj1Uj8HtzY5Gm747P18pTLIZZdOhyQu9UGQSL5zNsTIXCRHtS4zt54X
         ysrCzXOzHB5wz6IFMb4q6r0CRcVblPC5Aaj8AgOWn3IDr0PRQTOGQpJHgzh9QweXHJaS
         KDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R0IfDsjWsEWniMzX5vTmMT31F8tbMfvwkjStHp8GaZM=;
        b=Yv9tAVsVJA2toEG14dPEH61ygRGsorJZ75WV5bNbrcMCBiO5SSL9k7NR/syFHpR8BK
         Dl7CdKr5fXCnlTAIMHxyYX+a/02g+Stbw8G3APeEYa9nlbncSDZ77xpVFZy+a4mzsQoC
         bnDd3xyiv9U8j5PFkex6IsQWUo3oF81O3kCN/cnyluCbtYBhbNCiRoTaBUky3SpUDrvg
         06wu6HxO3QxoTDsk2G6Mj6jXflbaqPCU9OjVtJ+KKatKKTPTQU6NzyzarXC/EjbX3/OG
         8LSxrhwfxW5vX4GO0TsAefqTtyRtw3FSE9eJJoLkUPEWUfpIEz5/zLyomVHbWTAxfqaT
         IJaw==
X-Gm-Message-State: APjAAAVcRZq0mJihV+J6GtW7U7K5hEAWLMhXtiC8v0CDCSi47tZFT/EN
        1lee8nz2GSohFQqlx5WfdbzdGPYyjUk=
X-Google-Smtp-Source: APXvYqztOZhRwcKeF8xcSstPvMDXVToTiSXk4SlnqGZYZEe49+EOjfJvYWSCwhTi6GKbaBFR6JqEBQ==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr10142558lfd.33.1560408302177;
        Wed, 12 Jun 2019 23:45:02 -0700 (PDT)
Received: from [192.168.1.169] (h-29-16.A159.priv.bahnhof.se. [79.136.29.16])
        by smtp.gmail.com with ESMTPSA id r11sm430643ljh.90.2019.06.12.23.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 23:45:01 -0700 (PDT)
Subject: Re: [PATCH 1/1] Address regression in inet6_validate_link_af
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190611100327.16551-1-jonas@norrbonn.se>
 <58ac6ec1-9255-0e51-981a-195c2b1ac380@mellanox.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <833019dc-476f-f604-04a6-d77f9f86a5f4@norrbonn.se>
Date:   Thu, 13 Jun 2019 08:45:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <58ac6ec1-9255-0e51-981a-195c2b1ac380@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

On 12/06/2019 12:42, Maxim Mikityanskiy wrote:
> On 2019-06-11 13:03, Jonas Bonn wrote:
>> Patch 7dc2bccab0ee37ac28096b8fcdc390a679a15841 introduces a regression
>> with systemd 241.  In that revision, systemd-networkd fails to pass the
>> required flags early enough.  This appears to be addressed in later
>> versions of systemd, but for users of version 241 where systemd-networkd
>> nonetheless worked with earlier kernels, the strict check introduced by
>> the patch causes a regression in behaviour.
>>
>> This patch converts the failure to supply the required flags from an
>> error into a warning.
> The purpose of my patch was to prevent a partial configuration update on
> invalid input. -EINVAL was returned both before and after my patch, the
> difference is that before my patch there was a partial update and a warning.
> 
> Your patch basically makes mine pointless, because you revert the fix,
> and now we'll have the same partial update and two warnings.

Unfortunately, yes...

> 
> One more thing is that after applying your patch on top of mine, the
> kernel won't return -EINVAL anymore on invalid input. Returning -EINVAL
> is what happened before my patch, and also after my patch.

Yes, you're right, it would probably be better revert the entire patch 
because the checks in set_link_af have been dropped on the assumption 
that validate_link_af catches the badness.

> 
> Regarding the systemd issue, I don't think we should change the kernel
> to adapt to bugs in systemd. systemd didn't have this bug from day one,
> it was a regression introduced in [1]. The kernel has always returned
> -EINVAL here, but the behavior before my patch was basically a UB, and
> after the patch it's well-defined. If systemd saw EINVAL and relied on
> the UB that came with it, it can't be a reason enough to break the kernel.
> 
> Moreover, the bug looks fixed in systemd's master, so what you suggest
> is to insert a kernel-side workaround for an old version of software
> when there is a fixed one.

I agree, systemd is buggy here.  Probably what happens is:

i)  systemd tries to set the link up
ii)  it ends up doing a "partial" modification of the link state; 
critically, though, enough to actually effect the link state changing to UP
iii)  systemd sees the -EINVAL error and decides it probably failed to 
bring up the link
iv)  systemd then gets a notification that the link is up and runs a 
DHCP client on it

I haven't noticed any "partial modification" warnings in the kernel log 
but I wasn't looking for them, either...

With the new behaviour in 5.2, step ii) above results in no "partial 
modification" so the link remains down and systemd is forever unable to 
bring it up.

Anyway, for the record, the error is:

systemd:  Could not bring up interface... (invalid parameter)

And the solution is:  Linux >= 5.2 requires systemd != v241.

If nobody else notices, that's good enough for me.

> 
> Please correct me if anything I say is wrong.

Nothing wrong, but it's still a regression.

/Jonas

> 
> Thanks,
> Max
> 
> [1]:
> https://github.com/systemd/systemd/commit/0e2fdb83bb5e22047e0c7cc058b415d0e93f02cf
> 
>> With this, systemd-networkd version 241 once
>> again is able to bring up the link, albeit not quite as intended and
>> thereby with a warning in the kernel log.
>>
>> CC: Maxim Mikityanskiy <maximmi@mellanox.com>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
>> ---
>>    net/ipv6/addrconf.c | 3 ++-
>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index 081bb517e40d..e2477bf92e12 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -5696,7 +5696,8 @@ static int inet6_validate_link_af(const struct net_device *dev,
>>    		return err;
>>    
>>    	if (!tb[IFLA_INET6_TOKEN] && !tb[IFLA_INET6_ADDR_GEN_MODE])
>> -		return -EINVAL;
>> +		net_warn_ratelimited(
>> +			"required link flag omitted: TOKEN/ADDR_GEN_MODE\n");
>>    
>>    	if (tb[IFLA_INET6_ADDR_GEN_MODE]) {
>>    		u8 mode = nla_get_u8(tb[IFLA_INET6_ADDR_GEN_MODE]);
>>
> 
