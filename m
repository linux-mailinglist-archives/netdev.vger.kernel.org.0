Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB83C7A03
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 01:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbhGMXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhGMXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 19:20:24 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BA9C0613DD;
        Tue, 13 Jul 2021 16:17:33 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h9so530892ljm.5;
        Tue, 13 Jul 2021 16:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+L+XSIts3sWSH9rPyJ8d19pb+TeTwIO8ubgRgT2nCB8=;
        b=gE2m7yi4rjuyo6pQCeTQaZDq10FPCiBd+mDVvaE63noY7iJN3j52jfLt6NWEaeGB3C
         NBvrvl/V8cV82vgnh3keaG3KRJ93QuF9TgP8v52f2DXrU77rpfj5lBdzFHXP0zWuTM45
         qVltDwy0+2mHwZRjPLXLr88kfqTag1VhVoI1yPchhfej7pyDLw2qIIGTIX6SUJ8xUrZK
         8O+VbwxeevkuEviuvvsfqjxWrsYOlf1OU9epg2agBzkbqDCwxC0RJOXoPour03eEBP67
         ENxTTebbtRvjNdlaTgL/y7oooSpsIn/+LV9KAzwJ+VlIIXk+kc3BvUHYevE/fHdiJQpx
         U0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+L+XSIts3sWSH9rPyJ8d19pb+TeTwIO8ubgRgT2nCB8=;
        b=EHSjqNf7Vp2iYGmOb6B7t9a9UKus1QmaH9Hq/QprebatHuDixDW5PZgpxvGmSwfmGx
         35W4K3UA3XZODydHkIiGuC5jMOMc4Do5d24Pqk0qVTAXFGd2ZWAg+rg4peO+Xl5Xdq7b
         /yFkLJIDLqsYKrFXdmkfPNVkMeqQaxLICJ+/xuf/Qetmio4/nJX8cTzOdOGHH0yjfdmv
         1Kjo8APaFdAFW1t2xRfvrjRSjsFeCivvi361HvmfaCUhufzhPPidAKN2DVcZA41PZEDq
         kHubkJLpKaXzwQ7dPMEIZah3zkfOUIomKsklvRNPP/0mRdKnHcR/GEZQvRDdd7SpoEeX
         7znA==
X-Gm-Message-State: AOAM530CSp7qCR4+6/yiIatR8wEyABcuu9dMbZ7rZzxvRQ1jsdiyJIqC
        Q9JqgFCW2x2776vuDKi+uH5RwyKqXNWaO1i1bmg=
X-Google-Smtp-Source: ABdhPJzpajTynGgHQnsdxC4op3aEsBjv23iB9LydkL+oUyBZSLQ1EernGefxkAPqy7Yh+/kcdEMoDkGDC/jq1Enz9mo=
X-Received: by 2002:a2e:b80e:: with SMTP id u14mr6330406ljo.204.1626218252221;
 Tue, 13 Jul 2021 16:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210707043811.5349-1-hefengqing@huawei.com> <20210707043811.5349-4-hefengqing@huawei.com>
 <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
 <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com> <CAADnVQJ0Q0dLVs5UM-CyJe90N+KHomccAy-S_LOOARa9nXkXsA@mail.gmail.com>
 <bc75c9c5-7479-5021-58ea-ed8cf53fb331@huawei.com> <CAADnVQJ2DnoC07XLki_=xPti7V=wH153tQb1bowP+xdLwn580w@mail.gmail.com>
 <21d8cd9e-487e-411f-1cfd-67cebc86b221@huawei.com>
In-Reply-To: <21d8cd9e-487e-411f-1cfd-67cebc86b221@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Jul 2021 16:17:20 -0700
Message-ID: <CAADnVQ+XGGaXfte6aDdEp6euYckGtyP6S+VDUe4JusUz7xDLLg@mail.gmail.com>
Subject: Re: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
To:     He Fengqing <hefengqing@huawei.com>
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 7:17 PM He Fengqing <hefengqing@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2021/7/9 23:12, Alexei Starovoitov =E5=86=99=E9=81=93:
> > On Fri, Jul 9, 2021 at 4:11 AM He Fengqing <hefengqing@huawei.com> wrot=
e:
> >>
> >>
> >>
> >> =E5=9C=A8 2021/7/8 11:09, Alexei Starovoitov =E5=86=99=E9=81=93:
> >>> On Wed, Jul 7, 2021 at 8:00 PM He Fengqing <hefengqing@huawei.com> wr=
ote:
> >>>>
> >>>> Ok, I will change this in next version.
> >>>
> >>> before you spam the list with the next version
> >>> please explain why any of these changes are needed?
> >>> I don't see an explanation in the patches and I don't see a bug in th=
e code.
> >>> Did you check what is the prog clone ?
> >>> When is it constructed? Why verifier has anything to do with it?
> >>> .
> >>>
> >>
> >>
> >> I'm sorry, I didn't describe these errors clearly.
> >>
> >> bpf_check(bpf_verifier_env)
> >>       |
> >>       |->do_misc_fixups(env)
> >>       |    |
> >>       |    |->bpf_patch_insn_data(env)
> >>       |    |    |
> >>       |    |    |->bpf_patch_insn_single(env->prog)
> >>       |    |    |    |
> >>       |    |    |    |->bpf_prog_realloc(env->prog)
> >>       |    |    |    |    |
> >>       |    |    |    |    |->construct new_prog
> >>       |    |    |    |    |    free old_prog(env->prog)
> >>       |    |    |    |    |
> >>       |    |    |    |    |->return new_prog;
> >>       |    |    |    |
> >>       |    |    |    |->return new_prog;
> >>       |    |    |
> >>       |    |    |->adjust_insn_aux_data
> >>       |    |    |    |
> >>       |    |    |    |->return ENOMEM;
> >>       |    |    |
> >>       |    |    |->return NULL;
> >>       |    |
> >>       |    |->return ENOMEM;
> >>
> >> bpf_verifier_env->prog had been freed in bpf_prog_realloc function.
> >>
> >>
> >> There are two errors here, the first is memleak in the
> >> bpf_patch_insn_data function, and the second is use after free in the
> >> bpf_check function.
> >>
> >> memleak in bpf_patch_insn_data:
> >>
> >> Look at the call chain above, if adjust_insn_aux_data function return
> >> ENOMEM, bpf_patch_insn_data will return NULL, but we do not free the
> >> new_prog.
> >>
> >> So in the patch 2, before bpf_patch_insn_data return NULL, we free the
> >> new_prog.
> >>
> >> use after free in bpf_check:
> >>
> >> If bpf_patch_insn_data function return NULL, we will not assign new_pr=
og
> >> to the bpf_verifier_env->prog, but bpf_verifier_env->prog has been fre=
ed
> >> in the bpf_prog_realloc function. Then in bpf_check function, we will
> >> use bpf_verifier_env->prog after do_misc_fixups function.
> >>
> >> In the patch 3, I added a free_old parameter to bpf_prog_realloc, in
> >> this scenario we don't free old_prog. Instead, we free it in the
> >> do_misc_fixups function when bpf_patch_insn_data return a valid new_pr=
og.
> >
> > Thanks for explaining.
> > Why not to make adjust_insn_aux_data() in bpf_patch_insn_data() first t=
hen?
> > Just changing the order will resolve both issues, no?
> > .
> >
> adjust_insn_aux_data() need the new constructed new_prog as an input
> parameter, so we must call bpf_patch_insn_single() before
> adjust_insn_aux_data().

Right. I forgot about insn_has_def32() logic and
commit b325fbca4b13 ("bpf: verifier: mark patched-insn with
sub-register zext flag")
that added that extra parameter.

> But we can make adjust_insn_aux_data() never return ENOMEM. In
> bpf_patch_insn_data(), first we pre-malloc memory for new aux_data, then
> call bpf_patch_insn_single() to constructed the new_prog, at last call
> adjust_insn_aux_data() functin. In this way, adjust_insn_aux_data()
> never fails.
>
> bpf_patch_insn_data(env) {
>         struct bpf_insn_aux_data *new_data =3D vzalloc();
>         struct bpf_prog *new_prog;
>         if (new_data =3D=3D NULL)
>                 return NULL;
>
>         new_prog =3D bpf_patch_insn_single(env->prog);
>         if (new_prog =3D=3D NULL) {
>                 vfree(new_data);
>                 return NULL;
>         }
>
>         adjust_insn_aux_data(new_prog, new_data);
>         return new_prog;
> }
> What do you think about it?

That's a good idea. Let's do that. The new size for vzalloc is easy to comp=
ute.
What should be the commit in the Fixes tag?
commit 8041902dae52 ("bpf: adjust insn_aux_data when patching insns")
right?
4 year old bug then.
I wonder why syzbot with malloc error injection didn't catch it sooner.
