Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1ED415484
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfEFTkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:40:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56165 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfEFTkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 15:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LmXv43jalgATsXC3BlEHykUfjP9PKqkyPGppdZx2qmo=; b=SM7O8YlLoovzyIAlNViXs69+QY
        0H3UzF/nqmUv+v12SSCu/4Rgj5LGFq8hVZdGe5p/FAc1n9Zg53TeMfO1XKUxGtCYMorUWHJE3rNeq
        mdEs3Zl/sREEHWE3xHC6ZiRcCGjWsRnm+7luCt4eFeDeUILSUenKQRZIGPM4ZjevP0S8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNjTH-0000bP-AN; Mon, 06 May 2019 21:40:19 +0200
Date:   Mon, 6 May 2019 21:40:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Ruslan Babayev <ruslan@babayev.com>, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, wsa@the-dreams.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [PATCH net-next 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190506194019.GB25013@lunn.ch>
References: <20190505220524.37266-3-ruslan@babayev.com>
 <20190506045951.GB2895@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506045951.GB2895@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 07:59:51AM +0300, Mika Westerberg wrote:
> On Sun, May 05, 2019 at 03:05:23PM -0700, Ruslan Babayev wrote:
> > Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> > systems similar to how it's done with DT.
> > 
> > An example DSD describing an SFP on an ACPI based system:
> > 
> > Device (SFP0)
> > {
> >     Name (_HID, "PRP0001")
> >     Name (_DSD, Package ()
> >     {
> >         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >         Package () {
> >             Package () { "compatible", "sff,sfp" },
> >             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
> 
> Hmm, ACPI has I2cSerialBusV2() resource for this purpose. Why you are not
> using that?

Hi Mika

Does that reference the bus as a whole, or a device on the bus?

The SFP subsystem needs a reference to the bus as a whole. There can
be an at24 like EEPROM at addresses 0x50 and 0x51. There can be an
MDIO bus encapsulated in i2c at addresses 0x40-0x5f, excluding 0x50
and 0x51. What actually is there depends on the SFP module which is
plugged into the SFP cage, and it is all hot-plugable.

	Andrew
