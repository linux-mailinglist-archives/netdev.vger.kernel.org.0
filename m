Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1FE1CB62A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHRl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgEHRl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:41:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47527C061A0C;
        Fri,  8 May 2020 10:41:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h26so1955659qtu.8;
        Fri, 08 May 2020 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7T7yAvFeKSgSXmGunQdOXMhLRz3I+Bw3xWzVb3xqOk=;
        b=UI40pK+Ew+JfV9Jl0iizHGBHBXzAAYw+ik8fLqZYnP5T9BGHDxKYWClQbIgZZGxAA5
         0hCrEXGGJkecH6WKmDc80+QccDKowOigNM/MpHSpjLGvw5F6kMlvuHUYpF7TIE1Lplfh
         Y1JlvsmiVvy8zul0iqkkvxQWhpMHQOq6+hOrZZKyxpVhfcyUArR79YGhjUvVKDr0FH3B
         leUhXlSS0YPWIBvtqsDMTckRp1wUFh+ZLZ3ZMIEGNaRx4pWV+seB/MogNtUN0fXW2lU2
         6EZefCbG02fEQBpQslnNpYeOXP75YMKpLT9zNp18hATajWoimu1EbM57lR2xP8okmRDg
         b4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7T7yAvFeKSgSXmGunQdOXMhLRz3I+Bw3xWzVb3xqOk=;
        b=DAF2y+rCKTbcdQb6soLLXfg7F/PT7jDqQG3hkJLtYus5w5hfsZbQ50bUX0kJICFVki
         nx6B8QTviQAOhGd1EgR2QQLxeerYjj0MOccK+LQGdSjSNZKWFiiFgFgQtIkApRGUELFj
         0iIwgCHeTOQZdr/uNsvA/Pds9KJHMqJiMuJc3j2VCdNQzHa8G27iYlqUEkdUD5Tfit5Y
         yyA2DBPPfTyhTJZBNicfpAk4sRF99Vcji4HE2tg51S5Q6r6E6hLmNv6qc5VxFyBtira+
         dXJvrETwNuWzd1u9BkfuzYxUPW/IaVd3ErxeLSDDx/qG6TM2knSx77eMMogrBkpgOEfP
         g59A==
X-Gm-Message-State: AGi0PubuWccisoht8tVAnDcuutfwtzaZB877aV8cAN6PNFS1+8Ooo4Kj
        xgCyngF460hThoitTUgf243E/xlMqwa9Hfb1TdE=
X-Google-Smtp-Source: APiQypKczQT7kzoOYs/Mh9S4j5YLkIasn1bTXadpyGxqo46s86e1uAvg0zS88L3BSEq5kqm7cNkLnPila3WKYiCBxqs=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4072641qtn.141.1588959717497;
 Fri, 08 May 2020 10:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-15-jakub@cloudflare.com>
In-Reply-To: <20200506125514.1020829-15-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 10:41:46 -0700
Message-ID: <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 14/17] libbpf: Add support for SK_LOOKUP program type
To:     Jakub Sitnicki <jakub@cloudflare.com>, Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 5:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Make libbpf aware of the newly added program type, and assign it a
> section name.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/lib/bpf/libbpf.c        | 3 +++
>  tools/lib/bpf/libbpf.h        | 2 ++
>  tools/lib/bpf/libbpf.map      | 2 ++
>  tools/lib/bpf/libbpf_probes.c | 1 +
>  4 files changed, 8 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 977add1b73e2..74f4a15dc19e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6524,6 +6524,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
>
>  enum bpf_attach_type
>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
> @@ -6684,6 +6685,8 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
>                                                 BPF_CGROUP_SETSOCKOPT),
>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
> +                                               BPF_SK_LOOKUP),
>  };
>
>  #undef BPF_PROG_SEC_IMPL
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index f1dacecb1619..8373fbacbba3 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -337,6 +337,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
> +LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
>
>  LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
>  LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
> @@ -364,6 +365,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
> +LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);

cc Yonghong, bpf_iter programs should probably have similar
is_xxx/set_xxx functions?..

>
>  /*
>   * No need for __attribute__((packed)), all members of 'bpf_map_def'
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index e03bd4db827e..113ac0a669c2 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -253,6 +253,8 @@ LIBBPF_0.0.8 {
>                 bpf_program__set_attach_target;
>                 bpf_program__set_lsm;
>                 bpf_set_link_xdp_fd_opts;
> +               bpf_program__is_sk_lookup;
> +               bpf_program__set_sk_lookup;
>  } LIBBPF_0.0.7;
>

0.0.8 is sealed, please add them into 0.0.9 map below

>  LIBBPF_0.0.9 {
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 2c92059c0c90..5c6d3e49f254 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -109,6 +109,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>         case BPF_PROG_TYPE_STRUCT_OPS:
>         case BPF_PROG_TYPE_EXT:
>         case BPF_PROG_TYPE_LSM:
> +       case BPF_PROG_TYPE_SK_LOOKUP:
>         default:
>                 break;
>         }
> --
> 2.25.3
>
