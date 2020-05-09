Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A751CBE9B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgEIH5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgEIH5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:57:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CD6C061A0C;
        Sat,  9 May 2020 00:57:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s20so1748842plp.6;
        Sat, 09 May 2020 00:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L5ZH5WiQdP/X7RuqeW1CJzJD1ymkiOReNBzDvUy8tW0=;
        b=ejhY+hXGXAifeA/gZ1MRWhydS8Kggs/ozsHsVniwJiQy8wROZ3teQ+yj7sieBOaftr
         ir/Bpm6JufQaoGSfOlCoIb1FpBLVWJ3jdzHfKK0qdU1VxQhsT9K2qspxXKjAkNDLa2BF
         Kf/NEFQtS6rTsH//cLihU4qcbQeaETf32nZjgpNZJFqMfXZT8wPyYRcGwAyZXz82jHrT
         n9XhadTVbhAIMHH4xtD4nVsd1RHnMG39zOyrWDDvqMLYeI0OyS7kuD7KvtQT237ItADm
         1mFMUGuyDjennNuUUYn9QRVdmjQKWRk4xmLBCrYi0u2V1Z5LvXUSInNWGutdohKwRDGw
         SgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L5ZH5WiQdP/X7RuqeW1CJzJD1ymkiOReNBzDvUy8tW0=;
        b=T+LyR4Ladjwm6NMah20xQ6GopZhWggAOV542orfj/maQni/Q26/h9fjGWzoKkxx7TU
         SIn+sDz6lBYlLj85m1gnZRU3Eo55i9ptAZHvWMMfRFK47iOo27TcSI8k0mZzOhXkvDpA
         SIFAXgtPhq97OaT3wvGkZ7FNiDIsvefF2UXKkEpC8eKsjwslqE44wjkxBUBhlWPMDAvX
         wKYt4L28/J04dyYDNzMceLdYO1osMF1gp89dyO8TK6Btue8P+qgJmGv8hNNG5DRDWBcj
         U5pE4XrF3/JKrfL00h6IuE+SU6raijUPsiMrzCLXP8aqH6SwbwUvG1LLZpmdFjgn+piS
         y0nA==
X-Gm-Message-State: AGi0PuZdMHVilEeEJ1GGcKmiIRKYM4fdwAyw4NLsJmh0hWSPqXsvEX+K
        UMuBf5RQyXc2JLngAVuctA==
X-Google-Smtp-Source: APiQypI+J7LD1qXuPeY3OXp2M1s+niWRV0MONSHBRVhyh8DAQlJW74XiXR/gYebXd0+Gz4WFyOUv4w==
X-Received: by 2002:a17:90a:ba84:: with SMTP id t4mr9317770pjr.81.1589011051081;
        Sat, 09 May 2020 00:57:31 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:d0b:1e89:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id 1sm2805127pgy.77.2020.05.09.00.57.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 May 2020 00:57:29 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sat, 9 May 2020 13:27:22 +0530
To:     Amol Grover <frextrite@gmail.com>
Cc:     Qian Cai <cai@lca.pw>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ipmr_get_table
Message-ID: <20200509075721.GA30557@madhuparna-HP-Notebook>
References: <000000000000df9a9805a455e07b@google.com>
 <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
 <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
 <20200428141114.GA23123@madhuparna-HP-Notebook>
 <7EE520B9-1D73-49C5-9499-28B00340C993@lca.pw>
 <20200509072937.GA8709@kernel-dev-lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509072937.GA8709@kernel-dev-lenovo>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 12:59:37PM +0530, Amol Grover wrote:
> On Tue, Apr 28, 2020 at 10:28:41AM -0400, Qian Cai wrote:
> > 
> > 
> > > On Apr 28, 2020, at 10:11 AM, Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com> wrote:
> > > 
> > > On Tue, Apr 28, 2020 at 09:56:59AM -0400, Qian Cai wrote:
> > >> 
> > >> 
> > >>> On Apr 28, 2020, at 4:57 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >>>> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> > >> 
> > >> https://lore.kernel.org/netdev/20200222063835.14328-2-frextrite@gmail.com/
> > >> 
> > >> Never been picked up for a few months due to some reasons. You could probably
> > >> need to convince David, Paul, Steven or Linus to unblock the bot or carry patches
> > >> on your own?
> > >> 
> > >>>> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> > >> 
> > >> Not sure about this if anyone is working on it. Adding a few people...
> > >> 
> > > I will have a look at this one.
> > > 
> > >>>> 
> > >>>> other info that might help us debug this:
> > >>>> 
> > >>>> 
> > >>>> rcu_scheduler_active = 2, debug_locks = 1
> > >>>> 1 lock held by swapper/0/1:
> > >>>> #0: ffffffff8a5a6330 (pernet_ops_rwsem){+.+.}-{3:3}, at: register_pernet_subsys+0x16/0x40 net/core/net_namespace.c:1257
> > >>>> 
> > >>>> stack backtrace:
> > >>>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> > >>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > >>>> Call Trace:
> > >>>> __dump_stack lib/dump_stack.c:77 [inline]
> > >>>> dump_stack+0x18f/0x20d lib/dump_stack.c:118
> > >>>> ip6mr_get_table+0x153/0x180 net/ipv6/ip6mr.c:124
> > >>>> ip6mr_new_table+0x1b/0x70 net/ipv6/ip6mr.c:382
> > >>>> ip6mr_rules_init net/ipv6/ip6mr.c:236 [inline]
> > >>>> ip6mr_net_init+0x133/0x3f0 net/ipv6/ip6mr.c:1310
> > >>>> ops_init+0xaf/0x420 net/core/net_namespace.c:151
> > >>>> __register_pernet_operations net/core/net_namespace.c:1140 [inline]
> > >>>> register_pernet_operations+0x346/0x840 net/core/net_namespace.c:1217
> > >>>> register_pernet_subsys+0x25/0x40 net/core/net_namespace.c:1258
> > >>>> ip6_mr_init+0x49/0x152 net/ipv6/ip6mr.c:1363
> > >>>> inet6_init+0x1d7/0x6dc net/ipv6/af_inet6.c:1032
> > >>>> do_one_initcall+0x10a/0x7d0 init/main.c:1159
> > >>>> do_initcall_level init/main.c:1232 [inline]
> > >>>> do_initcalls init/main.c:1248 [inline]
> > >>>> do_basic_setup init/main.c:1268 [inline]
> > >>>> kernel_init_freeable+0x501/0x5ae init/main.c:1454
> > >>>> kernel_init+0xd/0x1bb init/main.c:1359
> > >>>> ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
> > >>>> 
> > >>>> =============================
> > >>>> WARNING: suspicious RCU usage
> > >>>> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> > >>>> -----------------------------
> > >>>> security/integrity/evm/evm_main.c:231 RCU-list traversed in non-reader section!!
> > >> 
> > >> Ditto.
> > >> 
> > > I am working on this one(evm_main.c). I am in touch with the maintaners
> > > and I will fix this one soon.
> > 
> > It would be great if you guys could test under KVM as well. Here are
> > quite a few false positives that I personally may never found enough
> > time to silence them.
> > 
> 
> Hey Madhuparna,
> 
> Do you want me to take a look at these if you're not already working
> on them?
>
Yes, you can have a look at the 1st one i.e. ip6mr.c

I have already sent a patch for the second one (emv_main.c)

thank you,
Madhuparna

> Thanks
> Amol
> 
> > [ 9403.765413][T61744] =============================
> > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L   
> > [ 9403.838945][T61744] -----------------------------
> > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > [ 9403.901270][T61744] 
> > [ 9403.901270][T61744] other info that might help us debug this:
> > [ 9403.901270][T61744] 
> > [ 9403.951032][T61744] 
> > [ 9403.951032][T61744] rcu_scheduler_active = 2, debug_locks = 1
> > [ 9403.986890][T61744] 2 locks held by qemu-kvm/61744:
> > [ 9404.008862][T61744]  #0: ffffc90008a390a8 (&kvm->slots_lock){+.+.}-{3:3}, at: kvm_set_memory_region+0x22/0x60 [kvm]
> > [ 9404.055627][T61744]  #1: ffffc90008a429e8 (&head->track_srcu){....}-{0:0}, at: kvm_page_track_flush_slot+0x46/0x149 [kvm]
> > [ 9404.104997][T61744] 
> > [ 9404.104997][T61744] stack backtrace:
> > [ 9404.130894][T61744] CPU: 24 PID: 61744 Comm: qemu-kvm Tainted: G             L    5.7.0-rc1-next-20200417 #4
> > [ 9404.176174][T61744] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 04/12/2017
> > [ 9404.216664][T61744] Call Trace:
> > [ 9404.230769][T61744]  dump_stack+0xa0/0xea
> > [ 9404.248749][T61744]  lockdep_rcu_suspicious+0x102/0x10b
> > [ 9404.272384][T61744]  kvm_page_track_flush_slot+0x140/0x149 [kvm]
> > [ 9404.299456][T61744]  kvm_arch_flush_shadow_memslot+0xe/0x10 [kvm]
> > [ 9404.326870][T61744]  kvm_set_memslot+0x197/0xbb0 [kvm]
> > [ 9404.350017][T61744]  kvm_delete_memslot+0xdb/0x1a0 [kvm]
> > [ 9404.374077][T61744]  ? kvm_set_memslot+0xbb0/0xbb0 [kvm]
> > [ 9404.398321][T61744]  __kvm_set_memory_region+0x9ce/0xbe0 [kvm]
> > [ 9404.427779][T61744]  ? kvm_vcpu_ioctl+0x960/0x960 [kvm]
> > [ 9404.454327][T61744]  ? check_flags.part.28+0x220/0x220
> > [ 9404.477673][T61744]  kvm_set_memory_region+0x2d/0x60 [kvm]
> > [ 9404.502368][T61744]  kvm_vm_ioctl+0xc11/0x1ad0 [kvm]
> > [ 9404.524760][T61744]  ? kvm_unregister_device_ops+0xd0/0xd0 [kvm]
> > [ 9404.551776][T61744]  ? check_chain_key+0x1df/0x2e0
> > [ 9404.573575][T61744]  ? register_lock_class+0xb90/0xb90
> > [ 9404.596638][T61744]  ? __lock_acquire+0xa18/0x3260
> > [ 9404.618201][T61744]  ? match_held_lock+0x20/0x270
> > [ 9404.639379][T61744]  ? __fget_files+0x22b/0x350
> > [ 9404.660094][T61744]  ? lock_downgrade+0x3e0/0x3e0
> > [ 9404.681314][T61744]  ? rcu_read_lock_held+0xac/0xc0
> > [ 9404.703305][T61744]  ? check_chain_key+0x1df/0x2e0
> > [ 9404.725022][T61744]  ? rcu_read_lock_sched_held+0xe0/0xe0
> > [ 9404.749344][T61744]  ? __fget_files+0x245/0x350
> > [ 9404.769762][T61744]  ? do_dup2+0x2b0/0x2b0
> > [ 9404.788159][T61744]  ? __kasan_check_read+0x11/0x20
> > [ 9404.810170][T61744]  ? __lru_cache_add+0x122/0x160
> > [ 9404.831822][T61744]  ? __fget_light+0x107/0x120
> > [ 9404.852136][T61744]  ksys_ioctl+0x26e/0xdd0
> > [ 9404.871267][T61744]  ? match_held_lock+0x20/0x270
> > [ 9404.892364][T61744]  ? generic_block_fiemap+0x70/0x70
> > [ 9404.915288][T61744]  ? do_page_fault+0x2ea/0x9d7
> > [ 9404.940091][T61744]  ? lock_downgrade+0x3e0/0x3e0
> > [ 9404.963107][T61744]  ? mark_held_locks+0x34/0xb0
> > [ 9404.983943][T61744]  ? do_syscall_64+0x79/0xaf0
> > [ 9405.004518][T61744]  ? do_syscall_64+0x79/0xaf0
> > [ 9405.024936][T61744]  __x64_sys_ioctl+0x43/0x4c
> > [ 9405.044853][T61744]  do_syscall_64+0xcc/0xaf0
> > [ 9405.064469][T61744]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> > [ 9405.088407][T61744]  ? syscall_return_slowpath+0x580/0x580
> > [ 9405.112635][T61744]  ? entry_SYSCALL_64_after_hwframe+0x3e/0xb3
> > [ 9405.139199][T61744]  ? trace_hardirqs_off_caller+0x3a/0x150
> > [ 9405.164191][T61744]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> > [ 9405.188632][T61744]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > [ 9405.215344][T61744] RIP: 0033:0x7f1e6950b87b
> > [ 9405.234484][T61744] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> > [ 9405.322433][T61744] RSP: 002b:00007fff58ec3118 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [ 9405.359532][T61744] RAX: ffffffffffffffda RBX: 0000563e85cf8690 RCX: 00007f1e6950b87b
> > [ 9405.394860][T61744] RDX: 00007fff58ec3180 RSI: 000000004020ae46 RDI: 000000000000000a
> > [ 9405.431480][T61744] RBP: 0000563e85cf6c50 R08: 0000000080000000 R09: 0000000000000006
> > [ 9405.471898][T61744] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff58ec3180
> > [ 9405.507059][T61744] R13: 0000000080000000 R14: 0000000000000000 R15: 0000563e86685260
> > [ 9405.817389][T61755] 
> > [ 9405.827846][T61755] =============================
> > [ 9405.842296][T61751] 
> > [ 9405.848994][T61755] WARNING: suspicious RCU usage
> > [ 9405.849006][T61755] 5.7.0-rc1-next-20200417 #4 Tainted: G             L   
> > [ 9405.859252][T61751] =============================
> > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > [ 9405.880867][T61755] -----------------------------
> > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L   
> > [ 9405.911942][T61751] -----------------------------
> > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > [ 9405.911955][T61751] 
> > [ 9405.911955][T61751] other info that might help us debug this:
> > [ 9405.911955][T61751] 
> > [ 9405.911962][T61751] 
> > [ 9405.911962][T61751] rcu_scheduler_active = 2, debug_locks = 1
> > [ 9405.911969][T61751] 3 locks held by qemu-kvm/61751:
> > [ 9405.911974][T61751]  #0: ffff888f0a5d0108 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x13c/0x960 [kvm]
> > [ 9405.932948][T61755] arch/x86/kvm/../../../virt/kvm/eventfd.c:472 RCU-list traversed in non-reader section!!
> > [ 9405.932952][T61755] 
> > [ 9405.932952][T61755] other info that might help us debug this:
> > [ 9405.932952][T61755] 
> > [ 9405.932958][T61755] 
> > [ 9405.932958][T61755] rcu_scheduler_active = 2, debug_locks = 1
> > [ 9405.932965][T61755] 1 lock held by kvm-pit/61744/61755:
> > [ 9405.957893][T61751]  #1: ffffc90008a43e10 (&kvm->srcu){....}-{0:0}, at: complete_emulated_pio+0x2b/0x100 [kvm]
> > [ 9405.981585][T61755]  #0: ffffc90008a44b98 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x95/0x260 [kvm]
> > [ 9405.981696][T61755] 
> > [ 9405.981696][T61755] stack backtrace:
> > [ 9406.012921][T61751]  #2: ffffc90008a429e8 (&head->track_srcu){....}-{0:0}, at: kvm_page_track_write+0x5a/0x180 [kvm]
> > [ 9406.034119][T61755] CPU: 57 PID: 61755 Comm: kvm-pit/61744 Tainted: G             L    5.7.0-rc1-next-20200417 #4
> > [ 9406.034125][T61755] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 04/12/2017
> > [ 9406.034129][T61755] Call Trace:
> > [ 9406.034139][T61755]  dump_stack+0xa0/0xea
> > [ 9406.034149][T61755]  lockdep_rcu_suspicious+0x102/0x10b
> > [ 9406.073706][T61751] 
> > [ 9406.073706][T61751] stack backtrace:
> > [ 9406.118968][T61755]  kvm_notify_acked_gsi+0xb0/0xc0 [kvm]
> > [ 9406.119062][T61755]  kvm_notify_acked_irq+0xe8/0x260 [kvm]
> > [ 9406.779456][T61755]  kvm_ioapic_update_eoi_one+0x72/0x410 [kvm]
> > [ 9406.807371][T61755]  ioapic_set_irq+0x3b4/0x500 [kvm]
> > [ 9406.831290][T61755]  kvm_ioapic_set_irq+0xab/0x100 [kvm]
> > [ 9406.856440][T61755]  kvm_set_ioapic_irq+0x53/0x60 [kvm]
> > [ 9406.881615][T61755]  kvm_set_irq+0x227/0x440 [kvm]
> > [ 9406.904332][T61755]  ? kvm_send_userspace_msi+0x160/0x160 [kvm]
> > [ 9406.932144][T61755]  ? kvm_hv_set_sint+0x50/0x50 [kvm]
> > [ 9406.956351][T61755]  ? kvm_set_ioapic_irq+0x60/0x60 [kvm]
> > [ 9406.984890][T61755]  ? lock_downgrade+0x3e0/0x3e0
> > [ 9407.009537][T61755]  ? mark_held_locks+0x34/0xb0
> > [ 9407.031387][T61755]  ? _raw_spin_unlock_irq+0x27/0x40
> > [ 9407.056810][T61755]  ? _raw_spin_unlock_irq+0x27/0x40
> > [ 9407.080805][T61755]  pit_do_work+0xa1/0x190 [kvm]
> > [ 9407.102876][T61755]  kthread_worker_fn+0x1c0/0x3f0
> > [ 9407.124632][T61755]  ? kthread_park+0xd0/0xd0
> > [ 9407.144858][T61755]  ? __kasan_check_read+0x11/0x20
> > [ 9407.167737][T61755]  ? __kthread_parkme+0xd4/0xf0
> > [ 9407.189114][T61755]  ? kthread_park+0xd0/0xd0
> > [ 9407.209832][T61755]  kthread+0x1f4/0x220
> > [ 9407.228102][T61755]  ? kthread_create_worker_on_cpu+0xc0/0xc0
> > [ 9407.255161][T61755]  ret_from_fork+0x3a/0x50
> > [ 9407.275120][T61751] CPU: 62 PID: 61751 Comm: qemu-kvm Tainted: G             L    5.7.0-rc1-next-20200417 #4
> > [ 9407.321799][T61751] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 04/12/2017
> > [ 9407.364109][T61751] Call Trace:
> > [ 9407.378980][T61751]  dump_stack+0xa0/0xea
> > [ 9407.397958][T61751]  lockdep_rcu_suspicious+0x102/0x10b
> > [ 9407.422764][T61751]  kvm_page_track_write+0x169/0x180 [kvm]
> > [ 9407.449267][T61751]  emulator_write_phys+0x3b/0x50 [kvm]
> > [ 9407.474448][T61751]  write_emulate+0xe/0x10 [kvm]
> > [ 9407.499219][T61751]  emulator_read_write_onepage+0x101/0x6d0 [kvm]
> > [ 9407.529721][T61751]  emulator_read_write+0xfa/0x270 [kvm]
> > [ 9407.555076][T61751]  emulator_write_emulated+0x15/0x20 [kvm]
> > [ 9407.581597][T61751]  segmented_write+0xb5/0xf0 [kvm]
> > [ 9407.604844][T61751]  ? em_fxsave+0x30/0x30 [kvm]
> > [ 9407.626540][T61751]  writeback+0x314/0x410 [kvm]
> > [ 9407.648356][T61751]  ? segmented_write+0xf0/0xf0 [kvm]
> > [ 9407.672776][T61751]  ? em_in+0x138/0x310 [kvm]
> > [ 9407.693374][T61751]  x86_emulate_insn+0xff7/0x1a80 [kvm]
> > [ 9407.718491][T61751]  ? decode_imm+0x3c0/0x3c0 [kvm]
> > [ 9407.741762][T61751]  ? init_decode_cache+0x70/0x70 [kvm]
> > [ 9407.766778][T61751]  ? lock_acquire+0x1a2/0x680
> > [ 9407.788387][T61751]  ? complete_emulated_pio+0x2b/0x100 [kvm]
> > [ 9407.815860][T61751]  x86_emulate_instruction+0x38c/0xd30 [kvm]
> > [ 9407.842628][T61751]  ? rcu_read_lock_sched_held+0xac/0xe0
> > [ 9407.867165][T61751]  complete_emulated_pio+0x8b/0x100 [kvm]
> > [ 9407.893878][T61751]  ? complete_emulated_pio+0x2b/0x100 [kvm]
> > [ 9407.920660][T61751]  kvm_arch_vcpu_ioctl_run+0x8c1/0xa10 [kvm]
> > [ 9407.948068][T61751]  kvm_vcpu_ioctl+0x3a1/0x960 [kvm]
> > [ 9407.971859][T61751]  ? kvm_vcpu_block+0x770/0x770 [kvm]
> > [ 9407.997524][T61751]  ? rcu_read_lock_held+0xac/0xc0
> > [ 9408.023001][T61751]  ? check_chain_key+0x1df/0x2e0
> > [ 9408.046613][T61751]  ? rcu_read_lock_sched_held+0xe0/0xe0
> > [ 9408.071844][T61751]  ? __fget_files+0x245/0x350
> > [ 9408.093254][T61751]  ? do_dup2+0x2b0/0x2b0
> > [ 9408.112665][T61751]  ? __kasan_check_read+0x11/0x20
> > [ 9408.135488][T61751]  ? __lru_cache_add+0x122/0x160
> > [ 9408.157861][T61751]  ? __fget_light+0x107/0x120
> > [ 9408.179171][T61751]  ksys_ioctl+0x26e/0xdd0
> > [ 9408.200256][T61751]  ? match_held_lock+0x20/0x270
> > [ 9408.222157][T61751]  ? generic_block_fiemap+0x70/0x70
> > [ 9408.245928][T61751]  ? do_page_fault+0x2ea/0x9d7
> > [ 9408.267669][T61751]  ? mark_held_locks+0x34/0xb0
> > [ 9408.289462][T61751]  ? kvm_on_user_return+0x5a/0x1e0 [kvm]
> > [ 9408.315329][T61751]  ? kvm_on_user_return+0x5a/0x1e0 [kvm]
> > [ 9408.341384][T61751]  ? lockdep_hardirqs_on+0x1b0/0x2c0
> > [ 9408.365536][T61751]  ? fire_user_return_notifiers+0x5d/0x70
> > [ 9408.391685][T61751]  ? trace_hardirqs_on+0x3a/0x160
> > [ 9408.414445][T61751]  ? mark_held_locks+0x34/0xb0
> > [ 9408.436145][T61751]  ? do_syscall_64+0x79/0xaf0
> > [ 9408.457516][T61751]  ? do_syscall_64+0x79/0xaf0
> > [ 9408.478993][T61751]  __x64_sys_ioctl+0x43/0x4c
> > [ 9408.499973][T61751]  do_syscall_64+0xcc/0xaf0
> > [ 9408.522780][T61751]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> > [ 9408.550287][T61751]  ? syscall_return_slowpath+0x580/0x580
> > [ 9408.576298][T61751]  ? entry_SYSCALL_64_after_hwframe+0x3e/0xb3
> > [ 9408.604089][T61751]  ? trace_hardirqs_off_caller+0x3a/0x150
> > [ 9408.630247][T61751]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> > [ 9408.655514][T61751]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > [ 9408.682308][T61751] RIP: 0033:0x7f1e6950b87b
> > [ 9408.702032][T61751] Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> > [ 9408.792794][T61751] RSP: 002b:00007f1e60a08678 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [ 9408.834244][T61751] RAX: ffffffffffffffda RBX: 00007f1e6e837004 RCX: 00007f1e6950b87b
> > [ 9408.870897][T61751] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000011
> > [ 9408.909368][T61751] RBP: 0000000000000004 R08: 0000563e835d1ad0 R09: 0000563e85e99c00
> > [ 9408.947178][T61751] R10: 0000000000000001 R11: 0000000000000246 R12: 0000563e835ba100
> > [ 9408.983915][T61751] R13: 0000000000000000 R14: 00007f1e6e836000 R15: 0000563e85d5aca0
> > 
> > 
> > [  972.397826][ T4274] =============================
> > [  972.397846][ T4274] WARNING: suspicious RCU usage
> > [  972.397865][ T4274] 5.7.0-rc1-next-20200417 #5 Not tainted
> > [  972.397875][ T4274] -----------------------------
> > [  972.397894][ T4274] arch/powerpc/kvm/book3s_64_vio.c:368 RCU-list traversed in non-reader section!!
> > [  972.397925][ T4274] 
> > [  972.397925][ T4274] other info that might help us debug this:
> > [  972.397925][ T4274] 
> > [  972.397957][ T4274] 
> > [  972.397957][ T4274] rcu_scheduler_active = 2, debug_locks = 1
> > [  972.397979][ T4274] 2 locks held by qemu-kvm/4274:
> > [  972.397997][ T4274]  #0: c00000057eb800d8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0xdc/0x950 [kvm]
> > [  972.398031][ T4274]  #1: c0000005dfc0c468 (&kvm->srcu){....}-{0:0}, at: kvmppc_h_put_tce+0x88/0x340 [kvm]
> > [  972.398060][ T4274] 
> > [  972.398060][ T4274] stack backtrace:
> > [  972.398081][ T4274] CPU: 44 PID: 4274 Comm: qemu-kvm Not tainted 5.7.0-rc1-next-20200417 #5
> > [  972.398103][ T4274] Call Trace:
> > [  972.398123][ T4274] [c00000008f0cf7c0] [c000000000717b20] dump_stack+0xf4/0x164 (unreliable)
> > [  972.398157][ T4274] [c00000008f0cf810] [c0000000001d9090] lockdep_rcu_suspicious+0x140/0x164
> > [  972.398193][ T4274] [c00000008f0cf890] [c0080000092ff498] kvmppc_tce_validate+0x240/0x280 [kvm]
> > [  972.398220][ T4274] [c00000008f0cf910] [c008000009300550] kvmppc_h_put_tce+0xd8/0x340 [kvm]
> > [  972.398257][ T4274] [c00000008f0cf9a0] [c00800000934d51c] kvmppc_pseries_do_hcall+0xac4/0x1440 [kvm_hv]
> > [  972.398291][ T4274] [c00000008f0cfa20] [c008000009350d88] kvmppc_vcpu_run_hv+0x930/0x15f0 [kvm_hv]
> > [  972.398328][ T4274] [c00000008f0cfb10] [c0080000092ef36c] kvmppc_vcpu_run+0x34/0x48 [kvm]
> > [  972.398363][ T4274] [c00000008f0cfb30] [c0080000092eb1cc] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
> > [  972.398399][ T4274] [c00000008f0cfbd0] [c0080000092d9848] kvm_vcpu_ioctl+0x340/0x950 [kvm]
> > [  972.398430][ T4274] [c00000008f0cfd50] [c000000000546ac8] ksys_ioctl+0xd8/0x130
> > [  972.398453][ T4274] [c00000008f0cfda0] [c000000000546b48] sys_ioctl+0x28/0x40
> > [  972.398475][ T4274] [c00000008f0cfdc0] [c000000000038b24] system_call_exception+0x114/0x1e0
> > [  972.398509][ T4274] [c00000008f0cfe20] [c00000000000c8f0] system_call_common+0xf0/0x278
