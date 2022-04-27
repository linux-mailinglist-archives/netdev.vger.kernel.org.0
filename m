Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE315121FD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiD0TEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbiD0TE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:04:29 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B458E6C;
        Wed, 27 Apr 2022 11:51:57 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id r17so559803iln.9;
        Wed, 27 Apr 2022 11:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZQVyLoTULJU+mTJplyB+tcWAoRmLqxiLZCPm6e6tkM=;
        b=Gvt3j+8RE8qj68oBS43ShIr4ULawwsHV3btbQNT66M3iPKGhsRIeE8kVemedxjASnm
         zOMVAjOSTYKUUBrYdOGHhFv2XIesCtiDWuCktL7NatWLI37TFpJZbx5cnOZVr7QWLsRv
         T0tHgBp7vary0oChfBKOURlZTkF10n7IOJld+RkE0ntZVSWeNoMOiif4/qWIy5Late6h
         eoxezw/oQADay2L14W6z+gP1Q7BSCZEYdxbEq883GeOBcKCo17ywHUho9okcB37Zn3Ws
         eJE4BIEocg88sVOxLgba/8aZfGene5W73TM2iftE1gbtNRo1zhpzPw1AxjCbyS88yZLV
         K9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZQVyLoTULJU+mTJplyB+tcWAoRmLqxiLZCPm6e6tkM=;
        b=ii9Ghx3W+Mg07wO89YGBhG7ak1nTetfgqJjjyMCWZaAtf/bJ5LkrgenktkR2XC+jUK
         YIkZ1BSa/UfjhlvqcadjKF0bqDNexroGu2Xk7E8bm8VV0T5DWNcpixOnJb/ui/7B8Rs2
         8mXAHpADJefeoQqeBLdK4o0uUm72osAd08qHW3BLLy/s3CP6Akpga5sjZhiGPGcpBH6N
         RAFevln/kvUb2bu0sC/CrMMowL3L21o/sWlc4zEgxpKy6noFvIUk+HxhwosnWKql8cFF
         l4v/guOGSNw2qkL4vxxr46NkX5v0MTZtjKBFeqj2B7rzWj5cVDln6g+NzG3gUACBjkXX
         ECMA==
X-Gm-Message-State: AOAM531CdGu5zhX6oY1IykCN8HUqFeAJbAxaldTXUKDiIgLah4GlImYf
        8S2nW6TG6CXwVfV47sFRNUXh/sBizJbZYukF0Apcatfp
X-Google-Smtp-Source: ABdhPJwQ7uj2BAqearf4Nz8WKXGUbCgmTHrwh0dwgmM//YCMI8iz0agCwVU5VnwLbNN3fFA2nCuMtQjcLDMc23cf2uk=
X-Received: by 2002:a92:c247:0:b0:2cc:1798:74fe with SMTP id
 k7-20020a92c247000000b002cc179874femr11638719ilo.239.1651085517052; Wed, 27
 Apr 2022 11:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-3-laoar.shao@gmail.com>
 <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net> <CALOAHbAb6VH_fHAE3_tCMK0pBJCdM9PPg9pfHoye+2jq+N7DYQ@mail.gmail.com>
 <CAEf4BzbPDhYw6DL6OySyQY1CgBCp0=RUO1FSc8CGYraJx6NMCQ@mail.gmail.com>
 <CALOAHbAPZVDKXE-0fBkDMdbcTZSQZjto7sjpDnG0X_cSBCV8Pw@mail.gmail.com> <CALOAHbB079w_KrJGP8ABJyBQd1HghP4Xza1mDwaJV6bX-=SHwA@mail.gmail.com>
In-Reply-To: <CALOAHbB079w_KrJGP8ABJyBQd1HghP4Xza1mDwaJV6bX-=SHwA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 11:51:46 -0700
Message-ID: <CAEf4BzZUsjV8-rApHRoOwiDyDqv_Wbkg8qCRPkHvybNM_x--1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] libbpf: Add helpers for pinning bpf prog
 through bpf object skeleton
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 8:48 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Wed, Apr 27, 2022 at 10:45 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Wed, Apr 27, 2022 at 7:16 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 8:59 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > On Mon, Apr 25, 2022 at 9:57 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >
> > > > > On 4/23/22 4:00 PM, Yafang Shao wrote:
> > > > > > Currently there're helpers for allowing to open/load/attach BPF object
> > > > > > through BPF object skeleton. Let's also add helpers for pinning through
> > > > > > BPF object skeleton. It could simplify BPF userspace code which wants to
> > > > > > pin the progs into bpffs.
> > > > >
> > > > > Please elaborate some more on your use case/rationale for the commit message,
> > > > > do you have orchestration code that will rely on these specifically?
> > > > >
> > > >
> > > > We have a bpf manager on our production environment to maintain the
> > > > bpf programs, some of which need to be pinned in bpffs, for example
> > > > tracing bpf programs, perf_event programs and other bpf hooks added by
> > > > ourselves for performance tuning.  These bpf programs don't need a
> > > > user agent, while they really work like a kernel module, that is why
> > > > we pin them. For these kinds of bpf programs, the bpf manager can help
> > > > to simplify the development and deployment.  Take the improvement on
> > > > development for example,  the user doesn't need to write userspace
> > > > code while he focuses on the kernel side only, and then bpf manager
> > > > will do all the other things. Below is a simple example,
> > > >    Step1, gen the skeleton for the user provided bpf object file,
> > > >               $ bpftool gen skeleton  test.bpf.o > simple.skel.h
> > > >    Step2, Compile the bpf object file into a runnable binary
> > > >               #include "simple.skel.h"
> > > >
> > > >               #define SIMPLE_BPF_PIN(name, path)  \
> > > >               ({                                                              \
> > > >                   struct name##_bpf *obj;                      \
> > > >                   int err = 0;                                            \
> > > >                                                                               \
> > > >                   obj = name##_bpf__open();                \
> > > >                    if (!obj) {                                              \
> > > >                        err = -errno;                                    \
> > > >                        goto cleanup;                                 \
> > > >                     }                                                         \
> > > >                                                                               \
> > > >                     err = name##_bpf__load(obj);           \
> > > >                     if (err)                                                 \
> > > >                         goto cleanup;                                 \
> > > >                                                                                \
> > > >                      err = name##_bpf__attach(obj);       \
> > > >                      if (err)                                                \
> > > >                          goto cleanup;                                \
> > > >                                                                                \
> > > >                      err = name##_bpf__pin_prog(obj, path);      \
> > > >                      if (err)                                                \
> > > >                          goto cleanup;                                \
> > > >                                                                               \
> > > >                       goto end;                                         \
> > > >                                                                               \
> > > >                   cleanup:                                              \
> > > >                       name##_bpf__destroy(obj);            \
> > > >                   end:                                                     \
> > > >                       err;                                                  \
> > > >                    })
> > > >
> > > >                    SIMPLE_BPF_PIN(test, "/sys/fs/bpf");
> > > >
> > > >                As the userspace code of FD-based bpf objects are all
> > > > the same,  so we can abstract them as above.  The pathset means to add
> > > > the non-exist "name##_bpf__pin_prog(obj, path)" for it.
> > > >
> > >
> > > Your BPF manager is user-space code that you control, right? I'm not
> > > sure how skeleton is helpful here given your BPF manager is generic
> > > and doesn't work with any specific skeleton, if I understand the idea.
> > > But let's assume that you use skeleton to also embed BPF ELF bytes and
> > > pass them to your manager for "activation". Once you open and load
> > > bpf_object, your BPF manager can generically iterate all BPF programs
> > > using bpf_object_for_each_program(), attempt to attach them with
> > > bpf_program__attach() (see how bpf_object__attach_skeleton is handling
> > > non-auto-attachable programs) and immediately pin the link (no need to
> > > even store it, you can destroy it after pinning immediately). All this
> > > is using generic libbpf APIs and requires no code generation.
> >
> > Many thanks for the detailed explanation. Your suggestion can also
> > work, but with the skeleton we can also generate a binary which can
> > run independently.  (Technically speaking, the binary is the same as
> > './bpf_install target.bpf.o').
> >
>
> Forgot to mention that with skeleton we can also modify the global
> data defined in bpf object file, that may need to be abstracted as a
> new common helper.  The bpf_object__* functions can't do it, right ?

I must be missing something because I don't see how you can have
code-generated skeleton and generic BPF manager at the same time. I'm
not saying don't use skeleton, I'm saying you can write this link
pinning code yourself and reuse it in your applications. You can get
access to struct bpf_object through skel->obj.

>
> > >  But keep
> > > in mind that not all struct bpf_link in libbpf are pinnable (not all
> > > links have FD-based BPF link in kernel associated with them), so
> > > you'll have to deal with that somehow (and what you didn't do in this
> > > patch for libbpf implementation).
> > >
> >
> > Right, I have found it. If I understand it correctly, only the link
> > types defined in enum bpf_link_type (which is in
> > include/uapi/linux/bpf.h) are pinnable, right?
> >

It's more complicated. For kprobe/tracepoint, for example, depending
on host kernel version it could be a "fake" libbpf-side-only link, or
it could be a proper kernel object backing it. So as always, it
depends.


> > BTW, is it possible to support pinning all struct bpf_link in libbpf ?

No, it depends on kernel support, libbpf can't do much about this.

> >
> >
> > --
> > Regards
> > Yafang
>
>
>
> --
> Regards
> Yafang
