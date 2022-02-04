Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6605C4A9BC0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359554AbiBDPRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:17:49 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:50592 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242172AbiBDPRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:17:48 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 4F8FE9C0210;
        Fri,  4 Feb 2022 10:17:47 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id lfYkrnKA_k0m; Fri,  4 Feb 2022 10:17:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id CB2B89C0226;
        Fri,  4 Feb 2022 10:17:46 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id upUyhKedY6rQ; Fri,  4 Feb 2022 10:17:46 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id AA3BE9C0210;
        Fri,  4 Feb 2022 10:17:46 -0500 (EST)
Date:   Fri, 4 Feb 2022 10:17:46 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
Message-ID: <526221306.489515.1643987866650.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <Yf0ykctMgWKswgpC@lunn.ch>
References: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <20220204133635.296974-2-enguerrand.de-ribaucourt@savoirfairelinux.com> <Yf0ykctMgWKswgpC@lunn.ch>
Subject: Re: [PATCH 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY
 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4180 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4177)
Thread-Topic: micrel: add Microchip KSZ 9897 Switch PHY support
Thread-Index: 4VuYldAnJFXW0zLKkU5SeLIxbCKXaQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Andrew Lunn" <andrew@lunn.ch>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: netdev@vger.kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk
> Sent: Friday, February 4, 2022 3:05:05 PM
> Subject: Re: [PATCH 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support

> On Fri, Feb 04, 2022 at 02:36:34PM +0100, Enguerrand de Ribaucourt wrote:
> > Adding Microchip 9897 Phy included in KSZ9897 Switch.
> > The KSZ9897 shares the same prefix as the KSZ8081. The phy_id_mask was
> > updated to allow the KSZ9897 to be matched.

>> Signed-off-by: Enguerrand de Ribaucourt
> > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > ---
> > drivers/net/phy/micrel.c | 15 +++++++++++++--
> > include/linux/micrel_phy.h | 1 +
> > 2 files changed, 14 insertions(+), 2 deletions(-)

> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index 44a24b99c894..9b2047e26449 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -1726,7 +1726,7 @@ static struct phy_driver ksphy_driver[] = {
> > }, {
> > .phy_id = PHY_ID_KSZ8081,
> > .name = "Micrel KSZ8081 or KSZ8091",
> > - .phy_id_mask = MICREL_PHY_ID_MASK,
> > + .phy_id_mask = 0x00ffffff,

> You can probably use PHY_ID_MATCH_EXACT().

Thank you for your feedback! The rest of the driver always uses
this style instead of PHY_ID_MATCH_EXACT().
Shouldn't I stick to it for consistency in micrel.c ?

Example:
	.phy_id		= PHY_ID_KSZ8031,
	.phy_id_mask	= 0x00ffffff,
	.name		= "Micrel KSZ8031",


> > .flags = PHY_POLL_CABLE_TEST,
> > /* PHY_BASIC_FEATURES */
> > .driver_data = &ksz8081_type,
> > @@ -1869,6 +1869,16 @@ static struct phy_driver ksphy_driver[] = {
> > .config_init = kszphy_config_init,
> > .suspend = genphy_suspend,
> > .resume = genphy_resume,
> > +}, {
> > + .phy_id = PHY_ID_KSZ9897,
> > + .phy_id_mask = 0x00ffffff,

> Here as well.

> > + .name = "Microchip KSZ9897",
> > + /* PHY_BASIC_FEATURES */
> > + .config_init = kszphy_config_init,
> > + .config_aneg = ksz8873mll_config_aneg,
> > + .read_status = ksz8873mll_read_status,
> > + .suspend = genphy_suspend,
> > + .resume = genphy_resume,
> > } };

> > module_phy_driver(ksphy_driver);
>> @@ -1888,11 +1898,12 @@ static struct mdio_device_id __maybe_unused micrel_tbl[]
> > = {
> > { PHY_ID_KSZ8041, MICREL_PHY_ID_MASK },
> > { PHY_ID_KSZ8051, MICREL_PHY_ID_MASK },
> > { PHY_ID_KSZ8061, MICREL_PHY_ID_MASK },
> > - { PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
> > + { PHY_ID_KSZ8081, 0x00ffffff },

> And here.

> > { PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
> > { PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
> > { PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
> > { PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
> > + { PHY_ID_KSZ9897, 0x00ffffff },

> etc.

> Andrew
