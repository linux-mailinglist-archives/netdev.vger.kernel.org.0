Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43D61956BE
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0MG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:06:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33132 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0MGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 08:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1A4KxxyEJTfDzTDi2VM8eA6J5WdBqmTT9sy80l9pA+o=; b=ShehKgELrAc6eNI9ymTruR1W2
        vaeSKkreP+P8DnttUOjT9Yr8siV4KdBMCt09RLgO4J5+idLUaha1TFeA/N0wy3hN4jYpYlYgc/nej
        +JPLNDiFzBsfd4VIXRcwP9RZRsdc/+5MPHy/gqgeWcdijbOOMo+zwVZ5xX2Om/Ao48SjJ9EEL/JZp
        hCwhcxYbqRR3ID6K7wakAt0+2HHQ9qDJalnSkF/sh3bnR3tHqjjBpYDA/dUeVcdJNwKV7u8HBQw/Z
        H2hfJ+saVsDJfoL5QdU54vHN/5+I7my2InJMBfUlJnvL5mWzfxqGL9doVX6LT5dKLroxLR8Qz6agc
        anAYSbGWg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37886)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHnl9-0000uz-Rz; Fri, 27 Mar 2020 12:06:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHnl8-0004Br-Of; Fri, 27 Mar 2020 12:06:46 +0000
Date:   Fri, 27 Mar 2020 12:06:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florinel Iordache <florinel.iordache@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt bindings
Message-ID: <20200327120646.GH25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
 <20200327010411.GM3819@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327010411.GM3819@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 02:04:11AM +0100, Andrew Lunn wrote:
> On Thu, Mar 26, 2020 at 03:51:15PM +0200, Florinel Iordache wrote:
> > Add ethernet backplane device tree bindings
> 
> > +  - |
> > +    /* Backplane configurations for specific setup */
> > +    &mdio9 {
> > +        bpphy6: ethernet-phy@0 {
> > +            compatible = "ethernet-phy-ieee802.3-c45";
> > +            reg = <0x0>;
> > +            lane-handle = <&lane_d>; /* use lane D */
> > +            eq-algorithm = "bee";
> > +            /* 10G Short cables setup: up to 30 cm cable */
> > +            eq-init = <0x2 0x5 0x29>;
> > +            eq-params = <0>;
> > +        };
> > +    };
> 
> So you are modelling this as just another PHY? Does the driver get
> loaded based on the PHY ID in registers 2 and 3? Does the standard
> define these IDs or are they vendor specific?

We likely need some mutual coordination here between the patches I've
already posted for PCS support and these patches.

As I've said, we can't deal with multiple ethernet PHYs connected to
one MAC, the patches I've posted cope with that, but likely will need
changes for this.  Conversely, these patches will need changes for my
work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
