Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53152F325D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbhALN6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733017AbhALN62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:58:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D23323110
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610459867;
        bh=32mjZmvr99YZ2ZjlfD7HsnznEEvDSHHruXjw3VsZ0VQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W2NtxHVPH8MzbUWyPsOnJp3puvcXOx/dsEqpHV97DsvlSIwoKNIHOYUZx1izqavul
         UfUL8ofomV16jEG6JPaOUbgt6l/yyI8jZz/DTyJUcABQ0XFOpMubWffKaR5ULxv57Q
         Kw1LTHsLq7x6kerp65fFYGN3cGcqc1ocXHUkQHI1fVUv6Hm1WPDrn/+mLYBf4JrC+G
         LgU6rqWmBntOgwyK//CNFQgE1sr2HyqHG6YfLAKl5SIBOyfQUfb+qxYH0jqD/s7UK+
         tYSOyqbOIufD165R4RjS0WTUmEOJfE5p9UIGDC1IBYY1A3vPCKEDo5NBVkUNh2uwY6
         ep46rgfnvLGCA==
Received: by mail-lf1-f52.google.com with SMTP id o10so3430426lfl.13
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 05:57:47 -0800 (PST)
X-Gm-Message-State: AOAM530ep9TzG1a7CqpMXddd7HKLtinxf8UFo43LW4DF1LxdcqS22utg
        o62d+6yFuMYGkuarT5ppfpO4hvZhMwWmV9ayoSb1zg==
X-Google-Smtp-Source: ABdhPJxn242iE48rbeSlKPBc7+QElLLFF9RgADzJ2HR6gzm3TEa7ZLEbUM/7xxEqwAfgWRGWf/uGGERze61AzLnI7yo=
X-Received: by 2002:a19:810:: with SMTP id 16mr2312202lfi.233.1610459865578;
 Tue, 12 Jan 2021 05:57:45 -0800 (PST)
MIME-Version: 1.0
References: <20210112091403.10458-1-gilad.reti@gmail.com>
In-Reply-To: <20210112091403.10458-1-gilad.reti@gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 12 Jan 2021 14:57:34 +0100
X-Gmail-Original-Message-ID: <CACYkzJ6DJ0NEm+qTBpMSJNFfgNHBFPZc=Ytj4w+4hY=Co4=0yg@mail.gmail.com>
Message-ID: <CACYkzJ6DJ0NEm+qTBpMSJNFfgNHBFPZc=Ytj4w+4hY=Co4=0yg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
To:     Gilad Reti <gilad.reti@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:14 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>
> Add support for pointer to mem register spilling, to allow the verifier
> to track pointer to valid memory addresses. Such pointers are returned

nit: pointers

> for example by a successful call of the bpf_ringbuf_reserve helper.
>
> This patch was suggested as a solution by Yonghong Song.

You can use the "Suggested-by:" tag for this.

>
> The patch was partially contibuted by CyberArk Software, Inc.

nit: typo *contributed

Also, I was wondering if "partially" here means someone collaborated with you
on the patch? And, in that case:

"Co-developed-by:" would be a better tag here.

Acked-by: KP Singh <kpsingh@kernel.org>


>
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
> support for it")
> Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> ---
>  kernel/bpf/verifier.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 17270b8404f1..36af69fac591 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
>         case PTR_TO_RDWR_BUF:
>         case PTR_TO_RDWR_BUF_OR_NULL:
>         case PTR_TO_PERCPU_BTF_ID:
> +       case PTR_TO_MEM:
> +       case PTR_TO_MEM_OR_NULL:
>                 return true;
>         default:
>                 return false;
> --
> 2.27.0
>
