Return-Path: <netdev+bounces-3815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D07AD708F15
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE2851C20BCE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA344643;
	Fri, 19 May 2023 05:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7517C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 05:00:43 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08B5198A;
	Thu, 18 May 2023 22:00:32 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4eff4ea8e39so3149341e87.1;
        Thu, 18 May 2023 22:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684472430; x=1687064430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JfbxFVUmc/KzvVhEC8vdQgF5kFe1WFt3rzR4UINE0fo=;
        b=BFi0u5sIoEnnX4okI+aOE7hqReySKr/IeZj7zzxVZhgribIxFlafyHNvVilTaGLzmN
         knIms4YLm7U1y/I5CNlsVXcBP9x8QeZROW5X41r24p2hhc7Ht3Y4EDGjq93s+4l3lDsJ
         Pk/DbGLMigKfroPs0SUi9ijtAABZtaIECKrtHjRAj4DFK6yRhSltBg58NMpe4kky+Z5O
         VR84UsYsFePdUZ8Ndp3YYDRJmnp1CZ6RWZ5xZ1xMg3MBPh2F2h1/Q+8YX8HR0dCfZZNo
         ZwiEpoF6NMGYC9Ro0HSPdvsk7wNlp2nw4vOoWzS/zWeG4WYgrDi7X3Gbvss9CZVlDv8q
         oVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684472430; x=1687064430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfbxFVUmc/KzvVhEC8vdQgF5kFe1WFt3rzR4UINE0fo=;
        b=jBCIvaJXkIPkyRLULvJYXewhUmpnIy6ICOms4Bv3nLFzAr+oZAa0dpwrninDcM0sn/
         AJl4fvps5X6mM92KD/xA1DSJJON+5yNlkc2lO3xA2tI+4DtuhhbR3uaur5WPOUWQHHMz
         EutDu0ikgvlDV3id+xsf84RjpkUF/ECVdHLM4UasLYeIwo2pisytu061WAa1KBCU4DLm
         /Mb5qWvmsC0saOaOKY9qf5g2QWBtb/nnldUD+8LABnIox2F7s5WBo4cLeHZpflmuJhIi
         FxyYYJNbInQF0smtKG7RCFMY52S++rCJJuAmSW5npCYyTEZOsp2MzbEG4GMYDG/2Vx9/
         EPZg==
X-Gm-Message-State: AC+VfDzREo2Jr5BHxuamUlnoSxeoqwMEEKoLSEJg937rhPXos4LGR16O
	voFUb78BLtxLLAdrnpdwOAk=
X-Google-Smtp-Source: ACHHUZ4VR47UvOx+IPM4HXNSDpSzTFPO0t3QVDvnSvGmOpkMfDVf6cQwy6rSnQkrabXwi7lrCaHYdg==
X-Received: by 2002:ac2:5e81:0:b0:4f3:872d:10ff with SMTP id b1-20020ac25e81000000b004f3872d10ffmr313027lfq.64.1684472429409;
        Thu, 18 May 2023 22:00:29 -0700 (PDT)
Received: from [192.168.1.126] (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id w4-20020a05651204c400b004db3900da02sm467200lfq.73.2023.05.18.22.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 22:00:28 -0700 (PDT)
Message-ID: <1a3a84d4-1955-f0ee-5c6d-ab36fddc5e15@gmail.com>
Date: Fri, 19 May 2023 08:00:27 +0300
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
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <ZGUFJ5LRCzW2V0a1@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 19:47, Andy Shevchenko wrote:
> On Tue, May 16, 2023 at 10:12:41AM +0300, Matti Vaittinen wrote:
>> fwnode_irq_get() was changed to not return 0 anymore.
>>
>> Drop check for return value 0.
> 
> ...
> 
>> -	if (data->irqnr <= 0) {
>> +	if (data->irqnr < 0) {
>>   		/* usage of interrupt is optional */
>>   		data->irqnr = -1;
>>   	} else {
> 
> 
> After this change I'm not sure we need this branch at all, I mean that -errn is
> equal to -1 in the code (but needs to be checked for silly checks like == -1).
> 
> Hence
> 
> Entire excerpt can be replaced with
> 
> 	if (data->irqnr > 0) {
> 

I agree. Furthermore, at a quick glance it seems the whole irqnr could 
be dropped from the private data, and the private data struct could 
probably be static. I'd send them as separate clean-ups though as those 
changes are not really related to this return-value series.

Yours,
	-- Matti

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~


