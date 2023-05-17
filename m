Return-Path: <netdev+bounces-3262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D28C70644E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CDA41C20E8C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADB41549A;
	Wed, 17 May 2023 09:40:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB5079D5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:40:39 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B9E3C3B;
	Wed, 17 May 2023 02:40:37 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7591797c638so32981785a.1;
        Wed, 17 May 2023 02:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684316437; x=1686908437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQTixujqPCw/tYDPmFIeEHaqb3XnIBzKysKwZdajktE=;
        b=B6yUg55Kenf0deuKbSfv3k2ZwhsoVSYQ5mcU5PoHqYjg9miRuTy4dSN305XSRWMav/
         sQnY1veAD4vWbHfhjpX2Uib8ZtOAuScnwH6uEKXcJRltAQ7yT/cGvm60oqdwI6vigukB
         RkbBSU7Q7CFXe8nk6DXp1UjkCg3uBLbaX1RhTv/TxWZQNjTMV/mdICiuALAYLfqCJy/P
         Yjv17JTUHLsLrLrpHWcQOAfejS+6UHUR1lbUABYWQZImZPGNegm9xPMlH8FiQqh2u0uZ
         Rxa95d620DcE6YyHAY9zGFOzCdtiY7hptH2T+SoRH7D2zUk8TrPz9tHo/76yGFnArjjo
         b1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684316437; x=1686908437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQTixujqPCw/tYDPmFIeEHaqb3XnIBzKysKwZdajktE=;
        b=hc+zMPZdh2/R8dPJ+/wPm0G6cH9y1i6fh5Mp+CnHue9PML9IM4rzuPap+K92hCIjZq
         gaTn2200LXhCojiWIuxz9mWGGI+gStk54ynj18N7+F6mZxvc2xI66Ge6jk8kJTvUInhg
         UUXEw2XEKCKYG3Njx3z0MQFaTquzhgHVTF5rp9y/1wHhtCFfM1ajkuLm47BZNp7DKADP
         64LMXypxZ4lZMiEfnX6cU0fUL40VREgN3KR17z4fUFdI2mGa+eDpgwNHXiYMPa5zWkSJ
         oK1m+S/kK4Bs7OjjPaohoND6tO/2/ClTW92MfJxkMzMGlgN+de4JzNl+n3GhyldiR1Vt
         023w==
X-Gm-Message-State: AC+VfDwrMWZ8mMg8GfqdrBsHOn9jThQurOY1NYitzQTdjz3gk7k8SZC7
	UZmvjYKjpBZCUVZRk6sVO0W+XHKebYbwwa3IIeA=
X-Google-Smtp-Source: ACHHUZ6vOu6TcYfQCrKrB0vCiSgdmFD/bS6ZZUimdhEXUgrGgywFTtqMOAZblEr8iTv9lThNuyXEtLtS9ImDEed/ozU=
X-Received: by 2002:ad4:5dec:0:b0:621:41f6:1f7b with SMTP id
 jn12-20020ad45dec000000b0062141f61f7bmr43546737qvb.7.1684316436802; Wed, 17
 May 2023 02:40:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-3-jiawenwu@trustnetic.com> <ZGH6TmeiR0icT6Tc@surfacebook>
 <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
In-Reply-To: <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 17 May 2023 12:40:00 +0300
Message-ID: <CAHp75VfsMGfy7y7X79sRhDqTajHsmeDnyUY2YurSvo0=LmxUEg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org, 
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com, 
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch, 
	hkallweit1@gmail.com, linux@armlinux.org.uk, linux-i2c@vger.kernel.org, 
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com, 
	Piotr Raczynski <piotr.raczynski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 11:49=E2=80=AFAM Jarkko Nikula
<jarkko.nikula@linux.intel.com> wrote:
> On 5/15/23 12:24, andy.shevchenko@gmail.com wrote:
> > Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:
> >> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communic=
ate
> >> with SFP.
> >>
> >> Introduce the property "snps,i2c-platform" to match device data for Wa=
ngxun
> >> in software node case. Since IO resource was mapped on the ethernet dr=
iver,
> >> add a model quirk to get regmap from parent device.
> >>
> >> The exists IP limitations are dealt as workarounds:
> >> - IP does not support interrupt mode, it works on polling mode.
> >> - Additionally set FIFO depth address the chip issue.
> >
> > ...
> >
> >>      dev->flags =3D (uintptr_t)device_get_match_data(&pdev->dev);
> >> +    if (device_property_present(&pdev->dev, "snps,i2c-platform"))
> >> +            dev->flags |=3D MODEL_WANGXUN_SP;
> >
> > What I meant here is to use device_property_present() _iff_ you have de=
cided to
> > go with the _vendor-specific_ property name.
> >
> > Otherwise it should be handled differently, i.e. with reading the actua=
l value
> > of that property. Hence it should correspond the model enum, which you =
need to
> > declare in the Device Tree bindings before use.
> >
> > So, either
> >
> >       if (device_property_present(&pdev->dev, "wx,..."))
> >               dev->flags |=3D MODEL_WANGXUN_SP;
> >
> > or
> >
> >       if ((dev->flags & MODEL_MASK) =3D=3D MODEL_NONE) {
> >       // you now have to distinguish that there is no model set in driv=
er data
> >               u32 model;
> >
> >               ret =3D device_property_read_u32(dev, "snps,i2c-platform"=
);
> >               if (ret) {
> >                       ...handle error...
> >               }
> >               dev->flags |=3D model
> >
> I'm not a device tree expert

Me neither, that's why I replied earlier that this needs to be
reviewed by DT people.

> but I wonder would it be possible somehow
> combine this and compatible properties in dw_i2c_of_match[]? They set
> model flag for MODEL_MSCC_OCELOT and MODEL_BAIKAL_BT1.
>
> Then I'm thinking is "snps,i2c-platform" descriptive enough name for a
> model and does it confuse with "snps,designware-i2c" compatible property?



--=20
With Best Regards,
Andy Shevchenko

