Return-Path: <netdev+bounces-6494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C9E716A7F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40A628120C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EF81F952;
	Tue, 30 May 2023 17:11:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168AD1F93B;
	Tue, 30 May 2023 17:11:33 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9082FF;
	Tue, 30 May 2023 10:11:00 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-9700219be87so862527066b.1;
        Tue, 30 May 2023 10:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685466659; x=1688058659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5nsi/XodGLWHCeElEU7rHxUb0yXLA6W6QP2vM/fOto=;
        b=YveCMHoAQuzG8pj7x3yIEXvIg1y3FP22gPWcqUl2a/p0glE8cMGUNNJD57UtEscrAZ
         MjobJ3FFme4aFHRONWeTSk994npeG0Zp1MtdQxcDfTBIyC/jG+M/QLraH1k8hcNhUb+t
         1ckwfybWxJrPtcTc92gqtKiMSJUs3lP/5voA6D46eeIP0Jy5AvWiNTrahDCzWbC389GV
         0kYVjB4aSfBqswnp0bO/7oixLKLpdaOpsgHccLL7q/Iiep9Oqh8fU8V7s1+vj9GLSIlu
         pnozubr1SJNLM0ftSsOy+tr9woHeUId1TMHBhXe68za187YKfsYIBAT3tAI1LgQ51cJW
         y/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685466659; x=1688058659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5nsi/XodGLWHCeElEU7rHxUb0yXLA6W6QP2vM/fOto=;
        b=c7atOsaJ9U1iTSRuA2NB95/oi67Nm/tpc6tZbiA/Ff5JU19Gk2MySb4OzTCBdWzcCa
         hRXvr0qMsiXyqmLwmUC6vdAKGzPmdrbNwcNUtyytpRBoie79JCbPmcnBsZ7uvAr4GYAJ
         XW011eBktyoiPrqPfPrK5uvkK9FMA5UV+BoVhuFdGnk4ie5oUyXE4qWdw9zChQkTxRQ/
         DN5EHsvN9xRPr7xNstlRP8msvN6uBzihw+KOPvMj1cXyMirtYdnuIV+HgnCCsRpW2W96
         FQuIm67j+ohgkudZE5RE5qB1Co3T9UVPCIR9+h+4K0vhznwEt8/mjIQXIPMTtVwQ/IHE
         qZLA==
X-Gm-Message-State: AC+VfDzjmZMCk90lDqPl/fEhDIaJnd7mFNP4AODOsN+uYdr4aN4PNkI0
	UYEp7R3hdn6sgWfRzSUpL165lmfAvQn/LLqZ6CgWUdNfO09CSA==
X-Google-Smtp-Source: ACHHUZ58EyaAC1yGjTxb2F4IkDgzg8ZRj1IGSaSEXrlKUnKADty4/UAxZnJPK4pITMddrVboyHBHd9sg5eWEJGtDV6Q=
X-Received: by 2002:a17:907:9811:b0:970:2e4d:61ac with SMTP id
 ji17-20020a170907981100b009702e4d61acmr3101715ejc.76.1685466658876; Tue, 30
 May 2023 10:10:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEf4BzZ69YgrQW7DHCJUT_X+GqMq_ZQQPBwopaJJVGFD5=d5Vg@mail.gmail.com>
 <20230526121124.3915-1-fw@strlen.de>
In-Reply-To: <20230526121124.3915-1-fw@strlen.de>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 30 May 2023 10:10:45 -0700
Message-ID: <CAEf4BzYt-gFs3cWfcAsMz9kie_pZNnsCdzXCy0NscK0wU1fCtg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: netfilter: add BPF_NETFILTER bpf_attach_type
To: Florian Westphal <fw@strlen.de>
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 5:11=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Andrii Nakryiko writes:
>
>  And we currently don't have an attach type for NETLINK BPF link.
>  Thankfully it's not too late to add it. I see that link_create() in
>  kernel/bpf/syscall.c just bypasses attach_type check. We shouldn't
>  have done that. Instead we need to add BPF_NETLINK attach type to enum
>  bpf_attach_type. And wire all that properly throughout the kernel and
>  libbpf itself.
>
> This adds BPF_NETFILTER and uses it.  This breaks uabi but this
> wasn't in any non-rc release yet, so it should be fine.
>
> Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER program=
s")
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Link: https://lore.kernel.org/bpf/CAEf4BzZ69YgrQW7DHCJUT_X+GqMq_ZQQPBwopa=
JJVGFD5=3Dd5Vg@mail.gmail.com/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  kernel/bpf/syscall.c           | 4 ++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  tools/lib/bpf/libbpf.c         | 2 +-
>  4 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1bb11a6ee667..c994ff5b157c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1035,6 +1035,7 @@ enum bpf_attach_type {
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
>         BPF_STRUCT_OPS,
> +       BPF_NETFILTER,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 14f39c1e573e..cc1fc2404406 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2433,6 +2433,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog=
_type,
>                 default:
>                         return -EINVAL;
>                 }
> +       case BPF_PROG_TYPE_NETFILTER:
> +               if (expected_attach_type =3D=3D BPF_NETFILTER)
> +                       return 0;
> +               return -EINVAL;
>         case BPF_PROG_TYPE_SYSCALL:
>         case BPF_PROG_TYPE_EXT:
>                 if (expected_attach_type)

You've missed updating link_create() as well, there is a

case BPF_PROG_TYPE_NETFILTER:
    break;

switch case, which should validate that attr->link_create.attach_type
is BPF_NETFILTER


Other than that, it looks good to me, thanks!

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 1bb11a6ee667..c994ff5b157c 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1035,6 +1035,7 @@ enum bpf_attach_type {
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
>         BPF_STRUCT_OPS,
> +       BPF_NETFILTER,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ad1ec893b41b..532a97cf1cc1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8712,7 +8712,7 @@ static const struct bpf_sec_def section_defs[] =3D =
{
>         SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>         SEC_DEF("struct_ops.s+",        STRUCT_OPS, 0, SEC_SLEEPABLE),
>         SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATT=
ACHABLE),
> -       SEC_DEF("netfilter",            NETFILTER, 0, SEC_NONE),
> +       SEC_DEF("netfilter",            NETFILTER, BPF_NETFILTER, SEC_NON=
E),
>  };
>
>  static size_t custom_sec_def_cnt;
> --
> 2.39.3
>

