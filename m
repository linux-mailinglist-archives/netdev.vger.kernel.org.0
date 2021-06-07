Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4861B39DCD8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFGMq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:46:58 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:12121 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhFGMq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623069907; x=1654605907;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ldICpVmPM5K8n+s7DsP2mONAmSrUKBI+7+MXhYW78c4=;
  b=EnV0+W0TnICFmbbAC4uwQusqsTaOcjPIiTJV0cYWp6ov3bCLwvRrs1DL
   LyjxhssJKd74d6h5HOG47nQHLw92gp6S/570v5AxIwbBjk/Motix1SFCx
   kqkcuD4XHIvaGWV+v2An+kfRmtW03rbxq0Au3a1cFmNstwMwEe1WxxkvT
   ULbXyJqh6DDIQDx+0H/fiMnNj2W/a5kva1v7g1scFA8Vvh2u4oOAofMxk
   1ztjwUr1XVGVgq2Vaf0R5t13Av2kUfVib5oMyAC4SxRCjZu4ZsHrXuT9T
   h/ofsS9NtreNKSHjZcrcWIfp/lxr7NPg9K1nHcQlT0mmHi4phw1+r/WVM
   g==;
IronPort-SDR: oZj/ute6IR9BD00CRNIddzFl/huqlMOXHab8fwEw3FFzmx7AcCqtQFqdqMeGCXzNIvCiUekbQO
 q4KyHX1EnzYSKteT08iDKqB5qfYpnjso6wJV5yJ+iGxv3BV+gvuRmjkkNwr/U2vnvbIKLzV4Sv
 RxWKzJCmxzW9FGkqMuO+0CFVmVnVfq/U1O/562rnVBZBU94p/LfFgbrotlEQU38yFuR2ikQUIP
 j7i0QcjEVifSAfFZukgEzDpF+xuSl9eUzyS5ylUxfL+2QXtpBFbzZnqNQThr4J0uFPykkxV3GZ
 Pww=
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="123779583"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 05:45:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 05:45:05 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 7 Jun 2021 05:45:02 -0700
Message-ID: <9f4fad323e17c8ba6ebde728fcc99c87dd06fc75.camel@microchip.com>
Subject: Re: [PATCH net-next v3 03/10] net: sparx5: add hostmode with
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
Date:   Mon, 7 Jun 2021 14:45:01 +0200
In-Reply-To: <20210607091536.GA30436@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-4-steen.hegelund@microchip.com>
         <20210607091536.GA30436@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments.

On Mon, 2021-06-07 at 10:15 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, Jun 04, 2021 at 10:55:53AM +0200, Steen Hegelund wrote:
> > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > +                                   unsigned int mode,
> > +                                   const struct phylink_link_state *state)
> > +{
> > +     struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > +     struct sparx5_port_config conf;
> > +
> > +     conf = port->conf;
> > +     conf.power_down = false;
> > +     conf.portmode = state->interface;
> > +     conf.speed = state->speed;
> > +     conf.autoneg = state->an_enabled;
> > +     conf.pause = state->pause;
> > +
> > +     if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
> > +             if (state->speed == SPEED_UNKNOWN) {
> > +                     /* When a SFP is plugged in we use capabilities to
> > +                      * default to the highest supported speed
> > +                      */
> > +                     if (phylink_test(state->advertising, 25000baseSR_Full) ||
> > +                         phylink_test(state->advertising, 25000baseCR_Full))
> > +                             conf.speed = SPEED_25000;
> > +                     else if (state->interface == PHY_INTERFACE_MODE_10GBASER)
> > +                             conf.speed = SPEED_10000;
> > +             } else if (state->speed == SPEED_2500) {
> > +                     conf.portmode = PHY_INTERFACE_MODE_2500BASEX;
> > +             } else if (state->speed == SPEED_1000) {
> > +                     conf.portmode = PHY_INTERFACE_MODE_1000BASEX;
> > +             }
> 
> 1) As detailed in the documentation for phylink, state->speed is not
>    guaranteed to be valid in the mac_config method.

OK.  I will assume speed is not known in this callback.


> 2) We clearly need PHY_INTERFACE_MODE_25GBASER rather than working
>    around this by testing bits in the advertising bitmap.


Yes that would be a very useful addition.
Should I add PHY_INTERFACE_MODE_25GBASER in this series or should that be added as a separate
series?

> 
> 3) I really don't get what's going on with setting the port mode to
>    2500base-X and 1000base-X here when state->interface is 10GBASER.

The high speed interfaces (> 2.5G) do not support any in-band signalling, so the only way that e.g a
10G interface running at 2.5G will be able to link up with its partner is if both ends configure the
speed manually via ethtool.
	
> 
> > +             if (phylink_test(state->advertising, FIBRE))
> > +                     conf.media = PHY_MEDIA_SR;
> > +             else
> > +                     conf.media = PHY_MEDIA_DAC;
> > +     }
> > +
> > +     if (!port_conf_has_changed(&port->conf, &conf))
> > +             return;
> > +}
> > +
> > +static void sparx5_phylink_mac_link_up(struct phylink_config *config,
> > +                                    struct phy_device *phy,
> > +                                    unsigned int mode,
> > +                                    phy_interface_t interface,
> > +                                    int speed, int duplex,
> > +                                    bool tx_pause, bool rx_pause)
> > +{
> 
> This is the only place that the MAC is guaranteed to know the
> negotiated speed.

OK.

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


