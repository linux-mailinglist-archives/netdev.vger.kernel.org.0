Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168E03F03CB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhHRMhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhHRMhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:37:32 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043BCC061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:36:58 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t68so2741618qkf.8
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2tHTb7cLI429oojxYBNMTFkpw1Ju5TQ+mYg+aChvB8=;
        b=WXh+rqXNBBDVqbTUc1vTfIS+VHDfZdb0TTvRu8b0A1HCf1iocGUQeojx4AGoC7uYe3
         qPIst9y7avpqoF/ikkgZqjfOwud6w6sc0/bi7XL3G05h+wZEjuaq7hycSNDSmoZrUXPs
         JlGVqXwSSb6xcrarWKfT0XES5z53ffpVfMsgd5Y7FsTb0E94FqdxIv0Uk0T38N/2C9ja
         HFMtsrN8sl0ESad5i2uE38+es18sqLtUmbcf5zopEjm5CQDMgXig2tITdulWapHdKLh3
         IHw1u8O7V3BMKr/sSPG5u1O65xhuQ8CfGMhCxqdnyNsMMXxrm0i/uSerZ+SfOwVjg4Yq
         sMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2tHTb7cLI429oojxYBNMTFkpw1Ju5TQ+mYg+aChvB8=;
        b=SVYHP6QPZBzrOeN69dBoPq/dW7H801nweFY7boWYiNzUp/3Yr7YTheEhHO3tEsFnPu
         4fK/apcMQym11NbWHs61mX+V5DfWMq5qY0UF8RCx0ddxoUWxPUPaOKpQaZKgfa51Rxtu
         Tle1f97QqNyPb+hsp9DNWLsk1IQ/5XO6fWC07mHw5+/c4DJzSrcZ6j8XZyDU47VPygot
         TH1LrCrTklFe6b/KTa7fo2fhl49fJipKOOOnrzlQ9o/OuSJ2UwsHQIPd0mNYkQRuxc29
         LFPeQaq57pk9Os6GrfLw/2SKTUY7PaIFYPk97wp5CMyd9i2sjAjjDjiJA4/4xN/UeuDP
         zpTQ==
X-Gm-Message-State: AOAM533MFNJi3wpPLrLSNNc8HNLiMaUWyYg/lF9WS9fF5KOSIWhx3Gu5
        K4ol3xoZAw9U0iMVgnmkTrkalQ==
X-Google-Smtp-Source: ABdhPJwP1RIMwKWh/ArWnm519SWx5dv+0wWoit8V5ZIfR1MqtakLGvvC+qE5DvU5F+a0wdCIB5lK4A==
X-Received: by 2002:a05:620a:811:: with SMTP id s17mr9147537qks.350.1629290217188;
        Wed, 18 Aug 2021 05:36:57 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id d16sm2423409qte.3.2021.08.18.05.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:36:56 -0700 (PDT)
Subject: Re: [PATCH] flow_offload: action should not be NULL when it is
 referenced
To:     Ido Schimmel <idosch@idosch.org>, 13145886936@163.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20210626115606.1243151-1-13145886936@163.com>
 <YRz1297sFSjG7/Cc@shredder>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <d20577c8-e5df-a31d-8435-619994dd5855@mojatatu.com>
Date:   Wed, 18 Aug 2021 08:36:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YRz1297sFSjG7/Cc@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-18 7:58 a.m., Ido Schimmel wrote:
> On Sat, Jun 26, 2021 at 04:56:06AM -0700, 13145886936@163.com wrote:
>> From: gushengxian <gushengxian@yulong.com>
>>
>> "action" should not be NULL when it is referenced.
>>
>> Signed-off-by: gushengxian <13145886936@163.com>
>> Signed-off-by: gushengxian <gushengxian@yulong.com>
>> ---
>>   include/net/flow_offload.h | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index dc5c1e69cd9f..69c9eabf8325 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
>>   	if (flow_offload_has_one_action(action))
>>   		return true;
>>   
>> -	flow_action_for_each(i, action_entry, action) {
>> -		if (i && action_entry->hw_stats != last_hw_stats) {
>> -			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>> -			return false;
>> +	if (action) {
> 
> This patch generates a smatch warning:
> 
> include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn: variable dereferenced before check 'action' (see line 319)
> 
> Why the patch is needed? 'action' is already dereferenced in
> flow_offload_has_one_action()
> 

Yep, doesnt make sense at all.

cheers,
jamal
