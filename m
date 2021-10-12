Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A803429C2C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 06:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhJLEKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 00:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLEKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 00:10:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3281DC061570;
        Mon, 11 Oct 2021 21:08:06 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id a7so43712063yba.6;
        Mon, 11 Oct 2021 21:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HFzEvrCR7W4GcboQU2raob0U4VgQiJqU9za3j/8KhVg=;
        b=LPK7mUn8kvDGU3TQL5FSnlNOnCYLp+7kvgCsUanQxGyveJwNmNku+7fYtugRONRHQ4
         TY3RI7DG/rVLnhgnSJlARAeXThLcpQhJ7mxCR1gMR5wKy59pS10bFVGqi6pHOc2NLvh8
         jFXU3z6ckpFCHtOKzaFqkHmCrclb4CyuUm/bmjFIvvd6EFMroYSLA57hwwtX2fB0McfI
         DlEMCWYMmDHw8DO0kmB9uGwYZsPU8Qrnhq7yYPpZa3pgpcLaJMCjLcc8z2dNOP5vYvDa
         hbGOVqKzZ/AKdZOtkTY6vFVnVKENKICr/IbZzbeuq0kEfM36yKYG9hw2M2NHjJI+Wo9X
         eLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HFzEvrCR7W4GcboQU2raob0U4VgQiJqU9za3j/8KhVg=;
        b=jCDGUpCbADHJ4Kz8avfdIlw1Y4YJopBZxgYC6qFT9V1jvFY6JKe//hC4RSl4HMVZRN
         tmyZSA9WXfoNbcEinqiuYcsyVC01evVLp4dJA+bE+bBxVQeARtLx1EsCokeeL6UaUOnG
         Av4NCvxfZt2W+qiCPYMKUV4gkSEAGPPrAPO8Zt5ami03TDIvDOkHSATGTiUObtlyaWcX
         EkXEQEzv/vG7pWvSmqA/PFXAqcC2q8ckUS2FSs7Drzct4975LOAgc3mSI6CbUGn5UZat
         bpwHXENKYF1e6qvsj8yoQhs/y80tnVH2HjzvIvhkCOy7dSsA2li5H1m40fYyMz1u7c7E
         kW+w==
X-Gm-Message-State: AOAM533HtE3njs1oghN1oGvym72M/iWygRmCgk83TzGTlIEyiRjresCe
        rCvJF2D42EYuekeV5YugvseeTciZRB8NqfSBG0XYfSXtgPvSvT6lVwY=
X-Google-Smtp-Source: ABdhPJxJOp3xq98y47f2ZxVq0+INR/tpJWQUzDh2+doKxTPpHOIE0V0dHuKgabcTgDoJJyPWiKOa6SC/FGVlOaFv4Eo=
X-Received: by 2002:a25:5606:: with SMTP id k6mr25572060ybb.51.1634011685012;
 Mon, 11 Oct 2021 21:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com>
In-Reply-To: <20211011155636.2666408-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Oct 2021 06:07:54 +0200
Message-ID: <CAEf4BzYbRGuLyUN+9APj0TiuEwWK=3qcT4dMQ0=uo+gAR5=zMw@mail.gmail.com>
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

Seems like you've signed up yourself for [0]? ;)

Please use the following syntax so that when this gets eventually
synced to Github, the issue will be auto-closed.

  [0] Closes: https://github.com/libbpf/libbpf/issues/273

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

let's remove specific mention of sec_name from this comment. Please
add clarification to LIBBPF_STRICT_SEC_NAME comment instead,
mentioning that it also changes the behavior of pinning.

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

nit: instead of duplicating this double assignment, you can just do `p
= name;` right before the below loop. It will be a bit cleaner.

> +
>         while ((p = strchr(p, '/')))
>                 *p = '_';
>
> --
> 2.33.0.882.g93a45727a2-goog
>
