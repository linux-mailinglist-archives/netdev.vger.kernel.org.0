Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C8163860
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgBSARy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:17:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33718 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgBSARx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YMouftBNukVfd+V5rq3rc28sLAN21sfUGwSKqETYPcY=; b=jai8NX5zIhRNa/9fDcgdd2Hv5
        eUfirrKbhxqr2p559fPpNPuU78B0Uie0ZJ54k4U5ASkEu4WylLiytSBbq/oqzFFbTI1vhjyZkogWP
        qJdzX5863OJr5R+XdNJvuSJCdTepx7Wg2xWaDXpfoRCYs6DVlkgDG+XpQoZKAcxfjNZ+VY0ro4Ac8
        1+U954mxMVGFohXkPGDLpEI1elfxGoeAcxdUVDZZX4A2sl7UANFH5HI4Lty+R7TfTRBe9sAvAT9wc
        SVcV44mtfOlsBBvnk9rr2JfqXzuntkFHtPciZnm3bMkPxSUMlaKme/jHH68e+JbZstrgrH8b7RiU5
        frVKGj/ng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53868)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4D3b-00024r-9d; Wed, 19 Feb 2020 00:17:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4D3Z-0000ss-4A; Wed, 19 Feb 2020 00:17:37 +0000
Date:   Wed, 19 Feb 2020 00:17:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200219001737.GP25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
> On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > This is a repost of the previously posted RFC back in December, which
> > did not get fully reviewed.  I've dropped the RFC tag this time as no
> > one really found anything too problematical in the RFC posting.
> > 
> > I've been trying to configure DSA for VLANs and not having much success.
> > The setup is quite simple:
> > 
> > - The main network is untagged
> > - The wifi network is a vlan tagged with id $VN running over the main
> >   network.
> > 
> > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
> > setup to provide wifi access to the vlan $VN network, while the switch
> > is also part of the main network.
> 
> Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> Don't add vlans when vlan filtering is disabled")? If a driver wants to
> veto the programming of VLANs while it has ports enslaved to a bridge
> that does not have VLAN filtering, it should have enough information to
> not do that operation.

I do not have the knowledge to know whether reverting that commit
would be appropriate; I do not know how the non-Marvell switches will
behave with such a revert - what was the reason for the commit in
the first place?

The commit says:

    This fixes at least one corner case. There are still issues in other
    corners, such as when vlan_filtering is later enabled.

but it doesn't say what that corner case was.  So, presumably reverting
it will cause a regression of whatever that corner case was...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
