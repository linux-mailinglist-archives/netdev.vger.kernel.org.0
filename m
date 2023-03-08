Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7949C6B0594
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjCHLOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCHLOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F243C96F31;
        Wed,  8 Mar 2023 03:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B9BB81B29;
        Wed,  8 Mar 2023 11:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75C6C433D2;
        Wed,  8 Mar 2023 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678274076;
        bh=ccMiXcux3iDGpJ9zg6DwkZ7guZhASt7RFzYQJF/9t+s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=imuRQSGxW8fc16+YkypSdiDiRiwwiUq5kQ1XaM6LT0ZwSbARikUWRWFPQdnPSCuNg
         QWwU4Yi86lUjw967W6VdYGt8DvbL0L8BytEwD7+jCzvJ/jNW47f/hxMNrPjnpWt1aV
         GUxXZ6pnS1tOyuMDyiDihZSDBnEv+vbRkxWrcEJIRm1IjjlVC30jybvqo52Vhy41PG
         8EjyJqWWr44SBNYUmaD2UDgl8ctT3KE11V7JGYRtSQ4B3o52KwTVby4sh3LwPIRGzK
         2IczxarO5oAIqtvnydOVlb13YNWMtmx6kBae18CV4hAkXQthb545QONkSIPP6au+Rm
         kdb3ukvzrJxxQ==
Message-ID: <4b8d8b8e-9062-e4e6-770b-86bd40cc3683@kernel.org>
Date:   Wed, 8 Mar 2023 13:14:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v3 5/6] soc: ti: pruss: Add helper function
 to enable OCP master ports
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
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-6-danishanwar@ti.com>
 <39879d9f-041b-9156-95a5-a81702721739@kernel.org>
 <c5c2fbcc-0955-0325-ef05-289b7a339110@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <c5c2fbcc-0955-0325-ef05-289b7a339110@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/03/2023 13:09, Md Danish Anwar wrote:
> Hi Roger,
> 
> On 08/03/23 14:11, Roger Quadros wrote:
>>
>>
>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>> From: Suman Anna <s-anna@ti.com>
>>>
>>> The PRU-ICSS subsystem on OMAP-architecture based SoCS (AM33xx, AM437x
>>> and AM57xx SoCs) has a control bit STANDBY_INIT in the PRUSS_CFG register
>>> to initiate a Standby sequence (when set) and trigger a MStandby request
>>> to the SoC's PRCM module. This same bit is also used to enable the OCP
>>> master ports (when cleared). The clearing of the STANDBY_INIT bit requires
>>> an acknowledgment from PRCM and is done through the monitoring of the
>>> PRUSS_SYSCFG.SUB_MWAIT bit.
>>>
>>> Add a helper function pruss_cfg_ocp_master_ports() to allow the PRU
>>> client drivers to control this bit and enable or disable the firmware
>>> running on PRU cores access to any peripherals or memory to achieve
>>> desired functionality. The access is disabled by default on power-up
>>> and on any suspend (context is not maintained).
>>>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>> ---
>>>  drivers/soc/ti/pruss.c           | 81 +++++++++++++++++++++++++++++++-
>>>  include/linux/remoteproc/pruss.h |  6 +++
>>>  2 files changed, 85 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>> index 537a3910ffd8..dc3abda0b8c2 100644
>>> --- a/drivers/soc/ti/pruss.c
>>> +++ b/drivers/soc/ti/pruss.c
>>> @@ -22,14 +22,19 @@
>>>  #include <linux/remoteproc.h>
>>>  #include <linux/slab.h>
>>>  
>>> +#define SYSCFG_STANDBY_INIT	BIT(4)
>>> +#define SYSCFG_SUB_MWAIT_READY	BIT(5)
>>> +
>>>  /**
>>>   * struct pruss_private_data - PRUSS driver private data
>>>   * @has_no_sharedram: flag to indicate the absence of PRUSS Shared Data RAM
>>>   * @has_core_mux_clock: flag to indicate the presence of PRUSS core clock
>>> + * @has_ocp_syscfg: flag to indicate if OCP SYSCFG is present
>>>   */
>>>  struct pruss_private_data {
>>>  	bool has_no_sharedram;
>>>  	bool has_core_mux_clock;
>>> +	bool has_ocp_syscfg;
>>>  };
>>>  
>>>  /**
>>> @@ -205,6 +210,72 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>>  }
>>>  EXPORT_SYMBOL_GPL(pruss_cfg_update);
>>>  
>>> +/**
>>> + * pruss_cfg_ocp_master_ports() - configure PRUSS OCP master ports
>>> + * @pruss: the pruss instance handle
>>> + * @enable: set to true for enabling or false for disabling the OCP master ports
>>> + *
>>> + * This function programs the PRUSS_SYSCFG.STANDBY_INIT bit either to enable or
>>> + * disable the OCP master ports (applicable only on SoCs using OCP interconnect
>>> + * like the OMAP family). Clearing the bit achieves dual functionalities - one
>>> + * is to deassert the MStandby signal to the device PRCM, and the other is to
>>> + * enable OCP master ports to allow accesses outside of the PRU-ICSS. The
>>> + * function has to wait for the PRCM to acknowledge through the monitoring of
>>> + * the PRUSS_SYSCFG.SUB_MWAIT bit when enabling master ports. Setting the bit
>>> + * disables the master access, and also signals the PRCM that the PRUSS is ready
>>> + * for Standby.
>>> + *
>>> + * Return: 0 on success, or an error code otherwise. ETIMEDOUT is returned
>>> + * when the ready-state fails.
>>> + */
>>> +int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
>>> +{
>>> +	int ret;
>>> +	u32 syscfg_val, i;
>>> +	const struct pruss_private_data *data;
>>> +
>>> +	if (IS_ERR_OR_NULL(pruss))
>>> +		return -EINVAL;
>>> +
>>> +	data = of_device_get_match_data(pruss->dev);
>>> +
>>> +	/* nothing to do on non OMAP-SoCs */
>>> +	if (!data || !data->has_ocp_syscfg)
>>> +		return 0;
>>> +
>>> +	/* assert the MStandby signal during disable path */
>>> +	if (!enable)
>>> +		return pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG,
>>> +					SYSCFG_STANDBY_INIT,
>>> +					SYSCFG_STANDBY_INIT);
>>
>> You can omit the above if() if you just encapsulate the below in
>>
>> if (enable) {
>>
>>
> Sure, I can omit the above if() and put the below block inside if (enable) {}.
> 
> Currently when API pruss_cfg_ocp_master_ports()is called with enable as false
> i.e. disabling PRUSS OCP master ports is requested, we directly return
> pruss_cfg_update() where as if we remove the above if() section and encapsulate
> below block in if (enable) {}, then in disable scenario, call flow will
> directly reach the label disable. In the label disable, we are updating cfg and
> then returning "ret", but at this point the variable ret is not assigned.
> 
> To counter this should I change the label disable to below?
> 
> disable:
> 	return pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
> 			 SYSCFG_STANDBY_INIT);

But you will loose the error code if we came here due to failure in pruss_cfg_read().

It's ok, don't make the change I suggested and leave it as it is.

> 
>>> +
>>> +	/* enable the OCP master ports and disable MStandby */
>>> +	ret = pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT, 0);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* wait till we are ready for transactions - delay is arbitrary */
>>> +	for (i = 0; i < 10; i++) {
>>> +		ret = pruss_cfg_read(pruss, PRUSS_CFG_SYSCFG, &syscfg_val);
>>> +		if (ret)
>>> +			goto disable;
>>> +
> 
> Changing the disable label will also result in losing the return value of
> pruss_cfg_read() API call here.
> 
>>> +		if (!(syscfg_val & SYSCFG_SUB_MWAIT_READY))
>>> +			return 0;
>>> +
>>> +		udelay(5);
>>> +	}
>>> +
>>> +	dev_err(pruss->dev, "timeout waiting for SUB_MWAIT_READY\n");
>>> +	ret = -ETIMEDOUT;
> 
> Changing the disable label will also result in losing ret = -ETIMEDOUT here.
> 
>>
>> }
>>
>>> +
>>> +disable:
>>> +	pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
>>> +			 SYSCFG_STANDBY_INIT);
>>> +	return ret;
>>> +}
> 
> So should I do this modification or keep it as it is?
> 
>>> +EXPORT_SYMBOL_GPL(pruss_cfg_ocp_master_ports);
>>> +
>>>  static void pruss_of_free_clk_provider(void *data)
>>>  {
>>>  	struct device_node *clk_mux_np = data;
>>> @@ -495,10 +566,16 @@ static int pruss_remove(struct platform_device *pdev)
>>>  /* instance-specific driver private data */
>>>  static const struct pruss_private_data am437x_pruss1_data = {
>>>  	.has_no_sharedram = false,
>>> +	.has_ocp_syscfg = true,
>>>  };
>>>  
>>>  static const struct pruss_private_data am437x_pruss0_data = {
>>>  	.has_no_sharedram = true,
>>> +	.has_ocp_syscfg = false,
>>> +};
>>> +
>>> +static const struct pruss_private_data am33xx_am57xx_data = {
>>> +	.has_ocp_syscfg = true,
>>>  };
>>
>> How about keeping platform data for different platforms separate?
>>
>> i.e. am33xx_pruss_data and am57xx_pruss_data
>>
> 
> Sure. I'll split am33xx_am57xx_data into am33xx_pruss_data and
> am57xx_pruss_data as well as am65x_j721e_pruss_data into am65x_pruss_data and
> j721e_pruss_data.
> 
>>>  
>>>  static const struct pruss_private_data am65x_j721e_pruss_data = {
>>> @@ -506,10 +583,10 @@ static const struct pruss_private_data am65x_j721e_pruss_data = {
>>>  };
>>>  
>>>  static const struct of_device_id pruss_of_match[] = {
>>> -	{ .compatible = "ti,am3356-pruss" },
>>> +	{ .compatible = "ti,am3356-pruss", .data = &am33xx_am57xx_data },
>>>  	{ .compatible = "ti,am4376-pruss0", .data = &am437x_pruss0_data, },
>>>  	{ .compatible = "ti,am4376-pruss1", .data = &am437x_pruss1_data, },
>>> -	{ .compatible = "ti,am5728-pruss" },
>>> +	{ .compatible = "ti,am5728-pruss", .data = &am33xx_am57xx_data },
>>>  	{ .compatible = "ti,k2g-pruss" },
>>>  	{ .compatible = "ti,am654-icssg", .data = &am65x_j721e_pruss_data, },
>>>  	{ .compatible = "ti,j721e-icssg", .data = &am65x_j721e_pruss_data, },
>>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>>> index 7952f250301a..8cb99d3cad0d 100644
>>> --- a/include/linux/remoteproc/pruss.h
>>> +++ b/include/linux/remoteproc/pruss.h
>>> @@ -168,6 +168,7 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>  int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);
>>>  int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>>  		     unsigned int mask, unsigned int val);
>>> +int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable);
>>>  
>>>  #else
>>>  
>>> @@ -203,6 +204,11 @@ static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>>  	return -EOPNOTSUPP;
>>>  }
>>>  
>>> +static inline int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
>>> +{
>>> +	return -EOPNOTSUPP;
>>> +}
>>> +
>>>  #endif /* CONFIG_TI_PRUSS */
>>>  
>>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>>
>> cheers,
>> -roger
> 

cheers,
-roger
