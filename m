Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2064DA437
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351753AbiCOUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351743AbiCOUuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:50:14 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B69624F06;
        Tue, 15 Mar 2022 13:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647377335;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:To:Subject:Date:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=mfqGnB/NorIrBYocK370TVdnZ90hKH4/cEEo32hkWwY=;
    b=BGDAm1EZRYfYZ4KX1kNZ5aurOwJ7JMSKWmS1K0SMwjlZ5on3oITcZJy9WqgHYP/Es7
    2Fb6FwO/kXt1K6J0eWpdSnNDf0VHUGbe+58QPyWnluDsVJQLPrOmjINwCJeAk6ff/0mc
    8yocIlUDGyyVUI263MSiGKA8HqLvMP1qwIHaHqoUOqwhkCrUQeGFa8iQVL0pRNKKl4zz
    H31elYe2yV4yEgS/Lyly2mvv+uVTSzUISksYPG4yMSiUXigsarTkg1flX92Nlq5PDKh3
    oDInwP2sO/zigM77E8oc1Iqr55l6bwTIafIBAduGrC7B3LyriTEs79hD/veDgih3BODu
    LkeQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.0 AUTH)
    with ESMTPSA id a046a1y2FKms13o
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Mar 2022 21:48:54 +0100 (CET)
Message-ID: <9bdaf3f2-3edc-5cd5-1184-55387344881d@hartkopp.net>
Date:   Tue, 15 Mar 2022 21:48:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: net-next Re: [syzbot] WARNING in isotp_tx_timer_handler (2)
Content-Language: en-US
To:     syzbot <syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000004e53a505da08501e@google.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <0000000000004e53a505da08501e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

thanks for the report!

A patch to fix the issue has been posted for the "net-next" tree here:

https://lore.kernel.org/netdev/20220315203748.1892-1-socketcan@hartkopp.net/T/#u

I sent it to the net-next tree as it fits best to get it into upstream 
before the merge window opens IMO.

Linus' tree (and the stable kernels) need a different patch due to 
current changes in net-next. A patch for the non net-next kernels is 
available too.

The fix is not critical. So there's no hurry to get it into Linus' tree 
and the stable trees.

Best regards,
Oliver


On 12.03.22 17:55, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    46b348fd2d81 alx: acquire mutex for alx_reinit in alx_chan..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=15da96e5700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=442f8ac61e60a75e
> dashboard link: https://syzkaller.appspot.com/bug?extid=2339c27f5c66c652843e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165c76ad700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143da461700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 19 at net/can/isotp.c:852 isotp_tx_timer_handler+0x717/0xcd0 net/can/isotp.c:852
> Modules linked in:
> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.17.0-rc7-syzkaller-00198-g46b348fd2d81 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:isotp_tx_timer_handler+0x717/0xcd0 net/can/isotp.c:852
> Code: f9 44 0f b6 25 3b 23 56 05 31 ff 44 89 e6 e8 f0 56 4f f9 45 84 e4 0f 85 9d fa ff ff e9 4e 01 20 01 85 ed 75 52 e8 59 54 4f f9 <0f> 0b 45 31 e4 e8 4f 54 4f f9 48 8b 74 24 40 48 b8 00 00 00 00 00
> RSP: 0018:ffffc90000d97c40 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88806f490568 RCX: 0000000000000100
> RDX: ffff888011945700 RSI: ffffffff88296bd7 RDI: 0000000000000003
> RBP: 0000000000000000 R08: ffffffff8ac3c440 R09: ffffffff8829656f
> R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff8880b9d2a880 R14: ffff8880b9d2a600 R15: ffffffff882964c0
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5c3133d1d8 CR3: 000000006b70d000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>   __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
>   hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
>   __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>   run_ksoftirqd kernel/softirq.c:921 [inline]
>   run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
>   smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
>   kthread+0x2e9/0x3a0 kernel/kthread.c:377
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
