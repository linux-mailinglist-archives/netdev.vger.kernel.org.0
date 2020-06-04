Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5572D1EECAD
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgFDU6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgFDU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:58:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BFDC08C5C0;
        Thu,  4 Jun 2020 13:58:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u13so1738791iol.10;
        Thu, 04 Jun 2020 13:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Qe+5VsgePcwf6ejrqCiKCctQ/WjhPUBGKBkCEYX6uA4=;
        b=odXbhUUcIf+wDeJdjDiEFXtAYFDHAH8SAaNwcJFDM9qyOS5kIxKELihPixhgMuWsuM
         P3ftGyZTm8N3iRqAE/zGh/6Tj/FwKzi+e312hNAri4dLyhuZsVZ6pvT0TGWVr82qZhqP
         xpzITULxMsu9HCeR/Fu8fY00Ujga47C2NYw0ZWpAq8nhchSjrc9Gx1hdB9IUk3cXGfsx
         VWi9Q6APAlhH+HlN+wzjZ2rOVsUqe/9ob+rhxSJYeRVHffy8QZ1CHAECUXaQz476rziC
         s3Xe2jQo9509hzQq9oZweKonvblBmfe30dX1ICjs/m7aTkmW94D1z6eVMJOHyrzwGabS
         qQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Qe+5VsgePcwf6ejrqCiKCctQ/WjhPUBGKBkCEYX6uA4=;
        b=LYl0CcSfK7WcwihtWFMyzO2bPwtto7IoZEvRE3mycYnjzVX3HVfXCnup+S9W/UjYB6
         7PjDgPpgAEyRrBMrwe7KcBHKMEjDMkzFUJM61c0r8YJy/9gxRFTBckd7NgKVuxhj50Vf
         oyHq7vMUqMINCS5yt2T5ngXzRUCGRDavO9b96u6Mesx8LZTJgbd5DrIopSPlmPxPv5qT
         Wd3IUH4iKCjcTO2mAjwxTV5rex1g3RwM5p5UzzeML72SJhsk+OsJDo3PaQy+rb8tME2O
         pf2UFPWYUBsA//WgL+ZPz3bkxw93Pj2tD1ubCGWNWaXEQgO8rZFhWawbKgBMrRm4JcFb
         bUHQ==
X-Gm-Message-State: AOAM532I8HbVFfCfyagpH+XTZfBHNomnicK+PUJeA8xQkCtorpL2unaI
        aeqVwQ6N5dNfBMm7pXfWKYrOXConN/mbnQRZT94=
X-Google-Smtp-Source: ABdhPJyHp6QCOAL+6a1wVmeMAZXhyv99uIVM4TXT2D1wSQJb1hxXPIfOtwEqduYsONFSiqzgwB7hE4xuQIiOkGIx+qI=
X-Received: by 2002:a02:ca18:: with SMTP id i24mr6012139jak.70.1591304293893;
 Thu, 04 Jun 2020 13:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-6-keescook@chromium.org> <CAKwvOdm5zDide5RuppY_jG=r46=UMdVJBrkBqD5x=dOMTG9cZg@mail.gmail.com>
 <202006041318.B0EA9059C7@keescook>
In-Reply-To: <202006041318.B0EA9059C7@keescook>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 22:58:02 +0200
Message-ID: <CA+icZUX7HE6cVoyiKtvOe85F+npUzGy5wmScTNCKRVeCEy8Juw@mail.gmail.com>
Subject: Re: [PATCH 05/10] ide: Remove uninitialized_var() usage
To:     Kees Cook <keescook@chromium.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 10:20 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 04, 2020 at 12:29:17PM -0700, Nick Desaulniers wrote:
> > On Wed, Jun 3, 2020 at 4:32 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > (or can in the future), and suppresses unrelated compiler warnings (e.g.
> > > "unused variable"). If the compiler thinks it is uninitialized, either
> > > simply initialize the variable or make compiler changes. As a precursor
> > > to removing[2] this[3] macro[4], just remove this variable since it was
> > > actually unused:
> > >
> > > drivers/ide/ide-taskfile.c:232:34: warning: unused variable 'flags' [-Wunused-variable]
> > >         unsigned long uninitialized_var(flags);
> > >                                         ^
> > >
> > > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> > >
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> Thanks for the reviews!
>
> > Fixes ce1e518190ea ("ide: don't disable interrupts during kmap_atomic()")
>
> I originally avoided adding Fixes tags because I didn't want these
> changes backported into a -stable without -Wmaybe-uninitialized
> disabled, but in these cases (variable removal), that actually does make
> sense. Thanks!
>

Fixes tag does not automatically mean it is "for-stable".

[1] says:

> Patches that fix a severe bug in a released kernel should be directed
> toward the stable maintainers by putting a line like this::
>
>   Cc: stable@vger.kernel.org

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n299
