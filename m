Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84086E1B31
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 06:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDNEtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 00:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDNEta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 00:49:30 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF6E44B9;
        Thu, 13 Apr 2023 21:49:27 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33E4nGNx073335;
        Thu, 13 Apr 2023 23:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681447756;
        bh=ewfkuLS0iYg6xWQwWbJ4p43ROxv9Ga94jsX4IeY1AyA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=RxcXYMpZr4wDser0h66aeKv6Wg5iHUXNY7BIMJySf8HbAQwoJMBDeStsnOnD8pkPH
         CtCkXKSplqNm+00h/Z/UOgFF78HLqQw/LCaPYb6W1kwLoyhF8JBfXY+e4pABAB/mBy
         oASr3XsHlU/JJ3phqPBFOo/j8cs5bZOFGqSi4qQo=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33E4nFPp062354
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Apr 2023 23:49:16 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 13
 Apr 2023 23:49:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 13 Apr 2023 23:49:15 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33E4nAr3015585;
        Thu, 13 Apr 2023 23:49:11 -0500
Message-ID: <4e991441-535e-6944-3cd5-682c822a9552@ti.com>
Date:   Fri, 14 Apr 2023 10:19:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [EXTERNAL] Re: [PATCH v8 4/4] soc: ti: pruss: Add helper
 functions to set GPI mode, MII_RT_event and XFR
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
References: <20230412103012.1754161-1-danishanwar@ti.com>
 <20230412103012.1754161-5-danishanwar@ti.com> <20230412171319.GD86761@p14s>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230412171319.GD86761@p14s>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/23 22:43, Mathieu Poirier wrote:
> On Wed, Apr 12, 2023 at 04:00:12PM +0530, MD Danish Anwar wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> The PRUSS CFG module is represented as a syscon node and is currently
>> managed by the PRUSS platform driver. Add easy accessor functions to set
>> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
>> to enable the PRUSS Ethernet usecase. These functions reuse the generic
>> pruss_cfg_update() API function.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>> Reviewed-by: Tony Lindgren <tony@atomide.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>> ---
>>  drivers/remoteproc/pru_rproc.c | 15 -------
>>  drivers/soc/ti/pruss.c         | 74 ++++++++++++++++++++++++++++++++++
>>  include/linux/pruss_driver.h   | 51 +++++++++++++++++++++++
>>  3 files changed, 125 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
>> index 095f66130f48..54f5ce302e7a 100644
>> --- a/drivers/remoteproc/pru_rproc.c
>> +++ b/drivers/remoteproc/pru_rproc.c
>> @@ -81,21 +81,6 @@ enum pru_iomem {
>>  	PRU_IOMEM_MAX,
>>  };
>>  
>> -/**
>> - * enum pru_type - PRU core type identifier
>> - *
>> - * @PRU_TYPE_PRU: Programmable Real-time Unit
>> - * @PRU_TYPE_RTU: Auxiliary Programmable Real-Time Unit
>> - * @PRU_TYPE_TX_PRU: Transmit Programmable Real-Time Unit
>> - * @PRU_TYPE_MAX: just keep this one at the end
>> - */
>> -enum pru_type {
>> -	PRU_TYPE_PRU = 0,
>> -	PRU_TYPE_RTU,
>> -	PRU_TYPE_TX_PRU,
>> -	PRU_TYPE_MAX,
>> -};
>> -
>>  /**
>>   * struct pru_private_data - device data for a PRU core
>>   * @type: type of the PRU core (PRU, RTU, Tx_PRU)
>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>> index 34d513816a9d..90a625ab9cfc 100644
>> --- a/drivers/soc/ti/pruss.c
>> +++ b/drivers/soc/ti/pruss.c
>> @@ -213,6 +213,80 @@ int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>>  }
>>  EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
>>  
>> +/**
>> + * pruss_cfg_gpimode() - set the GPI mode of the PRU
>> + * @pruss: the pruss instance handle
>> + * @pru_id: id of the PRU core within the PRUSS
>> + * @mode: GPI mode to set
>> + *
>> + * Sets the GPI mode for a given PRU by programming the
>> + * corresponding PRUSS_CFG_GPCFGx register
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>> +		      enum pruss_gpi_mode mode)
>> +{
>> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>> +		return -EINVAL;
>> +
> 
> Same
> 
>> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
>> +		return -EINVAL;
>> +
> 
> Same
> 
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
>> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
>> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_gpimode);
>> +
>> +/**
>> + * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
>> + * @pruss: the pruss instance
>> + * @enable: enable/disable
>> + *
>> + * Enable/disable the MII RT Events for the PRUSS.
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
>> +{
>> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
>> +				PRUSS_MII_RT_EVENT_EN, set);
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_miirt_enable);
>> +
>> +/**
>> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
>> + * @pruss: the pruss instance
>> + * @pru_type: PRU core type identifier
>> + * @enable: enable/disable
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>> +			 bool enable)
>> +{
>> +	u32 mask, set;
>> +
>> +	switch (pru_type) {
>> +	case PRU_TYPE_PRU:
>> +		mask = PRUSS_SPP_XFER_SHIFT_EN;
>> +		break;
>> +	case PRU_TYPE_RTU:
>> +		mask = PRUSS_SPP_RTU_XFR_SHIFT_EN;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	set = enable ? mask : 0;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
>> +
>>  static void pruss_of_free_clk_provider(void *data)
>>  {
>>  	struct device_node *clk_mux_np = data;
>> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
>> index c70e08c90165..2a139bfda452 100644
>> --- a/include/linux/pruss_driver.h
>> +++ b/include/linux/pruss_driver.h
>> @@ -32,6 +32,33 @@ enum pruss_gp_mux_sel {
>>  	PRUSS_GP_MUX_SEL_MAX,
>>  };
>>  
>> +/*
>> + * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
>> + *			 to program the PRUSS_GPCFG0/1 registers
>> + */
>> +enum pruss_gpi_mode {
>> +	PRUSS_GPI_MODE_DIRECT = 0,
> 
> Not needed
> 
>> +	PRUSS_GPI_MODE_PARALLEL,
>> +	PRUSS_GPI_MODE_28BIT_SHIFT,
>> +	PRUSS_GPI_MODE_MII,
>> +	PRUSS_GPI_MODE_MAX,
>> +};
>> +
>> +/**
>> + * enum pru_type - PRU core type identifier
>> + *
>> + * @PRU_TYPE_PRU: Programmable Real-time Unit
>> + * @PRU_TYPE_RTU: Auxiliary Programmable Real-Time Unit
>> + * @PRU_TYPE_TX_PRU: Transmit Programmable Real-Time Unit
>> + * @PRU_TYPE_MAX: just keep this one at the end
>> + */
>> +enum pru_type {
>> +	PRU_TYPE_PRU = 0,
> 
> Same
> 
> With the above:
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> 

Sure Mathieu, I will do these changes and send next revision.

>> +	PRU_TYPE_RTU,
>> +	PRU_TYPE_TX_PRU,
>> +	PRU_TYPE_MAX,
>> +};
>> +
>>  /*
>>   * enum pruss_mem - PRUSS memory range identifiers
>>   */
>> @@ -86,6 +113,11 @@ int pruss_release_mem_region(struct pruss *pruss,
>>  			     struct pruss_mem_region *region);
>>  int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
>>  int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>> +		      enum pruss_gpi_mode mode);
>> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
>> +int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>> +			 bool enable);
>>  
>>  #else
>>  
>> @@ -121,6 +153,25 @@ static inline int pruss_cfg_set_gpmux(struct pruss *pruss,
>>  	return ERR_PTR(-EOPNOTSUPP);
>>  }
>>  
>> +static inline int pruss_cfg_gpimode(struct pruss *pruss,
>> +				    enum pruss_pru_id pru_id,
>> +				    enum pruss_gpi_mode mode)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>> +static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
>> +				       enum pru_type pru_type,
>> +				       bool enable);
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>>  #endif /* CONFIG_TI_PRUSS */
>>  
>>  #endif	/* _PRUSS_DRIVER_H_ */
>> -- 
>> 2.34.1
>>

-- 
Thanks and Regards,
Danish.
