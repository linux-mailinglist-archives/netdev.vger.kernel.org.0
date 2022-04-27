Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800DA511EAF
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbiD0Pvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiD0Pvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:51:36 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3115953E12;
        Wed, 27 Apr 2022 08:48:22 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id f2so3432957ioh.7;
        Wed, 27 Apr 2022 08:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCsHvkWCR/wWly8ths3Wi4fTVqRYBvVSb9UFDlCgn5U=;
        b=Nhjlc0YGIjhDK9zT0+Mx9ZKF8lDQ1wUzAEjDDirrSwbTWMk85UryV3pvH7mi5209ws
         Zs7hqOw3AUQjcXL3y94/VIXHWtoM9kl4dWdtNB0vHf4k0K9T+RVpXYoVqxWu38nK716d
         nodHyaU1nxGJ1D1udEv9gKpzS4FJqRgxlFik6L7s21PcK7D8Va26sHF+yoIPe4QBMaAp
         yupDqtqHYcgII6IZ4FO1d02u0v1gCfsganKrKSNMOCIpHNQyJXcjj0kXZQeoP9o74y0y
         YKuSEWm5/1J2AfuWMNpQ4boARvKG0BfQwQKMFdzEqEH5KfiEBvn1bpRXtFJ8GPFn/z09
         USjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCsHvkWCR/wWly8ths3Wi4fTVqRYBvVSb9UFDlCgn5U=;
        b=10Y+6SG/NYruARzVB7y5nLFu/NrHX1HUZNcAlu9TPgM2yN1aOXc9XPeX2z2BX9giok
         2xKcCKJgUxmhUo3xGDxHO9CbJ4bTrmx+KxZKnTMPA+fiaLZcU9nGONygK66+VoFKAg8w
         cDrSh70s5QKb1jpnZ3KeFygKG+xWm3d1uA/9+JFNRaayRHJmzxUXIVl927+w7QpV46Cc
         49tUWCfxMogiU8UmW3NGhDy0kzxVqGwlLe3FdLjIYX0g/pIvaZopVTCDdFtJW+dpRaEH
         fVDhH+YzvEUa5Fc3ObPiL8olsquKx8M0UUdGwYMlTFD53GvJqlKfKNCJPqgj7jqpduIt
         2U1Q==
X-Gm-Message-State: AOAM530URd7NFGTy0Os2bZ6Yl4jzaVX7MgFsEB5I+/BeKJScRwYztPkh
        3qmrkpZf9CFtuOPRf5/npKZLMbnXH0eQ6NgntmI=
X-Google-Smtp-Source: ABdhPJzMQXTFudrU0X7e4SN93y82D4MVOxKjJfbsDsG093qJOs5uhCb9nmXshXPaFcPKPRfiLF+lnQhYqSe/TLV5yD8=
X-Received: by 2002:a05:6638:2652:b0:323:bbe3:550b with SMTP id
 n18-20020a056638265200b00323bbe3550bmr5569113jat.6.1651074501582; Wed, 27 Apr
 2022 08:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-3-laoar.shao@gmail.com>
 <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net> <CALOAHbAb6VH_fHAE3_tCMK0pBJCdM9PPg9pfHoye+2jq+N7DYQ@mail.gmail.com>
 <CAEf4BzbPDhYw6DL6OySyQY1CgBCp0=RUO1FSc8CGYraJx6NMCQ@mail.gmail.com> <CALOAHbAPZVDKXE-0fBkDMdbcTZSQZjto7sjpDnG0X_cSBCV8Pw@mail.gmail.com>
In-Reply-To: <CALOAHbAPZVDKXE-0fBkDMdbcTZSQZjto7sjpDnG0X_cSBCV8Pw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 27 Apr 2022 23:47:43 +0800
Message-ID: <CALOAHbB079w_KrJGP8ABJyBQd1HghP4Xza1mDwaJV6bX-=SHwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] libbpf: Add helpers for pinning bpf prog
 through bpf object skeleton
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Apr 27, 2022 at 10:45 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Wed, Apr 27, 2022 at 7:16 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Apr 26, 2022 at 8:59 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > On Mon, Apr 25, 2022 at 9:57 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On 4/23/22 4:00 PM, Yafang Shao wrote:
> > > > > Currently there're helpers for allowing to open/load/attach BPF object
> > > > > through BPF object skeleton. Let's also add helpers for pinning through
> > > > > BPF object skeleton. It could simplify BPF userspace code which wants to
> > > > > pin the progs into bpffs.
> > > >
> > > > Please elaborate some more on your use case/rationale for the commit message,
> > > > do you have orchestration code that will rely on these specifically?
> > > >
> > >
> > > We have a bpf manager on our production environment to maintain the
> > > bpf programs, some of which need to be pinned in bpffs, for example
> > > tracing bpf programs, perf_event programs and other bpf hooks added by
> > > ourselves for performance tuning.  These bpf programs don't need a
> > > user agent, while they really work like a kernel module, that is why
> > > we pin them. For these kinds of bpf programs, the bpf manager can help
> > > to simplify the development and deployment.  Take the improvement on
> > > development for example,  the user doesn't need to write userspace
> > > code while he focuses on the kernel side only, and then bpf manager
> > > will do all the other things. Below is a simple example,
> > >    Step1, gen the skeleton for the user provided bpf object file,
> > >               $ bpftool gen skeleton  test.bpf.o > simple.skel.h
> > >    Step2, Compile the bpf object file into a runnable binary
> > >               #include "simple.skel.h"
> > >
> > >               #define SIMPLE_BPF_PIN(name, path)  \
> > >               ({                                                              \
> > >                   struct name##_bpf *obj;                      \
> > >                   int err = 0;                                            \
> > >                                                                               \
> > >                   obj = name##_bpf__open();                \
> > >                    if (!obj) {                                              \
> > >                        err = -errno;                                    \
> > >                        goto cleanup;                                 \
> > >                     }                                                         \
> > >                                                                               \
> > >                     err = name##_bpf__load(obj);           \
> > >                     if (err)                                                 \
> > >                         goto cleanup;                                 \
> > >                                                                                \
> > >                      err = name##_bpf__attach(obj);       \
> > >                      if (err)                                                \
> > >                          goto cleanup;                                \
> > >                                                                                \
> > >                      err = name##_bpf__pin_prog(obj, path);      \
> > >                      if (err)                                                \
> > >                          goto cleanup;                                \
> > >                                                                               \
> > >                       goto end;                                         \
> > >                                                                               \
> > >                   cleanup:                                              \
> > >                       name##_bpf__destroy(obj);            \
> > >                   end:                                                     \
> > >                       err;                                                  \
> > >                    })
> > >
> > >                    SIMPLE_BPF_PIN(test, "/sys/fs/bpf");
> > >
> > >                As the userspace code of FD-based bpf objects are all
> > > the same,  so we can abstract them as above.  The pathset means to add
> > > the non-exist "name##_bpf__pin_prog(obj, path)" for it.
> > >
> >
> > Your BPF manager is user-space code that you control, right? I'm not
> > sure how skeleton is helpful here given your BPF manager is generic
> > and doesn't work with any specific skeleton, if I understand the idea.
> > But let's assume that you use skeleton to also embed BPF ELF bytes and
> > pass them to your manager for "activation". Once you open and load
> > bpf_object, your BPF manager can generically iterate all BPF programs
> > using bpf_object_for_each_program(), attempt to attach them with
> > bpf_program__attach() (see how bpf_object__attach_skeleton is handling
> > non-auto-attachable programs) and immediately pin the link (no need to
> > even store it, you can destroy it after pinning immediately). All this
> > is using generic libbpf APIs and requires no code generation.
>
> Many thanks for the detailed explanation. Your suggestion can also
> work, but with the skeleton we can also generate a binary which can
> run independently.  (Technically speaking, the binary is the same as
> './bpf_install target.bpf.o').
>

Forgot to mention that with skeleton we can also modify the global
data defined in bpf object file, that may need to be abstracted as a
new common helper.  The bpf_object__* functions can't do it, right ?

> >  But keep
> > in mind that not all struct bpf_link in libbpf are pinnable (not all
> > links have FD-based BPF link in kernel associated with them), so
> > you'll have to deal with that somehow (and what you didn't do in this
> > patch for libbpf implementation).
> >
>
> Right, I have found it. If I understand it correctly, only the link
> types defined in enum bpf_link_type (which is in
> include/uapi/linux/bpf.h) are pinnable, right?
>
> BTW, is it possible to support pinning all struct bpf_link in libbpf ?
>
>
> --
> Regards
> Yafang



-- 
Regards
Yafang
