Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00974C4A77
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbiBYQTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242808AbiBYQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:19:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B14751304;
        Fri, 25 Feb 2022 08:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645805939; x=1677341939;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=UOqNqD/MT+/w14sDOPUpIK1Y7//wu5zD395g6NWsff0=;
  b=m59XO8WBvvS1k/oD3FhFY+Xqy5FEbpfPJeY7gcvq22SWsaRWhMkF3JLv
   naekavYm/K8sMoiJLePlnFu7/okanjsNghFecB2tWS7wTpfiJW/p/svlV
   KfAFhAYfIlsjNr3uwLE3eEZxV3teWRLPzwNf5uojxbIme/4aPcS+fUOVV
   xZDqEXqpZ/EMCQWaVdXs1tyQx9vdGTjG+gb/wB11N1B0/k11PSG796Qd4
   cvDFcyQpJVPX2vsftQdO2xEZ9a1WW2EYKY4duEBssqcrYhL5oMT/55Y5c
   dkdlcNrfM/Vr2rj1L/Cl02jrgngyqzlS5hRQy/IZwEqhpi6M88atwCjrC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252720875"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252720875"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 08:18:40 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549317156"
Received: from glieseu-mobl1.ger.corp.intel.com ([10.252.48.77])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 08:18:34 -0800
Date:   Fri, 25 Feb 2022 18:18:32 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= 
        <ilpo.johannes.jarvinen@intel.com>, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 07/13] net: wwan: t7xx: Data path HW layer
In-Reply-To: <20220223223326.28021-8-ricardo.martinez@linux.intel.com>
Message-ID: <b4ca941a-e75b-3d9c-fa5c-f2496bb8f047@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-8-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
> for the upper layer (DPMAIF HIF). It implements functions to do the HW
> configuration, TX/RX control and interrupt handling.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---


> +static void t7xx_dpmaif_dl_set_ao_bat_rsv_length(struct dpmaif_hw_info *hw_info)
> +{
> +	unsigned int value;
> +
> +	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_PKTINFO_CON2);
> +	value &= ~DPMAIF_BAT_RSV_LEN_MSK;
> +	value |= DPMAIF_HW_BAT_RSVLEN & DPMAIF_BAT_RSV_LEN_MSK;

Drop & DPMAIF_BAT_RSV_LEN_MSK

> +static void t7xx_dpmaif_dl_set_ao_frg_check_thres(struct dpmaif_hw_info *hw_info)
> +{
> +	unsigned int value;
> +
> +	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_RDY_CHK_FRG_THRES);
> +	value &= ~DPMAIF_FRG_CHECK_THRES_MSK;
> +	value |= (DPMAIF_HW_CHK_FRG_NUM & DPMAIF_FRG_CHECK_THRES_MSK);

Ditto.

> +	value |= DPMAIF_DL_PIT_SEQ_VALUE & DPMAIF_DL_PIT_SEQ_MSK;

Ditto.


-- 
 i.

