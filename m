Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFF16B01A0
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjCHIge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCHIgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:36:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D55B3730;
        Wed,  8 Mar 2023 00:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B138616EB;
        Wed,  8 Mar 2023 08:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CAAC433EF;
        Wed,  8 Mar 2023 08:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678264458;
        bh=g6FWDWTVvtbUVJ0kus/OK9I+nhtkZyDFnv104tDpUdg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KJayE8QeTlag7cnxN2nStkgFonskLPD56vS7wrJt+yEbZIwhYJINJVweCe2mwGX2f
         LealC9F1CqMnXhkgKUGh/1H2M8d/N8+IAVzeFOW1tyuTTORDlUiU7EapRTleS5DdMz
         CBfkBuiaUcm5DvlHs6UK1QFx6qN4SuZ5ai812CgrkCg3Q8mbMk6Hdkk2M7vE+d1woQ
         EQ5o1TtFdU94PHElLD7IXLKn+GRjq1wUrvdLXq2xWIbmZe4a1rfGakc1/6q2ycFmC6
         L91jKRyk6/z7unULkymS1imZT2yLyVsBPOB9ipPjS53SudX8BBI4h6otu2iQTIHqq0
         TnbJ12NOPyLHw==
Message-ID: <2f039534-dd21-7361-0fcd-b91da1636a3a@kernel.org>
Date:   Wed, 8 Mar 2023 10:34:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 4/6] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-5-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-5-danishanwar@ti.com>
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

Hi Danish,

On 06/03/2023 13:09, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The PRUSS CFG module is represented as a syscon node and is currently
> managed by the PRUSS platform driver. Add easy accessor functions to set
> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
> to enable the PRUSS Ethernet usecase. These functions reuse the generic
> pruss_cfg_update() API function.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  include/linux/remoteproc/pruss.h | 55 ++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index d41bec448f06..7952f250301a 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -240,4 +240,59 @@ static inline bool is_pru_rproc(struct device *dev)
>  	return true;
>  }
>  
> +/**
> + * pruss_cfg_gpimode() - set the GPI mode of the PRU
> + * @pruss: the pruss instance handle
> + * @pru_id: id of the PRU core within the PRUSS
> + * @mode: GPI mode to set
> + *
> + * Sets the GPI mode for a given PRU by programming the
> + * corresponding PRUSS_CFG_GPCFGx register
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static inline int pruss_cfg_gpimode(struct pruss *pruss,
> +				    enum pruss_pru_id pru_id,
> +				    enum pruss_gpi_mode mode)
> +{
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> +		return -EINVAL;
> +

Should we check for invalid gpi mode and error out if so?

> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
> +}
> +
> +/**
> + * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
> + * @pruss: the pruss instance
> + * @enable: enable/disable
> + *
> + * Enable/disable the MII RT Events for the PRUSS.
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
> +{
> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
> +				PRUSS_MII_RT_EVENT_EN, set);
> +}
> +
> +/**
> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
> + * @pruss: the pruss instance
> + * @enable: enable/disable
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable)
> +{
> +	u32 set = enable ? PRUSS_SPP_XFER_SHIFT_EN : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP,
> +				PRUSS_SPP_XFER_SHIFT_EN, set);
> +}
> +
>  #endif /* __LINUX_PRUSS_H */

cheers,
-roger
