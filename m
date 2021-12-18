Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2258647992B
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 07:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhLRGYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 01:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhLRGYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 01:24:18 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F93BC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:24:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so5164491pjj.2
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CKvPRC5ZAp0iGmBvbBVIeeelUHLx4MIkyV8TlL65JmU=;
        b=gggiwJJroSBH+ZY9SN7QSDggD1m3Cm5YkfPevYR9F467HQgxuYrKCFKCg89b26MwLH
         jp33PpD0vvDqlyCzxRsAkImiEjdxTyfOi92KQqfwiKOyP/3V4SDS1/obqOHwBDg4dx+f
         UbOTDr5ChRcxPAkwZT+x8uNp3DIU3QeZOfebIMZLsFSBISsAwKKvYsx0TmpgOhSrkY0v
         VLo838yfdpSoVIW+5TCDaDUZttjvKnyWD2PSt4CIqDh/pMSG1OVyYktmSI+LDxZxQFsg
         q0DIfjuiPZbOtU/d+if354BmqZTrNVETFQvsCPuyHmfu/+jVvxUXYecS+ksXyTtWVlYq
         Eg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CKvPRC5ZAp0iGmBvbBVIeeelUHLx4MIkyV8TlL65JmU=;
        b=Vfbas4zWvT38wziTSH9MNCy8r4pP1BhuD04GBAtjs+/9w2zUvLZS1q8M5N884ixjC5
         MoEpYicX+qXcxochl9Bz4WYRgCf558XdeaPsMImCnAAd/HSThp95ojzul4023MKX1qrw
         jc1HwLNRzjivS19/h9vH7Tl96yn/OhLXjhOqllLdXM3PdIxDJc8IAge6POxroyP1ZPMc
         GpxMiOci07zzKNWQEIVWAViQekSiDs0PTs96uF+utLdSYTW36yaYbA/8fZMEDLQwjqX/
         d4Dg+HQpsy4X2EEOLFpnbLDFewZK1Rr5mb3qUn0n43bQOzYy6qxGG/zlppLouofw+yJ3
         yoHA==
X-Gm-Message-State: AOAM533nJS0kIh8zei+UDPNcwaJ4A52/+7wTgvZbLHwlkH+SW0bVdHI/
        gS82lNnAN7GAb7pS7aiNdPo8kLVoRw4vA+60p4E=
X-Google-Smtp-Source: ABdhPJxwIWO74TBcCrcpo/AbWY4cLbs0di2JmfenxnbhmYl5IB7/BsO5GbbNrkhN3MMLaY2d94i7HBVGqqezyYQupzg=
X-Received: by 2002:a17:903:246:b0:143:c007:7d41 with SMTP id
 j6-20020a170903024600b00143c0077d41mr6855262plh.59.1639808657499; Fri, 17 Dec
 2021 22:24:17 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-6-luizluca@gmail.com>
 <CACRpkdaJ_sV_Fb8qJXp7PN5mO2A68h7zw1UeFuBk2tLDH7cB1A@mail.gmail.com>
In-Reply-To: <CACRpkdaJ_sV_Fb8qJXp7PN5mO2A68h7zw1UeFuBk2tLDH7cB1A@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 03:24:06 -0300
Message-ID: <CAJq09z6J7oHi7D054fQZO_JkAgmDdRHZHmz0qE3oGb2+_pzQxQ@mail.gmail.com>
Subject: Re: [PATCH net-next 05/13] net: dsa: realtek: use phy_read in ds->ops
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > The ds->ops->phy_read will only be used if the ds->slave_mii_bus
> > was not initialized. Calling realtek_smi_setup_mdio will create a
> > ds->slave_mii_bus, making ds->ops->phy_read dormant.
> >
> > Using ds->ops->phy_read will allow switches connected through non-SMI
> > interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
> > same code.
> >
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> (...)
> > -static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int =
regnum)
> > +static int rtl8365mb_phy_read(struct dsa_switch *ds, int phy, int regn=
um)
> >  {
> >         u32 ocp_addr;
> >         u16 val;
> >         int ret;
> > +       struct realtek_priv *priv =3D ds->priv;
>
> Needs to be on top (reverse christmas tree, christmas is getting close).
>
> > -static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int=
 regnum,
> > +static int rtl8365mb_phy_write(struct dsa_switch *ds, int phy, int reg=
num,
> >                                u16 val)
> >  {
> >         u32 ocp_addr;
> >         int ret;
> > +       struct realtek_priv *priv =3D (struct realtek_priv *)ds->priv;
>
> Dito.
>
> > -static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int =
regnum)
> > +static int rtl8366rb_phy_read(struct dsa_switch *ds, int phy, int regn=
um)
> >  {
> >         u32 val;
> >         u32 reg;
> >         int ret;
> > +       struct realtek_priv *priv =3D ds->priv;
>
> Dito.
>
> > -static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int=
 regnum,
> > +static int rtl8366rb_phy_write(struct dsa_switch *ds, int phy, int reg=
num,
> >                                u16 val)
> >  {
> >         u32 reg;
> >         int ret;
> > +       struct realtek_priv *priv =3D ds->priv;
>
> Dito.
>
> Other than that it's a great patch, so with these nitpicky changes
> feel free to add:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>

Thanks! Fixed and added.
