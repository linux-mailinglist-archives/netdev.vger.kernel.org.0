Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D47C6CBD4A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjC1LRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjC1LRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:17:32 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE163C20;
        Tue, 28 Mar 2023 04:17:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32SBH9xG108436;
        Tue, 28 Mar 2023 06:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680002229;
        bh=+eoEEe1pmtcdoeNbEZvPGDZU834mlTMCt5fDZ1sH9SQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=oGGoOHR38rHg1qUDXzXDofSvKLb4TCXoaDSwBXKvJqcFbaP2AZ6akfsbz4hZS1jMX
         gRZ2Lj6Q7nNSA5gYVyHRgID/tmEGDY3kWCwgqo00dzrluSkMJ5DiWymlEqvP6zgs/w
         kH1Zrq6uXL86JfNBFkHgQECIpJRLoclkvPnEX+iU=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32SBH9M6037561
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Mar 2023 06:17:09 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 28
 Mar 2023 06:17:09 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 28 Mar 2023 06:17:09 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32SBH4Wp095866;
        Tue, 28 Mar 2023 06:17:04 -0500
Message-ID: <f5b84da7-313a-179b-5f35-aefffaa206a7@ti.com>
Date:   Tue, 28 Mar 2023 16:47:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 3/5] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
Content-Language: en-US
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-4-danishanwar@ti.com> <20230327210126.GC3158115@p14s>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230327210126.GC3158115@p14s>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/03/23 02:31, Mathieu Poirier wrote:
> On Thu, Mar 23, 2023 at 11:54:49AM +0530, MD Danish Anwar wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>> the PRUSS platform driver to read and program respectively a register
>> within the PRUSS CFG sub-module represented by a syscon driver.
>>
>> These APIs are internal to PRUSS driver. Various useful registers
>> and macros for certain register bit-fields and their values have also
>> been added.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>> ---
>>  drivers/soc/ti/pruss.c |   1 +
>>  drivers/soc/ti/pruss.h | 112 +++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 113 insertions(+)
>>  create mode 100644 drivers/soc/ti/pruss.h
>>
> 
> This patch doesn't compile without warnings.
> 

Sure, Mathieu. I'll check the warnings.

>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>> index 126b672b9b30..2fa7df667592 100644
>> --- a/drivers/soc/ti/pruss.c
>> +++ b/drivers/soc/ti/pruss.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/regmap.h>
>>  #include <linux/remoteproc.h>
>>  #include <linux/slab.h>
>> +#include "pruss.h"
>>  
>>  /**
>>   * struct pruss_private_data - PRUSS driver private data
>> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
>> new file mode 100644
>> index 000000000000..4626d5f6b874
>> --- /dev/null
>> +++ b/drivers/soc/ti/pruss.h
>> @@ -0,0 +1,112 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * PRU-ICSS Subsystem user interfaces
>> + *
>> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
>> + *	MD Danish Anwar <danishanwar@ti.com>
>> + */
>> +
>> +#ifndef _SOC_TI_PRUSS_H_
>> +#define _SOC_TI_PRUSS_H_
>> +
>> +#include <linux/bits.h>
>> +#include <linux/regmap.h>
>> +
>> +/*
>> + * PRU_ICSS_CFG registers
>> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
>> + */
>> +#define PRUSS_CFG_REVID         0x00
>> +#define PRUSS_CFG_SYSCFG        0x04
>> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
>> +#define PRUSS_CFG_CGR           0x10
>> +#define PRUSS_CFG_ISRP          0x14
>> +#define PRUSS_CFG_ISP           0x18
>> +#define PRUSS_CFG_IESP          0x1C
>> +#define PRUSS_CFG_IECP          0x20
>> +#define PRUSS_CFG_SCRP          0x24
>> +#define PRUSS_CFG_PMAO          0x28
>> +#define PRUSS_CFG_MII_RT        0x2C
>> +#define PRUSS_CFG_IEPCLK        0x30
>> +#define PRUSS_CFG_SPP           0x34
>> +#define PRUSS_CFG_PIN_MX        0x40
>> +
>> +/* PRUSS_GPCFG register bits */
>> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
>> +
>> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
>> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)
>> +
>> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
>> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)
>> +
>> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
>> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
>> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
>> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
>> +
>> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
>> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
>> +
>> +/* PRUSS_MII_RT register bits */
>> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
>> +
>> +/* PRUSS_SPP register bits */
>> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
>> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
>> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
>> +
>> +/**
>> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
>> + * @pruss: the pruss instance handle
>> + * @reg: register offset within the CFG sub-module
>> + * @val: pointer to return the value in
>> + *
>> + * Reads a given register within the PRUSS CFG sub-module and
>> + * returns it through the passed-in @val pointer
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val)
>> +{
>> +	if (IS_ERR_OR_NULL(pruss))
>> +		return -EINVAL;
>> +
>> +	return regmap_read(pruss->cfg_regmap, reg, val);
>> +}
>> +
>> +/**
>> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
>> + * @pruss: the pruss instance handle
>> + * @reg: register offset within the CFG sub-module
>> + * @mask: bit mask to use for programming the @val
>> + * @val: value to write
>> + *
>> + * Programs a given register within the PRUSS CFG sub-module
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>> +			    unsigned int mask, unsigned int val)
>> +{
>> +	if (IS_ERR_OR_NULL(pruss))
>> +		return -EINVAL;
>> +
>> +	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>> +}
>> +
>> +#endif  /* _SOC_TI_PRUSS_H_ */
>> -- 
>> 2.25.1
>>

-- 
Thanks and Regards,
Danish.
