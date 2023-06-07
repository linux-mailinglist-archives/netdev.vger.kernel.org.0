Return-Path: <netdev+bounces-8966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A237266C3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828651C20A0C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E230370FE;
	Wed,  7 Jun 2023 17:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4172763B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:08:53 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-19.smtpout.orange.fr [80.12.242.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F6B1BE4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:08:50 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 6weMqJe3YSNCw6weMqBxss; Wed, 07 Jun 2023 19:08:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1686157728;
	bh=cdPbQRbPDp+0zA8pJiiJF8vCEuIQxafiGUtIS4RjinE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iztr6Ygp2jO295OFc8hcNMYK+NHPUOyX56BTDBuZMDiabs1FaUVcwYl4TQvuerwvp
	 2jFbciRi9xuMH2xGzWgRwWoZxSU4qJQ0uyCDf9SEMobGgYJXXuDDTW6QrJIMz82kBH
	 tWXM81i2kXrcbKIQQbLUBrd5UxtBpO5mzfXxCs6u9HrmsspZWvJ+HRwUg4ZPOqTT4G
	 4PTkHFpAYxw0hMqb1UyVbfaFTxjRlKyaW8Ny8LDBo90zoxBWYjcou85E87gZAPk1sL
	 TC06vcxI474ViC+x9J/3K5kW3DvhjQzZw9CBnD2rkail3ByX+PiS/evzih4Vih/3fJ
	 khEtieUBvijeA==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 07 Jun 2023 19:08:48 +0200
X-ME-IP: 86.243.2.178
Message-ID: <b34b048e-1291-207d-b611-c66d591cbf1b@wanadoo.fr>
Date: Wed, 7 Jun 2023 19:08:46 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/2] net: Add MHI Endpoint network driver
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, loic.poulain@linaro.org
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
Content-Language: fr
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Le 07/06/2023 à 17:24, Manivannan Sadhasivam a écrit :
> Add a network driver for the Modem Host Interface (MHI) endpoint devices
> that provides network interfaces to the PCIe based Qualcomm endpoint
> devices supporting MHI bus. This driver allows the MHI endpoint devices to
> establish IP communication with the host machines (x86, ARM64) over MHI
> bus.
> 
> The driver currently supports only IP_SW0 MHI channel that can be used
> to route IP traffic from the endpoint CPU to host machine.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---

[...]

> +static int mhi_ep_net_newlink(struct mhi_ep_device *mhi_dev, struct net_device *ndev)
> +{
> +	struct mhi_ep_net_dev *mhi_ep_netdev;
> +	int ret;
> +
> +	mhi_ep_netdev = netdev_priv(ndev);
> +
> +	dev_set_drvdata(&mhi_dev->dev, mhi_ep_netdev);
> +	mhi_ep_netdev->ndev = ndev;
> +	mhi_ep_netdev->mdev = mhi_dev;
> +	mhi_ep_netdev->mru = mhi_dev->mhi_cntrl->mru;
> +
> +	skb_queue_head_init(&mhi_ep_netdev->tx_buffers);
> +	spin_lock_init(&mhi_ep_netdev->tx_lock);
> +
> +	u64_stats_init(&mhi_ep_netdev->stats.rx_syncp);
> +	u64_stats_init(&mhi_ep_netdev->stats.tx_syncp);
> +
> +	mhi_ep_netdev->xmit_wq = alloc_workqueue("mhi_ep_net_xmit_wq", 0, WQ_HIGHPRI);

if (!mhi_ep_netdev->xmit_wq)
	return -ENOMEM;

> +	INIT_WORK(&mhi_ep_netdev->xmit_work, mhi_ep_net_dev_process_queue_packets);
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		destroy_workqueue(mhi_ep_netdev->xmit_wq);

I don't really think it is needed, but to be consistent with 
mhi_ep_net_dellink(), maybe:
	dev_set_drvdata(&mhi_dev->dev, NULL);

CJ

> +		return ret;
> +	}
> +
> +	return 0;
> +}

[...]


