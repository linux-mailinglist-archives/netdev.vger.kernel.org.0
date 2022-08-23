Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7C59EF70
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiHWWt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiHWWt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:49:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795DD8A6FF;
        Tue, 23 Aug 2022 15:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/4z+pJZ8j5MKGAOmX2Jx8tKfWpwpcaLXxTeahMGzcA0=; b=rTrYnH6iBBt+kheY76MVf+6UPg
        Wmb6dgoHWTX8nEk/iOHI7Lfc2gsPRINh6BwZtvxxw8kLzGMIkloke1wWCV7BayAtmIBhku1wLJL6R
        EUIJNYIGq+ke89tNVhCD4lghS5cuc54afokDuVkEGju2AjLSaoLiwbrTOmobgEVw2vWTktE+Ocf7f
        Esuw6inCCvWst219bcJFA9Z1jXdogiSNvq7ardooxSi7mgO5Bo0MGbBSzFSqeEv0URSFSCueT1Hdh
        qlZw9OrRtNYNs2gKxyW5hNlFwVhulOLfud+ilpghPVn6o1hm5+48/9OI2THp7et1G210+b4QMEwq7
        2ISIqSYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33904)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQchz-0003cr-N4; Tue, 23 Aug 2022 23:49:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQchx-0003WF-JW; Tue, 23 Aug 2022 23:49:17 +0100
Date:   Tue, 23 Aug 2022 23:49:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Qingfang DENG <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: allow RGMII/RTBI in-band status
Message-ID: <YwVZbQrRiBT5SkGv@shell.armlinux.org.uk>
References: <20220819092607.2628716-1-dqfext@gmail.com>
 <20220823152625.7d0cbaae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823152625.7d0cbaae@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 03:26:25PM -0700, Jakub Kicinski wrote:
> On Fri, 19 Aug 2022 17:26:06 +0800 Qingfang DENG wrote:
> > As per RGMII specification v2.0, section 3.4.1, RGMII/RTBI has an
> > optional in-band status feature where the PHY's link status, speed and
> > duplex mode can be passed to the MAC.
> > Allow RGMII/RTBI to use in-band status.
> > 
> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > Signed-off-by: Qingfang DENG <dqfext@gmail.com>
> 
> Russell, PHY folks, any judgment on this one?

It looks fine to me, thanks for the reminder.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> Qingfang is there a platform which require RGMII to be supported 
> in upstream LTS branches? If there isn't you should re-target 
> the patch at net-next and drop the Fixes tag. Not implementing
> the entire spec is not considered a bug. Please clarify this
> in the commit message.

I agree - clarification is required.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
