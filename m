Return-Path: <netdev+bounces-2052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85065700194
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2E7281A17
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F82748C;
	Fri, 12 May 2023 07:37:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5AA1FA6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:37:03 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B71C8A56;
	Fri, 12 May 2023 00:37:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1aafa03f541so93073765ad.0;
        Fri, 12 May 2023 00:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683877021; x=1686469021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GZimun0Oi9tvlN9nCzCVCWURk/2Es/WbATqfStJw7Jk=;
        b=kxs4IocopkMFPeOzAqh0c+U3O9F108JkJjL9TX43hJjYO0opTg8f5s9H4zMQoNHeSq
         fuPpaklCw5aCrrUJzpFE+8tHaPT7BjUlxZm53R94zSDQGnRzQ0yK9ne5UD/0RUrklhHv
         kqAOzZUb84a1VSYp0Su+9f92FtW/6/25eWhjA2ejPaRC/z5zElxsB6XkHjznoMEbVxVL
         RVP5bxMaWZn+bBSik4ajyBI7CTi8+5l/BiN/g1TFHlmKD+i8d3+fOr9XcVFAGyYvZuNR
         gdWWDUA/vPbbiYGalpn1HTQvmYt9OSeffvZCyq7lSC1WBPgj5NRbj4aenaabFObwTUhv
         lnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683877021; x=1686469021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZimun0Oi9tvlN9nCzCVCWURk/2Es/WbATqfStJw7Jk=;
        b=QGvLMeipEtiimwi5nvKAv48w+39P5fAX/ODwmeHo7kVjLbrkwUp1vYuFxayavwiLsR
         2IGg4cZf4XpCgDCwphC6BWJWqg1mnbALcA0WO33h0doDMAnL62EiC1SB0gOM/VMBED9F
         uZiJ/hzY7gnv66IqNVAS4jCXa4afIcGVdZztY+/jmgquOpO+ERO4ixj5+MGBtR47Rmln
         G2LGShqolVouT1bFSfIaEeD1gAwL/CDo81y9o8y6UBYw3RIbL+eE8kaZeUUlk4xlsjmR
         jQ4PLmLcF3jUKdst2kN0uS9GfT/IEbAiCKmr1eNm7gn/R+nddmF0UeCGPhXIAY51su3C
         N6zg==
X-Gm-Message-State: AC+VfDzgyjh/WxlrGLRy/TWv3e1Ll3bpzt5CiKKIdevUkClkF0bS33pL
	8etHi6kYpWu92wJubekSBaA=
X-Google-Smtp-Source: ACHHUZ7atOYol5kKY9Mk5vvRPtiy8+WipTXuh4BTYp1JmLN8R9SHKkypxIthE7X2Q8U/yx9kTlHzMQ==
X-Received: by 2002:a17:902:d304:b0:1a9:21bc:65f8 with SMTP id b4-20020a170902d30400b001a921bc65f8mr24987876plc.11.1683877020733;
        Fri, 12 May 2023 00:37:00 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-8.three.co.id. [116.206.28.8])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001ab1cdb4295sm7168669plb.130.2023.05.12.00.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 00:37:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id AC7A6106AFF; Fri, 12 May 2023 14:36:57 +0700 (WIB)
Date: Fri, 12 May 2023 14:36:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>,
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	Donald Becker <becker@scyld.com>, Peter De Schrijver <p2@mind.be>
Subject: Re: [PATCH 04/10] net: ethernet: 8390: Replace GPL boilerplate with
 SPDX identifier
Message-ID: <ZF3smZ4TaIc0RHuO@debian.me>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-5-bagasdotme@gmail.com>
 <1eb3b5cb-5906-4776-74a2-820b5b05949c@linux-m68k.org>
 <2738e88d-16e9-15c7-37ea-4c2dc4f69181@sdinet.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ec7AyP+SLumfMJiE"
Content-Disposition: inline
In-Reply-To: <2738e88d-16e9-15c7-37ea-4c2dc4f69181@sdinet.de>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--Ec7AyP+SLumfMJiE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 12, 2023 at 08:57:15AM +0200, Sven-Haegar Koch wrote:
> On Fri, 12 May 2023, Greg Ungerer wrote:
>=20
> > On 11/5/23 23:34, Bagas Sanjaya wrote:
> > > Replace GPL boilerplate notice on remaining files with appropriate SP=
DX
> > > tag. For files mentioning COPYING, use GPL 2.0; otherwise GPL 1.0+.
>=20
> > > --- a/drivers/net/ethernet/8390/hydra.c
> > > +++ b/drivers/net/ethernet/8390/hydra.c
> > > @@ -1,10 +1,8 @@
> > > +/* SPDX-License-Identifier: GPL-1.0-only */
> > > +
> > >   /* New Hydra driver using generic 8390 core */
> > >   /* Based on old hydra driver by Topi Kanerva (topi@susanna.oulu.fi)=
 */
> > >   -/* This file is subject to the terms and conditions of the GNU Gen=
eral
> > > */
> > > -/* Public License.  See the file COPYING in the main directory of the
> > > */
> > > -/* Linux distribution for more details.
> > > */
> > > -
> > >   /* Peter De Schrijver (p2@mind.be) */
> > >   /* Oldenburg 2000 */
>=20
> GPL-1.0-only does not sound correct.

Oops, my oversight. The boilerplate above should have meant GPL 2.0
only.

Thanks for reminder!

--=20
An old man doll... just what I always wanted! - Clara

--Ec7AyP+SLumfMJiE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZF3smQAKCRD2uYlJVVFO
o0XAAP9sSAxXCqJpY7WStnzCXInOHEmRK2OZtGvoTaZXwWCpaAEAnq2zSjsqzwNZ
iabPwEj1X1Sr4N5lUmOwqkfwt//g1A0=
=a0Gi
-----END PGP SIGNATURE-----

--Ec7AyP+SLumfMJiE--

