Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4197760693
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 15:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfGEN3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 09:29:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33949 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbfGEN3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 09:29:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id u18so9992798wru.1
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 06:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ES3Fxqq/qVk0kvCdNYd6vQVB8dMaCL8eLDDrQ6qbPig=;
        b=jKImGNCLlO5An5dLyx2aVNvpjjInFeFKhGs2nmLuOp1EvadE1LSjGLgdbhRmtWQSfx
         n3MOTFnCoJzCmRtYd/3UAJewbi640IocbvSpPJt28zuRLrYKdpCPXQhFGTjVn9VW4C6Q
         ry3YKmLr46tCXpgWSMGkVOgJLCVZQWqszsNAslKm8KwOm6wxaXxui4og6rrSPEMBTUsv
         MD8jq4UhEWSs7/giqq378k9I8OY3qdXHsisW2/V/PxXRF8+FbcG3x/a9jeCDlSCcJ50l
         ogsrd3sOIYdRSvXPEg1u7n8rpdH45iY/fs3YdrbCuD8FAfLYp9Ey2AqdRR5tpntE1e0D
         ONJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ES3Fxqq/qVk0kvCdNYd6vQVB8dMaCL8eLDDrQ6qbPig=;
        b=XchTGoA9FLMzADJBygJ172/KWxlABUtIM7HFbWlBHeI+GieviKuXyx8P4FREcEkuf7
         B1KsSLTdwuLGFw8Bkxz82dwvSTFmuiZTCaXoMXObXmW9X/kmHMu3KAda9BFaOG01ResA
         wtRl1oXKAOKSQWLe3mxlFFbwoc6gFPGPkQxAcV9NLcxqZryvBDrWnJ0u6yCrzS1QXBSW
         F4fifC1xOAQInuXOcpbDjeiqe83AFT6TgA+ksNIbkWGfbQ5SwMqJk4BUYBTPt10PHIzz
         2oqbHTvAyXlQ0/nBo0xnjOEivbx5Si1hH0cXeRH0LrNvEOvIj0HQAZkDx2TpSyx/MKN8
         22Yw==
X-Gm-Message-State: APjAAAUYrGY+PSkj0jq3adL0B+TVQe7a0VC478Ctl+5qCGb+Iz+Aos+B
        FGzdtRwslxDVDdCjHIJE//9CBw==
X-Google-Smtp-Source: APXvYqzjMQhemoYavZtb41OiKS8heBAFjJkN3Jzjp+CP4WqiX2GqTTD7wj40s7CG20LugioQJosqgg==
X-Received: by 2002:adf:de08:: with SMTP id b8mr3606488wrm.282.1562333349431;
        Fri, 05 Jul 2019 06:29:09 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id h8sm8749710wmf.12.2019.07.05.06.29.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:29:08 -0700 (PDT)
Date:   Fri, 5 Jul 2019 16:29:05 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v3 3/3] net: stmmac: Introducing support for
 Page Pool
Message-ID: <20190705132905.GA15433@apalos>
References: <cover.1562311299.git.joabreu@synopsys.com>
 <384dab52828c4b65596ef4202562a574eed93b91.1562311299.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <384dab52828c4b65596ef4202562a574eed93b91.1562311299.git.joabreu@synopsys.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

I think this look ok for now. One request though, on page_pool_free 

On Fri, Jul 05, 2019 at 09:23:00AM +0200, Jose Abreu wrote:
> Mapping and unmapping DMA region is an high bottleneck in stmmac driver,
> specially in the RX path.
> 
> This commit introduces support for Page Pool API and uses it in all RX
> queues. With this change, we get more stable troughput and some increase
> of banwidth with iperf:
> 	- MAC1000 - 950 Mbps
> 	- XGMAC: 9.22 Gbps
> 
> Changes from v2:
> 	- Uncoditionally call page_pool_free() (Jesper)
> Changes from v1:
> 	- Use page_pool_get_dma_addr() (Jesper)
> 	- Add a comment (Jesper)
> 	- Add page_pool_free() call (Jesper)
> 	- Reintroduce sync_single_for_device (Arnd / Ilias)
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig       |   1 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  10 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 203 +++++++---------------
>  3 files changed, 70 insertions(+), 144 deletions(-)
> 

[...]
> @@ -1498,8 +1480,11 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
>  					  sizeof(struct dma_extended_desc),
>  					  rx_q->dma_erx, rx_q->dma_rx_phy);
>  
> -		kfree(rx_q->rx_skbuff_dma);
> -		kfree(rx_q->rx_skbuff);
> +		kfree(rx_q->buf_pool);
> +		if (rx_q->page_pool) {
> +			page_pool_request_shutdown(rx_q->page_pool);
> +			page_pool_free(rx_q->page_pool);

A patch currently under review will slightly change that [1] and [2]
Can you defer this a bit till that one gets merged?
The only thing you'll have to do is respin this and replace page_pool_free()
with page_pool_destroy()

[1] https://lore.kernel.org/netdev/20190705094346.13b06da6@carbon/
[2] https://lore.kernel.org/netdev/156225871578.1603.6630229522953924907.stgit@firesoul/
