Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51CD4688FA
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 04:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhLEDR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 22:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhLEDR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 22:17:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B978C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 19:14:31 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e136so21136690ybc.4
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 19:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUQYNDjSzoWBjWvHe6uuqlzy58Fmj0F3iBbvl34aMLw=;
        b=JFxa5qvdB2xQfHfrKzM7DdV2uFPm7XJG5ccQthX8Y1Y0L1a5EyVAVizdtV619w4yvj
         HtI6RNmdU8E5sxv4GR04OLZCTbKRzOZ6c5XXmwmN4/ocSoJVFb2h9PhXdUhlzn4iKNUj
         mxHk1TvUOr3HGoP7MnAcKjNu34InAy4KwpJKUWMeYpQMNk2+kFVi4C5M0mzXzCHPp6y3
         jXp3/vr+A3yh++Gu8k+AQEngfGGBrCZM04fyTr85sJwjJ3Vcy6a2IVaeZpIWD9JaPs5X
         V6ETb3n298IazFr4ZKCc5RxQfYfM4mYvPXmw4q3hCzk/R/yn5JkqvyV66Io/tcxproDY
         Sn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUQYNDjSzoWBjWvHe6uuqlzy58Fmj0F3iBbvl34aMLw=;
        b=RD2iEYVEvByZoufzmLmRGaHLQtgdTYHtU4zfL1Io4ZFWgRSq3h3EkHfwCASBOFDZfx
         ZiiMDslSp27XBN22WQLMelyXHXgsrOimtfJsr2XETIt/9ldt9hD7T3X69a2qAbDJPJRA
         PXE+t+84wR4WFbSLcIpWQV2j2UbEA4yNkyEqR+dm5b8qn52rbdm3YbLpx60P08UM1ARi
         V7Gg6HZ0vba0rEaSKeop8YsrV9sKPgYrqRVYOvUFgD0KOJLOGFIb3fS/5qAC2VfdV1LW
         kAjpPfS8sRLjWrabDJGXO3axB9IDxbpZ8N+m/c9T4fsx80cmoO2vHV5ETekw6PpsvOro
         Mk+g==
X-Gm-Message-State: AOAM532fDp+yfPPXt6Sbn/Bn+UR/na+D0tGNh2ULsJjxz/yAreVlwqHD
        KMr6jY5Qxysz6HiACYMx0jHfUiI24LuDDjTxwLjBPpXA6+D5Lw==
X-Google-Smtp-Source: ABdhPJyfghGWR7fORjpg4ZhxLtPm7PLMseIZScDA1XyoWWdYTF8RN7PEJmpw8wudVapKovc4AEHhZNT/nEKUgeOHk0I=
X-Received: by 2002:a5b:5c3:: with SMTP id w3mr14847428ybp.293.1638674070268;
 Sat, 04 Dec 2021 19:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20211203024640.1180745-3-eric.dumazet@gmail.com>
 <202112050729.hISLa0oF-lkp@intel.com> <CANn89i+q3S-TrqFS41_3Fo4_tckjWKRQoqCRvBXBxMjLaN-5Nw@mail.gmail.com>
In-Reply-To: <CANn89i+q3S-TrqFS41_3Fo4_tckjWKRQoqCRvBXBxMjLaN-5Nw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 4 Dec 2021 19:14:19 -0800
Message-ID: <CANn89iL5zB20hdGadWkiO19Jm-dKxeHET0Ww8M=tErktkhBBLQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 02/23] lib: add tests for reference tracker
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 4:45 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Dec 4, 2021 at 3:40 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Eric,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on net-next/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git fc993be36f9ea7fc286d84d8471a1a20e871aad4
> > config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20211205/202112050729.hISLa0oF-lkp@intel.com/config)
> > compiler: nios2-linux-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/98ad7e89138f4176a549203b6e23c2dc1cb9581d
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
> >         git checkout 98ad7e89138f4176a549203b6e23c2dc1cb9581d
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
> >
>
> I tried following these instructions, but this failed on my laptop.
>
>
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    lib/ref_tracker.c: In function 'ref_tracker_alloc':
> > >> lib/ref_tracker.c:80:22: error: implicit declaration of function 'stack_trace_save'; did you mean 'stack_depot_save'? [-Werror=implicit-function-declaration]
> >       80 |         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> >          |                      ^~~~~~~~~~~~~~~~
> >          |                      stack_depot_save
> > >> lib/ref_tracker.c:81:22: error: implicit declaration of function 'filter_irq_stacks' [-Werror=implicit-function-declaration]
> >       81 |         nr_entries = filter_irq_stacks(entries, nr_entries);
> >          |                      ^~~~~~~~~~~~~~~~~
> >    cc1: some warnings being treated as errors
> >
> > Kconfig warnings: (for reference only)
> >    WARNING: unmet direct dependencies detected for REF_TRACKER
> >    Depends on STACKTRACE_SUPPORT
> >    Selected by
> >    - TEST_REF_TRACKER && RUNTIME_TESTING_MENU && DEBUG_KERNEL
> >
>
> This seems to be a bug unrelated to this patch series.

Ah... maybe I got the Kconfig thing wrong.

This is hard to believe we will have to duplicate " depends on
STACKTRACE_SUPPORT" for all trackers
will intend to have (I have a series for netns refcount tracking)

diff --git a/net/Kconfig b/net/Kconfig
index 0b665e60b53490f44eeda1e5506d4e125ef4c53a..b54e233b8dd38ea153ac3500df1e8a2557097ba6
100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -255,6 +255,7 @@ config PCPU_DEV_REFCNT

 config NET_DEV_REFCNT_TRACKER
        bool "Enable tracking in dev_put_track() and dev_hold_track()"
+       depends on STACKTRACE_SUPPORT
        select REF_TRACKER
        default n
        help



I thought that having the dependency centralized in REF_TRACKER would
be enough really ?

config REF_TRACKER
        bool
        depends on STACKTRACE_SUPPORT
        select STACKDEPOT
