Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9C5483E59
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiADImy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiADImx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:42:53 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A06C061761;
        Tue,  4 Jan 2022 00:42:53 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id y130so81610037ybe.8;
        Tue, 04 Jan 2022 00:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2Mu/yLPI08BwOs4ENrx5eMAkD+Wr+U3dBWXV5FX6VSY=;
        b=c/WGsnSye+YudOci/VpOtQq5W+cvMoZPnV00eQJmRYv28XdiHX8GZTC8Yz/4HD+cvo
         SbornMjSbudqdENxcGeeQM4jFmdlTb0JIOtPMCLF/egajvcIz+fpF/3mjQ3pjlhJ1VAZ
         HJb0sX7eZJabBbCYqyAJIJsm5O/q//tn6xlyx8boSRHnvGkA5ySe4Z408gDkYxKyMi78
         /NKAMQQ9BQSWOLH1UCw83nvFSiPNtJBZEsv/SH6jpJY4IFD18LvBfuajjFdMuNXibXZ/
         K6xWQ2ho5pKMgEEGC5Gk215pIrvWY3cJBLC6DilZGVwmh6Hz/U1E2ESOcnxZNA/6Ici8
         WyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2Mu/yLPI08BwOs4ENrx5eMAkD+Wr+U3dBWXV5FX6VSY=;
        b=5iMi3reQB3X3Yf9V6CQdcSCQUoHYHNAJkjtH49d9tsUz0HC4/wOLsUah/x/LPm2l/4
         Bys4uLvxxX9v+n5o8RnrE8DlVfDHQRFJbiA2Ds+/a65IATzGhTdrEsHoLXyW/nJAi8Cu
         zgvLtKyiLXIiBNplJnweo/xwV2PMMmDMWHmmMdWEGIgTIbk2vor7Xbfw5jj1IOSxT1qX
         bVDgeqlq5EG4LlhJkkStmLEaRxYlLfr7LuykBMkQjS5CFxLXCJcP5n2FNqFFYs5+ovOz
         oC9BP1BzLUVvOAY0z8Sg7FYLIUCHqIUSpqFdA3vOjmRhNw6/jzM4N4KG3QIpTOcRIJ6L
         k/vg==
X-Gm-Message-State: AOAM530y6qpw/aUuHpQU2KpIwOcc15+vjp7PevmMcE2yRN4AZ1WClwjW
        NavcRCtQGlbBS0xrPrijEH+HJi1YW6mfEx+MBihFW4WjBOrRQqwT
X-Google-Smtp-Source: ABdhPJyICnYdCnhvxmn9XyQ16XC7PGiFGh8huMczNEoXVQaNTlnyrbJtDT/ZhOFGJsmecfYz8kMquy8INn1Yd+y2M74=
X-Received: by 2002:a25:b293:: with SMTP id k19mr54608303ybj.627.1641285772881;
 Tue, 04 Jan 2022 00:42:52 -0800 (PST)
MIME-Version: 1.0
From:   kvartet <xyru1999@gmail.com>
Date:   Tue, 4 Jan 2022 16:42:42 +0800
Message-ID: <CAFkrUshXhoAttBomV3ngTa2rWUebiKOb4D2QkXMrL+YB05Bx_g@mail.gmail.com>
Subject: INFO: task hung in sit_exit_batch_net
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Syzkaller to fuzz the latest Linux kernel, the following
crash was triggered.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output: https://paste.ubuntu.com/p/b8pTJKKYkB/plain/
kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Yiru Xu <xyru1999@gmail.com>


INFO: task kworker/u8:6:11437 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:6    state:D stack:26360 pid:11437 ppid:     2 flags:0x00004000
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 sit_exit_batch_net+0x88/0x770 net/ipv6/sit.c:1946
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:171
 cleanup_net+0x511/0xa90 net/core/net_namespace.c:593
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2298
 worker_thread+0x90/0xed0 kernel/workqueue.c:2445


Best Regards,
Yiru
