Return-Path: <netdev+bounces-7418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A2D720287
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1489D2818C7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B10418AE1;
	Fri,  2 Jun 2023 13:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1953915BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:03:55 +0000 (UTC)
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4131B3;
	Fri,  2 Jun 2023 06:03:53 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-565ee3d14c2so21184797b3.2;
        Fri, 02 Jun 2023 06:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685711033; x=1688303033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3ZRPUz8ZBR77uMNjAdn8AKPr3I5bpHtCQUGRxd1Y5I=;
        b=PCx/ghPp/7LQ4JBemhHQpWMBLCbwb2E5ZIWLu96BLs/tF4uAbK7VxQe+JUmTMOgJWP
         wbNwWcmos7mxPxeH/2AT1yC5OcOlNBMIbhEBbM26iGPiC5gWkxvprCtV2ZV88I8Cpipr
         wUvbi36DBW3X073X0BwGO80111vEpT8tQa+qUJ9XYkT6slRisaLDmpCg5Ouqb2O8/LUD
         NGotGc38gBVA3sFmLCclfGJvAvzUDB2dy896gVRBJvycnCHSodWBzs65ZF1owDSnx+aY
         4khZU0k+xoAyx4Kv6wUDIgrCFzEWkhGB5YqNbRyMyO7v4dqO/yqKjweZsT/1L2AnbWd6
         onTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685711033; x=1688303033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3ZRPUz8ZBR77uMNjAdn8AKPr3I5bpHtCQUGRxd1Y5I=;
        b=Gx77B0uujJXLVt0/PjxnaKBshkauN8JfCF6LLG8ozMr7BIiH12VGAvZ/T9WSQqvRPl
         ehoXNvQERz2tbkmKPQ0iBZlgzepGes086g1VpwO7BXNcLJuNQx9ZPe+PHbGFP6pFw+1H
         oqmHWTeuKE5kaAudQ09X7g0jIuaSuOli/sD1eIdJRt77Go+xiXZkTJpkpUklPeY1J+Of
         ZFVSEDZeHPKk+VfokuQmrvyajxSMQomNICVBgI8Uwdsj0gFq+sDtRLBB2XiXRO+6kT3y
         Idu+GPbB0C+bgl57jMl/mC791j1MNE1Xh3J2eV63DyS1V2hjJs+8byMDPdZGmfM5K0g3
         OD3A==
X-Gm-Message-State: AC+VfDw1k9eR2JygTQCoe0xUQrCaHa3HBeMUqwaGkecE49lS3TydIZxW
	0gJcmgej6H4NnvdOV+LYjD1Fz5aMjaf7CNzUsow=
X-Google-Smtp-Source: ACHHUZ7fFI2FiBfit/D2txdSbalGxdI6U723yrg8Qc5/16GhvGFJQS5doIqTz5hFt1EXkICJDhjoINq+kd6P1zfwPPk=
X-Received: by 2002:a0d:cbc5:0:b0:564:a549:babc with SMTP id
 n188-20020a0dcbc5000000b00564a549babcmr12513619ywd.32.1685711032746; Fri, 02
 Jun 2023 06:03:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iK13jkbKXv-rKiUbTqMrk3KjVPGYH_Vv7FtJJ5pTdUAYQ@mail.gmail.com>
 <20230531225947.38239-1-kuniyu@amazon.com> <b613cbaf569945e3811609a9f10fe0aa@AcuMS.aculab.com>
In-Reply-To: <b613cbaf569945e3811609a9f10fe0aa@AcuMS.aculab.com>
From: Akihiro Suda <suda.kyoto@gmail.com>
Date: Fri, 2 Jun 2023 22:03:41 +0900
Message-ID: <CAG8fp8R+2TztxYKcLwU354mQ47mD7RPQKarxnzA+j2ydtqamBg@mail.gmail.com>
Subject: Re: [PATCH linux] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294
To: David Laight <David.Laight@aculab.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, "edumazet@google.com" <edumazet@google.com>, 
	"akihiro.suda.cz@hco.ntt.co.jp" <akihiro.suda.cz@hco.ntt.co.jp>, 
	"akihirosuda@git.sr.ht" <akihirosuda@git.sr.ht>, "davem@davemloft.net" <davem@davemloft.net>, 
	"kuba@kernel.org" <kuba@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"segoon@openwall.com" <segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

2023=E5=B9=B46=E6=9C=882=E6=97=A5(=E9=87=91) 19:51 David Laight <David.Laig=
ht@aculab.com>:
>
> From: Kuniyuki Iwashima
> > Sent: 01 June 2023 00:00
> ....
> > > > --- a/include/net/ping.h
> > > > +++ b/include/net/ping.h
> > > > @@ -20,7 +20,7 @@
> > > >   * gid_t is either uint or ushort.  We want to pass it to
> > > >   * proc_dointvec_minmax(), so it must not be larger than MAX_INT
> > > >   */
> > > > -#define GID_T_MAX (((gid_t)~0U) >> 1)
> > > > +#define GID_T_MAX ((gid_t)~0U)
>
> Doesn't that comment need updating?
>
> I do wonder how much code breaks for gid > MAXINT.
> How much testing does it actually get??

It is fixed in v3:
https://patchwork.kernel.org/project/netdevbpf/patch/20230601031305.55901-1=
-akihiro.suda.cz@hco.ntt.co.jp/

```
-/*
- * gid_t is either uint or ushort.  We want to pass it to
- * proc_dointvec_minmax(), so it must not be larger than MAX_INT
- */
-#define GID_T_MAX (((gid_t)~0U) >> 1)
+#define GID_T_MAX (((gid_t)~0U) - 1)
```

Tested with 4294967294, 4294967295 (EINVAL), and 4294967296 (EINVAL), on x8=
6_64.




>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)

