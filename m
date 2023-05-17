Return-Path: <netdev+bounces-3265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45FF706478
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC1891C20EA8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5250C156CB;
	Wed, 17 May 2023 09:45:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4307E156C9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:45:28 +0000 (UTC)
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43AF3;
	Wed, 17 May 2023 02:45:26 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-623802d9bfdso4003126d6.2;
        Wed, 17 May 2023 02:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684316725; x=1686908725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JS7TU0dw9chohgrT5xvtCQpTIgYR3lbaiiLcpefpaLo=;
        b=os65s7tOqkaadzQyRicmkdoLAYTQj0v6whmyzu65LQeDeRRufEMJBtmPVpVUMBXjYr
         CoDc7kWTFiI0ktEYt178+kg9xmiR7ttlDbYCO/5gdiDzdaeFxjcR0JsITbB2p/GJqk3l
         tESeKLkPgGGWkZsyxruFob9aHs9fFPGtiN0ocizzdFg4RHE5x33nVkO6NX+Si4rf/hPq
         zmnAQPXAgsP5Uz6IUHo0JvqhikzPoDidskE+j0CP6wnHGs1ZuFOOgwFayYq76UNKbjgn
         j2KD9wx6QJ+sLWomm7uStgn8nlgFt/tblF4WolsgFTcukTOvBQDrFIWnQY++AjiNiAQS
         1aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684316725; x=1686908725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JS7TU0dw9chohgrT5xvtCQpTIgYR3lbaiiLcpefpaLo=;
        b=df7DCidAvsuWnTuzN5MAVyLCc7+dsUBj3ZJPEjF0kU5HPGNuLTPLHo3b6l7lMg+OuW
         xyr4sC2Wgqb8xnbsyBOJQzkfZB68exOS2R4Js0bVIDv3oRmAaNHDLAjn7h+XkjPjz2L/
         QlTajt2hmUc3Qq+uTjypodfbXmXOUferE435sVoyga99NORGKo35SzhN2QTY2F2pD+ox
         5f0x9oLYp6FqdZHm0fQFqts/32S+y9e0PehwIXF1Ztv29mm3BA2D5YrOxgYpAD0bxnee
         6hA1VFDo4ejSvWY9FaW0MleRkzX6n1J5617AafV561JJECwmynUVWYqvXzoeMuftVJxG
         BnUw==
X-Gm-Message-State: AC+VfDyeY89hhHOiMuxboo+U4Y02Q8vXS4MNVJqFK89A6bvvIlGvGdRK
	ZbBwADxDT49U4/l2SLxgIFC4qpqelBXX9wtyqRo=
X-Google-Smtp-Source: ACHHUZ5vnYRtrnTEZMFMKhPSyBzyWPDPU934xUoRp/94Le0N8uTi8icOW5jaSVj/DC7VR1WYJ4UX8NNqMlwnJ9zx1FU=
X-Received: by 2002:ad4:574a:0:b0:621:562c:4e22 with SMTP id
 q10-20020ad4574a000000b00621562c4e22mr51218619qvx.47.1684316725045; Wed, 17
 May 2023 02:45:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-3-jiawenwu@trustnetic.com> <ZGH6TmeiR0icT6Tc@surfacebook>
 <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com> <018c01d988a1$7f97fe80$7ec7fb80$@trustnetic.com>
In-Reply-To: <018c01d988a1$7f97fe80$7ec7fb80$@trustnetic.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 17 May 2023 12:44:49 +0300
Message-ID: <CAHp75VesUNnBwwccFxRAGTpQ4TcCeg6+tfYuBuSe93uHr=ZC_g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>, netdev@vger.kernel.org, 
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

On Wed, May 17, 2023 at 12:26=E2=80=AFPM Jiawen Wu <jiawenwu@trustnetic.com=
> wrote:
> On Wednesday, May 17, 2023 4:49 PM, Jarkko Nikula wrote:
> > On 5/15/23 12:24, andy.shevchenko@gmail.com wrote:
> > > Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:

...

> > >>    dev->flags =3D (uintptr_t)device_get_match_data(&pdev->dev);
> > >> +  if (device_property_present(&pdev->dev, "snps,i2c-platform"))
> > >> +          dev->flags |=3D MODEL_WANGXUN_SP;
> > >
> > > What I meant here is to use device_property_present() _iff_ you have =
decided to
> > > go with the _vendor-specific_ property name.
> > >
> > > Otherwise it should be handled differently, i.e. with reading the act=
ual value
> > > of that property. Hence it should correspond the model enum, which yo=
u need to
> > > declare in the Device Tree bindings before use.
> > >
> > > So, either
> > >
> > >     if (device_property_present(&pdev->dev, "wx,..."))
> > >             dev->flags |=3D MODEL_WANGXUN_SP;
> > >
> > > or
> > >
> > >     if ((dev->flags & MODEL_MASK) =3D=3D MODEL_NONE) {
> > >     // you now have to distinguish that there is no model set in driv=
er data
> > >             u32 model;
> > >
> > >             ret =3D device_property_read_u32(dev, "snps,i2c-platform"=
);
> > >             if (ret) {
> > >                     ...handle error...
> > >             }
> > >             dev->flags |=3D model
> > >
> > I'm not a device tree expert but I wonder would it be possible somehow
> > combine this and compatible properties in dw_i2c_of_match[]? They set
> > model flag for MODEL_MSCC_OCELOT and MODEL_BAIKAL_BT1.
>
> Maybe the table could be changed to match device property, instead of rel=
ying
> on DT only. Or device_get_match_data() could be also implemented in
> software node case?

This has been discussed [1] and still no visible prototype. Perhaps
you can collaborate with Vladimir on the matter.

[1]: https://lore.kernel.org/lkml/20230223203713.hcse3mkbq3m6sogb@skbuf/

--=20
With Best Regards,
Andy Shevchenko

