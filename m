Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A511264F66
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIJTlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgIJTlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:41:05 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDE1C061573;
        Thu, 10 Sep 2020 12:41:05 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v78so4831033ybv.5;
        Thu, 10 Sep 2020 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7NLoLuiSvemm18EApQM2ELQZ6rwM4D3aeHVfNMooP5Q=;
        b=UK8C9NDjGgKBJ0/4pL2GuK77SdooL+zUDHQUw7Ehpzb9wIzq0fGteyHEFbyE2jOCiL
         mn5rEl4L4iYLvWRBelOzVQLT7+vtoC42rv6M5Pmn8fuU7jyMhXExEDMw/jBEG7Jvm9cY
         JDbWWnE9qJe7WalPdEiLEOF52cExyGlSznC1c2WoknQ/FD95dTuJ/xixUhpcyCud0rK1
         5m/9YemQSypoyBnhFLzRK9MEDuwt+qgIGTpNdaB6zOiIvUNW5cmi7w8cGx1x0xggN8GB
         LYB+pDX/zV1bqtX2y3atCq3EAVjOzDZ10CA6EZkmVazuOtuxJEopNa51QWLdQ6iawDfv
         NVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7NLoLuiSvemm18EApQM2ELQZ6rwM4D3aeHVfNMooP5Q=;
        b=rTYfBtdy3xBT07VayAqj4Su8y/zUk1/bHSyNov8dyrEQERTLV600NnKMQ1yUaoi1dr
         UxLmCfLNygegZ67FABWW/S1Rqje3WgDPek3cga0u0tCbfGx6wh8O9O9pxaX+tT9FecqK
         djAPS3ISxCdNXYSt8MBtoaEdhN/aoHJp4ICQrjBbU155kaAOkn5lfikWsNF71ihoD63q
         ubOR22DmllfVe9HrtFKRYZTQpDgCeASygqdrCZWD2UvbgHh067SGfke9fcWYOld+Mo3c
         VdR4FHr/UlYoXCfzDJ1YARsWbx+fcKfPAzgHEyBsXN1bs/4aeANf/J3x5oGHDqJCFqU6
         Ltwg==
X-Gm-Message-State: AOAM531Yemy2PVyIlax4N5guWVnMi3Oddi9ZNygnItRJJsvWpmXWOwlK
        30RhRF7WMzYPkkbASYKazZ2vCuo8h7IHVSeQE9U=
X-Google-Smtp-Source: ABdhPJzq+QRV7V1mxn6clGBMEg/aL3hsMzscTRQMSMNVgpyQeFGyw5VYz7p3lEWhspp8baRZv1ULlAliokhuQpA+3pw=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr15009940ybg.425.1599766863823;
 Thu, 10 Sep 2020 12:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-4-sdf@google.com>
In-Reply-To: <20200909182406.3147878-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 12:40:53 -0700
Message-ID: <CAEf4BzaOmaOHdc2kkWk9KEByZqU+cKWHnFmFin4D3C2+xNubew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> When the libbpf tries to load a program, it will probe the kernel for
> the support of this syscall and unconditionally bind .rodata section

btw, you subject is out of sync, still mentions .metadata

> to the program.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>

Please drop zhuyifei@google.com from CC list (it's unreachable), when
you submit a new version.

> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/bpf.c      | 13 ++++++
>  tools/lib/bpf/bpf.h      |  8 ++++
>  tools/lib/bpf/libbpf.c   | 94 ++++++++++++++++++++++++++++++++--------
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 98 insertions(+), 18 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 82b983ff6569..5f6c5676cc45 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -872,3 +872,16 @@ int bpf_enable_stats(enum bpf_stats_type type)
>
>         return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
>  }
> +
> +int bpf_prog_bind_map(int prog_fd, int map_fd,
> +                     const struct bpf_prog_bind_opts *opts)
> +{
> +       union bpf_attr attr;
> +

you forgot OPTS_VALID check here

> +       memset(&attr, 0, sizeof(attr));
> +       attr.prog_bind_map.prog_fd = prog_fd;
> +       attr.prog_bind_map.map_fd = map_fd;
> +       attr.prog_bind_map.flags = OPTS_GET(opts, flags, 0);
> +
> +       return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
> +}

[...]

> -static int probe_kern_global_data(void)
> +static void probe_create_global_data(int *prog, int *map,
> +                                    struct bpf_insn *insns, size_t insns_cnt)
>  {
>         struct bpf_load_program_attr prg_attr;
>         struct bpf_create_map_attr map_attr;
>         char *cp, errmsg[STRERR_BUFSIZE];
> -       struct bpf_insn insns[] = {
> -               BPF_LD_MAP_VALUE(BPF_REG_1, 0, 16),
> -               BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 42),
> -               BPF_MOV64_IMM(BPF_REG_0, 0),
> -               BPF_EXIT_INSN(),
> -       };
> -       int ret, map;
> +       int err;
>
>         memset(&map_attr, 0, sizeof(map_attr));
>         map_attr.map_type = BPF_MAP_TYPE_ARRAY;
> @@ -3748,26 +3749,40 @@ static int probe_kern_global_data(void)
>         map_attr.value_size = 32;
>         map_attr.max_entries = 1;
>
> -       map = bpf_create_map_xattr(&map_attr);
> -       if (map < 0) {
> -               ret = -errno;
> -               cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> +       *map = bpf_create_map_xattr(&map_attr);
> +       if (*map < 0) {
> +               err = errno;
> +               cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
>                 pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
> -                       __func__, cp, -ret);
> -               return ret;
> +                       __func__, cp, -err);
> +               return;
>         }
>
> -       insns[0].imm = map;
> +       insns[0].imm = *map;

I think I already complained about this? You are assuming that
insns[0] is BPF_LD_MAP_VALUE, which is true only for one case out of
two already! It's just by luck that probe_prog_bind_map works because
the verifier ignores the exit code, apparently.

If this doesn't generalize well, don't generalize. But let's not do a
blind instruction rewrite, which will cause tons of confusion later.

>
>         memset(&prg_attr, 0, sizeof(prg_attr));
>         prg_attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
>         prg_attr.insns = insns;
> -       prg_attr.insns_cnt = ARRAY_SIZE(insns);
> +       prg_attr.insns_cnt = insns_cnt;
>         prg_attr.license = "GPL";
>
> -       ret = bpf_load_program_xattr(&prg_attr, NULL, 0);
> +       *prog = bpf_load_program_xattr(&prg_attr, NULL, 0);
> +}
> +
> +static int probe_kern_global_data(void)
> +{
> +       struct bpf_insn insns[] = {
> +               BPF_LD_MAP_VALUE(BPF_REG_1, 0, 16),
> +               BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 42),
> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +       int prog = -1, map = -1;
> +
> +       probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
> +
>         close(map);
> -       return probe_fd(ret);
> +       return probe_fd(prog);
>  }
>
>  static int probe_kern_btf(void)
> @@ -3894,6 +3909,32 @@ static int probe_kern_probe_read_kernel(void)
>         return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
>  }
>
> +static int probe_prog_bind_map(void)
> +{
> +       struct bpf_insn insns[] = {
> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +       int prog = -1, map = -1, ret = 0;
> +
> +       if (!kernel_supports(FEAT_GLOBAL_DATA))
> +               return 0;
> +
> +       probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
> +
> +       if (map >= 0 && prog < 0) {
> +               close(map);
> +               return 0;
> +       }
> +
> +       if (!bpf_prog_bind_map(prog, map, NULL))
> +               ret = 1;
> +
> +       close(map);
> +       close(prog);
> +       return ret;
> +}
> +

[...]

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 92ceb48a5ca2..0b7830f4ff8b 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -308,4 +308,5 @@ LIBBPF_0.2.0 {
>                 perf_buffer__epoll_fd;
>                 perf_buffer__consume_buffer;
>                 xsk_socket__create_shared;
> +               bpf_prog_bind_map;

please keep this list sorted

>  } LIBBPF_0.1.0;
> --
> 2.28.0.526.ge36021eeef-goog
>
