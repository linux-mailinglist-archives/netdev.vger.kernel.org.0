Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9434772E3
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbhLPNPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:15:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8417 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbhLPNPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639660507; x=1671196507;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=s33EBaXdszCdbhqMOmY9SCuEo5PNUN5kGbyjUWc0zqs=;
  b=xylBNkUMopR7NBNtiAbKiC6AfwtYk9NRM+kzkGJzuJUWO1R1HHcN/dXP
   7n+Hfl1LJuz2vEvBukfd5tIGO47gZo63yqaSf5n7cptXrV8vkShKtPJaJ
   xqXBUA5U8PzKI9YjvUw7VVWX+VeusAKHk3AnRC9q5Svqv6rKFX7pCdfiG
   8UGtXP4sinpIHIwjgZYEH/f08xEipFTPwkUP6l6pjr4edNPZYwoIy1GLx
   AOQmDbeWtgDHw/v2qSI0Cl7w4xs1RPEKH5coJd5yGnyhZ+PZPw+lEq74I
   WRMnUAKQz+NzDOx/UBHh10Yo1quO6wDual6Pp16zUUjGuvppLYaee4Ua1
   g==;
IronPort-SDR: iszirYNeSPiBx1h9bPO+otYTJgad0X+5W8ekkbh31OlVM+X++QXGNbloNGQSiLMbGYRrTuGKTI
 6FYj158Fce4MZpFIY1MHbUIgAZGNVef66BWHIQX5RdNSND2u3ZLFBgPF0bP3AOG19ZV0Pr1+MK
 UL5RWjsr2oxNafEF+zsLmBNK2o+G5GfiDD0jDHncWzKwgyUfKqeOvuJijRQFv7xi0/5EfrKSKF
 kpGgE1lVpxuhfsa02EadkJ3ODD5DcDuORyIxq45cOHYi8Tyv9WITHB/4QBfhM3tF7DlRCUlF7f
 j5f9z3IQp8aJRdJPLiULjRFR
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="79778095"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2021 06:15:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 06:15:06 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 16 Dec 2021 06:15:05 -0700
Subject: Re: [PATCH CFT net-next] net: macb: use .mac_select_pcs() interface
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <netdev@vger.kernel.org>
References: <E1mxq4w-00GWry-Lg@rmk-PC.armlinux.org.uk>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <e1e3e711-87bd-865c-5070-3349bb68f992@microchip.com>
Date:   Thu, 16 Dec 2021 14:15:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <E1mxq4w-00GWry-Lg@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2021 at 13:41, Russell King (Oracle) wrote:
> Convert the PCS selection to use mac_select_pcs, which allows the PCS
> to perform any validation it needs.
> 
> We must use separate phylink_pcs instances for the USX and SGMII PCS,
> rather than just changing the "ops" pointer before re-setting it to
> phylink as this interface queries the PCS, rather than requesting it
> to be changed.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Looks good to me:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Russell. Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb.h      |  3 ++-
>   drivers/net/ethernet/cadence/macb_main.c | 26 +++++++++++-------------
>   2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 5620b97b3482..9ddbee7de72b 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1271,7 +1271,8 @@ struct macb {
>          struct mii_bus          *mii_bus;
>          struct phylink          *phylink;
>          struct phylink_config   phylink_config;
> -       struct phylink_pcs      phylink_pcs;
> +       struct phylink_pcs      phylink_usx_pcs;
> +       struct phylink_pcs      phylink_sgmii_pcs;
> 
>          u32                     caps;
>          unsigned int            dma_burst_length;
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index d4da9adf6777..a363da928e8b 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -510,7 +510,7 @@ static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
>                                   phy_interface_t interface, int speed,
>                                   int duplex)
>   {
> -       struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
> +       struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
>          u32 config;
> 
>          config = gem_readl(bp, USX_CONTROL);
> @@ -524,7 +524,7 @@ static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
>   static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
>                                     struct phylink_link_state *state)
>   {
> -       struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
> +       struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
>          u32 val;
> 
>          state->speed = SPEED_10000;
> @@ -544,7 +544,7 @@ static int macb_usx_pcs_config(struct phylink_pcs *pcs,
>                                 const unsigned long *advertising,
>                                 bool permit_pause_to_mac)
>   {
> -       struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
> +       struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
> 
>          gem_writel(bp, USX_CONTROL, gem_readl(bp, USX_CONTROL) |
>                     GEM_BIT(SIGNAL_OK));
> @@ -727,28 +727,23 @@ static void macb_mac_link_up(struct phylink_config *config,
>          netif_tx_wake_all_queues(ndev);
>   }
> 
> -static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
> -                           phy_interface_t interface)
> +static struct phylink_pcs *macb_mac_select_pcs(struct phylink_config *config,
> +                                              phy_interface_t interface)
>   {
>          struct net_device *ndev = to_net_dev(config->dev);
>          struct macb *bp = netdev_priv(ndev);
> 
>          if (interface == PHY_INTERFACE_MODE_10GBASER)
> -               bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
> +               return &bp->phylink_usx_pcs;
>          else if (interface == PHY_INTERFACE_MODE_SGMII)
> -               bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
> +               return &bp->phylink_sgmii_pcs;
>          else
> -               bp->phylink_pcs.ops = NULL;
> -
> -       if (bp->phylink_pcs.ops)
> -               phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> -
> -       return 0;
> +               return NULL;
>   }
> 
>   static const struct phylink_mac_ops macb_phylink_ops = {
>          .validate = phylink_generic_validate,
> -       .mac_prepare = macb_mac_prepare,
> +       .mac_select_pcs = macb_mac_select_pcs,
>          .mac_config = macb_mac_config,
>          .mac_link_down = macb_mac_link_down,
>          .mac_link_up = macb_mac_link_up,
> @@ -806,6 +801,9 @@ static int macb_mii_probe(struct net_device *dev)
>   {
>          struct macb *bp = netdev_priv(dev);
> 
> +       bp->phylink_sgmii_pcs.ops = &macb_phylink_pcs_ops;
> +       bp->phylink_usx_pcs.ops = &macb_phylink_usx_pcs_ops;
> +
>          bp->phylink_config.dev = &dev->dev;
>          bp->phylink_config.type = PHYLINK_NETDEV;
> 
> --
> 2.30.2
> 


-- 
Nicolas Ferre
