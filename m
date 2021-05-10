Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C6378F67
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhEJNlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:41:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346913AbhEJMpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j5EzHxmHIQeijYWLXgO27l27M9QmN8aWCXpiUoQsyRg=; b=ErWqRBqQxGP5hYTBa/6MP/JKQi
        c46A5l+jYpT8OT5T+igBPnet36GTnr0d0HvauHrk0ZSK/uGX582f2WeHEB7sgnhXPH6zGH4oCJ1lC
        +CufHH5KzLYH1JchXtKG+OKxoc/FKuhxFOabHF1GywWbvgNV4kPTFgiTkphLQUAiXZIA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lg5Gp-003Wob-CZ; Mon, 10 May 2021 14:44:23 +0200
Date:   Mon, 10 May 2021 14:44:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [RFC PATCH v1 8/9] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <YJkqpxF9gu1XYdAs@lunn.ch>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-9-o.rempel@pengutronix.de>
 <YJKT173qkYZ+Iyp6@lunn.ch>
 <20210510090656.eiqlwp7t7hkvsxq3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510090656.eiqlwp7t7hkvsxq3@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 11:06:56AM +0200, Oleksij Rempel wrote:
> On Wed, May 05, 2021 at 02:47:19PM +0200, Andrew Lunn wrote:
> > On Wed, May 05, 2021 at 11:20:24AM +0200, Oleksij Rempel wrote:
> > > This patch support for cable test for the ksz886x switches and the
> > > ksz8081 PHY.
> > > 
> > > The patch was tested on a KSZ8873RLL switch with following results:
> > > 
> > > - port 1:
> > >   - cannot detect any distance
> > >   - provides inverted values
> > >     (Errata: DS80000830A: "LinkMD does not work on Port 1",
> > >      http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf)
> > >     - Reports "short" on open or ok.
> > >     - Reports "ok" on short.
> > 
> > Quite broken. Distance is optional, simply don't report it.  Status is
> > harder. Reporting ETHTOOL_A_CABLE_RESULT_CODE_OK should really mean
> > the cable is O.K. If you cannot tell open from O.K, i would return
> > ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC.
> > 
> 
> Yes, patch "net: phy: micrel: add patch for erratas on port1" provides
> a flag to return -ENOTSUPP on this port.
> 
> Is it acceptable way? Should I squash this patches?

This is O.K. Maybe add a comment that later patches in the series with
handle the errata?

       Andrew
