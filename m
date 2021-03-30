Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D934F1E7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhC3T7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhC3T6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:58:34 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18EEC061574;
        Tue, 30 Mar 2021 12:58:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id i6so5329052pgs.1;
        Tue, 30 Mar 2021 12:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ENHjPLdJcCbOVQbW/wX5HbF4ez/ctOf9xHc2bsUfuzo=;
        b=lfCCKkYKD6wVgNXH1X0uRfc6O+hm86EXu0lLXpsIm8N+Rt3y02ceCGYkbP0eEzADxO
         +40AxAkx4iucorkq5KYdqbU7jNGSrtoOSnsX775E+IDbou6rdeSxipo1/ekGMCEXCi2C
         xgBK+ygnz2KSa0uvr/emeTl6sBuPY/QrcWFrcUC9RfTCo6gNjiDEx85f5TuJHnfuOOyg
         giDEbf9ZE07+hkOeQbWYKLbIVaCrcxIJxgXzqilyIxYzImfnTaJkFGaYn//EejTfDhL4
         RprNGlVmj62RCrFlGKXhYYazkqSVIgOoRiyRcbqbmzgljQWH8/x94JUf54/M2UmBX2nk
         R0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ENHjPLdJcCbOVQbW/wX5HbF4ez/ctOf9xHc2bsUfuzo=;
        b=SNyYBHrg1Q20uOqOcMtpGn1FfvigpG0mwx/YYSBZ3y06qDXsOL+2pcQ4J7YEJmZ8x3
         DiyDhf9n6IGqxVcNtGJMzGWA48t4cBIqv3LgcpDgXoCGLtap4e3p3NR5Ar64GCjVd1WW
         wdZUZnwA4AFum1UIdge+XCya8SxW3vr7CLbWEQOSxJNDKD6SdYP3MuHEn3wlBp04BKYE
         H2qQQtmErGhKmiyMGxNaOEVQpFVoxL/edoseaP46veuarBis3t2Iywd1b+I448vKWpI+
         I3u1SAvGo5x/dTcO3c6MAFzLIcXd4wTjmZsx+khoBUwyNkmuhK7n1UUQh51kNicYhbDs
         k0WQ==
X-Gm-Message-State: AOAM530PdyaTOkcrtozV6xAIwm8ju46eNkpossMoEXhQfGjSyXPX7Vec
        ICMSyRS29TosXknwvdUIrLC5cMf4eiWhMee5azY=
X-Google-Smtp-Source: ABdhPJz3F15mx7HW3TFVZTXjzkq0/nzRiU5DtR//0EEz8pTh0Kz7bVnltV6QUgH98sQ3pPuXPpw6lde7Gr2sVBPL3GU=
X-Received: by 2002:aa7:99c6:0:b029:1f5:c49d:dce7 with SMTP id
 v6-20020aa799c60000b02901f5c49ddce7mr30679033pfi.78.1617134313278; Tue, 30
 Mar 2021 12:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
 <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
In-Reply-To: <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Mar 2021 12:58:22 -0700
Message-ID: <CAM_iQpXKQ6WDgoExX=9D2gXcuYtUD4xLsPOSKX=BnQ-0KpBZpg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 7:36 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 30, 2021 at 2:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This series adds support to allow bpf program calling kernel function.
> >
> > I think there are more build problems with this. Has anyone hit this before?
> >
> > $ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7
> >
> >   GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
> > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> >   GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
> > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> >   GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
> >   GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
> >   GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
> > libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
> > Error: failed to open BPF object file: No such file or directory
>
> The doc update is on its way:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210330054156.2933804-1-kafai@fb.com/

We just updated our clang to 13, and I still get the same error above.

Thanks.
