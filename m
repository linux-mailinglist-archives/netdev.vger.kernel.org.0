Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A42D58FCFF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiHKNBN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Aug 2022 09:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiHKNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:01:10 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2664F69E
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:01:09 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id q10-20020a056e020c2a00b002dedb497c7fso12519419ilg.16
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc;
        bh=v+vtANHgtC0uBIDsQ8uCszk3yyXgrodMzwVex7Hqr9w=;
        b=8JHMoXTHb2LRHY0gmQpp3XRL7xynLMNsf1yC4wKe2MtCDLMTr7hGh2TmAwg74mgfvf
         w80P1K6hadOqu9SKOA/KeQVnMXLeSW4+E8O/5u4OlTdbFprUVGKh/HtAK2Zd994hknp5
         yRK3S74XojU3K/Iq21ydA+9thfQnKPDbuPj3zztYLhJg7NuMUu5jNNUINKnyjVbfWb+E
         G2/8OjewLg+2G44jAPfKZafYmsFB3avEWaI9C+YStENtkoFycGSgvs+F+3J0dtsFu+VP
         lMrypZkcU1r3PKq5foaQJb1vrhBA2PtkGc8PpDOIQXdgGJwkWz3VE3zMb/8NTJH58aur
         XfMg==
X-Gm-Message-State: ACgBeo2upHRaydt1qWOFL5yQHEX62CrJn6IEawzEFVb16La0F/SwzKAo
        FWHsUoQFF9aqJjqUv+ixUiW0eNRZ+47InlqSm9QdtOnhN+DY
X-Google-Smtp-Source: AA6agR4iiK30TbnttctaI0xFNRGr0/OdLSYeUO658b/g7Xtor3QFnCAuLMe2eIbn/9xf6naV41sl4Hebq1F2gI4sahMy9FrmaFgA
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1387:b0:342:d852:599e with SMTP id
 w7-20020a056638138700b00342d852599emr11574337jad.281.1660222868474; Thu, 11
 Aug 2022 06:01:08 -0700 (PDT)
Date:   Thu, 11 Aug 2022 06:01:08 -0700
In-Reply-To: <1828ba28d43.27f8b7ca86738.4232033862850200536@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052d52c05e5f6c20a@google.com>
Subject: Re: [syzbot] WARNING in ieee80211_ibss_csa_beacon
From:   syzbot <syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com>
To:     code@siddh.me, davem@davemloft.net, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

 active interface with an up link
[   50.263416][ T3638] bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
[   50.285671][ T3638] team0: Port device team_slave_0 added
[   50.292792][ T3638] team0: Port device team_slave_1 added
[   50.310141][ T3638] batman_adv: batadv0: Adding interface: batadv_slave_0
[   50.317225][ T3638] batman_adv: batadv0: The MTU of interface batadv_slave_0 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
[   50.343683][ T3638] batman_adv: batadv0: Not using interface batadv_slave_0 (retrying later): interface not active
[   50.356731][ T3638] batman_adv: batadv0: Adding interface: batadv_slave_1
[   50.364022][ T3638] batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
[   50.390221][ T3638] batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
[   50.416765][ T3638] device hsr_slave_0 entered promiscuous mode
[   50.423796][ T3638] device hsr_slave_1 entered promiscuous mode
[   50.500816][ T3638] netdevsim netdevsim0 netdevsim0: renamed from eth0
[   50.511693][ T3638] netdevsim netdevsim0 netdevsim1: renamed from eth1
[   50.521112][ T3638] netdevsim netdevsim0 netdevsim2: renamed from eth2
[   50.530709][ T3638] netdevsim netdevsim0 netdevsim3: renamed from eth3
[   50.551898][ T3638] bridge0: port 2(bridge_slave_1) entered blocking state
[   50.559135][ T3638] bridge0: port 2(bridge_slave_1) entered forwarding state
[   50.566985][ T3638] bridge0: port 1(bridge_slave_0) entered blocking state
[   50.574182][ T3638] bridge0: port 1(bridge_slave_0) entered forwarding state
[   50.620324][ T3638] 8021q: adding VLAN 0 to HW filter on device bond0
[   50.634712][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[   50.644519][   T14] bridge0: port 1(bridge_slave_0) entered disabled state
[   50.653256][   T14] bridge0: port 2(bridge_slave_1) entered disabled state
[   50.661875][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   50.675639][ T3638] 8021q: adding VLAN 0 to HW filter on device team0
[   50.686683][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
[   50.696048][   T14] bridge0: port 1(bridge_slave_0) entered blocking state
[   50.703313][   T14] bridge0: port 1(bridge_slave_0) entered forwarding state
[   50.716587][  T143] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_1: link becomes ready
[   50.726078][  T143] bridge0: port 2(bridge_slave_1) entered blocking state
[   50.733163][  T143] bridge0: port 2(bridge_slave_1) entered forwarding state
[   50.751866][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_0: link becomes ready
[   50.766290][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
[   50.775160][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_1: link becomes ready
[   50.787909][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
[   50.800188][ T3638] hsr0: Slave B (hsr_slave_1) is not up; please bring it up to get a fully working HSR network
[   50.812187][ T3638] IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
[   50.821509][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
[   50.845246][ T3638] 8021q: adding VLAN 0 to HW filter on device batadv0
[   50.853191][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan0: link becomes ready
[   50.861297][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan1: link becomes ready
[   50.976504][  T143] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_virt_wifi: link becomes ready
[   50.990346][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_vlan: link becomes ready
[   51.001733][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): vlan0: link becomes ready
[   51.009609][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): vlan1: link becomes ready
[   51.018756][ T3638] device veth0_vlan entered promiscuous mode
[   51.033199][ T3638] device veth1_vlan entered promiscuous mode
[   51.053599][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): macvlan0: link becomes ready
[   51.063508][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): macvlan1: link becomes ready
[   51.072555][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_macvtap: link becomes ready
[   51.084230][ T3638] device veth0_macvtap entered promiscuous mode
[   51.093816][ T3638] device veth1_macvtap entered promiscuous mode
[   51.116192][ T3638] batman_adv: batadv0: Interface activated: batadv_slave_0
[   51.124686][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_batadv: link becomes ready
[   51.136685][    T6] IPv6: ADDRCONF(NETDEV_CHANGE): macvtap0: link becomes ready
[   51.149935][ T3638] batman_adv: batadv0: Interface activated: batadv_slave_1
[   51.158614][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): batadv_slave_1: link becomes ready
[   51.168462][ T3650] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_batadv: link becomes ready
[   51.182170][ T3638] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
[   51.192643][ T3638] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
[   51.202462][ T3638] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
[   51.212143][ T3638] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
[   51.299438][   T29] wlan0: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   51.310951][   T29] wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   51.322462][  T143] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   51.335671][ T2494] wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   51.344772][ T2494] wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   51.353568][  T143] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
2022/08/11 13:00:39 building call list...
[   51.514478][ T3638] ------------[ cut here ]------------
[   51.520140][ T3638] ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
[   51.530079][ T3638] WARNING: CPU: 0 PID: 3638 at lib/debugobjects.c:505 debug_object_assert_init+0x1fa/0x250
[   51.540259][ T3638] Modules linked in:
[   51.544336][ T3638] CPU: 0 PID: 3638 Comm: syz-executor.0 Not tainted 5.19.0-syzkaller #0
[   51.552766][ T3638] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
[   51.563627][ T3638] RIP: 0010:debug_object_assert_init+0x1fa/0x250
[   51.570150][ T3638] Code: e8 eb 83 d1 fd 4c 8b 45 00 48 c7 c7 60 9f 6a 8a 48 c7 c6 60 9c 6a 8a 48 c7 c2 00 a1 6a 8a 31 c9 49 89 d9 31 c0 e8 66 73 4e fd <0f> 0b ff 05 9a 20 8a 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
[   51.590417][ T3638] RSP: 0018:ffffc90003b0f8c8 EFLAGS: 00010046
[   51.596584][ T3638] RAX: af76cc1e655f6400 RBX: 0000000000000000 RCX: ffff888014741d40
[   51.604841][ T3638] RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
[   51.612846][ T3638] RBP: ffffffff8a0fc700 R08: ffffffff8165f59d R09: ffffed1017384f14
[   51.621025][ T3638] R10: ffffed1017384f14 R11: 1ffff11017384f13 R12: dffffc0000000000
[   51.629090][ T3638] R13: ffff88807f3d09d0 R14: 0000000000000011 R15: ffffffff90029988
[   51.637103][ T3638] FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
[   51.646131][ T3638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.652815][ T3638] CR2: 000000c00060a001 CR3: 0000000020940000 CR4: 00000000003506f0
[   51.660973][ T3638] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   51.668940][ T3638] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   51.677688][ T3638] Call Trace:
[   51.680962][ T3638]  <TASK>
[   51.683992][ T3638]  del_timer+0x3d/0x2d0
[   51.688212][ T3638]  ? try_to_grab_pending+0xb1/0x700
[   51.693412][ T3638]  try_to_grab_pending+0xbf/0x700
[   51.698619][ T3638]  __cancel_work_timer+0x81/0x5b0
[   51.703983][ T3638]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   51.709401][ T3638]  ? kmem_cache_free+0x95/0x1d0
[   51.714437][ T3638]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   51.719724][ T3638]  mgmt_index_removed+0x244/0x330
[   51.725464][ T3638]  hci_unregister_dev+0x28e/0x460
[   51.730623][ T3638]  ? vhci_open+0x360/0x360
[   51.735209][ T3638]  vhci_release+0x7f/0xd0
[   51.739538][ T3638]  __fput+0x3b9/0x820
[   51.743800][ T3638]  task_work_run+0x146/0x1c0
[   51.748501][ T3638]  do_exit+0x4ed/0x1f30
[   51.752680][ T3638]  ? rcu_read_lock_sched_held+0x41/0xb0
[   51.758365][ T3638]  do_group_exit+0x23b/0x2f0
[   51.762963][ T3638]  ? _raw_spin_unlock_irq+0x1f/0x40
[   51.768653][ T3638]  ? lockdep_hardirqs_on+0x8d/0x130
[   51.774245][ T3638]  get_signal+0x16a3/0x1700
[   51.779122][ T3638]  arch_do_signal_or_restart+0x29/0x5d0
[   51.784691][ T3638]  exit_to_user_mode_loop+0x74/0x150
[   51.790147][ T3638]  exit_to_user_mode_prepare+0xb2/0x140
[   51.796127][ T3638]  syscall_exit_to_user_mode+0x26/0x60
[   51.802152][ T3638]  do_syscall_64+0x49/0x90
[   51.806773][ T3638]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   51.812939][ T3638] RIP: 0033:0x4191dc
[   51.817111][ T3638] Code: Unable to access opcode bytes at RIP 0x4191b2.
[   51.823960][ T3638] RSP: 002b:00007fffcb50dcd0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   51.832477][ T3638] RAX: fffffffffffffe00 RBX: 00007fffcb50dd90 RCX: 00000000004191dc
[   51.840566][ T3638] RDX: 0000000000000050 RSI: 0000000000568020 RDI: 00000000000000f9
[   51.848559][ T3638] RBP: 0000000000000003 R08: 0000000000000000 R09: 0079746972756365
[   51.857099][ T3638] R10: 00000000005436a0 R11: 0000000000000246 R12: 0000000000000032
[   51.865523][ T3638] R13: 000000000000c8b1 R14: 0000000000000000 R15: 00007fffcb50ddd0
[   51.873863][ T3638]  </TASK>
[   51.876995][ T3638] Kernel panic - not syncing: panic_on_warn set ...
[   51.883575][ T3638] CPU: 0 PID: 3638 Comm: syz-executor.0 Not tainted 5.19.0-syzkaller #0
[   51.892096][ T3638] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
[   51.902161][ T3638] Call Trace:
[   51.905527][ T3638]  <TASK>
[   51.908545][ T3638]  dump_stack_lvl+0x131/0x1c8
[   51.913322][ T3638]  panic+0x26b/0x693
[   51.917497][ T3638]  ? __warn+0x131/0x220
[   51.921826][ T3638]  ? debug_object_assert_init+0x1fa/0x250
[   51.927674][ T3638]  __warn+0x1fa/0x220
[   51.931700][ T3638]  ? debug_object_assert_init+0x1fa/0x250
[   51.937520][ T3638]  report_bug+0x1b3/0x2d0
[   51.941878][ T3638]  handle_bug+0x3d/0x70
[   51.946174][ T3638]  exc_invalid_op+0x16/0x40
[   51.950780][ T3638]  asm_exc_invalid_op+0x16/0x20
[   51.955734][ T3638] RIP: 0010:debug_object_assert_init+0x1fa/0x250
[   51.962102][ T3638] Code: e8 eb 83 d1 fd 4c 8b 45 00 48 c7 c7 60 9f 6a 8a 48 c7 c6 60 9c 6a 8a 48 c7 c2 00 a1 6a 8a 31 c9 49 89 d9 31 c0 e8 66 73 4e fd <0f> 0b ff 05 9a 20 8a 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
[   51.981793][ T3638] RSP: 0018:ffffc90003b0f8c8 EFLAGS: 00010046
[   51.988057][ T3638] RAX: af76cc1e655f6400 RBX: 0000000000000000 RCX: ffff888014741d40
[   51.996245][ T3638] RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
[   52.005054][ T3638] RBP: ffffffff8a0fc700 R08: ffffffff8165f59d R09: ffffed1017384f14
[   52.013065][ T3638] R10: ffffed1017384f14 R11: 1ffff11017384f13 R12: dffffc0000000000
[   52.021767][ T3638] R13: ffff88807f3d09d0 R14: 0000000000000011 R15: ffffffff90029988
[   52.031524][ T3638]  ? __wake_up_klogd+0xcd/0x100
[   52.036840][ T3638]  ? debug_object_assert_init+0x1fa/0x250
[   52.042873][ T3638]  del_timer+0x3d/0x2d0
[   52.047348][ T3638]  ? try_to_grab_pending+0xb1/0x700
[   52.052749][ T3638]  try_to_grab_pending+0xbf/0x700
[   52.057800][ T3638]  __cancel_work_timer+0x81/0x5b0
[   52.062831][ T3638]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   52.068345][ T3638]  ? kmem_cache_free+0x95/0x1d0
[   52.073224][ T3638]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   52.078681][ T3638]  mgmt_index_removed+0x244/0x330
[   52.083977][ T3638]  hci_unregister_dev+0x28e/0x460
[   52.089128][ T3638]  ? vhci_open+0x360/0x360
[   52.093621][ T3638]  vhci_release+0x7f/0xd0
[   52.097961][ T3638]  __fput+0x3b9/0x820
[   52.102128][ T3638]  task_work_run+0x146/0x1c0
[   52.106746][ T3638]  do_exit+0x4ed/0x1f30
[   52.110908][ T3638]  ? rcu_read_lock_sched_held+0x41/0xb0
[   52.116673][ T3638]  do_group_exit+0x23b/0x2f0
[   52.121452][ T3638]  ? _raw_spin_unlock_irq+0x1f/0x40
[   52.126661][ T3638]  ? lockdep_hardirqs_on+0x8d/0x130
[   52.131858][ T3638]  get_signal+0x16a3/0x1700
[   52.136804][ T3638]  arch_do_signal_or_restart+0x29/0x5d0
[   52.142556][ T3638]  exit_to_user_mode_loop+0x74/0x150
[   52.147840][ T3638]  exit_to_user_mode_prepare+0xb2/0x140
[   52.153731][ T3638]  syscall_exit_to_user_mode+0x26/0x60
[   52.159196][ T3638]  do_syscall_64+0x49/0x90
[   52.163644][ T3638]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   52.169629][ T3638] RIP: 0033:0x4191dc
[   52.173526][ T3638] Code: Unable to access opcode bytes at RIP 0x4191b2.
[   52.180458][ T3638] RSP: 002b:00007fffcb50dcd0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   52.189133][ T3638] RAX: fffffffffffffe00 RBX: 00007fffcb50dd90 RCX: 00000000004191dc
[   52.197189][ T3638] RDX: 0000000000000050 RSI: 0000000000568020 RDI: 00000000000000f9
[   52.205251][ T3638] RBP: 0000000000000003 R08: 0000000000000000 R09: 0079746972756365
[   52.213269][ T3638] R10: 00000000005436a0 R11: 0000000000000246 R12: 0000000000000032
[   52.221332][ T3638] R13: 000000000000c8b1 R14: 0000000000000000 R15: 00007fffcb50ddd0
[   52.229405][ T3638]  </TASK>
[   52.232869][ T3638] Kernel Offset: disabled
[   52.237327][ T3638] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=<nil>)
GO111MODULE="auto"
GOARCH="amd64"
GOBIN=""
GOCACHE="/syzkaller/.cache/go-build"
GOENV="/syzkaller/.config/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/syzkaller/jobs/linux/gopath/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/syzkaller/jobs/linux/gopath"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GOVCS=""
GOVERSION="go1.17"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build1977670166=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at 607e3baf1
nothing to commit, working tree clean


go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sys/syz-sysgen
make .descriptions
bin/syz-sysgen
touch .descriptions
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=607e3baf1c25928040d05fc22eff6fce7edd709e -X 'github.com/google/syzkaller/prog.gitRevisionDate=20210324-183421'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=607e3baf1c25928040d05fc22eff6fce7edd709e -X 'github.com/google/syzkaller/prog.gitRevisionDate=20210324-183421'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=607e3baf1c25928040d05fc22eff6fce7edd709e -X 'github.com/google/syzkaller/prog.gitRevisionDate=20210324-183421'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -static -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"607e3baf1c25928040d05fc22eff6fce7edd709e\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=13730f25080000


Tested on:

commit:         64737995 wifi: mac80211: Don't finalize CSA in IBSS mo..
git tree:       https://github.com/siddhpant/linux.git warning_ibss_csa_beacon
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b770cb261c0c061
dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9fe29aefe68e4ad34
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
