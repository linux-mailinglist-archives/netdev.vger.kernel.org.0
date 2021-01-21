Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CA2FF911
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAUXrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbhAUXrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:47:11 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E02C06174A;
        Thu, 21 Jan 2021 15:46:30 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id r32so3781039ybd.5;
        Thu, 21 Jan 2021 15:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpMfdbp/QHi/ytzjPyr2zuRa1iy9QZdQsvbSjWMfPn0=;
        b=ImzD07q0rMMNphqaNuTURkrKPgUGGOPzUyqByMxBiycXpn4APItqq3XV2y42w3UeiU
         ym6qNVLAjAKgXV/lWrF4xFJQCAmZdjOIB54F877wUiQlw2t+IjGGdpKRb0tmVpJ0f2Vm
         GPnR6A68B2XTZD1Tm8ZkOM1yzxLK+F9NsyzAzjHnHE20t3fybs8xvCBs56kBtlzK4J93
         ZxPuJ3Jcsj6EwJnleyoEhO/F+o7SSFwsfw13HP34hQeEtsZfYNR/CMtXJuZGS1QbXp0f
         kepDPbPxbaqPxuZe07o/UDPk/VeE7OIvKHlCLLXDp4pTBvpLVNmbjf37LWiTitSDG0Wy
         f0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpMfdbp/QHi/ytzjPyr2zuRa1iy9QZdQsvbSjWMfPn0=;
        b=hqFjvSuMnkGIjH85Bwhq3xnTvdc+3EqUbyRBixiEshQmgv1PwcdZsebMkPOMhRnA2D
         Q71PcyGOxs8ExPBsgmgG78W6AoFcYFR3GlGPTavYtuBBKGzOK3wKI87raNfMmwaYt2W8
         vn+W4SUQRZSdnz0DfwsNDKZF1BvV6abguVGuEN/DNyL4pd1FyuOCHa3MxNoNmQM7ZpCR
         LSqJN0wgTM8CtnYIKCUb/pWG0ZkX6nQLPynJp/bnCki7Ju40YD16YnlbnTeRTYKZ0a5r
         okGiWbmn/pk7rrCYkTsyOIcHbdSyfM8X/4GSkbfQf9Epj3o+0JRGuE7WcMPuZOUwtvqo
         Evbg==
X-Gm-Message-State: AOAM533AX2N3S9uLIdf0nlwXDbklKpZuKEXOKDFYLSG4vy6L3yKxCW5r
        euxymhNxYC8m25GvUW6WDYLJ5iO5XnLTmPIjAXw=
X-Google-Smtp-Source: ABdhPJzRWb8qQZWCerw4gTMW+ywyvn+8gOCdM7f8Uv1tCw19HF8Q5PKtS4Fy981uRSqnRWsrKDvIID60gXT7COwti6k=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr2513176yba.403.1611272789347;
 Thu, 21 Jan 2021 15:46:29 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-4-jolsa@kernel.org>
In-Reply-To: <20210121202203.9346-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 15:46:18 -0800
Message-ID: <CAEf4Bzawpqk6iYm5GprLtGy0+muKdcHMkbz32KUX_Yym7k51pA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Use string table index from index
 table if needed
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:26 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for elf object's string
> table index - e_shstrndx.
>
> Call elf_getshdrstrndx to get the proper string table index,
> instead of reading it directly from ELF header.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

I've applied this patch to bpf-next, you don't need to re-send it in
the next version of this patch set.

>  tools/lib/bpf/btf.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 9970a288dda5..d9c10830d749 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -858,6 +858,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>         Elf_Scn *scn = NULL;
>         Elf *elf = NULL;
>         GElf_Ehdr ehdr;
> +       size_t shstrndx;
>
>         if (elf_version(EV_CURRENT) == EV_NONE) {
>                 pr_warn("failed to init libelf for %s\n", path);
> @@ -882,7 +883,14 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>                 pr_warn("failed to get EHDR from %s\n", path);
>                 goto done;
>         }
> -       if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
> +
> +       if (elf_getshdrstrndx(elf, &shstrndx)) {
> +               pr_warn("failed to get section names section index for %s\n",
> +                       path);
> +               goto done;
> +       }
> +
> +       if (!elf_rawdata(elf_getscn(elf, shstrndx), NULL)) {
>                 pr_warn("failed to get e_shstrndx from %s\n", path);
>                 goto done;
>         }
> @@ -897,7 +905,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>                                 idx, path);
>                         goto done;
>                 }
> -               name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
> +               name = elf_strptr(elf, shstrndx, sh.sh_name);
>                 if (!name) {
>                         pr_warn("failed to get section(%d) name from %s\n",
>                                 idx, path);
> --
> 2.27.0
>
