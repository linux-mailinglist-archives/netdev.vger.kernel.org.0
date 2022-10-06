Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CD35F5F85
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJFDVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJFDUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C13F17A92;
        Wed,  5 Oct 2022 20:19:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id o21so1637690ejm.11;
        Wed, 05 Oct 2022 20:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JMWpW+ooNTC/6z/R9cnX05e8m1vIwam4kn8UgJBux/E=;
        b=Z8CKBHmDHwtW1qRx7dXraDv87fqz1+6lxtmOeWDM9/cYnfDd9/6xaCyhSihOi5QkBV
         PVZrDXfyWFSY0vRXbtbjWnJ+d35W7AK5gVXFrnSNIkrpA4NQl3YjHqeMDt/SnL++GWwm
         LWcLAVR2Ghe7l19DfA3JzIAEtdI19OvZn/cbVKpW1r3WCWdqlRbAwmVwvwHVGgTbGqEE
         r98aWzm5TR5PYGRM8X5sZcZJ4aVXY2Inj9sPXQE56Q+qKDs3YsIXdhVeclHw+g2GZuir
         dkx+61NTBUY8e7RnpwbE+4k4uDSaMygtTfkqxdvsYgPKMiT3D23KVJOEY3KjMku+uuD/
         5zBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMWpW+ooNTC/6z/R9cnX05e8m1vIwam4kn8UgJBux/E=;
        b=p5bNMl6vxyd5mgj5/E1A0fJ7qn6dcJkmAdAYUE6e9XlvqjgD+UAZJ5hTWHFUeDCnCK
         4+U5fxl0hKDQNtyJvuDC29OZzFQUnKecpE8ZCbfr9YHHTr1sQ/Uwl69y7Vz2rm05j1Y4
         pWOW0YE7sruEfGYRcggz6uaM+Vs59b4HhpnYEpG+sABtXlZu5O6aSE5kDfTFGx0+7VDa
         chSmsiaT0UW6GaT5wOAlhRHcOzdmNh/MhXghh4+4UmjWcg0NTzl6/38VU1K7Hxsxpjwi
         wsfeNqkNMW894FlcTpqgxshjK2dKzYiEkhXw891M+9vmQJLd3ejXZN7HcgymKxpdEIer
         zBzg==
X-Gm-Message-State: ACrzQf1cZG39lolPIqSSLPnPwLXxF8YA+rD1iD0BwuEh9QF/82ZkSizN
        kXwMm47oaO6RXGrnmSfs/P6GeuJQsf0tEgOe63I=
X-Google-Smtp-Source: AMsMyM5CnMAZs1QbPpYYSC4SGUopv5WDsLTwM9r5aX8yrItZIQzPU9X5Qq2op/SiG/t5g25zz8yZTd+McmWHAVIi7yc=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr2127330ejn.302.1665026394561; Wed, 05
 Oct 2022 20:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-8-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-8-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:40 -0700
Message-ID: <CAEf4BzadsJWcCm4e=Bc40EaLj_8dMRy-MrfF7uwF5ysdZgGnkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] libbpf: Add extended attach/detach opts
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Extend libbpf attach opts and add a new detach opts API so this can be used
> to add/remove fd-based tc BPF programs. For concrete usage examples, see the
> extensive selftests that have been developed as part of this series.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf.c      | 21 +++++++++++++++++++++
>  tools/lib/bpf/bpf.h      | 17 +++++++++++++++--
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 18b1e91cc469..d1e338ac9a62 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -670,6 +670,27 @@ int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
>         return libbpf_err_errno(ret);
>  }
>
> +int bpf_prog_detach_opts(int prog_fd, int target_fd,
> +                        enum bpf_attach_type type,
> +                        const struct bpf_prog_detach_opts *opts)
> +{
> +       const size_t attr_sz = offsetofend(union bpf_attr, replace_bpf_fd);
> +       union bpf_attr attr;
> +       int ret;
> +
> +       if (!OPTS_VALID(opts, bpf_prog_detach_opts))
> +               return libbpf_err(-EINVAL);
> +
> +       memset(&attr, 0, attr_sz);
> +       attr.target_fd     = target_fd;
> +       attr.attach_bpf_fd = prog_fd;
> +       attr.attach_type   = type;
> +       attr.attach_priority = OPTS_GET(opts, attach_priority, 0);
> +
> +       ret = sys_bpf(BPF_PROG_DETACH, &attr, attr_sz);
> +       return libbpf_err_errno(ret);
> +}
> +
>  int bpf_link_create(int prog_fd, int target_fd,
>                     enum bpf_attach_type attach_type,
>                     const struct bpf_link_create_opts *opts)
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index bef7a5282188..96de58fecdbc 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -286,8 +286,11 @@ LIBBPF_API int bpf_obj_get_opts(const char *pathname,
>
>  struct bpf_prog_attach_opts {
>         size_t sz; /* size of this struct for forward/backward compatibility */
> -       unsigned int flags;
> -       int replace_prog_fd;
> +       __u32 flags;
> +       union {
> +               int replace_prog_fd;
> +               __u32 attach_priority;
> +       };

just add a new field, unions are very confusing in API structures.
It's ok if some unused fields stay zero.

>  };
>  #define bpf_prog_attach_opts__last_field replace_prog_fd
>
> @@ -296,9 +299,19 @@ LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
>  LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int attachable_fd,
>                                      enum bpf_attach_type type,
>                                      const struct bpf_prog_attach_opts *opts);
> +
> +struct bpf_prog_detach_opts {
> +       size_t sz; /* size of this struct for forward/backward compatibility */
> +       __u32 attach_priority;

please add size_t: 0; at the end to ensure better zero-initialization
by compiler

> +};
> +#define bpf_prog_detach_opts__last_field attach_priority
> +
>  LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
>  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>                                 enum bpf_attach_type type);
> +LIBBPF_API int bpf_prog_detach_opts(int prog_fd, int target_fd,
> +                                   enum bpf_attach_type type,

given we add detach_opts API, is type something that always makes
sense? If not, let's move it into opts.

> +                                   const struct bpf_prog_detach_opts *opts);
>
>  union bpf_iter_link_info; /* defined in up-to-date linux/bpf.h */
>  struct bpf_link_create_opts {
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index c1d6aa7c82b6..0c94b4862ebb 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -377,4 +377,5 @@ LIBBPF_1.1.0 {
>                 user_ring_buffer__reserve;
>                 user_ring_buffer__reserve_blocking;
>                 user_ring_buffer__submit;
> +               bpf_prog_detach_opts;

let's keep this sorted

>  } LIBBPF_1.0.0;

> --
> 2.34.1
>
