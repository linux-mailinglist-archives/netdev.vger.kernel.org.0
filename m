Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3A57F41C
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiGXI2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGXI2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:28:24 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A3B1E8
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:28:22 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id b15-20020a92c56f000000b002dd2870c587so2367456ilj.20
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=siNdMcmVC1qeTk+B4F5oiCxVfKOp5O/Vi1z/Kzj7dHM=;
        b=3r/eOGBOF0eKrlxYyetdOWRtCErDutE3O/mOc+u0wI7KESdIltA06Z2RBXJO4SU7Zh
         X4stwWImLid5sBrU1dm1XNZK+C2n1nQTsgBHA+bmlopuXynS68cdR69+yrGWuuL1C6VT
         wRCWq8/nuoHwZFT0fCf0nkzvP/UINWwNEVGaM6AjJZI76KaniiBg0/dL7nQWb5GIAU6l
         lwzutujuF6HJbKbXG161sc4xhcw+dy6UvmFA/4IJmJTayMqNJGr+wwR7WJWwuUfgIlWz
         ILqgLByaKDeravBERdaTu6w0pjWivceDiRPNH4x/l9WIfisfQzKU0TBX1h+Qj+9A11qg
         4oXQ==
X-Gm-Message-State: AJIora/iDC7U+XAkzgrtr2wsTgpbW57AChdvX48LYtldBYAV+c80JeC3
        fmt7GgwItvTRCsbCqB04EcFkd0z5MdyUAIpBEHeGh5Us99SM
X-Google-Smtp-Source: AGRyM1uGd9OBXtc0p0/1RqGf8T8rg3nLMfi8PXAhc6xK5yfQmQ85b1uF9FpNl81Z6HQczKkJ1DqoA4VoOjTpCjCT1HxtwbABIo6x
MIME-Version: 1.0
X-Received: by 2002:a6b:2a42:0:b0:67c:5ab8:a34e with SMTP id
 q63-20020a6b2a42000000b0067c5ab8a34emr2408381ioq.143.1658651302109; Sun, 24
 Jul 2022 01:28:22 -0700 (PDT)
Date:   Sun, 24 Jul 2022 01:28:22 -0700
In-Reply-To: <00000000000011f0c905d9097a62@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab295405e488d921@google.com>
Subject: Re: [syzbot] WARNING in p9_client_destroy
From:   syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, k.kahurani@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
        lucho@ionkov.net, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    cb71b93c2dc3 Add linux-next specific files for 20220628
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=106a4022080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
dashboard link: https://syzkaller.appspot.com/bug?extid=5e28cdb7ebd0f2389ca4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156f74ee080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com

------------[ cut here ]------------
kmem_cache_destroy 9p-fcall-cache: Slab cache still has objects when called from p9_client_destroy+0x213/0x370 net/9p/client.c:1100
WARNING: CPU: 0 PID: 3687 at mm/slab_common.c:505 kmem_cache_destroy mm/slab_common.c:505 [inline]
WARNING: CPU: 0 PID: 3687 at mm/slab_common.c:505 kmem_cache_destroy+0x138/0x140 mm/slab_common.c:493
Modules linked in:
CPU: 1 PID: 3687 Comm: syz-executor.0 Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:kmem_cache_destroy mm/slab_common.c:505 [inline]
RIP: 0010:kmem_cache_destroy+0x138/0x140 mm/slab_common.c:493
Code: 95 18 00 48 89 ef e8 07 96 18 00 eb cc c3 48 8b 55 60 48 c7 c6 80 da d7 89 48 c7 c7 88 e8 61 8b 48 8b 4c 24 18 e8 f2 3a 86 07 <0f> 0b eb ab 0f 1f 40 00 41 56 41 89 d6 41 55 49 89 f5 41 54 49 89
RSP: 0018:ffffc900034efcf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff9200069dfa5 RCX: 0000000000000000
RDX: ffff88807513ba80 RSI: ffffffff81610608 RDI: fffff5200069df90
RBP: ffff88801f0cc8c0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffffc900034efd68 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000555556019400(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe57b1fe718 CR3: 00000000728bc000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 p9_client_destroy+0x213/0x370 net/9p/client.c:1100
 v9fs_session_close+0x45/0x2d0 fs/9p/v9fs.c:504
 v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:226
 deactivate_locked_super+0x94/0x160 fs/super.c:332
 deactivate_super+0xad/0xd0 fs/super.c:363
 cleanup_mnt+0x3a2/0x540 fs/namespace.c:1186
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe57ba8a677
Code: ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff19aa4578 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fe57ba8a677
RDX: 00007fff19aa464c RSI: 000000000000000a RDI: 00007fff19aa4640
RBP: 00007fff19aa4640 R08: 00000000ffffffff R09: 00007fff19aa4410
R10: 000055555601a8b3 R11: 0000000000000246 R12: 00007fe57bae22a6
R13: 00007fff19aa5700 R14: 000055555601a810 R15: 00007fff19aa5740
 </TASK>

