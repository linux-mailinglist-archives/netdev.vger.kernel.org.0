Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBB5326A4E
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBZXEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhBZXEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 18:04:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E91C06174A;
        Fri, 26 Feb 2021 15:03:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id s23so6998460pji.1;
        Fri, 26 Feb 2021 15:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MTE5995sW7xCg6+cKusbl1v/9cFqGNg5CN+o+ZRAfSo=;
        b=OEK3agoH/vKSQ9T+6ySU8JlUUJVwfeMErbjV082/J+5HPKHg1Lg373HLrTQMISERqq
         MF7oeJ/MszWlLnf2rD6HXq3fceyJ5dm5TaemKhNaZ/kvNejVELiqTXlUV0vO8Gjm8VIX
         QnA6qzmq+uoeHfqtFSDzObZcpbNG5GAHPl1PE9Nd/JEqOXIgkH3mVgyON76JndBmuDJO
         AIYVXtPwirUSMfogPcvDNF/+h75nSxcgyNKGRpi/u0ro5bhzR7qXtb8bhf5yVgbYxWz9
         cLzkmiE5QzSyTqxsjKMadzlDNEdOMTPVQVtqaoJiJZrZHLeGon4dhC9pmdfl9jBvJEKa
         i/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MTE5995sW7xCg6+cKusbl1v/9cFqGNg5CN+o+ZRAfSo=;
        b=WU+i1yUdmtJ+aLllWrEMndpSyO1bDjAqmlCd/+vGmGhuRbp9mf5Npyx0DSNLAGjv6Z
         VfIvEO2LfDDLiLO9Y5coNtWd+2S2wkasRfBXE2xetVP/Hjei2ihshtfWZerQfXnZ5HxV
         2jyDBxct0+unntR4ws43c46ylhJg16WEkxBqnIhIKMTZnofpHmNVWd1Cyh1rNf9Tbk5k
         FQVkP7vo9KEyU7BiRcBEa4BOTDuwZ9VkwAhvvfsEMq5OPNhASIo6hQPIMdWFHXp7uYNK
         nTwrE/LFO4sXxrKHNkWt0SeVobZbtRsSdy4ee+jimXSmuMway9KQng1Ry3VTj97g2cG0
         Ja3Q==
X-Gm-Message-State: AOAM533lcd3WC++aPQlBg4Ey8uJ71aO8itMdO1XNzyvTOXprMkIpeRpW
        cxGbJikDQfsb5Pd/xBktXLSv6Eq8sP7jYS8VZzo=
X-Google-Smtp-Source: ABdhPJzOH9d25r0TOB+9aLqWrsbb5RGizo1REEYWgjMf9b67Sl6+dWZATP+rBxbDQxl0ic8KnhjBgrt+vNvPBWLBY7M=
X-Received: by 2002:a17:902:8209:b029:e3:2c17:73a9 with SMTP id
 x9-20020a1709028209b02900e32c1773a9mr5057040pln.23.1614380602051; Fri, 26 Feb
 2021 15:03:22 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
 <906d8114f1965965749f1890680f2547@dev.tdt.de> <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
 <e1750da4179aca52960703890e985af3@dev.tdt.de>
In-Reply-To: <e1750da4179aca52960703890e985af3@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 26 Feb 2021 15:03:11 -0800
Message-ID: <CAJht_ENP3Y98jgj1peGa3fGpQ-qPaF=1gtyYwMcawRFW_UCpeA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 6:21 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I have now had a look at it. It works as expected.
> I just wonder if it would not be more appropriate to call
> the lapb_register() already in x25_hdlc_open(), so that the layer2
> (lapb) can already "work" before the hdlc<x>_x25 interface is up.

I think it's better not to keep LAPB running unless hdlc<x>_x25 is up.
If I am the user, I would expect that when I change the X.25 interface
to the DOWN state, the LAPB protocol would be completely stopped and
the LAPB layer would not generate any new frames anymore (even if the
other side wants to connect), and when I change the X.25 interface
back to the UP state, it would be a fresh new start for the LAPB
protocol.

> Also, I have a hard time assessing if such a wrap is really enforceable.

Sorry. I don't understand what you mean. What "wrap" are you referring to?

> Unfortunately I have no idea how many users there actually are.
