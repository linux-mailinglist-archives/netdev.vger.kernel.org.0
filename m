Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5BD1890C3
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCQVvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:51:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36230 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQVvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:51:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id i13so12705608pfe.3
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 14:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G8ak8AESDzh6e3M3i5Q2LPitDfjwSZZdOv21drjByw8=;
        b=FEkQxtHI6tEEiJwlbwFi52EsMTXZpIUXioR7S7Wr4xWk9Ghi74KS+svtNioAOoPRky
         tF6ghSZgTzROe7lEebfnJW9vFSVSIHjrIBaTvJ0l4Uffiyq7HsAuOUnwQiwfmVrc+iwc
         D3v9rzffln59+PynNDLqx+gBuCK888KsmPuOMdJoJPEVbvBTEYNwdgpuyJ8jhoTfLbRG
         oFyg+vvjuyDHUeHqoEaQNj4RJ60TYXKUck/UgspMwtN57QE+h4ColetmC/uXsSYsDkfq
         oR5rtEun/pbcUpfx2gQZSblEmUS/o98xjLI6HYucgKPUCULKr+kaK3kHQPaZI4GRaFlO
         qDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G8ak8AESDzh6e3M3i5Q2LPitDfjwSZZdOv21drjByw8=;
        b=Qu1ES5hkRXpIxbfPefDaV44C5MAG8ru0iT+zy2Hz3Us8TH2ggW6i1Ad9JwL4BjDp7M
         aiJPCVY4CGleOuQUW5TqvbMxN79B4IW+sFxfNJUVN6BW/VBSr8AZQrD/nN3jQjQqMzaM
         HJg6TKraNSgy334wpgzqQOc2mzu+uUm9sdRrNJUClljV8Rg1T7ZTbed7d3ZtzVSUPHV7
         KufqHa3PrrgHByjyFO5KZZGaqYFYIw/kjt4QzkBe9NbVFSJzXklezgUiSxQ3k187271Z
         qyujXrd55Ge3HjKQxF38bzvebIpvfDd/QlOGgNn6CeNBNPhQdMwsDw13xl3PUK9jmMZd
         yY1w==
X-Gm-Message-State: ANhLgQ1w7jIQd+UOLk5FveJMqaa1IzLkGNc30LIEw5GIGIcDIQC4CPYo
        4JcdfqGiz33Ap+OyEysHR5OXNg==
X-Google-Smtp-Source: ADFU+vvIwGvcCUWXXx1DFbXkGaPEZZPpFDtT/IbqssY3XSl/aFqb3/1zeYKv3I82as6Sxpsrs09b/Q==
X-Received: by 2002:aa7:9416:: with SMTP id x22mr915918pfo.100.1584481862039;
        Tue, 17 Mar 2020 14:51:02 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q12sm3957215pfh.158.2020.03.17.14.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 14:51:01 -0700 (PDT)
Date:   Tue, 17 Mar 2020 14:51:00 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
Message-ID: <20200317215100.GC2459609@mini-arch.hsd1.ca.comcast.net>
References: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/17, Fangrui Song wrote:
> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> The existing 'file format' and 'architecture' parsing logic is brittle
> and does not work with llvm-objcopy/llvm-objdump.
Thanks, it all makes sense and looks much better/portable (too much
dependence on binutils :-).
I've left a bunch of questions/nits below.

> 
> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag and
> rename .BTF to BTF so that C code can reference the section via linker
> synthesized __start_BTF and __stop_BTF. This fixes a small problem that
> previous .BTF had the SHF_WRITE flag. Additionally, `objcopy -I binary`
> synthesized symbols _binary__btf_vmlinux_bin_start and
> _binary__btf_vmlinux_bin_start (not used elsewhere) are replaced with
> more common __start_BTF and __stop_BTF.
> 
> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
> 
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
> does not intend to support, because this is error-prone.
Please keep small changelog here, for example:

v5:
* rebased on top of bpfnext

Btw, I tried to pull and test it and failed:
$ curl -LO https://lore.kernel.org/bpf/20200317211649.o4fzaxrzy6qxvz4f@google.com/raw
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9627  100  9627    0     0  47191      0 --:--:-- --:--:-- --:--:-- 47191
$ git am raw
warning: Patch sent with format=flowed; space at the end of lines might
be lost.
Applying: bpf: Support llvm-objcopy and llvm-objdump for vmlinux BTF
error: corrupt patch at line 20
Patch failed at 0001 bpf: Support llvm-objcopy and llvm-objdump for
vmlinux BTF
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
$ git describe
v5.6-rc5-1621-g230021539e8c

Are you sure it's on top of the bpf-next? Or am I doing something wrong?

> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>  kernel/bpf/btf.c        |  9 ++++-----
>  kernel/bpf/sysfs_btf.c  | 11 +++++------
>  scripts/link-vmlinux.sh | 17 ++++++-----------
>  3 files changed, 15 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 50080add2ab9..6f397c4da05e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3477,8 +3477,8 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
>  	return ERR_PTR(err);
>  }
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  extern struct btf *btf_vmlinux;
>  #define BPF_MAP_TYPE(_id, _ops)
> @@ -3605,9 +3605,8 @@ struct btf *btf_parse_vmlinux(void)
>  	}
>  	env->btf = btf;
> -	btf->data = _binary__btf_vmlinux_bin_start;
> -	btf->data_size = _binary__btf_vmlinux_bin_end -
> -		_binary__btf_vmlinux_bin_start;
> +	btf->data = __start_BTF;
> +	btf->data_size = __stop_BTF - __start_BTF;
>  	err = btf_parse_hdr(env);
>  	if (err)
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 7ae5dddd1fe6..3b495773de5a 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -9,15 +9,15 @@
>  #include <linux/sysfs.h>
>  /* See scripts/link-vmlinux.sh, gen_btf() func for details */
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  static ssize_t
>  btf_vmlinux_read(struct file *file, struct kobject *kobj,
>  		 struct bin_attribute *bin_attr,
>  		 char *buf, loff_t off, size_t len)
>  {
> -	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
> +	memcpy(buf, __start_BTF + off, len);
>  	return len;
>  }
> @@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
>  static int __init btf_vmlinux_init(void)
>  {
> -	if (!_binary__btf_vmlinux_bin_start)
> +	if (!__start_BTF)
>  		return 0;
>  	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
>  	if (!btf_kobj)
>  		return -ENOMEM;
> -	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
> -				    _binary__btf_vmlinux_bin_start;
> +	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
>  	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
>  }
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index ac569e197bfa..ae2048625f1e 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -133,17 +133,12 @@ gen_btf()
>  	info "BTF" ${2}
>  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> -	# dump .BTF section into raw binary file to link with final vmlinux
> -	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> -		cut -d, -f1 | cut -d' ' -f2)
> -	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> -		awk '{print $4}')
> -	bin_file=.btf.vmlinux.bin
We still have the following in gen_btf that you need to remove:
	local bin_arch
	local bin_format
	local bin_file

> -	${OBJCOPY} --change-section-address .BTF=0 \
> -		--set-section-flags .BTF=alloc -O binary \
> -		--only-section=.BTF ${1} $bin_file
> -	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> -		--rename-section .data=.BTF $bin_file ${2}
> +	# Extract .BTF, add SHF_ALLOC, rename to BTF so that we can reference
> +	# it via linker synthesized __start_BTF and __stop_BTF. Change e_type
> +	# to ET_REL so that it can be used to link final vmlinux.
> +	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> +		--rename-section .BTF=BTF ${1} ${2} 2>/dev/null && \
> +		printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
	We have 'set -e' so && can be omitted. Maybe it will be a bit
	more clear:

	# Extract .BTF, add SHF_ALLOC, rename to BTF so that we can reference
	# it via linker synthesized __start_BTF and __stop_BTF.
	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
		--rename-section .BTF=BTF ${1} ${2} 2>/dev/null

	# Change e_type to ET_REL (0x01) so that it can be used to link final
	# vmlinux.
	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none

	^^^ maybe also point out that this is required for llvm's ldd.
	I know you point it out in the commit message, but still nice
	to have as a comment here.

>  }
>  # Create ${2} .o file with all symbols from the ${1} object file
> -- 
> 2.25.1.481.gfbce0eb801-goog
