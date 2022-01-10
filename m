Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1355489AED
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiAJN6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiAJN6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:58:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE58C06173F;
        Mon, 10 Jan 2022 05:58:36 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u21so31348368edd.5;
        Mon, 10 Jan 2022 05:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Zv6nNmjBL9mdUVHQrZVrPUfNP72rmPO0vaJqzRNwPm0=;
        b=eNeyd7VkvL3EFVhOAN0t9KaX0VOIX2ef8PVYq8iwK/iiQHfUcrQ7kBBp8YGgLASla6
         wYGS2qDGsUae3lqGVmJ9jNVxMcJ8EZN0rh8QT4XNXmmyw+at+USAhnOhk6+JLKcCa4TT
         v2PFvXxxl/2aq/LvzEF6jINnyaITJ2Yw52+tqDnXHXAm5CRcVLi4eaWrfr6aB3eSOwfS
         ypQqwuhXCDxtJWg/ceqt8zvdjVSR6N/2mnACejcwHjnfpNwUDBEWnuvZxOA/4I4OIv0Q
         8D0cjXriSxo3bMZQ2B+aVIiISjPqqQltC5Gz4Q3TSFpSlMk9EE8YRa8r055sPqHgUT1z
         ihgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Zv6nNmjBL9mdUVHQrZVrPUfNP72rmPO0vaJqzRNwPm0=;
        b=vNF6P2rp1vqghGbbbAYjT54dAdZvxto9lkYfZK6OsxBhB95RrAFY+iY2Si2Hxxc8el
         mf38vnvBy8f/mU0C1oelq/wnBaceNEcdpmhRBjttvzlk5ys8gqqryR1YqCCSAOHV9KA7
         BWu6XmxTtGi9xuVi9+vGEK7//fC1S0uhn0c8Fo44TKSqTmABR6GcvQb0dezsWT4uQb/+
         GRSEzDAWkVhg0b5E+99Cpfcy3DicYNck6IYgvKkaPn0MHSjgqCBJIO55XamoUD6y3tnw
         8tD9UnNcLZ9D5mU+J0TSPLOMEuPEj370i1OQ8IbjawRStBifdFNRSdrWfVgsJK8YBB6T
         6PHA==
X-Gm-Message-State: AOAM532DxylkHPOqO69v/LLlpiny3gMJnyRDpDBvGn0LWrzITN3RarVh
        vm9M0cLFMR247vW0c013DfTQ5cvgIw7erNquapA=
X-Google-Smtp-Source: ABdhPJxMw7YveTYZcnantzdiaeFOIgFcZQ+hv5t0lchCsDI6lmJTCX23ISvar7KrZUY53K5+zR1dF/hvNLCi0S9V2Mg=
X-Received: by 2002:a17:907:1b21:: with SMTP id mp33mr57031688ejc.580.1641823115465;
 Mon, 10 Jan 2022 05:58:35 -0800 (PST)
MIME-Version: 1.0
From:   cruise k <cruise4k@gmail.com>
Date:   Mon, 10 Jan 2022 21:58:24 +0800
Message-ID: <CAKcFiNC_=CecbLM6tzUajWt1AopWZciu53JTx_SufEqOR+X6LQ@mail.gmail.com>
Subject: INFO: task hung in wg_noise_handshake_create_initiation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Syzkaller found the following issue:

HEAD commit: 75acfdb Linux 5.16-rc8
git tree: upstream
console output: https://pastebin.com/raw/4aZeyEi8
kernel config: https://pastebin.com/raw/XsnKfdRt

And hope the report log can help you.

INFO: task kworker/u17:18:25859 blocked for more than 145 seconds.
      Not tainted 5.16.0-rc8+ #10
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u17:18  state:D stack:25232 pid:25859 ppid:     2 flags:0x00004000
Workqueue: wg-kex-wg2 wg_packet_handshake_send_worker
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2550 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 rwsem_down_write_slowpath+0x664/0x1190 kernel/locking/rwsem.c:1151
 __down_write_common kernel/locking/rwsem.c:1268 [inline]
 __down_write_common kernel/locking/rwsem.c:1265 [inline]
 __down_write kernel/locking/rwsem.c:1277 [inline]
 down_write+0x135/0x150 kernel/locking/rwsem.c:1524
 wg_noise_handshake_create_initiation+0xb8/0x580
drivers/net/wireguard/noise.c:497
 wg_packet_send_handshake_initiation+0x187/0x340 drivers/net/wireguard/send.c:34
 wg_packet_handshake_send_worker+0x18/0x30 drivers/net/wireguard/send.c:51
 process_one_work+0x9df/0x16a0 kernel/workqueue.c:2298
 worker_thread+0x90/0xe20 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
