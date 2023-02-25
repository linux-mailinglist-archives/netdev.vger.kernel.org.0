Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794696A2B69
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 20:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjBYTAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 14:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYTAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 14:00:00 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C177EEB50;
        Sat, 25 Feb 2023 10:59:56 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id r5so2836981qtp.4;
        Sat, 25 Feb 2023 10:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E10jt1KWt8WL3FzGY33XRX4lE4uuyqDdxIKH5Pzz/iY=;
        b=nW1LfqCY3neejLOYuKiJO9o283vbQHC25Mwy5kctDCFI+FCUVEluPauktoejLW/e85
         0M+GiVAHMyvQc1wDYKbPSYLpy5qj2DZMqLF96V48TO/cBXaD/Q9ArUfxYVRa0glIf6A5
         1B70U8EqBubgMe6GAJNX1I9taTLJbq+uD+AEuttsIHP7z3ryl1z6Twhd6tCc5H40Zgqm
         SJ+cozLhFKwS6Ght2K7ARRpaFqGhTje3nKjj2ImnDZcKEg6YjZfG3A3u4ZoypVdv1Anq
         39RiAL1sS5F+WITZFE1lDwXDcg3fxQcXZaY/VxCyrmjsgcgb+tdKwP9itKnP/LULLcbr
         6bSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E10jt1KWt8WL3FzGY33XRX4lE4uuyqDdxIKH5Pzz/iY=;
        b=DsBDkbslc+Z1iclJbg0u4JTEwKq6O1q27gkDbvh60m8tSstRxIyKGEpEHHicvX7gvZ
         UyGF97uBV68ygTZhxH7h/tocnEOb5Jr25Wxd6UrV/EWep79ZyIOqPgVg/uWitreDQQBb
         UqGg6vl7AtAoOOyDz/P5UE6x8oUUEGjLaMXjNyyb/CKj0quyUa0/6vvrqYRc9u3Tk7SB
         ndQeZiFohlqTUok63AClhURwJMCEqdO7xCFUYowsXB/wsYq09/0iGK6BEyuSQCeAu16C
         1RINI8+N8rLux5u5RqSAstJNvOrlsGDzfm8Ub9bLo3kCam2inrD8W6f/BgIItu5ul41q
         XSkA==
X-Gm-Message-State: AO0yUKXcfVhwEh8i0/UwMxqT3LMpXpIP3GqwDg621WTe9AhISeKeMQ8P
        JccdCrbmg4SY7ZGR+aOcYE8auRBt+mWStw==
X-Google-Smtp-Source: AK7set8TlERqsCl5RLNCRqUxfsIfB/ku6+9uhq+pL+DKYxyVcB3K3N7lzpJQcVTr4VcWRNvWVmTwrg==
X-Received: by 2002:a05:622a:38f:b0:3bd:f03:5f12 with SMTP id j15-20020a05622a038f00b003bd0f035f12mr30830921qtx.42.1677351595822;
        Sat, 25 Feb 2023 10:59:55 -0800 (PST)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id q4-20020a374304000000b007407157169fsm1605234qka.135.2023.02.25.10.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 10:59:55 -0800 (PST)
Message-ID: <68903a71-d86a-58ba-c253-eb6e5ab36dfd@gmail.com>
Date:   Sat, 25 Feb 2023 13:59:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 1/7] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-2-seanga2@gmail.com> <Y/o9tr8bV/eW4xOI@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y/o9tr8bV/eW4xOI@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/23 11:56, Simon Horman wrote:
> On Wed, Feb 22, 2023 at 04:03:49PM -0500, Sean Anderson wrote:
>> If we've tried regular autonegotiation and forcing the link mode, just
>> restart autonegotiation instead of reinitializing the whole NIC.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>>   drivers/net/ethernet/sun/sunhme.c | 12 +++++-------
>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index dd14114cbcfb..3eeda8f3fa80 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -589,7 +589,10 @@ static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
>>   	return 1;
>>   }
>>   
>> -static int happy_meal_init(struct happy_meal *hp);
>> +static void
>> +happy_meal_begin_auto_negotiation(struct happy_meal *hp,
>> +				  void __iomem *tregs,
>> +				  const struct ethtool_link_ksettings *ep);
> 
> I think it is preferable, though far more verbose, to move
> happy_meal_begin_auto_negotiation() before happy_meal_timer and avoid the
> need for a forward declaration. I did try this locally, and it did
> compile.

Fine by me.

--Sean

>>   static int is_lucent_phy(struct happy_meal *hp)
>>   {
>> @@ -743,12 +746,7 @@ static void happy_meal_timer(struct timer_list *t)
>>   					netdev_notice(hp->dev,
>>   						      "Link down, cable problem?\n");
>>   
>> -					ret = happy_meal_init(hp);
>> -					if (ret) {
>> -						/* ho hum... */
>> -						netdev_err(hp->dev,
>> -							   "Error, cannot re-init the Happy Meal.\n");
>> -					}
>> +					happy_meal_begin_auto_negotiation(hp, tregs, NULL);
>>   					goto out;
>>   				}
>>   				if (!is_lucent_phy(hp)) {
>> -- 
>> 2.37.1
>>

