Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48673746F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfFFMmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:42:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbfFFMmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yf+2kJuG6Nm4IGEGpPNiVHJv2buxOmnkj+VMHOYrIU4=; b=l4Ac7j1WAdE2oft5iXvNZrn6cj
        NGHUwS60zUvsS5Ocrrs/mMCwDTacSpBURXSc6EEYK/E1X0gTn27dkIBOCNnPYDBNIMT9xazqUeirR
        9E5BRT43/Hkqa8MxG4Z4MSS0iR379hA710gzZsnDTcBYKZBYRxiROo5i6X6kk8KapV7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYrik-0005eS-6b; Thu, 06 Jun 2019 14:42:18 +0200
Date:   Thu, 6 Jun 2019 14:42:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606124218.GD20899@lunn.ch>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:59:19AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 05, 2019 at 06:48:27PM -0700, David Miller wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> > Date: Wed, 05 Jun 2019 11:43:16 +0100
> > 
> > > +	    (state == PHY_UP || state == PHY_RESUMING)) {
> > 
> > drivers/net/phy/marvell10g.c: In function ‘mv3310_link_change_notify’:
> > drivers/net/phy/marvell10g.c:268:35: error: ‘PHY_RESUMING’ undeclared (first use in this function); did you mean ‘RPM_RESUMING’?
> >       (state == PHY_UP || state == PHY_RESUMING)) {
> >                                    ^~~~~~~~~~~~
> >                                    RPM_RESUMING
> > drivers/net/phy/marvell10g.c:268:35: note: each undeclared identifier is reported only once for each function it appears in
> > At top level:
> > drivers/net/phy/marvell10g.c:262:13: warning: ‘mv3310_link_change_notify’ defined but not used [-Wunused-function]
> >  static void mv3310_link_change_notify(struct phy_device *phydev)
> >              ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Hmm. Looks like Heiner's changes in net-next _totally_ screw this
> approach - it's not just about PHY_RESUMING being removed, it's
> also about the link change notifier being moved. :(

Hi Russell

The link change notifier still seems to be called, and it is still
part of the phy_driver structure.

Please could you be more specific about what changes Heiner made which
causes this patch problems?

       Thanks
	Andrew
