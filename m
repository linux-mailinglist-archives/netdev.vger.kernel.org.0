Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4CB62DE18
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbiKQO3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbiKQO3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:29:37 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FA227DFC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:29:36 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id w27-20020a05660205db00b006dbce8dc263so929045iox.16
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:29:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o9eKZjGozyGRTLpYtU3VmFYQ+RcvWdJzMHKEziJZGuw=;
        b=iCPYf+hFpUX8/xYgR8eq8p2N7mLTtxcksZJx9Lb8ThL39TOonQiva79MMOMwPVNxCv
         ARykf3Ac1ltRJr0GXzDBGLhJZg2L1SllkALfkWVdmCgd7vUWOquATeWK5KswYlmfZ6vl
         xIITJrArfsL8sinmk2SHK1hkq6TnLacooLNDw32yDIhEmc/QvHrKciv4nDUaYIlqVcCA
         lVez6ygSPKCArgpqo1rMwWpXDxa7XtrjAEKYOhr4Ng2KEYT5Zo5uXOwj4+OrPeBxB/NV
         C7NL3/9igofDDQBjGygDssNq+AQWO6F4RiAgQNgWgIB1RxzbvTJzFYxCtvM5eiAWPLnS
         4spg==
X-Gm-Message-State: ANoB5pn54tMDVNnWl4qJeWIIuNZ/v5dEeVDrFOFR6lkzk4nJOLbs8/we
        ouPt6fmwegOgOqH+OnuGAQLl0lJHWxza2KIyJu5HySlTUsNb
X-Google-Smtp-Source: AA0mqf6iYdfVCX4SeYTc6bs4YgH7WIZD7tDSk52d2gfooJRxhdrwFhE/sItX3FKP9+wem2ie3ijJ7jdUTrbD7ROm+Gifu1hAUOEp
MIME-Version: 1.0
X-Received: by 2002:a92:3605:0:b0:302:a011:ae1 with SMTP id
 d5-20020a923605000000b00302a0110ae1mr634468ila.170.1668695375935; Thu, 17 Nov
 2022 06:29:35 -0800 (PST)
Date:   Thu, 17 Nov 2022 06:29:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f056d05edab6b1e@google.com>
Subject: [syzbot] memory leak in virtual_ncidev_write
From:   syzbot <syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com>
To:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cc675d22e422 Merge tag 'for-linus-6.1-rc6-tag' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1152f8d9880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=435fb8cdd395f932
dashboard link: https://syzkaller.appspot.com/bug?extid=cdb9a427d1bc08815104
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bea8d9880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10015c4e880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f389db5cedc/disk-cc675d22.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c3ef1df08018/vmlinux-cc675d22.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e11bee4d6893/bzImage-cc675d22.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff88810e144e00 (size 240):
  comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ab79a9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:497
    [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
    [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
    [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
    [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
    [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
    [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810cec1a00 (size 512):
  comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814edca7>] __do_kmalloc_node mm/slab_common.c:954 [inline]
    [<ffffffff814edca7>] __kmalloc_node_track_caller+0x47/0x120 mm/slab_common.c:975
    [<ffffffff83ab788d>] kmalloc_reserve net/core/skbuff.c:437 [inline]
    [<ffffffff83ab788d>] __alloc_skb+0xdd/0x270 net/core/skbuff.c:509
    [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
    [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
    [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
    [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
    [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
    [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
