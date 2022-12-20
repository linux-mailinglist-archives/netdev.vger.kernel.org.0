Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2145B6520EF
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLTMsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiLTMrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:47:52 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F13BE4F
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:47:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1AE919C0828;
        Tue, 20 Dec 2022 07:47:49 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pZGv28hs0M_S; Tue, 20 Dec 2022 07:47:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7C03A9C088E;
        Tue, 20 Dec 2022 07:47:48 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 7C03A9C088E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671540468; bh=x0iqthYt5CHOhUhKD7B/nPxGe88L1pGyJgg0Civ2OtY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=BhY9cmus0XGmOr/qhv9sl4R85z2WA6J8U88mXLOAGQ1ALkDIFKSggniXXPQMHjwh9
         jW5E0uKBgVXymZmqXXMv4T/gOpPIirmQmETvES0m5C6w86jqwrY+1z97XE3CHbDYqL
         Biue6wFpViiP84nB72/0pQjGKlqlIdcQSy0iZQ1pgRZ2rz/AkNNE/cXJ5qqjCZHDjr
         VbS4uJ+8CTQw75C0k1uqkLcT8gozia/eB0vnXvGpB2t6qSo7vtjScslO2A0ztiHMaM
         QbT/4gbPetqahs92FHmMLxjzEYr0dIq/hWRVAvzC4+YrwWLc/aPLr1pIe4ouJzROIQ
         /IpmwLaZqEd7Q==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id I8uKjgcp_71G; Tue, 20 Dec 2022 07:47:48 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 57C589C0828;
        Tue, 20 Dec 2022 07:47:48 -0500 (EST)
Date:   Tue, 20 Dec 2022 07:47:47 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Message-ID: <1650367438.466155.1671540467993.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <1061700ecedf92911d474a675bd3c47354ab600a.camel@redhat.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com> <20221220113733.714233-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <1061700ecedf92911d474a675bd3c47354ab600a.camel@redhat.com>
Subject: Re: [PATCH v2] net: lan78xx: prevent LAN88XX specific operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4481 (ZimbraWebClient - FF107 (Linux)/8.8.15_GA_4481)
Thread-Topic: lan78xx: prevent LAN88XX specific operations
Thread-Index: yOsYNKpDqbKWxPFjnnNeuGV9qFYZzQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Paolo Abeni" <pabeni@redhat.com>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>, "netdev" <netdev@vger.kernel.org>
> Cc: "woojung huh" <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> <UNGLinuxDriver@microchip.com>
> Sent: Tuesday, December 20, 2022 1:41:08 PM
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

> You should not attach this tag (or acked-by) on your own.

Thanks, I'm still new with the patching process.

> The following is not even the code I was _asking_ about...

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

> This looks wrong. Should probably be:

> phy_enable_interrupts(phydev);

phy_enable_interrupts isn't exported in the header. I'll add a
dedicated commit for that.

> Paolo
