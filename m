Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ADF4479F6
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 06:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbhKHF1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 00:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhKHF1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 00:27:44 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D016FC061570
        for <netdev@vger.kernel.org>; Sun,  7 Nov 2021 21:25:00 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 188so1776719pgb.7
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 21:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zv8A5SdJdFnXGFUujP5eLzOnIQkuB6UXQ/3icX2J9M=;
        b=W48T89SQeAMDIT+9eFU0Irc+FkSsJ03P98ZCAaqEG2ZD3jw7+9kYN/yPvoP5PrGelL
         GQ99cWd35oyJnbUG7RmK72WU6YIr2jyEL+AXTcOipvcPbyXW/QDESMerwinccWWAogT1
         tbnbCM6ALrZ1Y1SkrTffVtGt3CVIdCwdZzkGIyl/aBS6FIB7uP8dsmeC3wGEGYml1yvf
         KLoeGz9GZs/RwkFtOo3COpJ44sCAZmIdrpYCIIM2zCZ0XVbsJCHSjuEVFt6jT0Iukp+P
         OV71o22S2wXHXRIS3zXYIyQRa7Cx5OJ//BCrQCNnsFZT56WM4y73otFz8D2P6MHYutvp
         DbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zv8A5SdJdFnXGFUujP5eLzOnIQkuB6UXQ/3icX2J9M=;
        b=gMahxZZ+vg3YIVFZg+FE7dHU4xCT7NMlXwPtgxhj0kvnHeFu8GLOwpsq/g6f47EbZ0
         TNlaFvhFW0cCfuNbIFC8GLK/kiGN0YHhRmhZ4CQvkL5jdEbdGgd57BxZW2/PibUH3nc3
         XO7C21AW7TdmD9FBJ4dxHuJEkEtimvY8bBBAgtv3gRIRk5f9tJdwWMVTTMe92956WN3u
         7PaF3jS4/ES+dg6Gjgk6HT1Q3OSwmmo++fcAUvd4HdennqDlQuajmU3QdYtzte/h5DUk
         e2FASzOonwKhgNfV0y3FQ67G/17pz3XOZ91fZFsZU9AAVAynaofEX1W4Jw7xtkI1B/5L
         UJPg==
X-Gm-Message-State: AOAM5301lP+y+FVowL190bcG7cxtVScD4UV6MyJN/0PNvSYjSNd+BLET
        0B51qEFnZ/Hd9v1mLPKilBM3jBD2Y0sn4EhMCyo=
X-Google-Smtp-Source: ABdhPJw6ONl0eMrSe2/tM4DtM02aWPZ5jqjo4xYJAhuQk5rld2a7TabI0DhhEHsPESgr3PssCfZ1nlFSIfWtYXaIbzk=
X-Received: by 2002:a65:550e:: with SMTP id f14mr42064367pgr.164.1636349100038;
 Sun, 07 Nov 2021 21:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20211020083854.1101670-1-atenart@kernel.org> <20211022130146.3dacef0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022130146.3dacef0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Mon, 8 Nov 2021 00:24:33 -0500
Message-ID: <CAPFHKzduJiebgnAAjEvx4vBJCFn7-eyfJ+k6JQja2waxqKeCwQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sysctl data could be in .bss
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        tglx@linutronix.de, peterz@infradead.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 4:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Widening the CC list a little.
>
> On Wed, 20 Oct 2021 10:38:54 +0200 Antoine Tenart wrote:
> > A check is made when registering non-init netns sysctl files to ensure
> > their data pointer does not point to a global data section. This works
> > well for modules as the check is made against the whole module address
> > space (is_module_address). But when built-in, the check is made against
> > the .data section. However global variables initialized to 0 can be in
> > .bss (-fzero-initialized-in-bss).
> >
> > Add an extra check to make sure the sysctl data does not point to the
> > .bss section either.
> >
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > Reviewed-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> > ---
> > Hello,
> >
> > This was previously sent as an RFC[1] waiting for a problematic sysctl
> > to be fixed. The fix was accepted and is now in the nf tree[2].
> >
> > This is not sent as a fix to avoid possible new warnings in stable
> > kernels. (The actual fixes of sysctl files should go).
> >
> > I think this can go through the net-next tree as kernel/extable.c
> > doesn't seem to be under any subsystem and a conflict is unlikely to
> > happen.
>
> > [1] https://lore.kernel.org/all/20211012155542.827631-1-atenart@kernel.org/T/
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=174c376278949c44aad89c514a6b5db6cee8db59
> >
> >  include/linux/kernel.h | 1 +
> >  kernel/extable.c       | 8 ++++++++
> >  net/sysctl_net.c       | 2 +-
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 2776423a587e..beb61d0ab220 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -231,6 +231,7 @@ extern char *next_arg(char *args, char **param, char **val);
> >  extern int core_kernel_text(unsigned long addr);
> >  extern int init_kernel_text(unsigned long addr);
> >  extern int core_kernel_data(unsigned long addr);
> > +extern int core_kernel_bss(unsigned long addr);
>
> Is the intention of these helpers to have strict section name semantics
> or higher level "is this global kernel data" semantics? If it's the
> latter we could make core_kernel_data() check bss instead, chances are
> all callers will either want that or not care. Steven?

The core_kernel_data() function was introduced in a2d063ac216c1, and
the commit message says:

"It may or may not return true for RO data... This utility function is
used to determine if data is safe from ever being freed. Thus it
should return true for all RW global data that is not in a module or
has been allocated, or false otherwise."

The intent of the function seems to be more in line with the
higher-level "is this global kernel data" semantics you suggested. The
purpose seems to be to differentiate between "part of the loaded
kernel image" vs. a dynamic allocation (which would include a loaded
module image). And given that it *might* return true for RO data
(depending on the arch linker script, presumably), I think it would be
safe to include .bss -- clearly, with that caveat in place, it isn't
promising strict section semantics.

There are only two existing in-tree consumers:

1. __register_ftrace_function() [kernel/trace/ftrace.c] -- Sets
FTRACE_OPS_FL_DYNAMIC if core_kernel_data(ops) returns false, which
denotes "dynamically allocated ftrace_ops which need special care". It
would be unlikely (if not impossible) for the "ops" object in question
to be all-zero and end up in the .bss, but if it were, then the
current behavior would be wrong. IOW, it would be more correct to
include .bss.

2. ensure_safe_net_sysctl() [net/sysctl_net.c] (The subject of this
thread) -- Trying to distinguish "global kernel data" (static/global
variables) from kmalloc-allocated objects. More correct to include
.bss.

Both of these callers only seem to delineate between static and
dynamic object allocations. Put another way, if core_kernel_bss(), all
existing callers should be updated to check core_kernel_data() ||
core_kernel_bss().

Since Steven introduced it, and until I added
ensure_safe_net_sysctl(), he / tracing was the only consumer.

Thinking critically from the C language perspective, I can't come up
with any case where one would actually expect core_kernel_data() to
return true for 'int global = 1' and false for 'int global = 0'.

In conclusion, I agree with your alternative proposal Jakub, and I
think this patch is the right way forward:

diff --git a/kernel/extable.c b/kernel/extable.c
index b0ea5eb0c3b4..8b6f1d0bdaf6 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -97,6 +97,9 @@ int core_kernel_data(unsigned long addr)
        if (addr >= (unsigned long)_sdata &&
            addr < (unsigned long)_edata)
                return 1;
+       if (addr >= (unsigned long)__bss_start &&
+           addr < (unsigned long)__bss_stop)
+               return 1;
        return 0;
 }

Jonathon Reinhart
