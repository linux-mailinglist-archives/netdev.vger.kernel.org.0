Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D542955D363
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbiF1Coj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343818AbiF1CoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:44:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85382AE04;
        Mon, 27 Jun 2022 19:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656384076; x=1687920076;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=R/My7bG1tndc9KWa9ml3CEgZlNh4YkqbSrS7zN+zo5A=;
  b=UxycprVXdSZfKQdJljZTmXtNZGrdqUs3zNIp21WMKPlXfctb4167NLtX
   QMfjW8QNSKvW8p70xmd+LLE66jLPwxF8qDyBps+xwpbqHM4YIX6brZjFJ
   EG3zXkTsi1RKtrJ9TbK652Tg7Zf1n7EsyHPjGa9R8NX/GlPdlM/htU9Lf
   hCLOFe/biFrhFE7kKRhG/5gnx6PX1AVGXz0aDZwrr2hvwwin6ogUFUbd9
   nF8G7c5UVNr1p1OyL8qCDXSBwbpV5wCq640fE86s7v6AcWsn91KfSkRHJ
   ZDEnUuDHbYkIWWGsuwcwtg5idcmv1jcdfkL5z6XR+4oXdTldhZqyepsFF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="345613282"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="xz'?yaml'?scan'208";a="345613282"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:41:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="xz'?yaml'?scan'208";a="692893937"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:41:06 -0700
Date:   Tue, 28 Jun 2022 10:40:59 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-can@vger.kernel.org, lkp@lists.01.org, ltp@lists.linux.it,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [can]  39bbbe2356:
 BUG:sleeping_function_called_from_invalid_context_at_mm/page_alloc.c
Message-ID: <YrpqO5jepAvv4zkf@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4I+8hqiQcx5tW7oo"
Content-Disposition: inline
In-Reply-To: <20220614122821.3646071-6-dario.binacchi@amarulasolutions.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: 39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9 ("[PATCH v4 05/12] can: slcan: use CAN network device driver API")
url: https://github.com/intel-lab-lkp/linux/commits/Dario-Binacchi/can-slcan-extend-supported-features/20220614-203636
patch link: https://lore.kernel.org/lkml/20220614122821.3646071-6-dario.binacchi@amarulasolutions.com

in testcase: ltp
version: ltp-x86_64-14c1f76-1_20220625
with following parameters:

	test: pty
	ucode: 0x21

test-description: The LTP testsuite contains a collection of tools for testing the Linux kernel and related features.
test-url: http://linux-test-project.github.io/


on test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz with 8G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


[  164.290583][ T3878] BUG: sleeping function called from invalid context at mm/page_alloc.c:5203
[  164.290589][ T3878] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3878, name: pty03
[  164.290592][ T3878] preempt_count: 1, expected: 0
[  164.290595][ T3878] CPU: 1 PID: 3878 Comm: pty03 Tainted: G S                5.19.0-rc2-00005-g39bbbe2356a2 #1
[  164.290600][ T3878] Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
[  164.290602][ T3878] Call Trace:
[  164.290604][ T3878]  <TASK>
[ 164.290606][ T3878] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 164.290615][ T3878] __might_resched.cold (kernel/sched/core.c:9792) 
[ 164.290621][ T3878] prepare_alloc_pages+0x330/0x500 
[ 164.290628][ T3878] ? tty_set_ldisc (drivers/tty/tty_ldisc.c:555) 
[ 164.290634][ T3878] __alloc_pages (mm/page_alloc.c:5415) 
[ 164.290637][ T3878] ? __alloc_pages_slowpath+0x15c0/0x15c0 
[ 164.290641][ T3878] ? tty_set_ldisc (drivers/tty/tty_ldisc.c:555) 
[ 164.290645][ T3878] ? kasan_save_stack (mm/kasan/common.c:40) 
[ 164.290650][ T3878] ? kasan_set_track (mm/kasan/common.c:45) 
[ 164.290654][ T3878] ? __kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328 mm/kasan/common.c:374) 
[ 164.290658][ T3878] ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115) 
[ 164.290663][ T3878] ? do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 164.290668][ T3878] ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115) 
[ 164.290672][ T3878] kmalloc_large_node (mm/slub.c:4432) 
[ 164.290677][ T3878] __kmalloc_node (include/asm-generic/getorder.h:41 mm/slub.c:4450) 
[ 164.290681][ T3878] kvmalloc_node (mm/util.c:619) 
[ 164.290687][ T3878] alloc_netdev_mqs (net/core/dev.c:10577) 
[ 164.290694][ T3878] ? can_get_state_str (drivers/net/can/dev/dev.c:222) can_dev
[ 164.290704][ T3878] ? _raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154) 
[ 164.290708][ T3878] alloc_candev_mqs (drivers/net/can/dev/dev.c:262) can_dev
[ 164.290717][ T3878] slcan_open (drivers/net/can/slcan.c:531 drivers/net/can/slcan.c:584) slcan
[ 164.290723][ T3878] tty_ldisc_open (drivers/tty/tty_ldisc.c:433) 
[ 164.290728][ T3878] tty_set_ldisc (drivers/tty/tty_ldisc.c:558) 
[ 164.290733][ T3878] tty_ioctl (drivers/tty/tty_io.c:2714) 
[ 164.290736][ T3878] ? do_sys_openat2 (fs/open.c:1288) 
[ 164.290740][ T3878] ? tty_release (drivers/tty/tty_io.c:2655) 
[ 164.290744][ T3878] ? do_sys_openat2 (fs/open.c:1288) 
[ 164.290747][ T3878] ? build_open_flags (fs/open.c:1264) 
[ 164.290751][ T3878] ? __ia32_sys_stat (fs/stat.c:396) 
[ 164.290755][ T3878] ? userns_owner (kernel/user_namespace.c:371) 
[ 164.290760][ T3878] ? __fget_files (arch/x86/include/asm/atomic64_64.h:22 include/linux/atomic/atomic-arch-fallback.h:2363 include/linux/atomic/atomic-arch-fallback.h:2388 include/linux/atomic/atomic-arch-fallback.h:2404 include/linux/atomic/atomic-long.h:497 include/linux/atomic/atomic-instrumented.h:1854 fs/file.c:882 fs/file.c:913) 
[ 164.290764][ T3878] __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:870 fs/ioctl.c:856 fs/ioctl.c:856) 
[ 164.290768][ T3878] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 164.290773][ T3878] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115) 
[  164.290777][ T3878] RIP: 0033:0x7f86f3323cc7
[ 164.290781][ T3878] Code: 00 00 00 48 8b 05 c9 91 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 91 0c 00 f7 d8 64 89 01 48
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 48 8b             	add    %cl,-0x75(%rax)
   5:	05 c9 91 0c 00       	add    $0xc91c9,%eax
   a:	64 c7 00 26 00 00 00 	movl   $0x26,%fs:(%rax)
  11:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  18:	c3                   	retq   
  19:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  20:	00 00 00 
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d 99 91 0c 00 	mov    0xc9199(%rip),%rcx        # 0xc91d3
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d 99 91 0c 00 	mov    0xc9199(%rip),%rcx        # 0xc91a9
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[  164.290784][ T3878] RSP: 002b:00007fff6a8fb8b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  164.290789][ T3878] RAX: ffffffffffffffda RBX: 00007f86f322c6c0 RCX: 00007f86f3323cc7
[  164.290792][ T3878] RDX: 000055911985c700 RSI: 0000000000005423 RDI: 000000000000000d
[  164.290795][ T3878] RBP: 000055911985c700 R08: 0000000000000000 R09: cccccccccccccccd
[  164.290797][ T3878] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000d
[  164.290799][ T3878] R13: 0000000000000006 R14: 000055911985c6a0 R15: 0000000000000004
[  164.290803][ T3878]  </TASK>
[  164.738226][ T3878] BUG: scheduling while atomic: pty03/3878/0x00000002
[  164.738233][ T3878] Modules linked in: slcan can_dev n_hdlc netconsole btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg i915 intel_rapl_msr intel_gtt intel_rapl_common drm_buddy x86_pkg_temp_thermal drm_display_helper intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ahci ttm ghash_clmulni_intel rapl libahci intel_cstate ipmi_devintf drm_kms_helper intel_uncore ipmi_msghandler usb_storage mei_me syscopyarea sysfillrect libata sysimgblt mei fb_sys_fops video drm fuse ip_tables
[  164.738298][ T3878] CPU: 3 PID: 3878 Comm: pty03 Tainted: G S      W         5.19.0-rc2-00005-g39bbbe2356a2 #1
[  164.738302][ T3878] Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
[  164.738305][ T3878] Call Trace:
[  164.738307][ T3878]  <TASK>
[ 164.738309][ T3878] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 164.738318][ T3878] __schedule_bug.cold (kernel/sched/core.c:5661) 
[ 164.738323][ T3878] schedule_debug (arch/x86/include/asm/preempt.h:35 kernel/sched/core.c:5688) 
[ 164.738329][ T3878] __schedule (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 kernel/sched/features.h:40 kernel/sched/core.c:6324) 
[ 164.738335][ T3878] ? node_tag_clear (arch/x86/include/asm/bitops.h:94 include/asm-generic/bitops/instrumented-non-atomic.h:43 lib/radix-tree.c:107 lib/radix-tree.c:1000) 
[ 164.738340][ T3878] ? io_schedule_timeout (kernel/sched/core.c:6310) 
[ 164.738344][ T3878] ? idr_alloc_u32 (lib/idr.c:55) 
[ 164.738349][ T3878] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 164.738353][ T3878] schedule (include/linux/instrumented.h:71 (discriminator 1) include/asm-generic/bitops/instrumented-non-atomic.h:134 (discriminator 1) include/linux/thread_info.h:118 (discriminator 1) include/linux/sched.h:2196 (discriminator 1) kernel/sched/core.c:6502 (discriminator 1)) 
[ 164.738358][ T3878] rwsem_down_write_slowpath (arch/x86/include/asm/current.h:15 kernel/locking/rwsem.c:1174) 
[ 164.738362][ T3878] ? __down_timeout (kernel/locking/rwsem.c:1099) 
[ 164.738365][ T3878] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 164.738370][ T3878] ? idr_get_free (lib/radix-tree.c:1533) 
[ 164.738373][ T3878] ? kernfs_dir_fop_release (fs/kernfs/dir.c:584) 
[ 164.738379][ T3878] down_write (kernel/locking/rwsem.c:1544) 
[ 164.738383][ T3878] ? down_write_killable (kernel/locking/rwsem.c:1540) 
[ 164.738386][ T3878] ? idr_alloc (lib/idr.c:118) 
[ 164.738389][ T3878] ? _raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154) 
[ 164.738393][ T3878] ? __fprop_add_percpu_max (lib/idr.c:35) 
[ 164.738397][ T3878] kernfs_add_one (include/linux/kernfs.h:332 fs/kernfs/dir.c:737) 
[ 164.738402][ T3878] ? kernfs_new_node (fs/kernfs/dir.c:659) 
[ 164.738406][ T3878] ? device_remove_bin_file (drivers/base/core.c:2089) 
[ 164.738411][ T3878] __kernfs_create_file (fs/kernfs/file.c:1016) 
[ 164.738415][ T3878] sysfs_add_file_mode_ns (fs/sysfs/file.c:301) 
[ 164.738419][ T3878] ? projid_m_show (kernel/user_namespace.c:308) 
[ 164.738423][ T3878] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 164.738427][ T3878] create_files (fs/sysfs/group.c:66 (discriminator 3)) 
[ 164.738431][ T3878] ? make_kgid (kernel/user_namespace.c:475) 
[ 164.738434][ T3878] internal_create_group (fs/sysfs/group.c:148) 
[ 164.738438][ T3878] ? down_write (arch/x86/include/asm/atomic64_64.h:34 include/linux/atomic/atomic-long.h:41 include/linux/atomic/atomic-instrumented.h:1280 kernel/locking/rwsem.c:139 kernel/locking/rwsem.c:256 kernel/locking/rwsem.c:1286 kernel/locking/rwsem.c:1296 kernel/locking/rwsem.c:1543) 
[ 164.738441][ T3878] ? create_files (fs/sysfs/group.c:109) 
[ 164.738444][ T3878] ? __cond_resched (kernel/sched/core.c:8217) 
[ 164.738448][ T3878] ? down_write (arch/x86/include/asm/atomic64_64.h:34 include/linux/atomic/atomic-long.h:41 include/linux/atomic/atomic-instrumented.h:1280 kernel/locking/rwsem.c:139 kernel/locking/rwsem.c:256 kernel/locking/rwsem.c:1286 kernel/locking/rwsem.c:1296 kernel/locking/rwsem.c:1543) 
[ 164.738452][ T3878] internal_create_groups+0x7c/0x140 
[ 164.738456][ T3878] device_add_attrs (drivers/base/core.c:2621) 
[ 164.738460][ T3878] ? klist_children_put (drivers/base/core.c:2614) 
[ 164.738464][ T3878] ? kernfs_create_link (fs/kernfs/symlink.c:48) 
[ 164.738467][ T3878] ? kernfs_put (arch/x86/include/asm/atomic.h:123 (discriminator 1) include/linux/atomic/atomic-instrumented.h:576 (discriminator 1) fs/kernfs/dir.c:521 (discriminator 1)) 
[ 164.738471][ T3878] device_add (drivers/base/core.c:3368) 
[ 164.738476][ T3878] ? device_initialize (drivers/base/core.c:3200) 
[ 164.738479][ T3878] ? __fw_devlink_link_to_suppliers (drivers/base/core.c:3299) 
[ 164.738484][ T3878] ? __hrtimer_init (kernel/time/hrtimer.c:1559) 
[ 164.738488][ T3878] netdev_register_kobject (net/core/net-sysfs.c:2014) 
[ 164.738493][ T3878] register_netdevice (net/core/dev.c:10047) 
[ 164.738498][ T3878] ? __cond_resched (kernel/sched/core.c:8217) 
[ 164.738502][ T3878] ? netdev_change_features (net/core/dev.c:9942) 
[ 164.738507][ T3878] register_netdev (net/core/dev.c:10171) 
[ 164.738511][ T3878] register_candev (drivers/net/can/dev/dev.c:460) can_dev
[ 164.738522][ T3878] ? can_set_termination (drivers/net/can/dev/dev.c:460) can_dev
[ 164.738529][ T3878] ? _raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154) 
[ 164.738533][ T3878] ? alloc_candev_mqs (drivers/net/can/dev/dev.c:284) can_dev
[ 164.738541][ T3878] slcan_open (drivers/net/can/slcan.c:598) slcan
[ 164.738547][ T3878] tty_ldisc_open (drivers/tty/tty_ldisc.c:433) 
[ 164.738552][ T3878] tty_set_ldisc (drivers/tty/tty_ldisc.c:558) 
[ 164.738557][ T3878] tty_ioctl (drivers/tty/tty_io.c:2714) 
[ 164.738561][ T3878] ? tty_release (drivers/tty/tty_io.c:2655) 
[ 164.738565][ T3878] ? __switch_to (arch/x86/kernel/process.h:38 arch/x86/kernel/process_64.c:627) 
[ 164.738569][ T3878] ? __schedule (kernel/sched/core.c:6310) 
[ 164.738574][ T3878] ? io_schedule_timeout (kernel/sched/core.c:6310) 
[ 164.738578][ T3878] ? __fget_files (arch/x86/include/asm/atomic64_64.h:22 include/linux/atomic/atomic-arch-fallback.h:2363 include/linux/atomic/atomic-arch-fallback.h:2388 include/linux/atomic/atomic-arch-fallback.h:2404 include/linux/atomic/atomic-long.h:497 include/linux/atomic/atomic-instrumented.h:1854 fs/file.c:882 fs/file.c:913) 
[ 164.738583][ T3878] __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:870 fs/ioctl.c:856 fs/ioctl.c:856) 
[ 164.738587][ T3878] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 164.738591][ T3878] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:115) 
[  164.738596][ T3878] RIP: 0033:0x7f86f3323cc7
[ 164.738599][ T3878] Code: 00 00 00 48 8b 05 c9 91 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 91 0c 00 f7 d8 64 89 01 48
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 48 8b             	add    %cl,-0x75(%rax)
   5:	05 c9 91 0c 00       	add    $0xc91c9,%eax
   a:	64 c7 00 26 00 00 00 	movl   $0x26,%fs:(%rax)
  11:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  18:	c3                   	retq   
  19:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  20:	00 00 00 
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d 99 91 0c 00 	mov    0xc9199(%rip),%rcx        # 0xc91d3
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d 99 91 0c 00 	mov    0xc9199(%rip),%rcx        # 0xc91a9
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[  164.738603][ T3878] RSP: 002b:00007fff6a8fb8b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  164.738608][ T3878] RAX: ffffffffffffffda RBX: 00007f86f322c6c0 RCX: 00007f86f3323cc7
[  164.738611][ T3878] RDX: 000055911985c700 RSI: 0000000000005423 RDI: 000000000000000d
[  164.738613][ T3878] RBP: 000055911985c700 R08: 0000000000000000 R09: cccccccccccccccd
[  164.738616][ T3878] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000d
[  164.738618][ T3878] R13: 0000000000000006 R14: 000055911985c6a0 R15: 0000000000000004
[  164.738621][ T3878]  </TASK>


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="config-5.19.0-rc2-00005-g39bbbe2356a2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.19.0-rc2 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-3) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23800
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23800
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_CC_HAS_SLS=y
# CONFIG_SLS is not set
# CONFIG_X86_CPU_RESCTRL is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_INTEL_TDX_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# CONFIG_PERF_EVENTS_AMD_BRS is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_LATE_LOADING=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_PRMT=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_VM_GET_PAGE_PROT=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_USERFAULTFD=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_PTE_MARKER=y
CONFIG_PTE_MARKER_UFFD_WP=y

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
# CONFIG_EFI_COCO_SECRET is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_GSC is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_AMT is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_OCTEON_EP is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
# CONFIG_SFC_SIENA is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWLMEI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SY7636A is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_WMI_EC is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SIMPLE_MFD_I2C is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_TOY is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_RC_XBOX_DVD is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# end of Media drivers

CONFIG_MEDIA_HIDE_ANCILLARY_SUBDRV=y

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LETSKETCH is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# CONFIG_DMABUF_SYSFS_STATS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MEM is not set
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_AMD_HSMP is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_IFS is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_ISHTP_ECLITE is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_GENERIC is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_STACK_HASH_ORDER=20
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_OBJTOOL=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
# CONFIG_FPROBE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAIL_SUNRPC is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='ltp'
	export testcase='ltp'
	export category='functional'
	export need_memory='4G'
	export job_origin='ltp-part2.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='lkp-ivb-d05'
	export tbox_group='lkp-ivb-d05'
	export submit_id='62b9512fa55bdc54b5383f4a'
	export job_file='/lkp/jobs/scheduled/lkp-ivb-d05/ltp-pty-ucode=0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9-20220627-21685-1ht87sk-4.yaml'
	export id='79608fe3764a45725900bc21b0aa315fc36ed79f'
	export queuer_version='/zday/lkp'
	export kconfig='x86_64-rhel-8.3-func'
	export model='Ivy Bridge'
	export nr_node=1
	export nr_cpu=4
	export memory='8G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=4
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB012T4_BTWD422402S31P2GGN-part2'
	export hdd_partitions='/dev/disk/by-id/ata-ST1000DM003-1CH162_Z1DARLY7-part*'
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BB012T4_BTWD422402S31P2GGN-part1'
	export brand='Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz'
	export commit='39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9'
	export netconsole_port=6679
	export ucode='0x21'
	export need_kconfig_hw='{"NET_VENDOR_REALTEK"=>"y"}
{"R8169"=>"y"}
SATA_AHCI
DRM_I915'
	export bisect_dmesg=true
	export need_kconfig='BLK_DEV_LOOP
{"CAN"=>"m"}
{"CAN_RAW"=>"m"}
{"CAN_VCAN"=>"m"}
{"MINIX_FS"=>"m"}
{"CHECKPOINT_RESTORE"=>"y"}'
	export initrds='linux_headers'
	export enqueue_time='2022-06-27 14:41:52 +0800'
	export _id='62b95130a55bdc54b5383f4b'
	export _rt='/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9'
	export user='lkp'
	export compiler='gcc-11'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='2da850b3d1cb4425e8846f168ca19d58670c87e7'
	export base_commit='a111daf0c53ae91e71fd2bfe7497862d14132e3e'
	export branch='linux-review/Dario-Binacchi/can-slcan-extend-supported-features/20220614-203636'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export result_root='/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/3'
	export scheduler_version='/lkp/lkp/.src-20220627-101958'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/3
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/vmlinuz-5.19.0-rc2-00005-g39bbbe2356a2
branch=linux-review/Dario-Binacchi/can-slcan-extend-supported-features/20220614-203636
job=/lkp/jobs/scheduled/lkp-ivb-d05/ltp-pty-ucode=0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9-20220627-21685-1ht87sk-4.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-func
commit=39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9
max_uptime=2100
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/linux-headers.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/ltp_20220625.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/ltp-x86_64-14c1f76-1_20220625.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220216.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.19.0-rc3-wt-ath-08406-g2da850b3d1cb'
	export repeat_to=6
	export schedule_notify_address=
	export stop_repeat_if_found='dmesg.BUG:sleeping_function_called_from_invalid_context_at_net/core/dev.c'
	export kbuild_queue_analysis=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/vmlinuz-5.19.0-rc2-00005-g39bbbe2356a2'
	export dequeue_time='2022-06-27 14:46:23 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-ivb-d05/ltp-pty-ucode=0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9-20220627-21685-1ht87sk-4.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test test='pty' $LKP_SRC/tests/wrapper ltp
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env test='pty' $LKP_SRC/stats/wrapper ltp
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time ltp.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--4I+8hqiQcx5tW7oo
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ltp
Content-Transfer-Encoding: quoted-printable

/usr/bin/mkisofs
2022-06-27 06:49:06 ./runltp -f pty
INFO: creating /lkp/benchmarks/ltp/output directory
INFO: creating /lkp/benchmarks/ltp/results directory
Checking for required user/group ids

'nobody' user id and group found.
'bin' user id and group found.
'daemon' user id and group found.
Users group found.
Sys group found.
Required users/groups exist.
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

/etc/os-release
PRETTY_NAME=3D"Debian GNU/Linux 11 (bullseye)"
NAME=3D"Debian GNU/Linux"
VERSION_ID=3D"11"
VERSION=3D"11 (bullseye)"
VERSION_CODENAME=3Dbullseye
ID=3Ddebian
HOME_URL=3D"https://www.debian.org/"
SUPPORT_URL=3D"https://www.debian.org/support"
BUG_REPORT_URL=3D"https://bugs.debian.org/"

uname:
Linux lkp-ivb-d05 5.19.0-rc2-00005-g39bbbe2356a2 #1 SMP Mon Jun 27 13:26:09=
 CST 2022 x86_64 GNU/Linux

/proc/cmdline
ip=3D::::lkp-ivb-d05::dhcp root=3D/dev/ram0 RESULT_ROOT=3D/result/ltp/pty-u=
code=3D0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-fun=
c/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/3 BOOT_IMAGE=3D/pkg/linux=
/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/vmlin=
uz-5.19.0-rc2-00005-g39bbbe2356a2 branch=3Dlinux-review/Dario-Binacchi/can-=
slcan-extend-supported-features/20220614-203636 job=3D/lkp/jobs/scheduled/l=
kp-ivb-d05/ltp-pty-ucode=3D0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a=
2a13ec26a8765d8a4e6dfe7ce33e9-20220627-21685-1ht87sk-4.yaml user=3Dlkp ARCH=
=3Dx86_64 kconfig=3Dx86_64-rhel-8.3-func commit=3D39bbbe2356a2a13ec26a8765d=
8a4e6dfe7ce33e9 max_uptime=3D2100 LKP_SERVER=3Dinternal-lkp-server nokaslr =
selinux=3D0 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 net.ifnames=3D0 printk.devkmsg=3Don panic=3D-1 softlockup_pan=
ic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 drbd.minor_count=3D8 systemd.log_level=3Derr ignore_loglevel console=3Dtt=
y0 earlyprintk=3DttyS0,115200 console=3DttyS0,115200 vga=3Dnormal rw

Gnu C                  gcc (Debian 10.2.1-6) 10.2.1 20210110
Clang                =20
Gnu make               4.3
util-linux             2.36.1
mount                  linux 2.36.1 (libmount 2.36.1: selinux, smack, btrfs=
, namespaces, assert, debug)
modutils               28
e2fsprogs              1.46.2
Linux C Library        > libc.2.31
Dynamic linker (ldd)   2.31
Procps                 3.3.17
iproute2               0.3.0
iputils                20210202
ethtool                5.9
Kbd                    loadkeys:
Sh-utils               8.32
Modules Loaded         netconsole btrfs blake2b_generic xor raid6_pq zstd_c=
ompress libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64=
 sg i915 intel_rapl_msr intel_gtt intel_rapl_common drm_buddy x86_pkg_temp_=
thermal drm_display_helper intel_powerclamp coretemp crct10dif_pclmul crc32=
_pclmul crc32c_intel ahci ttm ghash_clmulni_intel rapl libahci intel_cstate=
 ipmi_devintf drm_kms_helper intel_uncore ipmi_msghandler usb_storage mei_m=
e syscopyarea sysfillrect libata sysimgblt mei fb_sys_fops video drm fuse i=
p_tables

free reports:
               total        used        free      shared  buff/cache   avai=
lable
Mem:         6638428      661888     2823244        5300     3153296     27=
45820
Swap:              0           0           0

cpuinfo:
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   36 bits physical, 48 bits virtual
CPU(s):                          4
On-line CPU(s) list:             0-3
Thread(s) per core:              2
Core(s) per socket:              2
Socket(s):                       1
NUMA node(s):                    1
Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           58
Model name:                      Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz
Stepping:                        9
CPU MHz:                         3293.565
CPU max MHz:                     3300.0000
CPU min MHz:                     1600.0000
BogoMIPS:                        6585.14
L1d cache:                       64 KiB
L1i cache:                       64 KiB
L2 cache:                        512 KiB
L3 cache:                        3 MiB
NUMA node0 CPU(s):               0-3
Vulnerability Itlb multihit:     KVM: Mitigation: VMX unsupported
Vulnerability L1tf:              Mitigation; PTE Inversion
Vulnerability Mds:               Mitigation; Clear CPU buffers; SMT vulnera=
ble
Vulnerability Meltdown:          Mitigation; PTI
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disab=
led via prctl
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and _=
_user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Retpolines, IBPB conditional, =
IBRS_FW, STIBP conditional, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic se=
p mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm p=
be syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xt=
opology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl es=
t tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsa=
ve avx f16c lahf_lm cpuid_fault epb pti ssbd ibrs ibpb stibp fsgsbase smep =
erms xsaveopt dtherm arat pln pts md_clear flush_l1d

available filesystems:
9p autofs bdev bpf btrfs cgroup cgroup2 configfs cpuset debugfs devpts devt=
mpfs ext3 ext4 fuse fuseblk fusectl hugetlbfs mqueue nfs nfs4 pipefs proc p=
store ramfs rpc_pipefs securityfs sockfs sysfs tmpfs tracefs

mounted filesystems (/proc/mounts):
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,noexec,size=3D4096k,nr_inodes=3D65536,mode=
=3D755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime =
0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,size=3D1327688k,nr_inodes=3D819200,mode=3D=
755 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,m=
emory_recursiveprot 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=3D700 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=3D30,pgrp=3D1,time=
out=3D0,minproto=3D5,maxproto=3D5,direct,pipe_ino=3D32328 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime,pagesize=3D2M 0 0
mqueue /dev/mqueue mqueue rw,nosuid,nodev,noexec,relatime 0 0
sunrpc /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,nosuid,nodev,noexec,relatime 0 0
tracefs /sys/kernel/tracing tracefs rw,nosuid,nodev,noexec,relatime 0 0
configfs /sys/kernel/config configfs rw,nosuid,nodev,noexec,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,nosuid,nodev,noexec,relatime 0 0
tmp /tmp tmpfs rw,relatime 0 0
/dev/sda1 /opt/rootfs btrfs rw,relatime,ssd,space_cache,subvolid=3D5,subvol=
=3D/ 0 0

mounted filesystems (df):
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs          tmpfs     3.2G     0  3.2G   0% /dev/shm
tmpfs          tmpfs     1.3G  612K  1.3G   1% /run
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmp            tmpfs     3.2G  328K  3.2G   1% /tmp
/dev/sda1      btrfs     500G  7.0G  493G   2% /opt/rootfs

AppArmor disabled

SELinux mode: unknown
no big block device was specified on commandline.
Tests which require a big block device are disabled.
You can specify it with option -z
COMMAND:    /lkp/benchmarks/ltp/bin/ltp-pan   -e -S   -a 3635     -n 3635 -=
p -f /tmp/ltp-s6L50zOKT0/alltests -l /lkp/benchmarks/ltp/results/LTP_RUN_ON=
-2022_06_27-06h_49m_06s.log  -C /lkp/benchmarks/ltp/output/LTP_RUN_ON-2022_=
06_27-06h_49m_06s.failed -T /lkp/benchmarks/ltp/output/LTP_RUN_ON-2022_06_2=
7-06h_49m_06s.tconf
LOG File: /lkp/benchmarks/ltp/results/LTP_RUN_ON-2022_06_27-06h_49m_06s.log
FAILED COMMAND File: /lkp/benchmarks/ltp/output/LTP_RUN_ON-2022_06_27-06h_4=
9m_06s.failed
TCONF COMMAND File: /lkp/benchmarks/ltp/output/LTP_RUN_ON-2022_06_27-06h_49=
m_06s.tconf
Running tests.......
<<<test_start>>>
tag=3Dpty01 stime=3D1656312546
cmdline=3D"pty01"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       1  TPASS  :  test1
pty01       2  TPASS  :  test2
pty01       3  TPASS  :  test3
pty01       4  TPASS  :  test4
pty01       5  TPASS  :  test5
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D10 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D0 cstime=3D2
<<<test_end>>>
<<<test_start>>>
tag=3Dpty02 stime=3D1656312556
cmdline=3D"pty02"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_test.c:1526: TINFO: Timeout per run is 0h 00m 30s
pty02.c:53: TINFO: Calling FIONREAD, this will hang in n_tty_ioctl() if the=
 bug is present...
pty02.c:59: TPASS: Got to the end without hanging

Summary:
passed   1
failed   0
broken   0
skipped  0
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D0 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D0 cstime=3D0
<<<test_end>>>
<<<test_start>>>
tag=3Dpty03 stime=3D1656312556
cmdline=3D"pty03"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_test.c:1526: TINFO: Timeout per run is 0h 01m 00s
pty03.c:108: TINFO: Creating PTY with SLIP line discipline
pty03.c:91: TCONF: You don't appear to have the SLIP TTY line discipline: E=
INVAL (22)
pty03.c:108: TINFO: Creating PTY with Async PPP line discipline
pty03.c:91: TCONF: You don't appear to have the Async PPP TTY line discipli=
ne: EINVAL (22)
pty03.c:108: TINFO: Creating PTY with AX25/KISS line discipline
pty03.c:91: TCONF: You don't appear to have the AX25/KISS TTY line discipli=
ne: EINVAL (22)
pty03.c:108: TINFO: Creating PTY with HDLC line discipline
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 20, delay_bias =3D=
 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D -141469536ns, avg_dev =3D 778082560ns, dev_ratio =3D 5.50 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 70388ns, avg_dev =3D  4476ns, dev_ratio =3D 0.06 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 21391ns, avg_dev =3D  3162ns, dev_ratio =3D 0.15 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D -141420512ns, avg_dev =3D 778083072ns, dev_ratio =3D 5.50 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 24054  , avg_dev =3D  3727  , dev_ratio =3D 0.15 }
=2E./../../include/tst_fuzzy_sync.h:494: TINFO: Reached deviation ratios < =
0.10, introducing randomness
=2E./../../include/tst_fuzzy_sync.h:497: TINFO: Delay range is [-15908, 260=
24]
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 32456, delay_bias =
=3D 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D   130ns, avg_dev =3D    12ns, dev_ratio =3D 0.09 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 48260ns, avg_dev =3D  2204ns, dev_ratio =3D 0.05 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 29500ns, avg_dev =3D   708ns, dev_ratio =3D 0.02 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D 18890ns, avg_dev =3D  1682ns, dev_ratio =3D 0.09 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 10186  , avg_dev =3D   906  , dev_ratio =3D 0.09 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty03.c:134: TPASS: Did not crash with HDLC TTY discipline
pty03.c:108: TINFO: Creating PTY with Sync PPP line discipline
pty03.c:91: TCONF: You don't appear to have the Sync PPP TTY line disciplin=
e: EINVAL (22)
pty03.c:108: TINFO: Creating PTY with SLCAN line discipline
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 20, delay_bias =3D=
 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D -4621ns, avg_dev =3D 24829ns, dev_ratio =3D 5.37 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 17758180ns, avg_dev =3D 2379348ns, dev_ratio =3D 0.13 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 21860ns, avg_dev =3D   691ns, dev_ratio =3D 0.03 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D 17731700ns, avg_dev =3D 2392392ns, dev_ratio =3D 0.13 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 9403751  , avg_dev =3D 1279328  , dev_ratio =3D 0.14 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty03.c:134: TPASS: Did not crash with SLCAN TTY discipline
pty03.c:108: TINFO: Creating PTY with PPS line discipline
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 20, delay_bias =3D=
 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D   120ns, avg_dev =3D    47ns, dev_ratio =3D 0.39 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 542529ns, avg_dev =3D 480813ns, dev_ratio =3D 0.89 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 20011ns, avg_dev =3D  1545ns, dev_ratio =3D 0.08 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D 522639ns, avg_dev =3D 479881ns, dev_ratio =3D 0.92 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 271851  , avg_dev =3D 247664  , dev_ratio =3D 0.91 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty03.c:134: TPASS: Did not crash with PPS TTY discipline
pty03.c:108: TINFO: Creating PTY with CAIF line discipline
pty03.c:91: TCONF: You don't appear to have the CAIF TTY line discipline: E=
INVAL (22)
pty03.c:108: TINFO: Creating PTY with GSM line discipline
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 20, delay_bias =3D=
 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D -14299ns, avg_dev =3D 78637ns, dev_ratio =3D 5.50 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 12752330ns, avg_dev =3D 1173720ns, dev_ratio =3D 0.09 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 20738ns, avg_dev =3D   965ns, dev_ratio =3D 0.05 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D 12717293ns, avg_dev =3D 1213492ns, dev_ratio =3D 0.10 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 6725590  , avg_dev =3D 616283  , dev_ratio =3D 0.09 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty03.c:134: TPASS: Did not crash with GSM TTY discipline

Summary:
passed   4
failed   0
broken   0
skipped  5
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D120 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D11374 cstime=3D6778
<<<test_end>>>
<<<test_start>>>
tag=3Dpty04 stime=3D1656312676
cmdline=3D"pty04"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_test.c:1526: TINFO: Timeout per run is 0h 00m 30s
pty04.c:130: TINFO: PTS path is /dev/pts/0
pty04.c:105: TCONF: You don't appear to have the N_SLIP TTY line discipline=
: EINVAL (22)
pty04.c:130: TINFO: PTS path is /dev/pts/1
pty04.c:251: TINFO: Netdev is slcan0
pty04.c:260: TINFO: Netdev MTU is 16 (we set 16)
pty04.c:277: TINFO: Bound netdev 1834 to socket 8
tst_buffers.c:55: TINFO: Test is using guarded buffers
pty04.c:390: TINFO: Reading from socket 8
tst_buffers.c:55: TINFO: Test is using guarded buffers
pty04.c:214: TPASS: Wrote PTY N_SLCAN 6 (1)
pty04.c:223: TPASS: Wrote PTY N_SLCAN 6 (2)
pty04.c:396: TPASS: Read netdev N_SLCAN 8 (1)
pty04.c:402: TPASS: Read netdev N_SLCAN 8 (2)
pty04.c:408: TPASS: Write netdev N_SLCAN 8
pty04.c:229: TPASS: Read PTY N_SLCAN 6
pty04.c:419: TPASS: Data transmission on netdev interrupted by hangup
pty04.c:447: TINFO: Sent hangup ioctl to PTS
pty04.c:449: TINFO: Sent hangup ioctl to PTM
pty04.c:240: TPASS: Transmission on PTY interrupted by hangup

Summary:
passed   8
failed   0
broken   0
skipped  1
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D2 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D0 cstime=3D1
<<<test_end>>>
<<<test_start>>>
tag=3Dpty05 stime=3D1656312678
cmdline=3D"pty05"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_taint.c:116: TCONF: Ignoring already set kernel warning taint
tst_test.c:1526: TINFO: Timeout per run is 0h 03m 00s
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 1024, delay_bias =
=3D 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D    57ns, avg_dev =3D    55ns, dev_ratio =3D 0.97 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 11494ns, avg_dev =3D  1296ns, dev_ratio =3D 0.11 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D  3017ns, avg_dev =3D   250ns, dev_ratio =3D 0.08 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D  8533ns, avg_dev =3D  1109ns, dev_ratio =3D 0.13 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D  4498  , avg_dev =3D   536  , dev_ratio =3D 0.12 }
=2E./../../include/tst_fuzzy_sync.h:654: TINFO: Exceeded execution loops, r=
equesting exit
pty05.c:84: TPASS: Nothing bad happened, probably

Summary:
passed   1
failed   0
broken   0
skipped  1
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D41 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D3989 cstime=3D3404
<<<test_end>>>
<<<test_start>>>
tag=3Dpty06 stime=3D1656312719
cmdline=3D"pty06"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_taint.c:116: TCONF: Ignoring already set kernel warning taint
tst_test.c:1526: TINFO: Timeout per run is 0h 03m 00s
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 1024, delay_bias =
=3D 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D    85ns, avg_dev =3D    42ns, dev_ratio =3D 0.50 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 513943ns, avg_dev =3D 22121ns, dev_ratio =3D 0.04 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 1167407ns, avg_dev =3D 79593ns, dev_ratio =3D 0.07 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D -653380ns, avg_dev =3D 77996ns, dev_ratio =3D 0.12 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 338689  , avg_dev =3D 41038  , dev_ratio =3D 0.12 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty06.c:75: TPASS: Did not crash with VT_DISALLOCATE

Summary:
passed   1
failed   0
broken   0
skipped  1
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D150 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D7928 cstime=3D6290
<<<test_end>>>
<<<test_start>>>
tag=3Dpty07 stime=3D1656312869
cmdline=3D"pty07"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
tst_taint.c:116: TCONF: Ignoring already set kernel warning taint
tst_test.c:1526: TINFO: Timeout per run is 0h 03m 00s
pty07.c:92: TINFO: Saving active console 1
=2E./../../include/tst_fuzzy_sync.h:484: TINFO: Minimum sampling period end=
ed
=2E./../../include/tst_fuzzy_sync.h:307: TINFO: loop =3D 1024, delay_bias =
=3D 0
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: start_a - start_b: { avg =
=3D   138ns, avg_dev =3D    93ns, dev_ratio =3D 0.68 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - start_a  : { avg =
=3D 11110602ns, avg_dev =3D 3547036ns, dev_ratio =3D 0.32 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_b - start_b  : { avg =
=3D 21897612ns, avg_dev =3D 6269088ns, dev_ratio =3D 0.29 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: end_a - end_b    : { avg =
=3D -10786873ns, avg_dev =3D 7093202ns, dev_ratio =3D 0.66 }
=2E./../../include/tst_fuzzy_sync.h:295: TINFO: spins            : { avg =
=3D 5441998  , avg_dev =3D 3577182  , dev_ratio =3D 0.66 }
=2E./../../include/tst_fuzzy_sync.h:648: TINFO: Exceeded execution time, re=
questing exit
pty07.c:76: TPASS: Did not crash with VT_RESIZE
pty07.c:105: TINFO: Restoring active console

Summary:
passed   1
failed   0
broken   0
skipped  1
warnings 0
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D150 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D12817 cstime=3D4756
<<<test_end>>>
<<<test_start>>>
tag=3Dptem01 stime=3D1656313019
cmdline=3D"ptem01"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
ptem01      1  TPASS  :  test1
ptem01      2  TPASS  :  test2
ptem01      3  TPASS  :  test3
ptem01      4  TPASS  :  test4
ptem01      5  TPASS  :  test5
ptem01      6  TPASS  :  test6
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D0 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D0 cstime=3D1
<<<test_end>>>
<<<test_start>>>
tag=3Dhangup01 stime=3D1656313019
cmdline=3D"hangup01"
contacts=3D""
analysis=3Dexit
<<<test_output>>>
hangup01    1  TPASS  :  child process exited with status 0
incrementing stop
<<<execution_status>>>
initiation_status=3D"ok"
duration=3D1 termination_type=3Dexited termination_id=3D0 corefile=3Dno
cutime=3D0 cstime=3D0
<<<test_end>>>
INFO: ltp-pan reported all tests PASS
LTP Version: 20220527-61-g9fb28002b

       ###############################################################

            Done executing testcases.
            LTP Version:  20220527-61-g9fb28002b
       ###############################################################


--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
:#! jobs/ltp-part2.yaml:
suite: ltp
testcase: ltp
category: functional
need_memory: 4G
ltp:
  test: pty
job_origin: ltp-part2.yaml
:#! queue options:
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-ivb-d05
tbox_group: lkp-ivb-d05
submit_id: 62b94070e30f52a721af6e42
job_file: "/lkp/jobs/scheduled/lkp-ivb-d05/ltp-pty-ucode=0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9-20220627-42785-89799h-0.yaml"
id: 4e7f7a7a21d523fb5f525156a408e95fe1e0b934
queuer_version: "/zday/lkp"
kconfig: x86_64-rhel-8.3-func
:#! hosts/lkp-ivb-d05:
model: Ivy Bridge
nr_node: 1
nr_cpu: 4
memory: 8G
nr_ssd_partitions: 1
nr_hdd_partitions: 4
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB012T4_BTWD422402S31P2GGN-part2"
hdd_partitions: "/dev/disk/by-id/ata-ST1000DM003-1CH162_Z1DARLY7-part*"
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BB012T4_BTWD422402S31P2GGN-part1"
brand: Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz
:#! include/category/functional:
kmsg:
heartbeat:
meminfo:
:#! include/queue/cyclic:
commit: 39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9
:#! include/testbox/lkp-ivb-d05:
netconsole_port: 6679
ucode: '0x21'
need_kconfig_hw:
- NET_VENDOR_REALTEK: y
- R8169: y
- SATA_AHCI
- DRM_I915
bisect_dmesg: true
:#! include/ltp:
need_kconfig:
- BLK_DEV_LOOP
- CAN: m
- CAN_RAW: m
- CAN_VCAN: m
- MINIX_FS: m
- CHECKPOINT_RESTORE: y
initrds:
- linux_headers
enqueue_time: 2022-06-27 13:30:24.341831217 +08:00
_id: 62b94070e30f52a721af6e42
_rt: "/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9"
:#! schedule options:
user: lkp
compiler: gcc-11
LKP_SERVER: internal-lkp-server
head_commit: 2da850b3d1cb4425e8846f168ca19d58670c87e7
base_commit: a111daf0c53ae91e71fd2bfe7497862d14132e3e
branch: linux-devel/devel-hourly-20220625-155634
rootfs: debian-11.1-x86_64-20220510.cgz
result_root: "/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/0"
scheduler_version: "/lkp/lkp/.src-20220627-101958"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/ltp/pty-ucode=0x21/lkp-ivb-d05/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/vmlinuz-5.19.0-rc2-00005-g39bbbe2356a2
- branch=linux-devel/devel-hourly-20220625-155634
- job=/lkp/jobs/scheduled/lkp-ivb-d05/ltp-pty-ucode=0x21-debian-11.1-x86_64-20220510.cgz-39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9-20220627-42785-89799h-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-func
- commit=39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9
- max_uptime=2100
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/linux-headers.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/ltp_20220625.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/ltp-x86_64-14c1f76-1_20220625.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220216.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn
:#! /cephfs/db/releases/20220625093247/lkp-src/include/site/inn:
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
:#! runtime status:
last_kernel: 5.19.0-rc2-intel-next-01618-g2c3c4a63740f
schedule_notify_address:
:#! user overrides:
kernel: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/39bbbe2356a2a13ec26a8765d8a4e6dfe7ce33e9/vmlinuz-5.19.0-rc2-00005-g39bbbe2356a2"
dequeue_time: 2022-06-27 14:11:53.637569391 +08:00
:#! /cephfs/db/releases/20220627122720/lkp-src/include/site/inn:
job_state: finished
loadavg: 12.34 10.55 5.14 1/222 17292
start_time: '1656310481'
end_time: '1656310955'
version: "/lkp/lkp/.src-20220627-102040:973b271d4:4f1197d97"

--4I+8hqiQcx5tW7oo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./runltp -f pty

--4I+8hqiQcx5tW7oo--
