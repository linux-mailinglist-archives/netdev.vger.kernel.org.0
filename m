Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42146D8BD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhLHQqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:46:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232827AbhLHQqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 11:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dkjvmAjC6mSjmZqeTSN+Kc0OJQQXPi7O87SnNaGDtNo=; b=Ivna+c6cVjwqAKMXQnGk5QJAup
        B/BlAPDxaDBSyqNB2UDsZi2JoiiMhVkAdIq98fIauq11zP9y5LQmmTnPIdbyEeBDS7IHRqfjaDxdp
        lisvpfbiAAUwwF2l1UwQ3XqsO3Qgiqd+MCRkfxEcBC+J9PfVpNt7I6nUQNonJqBDL5FM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv02C-00FtwU-7N; Wed, 08 Dec 2021 17:43:12 +0100
Date:   Wed, 8 Dec 2021 17:43:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: prefer 1000baseT over 1000baseKX
Message-ID: <YbDgoKICfdKA9Cs7@lunn.ch>
References: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 11:36:30AM +0000, Russell King (Oracle) wrote:
> The PHY settings table is supposed to be sorted by descending match
> priority - in other words, earlier entries are preferred over later
> entries.
> 
> The order of 1000baseKX/Full and 1000baseT/Full is such that we
> prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> a lot rarer than 1000baseT/Full, and thus is much less likely to
> be preferred.
> 
> This causes phylink problems - it means a fixed link specifying a
> speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
> rather than 1000baseT/Full as would be expected - and since we offer
> userspace a software emulation of a conventional copper PHY, we want
> to offer copper modes in preference to anything else. However, we do
> still want to allow the rarer modes as well.
> 
> Hence, let's reorder these two modes to prefer copper.
> 
> Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
