Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD452187669
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbgCPX4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:56:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35380 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732880AbgCPX4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:56:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id g6so8759670plt.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 16:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dUkKsT4toOjs0vDW/Hl0lgm5Vma1SEYh7qBMpks+JuA=;
        b=zU6Zi2qOjFOy9pKZw9cU1mOBvfxR6LuzyI3pRF/2J4dYYUVTPtX2ZYcwSYiF+/WMgd
         3DcmE9HVJJBm+0IZc9LqFj5rAWsdKrE+1Q5uBgPQg8Ds2q8L6c+y1hazK45ZYcFnbP4r
         8KyjrYuIA+NIkeJ4JKsmuMPHtv8CAE2+cANH0CAMW+xK9pFpJtxndVf8F9l15kEZM+QU
         03BX0miCLFC/xW36ZsjrvKV+zc7E5LfwCHghs77tLK+grkjDGTdNSrSdfwgqci1SDa7p
         MDcE4aG4Bo5BGHgcZJSB3H0y0aUiOG5Ekc5I59oSafnY0u0s6h6f27sJ4lmwJ3gLXe1p
         /rtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dUkKsT4toOjs0vDW/Hl0lgm5Vma1SEYh7qBMpks+JuA=;
        b=H0Egg9PfZ5k9BHmKEEirroM/2+Am+ofziy9a+VNuaDBq1ltqWHVRKbEQpqm7QcGhOL
         IU2ikTyqENZ67dl/izCe2oPUvlpmXzC2JbV2qyL10NXgk7DheK9WuQlAiKHmuykDGPma
         q0aWpTJwc5gARYl2uLJ511jM9+lIW1kBhmtfJxH5ZII3Mqc9Bp7hMltpzuLI0azho/qm
         gwXPa7XblOJ8wWaJUiUp6Xwt+wXNh5N+PBhO+kbF0qcJ3HSMtKUbdusiTokwKDjQF09W
         1A1yvyPxR39Y6SYl2gJWdLMj+Zso4R+Xa5U/UCfESHO2GEcxW9X7OPt+2u5ya1Vhhokw
         Z6GA==
X-Gm-Message-State: ANhLgQ1BkWWD7SBA3zs5m6zL//rRbBs6whNe97MPifz3YPtHCm28PUYf
        h5A5cb40+E8RKwKe2mGPWyydMA==
X-Google-Smtp-Source: ADFU+vtk2RclaUGiePdTokC00vFifLhhIm8FIoO6grdfJEJFSeGY6HRQ4dEfglyUpVd98SapVPS7Mg==
X-Received: by 2002:a17:90b:300c:: with SMTP id hg12mr1962040pjb.96.1584402990779;
        Mon, 16 Mar 2020 16:56:30 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id c15sm545529pgk.66.2020.03.16.16.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 16:56:30 -0700 (PDT)
Date:   Mon, 16 Mar 2020 16:56:29 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Fangrui Song <maskray@google.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <20200316235629.GC2179110@mini-arch.hsd1.ca.comcast.net>
References: <20200316222518.191601-1-sdf@google.com>
 <20200316231516.kakoiumx4afph34t@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316231516.kakoiumx4afph34t@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/16, Fangrui Song wrote:
> On 2020-03-16, Stanislav Fomichev wrote:
> > Commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux
> > BTF") switched from --dump-section to
> > --only-section/--change-section-address for BTF export assuming
> > those ("legacy") options should cover all objcopy versions.
> > 
> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
> > but it does support --dump-section. Let's partially roll back and
> > try to use --dump-section first and fall back to
> > --only-section/--change-section-address for the older binutils.
> > 
> > 1. https://bugs.llvm.org/show_bug.cgi?id=45217
> > 
> > Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/871
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> > scripts/link-vmlinux.sh | 10 ++++++++++
> > 1 file changed, 10 insertions(+)
> > 
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index dd484e92752e..8ddf57cbc439 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -127,6 +127,16 @@ gen_btf()
> > 		cut -d, -f1 | cut -d' ' -f2)
> > 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> > 		awk '{print $4}')
> > +
> > +	# Compatibility issues:
> > +	# - pre-2.25 binutils objcopy doesn't support --dump-section
> > +	# - llvm-objcopy doesn't support --change-section-address, but
> > +	#   does support --dump-section
> > +	#
> > +	# Try to use --dump-section which should cover both recent
> > +	# binutils and llvm-objcopy and fall back to --only-section
> > +	# for pre-2.25 binutils.
> > +	${OBJCOPY} --dump-section .BTF=$bin_file ${1} 2>/dev/null || \
> > 	${OBJCOPY} --change-section-address .BTF=0 \
> > 		--set-section-flags .BTF=alloc -O binary \
> > 		--only-section=.BTF ${1} .btf.vmlinux.bin
> > -- 
> > 2.25.1.481.gfbce0eb801-goog
> 
> So let me take advantage of this email to ask some questions about
> commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF").
> 
> Does .BTF have the SHF_ALLOC flag?
No, that's why we manually do '--set-section-flags .BTF=alloc' to
make --only-section work.

> Is it a GNU objcopy<2.25 bug that objcopy --set-section-flags .BTF=alloc -O binary --only-section=.BTF does not skip the content?
> Non-SHF_ALLOC sections usually have 0 sh_addr. Why do they need --change-section-address .BTF=0 at all?
I think that '--set-section-flags .BTF=alloc' causes objcopy to put
some non-zero (valid) sh_addr, that's why we need to reset it to 0.

(it's not clear if it's a feature or a bug and man isn't helpful)

> Regarding
> 
> > Turns out llvm-objcopy doesn't implement --change-section-address [1],
> 
> This option will be difficult to implement in llvm-objcopy if we intend
> it to have a GNU objcopy compatible behavior.
> Without --only-section, it is not very clear how
> --change-section-{address,vma,lma} will affect program headers.
> There will be a debate even if we decide to implement them in llvm-objcopy.
> 
> Some PT_LOAD rewriting examples:
> 
>   objcopy --change-section-address .plt=0 a b
>   objcopy --change-section-address .text=0 a b
> 
> There is another bug related to -B
> (https://github.com/ClangBuiltLinux/linux/issues/871#issuecomment-599790909):
> 
> + objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc
> -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
> + objcopy -I binary -O elf64-x86-64 -B x86_64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.o
> objcopy: architecture x86_64 unknown
> + echo 'Failed to generate BTF for vmlinux'
> 
> It should be i386:x86_64.
Here is what I get:

+ bin_arch=i386:x86-64
+ bin_format=elf64-x86-64
+ objcopy --change-section-address .BTF=0 --set-section-flags .BTF=alloc -O binary --only-section=.BTF .tmp_vmlinux.btf .btf.vmlinux.bin
+ objcopy -I binary -O elf64-x86-64 -B i386:x86-64 --rename-section .data=.BTF .btf.vmlinux.bin .btf.vmlinux.bin.

Can you try to see where your x86_64 is coming from?
