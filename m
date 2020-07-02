Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0842124B3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgGBNaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:30:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgGBNaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:30:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqzHo-003KKR-Fg; Thu, 02 Jul 2020 15:29:56 +0200
Date:   Thu, 2 Jul 2020 15:29:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
Subject: Re: [net-next,PATCH 2/4] net: mdio-ipq4019: add clock support
Message-ID: <20200702132956.GI730739@lunn.ch>
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-3-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702103001.233961-3-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:29:59PM +0200, Robert Marko wrote:
> Some newer SoC-s have a separate MDIO clock that needs to be enabled.
> So lets add support for handling the clocks to the driver.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  drivers/net/phy/mdio-ipq4019.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
> index 0e78830c070b..7660bf006da0 100644
> --- a/drivers/net/phy/mdio-ipq4019.c
> +++ b/drivers/net/phy/mdio-ipq4019.c
> @@ -9,6 +9,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/of_address.h>
>  #include <linux/of_mdio.h>
> +#include <linux/clk.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  
> @@ -24,8 +25,12 @@
>  #define IPQ4019_MDIO_TIMEOUT	10000
>  #define IPQ4019_MDIO_SLEEP		10
>  
> +#define QCA_MDIO_CLK_DEFAULT_RATE	100000000
> +
>  struct ipq4019_mdio_data {
> -	void __iomem	*membase;
> +	void __iomem		*membase;
> +	struct clk			*mdio_clk;
> +	u32					clk_freq;

Hi Robert

Some sort of tab/space issue here.

>  };
>  
>  static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
> @@ -100,6 +105,7 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>  {
>  	struct ipq4019_mdio_data *priv;
>  	struct mii_bus *bus;
> +	struct device_node *np = pdev->dev.of_node;
>  	int ret;

Reverse Christmas tree.

	Andrew
