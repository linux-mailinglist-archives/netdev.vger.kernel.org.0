Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7D3620FC4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiKHMEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiKHMEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:04:52 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353AC62E1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:04:50 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id a14-20020a921a0e000000b003016bfa7e50so7572750ila.16
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:04:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JUtAod7ik8axbS2mcSWOVXWN5+ZnGt4lhHuscBLj+Ys=;
        b=tkE5Ox6sZZ6Noh4jgm44Cr4TAO9kSB8K8sU1YCVhigqiAVZTtr2EZvE4OqYXddlLC4
         +LESqm7XVYxHPsiVhOU2/oJL7lF7I3XQjf+4cHCyVuPq0QcTyBmkOcNplEr2K0icCu1y
         eumPOdjAt9yxt41jdH5IR2+xHbRW1FBiwGOS8QRutHY0kJX6AccraJMnW2aukYBkEST2
         tz7UkBBwS/Iz6XTn2eADn+nNp4Hl7CNLSnTpbBVgWKrKCZ8a8P83lP2sjANZHEQ2RQlI
         r9CR5ake3tpT+1hkEKNy3Vp2BVZ+T5rnmVjyZ54mA/AUxKdl6nlBNlOcoPhybIqfA/Wg
         CluA==
X-Gm-Message-State: ACrzQf2B7+cN1l1xtghZcAwlME3Dq352x+LB9r9MEYqVXPM6kCuhqUeq
        bc+1XKn7S95DY6xCxzvRZ9YZoOzqhb1w29bBEoTIQ/sZ+ea1
X-Google-Smtp-Source: AMsMyM6qJgVyHEubAq6DsnqPMu41Jr73H8iqWfCsDz5e1dPS2QiwvTlP2xA8yKaIzN50tKM3b54RdeflyLzjmpG+02I0Hz0SsmID
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cd3:b0:6d8:5b3e:c456 with SMTP id
 j19-20020a0566022cd300b006d85b3ec456mr11732782iow.152.1667909089385; Tue, 08
 Nov 2022 04:04:49 -0800 (PST)
Date:   Tue, 08 Nov 2022 04:04:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca64fe05ecf458e3@google.com>
Subject: [syzbot] net-next test error: WARNING in devl_port_unregister
From:   syzbot <syzbot+85e47e1a08b3e159b159@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jiri@nvidia.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    91c596cc8d32 Merge branch 'net-txgbe-fix-two-bugs-in-txgbe..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10cf5b96880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=155594ab86a8ef7a
dashboard link: https://syzkaller.appspot.com/bug?extid=85e47e1a08b3e159b159
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/811c994625c9/disk-91c596cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bf46bee439d4/vmlinux-91c596cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c005328dcdaa/bzImage-91c596cc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+85e47e1a08b3e159b159@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 56 at net/core/devlink.c:9998 devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
Modules linked in:
CPU: 1 PID: 56 Comm: kworker/u4:4 Not tainted 6.1.0-rc3-syzkaller-00810-g91c596cc8d32 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
Code: e8 0f 39 0b fa 85 ed 0f 85 7a fd ff ff e8 32 3c 0b fa 0f 0b e9 6e fd ff ff e8 26 3c 0b fa 0f 0b e9 53 ff ff ff e8 1a 3c 0b fa <0f> 0b e9 94 fd ff ff e8 7e ae 57 fa e9 78 ff ff ff e8 44 ae 57 fa
RSP: 0018:ffffc90001577a08 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880736c0810 RCX: 0000000000000000
RDX: ffff8880183c8000 RSI: ffffffff87717606 RDI: 0000000000000005
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8880736c0810
R13: ffff8880736c0808 R14: ffff88806f2c7800 R15: ffff8880736c0800
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bd232a4068 CR3: 000000001f12c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
 nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
 nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
 devlink_reload+0x1c2/0x6b0 net/core/devlink.c:4501
 devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12609
 ops_pre_exit_list net/core/net_namespace.c:159 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
