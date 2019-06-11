Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F443D3EA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406081AbfFKRXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:23:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45903 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405821AbfFKRXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:23:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id j19so15454981qtr.12;
        Tue, 11 Jun 2019 10:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fJpMXr+NnksvkRmMWu25nN4h1uzoNawfgvQzE9rHA+8=;
        b=Zd9Ji1wJ06DBu02p3GIu7ib7E14EX5jMOH62nvLOSunxZXxMLMiznLyP0kU76iJnQB
         p+dRUsIY2c3C1/k7JWgXlLt/+aYI5MOGhJuz/s0TwHCHWjhOk684jz2y9CshV0ZpHgZy
         98j9rnURnEjC3du4dRx/IrYg4Ag133+6mZPElkR2s5qzv3IUPG1WxTjLm2ET+yAXCqmS
         bU34IT5yOSJMU9NN/Njn9orHwQwI4eMzdD0wqPZdmJAj4/urbcyazuPCdNJykRYzbCE6
         WAfrs0AJq/rt+7wqzoK1FOr1iPGSH86cd/1EmrYM36EnHUCUKItllk9TfxRvOpEadKkk
         7isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fJpMXr+NnksvkRmMWu25nN4h1uzoNawfgvQzE9rHA+8=;
        b=G9eOjUUF7q9+CDiL5tsQ59+hwgRIIMvdWsFSQhvRr+ZVwXggyn1PRC3s/YQI4EibTW
         mW2xySRjdlORgilOlQlYzzsCbQ66WMS9PKc4Y3plGlu/R2Q8iu1V18EnVxCvQgUwP++0
         qjb6qrX8mC5EO14YQPelAvARrEC0vG7Jwb5UhQc1TUI9Qm/liVZoqhhKQkQ5UuxmEPZo
         M7nUh4cNMjB2UEInIcibkdcDDV8CDh+lgZ0nnN+xWjpsXZfsl0J0gU8ER8T3ezGVzP33
         HV74GTKt+rMSikfpCxeBybTOrSCqIVOsKgvPFA+Hjtcf+5oh1YgJiXcJ/kZinGlu1ykj
         PS2w==
X-Gm-Message-State: APjAAAUZMKHktHXZbtFDuY8G+aavs4oDoIlmZZGEFDPspDnd4WPeVHM/
        bMMwh8yc9BAsNCLHhiQdHcqIoXTgCXwfNMvKh0IovdJG
X-Google-Smtp-Source: APXvYqwZSya4vlvbJFOQgLkCkgG2ELdO+otqiQUeSWQOTT8mHiCyU3QUdJJxB+UqEeJBYy+H1Nowool38e1PJcmzZeM=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr47040577qty.59.1560273785202;
 Tue, 11 Jun 2019 10:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190611132811.GA27212@embeddedor>
In-Reply-To: <20190611132811.GA27212@embeddedor>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Jun 2019 10:22:54 -0700
Message-ID: <CAEf4BzaG=cQWAVNNj0hy4Ui7mHzXZgxs8J3rKbxjjVdEGdNkvA@mail.gmail.com>
Subject: Re: [PATCH] bpf: verifier: avoid fall-through warnings
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 7:05 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> In preparation to enabling -Wimplicit-fallthrough, this patch silences
> the following warning:

Your patch doesn't apply cleanly to neither bpf nor bpf-next tree.
Could you please rebase and re-submit? Please also include which tree
(probably bpf-next) you are designating this patch to in subject
prefix.

>
> kernel/bpf/verifier.c: In function =E2=80=98check_return_code=E2=80=99:
> kernel/bpf/verifier.c:5509:6: warning: this statement may fall through [-=
Wimplicit-fallthrough=3D]
>    if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP4_RECVMSG ||
>       ^
> kernel/bpf/verifier.c:5512:2: note: here
>   case BPF_PROG_TYPE_CGROUP_SKB:
>   ^~~~
>
> Warning level 3 was used: -Wimplicit-fallthrough=3D3
>
> Notice that it's much clearer to explicitly add breaks in each case
> (that actually contains some code), rather than letting the code to
> fall through.
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  kernel/bpf/verifier.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1e9d10b32984..e9fc28991548 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5509,11 +5509,13 @@ static int check_return_code(struct bpf_verifier_=
env *env)
>                 if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP=
4_RECVMSG ||
>                     env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP=
6_RECVMSG)
>                         range =3D tnum_range(1, 1);
> +               break;
>         case BPF_PROG_TYPE_CGROUP_SKB:
>                 if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_INE=
T_EGRESS) {
>                         range =3D tnum_range(0, 3);
>                         enforce_attach_type_range =3D tnum_range(2, 3);
>                 }
> +               break;
>         case BPF_PROG_TYPE_CGROUP_SOCK:
>         case BPF_PROG_TYPE_SOCK_OPS:
>         case BPF_PROG_TYPE_CGROUP_DEVICE:
> --
> 2.21.0
>
