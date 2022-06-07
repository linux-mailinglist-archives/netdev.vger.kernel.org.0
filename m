Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6812D54013B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245391AbiFGOXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245408AbiFGOXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:23:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E4AEABA1;
        Tue,  7 Jun 2022 07:23:52 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so20950528pjl.4;
        Tue, 07 Jun 2022 07:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a9HfVW17dxPowaFnT2mXtkCX/E8emMITEyMLwiyTVkg=;
        b=Xv5SNQfwwRE7/iVegGgC2rCLpaMrSYGaHhQDnbxDcPXmV8Df47dGp+rIOVg9yu3Isb
         GI8AwbaePfyxZPx4+2Zi95o9bBkVwUcqPonpPkG09Co52Wk4peG+O1Yt82Gkka98UAka
         6gIJJh1+7+YnZhtK6fcJ94br5y/UmgzxMOq8NBY9cT2EktOfdLUW61D10xMM2eeIrpDN
         fglHzpk3Ab+25wVLo/ll6GUSHwSiAG26EC3WjAhWmu84mNNSJaT48V034T6Q8M7VdGGJ
         EXYib4Dp9Xtho5JCe/s+sIF443XpYROtVW7WJgM1nxXdvP1xAhgaVNo/3GgRcSvcnkFn
         fFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a9HfVW17dxPowaFnT2mXtkCX/E8emMITEyMLwiyTVkg=;
        b=06gn53fOkwGDQX8gfDJHAwwNKSFNk9SN4weriaA6fC6HAs35Il/T9mOjNZpfkDwsEE
         O0oDax5bs8BLNwHCevk/pG8X+Y12sw/G7J/7CFl1xy2r0m/GTfnXfVeJg+7mA8Vw1V/d
         8ni6qgHdL08glIfeM+GjlsPDWZ4LqSl1PWqoPCeEo/XODsU2W3jwYUoCXPnecoQ5skpB
         JEKoYaqYNKissIMdp0Iys90H6kNGtvrRbn2/vjlGNx9VC95jvJy7essto0OYXa3Jsx0D
         lofPwqMfPR9zp/QJlJIyAg0h6pc+1uc8IgLbaTJSj8dJ2Pa/rvFu2oWd4qAVWl6w9mCh
         MYoQ==
X-Gm-Message-State: AOAM532YW9Pgv/Ak+IuagsXJESy9OXQ9UQPgkGdtfNKGldFxw0wrhayu
        yt+v9Qsx/uflCdSCdhlvm/39iRz5oxJFqxIFU6Q=
X-Google-Smtp-Source: ABdhPJzG9mlso5RyygzzP9Q0jn2BCiPgRSWzusTjeftT3K7Laty41V3lt9GPwNVy90UYvCe93uf67brhFKIaDD0ehzk=
X-Received: by 2002:a17:903:32d2:b0:166:3747:8465 with SMTP id
 i18-20020a17090332d200b0016637478465mr29083003plr.143.1654611831619; Tue, 07
 Jun 2022 07:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-6-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-6-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 11:23:40 -0300
Message-ID: <CAJq09z7gRosx0uBRCyP6xc0GUFMgnKCdry3BL-iB13M=JEY3hQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> Realtek switches in the rtl8365mb family always have at least one port
> with a so-called external interface, supporting PHY interface modes such
> as RGMII or SGMII. The purpose of this patch is to improve the driver's
> handling of these ports.
>
> A new struct rtl8365mb_chip_info is introduced. A static instance of
> this struct is added for each supported switch, which is distinguished
> by its chip ID and version. Embedded in each chip_info struct is an
> array of struct rtl8365mb_extint, describing the external interfaces
> available. This is more specific than the old rtl8365mb_extint_port_map,
> which was only valid for switches with up to 6 ports.
>
> The struct rtl8365mb_extint also contains a bitmask of supported PHY
> interface modes, which allows the driver to distinguish which ports
> support RGMII. This corrects a previous mistake in the driver whereby it
> was assumed that any port with an external interface supports RGMII.
> This is not actually the case: for example, the RTL8367S has two
> external interfaces, only the second of which supports RGMII. The first
> supports only SGMII and HSGMII. This new design will make it easier to
> add support for other interface modes.
>
> Finally, rtl8365mb_phylink_get_caps() is fixed up to return supported
> capabilities based on the external interface properties described above.
> This allows for ports with an external interface to be treated as DSA
> user ports, and for ports with an internal PHY to be treated as DSA CPU
> ports.

That's a nice patch. But while dealing with ext interfaces, wouldn't
it be nice to also add
a mask for user ports? We could easily validate if a declared dsa port
really exists.

...

> @@ -1997,33 +2122,27 @@ static int rtl8365mb_detect(struct realtek_priv *=
priv)
>         case RTL8365MB_CHIP_ID_8365MB_VC:
>                 switch (chip_ver) {
>                 case RTL8365MB_CHIP_VER_8365MB_VC:
> -                       dev_info(priv->dev,
> -                                "found an RTL8365MB-VC switch (ver=3D0x%=
04x)\n",
> -                                chip_ver);
> +                       mb->chip_info =3D &rtl8365mb_chip_info_8365mb_vc;
>                         break;
>                 case RTL8365MB_CHIP_VER_8367RB_VB:
> -                       dev_info(priv->dev,
> -                                "found an RTL8367RB-VB switch (ver=3D0x%=
04x)\n",
> -                                chip_ver);
> +                       mb->chip_info =3D &rtl8365mb_chip_info_8367rb_vb;
>                         break;
>                 case RTL8365MB_CHIP_VER_8367S:
> -                       dev_info(priv->dev,
> -                                "found an RTL8367S switch (ver=3D0x%04x)=
\n",
> -                                chip_ver);
> +                       mb->chip_info =3D &rtl8365mb_chip_info_8367s;
>                         break;
>                 default:
> -                       dev_err(priv->dev, "unrecognized switch version (=
ver=3D0x%04x)",
> -                               chip_ver);
> +                       dev_err(priv->dev,
> +                               "unrecognized switch (id=3D0x%04x, ver=3D=
0x%04x)",
> +                               chip_id, chip_ver);
>                         return -ENODEV;
>                 }

With this patch, we now have a nice chip_info for each device. If we
group all of them in an array, we could iterate over them instead of
switching over chip_id/ver. In this case, adding a new variant is just
a matter of creating a new chip_info and adding to the array. When the
chip id/ver is only used inside a single chip_info, I don't know if we
should keep a macro declaring each value. For example,

#define RTL8365MB_CHIP_ID_8367S         0x6367
#define RTL8365MB_CHIP_VER_8367S        0x00A0
...
+static const struct rtl8365mb_chip_info rtl8365mb_chip_info_8367s =3D {
+       .name =3D "RTL8367S",
+       .chip_id =3D RTL8365MB_CHIP_ID_8367S,
+       .chip_ver =3D RTL8365MB_CHIP_VER_8367S,
+       .extints =3D {
+               { 6, 1, PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+               { 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
+                       PHY_INTF(RGMII) },
+               { /* sentinel */ }
+       },
+       .jam_table =3D rtl8365mb_init_jam_8365mb_vc,
+       .jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+};

seems to be as clear as:

+static const struct rtl8365mb_chip_info rtl8365mb_chip_info_8367s =3D {
+       .name =3D "RTL8367S",
+       .chip_id =3D 0x6367,
+       .chip_ver =3D 0x00A0,
+       .extints =3D {
+               { 6, 1, PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+               { 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
+                       PHY_INTF(RGMII) },
+               { /* sentinel */ }
+       },
+       .jam_table =3D rtl8365mb_init_jam_8365mb_vc,
+       .jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+};

but smaller and not spread over the source.

Regards,

Luiz
