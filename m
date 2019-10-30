Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776F4EA5E6
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfJ3WCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:02:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41783 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfJ3WCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:02:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id m125so4556490qkd.8;
        Wed, 30 Oct 2019 15:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLkGBi8AqHwrrJaihuM7DKFQ0v3RjSOmcnIcPEdKZmo=;
        b=gx/fSHaMHMO2e4QlyV+fMumiHehoYvvEIr7JObwae1STNgM4X6BNbGUxzzJeg5/4sN
         ObmFm7JwTxkO1e1RwJ2cdy1X5etsN85krZRcG3wGaBvRpj3hlJw3wOAMDDkLBCYJ9diq
         D333HKzvWPnNcN3B+u39aBm46U+VrebUVrJuJpIk7XycZNJ9wLF87mLzZN9LDlmguNYH
         irErRDFTgK3GjUchhh45f5POisydwUJY6SUR68TEKfDyDx8pj1Dj0zt3vqqv9xtZWFfr
         XsW4O976ZURYL77kywZe1ONRB5Kem5WXFqkkuYCfjfp8yMjS5bolhtvlO6oaTgZ8PU8o
         SOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLkGBi8AqHwrrJaihuM7DKFQ0v3RjSOmcnIcPEdKZmo=;
        b=OITi/R2+CrzA59hkO6xy9y/2sVSGq/ciblaYARKNmphHBtsYMrAyeNMu4A/1ihW607
         68mm2ngQ1Rry6fEJt8PufklGrXfFpAaCCcqX0DU6Q1e3v9JKpKJaBd/zZrI64Hq+5/KB
         EykRf6jwCouArZu5VfBR6AlnR5m+Io097SQqn4hcU/6drVI/NPsHeCIICoz9lwOfwGjb
         pPGgYzMBshM8sX6EILF9WbXRh+Uw6FfQk1+Zx2KozagWDd3a90FD0TD7MrBbwChH6ghH
         9zu0j3m4yJvgUZyy28XpH3rc8Sbu+x63yLk/RHnNgKA0evTMjIYMZ8qBWVclIlqsRv3X
         pkdw==
X-Gm-Message-State: APjAAAVulfwjxZghobIzEvv17pvsVzpum07eSysLJKH6CLmmCDgoj9FO
        zuThWmG3/38UrumqnMjE/O1znqSV1gZN3JyJVxsFv0ga
X-Google-Smtp-Source: APXvYqyTM5Z8tVgUxLFVunQ+4Rrl79JwwzLqauxP5TLnJVPgUMt7+5X/x24HK+uB83k0l2YMXHDThULFCzlcMQfKgdg=
X-Received: by 2002:a37:8f83:: with SMTP id r125mr2300280qkd.36.1572472934233;
 Wed, 30 Oct 2019 15:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191030193532.262014-1-ast@kernel.org> <20191030193532.262014-3-ast@kernel.org>
In-Reply-To: <20191030193532.262014-3-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Oct 2019 15:02:03 -0700
Message-ID: <CAEf4BzatBeCW0mLWSuO_LFguwnT8RXr=WoUJFR_rjKHbyvukaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: add support for prog_tracing
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 12:36 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Cleanup libbpf from expected_attach_type == attach_btf_id hack
> and introduce BPF_PROG_TYPE_TRACING.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Looks good overall, but please replace all u32 to __u32 and add proper
LIBBPF_APIs for all the new exposed functions from libbpf.h, with
those changes:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/include/uapi/linux/bpf.h |  2 +
>  tools/lib/bpf/bpf.c            |  8 ++--
>  tools/lib/bpf/bpf.h            |  5 +-
>  tools/lib/bpf/libbpf.c         | 88 +++++++++++++++++++++++++---------
>  tools/lib/bpf/libbpf.h         |  4 ++
>  tools/lib/bpf/libbpf_probes.c  |  1 +
>  6 files changed, 80 insertions(+), 28 deletions(-)
>

[...]

>
> +static int libbpf_attach_btf_id_by_name(const char *name, u32 *btf_id);

here and in few places below, u32 will break libbpf on Github, please use __u32

> +
>  static struct bpf_object *
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                    struct bpf_object_open_opts *opts)
> @@ -3656,6 +3660,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>         bpf_object__for_each_program(prog, obj) {
>                 enum bpf_prog_type prog_type;
>                 enum bpf_attach_type attach_type;
> +               u32 btf_id;
>
>                 err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
>                                                &attach_type);
> @@ -3667,6 +3672,12 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>
>                 bpf_program__set_type(prog, prog_type);
>                 bpf_program__set_expected_attach_type(prog, attach_type);
> +               if (prog_type == BPF_PROG_TYPE_TRACING) {
> +                       err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
> +                       if (err)
> +                               goto out;
> +                       bpf_program__set_attach_btf_id(prog, btf_id);
> +               }
>         }
>
>         return obj;

[...]

>
> +#define BTF_PREFIX "btf_trace_"
> +static int libbpf_attach_btf_id_by_name(const char *name, u32 *btf_id)
> +{
> +       struct btf *btf = bpf_core_find_kernel_btf();
> +       char raw_tp_btf_name[128] = BTF_PREFIX;
> +       char *dst = raw_tp_btf_name + sizeof(BTF_PREFIX) - 1;
> +       int ret, i, err;
> +
> +       if (IS_ERR(btf)) {
> +               pr_warn("vmlinux BTF is not found\n");
> +               return -EINVAL;
> +       }
> +
> +       if (!name) {
> +               err = -EINVAL;
> +               goto err;
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(section_names); i++) {
> +               if (!section_names[i].is_attach_btf)
> +                       continue;
> +               if (strncmp(name, section_names[i].sec, section_names[i].len))
> +                       continue;
> +               /* prepend "btf_trace_" prefix per kernel convention */
> +               strncat(dst, name + section_names[i].len,
> +                       sizeof(raw_tp_btf_name) - sizeof(BTF_PREFIX));
> +               ret = btf__find_by_name(btf, raw_tp_btf_name);
> +               if (ret <= 0) {
> +                       pr_warn("%s is not found in vmlinux BTF\n", dst);
> +                       err = -EINVAL;
> +                       goto err;
> +               }
> +               *btf_id = ret;
> +               err = 0;

nit: I'd just initialize err to zero, it will be easy to miss this if
we need to extend this function a bit.

> +               goto err;
> +       }
> +       pr_warn("failed to identify btf_id based on ELF section name '%s'\n", name);
> +       err = -ESRCH;
> +err:

err is misleading, it's just exit, really

> +       btf__free(btf);
> +       return err;
> +}
> +
>  int libbpf_attach_type_by_name(const char *name,
>                                enum bpf_attach_type *attach_type)
>  {
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c63e2ff84abc..a3f5b8d3398d 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -307,6 +307,7 @@ LIBBPF_API int bpf_program__set_sched_cls(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
> +int bpf_program__set_tracing(struct bpf_program *prog);

LIBBPF_API? same few places below

>
>  LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
>  LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
> @@ -317,6 +318,8 @@ bpf_program__get_expected_attach_type(struct bpf_program *prog);
>  LIBBPF_API void
>  bpf_program__set_expected_attach_type(struct bpf_program *prog,
>                                       enum bpf_attach_type type);
> +void
> +bpf_program__set_attach_btf_id(struct bpf_program *prog, u32 btf_id);
>

[...]
