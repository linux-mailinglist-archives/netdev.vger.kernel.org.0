Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0F529D4FC
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgJ1V4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgJ1V4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:56:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E603C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:56:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so555843pfp.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hap+Ub5ET72I9+yJ9o5LmuUNjxopHfjlnKViAW1U6ds=;
        b=E8UMKKnNfVfoVPWRxRIZe2XGK8Wd0g8Codg/3oRZgRD8PBpi07Bm2zfrdCw7rD3iAj
         7QYDllm35Oh5wFsMdy0li2VogCRHZnnoKPWvZjCHlWBNP8QoPRgKQpTxAyd3JpfL80wT
         aXlHCYIRDVxJikExiCN0dLG11bHWr01JGw0fCnAp98jgpibwVzNRTXJU0VBtM9/aJ2lg
         VQsvPGWq+f75kqb1M0Ra8ODkSoIfng2sQqknCP6pVB3fQbivxNjQ+HuWDOx06L60AiR5
         WuzGCQz6gsL9VKj9L15wkzTk/EYqRvbRIeL0znA+nsbjSEpgzm8uidthjfBG2hji1ouL
         ARag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hap+Ub5ET72I9+yJ9o5LmuUNjxopHfjlnKViAW1U6ds=;
        b=IWc3o79fXa6B5gKGaYKZsof58xjbY0Ngiw2pxvOiW9piLnUXZQKjsj2EHe2NVjERRR
         hqnBANj8yauDTJez2XMEiQIujUeKHU/8dXEBF7H0zpVZHIsRhBl0aYHo8k61zPDTnawb
         mSA9alcPcBzuAL5qW+QBGSv0pC6vF4miGpChdLyN2BjBpkLm0VMQWGv3NQkRSDNMQvdv
         0oMAQ2Ct4GutteYCnDWtci1by0qOQZWvtJoJNkA5rLIsFDjwpgqXvGQy/TnDDqnkje/S
         cnd5tPt7I3X5smP67vsOI5STYz257PiglcNVpnvS6HB/5VmQYZNHahUvA+khkaO5U3tr
         fy2g==
X-Gm-Message-State: AOAM5301XcGPEFMnXTcwnIHf3YbTd8zgnpyM+bkTM6Z6XRSDruE5Otcg
        PtO4S9bBzEkvfoUgLFrDbFV693bgq0Cx88tM
X-Google-Smtp-Source: ABdhPJy6tDn0bCbSbxNaCae/QqJmGCBHTiTy6idjHS0NT4WAZ8VfHjIxrrcVxhVG7OazqkIZOsGExw==
X-Received: by 2002:a92:d2ca:: with SMTP id w10mr984987ilg.140.1603889131208;
        Wed, 28 Oct 2020 05:45:31 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r4sm2632814ilj.43.2020.10.28.05.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 05:45:30 -0700 (PDT)
Subject: Re: [PATCH net 5/5] net: ipa: avoid going past end of resource group
 array
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, evgreen@chromium.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20201027161120.5575-1-elder@linaro.org>
 <20201027161120.5575-6-elder@linaro.org>
 <CA+FuTSdGCBG0tZXfPTJqTnV7zRNv2VmuThOydwj080NWw4PU9Q@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <95d20d91-d187-2638-6978-8c0ff752b49f@linaro.org>
Date:   Wed, 28 Oct 2020 07:45:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdGCBG0tZXfPTJqTnV7zRNv2VmuThOydwj080NWw4PU9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 7:14 PM, Willem de Bruijn wrote:
> On Tue, Oct 27, 2020 at 12:38 PM Alex Elder <elder@linaro.org> wrote:
>>
>> The minimum and maximum limits for resources assigned to a given
>> resource group are programmed in pairs, with the limits for two
>> groups set in a single register.
>>
>> If the number of supported resource groups is odd, only half of the
>> register that defines these limits is valid for the last group; that
>> group has no second group in the pair.
>>
>> Currently we ignore this constraint, and it turns out to be harmless,
> 
> If nothing currently calls it with an odd number of registers, is this
> a bugfix or a new feature (anticipating future expansion, I guess)?
> 
>> but it is not guaranteed to be.  This patch addresses that, and adds
>> support for programming the 5th resource group's limits.
>>
>> Rework how the resource group limit registers are programmed by
>> having a single function program all group pairs rather than having
>> one function program each pair.  Add the programming of the 4-5
>> resource group pair limits to this function.  If a resource group is
>> not supported, pass a null pointer to ipa_resource_config_common()
>> for that group and have that function write zeroes in that case.
>>
>> Fixes: cdf2e9419dd91 ("soc: qcom: ipa: main code")
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/net/ipa/ipa_main.c | 89 +++++++++++++++++++++++---------------
>>  1 file changed, 53 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
>> index 74b1e15ebd6b2..09c8a16d216df 100644
>> --- a/drivers/net/ipa/ipa_main.c
>> +++ b/drivers/net/ipa/ipa_main.c
>> @@ -370,8 +370,11 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
>>         u32 i;
>>         u32 j;
>>
>> +       /* We program at most 6 source or destination resource group limits */
>> +       BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
>> +
>>         group_count = ipa_resource_group_src_count(ipa->version);
>> -       if (!group_count)
>> +       if (!group_count || group_count >= IPA_RESOURCE_GROUP_SRC_MAX)
>>                 return false;
> 
> Perhaps more a comment to the previous patch, but _MAX usually denotes
> the end of an inclusive range, here 5. The previous name COUNT better
> reflects the number of elements in range [0, 5], which is 6.

I agree with your point, but the max here represents something different
from what you're expecting.

For a given resource type (source or destination) there is some fixed
number (count) of resources available based on the version of SoC.
The *driver* can handle any number of them up to the maximum number
(max) for any SoC it supports.  In that respect, it *does* represent
the largest value in an inclusive range.

I could change the suffix to something like SRC_COUNT_MAX, but in
general the symbol names are longer than I like in this driver and
I'm trying to shorten them where possible.

If you still want me to change this, please say so and tell me what
you suggest I use instead.

Your observation below about using ">" rather than ">=" is correct,
and applies here as well.  That error might have led you to make
your comment about "max" representing an inclusive maximum.

I will send out a new version of the series to fix that.  I'll
wait until later today to give some time for more feedback before
I prepare them.

Thanks a lot for reviewing this.

					-Alex

>>         /* Return an error if a non-zero resource limit is specified
>> @@ -387,7 +390,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
>>         }
>>
>>         group_count = ipa_resource_group_dst_count(ipa->version);
>> -       if (!group_count)
>> +       if (!group_count || group_count >= IPA_RESOURCE_GROUP_DST_MAX)
>>                 return false;
>>
>>         for (i = 0; i < data->resource_dst_count; i++) {
>> @@ -421,46 +424,64 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
>>
>>         val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
>>         val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
>> -       val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
>> -       val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
>> +       if (ylimits) {
>> +               val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
>> +               val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
>> +       }
>>
>>         iowrite32(val, ipa->reg_virt + offset);
>>  }
>>
>> -static void ipa_resource_config_src_01(struct ipa *ipa,
>> -                                      const struct ipa_resource_src *resource)
>> +static void ipa_resource_config_src(struct ipa *ipa,
>> +                                   const struct ipa_resource_src *resource)
>>  {
>> -       u32 offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
>> +       u32 group_count = ipa_resource_group_src_count(ipa->version);
>> +       const struct ipa_resource_limits *ylimits;
>> +       u32 offset;
>>
>> -       ipa_resource_config_common(ipa, offset,
>> -                                  &resource->limits[0], &resource->limits[1]);
>> -}
>> +       offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
>> +       ylimits = group_count == 1 ? NULL : &resource->limits[1];
>> +       ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
>>
>> -static void ipa_resource_config_src_23(struct ipa *ipa,
>> -                                      const struct ipa_resource_src *resource)
>> -{
>> -       u32 offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
>> +       if (group_count < 2)
>> +               return;
>>
>> -       ipa_resource_config_common(ipa, offset,
>> -                                  &resource->limits[2], &resource->limits[3]);
>> -}
>> +       offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
>> +       ylimits = group_count == 3 ? NULL : &resource->limits[3];
>> +       ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
>>
>> -static void ipa_resource_config_dst_01(struct ipa *ipa,
>> -                                      const struct ipa_resource_dst *resource)
>> -{
>> -       u32 offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
>> +       if (group_count < 4)
>> +               return;
>>
>> -       ipa_resource_config_common(ipa, offset,
>> -                                  &resource->limits[0], &resource->limits[1]);
>> +       offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
>> +       ylimits = group_count == 5 ? NULL : &resource->limits[5];
> 
> Due to the check
> 
>> +       if (!group_count || group_count >= IPA_RESOURCE_GROUP_DST_MAX)
>>                 return false;
> 
> above, group_count can never be greater than 5. Should be greater than?
> 

