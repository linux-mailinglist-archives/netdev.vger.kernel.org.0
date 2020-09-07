Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D0B25F311
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIGGPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:15:44 -0400
Received: from mail.intenta.de ([178.249.25.132]:28544 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgIGGPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=DbMZrPNiSZyV/MGrBTAsouTip2qG5zxNYYBptBohLcI=;
        b=ofaFQ0IGc3oT7MFp6707aqNPqhcxPZQo8FzwLBLxGFVPGTV/pCqJL5BXedj4Dv1QpWkux9EwcviR9PpO0dj6DQhvarZOBA33Xs0WcNJSBMDa/JTS7QvKKC+Z24PY+xYCOzxlEIqFe/Xh8kKlqExSqtgGCRjqh5SZ1HU7zErwAgCMms6hdH/MEBtzpGsvmiLfwmQR0x0XfrHGlgDdXk3YiIAl75lovCrrMGwut+8cU9crDR/PHIxJ3N/rFAzlbYHrQQsH2OoqFPAB6i5hl0h/Fk4OxTFThCQxf9mpU8IXjN6XhZ0Gw6PRogxYKmsKNdTGVEAWixXtwS5wxu2jy7u6/A==;
Date:   Mon, 7 Sep 2020 08:15:33 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200907061533.GA2727@laureti-dev>
References: <20200824.153738.1423061044322742575.davem@davemloft.net>
 <20200904081438.GA14387@laureti-dev>
 <20200904135255.GM3112546@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200904135255.GM3112546@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Sep 04, 2020 at 03:52:55PM +0200, Andrew Lunn wrote:
> > +			dev_warn(dev->dev,
> > +				 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",

This is inside ksz8795_port_setup.

> That message seems mangled.

I'm not sure that I understand what you are objecting to here.

> > +			if (!p->interface) {
> > +				if (dev->compat_interface) {
> > +					dev_warn(dev->dev,
> > +						 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",
> > +						 i);

This is inside ksz9477_config_cpu_port.

> Same warning again.

I guess that you believe the warning should only be issued in one place.
The locations affect different chips driven by the same driver. I
considered moving them to a common function, but figured that it was not
worth tearing the code apart. In case a third chip would be supported by
the driver, it would not need the compatibility code. It would start out
using only the correct phy-mode property.

Does that address your concern?

Helmut
