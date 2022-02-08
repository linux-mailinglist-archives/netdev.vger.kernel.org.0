Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBF34AD397
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350056AbiBHIip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiBHIio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:38:44 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBDAC03FEC5
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:38:43 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1CDC59C020B;
        Tue,  8 Feb 2022 03:38:42 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VdBNoYKogVDd; Tue,  8 Feb 2022 03:38:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id AD7A99C0216;
        Tue,  8 Feb 2022 03:38:41 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5Wx1LI7puhwP; Tue,  8 Feb 2022 03:38:41 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 8C1929C020B;
        Tue,  8 Feb 2022 03:38:41 -0500 (EST)
Date:   Tue, 8 Feb 2022 03:38:41 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, hkallweit1 <hkallweit1@gmail.com>,
        linux <linux@armlinux.org.uk>
Message-ID: <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <YgGrNWeq6A7Rw3zG@lunn.ch>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com> <YgGrNWeq6A7Rw3zG@lunn.ch>
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4180 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4177)
Thread-Topic: micrel: add Microchip KSZ 9897 Switch PHY support
Thread-Index: pJ9vNxAOPWFGoUDpsGFpcrxIXbB7SQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Andrew Lunn" <andrew@lunn.ch>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: "netdev" <netdev@vger.kernel.org>, "hkallweit1" <hkallweit1@gmail.com>, "linux" <linux@armlinux.org.uk>
> Sent: Tuesday, February 8, 2022 12:28:53 AM
> Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support

> > + /* KSZ8081A3/KSZ8091R1 PHY and KSZ9897 switch share the same
> > + * exact PHY ID. However, they can be told apart by the default value
> > + * of the LED mode. It is 0 for the PHY, and 1 for the switch.
> > + */
> > + ret &= (MICREL_KSZ8081_CTRL2_LED_MODE0 | MICREL_KSZ8081_CTRL2_LED_MODE1);
> > + if (!ksz_8081)
> > + return ret;
> > + else
> > + return !ret;

> What exactly does MICREL_KSZ8081_CTRL2_LED_MODE0 and
> MICREL_KSZ8081_CTRL2_LED_MODE1 mean? We have to be careful in that
> there could be use cases which actually wants to configure the
> LEDs. There have been recent discussions for two other PHYs recently
> where the bootloader is configuring the LEDs, to something other than
> their default value.

Those registers configure the LED Mode according to the KSZ8081 datasheet:
[00] = LED1: Speed LED0: Link/Activity
[01] = LED1: Activity LED0: Link
[10], [11] = Reserved
default value is [00].

Indeed, if the bootloader changes them, we would match the wrong
device. However, I closely examined all the registers, and there is no
read-only bit that we can use to differentiate both models. The
LED mode bits are the only ones that have a different default value on the
KSZ8081: [00] and the KSZ9897: [01]. Also, the RMII registers are not
documented in the KSZ9897 datasheet so that value is not guaranteed to
be [01] even though that's what I observed.

Do you think we should find another way to match KSZ8081 and KSZ9897?
The good news is that I'm now confident about the phy_id emitted by
both models.

Thanks for your help.

> Andrew
