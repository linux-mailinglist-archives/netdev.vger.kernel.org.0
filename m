Return-Path: <netdev+bounces-3515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90FE6707A6A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CCFC1C2107D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BF02A9CA;
	Thu, 18 May 2023 06:52:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAC7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:52:32 +0000 (UTC)
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6EB2105
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:52:31 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-55db055b412so24013197b3.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684392750; x=1686984750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LdIUxcLnlvgE1xdJkhW15Ehzq4LjG4WA/TNMayIzpxw=;
        b=q5XA9FhpvNBTNC8QZpWlvNdstEDv4u9tAn2cMfKO3SS9+deSdLusU09nCoAMRG855Z
         CWhHJdh+/jsOOcINYcH3npKVjnQWczcFQjUfpzBkevSP26p7C/3N4tWs3M5CwydcSZ1x
         2qlggBDmHLaeMYFVbnjok4w9h/XkBvQxXEt64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684392750; x=1686984750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdIUxcLnlvgE1xdJkhW15Ehzq4LjG4WA/TNMayIzpxw=;
        b=W8ZZT5FQagfdxqphsHtMSxPqKyEqdc5Kzg81pVnlGApdichreGAa5oNCoVNWEPTAzx
         JObdLxJdeBZ1bJ5FkYFIP94uxDIo6JMnXbLKdfaotiLda40vxsPiPLT6tMW3Owl5TIVZ
         jIfenqHXgrZyYeOXftE8Fpr80rntr6o2Voqq0Henmtv/Howv+yT8jLuTIvtP/kYpDZ0d
         5FdGRONeq4AhS0f29CYkPdQH8OXBEIVU3R0Iss/PJdiUv5z9X+8/Qf//hSl0RTOvTMEK
         wJQvM3Up1dCW8p3NzKqwrSnVNGZ/Cu5teAdeVXoi92gHNfZc2uu/V13kVm8JA7I+M4P9
         0V7A==
X-Gm-Message-State: AC+VfDxo5c3gJz/h17hgeBiTZ1i21KrqrN26OvvVa0b3Am/RlMg6SpfA
	dHb6W+2Ii1R+huqbqMGHOLQIuleJVE7Uou1w4GzeBw==
X-Google-Smtp-Source: ACHHUZ6+MKsPKzjNuD6K1Bux0CRgWbd7RBL4vd4g+VtQBA9Y14+wI/UeAIPL2EB9PElAVZoyxQErG8Ygc0cJHucxuzk=
X-Received: by 2002:a81:5794:0:b0:561:5a0:8141 with SMTP id
 l142-20020a815794000000b0056105a08141mr639218ywb.13.1684392750723; Wed, 17
 May 2023 23:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518090634.6ec6b1e1@canb.auug.org.au> <20230517214200.33398f82@kernel.org>
 <11ab22ff9ecf7e7a330ac45e9ac08bf04aa7f6df.camel@redhat.com>
In-Reply-To: <11ab22ff9ecf7e7a330ac45e9ac08bf04aa7f6df.camel@redhat.com>
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date: Thu, 18 May 2023 08:52:19 +0200
Message-ID: <CABGWkvr-LBVA0XehWHnRaVMT5n-m_V91GzqG4R30fj4QYbuV5g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net tree
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, David Miller <davem@davemloft.net>, 
	Networking <netdev@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

On Thu, May 18, 2023 at 8:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Wed, 2023-05-17 at 21:42 -0700, Jakub Kicinski wrote:
> > On Thu, 18 May 2023 09:06:34 +1000 Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > After merging the net tree, today's linux-next build (arm
> > > multi_v7_defconfig) failed like this:
> > >
> > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > FATAL ERROR: Unable to parse input tree
> > > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f746-d=
isco.dtb] Error 1
> > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > FATAL ERROR: Unable to parse input tree
> > > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f769-d=
isco.dtb] Error 1
> > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > FATAL ERROR: Unable to parse input tree
> > >
> > > Caused by commit
> > >
> > >   0920ccdf41e3 ("ARM: dts: stm32: add CAN support on stm32f746")
> > >
> > > I have used the net tree from next-20230517 for today.
> >
> > Dario, Marc, can we get an immediate fix for this?
>
> Dario, Marc: we are supposed to send the net PR to Linus today. Lacking
> a fix, I'll be forced to revert the mentioned commit in a little time.
>

Marc reverted the commit:
https://lore.kernel.org/all/20230517181950.1106697-1-mkl@pengutronix.de/

Thanks and regards,
Dario

> Thanks!
>
> Paolo
>


--=20

Dario Binacchi

Senior Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com

