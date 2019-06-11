Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9B43D525
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406868AbfFKSIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:08:09 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43488 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406829AbfFKSIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:08:09 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so2442345qtj.10;
        Tue, 11 Jun 2019 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sDDXeskfmkhVSOYqH42jOLWDA0Vpzj5152gUAPbopKc=;
        b=gjAPQJQh5JYwgRA+PLgGch9BqhXKwD4pmlQFBzQr3EHgrz4jxWStM/Y7awrI1CUftG
         Q4m1ApltFabUdZJ0KRghLP8AFhPzODkHPQveT/xxQZQM+QEzkrLZmaltafHRgYzyaN0Y
         mTx67w113DmqbDylrQCFSSfjgbvytuU5ZMiihubCLlXR4+yw48u+DmsRbQGhIYPVMwhM
         La+vPFdwH+21lP1PAJ954YB58DnFtt0UlbvZdxAZTsz4i2CT5xl0M14PkmRabLaVIuVn
         pTgmipqwS+ibZ6aFKAIpTgfYI60dUE0cgrmgV4hrGfU4rlpA4zixbwMUbp3AXNH1hAnE
         PWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sDDXeskfmkhVSOYqH42jOLWDA0Vpzj5152gUAPbopKc=;
        b=CoM1hbSUlMaXJNn2kLxhtPhrUmOaBxCQ7vGPslf9B8LvI8c4hzFo7atkJd0PpEU08E
         TXtuv4VwaXBkBH83gB+jxxTl5Mq8DlXqP3t6prySydvIbCv9fTzHKWRVUdZkEwNXQUp5
         FzfqYp+cHTp3iczBuSZu9SrJErC/7WNnf1TVZLhU1XeaP0AUA3F4SP4SWf3RfT2PMz8a
         TLW/Y3Qnq3pRGFgx9q+4cHHegjadhVHdJIr/a/OLKNwCmDauFLcz9DLQL2Am5WI8VQBo
         ayHWXKE+orQaBc9cNdd6YZPD7oWpMOx/km6Z4IOXWVEpVLKFZzBuw3PQeNBINkkrL7PH
         MXVw==
X-Gm-Message-State: APjAAAWI4fvO5MGtljK9DOe9nhnSXenpe1lWs3z2x0HoW2Xu9o280jez
        NRCJB/qyLFVqWgaUgBUz9y7e4WBPcyqQjdWKyg8=
X-Google-Smtp-Source: APXvYqwOYnk52r/0lGOolOj7HyR0unUh3LoklSIswrk+LqydWlPNKuTeAXG8iyCxlGTqg36QPbC3khPydoiviuERjI4=
X-Received: by 2002:ac8:1087:: with SMTP id a7mr51876992qtj.141.1560276487946;
 Tue, 11 Jun 2019 11:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190611132811.GA27212@embeddedor> <CAEf4BzaG=cQWAVNNj0hy4Ui7mHzXZgxs8J3rKbxjjVdEGdNkvA@mail.gmail.com>
 <4acbc6b9-e2aa-02d3-0e99-f641b67a3da3@embeddedor.com> <07450b27-5c09-2156-e6ee-921fef174c78@embeddedor.com>
In-Reply-To: <07450b27-5c09-2156-e6ee-921fef174c78@embeddedor.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Jun 2019 11:07:56 -0700
Message-ID: <CAEf4BzawBrzyA60fS2PU_Kdg1EgP2ufSc8_BBx3JUZXqrFx0fg@mail.gmail.com>
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

On Tue, Jun 11, 2019 at 10:41 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
>
>
> On 6/11/19 12:27 PM, Gustavo A. R. Silva wrote:
> >
> >
> > On 6/11/19 12:22 PM, Andrii Nakryiko wrote:
> >> On Tue, Jun 11, 2019 at 7:05 AM Gustavo A. R. Silva
> >> <gustavo@embeddedor.com> wrote:
> >>>
> >>> In preparation to enabling -Wimplicit-fallthrough, this patch silence=
s
> >>> the following warning:
> >>
> >> Your patch doesn't apply cleanly to neither bpf nor bpf-next tree.
> >> Could you please rebase and re-submit? Please also include which tree
> >> (probably bpf-next) you are designating this patch to in subject
> >> prefix.
> >>
> >
> > This patch applies cleanly to linux-next (tag next-20190611).
> >
>
> It seems that this commit hasn't been merged into bpf/bpf-next yet:
>
> 983695fa676568fc0fe5ddd995c7267aabc24632
>
> --
> Gustavo
>
> >>>
> >>> kernel/bpf/verifier.c: In function =E2=80=98check_return_code=E2=80=
=99:
> >>> kernel/bpf/verifier.c:5509:6: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]
> >>>    if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP4_RECVMSG=
 ||
> >>>       ^
> >>> kernel/bpf/verifier.c:5512:2: note: here
> >>>   case BPF_PROG_TYPE_CGROUP_SKB:
> >>>   ^~~~
> >>>
> >>> Warning level 3 was used: -Wimplicit-fallthrough=3D3
> >>>
> >>> Notice that it's much clearer to explicitly add breaks in each case
> >>> (that actually contains some code), rather than letting the code to
> >>> fall through.
> >>>
> >>> This patch is part of the ongoing efforts to enable
> >>> -Wimplicit-fallthrough.
> >>>
> >>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> >>> ---
> >>>  kernel/bpf/verifier.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>> index 1e9d10b32984..e9fc28991548 100644
> >>> --- a/kernel/bpf/verifier.c
> >>> +++ b/kernel/bpf/verifier.c
> >>> @@ -5509,11 +5509,13 @@ static int check_return_code(struct bpf_verif=
ier_env *env)
> >>>                 if (env->prog->expected_attach_type =3D=3D BPF_CGROUP=
_UDP4_RECVMSG ||
> >>>                     env->prog->expected_attach_type =3D=3D BPF_CGROUP=
_UDP6_RECVMSG)
> >>>                         range =3D tnum_range(1, 1);
> >>> +               break;

So this part is in bpf tree only...

> >>>         case BPF_PROG_TYPE_CGROUP_SKB:
> >>>                 if (env->prog->expected_attach_type =3D=3D BPF_CGROUP=
_INET_EGRESS) {
> >>>                         range =3D tnum_range(0, 3);
> >>>                         enforce_attach_type_range =3D tnum_range(2, 3=
);
> >>>                 }
> >>> +               break;

... while this one is in bpf-next only.

Maybe just split this into two separate patches, one targeting bpf
tree and another for bpf-next tree? Unless you are willing to wait
till bpf is merged into bpf-next.

> >>>         case BPF_PROG_TYPE_CGROUP_SOCK:
> >>>         case BPF_PROG_TYPE_SOCK_OPS:
> >>>         case BPF_PROG_TYPE_CGROUP_DEVICE:
> >>> --
> >>> 2.21.0
> >>>
