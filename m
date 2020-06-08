Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77951F1A2B
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgFHNd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:33:58 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:62913 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFHNdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:33:54 -0400
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 058DXVKM023535;
        Mon, 8 Jun 2020 22:33:32 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 058DXVKM023535
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1591623212;
        bh=b+o3Hm4QtvCz1v/3Sh/JT6aGk4myx3VOofcrTavBqrk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CMJmkSl2WOimRx+lm6tfZz98ISZpMBRK0DbB5JCpCVvU6x7EGNBAK1BchsuKfx8eT
         smP18vaF0LLUaOLJWxy8PgD84wFJAeAuA6gRY5Xyrp6d9kZaXk5aFoiu2+9U+tjMFc
         gB4p9g751gJnRy3a2uMKdbZo0C5JbCb8mko8oObEUQQtWrg68xZjKQFZP9UXm/h75J
         zjjcUYdkWc5Tf9L9SVQpPL4JhbYTF7+il7fKYIjML4ZkHGKaeCPI0FqQ8bqHElBinZ
         hJR8KbojN5pNJxMzxmRBGMPyku/g/jDYEgyRcM2ENCGx4kOVBPdrUK8dUjMEG4N8qJ
         IykKAoNeJEqqQ==
X-Nifty-SrcIP: [209.85.217.54]
Received: by mail-vs1-f54.google.com with SMTP id k13so9773510vsm.13;
        Mon, 08 Jun 2020 06:33:32 -0700 (PDT)
X-Gm-Message-State: AOAM530nV0EcxYr2hWUDiPQvoMJ00z92eeC4LnCxOx3Cpk5RVOI9wB5N
        Z7wjvFHlgx810FBhKENF/x7pML8lNdby5qSXpzE=
X-Google-Smtp-Source: ABdhPJyfBMyc0+YCkYixUd2p+AN/T03Qhj7+s3JZLuqn4kS0/Z0lvBdDfypzJhoi2h2pGnaS8dEXskpx9ISJNDks+sQ=
X-Received: by 2002:a67:2d42:: with SMTP id t63mr15019160vst.181.1591623211449;
 Mon, 08 Jun 2020 06:33:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200423073929.127521-1-masahiroy@kernel.org> <20200423073929.127521-5-masahiroy@kernel.org>
 <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
In-Reply-To: <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 8 Jun 2020 22:32:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQkVA05G9f68PTyyChno2OEOq_gsmjGwML7PerZvwOuSA@mail.gmail.com>
Message-ID: <CAK7LNAQkVA05G9f68PTyyChno2OEOq_gsmjGwML7PerZvwOuSA@mail.gmail.com>
Subject: Re: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build bpfilter_umh
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 8:56 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Thu, Apr 23, 2020 at 04:39:17PM +0900, Masahiro Yamada wrote:
> > The user mode helper should be compiled for the same architecture as
> > the kernel.
> >
> > This Makefile reuses the 'hostprogs' syntax by overriding HOSTCC with CC.
> >
> > Now that Kbuild provides the syntax 'userprogs', use it to fix the
> > Makefile mess.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > Reported-by: kbuild test robot <lkp@intel.com>
> > ---
> >
> >  net/bpfilter/Makefile | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> > index 36580301da70..6ee650c6badb 100644
> > --- a/net/bpfilter/Makefile
> > +++ b/net/bpfilter/Makefile
> > @@ -3,17 +3,14 @@
> >  # Makefile for the Linux BPFILTER layer.
> >  #
> >
> > -hostprogs := bpfilter_umh
> > +userprogs := bpfilter_umh
> >  bpfilter_umh-objs := main.o
> > -KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> > -HOSTCC := $(CC)
> > +user-ccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> >
> > -ifeq ($(CONFIG_BPFILTER_UMH), y)
> > -# builtin bpfilter_umh should be compiled with -static
> > +# builtin bpfilter_umh should be linked with -static
> >  # since rootfs isn't mounted at the time of __init
> >  # function is called and do_execv won't find elf interpreter
> > -KBUILD_HOSTLDFLAGS += -static
> > -endif
> > +bpfilter_umh-ldflags += -static
> >
> >  $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
>
> Hello,
>
> I just noticed that this patch (now in mainline as commit 8a2cc0505cc4)
> drops the test if CONFIG_BPFILTER_UMH is "y" so that -static is now
> passed to the linker even if bpfilter_umh is built as a module which
> wasn't the case in v5.7.
>
> This is not mentioned in the commit message and the comment still says
> "*builtin* bpfilter_umh should be linked with -static" so this change
> doesn't seem to be intentional. Did I miss something?
>
> Michal Kubecek


Sorry. ifeq was accidentally dropped.
I will restore it.

-- 
Best Regards
Masahiro Yamada
