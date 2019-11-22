Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4C107B25
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVXO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:14:27 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46049 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfKVXO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:14:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id 30so9721989qtz.12;
        Fri, 22 Nov 2019 15:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRo/0YAgCktRuPB0HbBbarcytQ/1jci52QRWNjVG66s=;
        b=ZDOjyphkMHbZVGmf9gWj9FfH7PPBvzq6wS9c7rjsi2O2BMXPijqS70syHBj+fPuCgH
         38RastxoUTueOg1eesMwkRj+nhBgLAwHhYDZNZtu4Rv2/48raTQbQBOAp9rjjXnshBcN
         gmL41+BBXmooKogGPm9mU2BqdrWx0zWP9AgX5usjPmx4Q9IhDM0vjCF95m112D9gXJsa
         9SVN32T4H9F/95IpoggGEG8wIE3lN68gDCukdC1QNet4ixC7hUvF+pzeO727xqnuDvX5
         0DG8O7jDMGervAWRImXoCx+Mcee/cFpcRlCxgaS9tyKmPKgVitlI08RQzuCGM+Dzgcx2
         fvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRo/0YAgCktRuPB0HbBbarcytQ/1jci52QRWNjVG66s=;
        b=RqSWJzZWqBO0vpva/dlag0fjpTBmFuxw1sY25e8rn4DR56n5WsYD7xxmcBtj3yCXXy
         5Hl9YC19hX76c6mjyIUGRUMDWlqpr2un9wOGkprsN7BXBPrXCdofFavd/sRgwGKxBJ0/
         a5/JxnWqhJsVY6uMXWWbz3r2ViRLFrOS+/HLxABWlxpb5WP3h9feRT+MWvMbhhDm7Frb
         h7G/9utlwGDLv43gRSCpzGAkJKpbAaG2PwdG055m2yTl115505OBUhl9Tvr/xB4aQckc
         Z2vu9SuJSKsAKWWkswXT7g99n4tojsdSyopeIpKRGuPZtR+DTgCLYuIqhKQTUgVA9Cyu
         nX6Q==
X-Gm-Message-State: APjAAAWRSLqmv4G/BCFmFP/UGNB8KVdsWT7qW6/Skxd+fnFaPWPNHtAF
        Hr/3R8BW3ZZgvmOoFHf3bgVcm5kIBa+xIqJG44M1QA==
X-Google-Smtp-Source: APXvYqxsgaf/LCwkp1pZBHsDpB4grVjma7bGgbAabUrDS1VG/a9taO+nvcFW2g86jcSG4GZFLZm+mB1oU/IG/FwmV9c=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr665308qtl.171.1574464466133;
 Fri, 22 Nov 2019 15:14:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <3d6cbecbeb171117dccfe153306e479798fb608d.1574452833.git.daniel@iogearbox.net>
In-Reply-To: <3d6cbecbeb171117dccfe153306e479798fb608d.1574452833.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 15:14:15 -0800
Message-ID: <CAEf4BzbLeKYC7WJtqDkZQh6sVm4dw-aFgtUsO2Phb8DDxzaDEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 8/8] bpf, testing: add various tail call test cases
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add several BPF kselftest cases for tail calls which test the various
> patch directions, and that multiple locations are patched in same and
> different programs.
>
>   # ./test_progs -n 45
>    #45/1 tailcall_1:OK
>    #45/2 tailcall_2:OK
>    #45/3 tailcall_3:OK
>    #45/4 tailcall_4:OK
>    #45/5 tailcall_5:OK
>    #45 tailcalls:OK
>   Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED
>
> I've also verified the JITed dump after each of the rewrite cases that
> it matches expectations.
>
> Also regular test_verifier suite passes fine which contains further tail
> call tests:
>
>   # ./test_verifier
>   [...]
>   Summary: 1563 PASSED, 0 SKIPPED, 0 FAILED
>
> Checked under JIT, interpreter and JIT + hardening.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM. Thanks for adding more tests!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/tailcalls.c      | 487 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/tailcall1.c |  48 ++
>  tools/testing/selftests/bpf/progs/tailcall2.c |  59 +++
>  tools/testing/selftests/bpf/progs/tailcall3.c |  31 ++
>  tools/testing/selftests/bpf/progs/tailcall4.c |  33 ++
>  tools/testing/selftests/bpf/progs/tailcall5.c |  40 ++
>  6 files changed, 698 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall3.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall5.c
>

[...]
