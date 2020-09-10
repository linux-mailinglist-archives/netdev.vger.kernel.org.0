Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61D226542D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgIJVwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgIJVwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:52:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F8CC061573;
        Thu, 10 Sep 2020 14:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fg/b55yxoFWkolyAkcEjzousJpXve06w9VMuL5Sdnkk=; b=ZMcMkaW/c2U4wME0yN3lN8iyq
        Cabjm7Hra/p2QLrT5mmKewtEBX98jKbULNaeCzksnOjXFd/KBPMjWzggqocB6CD3soSxk08QfgkWj
        n9IShJX5HFbbZEejR0jEf+mNi4loEuaPf3zI+zz2liShClwNpC0+1q6T15cbGEijkp+yBWD2tqfjW
        sbvjsE1c0h9pMsh/XzqMtZSYdfSDxQrX8/XS/GPQqcsqDjkuQrVtt1xRqvAF/iAJkp5MRdlrs/gHy
        IgqIc3Q/VXMM0vvUJTXwsBbAHpB+d9p+sH/F9wMsGxVs53ENrxphr7fW4/Qo2vEIBhSJJI8gh1bKv
        N7TWu3fvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32992)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kGUNG-0006e5-W4; Thu, 10 Sep 2020 22:44:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kGUNC-0007bp-S9; Thu, 10 Sep 2020 22:44:54 +0100
Date:   Thu, 10 Sep 2020 22:44:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910214454.GE1551@shell.armlinux.org.uk>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910182434.GA22845@duo.ucw.cz>
 <20200910183154.GF3354160@lunn.ch>
 <20200910183435.GC1551@shell.armlinux.org.uk>
 <20200910223112.26b57dd6@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910223112.26b57dd6@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:31:12PM +0200, Marek Behun wrote:
> On Thu, 10 Sep 2020 19:34:35 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Thu, Sep 10, 2020 at 08:31:54PM +0200, Andrew Lunn wrote:
> > > Generally the driver will default to the hardware reset blink
> > > pattern. There are a few PHY drivers which change this at probe, but
> > > not many. The silicon defaults are pretty good.  
> > 
> > The "right" blink pattern can be a matter of how the hardware is
> > wired.  For example, if you have bi-colour LEDs and the PHY supports
> > special bi-colour mixing modes.
> > 
> 
> Have you seen such, Russell? This could be achieved via the multicolor
> LED framework, but I don't have a device which uses such LEDs, so I
> did not write support for this in the Marvell PHY driver.
> 
> (I guess I could test it though, since on my device LED0 and LED1
> are used, and this to can be put into bi-colour LED mode.)

I haven't, much to my dismay. The Macchiatobin would have been ideal -
the 10G RJ45s have bi-colour on one side and green on the other. It
would have been useful if they were wired to support the PHYs bi-
colour mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
