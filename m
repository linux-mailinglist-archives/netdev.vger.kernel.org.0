Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E53510C80
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356022AbiDZXTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243349AbiDZXTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:19:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E6D1D0CC;
        Tue, 26 Apr 2022 16:16:08 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z18so212667iob.5;
        Tue, 26 Apr 2022 16:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yppsyc05oe1m8mpf+O+Co+hByQ7uVVUk3HQJEr3W0ns=;
        b=oydaeg4hh/OSZIJD/jYMdmxNVPUQK2SY0q4Ypv7GyzG6ZlY0cbtQ2bBDV/iB5KUzoe
         RdEFkj2+c4Xs741cDjA18qoeQp/RMfyW1/vZQ17X4P47HZX6UmDLA/dIcFc810cBWfG2
         j90gzVdYtJCvjxqR5c1HK0ZO8FfXvB1GiIZ+ruo52nGcMUmkhkj4XhHJkz7c8f/arP/y
         UVPL4PovVxNlxvJxIoXneoB6n8u7pc8twnzFYOi6FiSAmGSs3y5FdJqoVswqGxzBPNLy
         tiba+co3hUBPsdPD55a9lliTG/sYvXa5u4sjn9QHFcJqS2y7382/4q3dD6l9jgoGGk64
         MjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yppsyc05oe1m8mpf+O+Co+hByQ7uVVUk3HQJEr3W0ns=;
        b=yjahZcHnOTLpzTtmCheNdKkdGIeqpExrptW7uTem6uShEvN7nqzd9Um+5GubzjnL5O
         eOYd4RzZ4GUFFumNg/0utN2mtyQ7RZM9/Au72N4QLgdEyx6GLQql6ZH0Gbt2z0QFcSKl
         rq5ZE7AvUnq/e2zFdZA+MZdh3+ubFVC1eI5PIrwegPzcUp6zdJ19XcvirbjisYjTVY1t
         5dWdzvYxjMWVNII5U7CcIFDVcESM6re3PfjzikCy/20rNhOZZgagbq6l2AAXMZSg5uy6
         mZqMjmfQjJPdYh8dcg6PPTkJkNu8J0CIaLGwalePTYLO8fkJFSc2YrIlfJt5rIiNLAbE
         cODQ==
X-Gm-Message-State: AOAM533knFysZ5Uft/ZIsHkPgIuj8/Pu7bM1UwyIbXenZTDNiXY4rsic
        cz48HyF+AedCvhPn1pDPZmjnD3IaQJfgeivfrKFDwujFqjA=
X-Google-Smtp-Source: ABdhPJzb6ML/RzXauOOjkITWOR1Uu8JJ/HKW7WdlxIRnOsKKxB7FDAWpBzJ8RGTUNjQTlE2+DBaliYryt0rdNTjJL+I=
X-Received: by 2002:a5d:9316:0:b0:657:a364:ceb with SMTP id
 l22-20020a5d9316000000b00657a3640cebmr2253628ion.63.1651014968258; Tue, 26
 Apr 2022 16:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-3-laoar.shao@gmail.com>
 <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net> <CALOAHbAb6VH_fHAE3_tCMK0pBJCdM9PPg9pfHoye+2jq+N7DYQ@mail.gmail.com>
In-Reply-To: <CALOAHbAb6VH_fHAE3_tCMK0pBJCdM9PPg9pfHoye+2jq+N7DYQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Apr 2022 16:15:57 -0700
Message-ID: <CAEf4BzbPDhYw6DL6OySyQY1CgBCp0=RUO1FSc8CGYraJx6NMCQ@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 8:59 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Mon, Apr 25, 2022 at 9:57 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 4/23/22 4:00 PM, Yafang Shao wrote:
> > > Currently there're helpers for allowing to open/load/attach BPF object
> > > through BPF object skeleton. Let's also add helpers for pinning through
> > > BPF object skeleton. It could simplify BPF userspace code which wants to
> > > pin the progs into bpffs.
> >
> > Please elaborate some more on your use case/rationale for the commit message,
> > do you have orchestration code that will rely on these specifically?
> >
>
> We have a bpf manager on our production environment to maintain the
> bpf programs, some of which need to be pinned in bpffs, for example
> tracing bpf programs, perf_event programs and other bpf hooks added by
> ourselves for performance tuning.  These bpf programs don't need a
> user agent, while they really work like a kernel module, that is why
> we pin them. For these kinds of bpf programs, the bpf manager can help
> to simplify the development and deployment.  Take the improvement on
> development for example,  the user doesn't need to write userspace
> code while he focuses on the kernel side only, and then bpf manager
> will do all the other things. Below is a simple example,
>    Step1, gen the skeleton for the user provided bpf object file,
>               $ bpftool gen skeleton  test.bpf.o > simple.skel.h
>    Step2, Compile the bpf object file into a runnable binary
>               #include "simple.skel.h"
>
>               #define SIMPLE_BPF_PIN(name, path)  \
>               ({                                                              \
>                   struct name##_bpf *obj;                      \
>                   int err = 0;                                            \
>                                                                               \
>                   obj = name##_bpf__open();                \
>                    if (!obj) {                                              \
>                        err = -errno;                                    \
>                        goto cleanup;                                 \
>                     }                                                         \
>                                                                               \
>                     err = name##_bpf__load(obj);           \
>                     if (err)                                                 \
>                         goto cleanup;                                 \
>                                                                                \
>                      err = name##_bpf__attach(obj);       \
>                      if (err)                                                \
>                          goto cleanup;                                \
>                                                                                \
>                      err = name##_bpf__pin_prog(obj, path);      \
>                      if (err)                                                \
>                          goto cleanup;                                \
>                                                                               \
>                       goto end;                                         \
>                                                                               \
>                   cleanup:                                              \
>                       name##_bpf__destroy(obj);            \
>                   end:                                                     \
>                       err;                                                  \
>                    })
>
>                    SIMPLE_BPF_PIN(test, "/sys/fs/bpf");
>
>                As the userspace code of FD-based bpf objects are all
> the same,  so we can abstract them as above.  The pathset means to add
> the non-exist "name##_bpf__pin_prog(obj, path)" for it.
>

Your BPF manager is user-space code that you control, right? I'm not
sure how skeleton is helpful here given your BPF manager is generic
and doesn't work with any specific skeleton, if I understand the idea.
But let's assume that you use skeleton to also embed BPF ELF bytes and
pass them to your manager for "activation". Once you open and load
bpf_object, your BPF manager can generically iterate all BPF programs
using bpf_object_for_each_program(), attempt to attach them with
bpf_program__attach() (see how bpf_object__attach_skeleton is handling
non-auto-attachable programs) and immediately pin the link (no need to
even store it, you can destroy it after pinning immediately). All this
is using generic libbpf APIs and requires no code generation. But keep
in mind that not all struct bpf_link in libbpf are pinnable (not all
links have FD-based BPF link in kernel associated with them), so
you'll have to deal with that somehow (and what you didn't do in this
patch for libbpf implementation).

> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >   tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++++
> > >   tools/lib/bpf/libbpf.h   |  4 +++
> > >   tools/lib/bpf/libbpf.map |  2 ++
> > >   3 files changed, 65 insertions(+)
> > >

[...]
