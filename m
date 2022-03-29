Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27B34EAD2F
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiC2Mck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiC2Mci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 08:32:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032205F264
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 05:30:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bq8so20847008ejb.10
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 05:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nRQGNy0JNeG8yPE1QXXWKqsK/KgT2iVgd9NOSAmnpao=;
        b=rghn0NZ7veo+c7F9TgovwmfTphDZN1nzJMzcXj5lds+VNPPlWVx4s9Km9UFuESnj9C
         0j6zPwG/Xf6D92JpGQDO2SsY514Cc3dispUkIKCGzRnO4C9HS7T9TWQ6L1NWItI9HoVR
         Wk/smMInsq69ioZO8yNZDu546rixqBUH1Q7RKjgyI+USlKpBx73H+Jxrz2inmb2EkToU
         H2vf7Sa/pckmLcWFoAxiMBDzr7UgHBsB2Q8hra4/Kl5ny0G8cLhgWaE+yEkyTutDGHt1
         d/7ehdh+gvbKH2tMg6SF+fI/PRBhqZLpgBB/Oz9YxV+MxEClGvdSUz2pl20OT0F+Mpvd
         d2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nRQGNy0JNeG8yPE1QXXWKqsK/KgT2iVgd9NOSAmnpao=;
        b=m8KgIRsUxsn8DNoKjeXKMXkI4dq4CM45VORjNADhNINYVBr8QIAxalX5s65YqTlLLn
         TeReu4RLoceMvxbS+QV151vm7Nuknb/mUvQtip6S09zT8E2kOfCYjQ+sY74GlTYckpcH
         N4UFztINZPkz2eKPd3km+wUySVWxtT2KBiNx5guNlqTPVcP3IbkIB4wve8PHC0s4mqUG
         zMWooiaDOXyaiQXY72rsXD3AZV0iv/+t4Y9IWb/jeQ0TlzoKmBKdqkLV1n8tn46I5Tb3
         rwiW88PGfgTxPBn/p4FMgA9rw9W6M335MHrkRaMnHetL6cuhxdGke/8+Slw/XWPV93VG
         +n2A==
X-Gm-Message-State: AOAM530mPVTfBSZuvNJY0q1/YJ7miExDX5njxiQbOibedStrNRmp81S6
        d8oDVQzgxFcTcfIBjzVZu9iteS6022SJwVpqOv5P6Q==
X-Google-Smtp-Source: ABdhPJyPZNX8y3gOGfSZgg3AGAll74j9kjPNXJs0DTpnrEh1/wBVEgROdTkgglF1+DGDwH7nabIubcnQbpp8LiNpfow=
X-Received: by 2002:a17:907:d2a:b0:6e0:963c:97d9 with SMTP id
 gn42-20020a1709070d2a00b006e0963c97d9mr28430774ejc.736.1648557051475; Tue, 29
 Mar 2022 05:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220326165909.506926-1-benni@stuerz.xyz> <20220326165909.506926-9-benni@stuerz.xyz>
In-Reply-To: <20220326165909.506926-9-benni@stuerz.xyz>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 29 Mar 2022 14:30:40 +0200
Message-ID: <CAMRc=Md5qTnP1ZYak4f3hyqmaOR6jT_KL=rNr5cwAOcZ22yXfg@mail.gmail.com>
Subject: Re: [PATCH 09/22] gpio-winbond: Use C99 initializers
To:     =?UTF-8?Q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>, linux@simtec.co.uk,
        Krzysztof Kozlowski <krzk@kernel.org>, alim.akhtar@samsung.com,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>, dave.hansen@linux.intel.com,
        hpa@zytor.com, robert.moore@intel.com,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, lenb@kernel.org,
        3chas3@gmail.com, laforge@gnumonks.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        isdn@linux-pingi.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, nico@fluxnic.net,
        loic.poulain@linaro.org, kvalo@kernel.org, pkshih@realtek.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        devel@acpica.org, linux-atm-general@lists.sourceforge.net,
        netdev <netdev@vger.kernel.org>, linux-edac@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux Input <linux-input@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 6:00 PM Benjamin St=C3=BCrz <benni@stuerz.xyz> wrot=
e:
>
> This replaces comments with C99's designated
> initializers because the kernel supports them now.
>
> Signed-off-by: Benjamin St=C3=BCrz <benni@stuerz.xyz>
> ---
>  drivers/gpio/gpio-winbond.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpio/gpio-winbond.c b/drivers/gpio/gpio-winbond.c
> index 7f8f5b02e31d..0b637fdb407c 100644
> --- a/drivers/gpio/gpio-winbond.c
> +++ b/drivers/gpio/gpio-winbond.c
> @@ -249,7 +249,7 @@ struct winbond_gpio_info {
>  };
>
>  static const struct winbond_gpio_info winbond_gpio_infos[6] =3D {
> -       { /* 0 */
> +       [0] =3D {
>                 .dev =3D WB_SIO_DEV_GPIO12,
>                 .enablereg =3D WB_SIO_GPIO12_REG_ENABLE,
>                 .enablebit =3D WB_SIO_GPIO12_ENABLE_1,
> @@ -266,7 +266,7 @@ static const struct winbond_gpio_info winbond_gpio_in=
fos[6] =3D {
>                         .warnonly =3D true
>                 }
>         },
> -       { /* 1 */
> +       [1] =3D {
>                 .dev =3D WB_SIO_DEV_GPIO12,
>                 .enablereg =3D WB_SIO_GPIO12_REG_ENABLE,
>                 .enablebit =3D WB_SIO_GPIO12_ENABLE_2,
> @@ -277,7 +277,7 @@ static const struct winbond_gpio_info winbond_gpio_in=
fos[6] =3D {
>                 .datareg =3D WB_SIO_GPIO12_REG_DATA2
>                 /* special conflict handling so doesn't use conflict data=
 */
>         },
> -       { /* 2 */
> +       [2] =3D {
>                 .dev =3D WB_SIO_DEV_GPIO34,
>                 .enablereg =3D WB_SIO_GPIO34_REG_ENABLE,
>                 .enablebit =3D WB_SIO_GPIO34_ENABLE_3,
> @@ -294,7 +294,7 @@ static const struct winbond_gpio_info winbond_gpio_in=
fos[6] =3D {
>                         .warnonly =3D true
>                 }
>         },
> -       { /* 3 */
> +       [3] =3D {
>                 .dev =3D WB_SIO_DEV_GPIO34,
>                 .enablereg =3D WB_SIO_GPIO34_REG_ENABLE,
>                 .enablebit =3D WB_SIO_GPIO34_ENABLE_4,
> @@ -311,7 +311,7 @@ static const struct winbond_gpio_info winbond_gpio_in=
fos[6] =3D {
>                         .warnonly =3D true
>                 }
>         },
> -       { /* 4 */
> +       [4] =3D {
>                 .dev =3D WB_SIO_DEV_WDGPIO56,
>                 .enablereg =3D WB_SIO_WDGPIO56_REG_ENABLE,
>                 .enablebit =3D WB_SIO_WDGPIO56_ENABLE_5,
> @@ -328,7 +328,7 @@ static const struct winbond_gpio_info winbond_gpio_in=
fos[6] =3D {
>                         .warnonly =3D true
>                 }
>         },
> -       { /* 5 */
> +       [5] =3D {
>                 .dev =3D WB_SIO_DEV_WDGPIO56,
>                 .enablereg =3D WB_SIO_WDGPIO56_REG_ENABLE,
>                 .enablebit =3D WB_SIO_WDGPIO56_ENABLE_6,
> --
> 2.35.1
>

Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
