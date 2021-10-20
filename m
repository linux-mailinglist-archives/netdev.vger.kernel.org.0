Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9004355F3
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhJTWkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTWkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:40:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64648C06161C;
        Wed, 20 Oct 2021 15:37:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t7so9360286pgl.9;
        Wed, 20 Oct 2021 15:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OJwF+uE6eDXMfBv3UBSE2lXZPkrfIf9IzSMZ3IaQ/c8=;
        b=JWml0sXNiOOoWVosCFV8sPCw8z362TG9wmEfxP8pkJSZvBpaCwLRXlay3E3gTcS1tq
         7Re+5I0BeW1FU4MdCPEAwMrLcMdVNPIemgX79QEz9Z31TWfnOFe4CgX6rnJ0NuOxFc4T
         45huU6Is6W/MrgDhbgV0YuTdUps++/AZYsj9Xkb4oN3J1W51jxiaGD4YZ5OU0yGLMKWS
         jLo7Elp89HoNNazekwmIooPDudjfkATRbl+JQYfOL4THbOhHfFiSq7lZBZMTjQNBOxCL
         QengOz1auTcQIBJaGULN0JcJCGEki99EH5NL8XxgsYRnD1FGS8r3MLA8IZ9vPdkwV4dn
         iEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OJwF+uE6eDXMfBv3UBSE2lXZPkrfIf9IzSMZ3IaQ/c8=;
        b=b/72VOBp2VKYpPSfNIhx8k2W/M17MIx6TqBSjJ3c/3cvuUo+ReoJyTnUdUbz8NI3R2
         WGDzvxgcqaEXbUUXrHZd9KpPmags8g8EhlB9U8EwIxSS3TIOaI86MaR92I8y18DRiTaM
         G1atQ7AemnjDX8npYZtKxMdOkdNtlRZS7df0Vd9nU4PN88F2c9zEXQhO69tiJQK0aXHe
         q6GmeVgyCYQsoypRvXUB59wlGt/rSer0WNUewdiduJGvaZGvb77LyFQ0U2IeKQ3lpJBT
         YROR4IHYTXzQgyUCdAFSDYHxed6ksLHQXwYZ/LHgDvXDUn8/YLXd+xPDdlzGg9nyhjE1
         nnoQ==
X-Gm-Message-State: AOAM533yl3FcXeeVpprF902LyuSbyrrNUjUnr1/jXWLEK1urbSdASKF3
        pYKuT1zDg5t6FSt9xsrJROs=
X-Google-Smtp-Source: ABdhPJz4Mh37KFov3KQdQeltAggYNCYy+ztxukywJF9skiZAhtgvHF6op0+Wc0lqYzU1q6igbdEPNQ==
X-Received: by 2002:a05:6a00:21c6:b0:44c:937:fbf3 with SMTP id t6-20020a056a0021c600b0044c0937fbf3mr2075921pfj.2.1634769461399;
        Wed, 20 Oct 2021 15:37:41 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id t1sm3431974pfe.51.2021.10.20.15.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 15:37:41 -0700 (PDT)
Date:   Thu, 21 Oct 2021 04:07:38 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
Message-ID: <20211020223738.r6coueqsymyt3422@apollo.localdomain>
References: <20211020191526.2306852-1-memxor@gmail.com>
 <20211020191526.2306852-7-memxor@gmail.com>
 <CAEf4BzajqpFv-pwt7vZ3+Ob8y7RnqcCMVRvWhF1Nfr_J-NFZ0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzajqpFv-pwt7vZ3+Ob8y7RnqcCMVRvWhF1Nfr_J-NFZ0A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 03:47:19AM IST, Andrii Nakryiko wrote:
> On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> > Include both light and libbpf skeleton in same file to test both of them
> > together.
> >
> > In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
> > I added support for generating both lskel and libbpf skel for a BPF
> > object, however the name parameter for bpftool caused collisions when
> > included in same file together. This meant that every test needed a
> > separate file for a libbpf/light skeleton separation instead of
> > subtests.
> >
> > Change that by appending a "_light" suffix to the name for files listed
> > in LSKELS_EXTRA, such that both light and libbpf skeleton can be used in
> > the same file for subtests, leading to better code sharing.
> >
> > While at it, improve the build output by saying GEN-LSKEL instead of
> > GEN-SKEL for light skeleton generation recipe.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  7 ++--
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
> >  .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
> >  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
> >  .../selftests/bpf/progs/test_ksyms_weak.c     |  3 +-
> >  5 files changed, 74 insertions(+), 39 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 498222543c37..1c3c8befc249 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -325,7 +325,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
> >  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> >         test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
> >  # Generate both light skeleton and libbpf skeleton for these
> > -LSKELS_EXTRA := test_ksyms_module.c
> > +LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
> >  SKEL_BLACKLIST += $$(LSKELS)
> >
> >  test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> > @@ -399,12 +399,13 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> >         $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
> >
> >  $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > -       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> > +       $$(call msg,GEN-LSKEL,$(TRUNNER_BINARY),$$@)
>
> This breaks nice output alignment:
>
>   GEN-SKEL [test_progs-no_alu32] bpf_iter_tcp4.skel.h
>   GEN-LSKEL [test_progs-no_alu32] trace_vprintk.lskel.h
>

Ok, I'll drop it.

> Isn't ".lskel.h" suffix enough to distinguish them?
>
> >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
> >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
> >         $(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
> >         $(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
> > -       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
> > +       $$(eval LSKEL_NAME := $$(notdir $$(<:.o=$$(if $$(filter $$(notdir $$(<:.o=.c)),$(LSKELS_EXTRA)),_light,))))
>
> eval inside eval?.. Wow, do we really need that? If you just want to

I knew you'd like it ;-)

> add _light (I suggest _lskel though, it will make for a more
> meaningful and recognizable names in user-space code) suffix, do it
> for all light skeletons unconditionally and keep it simple?
>

I avoided this because it would be a lot of unecessary changes, while we only
need this for two files. Every struct/function name will get the suffix, but I
can do it if the Makefile stuff looks too horrible.

> > +       $(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(LSKEL_NAME) > $$@
> >
> >  $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
> >         $$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
>
> [...]

--
Kartikeya
