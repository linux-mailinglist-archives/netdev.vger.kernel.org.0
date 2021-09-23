Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64B4159B5
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhIWID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 04:03:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49480 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbhIWIDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 04:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632384105; x=1663920105;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WYny+JtM14LGY8ybiycqCdBduZdzBrvRWNVNMawq9uo=;
  b=N13o7zjOJ0LGMSi+CWTue1/2WoGKzA08/Wg8LOCWMnNN+LNDsokdb8XR
   IF28skOd7JDb3TVpkz3PZg52lvYLqk98TTUU/D9/gVPRUkhSYdNQNaZHL
   ZkSDEybmw4UVQbIemydiIU5ssM2/KYByowqqUcmHa66iA4e+PK7cCnZ1A
   grahQ8+0WwXzVmJV2J1T/r2jItI1GIF9PVj+RaskRgf6Syc1mOpXK9Es5
   92HJzVHGbGfcudlR1BNx6EWU0udWkai8E2HdKUXyZu/OMdvmt83a59/fA
   C3bUmqLc+QCfmwX+PlaLeWxKbufUTK2wGBcILtN0HSvxFW+XJuKBSARvr
   g==;
IronPort-SDR: 8TQx98vnj7J6asqOL3DMtxQAVE6uI+QpIf/19c+/I5MxgRCG0Sd+QDGwV7jPbMaK+704azDPP8
 uboc08sNjV05bqX72tFSVNUTIy3LycPf6HQJ3xGroq447wJWMfBdM5Tnq0FY2+YRUWy4l9uoKR
 Yb9lJvTdeFdkWlyI3bAyDv8Yznji4nGq698fNOsV4j0+Bo8/wKojZUARNAXyJYgASyTjgpu77M
 Nibn/AuWuZpqkk9G12g40lrnbYiyJKM25bdKBlSAGe4VYP3O47Tw38kcTs1d2gm8NNqGFDP+jr
 rZ7ffdvJkdd5rjVyWBKBtKlr
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="137634402"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2021 01:01:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 23 Sep 2021 01:01:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 23 Sep 2021 01:01:07 -0700
Date:   Thu, 23 Sep 2021 10:02:36 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 10/12] net: lan966x: add port module support
Message-ID: <20210923080236.mqnb7shs2x6rzmh2@soft-dev3-1.localhost>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-11-horatiu.vultur@microchip.com>
 <YUiSkpRvvL0fvija@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YUiSkpRvvL0fvija@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2021 14:54, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe

Hi Russell,

> 
> On Mon, Sep 20, 2021 at 11:52:16AM +0200, Horatiu Vultur wrote:
> > +static void lan966x_cleanup_ports(struct lan966x *lan966x)
> > +{
> > +     struct lan966x_port *port;
> > +     int portno;
> > +
> > +     for (portno = 0; portno < lan966x->num_phys_ports; portno++) {
> > +             port = lan966x->ports[portno];
> > +             if (!port)
> > +                     continue;
> > +
> > +             if (port->phylink) {
> > +                     rtnl_lock();
> > +                     lan966x_port_stop(port->dev);
> > +                     rtnl_unlock();
> > +                     port->phylink = NULL;
> 
> This leaks the phylink structure. You need to call phylink_destroy().
> 
> >  static int lan966x_probe_port(struct lan966x *lan966x, u8 port,
> >                             phy_interface_t phy_mode)
> >  {
> >       struct lan966x_port *lan966x_port;
> > +     struct phylink *phylink;
> > +     struct net_device *dev;
> > +     int err;
> >
> >       if (port >= lan966x->num_phys_ports)
> >               return -EINVAL;
> >
> > -     lan966x_port = devm_kzalloc(lan966x->dev, sizeof(*lan966x_port),
> > -                                 GFP_KERNEL);
> > +     dev = devm_alloc_etherdev_mqs(lan966x->dev,
> > +                                   sizeof(struct lan966x_port), 8, 1);
> > +     if (!dev)
> > +             return -ENOMEM;
> >
> > +     SET_NETDEV_DEV(dev, lan966x->dev);
> > +     lan966x_port = netdev_priv(dev);
> > +     lan966x_port->dev = dev;
> >       lan966x_port->lan966x = lan966x;
> >       lan966x_port->chip_port = port;
> >       lan966x_port->pvid = PORT_PVID;
> >       lan966x->ports[port] = lan966x_port;
> >
> > +     dev->max_mtu = ETH_MAX_MTU;
> > +
> > +     dev->netdev_ops = &lan966x_port_netdev_ops;
> > +     dev->needed_headroom = IFH_LEN * sizeof(u32);
> > +
> > +     err = register_netdev(dev);
> > +     if (err) {
> > +             dev_err(lan966x->dev, "register_netdev failed\n");
> > +             goto err_register_netdev;
> > +     }
> 
> register_netdev() publishes the network device.
> 
> > +
> > +     lan966x_port->phylink_config.dev = &lan966x_port->dev->dev;
> > +     lan966x_port->phylink_config.type = PHYLINK_NETDEV;
> > +     lan966x_port->phylink_config.pcs_poll = true;
> > +
> > +     phylink = phylink_create(&lan966x_port->phylink_config,
> > +                              lan966x_port->fwnode,
> > +                              phy_mode,
> > +                              &lan966x_phylink_mac_ops);
> 
> phylink_create() should always be called _prior_ to the network device
> being published. In any case...
> 
> > +     if (IS_ERR(phylink))
> > +             return PTR_ERR(phylink);
> 
> If this fails, this function returns an error, but leaves the network
> device published - which is a bug in itself.

If this fails it should eventually call lan966x_cleaup_ports where the
net_device will be unregister. But first I will need to make
phylink_create() be called prior the network device.

> 
> > +static void lan966x_phylink_mac_link_down(struct phylink_config *config,
> > +                                       unsigned int mode,
> > +                                       phy_interface_t interface)
> > +{
> 
> Hmm? Shouldn't this do something?

I don't think I need to do anything here. The current setup is that
there is a PHY in front of the MAC.
So when the link partner goes down, the PHY will go down and the MAC
will still be up. Is this a problem?
When we force the port to be set down, then in the function
lan966x_port_stop we actually shutdown the port.

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
