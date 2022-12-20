Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD241652144
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiLTNKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiLTNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:10:16 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9300F583
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:10:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id B23FC9C0868;
        Tue, 20 Dec 2022 08:10:12 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id fFjtXBNeU1Vb; Tue, 20 Dec 2022 08:10:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1917A9C088F;
        Tue, 20 Dec 2022 08:10:12 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 1917A9C088F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671541812; bh=NrBNqU/sAJy4d5gG67VeQXWh1SehP8YlOkdIA+YA5gU=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=QHWhU0SsBFDlnJwzn+Le/xSBYqzi3ao1CpmIwrvVFsHkEC8mJfJselrlQ5qka+Qbl
         1Fwq9WN2I91T87nvXA8x4IamyQKc6ouVvCYnfn/6x/5ezICpFM1xt6fHRcGvFLglXP
         eiRfBmX8RpZfvPNZoLy0SJECSsNm+BtZZnNrzW9iiQPbzHJrwhX+0YrbNKd2Rf5TRy
         Z0hUXxp3GBbgejLnhVZKMJUJ7hUhM/7EUI45dMuTBgXOKxhK47jKQeprY3UWq7ISzd
         1eAdTawlttYPJRkCIGeMEFOyYgSCpJiVaw+6rdNdFVvFmuUno0bs89bw2Mm/8kCclB
         FvD37rlp+kjfA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bzbhQM875LeD; Tue, 20 Dec 2022 08:10:11 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EA3949C0868;
        Tue, 20 Dec 2022 08:10:11 -0500 (EST)
Date:   Tue, 20 Dec 2022 08:10:11 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Message-ID: <738320800.466311.1671541811900.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <d382c89ca5dc8675ed88efeae62f4adc0e72d6c0.camel@redhat.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com> <20221220113733.714233-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <d382c89ca5dc8675ed88efeae62f4adc0e72d6c0.camel@redhat.com>
Subject: Re: [PATCH v2] net: lan78xx: prevent LAN88XX specific operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4481 (ZimbraWebClient - FF107 (Linux)/8.8.15_GA_4481)
Thread-Topic: lan78xx: prevent LAN88XX specific operations
Thread-Index: lRSxGL74LuCBKX9IvfbbN2n1vhJpzA==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: "Paolo Abeni" <pabeni@redhat.com>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>,
> "netdev" <netdev@vger.kernel.org>
> Cc: "woojung huh" <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>,
> "UNGLinuxDriver" <UNGLinuxDriver@microchip.com>
> Sent: Tuesday, December 20, 2022 1:45:08 PM
> Subject: Re: [PATCH v2] net: lan78xx: prevent LAN88XX specific operations

> On Tue, 2022-12-20 at 12:37 +0100, Enguerrand de Ribaucourt wrote:
> > Some operations during the cable switch workaround modify the register
> > LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> > LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> > that register (0x19), corresponds to the LED and MAC address
> > configuration, resulting in unapropriate behavior.

> > Use the generic phy interrupt functions instead.

> > Fixes: 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
> > Reviewed-by: Paolo Abeni <pabeni@redhat.com>;
>> Signed-off-by: Enguerrand de Ribaucourt
> > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > ---
> > drivers/net/usb/lan78xx.c | 14 +++-----------
> > 1 file changed, 3 insertions(+), 11 deletions(-)

> > diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> > index f18ab8e220db..65d5d54994ff 100644
> > --- a/drivers/net/usb/lan78xx.c
> > +++ b/drivers/net/usb/lan78xx.c
> > @@ -28,6 +28,7 @@
> > #include <linux/phy_fixed.h>
> > #include <linux/of_mdio.h>
> > #include <linux/of_net.h>
> > +#include <linux/phy.h>
> > #include "lan78xx.h"

> > #define DRIVER_AUTHOR "WOOJUNG HUH <woojung.huh@microchip.com>"
>> @@ -2123,10 +2124,7 @@ static void lan78xx_link_status_change(struct net_device
> > *net)
> > * at forced 100 F/H mode.
> > */
> > if (!phydev->autoneg && (phydev->speed == 100)) {
> > - /* disable phy interrupt */
> > - temp = phy_read(phydev, LAN88XX_INT_MASK);
> > - temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
> > - phy_write(phydev, LAN88XX_INT_MASK, temp);
> > + phy_disable_interrupts(phydev);

> > temp = phy_read(phydev, MII_BMCR);
> > temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
>> @@ -2134,13 +2132,7 @@ static void lan78xx_link_status_change(struct net_device
> > *net)
> > temp |= BMCR_SPEED100;
> > phy_write(phydev, MII_BMCR, temp); /* set to 100 later */

> > - /* clear pending interrupt generated while workaround */
> > - temp = phy_read(phydev, LAN88XX_INT_STS);
> > -
> > - /* enable phy interrupt back */
> > - temp = phy_read(phydev, LAN88XX_INT_MASK);
> > - temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
> > - phy_write(phydev, LAN88XX_INT_MASK, temp);
> > + phy_request_interrupt(phydev);
> > }
> > }


> Oops, this does not even build... please take your time testing the
> code before sending patches to the ML.

I did verify that the patch built with the driver configured as built-in. I'll
investigate if there's a problem when built as a module.

> Paolo
