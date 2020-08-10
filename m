Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96A5240D03
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgHJSbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgHJSbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 14:31:01 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4048CC061756;
        Mon, 10 Aug 2020 11:31:01 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 77so9304620qkm.5;
        Mon, 10 Aug 2020 11:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=flrY2lJlHhxpTaFKprp88SIz0K8XOJ8MpibhcDVgMos=;
        b=hh4u/0+tiKEnxWRGibP8MASE3vehVJ61dqWOnOyQ01RrS5hlCmha/L7jNVyOmp+9l4
         Br90ey2/FQBhPfwfm17tKm/MvT0x3M9qXYX7ZudC5IrgeaYCvQM8ZB00MHduyvriF1A2
         LxF8RFLB1U2TMVU9oIW3+VelASg+PmJ5cjigRZvHMMAGUEOsM9BuwiOTH10MKnmzH3cG
         ZhRKKiE9ZpeJ/UtvnBgo6ahJoeCl6UNTItEuVFyIrkV22ureBL8un+SCnkqgibw1m+c4
         zozQcziQ8LwbGj2Hmms1dF/lGlafM1RMXpD62ovxB+EKME/NUGk7ef1670NqsakYGoR7
         jPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=flrY2lJlHhxpTaFKprp88SIz0K8XOJ8MpibhcDVgMos=;
        b=tTeHMjOMNhIq5l4RX1DWCXOyBgFmmhR4r28axOvUcMfsDW69K9DQSfA3nXNsDPhSl7
         u0j6FGPuklgYOkQ1bbiB1iyzdm1WRgX+SmnlKyl5JVskiTxEIMq80e/1xA7UFqtEjyWD
         Fk/mE0WDWuvDdnytOsusN2TIwnX1OCc+Gu+iorYV0nhxUg/KtDGLJ8fUqDEqm+aOxF6P
         cLXHlCFW0tqsKtPDu7ap386KJ6Z+Ml+KbpHXSOralGTboJWZq/4YZ5M5nzq85kMIhVeA
         ps9EIJ8TSdDJdBHY74I7z5++S6/8E91Y3sWO7vkWDpGVzW4XXCQKZkv8niSp747npe+a
         BSdw==
X-Gm-Message-State: AOAM530vJ369TDu1TTuagjXXKE12FN+TUFYCZ275iBUtFSH4QwuRwwE/
        FG/4A1N7MHTDw7qvW5x47GFGTIn64BA=
X-Google-Smtp-Source: ABdhPJzWytMFeIsB0IUABIS95TP0e1YbR2VTsanORtht4XLUmeH3thmwCOq6RFq1v0gmwNYlsp+3Dg==
X-Received: by 2002:a37:27cc:: with SMTP id n195mr26713576qkn.403.1597084260306;
        Mon, 10 Aug 2020 11:31:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:5401:5840:1a7c:e646:9161])
        by smtp.gmail.com with ESMTPSA id o25sm14122837qkm.42.2020.08.10.11.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 11:30:59 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 219ABC1D68; Mon, 10 Aug 2020 15:30:57 -0300 (-03)
Date:   Mon, 10 Aug 2020 15:30:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com, lucien.xin@gmail.com, jonas.falkevik@gmail.com
Subject: Re: general protection fault in sctp_ulpevent_notify_peer_addr_change
Message-ID: <20200810183057.GF3399@localhost.localdomain>
References: <000000000000d4adc705ac87ba8e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d4adc705ac87ba8e@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 08:37:18AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12f34d3a900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=50463ec6729f9706
> dashboard link: https://syzkaller.appspot.com/bug?extid=8f2165a7b1f2820feffc
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1517701c900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b7e0e2900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc000000004c: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000260-0x0000000000000267]
> CPU: 0 PID: 12765 Comm: syz-executor391 Not tainted 5.8.0-syzkaller #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0xa9/0xad0 net/sctp/ulpevent.c:346

Crashed in code added by 45ebf73ebcec ("sctp: check assoc before
SCTP_ADDR_{MADE_PRIM, ADDED} event"), but it would have crashed a
couple of instructions later on already anyway.

I can't reproduce this crash, with the same commit and kernel config.
I'm not seeing how transport->asoc can be null at there.

While trying to reproduce this, when I aborted a test, I actually
triggerred:

[ 1527.736212][ T8008] team0 (unregistering): Port device team_slave_1 removed
[ 1527.896902][ T8008] team0 (unregistering): Port device team_slave_0 removed
[ 1528.053936][ T8008] bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
[ 1528.445113][ T8008] bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
[ 1528.915669][ T8008] bond0 (unregistering): Released all slaves
[ 1530.531179][ T8008] ------------[ cut here ]------------
[ 1530.666414][ T8008] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x90
[ 1530.913574][ T8008] WARNING: CPU: 11 PID: 8008 at lib/debugobjects.c:485 debug_print_object+0x160/0x250
[ 1531.165944][ T8008] Kernel panic - not syncing: panic_on_warn set ...
[ 1531.291997][ T8008] CPU: 11 PID: 8008 Comm: kworker/u48:8 Not tainted 5.8.0+ #6
[ 1531.554397][ T8008] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
[ 1531.842844][ T8008] Workqueue: netns cleanup_net
[ 1531.983054][ T8008] Call Trace:
[ 1532.122433][ T8008]  dump_stack+0x18f/0x20d
[ 1532.257582][ T8008]  panic+0x2e3/0x75c
[ 1532.385158][ T8008]  ? __warn_printk+0xf3/0xf3
[ 1532.520152][ T8008]  ? console_unlock+0x7f0/0xf30
[ 1532.643891][ T8008]  ? __warn.cold+0x5/0x45
[ 1532.763171][ T8008]  ? __warn+0xd6/0x1f2
[ 1532.884107][ T8008]  ? debug_print_object+0x160/0x250
[ 1533.011290][ T8008]  __warn.cold+0x20/0x45
[ 1533.132625][ T8008]  ? wake_up_klogd.part.0+0x8c/0xc0
[ 1533.248423][ T8008]  ? debug_print_object+0x160/0x250
[ 1533.370165][ T8008]  report_bug+0x1bd/0x210
[ 1533.492858][ T8008]  handle_bug+0x38/0x90
[ 1533.614108][ T8008]  exc_invalid_op+0x14/0x40
[ 1533.730968][ T8008]  asm_exc_invalid_op+0x12/0x20
[ 1533.851289][ T8008] RIP: 0010:debug_print_object+0x160/0x250
[ 1533.964027][ T8008] Code: dd 40 b8 93 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 14 dd 40 b8 93 88 48 c7 c7 a0 ad 93 88 e8 02 66 a9 fd <0f> 0b 83 05 73 9f 13 07 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
[ 1534.313398][ T8008] RSP: 0018:ffffc90000e378a8 EFLAGS: 00010086
[ 1534.432053][ T8008] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[ 1534.677101][ T8008] RDX: ffff8881331a2300 RSI: ffffffff815d8e17 RDI: fffff520001c6f07
[ 1534.930977][ T8008] RBP: 0000000000000001 R08: 0000000000000001 R09: ffff888142fa0fcb
[ 1535.180403][ T8008] R10: 0000000000000000 R11: 0000000000008026 R12: ffffffff89bce120
[ 1535.424399][ T8008] R13: ffffffff81636500 R14: dead000000000100 R15: dffffc0000000000
[ 1535.678140][ T8008]  ? calc_wheel_index+0x3f0/0x3f0
[ 1535.808026][ T8008]  ? vprintk_func+0x97/0x1a6
[ 1535.939928][ T8008]  ? debug_print_object+0x160/0x250
[ 1536.072538][ T8008]  debug_check_no_obj_freed+0x301/0x41c
[ 1536.203742][ T8008]  ? dev_attr_show+0x90/0x90
[ 1536.343659][ T8008]  kfree+0xf0/0x2c0
[ 1536.484984][ T8008]  ? dev_attr_show+0x90/0x90
[ 1536.620853][ T8008]  kvfree+0x42/0x50
[ 1536.752990][ T8008]  ? netdev_class_remove_file_ns+0x30/0x30
[ 1536.886457][ T8008]  device_release+0x71/0x200
[ 1537.015419][ T8008]  ? dev_attr_show+0x90/0x90
[ 1537.142315][ T8008]  kobject_put+0x171/0x270
[ 1537.269426][ T8008]  netdev_run_todo+0x765/0xac0
[ 1537.402993][ T8008]  ? dev_xdp_uninstall+0x3f0/0x3f0
[ 1537.542007][ T8008]  ? default_device_exit_batch+0x3d0/0x3d0
[ 1537.679397][ T8008]  ? unregister_netdevice_many+0x50/0x50
[ 1537.811168][ T8008]  ? sysfs_remove_group+0xc2/0x170
[ 1537.941789][ T8008]  default_device_exit_batch+0x316/0x3d0
[ 1538.075268][ T8008]  ? unregister_netdev+0x20/0x20
[ 1538.209131][ T8008]  ? __init_waitqueue_head+0x110/0x110
[ 1538.340541][ T8008]  ? cfg802154_switch_netns+0x440/0x440
[ 1538.468571][ T8008]  ? unregister_netdev+0x20/0x20
[ 1538.574138][ T8008]  ? dev_change_net_namespace+0x1200/0x1200
[ 1538.676756][ T8008]  ops_exit_list+0x10d/0x160
[ 1538.778236][ T8008]  cleanup_net+0x4ea/0xa00
[ 1538.877412][ T8008]  ? ops_free_list.part.0+0x3d0/0x3d0
[ 1538.977271][ T8008]  ? lock_is_held_type+0xbb/0xf0
[ 1539.069114][ T8008]  process_one_work+0x94c/0x1670
[ 1539.165257][ T8008]  ? lock_release+0x8e0/0x8e0
[ 1539.257102][ T8008]  ? pwq_dec_nr_in_flight+0x2d0/0x2d0
[ 1539.343961][ T8008]  ? rwlock_bug.part.0+0x90/0x90
[ 1539.433524][ T8008]  worker_thread+0x64c/0x1120
[ 1539.521045][ T8008]  ? process_one_work+0x1670/0x1670
[ 1539.610356][ T8008]  kthread+0x3b5/0x4a0
[ 1539.698844][ T8008]  ? __kthread_bind_mask+0xc0/0xc0
[ 1539.788834][ T8008]  ? __kthread_bind_mask+0xc0/0xc0
[ 1539.871367][ T8008]  ret_from_fork+0x1f/0x30
[ 1539.959633][ T8008] Kernel Offset: disabled
[ 1540.038379][ T8008] Rebooting in 86400 seconds..
