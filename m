Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FDB2891DB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390716AbgJITjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731727AbgJITjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:39:48 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE03C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 12:39:48 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c5so10221399ilr.9
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 12:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xQ8UTjmcxBkyr9kdzQcEkeWqctEHrqs8CDp7y053heY=;
        b=YOEmmwX3weBMkV6EMLrxzpPx92svbqEyYiZ4LCKEDVhYQu8ZOXwFM5xkz3ihAesEFZ
         MCXZyqZeW6Q0TFlYry6DmYF5Pkfx5w7f7aBedyt8IgrjToiz+8UZM9SJMrAp5dduNwax
         rcRU4ygtpdzI0nA6+c4+BHBrJJn6zRJmWayexvx2siJf4g7QLzkvYbCAXD0f60e5Lz+2
         4bcU2Rc3vGhdMjtFFfQd6vMOxz0MAMu8R/DO153fWD8/O6uJEPja9c79vhEELwp8hqX6
         ljLcdL6DYheQyzTwCTSghPOmvHUbapSYasHMnsdpLm/+M5+Ob4KjmXGFWTdVcXcUz++N
         ta8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xQ8UTjmcxBkyr9kdzQcEkeWqctEHrqs8CDp7y053heY=;
        b=r01fZOnQJQe1fhsT85dPKKDqqexS3B9KpXDmbB3H7wy73EBOmCC3GPANVb1aBbZO7v
         raroXsCZXnVbcJKBpwV8QVjegEMD3t5ydV5cm1xpH0y4xSIPRWEzD4U0TWYl35G5W2S7
         mXPQ8pa9dXUU9967fWHc5Nxv7ZCS3v8ckfLDB7/drtRFzpx83I/nJY6cLV4WiOT/L15W
         u7yV3v/7TMoThioRol4u8OPjRrt2leKD9KmRx3zoABp+T7KNP8oM3k8Uiq4ofGcUk3fr
         AjJh74XrLZD+QkCpNlwdv6clHCvC1xHWHJVMnFCFP+t6rkBd8hKv28zSpUTgVNTvq3j+
         wpvA==
X-Gm-Message-State: AOAM533qRCD2vnvyIQ4FTsAgwOaPs/XfcPCEM9pA8y6fLEQNIGLI+VZa
        a6VSSPrZuVJAhZuo3lxa62HgZw==
X-Google-Smtp-Source: ABdhPJwtulAG6wcmzNl16+TH2gPGVSgNW5ffvDVQB4/BEAIm2zsxbCyxEh1NiO37k5owtKUtvYNgRA==
X-Received: by 2002:a05:6e02:13f0:: with SMTP id w16mr1687966ilj.208.1602272387629;
        Fri, 09 Oct 2020 12:39:47 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b3sm3877236iot.37.2020.10.09.12.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 12:39:46 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: ipa: only clear hardware state if setup has
 completed
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201006213047.31308-1-elder@linaro.org>
 <20201006213047.31308-2-elder@linaro.org>
 <20201009122517.02a53088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <65ea5328-9f15-5bb6-80e9-514970cd4380@linaro.org>
Date:   Fri, 9 Oct 2020 14:39:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201009122517.02a53088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 2:25 PM, Jakub Kicinski wrote:
> On Tue,  6 Oct 2020 16:30:46 -0500 Alex Elder wrote:
>> In the setup phase of initialization, GSI firmware gets loaded
>> and initialized, and the AP command TX and default RX endpoints
>> get set up.  Until that happens, IPA commands must not be issued
>> to the hardware.
>>
>> If the modem crashes, we stop endpoint channels and perform a
>> number of other activities to clear modem-related IPA state,
>> including zeroing filter and routing tables (using IPA commands).
>> This is a bug if setup is not complete.  We should also not be
>> performing the other cleanup activity in that case either.
>>
>> Fix this by returning immediately when handling a modem crash if we
>> haven't completed setup.
>>
>> Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
>> Tested-by: Matthias Kaehlcke <mka@chromium.org>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
>> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
>> index e34fe2d77324e..dd5b89c5cb2d4 100644
>> --- a/drivers/net/ipa/ipa_modem.c
>> +++ b/drivers/net/ipa/ipa_modem.c
>> @@ -285,6 +285,9 @@ static void ipa_modem_crashed(struct ipa *ipa)
>>   	struct device *dev = &ipa->pdev->dev;
>>   	int ret;
>>   
>> +	if (!ipa->setup_complete)
>> +		return;
>> +
>>   	ipa_endpoint_modem_pause_all(ipa, true);
>>   
>>   	ipa_endpoint_modem_hol_block_clear_all(ipa);
> 
> The only call site already checks setup_complete, so this is not needed,
> no?

Wow, you are correct.

I was mainly focused on the fact that the ipa_modem_crashed()
call could happen asynchronously, and that it called
ipa_table_reset() which requires IPA immediate commands.
I should have followed it back to its callers.

I agree with you, this is not needed.  The other patch
is definitely needed though.

Would you like me to re-post that single patch, or is
it acceptable as-is?

Thank you for reviewing this and catching my mistake.

					-Alex

> $ git grep -C2 ipa_modem_crashed\(
> drivers/net/ipa/ipa_modem.c-
> drivers/net/ipa/ipa_modem.c-/* Treat a "clean" modem stop the same as a crash */
> drivers/net/ipa/ipa_modem.c:static void ipa_modem_crashed(struct ipa *ipa)
> drivers/net/ipa/ipa_modem.c-{
> drivers/net/ipa/ipa_modem.c-    struct device *dev = &ipa->pdev->dev;
> --
> drivers/net/ipa/ipa_modem.c-                     notify_data->crashed ? "crashed" : "stopping");
> drivers/net/ipa/ipa_modem.c-            if (ipa->setup_complete)
> drivers/net/ipa/ipa_modem.c:                    ipa_modem_crashed(ipa);
> drivers/net/ipa/ipa_modem.c-            break;
> drivers/net/ipa/ipa_modem.c-
> 

