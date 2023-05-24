Return-Path: <netdev+bounces-5174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7653710003
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E4391C20D42
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEDD22634;
	Wed, 24 May 2023 21:29:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5537422627
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 21:29:30 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54992132;
	Wed, 24 May 2023 14:29:28 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34OLT2i8064437;
	Wed, 24 May 2023 16:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684963742;
	bh=e4GDbMukzYM0sutIg07akQTX4m7teKg+iSzWf6JpbVw=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=osx4bQruuwfuw/qTFQTJi70kmOO9xoW5EbPAmzdfupB844Gj4QdAoglP+DmHV+2Oy
	 zv1H4PxxOFmGNej8TT5KPGmbb+bOhpxap8HmZ86fpAOb5Vu4SQbPRoR/vpgoRKFSmQ
	 fHKE6aJWNJORuKCAM92E00NL24xQPHihIVWAM/DA=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34OLT2jn105929
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 24 May 2023 16:29:02 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 24
 May 2023 16:29:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 24 May 2023 16:29:01 -0500
Received: from [128.247.81.105] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34OLT1fJ007319;
	Wed, 24 May 2023 16:29:01 -0500
Message-ID: <8985ea03-a7dc-a0bc-a238-3099caadf740@ti.com>
Date: Wed, 24 May 2023 16:29:01 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>, Wolfgang Grandegger <wg@grandegger.com>,
        Marc
 Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo
 Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tony
 Lindgren <tony@atomide.com>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-3-jm@ti.com> <ZGyfAhp8op4GMElN@corigine.com>
From: Judith Mendez <jm@ti.com>
In-Reply-To: <ZGyfAhp8op4GMElN@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Simon,

On 5/23/23 6:09 AM, Simon Horman wrote:
> On Mon, May 22, 2023 at 09:37:49PM -0500, Judith Mendez wrote:
>> Add an hrtimer to MCAN class device. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found in
>> device tree M_CAN node.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
> 
> ...
> 
>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>> index 94dc82644113..b639c9e645d3 100644
>> --- a/drivers/net/can/m_can/m_can_platform.c
>> +++ b/drivers/net/can/m_can/m_can_platform.c
>> @@ -5,6 +5,7 @@
>>   //
>>   // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
>>   
>> +#include <linux/hrtimer.h>
>>   #include <linux/phy/phy.h>
>>   #include <linux/platform_device.h>
>>   
>> @@ -96,12 +97,30 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>   		goto probe_fail;
>>   
>>   	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>> -	irq = platform_get_irq_byname(pdev, "int0");
>> -	if (IS_ERR(addr) || irq < 0) {
>> -		ret = -EINVAL;
>> +	if (IS_ERR(addr)) {
>> +		ret = PTR_ERR(addr);
>>   		goto probe_fail;
>>   	}
>>   
>> +	if (device_property_present(mcan_class->dev, "interrupts") ||
>> +	    device_property_present(mcan_class->dev, "interrupt-names")) {
>> +		irq = platform_get_irq_byname(pdev, "int0");
>> +		mcan_class->polling = false;
>> +		if (irq == -EPROBE_DEFER) {
>> +			ret = -EPROBE_DEFER;
>> +			goto probe_fail;
>> +		}
>> +		if (irq < 0) {
>> +			ret = -ENXIO;
>> +			goto probe_fail;
>> +		}
>> +	} else {
>> +		mcan_class->polling = true;
>> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
>> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
>> +			     HRTIMER_MODE_REL_PINNED);
>> +	}
> 
> Hi Judith,
> 
> it seems that with this change irq is only set in the first arm of
> the above conditional. But later on it is used unconditionally.
> That is, it may be used uninitialised.
> 
> Reported by gcc-12 as:
> 
>   drivers/net/can/m_can/m_can_platform.c: In function 'm_can_plat_probe':
>   drivers/net/can/m_can/m_can_platform.c:150:30: warning: 'irq' may be used uninitialized [-Wmaybe-uninitialized]
>     150 |         mcan_class->net->irq = irq;
>         |         ~~~~~~~~~~~~~~~~~~~~~^~~~~
>   drivers/net/can/m_can/m_can_platform.c:86:13: note: 'irq' was declared here
>      86 |         int irq, ret = 0;
>         |             ^~~
> 

Maybe a good solution is to initialize irq=0 here.

>> +
>>   	/* message ram could be shared */
>>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
>>   	if (!res) {
>> -- 
>> 2.17.1


~Judith

