Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C5466A99
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbhLBTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhLBTts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 14:49:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839D3C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 11:46:25 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id f9so2587711ybq.10
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 11:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SDZLKXnzOEdeJG8V9HgCvcfDjwGbShjjCQ8MCbphcsI=;
        b=pXTLRtZx2LzbjO0zAhK5z/GBd5bimySbFsnQXestIwvBaHmaWg5C+/Be6MR9g2t4d0
         46yQCx1GBi129CF5c/tpmF5cwCl5wjQ5Ss7laMz0ekTPXc4FJ7LIBPvqnqwlFOBIU5Vo
         nVySzYTcHT4NVHpAhIFoiF0haD9aU6/CUp8wNgWx47ZwYL+grHR73KRosACFT0u2Q6Yc
         2/e7zr/tWqfGSXBooeXnQVxS+WmsASuoVV1a+ZLVJXoOfD7shaAY+ZwBa9ODACMRQHGF
         TfMTiBfOkm4IrCUl3k4+W94XWZmzKZvx2lCCds7CxQBQFdfDfiYB+HjY7CrUZAv50tj1
         Tvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SDZLKXnzOEdeJG8V9HgCvcfDjwGbShjjCQ8MCbphcsI=;
        b=PCto3VxtNJwTAwuJ03UGjciClJiDo3p8GaDrPOUQDEZZv6rSAllPhLy3dZu76M1Qei
         TYP/1ec334MDtXUDlyMHuQmRZP1M1NOR1dw4rZ/njikr6WbhXirb+7Ec99rhPTcydok5
         TzmdLiZ8N1Pk7ce0L8YOONIGVBw/e3yRNS1U0fWaVS0Ynudrnue6UmxOxV7TP1OZjY4T
         +V9K3VApP8SphjGr2r+PmxUbq8pJQQSDUtGZi8/Ba5/2R5iQjua0NJ7YvE++0M4Z02sR
         ViRdB1VqcEJfsfaBGFO9aF4jA9gIeH2VfYy/L1UFXK92lyma8xy6J3QZABk3T3DCqTsA
         rfTQ==
X-Gm-Message-State: AOAM532Jv1ekLabIUGy8WDJ8tf9SJ8Y1V8jOFdoMMzheS44hm9m5qQws
        yRF+G/Xio2H2GYK8zVVlquFmdwhJbd3wQbs6mHtEzw==
X-Google-Smtp-Source: ABdhPJwNuahf4HXN0L/Rzzs0IjA1Gw+nU8VNR6uVUcRNULTkbPHjNwDGucoJlEkwycXnDEqpbeghp6Y5Kkr2EYZAFBs=
X-Received: by 2002:a25:3252:: with SMTP id y79mr16952312yby.5.1638474384344;
 Thu, 02 Dec 2021 11:46:24 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-3-eric.dumazet@gmail.com> <202112030323.z9IhC2B3-lkp@intel.com>
In-Reply-To: <202112030323.z9IhC2B3-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 11:46:13 -0800
Message-ID: <CANn89iLi6Dh3_hhDO8u9xJ+nA4eSEgpyv3sMVz3A8bcbp-6-TA@mail.gmail.com>
Subject: Re: [PATCH net-next 02/19] lib: add tests for reference tracker
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

On Thu, Dec 2, 2021 at 11:25 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8057cbb8335cf6d419866737504473833e1d128a
> config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20211203/202112030323.z9IhC2B3-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/5da0cdb1848fae9fb2d9d749bb94e568e2493df8
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
>         git checkout 5da0cdb1848fae9fb2d9d749bb94e568e2493df8
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    nios2-linux-ld: kernel/stacktrace.o: in function `stack_trace_save':
> >> (.text+0x2e4): undefined reference to `save_stack_trace'
>    (.text+0x2e4): relocation truncated to fit: R_NIOS2_CALL26 against `save_stack_trace'
>
> Kconfig warnings: (for reference only)
>    WARNING: unmet direct dependencies detected for STACKTRACE
>    Depends on STACKTRACE_SUPPORT
>    Selected by
>    - STACKDEPOT
>

I am not sure I understand this.

Dmitry, do I need to add a depends on STACKTRACE_SUPPORT.

Thanks !
