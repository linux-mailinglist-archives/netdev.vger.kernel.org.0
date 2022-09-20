Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2505BD89F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiITACf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiITACP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:02:15 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC152DE9
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:01:51 -0700 (PDT)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E767A3F471
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1663632107;
        bh=0z9gwsimj3U8gRhpWG28lr30ChgAUk3dF+IW2dQ9Sz0=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=TfGKcVaO3p4DnyBFS+TvYSoEed7k0kIE4Zcpe36lNusYgcYimDLwcmalJfYrN8wRH
         DGk7hHsG/olHhOltQDEqpqQRk+nTtGHLZqAKBNYaMEbeqHlBRt82nu8QXt3HTS4/Uk
         TitOi+Ok+PkhsD5yZrbjNABttD0hib/UzErgYDdzbgFaVDT4XiV1UkFUkkrjX0M5FA
         cxc02EZiXFp09Ktnx226CvvKtUQcgOL+MRIIAKEeH/AFdfST+kZf++zuRCzLFFw3UF
         1z42fcAf4TL0dZvl93hfLZYxHAf/XpGAU/Ys4kDLWhDvtMZJYJXndKMxLqsXXi8Z9B
         Q1zF16TZOBkdg==
Received: by mail-pf1-f197.google.com with SMTP id u131-20020a627989000000b0054d3cf50780so572537pfc.22
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0z9gwsimj3U8gRhpWG28lr30ChgAUk3dF+IW2dQ9Sz0=;
        b=1iNI+AvT2GPtt1nmfb50ko8dVMIgct9J+GKgvTtpOCYezPNlSnmUxyfM6AEdaB5Wfz
         nM6phwiLmnkSjDycpcKuJNZwur83R++h/k65JGOYgX+OVNBLBKUxhsWP4ZqiGn/afQ2F
         nGzAMkgrMUgRFLPXUeOEs06wbq/SImJTwYxCkxO4p9mjXxeimQ7xWytL4BxSiZy9DNeL
         Uo2PznZt8MOX+abk2iZ/giJrultcjGkMNfDWwSaW1Xgheai2taQFd/FUFYLkwlJ1M9WG
         4yOFzbN9MGYLPPB5TzMoZCUpb1rjB4mC2BLuqaYKevasgMKulfNqC7CbnyMBszdU3c32
         JXbA==
X-Gm-Message-State: ACrzQf0jfE3LIneiyhi1UxfLGk/6mz2yg3L1PJ1Z+bm3KCQ3vkPtBhNw
        RaA653nA1kl6X+sREazRnluDa2n/kEe9b7vmfmB3DBUr8cAhut3jxAkZw3rBI74GiQNpYpBma7h
        DvZD7LPW8/f+WbxiqP8HaVSGFh9RN29Gp5Q==
X-Received: by 2002:a17:90b:3a85:b0:203:2044:c26 with SMTP id om5-20020a17090b3a8500b0020320440c26mr787533pjb.109.1663632106205;
        Mon, 19 Sep 2022 17:01:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM74R/c3pU1f4l7W7lkxF5tRTDPg/ZxzLnXHi17iYw6Taz5/LHKk+A6ME4CgI0iqhgm0ncHtNQ==
X-Received: by 2002:a17:90b:3a85:b0:203:2044:c26 with SMTP id om5-20020a17090b3a8500b0020320440c26mr787509pjb.109.1663632105886;
        Mon, 19 Sep 2022 17:01:45 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id q9-20020aa79829000000b00537fb1f9f25sm20980098pfl.110.2022.09.19.17.01.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2022 17:01:45 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id CC937604E4; Mon, 19 Sep 2022 17:01:44 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C5146A0101;
        Mon, 19 Sep 2022 17:01:44 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 1/2] selftests: bonding: cause oops in bond_rr_gen_slave_id
In-reply-to: <bb3abf634d23944a24f4a9453e07c37c7b2168e9.1663628505.git.jtoppins@redhat.com>
References: <cover.1663628505.git.jtoppins@redhat.com> <bb3abf634d23944a24f4a9453e07c37c7b2168e9.1663628505.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Mon, 19 Sep 2022 19:08:45 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18170.1663632104.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 19 Sep 2022 17:01:44 -0700
Message-ID: <18171.1663632104@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>This bonding selftest causes the following kernel oops on aarch64 and
>should be architectures agnostic.
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
> .../selftests/drivers/net/bonding/Makefile    |  3 +-
> .../bonding/bond-arp-interval-causes-panic.sh | 48 +++++++++++++++++++
> 2 files changed, 50 insertions(+), 1 deletion(-)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-=
interval-causes-panic.sh
>
>diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools=
/testing/selftests/drivers/net/bonding/Makefile
>index 0f9659407969..1d866658e541 100644
>--- a/tools/testing/selftests/drivers/net/bonding/Makefile
>+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
>@@ -2,7 +2,8 @@
> # Makefile for net selftests
> =

> TEST_PROGS :=3D bond-break-lacpdu-tx.sh \
>-	      dev_addr_lists.sh
>+	      dev_addr_lists.sh \
>+	      bond-arp-interval-causes-panic.sh
> =

> TEST_FILES :=3D lag_lib.sh
> =

>diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interva=
l-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-i=
nterval-causes-panic.sh
>new file mode 100755
>index 000000000000..095c262ba74c
>--- /dev/null
>+++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-cause=
s-panic.sh
>@@ -0,0 +1,48 @@
>+#!/bin/sh
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# cause kernel oops in bond_rr_gen_slave_id
>+DEBUG=3D${DEBUG:-0}
>+
>+set -e
>+test ${DEBUG} -ne 0 && set -x
>+
>+function finish()
>+{
>+	ip -all netns delete

	Would it be friendlier to only delete the netns created by the
test itself?

	I'm not too familiar with the selftest harness, so I'm not sure
if it handles that (runs the test in a container or something), but if
the test is run directly could this clobber other netns unrelated to the
test?

	-J

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
>+ip netns exec client ip link add dev bond0 down type bond mode 1 \
>+	miimon 100 all_slaves_active 1
>+ip netns exec client ip link set dev eth0 down master bond0
>+ip netns exec client ip link set dev bond0 up
>+ip netns exec client ip addr add ${client_ip4}/24 dev bond0
>+ip netns exec client ping -c 5 $server_ip4 >/dev/null
>+
>+ip netns exec client ip link set dev eth0 down nomaster
>+ip netns exec client ip link set dev bond0 down
>+ip netns exec client ip link set dev bond0 type bond mode 0 \
>+	arp_interval 1000 arp_ip_target "+${server_ip4}"
>+ip netns exec client ip link set dev eth0 down master bond0
>+ip netns exec client ip link set dev bond0 up
>+ip netns exec client ping -c 5 $server_ip4 >/dev/null
>+
>+exit 0
>-- =

>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
