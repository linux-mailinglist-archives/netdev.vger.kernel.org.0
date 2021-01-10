Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463B62F0869
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 17:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAJQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 11:36:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJQgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 11:36:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kydgb-00HKtc-2H; Sun, 10 Jan 2021 17:35:25 +0100
Date:   Sun, 10 Jan 2021 17:35:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <X/sszQBPDHehtQWM@lunn.ch>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 11:13:44AM +0000, Russell King wrote:
> Check whether the MAC driver has implemented the get_ts_info()
> method first, and call it if present.  If this method returns
> -EOPNOTSUPP, defer to the phylib or default implementation.
> 
> This allows network drivers such as mvpp2 to use their more accurate
> timestamping implementation than using a less accurate implementation
> in the PHY. Network drivers can opt to defer to phylib by returning
> -EOPNOTSUPP.
> 
> This change will be needed if the Marvell PHY drivers add support for
> PTP.
> 
> Note: this may cause a change for any drivers that use phylib and
> provide get_ts_info(). It is not obvious if any such cases exist.

Hi Russell

We can detect that condition through? Call both, then do a WARN() if
we are changing the order? Maybe we should do that for a couple of
cycles?

For netlink ethtool, we can also provide an additional attribute. A
MAC, or PHY indicator we can do in the core. A string for the name of
the driver would need a bigger change.

	Andrew
