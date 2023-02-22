Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED11469FD7B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjBVVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjBVVHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:07:47 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44747408;
        Wed, 22 Feb 2023 13:07:20 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id w42so8938017qtc.2;
        Wed, 22 Feb 2023 13:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M6JRb2xlXQj/RRrO0uwKMW7L+mxBKNZwN1+yHQmPmUE=;
        b=pbQSamF14WH+da0JGNN5z+VAwcCRJR9v6B6/asOVRtKGgHRu7LEEuxxKUUVkD1NCE3
         B95d1uLOYZzWrt3+hVwwcwb9eYvWMexSsJMyzxU6T350DR2FWhmZQhFTI/NcGw7txWCp
         0vUvQJQWsI/sFjunobfDYjLRi+mk0TYM+IO/GpY2f7UXxZKF+syD6NV+goS8qdYiMCYw
         ss365axFoNaHRc/PtZt8cO4DI/5+xUCvtfPYd8Sg+9C0aPe1PWjG+fVJmTwlta2l7L+Z
         Tuu/M4CSf3EKue9XteZXWertyFwFWY85eqlCjy4nxJm1jK/hKTgX55tvpiQk72+fbyvt
         87Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M6JRb2xlXQj/RRrO0uwKMW7L+mxBKNZwN1+yHQmPmUE=;
        b=0fuZd6i42SUUX7bwUHWbttL+4WA9zHHQRvhl5ZewksOeave3PxI9ix4Z5ejZg77xOY
         mdzu57CBDl85jG5LZOX4I+NQUvGJCid452+PQMEu8wMqoILLLfrfRZ2YxI6sz2hn/Gf3
         0acq6QUHMN6LbzP4nTZW1JMfpJrWiHMzReREUisJ6BjKpY5z2ffU4+zlS931kezJWy8f
         1/DtW8y/S+a3StqzMY6WDmoOJ7aDXZN3FGGQ7WNVM1Qutl4yH5WVT80DfThICxn2qvJG
         iHB+uR5sz9RSWdXJNo+iAc/h1bbucrYkyIu2u+lEf1SYjFgtGmBYuxNu5GdYHjq+UtJy
         vqyQ==
X-Gm-Message-State: AO0yUKWKz4JyZHfGLici0ElOxA33I+oW4kUnvIiKNQf0tiBGwQ8pWk5o
        vnTfV75EHhgYG0p26oSaW2M=
X-Google-Smtp-Source: AK7set9vPSu5tbODFDwrVaNryqyr+xbbtE7FlTl1RH9DwsPCWbgw/ARkk8nAvShfPRliysADO3ZlrQ==
X-Received: by 2002:a05:622a:1447:b0:3b9:ba24:4f38 with SMTP id v7-20020a05622a144700b003b9ba244f38mr19251709qtx.56.1677100037417;
        Wed, 22 Feb 2023 13:07:17 -0800 (PST)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id 129-20020a370687000000b007423ccd892csm964323qkg.47.2023.02.22.13.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:07:16 -0800 (PST)
Message-ID: <ef539bfa-d9f7-5977-03f4-1fcf20c7ef65@gmail.com>
Date:   Wed, 22 Feb 2023 16:07:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: sunhme: Return an error when we are out of slots
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
References: <20230222170935.1820939-1-seanga2@gmail.com>
 <Y/aCNSlx2p62iDYk@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y/aCNSlx2p62iDYk@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/23 15:59, Simon Horman wrote:
> On Wed, Feb 22, 2023 at 12:09:35PM -0500, Sean Anderson wrote:
>> We only allocate enough space for four devices when the parent is a QFE. If
>> we couldn't find a spot (because five devices were created for whatever
>> reason), we would not return an error from probe(). Return ENODEV, which
>> was what we did before.
>>
>> Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
> 
> I think the hash for that commit is acb3f35f920b.

Ah, sorry that's my local copy. The upstream commit is as you noted.

> 
> However, I also think this problem was introduced by the first hunk of
> 5b3dc6dda6b1 ("sunhme: Regularize probe errors").
> 
> Which is:
> 
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2945,7 +2945,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   	if (err)
>   		goto err_out;
>   	pci_set_master(pdev);
> -	err = -ENODEV;
>   
>   	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
>   		qp = quattro_pci_find(pdev);
> 

Yes. That's the one I should have blamed.

> Which leads me to wonder if simpler fixes would be either:
> 
> 1) Reverting the hunk above
> 2) Or, more in keeping with the rest of that patch,
>     explicitly setting err before branching to err_out,
>     as you your patch does, but without other logic changes.

>     Something like this (*compile tested only!*:
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 1c16548415cd..2409e7d6c29e 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2863,8 +2863,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   			if (!qp->happy_meals[qfe_slot])
>   				break;
>   
> -		if (qfe_slot == 4)
> +		if (qfe_slot == 4) {
> +			err = -ENOMEM;
>   			goto err_out;
> +		}
>   	}
>   
>   	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));

That's of course simpler, but this also does some cleanup to make it more
obvious what's going on.

> Also, I am curious why happy_meal_pci_probe() doesn't just return instaed
> of branching to err_out. As err_out only returns err.  I guess there is a
> reason for it. But simply returning would probably simplify error handling.
> (I'm not suggesting that approach for this fix.)

I think it's because there used to be cleanup in err_out. But you're right,
we can just return directly and avoid a goto.

--Sean

>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <error27@gmail.com>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
>> ---
>>
>>   drivers/net/ethernet/sun/sunhme.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
>> index 1c16548415cd..523e26653ec8 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2861,12 +2861,13 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>>   
>>   		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
>>   			if (!qp->happy_meals[qfe_slot])
>> -				break;
>> +				goto found_slot;
>>   
>> -		if (qfe_slot == 4)
>> -			goto err_out;
>> +		err = -ENODEV;
>> +		goto err_out;
>>   	}
>>   
>> +found_slot:
>>   	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
>>   	if (!dev) {
>>   		err = -ENOMEM;
>> -- 
>> 2.37.1
>>

