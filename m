Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F726DBA23
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDHKqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHKqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:46:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBDC1BC8
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:45:42 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gb34so2284516ejc.12
        for <netdev@vger.kernel.org>; Sat, 08 Apr 2023 03:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680950674;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=76NvAwebMnjTqXsYX2BkdeLSiN8cjCcv6+rnae8xzOo=;
        b=Xa8EsYI1Sdc7bZI2Ys3fTD3ltinEgRkTskSBF0YLMTzzQymWWhNFJLXoKTsDmmxf8g
         UkMPD4RMPkBlL2Mw4jkw8jEBLVDjnyWezRLrJeSmn+FvoiHSI5PQRyS9a7vBxf0UOzps
         P1b5z7uFOT4rCBEFoBChlNac7YBGPiWCV0JmaZDOzvYSQWcpLpOwhGEXRznYg0Eo2nfm
         Myx/e0FI7LRDchrP9m1vEM3bYhvVFE76oD48If5uPlW0bEm5Ai/eNZO7rVMh1NkzBGey
         /zCrgSwrEqgPJ7iNwmwm1C7f+wMBmHaD8AmGZ3z/zyNbdQ7VpG+UJhsVORsP0/sBYLIW
         sPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680950674;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=76NvAwebMnjTqXsYX2BkdeLSiN8cjCcv6+rnae8xzOo=;
        b=D/23LKvWIITBWI1z3Jnr8vmAhLd8LyozRNSalVcTPq8aSh4PblwWmMcm+rEs/Wnznw
         0qJ4og/qZ2GyGGFmpGBtrZjnMPZaXtVtBCv1lLeEVTVx/98lL9Tu6yVjjz1cVXSRjzbV
         kJrofNFnmox5WDUd6gOVtDfn7jxtvLMiH4cV/KCvWnwFT0TSLBsAYeCzjrhTAZoO8fF0
         Ey0DqfizQgHjN/Wg+nPlOxZmIhruZk4Ee7LNLINJ/hOWtaWDuntZdPSqJuVXmQBDz1Bm
         n9NojTLoQita313NHxN4F7S0RWAqx2lh75kgQrtLYmjMeRxU810fsQsL5/BZ73aJLV6A
         l07g==
X-Gm-Message-State: AAQBX9e9CWXrjOIcT9cVGwZ9kfOK5bPTOk1dAevAcBD3SlHDTSX2j9ZX
        ubdkoQlUhge1j5EO46QTlJ/9sQ==
X-Google-Smtp-Source: AKy350YOYqRALSeMqRhgiWj83zSI0pMTS3OCARZHurmOGMcvnDJXRHzYdsge66KEPtjQbhbegyljXg==
X-Received: by 2002:a17:906:980d:b0:933:3aa7:57a6 with SMTP id lm13-20020a170906980d00b009333aa757a6mr1201145ejb.12.1680950673753;
        Sat, 08 Apr 2023 03:44:33 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:4c06:aac9:100f:9d7f? ([2a02:810d:15c0:828:4c06:aac9:100f:9d7f])
        by smtp.gmail.com with ESMTPSA id g19-20020a170906521300b00947499e0e4dsm3062802ejm.146.2023.04.08.03.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Apr 2023 03:44:33 -0700 (PDT)
Message-ID: <5515891b-44f3-8c9b-ca51-0078070404af@linaro.org>
Date:   Sat, 8 Apr 2023 12:44:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
 <20230407084745.3aebbc9d@kernel.org>
 <3a0391e7-21f6-432a-9872-329e298e1582@roeck-us.net>
 <20230407181037.4cecfbde@kernel.org>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230407181037.4cecfbde@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/04/2023 03:10, Jakub Kicinski wrote:
> On Fri, 7 Apr 2023 11:05:06 -0700 Guenter Roeck wrote:
>> On Fri, Apr 07, 2023 at 08:47:45AM -0700, Jakub Kicinski wrote:
>>> On Fri,  7 Apr 2023 16:59:04 +0200 Krzysztof Kozlowski wrote:  
>>>> This depends on hwmon core patch:
>>>> https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/  
>>>
>>> That patch should have been put on a stable branch we can pull
>>> and avoid any conflict risks... Next time?  
>>
>> Yes, and I don't feel comfortable applying all those patches through
>> the hwmon tree since I have zero means to test them.
>>
>> I created a stable branch at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-const
> 
> Thanks! Krzysztof, give us a nod and we'll take the series to net-next.

Sure, go ahead, that's even better solution.

Best regards,
Krzysztof

