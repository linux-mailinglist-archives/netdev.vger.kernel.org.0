Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FB3283F9E
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgJET1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJET1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:27:51 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3DC0613CE;
        Mon,  5 Oct 2020 12:27:51 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d20so13377220qka.5;
        Mon, 05 Oct 2020 12:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yqh1mymn11gTBUW9Ioi4CBHz/WIGYTIRn4OtLEkbedQ=;
        b=NLxxOlo4nWGq9oxTyeNEJDOz0q/4ZPpGiPlTDFtJEIbJfSz3qLZMqCbdnghy30QFfL
         XWqNYg53ogdqYfTWZvKJ/zBbTC1DlMGntABf3VYr7iNWVsS76j6qZNX5NQhdtxgtOfYV
         2g5ChXAT6CpwbO7oVcQ/aVFEukDtiUiCIq6xYsERQsmTuewvqzsVMdHISix9emrpD/+3
         6xnKtrgsi0uhgvjAOEIb05lS0onkNmsjHBtuccJowyYrERnZB9MewiCK7RJhR+0bRq6+
         ijqj27p4eAh2+JIXUWw+eWOrkRoMArGQzJJE7GwuOb1XbQ7L/acQFjOEb6lyqFwUbdxg
         kViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yqh1mymn11gTBUW9Ioi4CBHz/WIGYTIRn4OtLEkbedQ=;
        b=f095kvGUo1q3DfDy3rmdilTOuXE/43vQG3+pZydc83Cfw7LrmYwWhAR0Nqt9IHW3P6
         VBzsWLNFNQhCHTMUG+QXOWnlBGHgtX2ZnTiv7agTuHAePIameCYefDDwnKywuW1yKQI0
         jnacjXT9NY33KdTrJb4jtFBFSDJ5WlvYQv+wyQ2+elygPh1aHS4LBRVXbKDjuuWIr+qP
         yRpC1kqndoDV7jYn+7Zyaac+DoLrHWM6zWW6DMa7cUJ064B/55PLfHbhB0OjmrVU6cJG
         jqLiH6GssskX/cgI9ttgKbpvzVSq6g+6UOLDNI1oH638RNoICzKW1YkSW/Nae1O8qkjD
         ghBw==
X-Gm-Message-State: AOAM533HwulBMjjsru12K7SQXfNIlzllrhFcJEytmN0r6uN4f6uoFL1E
        tmq+diwuJ6mq76m2eUStbP/yoGUXmO4FS/eGLFI=
X-Google-Smtp-Source: ABdhPJziPyPaDh5VJ1sDL45RnsHZWzJ/tbOkQK9p73gVSUbrDVEpDOM7wVsUtdCUIi//UwCunHklgGJVviaM8V8F84s=
X-Received: by 2002:a25:2596:: with SMTP id l144mr2074803ybl.510.1601926070335;
 Mon, 05 Oct 2020 12:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201003021904.1468678-1-yhs@fb.com> <CAEf4BzZSg9TWF=kGVmiZ7HUbpyXwYUEqrvFMeZgYo0h7EC8b3w@mail.gmail.com>
 <9dba5b12-8a78-fa6b-ec43-224fb9297f48@fb.com>
In-Reply-To: <9dba5b12-8a78-fa6b-ec43-224fb9297f48@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Oct 2020 12:27:39 -0700
Message-ID: <CAEf4BzYXXFtfR5LqNP2DPmCZwq_s1Dx6xo9xWevRtsDZ5AQyvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: change Makefile to cope with
 latest llvm
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 10:16 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/2/20 9:22 PM, Andrii Nakryiko wrote:
> > On Fri, Oct 2, 2020 at 7:19 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> With latest llvm trunk, bpf programs under samples/bpf
> >> directory, if using CORE, may experience the following
> >> errors:
> >>
> >> LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.inde=
x
> >> PLEASE submit a bug report to https://urldefense.proofpoint.com/v2/url=
?u=3Dhttps-3A__bugs.llvm.org_&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DDA8=
e1B5r073vIqRrFz7MRA&m=3D_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8Pa1ZM&s=3DBwT=
AvhipPl-Az_WaiJDbqU8yl__NvG8W4HmCqWqHdqg&e=3D  and include the crash backtr=
ace.
> >> Stack dump:
> >> 0.      Program arguments: llc -march=3Dbpf -filetype=3Dobj -o samples=
/bpf/test_probe_write_user_kern.o
> >> 1.      Running pass 'Function Pass Manager' on module '<stdin>'.
> >> 2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on f=
unction '@bpf_prog1'
> >>   #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&,=
 int)
> >>      (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc=
+0x183c26c)
> >> ...
> >>   #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.=
cur/install/bin/llc+0x17c375e)
> >>   #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::=
SDNode*)
> >>      (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc=
+0x16a75c5)
> >>   #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm:=
:SDNode*, unsigned char const*,
> >>      unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/i=
nstall/bin/llc+0x16ab4f8)
> >> ...
> >> Aborted (core dumped) | llc -march=3Dbpf -filetype=3Dobj -o samples/bp=
f/test_probe_write_user_kern.o
> >>
> >> The reason is due to llvm change https://urldefense.proofpoint.com/v2/=
url?u=3Dhttps-3A__reviews.llvm.org_D87153&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b=
3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=3D_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8P=
a1ZM&s=3Dfo_LvXqHJx_m0m0pJJiDdOUcOzVXm2_iYoxPhpqpzng&e=3D
> >> where the CORE relocation global generation is moved from the beginnin=
g
> >> of target dependent optimization (llc) to the beginning
> >> of target independent optimization (opt).
> >>
> >> Since samples/bpf programs did not use vmlinux.h and its clang compila=
tion
> >> uses native architecture, we need to adjust arch triple at opt level
> >> to do CORE relocation global generation properly. Otherwise, the above
> >> error will appear.
> >>
> >> This patch fixed the issue by introduce opt and llvm-dis to compilatio=
n chain,
> >> which will do proper CORE relocation global generation as well as O2 l=
evel
> >> optimization. Tested with llvm10, llvm11 and trunk/llvm12.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   samples/bpf/Makefile | 6 +++++-
> >>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> index 4f1ed0e3cf9f..79c5fdea63d2 100644
> >> --- a/samples/bpf/Makefile
> >> +++ b/samples/bpf/Makefile
> >> @@ -211,6 +211,8 @@ TPROGLDLIBS_xsk_fwd         +=3D -pthread
> >>   #  make M=3Dsamples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/gi=
t/llvm/build/bin/clang
> >>   LLC ?=3D llc
> >>   CLANG ?=3D clang
> >> +OPT ?=3D opt
> >> +LLVM_DIS ?=3D llvm-dis
> >>   LLVM_OBJCOPY ?=3D llvm-objcopy
> >>   BTF_PAHOLE ?=3D pahole
> >>
> >> @@ -314,7 +316,9 @@ $(obj)/%.o: $(src)/%.c
> >>                  -Wno-address-of-packed-member -Wno-tautological-compa=
re \
> >>                  -Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
> >>                  -I$(srctree)/samples/bpf/ -include asm_goto_workaroun=
d.h \
> >> -               -O2 -emit-llvm -c $< -o -| $(LLC) -march=3Dbpf $(LLC_F=
LAGS) -filetype=3Dobj -o $@
> >> +               -O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o -=
 | \
> >> +               $(OPT) -O2 -mtriple=3Dbpf-pc-linux | $(LLVM_DIS) | \
> >> +               $(LLC) -march=3Dbpf $(LLC_FLAGS) -filetype=3Dobj -o $@

This is an extremely unusual set of steps, and might be worthwhile to
leave a comment explaining what's going on, so that I or someone else
doesn't ask the same question few months later :)

At any rate, this fixes the issue, so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> >
> > I keep forgetting exact details of why we do this native clang + llc
> > pipeline instead of just doing `clang -target bpf`? Is it still
>
> samples/bpf programs did not use vmlinux.h. they directly use
> kernel-devel headers, hence they need to first compile with native arch
> for clang but later change target arch to bpf to generate final byte code=
.
> They cannot just do 'clang -target bpf' without vmlinux.h.

Ok, right, thanks for explanation. I wonder if this "native" clang +
llc pass will also help with vmlinux.h on 32-bit architectures (though
with my recent patches that shouldn't be necessary, so this is more of
a curiosity, rather than the need).

>
> But changing to use vmlinux.h is a much bigger project and I merely
> want to make it just work so people won't make/compile samples/bpf
> and get compilation errors.

Right, of course.

>
> > relevant and necessary, or we can just simplify it now?
> >
> >>   ifeq ($(DWARF2BTF),y)
> >>          $(BTF_PAHOLE) -J $@
> >>   endif
> >> --
> >> 2.24.1
> >>
