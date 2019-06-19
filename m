Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAC24C010
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSRon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:44:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38904 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSRon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:44:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so5782qtl.5;
        Wed, 19 Jun 2019 10:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Mk2gpbvSHmQwEjW959iYvYo2abn5Y4/qXqp6w2V8J0=;
        b=gvtX42hxSfWy2SM33jI+0MoZMCAFuxtt4RKDRI9SHYkSgljb1sZctxmPVBaE2Rb5/G
         TM9onI+hutgKacaAjVJYxOSxF4SasM9PkMHF3LRsePWWqaM+q656Hyl59MF877EMV/yN
         N7x4ZAkvZ4b0V/606K+J9LIIwNYKg0MQ2XkoduZESUVPFXqF8Va0tb+yWWYttBhAtzZG
         PsN+T5TnPy+WGzh3EfurcuKwyLn/7q/GB+8N9eloQjOSDsPe8sL+lElxGi+wGFgV5ZO9
         QBFrpXf1FYgP7tZRoOebJo96mHq8eiw0dYqe9+KwB5P/v9GEXH6Nd1rDty6OCV4J9wXq
         aFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Mk2gpbvSHmQwEjW959iYvYo2abn5Y4/qXqp6w2V8J0=;
        b=VQoDwDvqCzw3F40L3NSUQI2L3Z4bcCVMyRq49nxPvZaS7klkKqEdIMMtP28fepC3Px
         h/UREtVZJxFtv9M8eeqYX69vmRO+jvA77ssGvcI6vTpzbq3bPkQ0IailrjRC9AlU2g/R
         WxKBCFaiL7pCY4WU9e5k8BbNrShBJbwB3CeQkynmmphy2HXbmJuQaa1PBbIIWhuhRJul
         pDHghDKz3FKXFbZslYphhRcAQ5hRAtLrFegML5wbiOvGHZ9W2w35HhMovmWLLRf79a88
         PHbZXE00QgfX5NFJkNIdx2B8qWNSoK7OdCCUjqG2IxqFsWr9WAgRhDgQirK4v2Nj72aD
         hv8Q==
X-Gm-Message-State: APjAAAU9P9VCSAPhayvNoVLIfm8v2ur7OoYRYUeKxH09/A918ys/UeJJ
        ZPiF8p3eIh6celuqmcQsFYdQwqccnei9skdd1Lc=
X-Google-Smtp-Source: APXvYqw/RaKLGbNTQts/747r2icZVfvuLB7QDhYMj6aIDz+OFx+WMvvbFt9C1mbQ+fM5f6etLAZvbCZMqlWjmrEcr1o=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr18137983qty.141.1560966282085;
 Wed, 19 Jun 2019 10:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190619160708.GA30356@embeddedor>
In-Reply-To: <20190619160708.GA30356@embeddedor>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jun 2019 10:44:30 -0700
Message-ID: <CAEf4BzbVWSd=xVHdbM1R_u_V_HA7DESdF=gL9aH76VC25oq1dg@mail.gmail.com>
Subject: Re: [PATCH][bpf-next] bpf: verifier: add a break statement in switch
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

On Wed, Jun 19, 2019 at 9:07 AM Gustavo A. R. Silva
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
> index 709ce4cef8ba..0b38cc917d21 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6066,6 +6066,7 @@ static int check_return_code(struct bpf_verifier_env *env)
>                         range = tnum_range(0, 3);
>                         enforce_attach_type_range = tnum_range(2, 3);
>                 }
> +               break;
>         case BPF_PROG_TYPE_CGROUP_SOCK:
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>         case BPF_PROG_TYPE_SOCK_OPS:
> --
> 2.21.0
>
