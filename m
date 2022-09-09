Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BA35B2D50
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 06:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiIIETo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 00:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIIETg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 00:19:36 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B61E2677
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 21:19:25 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id z9-20020a921a49000000b002f0f7fb57e3so407781ill.2
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 21:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=JbsBL1c3AkZtVs4/cSEGc5hTtYMUj0g0hX9Fbt9+yjg=;
        b=eAAliiEKrtk302hdUy0wOo/fFvRPuyEDGyzxRIkcCuO7YS3SBcytc+AHmSJBzTVRIx
         w7E8lyq2uq3JtnQp/wFvbMvmmjaJdgwKRFOtugL/sLrsKfpGwES6NplLlskHC+3tlWdq
         YuTiV+yhP4JMwKXTer/6yy7Sj4bSwZeJaIfp0JX2g1tTa3V1w6BC3dn4kMu3y+VztMNH
         jUbxo7AxkEIN7tohohVmzPLy5+ott6MMzlYbFs0/j7gkVQ2rQO7BJVWzRnSnzzGJ7f44
         g/W6Aqtim8SrHNsBZf6yH2VDFikNBwmohYsRJUEAZB5PSiOkjXtE1rGds/UGCmINr5v/
         gTrQ==
X-Gm-Message-State: ACgBeo2nnmMqBw7piP9ecwrCrbwVDdmT34HvrB8rTocMqR/vpOr5baFl
        rwjMAHMVNd5rivbMbrbZQPmXK7YXa0IXhDvchW4VhmHl5X99
X-Google-Smtp-Source: AA6agR479dFZN40nHgHFqZhh2nj8Ibx3ZY9wf4YJrUbXeDaPLOwtxaKkASsbh6S5hVwVKtnImhn9pRjFGROqLGLqB+iHVcVMZOUr
MIME-Version: 1.0
X-Received: by 2002:a02:b001:0:b0:358:2f68:8a07 with SMTP id
 p1-20020a02b001000000b003582f688a07mr5056754jah.280.1662697165094; Thu, 08
 Sep 2022 21:19:25 -0700 (PDT)
Date:   Thu, 08 Sep 2022 21:19:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e506e905e836d9e7@google.com>
Subject: [syzbot] WARNING in bpf_verifier_vlog
From:   syzbot <syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, trix@redhat.com,
        yhs@fb.com
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

HEAD commit:    7e18e42e4b28 Linux 6.0-rc4
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1551da55080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4d613baa509128c
dashboard link: https://syzkaller.appspot.com/bug?extid=8b2a08dfbd25fd933d75
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1798cab7080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ccbdc5080000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da260c675b46/disk-7e18e42e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58f7bbbaa6ff/vmlinux-7e18e42e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com

------------[ cut here ]------------
verifier log line truncated - local buffer too short
WARNING: CPU: 1 PID: 3604 at kernel/bpf/verifier.c:300 bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
Modules linked in:
CPU: 1 PID: 3604 Comm: syz-executor146 Not tainted 6.0.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
Code: f5 95 3d 0c 31 ff 89 ee e8 06 07 f0 ff 40 84 ed 75 1a e8 7c 0a f0 ff 48 c7 c7 c0 e7 f3 89 c6 05 d4 95 3d 0c 01 e8 fb 4c ae 07 <0f> 0b e8 62 0a f0 ff 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1
RSP: 0018:ffffc900039bf8a0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff888017a19210 RCX: 0000000000000000
RDX: ffff888021fb1d80 RSI: ffffffff8161f408 RDI: fffff52000737f06
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff89f5aba0
R13: 00000000000003ff R14: ffff888017a19214 R15: ffff888012705800
FS:  0000555555cba300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020100000 CR3: 000000001bf9e000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __btf_verifier_log+0xbb/0xf0 kernel/bpf/btf.c:1375
 __btf_verifier_log_type+0x451/0x8f0 kernel/bpf/btf.c:1413
 btf_func_proto_check_meta+0x117/0x160 kernel/bpf/btf.c:3905
 btf_check_meta kernel/bpf/btf.c:4588 [inline]
 btf_check_all_metas+0x3c1/0xa70 kernel/bpf/btf.c:4612
 btf_parse_type_sec kernel/bpf/btf.c:4748 [inline]
 btf_parse kernel/bpf/btf.c:5031 [inline]
 btf_new_fd+0x939/0x1e70 kernel/bpf/btf.c:6710
 bpf_btf_load kernel/bpf/syscall.c:4314 [inline]
 __sys_bpf+0x13bd/0x6130 kernel/bpf/syscall.c:4998
 __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb092221c29
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff5b0a6878 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb092221c29
RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000012
RBP: 00007fb0921e5dd0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb0921e5e60
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
