Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61ED1AE66C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgDQUAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbgDQUAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 16:00:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F556C061A0C;
        Fri, 17 Apr 2020 13:00:51 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id r7so2366175edo.11;
        Fri, 17 Apr 2020 13:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=joiVaQizEHaQZ2229PthKafbXhuM8H8qQDWmPkZCvPA=;
        b=LnUVsZT2G4m7K2lZmIsUWXkdivVV7HhXp7uePi8XVh4Qriiw2cP6w0bxLLQvkkZCo2
         mdeOh5wMSkjEB9Xp1TpEzd414vQnYcilg+41HBWsJyNeN8qjMp2hS7ElPg/O1d/Aj9wz
         qi6KGI3SZcAvZRpN8+0+BQmZFjO97IiV5M3dSc6baK53+gtSmRAyLA0Ss33+3hoYPlF5
         OSJHY0PopkE10g6GPTZ+QsB6HRj/Wfj2wiyKR5cWe96nc1Fdauos2edLzf2NYQoCPPuC
         VXT7NZV8ej+/85a1lPIpdvg0IDCWxzsCMeyZwltHMZflAeaTdwgNp0mKuPIlcTVv0byq
         TfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=joiVaQizEHaQZ2229PthKafbXhuM8H8qQDWmPkZCvPA=;
        b=akT+S38ImNpMObn/zK+50LGtnAjegjtn7rtu43gaU7tvPJYnEYs5oX7gBvHE51U+PA
         mOtmJv+pCjF2CMp25sb0xwNOtnEev8dx9YerFjGJgvy5pSO4BBdvWHPNnTRQKYz8QkHK
         5TTimK9wJmHrW+I7TrnXindIX3hOHP7VOVOVtli9F+WgL/B/8R2KIZLdx1CNGTESnRl2
         9FB8vhyihBx6XpsV3vYcFoemvCa1Kq5OrhVOD5Ga7VFIKJkZsIWmSX0xA881z0LVp/ui
         ZRhcWltxe9oDiYCQKVsrfPV374yN92L8ecPNPdYqgN4d+6lUYmQ5zV30AUYQzIC03vpV
         KRjg==
X-Gm-Message-State: AGi0PuYYMI7LWk+Py1mPCaHPY1UG4aeDmcq/c43PyrSRVads49FTufrs
        Dx0zH2H0+BkgQqogEz0Uunk0FqjGnHwj9uaqs9vEfg==
X-Google-Smtp-Source: APiQypKyynWkw9qiXw74DF+bVe4DJIZMb0xgKZx3xRiuhX79mYKMVpvzm2p7v9bZYkxIhiNetPBgXQ6xsUuHUHAMwKY=
X-Received: by 2002:a50:a2e5:: with SMTP id 92mr4787735edm.139.1587153649966;
 Fri, 17 Apr 2020 13:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200417192858.6997-1-michael@walle.cc> <20200417192858.6997-2-michael@walle.cc>
 <20200417193905.GF785713@lunn.ch> <ef747b543bd8dd34aea89a6243de8da4@walle.cc>
In-Reply-To: <ef747b543bd8dd34aea89a6243de8da4@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 17 Apr 2020 23:00:38 +0300
Message-ID: <CA+h21hoB5n9DM0kcH_-DOzyxXvs5oMg-wxp-KkNTZOpfFhbWVA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: phy: add Broadcom BCM54140 support
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-hwmon@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, 17 Apr 2020 at 22:52, Michael Walle <michael@walle.cc> wrote:
>
> Hi Andrew,
>
> Am 2020-04-17 21:39, schrieb Andrew Lunn:
> > On Fri, Apr 17, 2020 at 09:28:57PM +0200, Michael Walle wrote:
> >
> >> +static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
> >> +{
> >> +    struct bcm54140_phy_priv *priv = phydev->priv;
> >> +    struct mii_bus *bus = phydev->mdio.bus;
> >> +    int addr, min_addr, max_addr;
> >> +    int step = 1;
> >> +    u32 phy_id;
> >> +    int tmp;
> >> +
> >> +    min_addr = phydev->mdio.addr;
> >> +    max_addr = phydev->mdio.addr;
> >> +    addr = phydev->mdio.addr;
> >> +
> >> +    /* We scan forward and backwards and look for PHYs which have the
> >> +     * same phy_id like we do. Step 1 will scan forward, step 2
> >> +     * backwards. Once we are finished, we have a min_addr and
> >> +     * max_addr which resembles the range of PHY addresses of the same
> >> +     * type of PHY. There is one caveat; there may be many PHYs of
> >> +     * the same type, but we know that each PHY takes exactly 4
> >> +     * consecutive addresses. Therefore we can deduce our offset
> >> +     * to the base address of this quad PHY.
> >> +     */
> >
> > Hi Michael
> >
> > How much flexibility is there in setting the base address using
> > strapping etc? Is it limited to a multiple of 4?
>
> You can just set the base address to any address. Then the following
> addresses are used:
>    base, base + 1, base + 2, base + 3, (base + 4)*
>
> It is not specified what happens if you set the base so that it would
> overflow. I guess that is a invalid strapping.
>
> * (base + 4) is some kind of special PHY address which maps some kind
> of moving window to a QSGMII address space. It is enabled by default,
> could be disabled in software, but it doesn't share the same PHY id
> for which this scans.
>
> So yes, if you look at the addresses and the phy ids, there are
> always 4 of this.
>
> -michael

What does the reading of the global register give you, when accessed
through the master PHY ID vs any other PHY ID? Could you use that as
an indication of this being the correct PHY ID, and scan only to the
left?

Regards,
-Vladimir
