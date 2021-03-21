Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349DA3433A8
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCURTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhCURTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:19:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A39C061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 10:19:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h1so12742378ilr.1
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 10:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=trd3bOQAuSxmemswUBJKTp+b88fg2ac3yQ5bfpCsI6I=;
        b=Ug03H1ZtqD2RF0P3tNq76X8in9uJZCVXfq+/rb82aqxHeSUy+jnJ1h6o5QVw2ceplP
         yEGZQ1GCnILtWoD1nOE/IKumvDKGeiq3QNIkdFsBHoAwvXr+EQO6M3r1RfKANWnpTIVk
         fwa8Ywv4/uKEXnr8WsG1ax0EjkEpzNfbxhy5l8+P4H3ynsW3Ck3WSVFbhQrXtdGr4l7N
         Jg2ZAHzSKWdTi2uhpc5xp+UmDrY6ESmW2uZKgW4GQ/+HMDD3uf+7lIGZ26qLAGOappoV
         7y40X+C2Iz85eKZffEqWMTH786+EC6hNcuomG1PeIPjfsGmT2+oZ22g+IBJyBAf/JEVV
         MbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=trd3bOQAuSxmemswUBJKTp+b88fg2ac3yQ5bfpCsI6I=;
        b=KJZ5c6AykkkYdWyQoGlfMGwUcN57JDmxPY0n0GHdoZWTv1X+0A/iTfDBEqlDZzOj+g
         7+/GDwM709ZtenprQ7IcHQcf79XNE111T1knicU3YfAaq/MFa8lFe4lnUA4TBezCnJC6
         Jti4GiC7++xb0pzXQqxOyg7tBbeZU4E3424pb4DPB9um2hwpsXY0+h5OdWx9E+ZoFWtn
         F4s5xd+bqoLrxHEPbhGyafbbBQF3S2uH5DeYqioyM0HRiIKQSVGmSYGkgVdC9eA0vLCB
         Q1U/OxJpZoR5M2C7THgCKysC0OpDRJ86hZzvCw0jr6/5b1ZYMYvbvpMyZLFkzDgNdU3i
         /glg==
X-Gm-Message-State: AOAM531gAleJVNGbwSnXzw1SaK8r+PMjlsolqUZ10qMM28rgVnKaHSWR
        LpwxIb9W0KEbBCdo7BShu4HFoA==
X-Google-Smtp-Source: ABdhPJyH+b8tBpFACR4h1flzXM5NNyQUAabLdDPKHvj5c8++3/du645cP7DvXxkGhwik76pqYqfYzA==
X-Received: by 2002:a05:6e02:c7:: with SMTP id r7mr8820894ilq.288.1616347144424;
        Sun, 21 Mar 2021 10:19:04 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id 14sm6607642ilt.54.2021.03.21.10.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 10:19:03 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org> <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org> <YFdO6UnWsm4DAkwc@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org>
Date:   Sun, 21 Mar 2021 12:19:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFdO6UnWsm4DAkwc@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 8:49 AM, Leon Romanovsky wrote:
> On Sun, Mar 21, 2021 at 08:21:24AM -0500, Alex Elder wrote:
>> On 3/21/21 3:21 AM, Leon Romanovsky wrote:
>>> On Sat, Mar 20, 2021 at 09:17:29AM -0500, Alex Elder wrote:
>>>> There are blocks of IPA code that sanity-check various values, at
>>>> compile time where possible.  Most of these checks can be done once
>>>> during development but skipped for normal operation.  These checks
>>>> permit the driver to make certain assumptions, thereby avoiding the
>>>> need for runtime error checking.
>>>>
>>>> The checks are defined conditionally, but not consistently.  In
>>>> some cases IPA_VALIDATION enables the optional checks, while in
>>>> others IPA_VALIDATE is used.
>>>>
>>>> Fix this by using IPA_VALIDATION consistently.
>>>>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> ---
>>>>   drivers/net/ipa/Makefile       | 2 +-
>>>>   drivers/net/ipa/gsi_trans.c    | 8 ++++----
>>>>   drivers/net/ipa/ipa_cmd.c      | 4 ++--
>>>>   drivers/net/ipa/ipa_cmd.h      | 6 +++---
>>>>   drivers/net/ipa/ipa_endpoint.c | 6 +++---
>>>>   drivers/net/ipa/ipa_main.c     | 6 +++---
>>>>   drivers/net/ipa/ipa_mem.c      | 6 +++---
>>>>   drivers/net/ipa/ipa_table.c    | 6 +++---
>>>>   drivers/net/ipa/ipa_table.h    | 6 +++---
>>>>   9 files changed, 25 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
>>>> index afe5df1e6eeee..014ae36ac6004 100644
>>>> --- a/drivers/net/ipa/Makefile
>>>> +++ b/drivers/net/ipa/Makefile
>>>> @@ -1,5 +1,5 @@
>>>>   # Un-comment the next line if you want to validate configuration data
>>>> -#ccflags-y		+=	-DIPA_VALIDATE
>>>> +# ccflags-y		+=	-DIPA_VALIDATION
>>>
>>> Maybe netdev folks think differently here, but general rule that dead
>>> code and closed code is such, is not acceptable to in Linux kernel.
>>>
>>> <...>
>>
>> What is the purpose of CONFIG_KGDB?  Or CONFIG_DEBUG_KERNEL?
>> Would you prefer I expose this through a kconfig option?  I
>> intentionally did not do that, because I really intended it
>> to be only for development, so defined it in the Makefile.
>> But I have no objection to making it configurable that way.
> 
> I prefer you to follow netdev/linux kernel rules of development.
> The upstream repository and drivers/net/* folder especially are not
> the place to put code used for the development.

How do I add support for new versions of the hardware as
it evolves?

What I started supporting (v3.5.1) was in some respects
relatively old.  Version 4.2 is newer, and the v4.5 and
beyond are for products that are relatively new on the
market.

Some updates to IPA (like 4.0+ after 3.5.1, or 4.5+
after 4.2) include substantial updates to the way the
hardware works.  The code can't support the new hardware
without being adapted and generalized to support both
old and new.

My goal is to get upstream support for IPA for all
Qualcomm SoCs that have it.  But the hardware design
is evolving; Qualcomm is actively developing their
architecture so they can support new technologies
(e.g. cellular 5G).  Development of the driver is
simply *necessary*.

The assertions I proposed and checks like this are
intended as an *aid* to the active development I
have been doing.

They may look like hacky debugging--checking errors
that can't happen.  They aren't that at all--they're
intended to the compiler help me develop correct code,
given I *know* it will be evolving.

But the assertions are gone, and I accept/agree that
these specific checks "look funny."  More below.

>>>> -#ifdef IPA_VALIDATE
>>>> +#ifdef IPA_VALIDATION
>>>>   	if (!size || size % 8)
>>>>   		return -EINVAL;
>>>>   	if (count < max_alloc)
>>>>   		return -EINVAL;
>>>>   	if (!max_alloc)
>>>>   		return -EINVAL;
>>>> -#endif /* IPA_VALIDATE */
>>>> +#endif /* IPA_VALIDATION */
>>>
>>> If it is possible to supply those values, the check should be always and
>>> not only under some closed config option.
>>
>> These are assertions.
>>
>> There is no need to test them for working code.  If
>> I run the code successfully with these tests enabled
>> exactly once, and they are satisfied, then every time
>> the code is run thereafter they will pass.  So I want
>> to check them when debugging/developing only.  That
>> way there is a mistake, it gets caught, but otherwise
>> there's no pointless argument checking done.
>>
>> I'll explain the first check; the others have similar
>> explanation.
>>
>> In the current code, the passed size is sizeof(struct)
>> for three separate structures.
>>   - If the structure size changes, I want to be
>>     sure the constraint is still honored
>>   - The code will break of someone happens
>>     to pass a size of 0.  I don't expect that to
>>     ever happen, but this states that requirement.
>>
>> This is an optimization, basically, but one that
>> allows the assumed conditions to be optionally
>> verified.
> 
> Everything above as an outcome of attempting to mix constant vs. run-time
> checks. If "size" is constant, the use of BUILD_BIG_ON() will help not only
> you but other developers to catch the errors too. The assumption that you alone
> are working on this code, can or can't be correct.

Right now I am the only one doing substantive development.
I am listed as the maintainer, and I trust anything more
than simple fixes will await my review before being
merged.

> If "size" is not constant, you should check it always.

To do that I might need to make this function (and others
like it) inline, or maybe __always_inline.  Regardless,
I generally agree with your suggestion of defensively
testing the argument value.  But this is an *internal
interface*.  The only callers are inside the driver.

It's basically putting the burden on the caller to verify
parameters, because often the caller already knows.

I think this is more of a philosophical argument than
a technical one.  The check isn't *that* expensive.

>>>>   	/* By allocating a few extra entries in our pool (one less
>>>>   	 * than the maximum number that will be requested in a
>>>> @@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>>>>   	dma_addr_t addr;
>>>>   	void *virt;
>>>> -#ifdef IPA_VALIDATE
>>>> +#ifdef IPA_VALIDATION
>>>>   	if (!size || size % 8)
>>>>   		return -EINVAL;
>>>>   	if (count < max_alloc)
>>>>   		return -EINVAL;
>>>>   	if (!max_alloc)
>>>>   		return -EINVAL;
>>>> -#endif /* IPA_VALIDATE */
>>>> +#endif /* IPA_VALIDATION */
>>>
>>> Same
>>>
>>> <...>
>>>
>>>>   {
>>>> -#ifdef IPA_VALIDATE
>>>> +#ifdef IPA_VALIDATION
>>>>   	/* At one time we assumed a 64-bit build, allowing some do_div()
>>>>   	 * calls to be replaced by simple division or modulo operations.
>>>>   	 * We currently only perform divide and modulo operations on u32,
>>>> @@ -768,7 +768,7 @@ static void ipa_validate_build(void)
>>>>   	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
>>>>   	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
>>>>   			field_max(AGGR_GRANULARITY_FMASK));
>>>> -#endif /* IPA_VALIDATE */
>>>> +#endif /* IPA_VALIDATION */
>>>
>>> BUILD_BUG_ON()s are checked during compilation and not during runtime
>>> like IPA_VALIDATION promised.
>>
>> So I should update the description.  But I'm not sure where
>> you are referring to.  Here is the first line of the patch
>> description:
>>   There are blocks of IPA code that sanity-check various
>>   values, at compile time where possible.
> 
> I'm suggesting to review if IPA_VALIDATION is truly needed.

*That* is a suggestion I can act on...

Right now, it's *there*.  These few patches were the beginning
of a side task to simplify and/or get rid of it.  The first
step is to get it so it's not fundamentally broken.  Then I
can work on getting rid of (or at least refactor) pieces.

The code I started with did lots of checks of these things
(including build-time checkable ones).  Many, many functions
needlessly returned values, just so these checks could be made.
The possibility of returning an error meant all callers had
to check for it, and that complicated things all the way up.

So I tried to gather such things into foo_validate() functions,
which just grouped these checks without having to clutter the
normal code path with them.  That way called functions could
have void return type, and calling functions would be simpler,
and so on.

So I guess to respond again to your comment, I really would
like to get rid of IPA_VALIDATION, or most of it.  As it is,
many things are checked with BUILD_BUG_ON(), but they need
not really be conditionally built.  That is a fix I intend
to make, but haven't yet.

But the code is there, and if I am going to fix it, I need
to do it with patches.  And I try to make my patches small
enough to be easily reviewable.

>>> IMHO, the issue here is that this IPA code isn't release quality but
>>> some debug drop variant and it is far from expected from submitted code.
>>
>> Doesn't sound very humble, IMHO.
> 
> Sorry about that.

I'd like to suggest a plan so I can begin to make progress,
but do so in a way you/others think is satisfactory.
- I would first like to fix the existing bugs, namely that
  if IPA_VALIDATION is defined there are build errors, and
  that IPA_VALIDATION is not consistently used.  That is
  this 2-patch series.
- I assure you that my goal is to simplify the code that
  does this sort of checking.  So here are some specific
  things I can implement in the coming weeks toward that:
    - Anything that can be checked at build time, will
      be checked with BUILD_BUG_ON().
    - Anything checked with BUILD_BUG_ON() will *not*
      be conditional.  I.e. it won't be inside an
      #ifdef IPA_VALIDATION block.
    - I will review all remaining VALIDATION code (which
      can't--or can't always--be checked at build time),
      If it looks prudent to make it *always* be checked,
      I will make it always be checked (not conditional
      on IPA_VALIDATION).
The result should clearly separate checks that can be done
at build time from those that can't.

And with what's left (especially on that third sub-bullet)
I might have some better examples with which to argue
for something different.  Or I might just concede that
you were right all along.

The IPA_VALIDATION stuff is a bit of an artifact of the
development process.  I want to make it better, and right
now it's upstream, so I have to do it in this forum.

>> This code was found acceptable and merged for mainline a
>> year ago.  At that time it supported IPA on the SDM845 SoC
>> (IPA v3.5.1).  Had it not been merged, I would have continued
>> refining the code out-of-tree until it could be merged.  But
>> now, it's upstream, so anything I want to do to make it better
>> must be done upstream.
> 
> The upstream just doesn't need to be your testing ground.

As I said, this is not how I view these checks, but
I understand why you're saying that.

Can you help me get closer to resolution?

Thank you for taking the time on this.  I have my
views on how I like to do things, but I really do
value your thoughts.

					-Alex

>> Since last year it has undergone considerable development,
>> including adding support for the SC7180 SoC (IPA v4.2).  I
>> am now in the process of getting things posted for review
>> so IPA versions 4.5, 4.9, and 4.11 are supported.  With any
>> luck all that will be done in this merge cycle; we'll see.
>>
>> Most of what I've been doing is gradually transforming
>> things to support the new hardware.  But in the process
>> I'm also improving what's there so that it is better
>> organized, more consistent, more understandable, and
>> maintainable.
>>
>> I have explained this previously, but this code was derived
>> from Qualcomm "downstream" code.  Much was done toward
>> getting it into the upstream kernel, including carving out
>> great deal of code, and removing functionality to focus on
>> just *one* target platform.
>>
>> Now that it's upstream, the aim is to add back functionality,
>> ideally to support all current and future Qualcomm IPA hardware,
>> and eventually (this year) to support some of the features
>> (hardware filtering/routing/NAT) that were removed to make
>> the code simpler.
>>
>> I'm doing a lot of development on this driver, yes.  But
>> it doesn't mean it's broken, it means it's improving.
> 
> It is not what I said.
> 
> I said "some debug drop variant" and all those validation and custom
> asserts for impossible flows are supporting my claim.
> 
> Thanks
> 
>>
>> 					-Alex
>>
>>> Thanks
>>>
>>

