Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16B29FF71
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3IOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3IOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 04:14:01 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACE6C0613D4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 01:14:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z24so4573905pgk.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 01:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FErVvc6A5qH1alUpiUZdXd2Gs1X4yIXnaPUiKV1XzBs=;
        b=XQaqqZUY+vDaoFE35JDQU2j1Gg88/6OGfk3ha++ZZS0kAmVs45uvH2T4kBLSzvQIGt
         wDTZ2NNMBZ0c57F67DSMEpsP5m8lIat+mp31y89QwmkP8FNwSRDANNcoQMmFOoqzihxb
         wRzEZ2Kgg1sB9sxPstCYjn1v0W6hfe4BspsveT+cd7dydWhjMefFl5+zHmnJXD6+seKv
         JFIE8DPHVhI8DI4aXM0L0P/H/b5tNrqoD80vlY86XVwQ7DzRPwDPLUld0X0mGBFq6NTJ
         8pBGwGj/SKwK+DjruV/zx0PjaipNCkdkDP6ZLmQrM/oLjjc1+OW+Za2UFFxh9pLamOKS
         BjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FErVvc6A5qH1alUpiUZdXd2Gs1X4yIXnaPUiKV1XzBs=;
        b=t0irQvRwDHrDpLA5wVfR+DG9ziH9Mqc5U0Y/ZrotRwgV9ZoewCg3Mxt1HjWyI7gZRs
         ttEdgwHLVR1BcklvrHwsppBtoaiXq79gUL+WFMC1lv08ULldimtOQso1cHb7K1+VwS+d
         qsMSN/4IkVYbzz3Lrskt7iFc9SJotlfOVniadMGohUJYwbbKCCBMjptT8rPq8JsG08bV
         xknYK5nkTE3SmEsaLJ8UrREqu/QhdBy1zmC2mhRUNXjswIDGbDOylZ1QO22e9eOxAN+1
         0jbeDvf1z+xjcwiZPpS53o6Mk1t5kKwxQWGIsGqKimGolxVYqdNiv/yEY/dya/Uky+Ru
         JE5Q==
X-Gm-Message-State: AOAM533ANgttZmSPgfxDUIKq4VTmJXd7WZe+bTygwuauZYw/5qfjYQjP
        W2VFaDwB/85VrVADFHwwXTXr
X-Google-Smtp-Source: ABdhPJxA3H1UxqI4VmnmX2Pt7IQMmfBLVy2EiecG2wlc/LPj38xhT55LydbbIbJbNla+xJTdThPx6g==
X-Received: by 2002:a17:90b:b12:: with SMTP id bf18mr1077616pjb.205.1604045640696;
        Fri, 30 Oct 2020 01:14:00 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:918:28fe:10d5:aaf5:e319:ec72])
        by smtp.gmail.com with ESMTPSA id gb13sm2250181pjb.55.2020.10.30.01.13.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Oct 2020 01:13:59 -0700 (PDT)
Date:   Fri, 30 Oct 2020 13:43:51 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, hemantk@codeaurora.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org
Subject: Re: [PATCH v8 2/2] net: Add mhi-net driver
Message-ID: <20201030081351.GA3818@Mani-XPS-13-9360>
References: <1603902898-25233-1-git-send-email-loic.poulain@linaro.org>
 <1603902898-25233-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603902898-25233-2-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Wed, Oct 28, 2020 at 05:34:58PM +0100, Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 

This patch looks good to me. I just commented few nits inline. With those
addressed, you can have my:

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>   v2: - rebase on net-next
>       - remove useless skb_linearize
>       - check error type on mhi_queue return
>       - rate limited errors
>       - Schedule RX refill only on 'low' buf level
>       - SET_NETDEV_DEV in probe
>       - reorder device remove sequence
>   v3: - Stop channels on net_register error
>       - Remove useles parentheses
>       - Add driver .owner
>   v4: - prevent potential cpu hog in rx-refill loop
>       - Access mtu via READ_ONCE
>   v5: - Fix access to u64 stats
>   v6: - Stop TX queue earlier if queue is full
>       - Preventing 'abnormal' NETDEV_TX_BUSY path
>   v7: - Stop dl/ul cb operations on channel resetting
>   v8: - remove premature comment about TX threading gain
>       - check rx_queued to determine queuing limits
>       - fix probe error path (unified goto usage)
> 
>  drivers/net/Kconfig   |   7 ++
>  drivers/net/Makefile  |   1 +
>  drivers/net/mhi_net.c | 313 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 321 insertions(+)
>  create mode 100644 drivers/net/mhi_net.c
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 1368d1d..11a6357 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -426,6 +426,13 @@ config VSOCKMON
>  	  mostly intended for developers or support to debug vsock issues. If
>  	  unsure, say N.
>  
> +config MHI_NET
> +	tristate "MHI network driver"
> +	depends on MHI_BUS
> +	help
> +	  This is the network driver for MHI.  It can be used with

network driver for MHI bus.

> +	  QCOM based WWAN modems (like SDX55).  Say Y or M.
> +
>  endif # NET_CORE
>  
>  config SUNGEM_PHY
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 94b6080..8312037 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_GTP) += gtp.o
>  obj-$(CONFIG_NLMON) += nlmon.o
>  obj-$(CONFIG_NET_VRF) += vrf.o
>  obj-$(CONFIG_VSOCKMON) += vsockmon.o
> +obj-$(CONFIG_MHI_NET) += mhi_net.o
>  
>  #
>  # Networking Drivers
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> new file mode 100644
> index 0000000..4ba146d
> --- /dev/null
> +++ b/drivers/net/mhi_net.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* MHI Network driver - Network over MHI

Network over MHI bus.

> + *
> + * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
> + */
> +
> +#include <linux/if_arp.h>
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/u64_stats_sync.h>
> +
> +#define MIN_MTU		ETH_MIN_MTU
> +#define MAX_MTU		0xffff
> +#define DEFAULT_MTU	16384

Please add a prefix to avoid namespace issues in future...

> +
> +struct mhi_net_stats {
> +	u64_stats_t rx_packets;
> +	u64_stats_t rx_bytes;
> +	u64_stats_t rx_errors;
> +	u64_stats_t rx_dropped;
> +	u64_stats_t tx_packets;
> +	u64_stats_t tx_bytes;
> +	u64_stats_t tx_errors;
> +	u64_stats_t tx_dropped;
> +	atomic_t rx_queued;
> +	struct u64_stats_sync tx_syncp;
> +	struct u64_stats_sync rx_syncp;
> +};
> +
> +struct mhi_net_dev {
> +	struct mhi_device *mdev;
> +	struct net_device *ndev;
> +	struct delayed_work rx_refill;
> +	struct mhi_net_stats stats;
> +	u32 rx_queue_sz;
> +};
> +

[...]

> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int size = READ_ONCE(ndev->mtu);
> +	struct sk_buff *skb;
> +	int err;
> +
> +	do {
> +		skb = netdev_alloc_skb(ndev, size);
> +		if (unlikely(!skb))
> +			break;
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> +		if (unlikely(err)) {
> +			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +					    ndev->name, err);
> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		/* Do not hog the CPU if rx buffers are completed faster than
> +		 * queued (unlikely).

s/completed/consumed

> +		 */
> +		cond_resched();
> +	} while (atomic_inc_return(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz);
> +
> +	/* If we're still starved of rx buffers, reschedule later */
> +	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +}
> +
> +static int mhi_net_probe(struct mhi_device *mhi_dev,
> +			 const struct mhi_device_id *id)
> +{
> +	const char *netname = (char *)id->driver_data;
> +	struct mhi_net_dev *mhi_netdev;
> +	struct net_device *ndev;
> +	struct device *dev = &mhi_dev->dev;
> +	int err;

Since this is a networking driver, please stick to reverse xmas tree order for
local variables.
