Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC71923CA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgCYJM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:12:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36149 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCYJM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:12:56 -0400
Received: by mail-ot1-f67.google.com with SMTP id l23so1264498otf.3;
        Wed, 25 Mar 2020 02:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gz93DcG7Dz2tFD+p9ycJ3JCHnMtIcY7SzR3oKARZebY=;
        b=W8eQ9jgYBxTqYOA99RvjSZSj8z7HIKo24AeBXrL0BmmL9ukEF23b+HOmBs/4miPf+V
         qLR3Z1q0vjLv+pRo9rEvTPFi+z8h7uIOCWlZCZFmR8zbitECypBAR6EsCvI5fhRuchO1
         9JYkmrSOXwHZSD7TCPNNvKJKBXCi29R6Bkagw+wLHnjQeDnYhdIZlnqTMib49G2+QVhY
         VLPAxeT5we99FonE9zoN5qfeaSi3kRQ+jdwWC4qc7le6Aq0dbpC7ETvim7hH1yTizkUM
         bg9QnSGRqV8WcQ3roj+nbigs9EpcagpxOkVeChqP+fPEl7cG3jmrXzbcVDEapVRkuIwV
         dfkg==
X-Gm-Message-State: ANhLgQ046ubfCWd7RbP39gICGgBDJQc2L1XOSGmFShcpMZieUBBg4zIE
        8jqSK3uh9Ca+qkwlgOuzKZvpciIFUDlIfNEG61A=
X-Google-Smtp-Source: ADFU+vvQhHUfMDl51KjMOop/re3P3z/uwXKVl6Pn2is5x/6Hk6ukY0mwXIYDd716VvToctFXK+bVAnjHkHoT8uUYi+M=
X-Received: by 2002:a9d:5c0c:: with SMTP id o12mr1727378otk.145.1585127575893;
 Wed, 25 Mar 2020 02:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
 <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com>
 <CAMuHMdXeOUu_zxKHXnNoLwyExy1GTp6N5UP2Neqyc8M3w2B8KQ@mail.gmail.com> <CAK7LNAST-ygeLAAneKRhr-uMdSW0V_V1s9AvN6VJSqfWfN4Otg@mail.gmail.com>
In-Reply-To: <CAK7LNAST-ygeLAAneKRhr-uMdSW0V_V1s9AvN6VJSqfWfN4Otg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 25 Mar 2020 10:12:45 +0100
Message-ID: <CAMuHMdUMhPg2Du9_EowsKL9b8fpz8ymc_8E2VLybWs7mpN2DDg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for
 rebuilding firmware
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yamada-san,

On Wed, Mar 25, 2020 at 10:06 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> On Wed, Mar 25, 2020 at 4:53 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Mar 25, 2020 at 4:50 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > On Wed, Mar 25, 2020 at 2:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Tue, Mar 24, 2020 at 5:17 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > > > As far as I understood from the Kconfig help text, this build rule is
> > > > > used to rebuild the driver firmware, which runs on the QUICC, m68k-based
> > > > > Motorola 68360.
> > > > >
> > > > > The firmware source, wanxlfw.S, is currently compiled by the combo of
> > > > > $(CPP) and $(AS68K). This is not what we usually do for compiling *.S
> > > > > files. In fact, this is the only user of $(AS) in the kernel build.
> > > > >
> > > > > Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
> > > > > PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
> > > > > Instead of combining $(CPP) and (AS) from different tool sets, using
> > > > > single $(CC68K) seems simpler, and saner.
> > > > >
> > > > > After this commit, the firmware rebuild will require cc68k instead of
> > > > > as68k. I do not know how many people care about this, though.
> > > > >
> > > > > I do not have cc68k/ld68k in hand, but I was able to build it by using
> > > > > the kernel.org m68k toolchain. [1]
> > > >
> > > > Would this work with a "standard" m68k-linux-gnu-gcc toolchain, like
> > > > provided by Debian/Ubuntu, too?
> > > >
> > >
> > > Yes, I did 'sudo apt install gcc-8-m68k-linux-gnu'
> > > It successfully compiled this firmware.
> >
> > Thanks for checking!
> >
> > > In my understanding, the difference is that
> > > the kernel.org ones lack libc,
> > > so cannot link userspace programs.
> > >
> > > They do not make much difference for this case.
> >
> > Indeed.
> >
> > So perhaps it makes sense to replace cc68k and ld68k in the Makefile by
> > m68k-linux-gnu-gcc and m68k-linux-gnu-ld, as these are easier to get hold
> > of on a modern system?
>
> If desired, I can do like this:
>
> ifeq ($(ARCH),m68k)
>   CC_M68K = $(CC)
>   LD_M68K = $(LD)
> else
>   CC_M68K = $(CROSS_COMPILE_M68K)gcc
>   LD_M68K = $(CROSS_COMPILE_M68K)ld
> endif

Thanks, that looks good to me.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
