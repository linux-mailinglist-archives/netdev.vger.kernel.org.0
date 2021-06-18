Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F73AC761
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhFRJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:27:33 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33597 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhFRJ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:27:31 -0400
Received: by mail-io1-f70.google.com with SMTP id i6-20020a0566022c86b02904df6556dad4so815381iow.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=L57I4D4osym4aQVEfPJQEtSx6Z1M0n8qs6P2zclR75A=;
        b=pLbU31oVSO7RcO/XaiaUCGoRajDoiwotvELPGYE85Qb6B3K1zi9UtCd2OqkhpZILmt
         2IO7s3egyR/XX4FejL03bnDyVdEK+Nvw45D3EmdMULMpg+dRrM+QQe1HWFuS9znE0t6j
         oplyGjYKiRl2eR2InAwTMFNiE+kAMLv1fSij8/lxLmCCxFgzHqdF4+YeC4BjhWa3hRvj
         im2EuNUXIQfq3JON86Y+/muIzRyyXoledpSt1CXV9Om4OwINj7imZCQzPS+r2DoenquJ
         kTRir/qLMAMwbj7tJIrjnDDOsLSUEP01qASzV7gKFYu3TUbL+9JJPH13tVICWq34WYcF
         JB2Q==
X-Gm-Message-State: AOAM533oVev2tzWRf1+tCRPb0i4tU3PKjCaN8x2SQRGXPkGjOnVzNRS/
        kw0kqMWczij6eVmv10wqxlYHPFLgbmQus5rA07pJ0jYkd1j9
X-Google-Smtp-Source: ABdhPJz373WPx00/kXm9ePGjCN740hlomJOmUrOytAjZHAcEPFiXF0RbvtlG5R+2PMnZTHiq51nk7GjUiTHZCZz9+Zr6kmHTGRmm
MIME-Version: 1.0
X-Received: by 2002:a92:8e03:: with SMTP id c3mr7006416ild.167.1624008322335;
 Fri, 18 Jun 2021 02:25:22 -0700 (PDT)
Date:   Fri, 18 Jun 2021 02:25:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002a48dd05c506e7cc@google.com>
Subject: [syzbot] divide error in ath9k_htc_swba
From:   syzbot <syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    37fdb7c9 Merge tag 'v5.13-rc6' into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1702bbebd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e3b6ba4f6e6c6ddf
dashboard link: https://syzkaller.appspot.com/bug?extid=90d241d7661ca2493f0b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113b98b8300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134650f7d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com

divide error: 0000 [#1] SMP KASAN
CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
RIP: 0010:ath9k_htc_choose_bslot drivers/net/wireless/ath/ath9k/htc_drv_beacon.c:277 [inline]
RIP: 0010:ath9k_htc_swba+0x1b2/0xc70 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c:310
Code: c0 40 84 c6 0f 85 db 09 00 00 48 8b 55 00 0f b7 c9 bd 01 00 00 00 48 0f ca 48 89 d0 c1 ea 0a 48 c1 e8 20 c1 e0 16 09 d0 31 d2 <f7> f1 8d 04 12 31 d2 f7 f1 29 c5 48 8d 83 b0 03 00 00 48 89 c7 48
RSP: 0018:ffffc90000148dc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811a0d31e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8304a44a R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88810efedc0c R15: ffff88811a63c1f0
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001038 CR3: 00000001081c0000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ath9k_wmi_event_tasklet+0x2e7/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:165
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x1b0/0x944 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu kernel/softirq.c:637 [inline]
 irq_exit_rcu+0x119/0x1a0 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x6a/0x90 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
Code: 89 03 e9 04 fd ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 66 0f 1f 44 00 00 <65> 8b 05 b9 d5 c0 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc90000197540 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888107ff0000 RSI: ffffffff812a3455 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8a8f0727
R10: ffffffff812a344b R11: 0000000000000000 R12: ffffffff82d1e760
R13: 0000000000000200 R14: dffffc0000000000 R15: ffffc900001975a0
 console_unlock+0x7cb/0xc20 kernel/printk/printk.c:2653
 vprintk_emit+0x20a/0x580 kernel/printk/printk.c:2174
 dev_vprintk_emit+0x36e/0x3b2 drivers/base/core.c:4553
 dev_printk_emit+0xba/0xf1 drivers/base/core.c:4564
 __dev_printk+0xcf/0xf5 drivers/base/core.c:4576
 _dev_err+0xd7/0x109 drivers/base/core.c:4619
 ath9k_init_htc_services.constprop.0.cold+0x32/0x11a drivers/net/wireless/ath/ath9k/htc_drv_init.c:220
 ath9k_htc_probe_device+0x25f/0x1e50 drivers/net/wireless/ath/ath9k/htc_drv_init.c:960
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:503
 ath9k_hif_usb_firmware_cb+0x274/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1239
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1081
 process_one_work+0x98d/0x1580 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 3235ce4c0fe1a3c7 ]---
RIP: 0010:ath9k_htc_choose_bslot drivers/net/wireless/ath/ath9k/htc_drv_beacon.c:277 [inline]
RIP: 0010:ath9k_htc_swba+0x1b2/0xc70 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c:310
Code: c0 40 84 c6 0f 85 db 09 00 00 48 8b 55 00 0f b7 c9 bd 01 00 00 00 48 0f ca 48 89 d0 c1 ea 0a 48 c1 e8 20 c1 e0 16 09 d0 31 d2 <f7> f1 8d 04 12 31 d2 f7 f1 29 c5 48 8d 83 b0 03 00 00 48 89 c7 48
RSP: 0018:ffffc90000148dc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811a0d31e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8304a44a R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88810efedc0c R15: ffff88811a63c1f0
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001038 CR3: 00000001081c0000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
