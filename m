Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01B455F40
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhKRPXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhKRPXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 10:23:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A45A061B3B
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637248846;
        bh=fDSaj4n747JDrUMPlz/uNu/yZWTaXEmTjYVO6855SdQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mBkZDfjzMRzfSMcNmqKbAooe07712jwjaiZCYt3eKcUEFNEIuGRAAgmOUtsiFhnlv
         gl/po49mueHA4EB62rc4dGKzUWRu/11VbwlqCraQBDcyPZMhXF4BqjjZ6jwlyIq7rR
         rW4MO+WnAFuc18X6nS3aQuXpSxKRxnsQdHrXDXcfRZnJ8PwdZHhrulndltVwrqgQcI
         u0N62TsYA0vimtTzUpHRqbJ+lvb6d64/ZlFmCzCy8+cBWfZimDbBqV77YCVoZqaR6k
         x3dr8a0/uKHjv2s9tEBAMYBoq/QjWVm3lDmntMQtNRFpxzqDrmsrz02NdCwnksnRA9
         ANRNqzlfviwUw==
Received: by mail-ed1-f53.google.com with SMTP id y13so28380216edd.13
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:20:46 -0800 (PST)
X-Gm-Message-State: AOAM530UUKj/myoHdEo0oZ2BQ+k+VLtsVILWKB7egNs2K25hETS3pybK
        +ys4jIIS8ED3n2rKfIVYywEF72flm/mi+Lk9JEgCCw==
X-Google-Smtp-Source: ABdhPJxrIyECmt0iA265eD0cyb9vvkwUMTacYpNtXPpnWBgJ7E+nmyeeG6x9UlEBQtDG163W9048JAyA5Hp/brmfTAE=
X-Received: by 2002:a17:907:7f1a:: with SMTP id qf26mr34115379ejc.543.1637248845008;
 Thu, 18 Nov 2021 07:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20211111161452.86864-1-lmb@cloudflare.com> <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
 <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com>
 <20211118010059.c2mixoshcrcz4ywq@ast-mbp> <CAEf4Bza=ZipeiwhvUvLLs9r4dbOUQ6JQTAotmgF6tUr1DAc9pw@mail.gmail.com>
 <CAEf4BzZTiyyKLg2y_dSvEEgzjSsCRCeRgt99DmFAHJyGqht8tw@mail.gmail.com> <06aa2d62d09bcd0a39898f7dcc7fb2fcdc262081.camel@linux.ibm.com>
In-Reply-To: <06aa2d62d09bcd0a39898f7dcc7fb2fcdc262081.camel@linux.ibm.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Thu, 18 Nov 2021 16:20:34 +0100
X-Gmail-Original-Message-ID: <CACYkzJ5rTQH+NgxmNv+SYc+OdYKuOLHi=_8y1RVap+SjeQUAbw@mail.gmail.com>
Message-ID: <CACYkzJ5rTQH+NgxmNv+SYc+OdYKuOLHi=_8y1RVap+SjeQUAbw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:56 PM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> On Wed, 2021-11-17 at 17:38 -0800, Andrii Nakryiko wrote:
> > On Wed, Nov 17, 2021 at 5:29 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Nov 17, 2021 at 5:01 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Nov 17, 2021 at 08:47:45AM +0000, Lorenz Bauer wrote:
> > > > > On Sat, 13 Nov 2021 at 01:27, Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > Not sure how you've tested it, but it doesn't work in unpriv:
> > > > > > $ test_verifier 789
> > > > > > #789/u map in map state pruning FAIL
> > > > > > processed 26 insns (limit 1000000) max_states_per_insn 0
> > > > > > total_states
> > > > > > 2 peak_states 2 mark_read 1
> > > > > > #789/p map in map state pruning OK
> > > > >
> > > > > Strange, I have a script that I use for bisecting which uses a
> > > > > minimal
> > > > > .config + virtue to run a vm, plus I was debugging in gdb at the
> > > > > same
> > > > > time. I might have missed this, apologies.
> > > > >
> > > > > I guess vmtest.sh is the canonical way to run tests now?
> > > >
> > > > vmtest.sh runs test_progs only. That's the minimum bar that
> > >
> > > It runs test_progs by default, unless something else is requested.
> > > You
> > > can run anything inside it, e.g.:
> > >
> > > ./vmtest.sh -- ./test_maps
> > >
> > > BTW, we recently moved configs around in libbpf repo on Github, so
> > > this script broke. I'm sending a fix in a few minutes, hopefully.
> >
> > ... and of course it's not that simple. [0] recently changed how we
> > build qemu image and vmtest.sh had some assumptions. Some trivial
> > things I fixed, but I'm not too familiar with the init scripts stuff.
> > Adding Ilya and KP to hopefully help with this. Ilya, KP, can you
> > please help restore vmtest.sh functionality?
> >
> > After fixing few paths:
> >
> > diff --git a/tools/testing/selftests/bpf/vmtest.sh
> > b/tools/testing/selftests/bpf/vmtest.sh
> > index 027198768fad..7ea40108b85d 100755
> > --- a/tools/testing/selftests/bpf/vmtest.sh
> > +++ b/tools/testing/selftests/bpf/vmtest.sh
> > @@ -13,8 +13,8 @@ DEFAULT_COMMAND="./test_progs"
> >  MOUNT_DIR="mnt"
> >  ROOTFS_IMAGE="root.img"
> >  OUTPUT_DIR="$HOME/.bpf_selftests"
> > -
> > KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/latest.config
> > "
> > -
> > KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/latest.config
> > "
> > +KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/config-latest.x86_64
> > "
> > +KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/config-latest.x86_64
> > "
> >  INDEX_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/INDEX
> > "
> >  NUM_COMPILE_JOBS="$(nproc)"
> >  LOG_FILE_BASE="$(date +"bpf_selftests.%Y-%m-%d_%H-%M-%S")"
> > @@ -85,7 +85,7 @@ newest_rootfs_version()
> >  {
> >         {
> >         for file in "${!URLS[@]}"; do
> > -               if [[ $file =~ ^libbpf-vmtest-rootfs-(.*)\.tar\.zst$
> > ]]; then
> > +               if [[ $file =~
> > ^x86_64/libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
> >                         echo "${BASH_REMATCH[1]}"
> >                 fi
> >         done
> >
> > ... the next problem is more severe. Script complains about missing
> > /etc/rcS.d, if I just force-created it, when kernel boots we get:
> >
> >
> > [    1.050803] ---[ end Kernel panic - not syncing: No working init
> > found.  Try passing init= option to kernel. See Linux
> > Documentation/admin-guide/init.rst for guidance. ]---
> >
> >
> > Please help.
> >
> >   [0] https://github.com/libbpf/libbpf/pull/204
>
> I've posted a fix, please give it a try:
>
> https://lore.kernel.org/bpf/20211118115225.1349726-1-iii@linux.ibm.com/
>
> Missing was the ${ARCH} prefix when downloading the image, so it ended
> up being empty. Now your ~/.bpf_selftests is poisoned with it, so
> you'll need to run vmtest.sh with -i switch once in order to remove the
> bad image.

Thanks for taking a look and sending a fix.
