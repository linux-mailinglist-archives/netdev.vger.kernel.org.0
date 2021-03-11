Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF00336A33
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCKCjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCKCjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:39:41 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1410C061574;
        Wed, 10 Mar 2021 18:39:41 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id a7so20257958iok.12;
        Wed, 10 Mar 2021 18:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zey6YZH56sG0/UgybfDLXqvfVhV/K5l7tMblValKcY8=;
        b=URbzlaTvQBEsRiwzE06HKEsMuT/D+UMvVLhO5t5/ADgc3QQlD/j9vDU4JNAN+wCN20
         cRyRtmeW64S/bW7iRcbtw0gwMBpSpjvfWu5XUNbQjpjRBaPAQoCAp8s26SoXqPYGiXWo
         bUO9cuCg1KZZctCvW/BxAps/5msoY1hXvIZyvCmtuBfuHH9chR/wmkel/hZQPgXzr/hK
         r4CpbgQa+IREUD5RBEIYaNBqOdYx3VfGAyBiPQAzCtGxudrs4qK8pO7oFcBWq1qsgPtB
         fnJGNyg6268xPFqkUoGMd0oK1oQ0XFSfnNczM0iXQZcCuoGkYdemt3K2sHgLG21a9QTT
         GZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zey6YZH56sG0/UgybfDLXqvfVhV/K5l7tMblValKcY8=;
        b=J0OGCVxo3celb0ATxEI2ts8bwk4e5o3swEdz9Wv8iZ/5fPPp7vGWEAeKwdpf0hoImC
         0hSINoWRH6JnzePV29GsmwYP7PkSfnOt7WY+2M5tKbNbsuN/IYMEoQkBs/6y6qfYNGye
         jbswvtIpY3I9SyuiaFkgEsjIqVul0gGG5D8hIvyDJXYRvKRqp0fMBgWTPnqOWzeHsbVW
         v7mcxHh/Efgy7A9vh1BZGQfeXO3ENOEeQkmwtwiZoVyn89thtEP7Czgu4BihZ44eGdP9
         BjEw5osD9/tjrn1RZ18oMUx1485zBLOEpg9A0vP/7JoCbNPLCpRPv5ZWW6BizGQi4E1k
         ogTw==
X-Gm-Message-State: AOAM532cgmF/EXMziyEP/cWWtP7zPcafF17vx3rQwTKHOqHhAwCs2rJr
        IG6HFXS81DSBMs1Bp0Rice5V+Bkom4JD1Ingb7M=
X-Google-Smtp-Source: ABdhPJzeglhviCeDW2QHAhoIus4BFhvOF/qC/o1iQtaVDkQ3mEKFf5ln4brGK2Khg4RJb8kQRL1iZv+qa0c67wGKSAE=
X-Received: by 2002:a6b:5818:: with SMTP id m24mr4577553iob.144.1615430381060;
 Wed, 10 Mar 2021 18:39:41 -0800 (PST)
MIME-Version: 1.0
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-3-ilya.lipnitskiy@gmail.com> <20210310231026.lhxakeldngkr7prm@skbuf>
In-Reply-To: <20210310231026.lhxakeldngkr7prm@skbuf>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Wed, 10 Mar 2021 18:39:29 -0800
Message-ID: <CALCv0x2f5M6phoGi2PMfmW9igcS3kmMm9Y5fSRi3oKckV4F1yA@mail.gmail.com>
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
I think I knew this, but didn't think it through. Thanks for your
guidance. I have submitted a single patch to "net" and that same patch
and two more to "net-next" - hopefully that looks better, but I'm sure
I have more to learn still.

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
