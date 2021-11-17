Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293D8454F83
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbhKQVoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:44:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:33460 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbhKQVnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:43:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637185256; x=1668721256;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=27nbSQ7gN1tPViPmDsvKhjsUvLmCDX41GQ6XMHIbi4o=;
  b=FY5TSpJFEwmzPWsZUgbtzqP8dc+DflCs4isOoyyZ4/wtuU5418IjkHxt
   FW4W0it+Io7Fr6tyOTiQQcRh2X2OzefVgxzo5YEFRm9b1YBOH82k4vvbd
   Bi9S2YhxYOYc40pPHLGDFB26cGLRWCJP4kqjdUP/LKyDMhRmW25o+PWH4
   3Ql3WyDHsa2zP/Gmglupvm/pKaSnhX1bLwnWlUtAr6YBNQM4HLTF2xlRO
   zYfOHcinQp5sf0MyT0YerrtEfu2YGjafDIEBHyji1IR+IeEUD9uavDkNa
   5KtxlV9+ghnRWJYaYbZYmzT3lCO6ucksOtn+Dv4632PKG/OZT0eES3tkb
   w==;
IronPort-SDR: CB+195Istl/ha0rjIkv51y1sHkrscSKmAn7T9Z4K7u1l8NX/Ag4OmpTchx8L+RCWnmtz9yahPw
 VziwOGjsAgNJPGF+zAdi0kakrIAHkhCHWrmeYj2tHEHU8KboZyyfkQdwsWt7CE6NqgHGefFOba
 S8LUaDAWAu1Ph9xAvWWouOby+A5Fkdw2lJEv6jx/dFzYfNawwD30JcVsO40Nf7uOYMyqiPRSIb
 tio8aLW1umykkiHnNBvj91tDum2Gb2yJdi6UHGzpdf50LPR6KIWeOi4lZj7aaWYCo/BDVgevdS
 FwVi9ZgSQs4GsGEA0pzKkgL9
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="76789820"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2021 14:40:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 17 Nov 2021 14:40:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 17 Nov 2021 14:40:44 -0700
Date:   Wed, 17 Nov 2021 22:42:31 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] net: lan966x: add the basic lan966x driver
Message-ID: <20211117214231.yiv2s6nxl6yx4klq@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-3-horatiu.vultur@microchip.com>
 <9ab98fba364f736b267dbd5e1d305d3e8426e877.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <9ab98fba364f736b267dbd5e1d305d3e8426e877.camel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/17/2021 10:52, Philipp Zabel wrote:
> 
> Hi Horatio,

Hi Phillip,

> 
> On Wed, 2021-11-17 at 10:18 +0100, Horatiu Vultur wrote:
> > +static int lan966x_reset_switch(struct lan966x *lan966x)
> > +{
> > +     struct reset_control *reset;
> > +     int val = 0;
> > +     int ret;
> > +
> > +     reset = devm_reset_control_get_shared(lan966x->dev, "switch");
> > +     if (IS_ERR(reset))
> > +             dev_warn(lan966x->dev, "Could not obtain switch reset: %ld\n",
> > +                      PTR_ERR(reset));
> > +     else
> > +             reset_control_reset(reset);
> 
> According to the device tree bindings, both resets are required.
> I'd expect this to return on error.
> Is there any chance of the device working with out the switch reset
> being triggered?

The only case that I see is if the bootloader triggers this switch
reset and then when bootloader starts the kernel and doesn't set back
the switch in reset. Is this a valid scenario or is a bug in the
bootloader?

> 
> > +
> > +     reset = devm_reset_control_get_shared(lan966x->dev, "phy");
> > +     if (IS_ERR(reset)) {
> > +             dev_warn(lan966x->dev, "Could not obtain phy reset: %ld\n",
> > +                      PTR_ERR(reset));
> > +     } else {
> > +             reset_control_reset(reset);
> > +     }
> 
> Same as above.
> Consider printing errors with %pe or dev_err_probe().
> 
> > +     lan_wr(SYS_RESET_CFG_CORE_ENA_SET(0), lan966x, SYS_RESET_CFG);
> > +     lan_wr(SYS_RAM_INIT_RAM_INIT_SET(1), lan966x, SYS_RAM_INIT);
> > +     ret = readx_poll_timeout(lan966x_ram_init, lan966x,
> > +                              val, (val & BIT(1)) == 0, READL_SLEEP_US,
> > +                              READL_TIMEOUT_US);
> > +     if (ret)
> > +             return ret;
> > +
> > +     lan_wr(SYS_RESET_CFG_CORE_ENA_SET(1), lan966x, SYS_RESET_CFG);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan966x_probe(struct platform_device *pdev)
> > +{
> > +     struct fwnode_handle *ports, *portnp;
> > +     struct lan966x *lan966x;
> > +     int err, i;
> > +
> > +     lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
> > +     if (!lan966x)
> > +             return -ENOMEM;
> > +
> > +     platform_set_drvdata(pdev, lan966x);
> > +     lan966x->dev = &pdev->dev;
> > +
> > +     ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
> > +     if (!ports) {
> > +             dev_err(&pdev->dev, "no ethernet-ports child not found\n");
> > +             err = -ENODEV;
> > +             goto out;
> 
> No need to goto as long as there's just a "return err;" after the out:
> label.

True, I will udate this.

> 
> > +     }
> > +
> > +     err = lan966x_create_targets(pdev, lan966x);
> > +     if (err)
> > +             goto out;
> > +
> > +     if (lan966x_reset_switch(lan966x)) {
> > +             err = -EINVAL;
> 
> This should propagate the error returned from lan966x_reset_switch()
> instead.

I will fix it in the next version.

> 
> > +             goto out;
> > +     }
> > +
> > +     i = 0;
> > +     fwnode_for_each_available_child_node(ports, portnp)
> > +             ++i;
> > +
> > +     lan966x->num_phys_ports = i;
> > +     lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
> > +                                   sizeof(struct lan966x_port *),
> > +                                   GFP_KERNEL);
> 
>         if (!lan966x->ports)
>                 return -ENOMEM;

Good catch.

> 
> regards
> Philipp

-- 
/Horatiu
