Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6DB6D524A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjDCUZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjDCUZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:15 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AC81FD2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:24:39 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q2so9486815qki.3
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 13:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680553475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G/ExHCytE0KsKoc5jrSwhaa1cz3PFYyRhULgZC7gW7Q=;
        b=kLg9nH51oc0t5hg3KdC0+JKn6Z/Omou9jm/jyeSriZPuc2d93Qv4K/3/77Yk5NNHuP
         Lz7r4n6hdmuFKMxz9RhTg8/BlwkFIz/LGJnwGLqQMfEWE7hdd1Hqd/UZRiMfi2jLV+Xg
         OzzIzwDkRzxq9CCOEGx4sgLmJdIZQjhhwLvfXsbABTl2/OTIlhEwPO2/S/b3jpbjoB02
         QIWfDIONUX4pRsy/Hx3Z6QpuDWykcvutmsyV270y8bnhiIpIkZyV/J5Xm6taFjLy28Qp
         VJMdNgGnUSrfMakm1ThWuoE/EBSTTmvCBNuJmHRhI/Sj2wcbZFtnzNvQV8KU4SoclbAj
         +jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G/ExHCytE0KsKoc5jrSwhaa1cz3PFYyRhULgZC7gW7Q=;
        b=sfISsG32ErfyhA6qbsmu5CkAAgpzDjlblAIcSZHNCG8Jl6n+PwMn1rMRsuH26r6rJP
         NPXfap6PXy7ogAYmSYlldMl9bGBYTHtT/163/z4NLqJ6H4LcQ3vN6+0VvKGE0Z6dELrk
         NMIZamwF4wbfKtsZ0sAQ0LlepN9Fo7bsoqNhQgoit72ufhOvY4boNK8yeylNgghthLNH
         sXp0PaJ/3na2aquSWrdt8nqe46ye7/hNzxWdI/DkmQTORwkDwnOwD7Ds8TdiZHhOlAOd
         EpLMwjWrbz0tmRcGFBcEENQngFNz10dYHLth5n0WnAeav0wu6GNDmVBjP26ixrx3Ha5p
         JcUA==
X-Gm-Message-State: AAQBX9dMGsu532z0NhE+s+LpQr098BKbshsYhBVG6hWkb6boTrlFsVYm
        ph2QMVqJ25uoGapI0hz7KNqlngMRVZAdHLDZO88=
X-Google-Smtp-Source: AKy350amFBKA73lgqKcJqzmDy4FiiqtuaOB6aweBRSgdaq7zhmGJ0eFAvYIc6qgXv+WAHXLYPtXFGnIdcH8z3YtSLrQ=
X-Received: by 2002:a05:620a:178f:b0:742:9899:98fb with SMTP id
 ay15-20020a05620a178f00b00742989998fbmr85984qkb.7.1680553475088; Mon, 03 Apr
 2023 13:24:35 -0700 (PDT)
MIME-Version: 1.0
References: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
In-Reply-To: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 3 Apr 2023 13:24:24 -0700
Message-ID: <CAFXsbZq=uzfFjkYw3eWuTjvcGpn6TSoc_OJYCwgthr5jU9qBpQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable support
 for G12A internal PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 12:35=E2=80=AFPM Heiner Kallweit <hkallweit1@gmail.c=
om> wrote:
>
> Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
> recently added tunable support in the smsc driver.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/meson-gxl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index 3dea7c752..bb9b33b6b 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -210,6 +210,10 @@ static struct phy_driver meson_gxl_phy[] =3D {
>                 .read_status    =3D lan87xx_read_status,
>                 .config_intr    =3D smsc_phy_config_intr,
>                 .handle_interrupt =3D smsc_phy_handle_interrupt,
> +
> +               .get_tunable    =3D smsc_phy_get_tunable,
> +               .set_tunable    =3D smsc_phy_set_tunable,
> +
>                 .suspend        =3D genphy_suspend,
Why add the empty lines before and after the two new lines?

>                 .resume         =3D genphy_resume,
>                 .read_mmd       =3D genphy_read_mmd_unsupported,
> --
> 2.40.0
>
