Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC06F0455
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243555AbjD0KnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243094AbjD0KnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:43:06 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414382103;
        Thu, 27 Apr 2023 03:43:05 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75131c2997bso176884185a.1;
        Thu, 27 Apr 2023 03:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682592184; x=1685184184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYgnRNwbIYIIzSu83L1pRc4OTtSlLOx+WGzeWTwcNyo=;
        b=qvISANOZFvBtug/xnJeaLEqFhYyurlT6jR0Y33ITAX9YnoP1ctWjOCxb0dSlwz3NRe
         R0zg8hVag7xnH7SygsgiHR69Q6/x/9EcJCDEmtzffPNnZXCVWPp1RKipibiXT2TLSZRR
         SAE8UYaK9sPX4QTTHLYZm2U86r39LNeNlTeczZn/qF6SK7BjzfmjqVOsgz/qKL9UDQNV
         8JRJOMGFwoceOnXBERYmQCy4LzPxKCAIH70WYyrSR1BFWgqxrgnGWjW48fXnlGg2XHym
         oLMNGB0iTwp661b/SoHWkBxwnCSibP0rpTreNcFGEsn/0yygh74+crsocVG+8rzpdiVh
         n2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682592184; x=1685184184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYgnRNwbIYIIzSu83L1pRc4OTtSlLOx+WGzeWTwcNyo=;
        b=exXrbSgCPqGBm1fi37pe+Z4xuOs5fH0Ra/3qzAGCNQGTYypZ46hhBZkTDI/MGA6tej
         r7f0lzgitPAdJAehbgT6m72jVw4g9/S/B1lNIjQOd9Kbozu2PWoIbISUZhd3KQFmhWE8
         pAcuY2LNbCaKn3P8m6g+N/HMvDBb+IlKa7PRa3cqCNJ4xiRsa88xnOR89sR0REKTJCoA
         cntGwztJAcacxGvDY17zCSHmykIE+GQ9/I546M3aKKCD2jENrsE1UAVy5gQEfwiGBQy8
         Q8wOxb6djfieRoDNis/HAnolAhmKi9dGFI83R5xrQo9OMGA5ooGX0SbrNtCo3TOv5lYc
         xBBQ==
X-Gm-Message-State: AC+VfDzfddHWtwXj7t59oDoa0V0LlY+DRB1KPy4IjGvwX3GGmqpfYKED
        UluvuMKqdw0Hcns0SiehevTXZugCFZP3cN72KaM=
X-Google-Smtp-Source: ACHHUZ7vGjKCD9G5DWKeLljtV40o1yNxj5Obnb0tMJP/f2xNqd15EQpL103oJM2ZcZQxM/JiXR0mMfnVJYEW1o5SnHc=
X-Received: by 2002:a05:622a:1355:b0:3e6:6c6d:94dc with SMTP id
 w21-20020a05622a135500b003e66c6d94dcmr7790620qtk.26.1682592184290; Thu, 27
 Apr 2023 03:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-3-jiawenwu@trustnetic.com> <ZElCHGho-szyySGC@surfacebook>
 <013a01d978ae$182104c0$48630e40$@trustnetic.com> <CAHp75Vdnm1bykoX5Dh9nen7jB5bGfLELw0PvXBcqs1PXTf31rA@mail.gmail.com>
 <015301d978d5$5e74f270$1b5ed750$@trustnetic.com>
In-Reply-To: <015301d978d5$5e74f270$1b5ed750$@trustnetic.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 27 Apr 2023 13:42:28 +0300
Message-ID: <CAHp75Vf54dkq9t9qt0KFjkUyj6sYrYxa8n70NxYiQX_XFJpx-Q@mail.gmail.com>
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

On Thu, Apr 27, 2023 at 9:58=E2=80=AFAM Jiawen Wu <jiawenwu@trustnetic.com>=
 wrote:
> On Thursday, April 27, 2023 1:57 PM, Andy Shevchenko wrote:
> > On Thu, Apr 27, 2023 at 5:15=E2=80=AFAM Jiawen Wu <jiawenwu@trustnetic.=
com> wrote:
> > > On Wednesday, April 26, 2023 11:45 PM, andy.shevchenko@gmail.com wrot=
e:
> > > > Wed, Apr 26, 2023 at 03:14:27PM +0800, Jiawen Wu kirjoitti:

...

> > > > > +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> > > > > +{
> > > > > +   struct platform_device *pdev =3D to_platform_device(dev->dev)=
;
> > > > > +   struct resource *r;
> > > > > +
> > > > > +   r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > +   if (!r)
> > > > > +           return -ENODEV;
> > > > > +
> > > > > +   dev->base =3D devm_ioremap(&pdev->dev, r->start, resource_siz=
e(r));
> > > > > +
> > > > > +   return PTR_ERR_OR_ZERO(dev->base);
> > > > > +}
> > > >
> > > > Redundant. See below.

...

> > > > >     case MODEL_BAIKAL_BT1:
> > > > >             ret =3D bt1_i2c_request_regs(dev);
> > > > >             break;
> > > > > +   case MODEL_WANGXUN_SP:
> > > > > +           ret =3D txgbe_i2c_request_regs(dev);
> > > >
> > > > How is it different to...
> > > >
> > > > > +           break;
> > > > >     default:
> > > > >             dev->base =3D devm_platform_ioremap_resource(pdev, 0)=
;
> > > >
> > > > ...this one?
> > >
> > > devm_platform_ioremap_resource() has one more devm_request_mem_region=
()
> > > operation than devm_ioremap(). By my test, this memory cannot be re-r=
equested,
> > > only re-mapped.
> >
> > Yeah, which makes a point that the mother driver requests a region
> > that doesn't belong to it. You need to split that properly in the
> > mother driver and avoid requesting it there. Is it feasible? If not,
> > why?
>
> The I2C region belongs to the middle part of the total region. It was not=
 considered to
> split because the mother driver implement I2C bus master driver itself in=
 the previous
> patch. But is it suitable for splitting? After splitting, I get two virtu=
al address, and each
> time I read/write to a register, I have to determine which region it belo=
ngs to...Right?

If it's in the middle there are two (maybe more, but I can't right now
come up with) possible solutions:
1/ mother driver can provide a regmap, then in the children drivers
the dev_get_regmap(pdev->dev.parent) will return it (see
intel_soc_pmic_*.c set of drivers, IIRC they work with this schema in
mind)
2/ in the mother driver you need to open code remapping resource in a
way that it does ioremap and request regions separately.

The problem with your current approach is that you request a region in
the driver which does not handle that part of IO space and belongs to
another one. It's a clear layering violation. (Note, we already have
one big driver that does something like this and we have to learn from
it not to be trapped by making the same mistake).


--=20
With Best Regards,
Andy Shevchenko
