Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C41FC22B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFPXOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:14:51 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8944C061573;
        Tue, 16 Jun 2020 16:14:51 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d27so142765qtg.4;
        Tue, 16 Jun 2020 16:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbiG8uOfUL3pcz3BrmR6AwaddBM4+rmGpkdSVNLXbeE=;
        b=OYjapKLa8ZOFqLAQEAeUiDygXF+v1qJrCEHcOuS+aqSMVbiXh+74oW6gEp3OVAXAvY
         3tm/XDyz4Orjfz4selMkLJhuXRbZ4SDBESHqKRyx9yxiyue6c4+C1jcrKxDca+Q0MJ2A
         DXUYZZAm/aH0t5Z1pygF3Lw4veL+WV6Aq1y2L3bX9pIx+F26loMld3lwZKL3QT5mCXWV
         Ja6gch0f36EInADcgBWBq4D3RMVss3gEaY0v5dUqnFdicKK522HX+5ywQe35Gmhh/BQ1
         XyyzC7pxPYfBMBd9VAgBrsM9vZU140DuNtR3nqXO0likhz7Ji2ndr0VsKYX0dgm80ndo
         oZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbiG8uOfUL3pcz3BrmR6AwaddBM4+rmGpkdSVNLXbeE=;
        b=Fey2pRZlCpNzididjFVQL/O+fmtjh3D8B7eY2kX640V+/nOmCOUTOV/ReF3k0x8tT1
         RoG+ONkU9zJf8aYnkdnMyvbAt3lc2hXiXc6TOLPfrFO8nDrVg8EM3XYhK2xRsxQnu3bC
         4oXf1Mhz81rfouBpAPdLqIhpnZnx0XiiIZwg72NYbOZPzh2iKdKEYB1C7z7fTZslSdun
         6fvGNXpMasV14mHZfReGh2r8pUkqctYpdxjNs8QqkbIPcFRHSz9Cb/qZ34Eiv6t3vsa0
         YZJRvJmRC+0QPNBJkDZiuIWJgiYGkbOctvaOosCHcEJ/QbX0GkLzD4RHYOGWlyJKe73h
         6Cqw==
X-Gm-Message-State: AOAM530/V05q41e9OemFJcWv3FpF9jIQvmXMX6hvvlzIaCad3J9EplBM
        KKvC8uYJhoFP+ONx8vsCwG6N9oHKvPQ1gd6Ts1lmbZLS
X-Google-Smtp-Source: ABdhPJxrW+bklmB57nZtcY1/zFwiLBeDVioV36nk+xL+kE//Qo3J1vZtlUSW9Zl+3vfkUg+gP01DSbLz0olFT8PyFgM=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr23294237qta.141.1592349290860;
 Tue, 16 Jun 2020 16:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200616050432.1902042-1-andriin@fb.com> <20200616050432.1902042-2-andriin@fb.com>
 <5fed920d-aeb6-c8de-18c0-7c046bbfb242@iogearbox.net> <CAEf4BzZQXKBFNqAtadcK6UArfgMDQ--5P0XA1m2f_d8KG6YRtg@mail.gmail.com>
 <dd14f356-44bc-0ff0-a089-ce9fb9936c62@iogearbox.net>
In-Reply-To: <dd14f356-44bc-0ff0-a089-ce9fb9936c62@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jun 2020 16:14:39 -0700
Message-ID: <CAEf4BzYB+gqGEOfuOpJZHP7-e76Y=gp8SQ7rSZ3EGpwQjF6hLA@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/16/20 11:27 PM, Andrii Nakryiko wrote:
> > On Tue, Jun 16, 2020 at 1:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 6/16/20 7:04 AM, Andrii Nakryiko wrote:
> >>> Add selftest that validates variable-length data reading and concatentation
> >>> with one big shared data array. This is a common pattern in production use for
> >>> monitoring and tracing applications, that potentially can read a lot of data,
> >>> but usually reads much less. Such pattern allows to determine precisely what
> >>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> >>>
> >>> This is the first BPF selftest that at all looks at and tests
> >>> bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> >>> testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> >>> 0 on success, instead of amount of bytes successfully read.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>
> >> Fix looks good, but I'm seeing an issue in the selftest on my side. With latest
> >> Clang/LLVM I'm getting:
> >>
> >> # ./test_progs -t varlen
> >> #86 varlen:OK
> >> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >>
> >> All good, however, the test_progs-no_alu32 fails for me with:
> >
> > Yeah, same here. It's due to Clang emitting unnecessary bit shifts
> > because bpf_probe_read_kernel_str() is defined as returning 32-bit
> > int. I have a patch ready locally, just waiting for bpf-next to open,
> > which switches those helpers to return long, which auto-matically
> > fixes this test.
> >
> > If it's not a problem, I'd just wait for that patch to go into
> > bpf-next. If not, I can sprinkle bits of assembly magic around to
> > force the kernel to do those bitshifts earlier. But I figured having
> > test_progs-no_alu32 failing one selftest temporarily wasn't too bad.
>
> Given {net,bpf}-next will open up soon, another option could be to take in the fix
> itself to bpf and selftest would be submitted together with your other improvement;
> any objections?
>

Yeah, no objections.

> Thanks,
> Daniel
