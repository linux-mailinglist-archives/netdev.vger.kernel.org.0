Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F009F5BF673
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIUGf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiIUGfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:35:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A3880526;
        Tue, 20 Sep 2022 23:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663742155; x=1695278155;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Nkxt24wv5HxrgUvepgEnI0awH/CBrinsjOv6eoBXr4Y=;
  b=Xl7E4hbMLh6RWzUqKcKz5IWSUsV7MSgWAyIyDD8l07LoHoQbJDwgvEm1
   MQCvOvN7Zl3L/7tBknVOzv55DkrDHv1qRM/vRKoA6KUfG0v+EjwJI+Rjx
   roxRyi1A0kDI2aywTbVaqnyGr1eYTymXm3YQSPNYdsqI5BIkT8/MckjQc
   p+EPSx2ydkVFSTHAK3/AQ/gPqEJP6urbS7Iwj0Cqle66ZNkcACDouph+f
   7Dsz35eJIAvrYwuNfN38aRIWINbvqK8oJCr4cYsyTDeKClirK61oBfKt7
   9Ng9KmcLpPc4prLUUXqxEQrivbanS4TAUyS2h9YMXwbMi5YowOYR256QH
   w==;
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="181271568"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 23:35:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 23:35:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 20 Sep 2022 23:35:53 -0700
Date:   Wed, 21 Sep 2022 08:40:19 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
Message-ID: <20220921064019.at4pbog6d2gzjyjq@soft-dev3-1.localhost>
References: <20220920141619.808117-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220920141619.808117-1-michael@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2022 16:16, Michael Walle wrote:
> 
> Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
> phy") the handler always returns IRQ_HANDLED, except in an error case.
> Before that commit, the interrupt status register was checked and if
> it was empty, IRQ_NONE was returned. Restore that behavior to play nice
> with the interrupt line being shared with others.
> 
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
>  drivers/net/phy/micrel.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 98e9bc101d96..21b6facf6e76 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2732,16 +2732,19 @@ static int lan8804_config_intr(struct phy_device *phydev)
>  static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
>  {
>         int irq_status, tsu_irq_status;
> +       int ret = IRQ_NONE;
> 
>         irq_status = phy_read(phydev, LAN8814_INTS);
> -       if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
> -               phy_trigger_machine(phydev);
> -
>         if (irq_status < 0) {
>                 phy_error(phydev);
>                 return IRQ_NONE;
>         }
> 
> +       if (irq_status & LAN8814_INT_LINK) {
> +               phy_trigger_machine(phydev);
> +               ret = IRQ_HANDLED;
> +       }
> +
>         while (1) {
>                 tsu_irq_status = lanphy_read_page_reg(phydev, 4,
>                                                       LAN8814_INTR_STS_REG);
> @@ -2750,12 +2753,15 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
>                     (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
>                                        LAN8814_INTR_STS_REG_1588_TSU1_ |
>                                        LAN8814_INTR_STS_REG_1588_TSU2_ |
> -                                      LAN8814_INTR_STS_REG_1588_TSU3_)))
> +                                      LAN8814_INTR_STS_REG_1588_TSU3_))) {
>                         lan8814_handle_ptp_interrupt(phydev);
> -               else
> +                       ret = IRQ_HANDLED;
> +               } else {
>                         break;
> +               }
>         }
> -       return IRQ_HANDLED;
> +
> +       return ret;
>  }
> 
>  static int lan8814_ack_interrupt(struct phy_device *phydev)
> --
> 2.30.2
> 

-- 
/Horatiu
