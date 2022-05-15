Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58200527682
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiEOJIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 05:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiEOJIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 05:08:19 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EED1A059
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 02:08:18 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 125-20020a1c1983000000b003941f354c62so7074943wmz.0
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 02:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4UPlHLLMHUIw4lCwKqytRf70kgAzZVqEMbwMAZTs8QI=;
        b=eDigYPY7ZRSUS7IKjWCTISNXs1Mys0oeAvOEd5+sNlqwpX/dS2dJLe2BoeGzOeZQkq
         sUcSBmdYkVkjREcbeEEv72lz4QsNrMpGz9mOQhhXyrQpv0JIjo9XV+tqyVWAtFxDAFpI
         fNlNnlVdMUgm5Mn3stDJyOZBPJ0u7gI8r6mXz/bkfOGeSSSNK1Tstp8bUrvWh4EZkZ4W
         ID3H65U+HKbAcs/n1WlOg25czuxfIHpZtmV5poPiYVNi9iPigGWfvCe2vCcb+1NWTQAa
         XZV0cRmMCXEyyTV7kYBQs/i91pSuUC+zwwJ8CHtdKulK4395d1OQn4p7KP/utLJpZvQJ
         PhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UPlHLLMHUIw4lCwKqytRf70kgAzZVqEMbwMAZTs8QI=;
        b=4lXCN4zneB96Lhgpmcx7W5oJqaiROu0ZDRsnojBTFPiax+LFbxOjQ4l68rSN0yaA1z
         K1teCeECIHOqZAbJwEPnXZOuVKdvnJ0cpCC6T++DPSGQjeue8gpxHSPyLf1Ktcsmr6xC
         Lor0CPZ+7AFTO9kmMEDy1XiDbuul3H3ih8AVQIJ9+NpjI4+bWuPc6mK1hom3PUPsBuFc
         yZiekAdiUoz+wGaqXjX+BwNSLHf2W9p+hocmK6C0zz8JVsAKw5BXgpHxYTBLqKmYFDHV
         F1pk0FPrR/+rIQrNYtqr+I9NcnhJs/+MIcuuCLu4sn4CMAldcLWXGH40gVFiavrdOqVq
         skmQ==
X-Gm-Message-State: AOAM533q84axuInWrNSNXh9sx+qiMrCgKNI7GdP9IH7lXHUFyjdfrxmO
        9akjHZ4FK3LIVIgSLLP1FOCTZkC58rPPvEq6vL3/fA==
X-Google-Smtp-Source: ABdhPJz9ONQSxakxMZXfP3VzMmYw2QEzxC32G/LK7q2wOgqvmlcLcPLMQv3BfxhBR402cK+g90Fl6xzpUljK0keHiyQ=
X-Received: by 2002:a05:600c:1908:b0:394:867d:66c4 with SMTP id
 j8-20020a05600c190800b00394867d66c4mr22018729wmq.152.1652605696605; Sun, 15
 May 2022 02:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com> <20220515023504.1823463-4-yosryahmed@google.com>
In-Reply-To: <20220515023504.1823463-4-yosryahmed@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Sun, 15 May 2022 02:07:40 -0700
Message-ID: <CAJD7tkaCEcabywFGyeiM9zggx2Tw-e=Qa2UArgxXN8j7vJR-fA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 3/7] libbpf: Add support for rstat flush progs
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 7:35 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> Add support to attach RSTAT_FLUSH programs.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  tools/lib/bpf/bpf.c      |  1 -
>  tools/lib/bpf/libbpf.c   | 40 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  3 +++
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5660268e103f..9e3cb0d1eb99 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -870,7 +870,6 @@ int bpf_link_create(int prog_fd, int target_fd,
>                 attr.link_create.tracing.cookie = OPTS_GET(opts, tracing.cookie, 0);
>                 if (!OPTS_ZEROED(opts, tracing))
>                         return libbpf_err(-EINVAL);
> -               break;

This is a mistake, a remnant of RFC V1. Will remove it in the next version.

>         default:
>                 if (!OPTS_ZEROED(opts, flags))
>                         return libbpf_err(-EINVAL);
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4867a930628b..b7fc64ebf8dd 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8998,6 +8998,7 @@ static int attach_trace(const struct bpf_program *prog, long cookie, struct bpf_
>  static int attach_kprobe_multi(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>  static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>  static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_link **link);
> +static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link);
>
>  static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("socket",               SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
> @@ -9078,6 +9079,7 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>         SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> +       SEC_DEF("rstat/flush",          RSTAT_FLUSH, 0, SEC_NONE, attach_rstat),
>  };
>
>  static size_t custom_sec_def_cnt;
> @@ -11784,6 +11786,44 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
>         return libbpf_get_error(*link);
>  }
>
> +struct bpf_link *bpf_program__attach_rstat(const struct bpf_program *prog)
> +{
> +       struct bpf_link *link = NULL;
> +       char errmsg[STRERR_BUFSIZE];
> +       int err, prog_fd, link_fd;
> +
> +       prog_fd = bpf_program__fd(prog);
> +       if (prog_fd < 0) {
> +               pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> +               return libbpf_err_ptr(-EINVAL);
> +       }
> +
> +       link = calloc(1, sizeof(*link));
> +       if (!link)
> +               return libbpf_err_ptr(-ENOMEM);
> +       link->detach = &bpf_link__detach_fd;
> +
> +       /* rstat flushers are currently the only supported rstat programs */
> +       link_fd = bpf_link_create(prog_fd, 0, BPF_RSTAT_FLUSH, NULL);
> +       if (link_fd < 0) {
> +               err = -errno;
> +               pr_warn("prog '%s': failed to attach: %s\n",
> +                       prog->name, libbpf_strerror_r(err, errmsg,
> +                                                     sizeof(errmsg)));
> +               free(link);
> +               return libbpf_err_ptr(err);
> +       }
> +
> +       link->fd = link_fd;
> +       return link;
> +}
> +
> +static int attach_rstat(const struct bpf_program *prog, long cookie, struct bpf_link **link)
> +{
> +       *link = bpf_program__attach_rstat(prog);
> +       return libbpf_get_error(*link);
> +}
> +
>  struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>  {
>         struct bpf_link *link = NULL;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 21984dcd6dbe..f8b6827d5550 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -662,6 +662,9 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_iter(const struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts);
>
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_rstat(const struct bpf_program *prog);
> +
>  /*
>   * Libbpf allows callers to adjust BPF programs before being loaded
>   * into kernel. One program in an object file can be transformed into
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 008da8db1d94..f945c6265cb5 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -449,6 +449,7 @@ LIBBPF_0.8.0 {
>                 bpf_program__attach_kprobe_multi_opts;
>                 bpf_program__attach_trace_opts;
>                 bpf_program__attach_usdt;
> +               bpf_program__attach_rstat;
>                 bpf_program__set_insns;
>                 libbpf_register_prog_handler;
>                 libbpf_unregister_prog_handler;
> --
> 2.36.0.550.gb090851708-goog
>
