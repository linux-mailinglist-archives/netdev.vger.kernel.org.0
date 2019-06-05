Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C15358E1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 10:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfFEIpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 04:45:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53378 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfFEIpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 04:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zAEKAkaJlWSdynEyHK37EvVVVoaBFWEA4Jbok8Skl2E=; b=OY/Khl/nFLTM0SWuQIKwRiFx5
        Gi5dVUrCyvIvldyo2/lhvWmfOLbioe9NiGhpqLBIzkp1EZnoxr0iSnRJPULoBDxHe6q11Uas7zDPj
        mLo0NY2vRsqQugXXy+5lRWNMYPbU2CsVnPVNI4+eNQSt7cpdCzYc/nEOl/layS4GLpnvc+9JViCEu
        TdEhKtBNXLW2mF+hFvo5SGfNGrQaEEwqjCWrnzXnq2wIffJyAsRPwBPpu8vqZ6sUyf5VHVZ/1YZ+Y
        zAqnn1IN5LoIMlMEmq3j0DUPJ2LvbnrD/skI99E28FLKDkcWeW6B1AHUIkBHVrzfnDEEW3QfLfdP5
        roJ9iSTXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52866)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYRXc-0006j2-0p; Wed, 05 Jun 2019 09:45:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYRXY-0002IP-Ly; Wed, 05 Jun 2019 09:45:00 +0100
Date:   Wed, 5 Jun 2019 09:45:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190605084500.pjkq43l4aaepznon@shell.armlinux.org.uk>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604213624.yw72vzdxarksxk33@shell.armlinux.org.uk>
 <33c5afc8-f35a-b586-63a3-8409cd0049a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33c5afc8-f35a-b586-63a3-8409cd0049a2@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 07:25:46PM -0700, Florian Fainelli wrote:
> On 6/4/2019 2:36 PM, Russell King - ARM Linux admin wrote:
> > Normally the PHY receives traffic, and passes it to the MAC which
> > just ignores the signals it receives from the PHY, so no processing
> > beyond the PHY receiving the traffic happens.
> > 
> > Ultimately, whether you want the PHY to stay linked or not linked
> > is, imho, a policy that should be set by the administrator (consider
> > where a system needs to become available quickly after boot vs a
> > system where power saving is important.)  We don't, however, have
> > a facility to specify that policy though.
> 
> Maybe that's what we need, something like:
> 
> ip link set dev eth0 phy [on|off|wake]
> 
> or whatever we deem appropriate such that people willing to maintain the
> PHY on can do that.

How would that work when the PHY isn't bound to the network device until
the network device is brought up?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
