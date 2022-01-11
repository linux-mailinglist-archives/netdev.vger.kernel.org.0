Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A08548A5D3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 03:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243845AbiAKCqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 21:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243811AbiAKCqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 21:46:54 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9889C06173F;
        Mon, 10 Jan 2022 18:46:53 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p187so919039ybc.0;
        Mon, 10 Jan 2022 18:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZuUFkyhWbm2NLmu49J/8mGsBY5V9ZWyFz+GjMtOdM6A=;
        b=niPpChHcShG+A/IYMTixx6U/rPxH2ziXfZ/janzAxnXkKYj9pk4yPb7+vLeCaBk5RU
         WLySODoV9h+txPkZGo9tD3tAkBXUa3/cRCabEYRzzzqw/rCJUp269fqkP3c4UusaxOs5
         gCZUczpApNDMvxRTOrG2fWOt39ehDi536AeqLTiqvV0GkLmfOXWbf/h30LGioU204B4o
         IJJygLBLyEXT1HHor9J/5HJS3vP6mHRuqC1ZFKLB1Jy6IeZ2u1Bh2f4B2T6GkCmmn0QQ
         vad0xL9JECPht+nkBcEFhhExO7muWZr4fcvMypDYBowWLbihcUSLGdE2vUkDkI9UrzlO
         03qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZuUFkyhWbm2NLmu49J/8mGsBY5V9ZWyFz+GjMtOdM6A=;
        b=G6oxSBwRV7NT60JulAyTPpjwaeOPFzFxjyRGZyHyF/+KaWN9V7HyOTKbYFUrwoA/Nv
         JMLjn4DFW+gbTgmSQ1kwhoQ+V1B+Bx/WQSxHDAiOikK1NCWwgRsFDVpNxEGfnfinAiIz
         LQ5cd118i47UK7gVJlFPP5wQKMC73lZ4NyGzG1s93TYb1vWNyrvwi3iufxjAPspZaDjt
         4O9+JWbtegCkuj/7VvgtOD8kZZiNlYctInKYq8PZtTc2vDIJ0r5ti33c3Lb7EEpBF8n1
         hY9EdwnfM2sAuuGy9hLvBWrp49SR/D/eVp3kuXnqGAb7b0xjdmJuANQWHGSRXFeSbESd
         5UYw==
X-Gm-Message-State: AOAM532B8TVK6OlkF/8FYj7ge1ecFyXhOA4aEtA6CA+KPTH37FG8v1io
        FPi6+q9YQvQGbP4S2tjmSDsSY8AoD2L2gvusb1NadBBXzO3XT1L+mRA=
X-Google-Smtp-Source: ABdhPJxwuVLBXfP24SwigYAyRltWIWBnQopglSyuFBj4EO1YsvxtDzUby4Vgl9Y7ZIsHN2hVuXt/MHy/vvBC5MExKxA=
X-Received: by 2002:a25:4cc5:: with SMTP id z188mr3367435yba.248.1641869213113;
 Mon, 10 Jan 2022 18:46:53 -0800 (PST)
MIME-Version: 1.0
From:   cruise k <cruise4k@gmail.com>
Date:   Tue, 11 Jan 2022 10:46:42 +0800
Message-ID: <CAKcFiNAdDdD30twPF6BxwdOenWgP1ma8sDRNyh194azvTp=8AQ@mail.gmail.com>
Subject: INFO: task hung in new_device_store
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Syzkaller found the following issue:

HEAD commit: 75acfdb Linux 5.16-rc8
git tree: upstream
console output: https://pastebin.com/raw/MDzqSYsC
kernel config: https://pastebin.com/raw/XsnKfdRt

And hope the report log can help you.

INFO: task syz-executor.14:6981 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc8+ #10
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.14 state:D stack:23984 pid: 6981 ppid:     1 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2550 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 new_device_store+0xe8/0x670 drivers/net/netdevsim/bus.c:174
 bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x337/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write+0x432/0x660 fs/read_write.c:503
 vfs_write+0x678/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fee725d301f
RSP: 002b:00007fff81b63990 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fee725d301f
RDX: 0000000000000004 RSI: 00007fff81b639e0 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007fff81b63930
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fee7268fcc3
R13: 00007fff81b639e0 R14: 0000000000000000 R15: 00007fee7367b320
 </TASK>
