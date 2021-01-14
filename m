Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE12F6969
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbhANSVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:21:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbhANSVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:21:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l07EP-000bjh-6S; Thu, 14 Jan 2021 19:20:25 +0100
Date:   Thu, 14 Jan 2021 19:20:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next] net: mvpp2: extend mib-fragments name
 to mib-fragments-err
Message-ID: <YACLaZ4c6HP9KL13@lunn.ch>
References: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
 <YABm5PDi94I5VKQp@lunn.ch>
 <CO6PR18MB387365B7B1DADFF14150ACB0B0A81@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387365B7B1DADFF14150ACB0B0A81@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 04:13:23PM +0000, Stefan Chulski wrote:
> > > From: Stefan Chulski <stefanc@marvell.com>
> > >
> > > This patch doesn't change any functionality, but just extend MIB
> > > counter register and ethtool-statistic names with "err".
> > >
> > > The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
> > > Extend REG name and appropriated ethtool statistic reg-name with the
> > > ERR/err.
> > 
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -1566,7 +1566,7 @@ static u32 mvpp2_read_index(struct mvpp2
> > *priv, u32 index, u32 reg)
> > >  	{ MVPP2_MIB_FC_RCVD, "fc_received" },
> > >  	{ MVPP2_MIB_RX_FIFO_OVERRUN, "rx_fifo_overrun" },
> > >  	{ MVPP2_MIB_UNDERSIZE_RCVD, "undersize_received" },
> > > -	{ MVPP2_MIB_FRAGMENTS_RCVD, "fragments_received" },
> > > +	{ MVPP2_MIB_FRAGMENTS_ERR_RCVD, "fragments_err_received" },
> > 
> > Hi Stefan
> > 
> > I suspect this is now ABI and you cannot change it. You at least need to argue
> > why it is not ABI.
> > 
> >   Andrew
> 
> Hi Andrew,
> 
> I not familiar with ABI concept. Does this mean we cannot change, fix or extend driver ethtool counters?

As Jakub pointed out, there could be user space looking for this name.

What you could do is add fragments_err_received in addition to
fragments_received. That should not break anything.

    Andrew
