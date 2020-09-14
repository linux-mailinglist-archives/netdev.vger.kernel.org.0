Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC8D2699AD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgINX2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgINX2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:28:47 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A2FC06174A;
        Mon, 14 Sep 2020 16:28:46 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id c17so1150547ybe.0;
        Mon, 14 Sep 2020 16:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLueDcSAFB5j2gZq1SAE+OMjjzMoWS7EO1QPUdHOJIc=;
        b=QP7nG0XnEkLFqdU8bUtmgh5PVNy1BY/NUSJr3C8rdPXMNVFDFUjYi0nevp14RKkrlY
         9W8LaPIoH84A3O4W961hqf+wEut4NoDDWtWfYrzgnYlw4K4nIpXXRwX5BiH21s3mPMoS
         O2gLtS37PEFKXrqO0aq2rJL+FiKKbRhWnnMu3Pmp2b45aGMcD5zb0Eq+LfsLhsJHOqFC
         vVqko5TAcNLYst1oSmhXwwbTyGB5l4V+u/ns6EkE6FanSgzkk1mbFFu+oaGufSdORseO
         cZO1BaV9U+KrfJPTJ0ps6lCoPRhzjuxTqBXbb85lGc5imHJ+Cfn70JbrQr6hrAAuFe58
         BxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLueDcSAFB5j2gZq1SAE+OMjjzMoWS7EO1QPUdHOJIc=;
        b=pD9WdUoVT+wh8Vh9NUEqF5uORGtHme5T0RclJS4mO0hR6B6d/cvDYSEIlFt3CDbdLW
         RIk1BjJm4wk8A3GOmv2qqtwIOcyQ7a0awTYbrLlJnoHgi7BpiDh80AJL3+Zqxmm4fZs2
         C6cdESZPX4oQb62CgMfxjnV7BGaKzf3KZFHcJgfITTpKh9ZjSeinrz9WbJSXHONUK8T0
         mHIzXkC6/hgolgEIWpCOE0yZSFv5WTDjmzwdC6H/ZFBXUWGnk99mRQk86yBb1pbVOjOK
         FlGu5Lv4qd5yEuWxWh66A5QcyQsjD1NnIK+awstI7QCJFajAFDr/p43BvBjftZkq819j
         iTyg==
X-Gm-Message-State: AOAM531/ACi36vvbkrULPZIio2ID4/+Nhfb/GFIaayN4u7thUygJZqyK
        aJMar1b8jWcrz+76KnMfZ2b+1kDc/ottLeFHutY=
X-Google-Smtp-Source: ABdhPJzOvk0NqU6ifSCnjD0VGxjU3Yf9LpBTuTrUCIrjXS5Lep5Gsknbc6PZdUA6EUqhDWGagcyHEKCUTha7LDFfumQ=
X-Received: by 2002:a25:da90:: with SMTP id n138mr4512213ybf.260.1600126125502;
 Mon, 14 Sep 2020 16:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-4-sdf@google.com>
In-Reply-To: <20200914183615.2038347-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 16:28:34 -0700
Message-ID: <CAEf4BzbW46kyE3pVm1fGXkXV+ZW9ScoYAGdMuTkgCNHP-dpiuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .rodata section
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

On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> When the libbpf tries to load a program, it will probe the kernel for
> the support of this syscall and unconditionally bind .rodata section
> to the program.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/bpf.c      | 16 +++++++++
>  tools/lib/bpf/bpf.h      |  8 +++++
>  tools/lib/bpf/libbpf.c   | 72 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 97 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 82b983ff6569..2baa1308737c 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -872,3 +872,19 @@ int bpf_enable_stats(enum bpf_stats_type type)
>
>         return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
>  }
> +
> +int bpf_prog_bind_map(int prog_fd, int map_fd,
> +                     const struct bpf_prog_bind_opts *opts)
> +{
> +       union bpf_attr attr;
> +
> +       if (!OPTS_VALID(opts, bpf_prog_bind_opts))
> +               return -EINVAL;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.prog_bind_map.prog_fd = prog_fd;
> +       attr.prog_bind_map.map_fd = map_fd;
> +       attr.prog_bind_map.flags = OPTS_GET(opts, flags, 0);
> +
> +       return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
> +}
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 015d13f25fcc..8c1ac4b42f90 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -243,6 +243,14 @@ LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
>  enum bpf_stats_type; /* defined in up-to-date linux/bpf.h */
>  LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
>
> +struct bpf_prog_bind_opts {
> +       size_t sz; /* size of this struct for forward/backward compatibility */
> +       __u32 flags;
> +};
> +#define bpf_prog_bind_opts__last_field flags
> +
> +LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
> +                                const struct bpf_prog_bind_opts *opts);
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 550950eb1860..b68fa08e2fa9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -174,6 +174,8 @@ enum kern_feature_id {
>         FEAT_EXP_ATTACH_TYPE,
>         /* bpf_probe_read_{kernel,user}[_str] helpers */
>         FEAT_PROBE_READ_KERN,
> +       /* BPF_PROG_BIND_MAP is supported */
> +       FEAT_PROG_BIND_MAP,
>         __FEAT_CNT,
>  };
>
> @@ -409,6 +411,7 @@ struct bpf_object {
>         struct extern_desc *externs;
>         int nr_extern;
>         int kconfig_map_idx;
> +       int rodata_map_idx;
>
>         bool loaded;
>         bool has_subcalls;
> @@ -1070,6 +1073,7 @@ static struct bpf_object *bpf_object__new(const char *path,
>         obj->efile.bss_shndx = -1;
>         obj->efile.st_ops_shndx = -1;
>         obj->kconfig_map_idx = -1;
> +       obj->rodata_map_idx = -1;
>
>         obj->kern_version = get_kernel_version();
>         obj->loaded = false;
> @@ -1428,6 +1432,8 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
>                                                     obj->efile.rodata->d_size);
>                 if (err)
>                         return err;
> +
> +               obj->rodata_map_idx = obj->nr_maps - 1;
>         }
>         if (obj->efile.bss_shndx >= 0) {
>                 err = bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
> @@ -3894,6 +3900,55 @@ static int probe_kern_probe_read_kernel(void)
>         return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
>  }
>
> +static int probe_prog_bind_map(void)
> +{
> +       struct bpf_load_program_attr prg_attr;
> +       struct bpf_create_map_attr map_attr;
> +       char *cp, errmsg[STRERR_BUFSIZE];
> +       struct bpf_insn insns[] = {
> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       };
> +       int ret, map, prog;
> +
> +       if (!kernel_supports(FEAT_GLOBAL_DATA))
> +               return 0;

TBH, I don't think this check is needed, and it's actually coupling
two independent features together. probe_prog_bind_map() probes
PROG_BIND_MAP, it has nothing to do with global data itself. It's all
cached now, so there is no problem with that, it just feels unclean.
If someone is using .rodata and the kernel doesn't support global
data, we'll fail way sooner. On the other hand, if there will be
another use case where PROG_BIND_MAP is needed for something else, why
would we care about global data support? I know that in the real world
it will be hard to find a kernel with PROG_BIND_MAP and no global data
support, due to the latter being so much older, but still, unnecessary
coupling.

Would be nice to follow up and remove this, thanks.

> +
> +       memset(&map_attr, 0, sizeof(map_attr));
> +       map_attr.map_type = BPF_MAP_TYPE_ARRAY;
> +       map_attr.key_size = sizeof(int);
> +       map_attr.value_size = 32;
> +       map_attr.max_entries = 1;
> +

[...]
