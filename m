Return-Path: <netdev+bounces-3269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBE3706513
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDA881C20DB2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9947156E5;
	Wed, 17 May 2023 10:27:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD285258
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:27:29 +0000 (UTC)
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FA63593;
	Wed, 17 May 2023 03:27:27 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-62382e9cb8dso2502486d6.2;
        Wed, 17 May 2023 03:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684319246; x=1686911246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ku64YlOXwUxGtel5r5oqM49Sg3shr54C7DoQNtG9SWE=;
        b=Z8y8hEBAAy/x2l1v2K3Mo0fK7tDWMoNmGGS4DyQEdxhliI6FH8gAwTDXGlhs7PhdiP
         FrPBMbSlay9o1nZYMjlf0N9Sd/8d/4LW8hCZEYdsLLxPgxHORBy3et8wcJiEVSLx/5ZB
         I974dS0vF+yQ7IMYmWs70uPO/AXLbXCiSjCjH/ooWPTPSF6bZByLTEEF/oJV85Nur7Gh
         4LR0oHYeZCd0KrMGLicL8U0RDYWjLYYGeBRgat/xRDhqekCBac+EBzgG0H05/ZSwLIQn
         BXP1lPkP/ObdpHrwDe/yCeL5gjQK07C39GW0baQOALmpJ8e02scBsmzc4ceR1Vm/DeaP
         YY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684319246; x=1686911246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ku64YlOXwUxGtel5r5oqM49Sg3shr54C7DoQNtG9SWE=;
        b=ZElGIEd0Z7v42nLWN4KsYMZb3Mf3AsyVrhfgJ+68gWGpuRq5R6Deg8VHJGTM8WWmNh
         GN5UKTuuypVI62LLzAGEzdp+uNr+HHzDrepFiO5wZRw4MfAnflV7Rb/5n5XzqHmFZfc/
         OsFIgTl685roYx4T8yv7P4gwTrwPAmpG1xz5wKXd0rbQk3wBb8tXfZluhpIvaRKjUakZ
         8TsDevNU9hJDtLPht9ytXZnsnbnF0vxz2b+cMEaucf+fLvMO1Cs+AtOXl3cKRpVBy5hq
         XV4A6dA7AdKdNzsZu8qit2Gns5TUXgmD8jXo8qM72nZbr0FwSlle+RJjx52DR9rmPvP/
         0GuA==
X-Gm-Message-State: AC+VfDyapJFj9FHMWpgPLIIRHHRWtIjD5wqfhJrdEigH9gwf+aaSOwql
	zXZLMX7YLAR0c/FIl7p/Zkmd3EmQPZNKf4elZUo=
X-Google-Smtp-Source: ACHHUZ485OFyNu+ycRGjAf7Qnz3U9tS6SpSvYbCi0Z4yVeAnTH5CAff9ZUxz+TUlUrBP7irZbAW7BoVe8vO3isbBRbs=
X-Received: by 2002:ad4:5dc9:0:b0:623:557d:91a9 with SMTP id
 m9-20020ad45dc9000000b00623557d91a9mr20788736qvh.31.1684319246574; Wed, 17
 May 2023 03:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
In-Reply-To: <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 17 May 2023 13:26:50 +0300
Message-ID: <CAHp75VfaU7avRi-aj0NbKD_HD3Ma+gXwwoNW0iz+YXizrdnmuA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
To: Jiawen Wu <jiawenwu@trustnetic.com>, Michael Walle <michael@walle.cc>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com, 
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com, 
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch, 
	hkallweit1@gmail.com, linux@armlinux.org.uk, linux-i2c@vger.kernel.org, 
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 5:56=E2=80=AFAM Jiawen Wu <jiawenwu@trustnetic.com>=
 wrote:
>
> > > > > +   gc =3D devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
> > > > > +   if (!gc)
> > > > > +           return -ENOMEM;
> > > > > +
> > > > > +   gc->label =3D devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x"=
,
> > > > > +                              (wx->pdev->bus->number << 8) | wx-=
>pdev->devfn);
> > > > > +   gc->base =3D -1;
> > > > > +   gc->ngpio =3D 6;
> > > > > +   gc->owner =3D THIS_MODULE;
> > > > > +   gc->parent =3D dev;
> > > > > +   gc->fwnode =3D software_node_fwnode(txgbe->nodes.group[SWNODE=
_GPIO]);
> > > >
> > > > Looking at the I=C2=B2C case, I'm wondering if gpio-regmap can be u=
sed for this piece.
> > >
> > > I can access this GPIO region directly, do I really need to use regma=
p?
> >
> > It's not a matter of access, it's a matter of using an existing
> > wrapper that will give you already a lot of code done there, i.o.w.
> > you don't need to reinvent a wheel.
>
> I took a look at the gpio-regmap code, when I call devm_gpio_regmap_regis=
ter(),
> I should provide gpio_regmap_config.irq_domain if I want to add the gpio_=
irq_chip.
> But in this use, GPIO IRQs are requested by SFP driver. How can I get irq=
_domain
> before SFP probe? And where do I add IRQ parent handler?

Summon Michael who can probably answer this better than me.

--=20
With Best Regards,
Andy Shevchenko

