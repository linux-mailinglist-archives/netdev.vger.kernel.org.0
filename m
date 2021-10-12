Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3227429C31
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 06:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJLENo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 00:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhJLENn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 00:13:43 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C70AC061570;
        Mon, 11 Oct 2021 21:11:42 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i84so43608819ybc.12;
        Mon, 11 Oct 2021 21:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EzttPnvSBj9TWPQB22etUBHe1lHk1VSkKn9Reb38kBY=;
        b=pblW8aH9whMxuBdAhzUGYKrFUCy7lCdFE27wZxsId/Gq7S6ykgNaOlWhYLcXXJmQt/
         uSPH8BIR36xDYQbAMGwWLrnKQK5VQrU0yvcqfxJqTwhAvL+5I8Gi+cHD0jTGiw1ziT5g
         ZYuSv/TtzpsTVyIXf0t8VpdsArtkn5R/72femKMG2imfP+tznYJJviUzeke5XgD2nnzJ
         gwj1BtO4+Phb1b2hKKCjmV8eqZ7XoGwrATr5ACVq61vIN/w5d2vDAODO6UgFayHrJeZW
         PqGU5+gGIM+Z5rvws9j2IXTYcXpNpfqFauT7gnyKk7a6kch0qgZFlt9Q82z0Hc90JE9p
         USKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EzttPnvSBj9TWPQB22etUBHe1lHk1VSkKn9Reb38kBY=;
        b=D10rqQ8YzfZO0rSrxd53dE8Pny1n/50/f++iFCLGC34F41rYBs0YPgs6PA0fgkH9My
         QsLC9GzPJEvG3jlyLcrQzTx+e+MMKrL+To4qNCJxRzWqhSVAGETn8iTXp1sn1gSYRlpz
         M7HyKITVzUoPTPY0klpLrU9/pooyIMInjzjXurE7nf46NuXinRAw78FPKKPfMgGbqsQc
         TCn+qr1kGjJOj+hcAOXX5wOt1NOtxgx6lcpd89ZY/17D1dPL8Y/34KSd5BYewVPdf2zO
         17SW/jddZhh0XSH/B8mi0TuOTzNBBj+Y3c+jO6hiuhdceSxC4uiLJQvHli8MUirR1tiq
         9alA==
X-Gm-Message-State: AOAM533X7aSzi2bjjSyBVhtvU6aOo+eUqa+jc/4APC/0LXzbTFGNtnDf
        luQnYclYqK1oqrN69j2D3IVzvnvKGruGVMw8x6E=
X-Google-Smtp-Source: ABdhPJwgS22Xnjxu0g/1EeTi3csvNvrQvyy0ap3OdxaOWAk110Rbh2ew7LUjWFUudztXD/lyT7aPZmmEA3fjHDvfUVc=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr24810219ybh.267.1634011901767;
 Mon, 11 Oct 2021 21:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com>
In-Reply-To: <20211011155636.2666408-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Oct 2021 06:11:30 +0200
Message-ID: <CAEf4BzZJg6bcFjkvKR627PMDj6EBy7pSMHYq1T9pyfo5CpjFQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: use func name when pinning programs
 with LIBBPF_STRICT_SEC_NAME
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 5:56 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> We can't use section name anymore because it's not unique
> and pinning objects with multiple programs with the same
> progtype/secname will fail.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Also, patch sets with more than one related patch should come with the
cover letter, please send one on the next revision. Thanks!

>  tools/lib/bpf/libbpf.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ae0889bebe32..0373ca86a54c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -285,7 +285,8 @@ struct bpf_program {
>         size_t sub_insn_off;
>
>         char *name;
> -       /* sec_name with / replaced by _; makes recursive pinning
> +       /* sec_name (or name when using LIBBPF_STRICT_SEC_NAME)
> +        * with / replaced by _; makes recursive pinning
>          * in bpf_object__pin_programs easier
>          */
>         char *pin_name;
> @@ -614,7 +615,11 @@ static char *__bpf_program__pin_name(struct bpf_program *prog)
>  {
>         char *name, *p;
>
> -       name = p = strdup(prog->sec_name);
> +       if (libbpf_mode & LIBBPF_STRICT_SEC_NAME)
> +               name = p = strdup(prog->name);
> +       else
> +               name = p = strdup(prog->sec_name);
> +
>         while ((p = strchr(p, '/')))
>                 *p = '_';
>
> --
> 2.33.0.882.g93a45727a2-goog
>
