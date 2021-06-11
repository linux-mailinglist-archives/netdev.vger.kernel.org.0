Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09723A41B5
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhFKMKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFKMKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:10:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED732C0617AF;
        Fri, 11 Jun 2021 05:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9b4NjnnY/G+BJnLJRscB32ZmK4BCv0m+aCZcDteGGuY=; b=hdDWo62YgSsybD3rJr5oMM8qr
        JHg6yt2vu8qYDh6QsYM8qg1UdFZ82JGrg1qeTvb5FqYr6bhmytcH6w6NAS40gQwyBnFB0mLVkiSrU
        uaiDNqMCWDxdAx6Mh2TgJhPTUPurNWGwA5oyyxWNuKknhL+FyAprE1sYmmnEOky3Yo/4W1IRX+Mqf
        hgfdJA3YIhxHlof/NIf9NNnj7KhVOFnBPY8zv2pXTMYmjzMT2yhlAierEgsLqr5NpNCotdMcQvSrU
        vSAzBBABgeY5xapVjSDgU7clz8e0s88ZBFQigyA0OWVhJVebGFHaMlAbnE+gUnA5Z4/LwVHD5EX09
        2uFVa4suA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44918)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lrfxv-0001AA-2y; Fri, 11 Jun 2021 13:08:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lrfxr-0001Hc-Ox; Fri, 11 Jun 2021 13:08:43 +0100
Date:   Fri, 11 Jun 2021 13:08:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v9 03/15] net: phy: Introduce phy related fwnode
 functions
Message-ID: <20210611120843.GK22278@shell.armlinux.org.uk>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-4-ciorneiioana@gmail.com>
 <CAHp75VcfEbMecsGprNW33OtiddVw1MhmOVrtb9Gx4tKL5BjvYw@mail.gmail.com>
 <CAJZ5v0ipvAodoFhU4XK+cL2tf-0jExtMd2QUarMK0QPJQyeJxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0ipvAodoFhU4XK+cL2tf-0jExtMd2QUarMK0QPJQyeJxg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 01:40:59PM +0200, Rafael J. Wysocki wrote:
> I'm not sure why you want the above to be two if () statements instead of one?
> 
> I would change the ordering anyway, that is
> 
> if (!IS_ERR(phy_node) || is_acpi_node(fwnode))
>         return phy_node;
> 
> And I think that the is_acpi_node() check is there to return the error
> code right away so as to avoid returning a "not found" error later.
> 
> But I'm not sure if this is really necessary.  Namely, if nothing
> depends on the specific error code returned by this function, it would
> be somewhat cleaner to let the code below run if phy_node is an error
> pointer in the ACPI case, because in that case the code below will
> produce an error pointer anyway.

However, that opens the door to someone shipping "working" ACPI with
one of these names that we've taken the decision not to support on
ACPI firmware. Surely, it's much better that we don't accept the
legacy names so we don't allow such configurations to work.


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
