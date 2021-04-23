Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD9B369D73
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhDWXh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbhDWXgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:36:21 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B137C061574;
        Fri, 23 Apr 2021 16:35:44 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g38so57497057ybi.12;
        Fri, 23 Apr 2021 16:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0COx3mtlqNxBxeyt1n3eCr9OKs4EOcdTrHgb2uw6IF4=;
        b=HWJE8jZvNKqcKjphmSnmAql4IBCkEvVmkLst898CWaF3OVVONQYuQzohmuD6fJwa+h
         FMsHC21WSs0EttNm9T1CetBbsH1uZJHY9CBk59H1qN+e8jUxGe2UkzhNtvQlnh+PdyHE
         zn+h451gvleqhU+Q7cDE9pHVZshTSjNeophshA/L8y/HCMXEsQkDrpIsOH6u6hcHJZW6
         OxAQ0k6OJUMLA06NEPU7pCgOMbsHq2PPhQ+b0XyQWZGpQqyNNn0UCIz2qeeU515Ia0BZ
         YkkGlBx1ARCFLOda9fFsIZDXbe9H76QK9RlOzHsgDbFB9RpTBkWw8eQ/Q1bHAm+aV9pK
         D1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0COx3mtlqNxBxeyt1n3eCr9OKs4EOcdTrHgb2uw6IF4=;
        b=QG++hF7DKRtT9qf0n97B/zrrNttnIPnbVD76YszL+T9X8yOa9qgqoMpfm0Qxnbd7kA
         DQXe5pe+7ehXAfX6Wd83NspVaId0ZA9RQyndb2E8p5uNAcMaxOtDIGDrFw7Rpijt5mPv
         +yojcwhU52M7MJcRohCRGw933FlGdIFzz2FI1yoEKCTwoqyIrQUQIdBp0ZIPnzjp7BLj
         otnLEOmX+hz+BNfNVbPUCU2qY7fAIdmM+o7P/H8/MDSoODQgWqv3fOtf8UFklreBitTi
         FX9OVKaTk08U0wOHA847IGJYxjvrD5E496YhdRGTl/u/LiH8ZqRyRhAH9ngKt2wFmoyr
         RHoQ==
X-Gm-Message-State: AOAM531WefdZSSKnDVLtq2lhiDEO0l5JT1jeuZzaaWHIfy/+T7xzyxlV
        nd9hebkHXVXGu3nvtfGcW4r2ifNGEgsTrOJOvy0=
X-Google-Smtp-Source: ABdhPJwbFCWFvfyWVyvv2VRIp+ERvF2oYAC4kmJhkcF+KemyCmzrRjMvsi0Zq7G4M2RY3IorBdvj6I9URSzKcEhpxNU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr9193584ybo.230.1619220943729;
 Fri, 23 Apr 2021 16:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
In-Reply-To: <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 16:35:32 -0700
Message-ID: <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> > >>>
> > >>> -static volatile const __u32 print_len;
> > >>> -static volatile const __u32 ret1;
> > >>> +volatile const __u32 print_len = 0;
> > >>> +volatile const __u32 ret1 = 0;
> > >>
> > >> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> > >> this is not in a static link test, right? The same for a few tests below.
> > >
> > > All the selftests are passed through a static linker, so it will
> > > append obj_name to each static variable. So I just minimized use of
> > > static variables to avoid too much code churn. If this variable was
> > > static, it would have to be accessed as
> > > skel->rodata->bpf_iter_test_kern4__print_len, for example.
> >
> > Okay this should be fine. selftests/bpf specific. I just feel that
> > some people may get confused if they write/see a single program in
> > selftest and they have to use obj_varname format and thinking this
> > is a new standard, but actually it is due to static linking buried
> > in Makefile. Maybe add a note in selftests/README.rst so we
> > can point to people if there is confusion.
>
> I'm not sure I understand.
> Are you saying that
> bpftool gen object out_file.o in_file.o
> is no longer equivalent to llvm-strip ?
> Since during that step static vars will get their names mangled?

Yes. Static vars and static maps. We don't allow (yet?) static
entry-point BPF programs, so those don't change.

> So a good chunk of code that uses skeleton right now should either
> 1. don't do the linking step
> or
> 2. adjust their code to use global vars
> or
> 3. adjust the usage of skel.h in their corresponding user code
>   to accommodate mangled static names?
> Did it get it right?

Yes, you are right. But so far most cases outside of selftest that
I've seen don't use static variables (partially because they need
pesky volatile to be visible from user-space at all), global vars are
much nicer in that regard. So I don't expect much changes to existing
skeleton users. But ultimately yes, going from non-statically linked
to statically linked might require few adjustments.
