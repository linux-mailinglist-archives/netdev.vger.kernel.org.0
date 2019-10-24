Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EB4E28BE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392885AbfJXDWa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Oct 2019 23:22:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:32822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390629AbfJXDWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 23:22:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 891EEB1D3;
        Thu, 24 Oct 2019 03:22:27 +0000 (UTC)
Date:   Wed, 23 Oct 2019 20:21:05 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: WARNING: at net/sched/sch_generic.c:448
Message-ID: <20191024032105.xmewznsphltnrido@linux-p48b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm hitting the following in linux-next, and as far back as v5.2, ring any bells?

[  478.588144] NETDEV WATCHDOG: eth0 (igb): transmit queue 0 timed out
[  478.601994] WARNING: CPU: 10 PID: 74 at net/sched/sch_generic.c:448 dev_watchdog+0x253/0x260
[  478.620613] Modules linked in: ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) bpfilter(E) scsi_transport_iscsi(E) af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) ext4(E) intel_rapl_msr(E) intel_rapl_common(E) crc16(E) mbcache(E) jbd2(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crc32_pclmul(E) iTCO_wdt(E) ghash_clmulni_intel(E) iTCO_vendor_support(E) aesni_intel(E) crypto_simd(E) cryptd(E) glue_helper(E) ipmi_si(E) igb(E) ioatdma(E) pcspkr(E) ipmi_devintf(E) mei_me(E) lpc_ich(E) mfd_core(E) ipmi_msghandler(E) joydev(E) i2c_i801(E) mei(E) dca(E) button(E) btrfs(E) libcrc32c(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) sd_mod(E) mgag200(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) i2c_algo_bit(E) isci(E) ehci_pci(E) drm_vram_helper(E) ahci(E) ehci_hcd(E) libsas(E) crc32c_intel(E) ttm(E) libahci(E) scsi_transport_sas(E) drm(E) usbcore(E)
[  478.620658]  libata(E) wmi(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
[  478.837008] CPU: 10 PID: 74 Comm: ksoftirqd/10 Kdump: loaded Tainted: G            E     5.4.0-rc4-2-default+ #2
[  478.859457] Hardware name: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP04.112220131546 11/22/2013
[  478.882867] RIP: 0010:dev_watchdog+0x253/0x260
[  478.892658] Code: 48 85 c0 75 e4 eb 9d 4c 89 ef c6 05 07 28 e8 00 01 e8 d1 fb fa ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 88 11 f8 b8 e8 fd dc 93 ff <0f> 0b e9 7c ff ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 41 57 41 56
[  478.934095] RSP: 0018:ffffb8e08cc17d88 EFLAGS: 00010286
[  478.945600] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  478.961337] RDX: ffff8b485f0a9780 RSI: ffff8b485f099898 RDI: ffff8b485f099898
[  478.977071] RBP: ffff8b40514a845c R08: 00000000000004bf R09: 000000000000000a
[  478.992808] R10: ffffb8e08cc17e08 R11: ffffb8e08cc17c20 R12: ffff8b405e220940
[  479.008543] R13: ffff8b40514a8000 R14: ffff8b40514a8480 R15: 0000000000000008
[  479.024280] FS:  0000000000000000(0000) GS:ffff8b485f080000(0000) knlGS:0000000000000000
[  479.042127] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  479.054795] CR2: 00007ff510ca6860 CR3: 000000081e5ba004 CR4: 00000000001606e0
[  479.070533] Call Trace:
[  479.075922]  ? pfifo_fast_reset+0x110/0x110
[  479.085138]  ? pfifo_fast_reset+0x110/0x110
[  479.094363]  call_timer_fn+0x2d/0x130
[  479.102438]  ? pfifo_fast_reset+0x110/0x110
[  479.111656]  run_timer_softirq+0x43b/0x470
[  479.120697]  ? __switch_to_asm+0x34/0x70
[  479.129338]  ? __switch_to_asm+0x40/0x70
[  479.137980]  ? __switch_to_asm+0x34/0x70
[  479.146622]  ? __switch_to_asm+0x40/0x70
[  479.155263]  ? __switch_to_asm+0x34/0x70
[  479.163919]  ? sort_range+0x20/0x20
[  479.171604]  __do_softirq+0x115/0x32e
[  479.179671]  ? sort_range+0x20/0x20
[  479.187354]  run_ksoftirqd+0x30/0x50
[  479.195242]  smpboot_thread_fn+0xef/0x160
[  479.204086]  kthread+0x113/0x130
[  479.211196]  ? kthread_park+0x90/0x90
[  479.219263]  ret_from_fork+0x3a/0x50

I'm also seeing workqueue lockups:

[  373.711360] BUG: workqueue lockup - pool cpus=1 node=0 flags=0x0 nice=0 stuck for 34s!
[  373.728861] Showing busy workqueues and worker pools:
[  373.740011] workqueue events: flags=0x0
[  373.748484]   pwq 24: cpus=12 node=1 flags=0x0 nice=0 active=1/256
[  373.762112]     in-flight: 120:free_work
[  373.770769]   pwq 20: cpus=10 node=1 flags=0x0 nice=0 active=3/256
[  373.784401]     in-flight: 486:igb_watchdog_task [igb]
[  373.795736]     pending: free_work, igb_watchdog_task [igb]
[  373.808008]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
[  373.821252]     in-flight: 240:cec_work_fn
[  373.830429] workqueue mm_percpu_wq: flags=0x8
[  373.840048]   pwq 30: cpus=15 node=1 flags=0x0 nice=0 active=2/256
[  373.853674]     in-flight: 122:vmstat_update
[  373.863085]     pending: vmstat_update
[  373.871345]   pwq 28: cpus=14 node=1 flags=0x0 nice=0 active=2/256
[  373.884975]     in-flight: 121:vmstat_update
[  373.894386]     pending: vmstat_update
[  373.902648]   pwq 26: cpus=13 node=1 flags=0x0 nice=0 active=1/256
[  373.916281]     in-flight: 118:vmstat_update
[  373.925689]   pwq 24: cpus=12 node=1 flags=0x0 nice=0 active=1/256
[  373.939302]     pending: vmstat_update
[  373.947559]   pwq 22: cpus=11 node=1 flags=0x0 nice=0 active=1/256
[  373.961186]     in-flight: 123:vmstat_update
[  373.970596]   pwq 20: cpus=10 node=1 flags=0x0 nice=0 active=1/256
[  373.984228]     pending: vmstat_update
[  373.992487]   pwq 18: cpus=9 node=1 flags=0x0 nice=0 active=1/256
[  374.005922]     pending: vmstat_update
[  374.014181]   pwq 16: cpus=8 node=1 flags=0x0 nice=0 active=1/256
[  374.027618]     pending: vmstat_update
[  374.035877]   pwq 10: cpus=5 node=0 flags=0x0 nice=0 active=1/256
[  374.049313]     pending: vmstat_update
[  374.057572]   pwq 8: cpus=4 node=0 flags=0x0 nice=0 active=1/256
[  374.070815]     pending: vmstat_update
[  374.079075]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
[  374.092318]     pending: vmstat_update
[  374.100853] pool 6: cpus=3 node=0 flags=0x0 nice=0 hung=2s workers=2 idle: 124
[  374.116782] pool 20: cpus=10 node=1 flags=0x0 nice=0 hung=20s workers=2 idle: 117
[  374.133288] pool 22: cpus=11 node=1 flags=0x0 nice=0 hung=1s workers=2 idle: 1014
[  374.149791] pool 24: cpus=12 node=1 flags=0x0 nice=0 hung=10s workers=2 idle: 550
[  374.166296] pool 26: cpus=13 node=1 flags=0x0 nice=0 hung=5s workers=2 idle: 618
[  374.182619] pool 28: cpus=14 node=1 flags=0x0 nice=0 hung=12s workers=2 idle: 431
[  374.199124] pool 30: cpus=15 node=1 flags=0x0 nice=0 hung=0s workers=2 idle: 105

Thanks,
Davidlohr
