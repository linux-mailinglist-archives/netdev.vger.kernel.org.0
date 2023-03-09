Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA1E6B231F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjCILfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCILfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:35:12 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF85FEB0;
        Thu,  9 Mar 2023 03:35:09 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 329BYu2C065254;
        Thu, 9 Mar 2023 05:34:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678361696;
        bh=iX7y3Z0tBRNNQCGKDp9Uv30r+tezSHa9h/x0ELZdFOU=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=ODStmCmYnXJEu4Sg5+R8o7IloBIFmO9LWNtS2Gs19J4sED9hm3roD/HwqkWqsI+X2
         9K2IyEzzog/RDd1HhMrXRxjoE35g3yHbFlN9LB58Of3VyITz4OvgXWeMuBabiipRHJ
         st0VGIH5lbCaKHB2+gCzR4ARQxZ99Yqn+91DYPVs=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 329BYuNw017261
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 05:34:56 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 05:34:55 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 05:34:56 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 329BYo7K025813;
        Thu, 9 Mar 2023 05:34:51 -0600
Message-ID: <9c866140-6ca6-3594-95b5-5a7a37ce9c05@ti.com>
Date:   Thu, 9 Mar 2023 17:04:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v3 5/6] soc: ti: pruss: Add helper function
 to enable OCP master ports
Content-Language: en-US
To:     Tony Lindgren <tony@atomide.com>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-6-danishanwar@ti.com>
 <20230309070450.GE7501@atomide.com>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230309070450.GE7501@atomide.com>
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

Hi Tony,

On 09/03/23 12:34, Tony Lindgren wrote:
> Hi,
> 
> * MD Danish Anwar <danishanwar@ti.com> [230306 11:10]:
>> From: Suman Anna <s-anna@ti.com>
>> +/**
>> + * pruss_cfg_ocp_master_ports() - configure PRUSS OCP master ports
>> + * @pruss: the pruss instance handle
>> + * @enable: set to true for enabling or false for disabling the OCP master ports
>> + *
>> + * This function programs the PRUSS_SYSCFG.STANDBY_INIT bit either to enable or
>> + * disable the OCP master ports (applicable only on SoCs using OCP interconnect
>> + * like the OMAP family). Clearing the bit achieves dual functionalities - one
>> + * is to deassert the MStandby signal to the device PRCM, and the other is to
>> + * enable OCP master ports to allow accesses outside of the PRU-ICSS. The
>> + * function has to wait for the PRCM to acknowledge through the monitoring of
>> + * the PRUSS_SYSCFG.SUB_MWAIT bit when enabling master ports. Setting the bit
>> + * disables the master access, and also signals the PRCM that the PRUSS is ready
>> + * for Standby.
>> + *
>> + * Return: 0 on success, or an error code otherwise. ETIMEDOUT is returned
>> + * when the ready-state fails.
>> + */
>> +int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
>> +{
>> +	int ret;
>> +	u32 syscfg_val, i;
>> +	const struct pruss_private_data *data;
>> +
>> +	if (IS_ERR_OR_NULL(pruss))
>> +		return -EINVAL;
>> +
>> +	data = of_device_get_match_data(pruss->dev);
>> +
>> +	/* nothing to do on non OMAP-SoCs */
>> +	if (!data || !data->has_ocp_syscfg)
>> +		return 0;
>> +
>> +	/* assert the MStandby signal during disable path */
>> +	if (!enable)
>> +		return pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG,
>> +					SYSCFG_STANDBY_INIT,
>> +					SYSCFG_STANDBY_INIT);
>> +
>> +	/* enable the OCP master ports and disable MStandby */
>> +	ret = pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* wait till we are ready for transactions - delay is arbitrary */
>> +	for (i = 0; i < 10; i++) {
>> +		ret = pruss_cfg_read(pruss, PRUSS_CFG_SYSCFG, &syscfg_val);
>> +		if (ret)
>> +			goto disable;
>> +
>> +		if (!(syscfg_val & SYSCFG_SUB_MWAIT_READY))
>> +			return 0;
>> +
>> +		udelay(5);
>> +	}
>> +
>> +	dev_err(pruss->dev, "timeout waiting for SUB_MWAIT_READY\n");
>> +	ret = -ETIMEDOUT;
>> +
>> +disable:
>> +	pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
>> +			 SYSCFG_STANDBY_INIT);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(pruss_cfg_ocp_master_ports);
> 
> The above you should no longer be needed, see for example am33xx-l4.dtsi
> for pruss_tm: target-module@300000. The SYSCFG register is managed by
> drivers/bus/ti-sysc.c using compatible "ti,sysc-pruss", and the "sysc"
> reg-names property. So when any of the child devices do pm_runtime_get()
> related functions, the PRUSS top level interconnect target module is
> automatically enabled and disabled as needed.
> 
> If there's something still missing like dts configuration for some SoCs,
> or quirk handling in ti-sysc.c, let's fix those instead so we can avoid
> exporting a custom function for pruss_cfg_ocp_master_ports.
> 
> Regards,
> 
> Tony

I will remove this patch in the next revision of this series as it is no longer
needed.

-- 
Thanks and Regards,
Danish.
