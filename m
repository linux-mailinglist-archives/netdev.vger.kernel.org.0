Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2142550E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbhJGOM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:12:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241812AbhJGOMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LJq/Rd1JQXwM/d/SGUYrLbU3t8Vadn/d/u9LaBROMtE=; b=qMOZZRpo/cGAiOuMobMS+AwpEf
        wM2MR1XcVjHyeoDHOzRhTMX2PVKckfK7nQVAxN3vGBSHUZ7TcUsi24304SHwRwteLXV0kr2oe2WMx
        sW72VxIDhPwPMNpK6CsLTuRPMgStbFX+H4ScegEg+ZpXNQCxN+g6XVvEMjAM5rZLYGvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYU6N-009xMM-Ai; Thu, 07 Oct 2021 16:10:27 +0200
Date:   Thu, 7 Oct 2021 16:10:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 2/3] eth: platform: add a helper for loading
 netdev->dev_addr
Message-ID: <YV7/0wqmxuuPB/yJ@lunn.ch>
References: <20211007132511.3462291-1-kuba@kernel.org>
 <20211007132511.3462291-3-kuba@kernel.org>
 <16f34ede9a885a443bb7c46255ee804f@walle.cc>
 <20211007065701.1ee88762@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007065701.1ee88762@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:57:01AM -0700, Jakub Kicinski wrote:
> On Thu, 07 Oct 2021 15:42:17 +0200 Michael Walle wrote:
> > > +int platform_get_ethdev_address(struct device *dev, struct net_device *netdev)
> > > +{
> > > +	u8 addr[ETH_ALEN];
> > > +	int ret;
> > > +
> > > +	ret = eth_platform_get_mac_address(dev, addr);  
> > 
> > this eventually calls ether_addr_copy(), which has a note:
> >    Please note: dst & src must both be aligned to u16.
> > 
> > Is this true for this addr on the stack?
> 
> It will but I don't think there's anything in the standard that
> requires it. Let me slap __aligned(2) on it to be sure.

Hi Jakub

I though you changed ether_addr_copy() to be a memcpy?
Or was that some other helper?

	Andrew
