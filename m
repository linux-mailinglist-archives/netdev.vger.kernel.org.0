Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19C62FF334
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbhAUSbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:31:38 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:43210 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbhAUSbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:31:05 -0500
Received: by mail-io1-f70.google.com with SMTP id n18so4842039ioo.10
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:30:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oVWccvp7x6PMxOa3dh/LvOXdIcojqs3FO4GiLhT8EWY=;
        b=tLD82rALO8UZLx7JQj2rtb2HSD0850q6F54KHmhfK433Kikj9e9Z0363uI82BcQFBH
         9swDUaGGvDnh2khxDTsnpf6kr+HisH3Th9l4vEVMztwUid+T150jwJAi/oPszKGrOPL3
         OUh4Wq/HjDriul7lCvbAnappx7ITLEZ1oljuMEOYG4X+/Y6DvSSrw+mB8kV2gek2Hd5T
         EBg+Bsy0tnixCVX4/TO4ggJwJPyvYz7wElc8unCZtGKzpidjlbGQ2K3cevOyJ7MlDKF/
         6ZSxTk9l5Cw4997LCfiMlTgqZNrfhqGSPw+BYJtgLhTcsKIfr7X3eJ4iuCANDxvgA5kp
         fJ1g==
X-Gm-Message-State: AOAM530eiGP0fywX94KZ+3Q71BxImFJLhX4+xV8gsATeheMC/eRtBOte
        VutxPqJ70vxYX5IoXPZETsxGLJ4LD4aLFMyswnq9jYtkEvzF
X-Google-Smtp-Source: ABdhPJxaPmTNkCSEprX+gFOvjNLdlWCW3XhUsIg14ROxCkei2qe77eZyd0hChFVaFaX32ZWsxC9ICPgq3iCeQlVXY7A3ZUacQvbW
MIME-Version: 1.0
X-Received: by 2002:a6b:b258:: with SMTP id b85mr617052iof.97.1611253823888;
 Thu, 21 Jan 2021 10:30:23 -0800 (PST)
Date:   Thu, 21 Jan 2021 10:30:23 -0800
In-Reply-To: <0000000000004c9e3505b96c58eb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0e9a705b96d4332@google.com>
Subject: Re: UBSAN: array-index-out-of-bounds in decode_data
From:   syzbot <syzbot+70ba6cae2f44c82dcb76@syzkaller.appspotmail.com>
To:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9791581c Merge tag 'for-5.11-rc4-tag' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13cd09a4d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39701af622f054a9
dashboard link: https://syzkaller.appspot.com/bug?extid=70ba6cae2f44c82dcb76
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133d8030d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+70ba6cae2f44c82dcb76@syzkaller.appspotmail.com

================================================================================
UBSAN: array-index-out-of-bounds in drivers/net/hamradio/6pack.c:845:16
index 400 is out of range for type 'unsigned char [400]'
CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound flush_to_ldisc
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
 decode_data.part.0+0x2c8/0x2e0 drivers/net/hamradio/6pack.c:845
 decode_data drivers/net/hamradio/6pack.c:965 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
 sixpack_receive_buf drivers/net/hamradio/6pack.c:458 [inline]
 sixpack_receive_buf+0xd8c/0x1320 drivers/net/hamradio/6pack.c:435
 tty_ldisc_receive_buf+0x14a/0x190 drivers/tty/tty_buffer.c:465
 tty_port_default_receive_buf+0x6e/0xa0 drivers/tty/tty_port.c:38
 receive_buf drivers/tty/tty_buffer.c:481 [inline]
 flush_to_ldisc+0x20d/0x380 drivers/tty/tty_buffer.c:533
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
================================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound flush_to_ldisc
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 ubsan_epilogue+0x54/0x5a lib/ubsan.c:162
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
 decode_data.part.0+0x2c8/0x2e0 drivers/net/hamradio/6pack.c:845
 decode_data drivers/net/hamradio/6pack.c:965 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
 sixpack_receive_buf drivers/net/hamradio/6pack.c:458 [inline]
 sixpack_receive_buf+0xd8c/0x1320 drivers/net/hamradio/6pack.c:435
 tty_ldisc_receive_buf+0x14a/0x190 drivers/tty/tty_buffer.c:465
 tty_port_default_receive_buf+0x6e/0xa0 drivers/tty/tty_port.c:38
 receive_buf drivers/tty/tty_buffer.c:481 [inline]
 flush_to_ldisc+0x20d/0x380 drivers/tty/tty_buffer.c:533
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled
Rebooting in 86400 seconds..

