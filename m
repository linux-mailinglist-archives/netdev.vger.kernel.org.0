Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BC574DDC
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbiGNMjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiGNMjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:39:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5277205CC;
        Thu, 14 Jul 2022 05:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xkzo1+jLdTW3x5JYk91+0YIKJPcQat2K2Pu8MNHVjIk=; b=fm00aGxYAWOz/V5wq0e/7M+CSX
        cxK+ClAkV4i4c57CkoufhpM9hvmKH5SpHaP+F48llBMpZpUCbGd32M2EbpBXyunIjx4MEbM0GtDOu
        vCFQG2kyGoXzC0MfaxLc4xvyFfZJfoj/C+7wTyxmfyU9BKc+cupqhomFTwczXTkAYjFYehq9qZ+2m
        6Kx12pm9bELbHJEyHbyAt7DOqeaUnWoa7Z1JqULzAMT/Oy6VBZPHOmV7lJIoI25rbJ/+hHeC1/V98
        w6hvIyZ7LoeXztI5bQZ9s/yRuWeaAE9P2oStSMqxKaX6m41638joLshSNTn6FwwDYtk9e0gM05suP
        iXa8RPMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33338)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBy7S-0005nL-4f; Thu, 14 Jul 2022 13:39:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBy7Q-0006bs-CC; Thu, 14 Jul 2022 13:39:00 +0100
Date:   Thu, 14 Jul 2022 13:39:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Message-ID: <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk>
 <Ys8+qT6ED4dty+3i@lunn.ch>
 <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 08:56:26AM +0000, Oleksandr Mazur wrote:
> Hello Andrew, Russel,
> Thanks for the input and sorry for the inconviniences.
> 
> >First question which applies to everything in this patch is - why make
> >phylink conditional for this driver?
> 
> 1. As for the phylink ifdefs:
> The original idea was to support mac config on devices (DB boards) that don't have full sfp support on board, however we scrapped out
> this idea as we could simply use fixed-link DTS configs; also due to this solution being non-upstream-friendly.
> Please note that V2 holds no phylink ifdefs;

I didn't specifically ask about the ifdefs - I asked the general
question about "why make phylink conditional for this driver".
Yes, v1 had ifdefs. v2 does not, but phylink is _still_ conditional.
You are introduing lots of this pattern of code:

	if (blah->phy_link)
		do something phylink related
	else
		do something else

And I want to know why.

> >In SGMII mode, it is normal for the advertising
> >mask to indicate the media modes on the PHY to advertise
> 2. As for the SGMII mode, yes, Russel, you're right; V3 will hold a fix for this, and keep the inband enabled for SGMII.
> 
> >No way to restart 1000base-X autoneg?
> 3. As for AN restart, no, it's not yet supported by our FW as of now.

Maybe put a comment in the code to that effect?

> >I think you should be calling phylink_mac_change() here, rather than
> >below.
> 
> 4. V3 is gonna fix this, thanks for the input.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
