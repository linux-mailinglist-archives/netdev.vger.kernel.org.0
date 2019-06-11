Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A443D0EF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405022AbfFKPfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:35:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43432 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404969AbfFKPfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x0ONBcm1rMiSU9BG1M5184+3qrW5ub0HPsmd59faX8g=; b=NdcQpHpLgtNnDBxuhIWYR8tSG
        8+d/kk9T87DpvX8aed+YtrqeYjPFxj40r8xMI4wkDTVDLRWdmccmQXdc7gaSy/1TTsFtTQaYk89TI
        J5p+rUOcpYRq0iK8sgQOuZLYeMGXxmmmZwrRxrroK1E5/6NX855FVQCgL3rHvofkCeVm1wbXt8I2a
        cGlu/sv2PJ+NDgDHHAO9DM5arV1gKHOR8DkszzUK2JjNk46AmIUTp0+rOxmCk+s/IkfAkwWdPXQSN
        NFWZ2s+rzXvuRadlVAtS84TXe1FBaYe6w9q7Jf97g6KRINhHVUaNx9W02AxzxVIg1T84ZjRkBn9CK
        aiahP+Mrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52956)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1haio9-0006QU-EU; Tue, 11 Jun 2019 16:35:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1haio6-0007xo-0x; Tue, 11 Jun 2019 16:35:30 +0100
Date:   Tue, 11 Jun 2019 16:35:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: stmmac: Start adding phylink support
Message-ID: <20190611153529.z6hlkhtrnd5ksx2n@shell.armlinux.org.uk>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <7daa1ac5cf56152b9d6c969c24603bc82e0b7d55.1560266175.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7daa1ac5cf56152b9d6c969c24603bc82e0b7d55.1560266175.git.joabreu@synopsys.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 05:18:46PM +0200, Jose Abreu wrote:
> Start adding the phylink callbacks.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  1 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  4 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 48 +++++++++++++++++++
>  3 files changed, 53 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index 0b5c8d74c683..cf0c9f4f347a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -4,6 +4,7 @@ config STMMAC_ETH
>  	depends on HAS_IOMEM && HAS_DMA
>  	select MII
>  	select PHYLIB
> +	select PHYLINK

Please replace PHYLIB with PHYLINK here, there's no need to select both.

>  	select CRC32
>  	imply PTP_1588_CLOCK
>  	select RESET_CONTROLLER
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index a16ada8b8507..b8386778f6c6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -25,6 +25,7 @@
>  #include <linux/clk.h>
>  #include <linux/stmmac.h>
>  #include <linux/phy.h>
> +#include <linux/phylink.h>

linux/phy.h is unnecessary when you include phylink.h

>  #include <linux/pci.h>
>  #include "common.h"
>  #include <linux/ptp_clock_kernel.h>
> @@ -155,6 +156,9 @@ struct stmmac_priv {
>  	struct mii_bus *mii;
>  	int mii_irq[PHY_MAX_ADDR];
>  
> +	struct phylink_config phylink_config;
> +	struct phylink *phylink;
> +
>  	struct stmmac_extra_stats xstats ____cacheline_aligned_in_smp;
>  	struct stmmac_safety_stats sstats;
>  	struct plat_stmmacenet_data *plat;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6a2f072c0ce3..e2e69cb08fef 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -45,6 +45,7 @@
>  #include <linux/seq_file.h>
>  #endif /* CONFIG_DEBUG_FS */
>  #include <linux/net_tstamp.h>
> +#include <linux/phylink.h>
>  #include <net/pkt_cls.h>
>  #include "stmmac_ptp.h"
>  #include "stmmac.h"
> @@ -848,6 +849,39 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
>  			priv->pause, tx_cnt);
>  }
>  
> +static void stmmac_validate(struct phylink_config *config,
> +			    unsigned long *supported,
> +			    struct phylink_link_state *state)
> +{
> +	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	int tx_cnt = priv->plat->tx_queues_to_use;
> +	int max_speed = priv->plat->max_speed;
> +
> +	/* Cut down 1G if asked to */
> +	if ((max_speed > 0) && (max_speed < 1000)) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +	}
> +
> +	/* Half-Duplex can only work with single queue */
> +	if (tx_cnt > 1) {
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 1000baseT_Half);
> +	}

The logic here looks a little weird - if max_speed is less than 1000, we
can end up with 1000baseT-HD enabled.  Surely this is not desirable.

> +
> +	bitmap_andnot(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_andnot(state->advertising, state->advertising, mask,
> +		      __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static int stmmac_mac_link_state(struct phylink_config *config,
> +				 struct phylink_link_state *state)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static void stmmac_mac_config(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> @@ -900,6 +934,11 @@ static void stmmac_mac_config(struct net_device *dev)
>  	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
>  }
>  
> +static void stmmac_mac_an_restart(struct phylink_config *config)
> +{
> +	/* Not Supported */
> +}
> +
>  static void stmmac_mac_link_down(struct net_device *dev, bool autoneg)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> @@ -914,6 +953,15 @@ static void stmmac_mac_link_up(struct net_device *dev, bool autoneg)
>  	stmmac_mac_set(priv, priv->ioaddr, true);
>  }
>  
> +static const struct phylink_mac_ops __maybe_unused stmmac_phylink_mac_ops = {
> +	.validate = stmmac_validate,
> +	.mac_link_state = stmmac_mac_link_state,
> +	.mac_config = NULL, /* TO BE FILLED */
> +	.mac_an_restart = stmmac_mac_an_restart,
> +	.mac_link_down = NULL, /* TO BE FILLED */
> +	.mac_link_up = NULL, /* TO BE FILLED */
> +};
> +

If this is not used, I don't really see the point of splitting this from
the rest of the patch.  Also, I don't see the point of all those NULL
initialisers either.

>  /**
>   * stmmac_adjust_link - adjusts the link parameters
>   * @dev: net device structure
> -- 
> 2.21.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
