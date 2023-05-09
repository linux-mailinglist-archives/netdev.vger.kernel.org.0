Return-Path: <netdev+bounces-1275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9F46FD286
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 197E42810DC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B2E182C8;
	Tue,  9 May 2023 22:18:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B031990C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:18:46 +0000 (UTC)
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FE5173B;
	Tue,  9 May 2023 15:18:41 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 349MI650127975;
	Tue, 9 May 2023 17:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683670686;
	bh=VPo0BABSLp/yxbXX4gZZ7G7cTOoL07it58TctQ+j5ik=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=FGFqDMbHMXIrXIfgOe9p+FKAufbeVHkv6noeC/6wdAOteglVO+Y047zkLUvgqSNKm
	 d32djcWLDbZpnBTwGiSxye3N74r35VrpPZX009V9Jw2fO9L5WsRWjur2d/e1boIE78
	 fs11K2clqx9U+Xg9f7re/YsX3IvUS7EsFQV6KYjM=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 349MI6FS087928
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 9 May 2023 17:18:06 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 9
 May 2023 17:18:06 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 9 May 2023 17:18:06 -0500
Received: from [128.247.81.95] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 349MI6D8046289;
	Tue, 9 May 2023 17:18:06 -0500
Message-ID: <84e5b09e-f8b9-15ae-4871-e5e4c4f4a470@ti.com>
Date: Tue, 9 May 2023 17:18:06 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software
 interrupt
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger
	<wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth
 Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Oliver
 Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-3-jm@ti.com>
 <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
Content-Language: en-US
From: Judith Mendez <jm@ti.com>
In-Reply-To: <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Marc,

On 5/2/23 01:37, Marc Kleine-Budde wrote:
> On 01.05.2023 17:46:22, Judith Mendez wrote:
>> Add an hrtimer to MCAN class device. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found and
>> poll-interval property is defined in device tree M_CAN node.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
> 
> I think this patch is as good as it gets, given the HW and SW
> limitations of the coprocessor.
> 
> Some minor nitpicks inline. No need to resend from my point of view,
> I'll fixup while applying the patch.
> 
> Marc
> 
>> ---
>> Changelog:
>> v1:
>>  1. Sort list of includes
>>  2. Create a define for HR_TIMER_POLL_INTERVAL
>>  3. Fix indentations and style issues/warnings
>>  4. Change polling variable to type bool
>>  5. Change platform_get_irq to optional so not to print error msg
>>  6. Move error check for addr directly after assignment
>>  7. Print appropriate error msg with dev_err_probe insead of dev_dbg
>>
>> v2:
>>  1. Add poll-interval to MCAN class device to check if poll-interval propery is
>>     present in MCAN node, this enables timer polling method
>>  2. Add 'polling' flag to MCAN class device to check if a device is using timer
>>     polling method
>>  3. Check if both timer polling and hardware interrupt are enabled for a MCAN
>>     device, default to hardware interrupt mode if both are enabled
>>  4. Change ms_to_ktime() to ns_to_ktime()
>>  5. Remove newlines, tabs, and restructure if/else section
>>  
>>  drivers/net/can/m_can/m_can.c          | 29 +++++++++++++++++++++--
>>  drivers/net/can/m_can/m_can.h          |  4 ++++
>>  drivers/net/can/m_can/m_can_platform.c | 32 +++++++++++++++++++++++---
>>  3 files changed, 60 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index a5003435802b..e1ac0c1d85a3 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/bitfield.h>
>>  #include <linux/can/dev.h>
>>  #include <linux/ethtool.h>
>> +#include <linux/hrtimer.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/io.h>
>>  #include <linux/iopoll.h>
>> @@ -308,6 +309,9 @@ enum m_can_reg {
>>  #define TX_EVENT_MM_MASK	GENMASK(31, 24)
>>  #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
>>  
>> +/* Hrtimer polling interval */
>> +#define HRTIMER_POLL_INTERVAL		1
>> +
>>  /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
>>   * and we can save a (potentially slow) bus round trip by combining
>>   * reads and writes to them.
>> @@ -1587,6 +1591,11 @@ static int m_can_close(struct net_device *dev)
>>  	if (!cdev->is_peripheral)
>>  		napi_disable(&cdev->napi);
>>  
>> +	if (cdev->polling) {
>> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
>> +		hrtimer_cancel(&cdev->hrtimer);
>> +	}
>> +
>>  	m_can_stop(dev);
>>  	m_can_clk_stop(cdev);
>>  	free_irq(dev->irq, dev);
>> @@ -1793,6 +1802,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>>  	return NETDEV_TX_OK;
>>  }
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
>>  static int m_can_open(struct net_device *dev)
>>  {
>>  	struct m_can_classdev *cdev = netdev_priv(dev);
>> @@ -1827,13 +1848,17 @@ static int m_can_open(struct net_device *dev)
>>  		}
>>  
>>  		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
>> -
> 
> unrelated change
> 
>>  		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
>>  					   IRQF_ONESHOT,
>>  					   dev->name, dev);
>> -	} else {
>> +	} else if (!cdev->polling) {
>>  		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>>  				  dev);
>> +	} else {
>> +		dev_dbg(cdev->dev, "Start hrtimer\n");
>> +		cdev->hrtimer.function = &hrtimer_callback;
>> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
>> +			      HRTIMER_MODE_REL_PINNED);
>>  	}
>>  
>>  	if (err < 0) {
>> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
>> index a839dc71dc9b..e9db5cce4e68 100644
>> --- a/drivers/net/can/m_can/m_can.h
>> +++ b/drivers/net/can/m_can/m_can.h
>> @@ -15,6 +15,7 @@
>>  #include <linux/device.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/freezer.h>
>> +#include <linux/hrtimer.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/io.h>
>>  #include <linux/iopoll.h>
>> @@ -93,6 +94,9 @@ struct m_can_classdev {
>>  	int is_peripheral;
>>  
>>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> +
>> +	struct hrtimer hrtimer;
>> +	bool polling;
>>  };
>>  
>>  struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>> index 9c1dcf838006..0fcb436298f8 100644
>> --- a/drivers/net/can/m_can/m_can_platform.c
>> +++ b/drivers/net/can/m_can/m_can_platform.c
>> @@ -5,6 +5,7 @@
>>  //
>>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
>>  
>> +#include <linux/hrtimer.h>
>>  #include <linux/phy/phy.h>
>>  #include <linux/platform_device.h>
>>  
>> @@ -96,12 +97,37 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>  		goto probe_fail;
>>  
>>  	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>> -	irq = platform_get_irq_byname(pdev, "int0");
>> -	if (IS_ERR(addr) || irq < 0) {
>> -		ret = -EINVAL;
>> +	if (IS_ERR(addr)) {
>> +		ret = PTR_ERR(addr);
>>  		goto probe_fail;
>>  	}
>>  
>> +	irq = platform_get_irq_byname_optional(pdev, "int0");
>> +	if (irq == -EPROBE_DEFER) {
>> +		ret = -EPROBE_DEFER;
>> +		goto probe_fail;
>> +	}
>> +
>> +	if (device_property_present(mcan_class->dev, "poll-interval"))
>> +		mcan_class->polling = 1;
> 
> true
> 
>> +
>> +	if (!mcan_class->polling && irq < 0) {
>> +		ret = -ENXIO;
>> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found and polling not activated\n");
>> +		goto probe_fail;
>> +	}
>> +
>> +	if (mcan_class->polling) {
>> +		if (irq > 0) {
>> +			mcan_class->polling = 0;
> 
> false
> 
>> +			dev_dbg(mcan_class->dev, "Polling enabled and hardware IRQ found, use hardware IRQ\n");
> 
> "...using hardware IRQ"
> 
> Use dev_info(), as there is something not 100% correct with the DT.

Is it dev_info or dev_dbg? I used to have dev_info since it was nice to see when polling was
enabled. Also, I had seen this print and the next as informative prints, hence the dev_info().
However, I was told in this review process to change to dev_dbg. Which is correct?

>> +		} else {
>> +			dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
>> +			hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
>> +				     HRTIMER_MODE_REL_PINNED);
>> +		}
>> +	}
>> +
>>  	/* message ram could be shared */
>>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
>>  	if (!res) {
>> -- 
>> 2.17.1
>>
>>
> 

regards,
Judith

