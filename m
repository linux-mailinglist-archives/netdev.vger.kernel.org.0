Return-Path: <netdev+bounces-4655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 812C070DB2C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA6C281337
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A744A856;
	Tue, 23 May 2023 11:08:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3594A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:08:06 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6351411A;
	Tue, 23 May 2023 04:08:05 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-62596e46d30so2601306d6.1;
        Tue, 23 May 2023 04:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684840084; x=1687432084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XWbMeRFiu1FhOl+K1gwtkA9FmHD9p8xpCPCjpyLGbE=;
        b=BGk0ke+i3DMnxSRIwolyq/V9QE0KYCu2aF3uh7QhocQ3mCacitLrUIzuxJ6600y11G
         vq3KrmdkfOk7SafftsYiXficQ8rAC/VbWk774sVJ1MqNa6NjSLzXCPZKxdII1+u+n4s2
         DtifTfHgOvqHudkdj/jZS+Im+Kx0shbTVd9f9ecBznBPHvKHPr60KRvEpylmEFw5rKJz
         vnLO1Htm/iMVWqs6iEtyn3rJCEFOBB2eObjfI/AK87wZiJAMQFYv8Zl8l+xLRlyEvLur
         KGyeY4mYmzpeRlO4sI8zzWtKUxLLBUOmE2xo+ebwJKJhvTAX4oOEP9v8u68WwCrqux5J
         J0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684840084; x=1687432084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0XWbMeRFiu1FhOl+K1gwtkA9FmHD9p8xpCPCjpyLGbE=;
        b=BcJ/qwPMrOo3gekLR5jK3aOAhkL6317FmwBKRhHC4CcTocULkohO7uNegrUiR4hTVP
         gkksevnuNMML+QpfZPq7yBTppN8bt7GSDwmNs683ZtbDppHQQ0J5SFxPKWdT+FTOz4W0
         sIg4fLgE6qVEU1xVtg6qHxuoXBNLKHs0pRzdoQcns1kmJp28Wl9UfTEKB8+3kdsmHqtO
         8AZ5sf2e9P/PAvTn26H/kUwlOTtbkLdjd5B8gDVufJb5gCLPPoPY9Hgkoi2RRTZGUEVX
         BUb/iQOrsw/TSH9W1zWtDSbVydeoPSDJNTsz3l7XtRXsoPWbMmRgWh2Npht3cqEje/Fj
         lRuA==
X-Gm-Message-State: AC+VfDxpJtgcX1UXMbFw+ZwR64AENW8kTXbuYz/37YEs0042azXwNQxR
	5x/nJKSmiIG+8SKGrbSIiHlcglUmfz45VirgKNHdixyNmZE=
X-Google-Smtp-Source: ACHHUZ4WvXxjX7JQ0M0RF7BiyMZyOBZIAitxQ50ZcpTLLNGVLPJ3NTRYYtn5noT9b3QDEZfYJHkB476skE+LSDtEf+0=
X-Received: by 2002:a05:6214:c43:b0:621:363c:ea9f with SMTP id
 r3-20020a0562140c4300b00621363cea9fmr21576457qvj.19.1684840084330; Tue, 23
 May 2023 04:08:04 -0700 (PDT)
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
 <013101d98d5c$b8fdd1d0$2af97570$@trustnetic.com>
In-Reply-To: <013101d98d5c$b8fdd1d0$2af97570$@trustnetic.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 23 May 2023 14:07:28 +0300
Message-ID: <CAHp75Vc=i2ft=M-gdXYDMeTAmK4RcPbZpmiy1pEjO-jOVD_pgA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
To: Jiawen Wu <jiawenwu@trustnetic.com>
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

On Tue, May 23, 2023 at 12:57=E2=80=AFPM Jiawen Wu <jiawenwu@trustnetic.com=
> wrote:
> > > Anyway it is a bit complicated, could I use this version of GPIO impl=
ementation if
> > > it's really tough?
> >
> > It's possible but from GPIO subsystem point of view it's discouraged
> > as long as there is no technical impediment to go the regmap way.
>
> After these days of trying, I guess there are still some bugs on gpio - r=
egmap - irq.
> It looks like an compatibility issue with gpio_irq_chip and regmap_irq_ch=
ip (My rough
> fixes seems to work).
>
> Other than that, it seems to be no way to add interrupt trigger in regmap=
_irq_thread(),
> to solve the both-edge problem for my hardware.
>
> I'd be willing to use gpio-regmap if above issues worked out, I learned I=
RQ controller,
> IRQ domain, etc. , after all.

And thank you for all this!
Now you may suggest the fixes to the GPIO regmap with all your
knowledge of the area.

> But if not, I'd like to implement GPIO in the original way,
> it was tested to work. May I? Thanks for all your suggestions.


--=20
With Best Regards,
Andy Shevchenko

