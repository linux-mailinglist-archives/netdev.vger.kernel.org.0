Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BAF65EF41
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjAEOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbjAEOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:49:55 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A25D414
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:49:41 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id o63so33496385vsc.10
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 06:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fqp0IL0vPx+WyxKibSi8EubINlKC1unlnZNjm/c7cRM=;
        b=F+siEV4aLITsQCjiU1Qs8wQrFy2AWdBhhk11oAPKnAhxB8fm43lmnsAlhC4gNM0h4I
         7EOHIdW4NtTIc7DSJJsXFmMRPE0j14mfzk4RfBu9M65hVcPCeGGaidqEtg0BktKxMEkL
         iLRloSDCLDK56HkE/8dxWyj2UIyfSmYp3W+O4+5oHaBfGKUPc6GwMGgeclo0j3J9gzJg
         BzlszB9X7kf5lczUBpDWvp/S/kNgRAjZzkXLPw2q2wgRY6MN8E5MIYjIyayWLXIybKtE
         vwHqSyEiFV0u/IJf8mCKiV64+FukZ6XsARvcfhqNJxAkHdhLruTCVPye6NvqdHglKcKk
         qw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fqp0IL0vPx+WyxKibSi8EubINlKC1unlnZNjm/c7cRM=;
        b=af3nh/CRVfm2XPC08ww32xg2lWGloVF6JewKCdM+WZOEpz0T7rU8TuQpgYcbuM5Tdd
         hv0D1az+tBbR1f0Rpw3FnoUR8gd7vEUdezsc2HjaSXrPFSUtINfvpqRIegSaVjiWWh+a
         uf/F7p7z63TmAaXLjfApah3ZItk9vt5W6iWsVuqQH08BoFU7NW/MhYeFSG2ZMNhNDzoQ
         r9WCC3qQ2oOWsE1ArhocHlqIHKPcPiUVDo/4pbAD6t4bF2mnCI6PKBBRJBqx1teyZDQW
         o+3OQt3l4XJR06j+8mxclsejyYM1A2Z6JbDKjMhSUF5DSmQXYSydEpkYUhcesX8FZif2
         riGA==
X-Gm-Message-State: AFqh2krwddUiaKh8VG1abkPhr7lx8fx+CBNqD5vn3IwhaesYuqxBMQ+l
        gIudvpykJzFcIVVOszoI2FivbsyDKdfxQGlc/Q/5jg==
X-Google-Smtp-Source: AMrXdXtEJw3EZH9EpXnc2Ogay85hUvGleLv1XAj0mDfcwC4642b3IoOsluGjf7d3z/jsZ0SLsWNk3meUmpY5w6WKJUY=
X-Received: by 2002:a05:6102:b0a:b0:3c7:dfdb:a6a2 with SMTP id
 b10-20020a0561020b0a00b003c7dfdba6a2mr4136444vst.34.1672930178753; Thu, 05
 Jan 2023 06:49:38 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Jan 2023 20:19:27 +0530
Message-ID: <CA+G9fYsTr9_r893+62u6UGD3dVaCE-kN9C-Apmb2m=hxjc1Cqg@mail.gmail.com>
Subject: selftests: tc-testing: tdc.sh - WARNING: inconsistent lock state on
 arm x15
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel warnings noticed on arm beagleboard X15 device while running
selftests: tc-testing: tdc.sh with stable-rc 6.1.

This is always reproducible with kselftest merge configs.
The build, config, vmlinux and test details links provided [1].

[  228.686798] WARNING: inconsistent lock state
[  228.193450] WARNING: CPU: 1 PID: 2386 at
include/linux/u64_stats_sync.h:145
__u64_stats_update_begin+0x180/0x1a4 [sch_gred]
[  228.439208] WARNING: CPU: 1 PID: 2386 at
include/linux/seqlock.h:269 __u64_stats_update_begin+0x1a0/0x1a4
[sch_gred

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[  204.305236] kselftest: Running tests in tc-testing
TAP version 13
1..1
# selftests: tc-testing: tdc.sh
# considering category actions
#  -- buildebpf/SubPlugin.__init__
# Unable to import the scapy python module.
#
# If not already installed, you may do so with:
# pip3 install scapy==2.4.2
[  207.264129] IPv6: ADDRCONF(NETDEV_CHANGE): v0p1: link becomes ready
[  207.271331] IPv6: ADDRCONF(NETDEV_CHANGE): v0p0: link becomes ready
[  228.188781] ------------[ cut here ]------------
[  228.193450] WARNING: CPU: 1 PID: 2386 at
include/linux/u64_stats_sync.h:145
__u64_stats_update_begin+0x180/0x1a4 [sch_gred]
[  228.204803] Modules linked in: sch_gred sch_multiq sch_cake
netdevsim psample iptable_raw ip6_tables vrf iptable_filter xt_state
ip_tables x_tables nft_masq nft_nat nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 veth nf_tables libcrc32c nfnetlink
cfg80211 bluetooth snd_soc_simple_card snd_soc_simple_card_utils
etnaviv gpu_sched onboard_usb_hub snd_soc_davinci_mcasp
snd_soc_ti_udma snd_soc_ti_edma snd_soc_ti_sdma snd_soc_core ac97_bus
snd_pcm_dmaengine snd_pcm snd_timer snd soundcore display_connector
sch_fq_codel fuse
[  228.252777] CPU: 1 PID: 2386 Comm: tc Not tainted 6.1.4-rc1 #1
[  228.258666] Hardware name: Generic DRA74X (Flattened Device Tree)
[  228.264770]  unwind_backtrace from show_stack+0x18/0x1c
[  228.270050]  show_stack from dump_stack_lvl+0x58/0x70
[  228.275146]  dump_stack_lvl from __warn+0xd0/0x1f0
[  228.279968]  __warn from warn_slowpath_fmt+0x64/0xc8
[  228.284973]  warn_slowpath_fmt from
__u64_stats_update_begin+0x180/0x1a4 [sch_gred]
[  228.292694]  __u64_stats_update_begin [sch_gred] from
gred_dump+0x1c0/0x790 [sch_gred]
[  228.300689]  gred_dump [sch_gred] from tc_fill_qdisc+0x154/0x44c
[  228.306732]  tc_fill_qdisc from qdisc_notify+0x11c/0x130
[  228.312072]  qdisc_notify from qdisc_graft+0x440/0x624
[  228.317260]  qdisc_graft from tc_modify_qdisc+0x558/0x850
[  228.322692]  tc_modify_qdisc from rtnetlink_rcv_msg+0x180/0x56c
[  228.328674]  rtnetlink_rcv_msg from netlink_rcv_skb+0xc0/0x118
[  228.334533]  netlink_rcv_skb from netlink_unicast+0x19c/0x268
[  228.340301]  netlink_unicast from netlink_sendmsg+0x1f8/0x484
[  228.346099]  netlink_sendmsg from ____sys_sendmsg+0x224/0x2bc
[  228.351898]  ____sys_sendmsg from ___sys_sendmsg+0x70/0x9c
[  228.357421]  ___sys_sendmsg from sys_sendmsg+0x54/0x90
[  228.362579]  sys_sendmsg from ret_fast_syscall+0x0/0x1c
[  228.367858] Exception stack(0xf03f9fa8 to 0xf03f9ff0)
[  228.372955] 9fa0:                   00000000 00000001 00000003
bee09bdc 00000000 00000000
[  228.381164] 9fc0: 00000000 00000001 b6f78800 00000128 626ad2dc
00000000 00000000 00076000
[  228.389373] 9fe0: 00000128 bee09b78 b6dff253 b6d71ae6
[  228.394561] irq event stamp: 25529
[  228.398040] hardirqs last  enabled at (25551): [<c03da980>]
__up_console_sem+0x58/0x68
[  228.406005] hardirqs last disabled at (25558): [<c03da96c>]
__up_console_sem+0x44/0x68
[  228.414001] softirqs last  enabled at (25548): [<c0301fc8>]
__do_softirq+0x300/0x538
[  228.421844] softirqs last disabled at (25537): [<c035a224>]
__irq_exit_rcu+0x14c/0x170
[  228.429870] ---[ end trace 0000000000000000 ]---
[  228.434509] ------------[ cut here ]------------
[  228.439208] WARNING: CPU: 1 PID: 2386 at
include/linux/seqlock.h:269 __u64_stats_update_begin+0x1a0/0x1a4
[sch_gred]
[  228.449829] Modules linked in: sch_gred sch_multiq sch_cake
netdevsim psample iptable_raw ip6_tables vrf iptable_filter xt_state
ip_tables x_tables nft_masq nft_nat nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 veth nf_tables libcrc32c nfnetlink
cfg80211 bluetooth snd_soc_simple_card snd_soc_simple_card_utils
etnaviv gpu_sched onboard_usb_hub snd_soc_davinci_mcasp
snd_soc_ti_udma snd_soc_ti_edma snd_soc_ti_sdma snd_soc_core ac97_bus
snd_pcm_dmaengine snd_pcm snd_timer snd soundcore display_connector
sch_fq_codel fuse
[  228.497802] CPU: 1 PID: 2386 Comm: tc Tainted: G        W
6.1.4-rc1 #1
[  228.505157] Hardware name: Generic DRA74X (Flattened Device Tree)
[  228.511291]  unwind_backtrace from show_stack+0x18/0x1c
[  228.516571]  show_stack from dump_stack_lvl+0x58/0x70
[  228.521636]  dump_stack_lvl from __warn+0xd0/0x1f0
[  228.526458]  __warn from warn_slowpath_fmt+0x64/0xc8
[  228.531494]  warn_slowpath_fmt from
__u64_stats_update_begin+0x1a0/0x1a4 [sch_gred]
[  228.539184]  __u64_stats_update_begin [sch_gred] from
gred_dump+0x1c0/0x790 [sch_gred]
[  228.547180]  gred_dump [sch_gred] from tc_fill_qdisc+0x154/0x44c
[  228.553222]  tc_fill_qdisc from qdisc_notify+0x11c/0x130
[  228.558593]  qdisc_notify from qdisc_graft+0x440/0x624
[  228.563751]  qdisc_graft from tc_modify_qdisc+0x558/0x850
[  228.569183]  tc_modify_qdisc from rtnetlink_rcv_msg+0x180/0x56c
[  228.575164]  rtnetlink_rcv_msg from netlink_rcv_skb+0xc0/0x118
[  228.581024]  netlink_rcv_skb from netlink_unicast+0x19c/0x268
[  228.586822]  netlink_unicast from netlink_sendmsg+0x1f8/0x484
[  228.592590]  netlink_sendmsg from ____sys_sendmsg+0x224/0x2bc
[  228.598388]  ____sys_sendmsg from ___sys_sendmsg+0x70/0x9c
[  228.603912]  ___sys_sendmsg from sys_sendmsg+0x54/0x90
[  228.609100]  sys_sendmsg from ret_fast_syscall+0x0/0x1c
[  228.614349] Exception stack(0xf03f9fa8 to 0xf03f9ff0)
[  228.619415] 9fa0:                   00000000 00000001 00000003
bee09bdc 00000000 00000000
[  228.627655] 9fc0: 00000000 00000001 b6f78800 00000128 626ad2dc
00000000 00000000 00076000
[  228.635864] 9fe0: 00000128 bee09b78 b6dff253 b6d71ae6
[  228.641052] irq event stamp: 25921
[  228.644470] hardirqs last  enabled at (25929): [<c03da980>]
__up_console_sem+0x58/0x68
[  228.652465] hardirqs last disabled at (25938): [<c03da96c>]
__up_console_sem+0x44/0x68
[  228.660491] softirqs last  enabled at (25920): [<c0301fc8>]
__do_softirq+0x300/0x538
[  228.668334] softirqs last disabled at (25957): [<c035a224>]
__irq_exit_rcu+0x14c/0x170
[  228.676300] ---[ end trace 0000000000000000 ]---
[  228.680999]
[  228.682495] ================================
[  228.686798] WARNING: inconsistent lock state
[  228.691070] 6.1.4-rc1 #1 Tainted: G        W
[  228.696136] --------------------------------
[  228.700439] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  228.706481] tc/2386 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  228.711303] c96870b4 (&syncp->seq#14){+.?.}-{0:0}, at:
gred_dump+0x1c0/0x790 [sch_gred]
[  228.719360] {IN-SOFTIRQ-W} state was registered at:
[  228.724273]   __u64_stats_update_begin+0x10c/0x1a4
[  228.729095]   __dev_queue_xmit+0xcac/0x1288
[  228.733306]   arp_process+0x8cc/0x95c
[  228.736999]   __netif_receive_skb_one_core+0x58/0x74
[  228.741973]   netif_receive_skb+0xe4/0x474
[  228.746093]   cpsw_rx_handler+0x1a0/0x42c
[  228.750122]   __cpdma_chan_process+0xf4/0x188
[  228.754516]   cpdma_chan_process+0x44/0x5c
[  228.758636]   cpsw_rx_mq_poll+0x4c/0x9c
[  228.762512]   __napi_poll+0x3c/0x28c
[  228.766113]   net_rx_action+0x160/0x350
[  228.769958]   __do_softirq+0x130/0x538
[  228.773712]   call_with_stack+0x18/0x20
[  228.777587]   do_softirq+0xb0/0xb4
[  228.781005]   __local_bh_enable_ip+0x180/0x1b8
[  228.785461]   ip_finish_output2+0x21c/0xb74
[  228.789672]   ip_send_skb+0x58/0x120
[  228.793273]   udp_send_skb+0x13c/0x38c
[  228.797027]   udp_sendmsg+0x920/0xe28
[  228.800720]   ____sys_sendmsg+0x224/0x2bc
[  228.804748]   ___sys_sendmsg+0x70/0x9c
[  228.808502]   sys_sendmsg+0x54/0x90
[  228.812011]   __sys_trace_return+0x0/0x10
[  228.816040] irq event stamp: 25991
[  228.819458] hardirqs last  enabled at (25991): [<c03da980>]
__up_console_sem+0x58/0x68
[  228.827423] hardirqs last disabled at (25990): [<c03da96c>]
__up_console_sem+0x44/0x68
[  228.835388] softirqs last  enabled at (25970): [<c0301fc8>]
__do_softirq+0x300/0x538
[  228.843170] softirqs last disabled at (25957): [<c035a224>]
__irq_exit_rcu+0x14c/0x170
[  228.851135]
[  228.851135] other info that might help us debug this:
[  228.857666]  Possible unsafe locking scenario:
[  228.857666]
[  228.863616]        CPU0
[  228.866088]        ----
[  228.868530]   lock(&syncp->seq#14);
[  228.872039]   <Interrupt>
[  228.874694]     lock(&syncp->seq#14);
[  228.878387]
[  228.878387]  *** DEADLOCK ***
[  228.878387]
[  228.884307] 1 lock held by tc/2386:
[  228.887817]  #0: c25b0760 (rtnl_mutex){+.+.}-{3:3}, at:
qdisc_create+0x3cc/0x5bc
[  228.895294]
[  228.895294] stack backtrace:
[  228.899658] CPU: 1 PID: 2386 Comm: tc Tainted: G        W
6.1.4-rc1 #1
[  228.907012] Hardware name: Generic DRA74X (Flattened Device Tree)
[  228.913146]  unwind_backtrace from show_stack+0x18/0x1c
[  228.918395]  show_stack from dump_stack_lvl+0x58/0x70
[  228.923492]  dump_stack_lvl from mark_lock.part.0+0xb74/0x128c
[  228.929351]  mark_lock.part.0 from __lock_acquire+0x984/0x2a8c
[  228.935211]  __lock_acquire from lock_acquire+0x110/0x364
[  228.940643]  lock_acquire from __u64_stats_update_begin+0x10c/0x1a4
[sch_gred]
[  228.947906]  __u64_stats_update_begin [sch_gred] from
gred_dump+0x1c0/0x790 [sch_gred]
[  228.955871]  gred_dump [sch_gred] from tc_fill_qdisc+0x154/0x44c
[  228.961914]  tc_fill_qdisc from qdisc_notify+0x11c/0x130
[  228.967254]  qdisc_notify from qdisc_graft+0x440/0x624
[  228.972442]  qdisc_graft from tc_modify_qdisc+0x558/0x850
[  228.977874]  tc_modify_qdisc from rtnetlink_rcv_msg+0x180/0x56c
[  228.983825]  rtnetlink_rcv_msg from netlink_rcv_skb+0xc0/0x118
[  228.989685]  netlink_rcv_skb from netlink_unicast+0x19c/0x268
[  228.995452]  netlink_unicast from netlink_sendmsg+0x1f8/0x484
[  229.001220]  netlink_sendmsg from ____sys_sendmsg+0x224/0x2bc
[  229.007019]  ____sys_sendmsg from ___sys_sendmsg+0x70/0x9c
[  229.012542]  ___sys_sendmsg from sys_sendmsg+0x54/0x90
[  229.017700]  sys_sendmsg from ret_fast_syscall+0x0/0x1c
[  229.022979] Exception stack(0xf03f9fa8 to 0xf03f9ff0)
[  229.028045] 9fa0:                   00000000 00000001 00000003
bee09bdc 00000000 00000000
[  229.036285] 9fc0: 00000000 00000001 b6f78800 00000128 626ad2dc
00000000 00000000 00076000
[  229.044494] 9fe0: 00000128 bee09b78 b6dff253 b6d71ae6
[  232.169219] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  232.528900] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  232.913879] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  233.339508] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  233.720397] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  234.080047] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  234.460174] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  234.540374] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  234.950683] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
[  235.029327] sch_tbf: burst 1500 is lower than device dummy1 mtu (1514) !
#
# -----> teardown stage *** Could not execute: \"$TC qdisc del dev
$DUMMY handle 1: root\"
#
# -----> teardown stage *** Error message: \"Error: Invalid handle.
# \"
#
# -----> teardown stage *** Aborting test run.
#

[1]
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974102/suite/log-parser-test/tests/
https://lkft.validation.linaro.org/scheduler/job/6022394#L4509


metadata:
  git_ref: linux-6.1.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: a31425cbf493ef8bc7f7ce775a1028b1e0612f32
  git_describe: v6.1.3-208-ga31425cbf493
  kernel_version: 6.1.4-rc1
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/738268273
  artifact-location:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of
  toolchain: gcc-10
  vmlinux.xz: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/vmlinux.xz
  System.map: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/System.map

--
Linaro LKFT
https://lkft.linaro.org
