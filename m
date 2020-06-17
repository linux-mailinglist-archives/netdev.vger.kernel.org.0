Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0760C1FD4F4
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgFQS4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgFQS4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:56:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C455C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v6X5i9Zd0RswLT921kQwQW7vvfFDXt7hoO3MSEXDN3A=; b=L9kvkIHXuGwVtI5wUEd06/6IA
        Qr6GxjXDu1JbOKnZVDpzmVVlkSk2L0Sqjsc0RSaJ81on3/VLaJWTnXUwQAGUi9n7Mp4LfVPAsRz77
        Y/tZ09yKP2+UoAvjhAWD1q5ss9mRFMBL+z+YWVZD/24usMN5OcMJ+p2oyLF51hQrF/pNhAsLGZKKv
        pQ1f5M7f3xV01RW9VKKytp0MJkFpNCqkHwWJy+QW1T1XJnZVvtO8GIC+YMPWY2F7qrhFgZBg8XVBv
        vvZhIvja1RV5mheNPm0e44hQPZI8UTwFR5eIvjAX/rhw05b1kzMVDpgih24VHVrvuF4VTMNZDMqEe
        9wdEyTbPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58594)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jldEF-00040A-VC; Wed, 17 Jun 2020 19:56:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jldEE-0003xn-ML; Wed, 17 Jun 2020 19:56:06 +0100
Date:   Wed, 17 Jun 2020 19:56:06 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Message-ID: <20200617185606.GV1551@shell.armlinux.org.uk>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
 <20200617174930.GU1551@shell.armlinux.org.uk>
 <CAHp75VeP_+2wJUyMThNs6_AbbbVa8qV6KrLDbXD5BYiOkp13qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeP_+2wJUyMThNs6_AbbbVa8qV6KrLDbXD5BYiOkp13qg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 08:54:23PM +0300, Andy Shevchenko wrote:
> On Wed, Jun 17, 2020 at 8:49 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> 
> ...
> 
> > > -     ret = of_address_to_resource(np, 0, &res);
> > > -     if (ret) {
> > > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +     if (!res) {
> > >               dev_err(&pdev->dev, "could not obtain address\n");
> > > -             return ret;
> > > +             return -EINVAL;
> > >       }
> >
> > I think, as you're completely rewriting the resource handling, it would
> > be a good idea to switch over to using devm_* stuff here.
> >
> >         void __iomem *regs;
> >
> >         regs = devm_platform_ioremap_resource(pdev, 0);
> >         if (IS_ERR(regs))
> {
> >                 dev_err(&pdev->dev, "could not map resource: %pe\n",
> >                         regs);
> 
> And just in case, this message is dup. The API has few of them
> depending on the error conditions.

I did try to check for that, but it seems it was rather buried.  This
seems to have been a common mistake, as I've seen patches removing
such things from various drivers, but I'm never sure which require that
treatment.

Maybe adding such details to the kerneldoc for the functions (maybe
actually _writing_ some kernel doc to describe what the functions are
doing) would be a good start to prevent this kind of thing...

There's a difference between the lazy kerneldoc style of:

/**
 * devm_platform_ioremap_resource - call devm_ioremap_resource() for a platform
 *                                  device
 *
 * @pdev: platform device to use both for memory resource lookup as well as
 *        resource management
 * @index: resource index
 */

and the "lets try to be informative" style:

/**
 * phy_lookup_setting - lookup a PHY setting
 * @speed: speed to match
 * @duplex: duplex to match
 * @mask: allowed link modes
 * @exact: an exact match is required
 *
 * Search the settings array for a setting that matches the speed and
 * duplex, and which is supported.
 *
 * If @exact is unset, either an exact match or %NULL for no match will
 * be returned.
 *
 * If @exact is set, an exact match, the fastest supported setting at
 * or below the specified speed, the slowest supported setting, or if
 * they all fail, %NULL will be returned.
 */

;)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
