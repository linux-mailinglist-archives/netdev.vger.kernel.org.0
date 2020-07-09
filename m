Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4D121A446
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGIQCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:02:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB0CC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 09:02:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x72so1203560pfc.6
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A3AXTMg73kST+LZKukzm4AzOe3bxg4QFgJT8PoB1cZ8=;
        b=hGsVjhG0V4FiT+Nv008ZFYuAkdSsigaDtNZvx0vc/SUDGzE55M3atOJaJjmHxR8HEL
         QkmksAe1cIu/0ECit6b88IMfLAWr3irs8mI2L0vTZAZNjzl3UDBEowyImNlEGfyB1tHT
         iaM2gYlgOqJU7ysRyEU0fAnRz4emTSbOs2bKgCECX+nlocFs3gfjGojgw9nMGA5ULtGc
         45+BvS/949lRz61B7LimJ2Q7NCwLoECZ6q0IdIL2+Q1ezY+J5z+NmbXjifB+vsbDoqxH
         AGFNQYs9DacuQBTVUUWZSlvRzpYNILCY89ZAyTlyK+qntHJIpWEogWkrpAVCNiQk9cci
         uNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A3AXTMg73kST+LZKukzm4AzOe3bxg4QFgJT8PoB1cZ8=;
        b=AGPfY2ApRW03mFaf6zNHDZ27szAoCyCifyF6tYMRbdomMCX92UvNZRkhgegZXIkWIV
         XSwguihT0MRibDlwsqJVd8Ya3PTGnSdhZ+ZsnvTKmjKS9YFhVMTdM47LvkN83Kohmn37
         hSUOyIKqx5Bi0eBoRUg8kYcNRVm4oGU4APunSm0upomV4GY0MBfCCDWWLwxx4htM0Rl2
         /8XFTOcPhRvjdX7sD+fMJD0YTPNQfECz590Gqnn0ZN3vBm5/mKB06H5Z1aJeg37uG1KA
         X6nXLFJ8sTnsIWj99RSv/bkY7IiU2QJWXi4KHCf5sYqHbYOTiYGzmMnPEeP2EuF2GoUV
         bAHg==
X-Gm-Message-State: AOAM530SrbtdSXjBm4dEn+u/Ze/+73wD5Fv62Dc0ZwtvKEm7veXqoM89
        eVf23a9ycBSfhb2vZeChrNk=
X-Google-Smtp-Source: ABdhPJz/B2qniydyBN/zSOaYrzQ8jnuaBwmDanAFnN07Uu2In3gKKjdoMSrtJPXmZqV0YEk55V/MMA==
X-Received: by 2002:a05:6a00:15c8:: with SMTP id o8mr60577055pfu.286.1594310520331;
        Thu, 09 Jul 2020 09:02:00 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k2sm3322292pgm.11.2020.07.09.09.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 09:01:59 -0700 (PDT)
Date:   Thu, 9 Jul 2020 09:01:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>
Subject: Re: [PATCH v3 net-next 3/3] octeontx2-pf: Add support for PTP clock
Message-ID: <20200709160156.GC7904@hoboy>
References: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
 <1594301221-3731-4-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594301221-3731-4-git-send-email-sundeep.lkml@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 06:57:01PM +0530, sundeep.lkml@gmail.com wrote:

> @@ -1736,6 +1751,143 @@ static void otx2_reset_task(struct work_struct *work)
>  	netif_trans_update(pf->netdev);
>  }
>  
> +static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable)
> +{
> +	struct msg_req *req;
> +	int err;
> +
> +	if (pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED && enable)
> +		return 0;

It appears that nothing protects pfvf->flags from concurrent access.
Please double check and correct if needed.

> +	mutex_lock(&pfvf->mbox.lock);
> +	if (enable)
> +		req = otx2_mbox_alloc_msg_cgx_ptp_rx_enable(&pfvf->mbox);
> +	else
> +		req = otx2_mbox_alloc_msg_cgx_ptp_rx_disable(&pfvf->mbox);
> +	if (!req) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return -ENOMEM;
> +	}
> +
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return err;
> +	}
> +
> +	mutex_unlock(&pfvf->mbox.lock);
> +	if (enable)
> +		pfvf->flags |= OTX2_FLAG_RX_TSTAMP_ENABLED;
> +	else
> +		pfvf->flags &= ~OTX2_FLAG_RX_TSTAMP_ENABLED;
> +	return 0;
> +}
> +
> +static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable)
> +{
> +	struct msg_req *req;
> +	int err;
> +
> +	if (pfvf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED && enable)
> +		return 0;

Again, please check concurrency here.

> +
> +	mutex_lock(&pfvf->mbox.lock);
> +	if (enable)
> +		req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_enable(&pfvf->mbox);
> +	else
> +		req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_disable(&pfvf->mbox);
> +	if (!req) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return -ENOMEM;
> +	}
> +
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return err;
> +	}
> +
> +	mutex_unlock(&pfvf->mbox.lock);
> +	if (enable)
> +		pfvf->flags |= OTX2_FLAG_TX_TSTAMP_ENABLED;
> +	else
> +		pfvf->flags &= ~OTX2_FLAG_TX_TSTAMP_ENABLED;
> +	return 0;
> +}
> +
> +static int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct hwtstamp_config config;
> +
> +	if (!pfvf->ptp)
> +		return -ENODEV;
> +
> +	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	/* reserved for future extensions */
> +	if (config.flags)
> +		return -EINVAL;
> +
> +	switch (config.tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +		otx2_config_hw_tx_tstamp(pfvf, false);
> +		break;
> +	case HWTSTAMP_TX_ON:
> +		otx2_config_hw_tx_tstamp(pfvf, true);
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		otx2_config_hw_rx_tstamp(pfvf, false);
> +		break;
> +	case HWTSTAMP_FILTER_ALL:
> +	case HWTSTAMP_FILTER_SOME:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		otx2_config_hw_rx_tstamp(pfvf, true);
> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	memcpy(&pfvf->tstamp, &config, sizeof(config));
> +
> +	return copy_to_user(ifr->ifr_data, &config,
> +			    sizeof(config)) ? -EFAULT : 0;
> +}
> +
> +static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct hwtstamp_config *cfg = &pfvf->tstamp;
> +

Need to test phy_has_hwtstamp() here and pass ioctl to PHY if true.

> +	switch (cmd) {
> +	case SIOCSHWTSTAMP:
> +		return otx2_config_hwtstamp(netdev, req);
> +	case SIOCGHWTSTAMP:
> +		return copy_to_user(req->ifr_data, cfg,
> +				    sizeof(*cfg)) ? -EFAULT : 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static const struct net_device_ops otx2_netdev_ops = {
>  	.ndo_open		= otx2_open,
>  	.ndo_stop		= otx2_stop,


> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
> new file mode 100644
> index 0000000..28058bd
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
> @@ -0,0 +1,208 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Marvell OcteonTx2 PTP support for ethernet driver */
> +
> +#include "otx2_common.h"
> +#include "otx2_ptp.h"
> +
> +static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
> +{
> +	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> +					    ptp_info);
> +	struct ptp_req *req;
> +	int err;
> +
> +	if (!ptp->nic)
> +		return -ENODEV;
> +
> +	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
> +	if (!req)
> +		return -ENOMEM;
> +
> +	req->op = PTP_OP_ADJFINE;
> +	req->scaled_ppm = scaled_ppm;
> +
> +	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static u64 ptp_cc_read(const struct cyclecounter *cc)
> +{
> +	struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
> +	struct ptp_req *req;
> +	struct ptp_rsp *rsp;
> +	int err;
> +
> +	if (!ptp->nic)
> +		return 0;
> +
> +	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
> +	if (!req)
> +		return 0;
> +
> +	req->op = PTP_OP_GET_CLOCK;
> +
> +	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
> +	if (err)
> +		return 0;
> +
> +	rsp = (struct ptp_rsp *)otx2_mbox_get_rsp(&ptp->nic->mbox.mbox, 0,
> +						  &req->hdr);
> +	if (IS_ERR(rsp))
> +		return 0;
> +
> +	return rsp->clk;
> +}
> +
> +static int otx2_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
> +{
> +	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> +					    ptp_info);
> +	struct otx2_nic *pfvf = ptp->nic;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +	timecounter_adjtime(&ptp->time_counter, delta);
> +	mutex_unlock(&pfvf->mbox.lock);
> +
> +	return 0;
> +}
> +
> +static int otx2_ptp_gettime(struct ptp_clock_info *ptp_info,
> +			    struct timespec64 *ts)
> +{
> +	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> +					    ptp_info);
> +	struct otx2_nic *pfvf = ptp->nic;
> +	u64 nsec;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +	nsec = timecounter_read(&ptp->time_counter);
> +	mutex_unlock(&pfvf->mbox.lock);
> +
> +	*ts = ns_to_timespec64(nsec);
> +
> +	return 0;
> +}
> +
> +static int otx2_ptp_settime(struct ptp_clock_info *ptp_info,
> +			    const struct timespec64 *ts)
> +{
> +	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> +					    ptp_info);
> +	struct otx2_nic *pfvf = ptp->nic;
> +	u64 nsec;
> +
> +	nsec = timespec64_to_ns(ts);
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +	timecounter_init(&ptp->time_counter, &ptp->cycle_counter, nsec);
> +	mutex_unlock(&pfvf->mbox.lock);
> +
> +	return 0;
> +}
> +
> +static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
> +			   struct ptp_clock_request *rq, int on)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +int otx2_ptp_init(struct otx2_nic *pfvf)
> +{
> +	struct otx2_ptp *ptp_ptr;
> +	struct cyclecounter *cc;
> +	struct ptp_req *req;
> +	int err;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +	/* check if PTP block is available */
> +	req = otx2_mbox_alloc_msg_ptp_op(&pfvf->mbox);
> +	if (!req) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return -ENOMEM;
> +	}
> +
> +	req->op = PTP_OP_GET_CLOCK;
> +
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return err;
> +	}
> +	mutex_unlock(&pfvf->mbox.lock);
> +
> +	ptp_ptr = kzalloc(sizeof(*ptp_ptr), GFP_KERNEL);
> +	if (!ptp_ptr) {
> +		err = -ENOMEM;
> +		goto error;
> +	}
> +
> +	ptp_ptr->nic = pfvf;
> +
> +	cc = &ptp_ptr->cycle_counter;
> +	cc->read = ptp_cc_read;
> +	cc->mask = CYCLECOUNTER_MASK(64);
> +	cc->mult = 1;
> +	cc->shift = 0;
> +
> +	timecounter_init(&ptp_ptr->time_counter, &ptp_ptr->cycle_counter,
> +			 ktime_to_ns(ktime_get_real()));
> +
> +	ptp_ptr->ptp_info = (struct ptp_clock_info) {
> +		.owner          = THIS_MODULE,
> +		.name           = "OcteonTX2 PTP",
> +		.max_adj        = 1000000000ull,
> +		.n_ext_ts       = 0,
> +		.n_pins         = 0,
> +		.pps            = 0,
> +		.adjfine        = otx2_ptp_adjfine,
> +		.adjtime        = otx2_ptp_adjtime,
> +		.gettime64      = otx2_ptp_gettime,
> +		.settime64      = otx2_ptp_settime,
> +		.enable         = otx2_ptp_enable,
> +	};
> +
> +	ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);
> +	if (IS_ERR(ptp_ptr->ptp_clock)) {
> +		err = PTR_ERR(ptp_ptr->ptp_clock);
> +		kfree(ptp_ptr);
> +		goto error;
> +	}

You need to handle NULL here.

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

> +
> +	pfvf->ptp = ptp_ptr;
> +
> +error:
> +	return err;
> +}
> +
> +void otx2_ptp_destroy(struct otx2_nic *pfvf)
> +{
> +	struct otx2_ptp *ptp = pfvf->ptp;
> +
> +	if (!ptp)
> +		return;
> +
> +	ptp_clock_unregister(ptp->ptp_clock);
> +	kfree(ptp);
> +	pfvf->ptp = NULL;
> +}
> +
> +int otx2_ptp_clock_index(struct otx2_nic *pfvf)
> +{
> +	if (!pfvf->ptp)
> +		return -ENODEV;
> +
> +	return ptp_clock_index(pfvf->ptp->ptp_clock);
> +}
> +
> +int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns)
> +{
> +	if (!pfvf->ptp)
> +		return -ENODEV;
> +
> +	*tsns = timecounter_cyc2time(&pfvf->ptp->time_counter, tstamp);
> +
> +	return 0;
> +}


> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 3a5b34a..1f90426 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -16,6 +16,7 @@
>  #include "otx2_common.h"
>  #include "otx2_struct.h"
>  #include "otx2_txrx.h"
> +#include "otx2_ptp.h"
>  
>  #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
>  
> @@ -81,8 +82,11 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
>  				 int budget, int *tx_pkts, int *tx_bytes)
>  {
>  	struct nix_send_comp_s *snd_comp = &cqe->comp;
> +	struct skb_shared_hwtstamps ts;
>  	struct sk_buff *skb = NULL;
> +	u64 timestamp, tsns;
>  	struct sg_list *sg;
> +	int err;
>  
>  	if (unlikely(snd_comp->status) && netif_msg_tx_err(pfvf))
>  		net_err_ratelimited("%s: TX%d: Error in send CQ status:%x\n",
> @@ -94,6 +98,18 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
>  	if (unlikely(!skb))
>  		return;
>  
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {

SKBTX_IN_PROGRESS may be set by the PHY, so you need to test whether
time stamping is enabled in your MAC driver as well.

> +		timestamp = ((u64 *)sq->timestamps->base)[snd_comp->sqe_id];
> +		if (timestamp != 1) {
> +			err = otx2_ptp_tstamp2time(pfvf, timestamp, &tsns);
> +			if (!err) {
> +				memset(&ts, 0, sizeof(ts));
> +				ts.hwtstamp = ns_to_ktime(tsns);
> +				skb_tstamp_tx(skb, &ts);
> +			}
> +		}
> +	}
> +
>  	*tx_bytes += skb->len;
>  	(*tx_pkts)++;
>  	otx2_dma_unmap_skb_frags(pfvf, sg);

Thanks,
Richard
