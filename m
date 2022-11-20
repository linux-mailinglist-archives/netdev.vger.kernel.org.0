Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735166311FF
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 01:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKTACG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 19:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiKTABw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 19:01:52 -0500
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA92A165A8;
        Sat, 19 Nov 2022 16:01:47 -0800 (PST)
Date:   Sun, 20 Nov 2022 00:01:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n8pjl.ca;
        s=protonmail; t=1668902501; x=1669161701;
        bh=lvzGxYQdIo6DToOuBILM9gN0gZvQcQ+reM0/jv620qw=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=slKxsVaLdg8gvQ2+rTPW+9hG8eGAOdJ2qlNJCWCKjtgce7sCcDjsftS0IRha5cgjv
         EHB0ik2GjopNoLHPgb2xECbZLEX4d3uRkU2eELjRc2o/0BqRBSbbWRSgLCZEfnh0Xs
         yPSBIB/WipNjozeS/jd3hzbIED7GklQQlvlN8kmN7WxJkTHV02QQEAkxQ2eaBXfmC4
         KjCbkwoFQMAzLwlXplx4wgX16nJlWG/HWundIObJ1f5Yr09TBgf96grrsbnd0iZ8PX
         On8ZD9tV3Sak6fBnaikT6T1+wXJTdkVHpETC6lqZc156ZgLjKIp5EhOEK6QpUYt3VI
         l8fPy/D22jC8Q==
To:     syzbot <syzbot+4643bc868f47ad276452@syzkaller.appspotmail.com>
From:   Peter Lafreniere <peter@n8pjl.ca>
Cc:     davem@davemloft.net, edumazet@google.com, jreuter@yaina.de,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in ax25_send_frame (2)
Message-ID: <_EStAmQIIbOHjwEqqb54KlnJy9ltngO0A__i8T4sJISE0rRSCaa8TlYBrwJ9AJPxJtrp27MNaXRISYfABlCoIWA1bze3-o2Oblw7PcCdxM4=@n8pjl.ca>
In-Reply-To: <000000000000da093705edbd2ca4@google.com>
References: <000000000000da093705edbd2ca4@google.com>
Feedback-ID: 53133685:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In response to the following syzbot report:

> general protection fault, probably for non-canonical address 0xdffffc0000=
00006c: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000360-0x0000000000000367]
> CPU: 1 PID: 10715 Comm: syz-executor.3 Not tainted 6.0.0-rc4-syzkaller-00=
136-g0727a9a5fbc1 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 08/26/2022
> RIP: 0010:ax25_dev_ax25dev include/net/ax25.h:342 [inline]
> RIP: 0010:ax25_send_frame+0xe4/0x640 net/ax25/ax25_out.c:56
> Code: 00 48 85 c0 49 89 c4 0f 85 fb 03 00 00 e8 34 cb 2b f9 49 8d bd 60 0=
3 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f=
 85 b1 04 00 00 4d 8b ad 60 03 00 00 4d 85 ed 0f 84
>=20
> RSP: 0000:ffffc90004c77a00 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffff88814a308008 RCX: 0000000000000100
> RDX: 000000000000006c RSI: ffffffff88503efc RDI: 0000000000000360
> RBP: ffffffff91561460 R08: 0000000000000001 R09: ffffffff908e4a9f
> R10: 0000000000000001 R11: 1ffffffff2020d9a R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000104 R15: 0000000000000000
> FS: 0000555556215400(0000) GS:ffff8880b9b00000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f328000 CR3: 0000000050a64000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
>
> rose_send_frame+0xcc/0x2f0 net/rose/rose_link.c:106
> rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
> rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
> rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
> call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> expire_timers kernel/time/timer.c:1519 [inline]
> __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> __run_timers kernel/time/timer.c:1768 [inline]
> run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> [...]
> </TASK>

The null dereference in ax25_dev_ax25dev() must be from a null struct
net_device* dev being passed to ax25_send_frame(). By tracing the call stac=
k,
the null pointer can be shown as coming from the dev field of
rose_loopback_neigh being null.

The null dereference was already mitigated with a fail-silent check by
commit e97c089d7a49 ("rose: Fix NULL pointer dereference in rose_send_frame=
()")
in response to a previous syzbot report "general protection fault in=20
rose_send_frame (2)", which was not closed.

Does anyone object to marking syzbot bugs
"general protection fault in {ax25|rose}_send_frame (2)"
as fixed?

Respectfully,
Peter Lafreniere (N8PJL)

