Return-Path: <netdev+bounces-2160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25012700918
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F39DD1C20FC7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF071D2CB;
	Fri, 12 May 2023 13:21:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC071DDF5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:21:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AB114E66
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683897680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4AlaRyQOy36sXdqy+JwhbCuIDwi8LlxpgbISw/CDPFM=;
	b=WVuFVWO6/FlQSCVBFPSJC0w1/VEBS0do9vDz6gEOk7BY/kXbJ95LDYOtcqNM3WjHSaCZvw
	q/dgJfGUO6xLvfizoSIiTsitotncXfuAFLv1jnZRfGTt6H0zQ0NrHOXe6e+urH9J6WHINu
	+MPeFTCgNTF61UxaqRCOdNs9ZQWVvng=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-ndbwY0gcNbax0oK91YUoew-1; Fri, 12 May 2023 09:21:19 -0400
X-MC-Unique: ndbwY0gcNbax0oK91YUoew-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-44fd17672b5so2536865e0c.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897679; x=1686489679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AlaRyQOy36sXdqy+JwhbCuIDwi8LlxpgbISw/CDPFM=;
        b=TERwgzWxQKDYtVjRieidyFvcyBYH+b8d3Hymt3FFSizLlJUV83K+5KstD6l1Yo2KBz
         4bLB6Y17QJBBmd+ZI1B7uLf38Ow3uy81FB+l7HIFKRs66q4hVfFwLrIHW0PVIgD26i8i
         aoECPAmtQE+IhZ6ZQTeKp6hGESfrLnXvmoI1KNDs4edgAFIcFbkDykWv1hryvRQnYi6M
         g0tIxKsZx7SDOTvknOCyOuBqgNhgcRcHeDZlUeS9cp6vTYMQbl5sccdzqJKMsO22Pg8n
         1NpwMI7tRo7sJcYcVEM7wT/4iETdFGNBICrk61De+3d+Ho8EwhNNNDqY6BV7eVmk+WmS
         jnHA==
X-Gm-Message-State: AC+VfDwL1E0zAx+YEy67j9xiGswz0Z/C5UQEXROoeGawGFbRHuVoJ1Fs
	te78Nbx+nNjlPHrke9m1LYYZSAdDKHLmTMqxRtPMIKRXJf1P3KKJ6pN3NtZHgCe71zqPX8Tcv54
	eIDqlfXvfBjmeZ4eol7JaXiQ/BbFAHFFm
X-Received: by 2002:a67:ffd5:0:b0:434:69be:8495 with SMTP id w21-20020a67ffd5000000b0043469be8495mr9541607vsq.9.1683897678641;
        Fri, 12 May 2023 06:21:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ56EVhPNDeIWeojbtIxhXDW0jsNAxPEwZjDUE5jSg6VIr1fyKKsgmU+sCABqffj01zeSX7annq0Y5IBzbAanRE=
X-Received: by 2002:a67:ffd5:0:b0:434:69be:8495 with SMTP id
 w21-20020a67ffd5000000b0043469be8495mr9541577vsq.9.1683897678350; Fri, 12 May
 2023 06:21:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512100620.36807-1-bagasdotme@gmail.com> <20230512100620.36807-10-bagasdotme@gmail.com>
In-Reply-To: <20230512100620.36807-10-bagasdotme@gmail.com>
From: Richard Fontana <rfontana@redhat.com>
Date: Fri, 12 May 2023 09:21:07 -0400
Message-ID: <CAC1cPGzSpMZC3oJOpzjqiEDvgWUszzSztMri6uxW6vZ7oZtD5w@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] udf: Replace license notice with SPDX identifier
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
	Manivannan Sadhasivam <mani@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 6:07=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:

> diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
> index de17a97e866742..b2b5bca45758df 100644
> --- a/fs/udf/ecma_167.h
> +++ b/fs/udf/ecma_167.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0+ */
>  /*
>   * ecma_167.h
>   *
> @@ -8,29 +9,6 @@
>   * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali@kernel.org>
>   * All rights reserved.
>   *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions, and the following disclaimer,
> - *    without modification.
> - * 2. The name of the author may not be used to endorse or promote produ=
cts
> - *    derived from this software without specific prior written permissi=
on.
> - *
> - * Alternatively, this software may be distributed under the terms of th=
e
> - * GNU Public License ("GPL").
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AN=
D
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PU=
RPOSE
> - * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABL=
E FOR
> - * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOO=
DS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, S=
TRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY=
 WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY O=
F
> - * SUCH DAMAGE.
>   */

This is not BSD-2-Clause. Ignoring the interior statement about the
GPL, I think the closest SPDX identifier might be
https://spdx.org/licenses/BSD-Source-Code.html
but it doesn't quite match.


> diff --git a/fs/udf/osta_udf.h b/fs/udf/osta_udf.h
> index 157de0ec0cd530..6c09a4cb46f4a7 100644
> --- a/fs/udf/osta_udf.h
> +++ b/fs/udf/osta_udf.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0+ */
>  /*
>   * osta_udf.h
>   *
> @@ -8,29 +9,6 @@
>   * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali@kernel.org>
>   * All rights reserved.
>   *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions, and the following disclaimer,
> - *    without modification.
> - * 2. The name of the author may not be used to endorse or promote produ=
cts
> - *    derived from this software without specific prior written permissi=
on.
> - *
> - * Alternatively, this software may be distributed under the terms of th=
e
> - * GNU Public License ("GPL").
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AN=
D
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PU=
RPOSE
> - * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABL=
E FOR
> - * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOO=
DS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, S=
TRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY=
 WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY O=
F
> - * SUCH DAMAGE.
>   */

Same comment - this is not BSD-2-Clause.

> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
> index fce4ad976c8c29..d0fce5348fd3f3 100644
> --- a/fs/udf/udftime.c
> +++ b/fs/udf/udftime.c
> @@ -1,21 +1,4 @@
> -/* Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, =
Inc.
> -   This file is part of the GNU C Library.
> -   Contributed by Paul Eggert (eggert@twinsun.com).
> -
> -   The GNU C Library is free software; you can redistribute it and/or
> -   modify it under the terms of the GNU Library General Public License a=
s
> -   published by the Free Software Foundation; either version 2 of the
> -   License, or (at your option) any later version.
> -
> -   The GNU C Library is distributed in the hope that it will be useful,
> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -   Library General Public License for more details.
> -
> -   You should have received a copy of the GNU Library General Public
> -   License along with the GNU C Library; see the file COPYING.LIB.  If n=
ot,
> -   write to the Free Software Foundation, Inc., 59 Temple Place - Suite =
330,
> -   Boston, MA 02111-1307, USA.  */
> +// SPDX-License-Identifier: GPL-2.0-only

Shouldn't this be
// SPDX-License-Identifier: LGPL-2.0-or-later ?
(or are you implicitly using the obscure LGPLv2.x section ... 3 mechanism?)

Richard


