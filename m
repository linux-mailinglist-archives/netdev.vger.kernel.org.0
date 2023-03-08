Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7BD6B02D5
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCHJZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCHJYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:24:44 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0369F9E534;
        Wed,  8 Mar 2023 01:24:23 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3289O4cl051801;
        Wed, 8 Mar 2023 03:24:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678267444;
        bh=rzTr8bnTeROzzh3w38D9zwnOYt+bZ9ojJe2+VMJVvnQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=JLB8xsUVNWLxbNHbo2UlxozT+V1MrRfZo1gn1FVRQp6nLaXRgVVpUvi6dVzJqYrIS
         VfpvhgZx955yyH1pwxTZJIaweCbQZi7CPRulD6orUv8rcX06ejRa+NJUGT3u4z0Oqe
         X9FPiQUgPsi6qt3TaoYzWfgtOZCLzHvLygiedqbU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3289O4F1118337
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 Mar 2023 03:24:04 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 8
 Mar 2023 03:24:04 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 8 Mar 2023 03:24:04 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3289NwCP003784;
        Wed, 8 Mar 2023 03:23:59 -0600
Message-ID: <ed3dd4b6-658f-07d2-a055-4c38f2ec9db0@ti.com>
Date:   Wed, 8 Mar 2023 14:53:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v3 4/6] soc: ti: pruss: Add helper
 functions to set GPI mode, MII_RT_event and XFR
To:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "Santosh Shilimkar" <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-5-danishanwar@ti.com>
 <2f039534-dd21-7361-0fcd-b91da1636a3a@kernel.org>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <2f039534-dd21-7361-0fcd-b91da1636a3a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roger,

On 08/03/23 14:04, Roger Quadros wrote:
> Hi Danish,
> 
> On 06/03/2023 13:09, MD Danish Anwar wrote:
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
>> ---
>>  include/linux/remoteproc/pruss.h | 55 ++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>
>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>> index d41bec448f06..7952f250301a 100644
>> --- a/include/linux/remoteproc/pruss.h
>> +++ b/include/linux/remoteproc/pruss.h
>> @@ -240,4 +240,59 @@ static inline bool is_pru_rproc(struct device *dev)
>>  	return true;
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
>> +static inline int pruss_cfg_gpimode(struct pruss *pruss,
>> +				    enum pruss_pru_id pru_id,
>> +				    enum pruss_gpi_mode mode)
>> +{
>> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>> +		return -EINVAL;
>> +
> 
> Should we check for invalid gpi mode and error out if so?
> 
Sure we can check for invalid gpi mode.

Does the below code snippet looks good to you?

	if(mode < PRUSS_GPI_MODE_DIRECT || mode > PRUSS_GPI_MODE_MII)
		return -EINVAL;

>> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
>> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
>> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
>> +}
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
>> +static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
>> +{
>> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
>> +				PRUSS_MII_RT_EVENT_EN, set);
>> +}
>> +
>> +/**
>> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
>> + * @pruss: the pruss instance
>> + * @enable: enable/disable
>> + *
>> + * Return: 0 on success, or an error code otherwise
>> + */
>> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable)
>> +{
>> +	u32 set = enable ? PRUSS_SPP_XFER_SHIFT_EN : 0;
>> +
>> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP,
>> +				PRUSS_SPP_XFER_SHIFT_EN, set);
>> +}
>> +
>>  #endif /* __LINUX_PRUSS_H */
> 
> cheers,
> -roger

-- 
Thanks and Regards,
Danish.
