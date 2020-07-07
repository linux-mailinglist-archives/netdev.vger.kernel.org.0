Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8B216305
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGGAfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGGAfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:35:04 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EDC061755;
        Mon,  6 Jul 2020 17:35:04 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id m9so18133791qvx.5;
        Mon, 06 Jul 2020 17:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fNfRNjvWmPjdgFa7aQJR0qFQbN5GGb54beIsAQQGzXM=;
        b=dP5dCFzxhTUT8wgdsp8TThYYqZBha27vUKbTzlDinUBfCyeeyPqK9QJt/mzxdhtmwz
         KBqPPmAy5CoFLTvUzNn1bXI1yN70MUfTHpDwJdVGT/q8AmCLjfwlFOZne7QVLx4Lq4lO
         HxwE6kY/MobUMB7pzlPU11C9jnKHHUBpa7YYuWZxcVpisPxuHrdfoCVy2BvTnatboaf4
         QIhMbvI6kl2yb3n3mNz8i8n2fSXQMykTGu2Lw31R/RZrucwYefXF4natigthMcDMLJ+7
         kyhD232iCV7spmSP/bek3p+Q4In3ZOX5Fn4mPwJijLJkJIeMXQB7FW0tJ4+zhbf1ospN
         UdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNfRNjvWmPjdgFa7aQJR0qFQbN5GGb54beIsAQQGzXM=;
        b=KOgc6q97zqGQNDDtft2HyYZXUi9cBr49IGED279h4t53iVEu3d13SZhZ3SIjnKILrt
         I5QSmFYFXpUgxW1eXtsxgl/ABOyFh0q5BNFzb+lKxaEwmeUE6Os9hZfhRk8UHMjo+Te/
         oUZL6P/Gbs0g2sK2dPiDYFGc1bYMJzt4RG0izOWM70e0ViCUhRfKSdGycoa8NRHWwiDo
         sA2MmfDGGcQcuq48JjQWOok8m7J7yCeQmbuRDa2Dko7LfLycequfK8jr9r2UiIC/KOYW
         fef78Ek/ZQc0ef5FhdnqQ0fKO+GHUYpeHdadvFokQMe0OFq63r3N75OwqT9smWoHitaq
         emhA==
X-Gm-Message-State: AOAM533DlkeoeS2/3RBvU0T5tfLLvMbKD50jNQJYjwu8b8zc9T/9uTdu
        mA1R0Nay2JOD+1s+8SzGloBjJg4vRHzLePLvH2AJPzq6jYjzPA==
X-Google-Smtp-Source: ABdhPJxxtwcS1lrBi0EmROMenn2aYj4VZwIQ5cfzXrnxa+kL7ZZFLbKKFltuiE4rvvizHImHRpuWBUAjFTwtK+lwmiw=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr49106915qvb.196.1594082103478;
 Mon, 06 Jul 2020 17:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-2-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 17:34:52 -0700
Message-ID: <CAEf4BzYL=tNo9ktTkjgcSyYi-Uj3tyZ1EydKVGVTZvQBaza-Aw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/9] bpf: Add resolve_btfids tool to resolve
 BTF IDs in ELF object
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The resolve_btfids tool scans elf object for .BTF_ids section
> and resolves its symbols with BTF ID values.
>
> It will be used to during linking time to resolve arrays of BTF
> ID values used in verifier, so these IDs do not need to be
> resolved in runtime.
>
> The expected layout of .BTF_ids section is described in btfid.c
> header. Related kernel changes are coming in following changes.
>
> Build issue reported by 0-DAY CI Kernel Test Service.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/resolve_btfids/Build    |  26 ++
>  tools/bpf/resolve_btfids/Makefile |  77 ++++
>  tools/bpf/resolve_btfids/main.c   | 716 ++++++++++++++++++++++++++++++
>  3 files changed, 819 insertions(+)
>  create mode 100644 tools/bpf/resolve_btfids/Build
>  create mode 100644 tools/bpf/resolve_btfids/Makefile
>  create mode 100644 tools/bpf/resolve_btfids/main.c
>
> diff --git a/tools/bpf/resolve_btfids/Build b/tools/bpf/resolve_btfids/Build
> new file mode 100644
> index 000000000000..c7318cc55341
> --- /dev/null
> +++ b/tools/bpf/resolve_btfids/Build
> @@ -0,0 +1,26 @@
> +resolve_btfids-y += main.o
> +resolve_btfids-y += rbtree.o
> +resolve_btfids-y += zalloc.o
> +resolve_btfids-y += string.o
> +resolve_btfids-y += ctype.o
> +resolve_btfids-y += str_error_r.o
> +
> +$(OUTPUT)rbtree.o: ../../lib/rbtree.c FORCE
> +       $(call rule_mkdir)
> +       $(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)zalloc.o: ../../lib/zalloc.c FORCE
> +       $(call rule_mkdir)
> +       $(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)string.o: ../../lib/string.c FORCE
> +       $(call rule_mkdir)
> +       $(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)ctype.o: ../../lib/ctype.c FORCE
> +       $(call rule_mkdir)
> +       $(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)str_error_r.o: ../../lib/str_error_r.c FORCE
> +       $(call rule_mkdir)
> +       $(call if_changed_dep,cc_o_c)

Is Build also a Makefile? If that's the case, why not:

$(output)%.o: ../../lib/%.c FORCE
    $(call rule_mkdir)
    $(call if_changed_dep,cc_o_c)

?

> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> new file mode 100644
> index 000000000000..948378ca73d4
> --- /dev/null
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -0,0 +1,77 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +include ../../scripts/Makefile.include
> +
> +ifeq ($(srctree),)
> +srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +endif
> +
> +ifeq ($(V),1)
> +  Q =
> +  msg =
> +else
> +  Q = @
> +  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
> +  MAKEFLAGS=--no-print-directory
> +endif
> +
> +OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/

Ok, so this builds nicely for in-tree build, but when I did
out-of-tree build (I use KBUILD_OUTPUT, haven't checked specifying
O=whatever), I get:

  LD      vmlinux
  BTFIDS  vmlinux
/data/users/andriin/linux/scripts/link-vmlinux.sh: line 342:
/data/users/andriin/linux/tools/bpf/resolve_btfids/resolve_btfids: No
such file or directory

I suspect because you are assuming OUTPUT to be in srctree? You
probably need to adjust for out-of-tree mode.

> +
> +LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> +SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
> +
> +BPFOBJ     := $(OUTPUT)/libbpf.a
> +SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a

[...]

> +
> +#define BTF_IDS_SECTION        ".BTF.ids"

You haven't updated a bunch of places (cover letter, this patch commit
message, maybe somewhere else) after renaming from .BTF_ids, please
keep them in sync. Also, while I'm not too strongly against this name,
it does sound like this section is part of generic BTF format (as is
.BTF and .BTF.ext), which it is not, because it's so kernel-specific.
So I'm mildly against it and pro .BTF_ids.

> +#define BTF_ID         "__BTF_ID__"
> +
> +#define BTF_STRUCT     "struct"
> +#define BTF_UNION      "union"
> +#define BTF_TYPEDEF    "typedef"
> +#define BTF_FUNC       "func"
> +#define BTF_SET                "set"
> +

[...]

> +}
> +
> +static struct btf *btf__parse_raw(const char *file)

I thought you were going to add this to libbpf itself? Or you planned
to do a follow up patch later?

> +{
> +       struct btf *btf;
> +       struct stat st;
> +       __u8 *buf;
> +       FILE *f;
> +
> +       if (stat(file, &st))
> +               return NULL;
> +
> +       f = fopen(file, "rb");
> +       if (!f)
> +               return NULL;
> +
> +       buf = malloc(st.st_size);
> +       if (!buf) {
> +               btf = ERR_PTR(-ENOMEM);
> +               goto exit_close;
> +       }
> +
> +       if ((size_t) st.st_size != fread(buf, 1, st.st_size, f)) {
> +               btf = ERR_PTR(-EINVAL);
> +               goto exit_free;
> +       }
> +
> +       btf = btf__new(buf, st.st_size);
> +
> +exit_free:
> +       free(buf);
> +exit_close:
> +       fclose(f);
> +       return btf;
> +}
> +

[...]
