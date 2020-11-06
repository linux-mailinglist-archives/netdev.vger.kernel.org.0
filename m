Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597B32A9286
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgKFJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:27:07 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:28207 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFJ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1604654825; x=1636190825;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nK5gvBSWQsXq04DVc5MktE2+AhU4XQkf0tgEdb+ePfA=;
  b=maFFQLaJVfaiyI2DTjhMazKdtaJjHPQiYJMBtbzlyvT1bSZb2bRcLSPf
   5KEWE0mM5uBK3DbVI3Fh5aWstBmxDRbHCO7k2eRNgG7S7m/XFWTYjygqM
   bAoU2H8vyNJpg49IzQAcLhAiFBa9H0Xh/zobRVwSaBC9frcYqEO4Grz9k
   AxOroAsn/ttbkgIEmyOu+zLrSbYyUS8HiKb9sxknVhm4IqaEBniVHCQB+
   GjtZZeLgxik7Gh/h0GLiehGwHcexWchj/s/uxsxwCRsZ878XjWSKg60CM
   RZTttrsUwtzwaNK+1n4aiu51ZiaxCAZKzwpaoyt4upNAbPoL2UdjMgD9K
   g==;
IronPort-SDR: EMMYq2lo8UEeeWqrQ9pzg0dF3KUXgPSKMC6DslfhsVfX0dTkW88H6vxyH7ZP0zcSiHql2Kwzvf
 3HTR5Ofr8n/t9cb9MXTS387GWvXqSHZ6T/3qoj+WwT2P6+MTt7/InovgWKr7Qq/0fda2/swseW
 tW5xXjhe2oG9Sddpu0XOq8E9EeEFSeE35N6mUxVpzgxihlw8E4SxcKYrmEk8TFsM2iWcwFbXl9
 5z1zvb+eAkbJcLq2SgzJXRc23JLvTkki3idTR6L3VV/t7S4m7JZBJ+3C+vXvBAEd71Ca/pC4nw
 CGg=
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="92723596"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2020 02:27:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 02:27:04 -0700
Received: from [10.171.246.114] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 6 Nov 2020 02:27:00 -0700
Subject: Re: [RESEND PATCH] net: macb: fix NULL dereference due to no
 pcs_config method
To:     Parshuram Thombare <pthombar@cadence.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <harini.katakam@xilinx.com>, <michal.simek@xilinx.com>
References: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <22c6b5ff-d19e-2af8-d601-341a2101d6ef@microchip.com>
Date:   Fri, 6 Nov 2020 10:26:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2020 at 18:58, Parshuram Thombare wrote:
> This patch fixes NULL pointer dereference due to NULL pcs_config
> in pcs_ops.
> 
> Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> Link: https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Parshuram, best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index b7bc160..130a5af 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
>          /* Not supported */
>   }
> 
> +static int macb_pcs_config(struct phylink_pcs *pcs,
> +                          unsigned int mode,
> +                          phy_interface_t interface,
> +                          const unsigned long *advertising,
> +                          bool permit_pause_to_mac)
> +{
> +       return 0;
> +}
> +
>   static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>          .pcs_get_state = macb_usx_pcs_get_state,
>          .pcs_config = macb_usx_pcs_config,
> @@ -642,6 +651,7 @@ static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>   static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
>          .pcs_get_state = macb_pcs_get_state,
>          .pcs_an_restart = macb_pcs_an_restart,
> +       .pcs_config = macb_pcs_config,
>   };
> 
>   static void macb_mac_config(struct phylink_config *config, unsigned int mode,
> @@ -776,10 +786,13 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
> 
>          if (interface == PHY_INTERFACE_MODE_10GBASER)
>                  bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
> -       else
> +       else if (interface == PHY_INTERFACE_MODE_SGMII)
>                  bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
> +       else
> +               bp->phylink_pcs.ops = NULL;
> 
> -       phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> +       if (bp->phylink_pcs.ops)
> +               phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
> 
>          return 0;
>   }
> --
> 2.7.4
> 


-- 
Nicolas Ferre
