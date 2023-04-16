Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB63D6E380A
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjDPMgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjDPMgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:36:23 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D3D2127;
        Sun, 16 Apr 2023 05:36:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681648397; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GnggELMCxxFRPmgSUsNqxykb1r16VuqNLwt6tSaiNLtaaGbimwlLLIx+mchgqhmC5R
    9o006fjlCLY29DblZYAEO7tNNYagQqf8IoivVA4VZzYCO2BVnoNhVvv9e0+jo430zrjs
    t6zn3PmPAl5sAD7eloLRFhWmrgnH2pVWWxYgphgzhvxPNlLxLhZ2RK8g8tczGfxBA8p2
    I9DGscWxHLNx/MzWN/KPwj9BfAHv/qNb3fHdyXTyIguIp9D0OwxdcC06I7Eavh2QV9Rz
    n4IgFc1TeONGhflTbQKqZnrc7VG71IDwLr3Fp6P9PCpSQ6KA98+70PeUj4K8RqijlgfM
    J6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681648397;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IKBUJF6tZX/jXw35f486xVBREJLR9ANrCysZJ8pX18o=;
    b=Ql8IPZb1g2ceSCX5yqJHRdrk2vPnuZVKj0DxzqVaMGNF6Fa8mTIuxA8xmewXKty6vV
    CbbdEa6nkDFMe7CYtbt9BXvYpuZDjHx3tyL3D4BonotSMN3qahgYof2YSUnsXdkE1c8a
    iKftj38FXPL91/w0Hdlz4EVQKQ+iLQEG231g7ae2e92KHnp/9kkTCqyTjbui2+xyHpox
    TaJQoo7vi49kvfW+DoNyaEvoH7B0LJdpCECgrx0Oib4CKmKt3KXQtd7eOtmUzxnuapwS
    eZBtia+S+0u/MqGwVQVyu0OCZfwjNrvzPC32scxwNEVWHGcjuUt17yCQ2586F66ZB6W5
    t3QA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681648397;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IKBUJF6tZX/jXw35f486xVBREJLR9ANrCysZJ8pX18o=;
    b=NyM4PPqeDa3ugRYF+mjgrhtpIfqE+9W9pR9ZXFeDzAg2aPhPdJmuc0fB+SIDJimcLf
    IvDYuB8byRqdYyUAEbLMeTZMnHLsSdu1OvYC6ugrEH2CkjW+AOJW62MW6QbPr0+Jx7Az
    A/5GaRR/vMjT+/sO0BGzYD87Oj/of7dBKdpRMY5QGxSXDtKiyHeqKcn3EZqslIOa8lmq
    vtAzYrE1HGlm0zbxbUz5QGzZcdm4F1ZFdfCuY439jvH638q6PZJ8DVba9jq7vhp1bA/O
    QdZamburdlOuDYOTPInyPBFaXiIlaQZRxFiWHtBLhB6vXu20Zb52UBQ6hnhwh158Nd3E
    Mr/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681648397;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IKBUJF6tZX/jXw35f486xVBREJLR9ANrCysZJ8pX18o=;
    b=rN1MJWIkjV6/zDin0Iz85QSrhUjH+SFBtFS0k6RjJH1zON7WYXP5otZBLr5YNJbzTZ
    4SjmyQlvvkB8WzGJp3Aw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbVLYqA=="
Received: from [IPV6:2a00:6020:4a8e:5000::83c]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3GCXGS6h
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 16 Apr 2023 14:33:16 +0200 (CEST)
Message-ID: <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
Date:   Sun, 16 Apr 2023 14:33:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>, Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/23 20:20, Marc Kleine-Budde wrote:
> On 13.04.2023 17:30:51, Judith Mendez wrote:
>> Add a hrtimer to MCAN struct. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
> 
> Are you sure about the 1ms?

The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC 
= 0 and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit => 
~50 usecs

So it should be something about

     50 usecs * (FIFO queue len - 2)

if there is some FIFO involved, right?

Best regards,
Oliver

>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>>   drivers/net/can/m_can/m_can.c          | 24 ++++++++++++++++++++++--
>>   drivers/net/can/m_can/m_can.h          |  3 +++
>>   drivers/net/can/m_can/m_can_platform.c |  9 +++++++--
>>   3 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index 8e83d6963d85..bb9d53f4d3cc 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/pinctrl/consumer.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/hrtimer.h>
>>   
>>   #include "m_can.h"
>>   
>> @@ -1584,6 +1585,11 @@ static int m_can_close(struct net_device *dev)
>>   	if (!cdev->is_peripheral)
>>   		napi_disable(&cdev->napi);
>>   
>> +	if (dev->irq < 0) {
>> +		dev_info(cdev->dev, "Disabling the hrtimer\n");
> 
> Make it a dev_dbg() or remove completely.
> 
>> +		hrtimer_cancel(&cdev->hrtimer);
>> +	}
>> +
>>   	m_can_stop(dev);
>>   	m_can_clk_stop(cdev);
>>   	free_irq(dev->irq, dev);
>> @@ -1792,6 +1798,19 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
>> +{
>> +	irqreturn_t ret;
> 
> never read value?
> 
>> +	struct m_can_classdev *cdev =
>> +		container_of(timer, struct m_can_classdev, hrtimer);
>> +
>> +	ret = m_can_isr(0, cdev->net);
>> +
>> +	hrtimer_forward_now(timer, ns_to_ktime(5 * NSEC_PER_MSEC));
> 
> There's ms_to_ktime()....and the "5" doesn't match your patch
> description.
> 
>> +
>> +	return HRTIMER_RESTART;
>> +}
>> +
>>   static int m_can_open(struct net_device *dev)
>>   {
>>   	struct m_can_classdev *cdev = netdev_priv(dev);
>> @@ -1836,8 +1855,9 @@ static int m_can_open(struct net_device *dev)
>>   	}
>>   
>>   	if (err < 0) {
>> -		netdev_err(dev, "failed to request interrupt\n");
>> -		goto exit_irq_fail;
>> +		dev_info(cdev->dev, "Enabling the hrtimer\n");
>> +		cdev->hrtimer.function = &hrtimer_callback;
>> +		hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);
> 
> IMHO it makes no sense to request an IRQ if the device doesn't have one,
> and then try to fix up things in the error path. What about this?
> 
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1831,9 +1831,11 @@ static int m_can_open(struct net_device *dev)
>                   err = request_threaded_irq(dev->irq, NULL, m_can_isr,
>                                              IRQF_ONESHOT,
>                                              dev->name, dev);
> -        } else {
> +        } else if (dev->irq) {
>                   err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>                                     dev);
> +        } else {
> +                // polling
>           }
>   
>           if (err < 0) {
> 
>>   	}
>>   
>>   	/* start the m_can controller */
>> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
>> index a839dc71dc9b..ed046d77fdb9 100644
>> --- a/drivers/net/can/m_can/m_can.h
>> +++ b/drivers/net/can/m_can/m_can.h
>> @@ -28,6 +28,7 @@
>>   #include <linux/pm_runtime.h>
>>   #include <linux/slab.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/hrtimer.h>
>>   
>>   /* m_can lec values */
>>   enum m_can_lec_type {
>> @@ -93,6 +94,8 @@ struct m_can_classdev {
>>   	int is_peripheral;
>>   
>>   	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> +
>> +	struct hrtimer hrtimer;
>>   };
>>   
>>   struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>> index 9c1dcf838006..53e1648e9dab 100644
>> --- a/drivers/net/can/m_can/m_can_platform.c
>> +++ b/drivers/net/can/m_can/m_can_platform.c
>> @@ -7,6 +7,7 @@
>>   
>>   #include <linux/phy/phy.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/hrtimer.h>
>>   
>>   #include "m_can.h"
>>   
>> @@ -98,8 +99,12 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>   	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>>   	irq = platform_get_irq_byname(pdev, "int0");
>>   	if (IS_ERR(addr) || irq < 0) {
> 
> What about the IS_ERR(addr) case?
> 
>> -		ret = -EINVAL;
>> -		goto probe_fail;
>> +		if (irq == -EPROBE_DEFER) {
>> +			ret = -EPROBE_DEFER;
>> +			goto probe_fail;
>> +		}
>> +		dev_info(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
>> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> 
> I don't like it when polling is unconditionally set up in case of an irq
> error. I'm not sure if we need an explicit device tree property....
> 
>>   	}
>>   
>>   	/* message ram could be shared */
>> -- 
>> 2.17.1
>>
>>
> 
> Marc
> 
