Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0818E84A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 12:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgCVLKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 07:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbgCVLKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 07:10:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7384520753;
        Sun, 22 Mar 2020 11:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584875454;
        bh=F+bb/PhDrGL6xSqYVlRBI18Yhx3UabZn2G7TvUh7EF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGWHc9YL5uj95BAw1iYQ3bd8gW+k+tBYGLfGEc/MOZ3necAF2Yqz4LxDye3nuh6Da
         3jrs1YfWP9wNIc9v2ikSqgtxxdTdqNPxOmmsZBCNOhWzIuxsjs6MXFEl07LrIdUC4K
         X8+cBWpxTZesIu/s4EQyz4id44lg495ySHcd4CUw=
Date:   Sun, 22 Mar 2020 12:10:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: phy: add marvell usb to mdio controller
Message-ID: <20200322111051.GB72939@kroah.com>
References: <20200322074006.GB64528@kroah.com>
 <C1H8VLGMUEEC.3BCHVI0HO90KD@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1H8VLGMUEEC.3BCHVI0HO90KD@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 10:09:28AM +0100, Tobias Waldekranz wrote:
> On Sun Mar 22, 2020 at 8:40 AM, Greg KH wrote:
> > From a USB point of view, it looks sane, only one question:
> 
> Great, thanks for the review.
> 
> > > +static int mvusb_mdio_probe(struct usb_interface *interface,
> > > +			    const struct usb_device_id *id)
> > > +{
> > > +	struct device *dev = &interface->dev;
> > > +	struct mvusb_mdio *mvusb;
> > > +	struct mii_bus *mdio;
> > > +
> > > +	mdio = devm_mdiobus_alloc_size(dev, sizeof(*mvusb));
> >
> > 
> > You allocate a bigger buffer here than the original pointer thinks it is
> > pointing to?
> 
> Yes. I've seen this pattern in a couple of places in the kernel,
> e.g. alloc_netdev also does this. The object is extended with the
> requested size, and the offset is stored somewhere for later use by
> the driver.
> 
> > > +	if (!mdio)
> > > +		return -ENOMEM;
> > > +
> > > +	mvusb = mdio->priv;
> >
> > 
> > And then you set this pointer here?
> 
> ...in this case in the priv member.
> 
> https://code.woboq.org/linux/linux/drivers/net/phy/mdio_bus.c.html#143

Ok, just wanted to make sure :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
