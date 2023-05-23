Return-Path: <netdev+bounces-4709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF98270DFAF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81BA9281310
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979301F199;
	Tue, 23 May 2023 14:52:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8941E4C7B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:52:36 +0000 (UTC)
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B9AFA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:52:31 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id ada2fe7eead31-43485a18d5aso3422093137.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684853550; x=1687445550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ov2Oc5u8alrp0ryIFZXMwNl4tyhrsxmBV9Vytekedzo=;
        b=UJRngDC45gNZB0uv4K61y64oN3KbgM3BohvZdO5c08tcvtp9hK4Bl2BP7/PikIv+0F
         s++3/65K8/zgPQMqnPLkaze8pMY6d4YDZU0X2MUDL0GOA5otArPyKJ1l5aVzame8PfqE
         FM5XVVdClec9fPtFuagtmYRAS9KANqaS47w1O3AKGYAXaYIupJ0pW5p1gjF409MfvX9q
         Pa5UCgM15Sy5H8OtP4/eZ6PS91vgLV0AquMhmYEGzeIVCuuYFsPVY1TsxNHbfDQWXzyt
         bcfk3SiSZkXxRtYWSc/wooRw0gIVqwY/AJIY7PYoTFZFpWVTy2uRVdypDhGrKVrEvGtb
         CW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853550; x=1687445550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ov2Oc5u8alrp0ryIFZXMwNl4tyhrsxmBV9Vytekedzo=;
        b=Hbl0Utb821XrvuzLdVi9fVGJJQWLyrsSHNmKgPpnYhguoJdJUL/2Ag31PHa/KlslZB
         TZ0P8k7dGCIeaUX5dn7bkpiNXcImOeMhEeS1hCJ+lRuwQvyIDYrXgxayCCpaecZGNjO/
         k4zmyGH/LaXWPIXOt/oNUu59zhbwrvYEIAzXrdXcCdP9gXvoDll9TBJPYXXFuLk0CNLm
         Hr8kKpqqvrN8gkJelIz7dUJaDmnRdWz1stlJgQrg4wPyhHl0m47wyR34sPG5iqqNUl9O
         sub5ooAmBTFFUC2aAY1owJYcLyK5gZtOKYhe95vCQABrz29PxFB89j5pOtDSjQF+Lkj4
         YHFg==
X-Gm-Message-State: AC+VfDyTGE+V3jSdmfCh68oFeiaFiopYZVQ9GrLvTEBoFwzop6lGtkKt
	oreUoMGfkb7quYbcav/fKsoLSWRkR3exArl/M2r8ow==
X-Google-Smtp-Source: ACHHUZ4rLhiSLlZC6XKl4l8eJWxiJ974uFE/cyJULYWv7+FRJPNbBowssp4UizoTjhEOG2R8fSqVsglW7XwIgDYE27M=
X-Received: by 2002:a05:6102:3d95:b0:436:108e:b1e9 with SMTP id
 h21-20020a0561023d9500b00436108eb1e9mr4451381vsv.12.1684853550200; Tue, 23
 May 2023 07:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522190405.880733338@linuxfoundation.org>
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 23 May 2023 20:22:18 +0530
Message-ID: <CA+G9fYs4zoTUQUnkvncEpPWvfGD6sDSXi94KXji+udMrvfm5Rg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, LTP List <ltp@lists.linux.it>, 
	Netdev <netdev@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 23 May 2023 at 00:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


NOTE:
Following are the list of intermittent failures.

LTP syscalls msync04 started failing intermittently on 6.3, 6.1 and 5.15 on
arm64 devices which are using NFS mounted rootfs and external mounted drive=
.
Where as on arm x15 device it is always fails from 6.3.2-rc1, 6.1.28-rc1
and 5.15.111-rc1.

Test log:
=3D=3D=3D=3D=3D=3D=3D=3D

tst_test.c:1634: TINFO: =3D=3D=3D Testing on vfat =3D=3D=3D
tst_test.c:1093: TINFO: Formatting /dev/loop0 with vfat opts=3D'' extra opt=
s=3D''
msync04.c:72: TPASS: msync() working correctly
tst_test.c:1634: TINFO: =3D=3D=3D Testing on ntfs =3D=3D=3D
tst_test.c:1093: TINFO: Formatting /dev/loop0 with ntfs opts=3D'' extra opt=
s=3D''
The partition start sector was not specified for /dev/loop0 and it
could not be obtained automatically.  It has been set to 0.
The number of sectors per track was not specified for /dev/loop0 and
it could not be obtained automatically.  It has been set to 0.
The number of heads was not specified for /dev/loop0 and it could not
be obtained automatically.  It has been set to 0.
To boot from a device, Windows needs the 'partition start sector', the
'sectors per track' and the 'number of heads' to be set.
Windows will not be able to boot from this device.
tst_test.c:1107: TINFO: Trying FUSE...
msync04.c:59: TFAIL: Expected dirty bit to be set after writing to
mmap()-ed area


log:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.=
3.3-365-g20efcce0526d/testrun/17163865/suite/ltp-syscalls/test/msync04/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.3.y/build/v6.=
3.3-365-g20efcce0526d/testrun/17163865/suite/ltp-syscalls/test/msync04/hist=
ory/

Test results compare across 6.3, 6.1 and 5.15.
 - https://qa-reports.linaro.org/_/comparetest/?project=3D1764&project=3D15=
97&project=3D1022&suite=3Dltp-syscalls&test=3Dmsync04


=3D=3D=3D=3D=3D
Following Perf CoreSight test cases failing intermittently on arm64
Qualcomm dragonboard 410c.


 78: CoreSight / Thread Loop 10 Threads - Check TID                  :
--- start ---
test child forked, pid 1196
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 6.477 MB
./perf-thread_loop-check-tid-10th.data ]
Thread IDs  1211 not found in perf AUX data
test child finished with -1
---- end ----
CoreSight / Thread Loop 10 Threads - Check TID: FAILED!


 79: CoreSight / Thread Loop 2 Threads - Check TID                   :
--- start ---
test child forked, pid 1285
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.005 MB
./perf-thread_loop-check-tid-2th.data ]
Thread IDs  1290 1290 not found in perf AUX data
test child finished with -1
---- end ----
CoreSight / Thread Loop 2 Threads - Check TID: FAILED!


logs:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17164102/suite/perf/test/CoreSight_Thread_Lo=
op_10_Threads__Check_TID/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17164102/suite/perf/test/CoreSight_Thread_Lo=
op_10_Threads__Check_TID/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17164102/suite/perf/test/CoreSight_Thread_Lo=
op_10_Threads__Check_TID/details/

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17164102/suite/perf/test/CoreSight_Thread_Lo=
op_2_Threads__Check_TID/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17164102/suite/perf/test/CoreSight_Thread_Lo=
op_2_Threads__Check_TID/details/


=3D=3D=3D=3D=3D

selftests: net/mptcp: diag.sh started failing on 6.1.30-rc1 but
passed on 6.3.4-rc1. This is due to changes in latest kselftest
(6.3) running on 6.1.

test logs:
=3D=3D=3D=3D=3D=3D=3D
# selftests: net/mptcp: diag.sh
# no msk on netns creation                          [  ok  ]
# listen match for dport 10000                      [  ok  ]
# listen match for sport 10000                      [  ok  ]
# listen match for saddr and sport                  [  ok  ]
# all listen sockets                                [  ok  ]
# after MPC handshake                               [  ok  ]
# ....chk remote_key                                [  ok  ]
# ....chk no fallback                               [  ok  ]
# ....chk 2 msk in use                              [ fail ] expected 2 fou=
nd 0
# ....chk 0 msk in use after flush                  [  ok  ]
# check fallback                                    [  ok  ]
# ....chk 1 msk in use                              [ fail ] expected 1 fou=
nd 0
# ....chk 0 msk in use after flush                  [  ok  ]
# many msk socket present                           [  ok  ]
# ....chk many msk in use                           [ fail ] expected
254 found 0
# ....chk 0 msk in use after flush                  [  ok  ]
not ok 4 selftests: net/mptcp: diag.sh # exit=3D11

logs:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17163977/suite/kselftest-net-mptcp/test/net_=
mptcp_diag_sh/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.=
1.29-293-ge00a3d96f756/testrun/17163977/suite/kselftest-net-mptcp/test/net_=
mptcp_diag_sh/details/


## Build
* kernel: 6.1.30-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: e00a3d96f756a884ab864ae21c22bc1b86d0844d
* git describe: v6.1.29-293-ge00a3d96f756
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
9-293-ge00a3d96f756

## Test Regressions (compared to v6.1.29)
* bcm2711-rpi-4-b, ltp-syscalls - intermittent failures
  - msync04

* dragonboard-410c, perf - intermittent failures
  - CoreSight_Thread_Loop_10_Threads__Check_TID
  - CoreSight_Thread_Loop_2_Threads__Check_TID

* qemu_i386, kselftest-net-mptcp - fails only on 32-bit architectures.
  - net_mptcp_diag_sh

## Metric Regressions (compared to v6.1.29)

## Test Fixes (compared to v6.1.29)

## Metric Fixes (compared to v6.1.29)

## Test result summary
total: 171342, pass: 147295, fail: 4403, skip: 19372, xfail: 272

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

