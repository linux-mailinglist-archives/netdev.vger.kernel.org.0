Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BB68DA46
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjBGOPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbjBGOO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:14:57 -0500
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFA96A51;
        Tue,  7 Feb 2023 06:14:55 -0800 (PST)
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317ArBxI023356;
        Tue, 7 Feb 2023 15:12:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=bRPLjENYLm4EkeQxpcXBxnDMwaCRtrrOyJyCcEKFKwM=;
 b=v+r2Y+dW5qpe2evs4+p2Rph0HUeYJkhrIakAtRF4fJW7pf/iMoA2BrjUcXOgAS4O+JMl
 IXKV7Hp74w1KJP0PvEekg8P/i3SR3P0AwBgPlA+9ojsAnk0s7LDy3CWyXOWlKcwqqPfu
 wPE7CdTQ6u+DTonaxS8J7QYwU2uD3eROQ4b0UVJqA3TaS3QYgy35kLMkIT8d6Z2toWJ5
 tMeMMxNPT8PXIpemJJgIQyZVYQ9Vv2xTMUAyQ8CNlfu2WPa6wKy9p9vIs1O/gAb/LlqC
 1+7jKtxsEn7AYZrcWlego6inAn0ozOi+IQs8ea9RiHb5iRVStFIyQmQyADvaliPIL6nK lw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3nhfk72dkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 15:12:28 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 763D6100034;
        Tue,  7 Feb 2023 15:12:27 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 48EEA21B516;
        Tue,  7 Feb 2023 15:12:27 +0100 (CET)
Received: from [10.201.20.249] (10.201.20.249) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Tue, 7 Feb
 2023 15:12:24 +0100
Message-ID: <d6c659d8-2e5c-cb60-d950-685c4ba319e2@foss.st.com>
Date:   Tue, 7 Feb 2023 15:12:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 4/6] bus: stm32_sys_bus: add support for STM32MP15 and
 STM32MP13 system bus
Content-Language: en-US
To:     Jonathan Cameron <jic23@kernel.org>
CC:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <olivier.moysan@foss.st.com>, <arnaud.pouliquen@foss.st.com>,
        <mchehab@kernel.org>, <fabrice.gasnier@foss.st.com>,
        <ulf.hansson@linaro.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
 <20230127164040.1047583-5-gatien.chevallier@foss.st.com>
 <20230128161217.0e79436e@jic23-huawei>
From:   Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20230128161217.0e79436e@jic23-huawei>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.20.249]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_05,2023-02-06_03,2022-06-22_01
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On 1/28/23 17:12, Jonathan Cameron wrote:
> On Fri, 27 Jan 2023 17:40:38 +0100
> Gatien Chevallier <gatien.chevallier@foss.st.com> wrote:
> 
>> This driver is checking the access rights of the different
>> peripherals connected to the system bus. If access is denied,
>> the associated device tree node is skipped so the platform bus
>> does not probe it.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> Signed-off-by: Loic PALLARDY <loic.pallardy@st.com>
> 
> Hi Gatien,
> 
> A few comments inline,
> 
> Thanks,
> 
> Jonathan
> 
>> diff --git a/drivers/bus/stm32_sys_bus.c b/drivers/bus/stm32_sys_bus.c
>> new file mode 100644
>> index 000000000000..c12926466bae
>> --- /dev/null
>> +++ b/drivers/bus/stm32_sys_bus.c
>> @@ -0,0 +1,168 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023, STMicroelectronics - All Rights Reserved
>> + */
>> +
>> +#include <linux/bitfield.h>
>> +#include <linux/bits.h>
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/platform_device.h>
>> +
>> +/* ETZPC peripheral as firewall bus */
>> +/* ETZPC registers */
>> +#define ETZPC_DECPROT			0x10
>> +
>> +/* ETZPC miscellaneous */
>> +#define ETZPC_PROT_MASK			GENMASK(1, 0)
>> +#define ETZPC_PROT_A7NS			0x3
>> +#define ETZPC_DECPROT_SHIFT		1
> 
> This define makes the code harder to read.  What we care about is
> the number of bits in the register divided by number of entries.
> (which is 2) hence the shift by 1. See below for more on this.
> 
> 
>> +
>> +#define IDS_PER_DECPROT_REGS		16
> 
>> +#define STM32MP15_ETZPC_ENTRIES		96
>> +#define STM32MP13_ETZPC_ENTRIES		64
> 
> These defines just make the code harder to check.
> They aren't magic numbers, but rather just telling us how many
> entries there are, so I would just put them in the structures directly.
> Their use make it clear what they are without needing to give them a name.
> 

Honestly, I'd rather read the hardware configuration registers to get 
this information instead of differentiating MP13/15. Would you agree on 
that?

> 
>> +struct stm32_sys_bus_match_data {
> 
> Comment on naming of this below.
> 
>> +	unsigned int max_entries;
>> +};
>> +
> 
> +static int stm32_etzpc_get_access(struct sys_bus_data *pdata, struct device_node *np)
> +{
> +	int err;
> +	u32 offset, reg_offset, sec_val, id;
> +
> +	err = stm32_sys_bus_get_periph_id(pdata, np, &id);
> +	if (err)
> +		return err;
> +
> +	/* Check access configuration, 16 peripherals per register */
> +	reg_offset = ETZPC_DECPROT + 0x4 * (id / IDS_PER_DECPROT_REGS);
> +	offset = (id % IDS_PER_DECPROT_REGS) << ETZPC_DECPROT_SHIFT;
> 
> Use of defines in here is actively unhelpful when it comes to review. I would suggest letting
> the maths be self explanatory (even if it's more code).
> 
> 	offset = (id % IDS_PER_DECPROT_REGS) * (sizeof(u32) * BITS_PER_BYTE / IDS_PER_DECPROT_REGS);
> 
> Or if you prefer have a define of
> 
> #define DECPROT_BITS_PER_ID (sizeof(u32) * BITS_PER_BYTE / IDS_PER_DECPROT_REGS)
> 
> and
> 	offset = (id % IDS_PER_DECPROT_REGS) * DECPROT_BITS_PER_ID;
> 

Ok I'll rework this for better understanding. Your suggestion seems fine

> +
> +	/* Verify peripheral is non-secure and attributed to cortex A7 */
> +	sec_val = (readl(pdata->sys_bus_base + reg_offset) >> offset) & ETZPC_PROT_MASK;
> +	if (sec_val != ETZPC_PROT_A7NS) {
> +		dev_dbg(pdata->dev, "Invalid bus configuration: reg_offset %#x, value %d\n",
> +			reg_offset, sec_val);
> +		return -EACCES;
> +	}
> +
> +	return 0;
> +}
> +
> ...
> 
>> +static int stm32_sys_bus_probe(struct platform_device *pdev)
>> +{
>> +	struct sys_bus_data *pdata;
>> +	void __iomem *mmio;
>> +	struct device_node *np = pdev->dev.of_node;
> 
> I'd be consistent. You use dev_of_node() accessor elsewhere, so should
> use it here as well >> +
>> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>> +	if (!pdata)
>> +		return -ENOMEM;
>> +
>> +	mmio = devm_platform_ioremap_resource(pdev, 0);
>> +	if (IS_ERR(mmio))
>> +		return PTR_ERR(mmio);
>> +
>> +	pdata->sys_bus_base = mmio;
>> +	pdata->pconf = of_device_get_match_data(&pdev->dev);
>> +	pdata->dev = &pdev->dev;
>> +
>> +	platform_set_drvdata(pdev, pdata);
> 
> Does this get used? I can't immediately spot where but maybe I just
> missed it.
> 

Not for now :)

>> +
>> +	stm32_sys_bus_populate(pdata);
>> +
>> +	/* Populate all available nodes */
>> +	return of_platform_populate(np, NULL, NULL, &pdev->dev);
> 
> As np only used here, I'd not bother with the local variable in this function.
> 

Agreed

>> +}
>> +
>> +static const struct stm32_sys_bus_match_data stm32mp15_sys_bus_data = {
> 
> Naming a structure after where it comes from is a little unusual and
> confusion when a given call gets it from somewhere else.
> 
> I'd expect it to be named after what sort of thing it contains.
> stm32_sys_bus_info or something like that.
> 

Then, this shall be removed thanks to the read to hardware registers.

>> +	.max_entries = STM32MP15_ETZPC_ENTRIES,
>> +};
>> +
>> +static const struct stm32_sys_bus_match_data stm32mp13_sys_bus_data = {
>> +	.max_entries = STM32MP13_ETZPC_ENTRIES,
>> +};
>> +
>> +static const struct of_device_id stm32_sys_bus_of_match[] = {
>> +	{ .compatible = "st,stm32mp15-sys-bus", .data = &stm32mp15_sys_bus_data },
>> +	{ .compatible = "st,stm32mp13-sys-bus", .data = &stm32mp13_sys_bus_data },
> 
> Alphabetical order usually preferred when there isn't a strong reason for
> another choice.
> 

I second that

>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(of, stm32_sys_bus_of_match);
>> +
>> +static struct platform_driver stm32_sys_bus_driver = {
>> +	.probe  = stm32_sys_bus_probe,
>> +	.driver = {
>> +		.name = "stm32-sys-bus",
>> +		.of_match_table = stm32_sys_bus_of_match,
>> +	},
>> +};
>> +
>> +static int __init stm32_sys_bus_init(void)
>> +{
>> +	return platform_driver_register(&stm32_sys_bus_driver);
>> +}
>> +arch_initcall(stm32_sys_bus_init);
>> +
> 
> Unwanted trailing blank line.
> 

Good spot, thanks

> 

Best regards,
Gatien
