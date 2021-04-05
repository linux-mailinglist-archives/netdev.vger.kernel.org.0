Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1C7354613
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbhDERe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:34:26 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34240 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbhDEReZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:34:25 -0400
Received: by mail-io1-f72.google.com with SMTP id l4so3996610iop.1
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 10:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vd51XgEIvP4DQDs0VI5+bjubW08Kj6vjDtH+/7eNtLk=;
        b=pGY1LT9SNroDjYoKB0uGxQ1Pj85OcCFoC4OKBiRNZuTewbVUCwAr0Bbt2bfjiLpRcz
         NlCV5UUhkns+8xtMk4bnC8VufQX2Y36w0SxfA5qND+/afOiuFwBM0vru4wGi4GeaK2BC
         x5Ry/o7LKDAOXKkYCeHaQsjqRBi+cl8GjSqJVn78f0fUhIRQNwfcEbVHrphHziPtxTDF
         847j8JPoVgIj9P8xWhPD1O/gZuwZEgi8ZlgApSQV1SfDck2LPgRdF+4TQnJSDHCTP6DC
         pS7uc7qMr56H9fvLtv6hNEm4gRSWAZSPv35/prTLxS2K2CNEEnmKEBYHkK/S3t+fQEOp
         MPDw==
X-Gm-Message-State: AOAM532/dBIxSTXMRfpVsJjf4UDY02VNvIscWztbIPB1vbWAOPMwdUAP
        9MUZNjhEaMCDueKVYl5XLn/mhlaFKpCCIzmAmY462VY8xAaJ
X-Google-Smtp-Source: ABdhPJxoaysSvm/vwPCZE9vCdUOjIG9huA7+Z034KzCf5cRvCelFCyvZ8u9yGuK1MunvlnEZcan1x4bLAO6PZp/nV+pIRNS2I2e7
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:149:: with SMTP id j9mr21536639ilr.57.1617644058638;
 Mon, 05 Apr 2021 10:34:18 -0700 (PDT)
Date:   Mon, 05 Apr 2021 10:34:18 -0700
In-Reply-To: <0000000000003798d705aedd870d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007cfd9b05bf3d1b70@google.com>
Subject: Re: [syzbot] memory leak in mgmt_cmd_status
From:   syzbot <syzbot+80f5bab4eb14d14e7386@syzkaller.appspotmail.com>
To:     anant.thazhemadam@gmail.com, davem@davemloft.net,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e49d033b Linux 5.12-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12579f11d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8dbd3c72fdc7777
dashboard link: https://syzkaller.appspot.com/bug?extid=80f5bab4eb14d14e7386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b1696d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c5a30ed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80f5bab4eb14d14e7386@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810ddf4700 (size 232):
  comm "kworker/u5:2", pid 8406, jiffies 4294997792 (age 10.670s)
  hex dump (first 32 bytes):
    d0 f0 af 0e 81 88 ff ff d0 f0 af 0e 81 88 ff ff  ................
    00 00 00 00 00 00 00 00 00 f0 af 0e 81 88 ff ff  ................
  backtrace:
    [<ffffffff8364af8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:412
    [<ffffffff83c5f871>] alloc_skb include/linux/skbuff.h:1103 [inline]
    [<ffffffff83c5f871>] mgmt_cmd_status+0x31/0x160 net/bluetooth/mgmt_util.c:102
    [<ffffffff83c2a669>] mgmt_set_discoverable_complete+0x1b9/0x1e0 net/bluetooth/mgmt.c:1357
    [<ffffffff83c579d8>] discoverable_update_work+0x88/0xb0 net/bluetooth/hci_request.c:2806
    [<ffffffff812595d9>] process_one_work+0x2c9/0x600 kernel/workqueue.c:2275
    [<ffffffff81259ec9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2421
    [<ffffffff812615f8>] kthread+0x178/0x1b0 kernel/kthread.c:292
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


