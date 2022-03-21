Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3088E4E20C6
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 07:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344647AbiCUG4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 02:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiCUG4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 02:56:47 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06E136164
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 23:55:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id k10-20020a5d91ca000000b006414a00b160so9950009ior.18
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 23:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=daSupJTaLEMjCQlcgBlg0/J8zG8qmmsadR+tY63b3gs=;
        b=gUB+e3R77dF/Ub/S2St1yOwHNbjn9SX347SDaEULK4OEj5O6243vQrYELhtVD4pClt
         hOJTTwBtvBNfH0rD+EnIOmTakJ7LvFHeiDwwjDsdVjFcDENdnO07eixy8puhHsss/oFf
         OiMpwWW9LI32ivzgSj35cSdy+QJhwO3+KhH8SfTjP7A2Q6duy+QFJ0dRTRf4OYcGLE7z
         d92Z473sMFqjrIFTg6lpvNpQgZV+SoILA1U9YzDCJrPm2SL9F0QVLO+bglT/ZvYkRvfq
         sbvCPmibi6GVrHmiaJHdrOBDmYQlzlDOCzgwFxOjXBnv3xLMtnkzCuScF2lRMVy8XGGc
         f6uA==
X-Gm-Message-State: AOAM530IAWnfrDgL1nibma9eT/F/LN+FLrCmfbvbh+bg0zKCTbE9jnf5
        G4YaFKS12C8OD/fCxmAMHD6JGJLi9Fen66STyDTNW9mtG7WF
X-Google-Smtp-Source: ABdhPJyaYb68cejI/NR0p5vkFV1JTMagoK9de7VunW25JL+u2gSHf2xZ1AF9cWOrhDNbTSrjR7+4DCvM8TADQF5NhhPKg9edY2Nj
MIME-Version: 1.0
X-Received: by 2002:a02:bb01:0:b0:31a:a11:1c39 with SMTP id
 y1-20020a02bb01000000b0031a0a111c39mr10494944jan.233.1647845722331; Sun, 20
 Mar 2022 23:55:22 -0700 (PDT)
Date:   Sun, 20 Mar 2022 23:55:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec9cf305dab4faae@google.com>
Subject: [syzbot] bpf-next boot error: WARNING in bpf_prog_pack_free
From:   syzbot <syzbot+c946805b5ce6ab87df0b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
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

Hello,

syzbot found the following issue on:

HEAD commit:    7ada3787e91c bpf: Check for NULL return from bpf_get_btf_v..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14079871700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=820db791969fe863
dashboard link: https://syzkaller.appspot.com/bug?extid=c946805b5ce6ab87df0b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c946805b5ce6ab87df0b@syzkaller.appspotmail.com

------------[ cut here ]------------
bpf_prog_pack bug
WARNING: CPU: 0 PID: 8 at kernel/bpf/core.c:947 bpf_prog_pack_free+0x2fc/0x3a0 kernel/bpf/core.c:947
Modules linked in:
CPU: 0 PID: 8 Comm: kworker/0:1 Not tainted 5.17.0-rc6-syzkaller-02056-g7ada3787e91c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_prog_pack_free+0x2fc/0x3a0 kernel/bpf/core.c:947
Code: 0b 31 ff 89 de e8 64 44 f3 ff 84 db 0f 85 82 fe ff ff e8 d7 41 f3 ff 48 c7 c7 60 df b2 89 c6 05 e2 99 fa 0b 01 e8 6b 10 87 07 <0f> 0b e9 63 fe ff ff e8 b8 41 f3 ff 0f 0b 0f 0b 41 be ff ff ff ff
RSP: 0000:ffffc900000d7c60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888010e65700 RSI: ffffffff815fe3a8 RDI: fffff5200001af7e
RBP: ffffffff8bc177e0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815f8a3e R11: 0000000000000000 R12: ffff8881449f4010
R13: ffffffffa0400000 R14: ffffffffa0600640 R15: 0000000000000540
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000b88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bpf_jit_binary_pack_free kernel/bpf/core.c:1151 [inline]
 bpf_jit_free+0x11d/0x2b0 kernel/bpf/core.c:1180
 bpf_prog_free_deferred+0x5c1/0x790 kernel/bpf/core.c:2553
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
