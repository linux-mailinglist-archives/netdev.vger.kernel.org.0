Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD4336A86
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCKDSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhCKDSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:18:04 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01018C061574;
        Wed, 10 Mar 2021 19:18:03 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id k2so17667243ili.4;
        Wed, 10 Mar 2021 19:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDVCmWBMN4wY4blBCdk5NbxQ4zATbHUHg6v9hjuwVWI=;
        b=lRq96C4BWNBxmE9Wkmv695xAY5/ghHOfDUq3ch5uIRfQn0e1KfAkVtU/mT7Dtdi/5V
         pNX5+vC/lSuHO33M/yNWgVrLUk4Qu7oyIukjcFYJQf3Ytbt4I6xHZ8ABUk5j8yxYDusI
         2f8iAsGLUGP7jMVNTQ4kutwrezoOhjPhNDZTitOLQVgb2F9ZbUf2ylMZZrCtMOv7Z7A2
         QF2gyeu0uhQxGxl3DGySDhLxoBYOCXSieMhrz4gHtdWrzwS7ma5ForjOTHfdLwF6mIpW
         MjXilZQrELyFczNZJVNu6dKA8Z5VqDHetBMP+dAwi1Jh8qWkHm1eeVcET/AVIiWlj0+4
         6Y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDVCmWBMN4wY4blBCdk5NbxQ4zATbHUHg6v9hjuwVWI=;
        b=X86JK36idgxw1SAs6K5RmAZSmJ4/KIQEqjXdv8Spy6sAmunQ39jSGRhK4EE/yg7wZK
         lNscYH22gLOlsmDxNJXCGc57iN5xE2u+sYrpofzENrPecnyVGKeQTPpQfc2K6YH7xefX
         gZTwIj/UfX/lXqy1sHDxR8eYc5WQuwHD/FcZHguMsLy3CFe1UrXJMot3E/6hKHzqGZYQ
         pjKwwcp1Zvwwa4D31M48DuC8aJ/VOI/DmSEDS2k5RlOH0/V74uYXRnXS7cI95d5eZYO/
         269oXDDiM8/8tyzZ7tuZKG4u5xk1UOP9WEqiNBl81RxHwPxt4mlcWEGtacc2xgp2C9yb
         0AVA==
X-Gm-Message-State: AOAM531Th2lBnDBz4BLPDoXjLibX2zn83aK2xbXMJQ24FCVpKn5kc+iU
        kwXIjNLQzjaU+q/CiYzOcwCwW7ufJV9m5SUtawM=
X-Google-Smtp-Source: ABdhPJwO613Bp41zr2CTUp0cH4WSHwqSazEWIyoQLC+TpS/jWusNSS40OlnL9oW2D2BOPwrYb2nn4Vd6sm1TkTrrIV0=
X-Received: by 2002:a92:cb49:: with SMTP id f9mr4997838ilq.0.1615432683376;
 Wed, 10 Mar 2021 19:18:03 -0800 (PST)
MIME-Version: 1.0
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-3-ilya.lipnitskiy@gmail.com> <20210310231026.lhxakeldngkr7prm@skbuf>
In-Reply-To: <20210310231026.lhxakeldngkr7prm@skbuf>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Wed, 10 Mar 2021 19:17:52 -0800
Message-ID: <CALCv0x0FKVKpVtKsxkq5BwzrSP2SnuYUaK38RHjd_zgoBCpdeA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: dsa: mt7530: setup core clock even in TRGMII mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Mar 10, 2021 at 3:10 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hello Ilya,
>
> On Wed, Mar 10, 2021 at 01:14:20PM -0800, Ilya Lipnitskiy wrote:
> > 3f9ef7785a9c ("MIPS: ralink: manage low reset lines") made it so mt7530
> > actually resets the switch on platforms such as mt7621 (where bit 2 is
> > the reset line for the switch). That exposed an issue where the switch
> > would not function properly in TRGMII mode after a reset.
> >
> > Reconfigure core clock in TRGMII mode to fix the issue.
> >
> > Also, disable both core and TRGMII Tx clocks prior to reconfiguring.
> > Previously, only the core clock was disabled, but not TRGMII Tx clock.
> >
> > Tested on Ubiquity ER-X (MT7621) with TRGMII mode enabled.
> >
> > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > ---
>
> For the networking subsystem there are two git trees, "net" for bugfixes
> and "net-next" for new features, and we specify the target tree using
> git send-email --subject-prefix="PATCH net-next".
>
> I assume you would like the v5.12 kernel to actually be functional on
> the Ubiquiti ER-X switch, so I would recommend keeping this patch
> minimal and splitting it out from the current series, and targeting it
> towards the "net" tree, which will eventually get merged into one of the
> v5.12 rc's and then into the final version. The other patches won't go
> into v5.12 but into v5.13, hence the "next" name.
I thought I figured it out - now I'm confused. Can you explain why
https://patchwork.kernel.org/project/netdevbpf/patch/20210311012108.7190-1-ilya.lipnitskiy@gmail.com/
is marked as supeseded?
>
> Also add these lines in your .gitconfig:
>
> [core]
>         abbrev = 12
> [pretty]
>         fixes = Fixes: %h (\"%s\")
>
> and run:
>
> git show 3f9ef7785a9c --pretty=fixes
> Fixes: 3f9ef7785a9c ("MIPS: ralink: manage low reset lines")
>
> and paste that "Fixes:" line in the commit message, right above your
> Signed-off-by: tag.
