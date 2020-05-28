Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9041E67CF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbgE1Qvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405123AbgE1Qvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:51:36 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF9C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:51:35 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f7so423399ejq.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPQTBrqHGlHTId3A3Dv5QAMAxCU+s7yVmts8qu1ZMAc=;
        b=URhcgqYuzhhYfBGVxBgmwDhFfgqXTsngZEXBQMiVP/I4mpgh3jCW5nGMBByfpVLmai
         E5RT7aQ6oaRGKr9wJIAoWSjiwBDURxD7OJ5Osu8/scumoyMDItHqT+/lF0uwTRZxxxv2
         bAWvvYD1ua9WX07cjShph54tcusDlZdoCAWN3UKwnqpDMgkZzdwcjWuTxr4D+js4QYWR
         y+W6EhrOMz5rCRtoiLHT+P5OB22jxTry0DP6xNBNPZzXYW+xOThWCuz/WaptXNOh9uqF
         Fvykj7xiCO3Lpt3yC9/6tf+xN00R58rv2E9QogZsaEkukRm6aM2kEEMaJsNQMz7YGOq1
         zTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPQTBrqHGlHTId3A3Dv5QAMAxCU+s7yVmts8qu1ZMAc=;
        b=m2Ay11Pn5jhdsvDOWZgNR53KQf3WPfaOSm4SXP2oKiWanPmUWwRyXUDo58J/KfgPVL
         Noc8RlUnOs6XSH6q/+++PujUgCgX/jg3D0SNHTASuD5/vzW6gh9eEvhDDrUQks1aWVey
         TG/i7QmawQfHmDeaT9Hw/v0XRBucEFQ4fN9Duzqz8UiXmaNJ9lxCzGnw2nvQqw1HQJOh
         dSbFvTZnAWI+u5Gj4aHP7sx/pmcU5vVXvFIBsnpm+65jTY8tt2bRZvcD6uhavrVNds1s
         0tLtPMVTKyjK37x2A00DUfFhUXfPVzTmcY0wcVx2+zcDSrWppaqgAWobKn/FrAwY2Qdt
         u3ew==
X-Gm-Message-State: AOAM533EaEI62V0i40bVWkjDlWS1uV5Sr+YfWIya4K1kkgXviyICyjT9
        oUJ1s+6i3tc36eu4MmWtjzhwJH6+PgGO/rWXvQA=
X-Google-Smtp-Source: ABdhPJxzXlXxjpuu/0eXWQrkJr4rrM8C5l+15dnBW34HOd1L0lCEeeDB5/Vhyeu6np3PNM7/3KXrIxij1ktRTVEbWSo=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr3766857eji.305.1590684694638;
 Thu, 28 May 2020 09:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528092135.62e4b06f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528092135.62e4b06f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 28 May 2020 19:51:23 +0300
Message-ID: <CA+h21hoaQEyVLfHPB67d9Nc0q+n9+jTJyK86fXFMBNNfFx653g@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 at 19:21, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 May 2020 02:41:13 +0300 Vladimir Oltean wrote:
> > From: Maxim Kochetkov <fido_max@inbox.ru>
> >
> > This is a 10-port (8 external, 2 internal) switch from
> > Vitesse/Microsemi/Microchip that is integrated into the Freescale/NXP
> > T1040 PowerPC SoC. The situation is very similar to Felix from NXP
> > LS1028A, except that this is a platform device and Felix is a PCI
> > device.
> >
> > Extending the Felix driver to probe a PCI as well as a platform device
> > would have introduced unnecessary complexity. The 'meat' of both drivers
> > is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> > duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> > bits in seville_vsc9953.c.
> >
> > Like Felix, this driver configures its own PCS on the internal MDIO bus
> > using a phy_device abstraction for it (yes, it will be refactored to use
> > a raw mdio_device, like other phylink drivers do, but let's keep it like
> > that for now). But unlike Felix, the MDIO bus and the PCS are not from
> > the same vendor. The PCS is the same QorIQ/Layerscape PCS as found in
> > Felix/ENETC/DPAA*, but the internal MDIO bus that is used to access it
> > is actually an instantiation of drivers/net/phy/mdio-mscc-miim.c. But it
> > would be difficult to reuse that driver (it doesn't even use regmap, and
> > it's less than 200 lines of code), so we hand-roll here some internal
> > MDIO bus accessors within seville_vsc9953.c, which serves the purpose of
> > driving the PCS absolutely fine.
> >
> > Also, same as Felix, the PCS doesn't support dynamic reconfiguration of
> > SerDes protocol, so we need to do pre-validation of PHY mode from device
> > tree and not let phylink change it.
> >
> > Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> drivers/net/dsa/ocelot/seville_vsc9953.c:636:19: warning: symbol 'vsc9953_vcap_is2_keys' was not declared. Should it be static?
> drivers/net/dsa/ocelot/seville_vsc9953.c:706:19: warning: symbol 'vsc9953_vcap_is2_actions' was not declared. Should it be static?

Rhetorical question...
