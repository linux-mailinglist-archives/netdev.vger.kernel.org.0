Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F09426CB0
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbhJHOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240647AbhJHOXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480BB604D2;
        Fri,  8 Oct 2021 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702885;
        bh=6q2yTJ+TQhPACP+8wkdHIGOXx3v45IfrWME5TRHKZCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CUedJ3rEZmLn+ZSl4qm2rvZiBQH88ClU/l1nKBmZnOd89oBJIrdRL/KTxp3gnFZ6C
         ecwyke9EGEs0rJk3qfJkWjpFG47rTeaJjngnl3pgm7EQL1M9copq0EiKA6H8VQYgX0
         IdtYshoIr/YpsBnVXgpv5VfEyJeFctFuUI1jpIgqnzPa9TCrND8JtPSjJcUIyCJBCv
         0SCCCYLJwUtnFjzLT3rAGiacsyykey4w9CIa3dY9y3pNNv0iJfc+4eAcJ1QnG37rbc
         fv+zonvJJrY4uDqPMbxq5pRMcBkz7GxseXbEfhqyojwEDmicRbKmNpbZzaUDHraiKd
         0h7Rwd2xiDVEQ==
Date:   Fri, 8 Oct 2021 07:21:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH v2 01/15] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <20211008072124.58d9885b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWAFP/Uf4LPK2oe6@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
        <20211008002225.2426-2-ansuelsmth@gmail.com>
        <20211007192304.7a9acabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YWAFP/Uf4LPK2oe6@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 10:45:51 +0200 Ansuel Smith wrote:
> On Thu, Oct 07, 2021 at 07:23:04PM -0700, Jakub Kicinski wrote:
> > On Fri,  8 Oct 2021 02:22:11 +0200 Ansuel Smith wrote:  
> > > From Documentation phy resume triggers phy reset and restart
> > > auto-negotiation. Add a dedicated function to wait reset to finish as
> > > it was notice a regression where port sometime are not reliable after a
> > > suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> > > Add dedicated suspend function to use genphy_suspend only with QCA8337
> > > phy and set only additional debug settings for QCA8327. With more test
> > > it was reported that QCA8327 doesn't proprely support this mode and
> > > using this cause the unreliability of the switch ports, especially the
> > > malfunction of the port0.
> > > 
> > > Fixes: 52a6cdbe43a3 ("net: phy: at803x: add resume/suspend function to qca83xx phy")  
> > 
> > Strange, checkpatch catches the wrong hash being used, but the
> > verify_fixes script doesn't. Did you mean:
> > 
> > Fixes: 15b9df4ece17 ("net: phy: at803x: add resume/suspend function to qca83xx phy")
> > 
> > Or is 52a6cdbe43a3 the correct commit hash? Same question for patch 2.
> > 
> > 
> > The fixes have to be a _separate_ series.  
> 
> this series contains changes that depends on the fixes. (the 4th patch
> that rename the define is based on this 2 patch) How to handle that?
> I know it was wrong to put net and net-next patch in the same series but
> I don't know how to handle this strange situation. Any hint about that?

If there is a functional dependency you'll need to send the net changes
first and then wait until the trees are merged before sending net-next
changes. Merge usually happens Thursday afternoon (pacific). You can
post the net-next changes as RFC before the trees get merged to make
sure they are reviewed and ready to go in.

> About the wrong hash, yes I wrongly took the hash from my local branch.

Indeed, looks like our checker got broken hence my confusion.
