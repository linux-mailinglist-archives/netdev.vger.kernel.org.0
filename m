Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0247B65CCA7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 06:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjADFtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 00:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjADFtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 00:49:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EFD12ABD;
        Tue,  3 Jan 2023 21:49:17 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y19so15866682plb.2;
        Tue, 03 Jan 2023 21:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRMw8YkC5GelsjQ4ctotZvX3YoYc/cuIsgMIf/atSNM=;
        b=WuPwvqLMNp2AUFqtp6Gx344uu8xMaM11JafDxYik4oC1rFztm4+mEoXE5etZQlqZe1
         S0Obrq0JTrLe7WrSJsE1Cp9YJYfSAuXrUwxgPZPwAu6LrltAFCd9qdQRCh7ugpcrezc9
         922OJMxIdXsH/LRc2FyLnpHPtUTm8GBcbBIfbOa4RYvwsXyIgVWYZ+/rNNrncZq4rup+
         AsZYSCdNPw6DfScWoAlp2x7zZIm3iT2PVnNGfoC+D3Irn6MHhdIrlCLbFFMpyKn4D9y+
         zcWV3XAD7/TCwCAby1GOHceeOAmTTHrBjAjW3Po428qAkoKdiKGmkKsqQLURWBJCopZL
         vhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRMw8YkC5GelsjQ4ctotZvX3YoYc/cuIsgMIf/atSNM=;
        b=7X65Tag0IxYPseG8PkmVrEW4HDCejjwj1ndjQLVTAndJieANeaVqZgt49qLGtHouXO
         T+GgSLtgInZg48co0znw336Q97sNxb0iDuMl4HpWKdGUMqs9w3T4jihtjVbEM6LH6H9J
         BWoLd+QODOziDW2YvFKCvvVDd5+SL8pplXf6CDxmrqQzgG8HXLllfuya1386r1CI/9qy
         LTU3vQ0k31BjYKkheacM1hJGo6BHsgA9jkXupPJhG8LWA1uQUdqC08b8UO+Nai0ToJZa
         jUvbGm2Di1COWz0jjHFseWkMPi5y3OC2g0qmeMKispf5EH+Ab9NIgB8N7NFmfWwHSC4P
         jrhA==
X-Gm-Message-State: AFqh2kq0hS+p3JgsUhtReH87Ns+Ua9SvKfFpx2qPoK0mv8rCzDOpCoFi
        EprKVfhaunnLn2vmQtuLU90agiZXC7wev9fL
X-Google-Smtp-Source: AMrXdXtUyjz7QT66TpEEs6imNzXTxAIEztWI0yJPeAWh8FrwYr1KIrupOvmY1bh+Ft1iI/+b/q6G+A==
X-Received: by 2002:a17:903:40c2:b0:192:b93a:6cdb with SMTP id t2-20020a17090340c200b00192b93a6cdbmr15634189pld.64.1672811356657;
        Tue, 03 Jan 2023 21:49:16 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b00192aa53a7d5sm10084790plg.8.2023.01.03.21.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 21:49:15 -0800 (PST)
Date:   Mon, 19 Dec 2022 10:46:47 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, bobby.eshleman@gmail.com
Subject: Re: [syzbot] kernel BUG in vhost_vsock_handle_tx_kick
Message-ID: <Y6A/Yyoh2uZSR0xj@bullseye>
References: <0000000000003a68dc05f164fd69@google.com>
 <Y7T+xTIq2izSlHHE@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7T+xTIq2izSlHHE@pop-os.localdomain>
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 08:21:25PM -0800, Cong Wang wrote:
> On Tue, Jan 03, 2023 at 04:08:51PM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c76083fac3ba Add linux-next specific files for 20221226
> > git tree:       linux-next
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1723da42480000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c217c755f1884ab6
> > dashboard link: https://syzkaller.appspot.com/bug?extid=30b72abaa17c07fe39dd
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fc414c480000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1604b20a480000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/e388f26357fd/disk-c76083fa.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/e24f0bae36d5/vmlinux-c76083fa.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/a5a69a059716/bzImage-c76083fa.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com
> 
> +bobby.eshleman@gmail.com
> 
> Bobby, please take a look.
> 
> Thanks.

Roger that, I'll take a gander asap.

> 
> > 
> > skbuff: skb_over_panic: text:ffffffff8768d6f1 len:25109 put:25109 head:ffff88802b5ac000 data:ffff88802b5ac02c tail:0x6241 end:0xc0 dev:<NULL>
> > ------------[ cut here ]------------
> > kernel BUG at net/core/skbuff.c:121!
> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 5072 Comm: vhost-5071 Not tainted 6.2.0-rc1-next-20221226-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:121
> > Code: f7 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 04 5b 8b ff 74 24 10 ff 74 24 20 e8 09 8e bf ff <0f> 0b e8 1a 67 82 f7 4c 8b 64 24 18 e8 80 3d d0 f7 48 c7 c1 40 12
> > RSP: 0018:ffffc90003cefca0 EFLAGS: 00010282
> > RAX: 000000000000008d RBX: ffff88802b674500 RCX: 0000000000000000
> > RDX: ffff8880236bba80 RSI: ffffffff81663b9c RDI: fffff5200079df86
> > RBP: ffffffff8b5b1280 R08: 000000000000008d R09: 0000000000000000
> > R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8768d6f1
> > R13: 0000000000006215 R14: ffffffff8b5b0400 R15: 00000000000000c0
> > FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020000380 CR3: 000000002985f000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  skb_over_panic net/core/skbuff.c:126 [inline]
> >  skb_put.cold+0x24/0x24 net/core/skbuff.c:2218
> >  virtio_vsock_skb_rx_put include/linux/virtio_vsock.h:56 [inline]
> >  vhost_vsock_alloc_skb drivers/vhost/vsock.c:374 [inline]
> >  vhost_vsock_handle_tx_kick+0xad1/0xd00 drivers/vhost/vsock.c:509
> >  vhost_worker+0x241/0x3e0 drivers/vhost/vhost.c:364
> >  kthread+0x2e8/0x3a0 kernel/kthread.c:376
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:121
> > Code: f7 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 04 5b 8b ff 74 24 10 ff 74 24 20 e8 09 8e bf ff <0f> 0b e8 1a 67 82 f7 4c 8b 64 24 18 e8 80 3d d0 f7 48 c7 c1 40 12
> > RSP: 0018:ffffc90003cefca0 EFLAGS: 00010282
> > RAX: 000000000000008d RBX: ffff88802b674500 RCX: 0000000000000000
> > RDX: ffff8880236bba80 RSI: ffffffff81663b9c RDI: fffff5200079df86
> > RBP: ffffffff8b5b1280 R08: 000000000000008d R09: 0000000000000000
> > R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8768d6f1
> > R13: 0000000000006215 R14: ffffffff8b5b0400 R15: 00000000000000c0
> > FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fdc6f4a4298 CR3: 000000002985f000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
