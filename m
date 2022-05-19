Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD10A52CBF5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiESGbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiESGbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:31:45 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EEA2496A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:31:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id g16so5073061lja.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=naZDnEoCjMXx13Y1+051NuNh/YR239ab6tyhsA1Bwj8=;
        b=Fbs2aVMU4cPjCMiljTBfCDS6deeUI+7jucOmpU9q1W+ptFqc83lQz0uSgCGSIfrf20
         zd63SsWiz/mIBngU8Uyjv/hP3q7oFtmI9nu/6pafHtYTWv+r4n91Tj9Sqrp6CncR+FKy
         jaZLbIPJaqVxGhyA9VApM/3/t8Kjdk3PP4JMCW0OwCNV4ss/2dxkKUGKpl+LJXir6BiJ
         QrNkWN81erHvWlU3S2mJ4LzepybjkQnwm9A5yEKj0r7XzT10r9XIJFBKG3t/jP7BYqaM
         87oTIQrxYBFWNAHYHxNaQkr7s5t+6ES8lcNaAHQCtQVUAO82EigJheMXDX1htuZkpxpP
         Qwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=naZDnEoCjMXx13Y1+051NuNh/YR239ab6tyhsA1Bwj8=;
        b=oYgwsCJ6U0tI8HI90fAcrfEkgYMXqQErLfQcqqN6oOQI3rl6D7JYCXA19glw+DzZ2n
         MlflJZkOaqaQJbVhUa2cCP1oCebDUzPARZDqafDH+/OKRYnEgRsny+jrvdH+vIngjowz
         fj6XA2gAJwC4HDYMmPjIkInXJ00R17hN0x8KBZ2UaqUMK6QpP96tnkSbEPePO31PbsLw
         Ofk94rCybs2TW3qnsAfRXU9J1tV69k7pldE/yNRfpJ4/YDA35Moj/OYKTRhwpA8BnpNd
         qLx5xg3uYoFxCq/isEmPWGW/m5YZl7vJjhc8NBpDvPSYTl8yTvYrkhDTa2WNgy74ekN1
         ee/g==
X-Gm-Message-State: AOAM530ibGAHLzhOq4TT19Cx9yP4iQFXZ408QdKk05AVSse6IYOyMFzh
        A7AP4Ndot6KL3+PI+3uimy6eXx1PrJ2Rf/iufST1mA==
X-Google-Smtp-Source: ABdhPJxZT6ot/IRbzSDhxEEopdx454QnWK1oePLTWm48P9Js7gUl7Na5CK9zAGOuKBgVVFLly+DTXzFkqHk/TayAodY=
X-Received: by 2002:a05:651c:1612:b0:253:d535:d7c0 with SMTP id
 f18-20020a05651c161200b00253d535d7c0mr870589ljq.33.1652941901043; Wed, 18 May
 2022 23:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000056758e05d301dd90@google.com>
In-Reply-To: <00000000000056758e05d301dd90@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 May 2022 08:31:29 +0200
Message-ID: <CACT4Y+bRrWXYGgKdbK3AFQLNUumJbSzujEJ=+37dcDBjzJg72A@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in hci_inquiry_result_with_rssi_evt
To:     syzbot <syzbot+e3cad3a4e3f03bc00562@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        =?UTF-8?Q?Tam=C3=A1s_Koczka?= <poprdi@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 at 08:17, syzbot
<syzbot+e3cad3a4e3f03bc00562@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4eee8d0b64ec Add linux-next specific files for 20211208
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=130203e5b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20b74d9da4ce1ef1
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3cad3a4e3f03bc00562
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101eb355b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b8f805b00000
>
> The issue was bisected to:
>
> commit 3e54c5890c87a30b1019a3de9dab968ff2b21e06
> Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Date:   Wed Dec 1 18:55:03 2021 +0000
>
>     Bluetooth: hci_event: Use of a function table to handle HCI events
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=150100bab00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=170100bab00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=130100bab00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e3cad3a4e3f03bc00562@syzkaller.appspotmail.com
> Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")

Presumably this was fixed by Luiz's patch:
https://github.com/torvalds/linux/commit/72279d17df54d5e4e7910b39c61a3f3464e36633

Let's close on syzbot to get new reports in future:

#syz fix: Bluetooth: hci_event: Rework hci_inquiry_result_with_rssi_evt


> Bluetooth: hci0: unexpected cc 0x1001 length: 249 > 9
> Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > 4
> Bluetooth: hci0: unexpected cc 0x0c25 length: 249 > 3
> Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > 2
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 6545 Comm: kworker/u5:1 Not tainted 5.16.0-rc4-next-20211208-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: hci0 hci_rx_work
> RIP: 0010:hci_inquiry_result_with_rssi_evt+0xbc/0x970 net/bluetooth/hci_event.c:4520
> Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 88 07 00 00 48 8b 04 24 4c 8b 28 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 1b 07 00 00
> RSP: 0018:ffffc90001aafad0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff88807e754000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff883588a8 RDI: ffff88807e754000
> RBP: ffff88807e754000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff88376f27 R11: 0000000000000000 R12: ffff88807015eb40
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd653f7000 CR3: 0000000071f88000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  hci_event_func net/bluetooth/hci_event.c:6812 [inline]
>  hci_event_packet+0x817/0xe90 net/bluetooth/hci_event.c:6860
>  hci_rx_work+0x4fa/0xd30 net/bluetooth/hci_core.c:3817
>  process_one_work+0x9b2/0x1690 kernel/workqueue.c:2318
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2465
>  kthread+0x405/0x4f0 kernel/kthread.c:345
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> Modules linked in:
> ---[ end trace 403a15c54e29c5c4 ]---
> RIP: 0010:hci_inquiry_result_with_rssi_evt+0xbc/0x970 net/bluetooth/hci_event.c:4520
> Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 88 07 00 00 48 8b 04 24 4c 8b 28 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 4c 89 ea 83 e2 07 38 d0 7f 08 84 c0 0f 85 1b 07 00 00
> RSP: 0018:ffffc90001aafad0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff88807e754000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff883588a8 RDI: ffff88807e754000
> RBP: ffff88807e754000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff88376f27 R11: 0000000000000000 R12: ffff88807015eb40
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2bb803f018 CR3: 000000001d893000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 4 bytes skipped:
>    0:   48 c1 ea 03             shr    $0x3,%rdx
>    4:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)
>    8:   0f 85 88 07 00 00       jne    0x796
>    e:   48 8b 04 24             mov    (%rsp),%rax
>   12:   4c 8b 28                mov    (%rax),%r13
>   15:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   1c:   fc ff df
>   1f:   4c 89 ea                mov    %r13,%rdx
>   22:   48 c1 ea 03             shr    $0x3,%rdx
> * 26:   0f b6 04 02             movzbl (%rdx,%rax,1),%eax <-- trapping instruction
>   2a:   4c 89 ea                mov    %r13,%rdx
>   2d:   83 e2 07                and    $0x7,%edx
>   30:   38 d0                   cmp    %dl,%al
>   32:   7f 08                   jg     0x3c
>   34:   84 c0                   test   %al,%al
>   36:   0f 85 1b 07 00 00       jne    0x757
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
