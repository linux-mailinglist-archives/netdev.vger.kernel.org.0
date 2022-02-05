Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2E4AA5C4
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 03:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378986AbiBECdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 21:33:20 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:38907 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378978AbiBECdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 21:33:18 -0500
Received: by mail-io1-f69.google.com with SMTP id r4-20020a6b4404000000b00614d5a865f7so5251946ioa.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 18:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=J56lO7LttwsJaeKgX0tNVRY/qO85NuUU/tQlLy1XDUM=;
        b=MCUyXS7nshdZTF2twtLIAgNeTfU8hoAChfFNrJEcQY4dE/PWHHd7WLOHZSWrq82cL7
         NLUfYqPQw+++H7a/qDXk4XWUeZEZDQykD+vzVJgtk+qPRHpTiirz5W4XyMNgXwVymcd7
         gJSXFtoOJquifuZPRPVQk9qONM2/rGUWcY5bsph5fhtzUoBJLkXadGmcSHJMxlq6Irhl
         b9MUniHynCgiwx5fguNSLwMa/vDigkTy8oDAcNc0TotzKzsT0sqR5wu2xGruo8J7+iTx
         kn1vHHYsIEMOlEXR3K8NqRuFs+W41xvP9N4X6eMMaKvvlk/enby/xjik8UUYBWnTQq/P
         /UNQ==
X-Gm-Message-State: AOAM5339bGmsT5rsvDRAFQ0YYujASXMTiKcsN+EfS0cIaWJ28KLvMCMX
        yxCDcyGVCTohNZlqdc5jCBbT0Nn4X0XHclqGZoEeiS7pN9cc
X-Google-Smtp-Source: ABdhPJzrn30KMHlfyE8tjwMMW5RfWIiW2TKyrm+AvngLD/RBeUYU1a46CCg0vow0BFIAymzz9x3u5Bpmg5HEH9HTrWutuIJE1Mbe
MIME-Version: 1.0
X-Received: by 2002:a92:c6c8:: with SMTP id v8mr988388ilm.14.1644028398304;
 Fri, 04 Feb 2022 18:33:18 -0800 (PST)
Date:   Fri, 04 Feb 2022 18:33:18 -0800
In-Reply-To: <00000000000072391b05b00bcb00@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae860205d73c30a8@google.com>
Subject: Re: [syzbot] WARNING in ieee80211_rx_list
From:   syzbot <syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com>
To:     ajithjain@space-mep.com, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    227a0713b319 libbpf: Deprecate forgotten btf__get_map_kv_t..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15d58c62700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b210f94c3ec14b22
dashboard link: https://syzkaller.appspot.com/bug?extid=8830db5d3593b5546d2e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1692ceec700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e97524700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8830db5d3593b5546d2e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 13 at net/mac80211/rx.c:4902 ieee80211_rx_list+0x18e2/0x2740 net/mac80211/rx.c:4902
Modules linked in:
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.16.0-syzkaller-11609-g227a0713b319 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_rx_list+0x18e2/0x2740 net/mac80211/rx.c:4902
Code: 00 00 31 ff 89 de e8 ad ba d8 f8 85 db 0f 85 19 02 00 00 e8 80 b8 d8 f8 4c 89 e7 e8 48 ef 88 fe e9 bc eb ff ff e8 6e b8 d8 f8 <0f> 0b e9 53 ec ff ff e8 62 b8 d8 f8 4c 89 ea 48 b8 00 00 00 00 00
RSP: 0018:ffffc90000d27b80 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888074dab3c8 RCX: 0000000000000100
RDX: ffff8880118d0000 RSI: ffffffff889f9d32 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff889f86cb R11: 0000000000000000 R12: ffff888078f17280
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888074da8e60
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555566663b8 CR3: 000000000b88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ieee80211_rx_napi+0xdb/0x3d0 net/mac80211/rx.c:5000
 ieee80211_rx include/net/mac80211.h:4594 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

