Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53295CD8D8
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 21:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfJFTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 15:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfJFTTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 15:19:13 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189A521479
        for <netdev@vger.kernel.org>; Sun,  6 Oct 2019 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570389552;
        bh=ktUpIaexhlxRiG4ce7iLuw4QHFnf1O8GxwmdLQRzKQQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yoHDBSHfwn2R9DQNKNey6IjgYQQ3iKumA9xVSa4w7i0ZBbVIjDv7j4kF/rzp6dak+
         g+yjLDpx0ycO6XeI4GT37gZAk6+zY6rrqL9xPsh93vnexztlzjyD1+CL1A0VKcY7bU
         RNHZComg9ON5ELsv2hs0AaFM4rfSAe5HKQvYxpnE=
Received: by mail-wm1-f48.google.com with SMTP id i16so10340536wmd.3
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 12:19:12 -0700 (PDT)
X-Gm-Message-State: APjAAAUOU37LKD+STfyzfqGvMLfTCTZV774lFjTmBIgckfHiloIXfTBC
        QCDP2ZxkwD5d5xvCUJ5cV0V8oK+rlfYFJa/n1WvTOQ==
X-Google-Smtp-Source: APXvYqzx1ZnDJzMrKkfkPpBPdQaV6IOTwM8ALHjC39JfwEbpQY+QpI4wEbZ4dp0MU/oNOnC7f2vGFBUaGlcGv6Uudg8=
X-Received: by 2002:a1c:1bcf:: with SMTP id b198mr19073715wmb.0.1570389548492;
 Sun, 06 Oct 2019 12:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <419CB0D1-E51C-49D5-9745-7771C863462F@amacapital.net>
 <mhng-c8a768f7-1a90-4228-b654-be9e879c92ec@palmer-si-x1c4> <CALCETrUmqKz4vu2VCPC5MYGFyiG4djbOmKG32oLtQPb=o6rJ_Q@mail.gmail.com>
In-Reply-To: <CALCETrUmqKz4vu2VCPC5MYGFyiG4djbOmKG32oLtQPb=o6rJ_Q@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 6 Oct 2019 12:18:57 -0700
X-Gmail-Original-Message-ID: <CALCETrVrQf2B5T6GhoWWuMzrmvTBx9TWxEEN5ZEaXFCiajqMZg@mail.gmail.com>
Message-ID: <CALCETrVrQf2B5T6GhoWWuMzrmvTBx9TWxEEN5ZEaXFCiajqMZg@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Kees Cook <keescook@chromium.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, me@carlosedp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 1:58 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Tue, Sep 3, 2019 at 3:27 PM Palmer Dabbelt <palmer@sifive.com> wrote:
> >
> > On Wed, 28 Aug 2019 10:52:05 PDT (-0700), luto@amacapital.net wrote:
> > >
> > >
> > >> On Aug 25, 2019, at 2:59 PM, Kees Cook <keescook@chromium.org> wrote=
:
> > >>
> > >>> On Thu, Aug 22, 2019 at 01:55:22PM -0700, David Abdurachmanov wrote=
:
> > >>> This patch was extensively tested on Fedora/RISCV (applied by defau=
lt on
> > >>> top of 5.2-rc7 kernel for <2 months). The patch was also tested wit=
h 5.3-rc
> > >>> on QEMU and SiFive Unleashed board.
> > >>
> > >> Oops, I see the mention of QEMU here. Where's the best place to find
> > >> instructions on creating a qemu riscv image/environment?
> > >
> > > I don=E2=80=99t suppose one of you riscv folks would like to contribu=
te riscv support to virtme?  virtme-run =E2=80=94arch=3Driscv would be quit=
e nice, and the total patch should be just a couple lines.  Unfortunately, =
it helps a lot to understand the subtleties of booting the architecture to =
write those couple lines :)
> >

FYI, it works now:

$ virtme-configkernel --arch=3Driscv --defconfig
  GEN     Makefile
[...]
Configured.  Build with 'make ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gn=
u- -j4'

$ make ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gnu- -j4
[...]

$ virtme-run --kdir=3D. --arch=3Driscv64 --mods=3Dauto --root [path to a
riscv filesystem]

This is with virtme master and a qemu-system-riscv64 from qemu git on
my path.  It does *not* work with Fedora 30's qemu.

So now you can all jump on the virtme bandwagon and have an easy way
to test riscv kernels. :)  Although, if you want to run kernel
selftests, you may find the process of actually running them to be
more fun if you use --rodir or --rwdir to map the kernel selftests
directory into the guest.
