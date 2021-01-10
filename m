Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE582F08F4
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbhAJSEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:04:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbhAJSEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 13:04:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyf4F-00HLof-UD; Sun, 10 Jan 2021 19:03:55 +0100
Date:   Sun, 10 Jan 2021 19:03:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Message-ID: <X/tBiyrJ8cJX+3u6@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <20210110175500.GG1551@shell.armlinux.org.uk>
 <CO6PR18MB38737188EA6812EE82F99379B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38737188EA6812EE82F99379B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:57:14PM +0000, Stefan Chulski wrote:
> > > +	} else {
> > > +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> > > +		if (!priv->sram_pool) {
> > > +			dev_warn(&pdev->dev, "DT is too old, TX FC
> > disabled\n");
> > 
> > I don't see anything in this patch that disables TX flow control, which means
> > this warning message is misleading.
> 
> OK, I would change to TX FC not supported.

And you should tell phlylink, so it knows to disable it in autoneg.

Which make me wonder, do we need a fix for stable? Has flow control
never been support in this device up until these patches get merged?
It should not be negotiated if it is not supported, which means
telling phylink.

   Andrew
