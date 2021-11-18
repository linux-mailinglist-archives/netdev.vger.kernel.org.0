Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE50C45524B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242304AbhKRBlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbhKRBlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:41:42 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C30C061570;
        Wed, 17 Nov 2021 17:38:43 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id i194so13101243yba.6;
        Wed, 17 Nov 2021 17:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffX9lZnZ5C5/MWpiSmumwABgSvb0YSntYiPxoSe6be4=;
        b=LeQcW2wtvS9wBTSnyOBb+P91DyOfbjtV24PHs2ulIZrLa/01giQC+vyN1KE2hWnqIT
         Ewev4XsAF4f3rN7aoHIUtsNBN08W7brKV1UE2cQKngDESKLuhRYJgqYFHGGgeMufcQDz
         zJVTPAzkoMX8k5F8kC64SuWnA2Kmk973IzIPApNwq8bo8lyw7xUGoEXspO20+UzydXh4
         NztgVLaB9NK4nf7AEKLCkcRFn8iBtNbDbDSzVSmFqtj2h/ZeMmPysyvNHCY28SqadlLZ
         ite1wIVTVDbEfC5QeanG4Of5dJAVzHAXNr2aPhB4fHBgf6JpXOzjNIZ1SGzn1CctRAD2
         WIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffX9lZnZ5C5/MWpiSmumwABgSvb0YSntYiPxoSe6be4=;
        b=MBZIjys0419AooLU9ysxveoGP1Ztt2U+TqBsLPpAFDftQNySUWhuKd7K1wYiuivpyL
         84kGJ9/fE7hsoAW7hM8tu5nUwpG+6VUUr06s/NcfcGiRkVIf8EFUQ+VEm/Z85goePHXt
         vTuzx7G9TzyqLft7e4u6h6nTCN8kNeolMlxAlahkkFchqnSOsWDYzFqwx9J2d/f+Hlfh
         9pDrp7atfIeclQMorrwl9cGQgKTmjK4zkocfMgM7e65tIjUbzD48xViHrf620pDxmzFG
         K+/+/TA6+2yOHv57wS/EJPjE+1hVdY2gZZNYaSfxZYh3j647tz5wQSWWrpcN14fu/ASR
         1FVQ==
X-Gm-Message-State: AOAM533pQjpcrdk0IBD8FvDp8eaYppmZ24Rx2DXV3IHEq6q6MHzM2a2j
        yXJaoqCQB/X324cXdupft7o8xX8C77WRJ9kA61E=
X-Google-Smtp-Source: ABdhPJwaE6rvp6crwixYCjHbr56n9Y4PKxXBNy7QLEBZnHa0VwzHhqjp8SyzMxe/jycSk0lfGmh/czM9OVEbBYZ84vc=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr23549511ybj.504.1637199522877;
 Wed, 17 Nov 2021 17:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20211111161452.86864-1-lmb@cloudflare.com> <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
 <CACAyw99EhJ8k4f3zeQMf3pRC+L=hQhK=Rb3UwSz19wt9gnMPrA@mail.gmail.com>
 <20211118010059.c2mixoshcrcz4ywq@ast-mbp> <CAEf4Bza=ZipeiwhvUvLLs9r4dbOUQ6JQTAotmgF6tUr1DAc9pw@mail.gmail.com>
In-Reply-To: <CAEf4Bza=ZipeiwhvUvLLs9r4dbOUQ6JQTAotmgF6tUr1DAc9pw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Nov 2021 17:38:31 -0800
Message-ID: <CAEf4BzZTiyyKLg2y_dSvEEgzjSsCRCeRgt99DmFAHJyGqht8tw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
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

On Wed, Nov 17, 2021 at 5:29 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 17, 2021 at 5:01 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Nov 17, 2021 at 08:47:45AM +0000, Lorenz Bauer wrote:
> > > On Sat, 13 Nov 2021 at 01:27, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > Not sure how you've tested it, but it doesn't work in unpriv:
> > > > $ test_verifier 789
> > > > #789/u map in map state pruning FAIL
> > > > processed 26 insns (limit 1000000) max_states_per_insn 0 total_states
> > > > 2 peak_states 2 mark_read 1
> > > > #789/p map in map state pruning OK
> > >
> > > Strange, I have a script that I use for bisecting which uses a minimal
> > > .config + virtue to run a vm, plus I was debugging in gdb at the same
> > > time. I might have missed this, apologies.
> > >
> > > I guess vmtest.sh is the canonical way to run tests now?
> >
> > vmtest.sh runs test_progs only. That's the minimum bar that
>
> It runs test_progs by default, unless something else is requested. You
> can run anything inside it, e.g.:
>
> ./vmtest.sh -- ./test_maps
>
> BTW, we recently moved configs around in libbpf repo on Github, so
> this script broke. I'm sending a fix in a few minutes, hopefully.

... and of course it's not that simple. [0] recently changed how we
build qemu image and vmtest.sh had some assumptions. Some trivial
things I fixed, but I'm not too familiar with the init scripts stuff.
Adding Ilya and KP to hopefully help with this. Ilya, KP, can you
please help restore vmtest.sh functionality?

After fixing few paths:

diff --git a/tools/testing/selftests/bpf/vmtest.sh
b/tools/testing/selftests/bpf/vmtest.sh
index 027198768fad..7ea40108b85d 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -13,8 +13,8 @@ DEFAULT_COMMAND="./test_progs"
 MOUNT_DIR="mnt"
 ROOTFS_IMAGE="root.img"
 OUTPUT_DIR="$HOME/.bpf_selftests"
-KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/latest.config"
-KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/latest.config"
+KCONFIG_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/config-latest.x86_64"
+KCONFIG_API_URL="https://api.github.com/repos/libbpf/libbpf/contents/travis-ci/vmtest/configs/config-latest.x86_64"
 INDEX_URL="https://raw.githubusercontent.com/libbpf/libbpf/master/travis-ci/vmtest/configs/INDEX"
 NUM_COMPILE_JOBS="$(nproc)"
 LOG_FILE_BASE="$(date +"bpf_selftests.%Y-%m-%d_%H-%M-%S")"
@@ -85,7 +85,7 @@ newest_rootfs_version()
 {
        {
        for file in "${!URLS[@]}"; do
-               if [[ $file =~ ^libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
+               if [[ $file =~
^x86_64/libbpf-vmtest-rootfs-(.*)\.tar\.zst$ ]]; then
                        echo "${BASH_REMATCH[1]}"
                fi
        done

... the next problem is more severe. Script complains about missing
/etc/rcS.d, if I just force-created it, when kernel boots we get:


[    1.050803] ---[ end Kernel panic - not syncing: No working init
found.  Try passing init= option to kernel. See Linux
Documentation/admin-guide/init.rst for guidance. ]---


Please help.

  [0] https://github.com/libbpf/libbpf/pull/204

>
> > developers have to pass before sending patches.
> > BPF CI runs test_progs, test_progs-no_alu32, test_verifier and test_maps.
> > If in doubt run them all.
