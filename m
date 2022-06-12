Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0F9547835
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 03:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiFLBkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 21:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiFLBkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 21:40:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9573D1DC;
        Sat, 11 Jun 2022 18:40:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so2769078pjg.5;
        Sat, 11 Jun 2022 18:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JnWxgn/1wqBRwYVI3n2SXvnPrpmM+qtla3r+d2WQynU=;
        b=Wp1J1mEPkMnDJ9uFyBbVvXkDDFGThKdZFo4XBSUbeGBb1XMi/Nba9+YWQsHqzsjXhQ
         BVvUpcXN+ZFDdJRrijX18mVohJqNPhaMxqofIpJqT6Bo1X5iAZKWzlSYYJVdblDWmSmH
         4jDW10nWXt6ftDdqRLGAsgx6clhJ9EfVU2vS7o7wHsiq8H4fPX8vA99+Tivu9GgCGa5O
         O1yReIu6YTCMFOcogHKTajWosve+mFV+k6ZBhBGhUZRpgJuAmWzVJWOk2wvqjTuD/5xr
         0SBWcVfZAiI6PPWJQSU/YLPbtrPpvhOIgSeyDjifYPI8H8wq0wWK/VtoVHp3+Jvf3rwb
         EFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JnWxgn/1wqBRwYVI3n2SXvnPrpmM+qtla3r+d2WQynU=;
        b=b5Jq14Txw1mMa/wRPYMTGwvW+zSQ+y1shtOO2nxAXuyPhYLpUV8kl8Tigwj+vv3Y72
         8Rxcvclfp3KgtW8or1skXqFZCNDXfknY1DPfjsnmukde7sAt3g21xuF6r7c08KQfnqOh
         V5pwoL0Wpdc9Ul9fYMYivh0w5fH9Z3161+HQuoFLhjvCj8zK2O3yXH73ZHQ9pfX9yYAl
         8hIiNOm9JhGdwoEXh+J4a8T489iw1LKGFlu2K7Z0/MSYd0aKDwjArG7ZAJPCvInmibjr
         h4fNWCBAaMJibk4tNVUzKkDOBlSvB4VvjxbHRjBwNyiOW2aXv/v6hZBRz4qFCYYCX826
         pzjA==
X-Gm-Message-State: AOAM532LG2sv1PiI5aUkRKBheGAsZn3GzX7Fx0CRJuScUZA3c5koABNN
        tsXSUy+K2M8xinpFSGtdyUt+jvorvZ7f0xXfxwc=
X-Google-Smtp-Source: ABdhPJy9nPVKya4joebimGvNZNnfOFgYEcrWQME+z0d/FfPUK+EOeejarp/2Ui5Bqfh80Ngbu2EITrkfTPu1lxdnAKU=
X-Received: by 2002:a17:903:32d2:b0:166:3747:8465 with SMTP id
 i18-20020a17090332d200b0016637478465mr51207202plr.143.1654998044485; Sat, 11
 Jun 2022 18:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220610153829.446516-1-alvin@pqrs.dk> <20220610153829.446516-5-alvin@pqrs.dk>
In-Reply-To: <20220610153829.446516-5-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 11 Jun 2022 22:40:33 -0300
Message-ID: <CAJq09z5gdfZtdoh5i1Bp08M-S6UiATXzcYNMArHxvsi3ch===g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] net: dsa: realtek: rtl8365mb: remove
 learn_limit_max private data member
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
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

> The variable is just assigned the value of a macro, so it can be
> removed.

As I commented previously, the switches in this family with 10 ports
do have a different value for RTL8365MB_LEARN_LIMIT_MAX.
Once we add support for one of those models, we will somewhat revert this p=
atch.

I believe learn_limit_max would fit better inside the new static
chip_info structure.

Regards,

Luiz


> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realte=
k/rtl8365mb.c
> index 3599fa5d9f14..676b88798976 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -563,7 +563,6 @@ struct rtl8365mb_port {
>   * @irq: registered IRQ or zero
>   * @chip_id: chip identifier
>   * @chip_ver: chip silicon revision
> - * @learn_limit_max: maximum number of L2 addresses the chip can learn
>   * @cpu: CPU tagging and CPU port configuration for this chip
>   * @mib_lock: prevent concurrent reads of MIB counters
>   * @ports: per-port data
> @@ -577,7 +576,6 @@ struct rtl8365mb {
>         int irq;
>         u32 chip_id;
>         u32 chip_ver;
> -       u32 learn_limit_max;
>         struct rtl8365mb_cpu cpu;
>         struct mutex mib_lock;
>         struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
> @@ -1088,15 +1086,13 @@ static void rtl8365mb_port_stp_state_set(struct d=
sa_switch *ds, int port,
>  static int rtl8365mb_port_set_learning(struct realtek_priv *priv, int po=
rt,
>                                        bool enable)
>  {
> -       struct rtl8365mb *mb =3D priv->chip_data;
> -
>         /* Enable/disable learning by limiting the number of L2 addresses=
 the
>          * port can learn. Realtek documentation states that a limit of z=
ero
>          * disables learning. When enabling learning, set it to the chip'=
s
>          * maximum.
>          */
>         return regmap_write(priv->map, RTL8365MB_LUT_PORT_LEARN_LIMIT_REG=
(port),
> -                           enable ? mb->learn_limit_max : 0);
> +                           enable ? RTL8365MB_LEARN_LIMIT_MAX : 0);
>  }
>
>  static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int p=
ort,
> @@ -2003,7 +1999,6 @@ static int rtl8365mb_detect(struct realtek_priv *pr=
iv)
>                 mb->priv =3D priv;
>                 mb->chip_id =3D chip_id;
>                 mb->chip_ver =3D chip_ver;
> -               mb->learn_limit_max =3D RTL8365MB_LEARN_LIMIT_MAX;
>                 mb->jam_table =3D rtl8365mb_init_jam_8365mb_vc;
>                 mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc)=
;
>
> --
> 2.36.1
>
