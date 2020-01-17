Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD30A14131E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgAQVao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:30:44 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35093 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgAQVao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 16:30:44 -0500
Received: by mail-qt1-f194.google.com with SMTP id e12so22931397qto.2;
        Fri, 17 Jan 2020 13:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oKpJrpMP/WbiwVT8VF9eF4TKH+tXOjUsUEulh6dUpSw=;
        b=ZtisCfjADHKFGS8o8e4KIuHaDJC/xyclaJ5vqDJIXm5Wrpcq2jsu1dpGYrbMc0EiN5
         aD2ZtqJ5kO3qMGy2kukqbaVq+bN2uyoA+FQK5QZa6GqyLIl5xj9kPoJsXh1NPy9mYWHZ
         Df7icJ+9GU0YMhkXtCe1sJ9emvzmzIfFi175xOHBsdwgP9zpTU6wtz+lLCkNVWis1/Ih
         f726gk7Az81OAW+ZSC3XvVr/LS8pJOvy5Da49AyeIuNTq33bDLdxBokHkKfq/XMxnAjn
         eM4xKe8nxEEl090/fSg4wPNpNHvCXlErB1Q89+KFi+uiVxMszLSLwfvHkeE0rwOd4u3r
         x8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oKpJrpMP/WbiwVT8VF9eF4TKH+tXOjUsUEulh6dUpSw=;
        b=S2o9JP+sQh8eFZwNW3F7v3DiIre2v4EcRw9BaNYNSfSEdTUokE3ozIBlH8F7H1gxIU
         FDpgz7maNKsFvn7T4oOx1jzpDAOz5VVRtxSxl8aG/75+qzGJN8g6PfF8LeKWIjs/j2Sk
         CeyyN32lr8P7O3/uGh3PZnbcKFommoN3kqR8JLezDWEqKCfdbJe5dpzW6Ff10n/3hD2l
         VXORmKHco7wkPcT0gOOBQwd8vggVDbr6qPmMVquxUd4lmL/zReq7U34uagxVDRsgUz4e
         /IwHIn/79wtkEl1JadoMyaG2jo6IDLjpTf9hzYytZc2QHj6+231Y/hTd+kxGg7Bm2m13
         VFTg==
X-Gm-Message-State: APjAAAXyOPwEfrgbHR9z51YOwiUWob8ltTCIwek+C2XPsbLHrMPbnzIF
        VHUKuGIimmRn/y8keyf2ex308F7StIEzmjlZmFA=
X-Google-Smtp-Source: APXvYqzF1gj4bIlwoe5msPiG+wBSblLtJO0oPNeDcVYjXiuMENAAjDDrH5pD8NKfKq+pPDxE8OOJmtbFJoZHeMN2MHQ=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr9287898qtu.141.1579296642749;
 Fri, 17 Jan 2020 13:30:42 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk> <157926819920.1555735.13051810516683828343.stgit@toke.dk>
In-Reply-To: <157926819920.1555735.13051810516683828343.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Jan 2020 13:30:31 -0800
Message-ID: <CAEf4BzY3RM3LS3bvU4dHY+8U27RaezeaC9rfuW1YLAcFQEQKEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 02/10] tools/bpf/runqslower: Fix override
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

On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
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

approach looks good, thanks, few nits below

>  tools/bpf/runqslower/Makefile |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index cff2fbcd29a8..b62fc9646c39 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -10,13 +10,9 @@ CFLAGS :=3D -g -Wall
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
> -endif
> +VMLINUX_BTF_PATHS :=3D /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_RE=
L)
> +VMLINUX_BTF_PATH :=3D $(abspath $(or $(VMLINUX_BTF),$(firstword \
> +       $(wildcard $(VMLINUX_BTF_PATHS)))))

you can drop abspath, relative path for VMLINUX_BTF would work just fine

>
>  abs_out :=3D $(abspath $(OUTPUT))
>  ifeq ($(V),1)
> @@ -67,9 +63,13 @@ $(OUTPUT):
>         $(call msg,MKDIR,$@)
>         $(Q)mkdir -p $(OUTPUT)
>
> -$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) | $(OUTPUT) $(BPFTOOL)
> +$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
>         $(call msg,GEN,$@)
> -       $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +       @if [ ! -e "$(VMLINUX_BTF_PATH)" ] ; then \

$(Q), not @

> +               echo "Couldn't find kernel BTF; set VMLINUX_BTF to specif=
y its location."; \
> +               exit 1;\

nit: please align \'s (same above for VMLONUX_BTF_PATH) at the right
edge as it's done everywhere in this Makefile

> +       fi
> +       $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
>
>  $(OUTPUT)/libbpf.a: | $(OUTPUT)
>         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)                   =
      \
>
