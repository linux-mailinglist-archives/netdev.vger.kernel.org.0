Return-Path: <netdev+bounces-2931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE12704978
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76C901C20DD5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295F7168CA;
	Tue, 16 May 2023 09:39:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BEB2C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:39:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBA6269F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684229953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGD0E936v4C0bvmmqTjsWmOTLh+PI4QmhffTf/b38Uc=;
	b=EjOGG5khzvfg2MPje2sSPXNKOxAm0BDr2pdwSS02MSJidrjr4zfeXCEScfIEaP2VzT85Q5
	fFaPgfs5yHhCpjml85FW5+2Nw2cNaFkA8H4QXEMK/uqqOIyb6ChgktqnW8C7rolRWE6210
	ZSEAOWDrFtUjqiRGX/Pp0+QyBB/PydQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-joOfCz2LNpONhDNTPQnn3w-1; Tue, 16 May 2023 05:39:12 -0400
X-MC-Unique: joOfCz2LNpONhDNTPQnn3w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f4fffe7883so3297365e9.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:39:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684229951; x=1686821951;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MGD0E936v4C0bvmmqTjsWmOTLh+PI4QmhffTf/b38Uc=;
        b=flRZHLKigQINvF+vaL6Hp7C8zTuB2ui5da5KN/atPF/QmVWDy2j1rlQm6CgSmLSOg3
         9cHBUb/5qL/dCc92pcCT5jnFGjZBZfz+F7y9Bru1DuKOS1hfWgZNUVqZW1qujV0ScVRC
         eCw5ygGnYqvM8JOC0ImaRoKjbVH7cDEyVi0OQDYTRWtcPRNLi8aokIbfZKIJLC0uDmuk
         WrT20uld74l7obh9GRrd2yIRlfWNm4G/VprJDWvSRNf42D6wPpAgHCwEfKBfVwiarTbR
         ysV7jIDOAH5EdrDPOnWUMu57yK7tF4vQiFdARf2ZYrSbXcx11931eF8dQkbKjy8L7U+l
         /WQw==
X-Gm-Message-State: AC+VfDyy1LdKVSA5tZlAruhxADXSBwipNZrvHw47anxbowfJTUFoBrpk
	6FooJJJhNhzptimh7y40ABXd66DrzW0OcEC31Tt4RbYVfGGhxXs0VxJtNXc1GHZ/qTxG+V3F65a
	4jG2KLKx+9HwQAuWj
X-Received: by 2002:a5d:68c8:0:b0:2e4:aa42:7872 with SMTP id p8-20020a5d68c8000000b002e4aa427872mr1417147wrw.4.1684229950828;
        Tue, 16 May 2023 02:39:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4umaRc0dHubmiKBnj4hLnRbm352/rGyW+hjRC2iLEfvLwVXKS/nQ6LtvkXeb5g09hOOpu0Lw==
X-Received: by 2002:a5d:68c8:0:b0:2e4:aa42:7872 with SMTP id p8-20020a5d68c8000000b002e4aa427872mr1417134wrw.4.1684229950535;
        Tue, 16 May 2023 02:39:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id m3-20020adfdc43000000b002ca864b807csm2023165wrj.0.2023.05.16.02.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:39:09 -0700 (PDT)
Message-ID: <aed598bbe094633859f477dd99ff7d086261b071.camel@redhat.com>
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
From: Paolo Abeni <pabeni@redhat.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>, Jiawen Wu
	 <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com, 
 andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com, 
 jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
 hkallweit1@gmail.com,  linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
 linux-gpio@vger.kernel.org,  mengyuanlou@net-swift.com
Date: Tue, 16 May 2023 11:39:08 +0200
In-Reply-To: <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
	 <20230515063200.301026-7-jiawenwu@trustnetic.com>
	 <ZGH-fRzbGd_eCASk@surfacebook>
	 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
	 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-16 at 10:12 +0300, Andy Shevchenko wrote:
> On Tue, May 16, 2023 at 5:39=E2=80=AFAM Jiawen Wu <jiawenwu@trustnetic.co=
m> wrote:
>=20
> ...
>=20
> > > > +   struct gpio_irq_chip *girq;
> > > > +   struct wx *wx =3D txgbe->wx;
> > > > +   struct gpio_chip *gc;
> > > > +   struct device *dev;
> > > > +   int ret;
> > >=20
> > > > +   dev =3D &wx->pdev->dev;
> > >=20
> > > This can be united with the defintion above.
> > >=20
> > >       struct device *dev =3D &wx->pdev->dev;
> > >=20
> >=20
> > This is a question that I often run into, when I want to keep this orde=
r,
> > i.e. lines longest to shortest, but the line of the pointer which get l=
ater
> > is longer. For this example:
> >=20
> >         struct wx *wx =3D txgbe->wx;
> >         struct device *dev =3D &wx->pdev->dev;
>=20
> So, we locate assignments according to the flow. I do not see an issue he=
re.

That would break the reverse x-mass tree order.

> > should I split the line, or put the long line abruptly there?
>=20
> The latter is fine.

This is minor, but I have to disagree. My understanding is that
respecting the reversed x-mass tree is preferred. In case of dependent
initialization as the above, the preferred style it the one used by
this patch.

Cheers,

Paolo



