Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411C535B481
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhDKNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 09:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbhDKNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 09:10:15 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABE1C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 06:09:58 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z3so10641157ioc.8
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 06:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JM5oanM+YKKkNLjjQdFL6wxoPfIGt3gvhsfIAt5e8eI=;
        b=LuJD7lDCGkYy69ThyQxSm1vxxTG/OWqE4mR85xRGuO57SnzCc5rX3fNhlzN5LJDXSB
         tmFub5+IoJ8RDN/4rgeXOp/VQA0WgeM20cVlcSwogUHWN316hxLajSX1CRBh+4eKIkGE
         +NrjbeaN0sKbI8iszyDk5nVOlANZp6d7ynIYECmhDmQttGLhc+ylvLXYTiuUYhh/1cUZ
         LlHW5lEOQxbiL1O+SyS6rTTxjt7H9yEZKEycj8nemnHRY430N2FjemRlEDvT5z3RRrHA
         FBBXVd9U4FlgJJfq9PfKtiR0vLW4KJpWBcMhqBZZciqTy9R2wgzwLN6f03SahOHAXTK6
         7tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JM5oanM+YKKkNLjjQdFL6wxoPfIGt3gvhsfIAt5e8eI=;
        b=cRVkfS8YSHAdqUJcp3j1zFsvVWoV/TdoIWQKMLicvc3kRBinX44pZ5nnTNRFMp5I85
         3b0e+Y0ijvo+WII6BXVa8c/zohzJPmxdTpr7ydZCzMgrBoBRIE296zy9Y0dvuDZwTt+P
         uIVDh7GrkTsw2iUZD+UcZM2e2heeON1D9NUnG0bEVjK8lHoICaAJZEkCYCHXw76boE/a
         badWs09/IFSmua2hJkpWT32Gfu90kp2C9gHJLM8hFiFwyRPS7l1xBmpy1MWLCiH5mlpZ
         rJ3zw384Ja8liih2axUpMP9BEgqzay3Mo3aBGZyBAoFpCW8DXZN6BMVho2Tm4d2zwLnb
         CObw==
X-Gm-Message-State: AOAM533s0UfeBLK6rgv+ssgEdD+NXXJkNC3/vSgHX7/M7f5ibUbkOhvo
        YmpsN/KRrBXXurnMjnWVlTBxUg==
X-Google-Smtp-Source: ABdhPJzbW/a93rAHbaEYIRvCuYi287wv6ez1OJPcXfhu1EWSbRRYY67STD4jY+/BCAnZyP8f6l2pdw==
X-Received: by 2002:a02:8801:: with SMTP id r1mr24179942jai.51.1618146597305;
        Sun, 11 Apr 2021 06:09:57 -0700 (PDT)
Received: from [192.168.20.93] ([64.118.8.63])
        by smtp.googlemail.com with ESMTPSA id j1sm4129647ile.75.2021.04.11.06.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 06:09:56 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org> <YHKYWCkPl5pucFZo@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org>
Date:   Sun, 11 Apr 2021 08:09:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHKYWCkPl5pucFZo@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 1:34 AM, Leon Romanovsky wrote:
> On Fri, Apr 09, 2021 at 01:07:19PM -0500, Alex Elder wrote:
>> In ipa_modem_stop(), if the modem netdev pointer is non-null we call
>> ipa_stop().  We check for an error and if one is returned we handle
>> it.  But ipa_stop() never returns an error, so this extra handling
>> is unnecessary.  Simplify the code in ipa_modem_stop() based on the
>> knowledge no error handling is needed at this spot.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/net/ipa/ipa_modem.c | 18 ++++--------------
>>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> <...>
> 
>> +	/* Stop the queue and disable the endpoints if it's open */
>>  	if (netdev) {
>> -		/* Stop the queue and disable the endpoints if it's open */
>> -		ret = ipa_stop(netdev);
>> -		if (ret)
>> -			goto out_set_state;
>> -
>> +		(void)ipa_stop(netdev);
> 
> This void casting is not needed here and in more general case sometimes
> even be seen as a mistake, for example if the returned attribute declared
> as __must_check.

I accept your point but I feel like it's sort of a 50/50 thing.

I think *not* checking an available return value is questionable
practice.  I'd really rather have a build option for a
"__need_not_check" tag and have "must_check" be the default.

The void cast here says "I know this returns a result, but I am
intentionally not checking it."  If it had been __must_check I
would certainly have checked it.  

That being said, I don't really care that much, so I'll plan
to post version 2, which will drop this cast (I'll probably
add a comment though).

Thanks.

					-Alex

> 
> Thanks
> 

