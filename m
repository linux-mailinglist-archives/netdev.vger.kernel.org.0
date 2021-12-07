Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6CF46BC6A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhLGN1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhLGN1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:27:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95C3C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 05:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WP7TGJtm116ETtLFhB6s2Gub9tdFYZdLdSFJ8AqMkkQ=; b=ihYwNXCqTANrZXkMfiPqELviGt
        Houl9w+bo7Ho2dl6JzPY+UGs9AX9gOyN2yznrGIv4Aok/SUqrXRzUM33IuNkmMKe+M0FSSD1fazUe
        Wu0a+qRyAPnbPu2L0VVQyLFkL+/oAp8AAePTiMnxpAzRgQxnhiFP1K5uB0YMkKI1NdQoFf+7vG0u8
        gE+o4ykYtqQxyb1xTIISOPLBd6oVPIHJj232/g2C9K/YiKLkMcpi/JaVExs1f3bXAi2VaPgK0abHf
        CrqYq2zr3TEn5KCmTGdj6nKeIzBG+usCOjTGes5Hy5Ll8kIMnQdW15Tyv4bf6OUgSqkS5rgkhHVDQ
        LZGTAgYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56152)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muaS7-0006Dl-CR; Tue, 07 Dec 2021 13:24:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muaS5-0005MQ-VA; Tue, 07 Dec 2021 13:24:13 +0000
Date:   Tue, 7 Dec 2021 13:24:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maarten Zanders <maarten.zanders@mind.be>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on
 internal PHY's"
Message-ID: <Ya9gfZdbcfn11IsG@shell.armlinux.org.uk>
References: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
 <f68a2913-779b-65b7-0dac-27a2c4521c42@mind.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68a2913-779b-65b7-0dac-27a2c4521c42@mind.be>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 02:22:56PM +0100, Maarten Zanders wrote:
> On 12/7/21 11:32, Russell King (Oracle) wrote:
> > Maarten Zanders has confirmed that the issue he was addressing was for
> > an 88E6250 switch, which does not have a PHY_DETECT bit in bit 12, but
> > instead a link status bit. Therefore, mv88e6xxx_port_ppu_updates() does
> > not report correctly.
> ...>    Yes, you're right, I'm targeting the 6250 family. And yes, your
> >    suggestion would solve my case and is a better implementation for
> >    the other devices (as far as I can see).
> 
> I confirm that this patch works on my hardware, which uses an 88E6071
> (88E6250 family).

Thanks for testing! Would you be able to supply a Tested-by:
attributation for the patch, so your confirmation can be recorded in
the commit please?

Thanks again.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
