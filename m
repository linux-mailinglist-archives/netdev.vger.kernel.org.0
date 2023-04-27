Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6AA6F0093
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242899AbjD0F5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbjD0F5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:57:42 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE951FE7;
        Wed, 26 Apr 2023 22:57:41 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3ef4daaf906so37753231cf.1;
        Wed, 26 Apr 2023 22:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682575060; x=1685167060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbgJvTv0yakRZ7pNU5qipSnootB9dMKqXoVGSrBCgEk=;
        b=LQFoSinlPAaUKSIFJtfcUcqZ3dkvMuX4ygiWFzuCdd0DphT21hueAh3S4Na+QZEBUp
         +ZGOytAL+ZOZm2+z1qGOAs+jzMp5FP0n0ZaEN0in8Dr+pzf0EBnS/Xg42O4u+2h6/tOu
         fPclUYovx5kATGdKcBoiPnRprkhLLFlJjdo52kGiMdESFFkNPKcz15fmPhSvF1ORjupH
         o5gBYfsuN/g44wzzmWFWfTl29jxVfNYFNt1rE0mJ+YF99k0YhjDwBmi/n2KTZjiDZDZ7
         6UzLnDekN8pEoTU7CFddPgKtdAAaPpfC0/joimK0iQCfFmKwCyqhrh2jgY5nulDO2CbG
         DYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682575060; x=1685167060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbgJvTv0yakRZ7pNU5qipSnootB9dMKqXoVGSrBCgEk=;
        b=hZRr7DoXpma2IKDvGithj2G4ilyw8mrLRwUHdul2hNpXCzded3So4p+lVtJwz13ORL
         xpydtBOmhDdz6ODM6+yQuparf+9A7UbJd4E8FhMAXDHEqCbC8XmH5AjG78Rud3OQffhZ
         URpdXcY4wDbj3qHQ/JS4OHKTPEq+v/YJks8JnCPIEVqpixzmzZAfJmlQUIqbR5flUjcf
         cLt7VocHYtQnFxM4BaJdVxD1c/9tpmksMf1k0Q69PFjW1+42UjD5EA1Lu339t8o7gpWm
         1VQit26rXRNM1KmHLVaBGFeI+6GH6lWnNZGk671BNoDb114wCj8n+e0lTKhK4aKnstsg
         BzYA==
X-Gm-Message-State: AC+VfDyWsB+oVlHwMMUeme0TJN2cZcgvEdEQwrlpO2Nt38A70jP5To12
        wbbNH2PHNaaqclPZ5wDSb84bda0xmE16/mI2CDVX5G/sjBcNaA==
X-Google-Smtp-Source: ACHHUZ4SwTUlaZN7rkwrqmE2/3VFRuukBkRGg0zeLpC3A1mPER/WYxh9qF14K9aIrYdivlQirwoTKTSYkVHHtz3WuEI=
X-Received: by 2002:ac8:5709:0:b0:3ef:ed2:3e60 with SMTP id
 9-20020ac85709000000b003ef0ed23e60mr529331qtw.43.1682575060548; Wed, 26 Apr
 2023 22:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-3-jiawenwu@trustnetic.com> <ZElCHGho-szyySGC@surfacebook>
 <013a01d978ae$182104c0$48630e40$@trustnetic.com>
In-Reply-To: <013a01d978ae$182104c0$48630e40$@trustnetic.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 27 Apr 2023 08:57:04 +0300
Message-ID: <CAHp75Vdnm1bykoX5Dh9nen7jB5bGfLELw0PvXBcqs1PXTf31rA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v5 2/9] i2c: designware: Add driver support
 for Wangxun 10Gb NIC
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
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

On Thu, Apr 27, 2023 at 5:15=E2=80=AFAM Jiawen Wu <jiawenwu@trustnetic.com>=
 wrote:
> On Wednesday, April 26, 2023 11:45 PM, andy.shevchenko@gmail.com wrote:
> > Wed, Apr 26, 2023 at 03:14:27PM +0800, Jiawen Wu kirjoitti:

...

> > > +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> > > +{
> > > +   struct platform_device *pdev =3D to_platform_device(dev->dev);
> > > +   struct resource *r;
> > > +
> > > +   r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +   if (!r)
> > > +           return -ENODEV;
> > > +
> > > +   dev->base =3D devm_ioremap(&pdev->dev, r->start, resource_size(r)=
);
> > > +
> > > +   return PTR_ERR_OR_ZERO(dev->base);
> > > +}
> >
> > Redundant. See below.

...

> > >     case MODEL_BAIKAL_BT1:
> > >             ret =3D bt1_i2c_request_regs(dev);
> > >             break;
> > > +   case MODEL_WANGXUN_SP:
> > > +           ret =3D txgbe_i2c_request_regs(dev);
> >
> > How is it different to...
> >
> > > +           break;
> > >     default:
> > >             dev->base =3D devm_platform_ioremap_resource(pdev, 0);
> >
> > ...this one?
>
> devm_platform_ioremap_resource() has one more devm_request_mem_region()
> operation than devm_ioremap(). By my test, this memory cannot be re-reque=
sted,
> only re-mapped.

Yeah, which makes a point that the mother driver requests a region
that doesn't belong to it. You need to split that properly in the
mother driver and avoid requesting it there. Is it feasible? If not,
why?

...

> > >     dev->flags =3D (uintptr_t)device_get_match_data(&pdev->dev);
> >
> > > +   if (!dev->flags)
> >
> > No need to check this. Just define priorities (I would go with above to=
 be
> > higher priority).
> >
> > > +           device_property_read_u32(&pdev->dev, "i2c-dw-flags", &dev=
->flags);
> >
> > Needs to be added to the Device Tree bindings I believe.
> >
> > But wait, don't we have other ways to detect your hardware at probe tim=
e and
> > initialize flags respectively?
>
> I2C is connected to our NIC chip with no PCI ID, so I register a platform=
 device for it.
> Please see the 4/9 patch. Software nodes are used to pass the device stru=
cture but
> no DT and ACPI. I haven't found another way to initialize flags yet, othe=
r than the
> platform data used in the previous patch (it seems to be an obsolete way)=
.

You can share a common data structure between the mother driver and
her children. In that case you may access it via
`dev_get_drvdata(pdev.dev->parent)` call.

OTOH, the property, if only Linux (kernel) specific for internal
usage, should be named accordingly, or be prepared to have one in
Device Tree / ACPI / etc. Examples: USB dwc3 driver (see "linux,"
ones), or intel-lpss-pci.c/intel-lpss-acpi.c (see the SPI type).

--=20
With Best Regards,
Andy Shevchenko
