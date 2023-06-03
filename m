Return-Path: <netdev+bounces-7643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1957720EE5
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 11:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6D511C20DDB
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293C8BA38;
	Sat,  3 Jun 2023 09:21:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D3EA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 09:21:46 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B011BB;
	Sat,  3 Jun 2023 02:21:44 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-ba8cd61ee2dso6318899276.1;
        Sat, 03 Jun 2023 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685784104; x=1688376104;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hfpl/xEXY9XzcbX8+XTKxz2NUoxhZKb5w5NqsqdPcck=;
        b=PMRgxj0+wOtz4czUmFw5meTwj+yS4Ir0xmOMBodlGKmO0ymGT4gzdEpZz5sAmNefE+
         Yxs4fuDd4Pc3fEczzxm/iALi5F+hXvjVMl5YMEYSpbO7mKJ5sKOUJc/OgWtjYjFDobHn
         AqsRI9SzQWdcRMLXv2DipvgRDNTobF1C69X+fCbuaTOqOntMqxpGfJikwMyvm3g2uAbS
         qGZYutaUmptZFGanV463KtRj7hncvQQO95c7DdcV7hajsLUBnlAKTXz25PVl+u1RTp/Z
         tyCq096qfCWCmWEiTexeMifBviVXviEvgs9a16x+bcofqk8U2kmoYx1oaxIsPk96hxnj
         JQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685784104; x=1688376104;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hfpl/xEXY9XzcbX8+XTKxz2NUoxhZKb5w5NqsqdPcck=;
        b=QzIx0zx2VwEpjHurquP4w537s4VuqHkn+6/pH9IBifZqacm+YAsxN6eKyB6MnDY044
         MjVgUcvJi/9lb5UDn47IjSn1gG1eSHrlXtONVt20CXrLTOUZofx3ixpbAdtUQtfR9JYc
         5NlbsxD1bPCnUKvM/nLrRd4MKcUlc/DlX9RBLQ0HlYlGsxUxNythfDAcgrd1ZMH4N6hh
         e6by6NH8WTq9rzq0bZiTxr4axiNrDeAUL9hJs0olx4WgoOkdzGe9GkGmPXK03PFQuubR
         mJADo0gAWL17RdQDLEqlpglCEg0v2T6EUbgotJ5uU74zRd6i5l7LZki5C08JKmU6Wsye
         Q28w==
X-Gm-Message-State: AC+VfDzQzxWXud8EtiwE3bUymZDEE5CUxLTWltMkeml6yDWRkKIC0mzz
	C37aCent0bQIJIyuNpN63dTjAFsqvSWye8KKtSE=
X-Google-Smtp-Source: ACHHUZ5WZxK9N6zZ4x1i0oum6PijbBoTJPqv/rAdG/l4p2zYnnUaxAJYdr0C1viKyiPJM3EXgAUNbY2/M9WMmK6ze7A=
X-Received: by 2002:a0d:db4f:0:b0:565:85b0:c128 with SMTP id
 d76-20020a0ddb4f000000b0056585b0c128mr3074712ywe.6.1685784103915; Sat, 03 Jun
 2023 02:21:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Palash Oswal <oswalpalash@gmail.com>
Date: Sat, 3 Jun 2023 02:21:32 -0700
Message-ID: <CAGyP=7ff859GTfM+Va5V4ugB7T-cuDxw4ir75MKLGQVAaSxBLw@mail.gmail.com>
Subject: KASAN: stack-out-of-bounds Read in scm_recv
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,
I found the following issue using syzkaller with enriched corpus[1] on:
HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
git tree: linux
C Reproducer : I do not have a C reproducer yet. I will update this
thread when I get one.
Kernel .config :
https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f

Link:
1. https://github.com/cmu-pasta/linux-kernel-enriched-corpus

Console log :
==================================================================
BUG: KASAN: stack-out-of-bounds in scm_recv.constprop.0+0x5b6/0x5c0
Read of size 8 at addr ffffc90003fcf948 by task syz-executor.2/18043

CPU: 0 PID: 18043 Comm: syz-executor.2 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xd9/0x150
 print_address_description.constprop.0+0x2c/0x3c0
 kasan_report+0x11c/0x130
 scm_recv.constprop.0+0x5b6/0x5c0
 __unix_dgram_recvmsg+0x824/0xb90
 unix_dgram_recvmsg+0xc4/0xf0
 ____sys_recvmsg+0x49c/0x5a0
 ___sys_recvmsg+0xf2/0x180
 do_recvmmsg+0x25e/0x6e0
 __x64_sys_recvmmsg+0x20f/0x260
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f17a168eacd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f17a2398bf8 EFLAGS: 00000246
 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007f17a17bc050 RCX: 00007f17a168eacd
RDX: 0000000000010106 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007f17a16fcb05 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdf09e0a3f R14: 00007ffdf09e0be0 R15: 00007f17a2398d80
 </TASK>

The buggy address belongs to stack of task syz-executor.2/18043
KASAN internal error: frame info validation failed; invalid marker: 0
The buggy address belongs to the virtual mapping at
 [ffffc90003fc8000, ffffc90003fd1000) created by:
 kernel_clone+0xeb/0x890

The buggy address belongs to the physical page:
page:ffffea00042a9800 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x10aa60
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask
0x2dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_ZERO), pid 31, tgid
31 (kworker/u6:1), ts 269514464150, free_ts 269297799927
 get_page_from_freelist+0x1190/0x2e20
 __alloc_pages+0x1cb/0x4a0
 alloc_pages+0x1aa/0x270
 __vmalloc_node_range+0xb1c/0x14a0
 copy_process+0x1320/0x7590
 kernel_clone+0xeb/0x890
 user_mode_thread+0xb1/0xf0
 call_usermodehelper_exec_work+0xd0/0x180
 process_one_work+0x991/0x15c0
 worker_thread+0x669/0x1090
 kthread+0x2e8/0x3a0
 ret_from_fork+0x1f/0x30
page last free stack trace:
 0x10e9caa858
 0x435023b
 0x10e9caa858
 0xffffffff0435023b
 release_pages+0xcd7/0x1380
 tlb_batch_pages_flush+0xa8/0x1a0
 release_pages+0xcd7/0x1380
 tlb_batch_pages_flush+0xa8/0x1a0
 __mmput+0x128/0x4c0
mmput+0x60/0x70
 __mmput+0x128/0x4c0
 mmput+0x60/0x70
 get_signal+0x2315/0x25b0
 arch_do_signal_or_restart+0x79/0x5c0
 get_signal+0x2315/0x25b0
 arch_do_signal_or_restart+0x79/0x5c0
 do_syscall_64+0x46/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 do_syscall_64+0x46/0xb0
 0x8a20008b
 0xef5794dbf
 0x43f023b
 0xef5794dbf
 0xffffffff043f023b
 tlb_finish_mmu+0x1a7/0x7e0
 exit_mmap+0x2ac/0x7f0
 tlb_finish_mmu+0x1a7/0x7e0
 exit_mmap+0x2ac/0x7f0
 do_exit+0x9d7/0x2960
 do_group_exit+0xd4/0x2a0
 do_exit+0x9d7/0x2960
 do_group_exit+0xd4/0x2a0
 exit_to_user_mode_prepare+0x11f/0x240
 syscall_exit_to_user_mode+0x1d/0x50
 exit_to_user_mode_prepare+0x11f/0x240
 syscall_exit_to_user_mode+0x1d/0x50
 0x0
 0xffffffff00000000
 0x0
 0x0
 kasan_save_stack+0x22/0x40
 0x81d1e785
 kasan_save_stack+0x22/0x40

