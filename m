Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0347D29C
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 14:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbhLVNFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 08:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbhLVNFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 08:05:00 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A1C061574;
        Wed, 22 Dec 2021 05:05:00 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d9so4898504wrb.0;
        Wed, 22 Dec 2021 05:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BPLpHI4x5W/zhC1d5lONCVDS5FWmiD7fkkKWzxlNBok=;
        b=FR9nipHfFmygSK7LvpaJW3XLs2pCFB+JHlQwqaDkr2rtngrLQSr5/R+z1nVhXtFHP/
         2SomlihLnbEpn33PbGvf3RCY4wnYiXrD6kEcXGnobDQT4Cod2A+ruZoKxgGTokGXTcKL
         e5jTQFbdFRnBRHqKFtcpa8zmPOFYGjE8a/gOb06wnSMbEKbteCZmjmNvFM1gr+twpIe8
         o5uqSTpBuAmsdat9pgm04X+EVuysRSLcxzVJnMB8gTvlkxqC/s8ThkiTPwifbEFy6G7Z
         Tt1A+siNzRuSzwxGV2uzTQZwafGKuGlp/lWJQAql/Zm8ua95LcHv/wAc7JzrN9ckyP7j
         rK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=BPLpHI4x5W/zhC1d5lONCVDS5FWmiD7fkkKWzxlNBok=;
        b=Mjd1mMtlyMeipV1LF2FQICPDjJ3+ELzNM0368Am1vyk+u2AgnkatpYC+UztZpwRWcl
         484FtraPcfn4+vklK5glfspe2L5v50FAvcukW4bvNHexDjJzT1rYqAZZHVqY1EvmenpE
         J4SvBe62sMQtk5WF5kd7GIFbr1tZHf0KDV/FBmqtZpPexZTrMcjp25czZ999p6Wua9PC
         2YLzJLNsUgOiWPPE0Jh7TXAOwra94W9bpI5AACJHXpGeIsGP/k/Bo6eSQvoXuTntaYc8
         +V3g9PekII1H3KeYUS9HqB0W666BEhTLpmiuFlWGUVdmXPqYho3HrgTtjGEkAezZQBpp
         v0ig==
X-Gm-Message-State: AOAM531SUzBsAEGN6ilr+44TNsWwJCJ7QjeEZrpcDmY3s8zUCtWgEbsM
        a4AYUe4RubvbTxlwACXPPI8=
X-Google-Smtp-Source: ABdhPJxnFFs4JhWrAl/oYfF3s/L3vExb1S9IoTiSLpR8jxNtTTwYdhPryXTHl90ldWSN74Tnf5mjQw==
X-Received: by 2002:adf:f70f:: with SMTP id r15mr2038881wrp.552.1640178298874;
        Wed, 22 Dec 2021 05:04:58 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e12sm1936510wrg.110.2021.12.22.05.04.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Dec 2021 05:04:58 -0800 (PST)
Date:   Wed, 22 Dec 2021 13:04:56 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: falcon: Check null pointer of rx_queue->page_ring
Message-ID: <20211222130456.3lbrgx3p47fzjnzi@gmail.com>
Mail-Followup-To: Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211220140344.978408-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220140344.978408-1-jiasheng@iscas.ac.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 10:03:44PM +0800, Jiasheng Jiang wrote:
> Because of the possible failure of the kcalloc, it should be better to
> set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> the consistency.
> 
> Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/falcon/rx.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
> index 966f13e7475d..11a6aee852e9 100644
> --- a/drivers/net/ethernet/sfc/falcon/rx.c
> +++ b/drivers/net/ethernet/sfc/falcon/rx.c
> @@ -728,7 +728,10 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask = page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask = 0;
> +	else
> +		rx_queue->page_ptr_mask = page_ring_size - 1;
>  }
>  
>  void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
> -- 
> 2.25.1
