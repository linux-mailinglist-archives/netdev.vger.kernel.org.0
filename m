Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5C39EAAC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFHA1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHA1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 20:27:15 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F67CC061574;
        Mon,  7 Jun 2021 17:25:23 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p184so27592068yba.11;
        Mon, 07 Jun 2021 17:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FXdIAx+SIQaX+Rfgk82PPgzLryYWwEx/T8fyadJKJbA=;
        b=lGTNzPepfYvua1AlwEIR1CgJ9EFV3fX8fd9ybzJO7FMkAqxKwVVkohLGaGMUlgL5Xg
         MlWtivsxOkhbQg4/2zDR15XEXIkYvHyNVmtaREAZMjRKjFHSxIMhCeObk/5Q6xCTcrxj
         Ffxt7M1rdjOLkYStvXt6JEGLThtvUyVrdVtm96sle2Mvt8rbqr2H/s64JilVgunmIBB3
         nqAptMs2MNi37+JDmOSQLmQiyc6R74s7H9CJWy2AT8EqG651ZKakHbMgHSNjGO3kXpNI
         ttSgtBU5aoZ+cSBU+qV/JSptogEoziU5ubqy0mGlZEdvrpURL7RXd8d2BckfgWNBQj8C
         XPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FXdIAx+SIQaX+Rfgk82PPgzLryYWwEx/T8fyadJKJbA=;
        b=NoyNkwi4n3ElTrBIuUPotU0Yyaa6a4KLvf+LCfB/Av0Pbra63NiPH4XUtSqsdbLcnu
         gXsql3lcG8+dh2DrPmf2+Wf31O5nAtimsln56IQ/rNt6ubr09aGarH7/l7hb2bNG9jG2
         AgVBIxgn/PuwtBwTyBPfsIxODXGjjWc2YjJehNYRDe3wSkRNFDvK4Enwd5U2TdUEkg+e
         wB1vjB6ATciVl1u0nuOjEJ8dg8H+jXrla5fU4YF95lUOXqBUmUshSaOT/aGbt6RNsabv
         9qqfHJ1Ifg0kQyZJuJRlcQz8rfmmxjZXRvERH6/cOALqPQVYEKqM3h7Q+/aWBjQfKsCT
         IqxA==
X-Gm-Message-State: AOAM5313lLikPQRZGClceRF1oGGnGOSO3zJUHQn6FWT/SgcYr326XdZo
        Mwu2ygLtuUn5+fmfRhFpgyHoxMINOeuwQRs61KWttcj2+AjGpA==
X-Google-Smtp-Source: ABdhPJyTkD5HKF6/JgoiUCA/D3nCeQ1h8+C5JCbL2G3L6ii9Q7sXQi6CI1gqEgrDMtQEoN07PP8Q/YfdVPgtIGo4KuE=
X-Received: by 2002:a25:aa66:: with SMTP id s93mr16641995ybi.260.1623111922602;
 Mon, 07 Jun 2021 17:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-7-andrii@kernel.org> <20210607231146.1077-1-tstellar@redhat.com>
In-Reply-To: <20210607231146.1077-1-tstellar@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 17:25:11 -0700
Message-ID: <CAEf4Bzad7OQj9JS7GVmBjAXyxKcc-nd77gxPQfFB8_hy_Xo+_g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/11] libbpf: add BPF static linker APIs
To:     Tom Stellard <tstellar@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 4:12 PM Tom Stellard <tstellar@redhat.com> wrote:
>
>
> Hi,
>
> >+                               } else {
> >+                                       pr_warn("relocation against STT_=
SECTION in non-exec section is not supported!\n");
> >+                                       return -EINVAL;
> >+                               }
>
> Kernel build of commit 324c92e5e0ee are failing for me with this error
> message:
>
> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4=
.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen objec=
t /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4=
.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_pe=
rm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5=
.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/=
bpf/bind_perm.o
> libbpf: relocation against STT_SECTION in non-exec section is not support=
ed!
>
> What information can I provide to help debug this failure?

Can you please send that bind_perm.o file? Also what's your `clang
--version` output?

I suspect this might be due to Clang commit 6a2ea84600ba ("BPF: Add
more relocation kinds"), but I get a different error on 324c92e5e0ee.
So meanwhile you might try applying 9f0c317f6aa1 ("libbpf: Add support
for new llvm bpf relocations") from bpf-next/master and check if that
helps. But please do share bind_perm.o, just to double-check what's
going on.


>
> Thanks,
> Tom
>
