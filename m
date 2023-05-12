Return-Path: <netdev+bounces-2130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF267006E9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20B672817D6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E357D511;
	Fri, 12 May 2023 11:34:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D9BA56
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:34:44 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E59D05E;
	Fri, 12 May 2023 04:34:42 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-3ef5b5d322dso99193501cf.2;
        Fri, 12 May 2023 04:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683891281; x=1686483281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jRL0mFkBIJ4KpIHNQ0nXnFUPNdCjxMZJfjytXJxyHUs=;
        b=RnMaoHKQty2EcLEaUL6R3/GL9nKNf2LnFZEeBqxJjdF7beqEn5Xc11wYAlgk6PC3XF
         6OSUQcnZXziN/KMlS9Bf+/wlbyeHXHDULmj5rn+C5AFQvayMGuK4P7+wBTimmzAv9iF8
         9J2bDyRTibimWbb2d53f2mK6cklI2cHZR+tMLt8j5c837itHN0VJcedm4hMrbeLTwdej
         DFMjuzx9WMC8dpGlYVyHPOucQ0ZGb8bIofVrPrmF/zbHE6Q4lTEBe+sZaqWAbyc0cDmI
         jp5R0Ix0w69Z73rtHVUeN9wkG3VkxqYsCGdkPlOf9LsA10DaRG3RE2uCz9UI1AHH9g0I
         hkbQ==
X-Gm-Message-State: AC+VfDxs9MZzvrF4JKEbWP4YiRuFxadQZ+xv4icyJKzNIRcsNzcHSVd6
	2LTM22FByBb06IIS1AXlJke2xqiTSVfyUg==
X-Google-Smtp-Source: ACHHUZ6g0qPmIXXysBtyKlJ8OBTOCCZ8wjQVTD+7qJVtXBQ1bHI8jYxrR/XdSPFvCFZmQTPVlLIYQA==
X-Received: by 2002:a05:622a:1a21:b0:3ef:36d0:c06e with SMTP id f33-20020a05622a1a2100b003ef36d0c06emr44128699qtb.33.1683891281389;
        Fri, 12 May 2023 04:34:41 -0700 (PDT)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id ey16-20020a05622a4c1000b003f3941ba4d9sm385778qtb.32.2023.05.12.04.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 04:34:41 -0700 (PDT)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-3ef588dcf7aso99169331cf.1;
        Fri, 12 May 2023 04:34:41 -0700 (PDT)
X-Received: by 2002:a0d:d691:0:b0:539:1b13:3d64 with SMTP id
 y139-20020a0dd691000000b005391b133d64mr23825102ywd.48.1683890887026; Fri, 12
 May 2023 04:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512100620.36807-1-bagasdotme@gmail.com> <20230512100620.36807-5-bagasdotme@gmail.com>
In-Reply-To: <20230512100620.36807-5-bagasdotme@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 12 May 2023 13:27:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWrApnnmC+p_+jeVsswc-_JRSK3FtvpS2X4PrscBCZtAA@mail.gmail.com>
Message-ID: <CAMuHMdWrApnnmC+p_+jeVsswc-_JRSK3FtvpS2X4PrscBCZtAA@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] net: ethernet: 8390: Replace GPL boilerplate
 with SPDX identifier
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux SPDX Licenses <linux-spdx@vger.kernel.org>, 
	Linux DRI Development <dri-devel@lists.freedesktop.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Networking <netdev@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Staging Drivers <linux-staging@lists.linux.dev>, 
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>, 
	Linux Kernel Actions <linux-actions@lists.infradead.org>, 
	Diederik de Haas <didi.debian@cknow.org>, Kate Stewart <kstewart@linuxfoundation.org>, 
	Philippe Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, 
	David Airlie <airlied@redhat.com>, Karsten Keil <isdn@linux-pingi.de>, 
	Jay Vosburgh <j.vosburgh@gmail.com>, Andy Gospodarek <andy@greyhouse.net>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sam Creasey <sammy@sammy.net>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, Daniel Mack <daniel@zonque.org>, 
	Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Wim Van Sebroeck <wim@linux-watchdog.org>, 
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, 
	Manivannan Sadhasivam <mani@kernel.org>, "David A . Hinds" <dahinds@users.sourceforge.net>, 
	Donald Becker <becker@scyld.com>, Peter De Schrijver <p2@mind.be>, Topi Kanerva <topi@susanna.oulu.fi>, 
	Alain Malek <Alain.Malek@cryogen.com>, Bruce Abbott <bhabbott@inhb.co.nz>, 
	Alan Cox <alan@linux.intel.com>, Greg Ungerer <gerg@linux-m68k.org>, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bagas,

On Fri, May 12, 2023 at 12:08=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:
> Replace GPL boilerplate notice on remaining files with appropriate SPDX
> tag. For files mentioning COPYING, use GPL 2.0; otherwise GPL 1.0+.
>
> Cc: David A. Hinds <dahinds@users.sourceforge.net>
> Cc: Donald Becker <becker@scyld.com>
> Cc: Peter De Schrijver <p2@mind.be>
> Cc: Topi Kanerva <topi@susanna.oulu.fi>
> Cc: Alain Malek <Alain.Malek@cryogen.com>
> Cc: Bruce Abbott <bhabbott@inhb.co.nz>
> Cc: Alan Cox <alan@linux.intel.com>
> Acked-by: Greg Ungerer <gerg@linux-m68k.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-1.0+

As per the removed lines below, this should be GPL-2.0-only.

>  /*
>   * Amiga Linux/68k 8390 based PCMCIA Ethernet Driver for the Amiga 1200
>   *
> @@ -19,12 +20,6 @@
>   *
>   * ---------------------------------------------------------------------=
-------
>   *
> - * This file is subject to the terms and conditions of the GNU General P=
ublic
> - * License.  See the file COPYING in the main directory of the Linux
> - * distribution for more details.
> - *
> - * ---------------------------------------------------------------------=
-------
> - *
>   */
>
>

> --- a/drivers/net/ethernet/8390/hydra.c
> +++ b/drivers/net/ethernet/8390/hydra.c
> @@ -1,10 +1,8 @@
> +// SPDX-License-Identifier: GPL-1.0+

Likewise.

> +
>  /* New Hydra driver using generic 8390 core */
>  /* Based on old hydra driver by Topi Kanerva (topi@susanna.oulu.fi) */
>
> -/* This file is subject to the terms and conditions of the GNU General  =
    */
> -/* Public License.  See the file COPYING in the main directory of the   =
    */
> -/* Linux distribution for more details.                                 =
    */
> -
>  /* Peter De Schrijver (p2@mind.be) */
>  /* Oldenburg 2000 */
>

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

