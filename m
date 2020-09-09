Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AFD263029
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgIIPES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729719AbgIIMMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 08:12:41 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D30DC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 05:04:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j2so2815648ioj.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 05:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=21n56gzCfDwIZ60Lp0c0iIzngmweNSj/vfWZjOJvv9E=;
        b=igWg3pgVHhH5d7dl2DaVXk/oViYWeMZGPCDmRaTL6fL/63vuT6GotTBlpTDSdSHPCl
         Rcl4c9VQvdsd7qer39/bJjfYhGnEQw6eLnQz5F9wkHSrhXY/EVQqpzYkyYIWXkn0CqUF
         zSNOAsLAlAgCx0wFZqQBNSVaNBmKiqwj/YCsw7o2YZ4Dkc9UQb7TP688Lciim883Q1Db
         jh4xkgFSkih4VV9yzyi40YfJ7nq2Ad5p6TC3opPS+4AAZVX5A77DK/OIhAHi3CblR9s/
         d6vvOhg/ZQpKJcSKpPPn6rJLj5nbY10xu/itkumAjhsqqLl8hdT44DFyLPn6zbvlEQGP
         e+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=21n56gzCfDwIZ60Lp0c0iIzngmweNSj/vfWZjOJvv9E=;
        b=VZC5V3mvBd42fyi/iI+MIEnSPjyc9YJOPX6hwkSGn8IfeZR1AHayXNHx7JFQzkVQL8
         v8H8y7P5KOm9IXNwJimZfxb0eoT+fEc5sIQkIGzrGTuwu6PFU4P+KrEfveuWMhyoWWRM
         NcIPeUk7DuZtIFhuxZTR4BVldyMmvU0WOmqpk6I1S2DGhY2zpuu8qPF3w8k0VCmm7kxv
         kCis/+565pUUFDKq2wbmQ5RExAvrBy0QoApLWUuXjnO/DqG5rfv0cVS9FpR143zpWUuS
         S8LwZ3mhc6WK+VSuLVqEO0RiyoVaBaRvWmpiG3MKoeAXU5p8UG76pXmraI6fSIf2dP6O
         Nlig==
X-Gm-Message-State: AOAM530otxvpZoht0y2zDYtJSozjLGh//ki2XD4rcvGHD2i9k60etQIh
        XHpvUYSETu58VDIA1h+7OuA34Q==
X-Google-Smtp-Source: ABdhPJy/Kc93n+U+E0l/9u8SoqOBHeGc8cY/hqW03il0FiTjpmXpYAKlaWdH/ICstpRNPtPrl+ii4w==
X-Received: by 2002:a05:6638:248d:: with SMTP id x13mr3791178jat.39.1599653092834;
        Wed, 09 Sep 2020 05:04:52 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p2sm1306539ili.75.2020.09.09.05.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 05:04:52 -0700 (PDT)
Subject: Re: [RFT net] net: ipa: fix u32_replace_bits by u32p_xxx version
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200908143237.8816-1-vadym.kochan@plvision.eu>
 <030185d3-8401-dd2f-8981-9dfe2239866a@linaro.org>
 <20200909120207.GA20411@plvision.eu>
From:   Alex Elder <elder@linaro.org>
Message-ID: <84ec1ad1-af3d-368b-f28a-137e577e9591@linaro.org>
Date:   Wed, 9 Sep 2020 07:04:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909120207.GA20411@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 7:02 AM, Vadym Kochan wrote:
> Hi Alex,
> 
> On Wed, Sep 09, 2020 at 06:53:17AM -0500, Alex Elder wrote:
>> On 9/8/20 9:32 AM, Vadym Kochan wrote:
>>> Looks like u32p_replace_bits() should be used instead of
>>> u32_replace_bits() which does not modifies the value but returns the
>>> modified version.
>>>
>>> Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
>>> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>>
>> You are correct!  Thank you for finding this.
>>
>> Your fix is good, and I have now tested it and verified it
>> works as desired.
>>
>> FYI, this is currently used only for the SDM845 platform.  It turns
>> out the register values (route and filter hash config) that are read
>> and intended to be updated always have value 0, so (fortunately) your
>> change has no effect there.
>>
> 
> I had such assumption that probably it works without the fix.
> 
>> Nevertheless, you have fixed this bug and I appreciate it.
>>
>> Reviewed-by: Alex Elder <elder@linaro.org>
>>
> 
> My understanding is that I need to re-submit this as an official patch
> without RFT/RFC prefix and with your reviewed tag ?

I hope David will accept it with my review, but if not maybe
he can answer your question.  Let's give him a chance to do
that, and if he hasn't responded within a day or two then
go ahead and send an updated version 2.

					-Alex

> Regards,
> Vadym Kochan
> 
>>> ---
>>> Found it while grepping of u32_replace_bits() usage and
>>> replaced it w/o testing.
>>>
>>>  drivers/net/ipa/ipa_table.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
>>> index 2098ca2f2c90..b3790aa952a1 100644
>>> --- a/drivers/net/ipa/ipa_table.c
>>> +++ b/drivers/net/ipa/ipa_table.c
>>> @@ -521,7 +521,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
>>>  	val = ioread32(endpoint->ipa->reg_virt + offset);
>>>  
>>>  	/* Zero all filter-related fields, preserving the rest */
>>> -	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
>>> +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
>>>  
>>>  	iowrite32(val, endpoint->ipa->reg_virt + offset);
>>>  }
>>> @@ -573,7 +573,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
>>>  	val = ioread32(ipa->reg_virt + offset);
>>>  
>>>  	/* Zero all route-related fields, preserving the rest */
>>> -	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
>>> +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
>>>  
>>>  	iowrite32(val, ipa->reg_virt + offset);
>>>  }
>>>
>>

