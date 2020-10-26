Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4036D2999A3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394354AbgJZW00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:26:26 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42625 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394247AbgJZW0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:26:23 -0400
Received: by mail-yb1-f196.google.com with SMTP id a12so9017609ybg.9;
        Mon, 26 Oct 2020 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VzKLIOn5ZNMh+ZqIZ5v07+6ceTHcQcV1XTB2DtB+0Ts=;
        b=nQDbuLLq1Djc0WyhCdBgEHdTisZtMaVebC8GnV+hrMP6JI4XeeJVig9a6Zfjsg53yx
         MevxN8yNaidpf2Uekxj0qq4eRVuEPdaZlWpblKVTG8B5TEl/W+iYGxXzN1IqQCXMghGo
         nOW16tmbpqcTwkE22hJLZDw6kiGht34Pj8pM7dsEKaD/J+3WSBs5IlCrBBeupiSxs2cG
         rGR8PXVFG0ofiUYcTp9GfxlUj23WMDhnHAY9hGUOfZSCOLrMHhkPsejM4LK0yUuhc15E
         rEFQNNJMh9c0QgJFFQxz8eH+4nqmUvpL4JBQTxby8Ha2jFCHQ5JZ00iSXCyrWLIO1O/Q
         BC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VzKLIOn5ZNMh+ZqIZ5v07+6ceTHcQcV1XTB2DtB+0Ts=;
        b=roqICu8lh9dXPkhigrt1oHifv/o4fZCJK5VH1VQS2jBdr1dVN6UoAyjTT4EdeRjCoo
         Jex3+6R65ks+g9McYCFCh1Pj1Oa98SHDNd4xauapSkRdYkEfD1rk3Ak+0J1ZupsQOXW8
         ylFmDH36Xu09Fouw5yyT0smJeaxSAauc9lRr8VrWaueW/XOBURf5IxeVsIPf9jJX+H78
         Lyh+gOsUV0uBNFG8OV1vAhthg11vkGj4YroxbLwlyTyqcWFCmzb68GZdd0/4YvMrXf+w
         aLxutr580AMmDw2LZ2pQFeU9Ul+Za8jdFnElKOJ8HBcMafS0QOC9XFgTFOnQ6IRsgB+e
         jUvg==
X-Gm-Message-State: AOAM530xvdJ+SWIpdC40ByvmYKRKXmIpSri+J/X0LZ185LMdxXctDZC5
        GhHmux2Rbn1nBh6PD2sBQHao/4pKJ4i80PoU2HA=
X-Google-Smtp-Source: ABdhPJzRLYCjS2G1lOpTFXy7qNFv9ulEegJsGvKEB3KqUMBxYEQdJ5dyFqKL2xuWt6VfyFFZti/VFYl+McD15eFMlAE=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr23857239ybg.459.1603751182707;
 Mon, 26 Oct 2020 15:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201026210332.3885166-1-arnd@kernel.org>
In-Reply-To: <20201026210332.3885166-1-arnd@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 15:26:11 -0700
Message-ID: <CAEf4BzaKSzEbPStm8EXk4RH417jHieSF3LCazQPXZ6qGskqB6Q@mail.gmail.com>
Subject: Re: [PATCH] bpf: suppress -Wcast-function-type warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 2:03 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> Building with -Wextra shows lots of warnings in the bpf
> code such as
>
> kernel/bpf/verifier.c: In function =E2=80=98jit_subprogs=E2=80=99:
> include/linux/filter.h:345:4: warning: cast between incompatible function=
 types from =E2=80=98unsigned int (*)(const void *, const struct bpf_insn *=
)=E2=80=99 to =E2=80=98u64 (*)(u64,  u64,  u64,  u64,  u64)=E2=80=99 {aka =
=E2=80=98long long unsigned int (*)(long long unsigned int,  long long unsi=
gned int,  long long unsigned int,  long long unsigned int,  long long unsi=
gned int)=E2=80=99} [-Wcast-function-type]
>   345 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
>       |    ^
> kernel/bpf/verifier.c:10706:16: note: in expansion of macro =E2=80=98BPF_=
CAST_CALL=E2=80=99
> 10706 |    insn->imm =3D BPF_CAST_CALL(func[subprog]->bpf_func) -
>       |                ^~~~~~~~~~~~~
>
> This appears to be intentional, so change the cast in a way that
> suppresses the warning.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/filter.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 1b62397bd124..20ba04583eaa 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -342,7 +342,7 @@ static inline bool insn_is_zext(const struct bpf_insn=
 *insn)
>  /* Function call */
>
>  #define BPF_CAST_CALL(x)                                       \
> -               ((u64 (*)(u64, u64, u64, u64, u64))(x))
> +               ((u64 (*)(u64, u64, u64, u64, u64))(uintptr_t)(x))
>
>  #define BPF_EMIT_CALL(FUNC)                                    \
>         ((struct bpf_insn) {                                    \
> --
> 2.27.0
>
