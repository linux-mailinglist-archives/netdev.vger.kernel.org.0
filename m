Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0464A11796D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLIWiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:19 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40944 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YqIUzqnPfvH5ueu/Sn7RW1UTHvNRC4ylAWNEcP67+Y8=; b=NG0RUdRLXIORhE5qApn/WB5f2
        EfUnXk9TvMxQSocm0XULgXwodnhgu/vxz6aGuG9l8J98fDuSr7BKrQx/EwUpeZ7p5KCBbbJ+/KNbY
        OQUfLfZFrbSP67gc6Q2i6YbquJ2Ek6wG+Ofwr+EEUg3yGzzPerPH8FaP8Q558e3GnUoQ1fR3RRtSf
        qlVtxyPGrtM1Sydw6DpgcVnPssPUghJhfemO2FPPzhmriNMmKENtasJv+V2l4A1Au0CAFuNleFObF
        5xJbXXpoppRleD6y4ihTT9gOb9xXhtW1ExetYKOWywU6Y9SNbwRtkWRzhLMtTcxEchhYLk7h/+yY9
        ebK2QoDpQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39140)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieRfS-0005s4-92; Mon, 09 Dec 2019 22:38:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieRfR-00040h-Pq; Mon, 09 Dec 2019 22:38:13 +0000
Date:   Mon, 9 Dec 2019 22:38:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] Add support for slow-to-probe-PHY copper
 SFP modules
Message-ID: <20191209223813.GS25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
 <20191209.143449.1221575502285244589.davem@davemloft.net>
 <20191209.143525.2056433568231018957.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209.143525.2056433568231018957.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:35:25PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 09 Dec 2019 14:34:49 -0800 (PST)
> 
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Mon, 9 Dec 2019 14:15:25 +0000
> > 
> >> This series, following on from the previous adding SFP+ copper support,
> >> adds support for a range of Copper SFP modules, made by a variety of
> >> companies, all of which have a Marvell 88E1111 PHY on them, but take
> >> far longer than the Marvell spec'd 15ms to start communicating on the
> >> I2C bus.
> >> 
> >> Researching the Champion One 1000SFPT module reveals that TX_DISABLE is
> >> routed through a MAX1971 switching regulator and reset IC which adds a
> >> 175ms delay to releasing the 88E1111 reset.
> >> 
> >> It is not known whether other modules use a similar setup, but there
> >> are a range of modules that are slow for the Marvell PHY to appear.
> >> 
> >> This patch series adds support for these modules by repeatedly trying
> >> to probe the PHY for up to 600ms.
> > 
> > Patch #3 gets full rejects when I try to apply this series.
> > 
> > Please respin, adding Andrew's ACKs.
> 
> Oh nevermind, I see this depends upon a series that's now in v2 and
> thus appears later int he queue.

Yep.  I'm hoping some comments will be forthcoming on that series soon.

Thanks for looking anyway.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
