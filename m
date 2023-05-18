Return-Path: <netdev+bounces-3618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A272F70813E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D73C22817A6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB66219E5F;
	Thu, 18 May 2023 12:27:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB5711C95
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:27:39 +0000 (UTC)
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453FD10CF;
	Thu, 18 May 2023 05:27:38 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-6238b15d298so10726416d6.0;
        Thu, 18 May 2023 05:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684412857; x=1687004857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQoMC7PnUwqXFKcs7QjHsSDHRS6nX1bw9OLvJjHMB7Q=;
        b=kWpHM7BVQdzVfVGxEOhfc1vdoqdyDNfCeOeK7dejyFcl6SpkxB0/nd7YVcTfqrZDyz
         ifHPMuhi/H4D8kIw3LH7Rq6tcUj3fF2AEQJJVzSWowsawtK7kwh7hkKOwtp5JM0+AOJ3
         8vHc31pEoqoxsYcNA59bAqPsQ/p6rCXUDmYbs2rlxl+WXzw99eC1gBmDTmMQqZbQQbNS
         zW7LSVky8+lbMsVxxvRSBHD/YLc6Ru1B8ibf4Owp5TXVhlPXw/x5m7Y3KP4q1cur5Ll5
         RvK1X98NakFL+jLHsKqpa/UujX9wm6zY7QvtIBjRXLlum7/QY5S0MeE/nsVOpu5+on5m
         kAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684412857; x=1687004857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQoMC7PnUwqXFKcs7QjHsSDHRS6nX1bw9OLvJjHMB7Q=;
        b=bw5SbJObO9IvmlbcpafAVKK8wQMtvOwf+Yw+wZznbF1lr3U90VSY60tSiAYDESUnWb
         vEtvmDKLFV7hhwMp/tQ79M2TH3k4TqweadI1o5DGP97MrC0eMr6Z+1skbH44T5vtgRUH
         ET7B6kOTvL5kbTTdCo9OJweVnn0q1Hw2YzqtkCpHIoEiR7vgoMfEuGM0kRm0xfqSCoP9
         dXkiDHktX3wF8vT8z0XCeKIroqtQC37o8irKs40HoU54OFQsBjsnEY2Z5XEaDlsQKZpG
         OM2E1WEiZ0Q6P4pKPuB1libpcUJyRBlqAKXv4luM1sYvJQGfb0wKuP1eQ4KYxENRsxTT
         3G8g==
X-Gm-Message-State: AC+VfDyKf70yqhcvyrgtIMz2n9EpNcmhTzyWKw253ImKXJ/D9dXIqdLI
	f9C/pSPPsYJhcnhz8qpqQph5p0YfyCtiSV/qJbg=
X-Google-Smtp-Source: ACHHUZ7Ydjq++lZXwmJmSS/AoH22qIonePEogztxhDAG3qmnb3/ka7+iImbyOGktaDx9skftuUUuzWwCBMHko3kwb7o=
X-Received: by 2002:a05:6214:234f:b0:61b:7e5a:ec00 with SMTP id
 hu15-20020a056214234f00b0061b7e5aec00mr4674842qvb.37.1684412857290; Thu, 18
 May 2023 05:27:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
 <025b01d9897e$d8894660$899bd320$@trustnetic.com>
In-Reply-To: <025b01d9897e$d8894660$899bd320$@trustnetic.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 18 May 2023 15:27:00 +0300
Message-ID: <CAHp75VfuB5dHp1U+G2OFpupMnbBJv=aHRWaBHemtPU-xOZA_3g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
To: Jiawen Wu <jiawenwu@trustnetic.com>, Michael Walle <michael@walle.cc>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org, jarkko.nikula@linux.intel.com, 
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com, 
	jsd@semihalf.com, Jose.Abreu@synopsys.com, hkallweit1@gmail.com, 
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org, 
	mengyuanlou@net-swift.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 2:50=E2=80=AFPM Jiawen Wu <jiawenwu@trustnetic.com>=
 wrote:
> On Wednesday, May 17, 2023 11:01 PM, Andrew Lunn wrote:
> > On Wed, May 17, 2023 at 10:55:01AM +0800, Jiawen Wu wrote:

...

> > > I should provide gpio_regmap_config.irq_domain if I want to add the g=
pio_irq_chip.
> > > But in this use, GPIO IRQs are requested by SFP driver. How can I get=
 irq_domain
> > > before SFP probe? And where do I add IRQ parent handler?
> >
> > I _think_ you are mixing upstream IRQs and downstream IRQs.
> >
> > Interrupts are arranged in trees. The CPU itself only has one or two
> > interrupts. e.g. for ARM you have FIQ and IRQ. When the CPU gets an
> > interrupt, you look in the interrupt controller to see what external
> > or internal interrupt triggered the CPU interrupt. And that interrupt
> > controller might indicate the interrupt came from another interrupt
> > controller. Hence the tree structure. And each node in the tree is
> > considered an interrupt domain.
> >
> > A GPIO controller can also be an interrupt controller. It has an
> > upstream interrupt, going to the controller above it. And it has
> > downstream interrupts, the GPIO lines coming into it which can cause
> > an interrupt. And the GPIO interrupt controller is a domain.
> >
> > So what exactly does gpio_regmap_config.irq_domain mean? Is it the
> > domain of the upstream interrupt controller? Is it an empty domain
> > structure to be used by the GPIO interrupt controller? It is very
> > unlikely to have anything to do with the SFP devices below it.
>
> Sorry, since I don't know much about interrupt,  it is difficult to under=
stand
> regmap-irq in a short time. There are many questions about regmap-irq.

That's why I Cc'ed to Michael who is the author of gpio-regmap to
probably get advice from.

> When I want to add an IRQ chip for regmap, for the further irq_domain,
> I need to pass a parameter of IRQ, and this IRQ will be requested with ha=
ndler:
> regmap_irq_thread(). Which IRQ does it mean? In the previous code of usin=
g
> devm_gpiochip_add_data(), I set the MSI-X interrupt as gpio-irq's parent,=
 but
> it was used to set chained handler only. Should the parent be this IRQ? I=
 found
> the error with irq_free_descs and irq_domain_remove when I remove txgbe.k=
o.
>
> As you said, the interrupt of each tree node has its domain. Can I unders=
tand
> that there are two layer in the interrupt tree for MSI-X and GPIOs, and r=
equesting
> them separately is not conflicting? Although I thought so, but after I im=
plement
> gpio-regmap, SFP driver even could not find gpio_desc. Maybe I missed som=
ething
> on registering gpio-regmap...
>
> Anyway it is a bit complicated, could I use this version of GPIO implemen=
tation if
> it's really tough?

It's possible but from GPIO subsystem point of view it's discouraged
as long as there is no technical impediment to go the regmap way.

--=20
With Best Regards,
Andy Shevchenko

