Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6517D228
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 08:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCHHGI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Mar 2020 03:06:08 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:39797 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHHGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 03:06:07 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2B390CED14;
        Sun,  8 Mar 2020 08:15:34 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: WARNING: ODEBUG bug in rfcomm_dev_ioctl
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200308013838.10144-1-hdanton@sina.com>
Date:   Sun, 8 Mar 2020 08:06:05 +0100
Cc:     syzbot <syzbot+4496e82090657320efc6@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: 8BIT
Message-Id: <EDEE42AF-02A8-4FC9-A07E-2489BCCF64E8@holtmann.org>
References: <20200308013838.10144-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

>> syzbot found the following crash on:
>> 
>> HEAD commit:    fb279f4e Merge branch 'i2c/for-current-fixed' of git://git..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=168c481de00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8b13b05f0e61d957
>> dashboard link: https://syzkaller.appspot.com/bug?extid=4496e82090657320efc6
>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> 
>> Unfortunately, I don't have any reproducer for this crash yet.
>> 
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
>> 
>> ------------[ cut here ]------------
>> ODEBUG: free active (active state 0) object type: timer_list hint: rfcomm_dlc_timeout+0x0/0xc0 net/bluetooth/rfcomm/core.c:300
>> WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
>> WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
>> WARNING: CPU: 0 PID: 9181 at lib/debugobjects.c:488 debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 0 PID: 9181 Comm: syz-executor.3 Not tainted 5.6.0-rc3-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>> __dump_stack lib/dump_stack.c:77 [inline]
>> dump_stack+0x1e9/0x30e lib/dump_stack.c:118
>> panic+0x264/0x7a0 kernel/panic.c:221
>> __warn+0x209/0x210 kernel/panic.c:582
>> report_bug+0x1ac/0x2d0 lib/bug.c:195
>> fixup_bug arch/x86/kernel/traps.c:174 [inline]
>> do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
>> do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>> invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
>> RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
>> RIP: 0010:debug_check_no_obj_freed+0x45c/0x640 lib/debugobjects.c:998
>> Code: 74 08 4c 89 f7 e8 64 2d 18 fe 4d 8b 06 48 c7 c7 53 10 d1 88 48 c7 c6 0f 01 cf 88 48 89 da 89 e9 4d 89 f9 31 c0 e8 c4 cd ae fd <0f> 0b 48 ba 00 00 00 00 00 fc ff df ff 05 c6 39 b1 05 48 8b 5c 24
>> RSP: 0018:ffffc90001907c88 EFLAGS: 00010046
>> RAX: 72f8f847df918a00 RBX: ffffffff88d4edca RCX: 0000000000040000
>> RDX: ffffc90011373000 RSI: 0000000000013ee9 RDI: 0000000000013eea
>> RBP: 0000000000000000 R08: ffffffff815e1276 R09: ffffed1015d04592
>> R10: ffffed1015d04592 R11: 0000000000000000 R12: ffff88808ea6fbac
>> R13: ffffffff8b592e40 R14: ffffffff890ddc78 R15: ffffffff873dcc50
>> kfree+0xfc/0x220 mm/slab.c:3756
>> rfcomm_dlc_put include/net/bluetooth/rfcomm.h:258 [inline]
>> __rfcomm_create_dev net/bluetooth/rfcomm/tty.c:417 [inline]
>> rfcomm_create_dev net/bluetooth/rfcomm/tty.c:486 [inline]
>> rfcomm_dev_ioctl+0xe37/0x2340 net/bluetooth/rfcomm/tty.c:588
>> rfcomm_sock_ioctl+0x79/0xa0 net/bluetooth/rfcomm/sock.c:902
>> sock_do_ioctl+0x7b/0x260 net/socket.c:1053
>> sock_ioctl+0x4aa/0x690 net/socket.c:1204
>> vfs_ioctl fs/ioctl.c:47 [inline]
>> ksys_ioctl fs/ioctl.c:763 [inline]
>> __do_sys_ioctl fs/ioctl.c:772 [inline]
>> __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:770
>> do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> 
> 
> No need to put dlc as it's not held in rfcomm_dlc_exists().
> 
> --- a/net/bluetooth/rfcomm/tty.c
> +++ b/net/bluetooth/rfcomm/tty.c
> @@ -413,10 +413,8 @@ static int __rfcomm_create_dev(struct so
> 		dlc = rfcomm_dlc_exists(&req.src, &req.dst, req.channel);
> 		if (IS_ERR(dlc))
> 			return PTR_ERR(dlc);
> -		else if (dlc) {
> -			rfcomm_dlc_put(dlc);
> +		if (dlc)
> 			return -EBUSY;
> -		}
> 		dlc = rfcomm_dlc_alloc(GFP_KERNEL);
> 		if (!dlc)
> 			return -ENOMEM;
> 

looks like this has been there since 2014 and nobody trigged it yet. Care to send a patch that I can apply.

Regards

Marcel

