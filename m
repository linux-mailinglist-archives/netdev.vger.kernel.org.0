Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9694941FE12
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 22:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhJBUmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 16:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhJBUmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 16:42:11 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434C6C0613EC
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 13:40:25 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id g15so5941295vke.5
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 13:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNIVK0kO4OyLgbBlEEKag1wUjDkN0DCQynWh6c8ag18=;
        b=A1H3NecD+cHXG6G5gXmA+fxHVmmvx5TKaiI04gPvAbZvfC7HyeSnYzl6xADuqhHIeC
         XAuZKbBYqFMpbukQMPtggToY+uLmrPujXELFglVjFNuJLUzH3Gn/WZMAY2cF/epQWsYt
         m5k3nVCb5f04t8HtUyUBo7zPw4MpIgJ7pWgkAsoFTJ0VvjEgIpKLdNi5Wneouf3YHEBe
         QhPOIx7AJaJtWbrTCeCqhPOVY5XXF3bgBDYeRqvNBjAvN7RJqhrUOSOGG2ifE2zrd2gl
         zev+LDAYc+oO45zrcrsX7RfQI0nd4I9tlsbn5fEflJSF1tFZMZoUjkhz30tLud6azDg7
         GeFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNIVK0kO4OyLgbBlEEKag1wUjDkN0DCQynWh6c8ag18=;
        b=5OnECSVriCRGfeWzDFC5tFU27W0YaMr213+hhi1B0I+3sxxjUOKUoX/GR9dK13Gds4
         LR3BVm/K7bJhPiJhW9o0rXAe+tMnSSgVaHa5nZ+Jxt9LJ+P+cNmpmx9n9F0xoSwQAmKu
         ltqvJfV+Jby1pWTITnmVV+5yzo/AfEyCsS5l67jUePColaVCKW5Wzepi5lc29FsIbC3k
         aaiwkQwtvDxPLIsnS/nIuD1Buw2sDjPqOVkJ8koP9PLe7tTQ1O/Mv7k81T2epVwsmrml
         P9RHIRzCjBcs6I+JRNTjunVlMGdvr1tt5O1VrDlDTm5D/h/bGkKVUyR0BcRVlsG9m5PP
         RsRw==
X-Gm-Message-State: AOAM532k4n1cpDtr2K+1HdX456R5TzJ1Nzo4sH/VVvLGmGbcM9e7P6FE
        U8jSnWKHRFbR/74RiPFS0QJyJMiizVBi1+bJmxlM8Q==
X-Google-Smtp-Source: ABdhPJzsEm7guaAFJZfKI6JguP01/GHgS5JO3A/evzbqNymBFJ96bMKuppzMcQHHKqZkFoGUH6x93zvuV+dE2/9RkDk=
X-Received: by 2002:a1f:cdc7:: with SMTP id d190mr5318066vkg.1.1633207224300;
 Sat, 02 Oct 2021 13:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <CAEf4Bza+C5cNJbvw_n_pR_mVL0rPH2VkZd-AJMx78Fp_m+CpRQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza+C5cNJbvw_n_pR_mVL0rPH2VkZd-AJMx78Fp_m+CpRQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 2 Oct 2021 21:40:13 +0100
Message-ID: <CACdoK4LU-uigbtQw63Yacd_AOzv+_fWuhL-ur20GyqFbE4doqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/9] install libbpf headers when using the library
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 at 00:05, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > Libbpf is used at several locations in the repository. Most of the time,
> > the tools relying on it build the library in its own directory, and include
> > the headers from there. This works, but this is not the cleanest approach.
> > It generates objects outside of the directory of the tool which is being
> > built, and it also increases the risk that developers include a header file
> > internal to libbpf, which is not supposed to be exposed to user
> > applications.
> >
> > This set adjusts all involved Makefiles to make sure that libbpf is built
> > locally (with respect to the tool's directory or provided build directory),
> > and by ensuring that "make install_headers" is run from libbpf's Makefile
> > to export user headers properly.
> >
> > This comes at a cost: given that the libbpf was so far mostly compiled in
> > its own directory by the different components using it, compiling it once
> > would be enough for all those components. With the new approach, each
> > component compiles its own version. To mitigate this cost, efforts were
> > made to reuse the compiled library when possible:
> >
> > - Make the bpftool version in samples/bpf reuse the library previously
> >   compiled for the selftests.
> > - Make the bpftool version in BPF selftests reuse the library previously
> >   compiled for the selftests.
> > - Similarly, make resolve_btfids in BPF selftests reuse the same compiled
> >   library.
> > - Similarly, make runqslower in BPF selftests reuse the same compiled
> >   library; and make it rely on the bpftool version also compiled from the
> >   selftests (instead of compiling its own version).
> > - runqslower, when compiled independently, needs its own version of
> >   bpftool: make them share the same compiled libbpf.
> >
> > As a result:
> >
> > - Compiling the samples/bpf should compile libbpf just once.
> > - Compiling the BPF selftests should compile libbpf just once.
> > - Compiling the kernel (with BTF support) should now lead to compiling
> >   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
> > - Compiling runqslower individually should compile libbpf just once. Same
> >   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.
>
> The whole sharing of libbpf build artifacts is great, I just want to
> point out that it's also dangerous if those multiple Makefiles aren't
> ordered properly. E.g., if you build runqslower and the rest of
> selftests in parallel without making sure that libbpf already
> completed its build, you might end up building libbpf in parallel in
> two independent make instances and subsequently corrupting generated
> object files. I haven't looked through all the changes (and I'll
> confess that it's super hard to reason about dependencies and ordering
> in Makefile) and I'll keep this in mind, but wanted to bring this up.

I'm not sure how Makefile handles this exactly, I don't know if it can
possibly build the two in parallel or if it's smart enough to realise
that the libbpf.a is the same object in both cases and should be built
only once. Same as you, I didn't hit any issue of this kind when
testing the patches.

> I suspect you already thought about that, but would be worth to call
> out this explicitly.

Ok, how would you like me to mention it? Comments in the Makefiles for
runqslower, the samples, and the selftests?

I'll post a new version addressing this, your other comments, and an
issue I found for the samples/bpf/ while doing more tests.

Thanks for the review and testing!
Quentin
