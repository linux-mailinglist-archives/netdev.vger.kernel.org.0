Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C551C5601A4
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiF2Nog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiF2No2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:44:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC6C165AA;
        Wed, 29 Jun 2022 06:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iNNpZQ4J4NP0iLtyPz5n241klxoCoQZ9heLmCzkZuyg=; b=TwsloGtjAMMljfnpdRox6V4P/a
        wbtHRFasAHZBA1hoamnYFBUBJAFhjoW3j5sL1zQGXw0Sujv/quxmbPZ1xUFTwQFpM4XvfL2SoR5/A
        SUDcbrmEZCvEWqOM6TZMAJ5PwcLwitZa3TxtLXd24SZaQNT9EfsPSUkDl1U5bLimTCFxY9BzmnKan
        VD7xTpwofgjxuO5CcmZfejlFQx1XGU1XH6+07oMpoCD3AzXr1Wp34hpg5PS7qtAoDkSAos4xvBLbW
        6/sDxE8MHzzwtpw2/3XyAAbXu0EjBDD2FnCpoKR9fK99s/Htoo9vFflVRfwydHfx1SFqSdyBiPbFq
        f8mOlvsg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33098)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6XzO-0003E8-I3; Wed, 29 Jun 2022 14:44:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6XzL-0005tn-Qa; Wed, 29 Jun 2022 14:44:15 +0100
Date:   Wed, 29 Jun 2022 14:44:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Divya Koppera <Divya.Koppera@microchip.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding LED feature for
 LAN8814 PHY
Message-ID: <YrxXL/p3q35SsXmk@shell.armlinux.org.uk>
References: <20220628054925.14198-1-Divya.Koppera@microchip.com>
 <YrsRUd6GPG0qCJsw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrsRUd6GPG0qCJsw@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 04:33:53PM +0200, Andrew Lunn wrote:
> On Tue, Jun 28, 2022 at 11:19:25AM +0530, Divya Koppera wrote:
> > LED support for extended mode where
> > LED 1: Enhanced Mode 5 (10M/1000M/Activity)
> > LED 2: Enhanced Mode 4 (100M/1000M/Activity)
> > 
> > By default it supports KSZ9031 LED mode
> 
> You need to update the binding documentation.

What happened to "use the LEDs interface, don't invent private bindings
for PHY LEDs" ?

Does this mean the private bindings are now acceptable and I can
resubmit my 88x3310 LED support code?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
