Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD82D45C3
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgLIPrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:47:09 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:20766 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgLIPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:47:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607528805; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=y1Wmae3WtsmaxXmUIENiy1KGHxXjyeq1imlrpIn8Kmg=; b=MhXCjk+ggjeyFojCTBkfOL9/1b1Hf3pKnDaWPG1QuGOImF+UHtbYiskbw8+wUIdfTAmjr0hG
 Mbkfu3HB79J6v/CA1PlbH07B1IW0yEDsopVa1kUhPnpebu2F1vRyihwGyvybF6IwcfUXiA1q
 Dc4KZvg4ii0jSBE81OGaICbESS0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fd0f15cce88b59ab8f41e9b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Dec 2020 15:46:36
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C216DC433ED; Wed,  9 Dec 2020 15:46:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BBB3AC433C6;
        Wed,  9 Dec 2020 15:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BBB3AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH 2/3] net: mhi: Get RX queue size from MHI core
To:     Loic Poulain <loic.poulain@linaro.org>, kuba@kernel.org
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1607526183-25652-1-git-send-email-loic.poulain@linaro.org>
 <1607526183-25652-2-git-send-email-loic.poulain@linaro.org>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <dba2d62f-ff2a-8925-e2e5-20c951d230c5@codeaurora.org>
Date:   Wed, 9 Dec 2020 08:46:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1607526183-25652-2-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/2020 8:03 AM, Loic Poulain wrote:
> The RX queue size can be determined at runtime by retrieveing the

retrieving

> number of available transfer descriptors
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>   drivers/net/mhi_net.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 8e72d94..0333e07 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -256,9 +256,6 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>   	mhi_netdev->mdev = mhi_dev;
>   	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
>   
> -	/* All MHI net channels have 128 ring elements (at least for now) */
> -	mhi_netdev->rx_queue_sz = 128;
> -
>   	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
>   	u64_stats_init(&mhi_netdev->stats.rx_syncp);
>   	u64_stats_init(&mhi_netdev->stats.tx_syncp);
> @@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>   	if (err)
>   		goto out_err;
>   
> +	/* Number of transfer descriptors determines size of the queue */
> +	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> +
>   	err = register_netdev(ndev);
>   	if (err)
>   		goto out_err;
> 


-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
