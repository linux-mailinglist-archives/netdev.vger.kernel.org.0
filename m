Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3C15C9A2
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgBMRmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:42:21 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43387 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgBMRmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:42:21 -0500
Received: by mail-qk1-f196.google.com with SMTP id p7so6474945qkh.10;
        Thu, 13 Feb 2020 09:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SeRIRwAxXCgkVIkqnHKnVkNwgSm44M/L7Ref4jNpIk=;
        b=spwkzztgIQeIuO4waZxR636AO2fypTRBRalqcpVGHE09aC/6U1WNQVuj7QVf+nLoRn
         FkcEXooRYeZhg7zKIMZk02VgAoAhGWYkrPAbycUZJ9LBO8voxNthFdJvOfR7iXivwTMA
         vVH9wukDV8r89eu1Gpk1O4rmydZYsmkQ8G9U7M7AIIEtjU8CTYnWrg8sgwIh2BFwjIKx
         jYj08tm26pqn7KeuedkozsDoEIGhjsXovv46FqbJquMS2IyFUPx4rrAorBM3D542IY4A
         X1fz+Kw+9D4aZ+EGLY6gzQxT63WDgr1rj1eqn9xw2E3ooN7YnISUtAM9WzGOPngfkm3P
         vQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SeRIRwAxXCgkVIkqnHKnVkNwgSm44M/L7Ref4jNpIk=;
        b=Kfr1r3Rla3ff04v0ZmNJvia66cw+kduO0cXhJlArsTM2lU4eRf7Bx5DMBJy7Oflsyg
         1+gTbU65Yfn8FpcikAuqGszKVPZkurD7Ie3w7tgiaoSUeOykr8hGHs84042Hrr+Vzxqf
         CPJNOy83dRhRlNbHqG7qyAPvJ4UNuEH877WCnjMV7hQW+uXD4sD79jtU75txbsGrrw8Q
         eip+ROo0eOMurwrRsfcPhlarioH59j24tyLkwlPXTBZRTojulqQYFvs+Mt2OUNh56j4N
         iRnZsc9m9ZmB2RLNl9/WSj6cbqxxdjCAtCx5XM7vuxlYXCj2dhvHIbBa0cbblNJbs7gG
         qOMg==
X-Gm-Message-State: APjAAAVwO7Hqx78oV6GcNjCgYlbmqalrEZLsrzse2gXofY2+GRczLhyM
        +N+Ym6tVE3VmOojZ1/pD83ZO9+heC/nuVfqT0uA=
X-Google-Smtp-Source: APXvYqx1nl6f2Zr1d51JuwBUaBpaNIgNfEMGseiSHJsucuRgkIjD3os20mX9S6GucebEwh+B55lENgq0kuxAqDhM2Zo=
X-Received: by 2002:a37:785:: with SMTP id 127mr17031600qkh.437.1581615739921;
 Thu, 13 Feb 2020 09:42:19 -0800 (PST)
MIME-Version: 1.0
References: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
In-Reply-To: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Feb 2020 09:42:07 -0800
Message-ID: <CAEf4Bzb59yjEMzs=n7pmbCB-L6RfmGDQiOwDFBoh54aSps4Vsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Add support for dynamic program
 attach target
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 7:05 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
>
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.
>
> The call flow would look something like this:
>
>   xdp_fd = bpf_prog_get_fd_by_id(id);
>   trace_obj = bpf_object__open_file("func.o", NULL);
>   prog = bpf_object__find_program_by_title(trace_obj,
>                                            "fentry/myfunc");
>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
>   bpf_program__set_attach_target(prog, xdp_fd,
>                                  "xdpfilt_blk_all");
>   bpf_object__load(trace_obj)
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

API-wise this looks good, thanks! Please address feedback below and
re-submit once bpf-next opens. Can you please also convert one of
existing selftests using open_opts's attach_prog_fd to use this API
instead to have a demonstration there?

> v1 -> v2: Remove requirement for attach type name in API
>
>  tools/lib/bpf/libbpf.c   |   33 +++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.h   |    4 ++++
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 514b1a524abb..9b8cab995580 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4939,8 +4939,8 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>  {
>         int err = 0, fd, i, btf_id;
>
> -       if (prog->type == BPF_PROG_TYPE_TRACING ||
> -           prog->type == BPF_PROG_TYPE_EXT) {
> +       if ((prog->type == BPF_PROG_TYPE_TRACING ||
> +            prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
>                 btf_id = libbpf_find_attach_btf_id(prog);
>                 if (btf_id <= 0)
>                         return btf_id;
> @@ -8132,6 +8132,35 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
>         }
>  }
>
> +int bpf_program__set_attach_target(struct bpf_program *prog,
> +                                  int attach_prog_fd,
> +                                  const char *attach_func_name)
> +{
> +       int btf_id;
> +
> +       if (!prog || attach_prog_fd < 0 || !attach_func_name)
> +               return -EINVAL;
> +
> +       if (attach_prog_fd)
> +               btf_id = libbpf_find_prog_btf_id(attach_func_name,
> +                                                attach_prog_fd);
> +       else
> +               btf_id = __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
> +                                              attach_func_name,
> +                                              prog->expected_attach_type);
> +
> +       if (btf_id <= 0) {
> +               if (!attach_prog_fd)
> +                       pr_warn("%s is not found in vmlinux BTF\n",
> +                               attach_func_name);

libbpf_find_attach_btf_id's error reporting is misleading (it always
reports as if error happened with vmlinux BTF, even if attach_prog_fd
> 0). Could you please fix that and add better error reporting here
for attach_prog_fd>0 case here?

> +               return btf_id;
> +       }
> +
> +       prog->attach_btf_id = btf_id;
> +       prog->attach_prog_fd = attach_prog_fd;
> +       return 0;
> +}
> +
>  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
>  {
>         int err = 0, n, len, start, end = -1;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 3fe12c9d1f92..02fc58a21a7f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -334,6 +334,10 @@ LIBBPF_API void
>  bpf_program__set_expected_attach_type(struct bpf_program *prog,
>                                       enum bpf_attach_type type);
>
> +LIBBPF_API int
> +bpf_program__set_attach_target(struct bpf_program *prog, int attach_prog_fd,
> +                              const char *attach_func_name);
> +
>  LIBBPF_API bool bpf_program__is_socket_filter(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct bpf_program *prog);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b035122142bb..8aba5438a3f0 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -230,6 +230,7 @@ LIBBPF_0.0.7 {
>                 bpf_program__name;
>                 bpf_program__is_extension;
>                 bpf_program__is_struct_ops;
> +               bpf_program__set_attach_target;

This will have to go into LIBBPF_0.0.8 once bpf-next opens. Please
rebase and re-send then.

>                 bpf_program__set_extension;
>                 bpf_program__set_struct_ops;
>                 btf__align_of;
>
