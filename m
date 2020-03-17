Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2060188749
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCQOSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:18:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgCQOSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nS2ZJXHGOoT2swC2Sa1bt6KvmtactSt/e8SM+EuN6qw=; b=RzLWBztiHvQzfIjr8pdo09xf9a
        NfuoyAjRNYmH+W/cTzU6mABCB8DkhP1hs23UNO1DvNppGC0zf9DTEte1vxqWdBrkm0xpUa9QE1ZuW
        SvKh1OicZfjbNWyDCTL4wVZdJnUZUHMsWkirCvMdrFi9GWrycHvt6oSRBDxVVbp4l0Mw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jED3H-0006rb-28; Tue, 17 Mar 2020 15:18:39 +0100
Date:   Tue, 17 Mar 2020 15:18:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH REPOST3 net-next 0/3] net: add phylink support for PCS
Message-ID: <20200317141839.GT24270@lunn.ch>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
 <20200314220018.GH8622@lunn.ch>
 <20200314224459.GL25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314224459.GL25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:44:59PM +0000, Russell King - ARM Linux admin wrote:
> On Sat, Mar 14, 2020 at 11:00:18PM +0100, Andrew Lunn wrote:
> > On Sat, Mar 14, 2020 at 10:31:02AM +0000, Russell King - ARM Linux admin wrote:
> > > Depends on "net: mii clause 37 helpers".
> > > 
> > > This series adds support for IEEE 802.3 register set compliant PCS
> > > for phylink.  In order to do this, we:
> > > 
> > > 1. add accessors for modifying a MDIO device register, and use them in
> > >    phylib, rather than duplicating the code from phylib.
> > > 2. add support for decoding the advertisement from clause 22 compatible
> > >    register sets for clause 37 advertisements and SGMII advertisements.
> > > 3. add support for clause 45 register sets for 10GBASE-R PCS.
> > 
> > Hi Russell
> > 
> > How big is the patchset which actually makes use of this code? It is
> > normal to add helpers and at least one user in the same patchset. But
> > if that would make the patchset too big, there could be some leeway.
> 
> The minimum is three patches:
> 
> arm64: dts: lx2160a: add PCS MDIO nodes
> dpaa2-mac: add 1000BASE-X/SGMII PCS support
> dpaa2-mac: add 10GBASE-R PCS support

Hi Russell

Are the two dpaa2-mac changes safe without the DT changes? I guess
so. So it seems sensible to post a set of 5 patches.

> and, at the moment, depending on whether you want 1G or 10G speeds,
> changes to the board firmware to select the serdes group mode.

And this is where we start speculating. I guess a new firmware API
will be needed to allow for runtime selection of the serdes group
mode. But i guess such an API change would not invalidate the PCS
work?  There is still likely to be two PCS. So it seems O.K. to merge
this, and then fix it up later to work with whatever is added to the
firmware. There is on KAPI involved here?

	Andrew
