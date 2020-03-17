Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6018772D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733278AbgCQA46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:56:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41231 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733119AbgCQA45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:56:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id t16so1789733plr.8
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 17:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=piiiUi1Oxpku//o2qSeAwqcou1OS0cpsZFRb+ApBsBk=;
        b=sd/xN+REFlUrpqjjirVErf725A99+lC6Ku6P6e/NHhKqHzrYD1DbfYy5EP+pCwldE3
         IIcs0tpI8aQvnv1PbwBvt3dlSVBREg73XSYM9JflBoq8RyavN/mhrHbI+33eNkB0Y3PP
         +hPGwWdJMLFe/M31+PW9r5trui5MtPM6pdjXFBKO5lasBHQ4BWxzc/UEKxnHeux8sBAD
         knZMki2XdcVFjG/N1fAjrAlNcoIFpVLyC26UAdV1qglOGaCJA7brug5GsImJ9SyWj1AI
         1GxdNlw7QHAENQXCWj+3gEVcEV8o+TtoUwy1hgrAewnhPzXwnRyYEbglffZgR0cdouPi
         5cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=piiiUi1Oxpku//o2qSeAwqcou1OS0cpsZFRb+ApBsBk=;
        b=rFS7SOwx3yV7TQHL//8QFcNlZKOCm0RxrhAyYgoC4Qe/Yso7+UlHN3AJGvbDYyf/PW
         DBeUHE+RTrVlRMkeijyHiEsHb4xvBDbSGx6m015xsxOQ4oDbmFLk/bnKhlk/W2BwL6gM
         phGnN1tQ4Bnouw0oFJRYG2HCeRDSEPAskL+3mOx4WifLbJUsCFNUJH9D9Q0BeiVc6cmy
         AD2CGMXHBuygy8PSOC50nCwqUJpjQiw6/nV9EcnINxdCs3AGr1fju5g3hCiRSGuy/5HK
         KcqwHN2Vqh9SpEEsz6JHL2dty794qfJ/iBcebqCzm6AGVSiU++rnuZqpnRONwGPu3feW
         m1DQ==
X-Gm-Message-State: ANhLgQ3xjaaWY8iMjTpIur4EZFXj+u+Ew/k7lA33adX+A3CoCVcUz/Y8
        8cPxd2b/bHJM5elJVMbU5QvCnQ==
X-Google-Smtp-Source: ADFU+vtYV8IXmAELPie2Fmbvw3TBiL/+De6aAp4TpkFOiXsT7RGZjSM2u2P1N3PCKpCg4Q9jf2bdkA==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr2299919pjx.175.1584406614580;
        Mon, 16 Mar 2020 17:56:54 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id o11sm844583pjb.18.2020.03.16.17.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 17:56:53 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:56:51 -0700
From:   Fangrui Song <maskray@google.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <20200317005651.tnzbreth7dk4ol43@google.com>
References: <20200316222518.191601-1-sdf@google.com>
 <20200316231516.kakoiumx4afph34t@google.com>
 <20200316235629.GC2179110@mini-arch.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200316235629.GC2179110@mini-arch.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-16, Stanislav Fomichev wrote:
>On 03/16, Fangrui Song wrote:
>> On 2020-03-16, Stanislav Fomichev wrote:
>> > Commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux
>> > BTF") switched from --dump-section to
>> > --only-section/--change-section-address for BTF export assuming
>> > those ("legacy") options should cover all objcopy versions.
>> >
>> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
>> > but it does support --dump-section. Let's partially roll back and
>> > try to use --dump-section first and fall back to
>> > --only-section/--change-section-address for the older binutils.
>> >
>> > 1. https://bugs.llvm.org/show_bug.cgi?id=45217
>> >
>> > Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
>> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> > Link: https://github.com/ClangBuiltLinux/linux/issues/871
>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> > ---
>> > scripts/link-vmlinux.sh | 10 ++++++++++
>> > 1 file changed, 10 insertions(+)
>> >
>> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
>> > index dd484e92752e..8ddf57cbc439 100755
>> > --- a/scripts/link-vmlinux.sh
>> > +++ b/scripts/link-vmlinux.sh
>> > @@ -127,6 +127,16 @@ gen_btf()
>> > 		cut -d, -f1 | cut -d' ' -f2)
>> > 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
>> > 		awk '{print $4}')
>> > +
>> > +	# Compatibility issues:
>> > +	# - pre-2.25 binutils objcopy doesn't support --dump-section
>> > +	# - llvm-objcopy doesn't support --change-section-address, but
>> > +	#   does support --dump-section
>> > +	#
>> > +	# Try to use --dump-section which should cover both recent
>> > +	# binutils and llvm-objcopy and fall back to --only-section
>> > +	# for pre-2.25 binutils.
>> > +	${OBJCOPY} --dump-section .BTF=$bin_file ${1} 2>/dev/null || \
>> > 	${OBJCOPY} --change-section-address .BTF=0 \
>> > 		--set-section-flags .BTF=alloc -O binary \
>> > 		--only-section=.BTF ${1} .btf.vmlinux.bin
>> > --
>> > 2.25.1.481.gfbce0eb801-goog
>>
>> So let me take advantage of this email to ask some questions about
>> commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF").
>>
>> Does .BTF have the SHF_ALLOC flag?
>No, that's why we manually do '--set-section-flags .BTF=alloc' to
>make --only-section work.
>
>> Is it a GNU objcopy<2.25 bug that objcopy --set-section-flags .BTF=alloc -O binary --only-section=.BTF does not skip the content?
>> Non-SHF_ALLOC sections usually have 0 sh_addr. Why do they need --change-section-address .BTF=0 at all?
>I think that '--set-section-flags .BTF=alloc' causes objcopy to put
>some non-zero (valid) sh_addr, that's why we need to reset it to 0.
>
>(it's not clear if it's a feature or a bug and man isn't helpful)
>
>> Regarding
>>
>> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
>>
>> This option will be difficult to implement in llvm-objcopy if we intend
>> it to have a GNU objcopy compatible behavior.
>> Without --only-section, it is not very clear how
>> --change-section-{address,vma,lma} will affect program headers.
>> There will be a debate even if we decide to implement them in llvm-objcopy.
>>
>> Some PT_LOAD rewriting examples:
>>
>>   objcopy --change-section-address .plt=0 a b
>>   objcopy --change-section-address .text=0 a b
>>
>> There is another bug related to -B
>> (https://github.com/ClangBuiltLinux/linux/issues/871#issuecomment-599790909):
>>
>> + objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc
>> -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
>> + objcopy -I binary -O elf64-x86-64 -B x86_64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.o
>> objcopy: architecture x86_64 unknown
>> + echo 'Failed to generate BTF for vmlinux'
>>
>> It should be i386:x86_64.
>Here is what I get:
>
>+ bin_arch=i386:x86-64
>+ bin_format=elf64-x86-64
>+ objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
>+ objcopy -I binary -O elf64-x86-64 -B i386:x86-64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.
>
>Can you try to see where your x86_64 is coming from?

llvm-objdump -f does not print bfdarch (ARCH= in binutils-gdb/ld/emulparams/*.sh).

% objdump -f .btf.vmlinux.bin.o

.btf.vmlinux.bin.o:     file format elf64-x86-64
architecture: i386:x86-64, flags 0x00000010:
HAS_SYMS
start address 0x0000000000000000

% llvm-objdump -f .btf.vmlinux.bin.o

.btf.vmlinux.bin.o:     file format elf64-x86-64

architecture: x86_64
start address: 0x0000000000000000

% objcopy -I binary -O elf64-x86-64 -B i386:x86-64 --rename-section .data=.BTF .btf.vmlinux.bin meow.btf.vmlinux.bin.o
# happy
% objcopy -I binary -O elf64-x86-64 -B x86-64 --rename-section .data=.BTF .btf.vmlinux.bin meow.btf.vmlinux.bin.o
objcopy: architecture x86-64 unknown


As a non-x86 example, elf64-powerpcle / powerpc:common64:

% powerpc64le-linux-gnu-objdump -f meow.btf.vmlinux.bin.o

meow.btf.vmlinux.bin.o:     file format elf64-powerpcle
architecture: powerpc:common64, flags 0x00000010:


Unfortunately, GNU objcopy<2.34 (before I complained about the redundant -B https://sourceware.org/bugzilla/show_bug.cgi?id=24968)
could not infer -B from -O elf* .
% objcopy -I binary -O elf64-x86-64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.o #<2.34
% file .btf.vmlinux.bin.o
.btf.vmlinux.bin.o: ELF 64-bit LSB relocatable, no machine, version 1 (SYSV), not stripped
objcopy: architecture x86-64 unknown

GNU ld and lld will error for e_machine==0.



I will be a bit nervous to make llvm-objdump behave more BFD like.
Adding i386:x86-64, powerpc:common64, etc does not look particularly clean.
Fortunately, looking at the code, it seems that we only want to retain .BTF
The following scheme may be simpler:

objcopy --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin.o && printf '\1' | dd of=.btf.vmlinux.bin.o conv=notrunc bs=1 seek=16

The command after && is to change e_type from ET_EXEC to ET_REL. GNU ld has an extremely rare feature that allows ET_EXEC to be linked,
but lld is more rigid and will reject such an input file.
https://mail.coreboot.org/hyperkitty/list/seabios@seabios.org/thread/HHIUPUXRIZ3KLTK4TPLG2V4PFP32HRBE/
