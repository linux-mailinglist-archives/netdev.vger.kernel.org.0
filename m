Return-Path: <netdev+bounces-3319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BC870669F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79BC11C20AE6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56312C72A;
	Wed, 17 May 2023 11:28:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2C211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:28:17 +0000 (UTC)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1147B3A96;
	Wed, 17 May 2023 04:28:12 -0700 (PDT)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5500d15d2f2so348725eaf.1;
        Wed, 17 May 2023 04:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684322892; x=1686914892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XfJAMBuLZXZSZNnRSd5oeEooqFY7wfWuqlbqLyMtlW8=;
        b=FFk8TBDqpap/3MOWmKRu2y9NMOMr3xZIuJ5al58pHp3REaA5rXhsAxWLdNljPikxgZ
         +9VxHX3o7/HzyvoShnIvYpkcJRPCl9/u3s50hwfn0OKK+x4ZId79Oi6EYMcGrTQ0pAXA
         uhbEZHTfWEArKH+DhsK6gqP8RbZsyafG35ZaPUPYlaGTXfKkVtmjOa2bYSIZ7xcMxx+m
         7D0sZGSXf1QtyzyRMNxD/8jglp7Ez92KTOKMR/mN5coONWaIR2XY+/L8GiYEp0ZvoLWJ
         +6Tewuv7D/xdrXWP7L3fgxC5AuYiNt0qNmJu8eCq092EvWadCvFxPUeR5RTti7Nj05hW
         Z0wg==
X-Gm-Message-State: AC+VfDzV7eUdD5CZzKXyCb/3KdoEqL6Njz29Elh9d1Omh3x6Cxk6f8WF
	yX/N91tBa4cR+0Ir0UTDiAArXb29WvEyDw==
X-Google-Smtp-Source: ACHHUZ4+oOnL1xg52ZbWJc2gVt81sW6G5249xre9fdB6ls/0c0n1zpvkAQRyD/iDUDXS/+8QsW1e7w==
X-Received: by 2002:a05:6808:a0c:b0:38b:4214:94f3 with SMTP id n12-20020a0568080a0c00b0038b421494f3mr13933051oij.24.1684322891996;
        Wed, 17 May 2023 04:28:11 -0700 (PDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id l6-20020a4a4346000000b0052a32a952e9sm12749567ooj.48.2023.05.17.04.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 04:28:11 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6ab2efc79aeso755409a34.1;
        Wed, 17 May 2023 04:28:11 -0700 (PDT)
X-Received: by 2002:a0d:d4ce:0:b0:561:e565:3678 with SMTP id
 w197-20020a0dd4ce000000b00561e5653678mr141331ywd.11.1684322506908; Wed, 17
 May 2023 04:21:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515060714.621952-1-bagasdotme@gmail.com> <20230515060714.621952-5-bagasdotme@gmail.com>
In-Reply-To: <20230515060714.621952-5-bagasdotme@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 May 2023 13:21:34 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWh3an=E0_gyx9cgVbMkm56Uv_KuoEY79yVVaN22gFpZA@mail.gmail.com>
Message-ID: <CAMuHMdWh3an=E0_gyx9cgVbMkm56Uv_KuoEY79yVVaN22gFpZA@mail.gmail.com>
Subject: Re: [PATCH net 4/5] net: ethernet: i825xx: Replace unversioned GPL
 (GPL 1.0) notice with SPDX identifier
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Networking <netdev@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jay Vosburgh <j.vosburgh@gmail.com>, 
	Andy Gospodarek <andy@greyhouse.net>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Sam Creasey <sammy@sammy.net>, Greg Ungerer <gerg@linux-m68k.org>, 
	Simon Horman <simon.horman@corigine.com>, Tom Rix <trix@redhat.com>, 
	Yang Yingliang <yangyingliang@huawei.com>, Donald Becker <becker@scyld.com>, 
	Richard Hirst <richard@sleepie.demon.co.uk>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bagas,

On Mon, May 15, 2023 at 8:19=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
> Replace unversioned GPL boilerplate notice with corresponding SPDX
> license identifier, which is GPL 1.0+.
>
> Cc: Donald Becker <becker@scyld.com>
> Cc: Richard Hirst <richard@sleepie.demon.co.uk>
> Cc: Sam Creasey <sammy@sammy.net>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Thanks for your patch, which is now commit 9ac40d080befb4a0 ("net:
ethernet: i825xx: Replace unversioned GPL (GPL 1.0) notice with SPDX
identifier") in net-next/main and next-20230517.

>  drivers/net/ethernet/i825xx/82596.c      | 5 ++---
>  drivers/net/ethernet/i825xx/lasi_82596.c | 5 ++---
>  drivers/net/ethernet/i825xx/lib82596.c   | 5 ++---
>  3 files changed, 6 insertions(+), 9 deletions(-)

> --- a/drivers/net/ethernet/i825xx/82596.c
> +++ b/drivers/net/ethernet/i825xx/82596.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-1.0+
>  /* 82596.c: A generic 82596 ethernet driver for linux. */
>  /*
>     Based on Apricot.c
> @@ -31,9 +32,7 @@
>     Driver skeleton
>     Written 1993 by Donald Becker.
>     Copyright 1993 United States Government as represented by the Directo=
r,
> -   National Security Agency. This software may only be used and distribu=
ted
> -   according to the terms of the GNU General Public License as modified =
by SRC,
> -   incorporated herein by reference.
> +   National Security Agency.

This file is not licensed under the "unversioned GPL", but
under the "GNU General Public License as modified by SRC".
Cfr. https://elixir.bootlin.com/linux/latest/source/drivers/net/LICENSE.SRC
Hence you removed important legal information.

Same for the two other files.

>
>     The author may be reached as becker@scyld.com, or C/O
>     Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD=
 21403

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

