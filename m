Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADE241F759
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354634AbhJAWSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhJAWSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:18:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E06C061775;
        Fri,  1 Oct 2021 15:16:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so4473911pjb.1;
        Fri, 01 Oct 2021 15:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZUjXMKqzHuZRdrUzbnb+ys8Fk09V5Vk6dMticep6Ig=;
        b=q7HDAbrErw9Yw3r3ycAv1kgF1w0cpuYYIzvYcIInJ8WiLiK21iOvp00dVelsmtjqt7
         7lre2abSE1Gy39G/wcjDBg60ymgFxpdy0t6Nm5DCg5+UX6Y4bEotJwLjkimRfuFiUbMq
         zD0ip+t9fwBtFRSCpbm2Bz/R/vCCoFzBWiYkO01osKBQKBhIcWxQ4LoqiNaGp8oZ85zT
         s3BIO1e+AfYuqm/m9Lb/gnLwnyXw+NPKmi1HwFAE7Eoil+VuG0TFK/SlU01CKI7rapOO
         dityWPemvEb23brBmKKUKMnAAvOKAfDTim6EdgSszurOsf2OMh4J2Am7TbnsHoqdTi/P
         m0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZUjXMKqzHuZRdrUzbnb+ys8Fk09V5Vk6dMticep6Ig=;
        b=ghFS3FrwQvnKaVJgVVwLeRZ/P7feWVH7Z0UM61w1D+S37e4cMpbw/UrXbs9XzNk64y
         LAXRMaJqGkgmXgwggIpIaxTeXL6A3LNr7h8XyO8D4NLu7HQAL3UapykbBWjico0WlvLc
         psbIpCiWWTHsm606be1wEC7CtqKXZqwMlN+jSIOp1Em4gNj01zngnloh6j9YvCyS1gNB
         yW9TB+9MpqNtWz4lVp+bs3szUnjpAm3zpgfKcUEY6PK107OhOW1uDBzijamhTaIQG4W0
         yho2vY4gGCsU6SJjhdzJ2tlBl+wQIX9It5KT0EilZ7+wgj/3bQL5Bgi6JLslI+fX5sdI
         1Q0w==
X-Gm-Message-State: AOAM531xW8W1hTAuWD/ZrS8hpcOgRTXA5T5BtD7YdGYm1nDRkssTMWxN
        EAWstBjQFq2Ggq+Ops+XXz0=
X-Google-Smtp-Source: ABdhPJwcGfXSzgro0v4OG6OMw+Pc88LQ2qWqUYg8CQELvCykShjyK9JzJC2CAC4vRI/4OFYkzcH+TA==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr22867599pjq.26.1633126617829;
        Fri, 01 Oct 2021 15:16:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id u24sm7716929pfm.27.2021.10.01.15.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 15:16:57 -0700 (PDT)
Date:   Sat, 2 Oct 2021 03:46:55 +0530
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
Subject: Re: [PATCH bpf-next v6 9/9] bpf: selftests: Add selftests for module
 kfunc support
Message-ID: <20211001221655.4sqtw5vbbdilsttx@apollo.localdomain>
References: <20210930062948.1843919-1-memxor@gmail.com>
 <20210930062948.1843919-10-memxor@gmail.com>
 <CAEf4BzYXFU+o-AKj_JP3_2VzAYHRtkyzO5Wu0BD7W=n9UHxe6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYXFU+o-AKj_JP3_2VzAYHRtkyzO5Wu0BD7W=n9UHxe6w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 02, 2021 at 03:43:05AM IST, Andrii Nakryiko wrote:
> On Wed, Sep 29, 2021 at 11:30 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This adds selftests that tests the success and failure path for modules
> > kfuncs (in presence of invalid kfunc calls) for both libbpf and
> > gen_loader. It also adds a prog_test kfunc_btf_id_list so that we can
> > add module BTF ID set from bpf_testmod.
> >
> > This also introduces  a couple of test cases to verifier selftests for
> > validating whether we get an error or not depending on if invalid kfunc
> > call remains after elimination of unreachable instructions.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/btf.h                           |  2 +
> >  kernel/bpf/btf.c                              |  2 +
> >  net/bpf/test_run.c                            |  5 +-
> >  tools/testing/selftests/bpf/Makefile          |  8 ++--
> >  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 +++++++++-
> >  .../selftests/bpf/prog_tests/ksyms_module.c   | 29 ++++++------
> >  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 +++++++++++
> >  .../selftests/bpf/progs/test_ksyms_module.c   | 46 ++++++++++++++-----
> >  tools/testing/selftests/bpf/verifier/calls.c  | 23 ++++++++++
> >  9 files changed, 135 insertions(+), 31 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
> >
>
> [...]
>
> > @@ -243,7 +244,9 @@ BTF_SET_END(test_sk_kfunc_ids)
> >
> >  bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
> >  {
> > -       return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
> > +       if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
> > +               return true;
> > +       return __bpf_prog_test_check_kfunc_call(kfunc_id, owner);
> >  }
> >
> >  static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index e1ce73be7a5b..df461699932d 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
> >         $(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
> >         $(Q)$(MAKE) $(submake_extras) -C bpf_testmod
> >         $(Q)cp bpf_testmod/bpf_testmod.ko $@
> > +       $(Q)$(RESOLVE_BTFIDS) -b $(VMLINUX_BTF) bpf_testmod.ko
>
> This should be done by kernel Makefiles, which are used to build
> bpf_testmod.ko. If this is not happening, something is wrong and let's
> try to figure out what.
>
> >
> >  $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
> >         $(call msg,CC,,$@)
> > @@ -315,8 +316,9 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
> >                 linked_vars.skel.h linked_maps.skel.h
> >
> >  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> > -       test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
> > -       trace_vprintk.c
> > +       test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
> > +# Generate both light skeleton and libbpf skeleton for these
> > +LSKELS_EXTRA := test_ksyms_module.c
> >  SKEL_BLACKLIST += $$(LSKELS)
> >
>
> [...]
>
> > +#define X_0(x)
> > +#define X_1(x) x X_0(x)
> > +#define X_2(x) x X_1(x)
> > +#define X_3(x) x X_2(x)
> > +#define X_4(x) x X_3(x)
> > +#define X_5(x) x X_4(x)
> > +#define X_6(x) x X_5(x)
> > +#define X_7(x) x X_6(x)
> > +#define X_8(x) x X_7(x)
> > +#define X_9(x) x X_8(x)
> > +#define X_10(x) x X_9(x)
> > +#define REPEAT_256(Y) X_2(X_10(X_10(Y))) X_5(X_10(Y)) X_6(Y)
>
> this is impressive, I can even sort of read it :)
>
> > +
> >  extern const int bpf_testmod_ksym_percpu __ksym;
> > +extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
> > +extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
> >
> > -int out_mod_ksym_global = 0;
> > -bool triggered = false;
> > +int out_bpf_testmod_ksym = 0;
> > +const volatile int x = 0;
> >
> > -SEC("raw_tp/sys_enter")
> > -int handler(const void *ctx)
> > +SEC("tc")
>
> Did you switch to tc because kfuncs are not allowed from raw_tp
> programs? Or is there some other reason?
>

Yeah, I was only adding .check_kfunc_call to it because of the tests, I figured
I'd just use a tc prog since other kfunc tests also use that, and because
there's no other user of kfuncs for raw_tp yet.

> > +int load(struct __sk_buff *skb)
> >  {
> > -       int *val;
> > -       __u32 cpu;
> > -
> > -       val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> > -       out_mod_ksym_global = *val;
> > -       triggered = true;
> > +       /* This will be kept by clang, but removed by verifier. Since it is
> > +        * marked as __weak, libbpf and gen_loader don't error out if BTF ID
> > +        * is not found for it, instead imm and off is set to 0 for it.
> > +        */
> > +       if (x)
> > +               bpf_testmod_invalid_mod_kfunc();
> > +       bpf_testmod_test_mod_kfunc(42);
> > +       out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> > +       return 0;
> > +}
> >
>
> [...]

--
Kartikeya
