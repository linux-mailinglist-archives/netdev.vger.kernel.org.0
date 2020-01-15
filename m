Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A913D022
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgAOWbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:31:50 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36467 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:31:50 -0500
Received: by mail-qk1-f193.google.com with SMTP id a203so17355080qkc.3;
        Wed, 15 Jan 2020 14:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m3ykeEiv2DWhC3YDv/3M+ztOkLKwpMGFjEqD6cnUt4s=;
        b=cNt51iDcDZI6zelQEGvFbm8lPIlIGnZldM0f2rIq1AgcoCCdkQIbVvR19pY8xHwYlP
         7R2OMxb5sfqI39LAluJjBuUlrFm8jXcFHwHzpQsVk9IHMN/xpCMK491szpikUKk8RT8X
         m7307OpYrbxFQJI8OakwrfTa3HGJZ4eJBfI86Xby5q50ox6WVd4PzkYEVcAciFBIwS8u
         f7mRKTLIgkBP65rlD0vn09o9FPFOgGm1EUGPVidZ+W/ZFmk+dDe2ZjwrZvCB++dEJ8sV
         SkthSvzz+nTTMBTamfNnFkYTRMY01cXfsbE7dr+lHGbkVSn+2SSSqgQh18vnIuXka7P3
         jZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m3ykeEiv2DWhC3YDv/3M+ztOkLKwpMGFjEqD6cnUt4s=;
        b=cK76LIAP5ynqr0Qta/8qtkniBiwY6z2LvYl36KzJhC160HWZAgWe7jrqSs6rdz51KO
         jvOYzc5iDZ5jEMidCg5GTs6O4px3Y9vBjWG95814auLdEtPiisD6EOzE4jAM7pZ/if06
         Y73rLUhWf5YehK9/0knabFTx+SmCHoRVm0XkuQh9SeHo7s/9OBXRisdV1InonIhgnHvY
         kvxy66xTcUm0LeQKyHsjwPbDFOeJueNg0/TXS9c/A/cnPj84VMNww/UfbaRJatW8cJtH
         Mte43cYFkUJjnqhSIxlzcsWwulykNHHh+yVSJd6j9xHx2a9ykwKoTYMCxPM9qh21vYh7
         XOIg==
X-Gm-Message-State: APjAAAVLiYLb8203H9f0aSWU+jQBOW6ieGh/6E8+TWrMNMJgtQICPqfV
        ZOGrpVd0Z2SQwg49NYDkGtG7+lsqO9IdXO45MaU=
X-Google-Smtp-Source: APXvYqzukFfHfNkIeKb+uK+DszszlveC2wPehwk6e8vAwphJhtnuhVoFPfjcvFFmRoCVVG49lShaKmldjnY1Y1hDegY=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr13631663qkg.92.1579127508368;
 Wed, 15 Jan 2020 14:31:48 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
 <157909757089.1192265.9038866294345740126.stgit@toke.dk> <CAEf4BzbqY8zivZy637Xy=iTECzBAYQ7vo=M7TvsLM2Yp12bJpg@mail.gmail.com>
 <87v9pctlvn.fsf@toke.dk>
In-Reply-To: <87v9pctlvn.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 14:31:37 -0800
Message-ID: <CAEf4BzZpGe-1S5_iwS8GBw9iiyFJmDUkOaO+2qaftRn_iy5cNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/10] tools/bpf/runqslower: Fix override
 option for VMLINUX_BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 2:06 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Jan 15, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> The runqslower tool refuses to build without a file to read vmlinux BT=
F
> >> from. The build fails with an error message to override the location b=
y
> >> setting the VMLINUX_BTF variable if autodetection fails. However, the
> >> Makefile doesn't actually work with that override - the error message =
is
> >> still emitted.
> >
> > Do you have example command with VMLINUX_BTF override that didn't work
> > (and what error message was emitted)?
>
> Before this patch:
>
> $ cd ~/build/linux/tools/bpf/runqslower
> $ make
> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify it =
explicitly".  Stop.
>
> $ make VMLINUX_BTF=3D~/build/linux/vmlinux
> Makefile:18: *** "Can't detect kernel BTF, use VMLINUX_BTF to specify it =
explicitly".  Stop.

Ok, so this is strange. Try make clean and run with V=3D1, it might help
to debug this. This could happen if ~/build/linux/vmlinux doesn't
exist, but I assume you double-checked that. It works for me just fine
(Makefile won't do VMLINUX_BTF :=3D assignment, if it's defined through
make invocation, so your change should be a no-op in that regard):

$ make clean
$ make VMLINUX_BTF=3D~/linux-build/default/vmlinux V=3D1
...
.output/sbin/bpftool btf dump file ~/linux-build/default/vmlinux
format c > .output/vmlinux.h
...

Wonder what your output looks like?

>
> >> Fix this by only doing auto-detection if no override is set. And while
> >> we're at it, also look for a vmlinux file in the current kernel build =
dir
> >> if none if found on the running kernel.
> >>
> >> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/bpf/runqslower/Makefile |   16 ++++++++++------
> >>  1 file changed, 10 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Make=
file
> >> index cff2fbcd29a8..fb93ce2bf2fe 100644
> >> --- a/tools/bpf/runqslower/Makefile
> >> +++ b/tools/bpf/runqslower/Makefile
> >> @@ -10,12 +10,16 @@ CFLAGS :=3D -g -Wall
> >>
> >>  # Try to detect best kernel BTF source
> >>  KERNEL_REL :=3D $(shell uname -r)
> >> -ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
> >> -VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
> >> -else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> >> -VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
> >> -else
> >> -$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it expli=
citly")
> >> +ifeq ("$(VMLINUX_BTF)","")
> >> +  ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
> >> +  VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
> >> +  else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> >> +  VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
> >> +  else ifneq ("$(wildcard $(abspath ../../../vmlinux))","")
> >> +  VMLINUX_BTF :=3D $(abspath ../../../vmlinux)
> >
> > I'm planning to mirror runqslower into libbpf Github repo and this
> > ../../../vmlinux piece will be completely out of place in that
> > context. Also it only will help when building kernel in-tree. So I'd
> > rather not add this.
>
> Well building the kernel in-tree is something people sometimes want to do=
 ;)
>
> Specifically, the selftests depend on this, so we should at least fix
> those; but I guess it could work to just pass in VMLINUX_BTF as part of
> the make -C from the selftests dir? I'll try that...

Yes, it can be handled through VMLINUX_BTF override for selftests. As
I said, this will be a self-contained example in libbpf's Github repo,
so this "in kernel tree" assumption doesn't stand there.


>
> -Toke
>
