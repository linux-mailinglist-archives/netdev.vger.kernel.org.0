Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2002222B3C8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgGWQlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:41:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:43980 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgGWQlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:41:01 -0400
IronPort-SDR: Pn9WlDxdRRMCAVjt+PXKsDLIJ9/TIrLoZay6gh+N0WiDlEEKnRXPQYiZ8bjWLcZPp0sHc3aMSi
 aHfStT3Ea2PQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138067312"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="138067312"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 09:41:00 -0700
IronPort-SDR: Ok9HxutTmxnbcn/eRWfT9E3+laGzdaRgRn157TeulCM1uqrp+bzPqmzAxKRM+/7omuJrvv4tRI
 h13CjqbyMTfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="432798018"
Received: from tthayer-hp-z620.an.intel.com (HELO [10.122.105.146]) ([10.122.105.146])
  by orsmga004.jf.intel.com with ESMTP; 23 Jul 2020 09:40:59 -0700
Reply-To: thor.thayer@linux.intel.com
Subject: Re: [PATCH v4 07/10] net: eth: altera: change tx functions to type
 netdev_tx_t
To:     "Ooi, Joyce" <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
 <20200708072401.169150-8-joyce.ooi@intel.com>
From:   Thor Thayer <thor.thayer@linux.intel.com>
Message-ID: <d7a0caaf-bf28-4b85-c65d-b646e31fcff6@linux.intel.com>
Date:   Thu, 23 Jul 2020 11:41:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708072401.169150-8-joyce.ooi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 2:23 AM, Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@linux.intel.com>
> 
> Modify all msgdma and sgdma tx_buffer functions to be of type
> netdev_tx_t, and also modify main tx function to be of
> netdev_tx_t type.
> 
> Signed-off-by: Dalon Westergreen <dalon.westergreen@linux.intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: this patch is added in patch version 2
> v3: no change
> v4: no change
> ---
>   drivers/net/ethernet/altera/altera_msgdma.c | 5 +++--
>   drivers/net/ethernet/altera/altera_msgdma.h | 4 ++--
>   drivers/net/ethernet/altera/altera_sgdma.c  | 5 +++--
>   drivers/net/ethernet/altera/altera_sgdma.h  | 4 ++--
>   drivers/net/ethernet/altera/altera_tse.h    | 4 ++--
>   5 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/altera/altera_msgdma.c b/drivers/net/ethernet/altera/altera_msgdma.c
> index ac1efd08267a..ac68151a7f47 100644
> --- a/drivers/net/ethernet/altera/altera_msgdma.c
> +++ b/drivers/net/ethernet/altera/altera_msgdma.c
> @@ -106,7 +106,8 @@ void msgdma_clear_txirq(struct altera_tse_private *priv)
>   }
>   
>   /* return 0 to indicate transmit is pending */
> -int msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
> +netdev_tx_t
> +msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
>   {
>   	csrwr32(lower_32_bits(buffer->dma_addr), priv->tx_dma_desc,
>   		msgdma_descroffs(read_addr_lo));
> @@ -120,7 +121,7 @@ int msgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
>   		msgdma_descroffs(stride));
>   	csrwr32(MSGDMA_DESC_CTL_TX_SINGLE, priv->tx_dma_desc,
>   		msgdma_descroffs(control));
> -	return 0;
> +	return NETDEV_TX_OK;
>   }
>   
>   u32 msgdma_tx_completions(struct altera_tse_private *priv)
> diff --git a/drivers/net/ethernet/altera/altera_msgdma.h b/drivers/net/ethernet/altera/altera_msgdma.h
> index 23f5b2a13898..d816b24dfa7f 100644
> --- a/drivers/net/ethernet/altera/altera_msgdma.h
> +++ b/drivers/net/ethernet/altera/altera_msgdma.h
> @@ -16,8 +16,8 @@ void msgdma_clear_txirq(struct altera_tse_private *priv);
>   u32 msgdma_tx_completions(struct altera_tse_private *priv);
>   void msgdma_add_rx_desc(struct altera_tse_private *priv,
>   			struct tse_buffer *buffer);
> -int msgdma_tx_buffer(struct altera_tse_private *priv,
> -		     struct tse_buffer *buffer);
> +netdev_tx_t msgdma_tx_buffer(struct altera_tse_private *priv,
> +			     struct tse_buffer *buffer);
>   u32 msgdma_rx_status(struct altera_tse_private *priv);
>   int msgdma_initialize(struct altera_tse_private *priv);
>   void msgdma_uninitialize(struct altera_tse_private *priv);
> diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
> index fe6276c7e4a3..6898ec682425 100644
> --- a/drivers/net/ethernet/altera/altera_sgdma.c
> +++ b/drivers/net/ethernet/altera/altera_sgdma.c
> @@ -166,7 +166,8 @@ void sgdma_clear_txirq(struct altera_tse_private *priv)
>    *   will now actually look at the code, so from now, 0 is good and return
>    *   NETDEV_TX_BUSY when busy.
>    */
> -int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
> +netdev_tx_t
> +sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
>   {
>   	struct sgdma_descrip __iomem *descbase =
>   		(struct sgdma_descrip __iomem *)priv->tx_dma_desc;
> @@ -196,7 +197,7 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
>   	/* enqueue the request to the pending transmit queue */
>   	queue_tx(priv, buffer);
>   
> -	return 0;
> +	return NETDEV_TX_OK;
>   }
>   
>   
> diff --git a/drivers/net/ethernet/altera/altera_sgdma.h b/drivers/net/ethernet/altera/altera_sgdma.h
> index 3fb201417820..6a41833f0965 100644
> --- a/drivers/net/ethernet/altera/altera_sgdma.h
> +++ b/drivers/net/ethernet/altera/altera_sgdma.h
> @@ -13,8 +13,8 @@ void sgdma_disable_rxirq(struct altera_tse_private *priv);
>   void sgdma_disable_txirq(struct altera_tse_private *priv);
>   void sgdma_clear_rxirq(struct altera_tse_private *priv);
>   void sgdma_clear_txirq(struct altera_tse_private *priv);
> -int sgdma_tx_buffer(struct altera_tse_private *priv,
> -		    struct tse_buffer *buffer);
> +netdev_tx_t sgdma_tx_buffer(struct altera_tse_private *priv,
> +			    struct tse_buffer *buffer);
>   u32 sgdma_tx_completions(struct altera_tse_private *priv);
>   void sgdma_add_rx_desc(struct altera_tse_private *priv,
>   		       struct tse_buffer *buffer);
> diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
> index fa24ab3c7d6a..79d02748c89d 100644
> --- a/drivers/net/ethernet/altera/altera_tse.h
> +++ b/drivers/net/ethernet/altera/altera_tse.h
> @@ -392,8 +392,8 @@ struct altera_dmaops {
>   	void (*disable_rxirq)(struct altera_tse_private *priv);
>   	void (*clear_txirq)(struct altera_tse_private *priv);
>   	void (*clear_rxirq)(struct altera_tse_private *priv);
> -	int (*tx_buffer)(struct altera_tse_private *priv,
> -			 struct tse_buffer *buffer);
> +	netdev_tx_t (*tx_buffer)(struct altera_tse_private *priv,
> +				 struct tse_buffer *buffer);
>   	u32 (*tx_completions)(struct altera_tse_private *priv);
>   	void (*add_rx_desc)(struct altera_tse_private *priv,
>   			    struct tse_buffer *buffer);
> 
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
