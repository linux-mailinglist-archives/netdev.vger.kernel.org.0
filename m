Return-Path: <netdev+bounces-5172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B788570FFE7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 249DE1C20D68
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408CF2262F;
	Wed, 24 May 2023 21:20:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6792260D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 21:20:49 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9B2132;
	Wed, 24 May 2023 14:20:45 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34OLKFGp073915;
	Wed, 24 May 2023 16:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684963215;
	bh=Anjqsreye1B4ntfPOBld6ZtkWYZAP0DjCad9lmUAkGE=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=uQVDZHbmTkpA/mH3J5yqgWVx2chzOoe0h/S9rI0FvmWZg2RLr8kCNiD+0QI/l7vN7
	 GHz9zCK1uhebWqdfMjN3GVdd85YboWrt2a2CcVyggl1AIqVb6lrYn8rF+RPNqE36Ze
	 v3G0ScixR4azV1CH8ODECmuYMLsxDuRC9nEG+D4A=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34OLKFcM030529
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 24 May 2023 16:20:15 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 24
 May 2023 16:20:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 24 May 2023 16:20:15 -0500
Received: from [128.247.81.105] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34OLKFEC109050;
	Wed, 24 May 2023 16:20:15 -0500
Message-ID: <351cbfcc-a3be-ff23-ead7-5fc38013ecbb@ti.com>
Date: Wed, 24 May 2023 16:20:15 -0500
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
        Conor Dooley <conor+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tony
 Lindgren <tony@atomide.com>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-3-jm@ti.com>
 <20230523-crawlers-cupbearer-7a7cbfed010b-mkl@pengutronix.de>
From: Judith Mendez <jm@ti.com>
In-Reply-To: <20230523-crawlers-cupbearer-7a7cbfed010b-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Marc,

On 5/23/23 1:35 AM, Marc Kleine-Budde wrote:
> On 22.05.2023 21:37:49, Judith Mendez wrote:
>> Add an hrtimer to MCAN class device. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found in
>> device tree M_CAN node.
> 
> Please add a sentence why you introduce polling mode, i.e. there are
> SoCs where the M_CAN interrupt is not available on the CPUs (which are
> running Linux).

Sure, I can do that, thanks.

> 
>> The hrtimer will generate a software interrupt every 1 ms. In
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>> Changelog:
>> v7:
>> - Clean up m_can_platform.c if/else section after removing poll-interval
>> - Remove poll-interval from patch description
>> v6:
>> - Move hrtimer stop/start function calls to m_can_open and m_can_close to
>> support power suspend/resume
>> v5:
>> - Change dev_dbg to dev_info if hardware interrupt exists and polling
>> is enabled
>> v4:
>> - No changes
>> v3:
>> - Create a define for 1 ms polling interval
>> - Change plarform_get_irq to optional to not print error msg
>> v2:
>> - Add functionality to check for 'poll-interval' property in MCAN node
>> - Add 'polling' flag in driver to check if device is using polling method
>> - Check for timer polling and hardware interrupt cases, default to
>> hardware interrupt method
>> - Change ns_to_ktime() to ms_to_ktime()
>> ---
>>   drivers/net/can/m_can/m_can.c          | 33 ++++++++++++++++++++++++--
>>   drivers/net/can/m_can/m_can.h          |  4 ++++
>>   drivers/net/can/m_can/m_can_platform.c | 25 ++++++++++++++++---
>>   3 files changed, 57 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index a5003435802b..f273d989bdff 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/bitfield.h>
>>   #include <linux/can/dev.h>
>>   #include <linux/ethtool.h>
>> +#include <linux/hrtimer.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/io.h>
>>   #include <linux/iopoll.h>
>> @@ -308,6 +309,9 @@ enum m_can_reg {
>>   #define TX_EVENT_MM_MASK	GENMASK(31, 24)
>>   #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
>>   
>> +/* Hrtimer polling interval */
>> +#define HRTIMER_POLL_INTERVAL		1
>> +
>>   /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
>>    * and we can save a (potentially slow) bus round trip by combining
>>    * reads and writes to them.
>> @@ -895,7 +899,7 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
>>   			netdev_dbg(dev, "Arbitration phase error detected\n");
>>   			work_done += m_can_handle_lec_err(dev, lec);
>>   		}
>> -		
>> +
> 
> Unrelated change. I've send a separate patch to fix the problem.

Sorry about this, this was not intentional.

> 
>>   		if (is_lec_err(dlec)) {
>>   			netdev_dbg(dev, "Data phase error detected\n");
>>   			work_done += m_can_handle_lec_err(dev, dlec);
>> @@ -1414,6 +1418,12 @@ static int m_can_start(struct net_device *dev)
>>   
>>   	m_can_enable_all_interrupts(cdev);
>>   
>> +	if (cdev->polling) {
>> +		dev_dbg(cdev->dev, "Start hrtimer\n");
>> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
>> +			      HRTIMER_MODE_REL_PINNED);
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1571,6 +1581,11 @@ static void m_can_stop(struct net_device *dev)
>>   	/* disable all interrupts */
>>   	m_can_disable_all_interrupts(cdev);
>>   
>> +	if (cdev->polling) {
>> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
>> +		hrtimer_cancel(&cdev->hrtimer);
>> +	}
>> +
> 
> This might be a racy. Please move the disabling of the hrtimer before
> disabling all interrupts. This makes it also symmetric with respect to
> m_can_start().

This makes sense.

> 
>>   	/* Set init mode to disengage from the network */
>>   	m_can_config_endisable(cdev, true);
>>   
>> @@ -1793,6 +1808,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +static enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
>> +{
>> +	struct m_can_classdev *cdev = container_of(timer, struct
>> +						   m_can_classdev, hrtimer);
>> +
>> +	m_can_isr(0, cdev->net);
>> +
>> +	hrtimer_forward_now(timer, ms_to_ktime(HRTIMER_POLL_INTERVAL));
>> +
>> +	return HRTIMER_RESTART;
>> +}
>> +
>>   static int m_can_open(struct net_device *dev)
>>   {
>>   	struct m_can_classdev *cdev = netdev_priv(dev);
>> @@ -1831,9 +1858,11 @@ static int m_can_open(struct net_device *dev)
>>   		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
>>   					   IRQF_ONESHOT,
>>   					   dev->name, dev);
>> -	} else {
>> +	} else if (!cdev->polling) {
>>   		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>>   				  dev);
>> +	} else {
>> +		cdev->hrtimer.function = &hrtimer_callback;
> 
> I think you can move this assignment to m_can_class_register(). We only
> need to set the function once.

Great idea!

> 
>>   	}
>>   
>>   	if (err < 0) {
>> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
>> index a839dc71dc9b..e9db5cce4e68 100644
>> --- a/drivers/net/can/m_can/m_can.h
>> +++ b/drivers/net/can/m_can/m_can.h
>> @@ -15,6 +15,7 @@
>>   #include <linux/device.h>
>>   #include <linux/dma-mapping.h>
>>   #include <linux/freezer.h>
>> +#include <linux/hrtimer.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/io.h>
>>   #include <linux/iopoll.h>
>> @@ -93,6 +94,9 @@ struct m_can_classdev {
>>   	int is_peripheral;
>>   
>>   	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> +
>> +	struct hrtimer hrtimer;
>> +	bool polling;
>>   };
>>   
>>   struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
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
> 
> I think irq will be uninitialized after this change. Although the
> compiler doesn't complain :(

Agreed, I did notice this when testing. But is it an issue?

> 
> BTW: I think we don't need the "polling" variable in the priv. We can
> make use of "irq". "irq" being 0 means use polling.

True, but is using the polling flag easier for the user to read?

> 
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

EINVAL? Wouldn't ENXIO (No such device or address) be more appropriate than
invalid argument?

> 
> Please return the original error code.
> 
>> +			goto probe_fail;
>> +		}
>> +	} else {
>> +		mcan_class->polling = true;
>> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
>> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
>> +			     HRTIMER_MODE_REL_PINNED);
>> +	}
>> +
>>   	/* message ram could be shared */
>>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
>>   	if (!res) {

~Judith

