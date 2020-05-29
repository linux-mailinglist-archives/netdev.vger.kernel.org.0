Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D854A1E8395
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgE2QZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:25:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2QZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 12:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fX4ye2k9RYANOwm67tZmZltszM+deAdWBJgcwkaw/vc=; b=24h4frs6Q/LunU3cuN09TvdBHG
        GnrQUnBgspWP9pcqx5r2wiUuKoiYuEhcwY1kgUJiy1Uy21gjXEWzifiHfDasOOmLxYw0wtl0kyeYJ
        F53hIUQO7j3Gk/IUBuhOWUdYAfk47Sh/AlJnQdUauIMtqhDMszL1ncE0YU9/LI0IEMHA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jehoe-003f55-CF; Fri, 29 May 2020 18:25:04 +0200
Date:   Fri, 29 May 2020 18:25:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200529162504.GH869823@lunn.ch>
References: <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529155121.GA1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529155121.GA1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I wonder how much risk there is to changing that, so we force the link
> down if phylink says the link should be down, otherwise we force the
> speed/duplex, disable AN, and allow the link to come up depending on
> the serdes status.  It /sounds/ like something sane to do.

Hi Russell

I actually did this for mv88e6xxx in a patchset for ZII devel B. It
was determining link based on SFP LOS, which we know is unreliable. It
said there was link even when the SERDES had lost link.

I did it by making use of the fixed-link state call back, since it was
a quick and dirty patch. But it might make more sense for the MAC to
call phylink_mac_change() for change in PCS state? Or add a PCS
specific.

	Andrew
