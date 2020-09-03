Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D774525CB22
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgICUij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:38:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41264 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgICUid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:38:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDvzq-00D6H2-Ly; Thu, 03 Sep 2020 22:38:14 +0200
Date:   Thu, 3 Sep 2020 22:38:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] net: mvpp2: ptp: add interrupt handling
Message-ID: <20200903203814.GA3122026@lunn.ch>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
 <E1kDVMg-0000k9-6g@rmk-PC.armlinux.org.uk>
 <20200903013940.GA3090178@lunn.ch>
 <20200903084816.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903084816.GO1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 09:48:16AM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Sep 03, 2020 at 03:39:40AM +0200, Andrew Lunn wrote:
> > > +static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
> > > +{
> > > +	void __iomem *ptp_q;
> > > +	u32 r0, r1, r2;
> > > +
> > > +	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
> > > +	if (nq)
> > > +		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
> > > +
> > > +	while (1) {
> > > +		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
> > > +		if (!r0)
> > > +			break;
> > > +
> > > +		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
> > > +		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
> > > +	}
> > > +}
> > 
> > Hi Russell
> > 
> > That is a rather odd interrupt handler, basically throwing everything
> > away. Maybe add a comment about what is going on?
> 
> We end up doing something with it in the following patch. I could
> squash 6 and 7 together, which would avoid this.

Hi Russell

Yes, i noticed this when i get to the next patch. Please either squash
it, or add something to the commit message that the following patches
will flesh the function out some more.

Thanks
      Andrew
