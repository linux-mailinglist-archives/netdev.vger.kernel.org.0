Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECF41CBF2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346249AbhI2Si3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345967AbhI2SiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 14:38:22 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD615C061765
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 11:36:40 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b15so14490793lfe.7
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=30gTw4/rMDKI6yq7yX+hC0yjowpbiiQ805lH/tDCQ54=;
        b=p1AeK2LRGxvcimtWPi7gRnDb50BhdiI8hPHI/ieGfA0AM9FnZgZ6aDtFa55oqG/g/x
         fB/ZitDqxw0k9tCccEC8A69ggx+MsObevkxyiwfRw56dc+rLMetiN9t3DQgz/4vt+ifi
         asy2xYm5Jy6t9erLoEitWfCug5tY+bpoNGXKxfHH4RkTH7awiGbckKiSOiQ8f1vvjd7s
         /s88xg/Hg2H4IQ7hvrFqt7Re/XLfah0Tb2o1fvwRIfqb+ACR78mMS8ukMa+7rVQjA+Lc
         w1ML+3+aY6s5RROfNOMb3oYCevLs9NiCRKmkNzq1VIyTGVMd2aWRU4hua7EQlJ+GOFDk
         eHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=30gTw4/rMDKI6yq7yX+hC0yjowpbiiQ805lH/tDCQ54=;
        b=IP3Hs5fVbE7hG9Hvk7ypBW5W8Ymth8VjOR/0Z7m0IH1cr6Q0mFTZIUbdykRd6qulMK
         MBBIcfYkTyWOiS92xD5a8LkaJn7tI02xyLs5T+kp+wt1m6mY2jEMEHXNebwgoCQDi/cq
         QmA1S2vvG/8Y9IUhXktki+oBG5O4h6qo7+PaqvCBu8sCZBlk+y+sPpNkYqdVBfItnThg
         dkKY6yUXJZrclBzJwpIjYItP1FoOsZmuHt0GwAgJCvfjFXE+qWJufwRtjsxdqfOUCyWj
         KpgDqbK/MMtvTI2pfXx0b/ngs3bXmQxWtZlIQZtY9CqVJR34BbDZVgdyQfsoWyd9KMuV
         5VsQ==
X-Gm-Message-State: AOAM532YsWILEsGq7IZScgtcop+nccbhOjTzcu6Rnv9qhgs8PGz5lCTI
        NVmjjfBGnvdnfnDur2tlWfDW2lz/Z0PGMFhxLnwebA==
X-Google-Smtp-Source: ABdhPJxbSa3iBTQHzsjyqJp8X0riqQ6PzO0B+GzOjGNQOpJg5j+H9cojxJYqf7N0BmHwYSMGlw8wonmW1eRYsArx6+k=
X-Received: by 2002:ac2:489b:: with SMTP id x27mr1128184lfc.43.1632940598743;
 Wed, 29 Sep 2021 11:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <a507efa7-066b-decf-8605-89cdb0ac1951.ref@schaufler-ca.com>
 <a507efa7-066b-decf-8605-89cdb0ac1951@schaufler-ca.com> <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
 <dd58bbf5-7983-ca26-c335-6bf8e492fcaa@schaufler-ca.com> <CAP_N_Z9iCP_xNNNSRVEzgGER7Zg+bb_nROzBUct=V6UyWn1P5A@mail.gmail.com>
 <2409eb92-aff5-7e1f-db9d-3c3ff3a12ad7@schaufler-ca.com> <5fd9974b-531b-b7e9-81d3-ffefbad3ee96@schaufler-ca.com>
In-Reply-To: <5fd9974b-531b-b7e9-81d3-ffefbad3ee96@schaufler-ca.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Wed, 29 Sep 2021 11:36:28 -0700
Message-ID: <CAP_N_Z93qyofipbRzdq2MmzhzsgPFC43+790fpxjRwGNcbwcig@mail.gmail.com>
Subject: Re: [External] Re: Regression in unix stream sockets with the Smack LSM
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 8:44 AM Casey Schaufler <casey@schaufler-ca.com> wr=
ote:
>
> On 9/20/2021 4:44 PM, Casey Schaufler wrote:
> > On 9/20/2021 3:35 PM, Jiang Wang . wrote:
> >> On Wed, Sep 15, 2021 at 9:52 AM Casey Schaufler <casey@schaufler-ca.co=
m> wrote:
> >>> On 9/13/2021 4:47 PM, Paul Moore wrote:
> >>>> On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.=
com> wrote:
> >>>>> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
> >>>>>
> >>>>>         af_unix: Add read_sock for stream socket types
> >>>>>
> >>>>> introduced a regression in UDS socket connections for the Smack LSM=
.
> >>>>> I have not tracked done the details of why the change broke the cod=
e,
> >>>>> but this is where bisecting the kernel indicates the problem lies, =
and
> >>>>> I have verified that reverting this change repairs the problem.
> >>>>>
> >>>>> You can verify the problem with the Smack test suite:
> >>>>>
> >>>>>         https://github.com/smack-team/smack-testsuite.git
> >>>>>
> >>>>> The failing test is tests/uds-access.sh.
> >>>>>
> >> I tried to reproduce with tests/uds-access.sh, but the first two test
> >> cases always failed.
>
> Just piping in that the behavior hasn't changed in 5.15-rc3.
> It still usually fails, with the occasional success. These
> tests used to succeed.
>
Got it. I am still working on it. I noticed that I did not enable smack
related kernel configs in my previous tests. I will try again.
Also, just to make sure, could you send me your kernel config?

I think there is a chance that other commits break the test, but I
will test more to make sure. Thanks.

> > That was my initial impression as well. However, when I started
> > running the tests outside the routine "make test-results" I started
> > observing that they succeeded irregularly.
> >
> > My biggest concern is that the test ever fails. The uds-access test
> > has not failed in several releases. The erratic behavior just adds
> > spice to the problem.
> >
> >>  I tried different kernels with and without my
> >> unix-stream sockmap patches. Also tried standard debian 4.19
> >> kernel and they all have the same result.  What distro did you use? ce=
ntos?
> >> Fedora?
> > I have been testing on Fedora32 and Fedora34.
> >
> >>  Have you tested on debian based distros?
> > Ubuntu 20.04.3 with a 5.15-rc1 kernel is exhibiting the same
> > behavior. The Ubuntu system fails the test more regularly, but
> > does succeed on occasion.
> >
> >> failing log:
> >> root@gitlab-runner-stretch:~/smack-testsuite# tests/uds-access.sh -v
> > # tools/clean-targets.sh
> > # tests/uds-access.sh -v
> >
> > will remove the UDS filesystem entry before the test runs.
> >
> >
> >> mkdir: cannot create directory =E2=80=98./targets/uds-notroot=E2=80=99=
: File exists
> >> tests/uds-access.sh:71 FAIL
> >> tests/uds-access.sh:76 FAIL
> >> tests/uds-access.sh:81 PASS
> >> tests/uds-access.sh:86 PASS
> >> tests/uds-access.sh:91 PASS
> >> tests/uds-access.sh PASS=3D3 FAIL=3D2
> >> root@gitlab-runner-stretch:~/smack-testsuite# uname -a
> >> Linux gitlab-runner-stretch 5.14.0-rc5.bm.1-amd64+ #6 SMP Mon Sep 20
> >> 22:01:10 UTC 2021 x86_64 GNU/Linux
> >> root@gitlab-runner-stretch:~/smack-testsuite#
> >>
> >>>>> I have not looked to see if there's a similar problem with SELinux.
> >>>>> There may be, but if there isn't it doesn't matter, there's still a
> >>>>> bug.
> >>>> FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
> >>>> looks like this code is only in v5.15) but as Casey said, a regressi=
on
> >>>> is a regression.
> >>>>
> >>>> Casey, what actually fails on the Smack system with this commit?
> >>> This problem occurs with security=3Dnone as well as with security=3Ds=
mack.
> >>>
> >>> There isn't a problem with connect, that always works correctly.
> >>> The problem is an unexpected read() failure in the connecting process=
.
> >>> This doesn't occur all the time, and sometimes happens in the first
> >>> of my two tests, sometimes the second, sometimes neither and, you gue=
ssed
> >>> it, sometimes both.
> >>>
> >>> Here's a sample socat log demonstrating the problem. The first run,
> >>> ending at "uds-access RC=3D0" behaves as expected. The second, ending
> >>> at "uds-access RC=3D1", demonstrates the read failure. This case was
> >> I tried to compare logs between RC=3D0 and RC=3D1, but they look  to m=
e
> >> not apple to apple comparison? The read syscall have different paramet=
ers
> >> and the syscall sequences are different. I am not sure which syscall
> >> is the first failure.  See more comments below.
> > The data being feed to socat is the Smack label, so the data passed acr=
oss
> > the socket will be of different length ("Pop" vs. "Snap") between the
> > two test cases, but that should be the only difference.
> >
> >
> >>> run with Smack enabled, but I see the same problem with the same
> >>> unpredictability on the same kernel with security=3Dnone.
> >>>
> >>> I've tried to convince myself that there's a flaw in the way I've
> >>> set up the scripts. They've been pretty robust and I've never seen
> >>> socat behaving erratically before. I've instrumented the kernel
> >>> code and all the security checks are behaving as expected. Plus,
> >>> as I mentioned above, the problem also occurs without an LSM.
> >>>
> >>> 2021/09/15 08:49:50 socat[2215] D getpid()
> >>> 2021/09/15 08:49:50 socat[2215] D getpid() -> 2215
> >>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PID", "2215", 1)
> >>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PPID", "2215", 1)
> >>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] I socat by Gerhard Rieger and contrib=
utors - see www.dest-unreach.org
> >>> 2021/09/15 08:49:50 socat[2215] I This product includes software deve=
loped by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.op=
enssl.org/)
> >>> 2021/09/15 08:49:50 socat[2215] I This product includes software writ=
ten by Tim Hudson (tjh@cryptsoft.com)
> >>> 2021/09/15 08:49:50 socat[2215] D socat version 1.7.4.1 on Jan 27 202=
1 00:00:00
> >>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_VERSION", "1.7.4.1", =
1)
> >>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D running on Linux version #58 SMP We=
d Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
> >>>
> >>> 2021/09/15 08:49:50 socat[2215] D argv[0]: "socat"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[1]: "-d"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[2]: "-d"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[3]: "-d"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[4]: "-d"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[5]: "-"
> >>> 2021/09/15 08:49:50 socat[2215] D argv[6]: "UNIX-CONNECT:./targets/ud=
s-notroot/uds-access-socket"
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(1, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(2, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(3, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(4, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(6, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(7, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(8, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(11, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction(15, 0x7fffaec50b50, 0x0)
> >>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D signal(13, 0x1)
> >>> 2021/09/15 08:49:50 socat[2215] D signal() -> 0x0
> >>> 2021/09/15 08:49:50 socat[2215] D atexit(0x55aa5d645110)
> >>> 2021/09/15 08:49:50 socat[2215] D atexit() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D xioopen("-")
> >>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> >>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f0139d0
> >>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
> >>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f013d30
> >>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> >>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014140
> >>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> >>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014bc0
> >>> 2021/09/15 08:49:50 socat[2215] D isatty(0)
> >>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D isatty(1)
> >>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> >>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f00
> >>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> >>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f90
> >>> 2021/09/15 08:49:50 socat[2215] N reading from and writing to stdio
> >>> 2021/09/15 08:49:50 socat[2215] D xioopen("UNIX-CONNECT:./targets/uds=
-notroot/uds-access-socket")
> >>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
> >>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f015020
> >>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
> >>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015360
> >>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
> >>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015770
> >>> 2021/09/15 08:49:50 socat[2215] N opening connection to AF=3D1 "./tar=
gets/uds-notroot/uds-access-socket"
> >>> 2021/09/15 08:49:50 socat[2215] D socket(1, 1, 0)
> >>> 2021/09/15 08:49:50 socat[2215] I socket(1, 1, 0) -> 5
> >>> 2021/09/15 08:49:50 socat[2215] D fcntl(5, 2, 1)
> >>> 2021/09/15 08:49:50 socat[2215] D fcntl() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D connect(5, {1,AF=3D1 "./targets/uds=
-notroot/uds-access-socket"}, 41)
> >>> 2021/09/15 08:49:50 socat[2215] D connect() -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D getsockname(5, 0x7fffaec50580, 0x7f=
ffaec50564{112})
> >>> 2021/09/15 08:49:50 socat[2215] D getsockname(, {AF=3D1 "<anon>"}, {2=
}) -> 0
> >>> 2021/09/15 08:49:50 socat[2215] N successfully connected from local a=
ddress AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
> >>> 2021/09/15 08:49:50 socat[2215] I resolved and opened all sock addres=
ses
> >>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(0x7fffaec50b28, 4096=
, 16385)
> >>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(...) -> 0
> >>> 2021/09/15 08:49:50 socat[2215] N starting data transfer loop with FD=
s [0,1] and [5,5]
> >>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->e=
of=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
> >>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/=
0.000000)
> >>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/=
0.000000), 4
> >>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
> >>> 2021/09/15 08:49:50 socat[2215] D read -> 4
> >>> 2021/09/15 08:49:50 socat[2215] D write(5, 0x55aa5f016000, 4)
> >>> Pop
> >>> 2021/09/15 08:49:50 socat[2215] D write -> 4
> >>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 0 to 5
> >>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
> >>> 2021/09/15 08:49:50 socat[2215] D read -> 4
> >>> 2021/09/15 08:49:50 socat[2215] D write(1, 0x55aa5f016000, 4)
> >>> Pop
> >>> 2021/09/15 08:49:50 socat[2215] D write -> 4
> >>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 5 to 1
> >>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->e=
of=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
> >>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/=
0.000000)
> >>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/=
0.000000), 4
> >>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
> >>> 2021/09/15 08:49:50 socat[2215] D read -> 0
> >>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
> >>> 2021/09/15 08:49:50 socat[2215] D read -> 0
> >>> 2021/09/15 08:49:50 socat[2215] N socket 1 (fd 0) is at EOF
> >>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 1)
> >>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
> >>> 2021/09/15 08:49:50 socat[2215] N socket 2 (fd 5) is at EOF
> >>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 2)
> >>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
> >>> 2021/09/15 08:49:50 socat[2215] N exiting with status 0
> >>> 2021/09/15 08:49:50 socat[2215] D exit(0)
> >>> 2021/09/15 08:49:50 socat[2215] D starting xioexit()
> >>> 2021/09/15 08:49:50 socat[2215] D finished xioexit()
> >>> uds-access RC=3D0
> >>> 2021/09/15 08:49:52 socat[2240] D getpid()
> >>> 2021/09/15 08:49:52 socat[2240] D getpid() -> 2240
> >>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PID", "2240", 1)
> >>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PPID", "2240", 1)
> >>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] I socat by Gerhard Rieger and contrib=
utors - see www.dest-unreach.org
> >>> 2021/09/15 08:49:52 socat[2240] I This product includes software deve=
loped by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.op=
enssl.org/)
> >>> 2021/09/15 08:49:52 socat[2240] I This product includes software writ=
ten by Tim Hudson (tjh@cryptsoft.com)
> >>> 2021/09/15 08:49:52 socat[2240] D socat version 1.7.4.1 on Jan 27 202=
1 00:00:00
> >>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_VERSION", "1.7.4.1", =
1)
> >>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D running on Linux version #58 SMP We=
d Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
> >>>
> >>> 2021/09/15 08:49:52 socat[2240] D argv[0]: "socat"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[1]: "-d"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[2]: "-d"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[3]: "-d"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[4]: "-d"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[5]: "-"
> >>> 2021/09/15 08:49:52 socat[2240] D argv[6]: "UNIX-CONNECT:./targets/ud=
s-notroot/uds-access-socket"
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(1, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(2, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(3, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(4, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(6, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(7, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(8, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(11, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction(15, 0x7ffcca7e26c0, 0x0)
> >>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D signal(13, 0x1)
> >>> 2021/09/15 08:49:52 socat[2240] D signal() -> 0x0
> >>> 2021/09/15 08:49:52 socat[2240] D atexit(0x560590a15110)
> >>> 2021/09/15 08:49:52 socat[2240] D atexit() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D xioopen("-")
> >>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> >>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e899d0
> >>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
> >>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e89d30
> >>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> >>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8a140
> >>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> >>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8abc0
> >>> 2021/09/15 08:49:52 socat[2240] D isatty(0)
> >>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D isatty(1)
> >>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> >>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af00
> >>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> >>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af90
> >>> 2021/09/15 08:49:52 socat[2240] N reading from and writing to stdio
> >>> 2021/09/15 08:49:52 socat[2240] D xioopen("UNIX-CONNECT:./targets/uds=
-notroot/uds-access-socket")
> >>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
> >>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8b020
> >>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
> >>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b360
> >>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
> >>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b770
> >>> 2021/09/15 08:49:52 socat[2240] N opening connection to AF=3D1 "./tar=
gets/uds-notroot/uds-access-socket"
> >>> 2021/09/15 08:49:52 socat[2240] D socket(1, 1, 0)
> >>> 2021/09/15 08:49:52 socat[2240] I socket(1, 1, 0) -> 5
> >>> 2021/09/15 08:49:52 socat[2240] D fcntl(5, 2, 1)
> >>> 2021/09/15 08:49:52 socat[2240] D fcntl() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D connect(5, {1,AF=3D1 "./targets/uds=
-notroot/uds-access-socket"}, 41)
> >>> 2021/09/15 08:49:52 socat[2240] D connect() -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D getsockname(5, 0x7ffcca7e20f0, 0x7f=
fcca7e20d4{112})
> >>> 2021/09/15 08:49:52 socat[2240] D getsockname(, {AF=3D1 "<anon>"}, {2=
}) -> 0
> >>> 2021/09/15 08:49:52 socat[2240] N successfully connected from local a=
ddress AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
> >>> 2021/09/15 08:49:52 socat[2240] I resolved and opened all sock addres=
ses
> >>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(0x7ffcca7e2698, 4096=
, 16385)
> >>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(...) -> 0
> >>> 2021/09/15 08:49:52 socat[2240] N starting data transfer loop with FD=
s [0,1] and [5,5]
> >>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->e=
of=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
> >>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x22, &0x0, NULL/=
0.000000)
> >>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x22, 0x0, NULL/0=
.000000), 3
> >>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
> >>> 2021/09/15 08:49:52 socat[2240] D read -> 5
> >>> 2021/09/15 08:49:52 socat[2240] D write(5, 0x560591e8c000, 5)
> >>> 2021/09/15 08:49:52 socat[2240] D write -> 5
> >>> 2021/09/15 08:49:52 socat[2240] I transferred 5 bytes from 0 to 5
> >>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->e=
of=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
> >>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x20, &0x0, NULL/=
0.000000)
> >>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x20, 0x0, NULL/0=
.000000), 2
> >>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
> >>> 2021/09/15 08:49:52 socat[2240] D read -> 0
> >>> 2021/09/15 08:49:52 socat[2240] N socket 1 (fd 0) is at EOF
> >>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 1)
> >>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
> >> Is this shutdown expected?
> > I'm not an expert on the internals of socat, but I don't think it
> > is expected.
> >
> >> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D3, sock2->eo=
f=3D0, closing=3D1, wasaction=3D1, total_to=3D{0.000000}
> >> 2021/09/15 08:49:52 socat[2240] D select(6, &0x20, &0x0, &0x0, &0.5000=
00)
> >> Snap
> >> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x20, 0x0, 0x0, &0.5000=
00), 1
> >> 2021/09/15 08:49:52 socat[2240] D read(5, 0x560591e8c000, 8192)
> >> 2021/09/15 08:49:52 socat[2240] D read -> -1
> >> This read failure seems due to the previous shutdown, right?
> > Again, I'm not the socat expert, but that would seem reasonable
> > to me.
> >
> >
> >>> 2021/09/15 08:49:52 socat[2240] E read(5, 0x560591e8c000, 8192): Inva=
lid argument
> >>> 2021/09/15 08:49:52 socat[2240] N exit(1)
> >>> 2021/09/15 08:49:52 socat[2240] D starting xioexit()
> >>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 2)
> >>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
> >>> 2021/09/15 08:49:52 socat[2240] D finished xioexit()
> >>> uds-access RC=3D1
> >>>
> >>>
> >>>
> >>>
