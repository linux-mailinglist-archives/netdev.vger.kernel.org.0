Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4828C4CE410
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 10:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiCEJ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 04:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCEJ6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 04:58:04 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F16859A49;
        Sat,  5 Mar 2022 01:57:15 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id j2so10342990oie.7;
        Sat, 05 Mar 2022 01:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1q/M7KC4YQOzuzU3gfyVVZfmbsjK5hZe7O6MPiN/Bk8=;
        b=McslBKcHxVzCIPHnZvFk4aQDX77ImcUv7m4m6qytWzxUmh4NfFXmVgbG7M7f9irvcj
         59l9IXu6oDj/ztL3PhYQUbKLbukAJgzNPJVgeR2AhastWLFekMl1bIZtxchVNCmE5y+z
         JzKpcsHvzzRO2reD6Y1fi0kt6SS02+YpeJdecUuJntroVh51Fs7PlITBuKB0DM6+D8D3
         03G9Z5RIB7npaQ9QxBenkb4TsXvAEFoAEMbQEEn1p0u8kQDEpPPxpFiT3A95sAJkyZKE
         XLS+fhAyOMwGt7FRsIOrYfGvxTXES+D6JK8bm4SsnNryeqDvjB2mAkcaGW38eK6bPX9H
         hA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1q/M7KC4YQOzuzU3gfyVVZfmbsjK5hZe7O6MPiN/Bk8=;
        b=Oaq0tJlbUEQXFU6Kosrmza8PAb8+/ZxktbYsKgxI2THpzdKhqMtgd/olN2gPspJswQ
         eXEeKmJOi/6P/Fo335+1cav7do1yGtqvzIrA+cm/EGVDjKG7kxYIsR9AGArV6nHEWmfr
         VbJIDAXYAj9L+1hjFaf8iysFYcmcBe+EU6OWrptGM70bVi4SP89SQnrl9e1KjKOis/p8
         i7QA3zMV3mP8nZHUUNUr2Q3SjUOUHYIHZurieIhigHAXrpxvEMID04wEoICcgtqg/xhF
         kS25XtNnL3wxK5/mShOTvv5lj49jUy+PSZF4AybhtM24qC1c78dBoO/iR+Unf3EGvkc+
         a9fA==
X-Gm-Message-State: AOAM533Pudc6CbVyG+VUpZejOMhZdcXe/eJL81cn56ZVR0cLCtImAAX3
        TbFvCqXx7f13zG8nvL61TM1/0vBs6uz0oJllFgOfqXU7iUQ=
X-Google-Smtp-Source: ABdhPJyZZFc1GhxQ1wI1wpyTpk8Z96+bZq0RBY35+3T4OroeQOC9Qf64W5yIrE3QXuEYEP9E6n6UgJD1R9mY5+oVLJ4=
X-Received: by 2002:a05:6808:bce:b0:2d9:a01a:487d with SMTP id
 o14-20020a0568080bce00b002d9a01a487dmr1836643oik.200.1646474234766; Sat, 05
 Mar 2022 01:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20220227142551.2349805-1-james.hilliard1@gmail.com>
 <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net> <CAEf4Bza84V1hwknb9XR+cNz8Sy4BK2EMYB-Oudq==pOYpqV0nw@mail.gmail.com>
In-Reply-To: <CAEf4Bza84V1hwknb9XR+cNz8Sy4BK2EMYB-Oudq==pOYpqV0nw@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Sat, 5 Mar 2022 02:57:03 -0700
Message-ID: <CADvTj4r4UKTV1RSs-1v=QZT8hehLzqHhZ3zmwugkcwYQQxrfuA@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 12:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Feb 28, 2022 at 7:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Hi James,
> >
> > On 2/27/22 3:25 PM, James Hilliard wrote:
> > > This definition seems to be missing from some older toolchains.
> > >
> > > Note that the fcntl.h in libbpf_internal.h is not a kernel header
> > > but rather a toolchain libc header.
> > >
> > > Fixes:
> > > libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first use in this function); did you mean 'FD_CLOEXEC'?
> > >     fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
> > >                    ^~~~~~~~~~~~~~~
> > >                    FD_CLOEXEC
> > >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> >
> > Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_CLOEXEC
> > was added back in 2.6.24 kernel. When did libc add it?
>
> It seems like it's guarded by __USE_XOPEN2K8 in glibc (from a quick
> glance at glibc code). But it's been there since 2010 or so, at the
> very least.

The toolchain that hit this issue appears to be uclibc based which seems to have
had some bugs with the F_DUPFD_CLOEXEC definition.

>
> >
> > Should we instead just add an include for <linux/fcntl.h> to libbpf_internal.h
> > (given it defines F_DUPFD_CLOEXEC as well)?
>
> yep, this is UAPI header so we can use it easily (we'll need to sync
> it into Github repo, but that's not a problem)
>
>
> >
> > > ---
> > >   tools/lib/bpf/libbpf_internal.h | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > > index 4fda8bdf0a0d..d2a86b5a457a 100644
> > > --- a/tools/lib/bpf/libbpf_internal.h
> > > +++ b/tools/lib/bpf/libbpf_internal.h
> > > @@ -31,6 +31,10 @@
> > >   #define EM_BPF 247
> > >   #endif
> > >
> > > +#ifndef F_DUPFD_CLOEXEC
> > > +#define F_DUPFD_CLOEXEC 1030
> > > +#endif
> > > +
> > >   #ifndef R_BPF_64_64
> > >   #define R_BPF_64_64 1
> > >   #endif
> > >
> >
> > Thanks,
> > Daniel
