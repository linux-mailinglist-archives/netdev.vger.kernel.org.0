Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5392E50F16F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343518AbiDZGsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343530AbiDZGso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:48:44 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEE18E14;
        Mon, 25 Apr 2022 23:45:37 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id k12so10820566ilv.3;
        Mon, 25 Apr 2022 23:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=333hgp36Hg+noixfGFAK/gjXVmk8k/NkyD+wV1nt6+U=;
        b=OTngiU6FUgP4pxMwbsOrP1ikdNN9eAnMDAaAL/O7D01y1xdVge+i49kEAqH7CBlLBN
         m9HsqFuSNTmc1/kFLo4G+4zFLbVAWO0DTDOKunFcXd1jJ7otW3O0+xeQ113OogdeZDOs
         RNvABICR2RiYlgfjhGLLFJp2Zweiyqwnd6hWzvBWhd/Me7jZH2AZTFbHvWA8CFFFLoCt
         zlnsh77ak1fjDUYQWIu2popvbLL/vGdOQkR8ZPJatjq85KzjFfTKzYkP4+9L7L6M5I6e
         Bn2bWngakwUvZCSjB8Bi5TS/MpmrxzwwwwmtTBuRhxZKqKeWnF1HIXftXiw0jgtvOc98
         GbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=333hgp36Hg+noixfGFAK/gjXVmk8k/NkyD+wV1nt6+U=;
        b=LkUBo50g70N9hyzc0gkEnQW34o0iEduIi4bYagnV6aFm/xJOkBib0yaTUltQDBxWCw
         FO6q2l/0hVxzlHiqe/CG2nA1/Cx80uIXi5Oswm8qdFkU+l/Xz2mWr7FWg2OqX7CtQ/oK
         4xanNC6IjVE2qrUfXLj33KJgp+rmV2pXsnbzzsPQ0czKiq5grs5TDPtL18UAGMXpNi+M
         SuL1hwPhQzAE+HA9T6hpCGn7wNH1El+24a0jliDJmF5jnRBCSbac2PrgGDYM+BCTtOXq
         twpB1BI/uf1G4EsT5E95NwsHpCu7JF/A2rwObcgZR+uqhG6vSxycXSt5PdgA/2KCUVki
         YNNQ==
X-Gm-Message-State: AOAM530OC8jCHGdi7TLHhcdWPkgkbC8UYYZw4Hj+Ts2Wx5g+T6EpOX4m
        hnmGHCgFCUYCjRSyddSEsjCXiAlE/x6KWWxY78XWqz1d
X-Google-Smtp-Source: ABdhPJxdxGHiUw+PaVj554lHW1GA901g51Bd1yA/8u59uw/snaL4KCtzH9eTshJn3ftWak0NtA+TTtrCl7kH7zG9OsQ=
X-Received: by 2002:a05:6e02:1ba3:b0:2cc:4158:d3ff with SMTP id
 n3-20020a056e021ba300b002cc4158d3ffmr8221367ili.98.1650955537176; Mon, 25 Apr
 2022 23:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-2-laoar.shao@gmail.com>
In-Reply-To: <20220423140058.54414-2-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:45:26 -0700
Message-ID: <CAEf4Bza_8d_K22DFRzGHYAQdz_y1+9b_bfSc0t0EkdM4nyy7Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] libbpf: Define DEFAULT_BPFFS
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, Apr 23, 2022 at 7:01 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Let's use a macro DEFAULT_BPFFS instead of the hard-coded "/sys/fs/bpf".
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  tools/lib/bpf/libbpf.c      | 2 +-
>  tools/lib/bpf/libbpf.h      | 6 ++++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 44df982d2a5c..9161ebcd3466 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -137,7 +137,7 @@ struct bpf_map_def {
>
>  enum libbpf_pin_type {
>         LIBBPF_PIN_NONE,
> -       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> +       /* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */

how is this improving things? now I need to grep some more to find out
what's the value of DEFAULT_BPFFS is


>         LIBBPF_PIN_BY_NAME,
>  };
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9a213aaaac8a..13fcf91e9e0e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2180,7 +2180,7 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
>         int len;
>
>         if (!path)
> -               path = "/sys/fs/bpf";
> +               path = DEFAULT_BPFFS;
>
>         len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
>         if (len < 0)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index cdbfee60ea3e..3784867811a4 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -28,6 +28,8 @@ LIBBPF_API __u32 libbpf_major_version(void);
>  LIBBPF_API __u32 libbpf_minor_version(void);
>  LIBBPF_API const char *libbpf_version_string(void);
>
> +#define DEFAULT_BPFFS "/sys/fs/bpf"
> +
>  enum libbpf_errno {
>         __LIBBPF_ERRNO__START = 4000,
>
> @@ -91,7 +93,7 @@ struct bpf_object_open_opts {
>         bool relaxed_core_relocs;
>         /* maps that set the 'pinning' attribute in their definition will have
>          * their pin_path attribute set to a file in this directory, and be
> -        * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
> +        * auto-pinned to that path on load; defaults to DEFAULT_BPFFS.
>          */
>         const char *pin_root_path;
>
> @@ -190,7 +192,7 @@ bpf_object__open_xattr(struct bpf_object_open_attr *attr);
>
>  enum libbpf_pin_type {
>         LIBBPF_PIN_NONE,
> -       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> +       /* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */
>         LIBBPF_PIN_BY_NAME,
>  };
>
> --
> 2.17.1
>
