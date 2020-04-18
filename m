Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716581AF26E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgDRQtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:49:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgDRQtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 12:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P/b34RLe96NmHWroAboNYyXEivVycOpXriadams37Hs=; b=lki8jxpWBjdXTfpdnAsq1HvNNn
        ci05HuhFkbdBie3I6GkCoxPRkLWV6vxlMJNDyQ29+4OlfLMXajWo7b6zIZXZBNgv1YJj6vynFkX+D
        B+KEteHqvnOH6BZ5WZDTo4TA8gTHOHLZIOvMOdBb67XWZ/bZaCqjTvkqIPeh5RQmMmQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPqeM-003UWm-HF; Sat, 18 Apr 2020 18:49:02 +0200
Date:   Sat, 18 Apr 2020 18:49:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
Message-ID: <20200418164902.GK804711@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
 <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
 <20200418142336.GB804711@lunn.ch>
 <b6b6c42b-aa2d-8036-958e-4f9929752536@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6b6c42b-aa2d-8036-958e-4f9929752536@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't see how that would work. Each device on the bus needs to be
> > able to receiver the transaction in order to decode the device
> > address, and then either discard it, or act on it. So the same as I2C
> > where the device address is part of the transaction. You need the bus
> > to run as fast as the slowest device on the bus. So a bus property is
> > the simplest. You could have per device properties, and during the bus
> > scan, figure out what the slowest device is, but that seems to add
> > complexity for no real gain. I2C does not have this either.
> > 
> > If MDIO was more like SPI, with per device chip select lines, then a
> > per device frequency would make sense.
> 
> OK, that is a good point, but then again, just like patch #3 you need to
> ensure that you are setting a MDIO bus controller frequency that is the
> lowest common denominator of all MDIO slaves on the bus, which means that
> you need to know about what devices do support.

Hi Florian

I've been following what I2C does, since MDIO and I2C is very similar.
I2C has none of what you are asking for. If I2C does not need any of
this, does MDIO? I2C assumes what whoever writes the DT knows what
they are doing and will set a valid clock frequency which works for
all devices on the bus. This seems to work for I2C, so why should it
not work for MDIO?

My preference is KISS.

    Andrew
