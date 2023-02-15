Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEB96981A8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBORLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBORLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:11:09 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EBB25B85
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:11:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id e12so3341589plh.6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hO7nU81HMNSsLNtrF4yNMYlGvNDCX20PHy6xDQqElrU=;
        b=lBxQHL8i7oQM/XteykgfEq+/Ab5NFZVq+cs+Qhu3/eEa34/VH8dvsskx9es+ko8Kzs
         UQOhsHNhE6IZL01Jc1jaAC/T6JuF5LpwxgLbRvwZA5MF+7HMB/mAtCuqlU4WRUMvp2Ty
         bYPaLiQrf8U0J7J9d+WTDgZKesh+ytq/ox/PfsEf1dnGB0cZwUnv81ev45pQCOZIAPfV
         LA0q6Gro0hYCa3JKuowBsCCzJpPL1O/K4CjpIgpbeT19442P1lvpGh6WID7W7vLOonFV
         1tqqNUODWNKcBmjzp7tvdR0lwnm047fs0+33GWK/lm01fC7enkJ4R64Xo6WbunPP2hcQ
         vYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hO7nU81HMNSsLNtrF4yNMYlGvNDCX20PHy6xDQqElrU=;
        b=phTmI4vvnba1r0JanjPVTv6LACgjNc7fe8qbOMuyIVJBOkYujDNGQd8tt4aYPTL29N
         w9Wwff67tOhxxKXRfomEAG0hMDpvgT/VHnP3pfzfTKFD+b1J9+JtPhuu7pU/C5TMt0wb
         VupNkpWWyRYKF764kTPOvpnQXlj4WERviavv2ZxW+k3JQSLyRcScEeLtQ1m3uiMF7xoj
         bCKK6qqVBuYLFuK82Wvc4hr6K6Uj4/GYH7eygx2p/vs5+ssvDirEbuS8kWf18BVlKZTw
         ZeI3rIargriik/4k5Pq3NZXNVKGJMVlA9yeRcym9EUQj+hwTrcZsBqAEKyslz2B+NEkL
         DNyQ==
X-Gm-Message-State: AO0yUKVNPxydtWpVAEmAvV9v7AxjEcQDOXrGOl3gGhW4xRP6algMbjtr
        h/Gd0YyTGC3eCmDzkp8+H18rdKRHEaaW4QB5R8H4vw==
X-Google-Smtp-Source: AK7set9jb3bntdo8ttp3MimnL30cO1cT/CQX1HTUsL52d/SI1vbjVhvYXZasIvpbLnmSyuCxeGUklQ==
X-Received: by 2002:a17:90b:1a91:b0:22c:792:d342 with SMTP id ng17-20020a17090b1a9100b0022c0792d342mr3750840pjb.26.1676481064338;
        Wed, 15 Feb 2023 09:11:04 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a3-20020a17090aa50300b0022bb3ee9b68sm1750271pjq.13.2023.02.15.09.11.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 09:11:04 -0800 (PST)
Date:   Wed, 15 Feb 2023 09:11:03 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 217040] New: TXDCTL.ENABLE for one or more queues not
 cleared within the polling period
Message-ID: <20230215091103.17c8addd@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 15 Feb 2023 03:46:21 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 217040] New: TXDCTL.ENABLE for one or more queues not cleared within the polling period


https://bugzilla.kernel.org/show_bug.cgi?id=217040

            Bug ID: 217040
           Summary: TXDCTL.ENABLE for one or more queues not cleared
                    within the polling period
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.0-100-generic
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: satish.txt@gmail.com
        Regression: No

I am running Ubuntu 20.04.4 with kernel version 5.4.0-100-generic. Recently in
my server rack one of server had memory failure caused all the servers in that
rack received following kernel trace and they failed to connect. 

Server vendor: HP DL460 Gen9 blades

# lspci | grep -i eth
06:00.0 Ethernet controller: Intel Corporation 82599 10 Gigabit Dual Port
Backplane Connection (rev 01)
06:00.1 Ethernet controller: Intel Corporation 82599 10 Gigabit Dual Port
Backplane Connection (rev 01)

~# ethtool -i eno50
driver: ixgbe
version: 5.1.0-k
firmware-version: 0x800008f0, 1.2836.0
expansion-rom-version:
bus-info: 0000:06:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes


Kernel version: 5.4.0-100-generic #113-Ubuntu


# brctl show
bridge name     bridge id               STP enabled     interfaces
br-mgmt         8000.38eaa733b589       no              eno50.51
br-vlan         8000.38eaa733b589       no              eno50
br-vxlan        8000.38eaa733b589       no              eno50.29


Kernel trace logs, what could be the issue here. Does it related to STP loop or
some kind of failure. 

[Thu Feb  9 07:17:07 2023] ------------[ cut here ]------------
[Thu Feb  9 07:17:07 2023] NETDEV WATCHDOG: eno50 (ixgbe): transmit queue 19
timed out
[Thu Feb  9 07:17:07 2023] WARNING: CPU: 16 PID: 0 at
net/sched/sch_generic.c:472 dev_watchdog+0x258/0x260
[Thu Feb  9 07:17:07 2023] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs
msdos jfs xfs cpuid xt_CHECKSUM xt_conntrack xt_tcpudp ip6table_mangle
ip6table_nat binfmt_misc nf_tables nfnetlink iptable_raw bpfilter vhost_net
vhost tap nbd iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_vs
iptable_nat iptable_mangle iptable_filter ipt_REJECT nf_reject_ipv4
xt_MASQUERADE nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter
ip6_tables ebtables dm_snapshot dm_bufio br_netfilter 8021q garp mrp bridge stp
llc dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_ssif ixgbevf
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
coretemp joydev input_leds kvm_intel kvm rapl intel_cstate serio_raw hpilo
ioatdma ipmi_si ipmi_devintf ipmi_msghandler acpi_tad mac_hid acpi_power_meter
sch_fq_codel msr ip_tables x_tables autofs4 btrfs zstd_compress raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
libcrc32c raid1 raid0 multipath
[Thu Feb  9 07:17:07 2023]  linear mgag200 drm_vram_helper i2c_algo_bit ttm
drm_kms_helper crct10dif_pclmul syscopyarea crc32_pclmul sysfillrect
ghash_clmulni_intel sysimgblt hid_generic aesni_intel fb_sys_fops crypto_simd
ixgbe usbhid cryptd psmouse hpsa glue_helper xfrm_algo drm hid i2c_i801 lpc_ich
scsi_transport_sas dca mdio wmi
[Thu Feb  9 07:17:07 2023] CPU: 16 PID: 0 Comm: swapper/16 Not tainted
5.4.0-100-generic #113-Ubuntu
[Thu Feb  9 07:17:07 2023] Hardware name: HP ProLiant BL460c Gen9, BIOS I36
03/25/2019
[Thu Feb  9 07:17:07 2023] RIP: 0010:dev_watchdog+0x258/0x260
[Thu Feb  9 07:17:07 2023] Code: 85 c0 75 e5 eb 9f 4c 89 ff c6 05 84 a2 2c 01
01 e8 ad bf fa ff 44 89 e9 4c 89 fe 48 c7 c7 f8 dc 63 8c 48 89 c2 e8 34 e2 13
00 <0f> 0b eb 80 0f 1f 40 00 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 d7
[Thu Feb  9 07:17:07 2023] RSP: 0018:ffffa133467c0e30 EFLAGS: 00010286
[Thu Feb  9 07:17:07 2023] RAX: 0000000000000000 RBX: ffff8f9deef6cec0 RCX:
000000000000083f
[Thu Feb  9 07:17:07 2023] RDX: 0000000000000000 RSI: 00000000000000f6 RDI:
000000000000083f
[Thu Feb  9 07:17:07 2023] RBP: ffffa133467c0e60 R08: ffff8fae1f71c8c8 R09:
0000000000000004
[Thu Feb  9 07:17:07 2023] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000000000040
[Thu Feb  9 07:17:07 2023] R13: 0000000000000013 R14: ffff8f9df16a0480 R15:
ffff8f9df16a0000
[Thu Feb  9 07:17:07 2023] FS:  0000000000000000(0000)
GS:ffff8fae1f700000(0000) knlGS:0000000000000000
[Thu Feb  9 07:17:07 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Feb  9 07:17:07 2023] CR2: 00007f0840382000 CR3: 0000000acea0a006 CR4:
00000000001626e0
[Thu Feb  9 07:17:07 2023] Call Trace:
[Thu Feb  9 07:17:07 2023]  <IRQ>
[Thu Feb  9 07:17:07 2023]  ? pfifo_fast_enqueue+0x150/0x150
[Thu Feb  9 07:17:07 2023]  call_timer_fn+0x32/0x130
[Thu Feb  9 07:17:07 2023]  __run_timers.part.0+0x180/0x280
[Thu Feb  9 07:17:07 2023]  ? tick_sched_handle+0x33/0x60
[Thu Feb  9 07:17:07 2023]  ? tick_sched_timer+0x3d/0x80
[Thu Feb  9 07:17:07 2023]  ? ktime_get+0x3e/0xa0
[Thu Feb  9 07:17:07 2023]  run_timer_softirq+0x2a/0x50
[Thu Feb  9 07:17:07 2023]  __do_softirq+0xe1/0x2d6
[Thu Feb  9 07:17:07 2023]  ? hrtimer_interrupt+0x136/0x220
[Thu Feb  9 07:17:07 2023]  irq_exit+0xae/0xb0
[Thu Feb  9 07:17:07 2023]  smp_apic_timer_interrupt+0x7b/0x140
[Thu Feb  9 07:17:07 2023]  apic_timer_interrupt+0xf/0x20
[Thu Feb  9 07:17:07 2023]  </IRQ>
[Thu Feb  9 07:17:07 2023] RIP: 0010:cpuidle_enter_state+0xc5/0x450
[Thu Feb  9 07:17:07 2023] Code: ff e8 ef b8 84 ff 80 7d c7 00 74 17 9c 58 0f
1f 44 00 00 f6 c4 02 0f 85 65 03 00 00 31 ff e8 62 c0 8a ff fb 66 0f 1f 44 00
00 <45> 85 ed 0f 88 8f 02 00 00 49 63 cd 4c 8b 7d d0 4c 2b 7d c8 48 8d
[Thu Feb  9 07:17:07 2023] RSP: 0018:ffffa13346377e38 EFLAGS: 00000246
ORIG_RAX: ffffffffffffff13
[Thu Feb  9 07:17:07 2023] RAX: ffff8fae1f72fe00 RBX: ffffffff8cd59fe0 RCX:
000000000000001f
[Thu Feb  9 07:17:07 2023] RDX: 0000000000000000 RSI: 000000003342629e RDI:
0000000000000000
[Thu Feb  9 07:17:07 2023] RBP: ffffa13346377e78 R08: 00285439725dde3a R09:
00285454394d7639
[Thu Feb  9 07:17:07 2023] R10: ffff8fae1f72eb00 R11: ffff8fae1f72eae0 R12:
ffffc1333f9021c0
[Thu Feb  9 07:17:07 2023] R13: 0000000000000004 R14: 0000000000000004 R15:
ffffc1333f9021c0
[Thu Feb  9 07:17:07 2023]  ? cpuidle_enter_state+0xa1/0x450
[Thu Feb  9 07:17:07 2023]  cpuidle_enter+0x2e/0x40
[Thu Feb  9 07:17:07 2023]  call_cpuidle+0x23/0x40
[Thu Feb  9 07:17:07 2023]  do_idle+0x1dd/0x270
[Thu Feb  9 07:17:07 2023]  cpu_startup_entry+0x20/0x30
[Thu Feb  9 07:17:07 2023]  start_secondary+0x167/0x1c0
[Thu Feb  9 07:17:07 2023]  secondary_startup_64+0xa4/0xb0
[Thu Feb  9 07:17:07 2023] ---[ end trace ca7e91fa58c34325 ]---
[Thu Feb  9 07:17:07 2023] ixgbe 0000:06:00.1 eno50: initiating reset due to tx
timeout
[Thu Feb  9 07:17:07 2023] ixgbe 0000:06:00.1 eno50: Reset adapter
[Thu Feb  9 07:17:07 2023] ixgbe 0000:06:00.1 eno50: TXDCTL.ENABLE for one or
more queues not cleared within the polling period
[Thu Feb  9 07:17:08 2023] br-vlan: port 1(eno50) entered disabled state
[Thu Feb  9 07:17:08 2023] br-vxlan: port 1(eno50.29) entered disabled state
[Thu Feb  9 07:17:08 2023] br-mgmt: port 1(eno50.51) entered disabled state
[Thu Feb  9 07:17:08 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Up 10 Gbps,
Flow Control: RX/TX
[Thu Feb  9 07:17:08 2023] br-vlan: port 1(eno50) entered blocking state
[Thu Feb  9 07:17:08 2023] br-vlan: port 1(eno50) entered forwarding state
[Thu Feb  9 07:17:08 2023] br-vxlan: port 1(eno50.29) entered blocking state
[Thu Feb  9 07:17:08 2023] br-vxlan: port 1(eno50.29) entered forwarding state
[Thu Feb  9 07:17:08 2023] br-mgmt: port 1(eno50.51) entered blocking state
[Thu Feb  9 07:17:08 2023] br-mgmt: port 1(eno50.51) entered forwarding state
[Thu Feb  9 07:17:09 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Down
[Thu Feb  9 07:17:10 2023] br-vlan: port 1(eno50) entered disabled state
[Thu Feb  9 07:17:10 2023] br-vxlan: port 1(eno50.29) entered disabled state
[Thu Feb  9 07:17:10 2023] br-mgmt: port 1(eno50.51) entered disabled state
[Thu Feb  9 07:17:10 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Up 10 Gbps,
Flow Control: RX/TX
[Thu Feb  9 07:17:10 2023] br-vlan: port 1(eno50) entered blocking state
[Thu Feb  9 07:17:10 2023] br-vlan: port 1(eno50) entered forwarding state
[Thu Feb  9 07:17:10 2023] br-vxlan: port 1(eno50.29) entered blocking state
[Thu Feb  9 07:17:10 2023] br-vxlan: port 1(eno50.29) entered forwarding state
[Thu Feb  9 07:17:10 2023] br-mgmt: port 1(eno50.51) entered blocking state
[Thu Feb  9 07:17:10 2023] br-mgmt: port 1(eno50.51) entered forwarding state
[Thu Feb  9 07:27:34 2023] ixgbe 0000:06:00.1 eno50: initiating reset due to tx
timeout
[Thu Feb  9 07:27:34 2023] ixgbe 0000:06:00.1 eno50: Reset adapter
[Thu Feb  9 07:27:35 2023] br-vlan: port 1(eno50) entered disabled state
[Thu Feb  9 07:27:35 2023] br-vxlan: port 1(eno50.29) entered disabled state
[Thu Feb  9 07:27:35 2023] br-mgmt: port 1(eno50.51) entered disabled state
[Thu Feb  9 07:27:35 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Up 10 Gbps,
Flow Control: RX/TX
[Thu Feb  9 07:27:35 2023] br-vlan: port 1(eno50) entered blocking state
[Thu Feb  9 07:27:35 2023] br-vlan: port 1(eno50) entered forwarding state
[Thu Feb  9 07:27:35 2023] br-vxlan: port 1(eno50.29) entered blocking state
[Thu Feb  9 07:27:35 2023] br-vxlan: port 1(eno50.29) entered forwarding state
[Thu Feb  9 07:27:35 2023] br-mgmt: port 1(eno50.51) entered blocking state
[Thu Feb  9 07:27:35 2023] br-mgmt: port 1(eno50.51) entered forwarding state
[Thu Feb  9 07:27:36 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Down
[Thu Feb  9 07:27:37 2023] br-vlan: port 1(eno50) entered disabled state
[Thu Feb  9 07:27:37 2023] br-vxlan: port 1(eno50.29) entered disabled state
[Thu Feb  9 07:27:37 2023] br-mgmt: port 1(eno50.51) entered disabled state
[Thu Feb  9 07:27:37 2023] ixgbe 0000:06:00.1 eno50: NIC Link is Up 10 Gbps,
Flow Control: RX/TX
[Thu Feb  9 07:27:37 2023] br-vlan: port 1(eno50) entered blocking state
[Thu Feb  9 07:27:37 2023] br-vlan: port 1(eno50) entered forwarding state
[Thu Feb  9 07:27:37 2023] br-vxlan: port 1(eno50.29) entered blocking state
[Thu Feb  9 07:27:37 2023] br-vxlan: port 1(eno50.29) entered forwarding state
[Thu Feb  9 07:27:37 2023] br-mgmt: port 1(eno50.51) entered blocking state
[Thu Feb  9 07:27:37 2023] br-mgmt: port 1(eno50.51) entered forwarding state
[Thu Feb  9 07:38:14 2023] ixgbe 0000:06:00.1 eno50: initiating reset due to tx
timeout
[Thu Feb  9 07:38:14 2023] ixgbe 0000:06:00.1 eno50: Reset adapter

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
