Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99F48A653
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346945AbiAKDbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346934AbiAKDbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:31:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4545C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:31:48 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u25so61807145edf.1
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEXDL2d5mW4dgNlrsV8b01CLHO2/qMkqM99n3xl1TPA=;
        b=FyLvpJ1ZUoGF3g5uvFCwTOHKR079Hu87MuIs3DVN7fscUsk3tY2DUgp69HVHHHQIjU
         XUFcHY9EZzK1MmE4mpTuhjOjaNxMOMXXCJ8e2hqbrcfjja8ztfJqy1UvHsRaKd/OdCR3
         +Pdqz2jBu645swYVXmS34WWp8g8qMucxzfWhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEXDL2d5mW4dgNlrsV8b01CLHO2/qMkqM99n3xl1TPA=;
        b=JboIFT00BdguihodqekYaNK7dIlGHQbtNvLNiLRggCv13Vq5dkxYhCRezBChgtiQQu
         Ve7XarqNM6y+5ayM2B3Zgh3XwpZkfL/5CfaHiRxdTt5W+rNb8wrxGcG98f3jgl139Xgr
         rhzlFrhQ6PeUUPDOs7okw5A8ujNgQqLEVh3hnydDATmsNLZy5NoUWxxiNrYDrJUjwJKX
         rNwNZqeI55Km4uTkXuI5PUzj2l9xhLVPhzFd7Vs5Hnl+mtv3Nq3Ql6lCV5HydLnedXuc
         6qAh3HpGWDGVVi0I+gfHeGbB154DyntwBo/L85AFaq9mlH5C+gnzZzAdJzFyZbH9GMgy
         aSdw==
X-Gm-Message-State: AOAM531uYF6+pGmh5D7NudlAuNvp63ETP8nHtDLoH8/hLNEpWoF7SUEE
        Me/1G4dXk0IBsfeueIjjUcAhf+nY0+axapDPdrE=
X-Google-Smtp-Source: ABdhPJzLBn1Vej41MRJ+3fyW2ePdZHqGtugunqybjS16Scu+1yJWqU1+fb0kcmaRZzokYbA9vG94vA==
X-Received: by 2002:a17:907:7e87:: with SMTP id qb7mr2016380ejc.107.1641871907200;
        Mon, 10 Jan 2022 19:31:47 -0800 (PST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id ho31sm2738412ejc.67.2022.01.10.19.31.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 19:31:46 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so1060887wme.0
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:31:46 -0800 (PST)
X-Received: by 2002:a05:600c:4f49:: with SMTP id m9mr633357wmq.8.1641871906578;
 Mon, 10 Jan 2022 19:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20220110025203.2545903-1-kuba@kernel.org>
In-Reply-To: <20220110025203.2545903-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Jan 2022 19:31:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
Message-ID: <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.17
To:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 6:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> At the time of writing we have one known conflict (/build failure)
> with tip, Stephen's resolution looks good:

Ok, the trees that trigger the conflict haven't actually hit my tree
yet, so I'll see that particular conflict later.

I assume I'll get the irq_set_affinity_and_hint() patches from Thomas
at some point - Thomas, can  you make sure to remind me of this
conflict, because this is exactly the kind of thing I would catch on
my home machine due to doing full builds, but that I will probably
miss if I'm on the road.

I'm home for a couple more days and will try to do as much of the
merge window heavy lifting as possible before my travels start, but
we'll see..

>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/5.17-net-next

Merged. But I now note that this actually triggers an error when
building with clang:

  net/netfilter/nf_tables_api.c:8278:4: error: variable 'data_size' is
uninitialized when used here [-Werror,-Wuninitialized]
                          data_size += sizeof(*prule) + rule->dlen;
                          ^~~~~~~~~

and I think clang is entirely right.

Sadly, I didn't actually notice that before having done the merge, so
I'll have to do the fixup as a separate commit.

I really wish we had more automation doing clang builds. Yes, some
parts of the kernel are still broken with clang, but a lot isn't, and
this isn't the first time my clang build setup has found issues.

I also notice that NET_VENDOR_VERTEXCOM defaults to 'n'. That's fine
by me, but it seems unusual. Normally the 'enable vendor XYZ' tend to
default to 'y'. But for unusual (and new) vendors, maybe that 'n' is
the right thing to avoid unnecessary questions.

And maybe that NET_VENDOR_xyz thing has happened many times before,
and I just haven't happened to notice...

               Linus
