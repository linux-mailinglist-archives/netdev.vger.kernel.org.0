Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9D44672B0
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350881AbhLCHlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 02:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350852AbhLCHlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 02:41:20 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6963C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 23:37:56 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id v19-20020a4a2453000000b002bb88bfb594so1508219oov.4
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 23:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zMWGmGY4+8W9Z4xeHe+E4bygT9LxpnGhYn3E+9Xi0s=;
        b=QryXv6DIGIapmaBc6WnQtLYuq3ucxcwp/SjvUtRN2ME5ZZzhA9hVCP70rJbbGsW9nf
         7cNMVNdM6nmPSWysVqLSD+E676NAohvDLLsT+B0WsNyg1OoAmz9lU2MchXa5ageXjXAv
         eUg5mA6djJjfvef2KMpiGSKRt5aWLXaSDfyQOs0uz4FBsu5J29+M3sVwVnwr4z3eL0n6
         3E5TslheSzXPXwhD9EC7wjPIVnIawvpsf2/xA8zYWhKLo7p3wkQfSgxKF7pNomJjAciu
         lEeOeFgMspecTyH05LXwaUxjLKB02Q+/7+eUzfHtuXmznRTbLY+ic00exoDoq6/dM6/A
         ES+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zMWGmGY4+8W9Z4xeHe+E4bygT9LxpnGhYn3E+9Xi0s=;
        b=T1XiBrE00/Xkp4VaHHzAdMgyOKh8XVofX+drkCV7nJSR3r/MK6KJTnFxGQ7g/6lJzc
         mXuYu/4ptO7LgpUIe+JV5+0VkWijIz+aqKtzbIWXdFEfZfgWM2xiD6PjBwUMZZ8B+ntx
         UcNjGUANrtdQyYypPQ7tf2PPhRBQ2Zhv32woILYxIm/zR+i16/wFsMGXDSVFoE4yGca0
         YcCwsT7JPFDfmgMYNIM9pjyBHhVCBDufTHP30yrQXVR62rR4xHxfgxV/PM4TpuUVxfSg
         rgd6oL5RDdAcVBWm7W4UOqTlxebCc8CU76fv4OKZSjGRuEi0f+tWCSpDYoewesNnV02N
         H+fA==
X-Gm-Message-State: AOAM5327qgci2jotbtD2/BBZLGWdfCziz+VGw7efqhlYWQLm9RlEZO90
        L0v8xFRLkJc5xRpCgouKTK6D7JUZ0OkgfvNIuQeLeQ==
X-Google-Smtp-Source: ABdhPJzDlQxkkAjxoMps/gl9jDxYkF0VP7injFBiCmJlLi/jkbejZDq/buuqqSHSjYQEtLlIb7Ty+y2aTBnaTMeCYXs=
X-Received: by 2002:a05:6830:1356:: with SMTP id r22mr14977516otq.196.1638517075994;
 Thu, 02 Dec 2021 23:37:55 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-3-eric.dumazet@gmail.com>
 <202112030323.z9IhC2B3-lkp@intel.com> <CANn89iLi6Dh3_hhDO8u9xJ+nA4eSEgpyv3sMVz3A8bcbp-6-TA@mail.gmail.com>
In-Reply-To: <CANn89iLi6Dh3_hhDO8u9xJ+nA4eSEgpyv3sMVz3A8bcbp-6-TA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 3 Dec 2021 08:37:45 +0100
Message-ID: <CACT4Y+Y8upXSt7j4MT8jfj_s2kVKCEN0nyJmb0PQ=teiUqGVQg@mail.gmail.com>
Subject: Re: [PATCH net-next 02/19] lib: add tests for reference tracker
To:     Eric Dumazet <edumazet@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 at 20:46, Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Dec 2, 2021 at 11:25 AM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Eric,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on net-next/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8057cbb8335cf6d419866737504473833e1d128a
> > config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20211203/202112030323.z9IhC2B3-lkp@intel.com/config)
> > compiler: nios2-linux-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/5da0cdb1848fae9fb2d9d749bb94e568e2493df8
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
> >         git checkout 5da0cdb1848fae9fb2d9d749bb94e568e2493df8
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    nios2-linux-ld: kernel/stacktrace.o: in function `stack_trace_save':
> > >> (.text+0x2e4): undefined reference to `save_stack_trace'
> >    (.text+0x2e4): relocation truncated to fit: R_NIOS2_CALL26 against `save_stack_trace'
> >
> > Kconfig warnings: (for reference only)
> >    WARNING: unmet direct dependencies detected for STACKTRACE
> >    Depends on STACKTRACE_SUPPORT
> >    Selected by
> >    - STACKDEPOT
> >
>
> I am not sure I understand this.
>
> Dmitry, do I need to add a depends on STACKTRACE_SUPPORT.

Humm... There is something strange about nios2 arch.

KASAN depends on ARCH_HAVE_KASAN which is not selected for nios2, so
it implicitly avoids this issue.

But I see PAGE_OWNER that also uses STACKDEPOT has "Depends on
STACKTRACE_SUPPORT".
So I guess yes.

I am not sure how Kconfig will reach if we make STACKDEPOT depend on
STACKTRACE_SUPPORT  and your config  says "select STACKDEPOT"...
