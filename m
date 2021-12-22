Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCAF47D9EF
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243367AbhLVXRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243348AbhLVXRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:17:48 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37A2C061574;
        Wed, 22 Dec 2021 15:17:47 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id d17so1753237ioz.0;
        Wed, 22 Dec 2021 15:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dff0r8n45mvWuk2RxTOvZIcrpYTBeLxoIYopzdxipjg=;
        b=KKigX/AuPLZafbpDh2E0dnoamrw5QHJf07R+fSOOvmMDEle5VXAZKnDBmW2xBYzivl
         BrxIvV1lCUQtFPiEHmO2Mq6PbOM0ByrdiVRwNO34qmzln/aJQeS+Iaaf1DXmKY2vLyJ9
         VLkZN+FHdXtaj+k1hIPcAvYhmt901l6ihC2dI++yq2hCLAW2VaU2WpTJHzcX4d5ueZvC
         oEMSBlG7/SxAl6qUPgfr0tjehr0eQzkcWPfVjTXNoZQTp0jycxLPKwWvVlrNVWToo2Ra
         5iyG9Ym1EbDmGX8q1wjqIFqaaX1pSB88Xoi6G4KU/qoHca9AKKqCSsG5fYOZQIgUQ94M
         e51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dff0r8n45mvWuk2RxTOvZIcrpYTBeLxoIYopzdxipjg=;
        b=Cjlxz8zm3BCg8/HLD5OuNYCxLG7RceGQZPuoy3UG2LVmrTzh2XxhsjEBPgigV/LTeH
         1vCZMGqd1Xwch+ymlb5ZVA0bQRGk5lDAI6jWf62anEzzlP7BJAylsEze8NjkIGP+W2ZK
         8h9Q1MH//wwb54uRVOmEU2+4UZgwrvCqaBpQRVAoVp+AL7OczccXgyIfMffTCU7Ij8Dv
         Q9u2+3/Er0KZ4PXmSAHzO1qSEdX43gKaSZvo6poAfnjkGY8I+MFIZR3PLE1JszeFbleK
         8Igix1fevkKmxdGOyNpMCVOHIpttWcHL5g8cisspASTdtSA9LZxbTYb5PaCL160U4WuA
         VInQ==
X-Gm-Message-State: AOAM530pkHBkAUyEng/ivxW65VQ9+XO3opX2L6nOkzWBdl/oSekoPvmL
        oqCnHwYt3T+fdp/GI+FxlOlNfl0DSN49+lnQISQ=
X-Google-Smtp-Source: ABdhPJw0prn6ou9/leHTPJACoUiainm5HEJjsXH5p3a/CImBJiPEnJadceO9JzUUsESORWWCgPdu/kxeBLZ7ef8Xr/A=
X-Received: by 2002:a05:6602:1495:: with SMTP id a21mr2517395iow.79.1640215067240;
 Wed, 22 Dec 2021 15:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20211214135555.125348-1-pulehui@huawei.com> <CAEf4BzaQcHV3iY5XqEbt3ptw+KejVVEZ8gSmW7u46=xHnsTaPA@mail.gmail.com>
 <a83777e4-528f-8adb-33e4-a0fea8d544a0@huawei.com> <CAEf4BzZf2UBgO=uaOOhPFEdJV9Jo7x3KAC3G9Wa1RVdmOD35nA@mail.gmail.com>
 <50d81d9c-2b5f-9dfd-a284-9778e6273725@huawei.com> <88aa98df-b566-d031-b9f9-2b88a437a810@huawei.com>
 <CAEf4BzbJsmKiZHrnEZUZxCL_7PP2w3K5-VabP1bcsoyKogiypw@mail.gmail.com> <bd0a5dff-7ada-4ff3-8fda-89e69254c2c4@huawei.com>
In-Reply-To: <bd0a5dff-7ada-4ff3-8fda-89e69254c2c4@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Dec 2021 15:17:35 -0800
Message-ID: <CAEf4BzZjoDH1ko7-wMPN6kquq-5dAnWAAqLfheRgKdQP8Mg7fQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix building error when using
 userspace pt_regs
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 5:33 PM Pu Lehui <pulehui@huawei.com> wrote:
>
>
>
> On 2021/12/22 7:52, Andrii Nakryiko wrote:
> > On Mon, Dec 20, 2021 at 4:58 PM Pu Lehui <pulehui@huawei.com> wrote:
> >>
> >>
> >>
> >> On 2021/12/20 22:02, Pu Lehui wrote:
> >>>
> >>>
> >>> On 2021/12/18 0:45, Andrii Nakryiko wrote:
> >>>> On Thu, Dec 16, 2021 at 6:25 PM Pu Lehui <pulehui@huawei.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 2021/12/16 12:06, Andrii Nakryiko wrote:
> >>>>>> On Tue, Dec 14, 2021 at 5:54 AM Pu Lehui <pulehui@huawei.com> wrote:
> >>>>>>>
> >>>>>>> When building bpf selftests on arm64, the following error will occur:
> >>>>>>>
> >>>>>>> progs/loop2.c:20:7: error: incomplete definition of type 'struct
> >>>>>>> user_pt_regs'
> >>>>>>>
> >>>>>>> Some archs, like arm64 and riscv, use userspace pt_regs in
> >>>>>>> bpf_tracing.h, which causes build failure when bpf prog use
> >>>>>>> macro in bpf_tracing.h. So let's use vmlinux.h directly.
> >>>>>>
> >>>>>> We could probably also extend bpf_tracing.h to work with
> >>>>>> kernel-defined pt_regs, just like we do for x86 (see __KERNEL__ and
> >>>>>> __VMLINUX_H__ checks). It's more work, but will benefit other end
> >>>>>> users, not just selftests.
> >>>>>>
> >>>>> It might change a lot. We can use header file directory generated by
> >>>>> "make headers_install" to fix it.
> >>>>
> >>>> We don't have dependency on "make headers_install" and I'd rather not
> >>>> add it.
> >>>>
> >>>> What do you mean by "change a lot"?
> >>>>
> >>> Maybe I misunderstood your advice. Your suggestion might be to extend
> >>> bpf_tracing.h to kernel-space pt_regs, while some archs, like arm64,
> >
> > yes
> >
> >>> only support user-space. So the patch might be like this:
> >>>
> >>> diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> >>> index db05a5937105..2c3cb8e9ae92 100644
> >>> --- a/tools/lib/bpf/bpf_tracing.h
> >>> +++ b/tools/lib/bpf/bpf_tracing.h
> >>> @@ -195,9 +195,13 @@ struct pt_regs;
> >>>
> >>>    #elif defined(bpf_target_arm64)
> >>>
> >>> -struct pt_regs;
> >>> +#if defined(__KERNEL__)
> >>> +#define PT_REGS_ARM64 const volatile struct pt_regs
> >>> +#else
> >>>    /* arm64 provides struct user_pt_regs instead of struct pt_regs to
> >>> userspace */
> >>>    #define PT_REGS_ARM64 const volatile struct user_pt_regs
> >>> +#endif
> >>> +
> >>>    #define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
> >>>    #define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
> >>>    #define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
> >>>
> >> Please ignore the last reply. User-space pt_regs of arm64/s390 is the
> >> first part of the kernel-space's, it should has covered both kernel and
> >> userspace.
> >
> > Alright, so is there still a problem or not? Looking at the definition
> > of struct pt_regs for arm64, just casting struct pt_regs to struct
> > user_pt_regs will indeed just work. So in that case, what was your
> > original issue?
> >
> Thanks for your reply. The original issue is, when arm64 bpf selftests
> cross compiling in x86_64 host, clang cannot find the arch specific uapi
> ptrace.h, and then the above error occur. Of course it works when
> compiling in arm64 host for it owns the corresponding uapi ptrace.h. So
> my suggestion is to add arch specific use header file directory
> generated by "make headers_install" for the cross compiling issue.

I see. Can you try adding something like:

ARCH_APIDIR := $(abspath ../../../../arch/$(SRCARCH)/include/uapi)

and then add -I$(ARCH_APIDIR) to BPF_CFLAGS?

Please let me know if that works for your cross-compilation case.

> >>>>>
> >>>>> --- a/tools/testing/selftests/bpf/Makefile
> >>>>> +++ b/tools/testing/selftests/bpf/Makefile
> >>>>> @@ -294,7 +294,8 @@ MENDIAN=$(if
> >>>>> $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
> >>>>>     CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
> >>>>>     BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) \
> >>>>>                -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) \
> >>>>> -            -I$(abspath $(OUTPUT)/../usr/include)
> >>>>> +            -I$(abspath $(OUTPUT)/../usr/include) \
> >>>>> +            -I../../../../usr/include
> >>>>>>>
> >>>>>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> >>>>>>> ---
> >>>>>>>     tools/testing/selftests/bpf/progs/loop1.c     |  8 ++------
> >>>>>>>     tools/testing/selftests/bpf/progs/loop2.c     |  8 ++------
> >>>>>>>     tools/testing/selftests/bpf/progs/loop3.c     |  8 ++------
> >>>>>>>     tools/testing/selftests/bpf/progs/loop6.c     | 20
> >>>>>>> ++++++-------------
> >>>>>>>     .../selftests/bpf/progs/test_overhead.c       |  8 ++------
> >>>>>>>     .../selftests/bpf/progs/test_probe_user.c     |  6 +-----
> >>>>>>>     6 files changed, 15 insertions(+), 43 deletions(-)
> >>>>>>>
> >>>>>>
> >>>>>> [...]
> >>>>>> .
> >>>>>>
> >>>> .
> >>>>
> >>> .
> > .
> >
