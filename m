Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7E643527A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhJTSRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhJTSRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:17:13 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FB6C06161C;
        Wed, 20 Oct 2021 11:14:59 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id t127so20018042ybf.13;
        Wed, 20 Oct 2021 11:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7/cVoDiFjayaQSkYQo+YyxTX5Kj53yItR5KqZ+dY+A=;
        b=NDilO4BskZrB9SWFQJd8P/4cGZI4gzvLyrs/TGsFnwt6/70F2TlzN3OHphGfBsy4Qo
         7+jq0eXW7efSlfNqV3uKOcURMj0423V2pUnybHjK3Ya5hMjL9qkIgcmmAUYQOyfuE8N7
         FLx64HnsJUZVwAnm4RMMx4xvOj29ZpYMoswf6MhYa6JRXnFk9ZaSt65jPp8H4J4Ll2Tt
         S5MSKYy1skTaNzgSK4q3zh8d3i0nOoSo/UbfLlrHmLfcD6ki4JCgqizMTA/yV+fwELAF
         ms+sijUo/e3SXe1EOQpH/W7j49/q2K7plFDYPI1He8Okybzeq8Nx8C9su9My8CrmAASb
         UqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7/cVoDiFjayaQSkYQo+YyxTX5Kj53yItR5KqZ+dY+A=;
        b=5zIyHahPfDADbs3BUJmT+STWi1dLpj1AMbrXjzs6rOPj3VLCnWQ5HldBL7mxoB36wp
         Ia4MalywBv91SrXuvSEKv5qkUsazhvNi1Jn167sZSHRDcVtMdM8BnJHW3Z3azBRdhH5N
         vMRpXVtkjCJPXsLjUDp5DeMTOrWGdHGyaD+1LD3lShoClH1ZKQP4UQ7/VDSqpEk/4ush
         U1rfABg/NmvmEU55SxksYX8MbQCD8xJg8MVGObLrsQ754h+7hiyFCxj3BFUma19ARpZJ
         Z7T5rOKBh1HxaiARdqHH6QwfrD8KLGAQycneFGYojxC8aGAVklF5SmypADsBd/kkVcyk
         k7dg==
X-Gm-Message-State: AOAM530pxiclSChDHvNgffy4bLNBuXvP5PJO9+ubZ5KloQQmc/Pv2y3H
        B0YEZkRIsiPOzhm/oWpa5dJQYfyRxWb+SJ6vhpA=
X-Google-Smtp-Source: ABdhPJwzZVDWkpX2FL536R0UeWaGWGrrVTgf3x7Lg0P2elSzY0G515FtAYG6kSljWBPRrD8guvPDh6UcgmTLeX10RAA=
X-Received: by 2002:a25:918e:: with SMTP id w14mr623639ybl.225.1634753698299;
 Wed, 20 Oct 2021 11:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com> <20211012161544.660286-2-sdf@google.com>
In-Reply-To: <20211012161544.660286-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 11:14:47 -0700
Message-ID: <CAEf4BzaL1het=ihyMKqhj26tUB6A8s3hx7evaspn1bvn6qZ5og@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] libbpf: use func name when pinning
 programs with LIBBPF_STRICT_SEC_NAME
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 9:15 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> We can't use section name anymore because they are not unique
> and pinning objects with multiple programs with the same
> progtype/secname will fail.
>
> Closes: https://github.com/libbpf/libbpf/issues/273
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ae0889bebe32..d1646b32188f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -285,7 +285,7 @@ struct bpf_program {
>         size_t sub_insn_off;
>
>         char *name;
> -       /* sec_name with / replaced by _; makes recursive pinning
> +       /* name with / replaced by _; makes recursive pinning
>          * in bpf_object__pin_programs easier
>          */
>         char *pin_name;
> @@ -614,7 +614,13 @@ static char *__bpf_program__pin_name(struct bpf_program *prog)
>  {
>         char *name, *p;
>
> -       name = p = strdup(prog->sec_name);
> +       if (libbpf_mode & LIBBPF_STRICT_SEC_NAME)
> +               name = strdup(prog->name);
> +       else
> +               name = strdup(prog->sec_name);
> +
> +       p = name;
> +
>         while ((p = strchr(p, '/')))

I bet this will SIGSEGV if p is NULL? Can you please add a check and Fixes: tag?

>                 *p = '_';
>
> --
> 2.33.0.882.g93a45727a2-goog
>
