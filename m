Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6739ED66
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFHEL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:11:56 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:34811 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhFHELz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:11:55 -0400
Received: by mail-yb1-f178.google.com with SMTP id i6so13587761ybm.1;
        Mon, 07 Jun 2021 21:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W+YYX7eX4erF8UOmYB6hJ2LH934H53RUcP2kIN4EhKg=;
        b=GI1r/+UloL43pfUTgJgLTIAaHwyht1tWz/wdZ5HVr5blyaKLbstroidAc6XT4qSJic
         S8E9CJgyVcjbKrScG8K3vrtZw0BXo42Ut4xPlFxTQmn7YgxD6yEWU2gdR00za4ohm6Cq
         Q4NQPyxBbnvpt/DDt9FCWnaqYcOz9Ulj0Ij6R9KS4LiA9KbWuZ+NkwweC/iLMu4JuOUb
         vnAhiJOG7Mol+niA69WMSGEgG6Wit6aYTHO1PQ85u+j8cZIXOhCAcMTklTBOsBcKfg6a
         64TjZhB8SiATUG8tFXP7OWB0z7KIRxoAl26ccHfzAPc0VBT8WfROy9eaG8sywzcQoGH9
         bwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W+YYX7eX4erF8UOmYB6hJ2LH934H53RUcP2kIN4EhKg=;
        b=P3q97UOt2Dp/QFSW8BL6Irg+XjZkvLSNDqgfqboNrm9m61hUdPtxvjLYrhE8/QgZJR
         5RlmfT0eeC0DPnAsaikSkTbB3lv5P+yi0v2L9I/AYvZ3YmSWs7oQtlE7xbB722BRhVao
         5uu5v+9KPy9GwM1DES3B3y5BRUpWLt29nkrgiRRFEH64aSaNyoVre/5GHJIybfFgTTK9
         pnJ74Pbj8/Fd5ZWcTKfKAgs7DWoIhCoBBrsEUZUuECcjd1gYctZ1uZx/KOQgmMVpYg39
         gqPcywxngtLR0i0mYYN828IOU+duD4QofjWKYt/CV0b5fk3kKUy6xhQxvru0N5XcRviX
         qusA==
X-Gm-Message-State: AOAM531c4kK22DYQ66KwGyWR3f6J0znEmIRPpO1/wfeSK/4me0GV0beY
        B8QN9t1HRtztCdA6q0AzLzkGhk/rELlcWTeq/dkVcZWqTg8=
X-Google-Smtp-Source: ABdhPJzO/nVFVwrF+obb/wUz+coXrAlSTjmJLfhMooTjT0BvI5mXPqU0qWT0/QlokB6QiKDyhjKisHaHihMQhvoAy5s=
X-Received: by 2002:a25:4182:: with SMTP id o124mr27953959yba.27.1623125328006;
 Mon, 07 Jun 2021 21:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-7-andrii@kernel.org> <20210607231146.1077-1-tstellar@redhat.com>
 <CAEf4Bzad7OQj9JS7GVmBjAXyxKcc-nd77gxPQfFB8_hy_Xo+_g@mail.gmail.com>
 <b1bdf1df-e3a8-1ce8-fc33-4ab40b39fb06@redhat.com> <84b3cb2c-2dff-4cd8-724c-a1b56316816b@redhat.com>
In-Reply-To: <84b3cb2c-2dff-4cd8-724c-a1b56316816b@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 21:08:36 -0700
Message-ID: <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com>
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

On Mon, Jun 7, 2021 at 7:41 PM Tom Stellard <tstellar@redhat.com> wrote:
>
> On 6/7/21 5:25 PM, Andrii Nakryiko wrote:
> > On Mon, Jun 7, 2021 at 4:12 PM Tom Stellard <tstellar@redhat.com> wrote=
:
> >>
> >>
> >> Hi,
> >>
> >>> +                               } else {
> >>> +                                       pr_warn("relocation against S=
TT_SECTION in non-exec section is not supported!\n");
> >>> +                                       return -EINVAL;
> >>> +                               }
> >>
> >> Kernel build of commit 324c92e5e0ee are failing for me with this error
> >> message:
> >>
> >> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.=
rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen ob=
ject /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.=
rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind=
_perm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linu=
x-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftes=
ts/bpf/bind_perm.o
> >> libbpf: relocation against STT_SECTION in non-exec section is not supp=
orted!
> >>
> >> What information can I provide to help debug this failure?
> >
> > Can you please send that bind_perm.o file? Also what's your `clang
> > --version` output?
> >
>
> clang version 12.0.0 (Fedora 12.0.0-2.fc35)
>
> >> I suspect this might be due to Clang commit 6a2ea84600ba ("BPF: Add
> >> more relocation kinds"), but I get a different error on 324c92e5e0ee.
> >> So meanwhile you might try applying 9f0c317f6aa1 ("libbpf: Add support
> >> for new llvm bpf relocations") from bpf-next/master and check if that
> >> helps. But please do share bind_perm.o, just to double-check what's
> >> going on.
> >>
>
> Here is bind_perm.o: https://fedorapeople.org/~tstellar/bind_perm.o
>

So somehow you end up with .eh_frame section in BPF object file, which
shouldn't ever happen. So there must be something that you are doing
differently (compiler flags or something else) that makes Clang
produce .eh_frame. So we need to figure out why .eh_frame gets
generated. Not sure how, but maybe you have some ideas of what might
be different about your build.

> Thanks,
> Tom
>
> >>
> >>>
> >>> Thanks,
> >>> Tom
> >>>
> >>
> >
>
