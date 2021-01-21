Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C394F2FE0B8
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbhAUEbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhAUEOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:14:24 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C2C061757;
        Wed, 20 Jan 2021 20:13:41 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k4so806133ybp.6;
        Wed, 20 Jan 2021 20:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qdYGbaNQ6RXEEqSgvnErn9aTL2ruB523HmhLn4769P0=;
        b=Y/wjnmDnqQEicOrIEn5igWesvc6VvkLe6H9gn0MNXrK8Od0OitS4GowYF4fZBPPYQU
         aw0yU20PJVRA8tRoevm8VV1ZbEtrxk6Zy07mJdq9//Rq1/ub6dOFDxCxo3hEgCA4hOte
         KP/8aLcT9f5NbXSKYIXEIe31sGI/yzcYnesDXp27vM1RLObprjK5syz6KZ7mtXQ5GrtF
         XoHnNU+CcQRGdj8I7/F9UDwS9ibTJfJcwFDc5pBC2nn+LtJQ8ByNM1w37YKH1Tvqsoo8
         VkRL8yFmGOdzvLdAR+SUHLcEd6aUFTvh3eInfHRyXS7mC6ailuxwU3oTpZOONIV6XwXJ
         umvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qdYGbaNQ6RXEEqSgvnErn9aTL2ruB523HmhLn4769P0=;
        b=a/p+AMFuKBF2yCuOnbaLzuXQdmA6oJ/qPvzOLk8QI1gEc+aMXEZFCVM+T0OTmIkSVa
         vQLO9GyI04l1H63Mq+Y/3YLNDKBo/mwWRSPDT7njmOPhJjPLP1IcP7WR4onJiKkLTGk1
         c/zokrL4UHuUZ1yg4L96HykdnWKg/l7RIAU80vElKfLgslbKvePl2BPjiQOBjRmtkEvR
         RtJyUEdoctoUNwjcr3zWHFC/J+pyK27ydvGBiGaGOjROhC/LeNRs3oJ5uBLWX220Ncrp
         xcCqpt4YJWnP5mGBMlHb4Nm+VfYZLLexPtoRPEI+G7SdLQuXOut9H1sUv3ZDgMQevCDr
         7b9g==
X-Gm-Message-State: AOAM530gO+WhPdJZQAPH8APCPWKX5ZCNN98XIbhRcN5dYTyt0xIyj71R
        U4iLBUYV+Ex06jybOMFivy3+90gdhPjIY70ldRQ=
X-Google-Smtp-Source: ABdhPJyw6udgxJBFQX0Vwqra1a/DaIb34pvGjg38qbZt2xv9lkediK7L08qo1hXvj7SN4BasIaTVpqghIM8fjo3C5sQ=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr3828051yba.403.1611202420666;
 Wed, 20 Jan 2021 20:13:40 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com> <1610921764-7526-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1610921764-7526-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Jan 2021 20:13:29 -0800
Message-ID: <CAEf4BzYZNUsdLH=fVqO_zXh2gwK6g325pQ7UeyH1NTK8kxSFmA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] libbpf: make skip_mods_and_typedefs
 available internally in libbpf
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 2:20 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> btf_dump.c will need it for type-based data display.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Given we make it into an internal API, let's call it
btf_skip_mods_and_typedefs()? Otherwise all ok.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c          | 4 +---
>  tools/lib/bpf/libbpf_internal.h | 2 ++
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2abbc38..4ef84e1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -73,8 +73,6 @@
>  #define __printf(a, b) __attribute__((format(printf, a, b)))
>
>  static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
> -static const struct btf_type *
> -skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
>
>  static int __base_pr(enum libbpf_print_level level, const char *format,
>                      va_list args)
> @@ -1885,7 +1883,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
>         return 0;
>  }
>
> -static const struct btf_type *
> +const struct btf_type *
>  skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
>  {
>         const struct btf_type *t = btf__type_by_id(btf, id);
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 969d0ac..c25d2df 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -108,6 +108,8 @@ static inline void *libbpf_reallocarray(void *ptr, size_t nmemb, size_t size)
>  void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
>                   size_t cur_cnt, size_t max_cnt, size_t add_cnt);
>  int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
> +const struct btf_type *skip_mods_and_typedefs(const struct btf *btf, __u32 id,
> +                                             __u32 *res_id);
>
>  static inline bool libbpf_validate_opts(const char *opts,
>                                         size_t opts_sz, size_t user_sz,
> --
> 1.8.3.1
>
