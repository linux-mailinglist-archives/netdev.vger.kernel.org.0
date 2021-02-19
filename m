Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6290431FFD2
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBSU3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 15:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhBSU3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 15:29:03 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D394C061786;
        Fri, 19 Feb 2021 12:28:23 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o63so5635630pgo.6;
        Fri, 19 Feb 2021 12:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4EqFO0bHbbTwpYb76+dNzJNfpMa1CvcusLleWdgGeU=;
        b=FjbQtzavC+F6wFZFWqI/3sC7jEEjVbmpIItbY6mJdmalBiaERgiiTrttCFz6vibxqB
         ACzjaHvFiyT4LhlkZXHDFX41AvRRqzGRm3kyo1oP9dnjhEUCN9+yTn0tk0KmGQfRFPxi
         jSZ37aKyRXYnmrKrgVTxKRxeH/Y9G0gUepagvWzflo/A5CDWZcUaWf0+VE43qvrFfTtj
         LoMrthb51/s29XZifhv+MklYAlO4isQtEC3eDKR8ACfPCkLi9en75RqU3qVDUlMA+Tcg
         tXP5A6V7wIiqhECOAnBYymtn7F5J6yo/veej9rXon1y7MbY6zXYRTDvoSS7WRVJxGnrY
         +EzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4EqFO0bHbbTwpYb76+dNzJNfpMa1CvcusLleWdgGeU=;
        b=rV6dcjRepkmEwbQvXgLzs2px9KvUSSyL8fspuQtK/+/1XL4Miy3S1Cs6dFZRdqmdyu
         r3sZLoT1Zbz0uV/TViooxn4SPRJcBZdgH+59tCSv1d7eQgIu2xEN6dxLw21fc48LvLUF
         oipwqgdIPU/WvqbS8qWfkw7eu/MWroY3hP3YBGXIB9FqVrt8nSUmSw8WuBmVSNMVPpS0
         MQDPN3nHTdJQsyfJGe48Kriz0fiEGm936T9/43zhI+RoiKmP/NaAxAjf20F+H9oInJjX
         gC6ZUqwP/x+Vw6tVEt5IBVEN5M1v+oRGH4w4lXyhR1S1rkhyROPi5HD6DS6jIRtgZ2nl
         7irQ==
X-Gm-Message-State: AOAM532+azrM5zw3Aj//9kOBSeXAIJP56L5hNJ82Hs5qd9bz32trgR9M
        AKsYkDQ0AO4pPOnFeveliDVx7eFNPppjWbaJqXUyLsXpEWQ=
X-Google-Smtp-Source: ABdhPJzJPzoRjCcfakTT18WRUTXj85l7X9izRxh5eUWA6sishY22bISBIHuRsK9jJeYlc21Ds0rZjaijFpndyVVH3jk=
X-Received: by 2002:a65:56c6:: with SMTP id w6mr10005007pgs.368.1613766503127;
 Fri, 19 Feb 2021 12:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com> <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 19 Feb 2021 12:28:12 -0800
Message-ID: <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 10:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Not entirely sure what the argument is about but adding constants would
> certainly help.

Leon wants me to replace this:

dev->needed_headroom = 3 - 1;

with this:

/* 2 is the result of 3 - 1 */
dev->needed_headroom = 2;

But I don't feel his way is better than my way.

> More fundamentally IDK if we can make such a fundamental change here.
> When users upgrade from older kernel are all their scripts going to
> work the same? Won't they have to bring the new netdev up?

Yes, this patch will break backward compatibility. Users with old
scripts will find them no longer working.

However, it's hard for me to find a better way to solve the problem
described in the commit message.

So I sent this as an RFC to see what people think about this. (Martin
Schiller seems to be OK with this.)

I think users who don't use scripts can adapt quickly and users who
use scripts can also trivally fix their scripts.

Actually many existing commits in the kernel also (more or less) cause
some user-visible changes. But I admit this patch is a really big
change.
