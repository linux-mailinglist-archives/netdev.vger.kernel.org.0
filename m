Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1DF3C26A9
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhGIPPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhGIPPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:15:54 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA56C0613DD;
        Fri,  9 Jul 2021 08:13:10 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id q18so23919295lfc.7;
        Fri, 09 Jul 2021 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+55UwqLAyfgxZBZ1Kggno0sqWKaYls4/rhJTUFXZyOs=;
        b=VnyDWFyLsgBcqq7dw8b1LLLrF8WEwEUHgmVhHHNmrD7FmHlqiHR+zAeG1n04MHWUbQ
         MVhaNyJOUcZOpvorCUoIViNwyRk0dUS/6MkD8CQ6N3gwF0nVhC1LonNKwMxlazr2Q8OM
         V1aU+UUDI0Oseo0MX/8BfRXWliPXD3vd2ECezbZiFYObgGfsSTRTVmSLrpwuNJj5aItx
         yoxFHBwfiT70iylX2MF+QdsLUw3EMsVzV0VmLpDNLioYSVLqUXfC1/GRIVfDMZLwLTxX
         akGgqXEaMzLhcPqtoZLwk3GO9dii6ruKu2TGQykd+hYWazY33MnKYc0sNytca/9/R9vF
         9FZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+55UwqLAyfgxZBZ1Kggno0sqWKaYls4/rhJTUFXZyOs=;
        b=gPyYSTeA5wsi2yNmlpzQw9WJIl8jeVbaYgFt7YefykMy/D3pYmTtxQgMNM/Jh2zs0N
         zqPTNuM9ah2hMmiuNwM3p37szLEZgfIhOKtXHloHpoLo208M50ZJxcP25uoqk+xnj5xN
         AOmzFc3/XgPaD56RaFVlZH+vn6AsePhfkRJCMm8/xEvIKGsuHiyGwVqmqJxoAE3MMqTP
         aqf7aPYjemRWifmW+Ruk7BvEkovoY56q3t/I2m3Q36jbHZ7unClOutxz/Olpnwe22bF7
         v7j4OeVaXhZ6rksByzstMBbyUMqU55HRnETUVQsFDyiYGqVtiaGipNJPW967SciVca2l
         CXDQ==
X-Gm-Message-State: AOAM532dij0XqNyyVbOQ0AfYFpGKGvVQi3N3P5GN/yJwsfwrujq4ieii
        tFMED3/eaPP/sihZavNlRmSZxW/GzY8No14T1IM=
X-Google-Smtp-Source: ABdhPJzfv85bnaHLaXptF5KvlQ6DnYHAtUF7rDk4Ei56144wGrcjflLnhmtknP2s4rZSQOGGahiZRc3IhRUH9SvxI/o=
X-Received: by 2002:a05:6512:3f1a:: with SMTP id y26mr30033434lfa.540.1625843588459;
 Fri, 09 Jul 2021 08:13:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210707043811.5349-1-hefengqing@huawei.com> <20210707043811.5349-4-hefengqing@huawei.com>
 <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
 <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com> <CAADnVQJ0Q0dLVs5UM-CyJe90N+KHomccAy-S_LOOARa9nXkXsA@mail.gmail.com>
 <bc75c9c5-7479-5021-58ea-ed8cf53fb331@huawei.com>
In-Reply-To: <bc75c9c5-7479-5021-58ea-ed8cf53fb331@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 9 Jul 2021 08:12:57 -0700
Message-ID: <CAADnVQJ2DnoC07XLki_=xPti7V=wH153tQb1bowP+xdLwn580w@mail.gmail.com>
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

On Fri, Jul 9, 2021 at 4:11 AM He Fengqing <hefengqing@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2021/7/8 11:09, Alexei Starovoitov =E5=86=99=E9=81=93:
> > On Wed, Jul 7, 2021 at 8:00 PM He Fengqing <hefengqing@huawei.com> wrot=
e:
> >>
> >> Ok, I will change this in next version.
> >
> > before you spam the list with the next version
> > please explain why any of these changes are needed?
> > I don't see an explanation in the patches and I don't see a bug in the =
code.
> > Did you check what is the prog clone ?
> > When is it constructed? Why verifier has anything to do with it?
> > .
> >
>
>
> I'm sorry, I didn't describe these errors clearly.
>
> bpf_check(bpf_verifier_env)
>      |
>      |->do_misc_fixups(env)
>      |    |
>      |    |->bpf_patch_insn_data(env)
>      |    |    |
>      |    |    |->bpf_patch_insn_single(env->prog)
>      |    |    |    |
>      |    |    |    |->bpf_prog_realloc(env->prog)
>      |    |    |    |    |
>      |    |    |    |    |->construct new_prog
>      |    |    |    |    |    free old_prog(env->prog)
>      |    |    |    |    |
>      |    |    |    |    |->return new_prog;
>      |    |    |    |
>      |    |    |    |->return new_prog;
>      |    |    |
>      |    |    |->adjust_insn_aux_data
>      |    |    |    |
>      |    |    |    |->return ENOMEM;
>      |    |    |
>      |    |    |->return NULL;
>      |    |
>      |    |->return ENOMEM;
>
> bpf_verifier_env->prog had been freed in bpf_prog_realloc function.
>
>
> There are two errors here, the first is memleak in the
> bpf_patch_insn_data function, and the second is use after free in the
> bpf_check function.
>
> memleak in bpf_patch_insn_data:
>
> Look at the call chain above, if adjust_insn_aux_data function return
> ENOMEM, bpf_patch_insn_data will return NULL, but we do not free the
> new_prog.
>
> So in the patch 2, before bpf_patch_insn_data return NULL, we free the
> new_prog.
>
> use after free in bpf_check:
>
> If bpf_patch_insn_data function return NULL, we will not assign new_prog
> to the bpf_verifier_env->prog, but bpf_verifier_env->prog has been freed
> in the bpf_prog_realloc function. Then in bpf_check function, we will
> use bpf_verifier_env->prog after do_misc_fixups function.
>
> In the patch 3, I added a free_old parameter to bpf_prog_realloc, in
> this scenario we don't free old_prog. Instead, we free it in the
> do_misc_fixups function when bpf_patch_insn_data return a valid new_prog.

Thanks for explaining.
Why not to make adjust_insn_aux_data() in bpf_patch_insn_data() first then?
Just changing the order will resolve both issues, no?
