Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743B041648C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbhIWRmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:42:44 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:53118 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbhIWRmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:42:44 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 5463020972EF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <40b51655-bd61-e1ab-5d9a-2448f39cd1a7@omp.ru>
Date:   Thu, 23 Sep 2021 20:41:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:07 PM, Biju Das wrote:

> Initialize GbEthernet dmac found on RZ/G2L SoC.

   DMAC (or AVB-DMAC).

> This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  4 ++
>  drivers/net/ethernet/renesas/ravb_main.c | 84 +++++++++++++++++++++++-
>  2 files changed, 85 insertions(+), 3 deletions(-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 2422e74d9b4f..54c4d31a6950 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -83,6 +83,11 @@ static int ravb_config(struct net_device *ndev)
>  	return error;
>  }
>  
> +static void ravb_rgeth_set_rate(struct net_device *ndev)

   What does 'rgeth' stand for? And why not the trailing part of the name, like the other cases? 

> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_set_rate(struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -217,6 +222,11 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  	return free_num;
>  }
>  
> +static void ravb_rx_ring_free_rgeth(struct net_device *ndev, int q)

   rgeth?

> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rx_ring_free(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -283,6 +293,11 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  	priv->tx_skb[q] = NULL;
>  }
>  
> +static void ravb_rx_ring_format_rgeth(struct net_device *ndev, int q)

   rgeth?

> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rx_ring_format(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -356,6 +371,12 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  	desc->dptr = cpu_to_le32((u32)priv->tx_desc_dma[q]);
>  }
>  
> +static void *ravb_rgeth_alloc_rx_desc(struct net_device *ndev, int q)

   Again, why rgeth is not in the symbol's tail?

> +{
> +	/* Place holder */
> +	return NULL;
> +}
> +
>  static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -426,6 +447,11 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  	return -ENOMEM;
>  }
>  
> +static void ravb_rgeth_emac_init(struct net_device *ndev)

   Same here...

> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rcar_emac_init(struct net_device *ndev)
>  {
>  	/* Receive frame limit set register */
> @@ -461,7 +487,32 @@ static void ravb_emac_init(struct net_device *ndev)
>  	info->emac_init(ndev);
>  }
>  
> -static void ravb_rcar_dmac_init(struct net_device *ndev)
> +static void ravb_dmac_init_rgeth(struct net_device *ndev)
> +{
> +	/* Set AVB RX */
> +	ravb_write(ndev, 0x60000000, RCR);
> +
> +	/* Set Max Frame Length (RTC) */
> +	ravb_write(ndev, 0x7ffc0000 | RGETH_RX_BUFF_MAX, RTC);
> +
> +	/* Set FIFO size */
> +	ravb_write(ndev, 0x00222200, TGC);
> +
> +	ravb_write(ndev, 0, TCCR);
> +
> +	/* Frame receive */
> +	ravb_write(ndev, RIC0_FRE0, RIC0);
> +	/* Disable FIFO full warning */
> +	ravb_write(ndev, 0x0, RIC1);
> +	/* Receive FIFO full error, descriptor empty */
> +	ravb_write(ndev, RIC2_QFE0 | RIC2_RFFE, RIC2);
> +
> +	ravb_write(ndev, 0x0, RIC3);
> +
> +	ravb_write(ndev, TIC_FTE0, TIC);
> +}

   Ah, so 'rgeth' stands for GbEthernet... why not 'gbeth' then?

[...]
> @@ -579,6 +630,14 @@ static void ravb_rx_csum(struct sk_buff *skb)
>  	skb_trim(skb, skb->len - sizeof(__sum16));
>  }
>  
> +/* Packet receive function for Gigabit Ethernet */
> +static bool ravb_rgeth_rx(struct net_device *ndev, int *quota, int q)
> +{
> +	/* Place holder */
> +	return true;
> +}
> +
> +/* Packet receive function for Ethernet AVB */
>  static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -1918,6 +1977,13 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  }
>  
> +static int ravb_set_features_rgeth(struct net_device *ndev,
> +				   netdev_features_t features)
> +{
> +	/* Place holder */
> +	return 0;
> +}
> +
>  static int ravb_set_features_rcar(struct net_device *ndev,
>  				  netdev_features_t features)
>  {
> @@ -2007,7 +2073,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
>  	.receive = ravb_rcar_rx,
>  	.set_rate = ravb_set_rate,
>  	.set_feature = ravb_set_features_rcar,
> -	.dmac_init = ravb_rcar_dmac_init,
> +	.dmac_init = ravb_dmac_init_rcar,
>  	.emac_init = ravb_rcar_emac_init,
>  	.gstrings_stats = ravb_gstrings_stats,
>  	.gstrings_size = sizeof(ravb_gstrings_stats),
> @@ -2028,7 +2094,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
>  	.receive = ravb_rcar_rx,
>  	.set_rate = ravb_set_rate,
>  	.set_feature = ravb_set_features_rcar,
> -	.dmac_init = ravb_rcar_dmac_init,
> +	.dmac_init = ravb_dmac_init_rcar,
>  	.emac_init = ravb_rcar_emac_init,
>  	.gstrings_stats = ravb_gstrings_stats,
>  	.gstrings_size = sizeof(ravb_gstrings_stats),
> @@ -2039,12 +2105,24 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
>  	.aligned_tx = 1,
>  };
>  
> +static const struct ravb_hw_info rgeth_hw_info = {
> +	.rx_ring_free = ravb_rx_ring_free_rgeth,
> +	.rx_ring_format = ravb_rx_ring_format_rgeth,
> +	.alloc_rx_desc = ravb_rgeth_alloc_rx_desc,
> +	.receive = ravb_rgeth_rx,
> +	.set_rate = ravb_rgeth_set_rate,
> +	.set_feature = ravb_set_features_rgeth,
> +	.dmac_init = ravb_dmac_init_rgeth,
> +	.emac_init = ravb_rgeth_emac_init,
> +};
> +>  static const struct of_device_id ravb_match_table[] = {
>  	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_hw_info },
>  	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_hw_info },
>  	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
>  	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
>  	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
> +	{ .compatible = "renesas,rzg2l-gbeth", .data = &rgeth_hw_info },

    Mhm, I thought this parch should come lst of the series, without any placeholders...

[...]

MBR, Sergey
