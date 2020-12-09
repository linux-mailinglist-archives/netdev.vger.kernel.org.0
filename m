Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEFB2D3894
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgLICHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:07:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgLICHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607479567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjX3QkifyLydUXt9avB5hNV0ZqXerXREz2PP73//2Q0=;
        b=ZdF6f+8HVzT/0mrD8ZmET0v1RDlXUVZT+kuSKQKYrwZFzrb4lZ2IdjEL1d5FlT9kkSVD2Y
        FK5yDdz9F/C+AMK16f+YZTgEENnoT5CeCysnDkTC9oc1IB/0dAVTz17PqDkwmOsq6MaBcC
        /N5mB0g7UaYDvadGsSKKHgj8L2enp/8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-5W3bY92KN3KgEYBv6ip_eg-1; Tue, 08 Dec 2020 21:06:01 -0500
X-MC-Unique: 5W3bY92KN3KgEYBv6ip_eg-1
Received: by mail-oi1-f199.google.com with SMTP id e203so35972oib.6
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fjX3QkifyLydUXt9avB5hNV0ZqXerXREz2PP73//2Q0=;
        b=q63iXYbCKEI8A4O6EzAnFjOanupcTZw1CYS25Cwr5wU4mBbZWxiRXxwSr9Z18m7rtb
         NwURGbqf6vihkGYrXNfzJPXVQKsnp2QFMuiXcLpEA5lCllVICfuWcQrljDKs7wf0gHOO
         N050FYtwjRGBX3fWdJa4Uyl3xkm8WOfGKXV6bsKUZ0S3SJjcEHm/42/7PEOgcK8Y2vXs
         1RlFDN++7B1T2boH9LNlf3HOAkY+j8bG0qulvl+ozzUUhbricNZPL09iEaTmW+Rp0g+1
         qVPWlMtWSZryzS/5+Sx8Bsvr/IVyhKKyfqake04guxitPMBGBSI72lgpy6c6ej8CXuLv
         sgXg==
X-Gm-Message-State: AOAM532TgP4Ny8Br3FIxGxfSry2tIiNjk755anllzI7Deqb1PWEEIWOo
        L17HNoRKl6bHSWVp7JgwKLiPaQCRrHdPjlawY3k7C1NzAIRtX8YlYOoACg/1n2QF4X0iNUEIb5A
        LKOPs/DLoGWgNrU9ZaowreHK/fZmcay9M
X-Received: by 2002:a9d:a4f:: with SMTP id 73mr13358otg.238.1607479560849;
        Tue, 08 Dec 2020 18:06:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdZq7fiXEzAWRq07kR7CFZz57B5ZnTMno7335XJ0CgeApWtbW6FOOOvQyKuvYKcODrMKU4yuW94vEo2GgD6Pc=
X-Received: by 2002:a9d:a4f:: with SMTP id 73mr13340otg.238.1607479560467;
 Tue, 08 Dec 2020 18:06:00 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
In-Reply-To: <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
From:   Jianlin Shi <jishi@redhat.com>
Date:   Wed, 9 Dec 2020 10:05:14 +0800
Message-ID: <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTAuMC1yYzYgKG1haQ==?=
        =?UTF-8?B?bmxpbmUua2VybmVsLm9yZyk=?=
To:     CKI Project <cki-project@redhat.com>, netdev@vger.kernel.org
Cc:     skt-results-master@redhat.com, Yi Zhang <yi.zhang@redhat.com>,
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

Hi ,

I reported a bug in bugzilla.kernel.org for geneve issue:
https://bugzilla.kernel.org/show_bug.cgi?id=3D210569

Thanks & Best Regards,
Jianlin Shi


On Tue, Dec 8, 2020 at 9:38 AM Jianlin Shi <jishi@redhat.com> wrote:
>
> Hi ,
>
>
> On Tue, Dec 8, 2020 at 8:25 AM CKI Project <cki-project@redhat.com> wrote=
:
>>
>>
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/torv=
alds/linux.git
>>             Commit: 7059c2c00a21 - Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/dtor/input
>>
>> The results of these automated tests are provided below.
>>
>>     Overall result: FAILED (see details below)
>>              Merge: OK
>>            Compile: OK
>>  Selftests compile: FAILED
>>              Tests: FAILED
>>
>>     Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipe=
line/-/pipelines/619303
>>
>>     Check out our dashboard including known failures tagged by our bot a=
t
>>       https://datawarehouse.internal.cki-project.org/kcidb/revisions/774=
8
>>
>> One or more kernel tests failed:
>>
>>     s390x:
>>      =E2=9D=8C LTP
>>      =E2=9D=8C Networking tunnel: geneve basic test
>>
>>     ppc64le:
>>      =E2=9D=8C Boot test
>>      =E2=9D=8C LTP
>>      =E2=9D=8C Networking tunnel: geneve basic test
>>
>>     aarch64:
>>      =E2=9D=8C storage: software RAID testing
>>      =E2=9D=8C LTP
>>      =E2=9D=8C Networking tunnel: geneve basic test
>>
>>     x86_64:
>>      =E2=9D=8C LTP
>>      =E2=9D=8C Networking tunnel: geneve basic test
>
>
> the basic traffic over geneve would fail, could you help to check. Should=
 we report a bug or not?
>
>
> ip netns add client
>
> ip netns add server
>
>
>
> ip link add veth0_c type veth peer name veth0_s
>
> ip link set veth0_c netns client
>
> ip link set veth0_s netns server
>
>
>
> ip netns exec client ip link set lo up
>
> ip netns exec client ip link set veth0_c up
>
>
>
> ip netns exec server ip link set lo up
>
> ip netns exec server ip link set veth0_s up
>
>
>
>
>
> ip netns exec client ip addr add 2000::1/64 dev veth0_c
>
> ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c
>
>
>
> ip netns exec server ip addr add 2000::2/64 dev veth0_s
>
> ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s
>
>
>
> ip netns exec client ping 10.10.0.2 -c 2
>
> ip netns exec client ping6 2000::2 -c 2
>
>
>
> ip netns exec client ip link add geneve1 type geneve vni 1234 remote 10.1=
0.0.2 ttl 64
>
> ip netns exec server ip link add geneve1 type geneve vni 1234 remote 10.1=
0.0.1 ttl 64
>
>
>
> ip netns exec client ip link set geneve1 up
>
> ip netns exec client ip addr add 1.1.1.1/24 dev geneve1
>
> ip netns exec server ip link set geneve1 up
>
> ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
> ip netns exec client ping 1.1.1.2 -c 3
>
>
>>
>>      =E2=9D=8C storage: software RAID testing
>>
>> We hope that these logs can help you find the problem quickly. For the f=
ull
>> detail on our testing procedures, please scroll to the bottom of this me=
ssage.
>>
>> Please reply to this email if you have any questions about the tests tha=
t we
>> ran or if you have any suggestions on how to make future tests more effe=
ctive.
>>
>>         ,-.   ,-.
>>        ( C ) ( K )  Continuous
>>         `-',-.`-'   Kernel
>>           ( I )     Integration
>>            `-'
>> ________________________________________________________________________=
______
>>
>> Compile testing
>> ---------------
>>
>> We compiled the kernel for 4 architectures:
>>
>>     aarch64:
>>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>     ppc64le:
>>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>     s390x:
>>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>     x86_64:
>>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>
>> We built the following selftests:
>>
>>   x86_64:
>>       net: OK
>>       bpf: fail
>>       install and packaging: OK
>>
>> You can find the full log (build-selftests.log) in the artifact storage =
above.
>>
>>
>> Hardware testing
>> ----------------
>> All the testing jobs are listed here:
>>
>>   https://beaker.engineering.redhat.com/jobs/?jobsearch-0.table=3DWhiteb=
oard&jobsearch-0.operation=3Dcontains&jobsearch-0.value=3Dcki%40gitlab%3A61=
9303
>>
>> We booted each kernel and ran the following tests:
>>
>>   aarch64:
>>     Host 1: https://beaker.engineering.redhat.com/recipes/9156933
>>        =E2=9C=85 Boot test
>>        =E2=9C=85 selinux-policy: serge-testsuite
>>        =E2=9D=8C storage: software RAID testing
>>        =E2=9C=85 stress: stress-ng
>>         =E2=9D=8C xfstests - ext4
>>         =E2=9C=85 xfstests - xfs
>>         =E2=9C=85 xfstests - btrfs
>>         =E2=9D=8C IPMI driver test
>>         =E2=9C=85 IPMItool loop stress test
>>         =E2=9C=85 Storage blktests
>>         =E2=9C=85 Storage block - filesystem fio test
>>         =E2=9C=85 Storage block - queue scheduler test
>>         =E2=9C=85 Storage nvme - tcp
>>         =E2=9C=85 Storage: swraid mdadm raid_module test
>>
>>     Host 2: https://beaker.engineering.redhat.com/recipes/9156932
>>        =E2=9C=85 Boot test
>>        =E2=9C=85 ACPI table test
>>        =E2=9C=85 ACPI enabled test
>>        =E2=9D=8C LTP
>>        =E2=9C=85 Loopdev Sanity
>>        =E2=9C=85 Memory: fork_mem
>>        =E2=9C=85 Memory function: memfd_create
>>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>>        =E2=9C=85 Networking bridge: sanity
>>        =E2=9C=85 Networking socket: fuzz
>>        =E2=9C=85 Networking: igmp conformance test
>>        =E2=9C=85 Networking route: pmtu
>>        =E2=9C=85 Networking route_func - local
>>        =E2=9C=85 Networking route_func - forward
>>        =E2=9C=85 Networking TCP: keepalive test
>>        =E2=9C=85 Networking UDP: socket
>>        =E2=9D=8C Networking tunnel: geneve basic test
>>        =E2=9C=85 Networking tunnel: gre basic
>>        =E2=9C=85 L2TP basic test
>>        =E2=9C=85 Networking tunnel: vxlan basic
>>        =E2=9C=85 Networking ipsec: basic netns - transport
>>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>>        =E2=9C=85 Libkcapi AF_ALG test
>>        =E2=9C=85 pciutils: update pci ids test
>>        =E2=9C=85 ALSA PCM loopback test
>>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>>        =E2=9C=85 storage: SCSI VPD
>>         =E2=9C=85 CIFS Connectathon
>>         =E2=9C=85 POSIX pjd-fstest suites
>>         =E2=9C=85 Firmware test suite
>>         =E2=9C=85 jvm - jcstress tests
>>         =E2=9C=85 Memory function: kaslr
>>         =E2=9C=85 Ethernet drivers sanity
>>         =E2=9C=85 Networking firewall: basic netfilter test
>>         =E2=9C=85 audit: audit testsuite test
>>         =E2=9C=85 trace: ftrace/tracer
>>         =E2=9C=85 kdump - kexec_boot
>>
>>   ppc64le:
>>     Host 1: https://beaker.engineering.redhat.com/recipes/9156935
>>        =E2=9D=8C Boot test
>>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module te=
st
>>
>>     Host 2: https://beaker.engineering.redhat.com/recipes/9156934
>>        =E2=9C=85 Boot test
>>        =E2=9D=8C LTP
>>        =E2=9C=85 Loopdev Sanity
>>        =E2=9C=85 Memory: fork_mem
>>        =E2=9C=85 Memory function: memfd_create
>>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>>        =E2=9C=85 Networking bridge: sanity
>>        =E2=9C=85 Networking socket: fuzz
>>        =E2=9C=85 Networking route: pmtu
>>        =E2=9C=85 Networking route_func - local
>>        =E2=9C=85 Networking route_func - forward
>>        =E2=9C=85 Networking TCP: keepalive test
>>        =E2=9C=85 Networking UDP: socket
>>        =E2=9D=8C Networking tunnel: geneve basic test
>>        =E2=9C=85 Networking tunnel: gre basic
>>        =E2=9C=85 L2TP basic test
>>        =E2=9C=85 Networking tunnel: vxlan basic
>>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>>        =E2=9C=85 Libkcapi AF_ALG test
>>        =E2=9C=85 pciutils: update pci ids test
>>        =E2=9C=85 ALSA PCM loopback test
>>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>>         =E2=9C=85 CIFS Connectathon
>>         =E2=9C=85 POSIX pjd-fstest suites
>>         =E2=9C=85 jvm - jcstress tests
>>         =E2=9C=85 Memory function: kaslr
>>         =E2=9C=85 Ethernet drivers sanity
>>         =E2=9C=85 Networking firewall: basic netfilter test
>>         =E2=9C=85 audit: audit testsuite test
>>         =E2=9C=85 trace: ftrace/tracer
>>
>>   s390x:
>>     Host 1: https://beaker.engineering.redhat.com/recipes/9156940
>>        =E2=9C=85 Boot test
>>        =E2=9C=85 selinux-policy: serge-testsuite
>>        =E2=9C=85 stress: stress-ng
>>         =E2=9C=85 Storage blktests
>>         =E2=9D=8C Storage nvme - tcp
>>         =E2=9C=85 Storage: swraid mdadm raid_module test
>>
>>     Host 2: https://beaker.engineering.redhat.com/recipes/9156939
>>        =E2=9C=85 Boot test
>>        =E2=9D=8C LTP
>>        =E2=9C=85 Loopdev Sanity
>>        =E2=9C=85 Memory: fork_mem
>>        =E2=9C=85 Memory function: memfd_create
>>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>>        =E2=9C=85 Networking bridge: sanity
>>        =E2=9C=85 Networking route: pmtu
>>        =E2=9C=85 Networking route_func - local
>>        =E2=9C=85 Networking route_func - forward
>>        =E2=9C=85 Networking TCP: keepalive test
>>        =E2=9C=85 Networking UDP: socket
>>        =E2=9D=8C Networking tunnel: geneve basic test
>>        =E2=9C=85 Networking tunnel: gre basic
>>        =E2=9C=85 L2TP basic test
>>        =E2=9C=85 Networking tunnel: vxlan basic
>>        =E2=9C=85 Networking ipsec: basic netns - transport
>>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>>        =E2=9C=85 Libkcapi AF_ALG test
>>         =E2=9C=85 CIFS Connectathon
>>         =E2=9C=85 POSIX pjd-fstest suites
>>         =E2=9C=85 jvm - jcstress tests
>>         =E2=9C=85 Memory function: kaslr
>>         =E2=9C=85 Ethernet drivers sanity
>>         =E2=9C=85 Networking firewall: basic netfilter test
>>         =E2=9D=8C audit: audit testsuite test
>>         =E2=9C=85 trace: ftrace/tracer
>>
>>   x86_64:
>>     Host 1: https://beaker.engineering.redhat.com/recipes/9156936
>>        =E2=9C=85 Boot test
>>        =E2=9C=85 ACPI table test
>>        =E2=9D=8C LTP
>>        =E2=9C=85 Loopdev Sanity
>>        =E2=9C=85 Memory: fork_mem
>>        =E2=9C=85 Memory function: memfd_create
>>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>>        =E2=9C=85 Networking bridge: sanity
>>        =E2=9C=85 Networking socket: fuzz
>>        =E2=9C=85 Networking: igmp conformance test
>>        =E2=9C=85 Networking route: pmtu
>>        =E2=9C=85 Networking route_func - local
>>        =E2=9C=85 Networking route_func - forward
>>        =E2=9C=85 Networking TCP: keepalive test
>>        =E2=9C=85 Networking UDP: socket
>>        =E2=9D=8C Networking tunnel: geneve basic test
>>        =E2=9C=85 Networking tunnel: gre basic
>>        =E2=9C=85 L2TP basic test
>>        =E2=9C=85 Networking tunnel: vxlan basic
>>        =E2=9C=85 Networking ipsec: basic netns - transport
>>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>>        =E2=9C=85 Libkcapi AF_ALG test
>>        =E2=9C=85 pciutils: sanity smoke test
>>        =E2=9C=85 pciutils: update pci ids test
>>        =E2=9C=85 ALSA PCM loopback test
>>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>>        =E2=9C=85 storage: SCSI VPD
>>         =E2=9C=85 CIFS Connectathon
>>         =E2=9C=85 POSIX pjd-fstest suites
>>         =E2=9C=85 Firmware test suite
>>         =E2=9C=85 jvm - jcstress tests
>>         =E2=9C=85 Memory function: kaslr
>>         =E2=9C=85 Ethernet drivers sanity
>>         =E2=9C=85 Networking firewall: basic netfilter test
>>         =E2=9C=85 audit: audit testsuite test
>>         =E2=9C=85 trace: ftrace/tracer
>>         =E2=9C=85 kdump - kexec_boot
>>
>>     Host 2: https://beaker.engineering.redhat.com/recipes/9156937
>>        =E2=9C=85 Boot test
>>         =E2=9C=85 kdump - sysrq-c
>>         =E2=9C=85 kdump - file-load
>>
>>     Host 3: https://beaker.engineering.redhat.com/recipes/9156938
>>
>>        =E2=9A=A1 Internal infrastructure issues prevented one or more te=
sts (marked
>>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectu=
re.
>>        This is not the fault of the kernel that was tested.
>>
>>        =E2=9C=85 Boot test
>>        =E2=9C=85 selinux-policy: serge-testsuite
>>        =E2=9D=8C storage: software RAID testing
>>        =E2=9C=85 stress: stress-ng
>>         =E2=9D=8C CPU: Frequency Driver Test
>>         =E2=9C=85 CPU: Idle Test
>>         =E2=9D=8C xfstests - ext4
>>         =E2=9C=85 xfstests - xfs
>>         =E2=9C=85 xfstests - btrfs
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanity te=
st
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module te=
st
>>
>>   Test sources: https://gitlab.com/cki-project/kernel-tests
>>     Pull requests are welcome for new tests or improvements to existing =
tests!
>>
>> Aborted tests
>> -------------
>> Tests that didn't complete running successfully are marked with =E2=9A=
=A1=E2=9A=A1=E2=9A=A1.
>> If this was caused by an infrastructure issue, we try to mark that
>> explicitly in the report.
>>
>> Waived tests
>> ------------
>> If the test run included waived tests, they are marked with . Such tests=
 are
>> executed but their results are not taken into account. Tests are waived =
when
>> their results are not reliable enough, e.g. when they're just introduced=
 or are
>> being fixed.
>>
>> Testing timeout
>> ---------------
>> We aim to provide a report within reasonable timeframe. Tests that haven=
't
>> finished running yet are marked with =E2=8F=B1.
>>
>> Reproducing results
>> -------------------
>> Click on a link below to access a web page that allows you to adjust the
>> Beaker job and re-run any failed tests. These links are generated for
>> failed or aborted tests that are not waived. Please adjust the Beaker
>> job whiteboard string in the web page so that it is easy for you to find
>> and so that it is not confused with a regular CKI job.
>>
>> After clicking the "Submit the job!" button, a dialog will open that sho=
uld
>> contain a link to the newly submitted Beaker job.
>>
>>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dres=
pin_job_4794082&recipe_id=3D9156933&recipe_id=3D9156932&job_id=3D4794082
>>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dres=
pin_job_4794083&recipe_id=3D9156935&recipe_id=3D9156934&job_id=3D4794083
>>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dres=
pin_job_4794085&recipe_id=3D9156939&job_id=3D4794085
>>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dres=
pin_job_4794084&recipe_id=3D9156936&recipe_id=3D9156938&job_id=3D4794084
>>

