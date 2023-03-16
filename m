Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4936BCD79
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCPLFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCPLFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:05:22 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BF067018;
        Thu, 16 Mar 2023 04:05:20 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32GB5A7f074665;
        Thu, 16 Mar 2023 06:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678964710;
        bh=43sI3V+5HkuG7ytp0+OIAoI/zPXPFa+f93/6FFpSTe0=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=myhLnEkk/AWjv9GNZBW6nJ791OGkoliA1JIlU79RT2nKz9YxEpBUJtd2WbUj9g3fd
         8PaejyukVDjZ/97XcPaSI7yS/QMDexKTUmyoEPlhOvJd7cW9BYSixzcx5Y/PaTmkIx
         KYDcURV3Wk/wCvNFFkQCygDSOZ7oYRESdQNHOSbU=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32GB5A1a057792
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Mar 2023 06:05:10 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 16
 Mar 2023 06:05:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 16 Mar 2023 06:05:09 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32GB54Ll085799;
        Thu, 16 Mar 2023 06:05:05 -0500
Message-ID: <b1409f34-86b5-14e8-f352-5032aa57ca46@ti.com>
Date:   Thu, 16 Mar 2023 16:35:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v4 4/5] soc: ti: pruss: Add helper
 functions to set GPI mode, MII_RT_event and XFR
Content-Language: en-US
To:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-5-danishanwar@ti.com>
 <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roger,

On 15/03/23 17:52, Roger Quadros wrote:
> 
> 
> On 13/03/2023 13:11, MD Danish Anwar wrote:
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
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>> ---
>>  drivers/soc/ti/pruss.c           | 60 ++++++++++++++++++++++++++++++++
>>  include/linux/remoteproc/pruss.h | 22 ++++++++++++
>>  2 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>> index 26d8129b515c..2f04b7922ddb 100644
>> --- a/drivers/soc/ti/pruss.c
>> +++ b/drivers/soc/ti/pruss.c
>> @@ -203,6 +203,66 @@ static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>  	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>>  }
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
>> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
>> +		return -EINVAL;
>> +
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
>> + * @enable: enable/disable
>> + * @mask: Mask for PRU / RTU
> 
> You should not expect the user to provide the mask but only
> the core type e.g. 
> 
> enum pru_type {
>         PRU_TYPE_PRU = 0,
>         PRU_TYPE_RTU,
>         PRU_TYPE_TX_PRU,
>         PRU_TYPE_MAX,
> };
> 
> Then you figure out the mask in the function.
> Also check for invalid pru_type and return error if so.
> 

Sure Roger, I will create a enum and take it as parameter in API. Based on
these enum I will calculate mask and do XFR shifting inside the API
pruss_cfg_xfr_enable().

There are two registers for XFR shift.

#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)

For PRU XFR shifting, the mask should be PRUSS_SPP_XFER_SHIFT_EN,
for RTU shifting mask should be PRUSS_SPP_RTU_XFR_SHIFT_EN and for PRU and RTU
shifting mask should be (PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN)

So the enum would be something like this.

/**
 * enum xfr_shift_type - XFR shift type
 * @XFR_SHIFT_PRU: Enables XFR shift for PRU
 * @XFR_SHIFT_RTU: Enables XFR shift for RTU
 * @XFR_SHIFT_PRU_RTU: Enables XFR shift for both PRU and RTU
 * @XFR_SHIFT_MAX: Total number of XFR shift types available.
 *
 */

enum xfr_shift_type {
        XFR_SHIFT_PRU = 0,
        XFR_SHIFT_RTU,
        XFR_SHIFT_PRU_RTU,
        XFR_SHIFT_MAX,
};

In pruss_cfg_xfr_enable() API, I will use switch case, and for first three
enums, I will calculate the mask.

If input is anything other than first three, I will retun -EINVAL. This will
serve as check for valid xfr_shift_type.

The API will look like this.

int pruss_cfg_xfr_enable(struct pruss *pruss, enum xfr_shift_type xfr_type,
			 bool enable);
{
	u32 mask;

	switch (xfr_type) {
	case XFR_SHIFT_PRU:
		mask = PRUSS_SPP_XFER_SHIFT_EN;
		break;
	case XFR_SHIFT_RTU:
		mask = PRUSS_SPP_RTU_XFR_SHIFT_EN;
		break;
	case XFR_SHIFT_PRU_RTU:
		mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
		break;
	default:
		return -EINVAL;
	}

	u32 set = enable ? mask : 0;

	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
}

This entire change I will keep as part of this patch only.

Please let me know if this looks OK to you.


>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask)
> 
> re-arrange so it is (struct pruss, enum pru_type, bool enable)
> 
>> +{
>> +	u32 set = enable ? mask : 0;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
>> +
>>  static void pruss_of_free_clk_provider(void *data)
>>  {
>>  	struct device_node *clk_mux_np = data;
>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>> index 12ef10b9fe9a..51a3eedd2be6 100644
>> --- a/include/linux/remoteproc/pruss.h
>> +++ b/include/linux/remoteproc/pruss.h
>> @@ -101,6 +101,7 @@ enum pruss_gpi_mode {
>>  	PRUSS_GPI_MODE_PARALLEL,
>>  	PRUSS_GPI_MODE_28BIT_SHIFT,
>>  	PRUSS_GPI_MODE_MII,
>> +	PRUSS_GPI_MODE_MAX,
> 
> This could have come as part of patch 3.
> 
>>  };
>>  
>>  /**
>> @@ -165,6 +166,10 @@ int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>>  			     struct pruss_mem_region *region);
>>  int pruss_release_mem_region(struct pruss *pruss,
>>  			     struct pruss_mem_region *region);
>> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>> +		      enum pruss_gpi_mode mode);
>> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
>> +int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask);
>>  
>>  #else
>>  
>> @@ -188,6 +193,23 @@ static inline int pruss_release_mem_region(struct pruss *pruss,
>>  	return -EOPNOTSUPP;
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
>> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +
>>  #endif /* CONFIG_TI_PRUSS */
>>  
>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> 
> cheers,
> -roger

-- 
Thanks and Regards,
Danish.
