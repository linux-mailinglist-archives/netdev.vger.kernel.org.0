Return-Path: <netdev+bounces-2358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D30EF70177B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 15:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B59F2819BF
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 13:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7FD4C67;
	Sat, 13 May 2023 13:43:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB662263E
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 13:43:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A44B19B4
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 06:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683985432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DB3tShWsmKkupSG4kjkSPgdjSDVuKYI2Ix/HxUCEp4=;
	b=LBYaZTyg9JeTRgrq5b0RG9NGoWpWfb45uBcbo9s0TXNSCsfBlK9cQXDLUwuip2VCUPDRuz
	WQUUIp0A5ekT1Jbp91t+yQf2KPm1bA8shMH4da81MHbxOYrqYXbxi5+FjfZh0JINaB3lRf
	7odei2rnSurutWyqUkXcVyEIG9XqxjA=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-sgyAk9ncPseLVU81Ytm_Fg-1; Sat, 13 May 2023 09:43:51 -0400
X-MC-Unique: sgyAk9ncPseLVU81Ytm_Fg-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-44fd17672b5so2867003e0c.3
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 06:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683985430; x=1686577430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9DB3tShWsmKkupSG4kjkSPgdjSDVuKYI2Ix/HxUCEp4=;
        b=O0hBFijvsf7DshUfDymA24RFx74BKqDUQmPpxIwuRKhewL1ev4yxJUuckQ1g5maF+h
         yQNLUcRzsn2Zl6Z9nWEwFEzYa/1voOxY6ZV8MbFkJQvY/VixhYxrynFdv4uxt47HzcO8
         GO6BTvetIn8jro0WP6oWK0drkY+nYfLjylblIqzQceyI6qqLQjQhjFrxL7ttujlfjdrk
         m3zOUeTbVwlS/4J8MAENSz/QEvDd0SOoek8vHbfwsd3TCft4+kpGOl08UiNXOG5aIeaz
         LEfkWIuRb/h/EdktqrGhS+NLerUUYWn5wZiv57ye6F+mGP3P3jYzO2QpbAQ3hGfBLLVX
         0CRQ==
X-Gm-Message-State: AC+VfDw0MSvCRKDmE8pf0GpDVux0R5Lj/Ky3PCKIhrN5CBVfsY2dLvwd
	kDWC0EayuUhHbMuFI2DqlpgSEIHcCocjUKyV2Ek9jzoEE5awCMva0fuFk/kkavMPnB8MwX/nEk+
	CRbv3IB8SLNEac/k/xHvfmp/4zRqfN16mKXxLxhmUAfQ=
X-Received: by 2002:a1f:cf44:0:b0:43c:6e7d:60b0 with SMTP id f65-20020a1fcf44000000b0043c6e7d60b0mr8278740vkg.15.1683985430623;
        Sat, 13 May 2023 06:43:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OKoxadeHskX30zk/2SxsIYXX7yuqtDMX0XJgUO0uD/088ZwUUrLZ6CEQ62Rv0aKLCGZw53hFwRxRMhCBVNTA=
X-Received: by 2002:a1f:cf44:0:b0:43c:6e7d:60b0 with SMTP id
 f65-20020a1fcf44000000b0043c6e7d60b0mr8278732vkg.15.1683985430363; Sat, 13
 May 2023 06:43:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512100620.36807-1-bagasdotme@gmail.com> <20230512100620.36807-9-bagasdotme@gmail.com>
 <CAC1cPGy=78yo2XcJPNZVvdjBr2-XzSq76JrAinSe42=sNdGv3w@mail.gmail.com> <ef31b33f-8e66-4194-37e3-916b53cf7088@gmail.com>
In-Reply-To: <ef31b33f-8e66-4194-37e3-916b53cf7088@gmail.com>
From: Richard Fontana <rfontana@redhat.com>
Date: Sat, 13 May 2023 09:43:39 -0400
Message-ID: <CAC1cPGzznK8zoLaT1gBjpHP1eKFvTKKi+SW6xuXF3B8aHN27=g@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers: watchdog: Replace GPL license notice
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
	Manivannan Sadhasivam <mani@kernel.org>, Ray Lehtiniemi <rayl@mail.com>, Alessandro Zummo <a.zummo@towertech.it>, 
	Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>, Marc Zyngier <maz@kernel.org>, 
	Jonas Jensen <jonas.jensen@gmail.com>, Sylver Bruneau <sylver.bruneau@googlemail.com>, 
	Andrew Sharp <andy.sharp@lsi.com>, Denis Turischev <denis@compulab.co.il>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, Alan Cox <alan@linux.intel.com>, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 6:53=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> On 5/12/23 19:46, Richard Fontana wrote:
> > On Fri, May 12, 2023 at 6:07=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail=
.com> wrote:
> >
> >
> >> diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
> >> index 504be461f992a9..822bf8905bf3ce 100644
> >> --- a/drivers/watchdog/sb_wdog.c
> >> +++ b/drivers/watchdog/sb_wdog.c
> >> @@ -1,3 +1,4 @@
> >> +// SPDX-License-Identifier: GPL-1.0+
> >>  /*
> >>   * Watchdog driver for SiByte SB1 SoCs
> >>   *
> >> @@ -38,10 +39,6 @@
> >>   *     (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> >>   *                                             All Rights Reserved.
> >>   *
> >> - *     This program is free software; you can redistribute it and/or
> >> - *     modify it under the terms of the GNU General Public License
> >> - *     version 1 or 2 as published by the Free Software Foundation.
> >
> > Shouldn't this be
> > // SPDX-License-Identifier: GPL-1.0 OR GPL-2.0
> > (or in current SPDX notation GPL-1.0-only OR GPL-2.0-only) ?
> >
>
> Nope, as it will fail spdxcheck.py. Also, SPDX specification [1]
> doesn't have negation operator (NOT), thus the licensing requirement
> on the above notice can't be expressed reliably in SPDX here.
>
> [1]: https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/

The GPL identifiers in recent versions of SPDX include an `-only` and
an `-or-later` variant. So I don't see why you can't represent it as
`GPL-1.0-only OR GPL-2.0-only`. From what I understand the kernel
requires/prefers use of the earlier approach to GPL identifiers (which
was better in my opinion) under which `GPL-1.0 OR GPL-2.0` would at
least be semantically similar. I don't see why you need a negation
operator in this case. You have other patches where you used the
`-only` identifiers.

Richard


