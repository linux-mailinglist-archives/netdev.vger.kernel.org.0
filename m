Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFA1652F0F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiLUJ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiLUJ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:58:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE82F233B3;
        Wed, 21 Dec 2022 01:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LXTjxNIwyTamcsYiCUb1qbSp8dawRiYmOqWzEm2gekI=; b=ln8ec5+mDsvVeVkYSdnkkKkSyL
        SZXC7xhjFUriKXcoax4iKbHOBqvEK+SXuneJWVll3OY6YVNzsnKSg5y20qCmb3nFPkAw8h4vwDTB8
        2R6mvqzk1nJ19+pSPicHHwCsf1FO5eJnSYbRIHXmbbW7NKzouJgccP7nbXs1YmEbOX8LWq/rSo/IS
        KlFf+S5I3eD2a2BzZqskDzKriDhfusCBD1wPwCzF3MVFTDUj3G8ZU1gSouJlNMuHvWa4lcwCLTlhX
        ntwkPH3nPstYgrYkSNEt8zrxOuldgsLxd7U6u/cONukLoCzBlFq2BhJpHgEkQ3oIcEUXiQMtXdDKV
        +16P8nww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35800)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p7voG-0000TN-KP; Wed, 21 Dec 2022 09:54:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p7voB-0006Rt-Mc; Wed, 21 Dec 2022 09:54:43 +0000
Date:   Wed, 21 Dec 2022 09:54:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
Message-ID: <Y6LX43poXJ4k/7mv@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
 <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
 <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
 <Y6JMe9oJDCyLkq7P@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6JMe9oJDCyLkq7P@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 12:59:55AM +0100, Andrew Lunn wrote:
> > > One thought on this approach though - if one has a PHY that supports
> > > "activity" but not independent "rx" and "tx" activity indications
> > > and it doesn't support software control, how would one enable activity
> > > mode? There isn't a way to simultaneously enable both at the same
> > > time... However, I need to check whether there are any PHYs that fall
> > > into this category.
> > >
> > 
> > Problem is that for such feature and to have at least something working
> > we need to face compromise. We really can't support each switch feature
> > and have a generic API for everything.
> 
> I agree we need to make compromises. We cannot support every LED
> feature of every PHY, they are simply too diverse. Hopefully we can
> support some features of every PHY. In the worst case, a PHY simply
> cannot be controlled via this method, which is the current state
> today. So it is not worse off.

... and that compromise is that it's not going to be possible to enable
activity mode on 88e151x with how the code stands and with the
independent nature of "rx" and "tx" activity control currently in the
netdev trigger... making this whole approach somewhat useless for
Marvell PHYs.

We really need to see a working implementation for this code for more
than just one PHY to prove that it is actually possible for it to
support other PHYs. If not, it isn't actually solving the problem,
and we're going to continue getting custom implementations to configure
the LED settings.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
