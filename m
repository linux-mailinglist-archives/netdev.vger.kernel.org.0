Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C25D36B7DD
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhDZRPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbhDZRPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:15:41 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB26C061756;
        Mon, 26 Apr 2021 10:14:57 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q192so12137809ybg.4;
        Mon, 26 Apr 2021 10:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xR0F+HLuIkso5ZlbvBDVXf6U/6oFZ6HggubnUlHmKTQ=;
        b=utXJQEPi/SP5n5NlakBGi8cjzvYdejtXvqCXLKMHMeG4VObHbdcDw3v6vPvVx4t87K
         Bah/YmWiZxidXErAYlZQdxjQBowwv/7DgtoAn5X3vfH/G7qCl+QPtZvLofV/r8p+pDkI
         fcZ0n05KPOcyIIDVyvEpd9TEjIWoTkzCR983AB6actGw5z3c5tgDOzHv8ZLag6kvGg7+
         6h5RBWpSIxP1tr/ms4KuUi6PiendDud5oU3ebGCCeeZ86YSJKNk3W0S/qBfKzrzQLdxN
         DNF8ZNGcdUL96K+mCj6DNX/VRRbbdmUOk/QAjbv2dQFo0AhVVMU36QD0dkwx9nZWC8jX
         tlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xR0F+HLuIkso5ZlbvBDVXf6U/6oFZ6HggubnUlHmKTQ=;
        b=PTTfhEwtiKWPtuDWizxRE1NYND8MLWXV9QwR1l8rg8qcyK78gDqtnNiysWlShjYcUA
         3zQTy/xCJxKIl9zH1gdInXTCPsXOXelMy+fD0J/giFuMRR4A2zHQrHhTRxgDVWeB6uOV
         WDeDzjqa6HIXVzgEizX5nCyC9x+ckIZtnZm6iaRg1oC0eJXdyUIKaG824CINqpqXq5fc
         E4lbRG/kBTWvD3hct/vOWhCpWpGGAXigVYWYZOrOUZoIf6dSU/MnNF+5b1QTpgGi0OpJ
         aEpRz/KUveDFxVxt17hb6uIGE6LwF2+TybzvcozgM26BET2jOIy8NXFBX3T+keoUatc0
         qqVA==
X-Gm-Message-State: AOAM532eEun9eBrM3zWJ8xl2c4ScjZIdxde2fw6iFA+bbxPEt6UAiQep
        xeq1DGdBRLMUpgltn+fiCKE7/eo29y73GuC7lMs=
X-Google-Smtp-Source: ABdhPJzvMTY//v8tZgQ2kSAAKZXNXfTok7l0Sqf1r5JsSB7FJJ2C7CEySx0iq5RQ5b3nDCpUUaWAIpkCRxhIwkwRDPA=
X-Received: by 2002:a25:7507:: with SMTP id q7mr6144202ybc.27.1619457297030;
 Mon, 26 Apr 2021 10:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-10-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-10-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 10:14:45 -0700
Message-ID: <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add support for FD_IDX make libbpf prefer that approach to loading programs.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/bpf.c             |  1 +
>  tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
>  tools/lib/bpf/libbpf_internal.h |  1 +
>  3 files changed, 65 insertions(+), 7 deletions(-)
>

[...]

> +static int probe_kern_fd_idx(void)
> +{
> +       struct bpf_load_program_attr attr;
> +       struct bpf_insn insns[] = {
> +               BPF_LD_IMM64_RAW(BPF_REG_0, BPF_PSEUDO_MAP_IDX, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> +       attr.insns = insns;
> +       attr.insns_cnt = ARRAY_SIZE(insns);
> +       attr.license = "GPL";
> +
> +       probe_fd(bpf_load_program_xattr(&attr, NULL, 0));

probe_fd() calls close(fd) internally, which technically can interfere
with errno, though close() shouldn't be called because syscall has to
fail on correct kernels... So this should work, but I feel like
open-coding that logic is better than ignoring probe_fd() result.

> +       return errno == EPROTO;
> +}
> +

[...]

> @@ -7239,6 +7279,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>         struct bpf_program *prog;
>         size_t i;
>         int err;
> +       struct bpf_map *map;
> +       int *fd_array = NULL;
>
>         for (i = 0; i < obj->nr_programs; i++) {
>                 prog = &obj->programs[i];
> @@ -7247,6 +7289,16 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>                         return err;
>         }
>
> +       if (kernel_supports(FEAT_FD_IDX) && obj->nr_maps) {
> +               fd_array = malloc(sizeof(int) * obj->nr_maps);
> +               if (!fd_array)
> +                       return -ENOMEM;
> +               for (i = 0; i < obj->nr_maps; i++) {
> +                       map = &obj->maps[i];
> +                       fd_array[i] = map->fd;

nit: obj->maps[i].fd will keep it a single line

> +               }
> +       }
> +
>         for (i = 0; i < obj->nr_programs; i++) {
>                 prog = &obj->programs[i];
>                 if (prog_is_subprog(obj, prog))
> @@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>                         continue;
>                 }
>                 prog->log_level |= log_level;
> +               prog->fd_array = fd_array;

you are not freeing this memory on success, as far as I can see. And
given multiple programs are sharing fd_array, it's a bit problematic
for prog to have fd_array. This is per-object properly, so let's add
it at bpf_object level and clean it up on bpf_object__close()? And by
assigning to obj->fd_array at malloc() site, you won't need to do all
the error-handling free()s below.

>                 err = bpf_program__load(prog, obj->license, obj->kern_version);
> -               if (err)
> +               if (err) {
> +                       free(fd_array);
>                         return err;
> +               }
>         }
> +       free(fd_array);
>         return 0;
>  }
>
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 6017902c687e..9114c7085f2a 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -204,6 +204,7 @@ struct bpf_prog_load_params {
>         __u32 log_level;
>         char *log_buf;
>         size_t log_buf_sz;
> +       int *fd_array;
>  };
>
>  int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
> --
> 2.30.2
>
