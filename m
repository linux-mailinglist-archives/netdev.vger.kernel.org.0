Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED513F542
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437156AbgAPSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:54:59 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34492 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389222AbgAPSy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:54:57 -0500
Received: by mail-qk1-f193.google.com with SMTP id j9so20229236qkk.1;
        Thu, 16 Jan 2020 10:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P69NeR3xJbxZLi5K91OSnj1oflfK13tq5qYKZgVnyUA=;
        b=a0BZb1CfHyVu6ryJUT4hyIFQr6IXepVmsN06Yv90dQQ2V2tiLXqGrpc9pU3y1CMp3X
         nFQABfi7O8zu3NW3d9er05dy3Y3ksxfMI6sZtSCG5qxgpZvegTuVbCOF9HaiEjav0l+/
         tP/vhsnQMIsMI+1SNEwJdAONbkkLS/9leyhm0EBxYf3dD9kxEA10fjakQ1o34C81UIVy
         YkcSr1AZwlVc1FHjvRIk+gUIsauAZvUD0VpqdNrgqiKsEY66cs23/ps+cVCmRtU527wL
         z9sgvpVclLD6jX01OreJixuBjrsOOlVmLqRphtE0BPOenKUmgh1DsKyl+JjN6jv+i/sc
         j7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P69NeR3xJbxZLi5K91OSnj1oflfK13tq5qYKZgVnyUA=;
        b=S3oOEdZSmO0uffbXEOzoZqyk02tl68NnEiuegt9TpgxzIhhzi4EgasZ6mw607ASVp6
         HjLx9B6AiP0fLS2KyHUMuUYoaGUxu6f0zWoMcvFk+ynUFn5UlA1E1S/jkAkXLHbMWyG6
         AlvS7nMQrBYA42nruZRrFKoVIobp6wp+cytaDb1QjI948ciFELzQ7faD0mw07Ua14gah
         ZtJYmLVcwUjB1F0b2/Xvh+6dzBNS5wRNMLjq7/4e+nxDmDTLnsxBvigUoOgPIH0tufe+
         F1LkbMV3SZe6c2YZqbY8JWXWIpP0qdGYHZ7qUG7FSk0LBjrmaJ92WjUoqUTiR+Ha9hFP
         GSEA==
X-Gm-Message-State: APjAAAVirlQE6lBoSUkbJog9/V5Tm5GDQjslwhoPG1ICYbvzLj/sii4g
        68ePWMllIDf7YPenuVXAP9z0OxJlbPSMcQKD9Gw=
X-Google-Smtp-Source: APXvYqzNWrYYAnZWogF+vDlCQ/krgmXOKSWASg7iizqummxNvC02kf/Ha3rlJBGEuZ5RkdjxLtxnZTctetiAYRvq/j0=
X-Received: by 2002:a37:a685:: with SMTP id p127mr31044074qke.449.1579200895688;
 Thu, 16 Jan 2020 10:54:55 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093389.1357254.10041649215380772130.stgit@toke.dk>
In-Reply-To: <157918093389.1357254.10041649215380772130.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 10:54:44 -0800
Message-ID: <CAEf4Bzbz47nFh4tPBn2PTi3+YiYpMDxymgf36P=ZjbuBPoCrZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/11] tools/bpf/runqslower: Fix override
 option for VMLINUX_BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 5:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The runqslower tool refuses to build without a file to read vmlinux BTF
> from. The build fails with an error message to override the location by
> setting the VMLINUX_BTF variable if autodetection fails. However, the
> Makefile doesn't actually work with that override - the error message is
> still emitted.
>
> Fix this by including the value of VMLINUX_BTF in the expansion, and only
> emitting the error message if the *result* is empty. Also permit running
> 'make clean' even though no VMLINUX_BTF is set.
>
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/bpf/runqslower/Makefile |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index cff2fbcd29a8..89fb7cd30f1a 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -10,12 +10,14 @@ CFLAGS :=3D -g -Wall
>
>  # Try to detect best kernel BTF source
>  KERNEL_REL :=3D $(shell uname -r)
> -ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
> -VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
> -else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> -VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
> -else
> -$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explicit=
ly")
> +VMLINUX_BTF_PATHS :=3D $(VMLINUX_BTF) /sys/kernel/btf/vmlinux /boot/vmli=
nux-$(KERNEL_REL)
> +VMLINUX_BTF_PATH :=3D $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))

If user specifies VMLINUX_BTF pointing to non-existing file, but the
system has /sys/kernel/btf/vmlinux, the latter will still be used,
which is a very surprising behavior.

Also MAKECMDGOALS feels like a fragile hack to me. How about we move
this VMLINUX_BTF guessing (without $(error)) into vmlinux.h rule
itself and use shell if conditional after it to check for file
existance and print nice error. That way we'll be checking VMLINUX_BTF
only when it's really needed.

> +
> +ifeq ("$(VMLINUX_BTF_PATH)","")
> +ifneq ($(MAKECMDGOALS),clean)
> +$(error Could not find kernel BTF file (tried: $(VMLINUX_BTF_PATHS)). \
> +       Try setting $$VMLINUX_BTF)
> +endif
>  endif
>
>  abs_out :=3D $(abspath $(OUTPUT))
> @@ -67,9 +69,9 @@ $(OUTPUT):
>         $(call msg,MKDIR,$@)
>         $(Q)mkdir -p $(OUTPUT)
>
> -$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) | $(OUTPUT) $(BPFTOOL)
> +$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
>         $(call msg,GEN,$@)
> -       $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +       $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
>
>  $(OUTPUT)/libbpf.a: | $(OUTPUT)
>         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)                   =
      \
>
