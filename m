Return-Path: <netdev+bounces-4657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9D470DB40
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466B62812FA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341B44A858;
	Tue, 23 May 2023 11:10:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D354A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:10:54 +0000 (UTC)
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF84121;
	Tue, 23 May 2023 04:10:40 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-62577da77d0so11013366d6.2;
        Tue, 23 May 2023 04:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684840239; x=1687432239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOWmJda5SbAjg1Q/q+OVszHEV/UtN0kJreVGiB6t0X8=;
        b=YBFTcbE25Zw7lgrUsnlgmRC5tmZcrlha7oTeGNCC2lsVrWf1NH+FALrh3GbYYW/gVK
         V44PrQZDxk6CH3f4CUfnplJhwxkchiOVRLSpl1H0IwxM+lT2ICH1M6y2NpQKIF3mrRB9
         kOS27joqfvRcXrqjw7bOccHNgHzcMiaUddG4ilVhuv2hgHp4k0kg9ZcKWFcouboSjpz3
         0re0NbCPIBS6/MOxmRTnUfEAnyFJNcZRE5+6WOyofeT2B3RpljmjbeT3k7co8Y0thsx/
         WMDQir7eedmkO1pSHpdSQWFNda+8WybH/NVA7ME5zZKK4y4nJNUvY2DjGzo97A9H7RAm
         qOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684840239; x=1687432239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOWmJda5SbAjg1Q/q+OVszHEV/UtN0kJreVGiB6t0X8=;
        b=E8jvLVqDyCce7y33ZMfft4d6/ZvRDDXvhEhcAHfwlJ0Le6iHX8mbj8LOkkQ93DTH3J
         wq5ahiJEpGDe6FPHBiByDfYJrSnAQA7HlL3DFGZDitd2L05HkPHVRs/+I+YHpc+9pKNA
         wgUuq9j6Axj3BY5OADpfNha/CR0az5RQAGIGZEWa0CbKQSQOoiCEpsYoF0mOu/xQGWIM
         hD/S9CaiETqHnJCP57WAY2pxmELDUTYsiFmR+1pPBAmPYBMyzUzlWOi6X5Je951hqQM6
         DpwEgozLZV3SnZzqVdkvTSSRdJ7XuW3Zt6eJtBWvAqOPUEBCAB/UKJ0zyx5bu1RhoSp3
         Futg==
X-Gm-Message-State: AC+VfDwkg/Ne7hD+NNwEqIqkduk73nlbhS873FQASPyQjliArBt28BxD
	4KW+/DDZiJKSaDLiim5QjYrSldQ3MhPZmalfDD4=
X-Google-Smtp-Source: ACHHUZ5g6G8bxkKCC9AMoWunRTUOr4oKHkZwqp0AJDEc5a7Mpa5fVUwqzPYGS2iZ4JoUq+0gG2vuHX3wH2Yb2tF4qCc=
X-Received: by 2002:ad4:5b8c:0:b0:5a3:cbc6:8145 with SMTP id
 12-20020ad45b8c000000b005a3cbc68145mr21037922qvp.19.1684840239590; Tue, 23
 May 2023 04:10:39 -0700 (PDT)
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
 <025b01d9897e$d8894660$899bd320$@trustnetic.com> <CAHp75VfuB5dHp1U+G2OFpupMnbBJv=aHRWaBHemtPU-xOZA_3g@mail.gmail.com>
 <013101d98d5c$b8fdd1d0$2af97570$@trustnetic.com> <CAHp75Vc=i2ft=M-gdXYDMeTAmK4RcPbZpmiy1pEjO-jOVD_pgA@mail.gmail.com>
In-Reply-To: <CAHp75Vc=i2ft=M-gdXYDMeTAmK4RcPbZpmiy1pEjO-jOVD_pgA@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 23 May 2023 14:10:03 +0300
Message-ID: <CAHp75Ve5c-ak9B_ZSZMayubBA+tP-im3jJf89ZW7xcebv5EsLQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
To: Jiawen Wu <jiawenwu@trustnetic.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org, 
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com, 
	mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com, 
	hkallweit1@gmail.com, linux@armlinux.org.uk, linux-i2c@vger.kernel.org, 
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I just realized that we are discussing all this without GPIO
maintainers to be involved!
Cc'ed to Linus and Bart for their valuable opinions / comments.

(TL;DR: GPIO regmap seems need some fixes)

On Tue, May 23, 2023 at 2:07=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, May 23, 2023 at 12:57=E2=80=AFPM Jiawen Wu <jiawenwu@trustnetic.c=
om> wrote:
> > > > Anyway it is a bit complicated, could I use this version of GPIO im=
plementation if
> > > > it's really tough?
> > >
> > > It's possible but from GPIO subsystem point of view it's discouraged
> > > as long as there is no technical impediment to go the regmap way.
> >
> > After these days of trying, I guess there are still some bugs on gpio -=
 regmap - irq.
> > It looks like an compatibility issue with gpio_irq_chip and regmap_irq_=
chip (My rough
> > fixes seems to work).
> >
> > Other than that, it seems to be no way to add interrupt trigger in regm=
ap_irq_thread(),
> > to solve the both-edge problem for my hardware.
> >
> > I'd be willing to use gpio-regmap if above issues worked out, I learned=
 IRQ controller,
> > IRQ domain, etc. , after all.
>
> And thank you for all this!
> Now you may suggest the fixes to the GPIO regmap with all your
> knowledge of the area.
>
> > But if not, I'd like to implement GPIO in the original way,
> > it was tested to work. May I? Thanks for all your suggestions.
>
>
> --
> With Best Regards,
> Andy Shevchenko



--
With Best Regards,
Andy Shevchenko

