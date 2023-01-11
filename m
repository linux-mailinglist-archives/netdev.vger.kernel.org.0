Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56700665854
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbjAKJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbjAKJ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:56:58 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D79BA5;
        Wed, 11 Jan 2023 01:54:25 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id y25so22681931lfa.9;
        Wed, 11 Jan 2023 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=plPA7numXSMIevYBGv3jTp9r4/qWe6lfogjrVU3jpVE=;
        b=bfdQtXmw6Le6iVD4QMNn4bzk7pkbJfFKWCuFlRBg850zP73YHdU4QZ7FtIW4txtkuv
         tuxQvUx/aDBdeUcQntRHGhZFG4IDs5G+IzXeweIr3++Nfkn2n5S4IHRz8dIGWjCqoT8R
         RB3KeTBd9UGj/B38DBwvpHKg+Xxdwl4/vtKhXqwnb+IrH75RFxxr3kSyiShva1X02mzr
         Ixr/i0jWXHYgCCfR/8/aW74qT1FZIAiIchPhEmJcC0PsrvxHn12wkimY4veIC3Lybo9W
         +4mn+0XizNnbc8Ojt+Yv7u2tCA5kPq8JeqLEWLRtGDzws4BcnnigiaDRiUovffWnjhCC
         b+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=plPA7numXSMIevYBGv3jTp9r4/qWe6lfogjrVU3jpVE=;
        b=BpXqUxNSgI9zwpMxtSnbenQt0WPAVvnK4bRYa3YPoyJlvRHqTwGPIzWbsPKGBh29na
         MuMj5Rgxw71Wz7W0rysGi3089tMvoaI13tOT3SLVt5XCpm4UVzQrd3h4l03VxPy467HH
         nzNlygr+bu1nTzT9QjlD/9WSGlz1tFpA1prdR0l4GRw4kujfYeXto7o+0HJQQ1eumNPr
         lJuP6Xqc8iAL2gEnJ/gczTaMj0Pvf9Yi3hAC5wVU6UNegbY4V2pbJT3w+7UxxxboBsKc
         vn3P6mVPXPvHVf79yNQwpRlnSRMXPzV+hcCoW2CPCo6wR1xqmVhgRWBFOeSh58wrrSXq
         U4xQ==
X-Gm-Message-State: AFqh2koZtTBXFmQ4Q9gXyytz0wMLwoDssnh+mHUOhgqG19lMxgyRQp6r
        OC1oRCQWDahGgbld1Hpauoo=
X-Google-Smtp-Source: AMrXdXsPsTib4x2S9bTDc/0F5FlwI0r2swSgEcG4X5I9NGkrhNc3oz9slQbHTlCUn5uOdpverUbE5w==
X-Received: by 2002:a05:6512:130c:b0:4ca:f9ec:eee2 with SMTP id x12-20020a056512130c00b004caf9eceee2mr21626636lfu.20.1673430864038;
        Wed, 11 Jan 2023 01:54:24 -0800 (PST)
Received: from [192.168.50.20] (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.gmail.com with ESMTPSA id f14-20020a0565123b0e00b004b7033da2d7sm2647067lfv.128.2023.01.11.01.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:54:23 -0800 (PST)
Message-ID: <d06d2e44-7403-7e7e-1936-588139bf448e@gmail.com>
Date:   Wed, 11 Jan 2023 10:54:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] rndis_wlan: Prevent buffer overflow in rndis_query_oid
To:     Alexander H Duyck <alexander.duyck@gmail.com>, kvalo@kernel.org,
        jussi.kivilinna@iki.fi, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <20230110173007.57110-1-szymon.heidrich@gmail.com>
 <ece5f6a7fad9eb55d0fbf97c6227571e887c2c33.camel@gmail.com>
Content-Language: en-US
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
In-Reply-To: <ece5f6a7fad9eb55d0fbf97c6227571e887c2c33.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2023 20:39, Alexander H Duyck wrote:
> On Tue, 2023-01-10 at 18:30 +0100, Szymon Heidrich wrote:
>> Since resplen and respoffs are signed integers sufficiently
>> large values of unsigned int len and offset members of RNDIS
>> response will result in negative values of prior variables.
>> This may be utilized to bypass implemented security checks
>> to either extract memory contents by manipulating offset or
>> overflow the data buffer via memcpy by manipulating both
>> offset and len.
>>
>> Additionally assure that sum of resplen and respoffs does not
>> overflow so buffer boundaries are kept.
>>
>> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
>> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
>> ---
>>  drivers/net/wireless/rndis_wlan.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
>> index 82a7458e0..d7fc05328 100644
>> --- a/drivers/net/wireless/rndis_wlan.c
>> +++ b/drivers/net/wireless/rndis_wlan.c
>> @@ -697,7 +697,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
>>  		struct rndis_query_c	*get_c;
>>  	} u;
>>  	int ret, buflen;
>> -	int resplen, respoffs, copylen;
>> +	u32 resplen, respoffs, copylen;
> 
> Rather than a u32 why not just make it an size_t? The advantage is that
> is the native type for all the memory allocation and copying that takes
> place in the function so it would avoid having to cast between u32 and
> size_t.
 
My sole intention with this patch was to address the exploitable overflow
with minimal chance of introducing any extra issues.
Sure some things probably could be done differently, but I would stick to
the choices made by original authors of this driver, especially since Greg
mentioned that RNDIS support generally should be dropped at some point.

> Also why not move buflen over to the unsigned integer category with the
> other values you stated were at risk of overflow?
> 
>>  
>>  	buflen = *len + sizeof(*u.get);
>>  	if (buflen < CONTROL_BUFFER_SIZE)
> 
> For example, this line here is comparing buflen to a fixed constant. If
> we are concerned about overflows this could be triggering an integer
> overflow resulting in truncation assuming *len is close to the roll-
> over threshold.

I'm not sure how this would be exploitable since len is controlled by the
developer rather than potential attacker, at least in existing code. Please
correct me in case I'm wrong.
 
> By converting to a size_t we would most likely end up blowing up on the
> kmalloc and instead returning an -ENOMEM.
> 
>> @@ -740,7 +740,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
> 
> Also with any type change such as this I believe you would also need to
> update the netdev_dbg statement that displays respoffs and the like to
> account for the fact that you are now using an unsigned value.
> Otherwise I believe %d will display the value as a signed integer
> value.
> 
>>  			goto exit_unlock;
>>  		}
>>  
>> -		if ((resplen + respoffs) > buflen) {
>> +		if (resplen > (buflen - respoffs)) {
>>  			/* Device would have returned more data if buffer would
>>  			 * have been big enough. Copy just the bits that we got.
>>  			 */
> 
> Actually you should be able to simplfy this further. Assuming resplen,
> buflen and respoffs all the same type this entire if statement could be
> broken down into:
> 		copylen = min(resplen, buflen - respoffs);
> 
> 

Agree, yet I would prefer to avoid any non-essential changes to keep the risk
of introducing errors as low as possible. I intentionally refrained from any
additional modifications. Is this acceptable?

Thank you for your review, I really appreciate all the suggestions.

