Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980515BCE42
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiISOOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiISOOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:14:38 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E5FD3C;
        Mon, 19 Sep 2022 07:14:37 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id i3so15831258qkl.3;
        Mon, 19 Sep 2022 07:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=y29nOjjE0WdGENdKB5VrsUJIzw7HpcrkvaNq9Rldol0=;
        b=NSzXi5cwKPoLbx17l7nM7lkVqW0fSNqt6xEcU1FJdKLrgaRNKgocf4h9h05ebjaL/g
         fIs+Kpi8n7dEVlwb4epyjFe+gBoYPi3HIVFM7DhapIvcp+TlcEj6PRidBtwojDUSjLLR
         IHKDwLv9lzzun2gpv/osSxSTQvqGk5WfNW98qVtYmI0Wdk7/xyhCLNnpZissc+DAdApj
         Dd7E6/kvtPlthyUZBhidRosdJynO+z2yCNwhRy916B+Lp8L8m0S4ROsjRFE0Sm+cwopC
         klnwL1o21qcVJ6cWONhWxYiZeH3rl4NNGfp6W1zd6UQCjHe8oRiSbfuvpa+PrTYrrNPl
         UR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=y29nOjjE0WdGENdKB5VrsUJIzw7HpcrkvaNq9Rldol0=;
        b=0KE0sMI6UGb8+Od+SLPyqguc7dYEI6nyvpIavVjAQMEa9LPpbtIeW6kqP95FKJXIvr
         YFeL6GRCakE6CqGKO8MKTvzbLbQOVJ4gVFPvYq7Cu5yPxuBc0ucJW+MrntaewwwbKsuw
         1IzHjl+pGvnb9pfmQwWEQyGqdoEphaQepkhiGuFnxkLdnoyaAWgt46akaUwmATdFNvDp
         BIBE+l8BetBRW6ugw2TX3HzTrZEPgZCA52O5uRrXlmp3YEk5EI+7beHxwcxiOI2V96zH
         WsJY4EgzEo2qPHtiychdYd7uT/zczAUOQF8Coot+9xwsdVD8R/SJ1pk3PjzGmniR+K4F
         3bXw==
X-Gm-Message-State: ACrzQf2m9jBR0gSmsPvqhXHSOAf8Pmo8+1+D0W7FVnBPyWhsAiwYeYbn
        FoWMjNRIzbimcYc8JZpKJHQ=
X-Google-Smtp-Source: AMsMyM4gveLiWAaqvLci47PbACdG11Fhi19tMQGDyUhlp4016ZHrh3pI5rQlJMvZRLGcIjR0pHIPog==
X-Received: by 2002:a05:620a:4807:b0:6cf:55d:e4c3 with SMTP id eb7-20020a05620a480700b006cf055de4c3mr3968308qkb.563.1663596876017;
        Mon, 19 Sep 2022 07:14:36 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id t13-20020a37ea0d000000b006ce60296f97sm101724qkj.68.2022.09.19.07.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 07:14:35 -0700 (PDT)
Message-ID: <cf05390e-a69b-ad34-8c61-c5e9bbdaf5e3@gmail.com>
Date:   Mon, 19 Sep 2022 10:14:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 11/13] sunhme: Combine continued messages
Content-Language: en-US
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>
References: <20220918232626.1601885-1-seanga2@gmail.com>
 <20220918232626.1601885-12-seanga2@gmail.com>
 <14992029.3CObj9AJNb@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <14992029.3CObj9AJNb@eto.sf-tec.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 09:23, Rolf Eike Beer wrote:
> Am Montag, 19. September 2022, 01:26:24 CEST schrieb Sean Anderson:
>> This driver seems to have been written under the assumption that messages
>> can be continued arbitrarily. I'm not when this changed (if ever), but such
>> ad-hoc continuations are liable to be rudely interrupted. Convert all such
>> instances to single prints. This loses a bit of timing information (such as
>> when a line was constructed piecemeal as the function executed), but it's
>> easy to add a few prints if necessary. This also adds newlines to the ends
>> of any prints without them.
> 
> I have a similar patch around, but yours catches more places.
> 
>> diff --git a/drivers/net/ethernet/sun/sunhme.c
>> b/drivers/net/ethernet/sun/sunhme.c index 98c38e213bab..9965c9c872a6 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -330,7 +331,6 @@ static int happy_meal_bb_read(struct happy_meal *hp,
>>   	int retval = 0;
>>   	int i;
>>
>> -	ASD("happy_meal_bb_read: reg=%d ", reg);
>>
>>   	/* Enable the MIF BitBang outputs. */
>>   	hme_write32(hp, tregs + TCVR_BBOENAB, 1);
> 
> You can remove one of the empty lines here.

OK

>> @@ -1196,15 +1182,15 @@ static void happy_meal_init_rings(struct happy_meal
>> *hp) struct hmeal_init_block *hb = hp->happy_block;
>>   	int i;
>>
>> -	HMD("happy_meal_init_rings: counters to zero, ");
>> +	HMD("counters to zero\n");
>>   	hp->rx_new = hp->rx_old = hp->tx_new = hp->tx_old = 0;
>>
>>   	/* Free any skippy bufs left around in the rings. */
>> -	HMD("clean, ");
>> +	HMD("clean\n");
> 
> I don't think this one is actually needed, there isn't much than can happen in
> between these 2 prints.

OK

>> @@ -1282,17 +1268,11 @@ happy_meal_begin_auto_negotiation(struct happy_meal
>> *hp, * XXX so I completely skip checking for it in the BMSR for now. */
>>
>> -#ifdef AUTO_SWITCH_DEBUG
>> -		ASD("%s: Advertising [ ");
>> -		if (hp->sw_advertise & ADVERTISE_10HALF)
>> -			ASD("10H ");
>> -		if (hp->sw_advertise & ADVERTISE_10FULL)
>> -			ASD("10F ");
>> -		if (hp->sw_advertise & ADVERTISE_100HALF)
>> -			ASD("100H ");
>> -		if (hp->sw_advertise & ADVERTISE_100FULL)
>> -			ASD("100F ");
>> -#endif
>> +		ASD("Advertising [ %s%s%s%s]\n",
>> +		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
>> +		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
>> +		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
>> +		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " :
> "");
>>
>>   		/* Enable Auto-Negotiation, this is usually on
> already... */
>>   		hp->sw_bmcr |= BMCR_ANENABLE;
> 
> Completely independent of this driver, but I wonder if there is no generic
> function to print these 10/100/* full/half duplex strings? There are several
> drivers doing this as a quick grep shows.

There's some functions to print just one link mode, but I think generally the
full advertising word is printed in debugs. I'm not too worried since this is
just for debug.

One of my goals is to convert this driver to phylib, but I haven't dived very
deep into it.

--Sean
