Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DC1BE6BC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgD2S5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:57:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2S5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uS9qOnGXgNTdEq8TAB+IhEPZs/o7LS8aQIdvZ0PrftY=; b=QSdyR1WXD7yi7NPAOIrWIOPadt
        dV7CwHbJL2xXoAPpsjsaWWEJz3Vqz8koS4HhY59LBpmKSx8os+qRwoByAUR9To4jB/evn/TO6TrDp
        mdqYPLC/T25Uflu3TWL+GxnbRpx3Jgks1aBC1w9s0iTANBgaKKa/nZHyCJwG9YYqCjZM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTrtf-000JDW-9h; Wed, 29 Apr 2020 20:57:27 +0200
Date:   Wed, 29 Apr 2020 20:57:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
Message-ID: <20200429185727.GP30459@lunn.ch>
References: <20200425180621.1140452-5-andrew@lunn.ch>
 <20200429161605.23104-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429161605.23104-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 06:16:05PM +0200, Michael Walle wrote:
> Hi,
> 
> > > > > +enum {
> > > > > +	ETHTOOL_A_CABLE_PAIR_0,
> > > > > +	ETHTOOL_A_CABLE_PAIR_1,
> > > > > +	ETHTOOL_A_CABLE_PAIR_2,
> > > > > +	ETHTOOL_A_CABLE_PAIR_3,
> > > > > +};
> > > > 
> > > > Do we really need this enum, couldn't we simply use a number (possibly
> > > > with a sanity check of maximum value)?
> > > 
> > > They are not strictly required. But it helps with consistence. Are the
> > > pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?
> > 
> > OK, I'm not strictly opposed to it, it just felt a bit weird.
> 
> Speaking of the pairs. What is PAIR_0 and what is PAIR_3? Maybe
> it is specified somewhere in a standard, but IMHO an example for
> a normal TP cable would help to prevent wild growth amongst the
> PHY drivers and would help to provide consistent reporting towards
> the user space.

Hi Michael

Good question

Section 25.4.3 gives the pin out for 100BaseT. There is no pair
numbering, just transmit+, transmit- and receive+, receive- signals.

1000BaseT calls the signals BI_DA+, BI_DA-, BI_DB+, BI_DB-, BI_DC+,
BI_DC-, BI_DDA+, BI_DD-. Comparing the pinout 100BaseT would use
BI_DA+, BI_DA-, BI_DB+, BI_DB. But 1000BaseT does not really have
transmit and receive pairs due to Auto MDI-X.

BroadReach calls the one pair it has BI_DA+/BI_DA-.

Maybe it would be better to have:

enum {
	ETHTOOL_A_CABLE_PAIR_A,
	ETHTOOL_A_CABLE_PAIR_B,
	ETHTOOL_A_CABLE_PAIR_C,
	ETHTOOL_A_CABLE_PAIR_D,
};

	Andrew
