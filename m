Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01250187943
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgCQFbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:31:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34608 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgCQFbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:31:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id f3so30539520qkh.1;
        Mon, 16 Mar 2020 22:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XXy14v1H5qtRvYyPugSKBtcwiv16J7o5FfkzIcp1Jlg=;
        b=WLVD/zf0i+fUP2SyAHSItt3BWS8cKI0clBoC9LIiM3ehdMWnswF/nkA5cETYMZsbqy
         +L0tTFNm6AtmM3SBMGSwcAtCeomly91l2L9HnoOMJPOM0fxjMDCpIoEuD0WKAYfAPf0B
         4m6vbaWEhM5M+4GpYdXh8X6InPv7YqueG7no23nz11SE/fMAO/NF7LFgxQS0rHiZk7xk
         Z5dGuXxY0BKK/4NBFUeGLcYE9mBKynGhNXYr1StqIgFZug4+9n+phE1On3Me98B1Q3ZB
         hcyZCkBpUatDDXMBGeucLqqKPcwQfu7b2dpuSnrAXSv8R0qITqJQQYppnxPF6moPiRY1
         j6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XXy14v1H5qtRvYyPugSKBtcwiv16J7o5FfkzIcp1Jlg=;
        b=Pelj0ryNQPJSIBrvowhpbPr8cfbsf7of4JIcdW3EdGa5LsLYkdQExIMEas4mjO8uSB
         pNw7eTIE42sAxaS7yO4i2D3b6PBvR67lvHqMD9JgrI/YCkX7zcbITKOjrB/c7+M7As9e
         DnWxpK06rBHg2gQGoUjbdhjEJZ44OAund7P0Aipjar/Q5Qs8RydfX5boHUO2cjWZLkzL
         VhhxguLheuAf3v9dc9eHbXwG8uczgoZWYVEwQRVEKl2lFkTfx7xth2ihLSFy03DKlxUd
         A2xhWsuzgPaqnP/meME5lm18rvY09Vodj2GiYK7r1dEzgSNYCbpymQ2XxRiKHGUj/9rl
         790g==
X-Gm-Message-State: ANhLgQ2tXK2LoTKyXmZHiIDdm99gcfi7T28Qd1WdSOmoC69C/7+CP0z7
        jCJtIcz03QxhXB3t+eZ1raKdEK0al7LvUlC+xHqagU8E
X-Google-Smtp-Source: ADFU+vty44T5xwlfAzeuiobyB7fjJWb1Rpr+0yfo3i+2ZJqxMA/vMgeoUouXiWE0Oeuq0BtwT/fUQH/bJKd0MegjsO0=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr3240261qkf.39.1584423078366;
 Mon, 16 Mar 2020 22:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200317011654.zkx5r7so53skowlc@google.com> <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
 <20200317033701.w7jwos7mvfnde2t2@google.com> <CAEf4BzYyimAo2_513kW6hrDWwmzSDhNjTYksjy01ugKKTPt+qA@mail.gmail.com>
 <20200317052120.diawg3a75kxl5hkn@google.com>
In-Reply-To: <20200317052120.diawg3a75kxl5hkn@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Mar 2020 22:31:07 -0700
Message-ID: <CAEf4BzYepRs4uB9vd1SCFY81H5S1kbvw2n9bKNeh-ORK_kutSg@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 10:21 PM Fangrui Song <maskray@google.com> wrote:
>
>
> On 2020-03-16, Andrii Nakryiko wrote:
> >On Mon, Mar 16, 2020 at 8:37 PM Fangrui Song <maskray@google.com> wrote:
> >>
> >> On 2020-03-16, Andrii Nakryiko wrote:
> >> >On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
> >> >>
> >> >> Simplify gen_btf logic to make it work with llvm-objcopy and
> >> >> llvm-objdump.  We just need to retain one section .BTF. To do so, we can
> >> >> use a simple objcopy --only-section=.BTF instead of jumping all the
> >> >> hoops via an architecture-less binary file.
> >> >>
> >> >> We use a dd comment to change the e_type field in the ELF header from
> >> >> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.
> >> >>
> >> >> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> >> >> Cc: Stanislav Fomichev <sdf@google.com>
> >> >> Cc: Nick Desaulniers <ndesaulniers@google.com>
> >> >> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> >> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> >> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> >> >> Signed-off-by: Fangrui Song <maskray@google.com>
> >> >> ---
> >> >>  scripts/link-vmlinux.sh | 13 ++-----------
> >> >>  1 file changed, 2 insertions(+), 11 deletions(-)
> >> >>
> >> >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >> >> index dd484e92752e..84be8d7c361d 100755
> >> >> --- a/scripts/link-vmlinux.sh
> >> >> +++ b/scripts/link-vmlinux.sh
> >> >> @@ -120,18 +120,9 @@ gen_btf()
> >> >>
> >> >>         info "BTF" ${2}
> >> >>         vmlinux_link ${1}
> >> >> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> >> >
> >> >Is it really tested? Seems like you just dropped .BTF generation step
> >> >completely...
> >>
> >> Sorry, dropped the whole line:/
> >> I don't know how to test .BTF . I can only check readelf -S...
> >>
> >> Attached the new patch.
> >>
> >>
> >>  From 02afb9417d4f0f8d2175c94fc3797a94a95cc248 Mon Sep 17 00:00:00 2001
> >> From: Fangrui Song <maskray@google.com>
> >> Date: Mon, 16 Mar 2020 18:02:31 -0700
> >> Subject: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
> >>   vmlinux BTF
> >>
> >> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> >> We use a dd comment to change the e_type field in the ELF header from
> >> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o can be accepted by lld.
> >>
> >> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> >> Cc: Stanislav Fomichev <sdf@google.com>
> >> Cc: Nick Desaulniers <ndesaulniers@google.com>
> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> >> Signed-off-by: Fangrui Song <maskray@google.com>
> >> ---
> >>   scripts/link-vmlinux.sh | 14 +++-----------
> >>   1 file changed, 3 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >> index dd484e92752e..b23313944c89 100755
> >> --- a/scripts/link-vmlinux.sh
> >> +++ b/scripts/link-vmlinux.sh
> >> @@ -120,18 +120,10 @@ gen_btf()
> >>
> >>         info "BTF" ${2}
> >>         vmlinux_link ${1}
> >> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> >> +       ${PAHOLE} -J ${1}
> >
> >I'm not sure why you are touching this line at all. LLVM_OBJCOPY part
> >is necessary, pahole assumes llvm-objcopy by default, but that can
> >(and should for objcopy) be overridden with LLVM_OBJCOPY.
>
> Why is LLVM_OBJCOPY assumed? What if llvm-objcopy is not available?

It's pahole assumption that we have to live with. pahole assumes
llvm-objcopy internally, unless it is overriden with LLVM_OBJCOPY env
var. So please revert this line otherwise you are breaking it for GCC
objcopy case.

> This is confusing that one tool assumes llvm-objcopy while the block
> below immediately uses GNU objcopy (without this patch).
>
> e83b9f55448afce3fe1abcd1d10db9584f8042a6 "kbuild: add ability to
> generate BTF type info for vmlinux" does not say why LLVM_OBJCOPY is
> set.
>
> >>
> >> -       # dump .BTF section into raw binary file to link with final vmlinux
> >> -       bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> >> -               cut -d, -f1 | cut -d' ' -f2)
> >> -       bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >> -               awk '{print $4}')
> >> -       ${OBJCOPY} --change-section-address .BTF=0 \
> >> -               --set-section-flags .BTF=alloc -O binary \
> >> -               --only-section=.BTF ${1} .btf.vmlinux.bin
> >> -       ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> >> -               --rename-section .data=.BTF .btf.vmlinux.bin ${2}
> >> +       # Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
> >> +       ${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
> >>   }
> >>
> >>   # Create ${2} .o file with all symbols from the ${1} object file
> >> --
> >> 2.25.1.481.gfbce0eb801-goog
> >>
