Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DB34C007
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfFSRnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:43:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36269 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSRni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:43:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so82273qkl.3;
        Wed, 19 Jun 2019 10:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q0JtMg6VhqJs+xdBOj+B5yb628OP/AHnMJJ6w0rRy8Y=;
        b=dRA0MPSUYUgio2i0/xFlKR6/ytiP2KHIs74EMKP8Y2xu1Lds82bjlV9JEEUxkUL6O6
         vYEjRjuT3d1e3ViIBnLqWS3Kb+seHaICTofRvYvJ0aSGDZSck5to/Dd0nsNpBQPfLgLK
         9S4rAFeHuqNdhaYKAbYmLRW9DWTxQFQFFY0PMXj2O3fT10iCgecEj9NjN2q8LwLc/A1G
         PNcwGOMuCfcKy+5WJG/dpQ2NDXqYUGD0Bnqo5btM36gKkk9tZgg/ntq7TBUkY3GZvTFY
         /bFqHOna8C+99xOh70lgGRDi41OygSgFH7CZ22tuG0ATDRhMyNAkWDzMyiYUhzqBi1ob
         A5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0JtMg6VhqJs+xdBOj+B5yb628OP/AHnMJJ6w0rRy8Y=;
        b=tHKRoiow3XaAsI/2CnvU002kDARDdFhf8xbf9uRwB/ccn+WBv9M10T30YpeSRlynDD
         AH+EtnH8KHErAQy4VAIlRLu/sDQ5KcktKegxeYIAwlWZ2juWKauQfk0g90wqxaHWDDo4
         SooLzOrjsmJaXQaOLDsu2if0bW0omcG+0IcVJBUBtHtbzncbjGJd/Pg+VnBc4rRByKaS
         KXFDBwZqTgJebOfwBN7NUYObqgoJqfos7YoXvLwFShNicdJ7c2+Z1W7V2wMfez/T01AB
         QnV+p7k0DKaaFCP9JRbV4qwkjTPROmktaMfyGKIlfVVU2Uc0dVaDh15XGh8maYHP86X2
         aqDw==
X-Gm-Message-State: APjAAAVKP+3dzDBkdJLlMM2K59Q/s88aczj9F+/xjO7+TAkCqaA+C9up
        j4wG9QYLaqFp/nnD7R1PMzceqNIB7Ge8ig2nb0o=
X-Google-Smtp-Source: APXvYqwv177/wAgsGwcVsblmEBoK8ORUDAhFxShro/2cIePx9XNclQuxtyZ0nCZnfOGmgxp7ZE8fFI2FJBaOBWybgDo=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr99959130qkn.247.1560966217540;
 Wed, 19 Jun 2019 10:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190619160207.GA26960@embeddedor>
In-Reply-To: <20190619160207.GA26960@embeddedor>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jun 2019 10:43:26 -0700
Message-ID: <CAEf4BzY+1-G4Kn1NNEX7iy51rcC4-yV-XWjAdaRTMH-6i-LB3g@mail.gmail.com>
Subject: Re: [PATCH][bpf] bpf: verifier: add break statement in switch
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 9:02 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> Notice that in this case, it's much clearer to explicitly add a break
> rather than letting the code to fall through. It also avoid potential
> future fall-through warnings[1].
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> [1] https://lore.kernel.org/patchwork/patch/1087056/
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/verifier.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d2c8a6677ac4..0acf7c569ec6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5365,6 +5365,7 @@ static int check_return_code(struct bpf_verifier_env *env)
>                 if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
>                     env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
>                         range = tnum_range(1, 1);
> +               break;
>         case BPF_PROG_TYPE_CGROUP_SKB:
>         case BPF_PROG_TYPE_CGROUP_SOCK:
>         case BPF_PROG_TYPE_SOCK_OPS:
> --
> 2.21.0
>
