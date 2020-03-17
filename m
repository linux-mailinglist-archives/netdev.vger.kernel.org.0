Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8745187803
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgCQDOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:14:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45749 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgCQDOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:14:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id c145so30163432qke.12;
        Mon, 16 Mar 2020 20:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HQTEP5qZYfmGLQ0NflRh2YcAfuWWOw0vSoZda8pwfE=;
        b=SPdMIcBffPhn6RZ/fhC6UrLVzvjMNYsuYbP320+TsVhn3rPHH/hyHEMIvDbP86vyz9
         pF17BRKMXO7Rb8bt/WfMfna5I/wRbuvmDF8/80esPgowet0dVylAoKnPjeXdMSSiOyrY
         sTURyZiJCKK+R/noqFqaXR/7iFG7aq2mHuvIDG/uc5pcDpNvIDklQ7VHUaQNZw870ObH
         W7QyPWFNcruk+9nOMRxFNu0OScKoABa79NakDs46d5qnOYN8+8VUksYb7z/qIbxoS/yi
         n4eN1Z0n8RG4iJ7V4FSZh5gRzh7Hk/q0yWROrOvROwVPZTqLNkqIE/qwl4CtEPGrNnpH
         P7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HQTEP5qZYfmGLQ0NflRh2YcAfuWWOw0vSoZda8pwfE=;
        b=pFlti/pmcNd4t4bBC1mzE71VkCTDq0upgEpPzbErDMjsSxiGs1d+OL59cguZ74HjDi
         5L/HrmI8eupKROFgW7mWq4FgFI0mmO1RizoK7Gku9Dj+8wWT5FO4+qLDoKyERpfDv4SB
         7EydwB2XRLCsZLFRyeX9SL5fOrrcbQftU41jexJcJGsEDxPkwDEtD4quXkggkacKhx1A
         e7EA+hXyCFDevrsRCTOyGqZqiUnj783h5iPE7a7u3IISZeAFK6k4C+940bP6KCwpArXz
         7Ku8zCulb4Cl1k6VYv2uwdjN8VVt+Qt0/r49sQZ6L27p8CcoSgtW3jYrMtEGFnm39PwA
         briA==
X-Gm-Message-State: ANhLgQ3kWYu3fRpAlwUgCYZ+qyMZBW86ZnBmC7ckqX+nvIXoYUjyShz1
        NCstKYB350WaAlkiogMQKRCTanVAPCTGaKJSyuw=
X-Google-Smtp-Source: ADFU+vvKh7tXfzkrn1LMqd93LnTXZvfTaIWbYisXw2mTah7l6JKs73ytAL1QDAbgO2wEqZDS/ai1+Xr0Pa68XBj4Hac=
X-Received: by 2002:a37:992:: with SMTP id 140mr3038319qkj.36.1584414890639;
 Mon, 16 Mar 2020 20:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200316222518.191601-1-sdf@google.com> <20200316231516.kakoiumx4afph34t@google.com>
 <20200316235629.GC2179110@mini-arch.hsd1.ca.comcast.net> <20200317005651.tnzbreth7dk4ol43@google.com>
In-Reply-To: <20200317005651.tnzbreth7dk4ol43@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Mar 2020 20:14:38 -0700
Message-ID: <CAEf4BzbmciTXu1COJNH2b-p6ySj+USynJ_7pXJo_k8i8DTBSag@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy for vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 6:09 PM Fangrui Song <maskray@google.com> wrote:
>
> On 2020-03-16, Stanislav Fomichev wrote:
> >On 03/16, Fangrui Song wrote:
> >> On 2020-03-16, Stanislav Fomichev wrote:
> >> > Commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux
> >> > BTF") switched from --dump-section to
> >> > --only-section/--change-section-address for BTF export assuming
> >> > those ("legacy") options should cover all objcopy versions.
> >> >
> >> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
> >> > but it does support --dump-section. Let's partially roll back and
> >> > try to use --dump-section first and fall back to
> >> > --only-section/--change-section-address for the older binutils.
> >> >
> >> > 1. https://bugs.llvm.org/show_bug.cgi?id=45217
> >> >
> >> > Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> >> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> >> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> > Link: https://github.com/ClangBuiltLinux/linux/issues/871
> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> > ---
> >> > scripts/link-vmlinux.sh | 10 ++++++++++
> >> > 1 file changed, 10 insertions(+)
> >> >
> >> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >> > index dd484e92752e..8ddf57cbc439 100755
> >> > --- a/scripts/link-vmlinux.sh
> >> > +++ b/scripts/link-vmlinux.sh
> >> > @@ -127,6 +127,16 @@ gen_btf()
> >> >            cut -d, -f1 | cut -d' ' -f2)
> >> >    bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >> >            awk '{print $4}')
> >> > +
> >> > +  # Compatibility issues:
> >> > +  # - pre-2.25 binutils objcopy doesn't support --dump-section
> >> > +  # - llvm-objcopy doesn't support --change-section-address, but
> >> > +  #   does support --dump-section
> >> > +  #
> >> > +  # Try to use --dump-section which should cover both recent
> >> > +  # binutils and llvm-objcopy and fall back to --only-section
> >> > +  # for pre-2.25 binutils.
> >> > +  ${OBJCOPY} --dump-section .BTF=$bin_file ${1} 2>/dev/null || \
> >> >    ${OBJCOPY} --change-section-address .BTF=0 \
> >> >            --set-section-flags .BTF=alloc -O binary \
> >> >            --only-section=.BTF ${1} .btf.vmlinux.bin
> >> > --
> >> > 2.25.1.481.gfbce0eb801-goog
> >>
> >> So let me take advantage of this email to ask some questions about
> >> commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF").
> >>
> >> Does .BTF have the SHF_ALLOC flag?
> >No, that's why we manually do '--set-section-flags .BTF=alloc' to
> >make --only-section work.
> >
> >> Is it a GNU objcopy<2.25 bug that objcopy --set-section-flags .BTF=alloc -O binary --only-section=.BTF does not skip the content?
> >> Non-SHF_ALLOC sections usually have 0 sh_addr. Why do they need --change-section-address .BTF=0 at all?
> >I think that '--set-section-flags .BTF=alloc' causes objcopy to put
> >some non-zero (valid) sh_addr, that's why we need to reset it to 0.
> >
> >(it's not clear if it's a feature or a bug and man isn't helpful)
> >
> >> Regarding
> >>
> >> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
> >>
> >> This option will be difficult to implement in llvm-objcopy if we intend
> >> it to have a GNU objcopy compatible behavior.
> >> Without --only-section, it is not very clear how
> >> --change-section-{address,vma,lma} will affect program headers.
> >> There will be a debate even if we decide to implement them in llvm-objcopy.
> >>
> >> Some PT_LOAD rewriting examples:
> >>
> >>   objcopy --change-section-address .plt=0 a b
> >>   objcopy --change-section-address .text=0 a b
> >>
> >> There is another bug related to -B
> >> (https://github.com/ClangBuiltLinux/linux/issues/871#issuecomment-599790909):
> >>
> >> + objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc
> >> -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
> >> + objcopy -I binary -O elf64-x86-64 -B x86_64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.o
> >> objcopy: architecture x86_64 unknown
> >> + echo 'Failed to generate BTF for vmlinux'
> >>
> >> It should be i386:x86_64.
> >Here is what I get:
> >
> >+ bin_arch=i386:x86-64
> >+ bin_format=elf64-x86-64
> >+ objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
> >+ objcopy -I binary -O elf64-x86-64 -B i386:x86-64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.
> >
> >Can you try to see where your x86_64 is coming from?
>
> llvm-objdump -f does not print bfdarch (ARCH= in binutils-gdb/ld/emulparams/*.sh).
>
> % objdump -f .btf.vmlinux.bin.o
>
> .btf.vmlinux.bin.o:     file format elf64-x86-64
> architecture: i386:x86-64, flags 0x00000010:
> HAS_SYMS
> start address 0x0000000000000000
>
> % llvm-objdump -f .btf.vmlinux.bin.o
>
> .btf.vmlinux.bin.o:     file format elf64-x86-64
>
> architecture: x86_64
> start address: 0x0000000000000000
>
> % objcopy -I binary -O elf64-x86-64 -B i386:x86-64 --rename-section .data=.BTF .btf.vmlinux.bin meow.btf.vmlinux.bin.o
> # happy
> % objcopy -I binary -O elf64-x86-64 -B x86-64 --rename-section .data=.BTF .btf.vmlinux.bin meow.btf.vmlinux.bin.o
> objcopy: architecture x86-64 unknown
>
>
> As a non-x86 example, elf64-powerpcle / powerpc:common64:
>
> % powerpc64le-linux-gnu-objdump -f meow.btf.vmlinux.bin.o
>
> meow.btf.vmlinux.bin.o:     file format elf64-powerpcle
> architecture: powerpc:common64, flags 0x00000010:
>
>
> Unfortunately, GNU objcopy<2.34 (before I complained about the redundant -B https://sourceware.org/bugzilla/show_bug.cgi?id=24968)
> could not infer -B from -O elf* .
> % objcopy -I binary -O elf64-x86-64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.o #<2.34
> % file .btf.vmlinux.bin.o
> .btf.vmlinux.bin.o: ELF 64-bit LSB relocatable, no machine, version 1 (SYSV), not stripped
> objcopy: architecture x86-64 unknown
>
> GNU ld and lld will error for e_machine==0.
>
>
>
> I will be a bit nervous to make llvm-objdump behave more BFD like.
> Adding i386:x86-64, powerpc:common64, etc does not look particularly clean.
> Fortunately, looking at the code, it seems that we only want to retain .BTF
> The following scheme may be simpler:
>
> objcopy --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin.o && printf '\1' | dd of=.btf.vmlinux.bin.o conv=notrunc bs=1 seek=16
>

This part looks pretty crazy. Would it be simpler to detect whether
$(OBJCOPY) is llvm-objcopy and handle that in a bit less hacky way?


> The command after && is to change e_type from ET_EXEC to ET_REL. GNU ld has an extremely rare feature that allows ET_EXEC to be linked,
> but lld is more rigid and will reject such an input file.
> https://mail.coreboot.org/hyperkitty/list/seabios@seabios.org/thread/HHIUPUXRIZ3KLTK4TPLG2V4PFP32HRBE/
