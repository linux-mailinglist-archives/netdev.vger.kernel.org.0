Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2BB6D090F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjC3PGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjC3PGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2C09C;
        Thu, 30 Mar 2023 08:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBBC620AE;
        Thu, 30 Mar 2023 15:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB65C433EF;
        Thu, 30 Mar 2023 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680188766;
        bh=dPa5iDYVqXA+hqQv91TzUwfoTYRtbylD49pBAZ3DPC8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YowgVcF2cjsefmg/giP3q7hz6zgKCBJiarScxQNJH5GK7Yq65JVHiF5zfcFVb7v3w
         HEReYbZVskzgs3RJk0V6vtTiMWV5BXfjBeg+PDuoQJvHEtEILoqYj57aVEEfqGyD3N
         sbzcUeVJzl4HiVB25Fmnlu1YbblBhy/gOaybGjh1OcwjW716wvCiy9Iea66q5bQQLw
         wIKMUO8+tMBTj7zAodk2VJ5q2Cn1zth2/d84bfE6fSe3YhhTUWU4iMHotY+xOBn/uA
         vYFwzLMvNxW/cRgI3VDdO3+J3H37ZwabOBBom9pezPOeRW5horpJT0VQxgGng5Oodt
         XiAf2cmyYSrzg==
Message-ID: <d42c8881-72f3-dbce-f1ea-5ba998f7427c@kernel.org>
Date:   Thu, 30 Mar 2023 18:06:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 3/5] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-4-danishanwar@ti.com> <20230327210126.GC3158115@p14s>
 <4e239000-c5f7-a42e-157e-5b668c6b2908@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <4e239000-c5f7-a42e-157e-5b668c6b2908@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/03/2023 13:00, Md Danish Anwar wrote:
> Hi Mathieu,
> 
> On 28/03/23 02:31, Mathieu Poirier wrote:
>> On Thu, Mar 23, 2023 at 11:54:49AM +0530, MD Danish Anwar wrote:
>>> From: Suman Anna <s-anna@ti.com>
>>>
>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>> the PRUSS platform driver to read and program respectively a register
>>> within the PRUSS CFG sub-module represented by a syscon driver.
>>>
>>> These APIs are internal to PRUSS driver. Various useful registers
>>> and macros for certain register bit-fields and their values have also
>>> been added.
>>>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>>> ---
>>>  drivers/soc/ti/pruss.c |   1 +
>>>  drivers/soc/ti/pruss.h | 112 +++++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 113 insertions(+)
>>>  create mode 100644 drivers/soc/ti/pruss.h
>>>
>>
>> This patch doesn't compile without warnings.
>>
> 
> I checked the warnings. Below are the warnings that I am getting for these patch.
> 
> In file included from drivers/soc/ti/pruss.c:24:
> drivers/soc/ti/pruss.h:103:12: warning: ‘pruss_cfg_update’ defined but not used
> [-Wunused-function]
>   103 | static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>       |            ^~~~~~~~~~~~~~~~
> drivers/soc/ti/pruss.h:84:12: warning: ‘pruss_cfg_read’ defined but not used
> [-Wunused-function]
>    84 | static int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
> unsigned int *val)
> 
> These warnings are coming because pruss_cfg_read() / update() APIs are
> introduced in this patch but they are used later.
> 
> One way to resolve this warning is to make this API "inline". I compiled after
> making these APIs inline, it got compiled without any warnings.
> 
> The other solution is to merge a user API of these APIs in this patch. Patch 4
> and 5 introduces some APIs that uses pruss_cfg_read() / update() APIs. If we
> squash patch 5 (as patch 5 uses both read() and update() APIs where as patch 4
> only uses update() API) with this patch and make it a single patch where
> pruss_cfg_read() / update() is introduced as well as used, then this warning
> will be resolved.
> 
> I still think making these APIs "inline" is a better option as these APIs
> implement very simple one line logic and can be made inline.
> 
> Please let me know what do you think and which approach sounds better.

You should squash this patch with the next one.

> 
> 
>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>> index 126b672b9b30..2fa7df667592 100644
>>> --- a/drivers/soc/ti/pruss.c
>>> +++ b/drivers/soc/ti/pruss.c
>>> @@ -21,6 +21,7 @@
>>>  #include <linux/regmap.h>
>>>  #include <linux/remoteproc.h>
>>>  #include <linux/slab.h>
>>> +#include "pruss.h"
>>>  
>>>  /**
>>>   * struct pruss_private_data - PRUSS driver private data
>>> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
>>> new file mode 100644
>>> index 000000000000..4626d5f6b874
>>> --- /dev/null
>>> +++ b/drivers/soc/ti/pruss.h
>>> @@ -0,0 +1,112 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * PRU-ICSS Subsystem user interfaces
>>> + *
>>> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
>>> + *	MD Danish Anwar <danishanwar@ti.com>
>>> + */
>>> +
>>> +#ifndef _SOC_TI_PRUSS_H_
>>> +#define _SOC_TI_PRUSS_H_
>>> +
>>> +#include <linux/bits.h>
>>> +#include <linux/regmap.h>
>>> +
>>> +/*
>>> + * PRU_ICSS_CFG registers
>>> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
>>> + */
>>> +#define PRUSS_CFG_REVID         0x00
>>> +#define PRUSS_CFG_SYSCFG        0x04
>>> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
>>> +#define PRUSS_CFG_CGR           0x10
>>> +#define PRUSS_CFG_ISRP          0x14
>>> +#define PRUSS_CFG_ISP           0x18
>>> +#define PRUSS_CFG_IESP          0x1C
>>> +#define PRUSS_CFG_IECP          0x20
>>> +#define PRUSS_CFG_SCRP          0x24
>>> +#define PRUSS_CFG_PMAO          0x28
>>> +#define PRUSS_CFG_MII_RT        0x2C
>>> +#define PRUSS_CFG_IEPCLK        0x30
>>> +#define PRUSS_CFG_SPP           0x34
>>> +#define PRUSS_CFG_PIN_MX        0x40
>>> +
>>> +/* PRUSS_GPCFG register bits */
>>> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
>>> +
>>> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
>>> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)
>>> +
>>> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
>>> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
>>> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
>>> +
>>> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
>>> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
>>> +
>>> +/* PRUSS_MII_RT register bits */
>>> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
>>> +
>>> +/* PRUSS_SPP register bits */
>>> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
>>> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
>>> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
>>> +
>>> +/**
>>> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
>>> + * @pruss: the pruss instance handle
>>> + * @reg: register offset within the CFG sub-module
>>> + * @val: pointer to return the value in
>>> + *
>>> + * Reads a given register within the PRUSS CFG sub-module and
>>> + * returns it through the passed-in @val pointer
>>> + *
>>> + * Return: 0 on success, or an error code otherwise
>>> + */
>>> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val)
>>> +{
>>> +	if (IS_ERR_OR_NULL(pruss))
>>> +		return -EINVAL;
>>> +
>>> +	return regmap_read(pruss->cfg_regmap, reg, val);
>>> +}
>>> +
>>> +/**
>>> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
>>> + * @pruss: the pruss instance handle
>>> + * @reg: register offset within the CFG sub-module
>>> + * @mask: bit mask to use for programming the @val
>>> + * @val: value to write
>>> + *
>>> + * Programs a given register within the PRUSS CFG sub-module
>>> + *
>>> + * Return: 0 on success, or an error code otherwise
>>> + */
>>> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>> +			    unsigned int mask, unsigned int val)
>>> +{
>>> +	if (IS_ERR_OR_NULL(pruss))
>>> +		return -EINVAL;
>>> +
>>> +	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>>> +}
>>> +
>>> +#endif  /* _SOC_TI_PRUSS_H_ */
>>> -- 
>>> 2.25.1
>>>
> 

--
cheers,
-roger
