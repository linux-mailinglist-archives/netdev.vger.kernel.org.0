Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5196662E57
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjAISKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbjAISJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:09:12 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D795CE1F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:08:45 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so6575006ilu.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NNbXfP3zZE+WclPy0AUqx7K6Aj2YoB9mgrIl7FBGaA8=;
        b=oYuDfIFdqxtyfaySsGvFQTQl7qt4Az3Ve4i963Ac1iCWX4Zj8TLYiAPTGFJOk46AgE
         4yxK2LKEuKn3ajq3OLQ3G2rR/Sk4Pfayx11tVPYG1kIJhVPuKTlN/5GL2yQFC2eiN9ei
         mFNMuuInAM0LrbZsMsVMdQSxNhzjYtnye/LIMyZGKym4576/JUHBZ68zX6dqGNy9Wt9w
         /jElE0eizBjR8Y8WmplGzzmU6m3Df+fRODmRnqyjIaSq/uwzZ2q94jsZp80SDll9v+Dw
         jnl0SnV82DaMQVdQlgZbNf6eeobuiKgGZOb++ZF4Uiwkc54OM5hbQCLdhLjM8dbH9/lG
         0wFQ==
X-Gm-Message-State: AFqh2krWG1HYKR+9ATLUMeH4TvQ1QaRP6WVUgQArRKx4cEgAzgtLgkx1
        KJEzh5tn6jKOaCKQQabxIx0+rfOIo60/iklY2AOGV/HUyv2h
X-Google-Smtp-Source: AMrXdXvpkKHHLqMZbhOHmwj6pgsDhxLa3dTss5kkOXIwr7JIziW6loNqGp1TbGtJjDKT2ofkUqryDL9mwDzOK776WAYxRd+MtrtH
MIME-Version: 1.0
X-Received: by 2002:a6b:7a0a:0:b0:6e9:b3db:b5ce with SMTP id
 h10-20020a6b7a0a000000b006e9b3dbb5cemr5861411iom.179.1673287725171; Mon, 09
 Jan 2023 10:08:45 -0800 (PST)
Date:   Mon, 09 Jan 2023 10:08:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000774b9205f1d8a80d@google.com>
Subject: [syzbot] WARNING in bpf_xdp_adjust_tail (4)
From:   syzbot <syzbot+f817490f5bd20541b90a@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        haoluo@google.com, hawk@kernel.org, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, yhs@fb.com
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

Hello,

syzbot found the following issue on:

HEAD commit:    fe69230f0589 caif: fix memory leak in cfctrl_linkup_reques..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=135e909a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ca07260bb631fb4
dashboard link: https://syzkaller.appspot.com/bug?extid=f817490f5bd20541b90a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a3f770480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d48034480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/50a413c711d8/disk-fe69230f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b754ff4c853/vmlinux-fe69230f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1cef7470412e/bzImage-fe69230f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f817490f5bd20541b90a@syzkaller.appspotmail.com

------------[ cut here ]------------
Too BIG xdp->frame_sz = 131072
WARNING: CPU: 1 PID: 5082 at net/core/filter.c:4065 ____bpf_xdp_adjust_tail net/core/filter.c:4065 [inline]
WARNING: CPU: 1 PID: 5082 at net/core/filter.c:4065 bpf_xdp_adjust_tail+0x461/0x9a0 net/core/filter.c:4047
Modules linked in:
CPU: 1 PID: 5082 Comm: syz-executor157 Not tainted 6.1.0-syzkaller-04386-gfe69230f0589 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:____bpf_xdp_adjust_tail net/core/filter.c:4065 [inline]
RIP: 0010:bpf_xdp_adjust_tail+0x461/0x9a0 net/core/filter.c:4047
Code: ff 89 de e8 11 74 af f9 84 db 0f 85 59 fd ff ff e8 94 77 af f9 89 ee 48 c7 c7 c0 df 5b 8b c6 05 9c dc 8b 06 01 e8 9f 37 ed 01 <0f> 0b e9 38 fd ff ff e8 43 78 fd f9 e9 64 fc ff ff e8 39 78 fd f9
RSP: 0018:ffffc90003baf8f0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888029903a80 RSI: ffffffff8166721c RDI: fffff52000775f10
RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000200 R11: 0000000000000000 R12: ffffffffffffffea
R13: ffff888076aafeef R14: 0000000000000000 R15: ffffc90003bafaa8
FS:  00005555573ed300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020011000 CR3: 000000007daac000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bpf_prog_4add87e5301a4105+0x1a/0x1c
 __bpf_prog_run include/linux/filter.h:600 [inline]
 bpf_prog_run_xdp include/linux/filter.h:775 [inline]
 bpf_prog_run_generic_xdp+0x578/0x11e0 net/core/dev.c:4752
 netif_receive_generic_xdp+0x2e8/0x930 net/core/dev.c:4838
 do_xdp_generic net/core/dev.c:4897 [inline]
 do_xdp_generic+0x9a/0x1b0 net/core/dev.c:4890
 tun_get_user+0x21ae/0x3870 drivers/net/tun.c:1913
 tun_chr_write_iter+0xdf/0x200 drivers/net/tun.c:2029
 call_write_iter include/linux/fs.h:2186 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9ed/0xdd0 fs/read_write.c:584
 ksys_write+0x12b/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f4723af0c33
Code: 5d 41 5c 41 5d 41 5e e9 9b fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
RSP: 002b:00007ffee97bbf18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007ffee97bbf40 RCX: 00007f4723af0c33
RDX: 000000000000fdef RSI: 0000000020001600 RDI: 00000000000000c8
RBP: 00007ffee97bbfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffee97bbf50 R14: 00007ffee97bbf70 R15: 00007ffee97bbf38
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
