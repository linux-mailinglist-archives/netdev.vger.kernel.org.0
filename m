Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9D672A3
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfGLPnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:43:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33681 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfGLPnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:43:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so6751507qkc.0;
        Fri, 12 Jul 2019 08:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cnr2C/JzDmwFpY8QG3EJIR58mB+sAsyN0pxTYko9fKw=;
        b=gfddwTagBd019wAjQEW4ILIuiOIvWifUcDVRviu8rR/HMssNDEGpKdiIIamCeZh6ga
         LME85eYU3r1nBvsJMqAr/wqE97iGbAlAx87g9gOTOxMCTTJkOb/a3Om4eS+V61nF8j+b
         uSuxh8ARaI0faBvYrvy+xkQuqx1oFTTOjC8SObBacUTcozhGFyYohwb+2GPinWR0FLlQ
         dmYr9eVnhQKpCmfZE8jAXXWRWeroeQXvBxDTB7SCrQH+qB6kgNUVwaDdpHIJK5AQJwCj
         lWdjuou0TzNgLY0TBbbzhAfeSmuDlLDYUFxGhn3EdpadlDBB8czjHASuERPm9bH9XQvq
         dpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cnr2C/JzDmwFpY8QG3EJIR58mB+sAsyN0pxTYko9fKw=;
        b=JxsZmoU0ElW4bHu97ZnBDINY2yMNWWhjxRUrVR1ur3EsHC1+hCWgPv9/r72/0uzjhI
         jgMZ4CgJqsNiX5QpyzMOHbtfqmvIUVR0Cd/BiGkcSFPgmQ+2OFdaWA7jgq6qSbSkBGvN
         lPGDh7rBrd9+RulGOscXMWAdoWjak2k42JXmENe9Vniw2moRFea8tYYR4116/WLU9eeo
         KtMk0F4M+uzFaZjVa+k/ZVPuo07lyK9ftRUkMXor5OVwjSFFFDLpbz2Yst3wq9bzf7Zx
         9TIiS9SMapVZ0Hdz8cW8gWtAo01VhuMF9FwU/Ocmiv7nCtyTIgOk/96bheOXY84TXzEJ
         OPtg==
X-Gm-Message-State: APjAAAUY6mARM61uGB/6Ro5lwLnu65lD/MyEYAZyEi8E0gL2K782NPxM
        OncDQoO1HX29D8cN/XijWDHvsbPKT5rkWjl7jWM5MO1ZuTehFQ==
X-Google-Smtp-Source: APXvYqzilmLdGufgUzj9WVYNCuqzP8SOoBU4/3ciQqBOLCQtyJ/e0dIBXK4xXIyPYkAZ5YEnDvZJjAhjD2OcmXheJWI=
X-Received: by 2002:a37:660d:: with SMTP id a13mr7065971qkc.36.1562946184072;
 Fri, 12 Jul 2019 08:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190711065307.2425636-1-andriin@fb.com> <0143c2e9-ac0d-33de-3019-85016d771c76@fb.com>
 <bf74b176-9321-c175-359d-4c5cf58a72b4@iogearbox.net>
In-Reply-To: <bf74b176-9321-c175-359d-4c5cf58a72b4@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 08:42:53 -0700
Message-ID: <CAEf4BzY-7MLt8hvBqMMdhpAq3ih_KFjgWitN3TSf74FypeAPRw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/12/2019 08:03 AM, Yonghong Song wrote:
> > On 7/10/19 11:53 PM, Andrii Nakryiko wrote:
> >> BTF size resolution logic isn't always resolving type size correctly, leading
> >> to erroneous map creation failures due to value size mismatch.
> >>
> >> This patch set:
> >> 1. fixes the issue (patch #1);
> >> 2. adds tests for trickier cases (patch #2);
> >> 3. and converts few test cases utilizing BTF-defined maps, that previously
> >>     couldn't use typedef'ed arrays due to kernel bug (patch #3).
> >>
> >> Patch #1 can be applied against bpf tree, but selftest ones (#2 and #3) have
> >> to go against bpf-next for now.
> >
> > Why #2 and #3 have to go to bpf-next? bpf tree also accepts tests,
> > AFAIK. Maybe leave for Daniel and Alexei to decide in this particular case.
>
> Yes, corresponding test cases for fixes are also accepted for bpf tree, thanks.

Thanks for merging, Daniel! My thinking was that at the time I posted
patch set, BTF-defined map tests weren't yet merged into bpf, so I
assumed it has to go against bpf-next.

>
> >> Andrii Nakryiko (3):
> >>    bpf: fix BTF verifier size resolution logic
> >>    selftests/bpf: add trickier size resolution tests
> >>    selftests/bpf: use typedef'ed arrays as map values
> >
> > Looks good to me. Except minor comments in patch 1/3, Ack the series.
> > Acked-by: Yonghong Song <yhs@fb.com>
> >
> >>
> >>   kernel/bpf/btf.c                              | 14 ++-
> >>   .../bpf/progs/test_get_stack_rawtp.c          |  3 +-
> >>   .../bpf/progs/test_stacktrace_build_id.c      |  3 +-
> >>   .../selftests/bpf/progs/test_stacktrace_map.c |  2 +-
> >>   tools/testing/selftests/bpf/test_btf.c        | 88 +++++++++++++++++++
> >>   5 files changed, 102 insertions(+), 8 deletions(-)
> >>
>
