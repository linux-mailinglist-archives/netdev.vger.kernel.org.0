Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10E6552280
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiFTQxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 12:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiFTQxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 12:53:19 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC5D193CB;
        Mon, 20 Jun 2022 09:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655743997; x=1687279997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kgESs27XhF81QnJUgze9eJuZmW99UDQpLFplT83+koM=;
  b=opYvnVJdRpIkA4ex4ZKNH4CdE96ALOzE6Gp+I4plUa+HvRhDDbq/eKKR
   F0t/uW4lztaSygb5gfTtyk1zPSwLduBgYc9LYgwUKrr6QcT+a1ZMNdCkS
   TuhUGBpwtbhpsaxGc0vHgdDV8liJ9gLvw1d+tyIhelD7Z/pUOLmYzWwoD
   o=;
X-IronPort-AV: E=Sophos;i="5.92,207,1650931200"; 
   d="scan'208";a="99721030"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 20 Jun 2022 16:47:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 3D52F81733;
        Mon, 20 Jun 2022 16:47:25 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 16:47:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 16:47:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <oliver.sang@intel.com>
CC:     <aams@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <lkp@intel.com>,
        <lkp@lists.01.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [af_unix]  b4813d5914: WARNING:possible_recursive_locking_detected
Date:   Mon, 20 Jun 2022 09:47:02 -0700
Message-ID: <20220620164702.43666-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620061053.GC3669@xsang-OptiPlex-9020>
References: <20220620061053.GC3669@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.55]
X-ClientProxiedBy: EX13D22UWB003.ant.amazon.com (10.43.161.76) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   kernel test robot <oliver.sang@intel.com>
Date:   Mon, 20 Jun 2022 14:10:53 +0800
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: b4813d591454d771b5aaf33a6252b214648c430f ("[PATCH v1 net-next 4/6] af_unix: Acquire/Release per-netns hash table's locks.")
> url: https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/af_unix-Introduce-per-netns-socket-hash-table/20220617-075046
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 5dcb50c009c9f8ec1cfca6a81a05c0060a5bbf68
> patch link: https://lore.kernel.org/netdev/20220616234714.4291-5-kuniyu@amazon.com
> 
> in testcase: boot
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> [  113.085258][    T1] WARNING: possible recursive locking detected
> [  113.085261][    T1] 5.19.0-rc1-00408-gb4813d591454 #1 Not tainted
> [  113.085264][    T1] --------------------------------------------
> [  113.085265][    T1] systemd/1 is trying to acquire lock:
> [ 113.085270][ T1] ffff888167ee6c18 (&net->unx.hash[i].lock){+.+.}-{2:2}, at: unix_bind_bsd (net/unix/af_unix.c:1200) 
> [  113.085313][    T1]
> [  113.085313][    T1] but task is already holding lock:
> [ 113.085314][ T1] ffff888167ee0918 (&net->unx.hash[i].lock){+.+.}-{2:2}, at: unix_bind_bsd (net/unix/af_unix.c:175 net/unix/af_unix.c:1199) 
> [  113.085321][    T1]
> [  113.085321][    T1] other info that might help us debug this:
> [  113.085323][    T1]  Possible unsafe locking scenario:
> [  113.085323][    T1]
> [  113.085324][    T1]        CPU0
> [  113.085325][    T1]        ----
> [  113.085325][    T1]   lock(&net->unx.hash[i].lock);
> [  113.085328][    T1]   lock(&net->unx.hash[i].lock);
> [  113.085330][    T1]
> [  113.085330][    T1]  *** DEADLOCK ***
> [  113.085330][    T1]
> [  113.085331][    T1]  May be due to missing lock nesting notation

Sorry, I did a wrong copy-and-paste.
I'll use spin_lock_nested() in unix_table_double_lock().


> [  113.085331][    T1]
> [  113.085333][    T1] 6 locks held by systemd/1:
> [ 113.085335][ T1] #0: ffff88815da40448 (sb_writers#6){.+.+}-{0:0}, at: filename_create (fs/namei.c:3744) 
> [ 113.085351][ T1] #1: ffff88815bffec40 (&type->i_mutex_dir_key#4/1){+.+.}-{3:3}, at: filename_create (fs/namei.c:3747) 
> [  OK  ] Started Forward Password Requests to Wall Directory Watch.
> [  OK  ] Started Dispatch Password Requests to Console Directory Watch.
> [  OK  ] Reached target Paths.
> [  OK  ] Listening on udev Control Socket.
> [ 113.085359][ T1] #2: ffff88815d974e18 (&u->bindlock){+.+.}-{3:3}, at: unix_bind_bsd (net/unix/af_unix.c:1192) 
> [ 113.085370][ T1] #3: ffffffffb0eec038 (&unix_table_locks[i]){+.+.}-{2:2}, at: unix_bind_bsd (net/unix/af_unix.c:172 net/unix/af_unix.c:1199) 
> [ 113.085377][ T1] #4: ffffffffb0ef1838 (&unix_table_locks[i]/1){+.+.}-{2:2}, at: unix_bind_bsd (net/unix/af_unix.c:174 net/unix/af_unix.c:1199) 
> [ 113.085384][ T1] #5: ffff888167ee0918 (&net->unx.hash[i].lock){+.+.}-{2:2}, at: unix_bind_bsd (net/unix/af_unix.c:175 net/unix/af_unix.c:1199) 
> [  113.085391][    T1]
> [  113.085391][    T1] stack backtrace:
> [  113.085395][    T1] CPU: 1 PID: 1 Comm: systemd Not tainted 5.19.0-rc1-00408-gb4813d591454 #1
> [  113.085401][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
> [  113.085408][    T1] Call Trace:
> [  113.085419][    T1]  <TASK>
> [ 113.085421][ T1] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4)) 
> [ 113.085453][ T1] validate_chain.cold (kernel/locking/lockdep.c:2988 kernel/locking/lockdep.c:3031 kernel/locking/lockdep.c:3816) 
> [ 113.085473][ T1] ? check_prev_add (kernel/locking/lockdep.c:3785) 
> [ 113.085483][ T1] ? rcu_read_unlock (include/linux/rcupdate.h:724 (discriminator 5)) 
> [ 113.085489][ T1] __lock_acquire (kernel/locking/lockdep.c:5053) 
> [  OK  ] Listening on Journal Socket (/dev/log).
> [  OK  ] Listening on Journal Socket.
> [  OK  ] Reached target Encrypted Volumes.
> [  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
> [ 113.085497][ T1] ? rcu_read_unlock (include/linux/rcupdate.h:724 (discriminator 5)) 
> [ 113.085501][ T1] lock_acquire (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5667 kernel/locking/lockdep.c:5630) 
> [ 113.085504][ T1] ? unix_bind_bsd (net/unix/af_unix.c:1200) 
> [ 113.085509][ T1] ? rcu_read_unlock (include/linux/rcupdate.h:724 (discriminator 5)) 
> [ 113.085513][ T1] ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 kernel/locking/spinlock_debug.c:115) 
> [ 113.085519][ T1] ? rwlock_bug+0xc0/0xc0 
> [  OK  ] Created slice User and Session Slice.
> [ 113.085524][ T1] _raw_spin_lock (include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154) 
> [ 113.085539][ T1] ? unix_bind_bsd (net/unix/af_unix.c:1200) 
> [ 113.085543][ T1] unix_bind_bsd (net/unix/af_unix.c:1200) 
> [ 113.085548][ T1] ? __might_fault (mm/memory.c:5566 mm/memory.c:5559) 
> [ 113.085557][ T1] ? unix_stream_sendmsg (net/unix/af_unix.c:1153) 
> [  OK  ] Created slice System Slice.
> [ 113.085560][ T1] ? lock_release (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5687) 
> [ 113.085563][ T1] ? _copy_from_user (arch/x86/include/asm/uaccess_64.h:46 arch/x86/include/asm/uaccess_64.h:52 lib/usercopy.c:16) 
> [ 113.085580][ T1] __sys_bind (net/socket.c:1776) 
> [ 113.085589][ T1] ? __ia32_sys_socketpair (net/socket.c:1763) 
> [ 113.085592][ T1] ? __lock_release (kernel/locking/lockdep.c:5341) 
> [ 113.085597][ T1] ? lock_is_held_type (kernel/locking/lockdep.c:5406 kernel/locking/lockdep.c:5708) 
> [ 113.085606][ T1] ? __might_fault (mm/memory.c:5566 mm/memory.c:5559) 
> [ 113.085610][ T1] ? lock_release (kernel/locking/lockdep.c:466 kernel/locking/lockdep.c:5687) 
> [ 113.085614][ T1] __do_compat_sys_socketcall (net/compat.c:453) 
> [ 113.085627][ T1] ? __x64_sys_rmdir (fs/namei.c:4221) 
> [ 113.085631][ T1] ? __ia32_compat_sys_recvmmsg_time32 (net/compat.c:425) 
> [ 113.085637][ T1] ? syscall_exit_to_user_mode (kernel/entry/common.c:129 kernel/entry/common.c:296) 
> [ 113.085642][ T1] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4526) 
> [ 113.085646][ T1] __do_fast_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:178) 
> [ 113.085652][ T1] ? __do_fast_syscall_32 (arch/x86/entry/common.c:183) 
> Mounting Debug File System...
> [ 113.085656][ T1] do_fast_syscall_32 (arch/x86/entry/common.c:203) 
> [ 113.085660][ T1] entry_SYSENTER_compat_after_hwframe (arch/x86/entry/entry_64_compat.S:117) 
> [  113.085669][    T1] RIP: 0023:0xf7f70549
> [ 113.085673][ T1] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> All code
> ========
>    0:	03 74 c0 01          	add    0x1(%rax,%rax,8),%esi
>    4:	10 05 03 74 b8 01    	adc    %al,0x1b87403(%rip)        # 0x1b8740d
>    a:	10 06                	adc    %al,(%rsi)
>    c:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
>   10:	10 07                	adc    %al,(%rdi)
>   12:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
>   16:	10 08                	adc    %cl,(%rax)
>   18:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
>   1c:	00 00                	add    %al,(%rax)
>   1e:	00 00                	add    %al,(%rax)
>   20:	00 51 52             	add    %dl,0x52(%rcx)
>   23:	55                   	push   %rbp
>   24:	89 e5                	mov    %esp,%ebp
>   26:	0f 34                	sysenter 
>   28:	cd 80                	int    $0x80
>   2a:*	5d                   	pop    %rbp		<-- trapping instruction
>   2b:	5a                   	pop    %rdx
>   2c:	59                   	pop    %rcx
>   2d:	c3                   	retq   
>   2e:	90                   	nop
>   2f:	90                   	nop
>   30:	90                   	nop
>   31:	90                   	nop
>   32:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
>   39:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	5d                   	pop    %rbp
>    1:	5a                   	pop    %rdx
>    2:	59                   	pop    %rcx
>    3:	c3                   	retq   
>    4:	90                   	nop
>    5:	90                   	nop
>    6:	90                   	nop
>    7:	90                   	nop
>    8:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
>    f:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
> 
> 
> To reproduce:
> 
>         # build kernel
> 	cd linux
> 	cp config-5.19.0-rc1-00408-gb4813d591454 .config
> 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
> 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
> 	cd <mod-install-dir>
> 	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> 
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
> 
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
> 
