Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D4F188A1F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCQQYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:24:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39695 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCQQYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:24:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id b22so6018058pgb.6
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 09:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3gLHCw1k1vgin5ImJr7e+a6EB7LHD7UzoYRzly3/8qo=;
        b=EgT9v/aR37CWq7iFaT0oY9LSc6BsugpDhQ7/fV9k59U/ro8irWn7ex6HLrOw4Mt5OL
         7xcIzOwrIwKHqugjTlDJrmkjx/PLsJ9pN9/hMlEGvgVnaQe9KFJkgL9BkkXRx1cKq3Pg
         /at+xO6E6LJGlNoKpUfusRqPDE7WTt533GNouZA9HGG7jQtO1wY1VnszWSo69BKNzvk1
         1jyI8LbJ4T2JjQXEKFgFAtC9H37wmlu432UurOQSJY8HqYIy7mzWAMO8oYG5coJ32ipi
         ImDcFjTJNKOtcwYMTLHwuExg1Kve6LLfvzZR8M87FQOEvlfP8YXIjJQs1fyMdYbO0hBM
         ijqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3gLHCw1k1vgin5ImJr7e+a6EB7LHD7UzoYRzly3/8qo=;
        b=WZHIR6iEFRe1vnycAhio8reO66Ppn2LunDQS630pJHgpVbRPKmPz49a7He3N3czpzI
         hipst3YmSGr7Lg89Q91pTI0BnEiaazaYMeuNgqb1nBiCDP67dZnlgLdcThvEq2giHanh
         DknRKd4DANvbJg4kP1fH/t/RIEDI98bOiAFEFBUSwyDGsC8cOI+/4Uu+iZZQS4xRoETC
         RpXFJY/P2q055ykJdXxBRDY77kaKzuS6kRJmATg8znHgRastHLZEWciMxShGKOutV5cI
         YOaMgbU2HXnPagQXBzPHDrawBp7z73Y+VA3oX3dMCXsYOc6PHpDpZr2fEujYokpFK6EU
         qGqg==
X-Gm-Message-State: ANhLgQ3dvEBKkIl23wBXD/SzYoimIkByxD8kplhy2TLVdlVBwcXAcVzI
        uM4QG/EV09aksfhQgBhCO8VuNs/6Gjg=
X-Google-Smtp-Source: ADFU+vu3ccDtnSUmt2sRX4YsJ3IGwbVyko3v299XzImXGkiQTr3h57D88UbgQpM5ciNsKHhnNzj5oQ==
X-Received: by 2002:a63:d255:: with SMTP id t21mr46599pgi.114.1584462247864;
        Tue, 17 Mar 2020 09:24:07 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id d6sm3303583pjz.39.2020.03.17.09.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 09:24:07 -0700 (PDT)
Date:   Tue, 17 Mar 2020 09:24:05 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Fangrui Song <maskray@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH bpf v3] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
Message-ID: <20200317162405.GB2459609@mini-arch.hsd1.ca.comcast.net>
References: <20200317011654.zkx5r7so53skowlc@google.com>
 <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
 <20200317033701.w7jwos7mvfnde2t2@google.com>
 <CAEf4BzYyimAo2_513kW6hrDWwmzSDhNjTYksjy01ugKKTPt+qA@mail.gmail.com>
 <20200317052120.diawg3a75kxl5hkn@google.com>
 <CAEf4BzYepRs4uB9vd1SCFY81H5S1kbvw2n9bKNeh-ORK_kutSg@mail.gmail.com>
 <20200317054359.snyyojyf6gjxufij@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317054359.snyyojyf6gjxufij@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/16, Fangrui Song wrote:
> On 2020-03-16, Andrii Nakryiko wrote:
> > On Mon, Mar 16, 2020 at 10:21 PM Fangrui Song <maskray@google.com> wrote:
> > > 
> > > 
> > > On 2020-03-16, Andrii Nakryiko wrote:
> > > >On Mon, Mar 16, 2020 at 8:37 PM Fangrui Song <maskray@google.com> wrote:
> > > >>
> > > >> On 2020-03-16, Andrii Nakryiko wrote:
> > > >> >On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
> > > >> >>
> > > >> >> Simplify gen_btf logic to make it work with llvm-objcopy and
> > > >> >> llvm-objdump.  We just need to retain one section .BTF. To do so, we can
> > > >> >> use a simple objcopy --only-section=.BTF instead of jumping all the
> > > >> >> hoops via an architecture-less binary file.
> > > >> >>
> > > >> >> We use a dd comment to change the e_type field in the ELF header from
> > > >> >> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.
> > > >> >>
> > > >> >> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> > > >> >> Cc: Stanislav Fomichev <sdf@google.com>
> > > >> >> Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > >> >> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > > >> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > >> >> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> > > >> >> Signed-off-by: Fangrui Song <maskray@google.com>
> > > >> >> ---
> > > >> >>  scripts/link-vmlinux.sh | 13 ++-----------
> > > >> >>  1 file changed, 2 insertions(+), 11 deletions(-)
> > > >> >>
> > > >> >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > >> >> index dd484e92752e..84be8d7c361d 100755
> > > >> >> --- a/scripts/link-vmlinux.sh
> > > >> >> +++ b/scripts/link-vmlinux.sh
> > > >> >> @@ -120,18 +120,9 @@ gen_btf()
> > > >> >>
> > > >> >>         info "BTF" ${2}
> > > >> >>         vmlinux_link ${1}
> > > >> >> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> > > >> >
> > > >> >Is it really tested? Seems like you just dropped .BTF generation step
> > > >> >completely...
> > > >>
> > > >> Sorry, dropped the whole line:/
> > > >> I don't know how to test .BTF . I can only check readelf -S...
> > > >>
> > > >> Attached the new patch.
> > > >>
> > > >>
> > > >>  From 02afb9417d4f0f8d2175c94fc3797a94a95cc248 Mon Sep 17 00:00:00 2001
> > > >> From: Fangrui Song <maskray@google.com>
> > > >> Date: Mon, 16 Mar 2020 18:02:31 -0700
> > > >> Subject: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
> > > >>   vmlinux BTF
> > > >>
> > > >> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> > > >> We use a dd comment to change the e_type field in the ELF header from
> > > >> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o can be accepted by lld.
> > > >>
> > > >> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> > > >> Cc: Stanislav Fomichev <sdf@google.com>
> > > >> Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > >> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> > > >> Signed-off-by: Fangrui Song <maskray@google.com>
> > > >> ---
> > > >>   scripts/link-vmlinux.sh | 14 +++-----------
> > > >>   1 file changed, 3 insertions(+), 11 deletions(-)
> > > >>
> > > >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > >> index dd484e92752e..b23313944c89 100755
> > > >> --- a/scripts/link-vmlinux.sh
> > > >> +++ b/scripts/link-vmlinux.sh
> > > >> @@ -120,18 +120,10 @@ gen_btf()
> > > >>
> > > >>         info "BTF" ${2}
> > > >>         vmlinux_link ${1}
> > > >> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> > > >> +       ${PAHOLE} -J ${1}
> > > >
> > > >I'm not sure why you are touching this line at all. LLVM_OBJCOPY part
> > > >is necessary, pahole assumes llvm-objcopy by default, but that can
> > > >(and should for objcopy) be overridden with LLVM_OBJCOPY.
> > > 
> > > Why is LLVM_OBJCOPY assumed? What if llvm-objcopy is not available?
> > 
> > It's pahole assumption that we have to live with. pahole assumes
> > llvm-objcopy internally, unless it is overriden with LLVM_OBJCOPY env
> > var. So please revert this line otherwise you are breaking it for GCC
> > objcopy case.
> 
> Acknowledged. Uploaded v3.
> 
> I added back 2>/dev/null which was removed by a previous change, to
> suppress GNU objcopy warnings. The warnings could be annoying in V=1
> output.
> 
> > > This is confusing that one tool assumes llvm-objcopy while the block
> > > below immediately uses GNU objcopy (without this patch).
> > > 
> > > e83b9f55448afce3fe1abcd1d10db9584f8042a6 "kbuild: add ability to
> > > generate BTF type info for vmlinux" does not say why LLVM_OBJCOPY is
> > > set.
> > > 
> > > >>
> > > >> -       # dump .BTF section into raw binary file to link with final vmlinux
> > > >> -       bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> > > >> -               cut -d, -f1 | cut -d' ' -f2)
> > > >> -       bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> > > >> -               awk '{print $4}')
> > > >> -       ${OBJCOPY} --change-section-address .BTF=0 \
> > > >> -               --set-section-flags .BTF=alloc -O binary \
> > > >> -               --only-section=.BTF ${1} .btf.vmlinux.bin
> > > >> -       ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> > > >> -               --rename-section .data=.BTF .btf.vmlinux.bin ${2}
> > > >> +       # Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
> > > >> +       ${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
> > > >>   }
> > > >>
> > > >>   # Create ${2} .o file with all symbols from the ${1} object file
> > > >> --
> > > >> 2.25.1.481.gfbce0eb801-goog
> > > >>
> 
> From ca3597477542453e9f63185c27c162da081a4baf Mon Sep 17 00:00:00 2001
> From: Fangrui Song <maskray@google.com>
> Date: Mon, 16 Mar 2020 22:38:23 -0700
> Subject: [PATCH bpf v3] bpf: Support llvm-objcopy and llvm-objdump for
>  vmlinux BTF
> 
> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> Add 2>/dev/null to suppress GNU objcopy (but not llvm-objcopy) warnings
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
> Our use of --only-section drops many SHF_ALLOC sections which will essentially nullify
> program headers. When used as linker input, program headers are simply
> ignored.
> 
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o can be accepted by lld.
> Accepting ET_EXEC as an input file is an extremely rare GNU ld feature
> that lld does not intend to support, because this is very error-prone.
> 
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>  scripts/link-vmlinux.sh | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index dd484e92752e..c3e808a89d4a 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -122,16 +122,8 @@ gen_btf()
>  	vmlinux_link ${1}
>  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> -	# dump .BTF section into raw binary file to link with final vmlinux
> -	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> -		cut -d, -f1 | cut -d' ' -f2)
> -	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> -		awk '{print $4}')
> -	${OBJCOPY} --change-section-address .BTF=0 \
> -		--set-section-flags .BTF=alloc -O binary \
> -		--only-section=.BTF ${1} .btf.vmlinux.bin
> -	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> -		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
> +	# Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
> +	${OBJCOPY} --only-section=.BTF ${1} ${2} 2> /dev/null && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
No, it doesn't work unfortunately, I get "in-kernel BTF is malformed"
from the kernel.

I think that's because -O binary adds the following:
$ nm .btf.vmxlinux.bin
00000000002f7bc9 D _binary__btf_vmlinux_bin_end
00000000002f7bc9 A _binary__btf_vmlinux_bin_size
0000000000000000 D _binary__btf_vmlinux_bin_start

While non-binary mode doesn't:
$ nm .btf.vmxlinux.bin

We don't add them manually in the linker map and expect objcopy to add
them, see:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/kernel/bpf/btf.c#n3480

>  }
>  # Create ${2} .o file with all symbols from the ${1} object file
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 
