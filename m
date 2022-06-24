Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B453F559330
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiFXGQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiFXGQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:16:08 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A748F4D629
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:16:06 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id l11so2803345ybu.13
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9U4jnUWe/pEdewOOkGcBCIFzqjLpolMViKZUaoGMMqw=;
        b=FoZLT+VYXvqlF4eunk+B04xnzsCWRpggzMGCsKLT9R2BghKimftncYS0kQUrzVXWu6
         2U1rj/PjsPPDcqEX4IsdWvJUDL+UTvflr0mxLSBNTPzXiXmUCqG3wdeoQ6dDo/WaqDTb
         ynSNNEOYaMN2bKRzVu03Y8rwvFsBoL5HwbqFYL2hzY4womlMUFN66rObLHtagFOMvDC8
         74YZ44dAAtnUB1hrkaXwiJz1Fj1Kf6ceQ3hT/Z5Guh5IzvcX40kszX+ICFtFT6IQp8IZ
         OhmPfiwyNc6eE7z+SLuvIEiv4sToNgVcUUYNPBicGzwDAsIydDkQ2Nfle5eHJTciuolV
         hREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9U4jnUWe/pEdewOOkGcBCIFzqjLpolMViKZUaoGMMqw=;
        b=ALJTXn7nG1AXDrIlda9s9/hCjlrMqAIKGnKYoWkCYb1UpmwGZLkTtYcpNOXr2bQ+tt
         GVUXmqJOqvOWber49JSXCGdeKbyz5e+3IRW3wOhR4ef4HChnqOafpjh4P4YmbfZHJrmO
         AXiR6el+xFFErhBxZyT1K+qB/6XWivbQOes7zznZBj69gFb+LesOz95qdcA/arOlT9hu
         3w0bpyP5q8BcOv0/q6woRsMvXug7XV+XsyBSpWP9O7bl38OCnWp8XHI1zNllrD9FEX3A
         wJX/HXVT0NSl4WJqhpvB0WuyjKmY+v3xtMpdPBzQbqx96JBy+i0j7AP5PPjNKCC9kPfH
         Nevg==
X-Gm-Message-State: AJIora/IBPd3jm6+JkQ5dFDrpkHcP5Oh0l0fAqg6v10W2aYe5L0Btwsp
        W5JuayCryvxqrl1GVF5cuHDTLvw0sW80D2ZS8wFla9nLUL/eGg==
X-Google-Smtp-Source: AGRyM1tzPp1D7oz8z/Ft+yJMHAug9qt29/OlEsr7dLD+goAbJkpUohG8Ppia9CFEFiafpZwBK+ocbYjIDzNT8aga57c=
X-Received: by 2002:a25:ae23:0:b0:668:daf8:c068 with SMTP id
 a35-20020a25ae23000000b00668daf8c068mr13227002ybj.427.1656051365435; Thu, 23
 Jun 2022 23:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <YrVUujEka5jSXZvt@archdragon>
In-Reply-To: <YrVUujEka5jSXZvt@archdragon>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Jun 2022 08:15:54 +0200
Message-ID: <CANn89iKLpGamedvzZjnhpNUUpPJ7ueiGo62DH0XM+omQvhr9HA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in cfusbl_device_notify
To:     "Dae R. Jeong" <threeearcat@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 8:08 AM Dae R. Jeong <threeearcat@gmail.com> wrote:
>
> Hello,
>
> We observed a crash "KASAN: use-after-free Read in cfusbl_device_notify" during fuzzing.
>
> Unfortunately, we have not found a reproducer for the crash yet. We
> will inform you if we have any update on this crash.
>
> Detailed crash information is attached at the end of this email.
>
>
> Best regards,
> Dae R. Jeong.
> ------
>
> - Kernel commit:
> b13baccc3850ca
>
> - Crash report:
> ==================================================================
> BUG: KASAN: use-after-free in cfusbl_device_notify+0x155/0xf40 net/caif/caif_usb.c:138
> Read of size 8 at addr ffff88804bc4c6f0 by task kworker/u8:0/18109

This is a known problem.

Some drivers do not like NETDEV_UNREGISTER being delivered multiple times.

Make sure in your fuzzing to have NET_DEV_REFCNT_TRACKER=y

Thanks.


>
> CPU: 1 PID: 18109 Comm: kworker/u8:0 Not tainted 5.19.0-rc2-31838-gef9c98f9637f #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x240/0x35a lib/dump_stack.c:106
>  print_address_description+0x65/0x4f0 mm/kasan/report.c:313
>  print_report+0xf4/0x1e0 mm/kasan/report.c:429
>  kasan_report+0xe5/0x110 mm/kasan/report.c:491
>  cfusbl_device_notify+0x155/0xf40 net/caif/caif_usb.c:138
>  notifier_call_chain kernel/notifier.c:87 [inline]
>  raw_notifier_call_chain+0xd4/0x170 kernel/notifier.c:455
>  call_netdevice_notifiers_info net/core/dev.c:1943 [inline]
>  call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
>  call_netdevice_notifiers net/core/dev.c:1995 [inline]
>  netdev_wait_allrefs_any net/core/dev.c:10225 [inline]
>  netdev_run_todo+0x14e6/0x23c0 net/core/dev.c:10337
>  default_device_exit_batch+0x99a/0xa10 net/core/dev.c:11329
>  ops_exit_list net/core/net_namespace.c:167 [inline]
>  cleanup_net+0xd23/0x15a0 net/core/net_namespace.c:594
>  process_one_work+0x909/0x12b0 kernel/workqueue.c:2289
>  worker_thread+0xab1/0x1320 kernel/workqueue.c:2436
>  kthread+0x294/0x330 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
> Allocated by task 6688:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:436 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
>  __kasan_kmalloc+0xac/0xe0 mm/kasan/common.c:524
>  kasan_kmalloc include/linux/kasan.h:234 [inline]
>  __kmalloc_node+0xed/0x780 mm/slub.c:4465
>  kmalloc_node include/linux/slab.h:623 [inline]
>  kvmalloc_node+0x6e/0x1a0 mm/util.c:613
>  kvmalloc include/linux/slab.h:750 [inline]
>  kvzalloc include/linux/slab.h:758 [inline]
>  alloc_netdev_mqs+0x94/0x1da0 net/core/dev.c:10576
>  rtnl_create_link+0x4ec/0x1360 net/core/rtnetlink.c:3241
>  veth_newlink+0x4a9/0x1810 drivers/net/veth.c:1749
>  rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:3580 [inline]
>  rtnl_newlink+0x251d/0x2fc0 net/core/rtnetlink.c:3593
>  rtnetlink_rcv_msg+0x1103/0x1a60 net/core/rtnetlink.c:6089
>  netlink_rcv_skb+0x2b6/0x670 net/netlink/af_netlink.c:2501
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0xc68/0xff0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x11a0/0x1680 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:693 [inline]
>  sock_sendmsg net/socket.c:713 [inline]
>  __sys_sendto+0x544/0x770 net/socket.c:2098
>  __do_sys_sendto net/socket.c:2110 [inline]
>  __se_sys_sendto net/socket.c:2106 [inline]
>  __x64_sys_sendto+0x1bb/0x250 net/socket.c:2106
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Freed by task 18109:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track+0x3d/0x60 mm/kasan/common.c:45
>  kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
>  ____kasan_slab_free+0xb2/0xf0 mm/kasan/common.c:366
>  kasan_slab_free include/linux/kasan.h:200 [inline]
>  slab_free_hook mm/slub.c:1727 [inline]
>  slab_free_freelist_hook+0x20c/0x540 mm/slub.c:1753
>  slab_free mm/slub.c:3507 [inline]
>  kfree+0x117/0x7e0 mm/slub.c:4555
>  device_release+0xf5/0x390
>  kobject_cleanup+0x340/0x4e0 lib/kobject.c:673
>  netdev_run_todo+0x211c/0x23c0 net/core/dev.c:10358
>  default_device_exit_batch+0x99a/0xa10 net/core/dev.c:11329
>  ops_exit_list net/core/net_namespace.c:167 [inline]
>  cleanup_net+0xd23/0x15a0 net/core/net_namespace.c:594
>  process_one_work+0x909/0x12b0 kernel/workqueue.c:2289
>  worker_thread+0xab1/0x1320 kernel/workqueue.c:2436
>  kthread+0x294/0x330 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
>
> The buggy address belongs to the object at ffff88804bc4c000
>  which belongs to the cache kmalloc-cg-4k of size 4096
> The buggy address is located 1776 bytes inside of
>  4096-byte region [ffff88804bc4c000, ffff88804bc4d000)
>
> The buggy address belongs to the physical page:
> page:ffffea00012f1200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4bc48
> head:ffffea00012f1200 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000122 ffff88801844c140
> raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6688, tgid 6688 (syz-executor.0), ts 297836664488, free_ts 31867390869
>  prep_new_page mm/page_alloc.c:2456 [inline]
>  get_page_from_freelist+0xa7c/0xf50 mm/page_alloc.c:4198
>  __alloc_pages+0x30e/0x710 mm/page_alloc.c:5426
>  alloc_slab_page+0x66/0x250 mm/slub.c:1797
>  allocate_slab+0xc0/0xe40 mm/slub.c:1942
>  new_slab mm/slub.c:2002 [inline]
>  ___slab_alloc+0x629/0x17a0 mm/slub.c:3002
>  __slab_alloc mm/slub.c:3089 [inline]
>  slab_alloc_node mm/slub.c:3180 [inline]
>  slab_alloc mm/slub.c:3222 [inline]
>  __kmalloc_track_caller+0x53a/0x600 mm/slub.c:4919
>  kmemdup+0x21/0x50 mm/util.c:129
>  _Z7kmemdupPKvU17pass_object_size0mj include/linux/fortify-string.h:456 [inline]
>  __addrconf_sysctl_register+0x97/0x680 net/ipv6/addrconf.c:7061
>  addrconf_sysctl_register+0x1c3/0x2a0 net/ipv6/addrconf.c:7126
>  ipv6_add_dev+0x170e/0x1f80 net/ipv6/addrconf.c:450
>  addrconf_notify+0xa36/0x3730 net/ipv6/addrconf.c:3532
>  notifier_call_chain kernel/notifier.c:87 [inline]
>  raw_notifier_call_chain+0xd4/0x170 kernel/notifier.c:455
>  call_netdevice_notifiers_info net/core/dev.c:1943 [inline]
>  call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
>  call_netdevice_notifiers net/core/dev.c:1995 [inline]
>  register_netdevice+0x23b1/0x32c0 net/core/dev.c:10078
>  hsr_dev_finalize+0x803/0xd50 net/hsr/hsr_device.c:539
>  hsr_newlink+0xba5/0xcf0 net/hsr/hsr_netlink.c:102
>  rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:3580 [inline]
>  rtnl_newlink+0x251d/0x2fc0 net/core/rtnetlink.c:3593
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1371 [inline]
>  free_pcp_prepare+0xa65/0xc90 mm/page_alloc.c:1421
>  free_unref_page_prepare mm/page_alloc.c:3343 [inline]
>  free_unref_page+0x7e/0x740 mm/page_alloc.c:3438
>  free_contig_range+0xd9/0x240 mm/page_alloc.c:9314
>  destroy_args+0x153/0xee4 mm/debug_vm_pgtable.c:1031
>  debug_vm_pgtable+0x4bd/0x553 mm/debug_vm_pgtable.c:1354
>  do_one_initcall+0x1a8/0x410 init/main.c:1295
>  do_initcall_level+0x168/0x21d init/main.c:1368
>  do_initcalls+0x50/0x91 init/main.c:1384
>  kernel_init_freeable+0x40d/0x59a init/main.c:1610
>  kernel_init+0x19/0x2c0 init/main.c:1499
>  ret_from_fork+0x1f/0x30
>
> Memory state around the buggy address:
>  ffff88804bc4c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88804bc4c600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88804bc4c680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff88804bc4c700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88804bc4c780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
