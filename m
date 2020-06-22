Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9220337F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgFVJei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgFVJeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:34:37 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF07C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:34:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so939977ejb.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6UHTXV1vBAbCBtvkZPGZNEXtMeZ6CORzfipY/DGFZ8=;
        b=dwRB4MFCnHHneMTAFr630MXuFGAk08RinBEEQh34dRVV25s9vh2PhFTxA1hyOSKo6c
         ByKSJ0NdFPRTQswBqmygfrqYYxNrwnJYclzF2kgGQq1xAl2AzKS7IWPQMZs8kSMejeFv
         zXl5TSAALrj6yfWppkWMS+a5sSQMw+Ypn9daLVY/mCOt1oIFKdyaqiWvJj/WrrLtmR1u
         kJ/dIXMJtfMauAoK50V0yNz9b/EujvjQ94vVS/TD+fv6W3Hs19W+HJiCVtlYB1193zUv
         O9REvqHRr+6mS0BlOUpSRGMcSfjUgYC5MKl3iugQAMhJHRFwKX0+XWaZMkgJ04xUlS7r
         uZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6UHTXV1vBAbCBtvkZPGZNEXtMeZ6CORzfipY/DGFZ8=;
        b=cmM6DC1NA2cWRNzxT6+Ba8o2Dw6jE+N/WIeCCBqxyKvf5xjoACZiq5yTvnjPHYAEzf
         /sL1PqOVW+cXi1r/G5KhAb0XbrWEAkMSY1MhB7AUh8JwBPoTV/zc1rvRiuN6eqvWg7XM
         vv34Y8h6Tg+bqKYHVQGhaRdLowGz54QVTfQ4MabYYid7Am8q9MQfcn91pA8/0zvGpNQK
         pa0i6QkmA8fqLQKDXXyWdgMTCS2dXtclz4O17AgrhgSlkz4rX6uZwKhQoEP54Go8Y8A0
         lbGUPR5Op7FXtI01+llnnddTfZvS5ZjDGTfEp+hyh3mB+u9M6z6qvrXmfuTnozYeDOq6
         ZXGg==
X-Gm-Message-State: AOAM5322BqK2j3JD6cTOKQMLRgfAmwtyvHdT0utpHKEa0/rbG8T/iL/Z
        +n5Hs019wVSuN9SxTgYFRd4Fo5EDDNagiumMtmg=
X-Google-Smtp-Source: ABdhPJw91Z5MGmkz8AzYM7lwDyTepzlUPbVu9tIawqc+H7sFR6DTZwj9zl1tpBm/l9YZQr/V8ChbGunmCsNAc+tagPM=
X-Received: by 2002:a17:906:885:: with SMTP id n5mr2555708eje.406.1592818476410;
 Mon, 22 Jun 2020 02:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200621225451.12435-1-ioana.ciornei@nxp.com> <20200622092944.GB1551@shell.armlinux.org.uk>
In-Reply-To: <20200622092944.GB1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 22 Jun 2020 12:34:25 +0300
Message-ID: <CA+h21hq146U6Zb38Nrc=BKwMu4esNtpK5g79oojxVmGs5gLcYg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 at 12:29, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 22, 2020 at 01:54:42AM +0300, Ioana Ciornei wrote:
> > Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> > The advantage of this structure is that multiple ethernet or switch
> > drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
> > same implementation of PCS configuration and runtime management.
> >
> > The PCS is represented as an mdio_device and the callbacks exported are
> > highly tied with PHYLINK and can't be used without it.
> >
> > The first 3 patches add some missing pieces in PHYLINK and the locked
> > mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> > standalone module. The majority of the code is extracted from the Felix
> > DSA driver. The last patch makes the necessary changes in the Felix
> > driver in order to use the new common PCS implementation.
> >
> > At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> > SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
> > in-band AN) are supported by the Lynx PCS MDIO module since these were
> > also supported by Felix and no functional change is intended at this
> > time.
>
> Overall, I think we need to sort out the remaining changes in phylink
> before moving forward with this patch set - I've made some progress
> with Florian and the Broadcom DSA switches late last night.  I'm now
> working on updating the felix DSA driver.
>

What needs to be done in the felix driver that is not part of this
series? Maybe you could review this instead?

> There's another reason - having looked at the work I did with this
> same PHY, I think you are missing configuration of the link timer,
> which is different in SGMII and 1000BASE-X.  Please can you look at
> the code I came up with?  "dpaa2-mac: add 1000BASE-X/SGMII PCS support".
>
> Thanks.
>

felix does not have support code for 1000base-x, so I think it's
natural to not clutter this series with things like that.
Things like USXGMII up to 10G, 10GBase-R, are also missing, for much
of the same reason - we wanted to make no functional change to the
existing code, precisely because we wanted it to go in quickly. There
are multiple things that are waiting for it:
- Michael Walle's enetc patches are going to use pcs-lynx
- The new Seville driver will use pcs-lynx

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Thanks,
-Vladimir
