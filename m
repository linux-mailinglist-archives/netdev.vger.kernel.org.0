Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF883AAA1D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhFQEdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 00:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQEdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:33:05 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03975C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:30:58 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g142so6240169ybf.9
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oKSDFk6VJyfz/ba/2nEaX1ckwIhps4d0Tn1iDJTGJHQ=;
        b=iQZRs1GYeUI05fAG6a6JkWmZ1UJ9PUvau9q1LRIeE+M0jz4zqHh0Pdie5uf3geBsWm
         1ya/jkUm6ZY21ke2oXJIsrWHkaR5yULcIDmzmIuzTS3QuQxnMCDwROatmETzfcp69NXY
         h/mjalI+YXQ7M1zOtshnkxtzs+13BRmf1D3F/Sp8X+BuUy+IIM/ThdppeCI+ZIQ3G0iJ
         vsoBXvGYfu1Azb9VYzXsaY8j9dDoYk21HJy9Ez5AQTy5Es60BJaWcmUy2jEkUEf48z14
         uhI21XCv8jRZmh9vHO3xLKHsRSeV9uGQBooHKg/ABtpaPZyx/lkyfRv/5BBeh8xHp500
         B3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oKSDFk6VJyfz/ba/2nEaX1ckwIhps4d0Tn1iDJTGJHQ=;
        b=OH/R60w6mwLrSvv3h1qPxQ0EKPjsbNb3mzkyLytoUK3rItkUvD7A5h2IwC+utuzHG7
         3PZW0GHrElrxK7ebNJ2dNqjZfFrN+/LmS3Kweic3NKddMBDSSpm6rqPyGXOGsMTgN1YV
         1NIk+fuUjBQ+6n+LbHV4q7LYIo1pI4+CUZtw/pEDr7jtzz0vq/Oi/e5iVTJac0bIuF4P
         Dwfph9a5XKqgBzJv6vIRCiGjEOkYUYvFQBXQxF/PnImWYtv93UA5takQd6WbZv6yJPEO
         z9BpTi8pbZnyJonPWsevGRUBRZfBVM5jQUf2e6J3araRghW5aSXtQ+GRA41PRQvKElL6
         XmkQ==
X-Gm-Message-State: AOAM5320wZ/hUCwt/hckImZ09lbI7OI4olHh0YGPYzMXM1kUImJbelta
        MfXI9uAPOuaOrp7VeT9O1UONGD45YWxPCeRcHgc=
X-Google-Smtp-Source: ABdhPJxf7seZxCNGKo1bpW60BDStoA/6u1MnPD6Xb74tJmh+/CsRrps9MxoAjZSYRftjZff97QE2bBZzAL0uwq5EAAU=
X-Received: by 2002:a25:aa66:: with SMTP id s93mr3922003ybi.260.1623904257270;
 Wed, 16 Jun 2021 21:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
In-Reply-To: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Jun 2021 21:30:46 -0700
Message-ID: <CAEf4Bzb688kxqzgdrDEc0EgNj7-btzfvJnp6YauTAxSXTkdLow@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/4] BPF fixes mixed tail and bpf2bpf calls
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 7:34 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> We recently tried to use mixed programs that have both tail calls and
> subprograms, but it needs the attached fixes.
>
> Also added a new test case tailcall_bpf2bpf_5 that simply runs the
> previous test case tailcall_bpf2bpf_4 and adds some "noise". The
> noise here is just a bunch of map calls to get the verifier to insert
> instructions and cause code movement plus it forces used_maps logic
> to be used. Originally, I just extended bpf2bpf_4 directly, but if I
> got the feedback correct it seems the preference is to have another
> test case for this specifically.
>
> With attached patches our programs are happily running with mixed
> subprograms and tailcalls.
>
> Thanks,
> John
>
> ---

Would be nice to include bpf@vger.kernel.org as well. I bet not
everyone interested in BPF follows netdev@vger closely.

>
> John Fastabend (4):
>       bpf: Fix null ptr deref with mixed tail calls and subprogs
>       bpf: map_poke_descriptor is being called with an unstable poke_tab[]
>       bpf: track subprog poke correctly
>       bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch
>
>
>  include/linux/bpf.h                           |  1 +
>  kernel/bpf/core.c                             |  6 ++--
>  kernel/bpf/verifier.c                         | 36 ++++++++++++++-----
>  .../selftests/bpf/prog_tests/tailcalls.c      | 36 +++++++++++++------
>  .../selftests/bpf/progs/tailcall_bpf2bpf4.c   | 20 ++++++++++-
>  5 files changed, 77 insertions(+), 22 deletions(-)
>
> --
>
