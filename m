Return-Path: <netdev+bounces-3817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EB9708F63
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CB40281B33
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B12D651;
	Fri, 19 May 2023 05:26:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636767C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 05:26:06 +0000 (UTC)
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FF7E4C;
	Thu, 18 May 2023 22:26:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f25d79f6bfso3323068e87.2;
        Thu, 18 May 2023 22:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684473962; x=1687065962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNtRnyQN8vO04gSlcyvpsqnkimMuzHNYu/QdOo0JXbg=;
        b=MmMPzTf5aPuDZyy+pZTLvBgU5RoGY7h4ncqYpeVHj+sAwcpYtepWH2v7u7wE8tOJzH
         bQ5aF6x3HuDfU4LKnPHxc46tOqC0CsVkDkt18RKY4+/oF01Zkb2oFebosWut936pCpOy
         92KBvUQcEMweaWq9cp97c8g/pPRra1YqK8CFHze+UV8JedIm0WcFrvkmX2RnHxsCrBTn
         tbX7hz5/zz9ObpEGIJC3MFYqQoiwit4jmSpt1clolDqy455jzvYUo4VWl1oZFAOHd1/T
         lrt4WwatKqHTU2QOnFZAaf1rDlL+FccUx8Eb7ZKUBhJvz7XM22RkLPBnUbjgKCxS1wyO
         fv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684473962; x=1687065962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNtRnyQN8vO04gSlcyvpsqnkimMuzHNYu/QdOo0JXbg=;
        b=c8z9ksRvASxb8bNb0nDjddM/qVNIEyohrvNkQzd6otMp7UhkoqTb9862FtyfMde75B
         GKOKEGfCeXgEvPlkKGM7Q6lhFDCZEBJWWsQFqBJtoiSsTNqFyL9JYZM/k+lYv9Wk8MYF
         T7oqlL0G5+zg2HiS4BwRJWfT2QpUsZKrvh2nMVK5suWI3qqT+fDOCqNtQehbNmnBwWNZ
         vhh64bEK2UaoJIEFzjQtvLtrZ8TF9r7rI8hfr8tSKw8kKy0X/LDo6Fpc4Kpx/wLDSByE
         5TMQwFKHpZ9zBdytEhuYnf8vQLTo+/lINq5DV2oCJMlHP+MeJyH6weR+IJO2mIvWv2dZ
         ZT8Q==
X-Gm-Message-State: AC+VfDxzt0itKxYxl/RqC2xbEeU0nFF7HBfx2e8GfuQ30V1V3hTgXiEx
	3vf2Y+nxE7idWpT2xrVNIoY=
X-Google-Smtp-Source: ACHHUZ7okWk9/fgEhxsg8/G1HG9gq5sDzS/nZVIxkKaxoXGvjfkpg8GlqgOs4szyC1dxuJJOg4zqFg==
X-Received: by 2002:ac2:4352:0:b0:4f0:124:b56b with SMTP id o18-20020ac24352000000b004f00124b56bmr441637lfl.7.1684473962219;
        Thu, 18 May 2023 22:26:02 -0700 (PDT)
Received: from [192.168.1.126] (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id m5-20020ac24ac5000000b004eed8de597csm472747lfp.32.2023.05.18.22.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 22:26:01 -0700 (PDT)
Message-ID: <6ab1852e-139f-579b-3ef4-5c98e0ea446d@gmail.com>
Date: Fri, 19 May 2023 08:26:00 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/7] iio: mb1232: relax return value check for IRQ get
Content-Language: en-US, en-GB
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
 Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Lars-Peter Clausen
 <lars@metafoo.de>, Michael Hennerich <Michael.Hennerich@analog.com>,
 Jonathan Cameron <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>,
 Marcin Wojtas <mw@semihalf.com>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
 Linus Walleij <linus.walleij@linaro.org>,
 Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
 Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <429804dac3b1ea55dd233d1e2fdf94240e2f2b93.1684220962.git.mazziesaccount@gmail.com>
 <ZGUFJ5LRCzW2V0a1@smile.fi.intel.com>
 <1a3a84d4-1955-f0ee-5c6d-ab36fddc5e15@gmail.com>
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <1a3a84d4-1955-f0ee-5c6d-ab36fddc5e15@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/19/23 08:00, Matti Vaittinen wrote:
> On 5/17/23 19:47, Andy Shevchenko wrote:
>> On Tue, May 16, 2023 at 10:12:41AM +0300, Matti Vaittinen wrote:
>>> fwnode_irq_get() was changed to not return 0 anymore.
>>>
>>> Drop check for return value 0.
>>
>> ...
>>
>>> -    if (data->irqnr <= 0) {
>>> +    if (data->irqnr < 0) {
>>>           /* usage of interrupt is optional */
>>>           data->irqnr = -1;
>>>       } else {
>>
>>
>> After this change I'm not sure we need this branch at all, I mean that 
>> -errn is
>> equal to -1 in the code (but needs to be checked for silly checks like 
>> == -1).
>>
>> Hence
>>
>> Entire excerpt can be replaced with
>>
>>     if (data->irqnr > 0) {
>>
> 
> I agree. Furthermore, at a quick glance it seems the whole irqnr could 
> be dropped from the private data, and the private data struct could 
> probably be static. I'd send them as separate clean-ups though as those 
> changes are not really related to this return-value series.

Please, ignore everything I wrote above, except that I agree to your 
suggestion. I was writing utter nonsense. Sorry for the noise.

> 
> Yours,
>      -- Matti
> 

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


