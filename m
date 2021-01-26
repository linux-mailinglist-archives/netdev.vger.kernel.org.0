Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EEA304D90
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbhAZXLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:22 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:32899 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391039AbhAZTrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 14:47:06 -0500
Received: by mail-io1-f71.google.com with SMTP id m3so26385576ioy.0
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 11:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HS1mLvI7gGCCCDTGoIi/OOHkbopud4i/8kv4AFXUS2A=;
        b=Pz19tGVf9MystqiLebpFp8JSgArMQpfQ0HRnglJ0mJVFq5ywKK2J2Wv8T676jHGOqS
         0tWAtlbaoJ+IBZzWxyDD0erDQnrU6M3afikttwdkzQwUoAsxqfxSbYeeGQMpCXmMvIjc
         0SyNutLN76ffZJAUeWDnJtH7Y5a1bUIVu6NTf6Bwn3vrfhSDbvgIzceKfyzbD+XL0vhq
         eKsh/ehRLUcD7ljkigotsO6rWIX8qqZ7PD8CiVF6SyV7v+6jSH+8UH79vugCCIe1YSop
         i9iHuTrCvCF0ln34aPKgafFv6+t//QpXwcsscintav+X2plGZ37/Me+v1xbGJIL35isP
         6tzA==
X-Gm-Message-State: AOAM530FFzb46bLGL6U3JKxKV2o0cRJ0s6TAHktV4gxlTgOVuTKnDX7o
        9fEOOWefIZJXDQIjJec9fdamFXR5ZVV7Z0ji4OZi7vC8uLsY
X-Google-Smtp-Source: ABdhPJxTWRRDAj9InA70XETSEwwoBPgYLs1ANQ6JHGXb2suqRHMzqOzS6OUHLjObxlgOYrQoLx+flQYGPUqvuqT6pp0RVZ9o6MSx
MIME-Version: 1.0
X-Received: by 2002:a02:aa9a:: with SMTP id u26mr6101608jai.4.1611690384801;
 Tue, 26 Jan 2021 11:46:24 -0800 (PST)
Date:   Tue, 26 Jan 2021 11:46:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dfc44f05b9d2e864@google.com>
Subject: upstream test error: INFO: trying to register non-static key in nsim_get_stats64
From:   syzbot <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c7230a48 Merge tag 'spi-fix-v5.11-rc5' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17731f94d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c312983a0475388
dashboard link: https://syzkaller.appspot.com/bug?extid=e74a6857f2d0efe3ad81
userspace arch: arm

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com

batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
device hsr_slave_0 entered promiscuous mode
device hsr_slave_1 entered promiscuous mode
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 4695 Comm: syz-executor.0 Not tainted 5.11.0-rc5-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: 
[<826fc5b8>] (dump_backtrace) from [<826fc82c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
 r7:00000080 r6:600f0193 r5:00000000 r4:83a28a38
[<826fc814>] (show_stack) from [<8270d1f8>] (__dump_stack lib/dump_stack.c:79 [inline])
[<826fc814>] (show_stack) from [<8270d1f8>] (dump_stack+0xa8/0xc8 lib/dump_stack.c:120)
[<8270d150>] (dump_stack) from [<802bf9c0>] (assign_lock_key kernel/locking/lockdep.c:935 [inline])
[<8270d150>] (dump_stack) from [<802bf9c0>] (register_lock_class+0xabc/0xb68 kernel/locking/lockdep.c:1247)
 r7:00000000 r6:8423efe8 r5:00000000 r4:00000000
[<802bef04>] (register_lock_class) from [<802baa2c>] (__lock_acquire+0x84/0x32d4 kernel/locking/lockdep.c:4711)
 r10:00000080 r9:886b4100 r8:00000001 r7:00000002 r6:00000000 r5:8a678764
 r4:00000000
[<802ba9a8>] (__lock_acquire) from [<802be840>] (lock_acquire.part.0+0xf0/0x554 kernel/locking/lockdep.c:5442)
 r10:00000080 r9:600f0193 r8:00000000 r7:00000000 r6:836cb680 r5:836cb680
 r4:89d1b8d0
[<802be750>] (lock_acquire.part.0) from [<802bed10>] (lock_acquire+0x6c/0x74 kernel/locking/lockdep.c:5415)
 r10:81e2efa0 r9:00000000 r8:00000001 r7:00000002 r6:00000000 r5:00000000
 r4:8a678764
[<802beca4>] (lock_acquire) from [<81560548>] (seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline])
[<802beca4>] (lock_acquire) from [<81560548>] (__u64_stats_fetch_begin include/linux/u64_stats_sync.h:164 [inline])
[<802beca4>] (lock_acquire) from [<81560548>] (u64_stats_fetch_begin include/linux/u64_stats_sync.h:175 [inline])
[<802beca4>] (lock_acquire) from [<81560548>] (nsim_get_stats64+0xdc/0xf0 drivers/net/netdevsim/netdev.c:70)
 r10:8a678764 r9:00000001 r8:8a678740 r7:600f0113 r6:81e2efa0 r5:8a67a12c
 r4:8a678000
[<8156046c>] (nsim_get_stats64) from [<81e2efa0>] (dev_get_stats+0x44/0xd0 net/core/dev.c:10405)
 r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:829fc0e0 r5:8a678000
 r4:8a67a12c
[<81e2ef5c>] (dev_get_stats) from [<81e53204>] (rtnl_fill_stats+0x38/0x120 net/core/rtnetlink.c:1211)
 r7:00000000 r6:8a678000 r5:8a495600 r4:8a67a128
[<81e531cc>] (rtnl_fill_stats) from [<81e59d58>] (rtnl_fill_ifinfo+0x6d4/0x148c net/core/rtnetlink.c:1783)
 r7:00000000 r6:83851ec4 r5:8a678000 r4:8a495600
[<81e59684>] (rtnl_fill_ifinfo) from [<81e5ceb4>] (rtmsg_ifinfo_build_skb+0x9c/0x108 net/core/rtnetlink.c:3798)
 r10:00000cc0 r9:8a4a0000 r8:00000000 r7:ffffffff r6:00000010 r5:8a495600
 r4:00000000
[<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3830 [inline])
[<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3821 [inline])
[<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo+0x44/0x70 net/core/rtnetlink.c:3839)
 r10:8a688000 r9:00000000 r8:00000000 r7:00000000 r6:00000cc0 r5:00000001
 r4:8a678000
[<81e5d068>] (rtmsg_ifinfo) from [<81e45c2c>] (register_netdevice+0x664/0x68c net/core/dev.c:10103)
 r7:00000000 r6:83b06e28 r5:8a678000 r4:00000000
[<81e455c8>] (register_netdevice) from [<815608bc>] (nsim_create+0xf8/0x124 drivers/net/netdevsim/netdev.c:317)
 r9:00000000 r8:8a642008 r7:8a688560 r6:8a678740 r5:00000000 r4:8a678000
[<815607c4>] (nsim_create) from [<81561184>] (__nsim_dev_port_add+0x108/0x188 drivers/net/netdevsim/dev.c:941)
 r7:00000000 r6:8a688560 r5:00000000 r4:8a642000
[<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_port_add_all drivers/net/netdevsim/dev.c:990 [inline])
[<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_probe+0x5cc/0x750 drivers/net/netdevsim/dev.c:1119)
 r8:00000000 r7:8a688560 r6:00000004 r5:00000000 r4:8a688400
[<81561b0c>] (nsim_dev_probe) from [<815661dc>] (nsim_bus_probe+0x10/0x14 drivers/net/netdevsim/bus.c:287)
 r10:00000002 r9:83a62720 r8:00000000 r7:847c3b00 r6:00000000 r5:847c3af8
 r4:8a688000
[<815661cc>] (nsim_bus_probe) from [<811724c0>] (really_probe+0x100/0x50c drivers/base/dd.c:554)
[<811723c0>] (really_probe) from [<811729c4>] (driver_probe_device+0xf8/0x1c8 drivers/base/dd.c:740)
 r10:83a62708 r9:00000000 r8:847c3aa4 r7:8a688000 r6:89d1bd5c r5:83a62720
 r4:8a688000
[<811728cc>] (driver_probe_device) from [<81172fe4>] (__device_attach_driver+0x8c/0xf0 drivers/base/dd.c:846)
 r9:00000000 r8:847c3aa4 r7:8a688000 r6:89d1bd5c r5:83a62720 r4:00000000
[<81172f58>] (__device_attach_driver) from [<8116fee0>] (bus_for_each_drv+0x88/0xd8 drivers/base/bus.c:431)
 r7:83a38930 r6:81172f58 r5:89d1bd5c r4:00000000
[<8116fe58>] (bus_for_each_drv) from [<81172c6c>] (__device_attach+0xdc/0x1d0 drivers/base/dd.c:914)
 r6:8a688090 r5:00000001 r4:8a688000
[<81172b90>] (__device_attach) from [<8117305c>] (device_initial_probe+0x14/0x18 drivers/base/dd.c:961)
 r6:8a688000 r5:83a626a8 r4:8a688000
[<81173048>] (device_initial_probe) from [<81171358>] (bus_probe_device+0x90/0x98 drivers/base/bus.c:491)
[<811712c8>] (bus_probe_device) from [<8116e77c>] (device_add+0x320/0x824 drivers/base/core.c:3109)
 r7:83a38930 r6:00000000 r5:00000000 r4:8a688000
[<8116e45c>] (device_add) from [<8116ec9c>] (device_register+0x1c/0x20 drivers/base/core.c:3182)
 r10:00000000 r9:83a626a8 r8:00000000 r7:847cd64c r6:83a62628 r5:00000003
 r4:8a688000
[<8116ec80>] (device_register) from [<81566710>] (nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline])
[<8116ec80>] (device_register) from [<81566710>] (new_device_store+0x178/0x208 drivers/net/netdevsim/bus.c:215)
 r5:00000003 r4:8a688000
[<81566598>] (new_device_store) from [<8116fcb4>] (bus_attr_store+0x2c/0x38 drivers/base/bus.c:122)
 r9:8a639700 r8:89d1bf08 r7:8a5e1110 r6:8a639700 r5:8116fc88 r4:81566598
[<8116fc88>] (bus_attr_store) from [<805b4b8c>] (sysfs_kf_write+0x48/0x54 fs/sysfs/file.c:139)
 r5:8116fc88 r4:00000003
[<805b4b44>] (sysfs_kf_write) from [<805b3c90>] (kernfs_fop_write_iter+0x128/0x1ec fs/kernfs/file.c:296)
 r7:8a5e1110 r6:8a5e1100 r5:00000000 r4:00000000
[<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (call_write_iter include/linux/fs.h:1901 [inline])
[<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (new_sync_write fs/read_write.c:518 [inline])
[<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (vfs_write+0x3dc/0x57c fs/read_write.c:605)
 r9:00000003 r8:804d2604 r7:89d1bf68 r6:00000000 r5:84f62000 r4:00000000
[<804d1f20>] (vfs_write) from [<804d2604>] (ksys_write+0x68/0xec fs/read_write.c:658)
 r10:00000004 r9:89d1a000 r8:80200224 r7:00000000 r6:00000000 r5:84f62000
 r4:84f62000
[<804d259c>] (ksys_write) from [<804d2698>] (__do_sys_write fs/read_write.c:670 [inline])
[<804d259c>] (ksys_write) from [<804d2698>] (sys_write+0x10/0x14 fs/read_write.c:667)
 r7:00000004 r6:00000003 r5:021f04c0 r4:00000004
[<804d2688>] (sys_write) from [<80200060>] (ret_fast_syscall+0x0/0x2c arch/arm/mm/proc-v7.S:64)
Exception stack(0x89d1bfa8 to 0x89d1bff0)
bfa0:                   00000004 021f04c0 00000004 7ecc31f0 00000003 00000000
bfc0: 00000004 021f04c0 00000003 00000004 00000002 7ecc384c 00086730 00000003
bfe0: 00000000 7ecc31c8 0002835c 000286c0
netdevsim netdevsim0 netdevsim0: renamed from eth0
netdevsim netdevsim0 netdevsim1: renamed from eth1
netdevsim netdevsim0 netdevsim2: renamed from eth2
netdevsim netdevsim0 netdevsim3: renamed from eth3
8021q: adding VLAN 0 to HW filter on device bond0
8021q: adding VLAN 0 to HW filter on device team0
IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
device veth0_vlan entered promiscuous mode
device veth1_vlan entered promiscuous mode
device veth0_macvtap entered promiscuous mode
device veth1_macvtap entered promiscuous mode
batman_adv: batadv0: Interface activated: batadv_slave_0
batman_adv: batadv0: Interface activated: batadv_slave_1
netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
cgroup: cgroup: disabling cgroup2 socket matching due to net_prio or net_cls activation


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
