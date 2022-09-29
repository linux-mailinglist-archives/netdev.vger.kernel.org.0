Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC23B5EFE97
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 22:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiI2UVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 16:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiI2UVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 16:21:31 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C5B54672;
        Thu, 29 Sep 2022 13:21:30 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id o2so3881926lfc.10;
        Thu, 29 Sep 2022 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sagugnC1p3O2ufwBdLs7xoWpbr3zH2wnWwkP7ywiAGM=;
        b=hjCGQT+XAP4AkVVX0DGnJBXlGFFlxRlQl82GPT2LUXa/IzmFL+A5qvCRHBpX9fdpSs
         KV7p63+M3dOmZd0JxRtAKkFp24EoZ2ch2BW9JYkoc3ZfDG98WXKSL48rbomdFlV1s22C
         kalwtUZXaXSrxTLSIgHH3Q+WPf6qq9+3btWzh3fFwuczdZfjOw3qSIhqQnSZCd5fuY9Q
         FQmNwi7WJkRvbLr8GfZ34eoEXF8ogP6SQKcLzlIkIa+37EMp9TpPH/gLRQQ5XxJo88SG
         fenach9BD9F5VDhW+ee98S0GdYiX8S/kt/lgvmZyRrVwikRIPzddN3ncCh38GnD329Xp
         Zsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sagugnC1p3O2ufwBdLs7xoWpbr3zH2wnWwkP7ywiAGM=;
        b=aVhWi7riEwNV2aGP0OtRMy24YirTf5lFAs1X52dQ9O2LGng6IoXsflT6yUNEDXjIM1
         3JT3ivCONzcMgmBy6VMwykHUo5Axuf5sG0PryhBmM+Adu5aYPR+5u9+V2gyaJ+Y0i+pV
         KBwEx72tPwLp5+eVhOeGqJLg99EjyYUifZXquCcP+Za8O73E7kaoWxQ4EthwRSUoHKgE
         V/214cV89WOY9gyyTaqnHjOQmYXKvoFJjVMnjBU/UMLitn/oSOGZ6HqslJVdWlmeUcXi
         Vo7qPr+dfnMdZNgfAi1LMphRsx5P7KhvJSAbqkEPbuA9G8dZCil4zV9RKtpvYiBI6MTG
         95wA==
X-Gm-Message-State: ACrzQf30HRsevYwZMo7lWdnRJ5DJ4YSMGdrEfHr+j9tjKVNRPpJsmE20
        5Z5sHxnOtxrdIjR7xRU4btXsty0mo9hfZN+NNCk=
X-Google-Smtp-Source: AMsMyM7/jWK5SnryhSQsXC2EN9BRyiLwr4h25RrugNSp9ryZUe+2R9gYcbD2XjLB2FyrHLGj2NZ1bfeFl7jOe7fdpJE=
X-Received: by 2002:a05:6512:3612:b0:499:aea7:8bed with SMTP id
 f18-20020a056512361200b00499aea78bedmr2020399lfs.26.1664482888687; Thu, 29
 Sep 2022 13:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAJNyHpLhfhfGUDvrFaFQ4pMPYYfsnSrfp=1mDCp8c8Kf91OP2Q@mail.gmail.com>
In-Reply-To: <CAJNyHpLhfhfGUDvrFaFQ4pMPYYfsnSrfp=1mDCp8c8Kf91OP2Q@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 29 Sep 2022 13:21:17 -0700
Message-ID: <CABBYNZKSnFJkyMoHn-TU1VJQz3WNNt0pC8Nvzdxb3-4-RtcQGw@mail.gmail.com>
Subject: Re: KASAN: use-after-free in __mutex_lock
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kim,

On Sat, Sep 3, 2022 at 1:09 PM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Hello, I am Sungwoo Kim (https://sung-woo.kim) from Purdue University.
>
> We report a bug found by FuzzBT, a modified version of syzkaller.
> It looks similar to the recent bug:
> https://lore.kernel.org/lkml/20220622082716.478486-1-lee.jones@linaro.org
>
> We propose to add l2cap_chan_hold_unless_zero() for after calling
> __l2cap_get_chan_blah().
>
> Bluetooth: l2cap_core.c:static void l2cap_chan_destroy(struct kref *kref)
> Bluetooth: chan 0000000023c4974d
> Bluetooth: parent 00000000ae861c08
> ==================================================================
> BUG: KASAN: use-after-free in __mutex_waiter_is_first
> kernel/locking/mutex.c:191 [inline]
> BUG: KASAN: use-after-free in __mutex_lock_common
> kernel/locking/mutex.c:671 [inline]
> BUG: KASAN: use-after-free in __mutex_lock+0x278/0x400
> kernel/locking/mutex.c:729
> Read of size 8 at addr ffff888006a49b08 by task kworker/u3:2/389
>
> CPU: 0 PID: 389 Comm: kworker/u3:2 Not tainted 5.15.0 #14
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: hci0 hci_rx_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x7e/0xb7 lib/dump_stack.c:106
>  print_address_description+0x88/0x3b0 mm/kasan/report.c:256
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report+0x172/0x1c0 mm/kasan/report.c:459
>  __asan_load8+0x80/0x90 mm/kasan/generic.c:256
>  __mutex_waiter_is_first kernel/locking/mutex.c:191 [inline]
>  __mutex_lock_common kernel/locking/mutex.c:671 [inline]
>  __mutex_lock+0x278/0x400 kernel/locking/mutex.c:729
>  __mutex_lock_slowpath+0x13/0x20 kernel/locking/mutex.c:979
>  mutex_lock+0x91/0xf0 kernel/locking/mutex.c:280
>  l2cap_chan_lock include/net/bluetooth/l2cap.h:890 [inline]
>  l2cap_connect_create_rsp net/bluetooth/l2cap_core.c:4431 [inline]
>  l2cap_bredr_sig_cmd+0xc7c/0x4060 net/bluetooth/l2cap_core.c:5865
>  l2cap_sig_channel net/bluetooth/l2cap_core.c:6633 [inline]
>  l2cap_recv_frame+0x71e/0xa00 net/bluetooth/l2cap_core.c:7899
>  l2cap_recv_acldata+0x3a2/0x6c0 net/bluetooth/l2cap_core.c:8641
>  hci_acldata_packet net/bluetooth/hci_core.c:5100 [inline]
>  hci_rx_work+0x39c/0x500 net/bluetooth/hci_core.c:5307
>  process_one_work+0x28c/0x440 kernel/workqueue.c:2297
>  worker_thread+0x434/0x5d0 kernel/workqueue.c:2444
>  kthread+0x214/0x250 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30
>
> Allocated by task 389:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  ____kasan_kmalloc+0xd6/0x110 mm/kasan/common.c:513
>  __kasan_kmalloc+0x9/0x10 mm/kasan/common.c:522
>  kasan_kmalloc include/linux/kasan.h:264 [inline]
>  kmem_cache_alloc_trace+0x1a9/0x230 mm/slub.c:3240
>  kmalloc include/linux/slab.h:591 [inline]
>  kzalloc include/linux/slab.h:721 [inline]
>  l2cap_chan_create+0x4c/0x2c0 net/bluetooth/l2cap_core.c:481
>  l2cap_sock_alloc+0xfa/0x150 net/bluetooth/l2cap_sock.c:1867
>  l2cap_sock_new_connection_cb+0xc9/0x140 net/bluetooth/l2cap_sock.c:1467
>  l2cap_connect+0x3eb/0x850 net/bluetooth/l2cap_core.c:4274
>  l2cap_connect_req net/bluetooth/l2cap_core.c:4387 [inline]
>  l2cap_bredr_sig_cmd+0x13fd/0x4060 net/bluetooth/l2cap_core.c:5860
>  l2cap_sig_channel net/bluetooth/l2cap_core.c:6633 [inline]
>  l2cap_recv_frame+0x71e/0xa00 net/bluetooth/l2cap_core.c:7899
>  l2cap_recv_acldata+0x3a2/0x6c0 net/bluetooth/l2cap_core.c:8641
>  hci_acldata_packet net/bluetooth/hci_core.c:5100 [inline]
>  hci_rx_work+0x39c/0x500 net/bluetooth/hci_core.c:5307
>  process_one_work+0x28c/0x440 kernel/workqueue.c:2297
>  worker_thread+0x434/0x5d0 kernel/workqueue.c:2444
>  kthread+0x214/0x250 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30
>
> Freed by task 364:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
>  kasan_set_free_info+0x23/0x40 mm/kasan/generic.c:360
>  ____kasan_slab_free+0x13a/0x170 mm/kasan/common.c:366
>  __kasan_slab_free+0x11/0x20 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:230 [inline]
>  slab_free_hook mm/slub.c:1700 [inline]
>  slab_free_freelist_hook+0x100/0x1a0 mm/slub.c:1726
>  slab_free mm/slub.c:3492 [inline]
>  kfree+0xe0/0x270 mm/slub.c:4552
>  l2cap_chan_destroy net/bluetooth/l2cap_core.c:524 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  l2cap_chan_put+0x147/0x190 net/bluetooth/l2cap_core.c:540
>  l2cap_sock_cleanup_listen net/bluetooth/l2cap_sock.c:1449 [inline]
>  l2cap_sock_teardown_cb+0x33a/0x3e0 net/bluetooth/l2cap_sock.c:1564
>  l2cap_chan_close+0x297/0x640
>  l2cap_sock_shutdown+0x6cc/0x8b0 net/bluetooth/l2cap_sock.c:1367
>  l2cap_sock_release+0x7d/0x130 net/bluetooth/l2cap_sock.c:1411
>  __sock_release+0x80/0x170 net/socket.c:649
>  sock_close+0x1e/0x30 net/socket.c:1314
>  __fput+0x2de/0x5d0 fs/file_table.c:280
>  ____fput+0x1a/0x20 fs/file_table.c:313
>  task_work_run+0x102/0x150 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0x511/0x1260 kernel/exit.c:825
>  do_group_exit+0xd9/0x1a0 kernel/exit.c:922
>  get_signal+0x397/0x11a0 kernel/signal.c:2855
>  arch_do_signal_or_restart+0x3b/0x3b0 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x103/0x1a0 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x2a/0x40 kernel/entry/common.c:300
>  do_syscall_64+0x52/0xc0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff888006a49800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 776 bytes inside of
>  1024-byte region [ffff888006a49800, ffff888006a49c00)
> The buggy address belongs to the page:
> page:000000004d4d912c refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x6a48
> head:000000004d4d912c order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
> raw: 000fffffc0010200 dead000000000100 dead000000000122 ffff888001041dc0
> raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff888006a49a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888006a49a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888006a49b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                       ^
>  ffff888006a49b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888006a49c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 2c9de67da..0e7978228 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4309,7 +4309,10 @@ static int l2cap_connect_create_rsp(struct
> l2cap_conn *conn,
>
>         err = 0;
>
> -       l2cap_chan_lock(chan);
> +       chan = l2cap_chan_hold_unless_zero(chan);
> +       if (chan) {
> +               l2cap_chan_lock(chan);
> +       }

This obviously doesn't work since you will need to bail out if chan is
NULL, so we would need to do something like:

if (!chan) {
  err = -EBADSLT;
  goto unlock;
}

l2cap_chan_lock(chan);

>
>         switch (result) {
>         case L2CAP_CR_SUCCESS:
> @@ -4336,6 +4339,7 @@ static int l2cap_connect_create_rsp(struct
> l2cap_conn *conn,
>         }
>
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>
>  unlock:
>         mutex_unlock(&conn->chan_lock);
>
>
> Best regards,
> Sungwoo Kim.



-- 
Luiz Augusto von Dentz
