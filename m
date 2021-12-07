Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577ED46BA62
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 12:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhLGLwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 06:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhLGLwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 06:52:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EBC061574;
        Tue,  7 Dec 2021 03:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=80kReiUlwekNbojqIZKz80Q8wRHoH2sdw+ED92mwvfs=; b=aJKv259UGKNYmARmx6J1Mfsp1O
        l32NaB4CHTd81W2usVx5wD5sqbeFGlQzqdu4fEYj0g1lT1uWMzqf6Bq5Z7sC1B+nrXNO2IEEmMlsU
        0RQQhWC3uYYxQW6hSQ91/ftqFS5sViIWZAhjJLM0jmnyl1B8okT4f5YeKio/uJz4TeCOb7K1oTDUZ
        yhnhlM/vAuNfgb14x1AeMH7Gc1coo4CqjgXuqNeV4WjTxSll+dG+mJupWlOugYTvlvdz6zNy5RB+I
        agupslukVpNtAgTBBwtiOFjWlELUk2tUPIc/k/L02krNZtSdEnr2QfEQsHnMplMN8qYtMftY97Fl3
        q71jRTAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56144)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muYxt-00066Q-OO; Tue, 07 Dec 2021 11:48:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muYxo-0005IY-Uo; Tue, 07 Dec 2021 11:48:52 +0000
Date:   Tue, 7 Dec 2021 11:48:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Message-ID: <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
 <20211204182858.1052710-6-colin.foster@in-advantage.com>
 <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:09:22PM -0800, Jakub Kicinski wrote:
> On Sat,  4 Dec 2021 10:28:58 -0800 Colin Foster wrote:
> > Expose ocelot_wm functions so they can be shared with other drivers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Yeah.. but there are no in-tree users of these. What's the story?
> 
> I see Vladimir reviewed this so presumably we trust that the users 
> will materialize rather quickly?

Thank you for highlighting this.

Vladimir told me recently over the phylink get_interfaces vs get_caps
change for DSA, and I quote:

  David who applied your patch can correct me, but my understanding from
  the little time I've spent on netdev is that dead code isn't a candidate
  for getting accepted into the tree, even more so in the last few days
  before the merge window, from where it got into v5.16-rc1.
  ...
  So yes, I take issue with that as a matter of principle, I very much
  expect that a kernel developer of your experience does not set a
  precedent and a pretext for people who submit various shady stuff to the
  kernel just to make their downstream life easier.

This sounds very much like double-standards, especially as Vladimir
reviewed this.

I'm not going to be spiteful NAK these patches, because we all need to
get along with each other. I realise that it is sometimes useful to get
code merged that facilitates or aids further development - provided
that development is submitted in a timely manner.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
