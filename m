Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D8410473A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKUADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:03:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47876 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfKUADk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:03:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5xmY3KMEdFXw13IZCuV7CTm19KFPphSqHIt2Exu3kpE=; b=afgWjA27czC+H19yptFCCc4nU
        Y4DdCmE6Xgj9H+SDsfUUr8QOYt+5arB3Ve+t0rGXVzP/by7/VOSZIJAmod+YvBtSgooHea9brA4fi
        E5wyocxPh7wtgxXIKpVWnMQ6axxXLde1JnVjf/GCe2M4uaGnAHlT8Lwnd01S87cjqDEBrdvXjoZbP
        qs23ZvR/4DmwMC8z0QCp6kHSDbzkVjexcBhNMn1kbj10uAjEER9wbxmFwIYJPfsYUfgrFXsGKv+8d
        7vY1ublaHoP7EfpRKAiBrXBtPBwYW1yYzJu+/UORXWU9FjqmfdBoOcVRumnVg9Vx/LmJRuboL7FMh
        3ejyG6Nxg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42408)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXZwZ-00031o-Qw; Thu, 21 Nov 2019 00:03:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXZwW-0002Am-Sb; Thu, 21 Nov 2019 00:03:28 +0000
Date:   Thu, 21 Nov 2019 00:03:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: add some quirks for GPON modules
Message-ID: <20191121000328.GX25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
 <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
 <20191120144632.0658d920@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120144632.0658d920@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 02:46:32PM -0800, Jakub Kicinski wrote:
> On Wed, 20 Nov 2019 11:42:47 +0000, Russell King wrote:
> >  static const struct sfp_quirk sfp_quirks[] = {
> > +	{
> > +		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> > +		// incorrectly report 2500MBd NRZ in their EEPROM
> > +		.vendor = "ALCATELLUCENT",
> > +		.part = "G010SP",
> > +		.modes = sfp_quirk_2500basex,
> > +	}, {
> > +		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
> > +		// report 3.2GBd NRZ in their EEPROM
> > +		.vendor = "ALCATELLUCENT",
> > +		.part = "3FE46541AA",
> > +		.modes = sfp_quirk_2500basex,
> > +	}, {
> > +		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
> > +		// NRZ in their EEPROM
> > +		.vendor = "HUAWEI",
> > +		.part = "MA5671A",
> > +		.modes = sfp_quirk_2500basex,
> > +	},
> >  };
> 
> nit: no C++ comment style?

Did you read Linus' opinions on commentry style during the discussion
over the SPDX tags?

https://lkml.org/lkml/2017/11/2/715
https://lkml.org/lkml/2017/11/25/133

It seems that Linus has decided to prefer // over /* */

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
