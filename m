Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9C4B03A4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiBJC7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:59:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiBJC7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:59:22 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581712487F
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 18:59:24 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id g14-20020a056e021e0e00b002a26cb56bd4so2975910ila.14
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 18:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=S1BNNgshEPWXG4irPyuOKxOVu/jqB12cTyepgh3rjw8=;
        b=ordwpYPd+Vq6RyNAhQpdP7XAOnWL1rVlaHABmaxtQDg6gnwZVOXrNh5Cw9lBZHyUUU
         XML6++S0Mq32we71/hl+ERaYCjbsOXfg6xlTHy1XH78rHeHLmZSh9GSQaX/Sjoqz1BMV
         PWkvG5lPFrIhJi8nofQyYxrjDuIhsAJHh3u2+6CVWDKdFidvDEzPIFYJiOSDFwm0dROb
         VetBWEN8WIbqPA0XkkFgpEjsggJVnldag+80P2T7WcYYWDrMfkD4iBa2mz6pMEBzanOf
         e29+U2807CblxsITP6tY9H+8OtpwcSNDVR/HmAjymqngjghtIqobFdlO2+29820vXCtP
         fqwg==
X-Gm-Message-State: AOAM530Pm8Zk34VKbLeRZtSeQlQzZ3vjcREjhcsySnqAE2zRlgyXsDg0
        WD5kZCMDXk8cg1zTBfl4kRstFX2JTiudTTjuJoZc8mo/KJL/
X-Google-Smtp-Source: ABdhPJxmKe52Zn6Gp/x+5e0cXt2LQ7ZReqON7Q2jw4jDUel3bcxRFG+bWCzk5PMk+Dl64tmZZkI0PhN+MVpY0jd8zxYKMuPiUYBY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4cd:: with SMTP id f13mr2987757ils.246.1644461963335;
 Wed, 09 Feb 2022 18:59:23 -0800 (PST)
Date:   Wed, 09 Feb 2022 18:59:23 -0800
In-Reply-To: <000000000000a3571605d27817b5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002bddaa05d7a12362@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
From:   syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bjorn.topel@gmail.com, bjorn.topel@intel.com, bjorn@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fgheet255t@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, mudongliangabcd@gmail.com,
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12073c74700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e514a4700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcdf8a700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3590 at mm/util.c:590 kvmalloc_node+0xf5/0x100 mm/util.c:590
Modules linked in:
CPU: 0 PID: 3590 Comm: syz-executor153 Not tainted 5.17.0-rc3-syzkaller-00043-gf4bc5bbb5fef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0xf5/0x100 mm/util.c:590
Code: 01 00 00 00 48 89 ef e8 c9 0d 0d 00 49 89 c5 e9 62 ff ff ff e8 ec d3 d0 ff 45 89 e5 41 81 cd 00 20 01 00 eb 8e e8 db d3 d0 ff <0f> 0b e9 45 ff ff ff 0f 1f 40 00 55 48 89 fd 53 e8 c6 d3 d0 ff 48
RSP: 0018:ffffc90002957c48 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88807297e2c0 RSI: ffffffff81a6da65 RDI: 0000000000000003
RBP: 00000007ff810000 R08: 000000007fffffff R09: 0000000000000001
R10: ffffffff81a6da21 R11: 0000000000000000 R12: 0000000000002dc0
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000700
FS:  000055555577a300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f31855463b0 CR3: 000000001d0ed000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:732 [inline]
 kvmalloc_array include/linux/slab.h:750 [inline]
 kvcalloc include/linux/slab.h:755 [inline]
 xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
 xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
 xdp_umem_create+0x563/0x1180 net/xdp/xdp_umem.c:252
 xsk_setsockopt+0x73e/0x9e0 net/xdp/xsk.c:1051
 __sys_setsockopt+0x2db/0x610 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3185535009
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff78e9c498 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3185535009
RDX: 0000000000000004 RSI: 000000000000011b RDI: 0000000000000003
RBP: 00007f31854f8ff0 R08: 0000000000000020 R09: 0000000000000000
R10: 0000000020000080 R11: 0000000000000246 R12: 00007f31854f9080
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

