Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8069D2935F2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405322AbgJTHkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:40:20 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36733 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405308AbgJTHkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:40:19 -0400
Received: by mail-oi1-f196.google.com with SMTP id u17so1219785oie.3;
        Tue, 20 Oct 2020 00:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MphawCggZoPyPLPjOXzPYGZL3RA+kXoFqq50s1cKbPA=;
        b=EfJ+eEd2kz28e/2VVafp28Vkpx9TxwmSI0jGg5zrBJXNggCddrzoc7kD713isApArz
         O/9nkW72cwlaRHkTrT09QCvfJGkJRG9CKOs8jJq87tiUHgUIZ2u+KcVF3B1hgNZ5uA/E
         S1lu6sni+DeHS8JOU1msDSl5c03JbvqvQ1ugwQrgKlNWxsEK5D79C0qtaq85t3jOP3Kw
         6GXwnqinr3TzaRw/EF/FjCMB7ddCT87mv4yiot8DZQ+XbYB69oFPM1OQtxucikbkpJmK
         e3Y/9kk/q1h9y8nHDwgvHZOw2nMTWBJHOAXmGg8enkge1J9hUd0I9XAYguJtj8NOmcG2
         xU+g==
X-Gm-Message-State: AOAM531hYIPSUI49CwLUy3kQr1MhO90yK6A9Z1oNRIpWV18XwEXo1Ccw
        FQCzWe44gwb1AHaiLjCNXjmK0QqGa4N2DX0L1QA=
X-Google-Smtp-Source: ABdhPJyfi/DdUPsxmzKRpKKKW0CKJyIiG/pHw6av94t0zAWOI2HIbQXGQIaG17RxvjCsdgV+mSmRFi3GNy15DLE6koY=
X-Received: by 2002:aca:c490:: with SMTP id u138mr1010902oif.54.1603179617218;
 Tue, 20 Oct 2020 00:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201019113240.11516-1-geert@linux-m68k.org> <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
 <CAMuHMdUDpVVejmrr3ayxnN=tgHrgDmUCVMG0VJht1Y-FUUv42Q@mail.gmail.com>
In-Reply-To: <CAMuHMdUDpVVejmrr3ayxnN=tgHrgDmUCVMG0VJht1Y-FUUv42Q@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Oct 2020 09:40:06 +0200
Message-ID: <CAMuHMdWEKszUOA6Q9Y+vpLdRnq3wstCj1ubV=8iUKZAQkew_wg@mail.gmail.com>
Subject: Re: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead
 of selecting it
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 10:38 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Oct 19, 2020 at 5:47 PM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
> > On 19/10/2020 13:32, Geert Uytterhoeven wrote:
> > > MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
> > > user may not want to enable.  Fix this by making the test depend on
> > > MPTCP instead.
> >
> > I think the initial intension was to select MPTCP to have an easy way to
> > enable all KUnit tests. We imitated what was and is still done in
> > fs/ext4/Kconfig.
> >
> > But it probably makes sense to depend on MPTCP instead of selecting it.
> > So that's fine for me. But then please also send a patch to ext4
> > maintainer to do the same there.
>
> Thanks, good point.  I didn't notice, as I did have ext4 enabled anyway.
> Will send a patch for ext4.  Looks like ext4 and MPTCP where the only
> test modules selecting their dependencies.

FTR, "[PATCH] ext: EXT4_KUNIT_TESTS should depend on EXT4_FS instead
of  selecting it"
https://lore.kernel.org/lkml/20201020073740.29081-1-geert@linux-m68k.org/


Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
