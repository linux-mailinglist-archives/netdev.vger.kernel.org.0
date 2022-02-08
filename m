Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9A4AE33A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386527AbiBHWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386393AbiBHUVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:21:33 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6525C0612C0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:21:31 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id p8-20020a056e02144800b002be41f4c3d2so4467480ilo.15
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TaQwE2DFiZTHkuTB9gFHxb0jFiUgExXwgy+A0Sjpojg=;
        b=sRX8dyjDJE2cdfVMk0mspkVhQqCdgCE5gjrylxBnz/c7wWpSjpnjXyDZBmTkwnlYvL
         xJQuitoatPVQboQ9tfk9GgCqDYp7zB2WOoSgaZg0KrG/Zj+ZSLIzduS0lXD1WzjLl8P/
         Cw3AIoJgcx7aX/dzACWIjbZSl8tba4stI3LP8NQrJrd/SKB1RlhW5FLum2ByfeCfC87G
         sBcv3i5SesfTRzi6tnim5umL8JQV8Wix4WwRNKHFekI+lR0iUgTzyq5GR2FId+nSBXI7
         kQN0yCDkE/wYYusscGQaZ5hkKFF0NbH3KlQXHZu7S7FfVgHWtsx5am6ncn/7+aFFbydo
         KtaA==
X-Gm-Message-State: AOAM532j2nekEzouBovW+DRXsQTFKt7aqq4mWF8Rnnd0GLmBpcUcmrcw
        EfDMVctOvEUeZAtV2NFGgaHkcLAkXSxYqyM91cFhr4j2fr3+
X-Google-Smtp-Source: ABdhPJwAVRTcWd8gAG6rv+1tIP3j1Wp4NlKNx+pkGdIW2URUSM4oWubQcegGkCjTmblLU4xyteAIKdcNHVJ/vB1Anc0NCup1HmkG
MIME-Version: 1.0
X-Received: by 2002:a02:6f48:: with SMTP id b8mr3107880jae.9.1644351690964;
 Tue, 08 Feb 2022 12:21:30 -0800 (PST)
Date:   Tue, 08 Feb 2022 12:21:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d045e05d78776f6@google.com>
Subject: [syzbot] BUG: MAX_LOCK_DEPTH too low! (3)
From:   syzbot <syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
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

syzbot found the following issue on:

HEAD commit:    ed14fc7a79ab net: sparx5: Fix get_stat64 crash in tcpdump
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=175bd324700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4a89edfcc8f7c74
dashboard link: https://syzkaller.appspot.com/bug?extid=4de3c0e8a263e1e499bc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f97334700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b54958700000

The issue was bisected to:

commit 341adeec9adad0874f29a0a1af35638207352a39
Author: Wen Gu <guwen@linux.alibaba.com>
Date:   Wed Jan 26 15:33:04 2022 +0000

    net/smc: Forward wakeup to smc socket waitqueue after fallback

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c2637c700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13c2637c700000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c2637c700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")

BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
depth: 48  max: 48!
48 locks held by syz-executor417/3783:
 #0: ffff888070db8810 (&sb->s_type->i_mutex_key#11){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:777 [inline]
 #0: ffff888070db8810 (&sb->s_type->i_mutex_key#11){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
 #1: ffff88801d4f7578 (&smc->clcsock_release_lock){+.+.}-{3:3}, at: smc_clcsock_release+0x71/0xe0 net/smc/smc_close.c:30
 #2: ffff8880739bc930 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1668 [inline]
 #2: ffff8880739bc930 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_close+0x1e/0xc0 net/ipv4/tcp.c:2921
 #3: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #4: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #5: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #6: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #7: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #8: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #9: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #10: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #11: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #12: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #13: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #14: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #15: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #16: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #17: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #18: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #19: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #20: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #21: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #22: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #23: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #24: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #25: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #26: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #27: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #28: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #29: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #30: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #31: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #32: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #33: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #34: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #35: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #36: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #37: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #38: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #39: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #40: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #41: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #42: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #43: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #44: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #45: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #46: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: smc_fback_forward_wakeup+0x0/0x540 net/smc/af_smc.c:2890
 #47: ffff888070db8c58 (&ei->socket.wq.wait){..-.}-{2:2}, at: add_wait_queue+0x42/0x260 kernel/sched/wait.c:23
INFO: lockdep is turned off.
CPU: 0 PID: 3783 Comm: syz-executor417 Not tainted 5.17.0-rc2-syzkaller-00168-ged14fc7a79ab #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __lock_acquire+0x18fd/0x5470 kernel/locking/lockdep.c:5045
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 add_wait_queue+0x42/0x260 kernel/sched/wait.c:23
 smc_fback_forward_wakeup+0x15b/0x540 net/smc/af_smc.c:617
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 smc_fback_forward_wakeup+0x161/0x540 net/smc/af_smc.c:618
 smc_fback_error_report+0x82/0xa0 net/smc/af_smc.c:664
 sk_error_report+0x35/0x310 net/core/sock.c:340
 tcp_disconnect+0x14e3/0x1e80 net/ipv4/tcp.c:3096
 __tcp_close+0xe65/0x12b0 net/ipv4/tcp.c:2792
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2922
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 __sock_release net/socket.c:650 [inline]
 sock_release+0x87/0x1b0 net/socket.c:678
 smc_clcsock_release+0xb3/0xe0 net/smc/smc_close.c:34
 __smc_release+0x35e/0x5b0 net/smc/af_smc.c:172
 smc_release+0x17f/0x530 net/smc/af_smc.c:209
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:311
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xb29/0x2a30 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:935
 get_signal+0x4b0/0x28c0 kernel/signal.c:2862
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f41e18579a9
Code: Unable to access opcode bytes at RIP 0x7f41e185797f.
RSP: 002b:00007f41e17e8318 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00007f41e18df3f8 RCX: 00007f41e18579a9
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f41e18df3fc
RBP: 00007f41e18df3f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f41e18ad074
R13: 00007ffefdec9ecf R14: 00007f41e17e8400 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
