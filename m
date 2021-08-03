Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76C33DF04B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhHCO3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:29:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236507AbhHCO3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=39kNPjDsQBCaa+m6oCrWSY0OrXd5M9GEZtjuh6gG6zs=; b=OJnMgpTiAhK9iiaqw4yuK+PzsD
        KtFUmXot8A+cAJx7a4u7ARxcZsRrPMVbboCeLMJUjb+RKmQ3TnCPbe1BKYcScrfoQsW+m2Jv8umQ3
        g+pLjFRs4QyPP7oDWviwIiQXSH0a7TLXbmQs/z3l9hIjWiyy8iuNSSOc400RYT3MhvMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAvPt-00Fyd2-4R; Tue, 03 Aug 2021 16:29:13 +0200
Date:   Tue, 3 Aug 2021 16:29:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] net: dsa: qca: ar9331: make proper initial
 port defaults
Message-ID: <YQlSuX73dUli2rky@lunn.ch>
References: <20210803085320.23605-1-o.rempel@pengutronix.de>
 <20210803090605.bud4ocr4siz3jl7r@skbuf>
 <20210803095419.y6hly7euht7gsktu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803095419.y6hly7euht7gsktu@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 11:54:19AM +0200, Oleksij Rempel wrote:
> On Tue, Aug 03, 2021 at 12:06:05PM +0300, Vladimir Oltean wrote:
> > On Tue, Aug 03, 2021 at 10:53:20AM +0200, Oleksij Rempel wrote:
> > > Make sure that all external port are actually isolated from each other,
> > > so no packets are leaked.
> > > 
> > > Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > > changes v2:
> > > - do not enable address learning by default
> > > 
> > >  drivers/net/dsa/qca/ar9331.c | 98 +++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 97 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> > > index 6686192e1883..de7c06b6c85f 100644
> > > --- a/drivers/net/dsa/qca/ar9331.c
> > > +++ b/drivers/net/dsa/qca/ar9331.c
> > > @@ -101,6 +101,46 @@
> > >  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> > >  	 AR9331_SW_PORT_STATUS_SPEED_M)
> > >  
> > > +#define AR9331_SW_REG_PORT_CTRL(_port)			(0x104 + (_port) * 0x100)
> > > +#define AR9331_SW_PORT_CTRL_ING_MIRROR_EN		BIT(17)
> > > +#define AR9331_SW_PORT_CTRL_LOCK_DROP_EN		BIT(5)
> > 
> > not used
> 
> ack, will remove

Just expanding Vladimirs comment. Patches for net should be as minimal
as possible, so they are obviously correct.

   Andrew
