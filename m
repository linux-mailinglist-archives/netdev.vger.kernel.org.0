Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95144F90C8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiDHIcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiDHIcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:32:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DE82FF507
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LJZmQO2qwNsGWatXKQzA4vWPXRwJPPzxinQqe8QfQ3w=; b=ZYEenVqvGP1xlSx4F6Uu0V3dj7
        jNBxvqMpNgNSJNkkE5EGDmNibBbaYMs66q+wk3I5PQQBzY6nY3Ks90fhwwRgi0cPEEiB14NdNc3zD
        oSD8YIWaz+KSZtX2vDjisDe3H9f9+Qxow8NTgnYdLwMYNVeSqrccU31rragrv4aG5iTKADdjVdiix
        oaIV4huIs7jaBUOGd9bL65U+dM3YvqdP4aDAExmuCeEkmzJ+aY6NbtPm2X+Ha8ACUcpe9E8coA8Dc
        p0uGz20cqBkHsixLhiQYWnIxHrFLLy3XxRkdBAbDobF9lnRLLk2UIAStSOJu7XPfNPHb2z8Jpt+oj
        cAMmU61g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58170)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nck0K-0005h3-Ra; Fri, 08 Apr 2022 09:30:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nck0I-0006ta-DQ; Fri, 08 Apr 2022 09:30:02 +0100
Date:   Fri, 8 Apr 2022 09:30:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: dsa: b53: convert to phylink_pcs
Message-ID: <Yk/yiv36t6QrhHBk@shell.armlinux.org.uk>
References: <E1nc7F6-004lEo-Be@rmk-PC.armlinux.org.uk>
 <f60b3515-d1a5-a5a8-9a3f-4cb82cd0a586@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60b3515-d1a5-a5a8-9a3f-4cb82cd0a586@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 03:55:35PM -0700, Florian Fainelli wrote:
> On 4/6/22 08:06, Russell King (Oracle) wrote:
> > Convert B53 to use phylink_pcs for the serdes rather than hooking it
> > into the MAC-layer callbacks.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> > Hi Florian,
> > 
> > Please can you test this patch? Thanks.
> 
> Did not spend much time debugging this as I had to do something else but
> here is what I got:
> 
> [    1.909223] b53-srab-switch 18036000.ethernet-switch: SerDes lane 0,
> model: 1, rev B0 (OUI: 0x0143bff0)
> [    1.918956] 8<--- cut here ---
> [    1.922119] Unable to handle kernel NULL pointer dereference at virtual
> address 0000012c

Thanks - it looks like the problem is dev->port has not been allocated
at the point where b53_serdes_init is called, causing this null pointer
deref. It's allocated in b53_switch_register(), which is also where the
driver works out how many ports there are.

I don't see an easy way to allocate this array earlier... so, where can
we save a pointer to the PCS. I guess as this is specific to srab, we
could put it in struct b53_srab_port_priv - but then we'll need
b53_phylink_mac_select_pcs() to call into the e.g. the srab layer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
