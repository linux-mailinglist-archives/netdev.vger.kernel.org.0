Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DE710FBBA
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCK27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:28:59 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56908 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCK26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:28:58 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB3ASdQU125781;
        Tue, 3 Dec 2019 04:28:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575368919;
        bh=jo8iHnrEm+gjBKUyjYXLNWcDF2FN0eHXQrGt/UkiHa4=;
        h=To:From:Subject:Date;
        b=EMOJSUz93bWqRHEL3lGPAA3VzTzTaTXmpsJ4Tf69gv1p0286b7O/CdEguK0J/nFCi
         ahMIH0SNmhVU49e5WAShIW9r6e/xuaRoGf4T6rxqz/NxJW/fVMasF630ki4Zrf+XF0
         piNEBS2YQ3F859uVwSFdGul6bD7ZL45VUJTQFYEs=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB3ASdDX033407
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Dec 2019 04:28:39 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Dec
 2019 04:28:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Dec 2019 04:28:39 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB3ASZsP092888;
        Tue, 3 Dec 2019 04:28:36 -0600
To:     netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Subject: linux-master: WARNING: suspicious RCU usage in
 mem_allocator_disconnect
Message-ID: <09e42c75-228a-f390-abd5-43e8f6ae70f2@ti.com>
Date:   Tue, 3 Dec 2019 12:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

While placing intf down I'm getting below splat with debug options enabled.
Not sure how to fix it, so will be appreciated for any help.



=========================================================
[  333.933896]
[  333.935511] =============================
[  333.939552] WARNING: suspicious RCU usage
[  333.943724] 5.4.0-08849-ga6eb3c7b339b-dirty #40 Not tainted
[  333.949335] -----------------------------
[  333.953445] ./include/linux/rcupdate.h:273 Illegal context switch in RCU read-side critical section!
[  333.962698]
[  333.962698] other info that might help us debug this:
[  333.962698]
[  333.970752]
[  333.970752] rcu_scheduler_active = 2, debug_locks = 1
[  333.977391] 2 locks held by ifconfig/1007:
[  333.981520]  #0: c10b18ec (rtnl_mutex){+.+.}, at: devinet_ioctl+0xc4/0x850
[  333.988534]  #1: c103e838 (rcu_read_lock){....}, at: rhashtable_walk_start_check+0x0/0x3dc
[  333.996939]
[  333.996939] stack backtrace:
[  334.001334] CPU: 0 PID: 1007 Comm: ifconfig Not tainted 5.4.0-08849-ga6eb3c7b339b-dirty #40
[  334.009733] Hardware name: Generic DRA72X (Flattened Device Tree)
[  334.015878] [<c0113330>] (unwind_backtrace) from [<c010d23c>] (show_stack+0x10/0x14)
[  334.023675] [<c010d23c>] (show_stack) from [<c09f9e08>] (dump_stack+0xe4/0x11c)
[  334.031038] [<c09f9e08>] (dump_stack) from [<c016e4a4>] (___might_sleep+0x1e8/0x2bc)
[  334.038834] [<c016e4a4>] (___might_sleep) from [<c0a17bd0>] (__mutex_lock+0x38/0xa18)
[  334.046716] [<c0a17bd0>] (__mutex_lock) from [<c0a185cc>] (mutex_lock_nested+0x1c/0x24)
[  334.054774] [<c0a185cc>] (mutex_lock_nested) from [<c0858208>] (mem_allocator_disconnect+0xf8/0x288)
[  334.063966] [<c0858208>] (mem_allocator_disconnect) from [<c085df50>] (page_pool_release+0x230/0x3b4)
[  334.073242] [<c085df50>] (page_pool_release) from [<c085e12c>] (page_pool_destroy+0x58/0x11c)
[  334.081822] [<c085e12c>] (page_pool_destroy) from [<c0771554>] (cpsw_destroy_xdp_rxqs+0x88/0xa0)
[  334.090663] [<c0771554>] (cpsw_destroy_xdp_rxqs) from [<c0774638>] (cpsw_ndo_stop+0x100/0x10c)
[  334.099331] [<c0774638>] (cpsw_ndo_stop) from [<c0814fdc>] (__dev_close_many+0xac/0x130)
[  334.107475] [<c0814fdc>] (__dev_close_many) from [<c0824068>] (__dev_change_flags+0xc8/0x1f0)
[  334.116053] [<c0824068>] (__dev_change_flags) from [<c08241a8>] (dev_change_flags+0x18/0x48)
[  334.124545] [<c08241a8>] (dev_change_flags) from [<c08efc3c>] (devinet_ioctl+0x6c0/0x850)
[  334.132775] [<c08efc3c>] (devinet_ioctl) from [<c08f2d98>] (inet_ioctl+0x1f8/0x3b4)
[  334.140483] [<c08f2d98>] (inet_ioctl) from [<c07f4594>] (sock_ioctl+0x398/0x5f4)
[  334.147929] [<c07f4594>] (sock_ioctl) from [<c03279b4>] (do_vfs_ioctl+0x9c/0xa08)
[  334.155461] [<c03279b4>] (do_vfs_ioctl) from [<c0328384>] (ksys_ioctl+0x64/0x74)
[  334.162905] [<c0328384>] (ksys_ioctl) from [<c01011ac>] (__sys_trace_return+0x0/0x14)
[  334.170781] Exception stack(0xed517fa8 to 0xed517ff0)
[  334.175870] 7fa0:                   0007b4ec bee79d84 00000003 00008914 bee79a80 0007b4ec
[  334.184099] 7fc0: 0007b4ec bee79d84 bee79d84 00000036 bee79c4c bee79c4c bee79a80 00000003
[  334.192325] 7fe0: 0009d1ec bee79a14 0003214b b6e94f7c
[  334.197604] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
[  334.206157] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1007, name: ifconfig
[  334.214274] 2 locks held by ifconfig/1007:
[  334.218401]  #0: c10b18ec (rtnl_mutex){+.+.}, at: devinet_ioctl+0xc4/0x850
[  334.225407]  #1: c103e838 (rcu_read_lock){....}, at: rhashtable_walk_start_check+0x0/0x3dc
[  334.233813] CPU: 0 PID: 1007 Comm: ifconfig Not tainted 5.4.0-08849-ga6eb3c7b339b-dirty #40
[  334.242212] Hardware name: Generic DRA72X (Flattened Device Tree)
[  334.248351] [<c0113330>] (unwind_backtrace) from [<c010d23c>] (show_stack+0x10/0x14)
[  334.256147] [<c010d23c>] (show_stack) from [<c09f9e08>] (dump_stack+0xe4/0x11c)
[  334.263506] [<c09f9e08>] (dump_stack) from [<c016e464>] (___might_sleep+0x1a8/0x2bc)
[  334.271300] [<c016e464>] (___might_sleep) from [<c0a17bd0>] (__mutex_lock+0x38/0xa18)
[  334.279181] [<c0a17bd0>] (__mutex_lock) from [<c0a185cc>] (mutex_lock_nested+0x1c/0x24)
[  334.287238] [<c0a185cc>] (mutex_lock_nested) from [<c0858208>] (mem_allocator_disconnect+0xf8/0x288)
[  334.296427] [<c0858208>] (mem_allocator_disconnect) from [<c085df50>] (page_pool_release+0x230/0x3b4)
[  334.305703] [<c085df50>] (page_pool_release) from [<c085e12c>] (page_pool_destroy+0x58/0x11c)
[  334.314281] [<c085e12c>] (page_pool_destroy) from [<c0771554>] (cpsw_destroy_xdp_rxqs+0x88/0xa0)
[  334.323122] [<c0771554>] (cpsw_destroy_xdp_rxqs) from [<c0774638>] (cpsw_ndo_stop+0x100/0x10c)
[  334.331788] [<c0774638>] (cpsw_ndo_stop) from [<c0814fdc>] (__dev_close_many+0xac/0x130)
[  334.339931] [<c0814fdc>] (__dev_close_many) from [<c0824068>] (__dev_change_flags+0xc8/0x1f0)
[  334.348510] [<c0824068>] (__dev_change_flags) from [<c08241a8>] (dev_change_flags+0x18/0x48)
[  334.357000] [<c08241a8>] (dev_change_flags) from [<c08efc3c>] (devinet_ioctl+0x6c0/0x850)
[  334.365228] [<c08efc3c>] (devinet_ioctl) from [<c08f2d98>] (inet_ioctl+0x1f8/0x3b4)
[  334.372935] [<c08f2d98>] (inet_ioctl) from [<c07f4594>] (sock_ioctl+0x398/0x5f4)
[  334.380380] [<c07f4594>] (sock_ioctl) from [<c03279b4>] (do_vfs_ioctl+0x9c/0xa08)
[  334.387911] [<c03279b4>] (do_vfs_ioctl) from [<c0328384>] (ksys_ioctl+0x64/0x74)
[  334.395355] [<c0328384>] (ksys_ioctl) from [<c01011ac>] (__sys_trace_return+0x0/0x14)
[  334.403231] Exception stack(0xed517fa8 to 0xed517ff0)
[  334.408319] 7fa0:                   0007b4ec bee79d84 00000003 00008914 bee79a80 0007b4ec
[  334.416548] 7fc0: 0007b4ec bee79d84 bee79d84 00000036 bee79c4c bee79c4c bee79a80 00000003
[  334.424774] 7fe0: 0009d1ec bee79a14 0003214b b6e94f7c


Enabled debug options:
=================================================
+CONFIG_LOCKUP_DETECTOR=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
+CONFIG_DETECT_HUNG_TASK=y
+CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=300
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
+CONFIG_PANIC_ON_OOPS=y
+CONFIG_PANIC_ON_OOPS_VALUE=1
+
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
+CONFIG_DEBUG_LOCKDEP=y
+CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_DEBUG_LOCKING_API_SELFTESTS=n
+CONFIG_STACKTRACE=y
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DEBUG_LIST=y
+CONFIG_DEBUG_SG=y
+CONFIG_DEBUG_NOTIFIERS=y
+
+CONFIG_SPARSE_RCU_POINTER=y
+CONFIG_RCU_CPU_STALL_TIMEOUT=60
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_TRACE=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_REPEATEDLY=y
+
+CONFIG_DMA_API_DEBUG=y


-- 
Best regards,
grygorii
