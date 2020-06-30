Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2F20F9BB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388098AbgF3QrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgF3QrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:47:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD14C061755;
        Tue, 30 Jun 2020 09:47:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so3216489pjb.2;
        Tue, 30 Jun 2020 09:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YjTGvZoFn9Gr5f+ufVSqWbKLtKiqYnTgMSui3Jl24dg=;
        b=AbhmhW0FcojEGsKBYgxR7fSDLdEmZIHxD1D6PsAJ6ezhxe6haZFOGdqcwtTOYqYnu8
         csrp77Uvqm6t4IumS+BuU61yWOx70HoJ41gDFDYF8E+Zmw0AAoyfuQhgU/t+mqkKZsIC
         vVhikQmUhVtik11wConsSXBOGyvUYPNOP/lzTbpybyPyry4tdraGAavYhELPywTAotso
         bAuWqD0/PD0M7VqkuCWpV0b6jIHGoC8ycoC/G88LPswm8vS5xGaKsp6YW6Fv4PTcmLBe
         WgbbqA+Jb55/agSHibk0rBoYDaCC4wiEvlOCFxzERjIl3GcYz/WxmmMIO3ieSKgJnCvp
         Nx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjTGvZoFn9Gr5f+ufVSqWbKLtKiqYnTgMSui3Jl24dg=;
        b=VYDyI/iOlySC8nb/Ebs0kCsCO3BI/4HOruzI/dB2IOQShqLeFJFimXHTMVNzYByP8a
         OjzbWOPaDVXdSAnEa+kM4BJ7fRtN1QoW3kFEYxX/iXOHB6H0nYuwVvgmkdgeSzq/0WaP
         ErhzFCSAfk6yYoMKeEKpVu57Z6HrPC7J3l8lE3rcUINKRGFSCPPk1urA2glYI1mbCeOW
         iX0h4dsfw9D5W+SM6AcLle3mp0wHrr4rw4a+Iov2l6IAUTakldGotMBKJaka+KfanRyV
         gtUiNNS0A/5emmkAzMSrLa5m9uqzZCbCiTO5457vmTz/NcClBHDNSHTU5HVdW6cgnKgq
         zziQ==
X-Gm-Message-State: AOAM530RbEKR99D6xLB4HG2uvO+ZwwsbgrD8cTmNoSyn8pI7+unO7cYy
        Y29lsKTFN3MBH8POF0UCjmY=
X-Google-Smtp-Source: ABdhPJzjpHaWFt/qmhE5T9q47jzJ9TE9edAwd+c9ayFlVVVk4E53qs0ThsG+1c9hkzQ01gj2/NvXeg==
X-Received: by 2002:a17:90a:cc18:: with SMTP id b24mr23349815pju.89.1593535632810;
        Tue, 30 Jun 2020 09:47:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e083])
        by smtp.gmail.com with ESMTPSA id c188sm3203756pfc.143.2020.06.30.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 09:47:11 -0700 (PDT)
Date:   Tue, 30 Jun 2020 09:47:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build
 bpfilter_umh
Message-ID: <20200630164708.aeuoq4ruhivu5o2d@ast-mbp.dhcp.thefacebook.com>
References: <20200423073929.127521-1-masahiroy@kernel.org>
 <20200423073929.127521-5-masahiroy@kernel.org>
 <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
 <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 03:30:04PM +0900, Masahiro Yamada wrote:
> Hi Michal, Alexei,
> 
> On Mon, Jun 8, 2020 at 8:56 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > On Thu, Apr 23, 2020 at 04:39:17PM +0900, Masahiro Yamada wrote:
> > > The user mode helper should be compiled for the same architecture as
> > > the kernel.
> > >
> > > This Makefile reuses the 'hostprogs' syntax by overriding HOSTCC with CC.
> > >
> > > Now that Kbuild provides the syntax 'userprogs', use it to fix the
> > > Makefile mess.
> > >
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > ---
> > >
> > >  net/bpfilter/Makefile | 11 ++++-------
> > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> > > index 36580301da70..6ee650c6badb 100644
> > > --- a/net/bpfilter/Makefile
> > > +++ b/net/bpfilter/Makefile
> > > @@ -3,17 +3,14 @@
> > >  # Makefile for the Linux BPFILTER layer.
> > >  #
> > >
> > > -hostprogs := bpfilter_umh
> > > +userprogs := bpfilter_umh
> > >  bpfilter_umh-objs := main.o
> > > -KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> > > -HOSTCC := $(CC)
> > > +user-ccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> > >
> > > -ifeq ($(CONFIG_BPFILTER_UMH), y)
> > > -# builtin bpfilter_umh should be compiled with -static
> > > +# builtin bpfilter_umh should be linked with -static
> > >  # since rootfs isn't mounted at the time of __init
> > >  # function is called and do_execv won't find elf interpreter
> > > -KBUILD_HOSTLDFLAGS += -static
> > > -endif
> > > +bpfilter_umh-ldflags += -static
> > >
> > >  $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
> >
> > Hello,
> >
> > I just noticed that this patch (now in mainline as commit 8a2cc0505cc4)
> > drops the test if CONFIG_BPFILTER_UMH is "y" so that -static is now
> > passed to the linker even if bpfilter_umh is built as a module which
> > wasn't the case in v5.7.
> >
> > This is not mentioned in the commit message and the comment still says
> > "*builtin* bpfilter_umh should be linked with -static" so this change
> > doesn't seem to be intentional. Did I miss something?
> >
> > Michal Kubecek
> 
> I was away for a while from this because I saw long discussion in
> "net/bpfilter: Remove this broken and apparently unmaintained"
> 
> 
> Please let me resume this topic now.
> 
> 
> The original behavior of linking umh was like this:
>   - If CONFIG_BPFILTER_UMH=y, bpfilter_umh was linked with -static
>   - If CONFIG_BPFILTER_UMH=m, bpfilter_umh was linked without -static

That was done to make sure both static and dynamic linking work.
For production -static is necessary.
For debugging of usermode blob dynamic is beneficial.

> Restoring the original behavior will add more complexity because
> now we have CONFIG_CC_CAN_LINK and CONFIG_CC_CAN_LINK_STATIC
> since commit b1183b6dca3e0d5
> 
> If CONFIG_BPFILTER_UMH=y, we need to check CONFIG_CC_CAN_LINK_STATIC.
> If CONFIG_BPFILTER_UMH=m, we need to check CONFIG_CC_CAN_LINK.
> This would make the Kconfig dependency logic too complicated.

Currently I'm working on adding bpf_iter to use 'user mode driver'
(old user mode blob) facility on top of Eric's patches.
So there will be quite a bit more complexity to build system.
Folks who don't want to deal with -static requirement should
just disable the feature.

> To make it simpler, I'd like to suggest two options.
> 
> 
> 
> Idea 1:
> 
>   Always use -static irrespective of whether
>   CONFIG_BPFILTER_UMH is y or m.

I don't think it's making it much simpler.
It's a tiny change to makefile.
I could be missing something.
Requiring -static for =y and =m is fine.

>   Add two more lines to clarify this
>   in the comment in net/bpfilter/Makefile:
> 
>   # builtin bpfilter_umh should be linked with -static
>   # since rootfs isn't mounted at the time of __init
>   # function is called and do_execv won't find elf interpreter.
>   # Static linking is not required when bpfilter is modular, but
>   # we always pass -static to keep the 'depends on' in Kconfig simple.
> 
> 
> 
> Idea 2:
> 
>    Allow umh to become only modular,
>    and drop -static flag entirely.

absolutely not.
Both =y and =m are mandatory.

> 
>    If you look at net/bpfilter/Kconfig,
>    BPFILTER_UMH already has 'default m'.
>    So, I assume the most expected use-case
>    is modular.

The default for BPFILTER is =N.
Distros should NOT be turning that to =y

Same thing with upcoming bpf_iter. It will default to =n.
