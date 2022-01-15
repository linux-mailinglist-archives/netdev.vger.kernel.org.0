Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA948F443
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiAOCFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiAOCFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:05:06 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41077C061574;
        Fri, 14 Jan 2022 18:05:06 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id p7so14584216iod.2;
        Fri, 14 Jan 2022 18:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZYEgGWK5aqV6ui8C+bUI0fg4LYZ6vxym7ajOf760s0A=;
        b=WCb8XwZZRNt2c5GGuJLkpm7G/CuZUD65xQ35jmLB5rUvgvi8WWxJHFEzGm8CUcjaUH
         k/e3H8NVAvTiLJ4TD6p4VKii0ex0o/EqPyyGUV8X/Y1RI1xnlB7wd4Xe1f228ZAB7OJc
         ROXo/ARQn4FSUvQieoGP1mDWBkyn1pryI95Bk4iWMnp1vlsEgxwxmpmXiDrKqefbyxB7
         Bk0H6MzMkgZoKc6TOsCXJytE8FPxf09HboRwg4Vjw/YzLlSVbPlHIlZwDpCWV+6/4H3r
         9pOqGU72HG/ghs7X8Cmefx5oi3ImAOilWZ1LYOKJhpugdBqtnFnAdgnqXsp/OvZLL6w3
         yREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZYEgGWK5aqV6ui8C+bUI0fg4LYZ6vxym7ajOf760s0A=;
        b=DN2R6mlXf5iJGSL3ih1qDzyjkVZu3vGQMz2pljKs7syFHqENGhyU24iqJDvvThuZ0n
         Mf1eUnEZhehL627WZ68wK4fTpe+8sc/pk70+DhvLG02RlxHRDBpMOiLjvLtpMJgvpEJF
         s3BIkb2BdTq+mvU1lracyAfV8L+b7h3U2voMFlrsBiH6mCmuGn6/QwnemRHJEXVXqCFA
         +/wAmInD9fCm1t/nRYWmPhQ7FiND/Y7OuhwS7pqLD/Rb/jjaEWOJ4+gcrIQ+yvHteC3w
         Kz06Zddz11aPqzFN8lOgvSQs6SKV3OPVJqRT6HgmMDdG1L6ckvJvgkuzBbiS6TEtY+lT
         OazQ==
X-Gm-Message-State: AOAM532Quhamar3A1vVeBVDn9VvtaFDRHwGJXmoKIb2wHTt7x4oPqX5w
        +8gMnwNe9od0E/LFJ9uIZ+/MdRQn7+u5qSlz2a0=
X-Google-Smtp-Source: ABdhPJxRuqLaUyEprVwky0EHxhYDxDgGsSb1qmxoqVwlHMd3JUY4SElJlBZ68pkaVgwmDLz0M5zfDJcQPq1ZG9iLkxQ=
X-Received: by 2002:a05:6638:2a7:: with SMTP id d7mr5202985jaq.93.1642212305553;
 Fri, 14 Jan 2022 18:05:05 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-3-mauricio@kinvolk.io>
In-Reply-To: <20220112142709.102423-3-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 18:04:54 -0800
Message-ID: <CAEf4BzaKakFkth+3ONF77VkEgTVgqS-Y=cUo03Drty1iVe7TPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/8] libbpf: Implement changes needed for
 BTFGen in bpftool
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This commit extends libbpf with the features that are needed to
> implement BTFGen:
>
> - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> to handle candidates cache.
> - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> candidates list.
> - Expose bpf_core_calc_relo_insn() to bpftool.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/Makefile          |  2 +-
>  tools/lib/bpf/libbpf.c          | 43 +++++++++++++++++++++------------
>  tools/lib/bpf/libbpf_internal.h | 12 +++++++++
>  3 files changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index f947b61b2107..dba019ee2832 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -239,7 +239,7 @@ install_lib: all_cmd
>
>  SRC_HDRS :=3D bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h=
      \
>             bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h     =
    \
> -           skel_internal.h libbpf_version.h
> +           skel_internal.h libbpf_version.h relo_core.h libbpf_internal.=
h

this is the list of public API headers, this is not the right place,
as Quentin pointed out

>  GEN_HDRS :=3D $(BPF_GENERATED)
>
>  INSTALL_PFX :=3D $(DESTDIR)$(prefix)/include/bpf
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4959c03a46f4..344b8b8e8a50 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5185,18 +5185,18 @@ size_t bpf_core_essential_name_len(const char *na=
me)
>         return n;
>  }
>
> -static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> +void bpf_core_free_cands(struct bpf_core_cand_list *cands)
>  {
>         free(cands->cands);
>         free(cands);
>  }
>
> -static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> -                             size_t local_essent_len,
> -                             const struct btf *targ_btf,
> -                             const char *targ_btf_name,
> -                             int targ_start_id,
> -                             struct bpf_core_cand_list *cands)
> +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> +                      size_t local_essent_len,
> +                      const struct btf *targ_btf,
> +                      const char *targ_btf_name,
> +                      int targ_start_id,
> +                      struct bpf_core_cand_list *cands)
>  {
>         struct bpf_core_cand *new_cands, *cand;
>         const struct btf_type *t, *local_t;
> @@ -5567,6 +5567,24 @@ static int bpf_core_resolve_relo(struct bpf_progra=
m *prog,
>                                        targ_res);
>  }
>
> +struct hashmap *bpf_core_create_cand_cache(void)
> +{
> +       return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> +}
> +
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache)
> +{
> +       struct hashmap_entry *entry;
> +       int i;
> +
> +       if (!IS_ERR_OR_NULL(cand_cache)) {

with separate function for clean up, it's nicer to invert the if
condition and exit early to reduce nesting


> +               hashmap__for_each_entry(cand_cache, entry, i) {
> +                       bpf_core_free_cands(entry->value);
> +               }
> +               hashmap__free(cand_cache);
> +       }
> +}
> +

[...]
