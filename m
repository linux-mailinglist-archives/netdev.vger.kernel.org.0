Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B49B2BB8
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfINOyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 10:54:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfINOyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 10:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Up4yvvFBtD1NCB8szKWwf5m7HVIMRzHayYDKRjZJhw=; b=ndXzlcZEFuFOwUauV3/FGP4eJo
        BPUasbnVh3XedATUyL7gl03b/BsVI4yOs7G4yBYwDjsPhctard+wak0PRkIEOBuPBSQ/Gopv37tYa
        OEqpEX/2Dfr2YBemXMIa8MeidkZS2/kIgq7BIVQRdBvaQaoV5a1/WyxjESUasmDTqv6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i99Rj-0007qw-E7; Sat, 14 Sep 2019 16:54:43 +0200
Date:   Sat, 14 Sep 2019 16:54:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Thomas <pthomas8589@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: net: phy: micrel KSZ9031 ifdown ifup issue
Message-ID: <20190914145443.GE27922@lunn.ch>
References: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 10:42:38AM -0400, Paul Thomas wrote:
> Hello,
> 
> I think I'm seeing an issue with the PHY hardware or PHY driver. What
> happens is sometimes (but not always) when I do 'ip link set eth0
> down' followed by 'ip link set eth0 up' I don't ever see an
> auto-negotiation again. LEDs don't come on, ethtool reports 'Link
> detected: no'. Even physically unplugging and plugging the network
> cable doesn't bring it back. I have to do a reboot to get the
> networking back.
> 
> When the networking is started I don't see any issue forcing
> negotiations by unplugging and plugging the cable. I get standard
> messages like this all day long:
> [   21.031793] 003: macb ff0b0000.ethernet eth0: link down
> [   26.142835] 003: macb ff0b0000.ethernet eth0: link up (1000/Full)
> 
> One thing that makes me think this is the PHY is that we have another
> Ethernet port using the DP83867 PHY and I can always do ifdown/ifup
> with it.
> 
> This is using a 5.2.10 kernel on arm64 zynqmp platform with the macb driver.
> 
> Is this something anyone else has seen? I know there is some Errata
> with this part, but I'm hoping there is something to fix or work
> around this. Any thoughts on where to look or add debugging would
> appreciated.

Hi Paul

Are you using interrupts, or polling? If interrupts, try polling?
Seems unlikely, but you could be missing an interrupt.

There is a fix from Antoine Tenart which suggests asym pause can be an
issue? What pause setup are you using? But this is a known issue,
which 5.2 should have the fix for.

    Andrew
