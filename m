Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FDE2FDF27
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404549AbhATXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403902AbhATXV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 18:21:28 -0500
Received: from mail-io1-xd47.google.com (mail-io1-xd47.google.com [IPv6:2607:f8b0:4864:20::d47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02762C061344
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:09:24 -0800 (PST)
Received: by mail-io1-xd47.google.com with SMTP id g7so306849ion.21
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 15:09:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=R7f0wyeTmA8SuzS7SzFRcl7d6pcYrpva5Er826cs0mk=;
        b=jCSr/3HcJ/ZWX3kKHB84eoibrMvqEBGVlsIynWzuoWK5opf9z43drCBvPehC4ij060
         HLy+x5BnKPkGO/zZqrbkYLKByaNbeoWVsAHg4hXyd4ib7DP8BfaNaRP1bfTuWRLttCiI
         AJjVJlLGw90wOW4/PlShNGVxBDIfugEwfi1UGPKH2c9zDD0kSVAmrjT7Ywi/HXztmyde
         0cHsZiN++vHdRcGkRU82TVmm7Sl5J0NQR6sm5TqTxuTiOWDjNlG+ykVbQTBi0PTMVefG
         m7GJpGwQj3AR0WtT39+dIXJHrh31j1qJnjiPxA13j52GI2BSG6VccHDRJ25+ulwlf/G8
         oWyA==
X-Gm-Message-State: AOAM532uXxkGBWafsPvETDeTtLul8KPVU6VF8fiW5ubXrZ6bAYIVN5+x
        20bAMVqUnEgkGv1w4cMMZ7xQyDDGBfalDiIFmYwStHSj5Wa3
X-Google-Smtp-Source: ABdhPJxx2Xjf/dKON/ViEpmZc8PUt27XQ8dLVFZm99Cd4bahkiaTQz/OYrK11/5lcTf3YlyNrJDROGRVOWMdRKnpf8k2rzjcSkae
MIME-Version: 1.0
X-Received: by 2002:a92:c986:: with SMTP id y6mr10047061iln.125.1611184164069;
 Wed, 20 Jan 2021 15:09:24 -0800 (PST)
Date:   Wed, 20 Jan 2021 15:09:24 -0800
In-Reply-To: <000000000000c8dd4a05b828d04c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c464f805b95d0bb2@google.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run7
From:   syzbot <syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7d68e382 bpf: Permit size-0 datasec
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1418c3c7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
dashboard link: https://syzkaller.appspot.com/bug?extid=fad5d91c7158ce568634
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1224daa4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dfabd0d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in __bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_trace_run7+0x411/0x420 kernel/trace/bpf_trace.c:2130
Read of size 8 at addr ffffc90000e5c030 by task syz-executor460/8508

CPU: 1 PID: 8508 Comm: syz-executor460 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 __bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
 bpf_trace_run7+0x411/0x420 kernel/trace/bpf_trace.c:2130
 __bpf_trace_percpu_alloc_percpu+0x1dc/0x220 include/trace/events/percpu.h:10
 __traceiter_percpu_alloc_percpu+0x97/0xf0 include/trace/events/percpu.h:10
 trace_percpu_alloc_percpu include/trace/events/percpu.h:10 [inline]
 pcpu_alloc+0xba6/0x16f0 mm/percpu.c:1844
 bpf_prog_alloc+0x78/0x250 kernel/bpf/core.c:117
 bpf_prog_load+0x656/0x1f40 kernel/bpf/syscall.c:2152
 __do_sys_bpf+0x1251/0x4f00 kernel/bpf/syscall.c:4380
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441659
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffebad746f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441659
RDX: 0000000000000078 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 000000000001191b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402470
R13: 0000000000402500 R14: 0000000000000000 R15: 0000000000000000


Memory state around the buggy address:
 ffffc90000e5bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e5bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc90000e5c000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                     ^
 ffffc90000e5c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e5c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================

