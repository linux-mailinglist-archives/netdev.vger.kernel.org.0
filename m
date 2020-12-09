Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1171B2D4899
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgLISG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732723AbgLISGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:06:17 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F91BC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 10:05:36 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id p5so2429997iln.8
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 10:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2zYxpMJ0tRn7IYPxzXicccPrTPpFUrm4WQ3zt6xg1F4=;
        b=Y8CFaiPw68quWSBemr0gejlWnleFf7JPrJTeob6BUIwpgdlXsBtArtVtjpLExPQXzm
         M3WPwlsvGgZksdivgj7TADBNEpuHXdxGGJBatXOY2MOZjHAGCL5KnyojxL6nVE912xHS
         kY5kEAaQ8c7OxHALn9A2A0+f1cjKQFbtrrW40iqOG6cAuXS36WP4O8mXP9nupA9XOpoH
         gPf5+E+2geYCeh98ov8ViqgM6uf7t61qZveuWyeNjU05SAp6s2X+JxddeIwc283VUAjL
         aUznyfDgXEWEshZob/g00CBBvG7BXGbzyX3pQ0fR10tUGs/MTzhn9Ids2wRpQ3G7wqKl
         A5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2zYxpMJ0tRn7IYPxzXicccPrTPpFUrm4WQ3zt6xg1F4=;
        b=YgL2JC2ACmRIQV177+xiuNTISMevgDdcd4izFZHy7Os5pTVKCEws5eT+24gOD57jm5
         gojIt3TqSc282xgfelipekjsO+9Vb6nqgTDGvDjfQXW9NqwWpHsWCxeLw96lduV8NBDt
         3cxeYr1GIR1OAXYVMJreFsBXPUMHTumOyvyx31AXcRn4S2V1TBTI5nKCtxsVI2VhsNtZ
         SuTUFzeEwaMmWrITG+YWsUioiz1egt/IYeNy0bpX9XvTm3h0izDylDQ9fuuI+HXVPTqE
         NzNVdbe14OFOwS5Gz6nnWoBne8KmwKsb0FgJCv3ZxPcM2L5ESaemZCd0DeYm0OdswZyn
         A8lw==
X-Gm-Message-State: AOAM531c1uOyPIgDyMlOP5t1rHCx8lQr3FrpQ/itrL2CTdm85983EZgf
        KUquKNIyCeIl2YbKK9Up2XPWSDF/4ZGFEUtlB4NLxQ==
X-Google-Smtp-Source: ABdhPJyFARiTN6LVGM03eiz7pvNIfpshBzncL0ZCULvM6SilvYivhnIR+RrMRaB1qOoajor21BbjUvqOpBPxGT9vs9s=
X-Received: by 2002:a92:da82:: with SMTP id u2mr4434348iln.137.1607537135620;
 Wed, 09 Dec 2020 10:05:35 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
 <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
In-Reply-To: <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Dec 2020 19:05:22 +0100
Message-ID: <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
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

On Wed, Dec 9, 2020 at 6:35 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Hmm... maybe the ECN stuff has always been buggy then, and nobody cared..=
.
>


Wait a minute, maybe this part was not needed,

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd..896a7eb61d70340f69b9d3be0f7=
95fbaab1458dd
100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -270,7 +270,7 @@ static void geneve_rx(struct geneve_dev *geneve,
struct geneve_sock *gs,
                        goto rx_error;
                break;
        default:
-               goto rx_error;
+               break;
        }
        oiph =3D skb_network_header(skb);
        skb_reset_network_header(skb);


>
> On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull IP
> > header before ECN decapsulation")?
> >
> > On Wed, 9 Dec 2020 10:05:14 +0800 Jianlin Shi wrote:
> > > Hi ,
> > >
> > > I reported a bug in bugzilla.kernel.org for geneve issue:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D210569
> > >
> > > Thanks & Best Regards,
> > > Jianlin Shi
> > >
> > >
> > > On Tue, Dec 8, 2020 at 9:38 AM Jianlin Shi <jishi@redhat.com> wrote:
> > > >
> > > > Hi ,
> > > >
> > > >
> > > > On Tue, Dec 8, 2020 at 8:25 AM CKI Project <cki-project@redhat.com>=
 wrote:
> > > >>
> > > >>
> > > >> Hello,
> > > >>
> > > >> We ran automated tests on a recent commit from this kernel tree:
> > > >>
> > > >>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/gi=
t/torvalds/linux.git
> > > >>             Commit: 7059c2c00a21 - Merge branch 'for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> > > >>
> > > >> The results of these automated tests are provided below.
> > > >>
> > > >>     Overall result: FAILED (see details below)
> > > >>              Merge: OK
> > > >>            Compile: OK
> > > >>  Selftests compile: FAILED
> > > >>              Tests: FAILED
> > > >>
> > > >>     Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/ck=
i-pipeline/-/pipelines/619303
> > > >>
> > > >>     Check out our dashboard including known failures tagged by our=
 bot at
> > > >>       https://datawarehouse.internal.cki-project.org/kcidb/revisio=
ns/7748
> > > >>
> > > >> One or more kernel tests failed:
> > > >>
> > > >>     s390x:
> > > >>      =E2=9D=8C LTP
> > > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > > >>
> > > >>     ppc64le:
> > > >>      =E2=9D=8C Boot test
> > > >>      =E2=9D=8C LTP
> > > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > > >>
> > > >>     aarch64:
> > > >>      =E2=9D=8C storage: software RAID testing
> > > >>      =E2=9D=8C LTP
> > > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > > >>
> > > >>     x86_64:
> > > >>      =E2=9D=8C LTP
> > > >>      =E2=9D=8C Networking tunnel: geneve basic test
> > > >
> > > >
> > > > the basic traffic over geneve would fail, could you help to check. =
Should we report a bug or not?
> > > >
> > > >
> > > > ip netns add client
> > > >
> > > > ip netns add server
> > > >
> > > >
> > > >
> > > > ip link add veth0_c type veth peer name veth0_s
> > > >
> > > > ip link set veth0_c netns client
> > > >
> > > > ip link set veth0_s netns server
> > > >
> > > >
> > > >
> > > > ip netns exec client ip link set lo up
> > > >
> > > > ip netns exec client ip link set veth0_c up
> > > >
> > > >
> > > >
> > > > ip netns exec server ip link set lo up
> > > >
> > > > ip netns exec server ip link set veth0_s up
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > ip netns exec client ip addr add 2000::1/64 dev veth0_c
> > > >
> > > > ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c
> > > >
> > > >
> > > >
> > > > ip netns exec server ip addr add 2000::2/64 dev veth0_s
> > > >
> > > > ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s
> > > >
> > > >
> > > >
> > > > ip netns exec client ping 10.10.0.2 -c 2
> > > >
> > > > ip netns exec client ping6 2000::2 -c 2
> > > >
> > > >
> > > >
> > > > ip netns exec client ip link add geneve1 type geneve vni 1234 remot=
e 10.10.0.2 ttl 64
> > > >
> > > > ip netns exec server ip link add geneve1 type geneve vni 1234 remot=
e 10.10.0.1 ttl 64
> > > >
> > > >
> > > >
> > > > ip netns exec client ip link set geneve1 up
> > > >
> > > > ip netns exec client ip addr add 1.1.1.1/24 dev geneve1
> > > >
> > > > ip netns exec server ip link set geneve1 up
> > > >
> > > > ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
> > > > ip netns exec client ping 1.1.1.2 -c 3
> > > >
> > > >
> > > >>
> > > >>      =E2=9D=8C storage: software RAID testing
> > > >>
> > > >> We hope that these logs can help you find the problem quickly. For=
 the full
> > > >> detail on our testing procedures, please scroll to the bottom of t=
his message.
> > > >>
> > > >> Please reply to this email if you have any questions about the tes=
ts that we
> > > >> ran or if you have any suggestions on how to make future tests mor=
e effective.
> > > >>
> > > >>         ,-.   ,-.
> > > >>        ( C ) ( K )  Continuous
> > > >>         `-',-.`-'   Kernel
> > > >>           ( I )     Integration
> > > >>            `-'
> > > >> __________________________________________________________________=
____________
> > > >>
> > > >> Compile testing
> > > >> ---------------
> > > >>
> > > >> We compiled the kernel for 4 architectures:
> > > >>
> > > >>     aarch64:
> > > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > > >>
> > > >>     ppc64le:
> > > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > > >>
> > > >>     s390x:
> > > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > > >>
> > > >>     x86_64:
> > > >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> > > >>
> > > >>
> > > >> We built the following selftests:
> > > >>
> > > >>   x86_64:
> > > >>       net: OK
> > > >>       bpf: fail
> > > >>       install and packaging: OK
> > > >>
> > > >> You can find the full log (build-selftests.log) in the artifact st=
orage above.
> > > >>
> > > >>
> > > >> Hardware testing
> > > >> ----------------
> > > >> All the testing jobs are listed here:
> > > >>
> > > >>   https://beaker.engineering.redhat.com/jobs/?jobsearch-0.table=3D=
Whiteboard&jobsearch-0.operation=3Dcontains&jobsearch-0.value=3Dcki%40gitla=
b%3A619303
> > > >>
> > > >> We booted each kernel and ran the following tests:
> > > >>
> > > >>   aarch64:
> > > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156933
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > > >>        =E2=9D=8C storage: software RAID testing
> > > >>        =E2=9C=85 stress: stress-ng
> > > >>         =E2=9D=8C xfstests - ext4
> > > >>         =E2=9C=85 xfstests - xfs
> > > >>         =E2=9C=85 xfstests - btrfs
> > > >>         =E2=9D=8C IPMI driver test
> > > >>         =E2=9C=85 IPMItool loop stress test
> > > >>         =E2=9C=85 Storage blktests
> > > >>         =E2=9C=85 Storage block - filesystem fio test
> > > >>         =E2=9C=85 Storage block - queue scheduler test
> > > >>         =E2=9C=85 Storage nvme - tcp
> > > >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> > > >>
> > > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156932
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9C=85 ACPI table test
> > > >>        =E2=9C=85 ACPI enabled test
> > > >>        =E2=9D=8C LTP
> > > >>        =E2=9C=85 Loopdev Sanity
> > > >>        =E2=9C=85 Memory: fork_mem
> > > >>        =E2=9C=85 Memory function: memfd_create
> > > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > > >>        =E2=9C=85 Networking bridge: sanity
> > > >>        =E2=9C=85 Networking socket: fuzz
> > > >>        =E2=9C=85 Networking: igmp conformance test
> > > >>        =E2=9C=85 Networking route: pmtu
> > > >>        =E2=9C=85 Networking route_func - local
> > > >>        =E2=9C=85 Networking route_func - forward
> > > >>        =E2=9C=85 Networking TCP: keepalive test
> > > >>        =E2=9C=85 Networking UDP: socket
> > > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > > >>        =E2=9C=85 Networking tunnel: gre basic
> > > >>        =E2=9C=85 L2TP basic test
> > > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > > >>        =E2=9C=85 Libkcapi AF_ALG test
> > > >>        =E2=9C=85 pciutils: update pci ids test
> > > >>        =E2=9C=85 ALSA PCM loopback test
> > > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > > >>        =E2=9C=85 storage: SCSI VPD
> > > >>         =E2=9C=85 CIFS Connectathon
> > > >>         =E2=9C=85 POSIX pjd-fstest suites
> > > >>         =E2=9C=85 Firmware test suite
> > > >>         =E2=9C=85 jvm - jcstress tests
> > > >>         =E2=9C=85 Memory function: kaslr
> > > >>         =E2=9C=85 Ethernet drivers sanity
> > > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > > >>         =E2=9C=85 audit: audit testsuite test
> > > >>         =E2=9C=85 trace: ftrace/tracer
> > > >>         =E2=9C=85 kdump - kexec_boot
> > > >>
> > > >>   ppc64le:
> > > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156935
> > > >>        =E2=9D=8C Boot test
> > > >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
> > > >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio=
 test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedule=
r test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mod=
ule test
> > > >>
> > > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156934
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9D=8C LTP
> > > >>        =E2=9C=85 Loopdev Sanity
> > > >>        =E2=9C=85 Memory: fork_mem
> > > >>        =E2=9C=85 Memory function: memfd_create
> > > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > > >>        =E2=9C=85 Networking bridge: sanity
> > > >>        =E2=9C=85 Networking socket: fuzz
> > > >>        =E2=9C=85 Networking route: pmtu
> > > >>        =E2=9C=85 Networking route_func - local
> > > >>        =E2=9C=85 Networking route_func - forward
> > > >>        =E2=9C=85 Networking TCP: keepalive test
> > > >>        =E2=9C=85 Networking UDP: socket
> > > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > > >>        =E2=9C=85 Networking tunnel: gre basic
> > > >>        =E2=9C=85 L2TP basic test
> > > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > > >>        =E2=9C=85 Libkcapi AF_ALG test
> > > >>        =E2=9C=85 pciutils: update pci ids test
> > > >>        =E2=9C=85 ALSA PCM loopback test
> > > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > > >>         =E2=9C=85 CIFS Connectathon
> > > >>         =E2=9C=85 POSIX pjd-fstest suites
> > > >>         =E2=9C=85 jvm - jcstress tests
> > > >>         =E2=9C=85 Memory function: kaslr
> > > >>         =E2=9C=85 Ethernet drivers sanity
> > > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > > >>         =E2=9C=85 audit: audit testsuite test
> > > >>         =E2=9C=85 trace: ftrace/tracer
> > > >>
> > > >>   s390x:
> > > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156940
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > > >>        =E2=9C=85 stress: stress-ng
> > > >>         =E2=9C=85 Storage blktests
> > > >>         =E2=9D=8C Storage nvme - tcp
> > > >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> > > >>
> > > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156939
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9D=8C LTP
> > > >>        =E2=9C=85 Loopdev Sanity
> > > >>        =E2=9C=85 Memory: fork_mem
> > > >>        =E2=9C=85 Memory function: memfd_create
> > > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > > >>        =E2=9C=85 Networking bridge: sanity
> > > >>        =E2=9C=85 Networking route: pmtu
> > > >>        =E2=9C=85 Networking route_func - local
> > > >>        =E2=9C=85 Networking route_func - forward
> > > >>        =E2=9C=85 Networking TCP: keepalive test
> > > >>        =E2=9C=85 Networking UDP: socket
> > > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > > >>        =E2=9C=85 Networking tunnel: gre basic
> > > >>        =E2=9C=85 L2TP basic test
> > > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > > >>        =E2=9C=85 Libkcapi AF_ALG test
> > > >>         =E2=9C=85 CIFS Connectathon
> > > >>         =E2=9C=85 POSIX pjd-fstest suites
> > > >>         =E2=9C=85 jvm - jcstress tests
> > > >>         =E2=9C=85 Memory function: kaslr
> > > >>         =E2=9C=85 Ethernet drivers sanity
> > > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > > >>         =E2=9D=8C audit: audit testsuite test
> > > >>         =E2=9C=85 trace: ftrace/tracer
> > > >>
> > > >>   x86_64:
> > > >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156936
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9C=85 ACPI table test
> > > >>        =E2=9D=8C LTP
> > > >>        =E2=9C=85 Loopdev Sanity
> > > >>        =E2=9C=85 Memory: fork_mem
> > > >>        =E2=9C=85 Memory function: memfd_create
> > > >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> > > >>        =E2=9C=85 Networking bridge: sanity
> > > >>        =E2=9C=85 Networking socket: fuzz
> > > >>        =E2=9C=85 Networking: igmp conformance test
> > > >>        =E2=9C=85 Networking route: pmtu
> > > >>        =E2=9C=85 Networking route_func - local
> > > >>        =E2=9C=85 Networking route_func - forward
> > > >>        =E2=9C=85 Networking TCP: keepalive test
> > > >>        =E2=9C=85 Networking UDP: socket
> > > >>        =E2=9D=8C Networking tunnel: geneve basic test
> > > >>        =E2=9C=85 Networking tunnel: gre basic
> > > >>        =E2=9C=85 L2TP basic test
> > > >>        =E2=9C=85 Networking tunnel: vxlan basic
> > > >>        =E2=9C=85 Networking ipsec: basic netns - transport
> > > >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> > > >>        =E2=9C=85 Libkcapi AF_ALG test
> > > >>        =E2=9C=85 pciutils: sanity smoke test
> > > >>        =E2=9C=85 pciutils: update pci ids test
> > > >>        =E2=9C=85 ALSA PCM loopback test
> > > >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> > > >>        =E2=9C=85 storage: SCSI VPD
> > > >>         =E2=9C=85 CIFS Connectathon
> > > >>         =E2=9C=85 POSIX pjd-fstest suites
> > > >>         =E2=9C=85 Firmware test suite
> > > >>         =E2=9C=85 jvm - jcstress tests
> > > >>         =E2=9C=85 Memory function: kaslr
> > > >>         =E2=9C=85 Ethernet drivers sanity
> > > >>         =E2=9C=85 Networking firewall: basic netfilter test
> > > >>         =E2=9C=85 audit: audit testsuite test
> > > >>         =E2=9C=85 trace: ftrace/tracer
> > > >>         =E2=9C=85 kdump - kexec_boot
> > > >>
> > > >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156937
> > > >>        =E2=9C=85 Boot test
> > > >>         =E2=9C=85 kdump - sysrq-c
> > > >>         =E2=9C=85 kdump - file-load
> > > >>
> > > >>     Host 3: https://beaker.engineering.redhat.com/recipes/9156938
> > > >>
> > > >>        =E2=9A=A1 Internal infrastructure issues prevented one or m=
ore tests (marked
> > > >>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this arch=
itecture.
> > > >>        This is not the fault of the kernel that was tested.
> > > >>
> > > >>        =E2=9C=85 Boot test
> > > >>        =E2=9C=85 selinux-policy: serge-testsuite
> > > >>        =E2=9D=8C storage: software RAID testing
> > > >>        =E2=9C=85 stress: stress-ng
> > > >>         =E2=9D=8C CPU: Frequency Driver Test
> > > >>         =E2=9C=85 CPU: Idle Test
> > > >>         =E2=9D=8C xfstests - ext4
> > > >>         =E2=9C=85 xfstests - xfs
> > > >>         =E2=9C=85 xfstests - btrfs
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/san=
ity test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio=
 test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedule=
r test
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> > > >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mod=
ule test
> > > >>
> > > >>   Test sources: https://gitlab.com/cki-project/kernel-tests
> > > >>     Pull requests are welcome for new tests or improvements to exi=
sting tests!
> > > >>
> > > >> Aborted tests
> > > >> -------------
> > > >> Tests that didn't complete running successfully are marked with =
=E2=9A=A1=E2=9A=A1=E2=9A=A1.
> > > >> If this was caused by an infrastructure issue, we try to mark that
> > > >> explicitly in the report.
> > > >>
> > > >> Waived tests
> > > >> ------------
> > > >> If the test run included waived tests, they are marked with . Such=
 tests are
> > > >> executed but their results are not taken into account. Tests are w=
aived when
> > > >> their results are not reliable enough, e.g. when they're just intr=
oduced or are
> > > >> being fixed.
> > > >>
> > > >> Testing timeout
> > > >> ---------------
> > > >> We aim to provide a report within reasonable timeframe. Tests that=
 haven't
> > > >> finished running yet are marked with =E2=8F=B1.
> > > >>
> > > >> Reproducing results
> > > >> -------------------
> > > >> Click on a link below to access a web page that allows you to adju=
st the
> > > >> Beaker job and re-run any failed tests. These links are generated =
for
> > > >> failed or aborted tests that are not waived. Please adjust the Bea=
ker
> > > >> job whiteboard string in the web page so that it is easy for you t=
o find
> > > >> and so that it is not confused with a regular CKI job.
> > > >>
> > > >> After clicking the "Submit the job!" button, a dialog will open th=
at should
> > > >> contain a link to the newly submitted Beaker job.
> > > >>
> > > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794082&recipe_id=3D9156933&recipe_id=3D9156932&job_id=3D4794=
082
> > > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794083&recipe_id=3D9156935&recipe_id=3D9156934&job_id=3D4794=
083
> > > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794085&recipe_id=3D9156939&job_id=3D4794085
> > > >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=
=3Drespin_job_4794084&recipe_id=3D9156936&recipe_id=3D9156938&job_id=3D4794=
084
> > > >>
> > >
> >
