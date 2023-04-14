Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5393F6E22C2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjDNL7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDNL7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:59:32 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5F5AD04
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 04:59:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t16so5630754ybi.13
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681473562; x=1684065562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50nW8LGcfi76dS0xmW8SA7TaUnAoz8p4AdZSpVmNHQg=;
        b=4m9nGHy42HSBzjedWIsz3mvEedrcU5JXLRwsDcxmriKtsaXCEYw6nk4M3//2izk9QN
         9M+30+I7iSm6S5V1Cu+AgB4fsmZmvZZ15IbjqeM5y2G80io3aV2oFtvisX1/LPrrHCeT
         nh8gSdomeuS8XbbKvOANvdNCeow5CGm4idLYyrH8VpV5VU+uDHQ22Ap/ptwsGAQN20Zo
         ID12Z4fBvVe8FXTQVMaHShcmZThlV3nVqnwhhFKMCTeVl12t/dwrIwFjQPsaA/z5FgEm
         +BZkzcpAYWCHvcJtSCmEfkVe4g8Ze8dwsM9tIyWmeA06WAP7Y/jQqOmnFX9yjUsaSBqj
         wFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681473562; x=1684065562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50nW8LGcfi76dS0xmW8SA7TaUnAoz8p4AdZSpVmNHQg=;
        b=Q7Pu4DX98l6qHLlD2CMeMw2X6mJDhBxLwb4djQfqAAvKjcRVipVIKFlxCn991AtvdK
         wm38F3qJH8jGZvatH/yjaKZdrmc7wN1Jlyr4FH8hw1wR0KYSb+lAczUO5yOLyzZHMB1O
         e38abPqVcvSXGlfH5RdkOyAgpjXlZ+azNSfX2+gJYQJtWm9Xfg4RCDG3uVcrB1RB6Ggx
         P3XXoQrW8R3DmxN35gmEd8FyY8fs9yIKxDRUvkeUM5xtto+Lx9oM0Cazz34IRJl7EXN9
         iK5oq+2DB9uEbj1+pwKHWz6RBoreSyvj62FPJaOLs/A7K9C3LocguNDgqoeY1Zv1+Fqz
         6dzg==
X-Gm-Message-State: AAQBX9dOdfEbuqRsjHYoD+GvYZicl2lV3wNoZw76BXrPBHtHeWx6DVH/
        2rU3pSx21JshSroX7jS0r9DUXiPmkU6VTw4683YFhA==
X-Google-Smtp-Source: AKy350bNcOWfxQ0ryxxJFYMoLKZBO1+cEZVQEpJsYTmGOvdyZof4LY0nU0/ynZ/4miaDf5QDUn5QzM7dyBk7igweRjQ=
X-Received: by 2002:a25:d196:0:b0:b8f:6faa:6480 with SMTP id
 i144-20020a25d196000000b00b8f6faa6480mr1126669ybg.7.1681473561864; Fri, 14
 Apr 2023 04:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAGyP=7djcPOF6JHvVV6Zmpvtb_nHsDM7865C3e4A5F06kF8FsQ@mail.gmail.com>
In-Reply-To: <CAGyP=7djcPOF6JHvVV6Zmpvtb_nHsDM7865C3e4A5F06kF8FsQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 14 Apr 2023 07:59:10 -0400
Message-ID: <CAM0EoM=wqtAF932JK+u7ZOYNF0dAfMHTe7aHM1oyYeMbczzVNA@mail.gmail.com>
Subject: Re: KASAN: slab-use-after-free Read in tcf_action_destroy
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will look at this unless someone already has figured it out...

cheers,
jama

On Thu, Apr 13, 2023 at 10:41=E2=80=AFPM Palash Oswal <oswalpalash@gmail.co=
m> wrote:
>
> Hello,
> I found the following issue using syzkaller with enriched corpus on:
> HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
> git tree: linux
>
> C Reproducer : https://gist.github.com/oswalpalash/278b6fb713f37fa8d4625d=
6be703550d
> Kernel .config :
> https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f
>
> syz-repro :
> r0 =3D socket$nl_route(0x10, 0x3, 0x0)
> r1 =3D socket(0x10, 0x3, 0x0)
> r2 =3D socket(0x10, 0x3, 0x0)
> sendmsg$nl_route_sched(r2, &(0x7f0000000180)=3D{0x0, 0x0,
> &(0x7f0000000140)=3D{0x0, 0x140}}, 0x0)
> getsockname$packet(r2, &(0x7f0000000080)=3D{0x11, 0x0, <r3=3D>0x0, 0x1,
> 0x0, 0x6, @broadcast}, &(0x7f0000000100)=3D0xab)
> sendmsg$nl_route_sched(r1, &(0x7f0000005840)=3D{0x0, 0x0,
> &(0x7f0000000780)=3D{&(0x7f0000000240)=3DANY=3D[@ANYBLOB=3D"4800000024000=
b0e00"/20,
> @ANYRES32=3Dr3, @ANYBLOB=3D"00000000ffffffff0000000008000100687462001c000=
2001800020003"],
> 0x48}}, 0x0)
> sendmsg$nl_route_sched(r0, &(0x7f00000000c0)=3D{0x0, 0x0,
> &(0x7f0000000180)=3D{&(0x7f00000007c0)=3D@newtfilter=3D{0x40, 0x2c, 0xd27=
,
> 0x0, 0x0, {0x0, 0x0, 0x0, r3, {}, {}, {0xfff3}},
> [@filter_kind_options=3D@f_flower=3D{{0xb}, {0x10, 0x2,
> [@TCA_FLOWER_KEY_ETH_DST=3D{0xa, 0x4, @local}]}}]}, 0x40}}, 0x0)
> (fail_nth: 19)
>
>
> Console log :
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in tcf_action_destroy+0x17f/0x1b0
> Read of size 8 at addr ffff88811024d800 by task kworker/u4:1/11
>
> CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted
> 6.3.0-rc6-pasta-00035-g0bcc40255504 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: tc_filter_workqueue fl_destroy_filter_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xd9/0x150
>  print_address_description.constprop.0+0x2c/0x3c0
>  kasan_report+0x11c/0x130
>  tcf_action_destroy+0x17f/0x1b0
>  tcf_exts_destroy+0xc5/0x160
>  __fl_destroy_filter+0x1a/0x100
>  process_one_work+0x991/0x15c0
>  worker_thread+0x669/0x1090
>  kthread+0x2e8/0x3a0
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
> Allocated by task 9570:
>  kasan_save_stack+0x22/0x40
>  kasan_set_track+0x25/0x30
>  __kasan_kmalloc+0xa3/0xb0
>  tcf_exts_init_ex+0xe4/0x5a0
>  fl_change+0x56f/0x4a20
>  tc_new_tfilter+0x995/0x22a0
>  rtnetlink_rcv_msg+0x996/0xd50
>  netlink_rcv_skb+0x165/0x440
>  netlink_unicast+0x547/0x7f0
>  netlink_sendmsg+0x926/0xe30
>  sock_sendmsg+0xde/0x190
>  ____sys_sendmsg+0x71c/0x900
>  ___sys_sendmsg+0x110/0x1b0
>  __sys_sendmsg+0xf7/0x1c0
>  do_syscall_64+0x39/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Freed by task 9570:
>  kasan_save_stack+0x22/0x40
>  kasan_set_track+0x25/0x30
>  kasan_save_free_info+0x2b/0x40
>  ____kasan_slab_free+0x13b/0x1a0
>  __kmem_cache_free+0xcd/0x2c0
>  tcf_exts_destroy+0xe5/0x160
>  tcf_exts_init_ex+0x484/0x5a0
>  fl_change+0x56f/0x4a20
>  tc_new_tfilter+0x995/0x22a0
>  rtnetlink_rcv_msg+0x996/0xd50
>  netlink_rcv_skb+0x165/0x440
>  netlink_unicast+0x547/0x7f0
>  netlink_sendmsg+0x926/0xe30
>  sock_sendmsg+0xde/0x190
>  ____sys_sendmsg+0x71c/0x900
>  ___sys_sendmsg+0x110/0x1b0
>  __sys_sendmsg+0xf7/0x1c0
>  do_syscall_64+0x39/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The buggy address belongs to the object at ffff88811024d800
>  which belongs to the cache kmalloc-256 of size 256
> The buggy address is located 0 bytes inside of
>  freed 256-byte region [ffff88811024d800, ffff88811024d900)
>
> The buggy address belongs to the physical page:
> page:ffffea0004409340 refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x11024d
> flags: 0x57ff00000000200(slab|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000000200 ffff888012440500 ffffea000436ea10 ffffea00041aec10
> raw: 0000000000000000 ffff88811024d000 0000000100000008 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask
> 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE),
> pid 8017, tgid 8017 (syz-executor.0), ts 60719725774, free_ts
> 60718847244
>  get_page_from_freelist+0x1190/0x2e20
>  __alloc_pages+0x1cb/0x4a0
>  cache_grow_begin+0x9b/0x3b0
>  cache_alloc_refill+0x27f/0x380
>  __kmem_cache_alloc_node+0x360/0x3f0
>  __kmalloc+0x4e/0x190
>  security_sb_alloc+0x105/0x240
>  alloc_super+0x236/0xb60
>  sget_fc+0x142/0x7c0
>  vfs_get_super+0x2d/0x280
>  vfs_get_tree+0x8d/0x350
>  path_mount+0x1342/0x1e40
>  __x64_sys_mount+0x283/0x300
>  do_syscall_64+0x39/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>  free_pcp_prepare+0x5d5/0xa50
>  free_unref_page+0x1d/0x490
>  vfree+0x180/0x7e0
>  delayed_vfree_work+0x57/0x70
>  process_one_work+0x991/0x15c0
>  worker_thread+0x669/0x1090
>  kthread+0x2e8/0x3a0
>  ret_from_fork+0x1f/0x30
>
> Memory state around the buggy address:
>  ffff88811024d700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88811024d780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88811024d800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff88811024d880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88811024d900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
