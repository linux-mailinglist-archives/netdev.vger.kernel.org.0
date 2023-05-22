Return-Path: <netdev+bounces-4407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C4070C59C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55FED280FAF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67839168BF;
	Mon, 22 May 2023 19:00:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F12168AF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:00:47 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D8FE;
	Mon, 22 May 2023 12:00:45 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34MJ062m122270;
	Mon, 22 May 2023 14:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684782006;
	bh=u0kzNDOOGbGz18201uqKyKCn8aM34jRLRTzxtQalNhA=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=rcqg8sD/AXsQbbITTBfWVQRSoXotFNmdekksmpeHKcwyOWWm/sWzF9iVeKk8RoYoK
	 0B1VgMAusETjmNUwOgYt7MaP//na8mNxdeFZltbU4owLwdPfuXIxDmICDYfi17J96i
	 56P3imKEaXBJ/c5VStki+WaC7fVriRhZNd0F70TE=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34MJ036R028442
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 22 May 2023 14:00:06 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 22
 May 2023 14:00:04 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 22 May 2023 14:00:04 -0500
Received: from [128.247.81.105] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34MJ04lW119935;
	Mon, 22 May 2023 14:00:04 -0500
Message-ID: <31925752-8028-98fc-b6a4-9b8fe8a3ce0b@ti.com>
Date: Mon, 22 May 2023 14:00:04 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 2/2] can: m_can: Add hrtimer to generate software
 interrupt
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>, Wolfgang Grandegger <wg@grandegger.com>,
        "David
 S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton
	<spatton@ti.com>,
        Tero Kristo <kristo@kernel.org>, Rob Herring
	<robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Conor
 Dooley <conor+dt@kernel.org>
References: <20230518193613.15185-1-jm@ti.com>
 <20230518193613.15185-3-jm@ti.com>
 <20230519-morbidity-directory-dbe704584aa3-mkl@pengutronix.de>
 <3859166d-fc78-f42d-1553-282e4140325a@ti.com>
 <20230522-manhunt-smooth-442d9d864f04-mkl@pengutronix.de>
Content-Language: en-US
From: Judith Mendez <jm@ti.com>
In-Reply-To: <20230522-manhunt-smooth-442d9d864f04-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On 5/22/23 1:37 PM, Marc Kleine-Budde wrote:
> On 22.05.2023 10:17:38, Judith Mendez wrote:
>>>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>>>> index 94dc82644113..3e60cebd9d12 100644
>>>> --- a/drivers/net/can/m_can/m_can_platform.c
>>>> +++ b/drivers/net/can/m_can/m_can_platform.c
>>>> @@ -5,6 +5,7 @@
>>>>    //
>>>>    // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
>>>> +#include <linux/hrtimer.h>
>>>>    #include <linux/phy/phy.h>
>>>>    #include <linux/platform_device.h>
>>>> @@ -96,12 +97,40 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>>>    		goto probe_fail;
>>>>    	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>>>> -	irq = platform_get_irq_byname(pdev, "int0");
>>>> -	if (IS_ERR(addr) || irq < 0) {
>>>> -		ret = -EINVAL;
>>>> +	if (IS_ERR(addr)) {
>>>> +		ret = PTR_ERR(addr);
>>>>    		goto probe_fail;
>>>>    	}
>>>
>>> As we don't use an explicit "poll-interval" anymore, this needs some
>>> cleanup. The flow should be (pseudo code, error handling omitted):
>>>
>>> if (device_property_present("interrupts") {
>>>           platform_get_irq_byname();
>>>           polling = false;
>>> } else {
>>>           hrtimer_init();
>>>           polling = true;
>>> }
>>
>> Ok.
>>
>>>
>>>> +	irq = platform_get_irq_byname_optional(pdev, "int0");
>>>
>>> Remove the "_optional" and....
>>
>> On V2, you asked to add the _optional?.....
>>
>>>   	irq = platform_get_irq_byname(pdev, "int0");
>>
>> use platform_get_irq_byname_optional(), it doesn't print an error
>> message.
> 
> ACK - I said that back in v2, when there was "poll-interval". But now we
> don't use "poll-interval" anymore, but test if interrupt properties are
> present.
> 
> See again pseudo-code I posted in my last mail:
> 
> | if (device_property_present("interrupts") {
> |          platform_get_irq_byname();
> 
> If this throws an error, it's fatal, bail out.
> 
> |          polling = false;
> | } else {
> |          hrtimer_init();
> |          polling = true;
> | }
> 

Ok, will add this then..


>>
>>>
>>>> +	if (irq == -EPROBE_DEFER) {
>>>> +		ret = -EPROBE_DEFER;
>>>> +		goto probe_fail;
>>>> +	}
>>>> +
>>>> +	if (device_property_present(mcan_class->dev, "interrupts") ||
>>>> +	    device_property_present(mcan_class->dev, "interrupt-names"))
>>>> +		mcan_class->polling = false;
>>>
>>> ...move the platform_get_irq_byname() here
>>
>> ok,
>>
>>>
>>>> +	else
>>>> +		mcan_class->polling = true;
>>>> +
>>>> +	if (!mcan_class->polling && irq < 0) {
>>>> +		ret = -ENXIO;
>>>> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found, polling not activated\n");
>>>> +		goto probe_fail;
>>>> +	}
>>>
>>> Remove this check.
>>
>> Should we not go to 'probe fail' if polling is not activated and irq is not
>> found?
> 
> If an interrupt property is present in the DT, we use it - if request
> IRQ fails, something is broken and we've already bailed out. See above.
> If there is no interrupt property we use polling.

Got it, thanks.

>>
>>>
>>>> +
>>>> +	if (mcan_class->polling) {
>>>> +		if (irq > 0) {
>>>> +			mcan_class->polling = false;
>>>> +			dev_info(mcan_class->dev, "Polling enabled, using hardware IRQ\n");
>>>
>>> Remove this.
>>
>> Remove the dev_info?
> 
> ACK, this is not possible anymore - we cannot have polling enabled and
> HW IRQs configured.

Sounds good, will submit a v7 with these cleanup changes.

regards,
Judith

