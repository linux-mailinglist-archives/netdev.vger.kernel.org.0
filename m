Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBAF58F0B4
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiHJQrY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Aug 2022 12:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiHJQrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:47:15 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE301B7B5
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:47:13 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id j13-20020a056e02154d00b002de828b4b63so10955262ilu.10
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc;
        bh=hUNWrnd+Zfkz4ZQhQ2tjQP7nALuL86rrrMxK8e0aiTE=;
        b=1ougr+VhGhvf3FZXooSO9k3BgkC0rxK7J1mDI6r1sYtqlOKBim/jYzoFJVvNBc/dMy
         i9IzSHOpP5K56I66YPTTJfJnasncNfra+ECn9cTludAh1wFTexSdKmZ/AacIgRHmWjnE
         DsR3SIih4MhsxD5BpMfHGC+nskOCf+MIvFgmjKhq+eGPqnEqRkBQw+EpVKApCx+I39PB
         doCqHA8DQMR70NI7WrnEAQ5hgnpQJeHs8amAGLdIj5H8VVV7Q2jVcgH3+bxeMe3Px4Ci
         Ujh4eoiHdthbf7E4iKx4K/ZZJyZZtroEiZkKXcx49QZwi3s3Ow+0TRe6kOQ7qwdoKg08
         jXAQ==
X-Gm-Message-State: ACgBeo0VCIfqmsZnI+rCkvVsSk+Wkaci3zavvpPTVu0UU22/SOelEQzn
        lUn8mwqM2Y5rQckMKgJRFpg81K4trN+bODrh4gMpK0Q0lO52
X-Google-Smtp-Source: AA6agR66HtL322jdgGZR1DaOw8R2zwjC0+BITQB2wgyQuiFN+btijKXxRda4MFBidyY/PgULsZgZP2IKVRS2VqayuxyEv4YiPOYj
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4192:b0:684:6256:e892 with SMTP id
 bx18-20020a056602419200b006846256e892mr8034820iob.89.1660150032475; Wed, 10
 Aug 2022 09:47:12 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:47:12 -0700
In-Reply-To: <20220810113551.344792-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5acfd05e5e5ccdc@google.com>
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

tered promiscuous mode
[   49.294465][ T3636] bond0: (slave bond_slave_0): Enslaving as an active interface with an up link
[   49.305282][ T3636] bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
[   49.325908][ T3636] team0: Port device team_slave_0 added
[   49.333047][ T3636] team0: Port device team_slave_1 added
[   49.350306][ T3636] batman_adv: batadv0: Adding interface: batadv_slave_0
[   49.357336][ T3636] batman_adv: batadv0: The MTU of interface batadv_slave_0 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
[   49.383401][ T3636] batman_adv: batadv0: Not using interface batadv_slave_0 (retrying later): interface not active
[   49.395845][ T3636] batman_adv: batadv0: Adding interface: batadv_slave_1
[   49.402957][ T3636] batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
[   49.430471][ T3636] batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
[   49.455720][ T3636] device hsr_slave_0 entered promiscuous mode
[   49.463006][ T3636] device hsr_slave_1 entered promiscuous mode
[   49.538340][ T3636] netdevsim netdevsim0 netdevsim0: renamed from eth0
[   49.549079][ T3636] netdevsim netdevsim0 netdevsim1: renamed from eth1
[   49.558155][ T3636] netdevsim netdevsim0 netdevsim2: renamed from eth2
[   49.569133][ T3636] netdevsim netdevsim0 netdevsim3: renamed from eth3
[   49.590785][ T3636] bridge0: port 2(bridge_slave_1) entered blocking state
[   49.597986][ T3636] bridge0: port 2(bridge_slave_1) entered forwarding state
[   49.605904][ T3636] bridge0: port 1(bridge_slave_0) entered blocking state
[   49.613050][ T3636] bridge0: port 1(bridge_slave_0) entered forwarding state
[   49.657283][ T3636] 8021q: adding VLAN 0 to HW filter on device bond0
[   49.669522][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[   49.679945][   T14] bridge0: port 1(bridge_slave_0) entered disabled state
[   49.688892][   T14] bridge0: port 2(bridge_slave_1) entered disabled state
[   49.697602][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   49.710449][ T3636] 8021q: adding VLAN 0 to HW filter on device team0
[   49.722894][ T3647] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
[   49.732572][ T3647] bridge0: port 1(bridge_slave_0) entered blocking state
[   49.739646][ T3647] bridge0: port 1(bridge_slave_0) entered forwarding state
[   49.750696][  T923] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_1: link becomes ready
[   49.759168][  T923] bridge0: port 2(bridge_slave_1) entered blocking state
[   49.766347][  T923] bridge0: port 2(bridge_slave_1) entered forwarding state
[   49.783139][ T3647] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_0: link becomes ready
[   49.798118][ T3647] IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
[   49.807101][ T3647] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_1: link becomes ready
[   49.816367][ T3647] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
[   49.828659][ T3636] hsr0: Slave B (hsr_slave_1) is not up; please bring it up to get a fully working HSR network
[   49.841622][ T3636] IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
[   49.849961][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
[   49.867463][  T923] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan0: link becomes ready
[   49.875057][  T923] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan1: link becomes ready
[   49.887724][ T3636] 8021q: adding VLAN 0 to HW filter on device batadv0
[   49.991352][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_virt_wifi: link becomes ready
[   50.007687][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_vlan: link becomes ready
[   50.016485][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): vlan0: link becomes ready
[   50.024664][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): vlan1: link becomes ready
[   50.034755][ T3636] device veth0_vlan entered promiscuous mode
[   50.047971][ T3636] device veth1_vlan entered promiscuous mode
[   50.067469][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): macvlan0: link becomes ready
[   50.075584][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): macvlan1: link becomes ready
[   50.084115][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_macvtap: link becomes ready
[   50.095890][ T3636] device veth0_macvtap entered promiscuous mode
[   50.105744][ T3636] device veth1_macvtap entered promiscuous mode
[   50.120925][ T3636] batman_adv: batadv0: Interface activated: batadv_slave_0
[   50.129807][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_batadv: link becomes ready
[   50.139778][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): macvtap0: link becomes ready
[   50.152837][ T3636] batman_adv: batadv0: Interface activated: batadv_slave_1
[   50.161478][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_batadv: link becomes ready
[   50.172240][ T3636] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
[   50.182764][ T3636] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
[   50.192635][ T3636] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
[   50.202479][ T3636] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
[   50.258761][   T33] wlan0: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   50.276234][   T33] wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   50.292455][   T22] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   50.306188][   T11] wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   50.315505][   T11] wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   50.325576][   T14] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
2022/08/10 16:46:13 building call list...
[   50.505046][ T3636] ------------[ cut here ]------------
[   50.510773][ T3636] ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
[   50.520732][ T3636] WARNING: CPU: 1 PID: 3636 at lib/debugobjects.c:505 debug_object_assert_init+0x1fa/0x250
[   50.530739][ T3636] Modules linked in:
[   50.534652][ T3636] CPU: 1 PID: 3636 Comm: syz-executor.0 Not tainted 5.19.0-syzkaller #0
[   50.542991][ T3636] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
[   50.553063][ T3636] RIP: 0010:debug_object_assert_init+0x1fa/0x250
[   50.559406][ T3636] Code: e8 bb d2 d1 fd 4c 8b 45 00 48 c7 c7 20 96 6a 8a 48 c7 c6 20 93 6a 8a 48 c7 c2 c0 97 6a 8a 31 c9 49 89 d9 31 c0 e8 86 cd 4e fd <0f> 0b ff 05 da 58 8a 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
[   50.579117][ T3636] RSP: 0018:ffffc9000392f8c8 EFLAGS: 00010046
[   50.585300][ T3636] RAX: 8bc764758f9d2d00 RBX: 0000000000000000 RCX: ffff88807f27ba80
[   50.593296][ T3636] RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
[   50.601277][ T3636] RBP: ffffffff8a0fc700 R08: ffffffff8165ed3d R09: ffffed10173a4f14
[   50.609266][ T3636] R10: ffffed10173a4f14 R11: 1ffff110173a4f13 R12: dffffc0000000000
[   50.617255][ T3636] R13: ffff88801bea49d0 R14: 0000000000000015 R15: ffffffff900beb38
[   50.625245][ T3636] FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
[   50.634196][ T3636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.641255][ T3636] CR2: 00007fe56a2e1200 CR3: 0000000011c4e000 CR4: 00000000003506e0
[   50.649282][ T3636] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   50.657280][ T3636] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   50.665286][ T3636] Call Trace:
[   50.668606][ T3636]  <TASK>
[   50.671567][ T3636]  del_timer+0x3d/0x2d0
[   50.675770][ T3636]  ? try_to_grab_pending+0xb1/0x700
[   50.681004][ T3636]  try_to_grab_pending+0xbf/0x700
[   50.686321][ T3636]  __cancel_work_timer+0x81/0x5b0
[   50.691373][ T3636]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   50.696805][ T3636]  ? kmem_cache_free+0x95/0x1d0
[   50.701675][ T3636]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   50.706989][ T3636]  mgmt_index_removed+0x244/0x330
[   50.712032][ T3636]  hci_unregister_dev+0x28e/0x460
[   50.718115][ T3636]  ? vhci_open+0x360/0x360
[   50.722542][ T3636]  vhci_release+0x7f/0xd0
[   50.726883][ T3636]  __fput+0x3b9/0x820
[   50.730896][ T3636]  task_work_run+0x146/0x1c0
[   50.735510][ T3636]  do_exit+0x4ed/0x1f30
[   50.739669][ T3636]  ? rcu_read_lock_sched_held+0x41/0xb0
[   50.745233][ T3636]  do_group_exit+0x23b/0x2f0
[   50.749828][ T3636]  ? _raw_spin_unlock_irq+0x1f/0x40
[   50.755023][ T3636]  ? lockdep_hardirqs_on+0x8d/0x130
[   50.760218][ T3636]  get_signal+0x16a3/0x1700
[   50.766302][ T3636]  arch_do_signal_or_restart+0x29/0x5d0
[   50.771852][ T3636]  exit_to_user_mode_loop+0x74/0x150
[   50.777133][ T3636]  exit_to_user_mode_prepare+0xb2/0x140
[   50.782695][ T3636]  syscall_exit_to_user_mode+0x26/0x60
[   50.788737][ T3636]  do_syscall_64+0x49/0x90
[   50.793176][ T3636]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   50.799177][ T3636] RIP: 0033:0x4191dc
[   50.803063][ T3636] Code: Unable to access opcode bytes at RIP 0x4191b2.
[   50.809916][ T3636] RSP: 002b:00007ffe6c6d7830 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   50.818354][ T3636] RAX: fffffffffffffe00 RBX: 00007ffe6c6d78f0 RCX: 00000000004191dc
[   50.826326][ T3636] RDX: 0000000000000050 RSI: 0000000000568020 RDI: 00000000000000f9
[   50.834295][ T3636] RBP: 0000000000000003 R08: 0000000000000000 R09: 0079746972756365
[   50.842269][ T3636] R10: 00000000005436a0 R11: 0000000000000246 R12: 0000000000000032
[   50.850229][ T3636] R13: 000000000000c4c0 R14: 0000000000000000 R15: 00007ffe6c6d7930
[   50.858211][ T3636]  </TASK>
[   50.861256][ T3636] Kernel panic - not syncing: panic_on_warn set ...
[   50.867835][ T3636] CPU: 1 PID: 3636 Comm: syz-executor.0 Not tainted 5.19.0-syzkaller #0
[   50.876158][ T3636] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
[   50.886289][ T3636] Call Trace:
[   50.890527][ T3636]  <TASK>
[   50.893448][ T3636]  dump_stack_lvl+0x131/0x1c8
[   50.898221][ T3636]  panic+0x26b/0x693
[   50.902113][ T3636]  ? __warn+0x131/0x220
[   50.906266][ T3636]  ? debug_object_assert_init+0x1fa/0x250
[   50.912064][ T3636]  __warn+0x1fa/0x220
[   50.916054][ T3636]  ? debug_object_assert_init+0x1fa/0x250
[   50.921777][ T3636]  report_bug+0x1b3/0x2d0
[   50.926103][ T3636]  handle_bug+0x3d/0x70
[   50.930513][ T3636]  exc_invalid_op+0x16/0x40
[   50.935009][ T3636]  asm_exc_invalid_op+0x16/0x20
[   50.939919][ T3636] RIP: 0010:debug_object_assert_init+0x1fa/0x250
[   50.946259][ T3636] Code: e8 bb d2 d1 fd 4c 8b 45 00 48 c7 c7 20 96 6a 8a 48 c7 c6 20 93 6a 8a 48 c7 c2 c0 97 6a 8a 31 c9 49 89 d9 31 c0 e8 86 cd 4e fd <0f> 0b ff 05 da 58 8a 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
[   50.965962][ T3636] RSP: 0018:ffffc9000392f8c8 EFLAGS: 00010046
[   50.972034][ T3636] RAX: 8bc764758f9d2d00 RBX: 0000000000000000 RCX: ffff88807f27ba80
[   50.980009][ T3636] RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
[   50.988148][ T3636] RBP: ffffffff8a0fc700 R08: ffffffff8165ed3d R09: ffffed10173a4f14
[   50.996123][ T3636] R10: ffffed10173a4f14 R11: 1ffff110173a4f13 R12: dffffc0000000000
[   51.004180][ T3636] R13: ffff88801bea49d0 R14: 0000000000000015 R15: ffffffff900beb38
[   51.012153][ T3636]  ? __wake_up_klogd+0xcd/0x100
[   51.017277][ T3636]  ? debug_object_assert_init+0x1fa/0x250
[   51.023040][ T3636]  del_timer+0x3d/0x2d0
[   51.027291][ T3636]  ? try_to_grab_pending+0xb1/0x700
[   51.032705][ T3636]  try_to_grab_pending+0xbf/0x700
[   51.037752][ T3636]  __cancel_work_timer+0x81/0x5b0
[   51.042785][ T3636]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   51.048148][ T3636]  ? kmem_cache_free+0x95/0x1d0
[   51.053085][ T3636]  ? mgmt_send_event_skb+0x2ee/0x4e0
[   51.058748][ T3636]  mgmt_index_removed+0x244/0x330
[   51.063855][ T3636]  hci_unregister_dev+0x28e/0x460
[   51.069135][ T3636]  ? vhci_open+0x360/0x360
[   51.073542][ T3636]  vhci_release+0x7f/0xd0
[   51.077997][ T3636]  __fput+0x3b9/0x820
[   51.082080][ T3636]  task_work_run+0x146/0x1c0
[   51.086847][ T3636]  do_exit+0x4ed/0x1f30
[   51.091007][ T3636]  ? rcu_read_lock_sched_held+0x41/0xb0
[   51.096557][ T3636]  do_group_exit+0x23b/0x2f0
[   51.101224][ T3636]  ? _raw_spin_unlock_irq+0x1f/0x40
[   51.106439][ T3636]  ? lockdep_hardirqs_on+0x8d/0x130
[   51.111641][ T3636]  get_signal+0x16a3/0x1700
[   51.116151][ T3636]  arch_do_signal_or_restart+0x29/0x5d0
[   51.121725][ T3636]  exit_to_user_mode_loop+0x74/0x150
[   51.127039][ T3636]  exit_to_user_mode_prepare+0xb2/0x140
[   51.132611][ T3636]  syscall_exit_to_user_mode+0x26/0x60
[   51.138271][ T3636]  do_syscall_64+0x49/0x90
[   51.143033][ T3636]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   51.149376][ T3636] RIP: 0033:0x4191dc
[   51.153293][ T3636] Code: Unable to access opcode bytes at RIP 0x4191b2.
[   51.160326][ T3636] RSP: 002b:00007ffe6c6d7830 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   51.170079][ T3636] RAX: fffffffffffffe00 RBX: 00007ffe6c6d78f0 RCX: 00000000004191dc
[   51.178052][ T3636] RDX: 0000000000000050 RSI: 0000000000568020 RDI: 00000000000000f9
[   51.186026][ T3636] RBP: 0000000000000003 R08: 0000000000000000 R09: 0079746972756365
[   51.194096][ T3636] R10: 00000000005436a0 R11: 0000000000000246 R12: 0000000000000032
[   51.202061][ T3636] R13: 000000000000c4c0 R14: 0000000000000000 R15: 00007ffe6c6d7930
[   51.210491][ T3636]  </TASK>
[   51.213889][ T3636] Kernel Offset: disabled
[   51.218357][ T3636] Rebooting in 86400 seconds..


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
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build478383173=/tmp/go-build -gno-record-gcc-switches"

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
https://syzkaller.appspot.com/x/error.txt?x=149def63080000


Tested on:

commit:         d4252071 add barriers to buffer_uptodate and set_buffe..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
kernel config:  https://syzkaller.appspot.com/x/.config?x=aac0e3f739de465e
dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9fe29aefe68e4ad34
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12593366080000

