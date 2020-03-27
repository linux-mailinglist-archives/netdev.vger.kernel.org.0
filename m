Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766B6196065
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgC0V0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:26:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgC0V0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mcVLbv+ONWuSTh/BfFcjtLQCKOb5vhxXiTQ1mhY9APU=; b=dAuKUPrtxNXIq8CVZNKOIj8qT3
        uyttFW9Mtj91biDDUNDvTPDqVlM8UhRsx9CQoeSOecQvYB7W1Kj91lJKd1+h/jRwWYjxTd6YkLy/k
        lpBTZXQb2wjhMPA/J17YGyQ+3BzKZxKuWR39dXC4Gygj7O2xnboKOxn4tKSMd1ge6fV8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHwUS-0005Pz-EO; Fri, 27 Mar 2020 22:26:08 +0100
Date:   Fri, 27 Mar 2020 22:26:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when
 changing speed
Message-ID: <20200327212608.GU3819@lunn.ch>
References: <20200323214900.14083-1-andrew@lunn.ch>
 <20200323214900.14083-3-andrew@lunn.ch>
 <20200323220113.GX25745@shell.armlinux.org.uk>
 <20200323223934.GA14512@lunn.ch>
 <20200327111316.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327111316.GF25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Russell
> > 
> > So the problem here is that CPU and DSA ports should default to up and
> > at their fastest speed. During setup, the driver is setting the CPU
> > port to 1G and up. Later on, phylink finds the fixed-link node in DT,
> > and then sets the port to 100Mbps as requested.
> > 
> > How do you suggest fixing this? If we find a fixed-link, configure it
> > first down and then up?
> 
> I think this is another example of DSA fighting phylink in terms of
> what's expected.
> 
> The only suggestion I've come up so far with is to avoid calling
> mv88e6xxx_port_setup_mac() with forced-link-up in
> mv88e6xxx_setup_port() if we have phylink attached.

Hi Russell

Yes, that might work. But it is a solution specific to mv88e6xxx. I
guess other switches could have a similar issue.

Is it really that bad to add the link down as i proposed? Do we even
have a guarantee the port is down before phylink starts configuring
it, for all switch drivers?

    Andrew
