Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A6A47991B
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 07:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhLRGJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 01:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhLRGJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 01:09:08 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F057CC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:09:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gn2so4128843pjb.5
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gFGndjzozMCyWfscFwP/fIZkX2pBurFEuUN02lT+Nns=;
        b=DxoM6nxwDEW45UkKSZqc7bw8AjVkdz09S/+XoeNSpKWDAunsPa+o1R1E57hyjn7l6E
         RUNJGNMGnbSP6U7cFl3MadusO/mH24ewX4MLn89nmEG+BJEWTnRUYX91SIss7xe1iO6S
         EjwiujmaaTiQ9fysT9mEDuGSbGUbygJjs6Nuc8bKfxVXsJSWY03VmuZ1mhC8lbudBmN3
         jutigieFctKmaKusi3hnfZnSuILGcRf+RrUtQbWq5x9G2ZCwFyB87ILPVmn+fYRc6ebh
         wp/i2bmwo/RaUDBDsf2+s36VYEWlSoTSuU3dPhzZWyJxjcdAjyLcmURzsYZQdnla8eRJ
         GVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gFGndjzozMCyWfscFwP/fIZkX2pBurFEuUN02lT+Nns=;
        b=0uw+ZK9zL5FLrB2Nkezeaq0GPTxYxUwqo/dk2XvrspeXXoDWipiAKmhPQfNbzRrG5K
         7Z0mUvZeoIFxCsKAIVfYBVcHdEteVkN1G/fz7BLm4TOa63uDpYp7oImp5dP3No0vwb0s
         nxv1Noh0atWLGdB6xGf9zKpkjcqMfAiQtWEYTDcviSJAV6BwiK3sKKJL4RTIV3J7Rul8
         mh54IGJBY1+r0/RrIS9PGHimo16ukItNDtQKI4xRjdsk73WcFH2nYfqPk+VJL5xZcNVU
         G6RB1nTzYtZkSEBLCFQgbl8LgLAYHD0h7kzMerKnpT9K6IzYXAA66lojuGLxcEOToldP
         U6hw==
X-Gm-Message-State: AOAM533YpZz4HE/e39NfFn8x2g3iGcQF3bLXJGQZuaLHNsjpXgccs4Cp
        GZm5FxPaNj1wAeqndbm1E56OGtbPST5tNBevzI8=
X-Google-Smtp-Source: ABdhPJwey9MH+j+CXEO7ghfLMKczi+ZxItOMUFQik+2G3pYpFnJJ/FTY1FSSGERqf1XSpZkLmtWPaA/WxjObfv2VV+Y=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr14737469pjb.32.1639807747329;
 Fri, 17 Dec 2021 22:09:07 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-8-luizluca@gmail.com>
 <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk> <CAJq09z79xThgsagBLAcLJqDKzC6yx=_jjP+Bg0G4OXXbNj30EQ@mail.gmail.com>
 <15fa5d93-944a-0267-9593-a890080d6e02@bang-olufsen.dk>
In-Reply-To: <15fa5d93-944a-0267-9593-a890080d6e02@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 03:08:56 -0300
Message-ID: <CAJq09z4CgW26yk8POdt5kW=R-X9pB9ihhAV24kx-gUe7JL0c4A@mail.gmail.com>
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to rtl8367c
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alvin,

> I don't think the current name is really hurting anybody. And as Ar=C4=B1=
n=C3=A7
> says, it=E2=80=99s a huge chunk of change with no real benefits.

Until now, the name was used internally and it would only matter for
developers. However now it will be exposed to userland. That is the
name they will need to find if a device is supported.

The rtl8367c was simply the name used by Realtek API distributed to
its patterns. It eventually got into multiple devices, including
Arduino, u-boot, and Linux kernel.

It is a nice game to decode Realtek product names. Realtek seems to
like to use letters as versions, but only with the second generation.
Letters like "S", "M", "N", "R" are some kind of feature indicator. If
you find a device rtl8366sc, it is likely there is a
rtl8366sb and probably a rtl8366s. but never a rtl8366.

So we have:

RTL - Realtek
83 - switch controllers?
6 - family
7 - number of ports, including external with 0 as 10
S, M, M, R - features. Might include an extra "-V" suffix
B, C, D... variant indicator. Even the extra suffix might use it

When you get a new product and a name collides, you add the next
variant suffix. It is not a generation indicator, just a way to avoid
collisions when two chips would have the same name.

And about the driver's name? Well, at first they might have worked
with a generic rtl8367 device and used that as the driver name. If it
was a Linux driver, it would probably be called rtl836x. What do they
do when a new driver version is needed? Use the same logic. So, we
have driver versions rtl8367, rtl8367b, rtl8367c, rtl8367d... And I
don't think there is a major breakage between these versions that
justify having them in parallel inside the Linux kernel. And it also
applies to rtl8366rb and rtl8365mb. From what I see, both are
independently doing the same thing, with different features
implemented. A good path would be to merge these two drivers into a
single rtl836x module. Maybe it could start by renaming
rtl8366(-core).c to rtl836x.c and try to migrate code from subdrivers
into this file, and create a shared register header file.

Yes, I agree the name rtl8367c is not good at all. I'll remove the
rename patch but it will take some time. I'll be two weeks away.

> Besides, not all renaming seems consistent - what is mb to mean here?:
>
> -       struct rtl8365mb *mb =3D priv->chip_data;
> +       struct rtl8367c *mb =3D priv->chip_data;

As I said, I do care about names and I have no idea. I was hoping that
you would know.

> The naming scheme for rtl8366rb is also mysterious - why not fix that
> too? Is that rtl8367b?

If we follow the same logic, yes, it would be rtl8367b. However, I
think the right path is to have a single rtl836x driver.
That name would be perfect for a user to find the correct driver by name.

> Honestly it seems like more effort than it is worth. The comments at the
> top of the driver should be sufficient to explain to any future
> developer what exactly is going on. If something is unclear, why not
> just add/remove some lines there?

End users do not read driver comments. It is more likely that they
will read kernel docs first.

> Since you don't feel strongly about the name, I would suggest you drop
> the renaming from your MDIO/RTL8367S series for now. It will also make
> the review process a bit easier.

Agreed

>
>         Alvin
