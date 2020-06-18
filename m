Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0381FFE54
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgFRWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgFRWts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:49:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E81C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QKv2DvPxjQIA7F+pTjCjHLZZ3yHxch6opHJIahoc+Qo=; b=JuQCBEZ4q2BXGEfaKIVQJQb4w
        QJMGtzD+FJkG8M9kW8Iyo/kqroaRkkZQZT7MYY06X/hmyi17/nwaFN7GXoLG5ylnPUhP6vB7SBi0E
        RTBDEpiDRTCe9MskVyJD1aj5AqQwddwZF4Tvz7SmiKCTYiNz0qNWyR4gS3ASM8ysEJ+7kiUstG0Q7
        uqEL8JoGpusU4pghV/J/xa869AKxaAZpVpzNtya5rQfAcmFVIhK3BctFrtYMASiDx2DQKJL3WjIK2
        rEPr9lj8F6B7QdRAh2vkF1v9BwCCOEzE9ro4Qg/5tOKuCo65U7R4OmLmO5jQUa/tNpCqttZxKLM/q
        ySUnVj5gg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58812)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jm3Lu-0005ef-2G; Thu, 18 Jun 2020 23:49:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jm3Lt-000554-CJ; Thu, 18 Jun 2020 23:49:45 +0100
Date:   Thu, 18 Jun 2020 23:49:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        michael@walle.cc, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618224945.GN1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618221352.GB279339@lunn.ch>
 <20200618222727.GM1551@shell.armlinux.org.uk>
 <20200618223740.GD279339@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618223740.GD279339@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 12:37:40AM +0200, Andrew Lunn wrote:
> > The other thing is, drivers/net/phy is becoming a little cluttered -
> > we have approaching 100 files there.
> > 
> > Should we be thinking about drivers/net/phy/mdio/ (for mdio*),
> > drivers/net/phy/lib/ for the core phylib code or leaving it where
> > it is, and, hmm, drivers/net/phy/media/ maybe for the PHY and PCS
> > drivers?  Or something like that?
> 
> Hi Russell
> 
> Do you have any experience how good git is at following file moves
> like this. We don't want to make it too hard for backporters of fixes.
> 
> If it is not going to be too painful, then yes, mdio, phy and pcs
> subdirectories would be nice.

It becomes problematical if git doesn't have the objects referenced
on the index line in the patch file when applying.  If it has the
objects, then git can work out where the file moved to via it's
rename detection.

I think the stable team probably have a better idea of how big an
issue it may be, but over the years there have been some quite big
reorganisations done.  The biggest I remember is a whole raft of
drivers moving from (iirc) drivers/net into
drivers/net/ethernet/<vendor> - moving the files in drivers/net/phy
would be quite a bit smaller in comparison.  I think drivers/media
has also seen quite a lot of renames, and drivers/video has been
significantly reorganised.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
