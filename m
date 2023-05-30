Return-Path: <netdev+bounces-6367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3010A715F53
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFEB428115E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1364B1992B;
	Tue, 30 May 2023 12:29:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0418007
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:29:54 +0000 (UTC)
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF4107
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:29:40 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-33aa60f4094so10559665ab.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685449778; x=1688041778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=db7pOK2qWllgoSD+hdy9un8RIi8jDZibrX+vbM0TbcI=;
        b=E3f6YBkCcce5sNygYmsqPom7hQcebcWA4FKh0jB+WuU4bCUNTTiVDOQ4oYLgDlkbaa
         +RIM1noTWHCjhF2Ve3BVHBooqefxmRSfa04XfNOEIjU3UVbYw6PptOdhcb86Pft+JLK3
         zrKLc5jfK02NFqj8hKTzoDVR42EKfq9IpM1KCGtmLoFN0dwef3sDgsRdxDF6HWltZGWe
         OPUuAcdUCowRP1t2kwVk1JqpElJ0HUP7QDw1pp3ZXNAmPvcOsdM3Bj5JG6BfUKZA5GEC
         TjNm4TPYZRmP+WRzwsS0MRUcGlExjiaeAuIEI1y7C5GuR1ISYq9tEEE2/qvQJgjIBycC
         C9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685449778; x=1688041778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=db7pOK2qWllgoSD+hdy9un8RIi8jDZibrX+vbM0TbcI=;
        b=l76+hXtZ6EcglSsRRdQjL7EGwpYFbzySAi3wec9E/9psyVxCjiPvn3P2Ocqi8nkOtm
         QcdFzzynu7VI43abpvipFUEXqs0CruVD6Pce0X5XnMJNwR0vk2c7y89B5zl+L2/hCnhZ
         AiSgtodo+9WGotYq57boYH3+ZBG307Vsm9SeXMOxUCak3nAyrzHlSLMg0jnkCNip+sop
         HIlJZMFLq10LZyIsVVaEuA+XjpBZownQaMWj0CBEqEWCzjoG/fhklwYpRVaNfNxHQV1G
         5dnZHzBKQErefc7tdft+HZ3sIIYUlFWGeAKIfpug9iFSuxjT//OQp3OJ76KaRW4E/32K
         2WKw==
X-Gm-Message-State: AC+VfDxgWpzL6xrZSEJG5jh24UqdZ0q5FBMA6XpFXtgC2KNeT7vm7j/P
	xIdBPpKoSmUC8gw5aWwBBBqn0w==
X-Google-Smtp-Source: ACHHUZ6TM/HJSRb/wKW1p0GHS4HzM3dN4kBjO5DaLuSqMt0fzSDZPsxL+zNlyWRu2e+sQg2eZZRvHQ==
X-Received: by 2002:a92:d688:0:b0:331:107d:e96e with SMTP id p8-20020a92d688000000b00331107de96emr1311753iln.16.1685449777883;
        Tue, 30 May 2023 05:29:37 -0700 (PDT)
Received: from [172.22.22.28] ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g186-20020a025bc3000000b0041643b78cbesm707344jab.120.2023.05.30.05.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 05:29:37 -0700 (PDT)
Message-ID: <3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
Date: Tue, 30 May 2023 07:29:36 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
Content-Language: en-US
To: Bert Karwatzki <spasswolf@web.de>,
 Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
 <ZHWhEiWtEC9VKOS1@corigine.com>
 <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 4:10 AM, Bert Karwatzki wrote:
> Am Dienstag, dem 30.05.2023 um 09:09 +0200 schrieb Simon Horman:
>> On Sat, May 27, 2023 at 10:46:25PM +0200, Bert Karwatzki wrote:
>>> commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
>>> IPA_STATUS_SIZE as a replacement for the size of the removed struct
>>> ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use this
>>> as IPA_STATUS_SIZE.

This is better, however it really isn't done in a way that's
appropriate for a Linux kernel patch.  I will gladly help you
get it right if you have the patience for that.  But I'm not
going to say anything yet--until you say you want me to help
you do this.  If you prefer, I can submit the patch for you.

The reason this is important is your commit is permanent, and
just like code, commit messages are best if kept consistent
and readable.  I also am offering to help you understand so
you avoid any trouble next time you want to send a kernel patch.

Let me know what you prefer.

					-Alex

>>>
>>>>  From 0623148733819bb5d3648b1ed404d57c8b6b31d8 Mon Sep 17 00:00:00 2001
>>> From: Bert Karwatzki <spasswolf@web.de>
>>> Date: Sat, 27 May 2023 22:16:52 +0200
>>> Subject: [PATCH] Use the correct value for IPA_STATUS_SIZE.
>>> IPA_STATUS_SIZE
>>>   was introduced in commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c as a
>>>   replacment for the size of the removed struct ipa_status which had
>>> size =
>>>   sizeof(__le32[8]).
>>>
>>> Signed-off-by: Bert Karwatzki <spasswolf@web.de>
>>
>> Hi Bert,
>>
>> As well as the feedback provided by Jakub elsewhere in this
>> thread I think it would be useful to CC the author of the above mentioned
>> commit, Alex Elder <elder@linaro.org>. I have CCed him on this email.
>> Please consider doing likewise when you post v2.
>>
>> FWIIW, I did take a look.
>> And I do agree with your maths: struct ipa_status was 32 (= 8 x 4) bytes long.
>>
>>> ---
>>>   drivers/net/ipa/ipa_endpoint.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ipa/ipa_endpoint.c
>>> b/drivers/net/ipa/ipa_endpoint.c
>>> index 2ee80ed140b7..afa1d56d9095 100644
>>> --- a/drivers/net/ipa/ipa_endpoint.c
>>> +++ b/drivers/net/ipa/ipa_endpoint.c
>>> @@ -119,7 +119,7 @@ enum ipa_status_field_id {
>>>   };
>>>   
>>>   /* Size in bytes of an IPA packet status structure */
>>> -#define IPA_STATUS_SIZE                        sizeof(__le32[4])
>>> +#define IPA_STATUS_SIZE                        sizeof(__le32[8])
>>>   
>>>   /* IPA status structure decoder; looks up field values for a structure
>>> */
>>>   static u32 ipa_status_extract(struct ipa *ipa, const void *data,
>>> -- 
>>> 2.40.1
>>>
>>> Bert Karwatzki
> 
> Here is v2 of the patch, the first one was garbled by the linebreak setting of
> evolution.
> 
> From: Bert Karwatzki <spasswolf@web.de>
> Date: Tue, 30 May 2023 10:55:55 +0200
> Subject: [PATCH] IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a
>   replacement for the size of the removed struct ipa_status of size
>   sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.
> 
> Signed-off-by: Bert Karwatzki <spasswolf@web.de>
> ---
>   drivers/net/ipa/ipa_endpoint.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 2ee80ed140b7..afa1d56d9095 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -119,7 +119,7 @@ enum ipa_status_field_id {
>   };
>   
>   /* Size in bytes of an IPA packet status structure */
> -#define IPA_STATUS_SIZE			sizeof(__le32[4])
> +#define IPA_STATUS_SIZE			sizeof(__le32[8])
>   
>   /* IPA status structure decoder; looks up field values for a structure */
>   static u32 ipa_status_extract(struct ipa *ipa, const void *data,


