Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A920604598
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiJSMmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiJSMmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:42:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46703317E9;
        Wed, 19 Oct 2022 05:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JhqoTv6oI6VeCIoZx6BVwVchA34wqcZ6eZRE7mXJULQ=; b=Jppr6nR3t5UgH30loqLy82PiMR
        fZ5pGuOVZuY/mmhBVAT8Zt78bQqGEDbRixgB7dzHgMCZsLXv0jS/kPZUZTVoF4fM6bdzmhogKMn/r
        pFwk+dEDM1taRD5sqsH7sjzmkLkT03N8LfcaMFxXW9GdCgwelb1CXR18Ld+gZi0pmpSmS2tYMqLLa
        E8USl5tGbxKvHnbDNcRWuqGMv76GgjU3o4txg4Y6lqUpml+s9r+baCF1oxDI2I0HZ0/pk26pfpZKt
        5jDwILtn6Cs8y2mNU/mNT1q8bEIXUYWtpgKMu6EwTwgJ13n2/eZoUEtlfpSPJz7BboHQNaqFo/Pzr
        w0myR9wA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34796)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol7ib-0005cB-2W; Wed, 19 Oct 2022 12:58:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol7iZ-00027y-J3; Wed, 19 Oct 2022 12:58:39 +0100
Date:   Wed, 19 Oct 2022 12:58:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Message-ID: <Y0/mbzaUItB1BOzg@shell.armlinux.org.uk>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
 <20221019124839.33ad3458@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221019124839.33ad3458@dellmb>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 12:48:39PM +0200, Marek Behún wrote:
> On Wed, 19 Oct 2022 17:50:51 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> 
> > Add support for selecting host speed mode. For now, only support
> > 1000M bps.
> > 
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> > index 383a9c9f36e5..daf3242c6078 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -101,6 +101,10 @@ enum {
> >  	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
> >  	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
> >  
> > +	MV_MOD_CONF		= 0xf000,
> > +	MV_MOD_CONF_SPEED_MASK	= 0x00c0,
> > +	MV_MOD_CONF_SPEED_1000	= BIT(7),
> > +
> 
> Where did you get these values from? My documentation says:
>   Mode Configuration
>   Device 31, Register 0xF000
>   Bits
>   7:6   Reserved  R/W  0x3  This must always be 11.

The closest is from the 88x3310 documentation that indicates these are
the default speed, which are used when the media side is down. There
is a specific sequence to update these.

However, as we seem to be talking about the 2110 here, that should be
reflected in these definitions.

Finally, using BIT() for definitions of a field which can be one of
four possible values is not acceptable. BIT() is for single bits
not for a multi-bit field which can take any possible value but just
the value we're representing there just happens to have a single bit
set.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
