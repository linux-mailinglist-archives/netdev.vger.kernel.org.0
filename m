Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEACD6CBDAD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjC1L3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjC1L3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:29:33 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE5683EC;
        Tue, 28 Mar 2023 04:29:07 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32SBSW2a014183;
        Tue, 28 Mar 2023 06:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680002912;
        bh=tZlcyEMDq5glYbCySPGUZF2oDnqMwNwb8dvtlXm0xME=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=uCKMtH3PtuevoT7K3mflv1uk3ejd39sKjJQ8TJMiF/OGzrwd7+lrq6ZzUlHwuDoPf
         99UQ0D9ikoj7VBfKoP2enNbj41VgDF0CwWzRYe+zPmWk7ImMR1iGStfNVMu1nRSyWz
         KU8pHio0m7V+i5Bsnc7FV6q4J2sWFhwprtiP2zEo=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32SBSWbr042746
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Mar 2023 06:28:32 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 28
 Mar 2023 06:28:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 28 Mar 2023 06:28:31 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32SBSQrK020834;
        Tue, 28 Mar 2023 06:28:27 -0500
Message-ID: <08cdd2b7-5152-8dec-aea2-ce286f8b97fb@ti.com>
Date:   Tue, 28 Mar 2023 16:58:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 5/5] soc: ti: pruss: Add helper
 functions to get/set PRUSS_CFG_GPMUX
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
 <20230323062451.2925996-6-danishanwar@ti.com> <20230327210429.GD3158115@p14s>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230327210429.GD3158115@p14s>
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



On 28/03/23 02:34, Mathieu Poirier wrote:
> On Thu, Mar 23, 2023 at 11:54:51AM +0530, MD Danish Anwar wrote:
>> From: Tero Kristo <t-kristo@ti.com>
>>
>> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
>> to get and set the GP MUX mode for programming the PRUSS internal wrapper
>> mux functionality as needed by usecases.
>>
>> Co-developed-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>> ---
>>  drivers/soc/ti/pruss.c           | 44 ++++++++++++++++++++++++++++++++
>>  include/linux/remoteproc/pruss.h | 30 ++++++++++++++++++++++
>>  2 files changed, 74 insertions(+)
>>
>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>> index ac415442e85b..3aa3c38c6c79 100644
>> --- a/drivers/soc/ti/pruss.c
>> +++ b/drivers/soc/ti/pruss.c
>> @@ -239,6 +239,50 @@ int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>>  }
>>  EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
>>  
>> +/**
>> + * pruss_cfg_get_gpmux() - get the current GPMUX value for a PRU device
>> + * @pruss: pruss instance
>> + * @pru_id: PRU identifier (0-1)
>> + * @mux: pointer to store the current mux value into
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
>> +{
>> +	int ret = 0;
>> +	u32 val;
>> +
>> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>> +		return -EINVAL;
>> +
>> +	ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
>> +	if (!ret)
>> +		*mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
>> +			    PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
> 
> What happens if @mux is NULL?

@mux being null may result in some error here. I will add NULL check for mux
before storing the value in mux.

I will modify the above if condition to have NULL check for mux as well.
The if condition will look like below.

	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS || !mux)
		return -EINVAL;

Please let me know if this looks OK.

> 
> Thanks,
> Mathieu
> 
> 
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_get_gpmux);
>> +
>> +/**
>> + * pruss_cfg_set_gpmux() - set the GPMUX value for a PRU device
>> + * @pruss: pruss instance
>> + * @pru_id: PRU identifier (0-1)
>> + * @mux: new mux value for PRU
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>> +{
>> +	if (mux >= PRUSS_GP_MUX_SEL_MAX ||
>> +	    pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>> +		return -EINVAL;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
>> +				PRUSS_GPCFG_PRU_MUX_SEL_MASK,
>> +				(u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
>> +
>>  static void pruss_of_free_clk_provider(void *data)
>>  {
>>  	struct device_node *clk_mux_np = data;
>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>> index bb001f712980..42f1586c62ac 100644
>> --- a/include/linux/remoteproc/pruss.h
>> +++ b/include/linux/remoteproc/pruss.h
>> @@ -16,6 +16,24 @@
>>  
>>  #define PRU_RPROC_DRVNAME "pru-rproc"
>>  
>> +/*
>> + * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
>> + * PRUSS_GPCFG0/1 registers
>> + *
>> + * NOTE: The below defines are the most common values, but there
>> + * are some exceptions like on 66AK2G, where the RESERVED and MII2
>> + * values are interchanged. Also, this bit-field does not exist on
>> + * AM335x SoCs
>> + */
>> +enum pruss_gp_mux_sel {
>> +	PRUSS_GP_MUX_SEL_GP = 0,
>> +	PRUSS_GP_MUX_SEL_ENDAT,
>> +	PRUSS_GP_MUX_SEL_RESERVED,
>> +	PRUSS_GP_MUX_SEL_SD,
>> +	PRUSS_GP_MUX_SEL_MII2,
>> +	PRUSS_GP_MUX_SEL_MAX,
>> +};
>> +
>>  /*
>>   * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
>>   *			 to program the PRUSS_GPCFG0/1 registers
>> @@ -110,6 +128,8 @@ int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>>  int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
>>  int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>>  			 bool enable);
>> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
>> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>>  
>>  #else
>>  
>> @@ -152,6 +172,16 @@ static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
>>  	return ERR_PTR(-EOPNOTSUPP);
>>  }
>>  
>> +static inline int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>> +static inline int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>>  #endif /* CONFIG_TI_PRUSS */
>>  
>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>> -- 
>> 2.25.1
>>

-- 
Thanks and Regards,
Danish.
