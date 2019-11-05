Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B153F0456
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390569AbfKERsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:48:46 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:45938 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfKERsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:48:46 -0500
Received: by mail-pf1-f169.google.com with SMTP id z4so10058684pfn.12
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LN99Id4mHGMhibJxXuSV2yLOyMUQjcg7jiUhXQt6Rn4=;
        b=wMGqUjX9uXj+EhRdk9+xh6xYmnet0XicNoKWj9QoglT1Ikaaoec1jtPnbW8/oH1HpH
         QGeQeUY0tb678L2+CRBmkvJeNK0DiwvRXsdatJdea2pjINgVAXAUjx91BD122sApQBDR
         I/coLvt7hfBfv0g2Mv21K5h7WDA4VkxqmdKd8kQRDtW3zq9QCszyxbn8W0pzJ6RhspYZ
         6QqjedJssv/dAGchfrCQ//Hfxkc95JeVMq+6ZIRLXWcxGQ5IsD+IULA/PfRH0d1Urh68
         X0WgHWLO/WSUNuONMdUavi2lzDnnNBSAF21LPAXocuJFYk7q48MgaT9oSHSXcy6RCQSA
         jEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LN99Id4mHGMhibJxXuSV2yLOyMUQjcg7jiUhXQt6Rn4=;
        b=PWHlX+U5mlYMTC6vIXVVstoSc1tZ2eTYnvO+1QHY9sx30ZmlTcdG4k1eMx2qh5K6Rq
         i8r7zzIOUd8v6PVdC3SwO9qxpwzgFkJXf6w9j+mU3XBG2tOp0Bdrw8qWzsETaj0HaJxk
         FnPr/JE1jAh0zOg4A0oNPmLpYjs5DXWT7kH523ebRsGtEWfyHAT252E7DxQ0xDRz+ilY
         j3vaBHQBYd+BkXLx0yQ10Ej14urIxrrrZo3UaMYmGvSD5tGfZwqGb1MXzuzUH3HzJ4oa
         gul+pUkwrVjG2PDMr/MXzcLylSEIcqGsNEUIP2TJx7vi6EPhnEj2RIfkhR3lj5aOb2tu
         KmNA==
X-Gm-Message-State: APjAAAUWJdiamBcENLGnyE3tiZtlaQyQHfusl75NvYAINgzNgrpNMMeD
        fa1pOCUe+f6rjAZHAghklJkOmQ==
X-Google-Smtp-Source: APXvYqzSdEvn3HooZaEpYfY+EbY16iR1ck0R4Q1ATjBGSFSCcP++NHQK0hn3mCDgwMrLts1Je18RsA==
X-Received: by 2002:a17:90a:195e:: with SMTP id 30mr350964pjh.60.1572976125448;
        Tue, 05 Nov 2019 09:48:45 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id 81sm25441012pfx.142.2019.11.05.09.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 09:48:45 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:48:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCHv4 1/1] net: forcedeth: add xmit_more support
Message-ID: <20191105094841.623b498e@cakuba.netronome.com>
In-Reply-To: <1572928001-6915-1-git-send-email-yanjun.zhu@oracle.com>
References: <1572928001-6915-1-git-send-email-yanjun.zhu@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 23:26:41 -0500, Zhu Yanjun wrote:
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 05d2b47..0d21ddd 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -2259,7 +2265,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  			u64_stats_update_begin(&np->swstats_tx_syncp);
>  			nv_txrx_stats_inc(stat_tx_dropped);
>  			u64_stats_update_end(&np->swstats_tx_syncp);
> -			return NETDEV_TX_OK;
> +
> +			writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
> +			       get_hwbase(dev) + NvRegTxRxControl);
> +			ret = NETDEV_TX_OK;
> +
> +			goto dma_error;

You could goto the middle of the txkick if statement here, instead of
duplicating the writel()? Actually the txkick label could be in the
middle of the if statement to begin with, TXBUSY case above stops the
queue so it will always go into the if.

>  		}
>  		np->put_tx_ctx->dma_len = bcnt;
>  		np->put_tx_ctx->dma_single = 1;
> @@ -2305,7 +2316,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  				u64_stats_update_begin(&np->swstats_tx_syncp);
>  				nv_txrx_stats_inc(stat_tx_dropped);
>  				u64_stats_update_end(&np->swstats_tx_syncp);
> -				return NETDEV_TX_OK;
> +
> +				writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
> +				       get_hwbase(dev) + NvRegTxRxControl);
> +				ret = NETDEV_TX_OK;
> +
> +				goto dma_error;

And here.

>  			}
>  
>  			np->put_tx_ctx->dma_len = bcnt;
> @@ -2357,8 +2373,15 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	spin_unlock_irqrestore(&np->lock, flags);
>  
> -	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
> -	return NETDEV_TX_OK;
> +txkick:
> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +		u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
> +
> +		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
> +	}
> +
> +dma_error:
> +	return ret;
>  }

But otherwise looks correct to me now, thanks!
