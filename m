Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B43432B9
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCUNVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCUNV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:21:26 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A8CC061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 06:21:26 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n21so11097296ioa.7
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 06:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hm0j+eixmdl/zBGbDZFFjyplev8KCj4c3qDD2qAyoQs=;
        b=V/ixscQe0sYickdYafYCxUnh/2Wg3r3Kyt1ax2rsHdFYjKxFEtL1Yigz6Yy3+sevbf
         40Ljm4s4Lj0hWxjbWJsv4KE6IqBW/XUEuGxri3mLHwqH84HfoXPK7BQGZCn50UD/xW5h
         yvfxA87H8JZoLdthgmWjqoZgo2ntGO/akntDijcSlxws7ESsK5Kyb448Va5JtCzopUIE
         P+OG6EQUvkAfeO9Y5f442uUIeayOyprgRzizbr5hWrYOQS6kH6ppDhFhQzcGYzfa1mYF
         A2zHhIy6YSumTx/pTPzQvMR2dUjvcPjippnxFlyJLzOq+35HwKbWWzhWQsoM1WgAKnd7
         St9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hm0j+eixmdl/zBGbDZFFjyplev8KCj4c3qDD2qAyoQs=;
        b=j5HAuOJHhDc5SkJ+s+MJsIDK//koy1CeYZwvcRRvvg1jtBkNQwqq6JU31Sa7WP8oZ4
         CMFBitc3qRHjIyT7FNFPgdNVfzHkhvbPiKjwQAUjaWrmdsnyjH7dfrule18FcNJnFSvB
         c2g1xRpmeUHdUvxb32BhyEBUbAoxD3jUuzkIUX4dvMcl3pyi9VjSUUIn1g1kP3JijPNZ
         wda4Y3s/GmAVPfowfg+iR0QA8awO/oI+Xez6DirdctLZ6lgDC8DwGxTmZw6e8/KdloUx
         m5zSIv/NmNwi7moYGSyCptuVyfWjanHIzD/U+yOF4qBefoMyARD3GFinuOsiqdoJyr1A
         vpaw==
X-Gm-Message-State: AOAM530gfLhH3wMIy3CIvQbWPELXGxh7BCHBUKWznTbx8RepF98BH0f9
        Pn+6vyMEVgVhQpz3BIlAk8b7Dg==
X-Google-Smtp-Source: ABdhPJzTSIaTOGsDTz6OIRL0MW2Ke8IhzwQonnCZd184Eu0CItzu9pX11IIxJLZ2iGqZGQ1ajDH4EA==
X-Received: by 2002:a02:ccb2:: with SMTP id t18mr7732583jap.123.1616332885588;
        Sun, 21 Mar 2021 06:21:25 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b5sm5885325ioq.7.2021.03.21.06.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 06:21:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org> <YFcCAr19ZXJ9vFQ5@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
Date:   Sun, 21 Mar 2021 08:21:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFcCAr19ZXJ9vFQ5@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 3:21 AM, Leon Romanovsky wrote:
> On Sat, Mar 20, 2021 at 09:17:29AM -0500, Alex Elder wrote:
>> There are blocks of IPA code that sanity-check various values, at
>> compile time where possible.  Most of these checks can be done once
>> during development but skipped for normal operation.  These checks
>> permit the driver to make certain assumptions, thereby avoiding the
>> need for runtime error checking.
>>
>> The checks are defined conditionally, but not consistently.  In
>> some cases IPA_VALIDATION enables the optional checks, while in
>> others IPA_VALIDATE is used.
>>
>> Fix this by using IPA_VALIDATION consistently.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/Makefile       | 2 +-
>>   drivers/net/ipa/gsi_trans.c    | 8 ++++----
>>   drivers/net/ipa/ipa_cmd.c      | 4 ++--
>>   drivers/net/ipa/ipa_cmd.h      | 6 +++---
>>   drivers/net/ipa/ipa_endpoint.c | 6 +++---
>>   drivers/net/ipa/ipa_main.c     | 6 +++---
>>   drivers/net/ipa/ipa_mem.c      | 6 +++---
>>   drivers/net/ipa/ipa_table.c    | 6 +++---
>>   drivers/net/ipa/ipa_table.h    | 6 +++---
>>   9 files changed, 25 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
>> index afe5df1e6eeee..014ae36ac6004 100644
>> --- a/drivers/net/ipa/Makefile
>> +++ b/drivers/net/ipa/Makefile
>> @@ -1,5 +1,5 @@
>>   # Un-comment the next line if you want to validate configuration data
>> -#ccflags-y		+=	-DIPA_VALIDATE
>> +# ccflags-y		+=	-DIPA_VALIDATION
> 
> Maybe netdev folks think differently here, but general rule that dead
> code and closed code is such, is not acceptable to in Linux kernel.
> 
> <...>

What is the purpose of CONFIG_KGDB?  Or CONFIG_DEBUG_KERNEL?
Would you prefer I expose this through a kconfig option?  I
intentionally did not do that, because I really intended it
to be only for development, so defined it in the Makefile.
But I have no objection to making it configurable that way.

>> -#ifdef IPA_VALIDATE
>> +#ifdef IPA_VALIDATION
>>   	if (!size || size % 8)
>>   		return -EINVAL;
>>   	if (count < max_alloc)
>>   		return -EINVAL;
>>   	if (!max_alloc)
>>   		return -EINVAL;
>> -#endif /* IPA_VALIDATE */
>> +#endif /* IPA_VALIDATION */
> 
> If it is possible to supply those values, the check should be always and
> not only under some closed config option.

These are assertions.

There is no need to test them for working code.  If
I run the code successfully with these tests enabled
exactly once, and they are satisfied, then every time
the code is run thereafter they will pass.  So I want
to check them when debugging/developing only.  That
way there is a mistake, it gets caught, but otherwise
there's no pointless argument checking done.

I'll explain the first check; the others have similar
explanation.

In the current code, the passed size is sizeof(struct)
for three separate structures.
   - If the structure size changes, I want to be
     sure the constraint is still honored
   - The code will break of someone happens
     to pass a size of 0.  I don't expect that to
     ever happen, but this states that requirement.

This is an optimization, basically, but one that
allows the assumed conditions to be optionally
verified.

>>   	/* By allocating a few extra entries in our pool (one less
>>   	 * than the maximum number that will be requested in a
>> @@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>>   	dma_addr_t addr;
>>   	void *virt;
>>   
>> -#ifdef IPA_VALIDATE
>> +#ifdef IPA_VALIDATION
>>   	if (!size || size % 8)
>>   		return -EINVAL;
>>   	if (count < max_alloc)
>>   		return -EINVAL;
>>   	if (!max_alloc)
>>   		return -EINVAL;
>> -#endif /* IPA_VALIDATE */
>> +#endif /* IPA_VALIDATION */
> 
> Same
> 
> <...>
> 
>>   {
>> -#ifdef IPA_VALIDATE
>> +#ifdef IPA_VALIDATION
>>   	/* At one time we assumed a 64-bit build, allowing some do_div()
>>   	 * calls to be replaced by simple division or modulo operations.
>>   	 * We currently only perform divide and modulo operations on u32,
>> @@ -768,7 +768,7 @@ static void ipa_validate_build(void)
>>   	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
>>   	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
>>   			field_max(AGGR_GRANULARITY_FMASK));
>> -#endif /* IPA_VALIDATE */
>> +#endif /* IPA_VALIDATION */
> 
> BUILD_BUG_ON()s are checked during compilation and not during runtime
> like IPA_VALIDATION promised.

So I should update the description.  But I'm not sure where
you are referring to.  Here is the first line of the patch
description:
   There are blocks of IPA code that sanity-check various
   values, at compile time where possible.

> IMHO, the issue here is that this IPA code isn't release quality but
> some debug drop variant and it is far from expected from submitted code.

Doesn't sound very humble, IMHO.

This code was found acceptable and merged for mainline a
year ago.  At that time it supported IPA on the SDM845 SoC
(IPA v3.5.1).  Had it not been merged, I would have continued
refining the code out-of-tree until it could be merged.  But
now, it's upstream, so anything I want to do to make it better
must be done upstream.

Since last year it has undergone considerable development,
including adding support for the SC7180 SoC (IPA v4.2).  I
am now in the process of getting things posted for review
so IPA versions 4.5, 4.9, and 4.11 are supported.  With any
luck all that will be done in this merge cycle; we'll see.

Most of what I've been doing is gradually transforming
things to support the new hardware.  But in the process
I'm also improving what's there so that it is better
organized, more consistent, more understandable, and
maintainable.

I have explained this previously, but this code was derived
from Qualcomm "downstream" code.  Much was done toward
getting it into the upstream kernel, including carving out
great deal of code, and removing functionality to focus on
just *one* target platform.

Now that it's upstream, the aim is to add back functionality,
ideally to support all current and future Qualcomm IPA hardware,
and eventually (this year) to support some of the features
(hardware filtering/routing/NAT) that were removed to make
the code simpler.

I'm doing a lot of development on this driver, yes.  But
it doesn't mean it's broken, it means it's improving.

					-Alex

> Thanks
> 

