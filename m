Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9352844E001
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhKLBzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhKLBzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:55:41 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB5BC061766;
        Thu, 11 Nov 2021 17:52:51 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v138so19739038ybb.8;
        Thu, 11 Nov 2021 17:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDSeHLLhGxHcPHudA96pLrr0NfbznFOxkpI1rPKILTQ=;
        b=XW81GIb1hqQ5nUIXfj1zIBSjA8c69MNZDfikCsPHVaCp+ZJB79qxCQrfDGf58tSvaN
         0lGuia8zrywt7JrQXCTRligK++ZVZr8ukBZGOKdZrjwi6FV8moHfegRjRiPNTyF0y4aC
         MKli97srOJ2xLs+zPS9LMmyZ/LvG0J5wNAtJrgx6Hsk8JSvDwqu4g8zGfNbPJ/Z6Fk0L
         5b/Y6miWMKWJA5CW5kMZruAT/d1DtV+rGCo8QAsTB1t0tLwkRaUoZc5iP1dbBDSYKfAl
         ivGJ3NgAbpufpk4Rm5srfaFx1u0uRkZEx8A2izBM4C2oJ6OyuRld1ExqEOd4VJW5qZRw
         WOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDSeHLLhGxHcPHudA96pLrr0NfbznFOxkpI1rPKILTQ=;
        b=IxyUfGG5Kz9Cqa9BDqTtvJktI095DfxZSKil9+0k8T3b+YObvJBhY39hKz0AZTocIC
         iTzBapTsePKirqsZV4kYuHRSyxPb4a3nfyeSmQx719a9UDPJF8xkwCQUQjODGzy+38VT
         prPgBfUZYsOf7IaESWAwFHXm6E3GbWwNm45gF7cn8L7LIP+doLIpB30Cz3xSgqb7Xnsr
         I09XyKMBfF7B/VNjju7bTTtJnRPikuazZFRM3i5FBuE59eDlIxRT/3FoQrS/yEUyrhuZ
         8gVd0PllOWjXhRsUw63czGp2Q7nz9aomdkQx0zM+JW5ryfOvtXJUMvb/L1w2GuGa2cLg
         pS8Q==
X-Gm-Message-State: AOAM532mKQZ+Ikz6voyT0bZt5RVquV4radjoBlrAkHqsqdNx8m7SdmQ0
        mtTSeH2tnM8ggywhJ1I6hxkE7rQ3vq0cAA8oF2ODA9rm
X-Google-Smtp-Source: ABdhPJzBaFDGUVWleBoMii66fQHpVAt7TCraUWlglPC4SFkXmwhrtmqbZZA3KFhlf4BgE23CoRTwwYiDJT4PpVW/uas=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr11784805ybj.433.1636681970725;
 Thu, 11 Nov 2021 17:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20211110114632.24537-1-quentin@isovalent.com> <20211110114632.24537-4-quentin@isovalent.com>
 <CAEf4BzbtC8S_j7oZP9vqK+FwoSvBmt8Hp4_ZyzbwUifg8JfUUA@mail.gmail.com> <CACdoK4JnbpU6ijcNr5n6HMj+yOb=OhEwO3DUQOgNYRvoe+EgfQ@mail.gmail.com>
In-Reply-To: <CACdoK4JnbpU6ijcNr5n6HMj+yOb=OhEwO3DUQOgNYRvoe+EgfQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Nov 2021 17:52:39 -0800
Message-ID: <CAEf4Bzbp=4Nj1btO7=SmeOw09wWwtrAcf_6wk-3KV8YBLOuOOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpftool: Use $(OUTPUT) and not $(O) for
 VMLINUX_BTF_PATHS in Makefile
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 3:39 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Thu, 11 Nov 2021 at 18:59, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Nov 10, 2021 at 3:46 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > The Makefile for bpftool relies on $(OUTPUT), and not on $(O), for
> > > passing the output directory. So $(VMLINUX_BTF_PATHS), used for
> > > searching for kernel BTF info, should use the same variable.
> > >
> > > Fixes: 05aca6da3b5a ("tools/bpftool: Generalize BPF skeleton support and generate vmlinux.h")
> > > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > > ---
> > >  tools/bpf/bpftool/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > > index 2a846cb92120..40abf50b59d4 100644
> > > --- a/tools/bpf/bpftool/Makefile
> > > +++ b/tools/bpf/bpftool/Makefile
> > > @@ -150,7 +150,7 @@ $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
> > >  OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
> > >  $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
> > >
> > > -VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
> > > +VMLINUX_BTF_PATHS ?= $(if $(OUTPUT),$(OUTPUT)/vmlinux)                 \
> > >                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
> >
> > But you still check KBUILD_OUTPUT? O overrides KBUILD_OUTPUT as far as
> > kernel build goes. So if you still support KBUILD_OUTPUT, you should
> > support O. And the $(OUTPUT) seems to be completely unrelated, as that
> > defines the output of bpftool build files, not the vmlinux image. Or
> > am I missing something?
>
> OK, I think I'm the one who missed the point. I simply figured we
> meant to search the output directory, and that it should be $(OUTPUT)
> like everywhere else in the Makefile. But from what I understand now,
> it's not the case. Let's drop this patch.
>
> If the rest of the set looks good to you, can you just skip this
> patch, or do you prefer me to send a v2?
>

I can just drop it when applying.

> Quentin
