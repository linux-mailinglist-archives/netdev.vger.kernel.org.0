Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D174A58F2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 10:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiBAJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 04:08:53 -0500
Received: from mga14.intel.com ([192.55.52.115]:22361 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbiBAJIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 04:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643706532; x=1675242532;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=za9uKb8xXejv/WmhsHKZ4f8ehj9UGiFHOBKePoS1dC0=;
  b=bBaYRwn+fJ192iJ34xNAenkQuovX+9Xn1v/b2ExjlR8ledDmR3A+Bm/a
   HC6Pf8TjLOv0iu7+/CcRDi4/GZeO6T3NogfP1M3SLpsGDI2ZhtE5aRxLP
   OV957nP6Iu0G+1J/8fC5kNndyPR0SCseB+CiicmlDnAHZ3dilAWR38dpz
   R4qapjJGMB/Yc7gOwEoCcB5jJJFCrDG8oFg/U3UWSetFCKveG8Z+osyO7
   yiidJilZmWYfdRz84/rrgxnOB1QV0aXN+QekyDk2QXv3gU6Cw/BzPpJqv
   DtD1xeMzgfbewKrNaksBCtUC4z76Kgo9k4NVJrxdlYLZV8J0IL4p/BNUT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247867486"
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="247867486"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 01:08:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,333,1635231600"; 
   d="scan'208";a="537726495"
Received: from mbechagg-mobl.ger.corp.intel.com ([10.249.44.42])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 01:08:46 -0800
Date:   Tue, 1 Feb 2022 11:08:39 +0200 (EET)
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
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 07/13] net: wwan: t7xx: Data path HW layer
In-Reply-To: <20220114010627.21104-8-ricardo.martinez@linux.intel.com>
Message-ID: <8593f871-6737-7f85-5035-b1b2d5d312e@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-8-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

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
> ---


> +static int t7xx_dpmaif_init_intr(struct dpmaif_hw_info *hw_info)
> +{
> +	struct dpmaif_isr_en_mask *isr_en_msk = &hw_info->isr_en_mask;

dpmaif_isr_en_mask is not defined until patch 08.


> +/* The para->intr_cnt counter is set to zero before this function is called.
> + * It does not check for overflow as there is no risk of overflowing intr_types or intr_queues.
> + */
> +static void t7xx_dpmaif_hw_check_rx_intr(struct dpmaif_ctrl *dpmaif_ctrl,
> +					 unsigned int *pl2_rxisar0,
> +					 struct dpmaif_hw_intr_st_para *para, int qno)
> +{
> +	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
> +	unsigned int l2_rxisar0 = *pl2_rxisar0;
> +	unsigned int value;
> +
> +	if (qno == DPF_RX_QNO_DFT) {
> +		value = l2_rxisar0 & DP_DL_INT_SKB_LEN_ERR;
> +		if (value)

In this function, value variable doesn't seem that useful compared with 
checking the condition directly on if line. And the value is never used 
after that.

> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_SKB_LEN_ERR, DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_BATCNT_LEN_ERR;
> +		if (value) {
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_BATCNT_LEN_ERR, DPF_RX_QNO_DFT);
> +			hw_info->isr_en_mask.ap_dl_l2intr_en_msk &= ~DP_DL_INT_BATCNT_LEN_ERR;
> +			iowrite32(DP_DL_INT_BATCNT_LEN_ERR,
> +				  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
> +		}
> +
> +		value = l2_rxisar0 & DP_DL_INT_PITCNT_LEN_ERR;
> +		if (value) {
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_PITCNT_LEN_ERR, DPF_RX_QNO_DFT);
> +			hw_info->isr_en_mask.ap_dl_l2intr_en_msk &= ~DP_DL_INT_PITCNT_LEN_ERR;
> +			iowrite32(DP_DL_INT_PITCNT_LEN_ERR,
> +				  hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMSR0);
> +		}
> +
> +		value = l2_rxisar0 & DP_DL_INT_PKT_EMPTY_MSK;
> +		if (value)
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_PKT_EMPTY_SET, DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_FRG_EMPTY_MSK;
> +		if (value)
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_FRG_EMPTY_SET, DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_MTU_ERR_MSK;
> +		if (value)
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_MTU_ERR, DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_FRG_LENERR_MSK;
> +		if (value)
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_FRGCNT_LEN_ERR, DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_Q0_PITCNT_LEN_ERR;
> +		if (value) {
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q0_PITCNT_LEN_ERR, BIT(qno));
> +			t7xx_dpmaif_dlq_mask_rx_pitcnt_len_err_intr(hw_info, qno);
> +		}
> +
> +		value = l2_rxisar0 & DP_DL_INT_HPC_ENT_TYPE_ERR;
> +		if (value)
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_HPC_ENT_TYPE_ERR,
> +						  DPF_RX_QNO_DFT);
> +
> +		value = l2_rxisar0 & DP_DL_INT_Q0_DONE;
> +		if (value) {
> +			/* Mask RX done interrupt immediately after it occurs */
> +			if (!t7xx_mask_dlq_intr(dpmaif_ctrl, qno)) {
> +				t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q0_DONE, BIT(qno));
> +			} else {
> +				/* Unable to clear the interrupt, try again on the next one
> +				 * device entered low power mode or suffer exception
> +				 */

It's not obvious what "on the next one" means. I assume you're 
also missing period from end of the first line.

> +				*pl2_rxisar0 = l2_rxisar0 & ~DP_DL_INT_Q0_DONE;
> +			}
> +		}
> +	} else {
> +		value = l2_rxisar0 & DP_DL_INT_Q1_PITCNT_LEN_ERR;
> +		if (value) {
> +			t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q1_PITCNT_LEN_ERR, BIT(qno));
> +			t7xx_dpmaif_dlq_mask_rx_pitcnt_len_err_intr(hw_info, qno);
> +		}
> +
> +		value = l2_rxisar0 & DP_DL_INT_Q1_DONE;
> +		if (value) {
> +			if (!t7xx_mask_dlq_intr(dpmaif_ctrl, qno))
> +				t7xx_dpmaif_set_intr_para(para, DPF_INTR_DL_Q1_DONE, BIT(qno));
> +			else
> +				*pl2_rxisar0 = l2_rxisar0 & ~DP_DL_INT_Q1_DONE;
> +		}
> +	}
> +}


> +static void t7xx_dpmaif_dl_dlq_pit_en(struct dpmaif_hw_info *hw_info, unsigned char q_num,
> +				      bool enable)
> +{
> +	unsigned int value;
> +
> +	value = ioread32(hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON3);
> +
> +	if (enable)
> +		value |= DPMAIF_DLQPIT_EN_MSK;
> +	else
> +		value &= ~DPMAIF_DLQPIT_EN_MSK;
> +
> +	iowrite32(value, hw_info->pcie_base + DPMAIF_DL_DLQPIT_INIT_CON3);
> +}

Only called with enabled = true


> +static int t7xx_dpmaif_config_dlq_hw(struct dpmaif_ctrl *dpmaif_ctrl)
> +{
> +	struct dpmaif_hw_info *hw_info = &dpmaif_ctrl->hif_hw_info;
> +	struct dpmaif_dl_hwq *dl_hw;

Only defined in 08. I might have not noticed all missing defs
so please compile test yourself to find the rest if any.

In general, it would be useful to use, e.g., a shell for loop to compile
test every change incrementally in the patchset before sending them out.

Another thing is that the values inside struct dpmaif_dl_hwq are
just set from constants and never changed anywhere. Why not use 
the constants directly?


> +static void t7xx_dpmaif_ul_all_q_en(struct dpmaif_hw_info *hw_info, bool enable)
> +{
> +	u32 ul_arb_en = ioread32(hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
> +
> +	if (enable)
> +		ul_arb_en |= DPMAIF_UL_ALL_QUE_ARB_EN;
> +	else
> +		ul_arb_en &= ~DPMAIF_UL_ALL_QUE_ARB_EN;
> +
> +	iowrite32(ul_arb_en, hw_info->pcie_base + DPMAIF_AO_UL_CHNL_ARB0);
> +}
> +
> +static bool t7xx_dpmaif_ul_idle_check(struct dpmaif_hw_info *hw_info)
> +{
> +	u32 dpmaif_ul_is_busy = ioread32(hw_info->pcie_base + DPMAIF_UL_CHK_BUSY);
> +
> +	return !(dpmaif_ul_is_busy & DPMAIF_UL_IDLE_STS);
> +}
> +
> + /* DPMAIF UL Part HW setting */

While not extremely useful to begin with, isn't this comment too late as
it is after two UL related functions?

> +unsigned int t7xx_dpmaif_dl_get_frg_rd_idx(struct dpmaif_hw_info *hw_info, unsigned char q_num)
> +{
> +	u32 value;
> +
> +	value = ioread32(hw_info->pcie_base + DPMAIF_AO_DL_FRGBAT_WRIDX);
> +	return value & DPMAIF_DL_FRG_WRIDX_MSK;
> +}

Function name has rd_idx but defines used are WRIDX. Is it intentional?


> +enum dpmaif_hw_intr_type {
> +	DPF_INTR_INVALID_MIN,
> +	DPF_INTR_UL_DONE,
> +	DPF_INTR_UL_DRB_EMPTY,
> +	DPF_INTR_UL_MD_NOTREADY,
> +	DPF_INTR_UL_MD_PWR_NOTREADY,
> +	DPF_INTR_UL_LEN_ERR,
> +	DPF_INTR_DL_DONE,
> +	DPF_INTR_DL_SKB_LEN_ERR,
> +	DPF_INTR_DL_BATCNT_LEN_ERR,
> +	DPF_INTR_DL_PITCNT_LEN_ERR,
> +	DPF_INTR_DL_PKT_EMPTY_SET,
> +	DPF_INTR_DL_FRG_EMPTY_SET,
> +	DPF_INTR_DL_MTU_ERR,
> +	DPF_INTR_DL_FRGCNT_LEN_ERR,
> +	DPF_INTR_DL_Q0_PITCNT_LEN_ERR,
> +	DPF_INTR_DL_Q1_PITCNT_LEN_ERR,
> +	DPF_INTR_DL_HPC_ENT_TYPE_ERR,
> +	DPF_INTR_DL_Q0_DONE,
> +	DPF_INTR_DL_Q1_DONE,
> +	DPF_INTR_INVALID_MAX
> +};
> +
> +#define DPF_RX_QNO0			0
> +#define DPF_RX_QNO1			1
> +#define DPF_RX_QNO_DFT			DPF_RX_QNO0
> +
> +struct dpmaif_hw_intr_st_para {
> +	unsigned int intr_cnt;
> +	enum dpmaif_hw_intr_type intr_types[DPF_INTR_INVALID_MAX - 1];
> +	unsigned int intr_queues[DPF_INTR_INVALID_MAX - 1];

Off-by-one errors?

In addition, I think there's some other problem related to these as
there are 20 values in enum (of which two are named "INVALID") but
t7xx_dpmaif_set_intr_para seems to be called only with 17 of them
(DPF_INTR_DL_DONE not among the calls). This implies intr_cnt will
likely be too small to cover the last entry when it is being used
in 08/13 for a for loop termination condition.


-- 
 i.

