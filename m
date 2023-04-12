Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE076DECF7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjDLHvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDLHvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:51:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EED59FF;
        Wed, 12 Apr 2023 00:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WDasEsbrZhq6Y6NIih1XXwyVWPjBSJhq2DHjFCLMKyU=; b=fFqzuowZKwSTde6gG9QCNF4AeM
        wFNcTZtQuE/+ZJKEE1xmzTEG3bJCxaTw2LqZKs9ElseEkHen+IU6tU7YdSeOo1YWgc7QTqj0N1d+t
        7deQ2ITZBv+gbdo5Uv5xrYSSGDNiBzUaI1OKVu5a1gmxeZXLuLhI7ML2VEqXQsSf5BW1+g91fFmil
        9tVV+nxo69zsc4OoJ3zFxKQ34kU9hNDaXyoty9P/7PwGB6zLk2HdnCGAvwpm1J2Y+c2jk7ghylFOO
        gzAOm1mVq6vXnfsiSLvPH1R4oae1MHK+++Vp2SoZZAUrpKdiXWsDEJ69RZ3u139Bqw+vwoY5KQAMv
        Zps9iteg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48782)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmVGJ-0007f7-CV; Wed, 12 Apr 2023 08:51:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmVGD-0004wd-Rw; Wed, 12 Apr 2023 08:51:21 +0100
Date:   Wed, 12 Apr 2023 08:51:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32 @ st-md-mailman . stormreply . com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "alexis . lothore @ bootlin . com" <alexis.lothore@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: phylink: check for SFP bus presence in
 phylink_expects_phy
Message-ID: <ZDZi+fs13A8JJFOs@shell.armlinux.org.uk>
References: <20230412074850.41260-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412074850.41260-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 09:48:50AM +0200, Maxime Chevallier wrote:
> When an SFP bus is present, we don't expect a PHY to be attached
> directly from the MAC driver, it will be handled by phylink at SFP
> attach time.

If we have a SFP, then phylink should be configured for in-band mode.
Maybe fix the firmware description instead?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
