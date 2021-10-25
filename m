Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D04393D4
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhJYKhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhJYKhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 06:37:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7319C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 03:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hXr3ZfHRdipw2FwWVZwHgT7wSRJxpXRa6uuA9+i4ii0=; b=eV1uKnUduXDKNZd5PryrFAyW0x
        j+AoJqrJHfUD97I/UsOrg3cA2qarIzVAAMfawI1cWUIu2eUpxuUzs6lcxYA3LU6GdA5n48uuItQga
        NcvhN2EgCzmar0LEh34fw/ulvWV8A2j0WNDU09PSsx8M4dSMNov1/jchzWMgh5vnWLce1/tqRxDQj
        rnRTyDts7M1F/7242mYzgxM+FLWjTswcaKosi4etJCVFOB9cYFKMTshj3w/+6AAUkdhwP4QLUyK9D
        lVYuFdvY4HdPhRXTye2OSnp31Z7g9gHIRZFqrs41M2p1eBH+olLeaXEHkiMP1xQx510HaWXUmBTtd
        rfmvQi3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55278)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mexJq-00045k-TF; Mon, 25 Oct 2021 11:35:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mexJo-0003tr-Tw; Mon, 25 Oct 2021 11:35:04 +0100
Date:   Mon, 25 Oct 2021 11:35:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <YXaIWFB8Kx9rm/j9@shell.armlinux.org.uk>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
 <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
 <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
 <YW7d+qm/hnTZ80Ar@shell.armlinux.org.uk>
 <24d336d7-9c6f-55bc-34dd-ddd796ef8234@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24d336d7-9c6f-55bc-34dd-ddd796ef8234@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 01:37:34PM -0400, Sean Anderson wrote:
> Hi Russell,
> 
> For "net: phy: add phy_interface_t bitmap support", phylink_or would be
> nice as well. I use it when implementing NA support for PCSs.

I think you actually mean phy_interface_or(). Given that we will need
MAC drivers to provide the union of their PCS support, I think that
would be a sensible addition. Thanks.

> For "net: sfp: augment SFP parsing with phy_interface_t bitmap",
> drivers/net/phy/marvell.c also needs to be converted. This is due to
> b697d9d38a5a ("net: phy: marvell: add SFP support for 88E1510") being
> added to net-next/master.
> 
> (I think you have fixed this in your latest revision)

I haven't - but when I move the patch series onto net-next, that will
need to be updated.

> "net: phylink: use supported_interfaces for phylink validation" looks
> good. Though the documentation should be updated. Perhaps something
> like

Yes, I haven't bothered with the doc updates yet... they will need to
be done before the patches are ready. Thanks for the suggestions though.

> I think "net: macb: populate supported_interfaces member" is wrong.
> Gigabit modes should be predicated on GIGABIT_MODE_AVAILABLE.

It is a conversion of what macb_validate() does - if the conversion is
incorrect, then macb_validate() is incorrect.

If MACB_CAPS_GIGABIT_MODE_AVAILABLE isn't set, but MACB_CAPS_HIGH_SPEED
and MACB_CAPS_PCS are both set, macb_validate() will not zero the
supported mask if e.g. PHY_INTERFACE_MODE_10GBASER is requested - it
will indicate 10baseT and 100baseT speeds are supported. So the current
macb_validate() code basically tells phylink that
PHY_INTERFACE_MODE_10GBASER supports 10baseT and 100baseT speeds! 

This probably is not what is intended, but this is what the code does,
and I'm maintaining bug-compatibility with the current macb_validate()
implementation. Any changes to the behaviour should be a separate
patch - either fixing it before this patch, or fixing it afterwards.
As the series is currently based on v5.14, it may be that this has
already been fixed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
