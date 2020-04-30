Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193E41C0892
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgD3UvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:51:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgD3UvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 16:51:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5A06G/vo4nsY8mFEkZch8Qvl2TNKsv7kBPwF2mP9QA0=; b=czWxAQDKv98MtAC8l9hWTbB2P4
        60yl54BWYL88bQfGnbZaj1aOWOm1Z5wJhStMc5ixDNUyj+puM3/XB6iZgWm8hv39wKm1K0xjIddsB
        cy0MHsKPfEcEs2mk4Vzp5ACRLFZMsxP2EQDvXHGQQqCJj7keYsL75Q5+/MqegK+XYcOY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUG96-000SnX-JG; Thu, 30 Apr 2020 22:51:00 +0200
Date:   Thu, 30 Apr 2020 22:51:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Message-ID: <20200430205100.GG107658@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc>
 <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <20200430182331.GE76972@lunn.ch>
 <30fd56d966b577a045ddeb01942a9944@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30fd56d966b577a045ddeb01942a9944@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 09:44:12PM +0200, Michael Walle wrote:
> Am 2020-04-30 20:23, schrieb Andrew Lunn:
> > > Ok. I do have one problem. TDR works fine for the AR8031 and the
> > > BCM54140 as long as there is no link partner, i.e. open cable,
> > > shorted pairs etc. But as soon as there is a link partner and a
> > > link, both PHYs return garbage. As far as I understand TDR, there
> > > must not be a link, correct?
> > 
> > Correct.
> > 
> > The Marvell PHY will down the link and then wait 1.5 seconds before
> > starting TDR, if you set a bit. I _think_ it downs the link by turning
> > off autoneg.
> 
> According to the Atheros datasheet the "CDT can be performed when
> there is no link partner or when the link partner is auto-negotiating".
> One could interpret that as is is only allowed _during_ autoneg. But
> as far as I know there is no indication if autoneg is currently active,
> is it?
> 
> > Maybe there is some hints in 802.3 clause 22?
> 
> I'm just skimming over that, but even if the link could be disabled
> locally, shouldn't there still be link pulses from the peer?

I guessing here....

If the local end stops negotiating, the link peer will stop sending
traffic, and just sends link pulses. The PHY knows when the next set of
link pulses are expected from the link partner, since they should be
every 16ms. It can then avoid them when doing its TDR.

      Andrew
