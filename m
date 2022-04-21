Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185FD50A0D2
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbiDUNad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385260AbiDUNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:30:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82A3C3968F
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ON/XENFr2fSdS2DJ/0ZIWH5lYfu7VbsCP2/gtJh2w7U=;
        b=Do9anB9jemeGHsnAemTjqBMr3QiChgZQMoykMYsYh26JFiff4c1r8S4BQBwMRHjTVolaS3
        zUYLELc5tRlWkyOKkFLnZn2ImHp8NvLBiJ3K/GRrqQT/jFQ8lYj6WCQaIbJq7XsyQ3CUK7
        UGACrcTh60ue6BERMjh7lGD9FnfDmhM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-b2dJQARhOkG_xLpMBDPgvA-1; Thu, 21 Apr 2022 09:27:27 -0400
X-MC-Unique: b2dJQARhOkG_xLpMBDPgvA-1
Received: by mail-wm1-f70.google.com with SMTP id c125-20020a1c3583000000b0038e3f6e871aso2354640wma.8
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ON/XENFr2fSdS2DJ/0ZIWH5lYfu7VbsCP2/gtJh2w7U=;
        b=sbGmTDaqPXO0TMCUrxwvtmq3VZ2zzrlp4cIh/6g6kAMI0our8GSEZmbIxq+MMBWJo2
         X2kE2b4mAzWAqiWfID+9MSy9oCZoCcBuQvQaTW8ZCa/BRUP37/M3+vECzmDQ4WtWbjiY
         27vbAfk702mPwbbsTZn6zJaHa0qEEUw9lojtrtpBdBuMhHjJU0gH+hzmuPlxk7dYgkSh
         lui5fypqgwRXMVbDn4kJsKRqzZLkOeP4oChb2IschyEvlLmkqHQjkf86VOl69RloaiSh
         QVvMlTMDI0L+pY20GuY9xAkLOJysHaWdhZ/2J5ONGo0oBbMw+ry76MpXwbPTuJa+8kn0
         14mw==
X-Gm-Message-State: AOAM533mNqf8XRwsibhan9e+Sr7HUO3queFIIeUPx+m0ABMSgLTsp8Rz
        V2/V13nZEGh36kahWCVst0sM6Ox1NSkGRf/Sq7bxr7cL+gfS3685hI7d3cM3pWTYfY1osJ8Tjxt
        RXigvKLzPn/gPyXEU
X-Received: by 2002:adf:e7c1:0:b0:20a:b724:cedd with SMTP id e1-20020adfe7c1000000b0020ab724ceddmr3754615wrn.409.1650547646147;
        Thu, 21 Apr 2022 06:27:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1mLjefkTZZ4wtvo2Ag6LTXFcm2397M8W/09XqE/3E7QwNxkbcdAd40bzlTtjEDoM/t6vrcA==
X-Received: by 2002:adf:e7c1:0:b0:20a:b724:cedd with SMTP id e1-20020adfe7c1000000b0020ab724ceddmr3754600wrn.409.1650547645820;
        Thu, 21 Apr 2022 06:27:25 -0700 (PDT)
Received: from gerbillo.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c358d00b0039291be4573sm2231246wmq.1.2022.04.21.06.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:27:25 -0700 (PDT)
Message-ID: <151a8301018e91ae34f9e33141b398cbe68de45f.camel@redhat.com>
Subject: Re: [PATCH V2] octeontx2-pf: Add support for adaptive interrupt
 coalescing
From:   Paolo Abeni <pabeni@redhat.com>
To:     Suman Ghosh <sumang@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, sgoutham@marvell.com, netdev@vger.kernel.org
Date:   Thu, 21 Apr 2022 15:27:24 +0200
In-Reply-To: <20220418110205.282193-1-sumang@marvell.com>
References: <20220418110205.282193-1-sumang@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-04-18 at 16:32 +0530, Suman Ghosh wrote:
> Added support for adaptive IRQ coalescing. It uses net_dim
> algorithm to find the suitable delay/IRQ count based on the
> current packet rate.
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> Changes since V1
> - No change, resubmitting because V1 did not get picked up in patchworks
>   for some reason.
> 
>  .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
>  .../marvell/octeontx2/nic/otx2_common.c       |  5 ---
>  .../marvell/octeontx2/nic/otx2_common.h       | 10 +++++
>  .../marvell/octeontx2/nic/otx2_ethtool.c      | 43 ++++++++++++++++---
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 22 ++++++++++
>  .../marvell/octeontx2/nic/otx2_txrx.c         | 28 ++++++++++++
>  .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
>  7 files changed, 99 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> index 8560f7e463d3..a544733152d8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
> +++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> @@ -30,6 +30,7 @@ config OCTEONTX2_PF
>  	tristate "Marvell OcteonTX2 NIC Physical Function driver"
>  	select OCTEONTX2_MBOX
>  	select NET_DEVLINK
> +	select DIMLIB
>  	depends on PCI
>  	help
>  	  This driver supports Marvell's OcteonTX2 Resource Virtualization
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 033fd79d35b0..c28850d815c2 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -103,11 +103,6 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)
>  {
>  	struct otx2_dev_stats *dev_stats = &pfvf->hw.dev_stats;
>  
> -#define OTX2_GET_RX_STATS(reg) \
> -	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
> -#define OTX2_GET_TX_STATS(reg) \
> -	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
> -
>  	dev_stats->rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
>  	dev_stats->rx_drops = OTX2_GET_RX_STATS(RX_DROP);
>  	dev_stats->rx_bcast_frames = OTX2_GET_RX_STATS(RX_BCAST);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index d9f4b085b2a4..6abf5c28921f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -16,6 +16,7 @@
>  #include <net/pkt_cls.h>
>  #include <net/devlink.h>
>  #include <linux/time64.h>
> +#include <linux/dim.h>
>  
>  #include <mbox.h>
>  #include <npc.h>
> @@ -54,6 +55,11 @@ enum arua_mapped_qtypes {
>  /* Send skid of 2000 packets required for CQ size of 4K CQEs. */
>  #define SEND_CQ_SKID	2000
>  
> +#define OTX2_GET_RX_STATS(reg) \
> +	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
> +#define OTX2_GET_TX_STATS(reg) \
> +	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
> +
>  struct otx2_lmt_info {
>  	u64 lmt_addr;
>  	u16 lmt_id;
> @@ -363,6 +369,7 @@ struct otx2_nic {
>  #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
>  #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
>  #define OTX2_FLAG_PTP_ONESTEP_SYNC		BIT_ULL(15)
> +#define OTX2_FLAG_ADPTV_INT_COAL_ENABLED	BIT_ULL(16)
>  	u64			flags;
>  	u64			*cq_op_addr;
>  
> @@ -442,6 +449,9 @@ struct otx2_nic {
>  #endif
>  	/* qos */
>  	struct otx2_qos		qos;
> +
> +	/* napi event count. It is needed for adaptive irq coalescing */
> +	u32 napi_events;
>  };
>  
>  static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 72d0b02da3cc..8ed282991f05 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -477,6 +477,14 @@ static int otx2_get_coalesce(struct net_device *netdev,
>  	cmd->rx_max_coalesced_frames = hw->cq_ecount_wait;
>  	cmd->tx_coalesce_usecs = hw->cq_time_wait;
>  	cmd->tx_max_coalesced_frames = hw->cq_ecount_wait;
> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
> +		OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
> +		cmd->use_adaptive_rx_coalesce = 1;
> +		cmd->use_adaptive_tx_coalesce = 1;
> +	} else {
> +		cmd->use_adaptive_rx_coalesce = 0;
> +		cmd->use_adaptive_tx_coalesce = 0;
> +	}
>  
>  	return 0;
>  }
> @@ -486,10 +494,10 @@ static int otx2_set_coalesce(struct net_device *netdev,
>  {
>  	struct otx2_nic *pfvf = netdev_priv(netdev);
>  	struct otx2_hw *hw = &pfvf->hw;
> +	u8 priv_coalesce_status;
>  	int qidx;
>  
> -	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
> -	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
> +	if (ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
>  	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
>  	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
>  	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low ||
> @@ -502,6 +510,18 @@ static int otx2_set_coalesce(struct net_device *netdev,
>  	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
>  		return 0;
>  
> +	/* Check and update coalesce status */
> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
> +	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
> +		priv_coalesce_status = 1;
> +		if (!ec->use_adaptive_rx_coalesce || !ec->use_adaptive_tx_coalesce)
> +			pfvf->flags &= ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
> +	} else {
> +		priv_coalesce_status = 0;
> +		if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)
> +			pfvf->flags |= OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
> +	}
> +
>  	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
>  	 * so clamp the user given value to the range of 1 to 25usec.
>  	 */
> @@ -521,13 +541,13 @@ static int otx2_set_coalesce(struct net_device *netdev,
>  		hw->cq_time_wait = min_t(u8, ec->rx_coalesce_usecs,
>  					 ec->tx_coalesce_usecs);
>  
> -	/* Max ecount_wait supported is 16bit,
> -	 * so clamp the user given value to the range of 1 to 64k.
> +	/* Max packet budget per napi is 64,
> +	 * so clamp the user given value to the range of 1 to 64.
>  	 */
>  	ec->rx_max_coalesced_frames = clamp_t(u32, ec->rx_max_coalesced_frames,
> -					      1, U16_MAX);
> +					      1, NAPI_POLL_WEIGHT);
>  	ec->tx_max_coalesced_frames = clamp_t(u32, ec->tx_max_coalesced_frames,
> -					      1, U16_MAX);
> +					      1, NAPI_POLL_WEIGHT);
>  
>  	/* Rx and Tx are mapped to same CQ, check which one
>  	 * is changed, if both then choose the min.
> @@ -540,6 +560,17 @@ static int otx2_set_coalesce(struct net_device *netdev,
>  		hw->cq_ecount_wait = min_t(u16, ec->rx_max_coalesced_frames,
>  					   ec->tx_max_coalesced_frames);
>  
> +	/* Reset 'cq_time_wait' and 'cq_ecount_wait' to
> +	 * default values if coalesce status changed from
> +	 * 'on' to 'off'.
> +	 */
> +	if (priv_coalesce_status &&
> +	    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) !=
> +	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
> +		hw->cq_time_wait = CQ_TIMER_THRESH_DEFAULT;
> +		hw->cq_ecount_wait = CQ_CQE_THRESH_DEFAULT;
> +	}
> +
>  	if (netif_running(netdev)) {
>  		for (qidx = 0; qidx < pfvf->hw.cint_cnt; qidx++)
>  			otx2_config_irq_coalescing(pfvf, qidx);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index f18c9a9a50d0..94aaafbeb365 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -1279,6 +1279,7 @@ static irqreturn_t otx2_cq_intr_handler(int irq, void *cq_irq)
>  	otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
>  
>  	/* Schedule NAPI */
> +	pf->napi_events++;
>  	napi_schedule_irqoff(&cq_poll->napi);
>  
>  	return IRQ_HANDLED;
> @@ -1292,6 +1293,7 @@ static void otx2_disable_napi(struct otx2_nic *pf)
>  
>  	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
>  		cq_poll = &qset->napi[qidx];
> +		cancel_work_sync(&cq_poll->dim.work);
>  		napi_disable(&cq_poll->napi);
>  		netif_napi_del(&cq_poll->napi);
>  	}
> @@ -1538,6 +1540,24 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
>  	mutex_unlock(&mbox->lock);
>  }
>  
> +static void otx2_dim_work(struct work_struct *w)
> +{
> +	struct dim_cq_moder cur_moder;
> +	struct otx2_cq_poll *cq_poll;
> +	struct otx2_nic *pfvf;
> +	struct dim *dim;
> +
> +	dim = container_of(w, struct dim, work);
> +	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
> +	cq_poll = container_of(dim, struct otx2_cq_poll, dim);
> +	pfvf = (struct otx2_nic *)cq_poll->dev;
> +	pfvf->hw.cq_time_wait = (cur_moder.usec > CQ_TIMER_THRESH_MAX) ?
> +				CQ_TIMER_THRESH_MAX : cur_moder.usec;
> +	pfvf->hw.cq_ecount_wait = (cur_moder.pkts > NAPI_POLL_WEIGHT) ?
> +				NAPI_POLL_WEIGHT : cur_moder.pkts;
> +	dim->state = DIM_START_MEASURE;
> +}
> +
>  int otx2_open(struct net_device *netdev)
>  {
>  	struct otx2_nic *pf = netdev_priv(netdev);
> @@ -1611,6 +1631,8 @@ int otx2_open(struct net_device *netdev)
>  					  CINT_INVALID_CQ;
>  
>  		cq_poll->dev = (void *)pf;
> +		cq_poll->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_CQE;
> +		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
>  		netif_napi_add(netdev, &cq_poll->napi,
>  			       otx2_napi_handler, NAPI_POLL_WEIGHT);
>  		napi_enable(&cq_poll->napi);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 459b94b99ddb..927dd12b4f4e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -512,6 +512,22 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
>  	return 0;
>  }
>  
> +static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct otx2_cq_poll *cq_poll)
> +{
> +	struct dim_sample dim_sample;
> +	u64 rx_frames, rx_bytes;
> +
> +	rx_frames = OTX2_GET_RX_STATS(RX_BCAST) + OTX2_GET_RX_STATS(RX_MCAST) +
> +			OTX2_GET_RX_STATS(RX_UCAST);
> +	rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
> +	dim_update_sample(pfvf->napi_events,
> +			  rx_frames,
> +			  rx_bytes,
> +			  &dim_sample);
> +
> +	net_dim(&cq_poll->dim, dim_sample);
> +}
> +
>  int otx2_napi_handler(struct napi_struct *napi, int budget)
>  {
>  	struct otx2_cq_queue *rx_cq = NULL;
> @@ -549,6 +565,18 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
>  		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
>  			return workdone;
>  
> +		/* Check for adaptive interrupt coalesce */
> +		if (workdone != 0 &&
> +		    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
> +		    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
> +			/* Adjust irq coalese using net_dim */
> +			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
> +
> +			/* Update irq coalescing */
> +			for (i = 0; i < pfvf->hw.cint_cnt; i++)
> +				otx2_config_irq_coalescing(pfvf, i);
> +		}
> +

Why are you updating the IRQ coalescing parameters for every sample?
You probably should to that in void otx2_dim_work(), when dim tells
it's the right time to update them.

Thanks,

Paolo

