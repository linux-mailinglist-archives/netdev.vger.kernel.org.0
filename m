Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5536CEAC4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfJGRgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:36:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44430 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfJGRgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:36:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id u22so13389423qkk.11;
        Mon, 07 Oct 2019 10:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKJ3N5Gkd1EHgf9v1jS+8y/j1wLU+z235cHL/cyi6Nk=;
        b=fm/uxf6bKt/6ZZHQfxwik7lPI1GwNtyIdbyzGVC8UAI89rCRNtXODiltBjTlFxeR6b
         ZJbXAPFZEekrUbmM3LBKBCbK29+k2ZCY5eu8nTgxffTh0CPo7I0Mmc3SMlQ/K5dnmLhv
         SrYomkUnrpV5UDcVvnJa2rnsoWiAvraILC+Dsa6DVQmZ5M+o6GzDGGWuQd83N/hWi9u5
         +rwGhqOqGz/B9na4spKex3kiCMkVSWMKN7MtLuOzzunp3Tp9Q0ILzeYJ1/6BmQ98s4R/
         1XtWpuWjhW5U/lL8o/l5HolcRPOCb1MoVZGSr0Wr4ASThZQYt8nvWDYbH369OmgrWr5E
         wvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKJ3N5Gkd1EHgf9v1jS+8y/j1wLU+z235cHL/cyi6Nk=;
        b=SbpuFZdwqFdazq2zzePG2uAPa8hJBlH5thIdDomLUerLNUeiW3KjZWcn18VrKHSKDt
         CFPvPKYGWPILQqz5RbESrZtTm7fWTffu7RQimse4UZpHLL3vu74+3DkEY08uOyjJOb1q
         LUwMaaRLzS3SZTkTAIV3KllTUgUMv276isgAtUSV90SM003+mXP+hxzwV2dQIz9vxp5b
         XuHd/KnUUInEAr5B7yxIeG68ez+RKxk4ekBIWDP7b+WeSQ6HJ9lgjCXVbPRBxuw/8d9Y
         yLQCtSTCVjF7s8yBZy+4qrCpWKDAzw9LZZwce16IypKOsLS12QbusQOMQB5GLEvaDuPg
         eywA==
X-Gm-Message-State: APjAAAVR2UKaGNu4zKEJPz/h6CcgPf2wqibhxDmdCWtBnlMYmLza55kH
        Bwpd8nTG/k3llLi0ePUB/IlyKtKYvXeKz0x7qLw=
X-Google-Smtp-Source: APXvYqyX/aUz2suPKggKQKTyenZqkJQpdYMY/cGdvLMRRV8t2QX6SsTtWUzTeweEYrHRVzU2+Bf2LpocEIsQg+IwKnI=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr25087905qkb.437.1570469794061;
 Mon, 07 Oct 2019 10:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191007033037.2687437-1-andriin@fb.com> <CAADnVQJwA-DbzncKJ_mjxvfk6PLu0HWuqkiOTWg0nVKyV6oRXQ@mail.gmail.com>
In-Reply-To: <CAADnVQJwA-DbzncKJ_mjxvfk6PLu0HWuqkiOTWg0nVKyV6oRXQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 10:36:21 -0700
Message-ID: <CAEf4BzZchoaMjeCEJnEh8_bvZYDYNPpByW319i2xHZp9CAFExw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix dependency ordering for
 attach_probe test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 10:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Oct 6, 2019 at 8:31 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Current Makefile dependency chain is not strict enough and allows
> > test_attach_probe.o to be built before test_progs's
> > prog_test/attach_probe.o is built, which leads to assembler compainig
> > about missing included binary.
> >
> > This patch is a minimal fix to fix this issue by enforcing that
> > test_attach_probe.o (BPF object file) is built before
> > prog_tests/attach_probe.c is attempted to be compiled.
> >
> > Fixes: 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> It doesn't help.
> Before and after I still see:
> $ cd selftests/bpf/
> $ make
> ...
> /tmp/cco8plDk.s: Assembler messages:
> /tmp/cco8plDk.s:8: Error: file not found: test_attach_probe.o

:( I'll try to come up with better fix then. Thanks for checking.
