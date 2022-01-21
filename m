Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE8C4967B5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 23:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiAUWNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 17:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiAUWNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 17:13:19 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57164C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:13:19 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y27so5938395pfa.0
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMEDMrFvIrW6AllYXRP4p5q8ZNI0uS5BX73swVeXeTM=;
        b=lLJrgWELyO3gxL77PdQ1iuF2J3o+ut/ZLa2t4IvTtC2ZjdOj4yyxsT3V8q/5XXyf+s
         c6Fmh8exwsJg58zspubPldw4Cq0vPRr01jUgAfvAgoapLdt15dX2EDDn5ib5egLYsjGP
         iNORgqkWXcuKw0WSIdBfm7DjZ3XYb9GNLiC7xaCQJnt12Sb2UpOG9V/+dVB5UWHJlgHz
         qm5y+jDhovz3Lc4oMQLOfWnNmwQTKJKxGRCTlTHIgMRfaB69zo1sYJpR8WMi8qVoT7Ox
         dsHDZ4Y7G5ONjKalTEKL0Dp1IZgDIUL9XipwSyp+2G0kJdC1XW4aRANnFdz6rPVVM3dk
         1mWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMEDMrFvIrW6AllYXRP4p5q8ZNI0uS5BX73swVeXeTM=;
        b=1KXsKrjHzP635X65Vdj0DuH48hyK5rzrgn0HyUWs7toRCglHrh2cwJQzXAdcCR5Lyl
         W2MFOs66+nj1BZ59PTVaDqzaomVX68wuotvfaMYB0KAM9XYlg2lfqOk/++ka6uQ/cdpz
         zHRx2vfhNHzlJK8RlrkXyQi9MsfTpDbjeR+B0Ekm/f8Qfq1VsUWAKnzC54DgoiJguBJj
         /0qZJ36HmW6s4UX9uIEERUnFrpNI5q2FlvcXuCiO6hYdzQ97GALqKcF1MnLb6T+rBzTY
         FfgES8rhrbNBHhP3RRqBKKYWH2jYyVIzzoKtvIiscnP3w91frZNAp//3KYOY4m2ss/CA
         pbNQ==
X-Gm-Message-State: AOAM532gqLmNXuO2UQq2FQWH3GfwqLKLGTveNALPrXf4ZK3I8zeg02xB
        WEUvb/TPvUJxJfIauHcv1Z1MgIbV3qxwomxDiIU=
X-Google-Smtp-Source: ABdhPJySEdFnoYtEfN30PGNUBjVm0+eYNq6wdbJBpVW0sg/2B5GLbAySbZmvN8tfUqTTmborNX8vGBfV5LAmDoRoAjU=
X-Received: by 2002:a05:6a00:1404:b0:4c2:7c7c:f3d9 with SMTP id
 l4-20020a056a00140400b004c27c7cf3d9mr5180817pfu.77.1642803198816; Fri, 21 Jan
 2022 14:13:18 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-6-luizluca@gmail.com>
 <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com> <CAJq09z4U5qmBuPUqBnGpT+qcG-vmtFwNMg5Uau3q3F53W-0YDA@mail.gmail.com>
 <Yea9oR0AteAMwjW2@lunn.ch>
In-Reply-To: <Yea9oR0AteAMwjW2@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 21 Jan 2022 19:13:07 -0300
Message-ID: <CAJq09z59qhs71Vn79Zty4krpoCn_capam03yE4-kP=5E1K4bYQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in ds->ops
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
> > Thanks, Florian. You should be correct. It might call
> > mdiobus_unregister() and mdiobus_free() twice, once inside the dsa
> > code and another one by the devm (if I understood how devm functions
> > work).
> >
> > The issue is that the dsa switch is assuming that if slave_mii is
> > allocated and ds->ops->phy_read is defined, it has allocated the
> > slave_mii by itself and it should clean up the slave_mii during
> > teardown.
>
> Correct. Either the DSA core takes care of the mdiobus and uses the
> phy_read and phy_write ops, or the driver internally registers its own
> mdiobus, and phy_read and phy_write ops are not implemented. The core
> is not designed to mix those together.
>
> > if ds->ops->phy_read value should not tell if ds->slave_mii_bus should
> > be cleaned by the DSA switch.
> >
> > I would selfishly hope the correct one was the second option because
> > it would make my code much cleaner. If not, that's a complex issue to
> > solve without lots of duplications: realtek-smi drivers should not
> > have ds->ops->phy_read defined while realtek-mdio requires it. I'll
> > need to duplicate dsa_switch_ops for each subdriver only to unset
> > phy_read and also duplicate realtek_variant for each interface only to
> > reference that different dsa_switch_ops.
>
> One option would be to provide a dummy mdiobus driver for
> realtek-mdio, which simply passes the access through to the existing
> MDIO bus.
>
>      Andrew

Ok, thanks for the clarification, Andrew. In the end, I simply
duplicated ds_ops and wrote a wrap funcion.
Much less painful than I anticipated.

Should I submit a patch to make dsa work like this then?

dsa_switch_setup() {
        ....
        ds->ops->setup()
        ....
        if (ds->ops->phy_read) {
              if (ds->slave_mii_bus)
                    error("ds->ops->phy_read is set, I should be the
one allocating ds->slave_mii_bus!")
              ...allocate and register ds->slave_mii_bus...
        }
}

I think it is better to fail when there is an invalid setup than to
expect the dsa driver to behave correctly.

Regards,

Luiz
