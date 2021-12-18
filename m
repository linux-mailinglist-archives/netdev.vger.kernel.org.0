Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19E147983D
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhLRCuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLRCuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:50:44 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA638C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:50:43 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id p4so6385154oia.9
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OQsziMdDCpatPRroGpOxFnIEJJmvPViVO/JwKnn+1Po=;
        b=PfmyNS51XW0AYovooGDAsEqeaZkUDB5nXB9CWgf+Wmo83cQWWgyShQ6I5/tFF7GPd2
         lRA65uVMX7oD2GKpvkvf3UOgAbB9ZKTM8KiBHa0FKeTCeKx2e8aMTcTgWunDhRWgd7XV
         RzqZkd2rnTKhPROH9PB2eOYfxJ5LUaCBuN/nkEQHvL4nyDC+FXoFhNjqnhEZCzvG/FWo
         jdQLs2iWS1qPlAf43VcTccZGamtVkDKkJSNdUW4LlFdjrlE0073Vmu0KZD/DpLBNyDLD
         dA1DoX81OaU2drqnCctiEXwepsm19mZgehSzWrUjGDphn37C4YZcg+5vzFCPF4EZj6EI
         ubOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OQsziMdDCpatPRroGpOxFnIEJJmvPViVO/JwKnn+1Po=;
        b=B2ruX2nz0GgmRco/Vh1UVr0KS9hJFOtEnmS5inFBPGeLdxq9IqWCkJObLSDrzbCmgf
         kaafF0Is1xOLcpUTFY4qn4//5WjM5vU4JEJfKb/PMYOqijolQkZy+pwdCN+Qn+WavPbq
         svp1lXhSYpTT0Q14etbfEohwpz9SKNLmkyJU1Uu7PufPk3ez9Rxenq2CQTQ7h/6CvbdT
         i5YpW/SC09x3rjJP1J+xd0ZU5FSUCM+fB3aUrUzeGIaKUYNbZeGrfr04OrhCoudtKP9j
         kA4BRvlVOywO6aj96WiyWKdrUeAcTFjl1uogt2seOcSOx27sCLwumiB81OVl8uWBh8L2
         IGBw==
X-Gm-Message-State: AOAM530h70HoQ1vgDNoEkg9rK0tOYrQUsII0WN9UcS9dJYA20hxPe510
        GdD/1VTUl1mKcOGRll9mmSPOJwiRp2rtEKXDXpszig==
X-Google-Smtp-Source: ABdhPJzWUFS+w1qiV9v2OnoC4njxzMrKV8fD1cNZAbcTiPM3GOBBr09dzOTRBYU9fOSxCYNlRJAjzFU3zIdaxWvjOAc=
X-Received: by 2002:aca:120f:: with SMTP id 15mr4332801ois.132.1639795843186;
 Fri, 17 Dec 2021 18:50:43 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-6-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-6-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:50:31 +0100
Message-ID: <CACRpkdaJ_sV_Fb8qJXp7PN5mO2A68h7zw1UeFuBk2tLDH7cB1A@mail.gmail.com>
Subject: Re: [PATCH net-next 05/13] net: dsa: realtek: use phy_read in ds->ops
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> The ds->ops->phy_read will only be used if the ds->slave_mii_bus
> was not initialized. Calling realtek_smi_setup_mdio will create a
> ds->slave_mii_bus, making ds->ops->phy_read dormant.
>
> Using ds->ops->phy_read will allow switches connected through non-SMI
> interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
> same code.
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
(...)
> -static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int re=
gnum)
> +static int rtl8365mb_phy_read(struct dsa_switch *ds, int phy, int regnum=
)
>  {
>         u32 ocp_addr;
>         u16 val;
>         int ret;
> +       struct realtek_priv *priv =3D ds->priv;

Needs to be on top (reverse christmas tree, christmas is getting close).

> -static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int r=
egnum,
> +static int rtl8365mb_phy_write(struct dsa_switch *ds, int phy, int regnu=
m,
>                                u16 val)
>  {
>         u32 ocp_addr;
>         int ret;
> +       struct realtek_priv *priv =3D (struct realtek_priv *)ds->priv;

Dito.

> -static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int re=
gnum)
> +static int rtl8366rb_phy_read(struct dsa_switch *ds, int phy, int regnum=
)
>  {
>         u32 val;
>         u32 reg;
>         int ret;
> +       struct realtek_priv *priv =3D ds->priv;

Dito.

> -static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int r=
egnum,
> +static int rtl8366rb_phy_write(struct dsa_switch *ds, int phy, int regnu=
m,
>                                u16 val)
>  {
>         u32 reg;
>         int ret;
> +       struct realtek_priv *priv =3D ds->priv;

Dito.

Other than that it's a great patch, so with these nitpicky changes
feel free to add:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
