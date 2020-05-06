Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968821C751D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEFPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbgEFPjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:39:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6C7C061A0F;
        Wed,  6 May 2020 08:39:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a32so1076871pje.5;
        Wed, 06 May 2020 08:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GUg45fchfUJQyrKfi2SeBKzH5Au3T1iP5qk+rGEmaqg=;
        b=h0emR6HiPjlvE4+oNQiBkwQ42rZvSGOJmEfD8kJAq1SNcD610Z8eOr5IYXUxn1byyg
         xoT0OApMp2Dzf3uCpakCwiyn4PMvNrHOtqpWguc77zjCg/IGLSwgh6p1+CVk7AQjZdAR
         ZI77YeSsNrTGs72UkSjlrMeSVl3FZ84wrI6g7tLOcbKGMJFAW12XXU5yNW7ESwSkllOL
         1t1PMOv4PXnSkpW19bURdX7ujylXyyYTcTRivO4y9x4pf5cpNpD02n1sK1h7G8fxHqVl
         AdXeZrvWikGLJeee8JeKWdcOmguM/0hplTIz8HC3WntxSHJshQC0R3PtG4VDBf0Yvm2Z
         UHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GUg45fchfUJQyrKfi2SeBKzH5Au3T1iP5qk+rGEmaqg=;
        b=RNw/VJmHAdhqXcnuKL5ZjuyROj0UPGpG/ZUDWmSWM7jD4o/s9XAohUPnd1Ix3UtezL
         N1jeNyGvAJfeQYrL6q7D/DCCJuvHaBbqF1uxwW14xVB3RID3XpKfw2i2me1qmNLQBIyT
         pVGJTBJqLovU8+7vAVFV/6qC0VI2WMyUqdpi2rdkrbJIPvWnqQXiuoxcs2Rf02K1L0Us
         0y4/zOqQZKGtteMk7DRRNGfgFV6w0GJaggcIPrJzB1k7WI618EEHCfvsLY++pNnTv29W
         0o6rAAyk6LWifTMd4cg4WLMbWmXUpi8wOSxv3uRXakbd5lRHDdt2O2rgo98AQz0QcRwn
         P6pw==
X-Gm-Message-State: AGi0PuaMAgaaZRtP7uzm34Jf68MEVRHQTSRPZ6KUWDkFo4RU1DPRGT4P
        JkK59lDOAo/kqjivt3DJ798=
X-Google-Smtp-Source: APiQypKO23eydN/tJba7Ah1lcRr2KBG75WfI7bF7h/LDo1PI/Vd27IzZd77FLmvDeq6MfOQMPx9Zew==
X-Received: by 2002:a17:90a:3509:: with SMTP id q9mr10169884pjb.121.1588779591143;
        Wed, 06 May 2020 08:39:51 -0700 (PDT)
Received: from kernel-dev-lenovo ([103.87.57.23])
        by smtp.gmail.com with ESMTPSA id 4sm2233973pff.18.2020.05.06.08.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:39:50 -0700 (PDT)
Date:   Wed, 6 May 2020 21:09:41 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
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
Message-ID: <20200506153941.GA16135@kernel-dev-lenovo>
References: <000000000000df9a9805a455e07b@google.com>
 <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
 <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 09:56:59AM -0400, Qian Cai wrote:
> 
> 
> > On Apr 28, 2020, at 4:57 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> 
> https://lore.kernel.org/netdev/20200222063835.14328-2-frextrite@gmail.com/
> 
> Never been picked up for a few months due to some reasons. You could probably
> need to convince David, Paul, Steven or Linus to unblock the bot or carry patches
> on your own?
> 
> >> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> 
> Not sure about this if anyone is working on it. Adding a few people...
> 
> >> 
> >> other info that might help us debug this:
> >> 
> >> 
> >> rcu_scheduler_active = 2, debug_locks = 1
> >> 1 lock held by swapper/0/1:
> >> #0: ffffffff8a5a6330 (pernet_ops_rwsem){+.+.}-{3:3}, at: register_pernet_subsys+0x16/0x40 net/core/net_namespace.c:1257
> >> 
> >> stack backtrace:
> >> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> Call Trace:
> >> __dump_stack lib/dump_stack.c:77 [inline]
> >> dump_stack+0x18f/0x20d lib/dump_stack.c:118
> >> ip6mr_get_table+0x153/0x180 net/ipv6/ip6mr.c:124
> >> ip6mr_new_table+0x1b/0x70 net/ipv6/ip6mr.c:382
> >> ip6mr_rules_init net/ipv6/ip6mr.c:236 [inline]
> >> ip6mr_net_init+0x133/0x3f0 net/ipv6/ip6mr.c:1310
> >> ops_init+0xaf/0x420 net/core/net_namespace.c:151
> >> __register_pernet_operations net/core/net_namespace.c:1140 [inline]
> >> register_pernet_operations+0x346/0x840 net/core/net_namespace.c:1217
> >> register_pernet_subsys+0x25/0x40 net/core/net_namespace.c:1258
> >> ip6_mr_init+0x49/0x152 net/ipv6/ip6mr.c:1363
> >> inet6_init+0x1d7/0x6dc net/ipv6/af_inet6.c:1032
> >> do_one_initcall+0x10a/0x7d0 init/main.c:1159
> >> do_initcall_level init/main.c:1232 [inline]
> >> do_initcalls init/main.c:1248 [inline]
> >> do_basic_setup init/main.c:1268 [inline]
> >> kernel_init_freeable+0x501/0x5ae init/main.c:1454
> >> kernel_init+0xd/0x1bb init/main.c:1359
> >> ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
> >> 
> >> =============================
> >> WARNING: suspicious RCU usage
> >> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> >> -----------------------------
> >> security/integrity/evm/evm_main.c:231 RCU-list traversed in non-reader section!!
> 
> Ditto.
> 
> >> 
> >> other info that might help us debug this:
> >> 
> >> 
> >> rcu_scheduler_active = 2, debug_locks = 1
> >> 2 locks held by systemd/1:
> >> #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: sb_start_write include/linux/fs.h:1659 [inline]
> >> #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+0x3a/0xb0 fs/namespace.c:354
> >> #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
> >> #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: vfs_setxattr+0x92/0xf0 fs/xattr.c:219
> >> 
> >> stack backtrace:
> >> CPU: 0 PID: 1 Comm: systemd Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> Call Trace:
> >> __dump_stack lib/dump_stack.c:77 [inline]
> >> dump_stack+0x18f/0x20d lib/dump_stack.c:118
> >> evm_protected_xattr+0x1c2/0x210 security/integrity/evm/evm_main.c:231
> >> evm_protect_xattr.isra.0+0xb6/0x3d0 security/integrity/evm/evm_main.c:318
> >> evm_inode_setxattr+0xc4/0xf0 security/integrity/evm/evm_main.c:387
> >> security_inode_setxattr+0x18f/0x200 security/security.c:1297
> >> vfs_setxattr+0xa7/0xf0 fs/xattr.c:220
> >> setxattr+0x23d/0x330 fs/xattr.c:451
> >> path_setxattr+0x170/0x190 fs/xattr.c:470
> >> __do_sys_setxattr fs/xattr.c:485 [inline]
> >> __se_sys_setxattr fs/xattr.c:481 [inline]
> >> __x64_sys_setxattr+0xc0/0x160 fs/xattr.c:481
> >> do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >> entry_SYSCALL_64_after_hwframe+0x49/0xb3
> >> RIP: 0033:0x7fe46005e67a
> >> Code: 48 8b 0d 21 18 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ee 17 2b 00 f7 d8 64 89 01 48
> >> RSP: 002b:00007fffef423568 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
> >> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe46005e67a
> >> RDX: 00007fffef4235e0 RSI: 0000556ea53ddf9b RDI: 0000556ea6766760
> >> RBP: 0000556ea53ddf9b R08: 0000000000000000 R09: 0000000000000030
> >> R10: 0000000000000020 R11: 0000000000000246 R12: 00007fffef4235e0
> >> R13: 0000000000000020 R14: 0000000000000000 R15: 0000556ea6751700
> >> 
> >> security/device_cgroup.c:357 RCU-list traversed in non-reader section!!
> 
> https://lore.kernel.org/lkml/20200406105950.GA2285@workstation-kernel-dev/
> 
> The same story. The patch had been ignored for a while.
> 

Thank you for reminding! I will resend the patches and try to get them
merged ASAP.

> 
> 
