Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CB21972B
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 06:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgGIEXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 00:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIEXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 00:23:39 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25A5C061A0B;
        Wed,  8 Jul 2020 21:23:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id m8so400437qvk.7;
        Wed, 08 Jul 2020 21:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BI6WIEp2vA5C++YoVlosdSBgzk51TzlOu3ElCQWiUPc=;
        b=PO7UoS1VP7MLs4qudbrhEMGU/wXEdlBpnqzbtep6RObHLrY1E7BwsQ2ZsMsJZDcUq0
         fWeKt+rQQOkODGUvyaU8SWqiDjdAJgv5s2nGSn8msJWTsMVPQzTMnbxhcLfICsGWV5BQ
         2fu32tvp5iFEXGPXFiU/TK8e8mGzOlyPOElRVJsEjYDj5TCCRPr6URWbgUBcrdu+4suD
         /YjVm33zp/AdF1g1y9HPmazVGrl3Lx7Z+Y1aq/DDBgtWmbMruTrcgs3DavID9CC/H0Lo
         ZVs3GBRFwUGXNVcA+2RtiPHv3OUIt49dBp+UKKhUrufvswPiHeYcWpH0xQ3sq66yYnyh
         SR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BI6WIEp2vA5C++YoVlosdSBgzk51TzlOu3ElCQWiUPc=;
        b=gJp6vptfzvMoF0ES5rUc1NmcwE1MCPoZj1oSZ0hpZgOrohqJ2jOxAzXe/XnMX5sW5k
         7ZjpTfbOaa2VoKRbP/um1TUBek05ioMRm5uQ6THmZ2jss0pL5aYNNkUip+QyHocSFt5H
         Bd/MvW5Jbj1TALK8CVZ1NS0aNva8HDsSBvPo2bhWA6KuLO1rt2MosBi4wsHhkWb2wJBa
         BWdHx33x+/GhJimhtaJfcQ9uaFIyfswIUAjC7vj97zTT3z0XbPbTeEygY4hdRIEQi6I8
         sdXjAXO/aobGGCmDw9b615lBx+ApkZAV5JOuCBo9qEWM8S48uYcmgGha5qMHoHna4FIj
         LybQ==
X-Gm-Message-State: AOAM5302d8VNv1N3UiUO7IXCzkIwbm7OcOI49DU0q0LdJQteKGMgJ5D1
        KTPHKG7Z06fUvsjfXtVIZyUn/kASPFAQSYo8/qHk5NJe+eU=
X-Google-Smtp-Source: ABdhPJxY8qBHhb8uZdj35CzHXBBkV1m//S4ulsmfQmkxpqfkpiJnfBub3tMoOZSNEP/pgjQbGbtjQ7aqZAf6wBIerxY=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr57148481qvb.228.1594268617982;
 Wed, 08 Jul 2020 21:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com>
In-Reply-To: <20200702092416.11961-13-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 21:23:27 -0700
Message-ID: <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP
 program type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Make libbpf aware of the newly added program type, and assign it a
> section name.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>
> Notes:
>     v3:
>     - Move new libbpf symbols to version 0.1.0.
>     - Set expected_attach_type in probe_load for new prog type.
>
>     v2:
>     - Add new libbpf symbols to version 0.0.9. (Andrii)
>
>  tools/lib/bpf/libbpf.c        | 3 +++
>  tools/lib/bpf/libbpf.h        | 2 ++
>  tools/lib/bpf/libbpf.map      | 2 ++
>  tools/lib/bpf/libbpf_probes.c | 3 +++
>  4 files changed, 10 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4ea7f4f1a691..ddcbb5dd78df 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6793,6 +6793,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
>
>  enum bpf_attach_type
>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
> @@ -6969,6 +6970,8 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
>                                                 BPF_CGROUP_SETSOCKOPT),
>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
> +                                               BPF_SK_LOOKUP),

So it's a BPF_PROG_TYPE_SK_LOOKUP with attach type BPF_SK_LOOKUP. What
other potential attach types could there be for
BPF_PROG_TYPE_SK_LOOKUP? How the section name will look like in that
case?

>  };
>
>  #undef BPF_PROG_SEC_IMPL
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 2335971ed0bd..c2272132e929 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -350,6 +350,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
> +LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
>
>  LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
>  LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
> @@ -377,6 +378,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
> +LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
>
>  /*
>   * No need for __attribute__((packed)), all members of 'bpf_map_def'
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 6544d2cd1ed6..04b99f63a45c 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -287,5 +287,7 @@ LIBBPF_0.1.0 {
>                 bpf_map__type;
>                 bpf_map__value_size;
>                 bpf_program__autoload;
> +               bpf_program__is_sk_lookup;
>                 bpf_program__set_autoload;
> +               bpf_program__set_sk_lookup;
>  } LIBBPF_0.0.9;
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 10cd8d1891f5..5a3d3f078408 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -78,6 +78,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>                 xattr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
>                 break;
> +       case BPF_PROG_TYPE_SK_LOOKUP:
> +               xattr.expected_attach_type = BPF_SK_LOOKUP;
> +               break;
>         case BPF_PROG_TYPE_KPROBE:
>                 xattr.kern_version = get_kernel_version();
>                 break;
> --
> 2.25.4
>
