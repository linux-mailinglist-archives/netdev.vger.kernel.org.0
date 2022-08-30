Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9F5A663C
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiH3OYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 10:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiH3OYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:24:50 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2EA39E;
        Tue, 30 Aug 2022 07:24:44 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A3381121;
        Tue, 30 Aug 2022 16:24:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661869482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksexceGYLzmlYsHeH0rjdnvsXlkUmLS38Dmp/YO60oQ=;
        b=vgKzVwKoXHDPNbBLh16JW5TCnOV8a8HQ798Pb8eyYspmZ3tboetf7xkqhdVTNV75NEbsgC
        DyPK+R0ZHfA3nvuUi1OfNu9br6i6h/1t6Th07icjgTwEPluILSZAOCrVzxdNsq7vr8lRp6
        zW1CjEOzHYX8mMVQaW5EgQayN4ZjLAxPeIwdf1jIRqhLZtdvTcyLfHLik39GTXW+xH0LAR
        ASXeiz99Oul80NtAzgjRaRMeoUEPC3Hqynqbv9BbgyDbRnSqz4tYgdyjrOVhdOBfPBnZoz
        VSZqUQ/03BO1K5PMYhx1KZ23RiNLReB/pIpePCho7cRjjvNXU0H6Dz4Ep29DXQ==
MIME-Version: 1.0
Date:   Tue, 30 Aug 2022 16:24:42 +0200
From:   Michael Walle <michael@walle.cc>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
In-Reply-To: <e2d91011-583e-a88d-94f9-beb194416326@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-7-michael@walle.cc>
 <e2d91011-583e-a88d-94f9-beb194416326@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ae27e9d300a9c9eca4e9ec0c702b5e0a@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-30 15:36, schrieb Srinivas Kandagatla:
> On 25/08/2022 22:44, Michael Walle wrote:
>> NVMEM layouts are used to generate NVMEM cells during runtime. Think 
>> of
>> an EEPROM with a well-defined conent. For now, the content can be
>> described by a device tree or a board file. But this only works if the
>> offsets and lengths are static and don't change. One could also argue
>> that putting the layout of the EEPROM in the device tree is the wrong
>> place. Instead, the device tree should just have a specific compatible
>> string.
>> 
>> Right now there are two use cases:
>>   (1) The NVMEM cell needs special processing. E.g. if it only 
>> specifies
>>       a base MAC address offset and you need to add an offset, or it
>>       needs to parse a MAC from ASCII format or some proprietary 
>> format.
>>       (Post processing of cells is added in a later commit).
>>   (2) u-boot environment parsing. The cells don't have a particular
>>       offset but it needs parsing the content to determine the offsets
>>       and length.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>   drivers/nvmem/Kconfig          |  2 ++
>>   drivers/nvmem/Makefile         |  1 +
>>   drivers/nvmem/core.c           | 57 
>> ++++++++++++++++++++++++++++++++++
>>   drivers/nvmem/layouts/Kconfig  |  5 +++
>>   drivers/nvmem/layouts/Makefile |  4 +++
>>   include/linux/nvmem-provider.h | 38 +++++++++++++++++++++++
>>   6 files changed, 107 insertions(+)
>>   create mode 100644 drivers/nvmem/layouts/Kconfig
>>   create mode 100644 drivers/nvmem/layouts/Makefile
> 
> update to ./Documentation/driver-api/nvmem.rst would help others.

Sure. Didn't know about that one.

>> diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
>> index bab8a29c9861..1416837b107b 100644
>> --- a/drivers/nvmem/Kconfig
>> +++ b/drivers/nvmem/Kconfig
>> @@ -357,4 +357,6 @@ config NVMEM_U_BOOT_ENV
>>     	  If compiled as module it will be called nvmem_u-boot-env.
>>   +source "drivers/nvmem/layouts/Kconfig"
>> +
>>   endif
>> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
>> index 399f9972d45b..cd5a5baa2f3a 100644
>> --- a/drivers/nvmem/Makefile
>> +++ b/drivers/nvmem/Makefile
>> @@ -5,6 +5,7 @@
>>     obj-$(CONFIG_NVMEM)		+= nvmem_core.o
>>   nvmem_core-y			:= core.o
>> +obj-y				+= layouts/
>>     # Devices
>>   obj-$(CONFIG_NVMEM_BCM_OCOTP)	+= nvmem-bcm-ocotp.o
>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>> index 3dfd149374a8..5357fc378700 100644
>> --- a/drivers/nvmem/core.c
>> +++ b/drivers/nvmem/core.c
>> @@ -74,6 +74,9 @@ static LIST_HEAD(nvmem_lookup_list);
>>     static BLOCKING_NOTIFIER_HEAD(nvmem_notifier);
>>   +static DEFINE_SPINLOCK(nvmem_layout_lock);
>> +static LIST_HEAD(nvmem_layouts);
>> +
>>   static int __nvmem_reg_read(struct nvmem_device *nvmem, unsigned int 
>> offset,
>>   			    void *val, size_t bytes)
>>   {
>> @@ -744,6 +747,56 @@ static int nvmem_add_cells_from_of(struct 
>> nvmem_device *nvmem)
>>   	return 0;
>>   }
>>   +int nvmem_register_layout(struct nvmem_layout *layout)
>> +{
>> +	spin_lock(&nvmem_layout_lock);
>> +	list_add(&layout->node, &nvmem_layouts);
>> +	spin_unlock(&nvmem_layout_lock);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_register_layout);
> 
> we should provide nvmem_unregister_layout too, so that providers can
> add them if they can in there respective drivers.

Actually, that was the idea; that you can have layouts outside of 
layouts/.
I also had a nvmem_unregister_layout() but removed it because it was 
dead
code. Will re-add it again.

>> +
>> +static struct nvmem_layout *nvmem_get_compatible_layout(struct 
>> device_node *np)
>> +{
>> +	struct nvmem_layout *p, *ret = NULL;
>> +
>> +	spin_lock(&nvmem_layout_lock);
>> +
>> +	list_for_each_entry(p, &nvmem_layouts, node) {
>> +		if (of_match_node(p->of_match_table, np)) {
>> +			ret = p;
>> +			break;
>> +		}
>> +	}
>> +
>> +	spin_unlock(&nvmem_layout_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int nvmem_add_cells_from_layout(struct nvmem_device *nvmem)
>> +{
>> +	struct nvmem_layout *layout;
>> +
>> +	layout = nvmem_get_compatible_layout(nvmem->dev.of_node);
>> +	if (layout)
>> +		layout->add_cells(&nvmem->dev, nvmem, layout);
> 
> access to add_cells can crash hear as we did not check it before
> adding in to list.
> Or
> we could relax add_cells callback for usecases like imx-octop.

good catch, will use layout && layout->add_cells.

>> +
>> +	return 0;
>> +}
>> +
>> +const void *nvmem_layout_get_match_data(struct nvmem_device *nvmem,
>> +					struct nvmem_layout *layout)
>> +{
>> +	const struct of_device_id *match;
>> +
>> +	match = of_match_node(layout->of_match_table, nvmem->dev.of_node);
>> +
>> +	return match ? match->data : NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_layout_get_match_data);
>> +
>>   /**
>>    * nvmem_register() - Register a nvmem device for given 
>> nvmem_config.
>>    * Also creates a binary entry in 
>> /sys/bus/nvmem/devices/dev-name/nvmem
>> @@ -872,6 +925,10 @@ struct nvmem_device *nvmem_register(const struct 
>> nvmem_config *config)
>>   	if (rval)
>>   		goto err_remove_cells;
>>   +	rval = nvmem_add_cells_from_layout(nvmem);
>> +	if (rval)
>> +		goto err_remove_cells;
>> +
>>   	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
>>     	return nvmem;
>> diff --git a/drivers/nvmem/layouts/Kconfig 
>> b/drivers/nvmem/layouts/Kconfig
>> new file mode 100644
>> index 000000000000..9ad3911d1605
>> --- /dev/null
>> +++ b/drivers/nvmem/layouts/Kconfig
>> @@ -0,0 +1,5 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +menu "Layout Types"
>> +
>> +endmenu
>> diff --git a/drivers/nvmem/layouts/Makefile 
>> b/drivers/nvmem/layouts/Makefile
>> new file mode 100644
>> index 000000000000..6fdb3c60a4fa
>> --- /dev/null
>> +++ b/drivers/nvmem/layouts/Makefile
>> @@ -0,0 +1,4 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Makefile for nvmem layouts.
>> +#
>> diff --git a/include/linux/nvmem-provider.h 
>> b/include/linux/nvmem-provider.h
>> index e710404959e7..323685841e9f 100644
>> --- a/include/linux/nvmem-provider.h
>> +++ b/include/linux/nvmem-provider.h
>> @@ -127,6 +127,28 @@ struct nvmem_cell_table {
>>   	struct list_head	node;
>>   };
>>   +/**
>> + * struct nvmem_layout - NVMEM layout definitions
>> + *
>> + * @name:		Layout name.
>> + * @of_match_table:	Open firmware match table.
>> + * @add_cells:		Will be called if a nvmem device is found which
>> + *			has this layout. The function will add layout
>> + *			specific cells with nvmem_add_one_cell().
>> + * @node:		List node.
>> + *
>> + * A nvmem device can hold a well defined structure which can just be
>> + * evaluated during runtime. For example a TLV list, or a list of 
>> "name=val"
>> + * pairs. A nvmem layout can parse the nvmem device and add 
>> appropriate
>> + * cells.
>> + */
>> +struct nvmem_layout {
>> +	const char *name;
>> +	const struct of_device_id *of_match_table;
> 
> looking at this, I think its doable to convert the existing
> cell_post_process callback to layouts by adding a layout specific
> callback here.

can you elaborate on that?

-michael
