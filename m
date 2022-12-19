Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93E465090D
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiLSJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiLSJGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:06:21 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27720A476
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:06:20 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id bp15so12645857lfb.13
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CRuvMnjZV42vUQNGodma6sGFsKhH8EEsTSMEdJ8pnZc=;
        b=g78QN//gba6WVeytf6dFJRn6b/QqefPUI+YMxbrtC/q1jWI/uaoLjGH5uyS/zt7drx
         fFZmdBf20jA16dTPh2DBfBO9BacVWc/GXkT46cYEvBUgNsdL2OHKtCZ8/BVqiYwB44Of
         9+uZtVMrCvoC9PjpDG9L4mMyniQFISJLgdCYbaE+IQcsOpngrDU6UvxOmt+18W/QXB29
         CPvAXKiTK8oGWSZE31oSyxt+ZJS205lgIbah57VS69lohcO7PibIQNYOxg7S0IlQL6qL
         IxFLPD2onOwybRKhbQS/1dSZUkU13OoCKvFdNARKUIWAl/ruNdVVpwc+XtK06HZEr/J1
         eMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRuvMnjZV42vUQNGodma6sGFsKhH8EEsTSMEdJ8pnZc=;
        b=qYL9dx+mtoF9RLnzvTegxzD4lO8T5gtfnsjUx2Mfp5gPzoik9roqgBNVL1UvzBugbd
         sOz9ntpORPuMJcTVLIrIWlD7v9keuVqHFfKhu9jr2UwY7Az/RlUVN8+H8HM1V8bMGl+l
         c4PK8sAydJpf4X2jyfY4qt/L50oFLyvUvj+84pmOt/hN8eI80FagklaDHDQmTsXHPu+J
         1m70y+OZX4aGQvPmE+gNW6fhyAub574ktTJ7S2gXIRDiW65PQ3mLOIAtMy/o+F5h5UND
         IcnRqTz75hism+LfK9EUtzjFSq/QA0H32P0dHc5Xp9bwQWqlSTuGJCWmWQP6IPMhe4/N
         QsFA==
X-Gm-Message-State: ANoB5pmxsfXoKPp2UyBZv/+DLyBgazHEKr+NigzsND3z7WX1V7bd0PDP
        GTnUETQRI8o3DIBBrg6akN9R6Q==
X-Google-Smtp-Source: AA0mqf4tucWR8FvIV0PjwY8hMQyLsVFH83QCGPpX+M2/P5muSqBBObrnmD/SWV92CabPEjKlE7uNYQ==
X-Received: by 2002:a05:6512:3c82:b0:4b5:5bc1:16da with SMTP id h2-20020a0565123c8200b004b55bc116damr14818241lfv.39.1671440778542;
        Mon, 19 Dec 2022 01:06:18 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id r14-20020ac24d0e000000b004aa0870b5e5sm1056337lfi.147.2022.12.19.01.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 01:06:18 -0800 (PST)
Message-ID: <bd44539b-b3fb-f88d-86f2-fbc3fa83c783@linaro.org>
Date:   Mon, 19 Dec 2022 10:06:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] nfc: st-nci: array index overflow in st_nci_se_get_bwi()
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Aleksandr Burakov <a.burakov@rosalinux.ru>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20221213141228.101786-1-a.burakov@rosalinux.ru>
 <5841f9021baf856c26fb27ac1d75fc1e29d3e044.camel@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5841f9021baf856c26fb27ac1d75fc1e29d3e044.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/12/2022 19:35, Alexander H Duyck wrote:
> On Tue, 2022-12-13 at 09:12 -0500, Aleksandr Burakov wrote:
>> Index of info->se_info.atr can be overflow due to unchecked increment
>> in the loop "for". The patch checks the value of current array index
>> and doesn't permit increment in case of the index is equal to
>> ST_NCI_ESE_MAX_LENGTH - 1.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
>> Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
>> ---
>>  drivers/nfc/st-nci/se.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
>> index ec87dd21e054..ff8ac1784880 100644
>> --- a/drivers/nfc/st-nci/se.c
>> +++ b/drivers/nfc/st-nci/se.c
>> @@ -119,10 +119,11 @@ static u8 st_nci_se_get_bwi(struct nci_dev *ndev)
>>  	/* Bits 8 to 5 of the first TB for T=1 encode BWI from zero to nine */
>>  	for (i = 1; i < ST_NCI_ESE_MAX_LENGTH; i++) {
>>  		td = ST_NCI_ATR_GET_Y_FROM_TD(info->se_info.atr[i]);
>> -		if (ST_NCI_ATR_TA_PRESENT(td))
>> +		if (ST_NCI_ATR_TA_PRESENT(td) && i < ST_NCI_ESE_MAX_LENGTH - 1)
>>  			i++;
>>  		if (ST_NCI_ATR_TB_PRESENT(td)) {
>> -			i++;
>> +			if (i < ST_NCI_ESE_MAX_LENGTH - 1)
>> +				i++;
>>  			return info->se_info.atr[i] >> 4;
>>  		}
>>  	}
> 
> Rather than adding 2 checks you could do this all with one check.
> Basically you would just need to replace:
>   if (ST_NCI_ATR_TB_PRESENT(td)) {
> 	i++;
> 
> with:
>   if (ST_NCI_ATR_TB_PRESENT(td) && ++i < ST_NCI_ESE_MAX_LENGTH)
> 
> Basically it is fine to increment "i" as long as it isn't being used as
> an index so just restricting the last access so that we don't
> dereference using it as an index should be enough.

These are different checks - TA and TB. By skipping TA, your code is not
equivalent. Was it intended?

Best regards,
Krzysztof

