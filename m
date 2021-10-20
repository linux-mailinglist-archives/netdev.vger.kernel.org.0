Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B41435606
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJTWqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTWqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:46:09 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A86C06161C;
        Wed, 20 Oct 2021 15:43:54 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id o17so1797528ybq.4;
        Wed, 20 Oct 2021 15:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwaMC/6ruMO+LGss1WmS4jX8l4+xtzOGvPJHIdwrEaU=;
        b=H2AeoXeV5SSCuplp0XfkE/DyBhs84q1u+iRlll8wCrqwtZRUqRqZ21W8BVmriXo9Li
         lNN/FQ0SLMhRa2IZKQujdhy9rCkhhg64Sr0th9GL8oyjvdKTu6cs/PTrnq2TUrYgr8qT
         pso0MJOLobPaiqjGOtJ3z1t/eVi6l7wixG+qC/mC6TCK6pS+Uq8LESiEaFY7CfMNMV3I
         FIDGEawc5rsMzekP2Lfu92Q+b6aMyg2vEqzLXVBvxnZy9LBO6SsN3jzZRD/NBPHvikus
         TV2ZL+XpPczX58zTWs7Hb1kk+DXDUXB05ST8Dgog2i83+1UyTtxAriFfRRfm+Y3ICPHF
         tong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwaMC/6ruMO+LGss1WmS4jX8l4+xtzOGvPJHIdwrEaU=;
        b=k67WNjvYXpSJI0rLT73GY689vz+/62Q1DB6wmCoV7WCAhhENQWWOdJexLjnRARKpfs
         ZA2RBfxIcc5yDF5dGrNMbahW5KEQICGnaW47CJhNrc4zOUKOUrgVOlcOeavU70ncNd02
         0pE0L+E9XqDSqgxAsF/AUS6C7KafxV53+vzrpfBJW681MPElzv2Mp48ZsVgr04MHVduu
         4O5x/uln94efKwwmL7JiI650hXyE8+gaj030Sf7BSfaun4HTstR/bQomQAomhufHX8Y6
         fIepwz5EptvgsdzeB1a/caUdSMn7gZkh9+zSbtAsc8NwLP9KNd2twijkGJXhEaZM/qlw
         Wr/Q==
X-Gm-Message-State: AOAM533vG8J+Li9La/a/OlZaLIvRY9/R8pbt46CloGsUZP6Hmi1QKB8k
        P8hGt5Md4DsOf2g9gSlM+rc5XqEB5mn3cAOWdpc=
X-Google-Smtp-Source: ABdhPJwaCTPVnO+AoYeTsuLHoXg6FFLpUKpsKCyOOtgjMuOTyRonetzACHYoP0OYXeVYMjLGZaF9WKitZtpIlKgLX5w=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr2083341ybj.504.1634769833554;
 Wed, 20 Oct 2021 15:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211020191526.2306852-1-memxor@gmail.com> <20211020191526.2306852-7-memxor@gmail.com>
 <CAEf4BzajqpFv-pwt7vZ3+Ob8y7RnqcCMVRvWhF1Nfr_J-NFZ0A@mail.gmail.com> <20211020223738.r6coueqsymyt3422@apollo.localdomain>
In-Reply-To: <20211020223738.r6coueqsymyt3422@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 15:43:42 -0700
Message-ID: <CAEf4BzYUdHjqyu=gagGOhiAbdJ-BnKgesVajoWMoFWeF8Da6wA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 3:37 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, Oct 21, 2021 at 03:47:19AM IST, Andrii Nakryiko wrote:
> > On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> > > Include both light and libbpf skeleton in same file to test both of them
> > > together.
> > >
> > > In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
> > > I added support for generating both lskel and libbpf skel for a BPF
> > > object, however the name parameter for bpftool caused collisions when
> > > included in same file together. This meant that every test needed a
> > > separate file for a libbpf/light skeleton separation instead of
> > > subtests.
> > >
> > > Change that by appending a "_light" suffix to the name for files listed
> > > in LSKELS_EXTRA, such that both light and libbpf skeleton can be used in
> > > the same file for subtests, leading to better code sharing.
> > >
> > > While at it, improve the build output by saying GEN-LSKEL instead of
> > > GEN-SKEL for light skeleton generation recipe.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  7 ++--
> > >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
> > >  .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
> > >  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
> > >  .../selftests/bpf/progs/test_ksyms_weak.c     |  3 +-
> > >  5 files changed, 74 insertions(+), 39 deletions(-)
> > >  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 498222543c37..1c3c8befc249 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -325,7 +325,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
> > >  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> > >         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
> > >  # Generate both light skeleton and libbpf skeleton for these
> > > -LSKELS_EXTRA := test_ksyms_module.c
> > > +LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
> > >  SKEL_BLACKLIST += $$(LSKELS)
> > >
> > >  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> > > @@ -399,12 +399,13 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > >         $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
> > >
> > >  $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > > -       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> > > +       $$(call msg,GEN-LSKEL,$(TRUNNER_BINARY),$$@)
> >
> > This breaks nice output alignment:
> >
> >   GEN-SKEL [test_progs-no_alu32] bpf_iter_tcp4.skel.h
> >   GEN-LSKEL [test_progs-no_alu32] trace_vprintk.lskel.h
> >
>
> Ok, I'll drop it.
>
> > Isn't ".lskel.h" suffix enough to distinguish them?
> >
> > >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
> > >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
> > >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
> > >         $(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
> > > -       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
> > > +       $$(eval LSKEL_NAME := $$(notdir $$(<:.o=$$(if $$(filter $$(notdir $$(<:.o=.c)),$(LSKELS_EXTRA)),_light,))))
> >
> > eval inside eval?.. Wow, do we really need that? If you just want to
>
> I knew you'd like it ;-)

yeah, big fan, obviously :)

>
> > add _light (I suggest _lskel though, it will make for a more
> > meaningful and recognizable names in user-space code) suffix, do it
> > for all light skeletons unconditionally and keep it simple?
> >
>
> I avoided this because it would be a lot of unecessary changes, while we only
> need this for two files. Every struct/function name will get the suffix, but I
> can do it if the Makefile stuff looks too horrible.

There are 10 light skeleton-using selftests, it's not a problem to do
one-time renaming. Currently there are only two files that do both
skel and lskel, but that number will inevitably grow, so better to set
everything up now.

>
> > > +       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(LSKEL_NAME) > $$@
> > >
> > >  $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > >         $$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
> >
> > [...]
>
> --
> Kartikeya
