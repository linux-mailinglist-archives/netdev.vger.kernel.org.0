Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EFF3B1AB2
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhFWNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:07:21 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3412 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhFWNHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 09:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1624453503; x=1655989503;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7B/HtMHdJOJXKEZrylCHaNSZqDWrKwGNR7ZU9nPVJg=;
  b=I6B+B4bs2Mc0WzMjfoKd5kZzxj8tQ6zNvzCsO8CkYAM/p/R/5d/He+sv
   0OMWt6C0ZUL0QZGLS8U60ZeoDC96EbOeUAedcCRL2r01inGnc3leohSDC
   4+zAU3HQYWAYW1V8fsWDrTdRO4PYN7szfraJJe7lT0crIu69hy6z56uic
   FvQn+I+TxvXetUVhfuXXL2Bh6OCUz5YrxOC+Jy16q80VDARwCLM5IT1yu
   ASpPuclOPaENntAO4JT7ashIp24iU3bWaviOW0Dv6H8KEbTyKKevEGugb
   FgYOmQye5SBd41xk1VU5YyalsJdpWRGjS6rw9TAXDLsP/CJNeNcbRJLaz
   Q==;
IronPort-SDR: wnj/F1BCLui7CCja60zDgDzVh1q/ia46tYx2a97QvSKaGlRtnKdXxH+tcT/Udcee4V92Ei0TNQ
 dyKbzP2wkFRkuoA4tM3s/wLJIWGjmTanhI73CfITcXGWSU7clmOhc3MinZtwM6+Iay/e6PXsmn
 LaPM6F13O0/Dk9/4ER4xPTLS+nmPYSJ74gPJ9APqt0KWqvkRu/Di6cZdx6jbmNZv1RTbP/WkkQ
 2KBlKa4bEC+vlvrdaOoGcPhgejPGl3H5PG6TpHUSeXND7bLcQOJrgIhhPbvm7V9YwWK4LR8RO9
 ky8=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="133164106"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jun 2021 06:05:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 06:05:00 -0700
Received: from [10.205.21.35] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 23 Jun 2021 06:04:54 -0700
Message-ID: <a005f0a04f55677622403a0a3b2ac99447bc11b8.camel@microchip.com>
Subject: Re: [PATCH net-next v4 03/10] net: sparx5: add hostmode with
 phylink support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 23 Jun 2021 15:04:53 +0200
In-Reply-To: <20210621142628.GM22278@shell.armlinux.org.uk>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
         <20210615085034.1262457-4-steen.hegelund@microchip.com>
         <20210621142628.GM22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments.

On Mon, 2021-06-21 at 15:26 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Jun 15, 2021 at 10:50:27AM +0200, Steen Hegelund wrote:
> > This patch adds netdevs and phylink support for the ports in the switch.
> > It also adds register based injection and extraction for these ports.
> > 
> > Frame DMA support for injection and extraction will be added in a later
> > series.
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> 
> Hi,
> 
> While looking at this patch, I found sparx5_destroy_netdev() which seems
> to be unreferenced - it may be referenced in a future patch. However,
> this means that while sparx5_create_port() creates the phylink
> structure, there is nothing in this patch that cleans it up.

Yes the sparx5_destroy_netdev() is currently being added in a later patch. 
I will move it here instead. 

> 
> I'm puzzled by the call to phylink_disconnect_phy() in
> sparx5_destroy_netdev() too - surely if we get to the point of tearing
> down stuff that we've created at initialisation, the interface had
> better be down?

Yes the unregister_netdev is missing. I will add that before the phylink is destroyed.

> 
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> > b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> > new file mode 100644
> > index 000000000000..c17a3502645a
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> > @@ -0,0 +1,185 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/* Microchip Sparx5 Switch driver
> > + *
> > + * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/phylink.h>
> > +#include <linux/device.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/sfp.h>
> > +
> > +#include "sparx5_main_regs.h"
> > +#include "sparx5_main.h"
> > +
> > +static void sparx5_phylink_validate(struct phylink_config *config,
> > +                                 unsigned long *supported,
> > +                                 struct phylink_link_state *state)
> > +{
> > +     struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > +     __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +     phylink_set(mask, Autoneg);
> > +     phylink_set_port_modes(mask);
> > +     phylink_set(mask, Pause);
> > +     phylink_set(mask, Asym_Pause);
> > +
> > +     switch (state->interface) {
> > +     case PHY_INTERFACE_MODE_5GBASER:
> > +     case PHY_INTERFACE_MODE_10GBASER:
> > +     case PHY_INTERFACE_MODE_25GBASER:
> > +     case PHY_INTERFACE_MODE_NA:
> > +             if (port->conf.bandwidth == SPEED_5000)
> > +                     phylink_set(mask, 5000baseT_Full);
> > +             if (port->conf.bandwidth == SPEED_10000) {
> > +                     phylink_set(mask, 5000baseT_Full);
> > +                     phylink_set(mask, 10000baseT_Full);
> > +                     phylink_set(mask, 10000baseCR_Full);
> > +                     phylink_set(mask, 10000baseSR_Full);
> > +                     phylink_set(mask, 10000baseLR_Full);
> > +                     phylink_set(mask, 10000baseLRM_Full);
> > +                     phylink_set(mask, 10000baseER_Full);
> > +             }
> > +             if (port->conf.bandwidth == SPEED_25000) {
> > +                     phylink_set(mask, 5000baseT_Full);
> > +                     phylink_set(mask, 10000baseT_Full);
> > +                     phylink_set(mask, 10000baseCR_Full);
> > +                     phylink_set(mask, 10000baseSR_Full);
> > +                     phylink_set(mask, 10000baseLR_Full);
> > +                     phylink_set(mask, 10000baseLRM_Full);
> > +                     phylink_set(mask, 10000baseER_Full);
> > +                     phylink_set(mask, 25000baseCR_Full);
> > +                     phylink_set(mask, 25000baseSR_Full);
> > +             }
> 
> I really need to fix phylink so we shouldn't be lying about which
> speeds are supported over a 10GBASER link... but that's something
> for the future.
> 
> > +static bool port_conf_has_changed(struct sparx5_port_config *a, struct sparx5_port_config *b)
> > +{
> > +     if (a->speed != b->speed ||
> > +         a->portmode != b->portmode ||
> > +         a->autoneg != b->autoneg ||
> > +         a->pause != b->pause ||
> > +         a->power_down != b->power_down ||
> > +         a->media != b->media)
> > +             return true;
> > +     return false;
> > +}
> 
> Should this be positioned somewhere else rather than in the middle of
> the sparx5 phylink functions (top of file maybe?)

I will move it to the top.

> 
> > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > +                                   unsigned int mode,
> > +                                   const struct phylink_link_state *state)
> > +{
> > +     struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > +
> > +     port->conf.autoneg = state->an_enabled;
> > +     port->conf.pause = state->pause;
> 
> What are you doing with state->pause? It looks to me like you're using
> both of these to carry configuration to pcs_config?

Hmm.  I have now removed that, and will the pcs_config() to collect the advertised pause mode.

> 
> Generally, an_enabled can be pulled out of the advertising mask, it
> should always reflect ETHTOOL_LINK_MODE_Autoneg_BIT. The "pause"
> interpretation of the pause bits here are somewhat hardware specific.
> It depends whether the MAC automatically receives state information
> from the PCS or not. If the hardware does, then MLO_PAUSE_AN indicates
> whether that should be permitted or not.
> 
> Otherwise, the advertising mask in pcs_config() indicates which pause
> modes should be advertised, and the tx_pause/rx_pause in the
> *_link_up() indicates what should actually be set.

OK. I will use the pcs_config() to collect the advertising mode and the .._link_up() to collect the
configuration value.

> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com



