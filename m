Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9717734EA7D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhC3Off (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhC3OfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:35:13 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3BFC061574;
        Tue, 30 Mar 2021 07:35:13 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id f26so20128494ljp.8;
        Tue, 30 Mar 2021 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EFhs2tIDZibWzrJh59IOvN0bJfFhpwIvqS6V+K23EGA=;
        b=qnTFvoKXQoWNENte4Gv8Xi3mcBX4Nk7i6lThG5ZXALGCZckmWlv1Gv/+g2/LkDVnrc
         5mTpFgC7RPvORSgn6yoHGsvDaFRpfGW2+bHBhNq69JW0jDFCOcTeLfJFhJnqnN9j9Mu0
         XWXoemkmBmX5h4mko8OHsk7MM5l1lSsqoKtxS5zmTHfSgaENeqXQHw5YbLok46z4TCCT
         qToCPTw+IJ7D6XQVQ6iF6Es3t7HenmhMRwFfI+kbcWT9pw5tCoo4aaD/d/Qtzcts+QIf
         vErEOYszC3ZZI4dgHDJkbe/RRNOGWxVT02i2pCfNC3hgQZIKELIR5iWgRWqn9BphQhhv
         rPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EFhs2tIDZibWzrJh59IOvN0bJfFhpwIvqS6V+K23EGA=;
        b=g6d0Ifl8LXtQF3qmqen4B5keJuETPbPOr5ip6RoNZcEzGQfgx+VRKASzrQicmM9dEn
         qpdG+WT45481YPffZjZ2jDvdjblC3N9aP/EG5jWNJBSXvUyPKkWOL8aLwr2vtAZN7d2X
         e4Cs/F+jbIMRzwNiPAZPF9Fks5qSZWH6iEwbTTmdXJNT5qOasV6QQ5SxzI0SNtvcrPZr
         STA7KvrcFRU/wxTlco+CcgtfwY8G4PJHLnfAcYLD+ce87mA4IH/D2YmFDIzfx00FB3Gl
         uPQuI9FL4YOFzmT3gSYMAE4iB3vX1vjdV9MNAH5ZiFAtXNKuf9bJ1e1lG7nYnKt2uJhm
         TTdg==
X-Gm-Message-State: AOAM53286IjEFdF5vLgK+0MTV7KR8bSqNOJTS7RdGqq79UohXhlSf7Rs
        D29S50Ti53NivwNPab230kSXKo/0nbK7Jhc7SrM+GgMffEY=
X-Google-Smtp-Source: ABdhPJxVHLziL4cXahjty2X+Gj5pT44WVdD84yxRNN1+udjd/FJMOnE+PZ8iT9ThWWdLr5NrbPXVUIadeByTHSh4KmM=
X-Received: by 2002:a2e:9704:: with SMTP id r4mr20654715lji.486.1617114911657;
 Tue, 30 Mar 2021 07:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
In-Reply-To: <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 07:35:00 -0700
Message-ID: <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 2:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This series adds support to allow bpf program calling kernel function.
>
> I think there are more build problems with this. Has anyone hit this before?
>
> $ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7
>
>   GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
> libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
>   GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
> libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
>   GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
>   GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
>   GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
> libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
> Error: failed to open BPF object file: No such file or directory

The doc update is on its way:
https://patchwork.kernel.org/project/netdevbpf/patch/20210330054156.2933804-1-kafai@fb.com/
