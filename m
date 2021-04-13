Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE535DFEA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345911AbhDMNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344864AbhDMNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:17:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF5FC061574;
        Tue, 13 Apr 2021 06:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ropDLcpP7yGMVkAD0I4OVyDHA5X+bljerlASzUM5/t4=; b=OMSN+h+FUy4gJad4fIayGztOV
        DPqnvkCshZXI0TrarQzoTKRJCIwoIAQ2cju0aFm/1JyfVcfhIJNDTtpOek7FZ57nHCuWQeDF0Susj
        75aCxTLBIh09DCJhV2LkMrEDZzAppbSEYKp6T8lbpXiDSs2Tz+EvSyMNWHfOJY07/OLdwwmeT7khF
        szjhCWzJWizxCewqVRQjOBTbRWJQ0V+w0VXa15pLyyJUBf9XQ4A0tGyR97uHxANdS31IXfavVNDgx
        sIfeEzcgfMWTml6CT30hfMpxHDYAPjDb3pKbvqIooGDqx1J/altiA23UY7XfSimj903GMyYPSaO9+
        4NNK2ZbZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52382)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lWIuN-0005g7-3Y; Tue, 13 Apr 2021 14:16:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lWIuM-0008DZ-HQ; Tue, 13 Apr 2021 14:16:46 +0100
Date:   Tue, 13 Apr 2021 14:16:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413131646.GQ1463@shell.armlinux.org.uk>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <YHTacMwlsR8Wl5q/@lunn.ch>
 <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
 <20210413092348.GM1463@shell.armlinux.org.uk>
 <YHWYpQhjxKBjRvC3@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHWYpQhjxKBjRvC3@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Apr 13, 2021 at 03:12:05PM +0200, Andrew Lunn wrote:
> Is there something like this in the marvell10 driver?

No, it doesn't seem to be necessary there - I haven't seen spontaneous
link-ups with the 88x3310 there. Even if we did, that would cause other
issues beyond a nusience link-up event, as the PHY selects the first
media that has link between copper and fiber (and both are present on
Macchiatobin platforms.)

If the fiber indicates link up, it would prevent a copper connection
being established.

> Also, do you know when there is an SFP cage? Do we need a standardised
> DT property for this?

phydev->sfp_bus being non-NULL?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
