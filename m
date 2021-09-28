Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902FB41B915
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbhI1VOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbhI1VON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 17:14:13 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1979CC06161C;
        Tue, 28 Sep 2021 14:12:34 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e7so426879pgk.2;
        Tue, 28 Sep 2021 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pHYj7HRtahjbKwEBtzCUYVObQgp1AeKgLSsYRQ8rMi0=;
        b=K1C9LSpM1QNOMC/qREq9uYcoo3rfN5zeS32XGKdG2eM6GETIOOXbwy6YuJ/EifFg5s
         xqbTJZdvVMFhJB3YTMX9ce2Kb2z/eplfEeN4wM69qcuCm9V/wYAcce4+dV2WETYDR+6L
         zbIRBxBDodqw9VWY5wG+0QQt6OMP72V5uWVA65TA4KVcvPw6mvmrbg9RRHcYYudGMVn+
         iRX2XxbH2Xv+pGqiIQ2BK8QGQIzMklN32ochpjgsLdkqm+O/0occ/B7toJs8LhJRUonj
         uLRi9owSupAJ80JA4QL050ihR5FJj3nAB99gSTjhpqrovMniq/dN+E83fgdG4xk3mJWX
         Bc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pHYj7HRtahjbKwEBtzCUYVObQgp1AeKgLSsYRQ8rMi0=;
        b=sM9295G+DMoSkTnGlzarym5okKi67ObaajKxLreJ/UvV6oDJlMv6VRihOfJpXyv/Df
         X7Bs0EToaXRho9dO9Ywx94jcx+DNUuWYKbNKsqnsmQAQgL6FPqFlr0KmIp7UFy1WXO/h
         u10Q3KDg3lZrh8UWTTb7xU9zNgshGplWAoAYry1lmsg4RdcZxpbf0rL4Qcib6o+79i7D
         EqNKNsq8wDK2eEnd4gj4jfiqB4UwIRFcfbs6+BAUX9bcVCAbFUlk0Np9jDq+VSuK6CQu
         x2cP+4utmnFNlQaR0PJsw6RZjbgj6Mp8HlAqOytKNTbJjL5l8uFAllYEjesmb2Iybfc6
         imDg==
X-Gm-Message-State: AOAM532b669xFAO08Z4jTNYhjyPVtjsr7qns30wfVCnD5Oo36fCEs1HA
        s2BRGfxXbXbejOOv3mDCmaoQG6hzJnDf7SRW/p4=
X-Google-Smtp-Source: ABdhPJylbWKY9yS+Xe+vI41SkojRTv66HK3od19kYKSV+bsAsKa/+ykIfQi5Z4oTK3GcuAuKUgP4tiSPKM0wyD0neik=
X-Received: by 2002:aa7:83c4:0:b0:44b:bc59:1a46 with SMTP id
 j4-20020aa783c4000000b0044bbc591a46mr2555856pfn.77.1632863552393; Tue, 28 Sep
 2021 14:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210927182700.2980499-1-keescook@chromium.org> <CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb46=-J5Fxc3mMZ8JQPtK1uoE0q6+g6WPz53Cvx=CBEhw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Sep 2021 14:12:21 -0700
Message-ID: <CAADnVQJmXEpzA6Phgmf8AW6ZvKjbn1XQeZZQdNt_rrQ6NxGD3A@mail.gmail.com>
Subject: Re: [PATCH 0/2] bpf: Build with -Wcast-function-type
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 10:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Sep 27, 2021 at 11:27 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > Hi,
> >
> > In order to keep ahead of cases in the kernel where Control Flow Integr=
ity
> > (CFI) may trip over function call casts, enabling -Wcast-function-type
> > is helpful. To that end, replace BPF_CAST_CALL() as it triggers warning=
s
> > with this option and is now one of the last places in the kernel in nee=
d
> > of fixing.
> >
> > Thanks,
> >
> > -Kees
> >
> > Kees Cook (2):
> >   bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
> >   bpf: Replace callers of BPF_CAST_CALL with proper function typedef
> >
>
> Both patches look good to me. For the series:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

It needs a rebase to bpf-next:
In file included from ../lib/test_bpf.c:12:
../lib/test_bpf.c: In function =E2=80=98prepare_tail_call_tests=E2=80=99:
../lib/test_bpf.c:12442:27: error: implicit declaration of function
=E2=80=98BPF_CAST_CALL=E2=80=99; did you mean =E2=80=98BPF_EMIT_CALL=E2=80=
=99?
[-Werror=3Dimplicit-function-declaration]
     *insn =3D BPF_EMIT_CALL(BPF_CAST_CALL(addr));

Please mark the patches as [PATCH bpf-next v2] to help CI pick the right tr=
ee.
