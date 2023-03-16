Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733076BCF41
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCPMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCPMTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:19:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280F26C1D;
        Thu, 16 Mar 2023 05:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C83B8213F;
        Thu, 16 Mar 2023 12:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91E0C4339B;
        Thu, 16 Mar 2023 12:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678969156;
        bh=hbKOvEwKovlGoJYefBxKQZ367EL/i6RYcMcuImKZkZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kR5QVIrBJ9m5dBdeldQYjOL2yMiKiZUlNhv5gk9sB198hjvyqoPeU9hCjqXS1PrCc
         VBFFzoQCLhoVoxMbW72ErLDOkGrhi+J+CtDKVBJ0BUATLbpbWVBb6E2qmkfw1q26PU
         uJebGUsfmdNChhnmO4fI9IPRl13qgrT7F96xM/BaiXoTEpx5jZshRPPu8mR5J1wWQw
         vUHT+gh+eDHVerZzinN5jz+gAtAHUw2gKIBO4uZCn78vIfkemghMj/FBPn5sScAlsj
         hfyHVkwze0tYmegXxq/x9dsw391XQsWFmE6UqXHG2dj8KqIfi/EsXjyMjuAWPiYoZy
         DI052+tp2x+Hw==
Message-ID: <e49b9a78-5e35-209e-7ecc-2333478b98b0@kernel.org>
Date:   Thu, 16 Mar 2023 14:19:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 4/5] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-5-danishanwar@ti.com>
 <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
 <b1409f34-86b5-14e8-f352-5032aa57ca46@ti.com>
 <60e73395-f670-6eaa-0eb7-389553320a71@kernel.org>
 <20718115-7606-a77b-7e4d-511ca9c1d798@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20718115-7606-a77b-7e4d-511ca9c1d798@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/03/2023 13:44, Md Danish Anwar wrote:
> 
> On 16/03/23 17:06, Roger Quadros wrote:
>> Hi,
>>
>> On 16/03/2023 13:05, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 15/03/23 17:52, Roger Quadros wrote:
>>>>
>>>>
>>>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>
>>>>> The PRUSS CFG module is represented as a syscon node and is currently
>>>>> managed by the PRUSS platform driver. Add easy accessor functions to set
>>>>> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
>>>>> to enable the PRUSS Ethernet usecase. These functions reuse the generic
>>>>> pruss_cfg_update() API function.
>>>>>
>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>>>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>>>>> ---
>>>>>  drivers/soc/ti/pruss.c           | 60 ++++++++++++++++++++++++++++++++
>>>>>  include/linux/remoteproc/pruss.h | 22 ++++++++++++
>>>>>  2 files changed, 82 insertions(+)
>>>>>
>>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>>> index 26d8129b515c..2f04b7922ddb 100644
>>>>> --- a/drivers/soc/ti/pruss.c
>>>>> +++ b/drivers/soc/ti/pruss.c
>>>>> @@ -203,6 +203,66 @@ static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>>>>  	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>>>>>  }
>>>>>  
>>>>> +/**
>>>>> + * pruss_cfg_gpimode() - set the GPI mode of the PRU
>>>>> + * @pruss: the pruss instance handle
>>>>> + * @pru_id: id of the PRU core within the PRUSS
>>>>> + * @mode: GPI mode to set
>>>>> + *
>>>>> + * Sets the GPI mode for a given PRU by programming the
>>>>> + * corresponding PRUSS_CFG_GPCFGx register
>>>>> + *
>>>>> + * Return: 0 on success, or an error code otherwise
>>>>> + */
>>>>> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>>>>> +		      enum pruss_gpi_mode mode)
>>>>> +{
>>>>> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
>>>>> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
>>>>> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pruss_cfg_gpimode);
>>>>> +
>>>>> +/**
>>>>> + * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
>>>>> + * @pruss: the pruss instance
>>>>> + * @enable: enable/disable
>>>>> + *
>>>>> + * Enable/disable the MII RT Events for the PRUSS.
>>>>> + *
>>>>> + * Return: 0 on success, or an error code otherwise
>>>>> + */
>>>>> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
>>>>> +{
>>>>> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
>>>>> +
>>>>> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
>>>>> +				PRUSS_MII_RT_EVENT_EN, set);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pruss_cfg_miirt_enable);
>>>>> +
>>>>> +/**
>>>>> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
>>>>> + * @pruss: the pruss instance
>>>>> + * @enable: enable/disable
>>>>> + * @mask: Mask for PRU / RTU
>>>>
>>>> You should not expect the user to provide the mask but only
>>>> the core type e.g. 
>>>>
>>>> enum pru_type {
>>>>         PRU_TYPE_PRU = 0,
>>>>         PRU_TYPE_RTU,
>>>>         PRU_TYPE_TX_PRU,
>>>>         PRU_TYPE_MAX,
>>>> };
>>>>
>>>> Then you figure out the mask in the function.
>>>> Also check for invalid pru_type and return error if so.
>>>>
>>>
>>> Sure Roger, I will create a enum and take it as parameter in API. Based on
>>> these enum I will calculate mask and do XFR shifting inside the API
>>> pruss_cfg_xfr_enable().
>>>
>>> There are two registers for XFR shift.
>>>
>>> #define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
>>> #define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
>>>
>>> For PRU XFR shifting, the mask should be PRUSS_SPP_XFER_SHIFT_EN,
>>> for RTU shifting mask should be PRUSS_SPP_RTU_XFR_SHIFT_EN and for PRU and RTU
>>> shifting mask should be (PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN)
>>>
>>> So the enum would be something like this.
>>>
>>> /**
>>>  * enum xfr_shift_type - XFR shift type
>>>  * @XFR_SHIFT_PRU: Enables XFR shift for PRU
>>>  * @XFR_SHIFT_RTU: Enables XFR shift for RTU
>>>  * @XFR_SHIFT_PRU_RTU: Enables XFR shift for both PRU and RTU
>>
>> This is not required. User can call the API twice. once for PRU and once for RTU.
>>
>>>  * @XFR_SHIFT_MAX: Total number of XFR shift types available.
>>>  *
>>>  */
>>>
>>> enum xfr_shift_type {
>>>         XFR_SHIFT_PRU = 0,
>>>         XFR_SHIFT_RTU,
>>>         XFR_SHIFT_PRU_RTU,
>>>         XFR_SHIFT_MAX,
>>> };
>>
>> Why do you need this new enum definition?
>> We already have pru_type defined somewhere. You can move it to a public header
>> if not there yet.
>>
>> enum pru_type {
>>          PRU_TYPE_PRU = 0,
>>          PRU_TYPE_RTU,
>>          PRU_TYPE_TX_PRU,
>>          PRU_TYPE_MAX,
>> };
>>
> 
> This enum is present in drivers/remoteproc/pru_rproc.c file. But the problem
> with this enum is that in [1] we need to enable XFR shift for both PRU and RTU
> for which the mask will be OR of PRUSS_SPP_XFER_SHIFT_EN (mask for PRU) and
> PRUSS_SPP_RTU_XFR_SHIFT_EN (mask of RTU).

Is there any limitation that you have to enable both simultaneously?
The driver can first do enable for PRU and then later for RTU.

As you will do a read modify write, the previous enable state of register
shouldn't be affected.

> 
> Now this enum doesn't have a field for both PRU and RTU. Also we don't need
> need the XFR shift for PRU_TYPE_TX_PRU as only two XFR shift register bits are
> defined.

That is OK. You can return error if not RTU or PRU.

> 
> That is why I thought of introducing new enum.
> 
> [1] drivers/net/ethernet/ti/icssg_config.c
> 
> /* enable XFR shift for PRU and RTU */
> 	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;

Driver can do like so

	pruss_cfg_xfr_enable(pruss, PRU_TYPE_PRU, true);
	pruss_cfg_xfr_enable(pruss, PRU_TYPE_RTU, true);

The second call should not disable the PRU XFR as you will do a
read-modify-write only affecting the RTU bit.

cheers,
-roger
