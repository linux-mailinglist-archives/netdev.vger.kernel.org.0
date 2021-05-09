Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969723776AA
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 14:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEIM6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 08:58:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:26375 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhEIM6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 08:58:22 -0400
IronPort-SDR: AL8JE586ue+nAZyKMI4ypJHjByttxQuW7qu1f9/lL+iqdkdesgnYPnUXhQLS9unOA75Mjoqv+3
 ab05XzE6ILbQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9978"; a="179287457"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="xz'?yaml'?scan'208";a="179287457"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 05:57:19 -0700
IronPort-SDR: yaNxN0SQReZ9drX8uCskQD66ZPMwt9kw6ShYWGYnJ+NvI/agkDuyMsQD6JEVphg/TJqu4Eer1i
 pMsbT10UE99g==
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="xz'?yaml'?scan'208";a="435727867"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 05:57:12 -0700
Date:   Sun, 9 May 2021 21:14:11 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     0day robot <lkp@intel.com>, Taehee Yoo <ap420073@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Subject: [rtnetlink]  aced02f261:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Message-ID: <20210509131411.GA22693@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-9):

commit: aced02f26141d4ad6fb3370f16282029575a099d ("[Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list")
url: https://github.com/0day-ci/linux/commits/Cong-Wang/rtnetlink-use-rwsem-to-protect-rtnl_af_ops-list/20210506-073907
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git 8621436671f3a4bba5db57482e1ee604708bf1eb

in testcase: kernel-selftests
version: kernel-selftests-x86_64-0d95472a-1_20210507
with following parameters:

	group: x86
	ucode: 0xde

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 4 threads 1 sockets Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz with 32G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


kern  :err   : [   28.131242] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1352
kern  :err   : [   28.132015] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 376, name: ip
kern  :warn  : [   28.132651] 2 locks held by ip/376:
kern :warn : [   28.132982] #0: ffffffff8343bcc0 (rcu_read_lock){....}-{1:2}, at: rtnetlink_rcv_msg (kbuild/src/consumer/include/linux/rcupdate.h:655 kbuild/src/consumer/net/core/rtnetlink.c:5490) 
kern :warn : [   28.136748] #1: ffffffff8343bcc0 (rcu_read_lock){....}-{1:2}, at: rtnl_calcit+0x9f/0x200 
kern  :err   : [   28.137792] Preemption disabled at:
kern :err : [   28.137794] 0x0 
kern  :warn  : [   28.138727] CPU: 3 PID: 376 Comm: ip Not tainted 5.12.0-11126-gaced02f26141 #1
kern  :warn  : [   28.139350] Hardware name: Intel Corporation NUC7i7BNH/NUC7i7BNB, BIOS BNKBL357.86A.0067.2018.0814.1500 08/14/2018
kern  :warn  : [   28.140196] Call Trace:
kern :warn : [   28.140454] dump_stack (kbuild/src/consumer/lib/dump_stack.c:122) 
kern :warn : [   28.140777] ___might_sleep.cold (kbuild/src/consumer/kernel/sched/core.c:8339) 
kern :warn : [   28.141164] down_read (kbuild/src/consumer/include/linux/kernel.h:96 kbuild/src/consumer/kernel/locking/rwsem.c:1352) 
kern :warn : [   28.141486] if_nlmsg_size (kbuild/src/consumer/net/core/rtnetlink.c:591 kbuild/src/consumer/net/core/rtnetlink.c:1047) 
kern :warn : [   28.141846] rtnl_calcit+0x102/0x200 
kern :warn : [   28.142279] ? rtnl_fill_ifinfo (kbuild/src/consumer/net/core/rtnetlink.c:2057) 
kern :warn : [   28.142677] rtnetlink_rcv_msg (kbuild/src/consumer/net/core/rtnetlink.c:5507) 
kern :warn : [   28.143058] ? lock_acquire (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5514 kbuild/src/consumer/kernel/locking/lockdep.c:5477) 
kern :warn : [   28.143414] ? rtnetlink_put_metrics (kbuild/src/consumer/net/core/rtnetlink.c:5463) 
kern :warn : [   28.143831] netlink_rcv_skb (kbuild/src/consumer/net/netlink/af_netlink.c:2502) 
kern :warn : [   28.144199] netlink_unicast (kbuild/src/consumer/net/netlink/af_netlink.c:1313 kbuild/src/consumer/net/netlink/af_netlink.c:1338) 
kern :warn : [   28.144569] netlink_sendmsg (kbuild/src/consumer/net/netlink/af_netlink.c:1927) 
kern :warn : [   28.144946] sock_sendmsg (kbuild/src/consumer/net/socket.c:654 kbuild/src/consumer/net/socket.c:674) 
kern :warn : [   28.145282] __sys_sendto (kbuild/src/consumer/net/socket.c:1977) 
kern :warn : [   28.145664] ? lock_is_held_type (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5556) 
kern :warn : [   28.146053] ? syscall_enter_from_user_mode (kbuild/src/consumer/kernel/entry/common.c:290 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:80 kbuild/src/consumer/kernel/entry/common.c:106) 
kern :warn : [   28.146519] __x64_sys_sendto (kbuild/src/consumer/net/socket.c:1989 kbuild/src/consumer/net/socket.c:1985 kbuild/src/consumer/net/socket.c:1985) 
kern :warn : [   28.146877] do_syscall_64 (kbuild/src/consumer/arch/x86/entry/common.c:47) 
kern :warn : [   28.147218] entry_SYSCALL_64_after_hwframe (kbuild/src/consumer/arch/x86/entry/entry_64.S:112) 
kern  :warn  : [   28.147663] RIP: 0033:0x7f2e3859385d
kern :warn : [ 28.148000] Code: ff ff ff ff eb b6 0f 1f 80 00 00 00 00 48 8d 05 a9 5e 0c 00 41 89 ca 8b 00 85 c0 75 20 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6b c3 66 2e 0f 1f 84 00 00 00 00 00 41 56 41
All code
========
   0:	ff                   	(bad)  
   1:	ff                   	(bad)  
   2:	ff                   	(bad)  
   3:	ff                   	(bad)  
   4:	eb b6                	jmp    0xffffffffffffffbc
   6:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   d:	48 8d 05 a9 5e 0c 00 	lea    0xc5ea9(%rip),%rax        # 0xc5ebd
  14:	41 89 ca             	mov    %ecx,%r10d
  17:	8b 00                	mov    (%rax),%eax
  19:	85 c0                	test   %eax,%eax
  1b:	75 20                	jne    0x3d
  1d:	45 31 c9             	xor    %r9d,%r9d
  20:	45 31 c0             	xor    %r8d,%r8d
  23:	b8 2c 00 00 00       	mov    $0x2c,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 6b                	ja     0x9d
  32:	c3                   	retq   
  33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  3a:	00 00 00 
  3d:	41 56                	push   %r14
  3f:	41                   	rex.B

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 6b                	ja     0x73
   8:	c3                   	retq   
   9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10:	00 00 00 
  13:	41 56                	push   %r14
  15:	41                   	rex.B
kern  :warn  : [   28.149463] RSP: 002b:00007ffc052f28c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
kern  :warn  : [   28.150107] RAX: ffffffffffffffda RBX: 000055edaab5a580 RCX: 00007f2e3859385d
kern  :warn  : [   28.150699] RDX: 0000000000000028 RSI: 00007ffc052f28d0 RDI: 0000000000000003
kern  :warn  : [   28.151291] RBP: 00007ffc052f28d0 R08: 0000000000000000 R09: 0000000000000000
kern  :warn  : [   28.151882] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000011
kern  :warn  : [   28.152474] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

kern  :warn  : [   28.159184] =============================
kern  :warn  : [   28.159536] [ BUG: Invalid wait context ]
kern  :warn  : [   28.159900] 5.12.0-11126-gaced02f26141 #1 Tainted: G        W
kern  :warn  : [   28.160424] -----------------------------
kern  :warn  : [   28.160779] ip/376 is trying to lock:
kern :warn : [   28.161109] ffffffff8366adf0 (af_ops_sem){++++}-{3:3}, at: if_nlmsg_size (kbuild/src/consumer/net/core/rtnetlink.c:591 kbuild/src/consumer/net/core/rtnetlink.c:1047) 
kern  :warn  : [   28.161769] other info that might help us debug this:
kern  :warn  : [   28.162190] context-{4:4}
kern  :warn  : [   28.162445] 2 locks held by ip/376:
kern :warn : [   28.162760] #0: ffffffff8343bcc0 (rcu_read_lock){....}-{1:2}, at: rtnetlink_rcv_msg (kbuild/src/consumer/include/linux/rcupdate.h:655 kbuild/src/consumer/net/core/rtnetlink.c:5490) 
kern :warn : [   28.163457] #1: ffffffff8343bcc0 (rcu_read_lock){....}-{1:2}, at: rtnl_calcit+0x9f/0x200 
kern  :warn  : [   28.164160] stack backtrace:
kern  :warn  : [   28.164431] CPU: 3 PID: 376 Comm: ip Tainted: G        W         5.12.0-11126-gaced02f26141 #1
kern  :warn  : [   28.165120] Hardware name: Intel Corporation NUC7i7BNH/NUC7i7BNB, BIOS BNKBL357.86A.0067.2018.0814.1500 08/14/2018
kern  :warn  : [   28.165926] Call Trace:
kern :warn : [   28.166177] dump_stack (kbuild/src/consumer/lib/dump_stack.c:122) 
kern :warn : [   28.166488] __lock_acquire.cold (kbuild/src/consumer/kernel/locking/lockdep.c:6391 kbuild/src/consumer/kernel/locking/lockdep.c:4614 kbuild/src/consumer/kernel/locking/lockdep.c:4852) 
kern :warn : [   28.166853] ? lock_is_held_type (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5556) 
kern :warn : [   28.167220] lock_acquire (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5514 kbuild/src/consumer/kernel/locking/lockdep.c:5477) 
kern :warn : [   28.167543] ? if_nlmsg_size (kbuild/src/consumer/net/core/rtnetlink.c:591 kbuild/src/consumer/net/core/rtnetlink.c:1047) 
kern :warn : [   28.167895] down_read (kbuild/src/consumer/arch/x86/include/asm/atomic64_64.h:160 kbuild/src/consumer/include/asm-generic/atomic-instrumented.h:893 kbuild/src/consumer/include/asm-generic/atomic-long.h:65 kbuild/src/consumer/kernel/locking/rwsem.c:237 kbuild/src/consumer/kernel/locking/rwsem.c:1212 kbuild/src/consumer/kernel/locking/rwsem.c:1222 kbuild/src/consumer/kernel/locking/rwsem.c:1355) 
kern :warn : [   28.168201] ? if_nlmsg_size (kbuild/src/consumer/net/core/rtnetlink.c:591 kbuild/src/consumer/net/core/rtnetlink.c:1047) 
kern :warn : [   28.168549] if_nlmsg_size (kbuild/src/consumer/net/core/rtnetlink.c:591 kbuild/src/consumer/net/core/rtnetlink.c:1047) 
kern :warn : [   28.168884] rtnl_calcit+0x102/0x200 
kern :warn : [   28.169260] ? rtnl_fill_ifinfo (kbuild/src/consumer/net/core/rtnetlink.c:2057) 
kern :warn : [   28.169639] rtnetlink_rcv_msg (kbuild/src/consumer/net/core/rtnetlink.c:5507) 
kern :warn : [   28.170000] ? lock_acquire (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5514 kbuild/src/consumer/kernel/locking/lockdep.c:5477) 
kern :warn : [   28.170335] ? rtnetlink_put_metrics (kbuild/src/consumer/net/core/rtnetlink.c:5463) 
kern :warn : [   28.170730] netlink_rcv_skb (kbuild/src/consumer/net/netlink/af_netlink.c:2502) 
kern :warn : [   28.171073] netlink_unicast (kbuild/src/consumer/net/netlink/af_netlink.c:1313 kbuild/src/consumer/net/netlink/af_netlink.c:1338) 
kern :warn : [   28.171421] netlink_sendmsg (kbuild/src/consumer/net/netlink/af_netlink.c:1927) 
kern :warn : [   28.171770] sock_sendmsg (kbuild/src/consumer/net/socket.c:654 kbuild/src/consumer/net/socket.c:674) 
kern :warn : [   28.172088] __sys_sendto (kbuild/src/consumer/net/socket.c:1977) 
kern :warn : [   28.172414] ? lock_is_held_type (kbuild/src/consumer/kernel/locking/lockdep.c:438 kbuild/src/consumer/kernel/locking/lockdep.c:5556) 
kern :warn : [   28.172779] ? syscall_enter_from_user_mode (kbuild/src/consumer/kernel/entry/common.c:290 kbuild/src/consumer/arch/x86/include/asm/irqflags.h:80 kbuild/src/consumer/kernel/entry/common.c:106) 
kern :warn : [   28.173203] __x64_sys_sendto (kbuild/src/consumer/net/socket.c:1989 kbuild/src/consumer/net/socket.c:1985 kbuild/src/consumer/net/socket.c:1985) 
kern :warn : [   28.173543] do_syscall_64 (kbuild/src/consumer/arch/x86/entry/common.c:47) 
kern :warn : [   28.173865] entry_SYSCALL_64_after_hwframe (kbuild/src/consumer/arch/x86/entry/entry_64.S:112) 
kern  :warn  : [   28.174290] RIP: 0033:0x7f2e3859385d
kern :warn : [ 28.174613] Code: ff ff ff ff eb b6 0f 1f 80 00 00 00 00 48 8d 05 a9 5e 0c 00 41 89 ca 8b 00 85 c0 75 20 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 6b c3 66 2e 0f 1f 84 00 00 00 00 00 41 56 41
All code
========
   0:	ff                   	(bad)  
   1:	ff                   	(bad)  
   2:	ff                   	(bad)  
   3:	ff                   	(bad)  
   4:	eb b6                	jmp    0xffffffffffffffbc
   6:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   d:	48 8d 05 a9 5e 0c 00 	lea    0xc5ea9(%rip),%rax        # 0xc5ebd
  14:	41 89 ca             	mov    %ecx,%r10d
  17:	8b 00                	mov    (%rax),%eax
  19:	85 c0                	test   %eax,%eax
  1b:	75 20                	jne    0x3d
  1d:	45 31 c9             	xor    %r9d,%r9d
  20:	45 31 c0             	xor    %r8d,%r8d
  23:	b8 2c 00 00 00       	mov    $0x2c,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 6b                	ja     0x9d
  32:	c3                   	retq   
  33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  3a:	00 00 00 
  3d:	41 56                	push   %r14
  3f:	41                   	rex.B

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 6b                	ja     0x73
   8:	c3                   	retq   
   9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10:	00 00 00 
  13:	41 56                	push   %r14
  15:	41                   	rex.B
kern  :warn  : [   28.176011] RSP: 002b:00007ffc052f28c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
kern  :warn  : [   28.176624] RAX: ffffffffffffffda RBX: 000055edaab5a580 RCX: 00007f2e3859385d
kern  :warn  : [   28.177191] RDX: 0000000000000028 RSI: 00007ffc052f28d0 RDI: 0000000000000003
kern  :warn  : [   28.177756] RBP: 00007ffc052f28d0 R08: 0000000000000000 R09: 0000000000000000
kern  :warn  : [   28.178323] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000011
kern  :warn  : [   28.178890] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
kern  :info  : [   28.396508] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
kern  :debug : [   28.397686] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
kern  :info  : [   28.398251] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
kern  :info  : [   28.398891] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
kern  :info  : [   28.399815] ata1.00: ATA-9: INTEL SSDSC2BB800G4, D2010370, max UDMA/133
kern  :info  : [   28.400358] ata1.00: 1562824368 sectors, multi 1: LBA48 NCQ (depth 32)
kern  :debug : [   28.401620] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
kern  :info  : [   28.402186] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
kern  :info  : [   28.402826] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
kern  :info  : [   28.403862] ata1.00: configured for UDMA/133
kern  :notice: [   28.404448] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB80 0370 PQ: 0 ANSI: 5
kern  :info  : [   28.451494] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
kern  :info  : [   28.477306] ata3.00: ATA-10: INTEL SSDSCKJW180H6, RG11, max UDMA/133
kern  :info  : [   28.477862] ata3.00: 351651888 sectors, multi 16: LBA48 NCQ (depth 32), AA
kern  :info  : [   28.491327] ata3.00: configured for UDMA/133
kern  :notice: [   28.985058] scsi 2:0:0:0: Direct-Access     ATA      INTEL SSDSCKJW18 RG11 PQ: 0 ANSI: 5
kern  :notice: [   29.011071] scsi 0:0:0:0: Attached scsi generic sg0 type 0
kern  :notice: [   29.011625] scsi 2:0:0:0: Attached scsi generic sg1 type 0
kern  :info  : [   29.016535] i915 0000:00:02.0: [drm] Found 64MB of eDRAM
kern  :info  : [   29.017037] i915 0000:00:02.0: vgaarb: deactivate vga console
kern  :info  : [   29.019659] Console: switching to colour dummy device 80x25
kern  :info  : [   29.038204] ata1.00: Enabling discard_zeroes_data
kern  :notice: [   29.038581] sd 2:0:0:0: [sdb] 351651888 512-byte logical blocks: (180 GB/168 GiB)
kern  :notice: [   29.039221] sd 0:0:0:0: [sda] 1562824368 512-byte logical blocks: (800 GB/745 GiB)
kern  :notice: [   29.039749] sd 0:0:0:0: [sda] 4096-byte physical blocks
kern  :notice: [   29.040181] sd 2:0:0:0: [sdb] Write Protect is off
kern  :debug : [   29.040520] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
kern  :notice: [   29.040893] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kern  :notice: [   29.041582] sd 0:0:0:0: [sda] Write Protect is off
kern  :debug : [   29.041923] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
kern  :notice: [   29.042351] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kern  :info  : [   29.044791] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
kern  :warn  : [   29.046583] i915 0000:00:02.0: Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
kern  :notice: [   29.047231] i915 0000:00:02.0: [drm] Failed to load DMC firmware i915/kbl_dmc_ver1_04.bin. Disabling runtime power management.
kern  :notice: [   29.048024] i915 0000:00:02.0: [drm] DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
kern  :info  : [   29.050276]  sda: sda1 sda2
kern  :info  : [   29.050804]  sdb: sdb1
kern  :notice: [   29.052966] sd 2:0:0:0: [sdb] Attached SCSI disk
kern  :info  : [   29.053348] ata1.00: Enabling discard_zeroes_data
kern  :notice: [   29.053795] sd 0:0:0:0: [sda] Attached SCSI disk
kern  :notice: [   29.120205] random: fast init done
kern  :info  : [   29.136978] intel_rapl_common: Found RAPL domain package
kern  :info  : [   29.137361] intel_rapl_common: Found RAPL domain core
kern  :info  : [   29.137725] intel_rapl_common: Found RAPL domain uncore
kern  :info  : [   29.138106] intel_rapl_common: Found RAPL domain dram
kern  :info  : [   29.138462] intel_rapl_common: Found RAPL domain psys
kern  :info  : [   29.179045] raid6: avx2x4   gen() 21771 MB/s
kern  :info  : [   29.196054] raid6: avx2x4   xor() 11737 MB/s
kern  :info  : [   29.213043] raid6: avx2x2   gen() 21199 MB/s
kern  :info  : [   29.230016] raid6: avx2x2   xor() 12500 MB/s
kern  :info  : [   29.247096] raid6: avx2x1   gen() 18062 MB/s
kern  :info  : [   29.263989] raid6: avx2x1   xor() 10888 MB/s
kern  :info  : [   29.281390] raid6: sse2x4   gen() 10083 MB/s
kern  :info  : [   29.298000] raid6: sse2x4   xor()  6499 MB/s
kern  :info  : [   29.315014] raid6: sse2x2   gen() 11017 MB/s
kern  :info  : [   29.331999] raid6: sse2x2   xor()  6471 MB/s
kern  :info  : [   29.348999] raid6: sse2x1   gen()  7271 MB/s
kern  :info  : [   29.365989] raid6: sse2x1   xor()  5586 MB/s
kern  :info  : [   29.366303] raid6: using algorithm avx2x4 gen() 21771 MB/s
kern  :info  : [   29.366687] raid6: .... xor() 11737 MB/s, rmw enabled
kern  :info  : [   29.367071] raid6: using avx2x2 recovery algorithm
kern  :info  : [   29.383721] xor: automatically using best checksumming function   avx
kern  :info  : [   29.483041] i915 0000:00:02.0: [drm] failed to retrieve link info, disabling eDP
kern  :warn  : [   29.484170] ------------[ cut here ]------------
kern  :warn  : [   29.484497] WARN_ON(!ww && vma->resv && lock_is_held(&(&(vma->resv)->lock.base)->dep_map))


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install                job.yaml  # job file is attached in this email
        bin/lkp split-job --compatible job.yaml  # generate the yaml file for lkp run
        bin/lkp run                    generated-yaml-file



---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation

Thanks,
Oliver Sang


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.12.0-11126-gaced02f26141"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.12.0 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
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
CONFIG_IRQ_SIM=y
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
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y

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
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
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
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
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
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
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
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_LSM is not set
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_PRELOAD is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
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
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
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
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
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
# CONFIG_DPM_WATCHDOG is not set
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
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
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y

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
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
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
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
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
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
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
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_X86_SGX_KVM is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_KVM_MMU_AUDIT=y
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
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
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
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
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
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
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
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

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
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
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
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
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
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
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
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
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
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
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
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_COUNTER=m
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
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
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
CONFIG_NF_FLOW_TABLE_IPV4=m
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
CONFIG_NF_FLOW_TABLE_IPV6=m
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
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
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
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
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
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
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
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
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
CONFIG_BPF_JIT=y
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
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
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

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
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
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

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
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

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
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
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
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
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
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
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
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
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
# CONFIG_INTEL_MEI_HDCP is not set
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

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
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
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
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
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
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
# CONFIG_PATA_PLATFORM is not set
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
# CONFIG_MD_MULTIPATH is not set
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
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
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
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
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
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
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
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
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
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
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
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
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
# CONFIG_LED_TRIGGER_PHY is not set
# CONFIG_FIXED_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
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
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
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
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
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
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
# CONFIG_MT7921E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
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
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
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
# CONFIG_MAC80211_HWSIM is not set
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
# CONFIG_WWAN is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

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
# CONFIG_INPUT_MISC is not set
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
# CONFIG_RMI4_F54 is not set
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
CONFIG_HYPERV_KEYBOARD=m
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
# CONFIG_SERIAL_BCM63XX is not set
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
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
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
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
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
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

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
CONFIG_I2C_SMBUS=m
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
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
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
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
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
# CONFIG_SPI_ALTERA_CORE is not set
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
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
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
CONFIG_GPIO_MOCKUP=m
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
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
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
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
CONFIG_SENSORS_DELL_SMM=m
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
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
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
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
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
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
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
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

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
CONFIG_SP5100_TCO=m
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
CONFIG_XEN_WDT=m

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
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
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
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
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
# CONFIG_MFD_TPS80031 is not set
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
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_MXL692=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

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
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
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
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
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
CONFIG_HID_CHICONY=m
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
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
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
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
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
# CONFIG_HID_PLAYSTATION is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
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
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
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
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
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
# LED Blink
#
# CONFIG_LEDS_BLINK is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
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
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_ZYNQMP_DPDMA is not set
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
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
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
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
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
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
# CONFIG_QLGE is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
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
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
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
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
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
CONFIG_IOMMU_IO_PGTABLE=y
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

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
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_DTPM is not set
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
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
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
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
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
# CONFIG_XFS_ONLINE_REPAIR is not set
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
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
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
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
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
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
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
# CONFIG_MINIX_FS is not set
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
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
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
CONFIG_NFSD_V3=y
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
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
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
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
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
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
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
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
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
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
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

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
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
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
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
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
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
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_COHERENT_POOL=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
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
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B is not set
CONFIG_STACK_VALIDATION=y
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
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
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
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
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
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
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
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
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
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
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
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
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
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export kconfig='x86_64-rhel-8.3-kselftests'
	export need_memory='2G'
	export need_cpu=2
	export kernel_cmdline='erst_disable'
	export job_origin='kernel-selftests-x86.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-kbl-nuc1'
	export tbox_group='lkp-kbl-nuc1'
	export submit_id='609798e457be22f57929f048'
	export job_file='/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-aced02f26141d4ad6fb3370f16282029575a099d-20210509-62841-1365rm4-8.yaml'
	export id='437fe6e5d82e7e36adbdb1a80190ec1b00884b69'
	export queuer_version='/lkp-src'
	export model='Kaby Lake'
	export nr_node=1
	export nr_cpu=4
	export memory='32G'
	export nr_sdd_partitions=1
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part2'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part1'
	export brand='Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz'
	export commit='aced02f26141d4ad6fb3370f16282029575a099d'
	export netconsole_port=6674
	export ucode='0xde'
	export need_kconfig_hw='CONFIG_E1000E=y
CONFIG_SATA_AHCI
CONFIG_DRM_I915'
	export need_linux_headers=true
	export need_linux_selftests=true
	export need_kselftests=true
	export need_kconfig='CONFIG_POSIX_TIMERS=y ~ ">= v4.10-rc1"'
	export enqueue_time='2021-05-09 16:10:13 +0800'
	export _id='609798e457be22f57929f048'
	export _rt='/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='4e59ccb12a6f1816f7058a57c5e47881ea076fc7'
	export base_commit='9f4ad9e425a1d3b6a34617b8ea226d56a119a717'
	export branch='linux-review/Cong-Wang/rtnetlink-use-rwsem-to-protect-rtnl_af_ops-list/20210506-073907'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/8'
	export scheduler_version='/lkp/lkp/.src-20210506-110429'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-aced02f26141d4ad6fb3370f16282029575a099d-20210509-62841-1365rm4-8.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kselftests
branch=linux-review/Cong-Wang/rtnetlink-use-rwsem-to-protect-rtnl_af_ops-list/20210506-073907
commit=aced02f26141d4ad6fb3370f16282029575a099d
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/vmlinuz-5.12.0-11126-gaced02f26141
erst_disable
max_uptime=2100
RESULT_ROOT=/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/8
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
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/linux-selftests.cgz'
	export kselftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/kselftests.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210507.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-0d95472a-1_20210507.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=9
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/vmlinuz-5.12.0-11126-gaced02f26141'
	export dequeue_time='2021-05-09 16:21:06 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-aced02f26141d4ad6fb3370f16282029575a099d-20210509-62841-1365rm4-8.cgz'

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

	run_test group='x86' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='x86' $LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--ReaqsoxgOBHFXBhH
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kmsg.xz"
Content-Transfer-Encoding: base64

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

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kernel-selftests

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8.3-kselftests-aced02f26141d4ad6fb3370f16282029575a099d
2021-05-09 08:22:13 ln -sf /usr/bin/clang
2021-05-09 08:22:13 ln -sf /usr/bin/llc
2021-05-09 08:22:13 sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
2021-05-09 08:22:13 sed -i s/default_timeout=45/default_timeout=300/ /kselftests/kselftest/runner.sh
source /lkp/lkp/src/lib/tests/kernel-selftests-ext.sh
2021-05-09 08:22:13 /kselftests/run_kselftest.sh -c x86
TAP version 13
1..38
# selftests: x86: single_step_syscall_32
# [RUN]	Set TF and check nop
# [OK]	Survived with TF set and 15 traps
# [RUN]	Set TF and check int80
# [OK]	Survived with TF set and 14 traps
# [RUN]	Set TF and check a fast syscall
# [OK]	Survived with TF set and 45 traps
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
# [RUN]	Set TF and check SYSENTER
# 	Got SIGSEGV with RIP=f7edb549, TF=256
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
ok 1 selftests: x86: single_step_syscall_32
# selftests: x86: sysret_ss_attrs_32
# [RUN]	Syscalls followed by SS validation
# [OK]	We survived
ok 2 selftests: x86: sysret_ss_attrs_32
# selftests: x86: syscall_nt_32
# [RUN]	Set NT and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set DF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF|DF and issue a syscall
# [OK]	The syscall worked and flags are still set
ok 3 selftests: x86: syscall_nt_32
# selftests: x86: test_mremap_vdso_32
# 	AT_SYSINFO_EHDR is 0xf7f3b000
# [NOTE]	Moving vDSO: [0xf7f3b000, 0xf7f3c000] -> [0xf7f64000, 0xf7f65000]
# [NOTE]	vDSO partial move failed, will try with bigger size
# [NOTE]	Moving vDSO: [0xf7f3b000, 0xf7f3d000] -> [0xf7f33000, 0xf7f35000]
# [OK]
ok 4 selftests: x86: test_mremap_vdso_32
# selftests: x86: check_initial_reg_state_32
# [OK]	All GPRs except SP are 0
# [OK]	FLAGS is 0x202
ok 5 selftests: x86: check_initial_reg_state_32
# selftests: x86: sigreturn_32
# [OK]	set_thread_area refused 16-bit data
# [OK]	set_thread_area refused 16-bit data
# [RUN]	Valid sigreturn: 64-bit CS (33), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 64-bit CS (33), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	64-bit CS (33), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	64-bit CS (33), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	32-bit CS (4f), bogus SS (2b)
# [OK]	Got #NP(0x4c) (i.e. LDT index 9, Bus error)
# [RUN]	32-bit CS (23), bogus SS (57)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
ok 6 selftests: x86: sigreturn_32
# selftests: x86: iopl_32
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# 	child: set IOPL to 3
# [RUN]	child: write to 0x80
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# [RUN]	parent: write to 0x80 (should fail)
# [OK]	outb to 0x80 failed
# [OK]	CLI faulted
# [OK]	STI faulted
# 	iopl(3)
# 	Drop privileges
# [RUN]	iopl(3) unprivileged but with IOPL==3
# [RUN]	iopl(0) unprivileged
# [RUN]	iopl(3) unprivileged
# [OK]	Failed as expected
ok 7 selftests: x86: iopl_32
# selftests: x86: ioperm_32
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	child: check that we inherited permissions
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	child: Extend permissions to 0x81
# [RUN]	child: Drop permissions to 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# 	Verify that unsharing the bitmap worked
# [OK]	outb to 0x80 worked
# 	Drop privileges
# [RUN]	disable 0x80
# [OK]	it worked
# [RUN]	enable 0x80 again
# [OK]	it failed
ok 8 selftests: x86: ioperm_32
# selftests: x86: test_vsyscall_32
# [NOTE]	failed to find getcpu in vDSO
# [RUN]	test gettimeofday()
# 	vDSO time offsets: 0.000006 0.000000
# [OK]	vDSO gettimeofday()'s timeval was okay
# [RUN]	test time()
# [OK]	vDSO time() is okay
# [RUN]	getcpu() on CPU 0
# [RUN]	getcpu() on CPU 1
ok 9 selftests: x86: test_vsyscall_32
# selftests: x86: mov_ss_trap_32
# 	SS = 0x2b, &SS = 0x0x804e11c
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# 	DR0 = 804e11c, DR1 = 80493b4, DR7 = 7000a
# 	SS = 0x2b, &SS = 0x0x804e11c
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# [RUN]	Read from watched memory (should get SIGTRAP)
# 	Got SIGTRAP with RIP=804920a, EFLAGS.RF=0
# [RUN]	MOV SS; INT3
# 	Got SIGTRAP with RIP=804921b, EFLAGS.RF=0
# [RUN]	MOV SS; INT 3
# 	Got SIGTRAP with RIP=804922d, EFLAGS.RF=0
# [RUN]	MOV SS; CS CS INT3
# 	Got SIGTRAP with RIP=8049240, EFLAGS.RF=0
# [RUN]	MOV SS; CSx14 INT3
# 	Got SIGTRAP with RIP=804925f, EFLAGS.RF=0
# [RUN]	MOV SS; INT 4
# 	Got SIGSEGV with RIP=8049289
# [RUN]	MOV SS; INTO
# 	Got SIGTRAP with RIP=80492b9, EFLAGS.RF=0
# [RUN]	MOV SS; ICEBP
# 	Got SIGTRAP with RIP=8049304, EFLAGS.RF=0
# [RUN]	MOV SS; CLI
# 	Got SIGSEGV with RIP=8049611
# [RUN]	MOV SS; #PF
# 	Got SIGSEGV with RIP=80495d3
# [RUN]	MOV SS; INT 1
# 	Got SIGSEGV with RIP=8049394
# [RUN]	MOV SS; breakpointed NOP
# 	Got SIGTRAP with RIP=80493b5, EFLAGS.RF=0
# [RUN]	MOV SS; SYSENTER
# 	Got SIGSEGV with RIP=f7f33549
# [RUN]	MOV SS; INT $0x80
# [OK]	I aten't dead
ok 10 selftests: x86: mov_ss_trap_32
# selftests: x86: syscall_arg_fault_32
# [RUN]	SYSENTER with invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with invalid state
# [SKIP]	Illegal instruction
# [RUN]	SYSENTER with TF and invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with TF and invalid state
# [SKIP]	Illegal instruction
ok 11 selftests: x86: syscall_arg_fault_32
# selftests: x86: fsgsbase_restore_32
# 	Setting up a segment
# 	segment base address = 0xf7f41000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Tracee will take a nap until signaled
# 	Tracee: in tracee_zap_segment()
# 	Tracee is going back to sleep
# 	Tracee was resumed.  Will re-check segment.
# [OK]	The segment points to the right place.
# 	Setting up a segment
# 	segment base address = 0xf7f41000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Child FS=0x7
# 	Tracer: redirecting tracee to tracee_zap_segment()
# 	Tracer: restoring tracee state
# [OK]	All is well.
ok 12 selftests: x86: fsgsbase_restore_32
# selftests: x86: entry_from_vm86_32
# [RUN]	#BR from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSENTER from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSCALL from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	STI with VIP set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP set and IF clear from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP clear and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	INT3 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	int80 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	UMIP tests from vm86 mode
# [SKIP]	vm86 not supported
# [INFO]	Result from SMSW:[0x0000]
# [INFO]	Result from SIDT: limit[0x0000]base[0x00000000]
# [INFO]	Result from SGDT: limit[0x0000]base[0x00000000]
# [PASS]	All the results from SMSW are identical.
# [PASS]	All the results from SGDT are identical.
# [PASS]	All the results from SIDT are identical.
# [RUN]	STR instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SLDT instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	Execute null pointer from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	#BR from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSENTER from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSCALL from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	STI with VIP set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP set and IF clear from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP clear and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	INT3 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	int80 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	UMIP tests from vm86 mode
# [SKIP]	vm86 not supported
# [INFO]	Result from SMSW:[0x0000]
# [INFO]	Result from SIDT: limit[0x0000]base[0x00000000]
# [INFO]	Result from SGDT: limit[0x0000]base[0x00000000]
# [PASS]	All the results from SMSW are identical.
# [PASS]	All the results from SGDT are identical.
# [PASS]	All the results from SIDT are identical.
# [RUN]	STR instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SLDT instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	Execute null pointer from vm86 mode
# [SKIP]	vm86 not supported
ok 13 selftests: x86: entry_from_vm86_32
# selftests: x86: test_syscall_vdso_32
# [RUN]	Executing 6-argument 32-bit syscall via VDSO
# [WARN]	Flags before=0000000000200ed7 id 0 00 o d i s z 0 a 0 p 1 c
# [WARN]	Flags  after=0000000000200682 id 0 00 d i s 0 0 1 
# [WARN]	Flags change=0000000000000855 0 00 o z 0 a 0 p 0 c
# [OK]	Arguments are preserved across syscall
# [NOTE]	R11 has changed:0000000000200682 - assuming clobbered by SYSRET insn
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via INT 80
# [OK]	Arguments are preserved across syscall
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via VDSO
# [WARN]	Flags before=0000000000200ed7 id 0 00 o d i s z 0 a 0 p 1 c
# [WARN]	Flags  after=0000000000200686 id 0 00 d i s 0 0 p 1 
# [WARN]	Flags change=0000000000000851 0 00 o z 0 a 0 0 c
# [OK]	Arguments are preserved across syscall
# [NOTE]	R11 has changed:0000000000200686 - assuming clobbered by SYSRET insn
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via INT 80
# [OK]	Arguments are preserved across syscall
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Running tests under ptrace
ok 14 selftests: x86: test_syscall_vdso_32
# selftests: x86: unwind_vdso_32
# 	AT_SYSINFO is 0xf7f64540
# [OK]	AT_SYSINFO maps to linux-gate.so.1, loaded at 0x0xf7f64000
# [RUN]	Set TF and check a fast syscall
# 	In vsyscall at 0xf7f64540, returning to 0xf7e28687
# 	SIGTRAP at 0xf7f64540
# 	  0xf7f64540
# 	  0xf7e28687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f64541
# 	  0xf7f64541
# 	  0xf7e28687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f64542
# 	  0xf7f64542
# 	  0xf7e28687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f64543
# 	  0xf7f64543
# 	  0xf7e28687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f64545
# 	  0xf7f64545
# 	  0xf7e28687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f6454a
# 	  0xf7f6454a
# 	  0xf7e28687
# [OK]	  NR = 1465, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f6454b
# 	  0xf7f6454b
# 	  0xf7e28687
# [OK]	  NR = 1465, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7f6454c
# 	  0xf7f6454c
# 	  0xf7e28687
# [OK]	  NR = 1465, args = 1, 2, 3, 4, 5, 6
# 	Vsyscall is done
# [OK]	All is well
ok 15 selftests: x86: unwind_vdso_32
# selftests: x86: test_FCMOV_32
# [RUN]	Testing fcmovCC instructions
# [OK]	fcmovCC
ok 16 selftests: x86: test_FCMOV_32
# selftests: x86: test_FCOMI_32
# [RUN]	Testing f[u]comi[p] instructions
# [OK]	f[u]comi[p]
ok 17 selftests: x86: test_FCOMI_32
# selftests: x86: test_FISTTP_32
# [RUN]	Testing fisttp instructions
# [OK]	fisttp
ok 18 selftests: x86: test_FISTTP_32
# selftests: x86: vdso_restorer_32
# [RUN]	Raise a signal, SA_SIGINFO, sa.restorer == NULL
# [OK]	SA_SIGINFO handler returned successfully
# [RUN]	Raise a signal, !SA_SIGINFO, sa.restorer == NULL
# [OK]	!SA_SIGINFO handler returned successfully
ok 19 selftests: x86: vdso_restorer_32
# selftests: x86: ldt_gdt_32
# [NOTE]	set_thread_area is available; will use GDT index 13
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 0 is invalid
# [NOTE]	set_thread_area is available; will use GDT index 13
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	Child succeeded
# [RUN]	Test size
# [DONE]	Size test
# [OK]	modify_ldt failure 22
# [OK]	LDT entry 0 has AR 0x0000F300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x0000F100 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000001
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000000
# [OK]	LDT entry 0 is invalid
# [OK]	LDT entry 0 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	GDT entry 13 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	LDT entry 0 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 is invalid
# [RUN]	Cross-CPU LDT invalidation
# [OK]	All 5 iterations succeeded
# [RUN]	Test exec
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000002A
# [OK]	Child succeeded
# [OK]	Invalidate DS with set_thread_area: new DS = 0x0
# [OK]	Invalidate ES with set_thread_area: new ES = 0x0
# [OK]	Invalidate FS with set_thread_area: new FS = 0x0
# [OK]	Invalidate GS with set_thread_area: new GS = 0x0
ok 20 selftests: x86: ldt_gdt_32
# selftests: x86: ptrace_syscall_32
# [RUN]	Check int80 return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	Check AT_SYSINFO return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	ptrace-induced syscall restart
# [RUN]	SYSEMU
# [OK]	Initial nr and args are correct
# [RUN]	Restart the syscall (ip = 0xf7f9a549)
# [OK]	Restarted nr and args are correct
# [RUN]	Change nr and args and restart the syscall (ip = 0xf7f9a549)
# [OK]	Replacement nr and args are correct
# [OK]	Child exited cleanly
# [RUN]	kernel syscall restart under ptrace
# [RUN]	SYSCALL
# [OK]	Initial nr and args are correct
# [RUN]	SYSCALL
# [OK]	Args after SIGUSR1 are correct (ax = -514)
# [OK]	Child got SIGUSR1
# [RUN]	Step again
# [OK]	pause(2) restarted correctly
ok 21 selftests: x86: ptrace_syscall_32
# selftests: x86: single_step_syscall_64
# [RUN]	Set TF and check nop
# [OK]	Survived with TF set and 10 traps
# [RUN]	Set TF and check syscall-less opportunistic sysret
# [OK]	Survived with TF set and 12 traps
# [RUN]	Set TF and check int80
# [OK]	Survived with TF set and 9 traps
# [RUN]	Set TF and check a fast syscall
# [OK]	Survived with TF set and 22 traps
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
# [RUN]	Set TF and check SYSENTER
# 	Got SIGSEGV with RIP=65165549, TF=256
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
ok 22 selftests: x86: single_step_syscall_64
# selftests: x86: sysret_ss_attrs_64
# [RUN]	Syscalls followed by SS validation
# [OK]	We survived
ok 23 selftests: x86: sysret_ss_attrs_64
# selftests: x86: syscall_nt_64
# [RUN]	Set NT and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set DF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF|DF and issue a syscall
# [OK]	The syscall worked and flags are still set
ok 24 selftests: x86: syscall_nt_64
# selftests: x86: test_mremap_vdso_64
# 	AT_SYSINFO_EHDR is 0x7fff4c7ec000
# [NOTE]	Moving vDSO: [0x7fff4c7ec000, 0x7fff4c7ed000] -> [0x7f334b413000, 0x7f334b414000]
# [NOTE]	vDSO partial move failed, will try with bigger size
# [NOTE]	Moving vDSO: [0x7fff4c7ec000, 0x7fff4c7ee000] -> [0x7f334b412000, 0x7f334b414000]
# [OK]
ok 25 selftests: x86: test_mremap_vdso_64
# selftests: x86: check_initial_reg_state_64
# [OK]	All GPRs except SP are 0
# [OK]	FLAGS is 0x202
ok 26 selftests: x86: check_initial_reg_state_64
# selftests: x86: sigreturn_64
# [OK]	set_thread_area refused 16-bit data
# [OK]	set_thread_area refused 16-bit data
# [RUN]	Valid sigreturn: 64-bit CS (33), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 32-bit SS (2b, GDT)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 64-bit CS (33), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 16-bit SS (3f)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# 	Corrupting SS on return to 64-bit mode
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# 	Corrupting SS on return to 64-bit mode
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	64-bit CS (33), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	64-bit CS (33), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	32-bit CS (4f), bogus SS (2b)
# [OK]	Got #NP(0x4c) (i.e. LDT index 9, Bus error)
# [RUN]	32-bit CS (23), bogus SS (57)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	Clear UC_STRICT_RESTORE_SS and corrupt SS
# [OK]	It worked
ok 27 selftests: x86: sigreturn_64
# selftests: x86: iopl_64
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# 	child: set IOPL to 3
# [RUN]	child: write to 0x80
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# [RUN]	parent: write to 0x80 (should fail)
# [OK]	outb to 0x80 failed
# [OK]	CLI faulted
# [OK]	STI faulted
# 	iopl(3)
# 	Drop privileges
# [RUN]	iopl(3) unprivileged but with IOPL==3
# [RUN]	iopl(0) unprivileged
# [RUN]	iopl(3) unprivileged
# [OK]	Failed as expected
ok 28 selftests: x86: iopl_64
# selftests: x86: ioperm_64
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	child: check that we inherited permissions
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	child: Extend permissions to 0x81
# [RUN]	child: Drop permissions to 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# 	Verify that unsharing the bitmap worked
# [OK]	outb to 0x80 worked
# 	Drop privileges
# [RUN]	disable 0x80
# [OK]	it worked
# [RUN]	enable 0x80 again
# [OK]	it failed
ok 29 selftests: x86: ioperm_64
# selftests: x86: test_vsyscall_64
# 	vsyscall map: ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
# 	vsyscall permissions are r-x
# [RUN]	test gettimeofday()
# 	vDSO time offsets: 0.000005 0.000002
# [OK]	vDSO gettimeofday()'s timeval was okay
# 	vsyscall time offsets: 0.000006 0.000001
# [OK]	vsyscall gettimeofday()'s timeval was okay
# [RUN]	test time()
# [OK]	vDSO time() is okay
# [OK]	vsyscall time() is okay
# [RUN]	getcpu() on CPU 0
# [OK]	vDSO reported correct CPU
# [OK]	vDSO reported correct node
# [OK]	vsyscall reported correct CPU
# [OK]	vsyscall reported correct node
# [RUN]	getcpu() on CPU 1
# [OK]	vDSO reported correct CPU
# [OK]	vDSO reported correct node
# [OK]	vsyscall reported correct CPU
# [OK]	vsyscall reported correct node
# [RUN]	Checking read access to the vsyscall page
# [OK]	We have read access
# [RUN]	process_vm_readv() from vsyscall page
# [OK]	It worked and read correct data
# [RUN]	checking that vsyscalls are emulated
# [OK]	vsyscalls are emulated (1 instructions in vsyscall page)
ok 30 selftests: x86: test_vsyscall_64
# selftests: x86: mov_ss_trap_64
# 	SS = 0x2b, &SS = 0x0x406188
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# 	DR0 = 406188, DR1 = 40133a, DR7 = 7000a
# 	SS = 0x2b, &SS = 0x0x406188
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# [RUN]	Read from watched memory (should get SIGTRAP)
# 	Got SIGTRAP with RIP=4011ca, EFLAGS.RF=0
# [RUN]	MOV SS; INT3
# 	Got SIGTRAP with RIP=4011dd, EFLAGS.RF=0
# [RUN]	MOV SS; INT 3
# 	Got SIGTRAP with RIP=4011f1, EFLAGS.RF=0
# [RUN]	MOV SS; CS CS INT3
# 	Got SIGTRAP with RIP=401206, EFLAGS.RF=0
# [RUN]	MOV SS; CSx14 INT3
# 	Got SIGTRAP with RIP=401227, EFLAGS.RF=0
# [RUN]	MOV SS; INT 4
# 	Got SIGSEGV with RIP=401251
# [RUN]	MOV SS; ICEBP
# 	Got SIGTRAP with RIP=40128f, EFLAGS.RF=0
# [RUN]	MOV SS; CLI
# 	Got SIGSEGV with RIP=40158c
# [RUN]	MOV SS; #PF
# 	Got SIGSEGV with RIP=401557
# [RUN]	MOV SS; INT 1
# 	Got SIGSEGV with RIP=401528
# [RUN]	MOV SS; SYSCALL
# [RUN]	MOV SS; breakpointed NOP
# 	Got SIGTRAP with RIP=40133b, EFLAGS.RF=0
# [RUN]	MOV SS; SYSENTER
# 	Got SIGSEGV with RIP=8238d549
# [RUN]	MOV SS; INT $0x80
# [OK]	I aten't dead
ok 31 selftests: x86: mov_ss_trap_64
# selftests: x86: syscall_arg_fault_64
# [RUN]	SYSENTER with invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with invalid state
# [OK]	SYSCALL returned normally
# [RUN]	SYSENTER with TF and invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with TF and invalid state
# [OK]	SYSCALL returned normally
# [RUN]	SYSENTER with TF, invalid state, and GSBASE < 0
# [OK]	Seems okay
ok 32 selftests: x86: syscall_arg_fault_64
# selftests: x86: fsgsbase_restore_64
# 	Setting up a segment
# 	segment base address = 0x40820000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Tracee will take a nap until signaled
# 	Tracee: in tracee_zap_segment()
# 	Tracee is going back to sleep
# 	Tracee was resumed.  Will re-check segment.
# [OK]	The segment points to the right place.
# 	Setting up a segment
# 	segment base address = 0x40820000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Child GS=0x7, GSBASE=0x40820000
# 	Tracer: redirecting tracee to tracee_zap_segment()
# 	Tracer: restoring tracee state
# [OK]	All is well.
ok 33 selftests: x86: fsgsbase_restore_64
# selftests: x86: fsgsbase_64
# [OK]	GSBASE started at 1
# [RUN]	Set GS = 0x7, read GSBASE
# [OK]	GSBASE reads as 0x1 with invalid GS
# 	FSGSBASE instructions are enabled
# [RUN]	ARCH_SET_GS to 0x0
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x1
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x200000000
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x0
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x200000000
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x1
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x0 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x1 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x200000000 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x0 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x1 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x200000000 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0), clear gs, then manipulate GSBASE in a different thread
# 	using LDT slot 0
# [OK]	GSBASE remained 0
# [RUN]	GS = 0x0, GSBASE = 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0x200000000
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0xffffffffffffffff
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x200000000
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0xffffffffffffffff
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [OK]	GS remained 0x7 and GSBASE changed to 0xFF
ok 34 selftests: x86: fsgsbase_64
# selftests: x86: sysret_rip_64
# [RUN]	sigreturn to 0x800000000000
# [OK]	Got SIGSEGV at RIP=0x800000000000
# [RUN]	sigreturn to 0x1000000000000
# [OK]	Got SIGSEGV at RIP=0x1000000000000
# [RUN]	sigreturn to 0x2000000000000
# [OK]	Got SIGSEGV at RIP=0x2000000000000
# [RUN]	sigreturn to 0x4000000000000
# [OK]	Got SIGSEGV at RIP=0x4000000000000
# [RUN]	sigreturn to 0x8000000000000
# [OK]	Got SIGSEGV at RIP=0x8000000000000
# [RUN]	sigreturn to 0x10000000000000
# [OK]	Got SIGSEGV at RIP=0x10000000000000
# [RUN]	sigreturn to 0x20000000000000
# [OK]	Got SIGSEGV at RIP=0x20000000000000
# [RUN]	sigreturn to 0x40000000000000
# [OK]	Got SIGSEGV at RIP=0x40000000000000
# [RUN]	sigreturn to 0x80000000000000
# [OK]	Got SIGSEGV at RIP=0x80000000000000
# [RUN]	sigreturn to 0x100000000000000
# [OK]	Got SIGSEGV at RIP=0x100000000000000
# [RUN]	sigreturn to 0x200000000000000
# [OK]	Got SIGSEGV at RIP=0x200000000000000
# [RUN]	sigreturn to 0x400000000000000
# [OK]	Got SIGSEGV at RIP=0x400000000000000
# [RUN]	sigreturn to 0x800000000000000
# [OK]	Got SIGSEGV at RIP=0x800000000000000
# [RUN]	sigreturn to 0x1000000000000000
# [OK]	Got SIGSEGV at RIP=0x1000000000000000
# [RUN]	sigreturn to 0x2000000000000000
# [OK]	Got SIGSEGV at RIP=0x2000000000000000
# [RUN]	sigreturn to 0x4000000000000000
# [OK]	Got SIGSEGV at RIP=0x4000000000000000
# [RUN]	sigreturn to 0x8000000000000000
# [OK]	Got SIGSEGV at RIP=0x8000000000000000
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffe000
# [OK]	We survived
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffff000
# [OK]	We survived
# [RUN]	Trying a SYSCALL that falls through to 0x800000000000
# [OK]	mremap to 0x7ffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xfffffffff000
# [OK]	mremap to 0xffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1000000000000
# [OK]	mremap to 0xfffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1fffffffff000
# [OK]	mremap to 0x1ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x2000000000000
# [OK]	mremap to 0x1fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3fffffffff000
# [OK]	mremap to 0x3ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x4000000000000
# [OK]	mremap to 0x3fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffff000
# [OK]	mremap to 0x7ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x8000000000000
# [OK]	mremap to 0x7fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xffffffffff000
# [OK]	mremap to 0xfffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x10000000000000
# [OK]	mremap to 0xffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1ffffffffff000
# [OK]	mremap to 0x1fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x20000000000000
# [OK]	mremap to 0x1ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3ffffffffff000
# [OK]	mremap to 0x3fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x40000000000000
# [OK]	mremap to 0x3ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffffff000
# [OK]	mremap to 0x7fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x80000000000000
# [OK]	mremap to 0x7ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xfffffffffff000
# [OK]	mremap to 0xffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x100000000000000
# [OK]	mremap to 0xfffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1fffffffffff000
# [OK]	mremap to 0x1ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x200000000000000
# [OK]	mremap to 0x1fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3fffffffffff000
# [OK]	mremap to 0x3ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x400000000000000
# [OK]	mremap to 0x3fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffffff000
# [OK]	mremap to 0x7ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x800000000000000
# [OK]	mremap to 0x7fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xffffffffffff000
# [OK]	mremap to 0xfffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1000000000000000
# [OK]	mremap to 0xffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1ffffffffffff000
# [OK]	mremap to 0x1fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x2000000000000000
# [OK]	mremap to 0x1ffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3ffffffffffff000
# [OK]	mremap to 0x3fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x4000000000000000
# [OK]	mremap to 0x3ffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffffffff000
# [OK]	mremap to 0x7fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x8000000000000000
# [OK]	mremap to 0x7ffffffffffff000 failed
ok 35 selftests: x86: sysret_rip_64
# selftests: x86: syscall_numbering_64
# 	Checking for x32... not supported
# [RUN]	Checking syscalls 512-547
# [RUN]	Checking some 64-bit syscalls in x32 range
# [RUN]	Checking numbers above 2^32-1
# [OK]	They all returned -ENOSYS
ok 36 selftests: x86: syscall_numbering_64
# selftests: x86: ldt_gdt_64
# [NOTE]	set_thread_area is available; will use GDT index 12
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 0 is invalid
# [NOTE]	set_thread_area is available; will use GDT index 12
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	Child succeeded
# [RUN]	Test size
# [DONE]	Size test
# [OK]	modify_ldt failure 22
# [OK]	LDT entry 0 has AR 0x0000F300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x0000F100 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000001
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000000
# [OK]	LDT entry 0 is invalid
# [OK]	LDT entry 0 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	LDT entry 0 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 is invalid
# [RUN]	Cross-CPU LDT invalidation
# [OK]	All 5 iterations succeeded
# [RUN]	Test exec
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000002A
# [OK]	Child succeeded
# [OK]	Invalidate DS with set_thread_area: new DS = 0x0
# [OK]	Invalidate ES with set_thread_area: new ES = 0x0
# [OK]	Invalidate FS with set_thread_area: new FS = 0x0
# [OK]	New FSBASE was zero
# [OK]	Invalidate GS with set_thread_area: new GS = 0x0
# [OK]	New GSBASE was zero
ok 37 selftests: x86: ldt_gdt_64
# selftests: x86: ptrace_syscall_64
# [RUN]	Check int80 return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	ptrace-induced syscall restart
# [RUN]	SYSEMU
# [OK]	Initial nr and args are correct
# [RUN]	Restart the syscall (ip = 0x7f4726f93f59)
# [OK]	Restarted nr and args are correct
# [RUN]	Change nr and args and restart the syscall (ip = 0x7f4726f93f59)
# [OK]	Replacement nr and args are correct
# [OK]	Child exited cleanly
# [RUN]	kernel syscall restart under ptrace
# [RUN]	SYSCALL
# [OK]	Initial nr and args are correct
# [RUN]	SYSCALL
# [OK]	Args after SIGUSR1 are correct (ax = -514)
# [OK]	Child got SIGUSR1
# [RUN]	Step again
# [OK]	pause(2) restarted correctly
ok 38 selftests: x86: ptrace_syscall_64

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests-x86.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kconfig: x86_64-rhel-8.3-kselftests
need_memory: 2G
need_cpu: 2
kernel-selftests:
  group: x86
kernel_cmdline: erst_disable
job_origin: kernel-selftests-x86.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-kbl-nuc1
tbox_group: lkp-kbl-nuc1
submit_id: 6096333b1970f346ffc35fec
job_file: "/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-aced02f26141d4ad6fb3370f16282029575a099d-20210508-18175-h7plsn-0.yaml"
id: 0b269469d71f57262eb8723797b28db798cfbb38
queuer_version: "/lkp-src"

#! hosts/lkp-kbl-nuc1
model: Kaby Lake
nr_node: 1
nr_cpu: 4
memory: 32G
nr_sdd_partitions: 1
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part2"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part1"
brand: Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz

#! include/category/functional
kmsg: 
heartbeat: 
meminfo: 

#! include/queue/cyclic
commit: aced02f26141d4ad6fb3370f16282029575a099d

#! include/testbox/lkp-kbl-nuc1
netconsole_port: 6674
ucode: '0xde'
need_kconfig_hw:
- CONFIG_E1000E=y
- CONFIG_SATA_AHCI
- CONFIG_DRM_I915

#! include/kernel-selftests
need_linux_headers: true
need_linux_selftests: true
need_kselftests: true
need_kconfig:
- CONFIG_POSIX_TIMERS=y ~ ">= v4.10-rc1"
enqueue_time: 2021-05-08 14:44:11.733097782 +08:00
_id: 6096333b1970f346ffc35fec
_rt: "/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d"

#! schedule options
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: 4e59ccb12a6f1816f7058a57c5e47881ea076fc7
base_commit: 9f4ad9e425a1d3b6a34617b8ea226d56a119a717
branch: linux-devel/devel-hourly-20210506-172741
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/0"
scheduler_version: "/lkp/lkp/.src-20210506-110429"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-aced02f26141d4ad6fb3370f16282029575a099d-20210508-18175-h7plsn-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kselftests
- branch=linux-devel/devel-hourly-20210506-172741
- commit=aced02f26141d4ad6fb3370f16282029575a099d
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/vmlinuz-5.12.0-11126-gaced02f26141
- erst_disable
- max_uptime=2100
- RESULT_ROOT=/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/0
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
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/linux-selftests.cgz"
kselftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/kselftests.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210507.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-0d95472a-1_20210507.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20210506-110429/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 4.20.0

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/aced02f26141d4ad6fb3370f16282029575a099d/vmlinuz-5.12.0-11126-gaced02f26141"
dequeue_time: 2021-05-08 14:50:48.234878535 +08:00
job_state: finished
loadavg: 0.74 0.19 0.06 1/139 1838
start_time: '1620456707'
end_time: '1620456708'
version: "/lkp/lkp/.src-20210506-110504:c8d5f8a8:89926580f"

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

ln -sf /usr/bin/clang
ln -sf /usr/bin/llc
sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
sed -i s/default_timeout=45/default_timeout=300/ /kselftests/kselftest/runner.sh
/kselftests/run_kselftest.sh -c x86

--ReaqsoxgOBHFXBhH--
