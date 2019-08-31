Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663B2A45C7
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfHaSc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 14:32:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33527 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfHaSc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 14:32:59 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so20993765iog.0;
        Sat, 31 Aug 2019 11:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=bjc7ayKa/cq03dThSGQ6pLp6rDV/WQ1aTS5E3AEYpH0=;
        b=ZryxRM+FV/pPB+skU3zXg+PD8pSscNH2Cu8vRSJKsbFUD0cU1Ji7m9C/+AVs6j7N73
         uJb8/HeZzJRSmhihRFO6BysF2fbpElxVvrvE1H6yyNAyCs4RhfxwD6Z7R7erwXHej5JJ
         SUo/F+IBF/OE/Fy7+piRAkt1KHsO9Q7UKr32YCFABbBXZK8+mLQ6YnUo8YZ33WCaK+d1
         42kpGPHxWEGr/6t5oVXXDE3XOVMKmkRrDuRDcEKxBBCRHrU7hhZln5t2PmQwEZgkCLOq
         34yudrQlr03XKWuE3rz0WHOYxlx+7GCyIQgouv1gnsc/D0FzdF8uzMupWR6KXKnvVmye
         5pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=bjc7ayKa/cq03dThSGQ6pLp6rDV/WQ1aTS5E3AEYpH0=;
        b=tumFfXg1u9/0k4KssIo/dtTDR8HKEAFwL5cp7ElvmuouOpDN8o0d1lE1bX/KM6V1u+
         xsAf5Y4HNvcr4FsrQYlLNPYnlSZSiHP044INXyurq9Hu2wxajnznBQ+zCrkvluOdZ8mC
         fdSnM1FiG8k9j1rVFBJnr3Iv+bwwuEqwgoaeorKke/P7/YnRhJP4bTio5WkX5NG3HjRG
         kyUutI+qEY2B0EQKcS41XNlDXfvnw/AY9nAgUwYcmhSc8owK6nqdG/EWlItplcqdlrtN
         BJtjndnDCcvcjXxbeb97m1pKKIx9/1OQWWI1D0lMuYJH06h24C3NNFZpCC9N1lDVfkJc
         ZkyQ==
X-Gm-Message-State: APjAAAV5lAdIAqSi+cTKUqYpl4u47Q4UB7FmaTfeXLqybVpCIDDYaBse
        ZGGkeZndqmHouhK/qTeru1DOnakn13nNqQ==
X-Google-Smtp-Source: APXvYqyisKeiw9N8atdC8F+/FU6smfv2c2VAswuz/G1tWYcTITkfZezGLZq8QOcY0JwjuIw934Fyow==
X-Received: by 2002:a5d:9655:: with SMTP id d21mr7109935ios.99.1567276378114;
        Sat, 31 Aug 2019 11:32:58 -0700 (PDT)
Received: from [10.164.9.36] (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.gmail.com with ESMTPSA id w17sm7672407ior.23.2019.08.31.11.32.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2019 11:32:57 -0700 (PDT)
From:   Hui Peng <benquike@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     security@kernel.org, Mathias Payer <mathias.payer@nebelwelt.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
References: <20190819220230.10597-1-benquike@gmail.com>
 <20190831181852.GA22160@roeck-us.net>
Message-ID: <d5b3e9ff-ddca-52fc-81cf-9a213ad2c251@gmail.com>
Date:   Sat, 31 Aug 2019 14:32:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190831181852.GA22160@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/19 2:18 PM, Guenter Roeck wrote:
> On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
>> `dev` (struct rsi_91x_usbdev *) field of adapter
>> (struct rsi_91x_usbdev *) is allocated  and initialized in
>> `rsi_init_usb_interface`. If any error is detected in information
>> read from the device side,  `rsi_init_usb_interface` will be
>> freed. However, in the higher level error handling code in
>> `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
>> again, in which `dev` will be freed again, resulting double free.
>>
>> This patch fixes the double free by removing the free operation on
>> `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
>> used in `rsi_disconnect`, in that code path, the `dev` field is not
>>  (and thus needs to be) freed.
>>
>> This bug was found in v4.19, but is also present in the latest version
>> of kernel.
>>
>> Reported-by: Hui Peng <benquike@gmail.com>
>> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
>> Signed-off-by: Hui Peng <benquike@gmail.com>
> FWIW:
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
> of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
>
> Are there any plans to apply this patch to the upstream kernel anytime
> soon ? If not, are there reasons to believe that the problem is not as
> severe as its CVSS score may indicate ?
This patch is also still under review.
> Thanks,
> Guenter
>
>> ---
>>  drivers/net/wireless/rsi/rsi_91x_usb.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
>> index c0a163e40402..ac917227f708 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
>> @@ -640,7 +640,6 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
>>  	kfree(rsi_dev->tx_buffer);
>>  
>>  fail_eps:
>> -	kfree(rsi_dev);
>>  
>>  	return status;
>>  }
>> -- 
>> 2.22.1
>>
