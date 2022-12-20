Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1473A651CC7
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiLTJCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiLTJCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:02:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39285F69
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671526917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=071Ihgv+kmny1BZSXDKdzb8PVaG1P2NHyCF3XVrgCTo=;
        b=HTBM5+G/yvopc9cDYNLHP9q8yRygDcJkLaRaQyimENlnRzUmm2ns+fkFDIzeuTGSijgQfb
        l50Z1BTQlNesP9Y+skpvKE7alqoJMJl4SB1NXjwCOcC4hh17rbG3yr9VtPoV3hvDL0neEt
        3dg8EsHKiVuxGnzxRsZfTrta4kygjBA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-s3F1HDm5NzuUKvya04NvJw-1; Tue, 20 Dec 2022 04:01:56 -0500
X-MC-Unique: s3F1HDm5NzuUKvya04NvJw-1
Received: by mail-wm1-f72.google.com with SMTP id r67-20020a1c4446000000b003d09b0fbf54so7755031wma.3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=071Ihgv+kmny1BZSXDKdzb8PVaG1P2NHyCF3XVrgCTo=;
        b=y2jT54cqILY9oYQxKbBK6GNmxoAcJir8m/YKnAZUSj2EHufhGBXrwyoUWDhbB3qFTB
         Nk3dHYJkayFcA9JFcgWjT9Jv0CoN+MX41qdr+U/rDN5JFl0ecf8S10BLcQnpLnV8oPdx
         Ust7rwf1tWbo1Wsr6nubaD9BaKA3QRCTqph+TT5lkFaCoMsMevneY8zn9Bog/WFtbqNu
         mtKroT89MhaGPbXltARq7N3s/i3SotM59YNoXyKXdHbl6cx4n1Qq/mimwY4pLzO9i9ZO
         y9hY3JaRBI0NI8SFPqSHO4p4/PTCSs1uvqZshMgaQiI2Imz3ZPu0BiDcG6Ut6OZELwGg
         /dZw==
X-Gm-Message-State: AFqh2kpUKWJiQFGy8OXhFrlg23z47nb8fum5+bXS5Y6LBoE33AHRbZht
        Rlu36z6ArvKzCV5xBpKuAdVDVuN758hOWKB2GSKsundcwVspb6WtQZOFyganUYghHLebe6HGx5y
        d54JGLux8lvNuQca2
X-Received: by 2002:a05:600c:1ca9:b0:3d3:4877:e556 with SMTP id k41-20020a05600c1ca900b003d34877e556mr10364502wms.29.1671526914567;
        Tue, 20 Dec 2022 01:01:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu4JnnjkOZIQePTi63UCTCNyqSf1vU1BN1/U2mLi5J2uZr6FsWYUxPZNdvxCTkCQ0NLciDuRw==
X-Received: by 2002:a05:600c:1ca9:b0:3d3:4877:e556 with SMTP id k41-20020a05600c1ca900b003d34877e556mr10364471wms.29.1671526914247;
        Tue, 20 Dec 2022 01:01:54 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id t187-20020a1c46c4000000b003d21759db42sm22401269wma.5.2022.12.20.01.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:01:53 -0800 (PST)
Message-ID: <d81e425ea627bf4228f19126dcb3dc3b79a412cc.camel@redhat.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in ovs_vport_locate
From:   Paolo Abeni <pabeni@redhat.com>
To:     syzbot <syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com>,
        davem@davemloft.net, dev@openvswitch.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pshelar@ovn.org,
        syzkaller-bugs@googlegroups.com
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Date:   Tue, 20 Dec 2022 10:01:51 +0100
In-Reply-To: <00000000000075036e05f03e23df@google.com>
References: <00000000000075036e05f03e23df@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 00:22 -0800, syzbot wrote:
> HEAD commit:    041fae9c105a Merge tag 'f2fs-for-6.2-rc1' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c5d020480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=836aafbf33f4fa6c
> dashboard link: https://syzkaller.appspot.com/bug?extid=8f4e2dcfcb3209ac35f9
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/30e749b24df4/disk-041fae9c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/dd6d972f5b02/vmlinux-041fae9c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/405163d7c7cc/bzImage-041fae9c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com
> 
> netlink: 208 bytes leftover after parsing attributes in process `syz-executor.4'.
> ==================================================================
> BUG: KASAN: use-after-free in read_pnet include/net/net_namespace.h:383 [inline]
> BUG: KASAN: use-after-free in ovs_dp_get_net net/openvswitch/datapath.h:195 [inline]
> BUG: KASAN: use-after-free in ovs_vport_locate+0x131/0x150 net/openvswitch/vport.c:103
> Read of size 8 at addr ffff88802055e360 by task syz-executor.4/5621
> 
> CPU: 0 PID: 5621 Comm: syz-executor.4 Not tainted 6.1.0-syzkaller-10971-g041fae9c105a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:306 [inline]
>  print_report+0x15e/0x461 mm/kasan/report.c:417
>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
>  read_pnet include/net/net_namespace.h:383 [inline]
>  ovs_dp_get_net net/openvswitch/datapath.h:195 [inline]
>  ovs_vport_locate+0x131/0x150 net/openvswitch/vport.c:103
>  lookup_datapath+0x54/0x3a0 net/openvswitch/datapath.c:1628
>  ovs_dp_reset_user_features net/openvswitch/datapath.c:1639 [inline]
>  ovs_dp_cmd_new+0xd5b/0x11c0 net/openvswitch/datapath.c:1848
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xd3/0x120 net/socket.c:734
>  ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f142348c0d9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f14240ff168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f14235abf80 RCX: 00007f142348c0d9
> RDX: 0000000000000800 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00007f14234e7ae9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffdd965a34f R14: 00007f14240ff300 R15: 0000000000022000
>  </TASK>
> 
> Allocated by task 5564:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>  __kasan_kmalloc+0xa3/0xb0 mm/kasan/common.c:380
>  kmalloc include/linux/slab.h:580 [inline]
>  kzalloc include/linux/slab.h:720 [inline]
>  ovs_dp_cmd_new+0x1a3/0x11c0 net/openvswitch/datapath.c:1796
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xd3/0x120 net/socket.c:734
>  ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 5564:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:518
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x13b/0x1a0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:177 [inline]
>  __cache_free mm/slab.c:3394 [inline]
>  __do_kmem_cache_free mm/slab.c:3580 [inline]
>  __kmem_cache_free+0xcd/0x3b0 mm/slab.c:3587
>  ovs_dp_cmd_new+0x25e/0x11c0 net/openvswitch/datapath.c:1884
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xd3/0x120 net/socket.c:734
>  ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Last potentially related work creation:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  __kasan_record_aux_stack+0x7b/0x90 mm/kasan/generic.c:488
>  insert_work+0x48/0x350 kernel/workqueue.c:1358
>  __queue_work+0x693/0x13b0 kernel/workqueue.c:1517
>  queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  addr_event.part.0+0x33e/0x4f0 drivers/infiniband/core/roce_gid_mgmt.c:853
>  addr_event drivers/infiniband/core/roce_gid_mgmt.c:824 [inline]
>  inet6addr_event+0x142/0x1c0 drivers/infiniband/core/roce_gid_mgmt.c:883
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
>  atomic_notifier_call_chain+0x74/0x180 kernel/notifier.c:225
>  ipv6_add_addr+0x1266/0x1de0 net/ipv6/addrconf.c:1165
>  addrconf_add_linklocal+0x1cc/0x590 net/ipv6/addrconf.c:3215
>  addrconf_addr_gen+0x326/0x370 net/ipv6/addrconf.c:3346
>  addrconf_dev_config+0x255/0x410 net/ipv6/addrconf.c:3391
>  addrconf_notify+0xfb6/0x1c80 net/ipv6/addrconf.c:3635
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
>  netdev_state_change net/core/dev.c:1319 [inline]
>  netdev_state_change+0x104/0x130 net/core/dev.c:1312
>  linkwatch_do_dev+0x10e/0x150 net/core/link_watch.c:182
>  __linkwatch_run_queue+0x23f/0x6a0 net/core/link_watch.c:235
>  linkwatch_event+0x4e/0x70 net/core/link_watch.c:278
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> Second to last potentially related work creation:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  __kasan_record_aux_stack+0x7b/0x90 mm/kasan/generic.c:488
>  insert_work+0x48/0x350 kernel/workqueue.c:1358
>  __queue_work+0x693/0x13b0 kernel/workqueue.c:1517
>  queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
>  queue_work include/linux/workqueue.h:503 [inline]
>  netdevice_queue_work drivers/infiniband/core/roce_gid_mgmt.c:659 [inline]
>  netdevice_event+0x5e9/0x8f0 drivers/infiniband/core/roce_gid_mgmt.c:802
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
>  call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
>  call_netdevice_notifiers net/core/dev.c:1996 [inline]
>  register_netdevice+0xfb4/0x1640 net/core/dev.c:10078
>  bond_newlink drivers/net/bonding/bond_netlink.c:560 [inline]
>  bond_newlink+0x4b/0xa0 drivers/net/bonding/bond_netlink.c:550
>  rtnl_newlink_create net/core/rtnetlink.c:3407 [inline]
>  __rtnl_newlink+0x10c2/0x1840 net/core/rtnetlink.c:3624
>  rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
>  rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
>  netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xd3/0x120 net/socket.c:734
>  __sys_sendto+0x23a/0x340 net/socket.c:2117
>  __do_sys_sendto net/socket.c:2129 [inline]
>  __se_sys_sendto net/socket.c:2125 [inline]
>  __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff88802055e300
>  which belongs to the cache kmalloc-192 of size 192
> The buggy address is located 96 bytes inside of
>  192-byte region [ffff88802055e300, ffff88802055e3c0)
> 
> The buggy address belongs to the physical page:
> page:ffffea0000815780 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88802055ef00 pfn:0x2055e
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffff888012040000 ffffea0000873fd0 ffffea000083f490
> raw: ffff88802055ef00 ffff88802055e000 000000010000000e 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 1, tgid 1 (swapper/0), ts 8303233753, free_ts 8269599359
>  prep_new_page mm/page_alloc.c:2531 [inline]
>  get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
>  __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
>  __alloc_pages_node include/linux/gfp.h:237 [inline]
>  kmem_getpages mm/slab.c:1363 [inline]
>  cache_grow_begin+0x94/0x390 mm/slab.c:2574
>  cache_alloc_refill+0x27f/0x380 mm/slab.c:2947
>  ____cache_alloc mm/slab.c:3023 [inline]
>  ____cache_alloc mm/slab.c:3006 [inline]
>  __do_cache_alloc mm/slab.c:3206 [inline]
>  slab_alloc_node mm/slab.c:3254 [inline]
>  __kmem_cache_alloc_node+0x44f/0x510 mm/slab.c:3544
>  kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
>  kmalloc include/linux/slab.h:580 [inline]
>  kzalloc include/linux/slab.h:720 [inline]
>  call_usermodehelper_setup+0x9c/0x340 kernel/umh.c:366
>  kobject_uevent_env+0xed3/0x1620 lib/kobject_uevent.c:614
>  device_add+0xb76/0x1e90 drivers/base/core.c:3498
>  rfkill_register+0x1a9/0xb00 net/rfkill/core.c:1070
>  wiphy_register+0x24ae/0x2ae0 net/wireless/core.c:1007
>  virt_wifi_make_wiphy drivers/net/wireless/virt_wifi.c:383 [inline]
>  virt_wifi_init_module+0x352/0x3da drivers/net/wireless/virt_wifi.c:665
>  do_one_initcall+0x141/0x790 init/main.c:1306
>  do_initcall_level init/main.c:1379 [inline]
>  do_initcalls init/main.c:1395 [inline]
>  do_basic_setup init/main.c:1414 [inline]
>  kernel_init_freeable+0x6f9/0x782 init/main.c:1634
>  kernel_init+0x1e/0x1d0 init/main.c:1522
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1446 [inline]
>  free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
>  free_unref_page_prepare mm/page_alloc.c:3369 [inline]
>  free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
>  __vunmap+0x85d/0xd30 mm/vmalloc.c:2727
>  free_work+0x5c/0x80 mm/vmalloc.c:100
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> Memory state around the buggy address:
>  ffff88802055e200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88802055e280: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
> > ffff88802055e300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                        ^
>  ffff88802055e380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88802055e400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================

@Eelco, @Aaron: could you please have a look? I think the
ovs_dp_cmd_new() error path does not clean correctly the to-be-deleted
datapath, possibly a ovs_dp_detach_port() call for the internal one is
missing.

Thanks,

Paolo

