Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B191611F401
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfLNUg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:36:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34819 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLNUg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:36:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so1320752pgk.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 12:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=u5S8AzA/two94BW1QHz+RPP0930vQSWwKoy/1jrejMo=;
        b=lfGP0h/6gjRV3qM4YEFh2+9XY/Vn700YCuonoJZrLzUvgymJ4AwkVEjYqcRp6LBlMl
         ptZSe9eEWDPT9Af6pcwB5Rd12R0ps6Rdsue/xR4W7IWtPvk87m9rzCSv7zx66OWmUnnP
         z+6PZGJ0sQnUihfo3rijoi1qU6NsYEuNgZjWfihTdu/VKqe0oOLBGKVjw5GSBliKtM7i
         B8kAQFe6vXRShN9qPbBkACTWzJEgjbfxxzPqtB2Ahdyhg/bj+mvtc3xoousWt49dfeu3
         p30tsbDnEzZFNYY1geeh9It/aYV+mifXhi2O+iNCguBlN7RD1Z9hBxkKccDNUmUpOquF
         YeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=u5S8AzA/two94BW1QHz+RPP0930vQSWwKoy/1jrejMo=;
        b=ebHAMQmpuSpCCcGBAegXsLZpxPFXFFrMC6VROz6jojmPFBpGkT3I67rBzeX+zk09hv
         fOnYFCN2HzTRjcwT38bl7y/8GzrLs6MTVdN/a2rXPmAQyr1IyuhZb7RPyXVh51ycn22U
         nRsTTjBxE8OKwbQxyiJH1e0UY3omdyNMPAFmh5zrMXtquJyTzu+V29erl6iUTbkIc6nc
         61XZQ7xyRILiUWTbkPI55WGSP31v4b1SLHrNCLeMGIONybwNQtH0UIaAnNE9Ch7kWD3h
         8+SoyEGEIqYfaxfoVvTx53bK/KsOaVd96ibF1xbvQlLBB5YacwV++a5gMX/aYsa4VKvF
         6mLg==
X-Gm-Message-State: APjAAAWj94b2m0fM3Qs++8E1uYkmWGOxlGnoBwRt+65BFL0c9beBkA+U
        Dx6sFZeYwy9nGFlUR8J+H1AGBw==
X-Google-Smtp-Source: APXvYqyy2Uw5pYrnt7cqN32mxFB1vF+Q9fs1ZY/FlZ7maVgLk5Wicty7+Ay07UDDowWoZgWaopJlaA==
X-Received: by 2002:a62:ee06:: with SMTP id e6mr7100945pfi.45.1576355786428;
        Sat, 14 Dec 2019 12:36:26 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j28sm15493997pgb.36.2019.12.14.12.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 12:36:26 -0800 (PST)
Date:   Sat, 14 Dec 2019 12:36:23 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: stmmac: Let TX and RX interrupts be
 independently enabled/disabled
Message-ID: <20191214123623.1aeb4966@cakuba.netronome.com>
In-Reply-To: <04c000a3e0356e8bfb63e07490d8de8e081a2afe.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
        <04c000a3e0356e8bfb63e07490d8de8e081a2afe.1576007149.git.Jose.Abreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 20:54:43 +0100, Jose Abreu wrote:
> @@ -2278,10 +2286,14 @@ static void stmmac_tx_timer(struct timer_list *t)
>  	 * If NAPI is already running we can miss some events. Let's rearm
>  	 * the timer and try again.
>  	 */
> -	if (likely(napi_schedule_prep(&ch->tx_napi)))
> +	if (likely(napi_schedule_prep(&ch->tx_napi))) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&ch->lock, flags);
> +		stmmac_disable_dma_irq(priv, priv->ioaddr, ch->index, 0, 1);
> +		spin_unlock_irqrestore(&ch->lock, flags);
>  		__napi_schedule(&ch->tx_napi);
> -	else
> -		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));

You should also remove the comment above the if statement if it's
really okay to no longer re-arm the timer. No?

> +	}
>  }
>  
>  /**

> @@ -3759,24 +3777,18 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
>  	struct stmmac_channel *ch =
>  		container_of(napi, struct stmmac_channel, tx_napi);
>  	struct stmmac_priv *priv = ch->priv_data;
> -	struct stmmac_tx_queue *tx_q;
>  	u32 chan = ch->index;
>  	int work_done;
>  
>  	priv->xstats.napi_poll++;
>  
> -	work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
> -	work_done = min(work_done, budget);
> -
> -	if (work_done < budget)
> -		napi_complete_done(napi, work_done);
> +	work_done = stmmac_tx_clean(priv, budget, chan);
> +	if (work_done < budget && napi_complete_done(napi, work_done)) {

Not really related to this patch, but this looks a little suspicious. 
I think the TX completions should all be processed regardless of the
budget. The budget is for RX.

> +		unsigned long flags;
>  
> -	/* Force transmission restart */
> -	tx_q = &priv->tx_queue[chan];
> -	if (tx_q->cur_tx != tx_q->dirty_tx) {
> -		stmmac_enable_dma_transmission(priv, priv->ioaddr);
> -		stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr,
> -				       chan);
> +		spin_lock_irqsave(&ch->lock, flags);
> +		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
> +		spin_unlock_irqrestore(&ch->lock, flags);
>  	}
>  
>  	return work_done;
