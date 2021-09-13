Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C188F409AB5
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbhIMRgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbhIMRgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:36:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FD3C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:34:50 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id n30so6838944pfq.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TQ1ch5IKCKpdtPErJzh0Q4aULiEy9nKEqBiYssfjG94=;
        b=qvWmhf2YkaLPu57JMVdysfo+yN7Q+9fGLq9bDi7V4l644aLGl641+DHi5zA8DAm3IZ
         RIHeIbunjW68K/EjxAe5WRM0VGqsa8HkvE2aau0JgPQvNZ/pRi+G/lcLJ+yXXgV+08wm
         wcq/sNn5wa+BclTT2Nr2PdHvZ6Oecbx/o98e6EfqKS0SFXNw4Zu8F0K8b2R8oBHobbWP
         BMFNqyO5Qz7EGfzanrEF8BTAUPJKKC8CRGZME54BvFzG4hZCcRv4Z90QuPDHSDuOT8HA
         fGVB/bdkEShtGfLoxlx4S4CDft7HV8OE/GtkbLxN+kV9rK638gxsLhxyj35pTcB7Yqih
         mpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TQ1ch5IKCKpdtPErJzh0Q4aULiEy9nKEqBiYssfjG94=;
        b=cwZrpa8icp74aW8MQgjckguDeZHqykVv0i4wvlkA7tbr6RYHAurvJvnjEAUsLMc4tk
         fGPWE4NpYex0CKluhz0vuO1XjsicJXSaIwRuUCO/eaq/Euhi3Xo52ghf42QYet6AEdmj
         OV50Gc1pNLNZrMWbJjesNZNAvl/R5xFh1B2SR6VRNtSu7f2roE5XBZxdJy76Za407W1k
         e67bxut8iQBJdPz/ZJ2JWh77GPIlpohOPQF4bpSLKqmHMeYoGKDu1hovd4Tv2ua1jwHB
         nrULqwuw3voitYVhPdUfxcw2tLVLtrhN/N0MQ/g+yytUxeR8sUSvokfpNwknpRhHctJb
         +Wew==
X-Gm-Message-State: AOAM532AeZasYkOSYURUALPzgNFcTZ5aAitCRNiVtvxK8CicLPsopbAF
        0k276pW02PcJHGPrxi3U8a4=
X-Google-Smtp-Source: ABdhPJzdSw3DhDSxfyfQ/k0MiS1DvrV3yfyIY7ZzPJdnwPWzFq+WyIz+7p0/kWMUpvcGLIEh7tAayA==
X-Received: by 2002:a05:6a00:2410:b0:409:5fbd:cb40 with SMTP id z16-20020a056a00241000b004095fbdcb40mr656562pfh.8.1631554489602;
        Mon, 13 Sep 2021 10:34:49 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p18sm8971015pgk.28.2021.09.13.10.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:34:48 -0700 (PDT)
Message-ID: <43ee7616-ca74-b783-1810-bd11f9c03868@gmail.com>
Date:   Mon, 13 Sep 2021 10:34:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 7/8] net: dsa: rtl8366: Fix a bug in deleting
 VLANs
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-8-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913144300.1265143-8-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2021 7:42 AM, Linus Walleij wrote:
> We were checking that the MC (member config) was != 0
> for some reason, all we need to check is that the config
> has no ports, i.e. no members. Then it can be recycled.
> This must be some misunderstanding.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Might be worth adding a Fixes tag?
-- 
Florian
