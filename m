Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DEA3C390
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 07:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403808AbfFKFrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 01:47:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36397 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390485AbfFKFrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 01:47:05 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so5730351qtl.3;
        Mon, 10 Jun 2019 22:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A5wEeAyNDVZXiW6xkSMzpzOefP4LoMFNlikHzfFKkbA=;
        b=MEjjALLPHdnWy5msWX3MwHLfjkl8sZtsl9HKWIhJrzZM6n6n7RND9/LRrdhnkLWZYH
         bGgxrVSPjyLG+VaGT9Xfee2TCU4N2HhtqdQ+rMmV6v1oZe2s6spwrsyXx+5WQjuf7I8+
         x1ugPkDN54ZiERf4RreN2BtDBYh16gtxL0l02ILc5ZtYGDAGmtmeuUkfkX58ckBknQs9
         sMNmWz0FjAw9FXm0UCaFvzZ0OOfXNyxMIC4LRdH5TDrjPZSPkCr75dcZuH1jx2963hd3
         e36Z8rcwEUMvUeWvBrK4czZouDeX2ZN35sw1nz2EDY4sD73pA9zzij7Ez+mHaYhpZ1Dk
         obsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A5wEeAyNDVZXiW6xkSMzpzOefP4LoMFNlikHzfFKkbA=;
        b=Gp5jMIxSJQCBq+skH1VYNSsfLb5v4/8KJD8KolIWWhvH6XcRHqoza4JDUt8UHj94Yy
         xrHXvBQCruxZiyBqH2DsYW0x/Q5Glq3kIJ7fAiruXl/lkKfaooGmCJFNEh2t6IWvehO/
         ZzYBHIlJxWmez8cXujdrk62hUHIORgJR5SAUyumBdnbpcbd1gCoQtQS16/ZFAtSlylYQ
         s0AhZFa7GWFMc1juWXau5vOxO8CXjIf2wkm/b/Vk0ZVEESj4Mu0KIJlRxtMZMDyFheMq
         rvGC0SAbRvvgyF9WCN4rVJYbzdbdBaUNhIi5yzXrAYHdKJy4t96ppgbJUCq75DVbT7cV
         USKw==
X-Gm-Message-State: APjAAAUWJmC8+qttN8Z5tpUEKFOIKyotnGpz8wVCd55nRIK4e6PhlZOm
        +kFnXqyOBi7729/wfsS+eCoebf1B3GaM6e3WRwA=
X-Google-Smtp-Source: APXvYqwz0mZMk1bLFqIpFAmo4mB6Gt5pF/u2vMOVOWKu7V2PtslgKVLzTrmb5hNGsIJDrNDl1+aXHzIO5PBhVKihcZo=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr12538069qta.171.1560232024706;
 Mon, 10 Jun 2019 22:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <29466.1559875167@turing-police>
In-Reply-To: <29466.1559875167@turing-police>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 22:46:53 -0700
Message-ID: <CAEf4BzbN2DzQ2QuUwcQy1r8kc4dQv7PyufWLkbymsL8rPSC0UQ@mail.gmail.com>
Subject: Re: [PATCH] bpf/core.c - silence warning messages
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 8:08 PM Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.e=
du> wrote:
>
> Compiling kernel/bpf/core.c with W=3D1 causes a flood of warnings:
>
> kernel/bpf/core.c:1198:65: warning: initialized field overwritten [-Wover=
ride-init]
>  1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] =3D=
 true
>       |                                                                 ^=
~~~
> kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
>  1087 |  INSN_3(ALU, ADD,  X),   \
>       |  ^~~~~~
> kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
>  1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
>       |   ^~~~~~~~~~~~
> kernel/bpf/core.c:1198:65: note: (near initialization for 'public_insntab=
le[12]')
>  1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] =3D=
 true
>       |                                                                 ^=
~~~
> kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
>  1087 |  INSN_3(ALU, ADD,  X),   \
>       |  ^~~~~~
> kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
>  1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
>       |   ^~~~~~~~~~~~
>
> 98 copies of the above.
>
> The attached patch silences the warnings, because we *know* we're overwri=
ting
> the default initializer. That leaves bpf/core.c with only 6 other warning=
s,
> which become more visible in comparison.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Thanks! Please include bpf-next in [PATCH] prefix in the future. I've
also CC'ed bpf@vger.kernel.org list.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 4c2fa3ac56f6..2606665f2cb5 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -21,3 +21,4 @@ obj-$(CONFIG_CGROUP_BPF) +=3D cgroup.o
>  ifeq ($(CONFIG_INET),y)
>  obj-$(CONFIG_BPF_SYSCALL) +=3D reuseport_array.o
>  endif
> +CFLAGS_core.o          +=3D $(call cc-disable-warning, override-init)
>
>
