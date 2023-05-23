Return-Path: <netdev+bounces-4588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7E270D4F0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8797F2812E4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957C91D2D6;
	Tue, 23 May 2023 07:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4F1D2CE
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:28:53 +0000 (UTC)
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7708E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:28:31 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-561bcd35117so86425967b3.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684826911; x=1687418911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upch7Q6AOsaur87v+sBxkxaq7IOsMNTEg+umeJdYQA4=;
        b=gTwWL2EqX8yykEeDniQFmRWXYMac8IiYC1BgxwaML1x1RPUQ/9Vl6bPZuZYxnIa+37
         OFQRsXHXaRVuuG2tLih2jrAaphGIWjPfE+AYHInIAmUlbUkgzSg8mQ4lbA5jat9GCIPK
         do7aL8nJvdYc1/Tw+qhtsxQc4ELrH4QTd3AFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826911; x=1687418911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=upch7Q6AOsaur87v+sBxkxaq7IOsMNTEg+umeJdYQA4=;
        b=GoFGuSbZgIUVL2+i3ldLev3I2X/WHk9Q2/fDt9hZ/lFIqGRkJ7S07mugxm8knqsErC
         gSeeZF4OonPNoDwarNbg6LLbDveppoUvAzw2njwiFKXj9sS7Poi3f6PB6cXqKzjCfBlI
         F06ld+lvhFNm+vpF0+mu7yqhQUARC9Sfp2ps55znVKcVt5/FCLbcgWW9vluVSXB9i/bq
         UuL+EBw/BMsYnwGkbAQfEDJpYJDiFVzcqHTiulZgBA3evSAdkFsL0zKUm84fOLs0v+3N
         h4LOlu70nS9FPMa28WVqewYYRDqgagHa8zeMV+Z/2Vgi6ocE1yEWh6zDeljQ7oElvU2g
         5B4Q==
X-Gm-Message-State: AC+VfDyxgyqX674tgQ0gFwHv1j8zxdpPNm4/zC3hsjCreTER7g6TcfYV
	t7/1KTmC3ffz2Fvt3yi8wIScRNY4w8SlAp0sfXZSrg==
X-Google-Smtp-Source: ACHHUZ7ytXyb07nN4RN59Cl6Fe3VATbePCWMPZ3Z3Df6OhvQaLuHmJIQElgghHIP+4079NzU5xV0C7D5EVISRBX5RsM=
X-Received: by 2002:a0d:d4ca:0:b0:55a:77d:5630 with SMTP id
 w193-20020a0dd4ca000000b0055a077d5630mr15349896ywd.11.1684826911059; Tue, 23
 May 2023 00:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522175401.1232921-1-dario.binacchi@amarulasolutions.com> <20230523050604.h7qlqdop2fxxcejy@lion.mk-sys.cz>
In-Reply-To: <20230523050604.h7qlqdop2fxxcejy@lion.mk-sys.cz>
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date: Tue, 23 May 2023 09:28:19 +0200
Message-ID: <CABGWkvrG8rsWpLaXhLN6G0GqW3XF1z=fy=GaCs34iti6+r2TPg@mail.gmail.com>
Subject: Re: [PATCH ethtool v2, 1/1] netlink/rss: move variable declaration
 out of the for loop
To: Michal Kubecek <mkubecek@suse.cz>
Cc: netdev@vger.kernel.org, 
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Michal,

On Tue, May 23, 2023 at 7:06=E2=80=AFAM Michal Kubecek <mkubecek@suse.cz> w=
rote:
>
> On Mon, May 22, 2023 at 07:54:01PM +0200, Dario Binacchi wrote:
> > The patch fixes this compilation error:
> >
> > netlink/rss.c: In function 'rss_reply_cb':
> > netlink/rss.c:166:3: error: 'for' loop initial declarations are only al=
lowed in C99 mode
> >    for (unsigned int i =3D 0; i < get_count(hash_funcs); i++) {
> >    ^
> > netlink/rss.c:166:3: note: use option -std=3Dc99 or -std=3Dgnu99 to com=
pile your code
> >
> > The project doesn't really need a C99 compiler, so let's move the varia=
ble
> > declaration outside the for loop.
> >
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > ---
>
> To be honest, I'm rather surprised that this would be the only C99
> feature in ethtool code, I thought that e.g. the named struct
> initializers also require C99.

Yes, you're probably right. That might be the first of the compilation erro=
rs,
or in other cases, the compiler I used may only display warnings.

>
> Anyway, with kernel explicitly declaring C11 as the standard to use
> since 5.18, it would IMHO make more sense to do the same in ethtool so
> that developers do not need to keep in mind that they cannot use
> language features they are used to from kernel. What do you think?

I agree with you.
Anyway, to fix this issue
https://patchwork.ozlabs.org/project/buildroot/patch/20230520211246.3950131=
-1-dario.binacchi@amarulasolutions.com/
can I send patch updating configure.ac as suggested by Yann E. Morin ?

--- a/configure.ac
+++ b/configure.ac
@@ -12,6 +12,10 @@ AC_PROG_CC
 AC_PROG_GCC_TRADITIONAL
 AM_PROG_CC_C_O
 PKG_PROG_PKG_CONFIG
+AC_PROG_CC_C99
+AS_IF([test "x$ac_cv_prog_cc_c99" =3D "xno"], [
+       AC_MSG_ERROR([no C99 compiler found, $PACKAGE requires a C99 compil=
er.])
+])

Thanks and regards,
Dario

>
> Michal


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

