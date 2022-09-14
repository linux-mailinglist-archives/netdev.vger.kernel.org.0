Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A95D5B8AD4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiINOk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiINOkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:40:55 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328005B06B
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:40:52 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1853F3F12F
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1663166450;
        bh=SIyAiZxHZhjhhg6XuK5Tq4n/RcjpHTbx2lOqKDUkWXs=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=fzjEi1CNOb/xrry9L3SMq9KJrNutbBFbbzkju/4h1OaA1BhY1KJ2ShcS/0I90129E
         ODLXC0Qt5jgEgjVygx6P8undv4SDtd0adzqeJmt4xEquN/1jP/qCJdrxnXD9wVKy7U
         AaZwE0gO1Z4qaQoE4CtS7eijOVA81NMQP5x7xQ1hsPJeiGNQa2+/Y2c/zOS8jOD29C
         97aZFErKBTf5aZaKjwWnua3CEMJfAoTUfx0/t9IOTfDeLltgsj1zWsaea3u6ovKr3y
         oDtu+LVZpwx1QP41LUjdldqGycjNxJVpW054Yzrs+VgoZ4F2gPrdTafa21wdxQ+RsF
         fA0tO6AQlie5Q==
Received: by mail-pj1-f72.google.com with SMTP id x4-20020a17090a294400b002007b5f5fabso6181094pjf.7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SIyAiZxHZhjhhg6XuK5Tq4n/RcjpHTbx2lOqKDUkWXs=;
        b=rxo2ugVrPMAvHgn0YYsdJZlCCyCWMXAz8hAaMcN6qRLcbQ0tBo4nCtCuTUV+FHehcN
         /9HIycsoqOmmqS3m1pvQAXlwKPgQQXA0X0B1ev0sOGUFAb7OifceuwRAtUjw2+yEO0r/
         njkI5gYWI1ik5J6zXbeI8uLehTki8dDgB5H8tlvDhEjbMsAW09WCreC6b9s1IbSSe2If
         8+QoN7GvmHn6olozKkaVFKGd9KSI5d7piVFEOimpiCfkpNnhuXJFigpbitpCYlAmPk0N
         ZAAhPlWaU7cp1rAfCTzsfXi34mLACdRJeZAWw4TR5/Ou10pHsaPS3SiXefhgArDZR7SI
         glAA==
X-Gm-Message-State: ACrzQf0PyJMm64cVO5f2XYoegFEqg0rQHyn5csi5r9t9L8v2I3KmnlL3
        ZCt2av7IgYQhlzqH4+IAH3hUZX4u5610vyoiZ+DIiIkAsuA+FElgfTzyDm0yP/78ygIzHU94+0S
        fsujian/Rt6geOGafxycN4pZGsLzjVQRhwQ==
X-Received: by 2002:a17:90b:3e87:b0:203:b9c:f9b7 with SMTP id rj7-20020a17090b3e8700b002030b9cf9b7mr5101373pjb.93.1663166448744;
        Wed, 14 Sep 2022 07:40:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4KcA/wDL2ETtUprVMLzZFQ9CJlYKiZHg134AU3wdDyb76XoU93l3Dr1YzrfPEQphivE/m/Hg==
X-Received: by 2002:a17:90b:3e87:b0:203:b9c:f9b7 with SMTP id rj7-20020a17090b3e8700b002030b9cf9b7mr5101352pjb.93.1663166448389;
        Wed, 14 Sep 2022 07:40:48 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id g12-20020aa79f0c000000b005380c555ba1sm10626567pfr.13.2022.09.14.07.40.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Sep 2022 07:40:48 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 88E0860DBF; Wed, 14 Sep 2022 07:40:47 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 82B38A0101;
        Wed, 14 Sep 2022 07:40:47 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH] bonding: cause oops on aarch64 architecture in bond_rr_gen_slave_id
In-reply-to: <7565deb870649ba6b5995034695f1b498245617a.1663042611.git.jtoppins@redhat.com>
References: <7565deb870649ba6b5995034695f1b498245617a.1663042611.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 13 Sep 2022 00:16:51 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27974.1663166447.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 14 Sep 2022 07:40:47 -0700
Message-ID: <27975.1663166447@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>This bonding selftest causes the following kernel oops on aarch64 and
>possibly ppc64le architectures. This was reproduced on net/master commit
>64ae13ed478428135cddc2f1113dff162d8112d4 net: core: fix flow symmetric ha=
sh
>
>[  329.805838] kselftest: Running tests in drivers/net/bonding
>[  330.011028] eth0: renamed from link1_2
>[  330.220846] eth0: renamed from link1_1
>[  330.387755] bond0: (slave eth0): making interface the new active one
>[  330.394165] bond0: (slave eth0): Enslaving as an active interface with=
 an up link
>[  330.401867] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>[  334.586619] bond0: (slave eth0): Releasing backup interface
>[  334.671065] bond0: (slave eth0): Enslaving as an active interface with=
 an up link
>[  334.686773] Unable to handle kernel paging request at virtual address =
ffff2c91ac905000
>[  334.694703] Mem abort info:
>[  334.697486]   ESR =3D 0x0000000096000004
>[  334.701234]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>[  334.706536]   SET =3D 0, FnV =3D 0
>[  334.709579]   EA =3D 0, S1PTW =3D 0
>[  334.712719]   FSC =3D 0x04: level 0 translation fault
>[  334.717586] Data abort info:
>[  334.720454]   ISV =3D 0, ISS =3D 0x00000004
>[  334.724288]   CM =3D 0, WnR =3D 0
>[  334.727244] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000008044d66=
2000
>[  334.733944] [ffff2c91ac905000] pgd=3D0000000000000000, p4d=3D000000000=
0000000
>[  334.740734] Internal error: Oops: 96000004 [#1] SMP
>[  334.745602] Modules linked in: bonding tls veth rfkill sunrpc arm_spe_=
pmu vfat fat acpi_ipmi ipmi_ssif ixgbe igb i40e mdio ipmi_devintf ipmi_msg=
handler arm_cmn arm_dsu_pmu cppc_cpufreq acpi_tad fuse zram crct10dif_ce a=
st ghash_ce sbsa_gwdt nvme drm_vram_helper drm_ttm_helper nvme_core ttm xg=
ene_hwmon
>[  334.772217] CPU: 7 PID: 2214 Comm: ping Not tainted 6.0.0-rc4-00133-g6=
4ae13ed4784 #4
>[  334.779950] Hardware name: GIGABYTE R272-P31-00/MP32-AR1-00, BIOS F18v=
 (SCP: 1.08.20211002) 12/01/2021
>[  334.789244] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
>[  334.796196] pc : bond_rr_gen_slave_id+0x40/0x124 [bonding]
>[  334.801691] lr : bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]

	What line in the source code is that?  Looking at the function,
I don't really see anything that's arch specific, unless perhaps the
rr_tx_counter assignment isn't visible for some ARM cache reason (i.e.,
the dcache on the relevant cpu already had a populated cache line that's
out of date, and wasn't flushed).

	-J

>[  334.807962] sp : ffff8000221733e0
>[  334.811265] x29: ffff8000221733e0 x28: ffffdbac8572d198 x27: ffff80002=
217357c
>[  334.818392] x26: 000000000000002a x25: ffffdbacb33ee000 x24: ffff07ff9=
80fa000
>[  334.825519] x23: ffffdbacb2e398ba x22: ffff07ff98102000 x21: ffff07ff9=
81029c0
>[  334.832646] x20: 0000000000000001 x19: ffff07ff981029c0 x18: 000000000=
0000014
>[  334.839773] x17: 0000000000000000 x16: ffffdbacb1004364 x15: 0000aaaab=
e2f5a62
>[  334.846899] x14: ffff07ff8e55d968 x13: ffff07ff8e55db30 x12: 000000000=
0000000
>[  334.854026] x11: ffffdbacb21532e8 x10: 0000000000000001 x9 : ffffdbac8=
57178ec
>[  334.861153] x8 : ffff07ff9f6e5a28 x7 : 0000000000000000 x6 : 000000007=
c2b3742
>[  334.868279] x5 : ffff2c91ac905000 x4 : ffff2c91ac905000 x3 : ffff07ff9=
f554400
>[  334.875406] x2 : ffff2c91ac905000 x1 : 0000000000000001 x0 : ffff07ff9=
81029c0
>[  334.882532] Call trace:
>[  334.884967]  bond_rr_gen_slave_id+0x40/0x124 [bonding]
>[  334.890109]  bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
>[  334.896033]  __bond_start_xmit+0x128/0x3a0 [bonding]
>[  334.901001]  bond_start_xmit+0x54/0xb0 [bonding]
>[  334.905622]  dev_hard_start_xmit+0xb4/0x220
>[  334.909798]  __dev_queue_xmit+0x1a0/0x720
>[  334.913799]  arp_xmit+0x3c/0xbc
>[  334.916932]  arp_send_dst+0x98/0xd0
>[  334.920410]  arp_solicit+0xe8/0x230
>[  334.923888]  neigh_probe+0x60/0xb0
>[  334.927279]  __neigh_event_send+0x3b0/0x470
>[  334.931453]  neigh_resolve_output+0x70/0x90
>[  334.935626]  ip_finish_output2+0x158/0x514
>[  334.939714]  __ip_finish_output+0xac/0x1a4
>[  334.943800]  ip_finish_output+0x40/0xfc
>[  334.947626]  ip_output+0xf8/0x1a4
>[  334.950931]  ip_send_skb+0x5c/0x100
>[  334.954410]  ip_push_pending_frames+0x3c/0x60
>[  334.958758]  raw_sendmsg+0x458/0x6d0
>[  334.962325]  inet_sendmsg+0x50/0x80
>[  334.965805]  sock_sendmsg+0x60/0x6c
>[  334.969286]  __sys_sendto+0xc8/0x134
>[  334.972853]  __arm64_sys_sendto+0x34/0x4c
>[  334.976854]  invoke_syscall+0x78/0x100
>[  334.980594]  el0_svc_common.constprop.0+0x4c/0xf4
>[  334.985287]  do_el0_svc+0x38/0x4c
>[  334.988591]  el0_svc+0x34/0x10c
>[  334.991724]  el0t_64_sync_handler+0x11c/0x150
>[  334.996072]  el0t_64_sync+0x190/0x194
>[  334.999726] Code: b9001062 f9403c02 d53cd044 8b040042 (b8210040)
>[  335.005810] ---[ end trace 0000000000000000 ]---
>[  335.010416] Kernel panic - not syncing: Oops: Fatal exception in inter=
rupt
>[  335.017279] SMP: stopping secondary CPUs
>[  335.021374] Kernel Offset: 0x5baca8eb0000 from 0xffff800008000000
>[  335.027456] PHYS_OFFSET: 0x80000000
>[  335.030932] CPU features: 0x0000,0085c029,19805c82
>[  335.035713] Memory Limit: none
>[  335.038756] Rebooting in 180 seconds..
>
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
> .../selftests/drivers/net/bonding/Makefile    |  1 +
> .../bonding/bond-arp-interval-causes-panic.sh | 46 +++++++++++++++++++
> 2 files changed, 47 insertions(+)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-=
interval-causes-panic.sh
>
>diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools=
/testing/selftests/drivers/net/bonding/Makefile
>index ab6c54b12098..79bb06fd386a 100644
>--- a/tools/testing/selftests/drivers/net/bonding/Makefile
>+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
>@@ -2,5 +2,6 @@
> # Makefile for net selftests
> =

> TEST_PROGS :=3D bond-break-lacpdu-tx.sh
>+TEST_PROGS +=3D bond-arp-interval-causes-panic.sh
> =

> include ../../../lib.mk
>diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interva=
l-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-i=
nterval-causes-panic.sh
>new file mode 100755
>index 000000000000..0c3e5d486193
>--- /dev/null
>+++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-cause=
s-panic.sh
>@@ -0,0 +1,46 @@
>+#!/bin/sh
>+
>+# cause kernel oops in bond_rr_gen_slave_id on aarch64 and ppcle
>+# architectures
>+DEBUG=3D${DEBUG:-0}
>+
>+set -e
>+test ${DEBUG} -ne 0 && set -x
>+
>+function finish()
>+{
>+	ip -all netns delete
>+	ip link del link1_1 || true
>+}
>+
>+trap finish EXIT
>+
>+client_ip4=3D192.168.1.198
>+server_ip4=3D192.168.1.254
>+
>+# setup kernel so it reboots after causing the panic
>+echo 180 >/proc/sys/kernel/panic
>+
>+# build namespaces
>+ip link add dev link1_1 type veth peer name link1_2
>+
>+ip netns add "server"
>+ip link set dev link1_2 netns server up name eth0
>+ip netns exec server ip addr add ${server_ip4}/24 dev eth0
>+
>+ip netns add "client"
>+ip link set dev link1_1 netns client down name eth0
>+ip netns exec client ip link add dev bond0 down type bond mode 1 miimon =
100 all_slaves_active 1
>+ip netns exec client ip link set dev eth0 down master bond0
>+ip netns exec client ip link set dev bond0 up
>+ip netns exec client ip addr add ${client_ip4}/24 dev bond0
>+ip netns exec client ping -c 5 $server_ip4 >/dev/null
>+
>+ip netns exec client ip link set dev eth0 down nomaster
>+ip netns exec client ip link set dev bond0 down
>+ip netns exec client ip link set dev bond0 type bond mode 0 arp_interval=
 1000 arp_ip_target "+${server_ip4}"
>+ip netns exec client ip link set dev eth0 down master bond0
>+ip netns exec client ip link set dev bond0 up
>+ip netns exec client ping -c 5 $server_ip4 >/dev/null
>+
>+exit 0
>-- =

>2.31.1
>
