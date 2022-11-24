Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF76374AB
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKXJB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKXJBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:01:16 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF81121C9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:01:14 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3691e040abaso9611607b3.9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvetRScBq/s0DVGZvJBwJ/1K4SpuPcPyxQYleNpibXI=;
        b=pMsdQNoNfU0rh35srANZFehK2wR2DJibDRvhXsvvfKZ8dc3tGsVZjZVSIPWC5hKFs/
         uc1NmsQNUv9fA/iisY/7dVUrr3aZBLnDhKIaNL29ixmth1THZj5O2b9+MnsQwJz+hHVx
         /BA0B/VEn1O/ntePJbEdtq1cZljTbYpDd1P/T9vld1cF1gZ0C5n1+myyrNVYvAcyTwX3
         VtGdPeddM8QzCW12kdaKtM64JsTBiilk+JpTomOMbKej1a5+VFhh79hNu53U1VHeRiJz
         pzq3jHy3cZg4E7LZ7FsB6zjnq9KvDwps09ezFsqc6Yn9RyKeLl0b4DW6beWlxeaPfYl+
         6Cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvetRScBq/s0DVGZvJBwJ/1K4SpuPcPyxQYleNpibXI=;
        b=dHGxgsdK+cPz0Jv6ycfFBj2EX/wWmMzweaQJo0L/VUs2xHWD17Ou7t0h0Tc1EO3Ipu
         X1EWcMk4L49OEul7BywVGUUJ7gxvdbjutbtUAE3xEcFjVD05MwhJB7S+irHBb4TwLtxs
         ep9ryNg0Qgx7dacC3/eby6XFzx8OTV8GOC9YMkR2CHDb/SeeYBJ3oyo8NaAR6r5Q/Ljf
         B5uR+mUpxe4DnqEQQyOdzPiWnWwXGan1pNC38w3VzqKJspk/qXJNIciPrpsuW+utlNlY
         ULovz+U3aoFwdaipSp3hslWu/emt5UlhwICkqcUXrnD8NG0KG1FnBP2hAkx95orz3F/N
         FTcA==
X-Gm-Message-State: ANoB5pmPKxavAlCCrUWSO72fYPC9HDkBp4FogGgBSzvKYy6BCWjJed5t
        IQn3VGv3In7TUVK0Z2p0BD7rk2XCaoyJ7fWLQrfb2g==
X-Google-Smtp-Source: AA0mqf7MMgqNAhG6NdPV9XIza2YmYh+WvIZMjbCQOoympHhsVRMd7ekn+yr9vGo/uakzzKReZUID+tOIpiFiSv4TLDQ=
X-Received: by 2002:a81:7909:0:b0:36f:d2d9:cdc4 with SMTP id
 u9-20020a817909000000b0036fd2d9cdc4mr14926932ywc.380.1669280473638; Thu, 24
 Nov 2022 01:01:13 -0800 (PST)
MIME-Version: 1.0
References: <20221108181144.433087-1-nfrayer@baylibre.com> <20221108181144.433087-3-nfrayer@baylibre.com>
 <7775f7ff-b297-eeab-dd46-e7ac5e1c14fb@gmail.com>
In-Reply-To: <7775f7ff-b297-eeab-dd46-e7ac5e1c14fb@gmail.com>
From:   Nicolas Frayer <nfrayer@baylibre.com>
Date:   Thu, 24 Nov 2022 10:01:02 +0100
Message-ID: <CANyCTtSgky6DNPasaLKs1sHpn_YDEoZgKb+WGbgKPd=UkFTeJw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] soc: ti: Add module build support
To:     =?UTF-8?Q?P=C3=A9ter_Ujfalusi?= <peter.ujfalusi@gmail.com>
Cc:     nm@ti.com, ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vkoul@kernel.org,
        dmaengine@vger.kernel.org, grygorii.strashko@ti.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, khilman@baylibre.com, glaroque@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le jeu. 24 nov. 2022 =C3=A0 08:53, P=C3=A9ter Ujfalusi
<peter.ujfalusi@gmail.com> a =C3=A9crit :

Hi Peter,
>
>
>
> On 08/11/2022 20:11, Nicolas Frayer wrote:
> > Added module build support for the TI K3 SoC info driver.
>
> Subject: "soc: ti: k3-socinfo: ..."
>
> >
> > Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
> > ---
> >   arch/arm64/Kconfig.platforms |  1 -
> >   drivers/soc/ti/Kconfig       |  3 ++-
> >   drivers/soc/ti/k3-socinfo.c  | 11 +++++++++++
> >   3 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platform=
s
> > index 76580b932e44..4f2f92eb499f 100644
> > --- a/arch/arm64/Kconfig.platforms
> > +++ b/arch/arm64/Kconfig.platforms
> > @@ -130,7 +130,6 @@ config ARCH_K3
> >       select TI_SCI_PROTOCOL
> >       select TI_SCI_INTR_IRQCHIP
> >       select TI_SCI_INTA_IRQCHIP
> > -     select TI_K3_SOCINFO
> >       help
> >         This enables support for Texas Instruments' K3 multicore SoC
> >         architecture.
> > diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> > index 7e2fb1c16af1..1a730c057cce 100644
> > --- a/drivers/soc/ti/Kconfig
> > +++ b/drivers/soc/ti/Kconfig
> > @@ -74,7 +74,8 @@ config TI_K3_RINGACC
> >         If unsure, say N.
> >
> >   config TI_K3_SOCINFO
> > -     bool
> > +     tristate "TI K3 SoC info driver"
> > +     default y
>
> Why it is a good thing to have this driver as module compared to always
> built in?
> It has no dependencies, just things depending on it.
> It is small, just couple of lines long
>
> I don't really see the benefit of building it as a module, not even an
> academic one...
>

Just to give an update, this series will be dropped as it introduces
dependency issues
with consumer drivers.
The reason why I've enabled the module build support is because it is
required to build
vendor drivers as modules for Android GKI feature.

>
> >       depends on ARCH_K3 || COMPILE_TEST
> >       select SOC_BUS
> >       select MFD_SYSCON
> > diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
> > index 19f3e74f5376..98348f998e0f 100644
> > --- a/drivers/soc/ti/k3-socinfo.c
> > +++ b/drivers/soc/ti/k3-socinfo.c
> > @@ -13,6 +13,7 @@
> >   #include <linux/slab.h>
> >   #include <linux/string.h>
> >   #include <linux/sys_soc.h>
> > +#include <linux/module.h>
> >
> >   #define CTRLMMR_WKUP_JTAGID_REG             0
> >   /*
> > @@ -141,6 +142,7 @@ static const struct of_device_id k3_chipinfo_of_mat=
ch[] =3D {
> >       { .compatible =3D "ti,am654-chipid", },
> >       { /* sentinel */ },
> >   };
> > +MODULE_DEVICE_TABLE(of, k3_chipinfo_of_match);
> >
> >   static struct platform_driver k3_chipinfo_driver =3D {
> >       .driver =3D {
> > @@ -156,3 +158,12 @@ static int __init k3_chipinfo_init(void)
> >       return platform_driver_register(&k3_chipinfo_driver);
> >   }
> >   subsys_initcall(k3_chipinfo_init);
>
> subsys_initcall for a module?

By including module.h, the subsys_initcall() is redefined as
module_init() when built
as a module. When built-in, it is redefined as the usual __initcall.

>
> > +
> > +static void __exit k3_chipinfo_exit(void)
> > +{
> > +     platform_driver_unregister(&k3_chipinfo_driver);
> > +}
> > +module_exit(k3_chipinfo_exit);
> > +
> > +MODULE_DESCRIPTION("TI K3 SoC info driver");
> > +MODULE_LICENSE("GPL");
>
> --
> P=C3=A9ter
