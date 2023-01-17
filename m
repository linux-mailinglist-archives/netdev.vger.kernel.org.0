Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4491266E5F6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjAQS3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjAQS1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:27:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C60F45BF7;
        Tue, 17 Jan 2023 09:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oTQ51UdTzrcO70uhBDlVnjUBjeBv3ulnXFGtTiGIm0k=; b=T+nS/B++wLjSplKMC1zkLdoVCy
        zlTMepyVcgrVjUvgmzLOniKFcoIDT9QmRogGeAob6c9cOy+2VluTCn5AHsufqp/nOtq2HxM/GPPgz
        Bb6Kq/kqlh18qtJPCV+JJc4PwahXaSZz9s8mBG17OtrgQrXDVHZ1xwLrMsOO0gnnuU+bbiFpvcnYT
        oVCqkjPSNIHC5P8LiyjStPbDusChy3qM8i1IZbq5OozthAVMuyUCIZ0Og6vkfxo9+dtqZwJxGz9fp
        k5D6QGoFM6N5dZj4hT6pO4zylc5wCLgtY0/gk67ciyQevkbPmEr7Sg1z2GhwUuFL68nQcmWzwMFMw
        JMDpA5Cg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36164)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHqEN-0008Cm-SG; Tue, 17 Jan 2023 17:58:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHqEH-0007Ag-CE; Tue, 17 Jan 2023 17:58:37 +0000
Date:   Tue, 17 Jan 2023 17:58:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Landen.Chao@mediatek.com, Samer.El-Haj-Mahmoud@arm.com,
        andrew@lunn.ch, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, jaz@semihalf.com, kuba@kernel.org,
        linus.walleij@linaro.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        olteanv@gmail.com, pabeni@redhat.com, rafael@kernel.org,
        sean.wang@mediatek.com, tn@semihalf.com, vivien.didelot@gmail.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <Y8bhzex/k05i9NCQ@shell.armlinux.org.uk>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
 <CAPv3WKcbuY0kmM0trfS++at=r4KhCsp2bZ1kBL2r+-YJe=kE3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKcbuY0kmM0trfS++at=r4KhCsp2bZ1kBL2r+-YJe=kE3w@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Tue, Jan 17, 2023 at 05:20:01PM +0100, Marcin Wojtas wrote:
> Hi Russell,
> 
> 
> pon., 16 sty 2023 o 18:50 Russell King (Oracle) <linux@armlinux.org.uk>
> napisał(a):
> >
> > On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > > fixed-link PHYs API is used by DSA and a number of drivers
> > > and was depending on of_. Switch to fwnode_ so to make it
> > > hardware description agnostic and allow to be used in ACPI
> > > world as well.
> >
> > Would it be better to let the fixed-link PHY die, and have everyone use
> > the more flexible fixed link implementation in phylink?
> >
> ,
> This patchset did not intend to introduce any functional change, simply
> switch to a more generic HW description abstraction. Killing
> of/fwnode_phy_(de)register_fixed_link entirely seems to be a challenge, as
> there are a lot of users beyond the DSA. Otoh I see a value in having
> of_/fwnode_phy_is_fixed_link check, afaik there is no equivalent in
> phylink...

Phylink provides a much improved implementation of fixed-link that is
way more flexible than the phylib approach - it can implement speeds
in excess of 1G. DSA already supports phylink with modern updated
drivers that do not use the "adjust_link" implementation.

What I'm proposing is that we don't bring the baggage of the phylib
based fixed link forwards into fwnode, and leave this to be DT-only.
I think this is what Andrew and Vladimir have also said.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
