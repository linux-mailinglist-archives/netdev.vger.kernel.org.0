Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530865BE6F3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiITNXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiITNXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:23:13 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08D4DB0E;
        Tue, 20 Sep 2022 06:23:11 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id v15so1944548qvi.11;
        Tue, 20 Sep 2022 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=k1ondIBYTXsuq+93bFBIfa0vNivWkkEf+GNV0BFc+7k=;
        b=LrHXAC9mAT4IzMGFAPbFf+UJ1rcL0CtlcsxfzKtQmWUwFHVh0tycUFXSDgudhQRGi1
         63KlmzKLv5igOukDxVSRM1tV8Rnhi0GK52NppeMjvWCpoPF8iRok+RMTyOQTbVUf52vN
         SmSf5HG6MfMhAJL8Lad8g0toJi2qi/GrZuITXw87hTHVDt7dePJL2DFmdBgZpv0HRGGF
         OlU89ad4ZsyrSuXZRXO3GxcA2Z3dr6QAB1x/UD3LO3ZHsMfiiJ3mew/VoknwOLx2A0aS
         GEFP711wMi32eRrDzDRkOuu6j8T7wq01sCv6mJUU5n1+SeFWoE9TbX1AlClcASZFORcy
         QVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=k1ondIBYTXsuq+93bFBIfa0vNivWkkEf+GNV0BFc+7k=;
        b=sotmRHHUdKKPGS2TjeMg5ABTnOA1C2AmcDtn5dD2JQyyWjprTHMU3M3vgN74SZq5+t
         cM37zTW0cF8paDMWoI2CTSQit9hXJGPLjZ7Bjb1iFxRDveD/DpFw8JsbEqGoSznnhi09
         u1jv7MWH7+BTTl9/mFBnAQ7Vp7dcLlFcyduFtH3xojReWYLhO0XEgA/mfmvc/vAI3OZW
         u8P+2jus/gcA2E9KnaEoNTSEqJ5/pwKdCvqG2+3Q+RPNmNycemLeemzfvIgjYAXMNvzc
         f8id4dSqSA1CsEIr61zeIGvvo1o/sXCg+0aamTGIVYIy9ppCchriu8SwHDQJNL5Bx7fn
         9zKw==
X-Gm-Message-State: ACrzQf1aTJTgO4uy5Pxx0gCSG5niLsQfWqhnw+VtWocHWB7C4clgTre5
        TBD7OK4vTUZRoTT6TqyEjNE=
X-Google-Smtp-Source: AMsMyM74/O3pPhkmqPl9DsitaJGKdbmDcx93CFu1cSKXqCjXLMBT3yo5ax6ppvXfGLdhm6jaBVfmUw==
X-Received: by 2002:a05:6214:20ac:b0:4ac:ad56:a9f4 with SMTP id 12-20020a05621420ac00b004acad56a9f4mr18554658qvd.78.1663680190941;
        Tue, 20 Sep 2022 06:23:10 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id dt30-20020a05620a479e00b006ce3cffa2c8sm151520qkb.43.2022.09.20.06.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 06:23:10 -0700 (PDT)
Message-ID: <eb3ea4f2-3f12-3040-7faa-3d4fe44f68e5@gmail.com>
Date:   Tue, 20 Sep 2022 09:23:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>
References: <20220918215534.1529108-1-seanga2@gmail.com>
 <YyjTa1qtt7kPqEaZ@lunn.ch> <ab2ce38a-313b-7e87-aaf5-cfc2b6e0cb28@gmail.com>
 <Yymz9K6QXi860AWh@lunn.ch>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Yymz9K6QXi860AWh@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/22 08:37, Andrew Lunn wrote:
>>> Please could you add a Fixes: tag indicating when the problem was
>>> introduced. Its O.K. if that was when the driver was added. It just
>>> helps getting the patch back ported to older stable kernels.
>>
>> Well, the driver was added before git was started...
>>
>> I suppose I could blame 1da177e4c3f4 ("Linux-2.6.12-rc2"), but maybe I
>> should just CC the stable list?
> 
> That is a valid commit to use. It is unlikely anybody will backport it
> that far, but it does give the machinery a trigger it does need
> backporting.
> 
> 	Andrew
> 

OK, well then this

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
