Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE06A24FBE
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfEUNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:07:21 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:42330 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbfEUNHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:07:21 -0400
Received: by mail-ua1-f68.google.com with SMTP id e9so6587467uar.9;
        Tue, 21 May 2019 06:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9zdMKMq6YtEJcAmlQV2agBqhGjgcY71RbSkdU/Um18Y=;
        b=qC1pmOKJLrPxvbs5uWxUquS1d16CTi0asKi9/eQNiTV5z/S1Ip1ltRprrHUWL2XKNr
         a3FfEM4avx5+RmkBwIA9L98W0IyKPeiwySXW7A2ZNJeFJ3NJzOpVLTTcNNRlhItyccGb
         BvaFnGp7VnCXVrJcWIvWPmT75HZo4M2aRMG+2CTBDjZ/4CLlI5vvbsZwIeyVcwhYTvr1
         l7PiKKoGT9OyirczJzWkdKCBcaD7yqupSnzI878mTYz2V3cj481HzeudwWW8AVx1sOPS
         g8kOrav3Hu12nt44/AiLWlkr5ox0kqMNWIX7M9HkdSE8RbVF38EL+PqKPmWC0uRsYWTr
         6VHw==
X-Gm-Message-State: APjAAAWZNtEyCtNYos6/9FJxcQzCoeuJvpam88FdbQy5ymvA2hmrKYzX
        2G51mxinvw/NHoFucEZ6WA1vzWiOE7MlXqchm7I=
X-Google-Smtp-Source: APXvYqwk86c0hOBvUvXgwVC5HhHHgKfiCpYrw7PY71h9R+NjlgSuR31+RKZOh67So1NHcZxoXJw+Sjkim3xtMudQ18M=
X-Received: by 2002:ab0:2bc6:: with SMTP id s6mr4471903uar.86.1558444040004;
 Tue, 21 May 2019 06:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-23bfaa594002f4bba085e0a1ae3c9847b988d816@kernel.org>
In-Reply-To: <git-mailbomb-linux-master-23bfaa594002f4bba085e0a1ae3c9847b988d816@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 May 2019 15:07:08 +0200
Message-ID: <CAMuHMdXH4A96CUuSkmnL8RVubRyd9eswz9VPqBsDqXGbNCWncw@mail.gmail.com>
Subject: Re: net: phy: improve pause mode reporting in phy_print_status
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Wed, May 8, 2019 at 8:02 AM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Commit:     23bfaa594002f4bba085e0a1ae3c9847b988d816
> Parent:     5db9c74042e3c2168b1f1104d691063f5b662a8b
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/23bfaa594002f4bba085e0a1ae3c9847b988d816
> Author:     Heiner Kallweit <hkallweit1@gmail.com>
> AuthorDate: Sun May 5 19:03:51 2019 +0200
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Tue May 7 12:40:39 2019 -0700
>
>     net: phy: improve pause mode reporting in phy_print_status
>
>     So far we report symmetric pause only, and we don't consider the local
>     pause capabilities. Let's properly consider local and remote
>     capabilities, and report also asymmetric pause.
>
>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Due to this commit, I see the folllowing change on Renesas development
boards using either the sh_eth or ravb Ethernet driver:

    -sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow
control rx/tx
    +sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off

and

    -ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
    +ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

Adding debug prints reveals that:

    phydev->autoneg = 1
    phydev->pause = 1
    phydev->asym_pause = 0 or 1 (depending on the board)
    local_pause = 0
    local_asym_pause = 0

Is this expected behavior?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
