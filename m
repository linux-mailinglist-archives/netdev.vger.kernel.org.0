Return-Path: <netdev+bounces-2425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA71701D8C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 15:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C89728035B
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 13:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9005392;
	Sun, 14 May 2023 13:08:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDC74C87
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 13:08:35 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9342D43;
	Sun, 14 May 2023 06:08:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-643995a47f7so12151962b3a.1;
        Sun, 14 May 2023 06:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684069711; x=1686661711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y5XEouAH/P1Pc1xR/i0kwTIYjZQ4lEbXoXqgUXs2Qrc=;
        b=JgFgXkWGfmHspAu7HjxcvhDThdTjCYb1GNamypAn0LCFacWj8H5PF8YNDKsh/tltmv
         LqdKH0NNZhsyay3GsncvplLD3ClamfUcj0OyLTHNhYu9JaddW/YiogoN5e0ZyVELkp0R
         KTQ/K5Sn/xBtjAra7xamVhMaa1QU94H6fvOpT4+AqUlfDjFYBsVyt/meC8Jj4tZo1sbR
         586YES8hrpWNVFyydRbUXQL6dvIElCzLk2YWjgEmqvytADeUUHamD87e09ZifRyBLLio
         6yfsTPDGlXTuK79WwdedbhKlxetYYbIcNS4hYFQl+hr9HZMGmSmNi+xdUho7RYx/SL60
         dI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684069711; x=1686661711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5XEouAH/P1Pc1xR/i0kwTIYjZQ4lEbXoXqgUXs2Qrc=;
        b=K1znHE8W9EnrPS7ut1zKEMetujD6IHsFzzP+j+J+8gHKyb165OgNlTWew68GLMSaHN
         hack0Ykn08MWTvvsrQTOhIWG+WBf+EdWJQWlk9W8O9Ma2fS9wHfkeD5DKCmloxzf+xyS
         mt3ypMPVuhZLxd1bkRcbBtbBhJlQD5I98WShrHLN6KNKq1pSJ+2eS3UXjs5P49U8GFl4
         Fp2NqJWwtRbqL/I5UFAF/a82Iaz1uwrcghWi8fQn7RF37Yxny1i/W1EFq/bMJxwB1cKU
         YgSj2dBpk0Ua6SffPA1SnYbBj/Hu9VAaQm+oXZO2Dc1L6UuI1iHQZmM09zYGqmTqgrlV
         jXAQ==
X-Gm-Message-State: AC+VfDwEHDLRKgMx65pSzTlGS3LabFRMcH0tyijBJSfcWFGJ+Fcg7kwJ
	Dlfb9O4BBZlWWpdZLQ99NSM=
X-Google-Smtp-Source: ACHHUZ5ut8+Hg2HyxrT4MXIOvyVb3bS836tjfmXkxs1tJNydk4q379JJXY2tKiMm5x8T7vuA9c0e3w==
X-Received: by 2002:a05:6a20:3d28:b0:103:9c25:99a3 with SMTP id y40-20020a056a203d2800b001039c2599a3mr18361027pzi.59.1684069711559;
        Sun, 14 May 2023 06:08:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b30-20020a631b1e000000b0050bd4bb900csm9760255pgb.71.2023.05.14.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 06:08:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 14 May 2023 06:08:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Fontana <rfontana@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
	Wim Van Sebroeck <wim@linux-watchdog.org>, Jan Kara <jack@suse.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Ray Lehtiniemi <rayl@mail.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>,
	Marc Zyngier <maz@kernel.org>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Sylver Bruneau <sylver.bruneau@googlemail.com>,
	Andrew Sharp <andy.sharp@lsi.com>,
	Denis Turischev <denis@compulab.co.il>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Alan Cox <alan@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2 08/10] drivers: watchdog: Replace GPL license notice
 with SPDX identifier
Message-ID: <511814a0-0c42-4813-9473-13748d6c6cb0@roeck-us.net>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
 <20230512100620.36807-9-bagasdotme@gmail.com>
 <CAC1cPGy=78yo2XcJPNZVvdjBr2-XzSq76JrAinSe42=sNdGv3w@mail.gmail.com>
 <ef31b33f-8e66-4194-37e3-916b53cf7088@gmail.com>
 <CAC1cPGzznK8zoLaT1gBjpHP1eKFvTKKi+SW6xuXF3B8aHN27=g@mail.gmail.com>
 <2023051414-headroom-maimed-553c@gregkh>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023051414-headroom-maimed-553c@gregkh>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 12:07:28AM +0900, Greg Kroah-Hartman wrote:
> On Sat, May 13, 2023 at 09:43:39AM -0400, Richard Fontana wrote:
> > On Sat, May 13, 2023 at 6:53 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> > >
> > > On 5/12/23 19:46, Richard Fontana wrote:
> > > > On Fri, May 12, 2023 at 6:07 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> > > >
> > > >
> > > >> diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
> > > >> index 504be461f992a9..822bf8905bf3ce 100644
> > > >> --- a/drivers/watchdog/sb_wdog.c
> > > >> +++ b/drivers/watchdog/sb_wdog.c
> > > >> @@ -1,3 +1,4 @@
> > > >> +// SPDX-License-Identifier: GPL-1.0+
> > > >>  /*
> > > >>   * Watchdog driver for SiByte SB1 SoCs
> > > >>   *
> > > >> @@ -38,10 +39,6 @@
> > > >>   *     (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> > > >>   *                                             All Rights Reserved.
> > > >>   *
> > > >> - *     This program is free software; you can redistribute it and/or
> > > >> - *     modify it under the terms of the GNU General Public License
> > > >> - *     version 1 or 2 as published by the Free Software Foundation.
> > > >
> > > > Shouldn't this be
> > > > // SPDX-License-Identifier: GPL-1.0 OR GPL-2.0
> > > > (or in current SPDX notation GPL-1.0-only OR GPL-2.0-only) ?
> > > >
> > >
> > > Nope, as it will fail spdxcheck.py. Also, SPDX specification [1]
> > > doesn't have negation operator (NOT), thus the licensing requirement
> > > on the above notice can't be expressed reliably in SPDX here.
> > >
> > > [1]: https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/
> > 
> > The GPL identifiers in recent versions of SPDX include an `-only` and
> > an `-or-later` variant.
> 
> But Linux does not use the newer versions of SPDX given that we started
> the conversion before the "-only" variant came out.  Let's stick with
> the original one please before worrying about converting to a newer
> version of SPDX and mixing things up.
> 

Either case I'd prefer to have no conversion if there is no means
to express the original license (ie GPL-1.0 or GPL-2.0 and nothing else)
in acceptable SPDX form.

Thanks,
Guenter

