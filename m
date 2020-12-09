Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7A2D4807
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgLIRgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgLIRgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 12:36:21 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F7CC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 09:35:40 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id i9so2451924ioo.2
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 09:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zGJX8D4vtCSqr2DGa7PCajN4DvqzltP0M5/YVk5rOFw=;
        b=VJVnz1EbcQBn2snGfCO2iW4KtWfEZXy9hG5nUGMGe+ijtqGBU52EvlpAUMbALfznrt
         AWcUTbO1sT2YPV7pN2kSct/wR7iGCOjS5bdfDotaWvJRENUjtXDb+pthzAeZIIzmaTXB
         TiChPwAdFz285w9xLj/8qe5SJJ4oKQicuDU5ndEhHOH2vasvQ+LNXB1fDp7S8qQH3Hfx
         3Ui0KoLm/da7eR9Ff20lJ5iUNZLNuF8f8oAA0qiJc5vSiu+8bfPLslWKIg+kWErrD5fV
         Brz0FXENtckFQS9TghIzLDyg4hrm/6X50QcZd2w2e6AaxA0CKTdGQR3RyDpr6hS9ESzc
         L6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zGJX8D4vtCSqr2DGa7PCajN4DvqzltP0M5/YVk5rOFw=;
        b=JmXk9+oUndIPcLZMHuAtOLBvqi43NUcZy+Nj4EhifCcF7ME0CJclLdb05vfSPsqIJL
         kmVtUuDhNOtc/23DZc7Jv1jsdkoxo1eIxnPtUD/XnztDPHDZdU/THp4aJdYPCGPxdL6P
         h5F/dPHta7ZiUqaAphZFtKlMLrO4Xsukn6FpPHwCK0u3RrwRguNmeP9pUWl5arsy6fur
         tmwKWOohHR5mtcoOQadhaimd6cifOw52q6DA/L/RhGWZOWMe9OR2Cgqc8qPoXFHpAT6D
         YvgrIw+jNNMqNMJb+a5AoUzrCROQjOXYA4LRs0YECNKgpXgqtwO7e6X8EkkRzGpn+SqC
         BoXg==
X-Gm-Message-State: AOAM533SKU27P4LEOMbfueUkpROUJ21sRFCQNpoCsd7848aeww5Hj9fh
        zFwLvIy4IW7YfIyYf/1vG/SoQ5LjZGBfOqFpFDuBEg==
X-Google-Smtp-Source: ABdhPJwMKvIQb7Jam/+AUhBr9Qo60CxTabcd/YRygCTRFbDeHJpW5iogVn/2diDN6xh67lrMliUS8jPiLr4+vJNVdZ8=
X-Received: by 2002:a6b:928b:: with SMTP id u133mr4193045iod.145.1607535339602;
 Wed, 09 Dec 2020 09:35:39 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com> <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Dec 2020 18:35:26 +0100
Message-ID: <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTAuMC1yYzYgKG1haQ==?=
        =?UTF-8?B?bmxpbmUua2VybmVsLm9yZyk=?=
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmm... maybe the ECN stuff has always been buggy then, and nobody cared...


On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull IP
> header before ECN decapsulation")?
>
> On Wed, 9 Dec 2020 10:05:14 +0800 Jianlin Shi wrote:
> > Hi ,
> >
> > I reported a bug in bugzilla.kernel.org for geneve issue:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D210569
> >
> > Thanks & Best Regards,
> > Jianlin Shi
> >
> >
> > On Tue, Dec 8, 2020 at 9:38 AM Jianlin Shi <jishi@redhat.com> wrote:
> > >
> > > Hi ,
> > >
> > >
> > > On Tue, Dec 8, 2020 at 8:25 AM CKI Project <cki-project@redhat.com> w=
rote:
> > >>
> > >>
> > >> Hello,
> > >>
> > >> We ran automated tests on a recent commit from this kernel tree:
> > >>
> > >>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/=
torvalds/linux.git
> > >>             Commit: 7059c2c00a21 - Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> > >>
> > >> The results of these automated tests are provided below.
> > >>
> > >>     Overall result: FAILED (see details below)
> > >>              Merge: OK
> > >>            Compile: OK
> > >>  Selftests compile: FAILED
> > >>              Tests: FAILED
> > >>
> > >>     Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-=
pipeline/-/pipelines/619303
> > >>
> > >>     Check out our dashboard including known failures tagged by our b=
ot at
> > >>       https://datawarehouse.internal.cki-project.org/kcidb/revisions=
/7748
> > >>
> > >> One or more kernel tests failed:
> > >>
> > >>     s390x:
> > >>      =E2=9D=8C LTP
> > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > >>
> > >>     ppc64le:
> > >>      =E2=9D=8C Boot test
> > >>      =E2=9D=8C LTP
> > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > >>
> > >>     aarch64:
> > >>      =E2=9D=8C storage: software RAID testing
> > >>      =E2=9D=8C LTP
> > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > >>
> > >>     x86_64:
> > >>      =E2=9D=8C LTP
> > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > >
> > >
> > > the basic traffic over geneve would fail, could you help to check. Sh=
ould we report a bug or not?
> > >
> > >
> > > ip netns add client
> > >
> > > ip netns add server
> > >
> > >
> > >
> > > ip link add veth0_c type veth peer name veth0_s
> > >
> > > ip link set veth0_c netns client
> > >
> > > ip link set veth0_s netns server
> > >
> > >
> > >
> > > ip netns exec client ip link set lo up
> > >
> > > ip netns exec client ip link set veth0_c up
> > >
> > >
> > >
> > > ip netns exec server ip link set lo up
> > >
> > > ip netns exec server ip link set veth0_s up
> > >
> > >
> > >
> > >
> > >
> > > ip netns exec client ip addr add 2000::1/64 dev veth0_c
> > >
> > > ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c
> > >
> > >
> > >
> > > ip netns exec server ip addr add 2000::2/64 dev veth0_s
> > >
> > > ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s
> > >
> > >
> > >
> > > ip netns exec client ping 10.10.0.2 -c 2
> > >
> > > ip netns exec client ping6 2000::2 -c 2
> > >
> > >
> > >
> > > ip netns exec client ip link add geneve1 type geneve vni 1234 remote =
10.10.0.2 ttl 64
> > >
> > > ip netns exec server ip link add geneve1 type geneve vni 1234 remote =
10.10.0.1 ttl 64
> > >
> > >
> > >
> > > ip netns exec client ip link set geneve1 up
> > >
> > > ip netns exec client ip addr add 1.1.1.1/24 dev geneve1
> > >
> > > ip netns exec server ip link set geneve1 up
> > >
> > > ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
> > > ip netns exec client ping 1.1.1.2 -c 3
> > >
> > >
> > >>
> > >>      =E2=9D=8C storage: software RAID testing
> > >>
> > >> We hope that these logs can help you find the problem quickly. For t=
he full
> > >> detail on our testing procedures, please scroll to the bottom of thi=
s message.
> > >>
> > >> Please reply to this email if you have any questions about the tests=
 that we
> > >> ran or if you have any suggestions on how to make future tests more =
effective.
> > >>
> > >>         ,-.   ,-.
> > >>        ( C ) ( K )  Continuous
> > >>         `-',-.`-'   Kernel
> > >>           ( I )     Integration
> > >>            `-'
> > >> ____________________________________________________________________=
__________
> > >>
> > >> Compile testing
> > >> ---------------
> > >>
> > >> We compiled the kernel for 4 architectures:
> > >>
> > >>     aarch64:
> > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > >>
> > >>     ppc64le:
> > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > >>
> > >>     s390x:
> > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > >>
> > >>     x86_64:
> > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > >>
> > >>
> > >> We built the following selftests:
> > >>
> > >>   x86_64:
> > >>       net: OK
> > >>       bpf: fail
> > >>       install and packaging: OK
> > >>
> > >> You can find the full log (build-selftests.log) in the artifact stor=
age above.
> > >>
> > >>
> > >> Hardware testing
> > >> ----------------
> > >> All the testing jobs are listed here:
> > >>
> > >>   https://beaker.engineering.redhat.com/jobs/?jobsearch-0.table=3DWh=
iteboard&jobsearch-0.operation=3Dcontains&jobsearch-0.value=3Dcki%40gitlab%=
3A619303
> > >>
> > >> We booted each kernel and ran the following tests:
> > >>
> > >>   aarch64:
> > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156933
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > >>        =E2=9D=8C storage: software RAID testing
> > >>        =E2=9C=85 stress: stress-ng
> > >>         =E2=9D=8C xfstests - ext4
> > >>         =E2=9C=85 xfstests - xfs
> > >>         =E2=9C=85 xfstests - btrfs
> > >>         =E2=9D=8C IPMI driver test
> > >>         =E2=9C=85 IPMItool loop stress test
> > >>         =E2=9C=85 Storage blktests
> > >>         =E2=9C=85 Storage block - filesystem fio test
> > >>         =E2=9C=85 Storage block - queue scheduler test
> > >>         =E2=9C=85 Storage nvme - tcp
> > >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> > >>
> > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156932
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9C=85 ACPI table test
> > >>        =E2=9C=85 ACPI enabled test
> > >>        =E2=9D=8C LTP
> > >>        =E2=9C=85 Loopdev Sanity
> > >>        =E2=9C=85 Memory: fork_mem
> > >>        =E2=9C=85 Memory function: memfd_create
> > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > >>        =E2=9C=85 Networking bridge: sanity
> > >>        =E2=9C=85 Networking socket: fuzz
> > >>        =E2=9C=85 Networking: igmp conformance test
> > >>        =E2=9C=85 Networking route: pmtu
> > >>        =E2=9C=85 Networking route_func - local
> > >>        =E2=9C=85 Networking route_func - forward
> > >>        =E2=9C=85 Networking TCP: keepalive test
> > >>        =E2=9C=85 Networking UDP: socket
> > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > >>        =E2=9C=85 Networking tunnel: gre basic
> > >>        =E2=9C=85 L2TP basic test
> > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > >>        =E2=9C=85 Libkcapi AF_ALG test
> > >>        =E2=9C=85 pciutils: update pci ids test
> > >>        =E2=9C=85 ALSA PCM loopback test
> > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > >>        =E2=9C=85 storage: SCSI VPD
> > >>         =E2=9C=85 CIFS Connectathon
> > >>         =E2=9C=85 POSIX pjd-fstest suites
> > >>         =E2=9C=85 Firmware test suite
> > >>         =E2=9C=85 jvm - jcstress tests
> > >>         =E2=9C=85 Memory function: kaslr
> > >>         =E2=9C=85 Ethernet drivers sanity
> > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > >>         =E2=9C=85 audit: audit testsuite test
> > >>         =E2=9C=85 trace: ftrace/tracer
> > >>         =E2=9C=85 kdump - kexec_boot
> > >>
> > >>   ppc64le:
> > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156935
> > >>        =E2=9D=8C Boot test
> > >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
> > >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio t=
est
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler =
test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_modul=
e test
> > >>
> > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156934
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9D=8C LTP
> > >>        =E2=9C=85 Loopdev Sanity
> > >>        =E2=9C=85 Memory: fork_mem
> > >>        =E2=9C=85 Memory function: memfd_create
> > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > >>        =E2=9C=85 Networking bridge: sanity
> > >>        =E2=9C=85 Networking socket: fuzz
> > >>        =E2=9C=85 Networking route: pmtu
> > >>        =E2=9C=85 Networking route_func - local
> > >>        =E2=9C=85 Networking route_func - forward
> > >>        =E2=9C=85 Networking TCP: keepalive test
> > >>        =E2=9C=85 Networking UDP: socket
> > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > >>        =E2=9C=85 Networking tunnel: gre basic
> > >>        =E2=9C=85 L2TP basic test
> > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > >>        =E2=9C=85 Libkcapi AF_ALG test
> > >>        =E2=9C=85 pciutils: update pci ids test
> > >>        =E2=9C=85 ALSA PCM loopback test
> > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > >>         =E2=9C=85 CIFS Connectathon
> > >>         =E2=9C=85 POSIX pjd-fstest suites
> > >>         =E2=9C=85 jvm - jcstress tests
> > >>         =E2=9C=85 Memory function: kaslr
> > >>         =E2=9C=85 Ethernet drivers sanity
> > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > >>         =E2=9C=85 audit: audit testsuite test
> > >>         =E2=9C=85 trace: ftrace/tracer
> > >>
> > >>   s390x:
> > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156940
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > >>        =E2=9C=85 stress: stress-ng
> > >>         =E2=9C=85 Storage blktests
> > >>         =E2=9D=8C Storage nvme - tcp
> > >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> > >>
> > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156939
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9D=8C LTP
> > >>        =E2=9C=85 Loopdev Sanity
> > >>        =E2=9C=85 Memory: fork_mem
> > >>        =E2=9C=85 Memory function: memfd_create
> > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > >>        =E2=9C=85 Networking bridge: sanity
> > >>        =E2=9C=85 Networking route: pmtu
> > >>        =E2=9C=85 Networking route_func - local
> > >>        =E2=9C=85 Networking route_func - forward
> > >>        =E2=9C=85 Networking TCP: keepalive test
> > >>        =E2=9C=85 Networking UDP: socket
> > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > >>        =E2=9C=85 Networking tunnel: gre basic
> > >>        =E2=9C=85 L2TP basic test
> > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > >>        =E2=9C=85 Libkcapi AF_ALG test
> > >>         =E2=9C=85 CIFS Connectathon
> > >>         =E2=9C=85 POSIX pjd-fstest suites
> > >>         =E2=9C=85 jvm - jcstress tests
> > >>         =E2=9C=85 Memory function: kaslr
> > >>         =E2=9C=85 Ethernet drivers sanity
> > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > >>         =E2=9D=8C audit: audit testsuite test
> > >>         =E2=9C=85 trace: ftrace/tracer
> > >>
> > >>   x86_64:
> > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156936
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9C=85 ACPI table test
> > >>        =E2=9D=8C LTP
> > >>        =E2=9C=85 Loopdev Sanity
> > >>        =E2=9C=85 Memory: fork_mem
> > >>        =E2=9C=85 Memory function: memfd_create
> > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > >>        =E2=9C=85 Networking bridge: sanity
> > >>        =E2=9C=85 Networking socket: fuzz
> > >>        =E2=9C=85 Networking: igmp conformance test
> > >>        =E2=9C=85 Networking route: pmtu
> > >>        =E2=9C=85 Networking route_func - local
> > >>        =E2=9C=85 Networking route_func - forward
> > >>        =E2=9C=85 Networking TCP: keepalive test
> > >>        =E2=9C=85 Networking UDP: socket
> > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > >>        =E2=9C=85 Networking tunnel: gre basic
> > >>        =E2=9C=85 L2TP basic test
> > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > >>        =E2=9C=85 Libkcapi AF_ALG test
> > >>        =E2=9C=85 pciutils: sanity smoke test
> > >>        =E2=9C=85 pciutils: update pci ids test
> > >>        =E2=9C=85 ALSA PCM loopback test
> > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > >>        =E2=9C=85 storage: SCSI VPD
> > >>         =E2=9C=85 CIFS Connectathon
> > >>         =E2=9C=85 POSIX pjd-fstest suites
> > >>         =E2=9C=85 Firmware test suite
> > >>         =E2=9C=85 jvm - jcstress tests
> > >>         =E2=9C=85 Memory function: kaslr
> > >>         =E2=9C=85 Ethernet drivers sanity
> > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > >>         =E2=9C=85 audit: audit testsuite test
> > >>         =E2=9C=85 trace: ftrace/tracer
> > >>         =E2=9C=85 kdump - kexec_boot
> > >>
> > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156937
> > >>        =E2=9C=85 Boot test
> > >>         =E2=9C=85 kdump - sysrq-c
> > >>         =E2=9C=85 kdump - file-load
> > >>
> > >>     Host 3: https://beaker.engineering.redhat.com/recipes/9156938
> > >>
> > >>        =E2=9A=A1 Internal infrastructure issues prevented one or mor=
e tests (marked
> > >>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this archit=
ecture.
> > >>        This is not the fault of the kernel that was tested.
> > >>
> > >>        =E2=9C=85 Boot test
> > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > >>        =E2=9D=8C storage: software RAID testing
> > >>        =E2=9C=85 stress: stress-ng
> > >>         =E2=9D=8C CPU: Frequency Driver Test
> > >>         =E2=9C=85 CPU: Idle Test
> > >>         =E2=9D=8C xfstests - ext4
> > >>         =E2=9C=85 xfstests - xfs
> > >>         =E2=9C=85 xfstests - btrfs
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanit=
y test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio t=
est
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler =
test
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_modul=
e test
> > >>
> > >>   Test sources: https://gitlab.com/cki-project/kernel-tests
> > >>     Pull requests are welcome for new tests or improvements to exist=
ing tests!
> > >>
> > >> Aborted tests
> > >> -------------
> > >> Tests that didn't complete running successfully are marked with =E2=
=9A=A1=E2=9A=A1=E2=9A=A1.
> > >> If this was caused by an infrastructure issue, we try to mark that
> > >> explicitly in the report.
> > >>
> > >> Waived tests
> > >> ------------
> > >> If the test run included waived tests, they are marked with . Such t=
ests are
> > >> executed but their results are not taken into account. Tests are wai=
ved when
> > >> their results are not reliable enough, e.g. when they're just introd=
uced or are
> > >> being fixed.
> > >>
> > >> Testing timeout
> > >> ---------------
> > >> We aim to provide a report within reasonable timeframe. Tests that h=
aven't
> > >> finished running yet are marked with =E2=8F=B1.
> > >>
> > >> Reproducing results
> > >> -------------------
> > >> Click on a link below to access a web page that allows you to adjust=
 the
> > >> Beaker job and re-run any failed tests. These links are generated fo=
r
> > >> failed or aborted tests that are not waived. Please adjust the Beake=
r
> > >> job whiteboard string in the web page so that it is easy for you to =
find
> > >> and so that it is not confused with a regular CKI job.
> > >>
> > >> After clicking the "Submit the job!" button, a dialog will open that=
 should
> > >> contain a link to the newly submitted Beaker job.
> > >>
> > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794082&recipe_id=3D9156933&recipe_id=3D9156932&job_id=3D4794=
082
> > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794083&recipe_id=3D9156935&recipe_id=3D9156934&job_id=3D4794=
083
> > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794085&recipe_id=3D9156939&job_id=3D4794085
> > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794084&recipe_id=3D9156936&recipe_id=3D9156938&job_id=3D4794=
084
> > >>
> >
>
