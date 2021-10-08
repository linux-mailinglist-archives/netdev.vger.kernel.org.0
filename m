Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA9B426D59
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbhJHPRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbhJHPRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 11:17:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904A7C061570;
        Fri,  8 Oct 2021 08:15:38 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r7so30806585wrc.10;
        Fri, 08 Oct 2021 08:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T7MGxfkmIu6hScMKkOk6yF8OXztAXQpl5GmJESEY5qk=;
        b=kKlXRck94dKwpDv9Q3VWhmF7nfKwZ5VJYQKpk1hhg8qtPH3aJysWH7T2suuZ8NfXFJ
         giuanddnj8r+JUDEPs15tPMQ7+iTqkIJoqhBA73KP9NQ32QLjgc4zgKBTyTP1am85O8M
         VQcxB387+qgcQZJf2A3F1ScHRbiAK/0SkX3Ga4Mh/90rMs3bW43kREYdfr8wdtD0QbxG
         bit6yPrVafWp/802qWytkWGY0DGYBBnF5VdlIDoRMbMvogHH29jBhHFhY22PcX7cKPYC
         f4w2LAM7XIQhtvYbv8e5YWG2K3C0fQa8WUnvsv0/be+L5zECZ5GLB/E0IiUJON4wLKCi
         k+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T7MGxfkmIu6hScMKkOk6yF8OXztAXQpl5GmJESEY5qk=;
        b=iOc3D6yEY/n1fSxhaSAGbhmmETlIV7xlMJajnAIbrmmPfvoziWmB4yB6QLrKDxF8Kw
         IuYj83LFVSkyIse78LnAi138BetWLx75BIv2YoEMD1PDruD+u26hnPWas92/Gk9CLF8x
         GYCT2a4IMAgpdXSkuGcQgtcOpNiD6S50hCUkz39/+f1rcjADBdP0MsDUhN5P9oJA4xYP
         IBsx9lua3VaFr3q+h3AsLkzYYpaUX3n+VPa5aME2WcFZUCUozvPos1qIcqgYkv8bQhn0
         zRG5SieSSrUgV1CflIa7qKIHt3F9ja9nz1Bv104IQc9SgBEzT3Xoge0n2qNvIeQE2o8v
         cYqg==
X-Gm-Message-State: AOAM533fxug1ALvscs7wRxVLfjgpC7/H1xZz+0RRFr7nQqwMKRbkBvXp
        QD8prMD8EkIDLqVuGSp2aY1kJMzLzd4=
X-Google-Smtp-Source: ABdhPJw2mPZ7iIGxCYSLIRRzvDjAUDj7yUfLjQg9/i0ys9BPd5HwmME8GyYiizY6YhDzJfgq6K7ZMg==
X-Received: by 2002:a05:600c:1c01:: with SMTP id j1mr3956324wms.1.1633706137003;
        Fri, 08 Oct 2021 08:15:37 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff047000d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff04:7000:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id u5sm210928wmm.39.2021.10.08.08.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:15:36 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mYpiO-0009Ks-SC;
        Fri, 08 Oct 2021 17:15:35 +0200
Subject: Re: [PATCH] carl9170: Fix error return -EAGAIN if not started
To:     Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211008001558.32416-1-colin.king@canonical.com>
 <20211008055854.GE2048@kadam>
 <382b719f-f14e-2963-284d-c0b38dedc4ae@canonical.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <4e6efdf8-3c2e-68cd-5c23-b9809eceb331@gmail.com>
Date:   Fri, 8 Oct 2021 17:15:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <382b719f-f14e-2963-284d-c0b38dedc4ae@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 08/10/2021 09:31, Colin Ian King wrote:
> On 08/10/2021 06:58, Dan Carpenter wrote:
>> On Fri, Oct 08, 2021 at 01:15:58AM +0100, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> There is an error return path where the error return is being
>>> assigned to err rather than count and the error exit path does
>>> not return -EAGAIN as expected. Fix this by setting the error
>>> return to variable count as this is the value that is returned
>>> at the end of the function.
>>>
>>> Addresses-Coverity: ("Unused value")
>>> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>   drivers/net/wireless/ath/carl9170/debug.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
>>> index bb40889d7c72..f163c6bdac8f 100644
>>> --- a/drivers/net/wireless/ath/carl9170/debug.c
>>> +++ b/drivers/net/wireless/ath/carl9170/debug.c
>>> @@ -628,7 +628,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
>>>       case 'R':
>>>           if (!IS_STARTED(ar)) {
>>> -            err = -EAGAIN;
>>> +            count = -EAGAIN;
>>>               goto out;
>>
>> This is ugly.  The bug wouldn't have happened with a direct return, it's
>> only the goto out which causes it.  Better to replace all the error
>> paths with direct returns.  There are two other direct returns so it's
>> not like a new thing...
> 
> Yep, I agree it was ugly, I was trying to keep to the coding style and reduce the patch delta size. I can do a V2 if the maintainers deem it's a cleaner solution.

Hm? I don't think there's any need to stick to a particular
coding style. This file hasn't been touched a lot since 2010.
Things moved on and replacing the gotos with straight return
is totally fine.

(It has to pass the build checkers of course. However I don't
think this will be a problem here...)

Cheers,
Christian
