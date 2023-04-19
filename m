Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992C76E8205
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjDSTmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjDSTmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:42:45 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC574C37
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:42:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50847469a7fso235766a12.0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681933362; x=1684525362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kabpnjTCjqP45slsIo1+rdV4uXUZnlZBAEyWTGefmrU=;
        b=gq3s9X5ikbqCGzliFi7nIlnmW31Ify5ixO5hPtad1QUB8mqOPEckD2+xG9t4KQ9a05
         iC8ce3WvsNqQrBIOf/9G+liCWflGly5Bd//qfw9g/ySnfc4loFGCmelwKfYc8zigSslw
         XqULE6Y0BShT5AEpnMQmzDQPIi0vN6Zv8eT+iUH78EsWdhWeaSu4DQ+C8yCFMytRK67Z
         3zbec/wPdWd90sUGxE2dLK9O+bguvb2JeKoJkdqUCdOcOJ1Bdfzk/zLn7O3AejJfAaHT
         3Z1CmL5U+LWtj8WtftgA8vA3Ua3+74D2Fuj2QVpeKDobiNi5Mcu2SjieSg3YzTiofWIY
         MhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681933362; x=1684525362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kabpnjTCjqP45slsIo1+rdV4uXUZnlZBAEyWTGefmrU=;
        b=abJfJAKMVsMYWRSBAgbFdK7QP2cTaNMVNCNgsYU0yz9Uq6KYZVa5iTqDrkHN+Vtgyu
         cY6VtO4QG9Vto4gTCQcc7gzkrs5BrR9CgoX8yc/sTxmhpqao1HfUdyFw/jaDnh6njg+/
         1tqbtrgO0Jd5tVjOikkRl+Mp3oD8vvpCfDFmnho341X1vJeg/q6V1AAMaZFFgKhULzRa
         CL6kT5ys0kFi44OpNkPUIhm7rPIRoK15JHoHzxz8SKQ1JzDrzktyPtxexJymw+XI7vKI
         VWE22vufHnZtUuLLWmxwvHIrFlVUeN+zwcsyO7O3wbPABQ7Lo1S+O8NAsU72nEKa1aUx
         H2SQ==
X-Gm-Message-State: AAQBX9fYLBevzND8H+msbD7wgAyVkhy7eS0h3YrmoRoLnRBEU+HjETfK
        vayRDzJb3uP9sO/2vqVmGZl5Zg==
X-Google-Smtp-Source: AKy350bc3GWY3VPzEuT8jJUkQFSPKSNrIhp44xSKlRK8k+SiL3FGI4ilYR5RzlkLUN29gcUPYIyOSg==
X-Received: by 2002:a05:6402:342:b0:504:ecfa:fa6c with SMTP id r2-20020a056402034200b00504ecfafa6cmr6323605edw.1.1681933362301;
        Wed, 19 Apr 2023 12:42:42 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:976c:1d6c:6ed0:8935? ([2a02:810d:15c0:828:976c:1d6c:6ed0:8935])
        by smtp.gmail.com with ESMTPSA id fl3-20020a1709072a8300b0094f396c7a7asm6021574ejc.214.2023.04.19.12.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 12:42:41 -0700 (PDT)
Message-ID: <ef3fe52f-c6d0-b74d-e37e-0d0129990ef7@linaro.org>
Date:   Wed, 19 Apr 2023 21:42:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] net: nfc: nci: fix for UBSAN: shift-out-of-bounds in
 nci_activate_target
To:     Anup Sharma <anupnewsmail@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linma@zju.edu.cn,
        dvyukov@google.com, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZD9A5Krm+ZoFEFWZ@yoga>
 <3aeac99f-aef3-ee22-f307-3871b141dc7b@linaro.org>
 <76d5df65-c0c9-9702-8037-4c1d3b2255f3@linaro.org> <ZEA/N5SAFHd2UjS8@yoga>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZEA/N5SAFHd2UjS8@yoga>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 21:21, Anup Sharma wrote:

> 
>>>> +		pr_err("Too many supported protocol by the device\n");
>>>> +		return -EINVAL;
>>>
>>> I am pretty sure that you broke now NFC. Test the patches first and
>>> share your test scenario.
> 
> Since a reproducer for this bug is not available, I am unable to test it locally
> or through syzbot before submitting the patch. 

Reproducer is only to test the actual issue, not test the code. Code can
be tested with real device and maybe with virtual NCI driver.

> Are there any other tests that
> I can perform before submitting the patch, apart from simply compiling the kernel?

Compiling a kernel is not tested. Maybe you can test this part
successfully with virtual NCI driver, maybe not, I don't know.

> 
>>
>> BTW, ISO15693 is here protocol 128, so definitely more than 32.
> 
> Thank you for your feedback. I would like to address the UBSAN bug and I have
> thought of a potential solution which involves adding a check statement for the
> minimum and maximum values of the protocol before net/nfc/nci/core.c +912:
> 
> if (!(nci_target->supported_protocols & (1 << protocol)))
> 
> Could you please assist me in determining the correct approach?

I would first propose to check whether the UBSAN report is an actual
real issue to fix.


Best regards,
Krzysztof

