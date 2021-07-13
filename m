Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DE3C7109
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhGMNKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:10:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236677AbhGMNKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 09:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U96NI2AGJuhqP5+/xjUH0gQkh60Cu2uwD9mCLAs6TFA=; b=bpHciKamB0LY4LVzoJGeG2kXPh
        vluHAzAiNVOkFARFf+mHlBBta/BiEIBRVex9/iNaEW01yMUzEbvBLBsYnYLp7mDo+wBqK4+DfP5cj
        gUerjKmV0wDDsMJx73LhdLx5pLIj3GCSLu2lgZwBzSKvLm1YXyoFp1We0wzCy7e+3wQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3I7k-00DDBM-DO; Tue, 13 Jul 2021 15:06:56 +0200
Date:   Tue, 13 Jul 2021 15:06:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <YO2P8J4Ln+RwxkfO@lunn.ch>
References: <20210709164216.18561-1-ms@dev.tdt.de>
 <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
 <fcb3203ea82d1180a6e471f22e39e817@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb3203ea82d1180a6e471f22e39e817@dev.tdt.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > [...]
> > > +#if IS_ENABLED(CONFIG_OF_MDIO)
> > is there any particular reason why we need to guard this with
> > CONFIG_OF_MDIO?
> > The dp83822 driver does not use this #if either (as far as I
> > understand at least)
> > 
> 
> It makes no sense to retrieve properties from the device tree if we are
> compiling for a target that does not support a device tree.
> At least that is my understanding of this condition.

There should be stubs for all these functions, so if OF is not part of
the configured kernel, stub functions take their place. That has the
advantage of at least compiling the code, so checking parameter types
etc. We try to avoid #ifdef where possible, so we get better compiler
build test coverage. The more #ifef there are, the more different
configurations that need compiling in order to get build coverage.

	       Andrew
