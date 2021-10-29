Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D643F84C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhJ2H7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhJ2H7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:59:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9652C061570;
        Fri, 29 Oct 2021 00:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9SOc3Ajw2THfmYE3949YDw5L3FUbF+ZvQmbfO7gYLi0=; b=RkhhqsOVlYafm8C8D3/JUaGNfo
        wprONAhMDYdtolBnz4tBefJI2it5q0/C/8+cG6CQppqd8TN1iq2Zwiy9N10t6oRdttX1M4eSu4vSK
        ip3o6ii4EznhkGOLWy8BrHoRvyLMHPC95j3gs9hW3vqFjxBhnU3CKM2UWvmZjRslilYvQBnPiXORs
        0w4aj/vQKISXVWLzDQG0C7Qt8jv1+kVFQnJOlm74GIPBK2n+sK8qKht1XoDXXNK1Sn4wR12H0kdEF
        NcXk8Y86Ts37aBvbVHpWcN+GAEFohneqRdww/stDRR3LkZliZPtikGz5QUYaravBdDG322V0lOK9Z
        iciL+WEA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55370)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mgMl7-0008M3-MU; Fri, 29 Oct 2021 08:57:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mgMl4-0001Rb-Dd; Fri, 29 Oct 2021 08:57:02 +0100
Date:   Fri, 29 Oct 2021 08:57:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <YXupTqhiarSjbwaT@shell.armlinux.org.uk>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
 <20211028164111.521039-7-prasanna.vengateshan@microchip.com>
 <YXrYYL7+NRgUtvN3@shell.armlinux.org.uk>
 <b3c069c8bc9b2f68d4705c04fb010cb4aaa0b29b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3c069c8bc9b2f68d4705c04fb010cb4aaa0b29b.camel@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 08:29:49AM +0530, Prasanna Vengateshan wrote:
> On Thu, 2021-10-28 at 18:05 +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > I've just sent "net: dsa: populate supported_interfaces member"
> > which adds a hook to allow DSA to populate the newly introduced
> > supported_interfaces member of phylink_config. Once this patch is
> > merged, it would be great to see any new drivers setting this
> > member.
> > 
> > Essentially, the phylink_get_interfaces method is called with the
> > DSA switch and port number, and a pointer to the supported_interfaces
> > member - which is a bitmap of PHY_INTERFACE_MODEs that are supported
> > by this port.
> > 
> > When you have set any bit in the supported interfaces, phylink's
> > behaviour when calling your lan937x_phylink_validate changes - it will
> > no longer call it with PHY_INTERFACE_MODE_NA, but will instead do a
> > bitwalk over the bitmap, and call it for each supported interface type
> > instead.
> > 
> > When phylink has a specific interface mode, it will continue to make a
> > single call - but only if the interface mode is indicated as supported
> > in the supported interfaces bitmap.
> > 
> > Please keep an eye on "net: dsa: populate supported_interfaces member"
> > and if you need to respin this series after that patch has been merged,
> > please update in regards of this.
> 
> Sure, i will watch out for this series and add to my new driver. Do the 
> new drivers need to still return all supported modes if state->interface
> is set to %PHY_INTERFACE_MODE_NA as per phylink documentation? I 
> understand that supported_interfaces will not be empty if
> phylink_get_interfaces() is handled. But i just wanted to double check
> with you.

The phylink documentation has already been updated:

 * When @config->supported_interfaces has been set, phylink will iterate
 * over the supported interfaces to determine the full capability of the
 * MAC. The validation function must not print errors if @state->interface
 * is set to an unexpected value.
 *
 * When @config->supported_interfaces is empty, phylink will call this
 * function with @state->interface set to %PHY_INTERFACE_MODE_NA, and
 * expects the MAC driver to return all supported link modes.

As I state in my initial reply, ->validate will never be called with
PHY_INTERFACE_MODE_NA if supported_interfaces is populated.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
