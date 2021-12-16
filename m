Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622D74769A5
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 06:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhLPFfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 00:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhLPFfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 00:35:19 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593BDC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 21:35:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d11so13398288pgl.1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 21:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xAUPKtHZ/cqip3q5aKQfZCHMrNxXrdQ/AfUvWj8BXC0=;
        b=wHwXQzzywBprb31FoxwkrxpnFsD39NHv77EUAfDiIV60T5VCq4gdjm9nr7ux3gM66T
         CC5QgxYPgbNaQV7JbJX5V1L105hE4Qqm5XFqT9R8y7sLxIpcxscRkZv02CBVFfEjplcM
         AirvFnTDiTy/fmHej5+AZ0PCE7Pu3a7aH0vsQVL12GgfTy38zWOEqVPZNaD9pIBOoRF8
         bDCaK9LUDVHpg5TUy8qj9CkiMO5AByL61fo9ljgdQpa6fSAL9zXhax94jyKN2M8ROLnt
         nY5BFpRNBsx11pG1pr2Hh1mTaMyXfn5+JNQSdgO9yN/ohEAzZIs3VZmq4I3mopIBldcK
         iKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xAUPKtHZ/cqip3q5aKQfZCHMrNxXrdQ/AfUvWj8BXC0=;
        b=M7D8wXz6oWSqOlh5lrq66uiRHqnM9M4Xz79HlfgSp2XcWDI/JeO55dvg6a1oqmM1Hb
         7k7RPz3ID1hPJ4mjAdPJAkwhEKiiHozDKzkVIRCuGu8129xv8JitV9hA8vZdGS2GzYjn
         JsZo44yEt4qVRpnLfztlmcgbHtI3fR41hUBspmPaYGPnhVcUPHGgycZN2DDVZymby7c/
         HLyBFoL45AP3jA2M8sa8NhsWZrON1ZV5LZezE0Tk7uer/uXG89ocdsbYYEDB2XJEQ0AX
         FKd33tmH9XGJyBBEF/nqgT9c3vsSMVeL99s8pM0OnfTJBgcjuvlh4cKP/laM73acLuPu
         42zw==
X-Gm-Message-State: AOAM5313VnBfrrGxwyX7j1hSD0xqWtCs2SJPMI00dRI+JHfv2SqY83hc
        3jTL6KWKr/fSPl3BGARZfrY037xwyv4B
X-Google-Smtp-Source: ABdhPJwWgwWqnJqfrk7zPIVSoeCZxW3qcEmBoSg8LL687Mj2sffFemKpbMHq7tQO0c4v26/A/eIjwA==
X-Received: by 2002:a05:6a00:1903:b0:47c:34c1:c6b6 with SMTP id y3-20020a056a00190300b0047c34c1c6b6mr12422821pfi.17.1639632918869;
        Wed, 15 Dec 2021 21:35:18 -0800 (PST)
Received: from thinkpad ([117.193.209.65])
        by smtp.gmail.com with ESMTPSA id me7sm8589866pjb.9.2021.12.15.21.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 21:35:18 -0800 (PST)
Date:   Thu, 16 Dec 2021 11:05:13 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     loic.poulain@linaro.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] bus: mhi: core: Add an API for auto queueing buffers
 for DL channel
Message-ID: <20211216053513.GC42608@thinkpad>
References: <20211207071339.123794-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207071339.123794-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 12:43:39PM +0530, Manivannan Sadhasivam wrote:
> Add a new API "mhi_prepare_for_transfer_autoqueue" for using with client
> drivers like QRTR to request MHI core to autoqueue buffers for the DL
> channel along with starting both UL and DL channels.
> 
> So far, the "auto_queue" flag specified by the controller drivers in
> channel definition served this purpose but this will be removed at some
> point in future.
> 
> Cc: netdev@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied to mhi-next with Ack from Jakub!

Thanks,
Mani

> ---
> 
> Changes in v2:
> 
> * Rebased on top of 5.16-rc1
> * Fixed an issue reported by kernel test bot
> * CCed netdev folks and Greg
> * Slight change to the commit subject for reflecting "core" sub-directory
> 
>  drivers/bus/mhi/core/internal.h |  6 +++++-
>  drivers/bus/mhi/core/main.c     | 21 +++++++++++++++++----
>  include/linux/mhi.h             | 21 ++++++++++++++++-----
>  net/qrtr/mhi.c                  |  2 +-
>  4 files changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> index 9d72b1d1e986..e2e10474a9d9 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -682,8 +682,12 @@ void mhi_deinit_free_irq(struct mhi_controller *mhi_cntrl);
>  void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
>  		      struct image_info *img_info);
>  void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
> +
> +/* Automatically allocate and queue inbound buffers */
> +#define MHI_CH_INBOUND_ALLOC_BUFS BIT(0)
>  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> -			struct mhi_chan *mhi_chan);
> +			struct mhi_chan *mhi_chan, unsigned int flags);
> +
>  int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
>  		       struct mhi_chan *mhi_chan);
>  void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> index 930aba666b67..ffde617f93a3 100644
> --- a/drivers/bus/mhi/core/main.c
> +++ b/drivers/bus/mhi/core/main.c
> @@ -1430,7 +1430,7 @@ static void mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
>  }
>  
>  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> -			struct mhi_chan *mhi_chan)
> +			struct mhi_chan *mhi_chan, unsigned int flags)
>  {
>  	int ret = 0;
>  	struct device *dev = &mhi_chan->mhi_dev->dev;
> @@ -1455,6 +1455,9 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
>  	if (ret)
>  		goto error_pm_state;
>  
> +	if (mhi_chan->dir == DMA_FROM_DEVICE)
> +		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
> +
>  	/* Pre-allocate buffer for xfer ring */
>  	if (mhi_chan->pre_alloc) {
>  		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
> @@ -1610,8 +1613,7 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
>  	read_unlock_bh(&mhi_cntrl->pm_lock);
>  }
>  
> -/* Move channel to start state */
> -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
> +static int __mhi_prepare_for_transfer(struct mhi_device *mhi_dev, unsigned int flags)
>  {
>  	int ret, dir;
>  	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> @@ -1622,7 +1624,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
>  		if (!mhi_chan)
>  			continue;
>  
> -		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
> +		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
>  		if (ret)
>  			goto error_open_chan;
>  	}
> @@ -1640,8 +1642,19 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
>  
>  	return ret;
>  }
> +
> +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
> +{
> +	return __mhi_prepare_for_transfer(mhi_dev, 0);
> +}
>  EXPORT_SYMBOL_GPL(mhi_prepare_for_transfer);
>  
> +int mhi_prepare_for_transfer_autoqueue(struct mhi_device *mhi_dev)
> +{
> +	return __mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
> +}
> +EXPORT_SYMBOL_GPL(mhi_prepare_for_transfer_autoqueue);
> +
>  void mhi_unprepare_from_transfer(struct mhi_device *mhi_dev)
>  {
>  	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> index 723985879035..271db1d6da85 100644
> --- a/include/linux/mhi.h
> +++ b/include/linux/mhi.h
> @@ -717,15 +717,26 @@ void mhi_device_put(struct mhi_device *mhi_dev);
>  
>  /**
>   * mhi_prepare_for_transfer - Setup UL and DL channels for data transfer.
> - *                            Allocate and initialize the channel context and
> - *                            also issue the START channel command to both
> - *                            channels. Channels can be started only if both
> - *                            host and device execution environments match and
> - *                            channels are in a DISABLED state.
>   * @mhi_dev: Device associated with the channels
> + *
> + * Allocate and initialize the channel context and also issue the START channel
> + * command to both channels. Channels can be started only if both host and
> + * device execution environments match and channels are in a DISABLED state.
>   */
>  int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
>  
> +/**
> + * mhi_prepare_for_transfer_autoqueue - Setup UL and DL channels with auto queue
> + *                                      buffers for DL traffic
> + * @mhi_dev: Device associated with the channels
> + *
> + * Allocate and initialize the channel context and also issue the START channel
> + * command to both channels. Channels can be started only if both host and
> + * device execution environments match and channels are in a DISABLED state.
> + * The MHI core will automatically allocate and queue buffers for the DL traffic.
> + */
> +int mhi_prepare_for_transfer_autoqueue(struct mhi_device *mhi_dev);
> +
>  /**
>   * mhi_unprepare_from_transfer - Reset UL and DL channels for data transfer.
>   *                               Issue the RESET channel command and let the
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index fa611678af05..18196e1c8c2f 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -79,7 +79,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	int rc;
>  
>  	/* start channels */
> -	rc = mhi_prepare_for_transfer(mhi_dev);
> +	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
>  	if (rc)
>  		return rc;
>  
> -- 
> 2.25.1
> 
