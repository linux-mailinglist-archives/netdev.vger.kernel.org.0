Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44F5259652
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgIAQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:01:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730331AbgIAP7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 11:59:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kD8hF-00CmnA-Sz; Tue, 01 Sep 2020 17:59:45 +0200
Date:   Tue, 1 Sep 2020 17:59:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200901155945.GG2403519@lunn.ch>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-3-kurt@linutronix.de>
 <20200901134020.53vob6fis5af7nig@skbuf>
 <87y2ltegnd.fsf@kurt>
 <20200901142243.2jrurmfmh6znosxd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901142243.2jrurmfmh6znosxd@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >
> > > What is the register lock protecting against, exactly?
> > 
> > A lot of the register operations work by:
> > 
> >  * Select port, priority, vlan or counter
> >  * Configure it
> > 
> > These sequences have to be atomic. That's what I wanted to ensure.
> > 
> 
> So, let me rephrase. Is there any code path that is broken, even if only
> theoretically, if you remove the reg_lock?

Maybe, at the moment, RTNL is keeping things atomic. But that is
because there is no HWMON, or MDIO bus. Those sort of operations don't
take the RTNL, and so would be an issue. I've also never audited the
network stack to check RTNL really is held at all the network stack
entry points to a DSA driver. It would be an interesting excesses to
scatter some ASSERT_RTNL() in a DSA driver and see what happens.

	Andrew
