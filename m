Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9F6A1F13
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjBXP6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXP60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:58:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44068233CE
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v6xD6+0GStSloZawr5RqvURi52Nlz26it1cx8NtjoZc=; b=VF0ab3ZQRMQaoRchW8hi6q846w
        0859q2eI7wjctlQ98Xh/6MtAMfUXHwkiqlBZ7i53D+OW26larFcz2+thuT5B8z+0KWJMrZ7hg/qVn
        KROHAe1tHHxMeAfa1OjqU8LgebDYuiQb2mzpzjQQ3yeQWCyoEIekgpLCrU5XGQZAPXKW7jNOeZyeF
        PQdsau03r/saoPl0CcX/9SBV3bBlOpKki3b0BTlKzgBKJx2grxwwOQBA0B6/mt+UyuI85y74Z/IwI
        hy9WOa+vCV+ui0kMqK3VqGa+MANu4QCUwVTHY0WIFmI9emvSAtaWunPiL6J/vAyZFX98NwryvQL3N
        Z2xywKFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34006)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pVaSi-0000py-4l; Fri, 24 Feb 2023 15:58:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pVaSd-0005X4-2i; Fri, 24 Feb 2023 15:58:15 +0000
Date:   Fri, 24 Feb 2023 15:58:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <Y/jel+aPo4PkWc1g@shell.armlinux.org.uk>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224155235.512695-4-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 05:52:35PM +0200, Vladimir Oltean wrote:
> When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
> and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
> be printed:
> 
> [    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...
> 
> Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
> duplication, and update the mfd_cell entry for its resources.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I'll also send another patch to delete linux/phylink.h from
ocelot_ext.c - seems that wasn't removed when the phylink instance
was removed during review.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
