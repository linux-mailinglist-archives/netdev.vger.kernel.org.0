Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCD12B9828
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgKSQgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbgKSQga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:36:30 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07211C0613CF;
        Thu, 19 Nov 2020 08:36:30 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id w142so9139127lff.8;
        Thu, 19 Nov 2020 08:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GL1geUz8ksyok3o+HModRJUNdxfeUOLSXkwVu2pzVw=;
        b=ZjIHp4XbVLR3mEdwG18h+SFeiMuVhrEnm1I+o4JxYe6xHL5cGGoXTKaqksF40qh8AV
         2a15evGdxclpi/ZpK3Ojgi1SDjsiUalaB5XrqUBfjloVKgOnM1hLIsAlAyxTrZzPWMrQ
         p2Rpa9Q8r9pw/XLekQzHqIvCkjO+b6dNblaWQHeesD9xdO2t4KU1JbYUFndDC7ID7L1X
         CpbGZj+Q/Up26Jch8B7PWpmY/IWjeHqKISZiCEfyZ5Clq9X6mWAsqoZm3LwIkr919haZ
         S2B3+4g+z6fSO4nVDsNN8M3/frXb6a00DBqqUhskplPrNUbshRN9IyZhpdD/elrJmc0U
         AS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GL1geUz8ksyok3o+HModRJUNdxfeUOLSXkwVu2pzVw=;
        b=aU3qadSBa7oknL5/q5aYKb0PeVs1gt9CN3aE2NHuaiEQek22HE6/UHJQ39zFJEROgi
         eoHRMxXS3gV9+JANG3NrslyVzQn968Nc+pROmFyBd4nPhJDEekCpxXsKoGRilX3Ns5UE
         VxVmS88BpScPnX3594qB9DifaBZW55o2rzBSRwQNjA4IVnXyIXOGFo2KBj1yHF5bAmla
         jdMLTlk/aA8/uf7kxpJ850NDMTIifbAbNpRmDkZosRqzRIYvQHLqLlZPKYrxnYmzY3OI
         U9zm3AiusLqqH9S/m1WCxabGxHnvw3zpfoQdySr38JOKFVC5P6AkvGuuOK/6ugn8frrO
         gbyg==
X-Gm-Message-State: AOAM5304kl0yznGzfigqrVQGCRnmxzDPTlP4lIg4Mk1ZzjaSllRb5Zyb
        ZGAXbkqVPVRtqRi7nMdYtOXZtekiDG1bpviMPSU=
X-Google-Smtp-Source: ABdhPJxXfPjRWHEbwDGN5Oo7lGcgZBlLqA+m05kWlN7DzRDYiiWURZwOXfqHnCGxcIQDLNCmrccAvLKQJw5PMbW1Ys8=
X-Received: by 2002:a19:48ca:: with SMTP id v193mr5856891lfa.263.1605803788474;
 Thu, 19 Nov 2020 08:36:28 -0800 (PST)
MIME-Version: 1.0
References: <20201118230929.18147-1-rentao.bupt@gmail.com> <20201118232719.GI1853236@lunn.ch>
 <20201118234252.GA18681@taoren-ubuntu-R90MNF91> <20201119010119.GA248686@roeck-us.net>
 <20201119012653.GA249502@roeck-us.net> <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 Nov 2020 08:36:17 -0800
Message-ID: <CAADnVQL86rs=bc+fg1EsHYZzYGC_WWOPtAVWWTqwmA_6SToGUA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, openbmc@lists.ozlabs.org,
        taoren@fb.com, mikechoi@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 7:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 17:26:53 -0800 Guenter Roeck wrote:
> > On Wed, Nov 18, 2020 at 05:01:19PM -0800, Guenter Roeck wrote:
> > > On Wed, Nov 18, 2020 at 03:42:53PM -0800, Tao Ren wrote:
> > > > On Thu, Nov 19, 2020 at 12:27:19AM +0100, Andrew Lunn wrote:
> > > > > On Wed, Nov 18, 2020 at 03:09:27PM -0800, rentao.bupt@gmail.com wrote:
> > > > > > From: Tao Ren <rentao.bupt@gmail.com>
> > > > > >
> > > > > > The patch series adds hardware monitoring driver for the Maxim MAX127
> > > > > > chip.
> > > > >
> > > > > Hi Tao
> > > > >
> > > > > Why are using sending a hwmon driver to the networking mailing list?
> > > > >
> > > > >     Andrew
> > > >
> > > > Hi Andrew,
> > > >
> > > > I added netdev because the mailing list is included in "get_maintainer.pl
> > > > Documentation/hwmon/index.rst" output. Is it the right command to find
> > > > reviewers? Could you please suggest? Thank you.
> > >
> > > I have no idea why running get_maintainer.pl on
> > > Documentation/hwmon/index.rst returns such a large list of mailing
> > > lists and people. For some reason it includes everyone in the XDP
> > > maintainer list. If anyone has an idea how that happens, please
> > > let me know - we'll want to get this fixed to avoid the same problem
> > > in the future.
> >
> > I found it. The XDP maintainer entry has:
> >
> > K:    xdp
> >
> > This matches Documentation/hwmon/index.rst.
> >
> > $ grep xdp Documentation/hwmon/index.rst
> >    xdpe12284
> >
> > It seems to me that a context match such as "xdp" in MAINTAINERS isn't
> > really appropriate. "xdp" matches a total of 348 files in the kernel.
> > The large majority of those is not XDP related. The maintainers
> > of XDP (and all the listed mailing lists) should not be surprised
> > to get a large number of odd review requests if they want to review
> > every single patch on files which include the term "xdp".
>
> Agreed, we should fix this. For maintainers with high patch volume life
> would be so much easier if people CCed the right folks to get reviews,
> so we should try our best to fix get_maintainer.
>
> XDP folks, any opposition to changing the keyword / filename to:
>
>         [^a-z0-9]xdp[^a-z0-9]

Reducing regex makes sense.
git grep -l -E "xdp"|wc -l
348
git grep -l -E "[^a-z0-9]xdp[^a-z0-9]"|wc -l
295

The false positive match was:
+drivers/hwmon/pmbus/Kconfig
+drivers/hwmon/pmbus/Makefile
+drivers/hwmon/pmbus/xdpe12284.c
+drivers/net/ethernet/natsemi/ns83820.c
+drivers/net/ethernet/neterion/s2io.c
+drivers/net/ethernet/neterion/s2io.h
+drivers/net/ethernet/neterion/vxge/vxge-config.c
+drivers/net/ethernet/neterion/vxge/vxge-config.h
+drivers/net/ethernet/neterion/vxge/vxge-traffic.c
+drivers/net/ethernet/sis/sis900.c
+drivers/net/ethernet/sis/sis900.h
+drivers/net/wireless/ath/ath5k/ath5k.h
+drivers/net/wireless/ath/ath5k/base.c
+drivers/net/wireless/ath/ath5k/debug.c
+drivers/net/wireless/ath/ath5k/dma.c

so it's pretty much hwmon and few drivers.
I agree that sparing xdp from hwmon patches is a good thing :)
