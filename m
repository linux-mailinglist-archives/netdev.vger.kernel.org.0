Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E280B443DC6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 08:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhKCHnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 03:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhKCHnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 03:43:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2086FC061714;
        Wed,  3 Nov 2021 00:41:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u1so2073309wru.13;
        Wed, 03 Nov 2021 00:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rEUk3hjZbgaNLemqWe9Q44RKe4LYiJjMpeJVdUSL6cI=;
        b=SzSEr4GzUIi1n53esxrhyzEL+hnpq51VXmuNzoRbJng2jp0GsMOv6J6G+0AUT7sKib
         WaR12lSVZFAI5pPfRFm9i0NG3DAZEN4srkUw67DLwYHYnhu3wUCn780FuNIYfO0LzT40
         1Nj9cfpioDcXN/7KmFeruIRM9XUofAP7KZhnQMRuqUkJhuz49XhNdRrR2FIzrb8Ah5f0
         xSfFjOU9PBmgkriGn55A5Q6gxEwiETQJqtV1yx7WGqGX849wiHMl3lVPW3SrzN3LFSmT
         tBrMKwDkH4oSdrSOYaHSJLP2+zRMOnlibiAZVi1+gMlRLxYDs5zu6QQoVEsDBOje/AjA
         dS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rEUk3hjZbgaNLemqWe9Q44RKe4LYiJjMpeJVdUSL6cI=;
        b=F4+JdGU5/88RO+OLiI1m2zc/lDBPS1ymNR832P2tBao7fVSS4yYivFG1/VuFNhEL8G
         E5UcQuEw+9T6tg0On+llcbwOm9nhjNy8eEqJAopTfE/OZEzIiUU1OesfcbvnhfvSFJl1
         fENZan8r/DPEJMNgFsrFFYH/shoMjs7Qol+ssar+E7zq1OoF/ROyd3wX+0EVBspBngcE
         5dfm4rWrFPJ6/4qIZCJ6QKSeDNX+GBZQaoSQV4xdV/Hk0fuAyNnF2nhLsbgQOYh8T7+Y
         9Kxlm5aZb1xyb5atqdkrzv7ldmPZQ32CgZT6FsjJilodJQVaXpPnP92STomciBbtlhkJ
         4x8Q==
X-Gm-Message-State: AOAM5315Kj9IWAeZrlAagiRFlLYOk73lmrh914R/u2sdy0qCkT5S/byQ
        /MJpF4AFwqL7D/1rWCpN9YyYOcOdKwj8v8FTmSQy28bgcFA2Ng==
X-Google-Smtp-Source: ABdhPJyzngaH7X863kxwlhmnQIi8Eo36rd8szhefxmDQ/tTo5iBVuHnTW5qLSd4+auf3a1fe/uazHgl4Ex4uDlBMxLU=
X-Received: by 2002:a05:6000:12d2:: with SMTP id l18mr42076950wrx.289.1635925272752;
 Wed, 03 Nov 2021 00:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211102145642.724820-1-tongtiangen@huawei.com>
 <CAJ+HfNg1Ki=1Zc+ThW-ynvtDo5=fNAUK-XV08-icz-nY9CNoUQ@mail.gmail.com>
 <448599f5-e773-6ab5-bdaf-289f583edf01@huawei.com> <CAJ+HfNj_p36trWFzdyxVVgykrPVq=OvKcYq61w2QyKsHwa0gDw@mail.gmail.com>
 <f3ed7e48-c565-9147-eca0-6298a36b3d61@huawei.com>
In-Reply-To: <f3ed7e48-c565-9147-eca0-6298a36b3d61@huawei.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Nov 2021 08:41:01 +0100
Message-ID: <CAJ+HfNgze3=heV-ehvagHQFc5w6ymZ7XQMfKPzeWBo1M82+E-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] riscv, bpf: fix some compiler error
To:     tongtiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 at 08:26, tongtiangen <tongtiangen@huawei.com> wrote:
>

[...]

>
> Adding a function declaration in bpf_jit_comp64.c file cannot fix this co=
mpiler error:
>

AFAIK, there are two issues:

1. https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/
2. https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/

1 is a warning when W=3D1 is enabled (missing prototype from -Wmissing-prot=
otypes)
2 is an error, since the function is not defined when building CONFIG_ARCH_=
RV32I

You are trying to address both issues in this patch.

> ....
> when CONFIG_BPF_JIT and CONFIG_ARCH_64I is open, There is the following c=
ompiler error (W=3D1):
>    error: no previous prototype for 'rv_bpf_fixup_exception'
> ....
>
> To fix this compiler error, you need to make a declaration in a header fi=
le, which is also
> the reason for introducing extable.h.
>

No, you don't need the header file. The forward declaration is
sufficient to get rid of the warning, and the adding CONFIG_ARCH_RV64I
fixes the RV32I build.


Bj=C3=B6rn
