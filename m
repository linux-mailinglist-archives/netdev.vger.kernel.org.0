Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7025753D346
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiFCVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349191AbiFCVfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:35:07 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7683DDD7;
        Fri,  3 Jun 2022 14:35:05 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q1so9730023ljb.5;
        Fri, 03 Jun 2022 14:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8v76F/y6/MbjqM3o59kqOrykFh+Wdeo7EKyCKM8FAro=;
        b=G/IMUz4AXagHtKwKz/0cM5KncgmL00Lr/4+KexXnLrFlEmUQvzio1nNOvPjmVMOUtA
         a+QyPPW1uTrQkmdUd9+WUC2RO8XpyaJNlDeUavAglnk2k94AGmLcJGl+2aWa/uaGMfK9
         BWEm3sxG3DKGGSlwv3HXPeO64atHAJj98pkJyG0QutfACMKQ7xSNZY/UjInhccbivHfa
         Kg2XeoIgsbPZOQh2JYb41YIWD53+zY3Az5qX5KpbhzcWV/MjnaI9Xgrh7ASaMa8Hmy3s
         XXH4+41XppL71u0Sh0oyKJDp/vsFoCv/TpBesp3KPKvUlX1zlrR8GRHds/Ir9GpaF5YP
         M9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8v76F/y6/MbjqM3o59kqOrykFh+Wdeo7EKyCKM8FAro=;
        b=8FEcjyuLhZ/nC/3yKo1A/sZAbTvN3oWe/8vszcHCPPNZucSI7uP9+xgcgWS3Q886Fe
         +O3pD5Fy+P6DlNpDl4SFpjt3eEWEOysmfY9k0J250+uO3PTFyU2QQ+1BhZnN9+VIfABw
         9jP0vb7WNOGL+bgvND+RdqrldN4y8KECq7PPJ11UTQIuuXmm0NhfipM2j5zc0vcM5RF+
         SIsUzi0SCJgZF0FeM0bYdX45Jn04l15uyey7ozpJub81WddobfpfcXtomJo/XfRqNlYn
         qu/YWR3ykG/V7pblfCiHY6K0vibYVhHjvha8TwZD2vqehaHRGMj+HTljZ98/ZbqQ7jXA
         40Ug==
X-Gm-Message-State: AOAM532j2pIx2YMXz9hxmGZ6F7lRO/+x7RwHKjxwMqSUX6Xa7DEBp/Sg
        Mw+pNkG94nuYT/5atAVHxpEEbqHhk4bQrG33L+0kr80H/Ec=
X-Google-Smtp-Source: ABdhPJyUjHrmvehS2Lv5fKms+WVL07tJMSBLtK7DuhfMKXxdu7GqoyqbOyELcFuGAsFMDZFp7dS86KBXevDnDvT+RPw=
X-Received: by 2002:a2e:9bc1:0:b0:253:e20a:7a79 with SMTP id
 w1-20020a2e9bc1000000b00253e20a7a79mr38883935ljj.445.1654292104054; Fri, 03
 Jun 2022 14:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-9-sdf@google.com>
In-Reply-To: <20220601190218.2494963-9-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:34:52 -0700
Message-ID: <CAEf4BzYewhP+RbV9H1+8Htr73Y0fPNT4tN3E6v4-_GwEiJud-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 08/11] libbpf: implement bpf_prog_query_opts
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 12:02 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Implement bpf_prog_query_opts as a more expendable version of
> bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> well:
>
> * prog_attach_flags is a per-program attach_type; relevant only for
>   lsm cgroup program which might have different attach_flags
>   per attach_btf_id
> * attach_btf_func_id is a new field expose for prog_query which
>   specifies real btf function id for lsm cgroup attachments
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/include/uapi/linux/bpf.h |  3 +++
>  tools/lib/bpf/bpf.c            | 40 +++++++++++++++++++++++++++-------
>  tools/lib/bpf/bpf.h            | 15 +++++++++++++
>  tools/lib/bpf/libbpf.map       |  2 +-
>  4 files changed, 51 insertions(+), 9 deletions(-)
>

Few consistency nits, but otherwise:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index fa64b0b612fd..4271ef3c2afb 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1432,6 +1432,7 @@ union bpf_attr {
>                 __u32           attach_flags;
>                 __aligned_u64   prog_ids;
>                 __u32           prog_cnt;
> +               __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> @@ -5996,6 +5997,8 @@ struct bpf_prog_info {
>         __u64 run_cnt;
>         __u64 recursion_misses;
>         __u32 verified_insns;
> +       __u32 attach_btf_obj_id;
> +       __u32 attach_btf_id;
>  } __attribute__((aligned(8)));
>
>  struct bpf_map_info {
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 240186aac8e6..c7af7db53725 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -888,28 +888,52 @@ int bpf_iter_create(int link_fd)
>         return libbpf_err_errno(fd);
>  }
>
> -int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
> -                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
> +int bpf_prog_query_opts(int target_fd,
> +                       enum bpf_attach_type type,
> +                       struct bpf_prog_query_opts *opts)
>  {
>         union bpf_attr attr;
>         int ret;
>
>         memset(&attr, 0, sizeof(attr));
> +
> +       if (!OPTS_VALID(opts, bpf_prog_query_opts))
> +               return libbpf_err(-EINVAL);
> +

nit: check input args before you do work (memset), but it's very minor

>         attr.query.target_fd    = target_fd;
>         attr.query.attach_type  = type;
> -       attr.query.query_flags  = query_flags;
> -       attr.query.prog_cnt     = *prog_cnt;
> -       attr.query.prog_ids     = ptr_to_u64(prog_ids);
> +       attr.query.query_flags  = OPTS_GET(opts, query_flags, 0);
> +       attr.query.prog_cnt     = OPTS_GET(opts, prog_cnt, 0);
> +       attr.query.prog_ids     = ptr_to_u64(OPTS_GET(opts, prog_ids, NULL));
> +       attr.query.prog_attach_flags = ptr_to_u64(OPTS_GET(opts, prog_attach_flags, NULL));
>
>         ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
>
> -       if (attach_flags)
> -               *attach_flags = attr.query.attach_flags;
> -       *prog_cnt = attr.query.prog_cnt;
> +       OPTS_SET(opts, attach_flags, attr.query.attach_flags);
> +       OPTS_SET(opts, prog_cnt, attr.query.prog_cnt);
>
>         return libbpf_err_errno(ret);
>  }
>
> +int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
> +                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
> +{
> +       LIBBPF_OPTS(bpf_prog_query_opts, p);

nit: for consistency it would be good to call variable "opts" as we do
pretty much everywhere else?

> +       int ret;
> +
> +       p.query_flags = query_flags;
> +       p.prog_ids = prog_ids;
> +       p.prog_cnt = *prog_cnt;
> +
> +       ret = bpf_prog_query_opts(target_fd, type, &p);
> +
> +       if (attach_flags)
> +               *attach_flags = p.attach_flags;
> +       *prog_cnt = p.prog_cnt;
> +
> +       return ret;

maybe use libbpf_err() here for consistency and just in case we add
something that can clobber errno

> +}
> +
>  int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
>                       void *data_out, __u32 *size_out, __u32 *retval,
>                       __u32 *duration)

[...]
