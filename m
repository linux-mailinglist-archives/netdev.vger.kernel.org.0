Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF36E341D08
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhCSMjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCSMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:38:28 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB60C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:38:28 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r193so5894756ior.9
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 05:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/OYjM5y8yFAlepuKq7x4/4B40LCocxmYgwfu/GJmmpg=;
        b=x+GSzA+Y1mAaSkxyrJPKoG7OFaOXgkf1VKgR9RKXFro+nsB6qaWKgPkK+P0lfWwEoE
         Rn2h1ca7nC6kNpQfLfCYwZ4oJbdvazJvlADlYHMlDvseHBPelCSqXMQjcw6HFnWqIt2i
         +5k1QcM8+itDEMTkFt7FZYm+uDNp5+KkwJPS+rVhwJ+2kqGVRbCD0df9qqlvr/U2WuHR
         LD2ZZRYCRmUqDmeodwLgtpJD5UYqK12671zYM0UlD6Ppg4C9gh/x6ONlKWq7fOgT+S7h
         wt4zgKGaZ602CClkRX9QO4PVtUMb/BDdtfy68DNt0m1p3gS8wrBgY8OXEAphXMWzdkOa
         VF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/OYjM5y8yFAlepuKq7x4/4B40LCocxmYgwfu/GJmmpg=;
        b=gyCfgLhh1tWLceCt6z7rmjjKZ7t7K4rDrhno3ydLijwxL+yihas3Wg+R3HVSQTyI44
         W0BUOfP7IRv4S4d4ZSSFVqOL36kuRDf9mjPKJPScAPiGP5lxCNCKsRjfNFmFdJE9TMwQ
         nnT9LdQQajagSwV7cW3vd16LWIkPrBPLjDmchWPodBdAJe+Ite5wxfkKMhximmU87v2J
         Y3vmlyoddzLaZEhWKaXONomKRtXhMi6qXen66CkaMsOfrSRHSAI2LtZfH1xxp6RDTWgn
         vkAJ69Lf2pLYMaTZ6FX92p4ZsGLxE8xmaVyUOdAHiXryyubbjjAa5/nRgk9gjKY816Q4
         SXnw==
X-Gm-Message-State: AOAM5331YReN4sTZtHUUnaGFk6y4iZWllZf4ACZnDZmW2HWgP+WP/UuP
        S2KYkPT2LDZQr3T4BJI6lLtjgA==
X-Google-Smtp-Source: ABdhPJzlo6dpHXc5S2xlwPkC3pmlfV7L8qXFY6jG7MvHygsFZ8rN5qckGsgevqiCDz6u+WY/328Meg==
X-Received: by 2002:a02:ca50:: with SMTP id i16mr1154633jal.5.1616157508147;
        Fri, 19 Mar 2021 05:38:28 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q12sm1849044ilm.63.2021.03.19.05.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 05:38:27 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: ipa: introduce ipa_assert()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-4-elder@linaro.org> <YFQurZjWYaolHGvR@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <edb7ab60-f0e2-8fc4-ca73-9614bb547ab5@linaro.org>
Date:   Fri, 19 Mar 2021 07:38:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFQurZjWYaolHGvR@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 11:55 PM, Leon Romanovsky wrote:
> On Thu, Mar 18, 2021 at 11:29:22PM -0500, Alex Elder wrote:
>> Create a new macro ipa_assert() to verify that a condition is true.
>> This produces a build-time error if the condition can be evaluated
>> at build time; otherwise __ipa_assert_runtime() is called (described
>> below).
>>
>> Another macro, ipa_assert_always() verifies that an expression
>> yields true at runtime, and if it does not, reports an error
>> message.
>>
>> When IPA validation is enabled, __ipa_assert_runtime() becomes a
>> call to ipa_assert_always(), resulting in runtime verification of
>> the asserted condition.  Otherwise __ipa_assert_runtime() has no
>> effect, so such ipa_assert() calls are effectively ignored.
>>
>> IPA assertion errors will be reported using the IPA device if
>> possible.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/ipa_assert.h | 50 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 50 insertions(+)
>>   create mode 100644 drivers/net/ipa/ipa_assert.h
>>
>> diff --git a/drivers/net/ipa/ipa_assert.h b/drivers/net/ipa/ipa_assert.h
>> new file mode 100644
>> index 0000000000000..7e5b9d487f69d
>> --- /dev/null
>> +++ b/drivers/net/ipa/ipa_assert.h
>> @@ -0,0 +1,50 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2021 Linaro Ltd.
>> + */
>> +#ifndef _IPA_ASSERT_H_
>> +#define _IPA_ASSERT_H_
>> +
>> +#include <linux/compiler.h>
>> +#include <linux/printk.h>
>> +#include <linux/device.h>
>> +
>> +/* Verify the expression yields true, and fail at build time if possible */
>> +#define ipa_assert(dev, expr) \
>> +	do { \
>> +		if (__builtin_constant_p(expr)) \
>> +			compiletime_assert(expr, __ipa_failure_msg(expr)); \
>> +		else \
>> +			__ipa_assert_runtime(dev, expr); \
>> +	} while (0)
>> +
>> +/* Report an error if the given expression evaluates to false at runtime */
>> +#define ipa_assert_always(dev, expr) \
>> +	do { \
>> +		if (unlikely(!(expr))) { \
>> +			struct device *__dev = (dev); \
>> +			\
>> +			if (__dev) \
>> +				dev_err(__dev, __ipa_failure_msg(expr)); \
>> +			else  \
>> +				pr_err(__ipa_failure_msg(expr)); \
>> +		} \
>> +	} while (0)
> 
> It will be much better for everyone if you don't obfuscate existing
> kernel primitives and don't hide constant vs. dynamic expressions.

I don't agree with this characterization.

Yes, there is some complexity in this one source file, where
ipa_assert() is defined.  But as a result, callers are simple
one-line statements (similar to WARN_ON()).

Existing kernel primitives don't achieve these objectives:
- Don't check things at run time under normal conditions
- Do check things when validation is enabled
- If you can check it at compile time, check it regardless
If there is something that helps me do that, suggest it because
I will be glad to use it.

> So any random kernel developer will be able to change the code without
> investing too much time to understand this custom logic.

There should be almost no need to change the definition of
ipa_assert().  Even so, this custom logic is not all that
complicated in my view; it's broken into a few macros that
are each pretty simple.  It was actuallyl a little simpler
before I added some things to satisfy checkpatch.pl.

> And constant expressions are checked with BUILD_BUG_ON().

BUILD_BUG_ON() is great.  But it doesn't work for
non-constant expressions.

Suppose I try to simplify ipa_assert() as:

    #define ipa_assert(dev, expr) \
	do { \
	    BUILD_BUG_ON(expr); \
	    __ipa_runtime_assert(dev, expr); \
	} while (0)

I can't do that, because BUILD_BUG_ON() evaluates the
expression, so I can't safely do that again in the called
macro.

I explained how I wanted it to work earlier, but the main
reason for doing this is to communicate to the reader
that the asserted properties are guaranteed to be true.
It can be valuable for making things understandable.
You don't have to wonder, "what if the value passed
is out of range?"  It won't be, and the assertion tells
you that.

> If you still feel need to provide assertion like this, it should be done
> in general code.

I could do that but I'm afraid it's more than I intend
to take on, and am not aware of anyone else asking for
a feature like this.  Do you want it?

I honestly appreciate your input, but I don't agree with
it.  I can do without codifying informative assertions
but I'd really like to be able to test them.

					-Alex

> Thanks
> 
>> +
>> +/* Constant message used when an assertion fails */
>> +#define __ipa_failure_msg(expr)	"IPA assertion failed: " #expr "\n"
>> +
>> +#ifdef IPA_VALIDATION
>> +
>> +/* Only do runtime checks for "normal" assertions if validating the code */
>> +#define __ipa_assert_runtime(dev, expr)	ipa_assert_always(dev, expr)
>> +
>> +#else /* !IPA_VALIDATION */
>> +
>> +/* "Normal" assertions aren't checked when validation is disabled */
>> +#define __ipa_assert_runtime(dev, expr)	\
>> +	do { (void)(dev); (void)(expr); } while (0)
>> +
>> +#endif /* !IPA_VALIDATION */
>> +
>> +#endif /* _IPA_ASSERT_H_ */
>> -- 
>> 2.27.0
>>

