Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E9B301E3F
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 19:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbhAXSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 13:47:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56968 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbhAXSrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 13:47:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l3kP0-002PSp-RR; Sun, 24 Jan 2021 19:46:22 +0100
Date:   Sun, 24 Jan 2021 19:46:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM memory map
Message-ID: <YA3Afgtq0thFDH6Z@lunn.ch>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-4-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index a07cf60..c969a2d 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -25,6 +25,7 @@
>  #include <linux/of_net.h>
>  #include <linux/of_address.h>
>  #include <linux/of_device.h>
> +#include <linux/genalloc.h>
>  #include <linux/phy.h>
>  #include <linux/phylink.h>
>  #include <linux/phy/phy.h>
> @@ -91,6 +92,18 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
>  	return cpu % priv->nthreads;
>  }
>  
> +static inline
> +void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data)
> +{
> +	writel(data, priv->cm3_base + offset);
> +}
> +
> +static inline
> +u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset)
> +{
> +	return readl(priv->cm3_base + offset);
> +}

No inline functions in .c file please. Let the compiler decide.

   Andrew
