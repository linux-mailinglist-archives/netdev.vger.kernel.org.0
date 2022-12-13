Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1385664B445
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiLMLeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiLMLet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:34:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA411B79D;
        Tue, 13 Dec 2022 03:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hKDbF4ofJiHqsJGA4ylrAICZ0zQGFIcCyE1knfmOcuI=; b=Ik2QE9k7/ZPAKTNLj07ElIzlp6
        QPIkoGB8swNZIm8tl8T3hQXhcr3nrNvBFpCcUb+KULaLtgbHarSn+AuFjSj667cjFJUtJB8XF/X3A
        6cxR3vLMIavzcYpa9TRdTGOFD+Tb98AU8io9MIA7jSPQJavCzMyyrmPYZNSuNvW4M4SnBOje0njNm
        xsFtCXq0fqMTUQOM779fHOPAzq5lzyeAFhTlyJgNN51wWFDPnNVuBfvsP36xj0M87RhW0p++AsGG1
        fSsZrvsTiyHKxYadjDaNpHw7hRSeYaFAbsEBKiCY3U14SiYN0dkqWB+vaM+GDaDwHZ8GKRfmwk57M
        o4ZDgwNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35690)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p53YZ-0006mV-Hc; Tue, 13 Dec 2022 11:34:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p53YY-0006PV-DI; Tue, 13 Dec 2022 11:34:42 +0000
Date:   Tue, 13 Dec 2022 11:34:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v6 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y5hjUtQnan/09jRQ@shell.armlinux.org.uk>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
 <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
 <Y5Ypc5fDP3Cbi+RZ@gvm01>
 <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
 <Y5b5lsUfZqeNBSss@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5b5lsUfZqeNBSss@gvm01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 10:51:18AM +0100, Piergiorgio Beruto wrote:
> On Sun, Dec 11, 2022 at 08:34:14PM +0000, Russell King (Oracle) wrote:
> > Please see Documentation/doc-guide/kernel-doc.rst
> > 
> > "Function parameters
> > ~~~~~~~~~~~~~~~~~~~
> > 
> > Each function argument should be described in order, immediately following
> > the short function description.  Do not leave a blank line between the
> > function description and the arguments, nor between the arguments."
> > 
> > Note the last sentence - there should _not_ be a blank line, so please
> > follow this for new submissions. I don't think we care enough to fix
> > what's already there though.
> Fair enough, I'll change this. However, I would suggest to write these
> kind of rules (about following the new style vs keeping consistency with
> what it's there already) to help newcomers like me understanding what
> the policy actually is. I got different opinions about that.

phy.c has two different formats for docbook comments - some of them
are to the documented format, others with the extra blank line. Given
that correct form is without the blank line, new docbook comments
should conform to the standard format.

> > This is a review comment I've made already, but you seem to have ignored
> > it. Please ensure that new contributions are safe. Yes, existing code
> > may not be, and that's something we should fix, but your contribution
> > should at least be safer than the existing code.
> > 
> Russle, I did not actually ignore your comment. Looking back at the
> history, you were commenting on the functions in plca.c and we were
> talking about the global rtnl lock.

Thanks for checking back, you're correct. You can ignore this comment
as it won't make any difference.

Looking at phy_remove(), it wouldn't make any difference anyway, so
please keep the code as-is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
