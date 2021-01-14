Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C722F58F1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbhANDGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbhANDGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D246235FA;
        Thu, 14 Jan 2021 03:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593557;
        bh=QNr4JJvWMR/qdBxM+RhNO7YPB5scb3q4zTwfPBJriCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XV7Y+W/2qU2rnFxrQkZD2e270WxjfLvkWrb0UNpxmCyBwbHVDHOwM8iY5V4oZjkO8
         7TLZvI28hS++eJNDVgiMzwUAJNgvxjsY1okix//l+SzmsH+BHYHhmuubfhoTbs13jK
         2rVPJCa0QVVsrsjX/rrj27o2MS7uYU1YUr4kTs2u0BeCRbWOPlpHWYhSujDXhd1rWd
         wDlCebSGBvc9CmQtCeeNSZIJ5oqmNjBQLVsK85dfl3JjjSpUWG2dNIa+vysufTiyXK
         71FqiWKmTpOYEF8fVOKcKWRI+aQOm2ECPEwf9RXkB94aaryUx/taefFsEuTuZnjgiv
         peDZMeMNw7s5Q==
Date:   Wed, 13 Jan 2021 19:05:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210113190555.095bf937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/sszQBPDHehtQWM@lunn.ch>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
        <X/sszQBPDHehtQWM@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 17:35:25 +0100 Andrew Lunn wrote:
> On Sun, Jan 10, 2021 at 11:13:44AM +0000, Russell King wrote:
> > Check whether the MAC driver has implemented the get_ts_info()
> > method first, and call it if present.  If this method returns
> > -EOPNOTSUPP, defer to the phylib or default implementation.
> > 
> > This allows network drivers such as mvpp2 to use their more accurate
> > timestamping implementation than using a less accurate implementation
> > in the PHY. Network drivers can opt to defer to phylib by returning
> > -EOPNOTSUPP.
> > 
> > This change will be needed if the Marvell PHY drivers add support for
> > PTP.
> > 
> > Note: this may cause a change for any drivers that use phylib and
> > provide get_ts_info(). It is not obvious if any such cases exist.  
> 
> Hi Russell
> 
> We can detect that condition through? Call both, then do a WARN() if
> we are changing the order? Maybe we should do that for a couple of
> cycles?
> 
> For netlink ethtool, we can also provide an additional attribute. A
> MAC, or PHY indicator we can do in the core. A string for the name of
> the driver would need a bigger change.

I'm not seeing a response to this suggestion, did vger eat it?
