Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E02245B647
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhKXIOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:14:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2930 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbhKXIOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637741490; x=1669277490;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6wtJLhHz1/x08JxdTceuRqkfX+noCAGaJ4KU0to86OI=;
  b=XSVhM00z/6S92Pxd6+EqEhtgvHmGOn8PhBLN5DS5uXqgNnp/lJXiFDBT
   zlkZuuyPavHPfQeXwcBHnq0QHYGORCMmpCHXsDcFcC3jNYLipGh6jNepY
   4QcAGNMvjnUPjBh5stn9rgZehyJiepgyBV8V37djv6imZVYV1rm4h7jQm
   4GvSjzM8X7lblLsq5VsBZ+yQYpTG7Cyc7p5D4KgnRb1vP4ZpFDZDtErvD
   0xxg5zurUTQ96hduXsGHxYBQOpwESJt6JwnF32FmCLWYb7OofBcJSWXvk
   7vRkkMmlrPxaMEMmoA1gzxs4k3ehQXpUG6ClqGhBhDx7uz+BQ/DcwCsZe
   w==;
IronPort-SDR: /HMDUhn/N4fQQvzwOzOG8BE+T3sOSOE48H6iiNTkIMM5mnnYdXOX+uzLXIpkJIblJVwi72Mxy3
 VJSLUsrwGmY5Ra5Pe67+Qwg7JL3hcYucskXANwrHklJFlvUPINzsERhWW4mkMuNSoy998rjNQK
 mKvhz9hItb8mvsL/z6eixzl4A+HU7W8rC8MR2dqWeAy5Qigfm3CoiGVaJPGOowlUVggAMmP8rD
 GxsDGODJZ93tfGn5lEzuypQnwJJSJ7BB2FuVVrOMp890dIUebhJbdifMrugRpsXhADvo7lr4xG
 xHQP8VB0If4xzckW4qU1bHIE
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="140154769"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:11:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:11:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 24 Nov 2021 01:11:29 -0700
Date:   Wed, 24 Nov 2021 09:13:21 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Denis Kirjanov <dkirjanov@suse.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: lan966x: add the basic lan966x
 driver
Message-ID: <20211124081321.qbxhbbathz7nduuu@soft-dev3-1.localhost>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-3-horatiu.vultur@microchip.com>
 <16727fc4-4cc7-41de-910d-80b3bca70ef1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <16727fc4-4cc7-41de-910d-80b3bca70ef1@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/23/2021 18:31, Denis Kirjanov wrote:
> 
Hi Denis,

> > +static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> > +                           phy_interface_t phy_mode)
> > +{
> > +     struct lan966x_port *port;
> > +
> > +     if (p >= lan966x->num_phys_ports)
> > +             return -EINVAL;
> > +
> > +     port = devm_kzalloc(lan966x->dev, sizeof(*port), GFP_KERNEL);
> ENOMEM?

I will add this, even though the next patch in the series will change this.

> > +
> > +     port->lan966x = lan966x;
> > +     port->chip_port = p;
> > +     port->pvid = PORT_PVID;
> > +     lan966x->ports[p] = port;
> > +
> > +     return 0;
> > +}
> > +

...

> > +
> > +     /* go over the child nodes */
> > +     fwnode_for_each_available_child_node(ports, portnp) {
> > +             phy_interface_t phy_mode;
> > +             u32 p;
> > +
> > +             if (fwnode_property_read_u32(portnp, "reg", &p))
> > +                     continue;
> > +
> > +             phy_mode = fwnode_get_phy_mode(portnp);
> > +             err = lan966x_probe_port(lan966x, p, phy_mode);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     return 0;
> You have to properly free allocated resource in the error case

Yes, I will need to call, fwnode_handle_put(portnp), like it is done in
the next patch.

> > +}
> > +
> > +static int lan966x_remove(struct platform_device *pdev)
> > +{
> > +     return 0;
> > +}
> > +
> > 

-- 
/Horatiu
