Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374A51394AA
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgAMPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:20:17 -0500
Received: from mx4.wp.pl ([212.77.101.12]:21486 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgAMPUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 10:20:16 -0500
Received: (wp-smtpd smtp.wp.pl 25356 invoked from network); 13 Jan 2020 16:20:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578928814; bh=ckiIUgf+Tu5dz5bSkyhu+9/WG8U3ri+CC3Yzi1RogcU=;
          h=From:To:Cc:Subject;
          b=NeSFLFdiaaOtnduuiNXv0m3FxynzuH3vJW9Ys2S+vbRzGA0LVmL0946RrA6kxb4KH
           +VLCkHAyV57L9+KK16iXno0hhZnd//0dphpVH4rQMsgypOHg3029TTgu6CasCN+Hs3
           jcUW6qwhui9F5L0Bn2LzwrHrTHCsdDI4zJyAPdvI=
Received: from unknown (HELO cakuba) (kubakici@wp.pl@[172.58.35.234])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <Jose.Abreu@synopsys.com>; 13 Jan 2020 16:20:13 +0100
Date:   Mon, 13 Jan 2020 07:19:46 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/8] net: stmmac: Add missing information in
 DebugFS capabilities file
Message-ID: <20200113071946.1dbdecd1@cakuba>
In-Reply-To: <faaa377a5518be7357f897d02eb0e35b57912093.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
        <faaa377a5518be7357f897d02eb0e35b57912093.1578920366.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: e9542c228b230751ee00c2b6f941528f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gaNR]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 14:02:41 +0100, Jose Abreu wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index fcc1ffe0b11e..7c2645ee81b1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4341,6 +4341,10 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
>  		   priv->dma_cap.number_rx_queues);
>  	seq_printf(seq, "\tNumber of Additional TX queues: %d\n",
>  		   priv->dma_cap.number_tx_queues);
> +	seq_printf(seq, "\tCurrent number of TX queues: %d\n",
> +		   priv->plat->tx_queues_to_use);
> +	seq_printf(seq, "\tCurrent number of RX queues: %d\n",
> +		   priv->plat->rx_queues_to_use);

You should probably just implement ethtool get_channels. 
nack on this part.

>  	seq_printf(seq, "\tEnhanced descriptors: %s\n",
>  		   (priv->dma_cap.enh_desc) ? "Y" : "N");
>  	seq_printf(seq, "\tTX Fifo Size: %d\n", priv->dma_cap.tx_fifo_size);
