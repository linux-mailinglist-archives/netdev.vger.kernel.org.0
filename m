Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F105A8B49
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiIACLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIACLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:11:50 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC1011B600;
        Wed, 31 Aug 2022 19:11:44 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id n125so16395364vsc.5;
        Wed, 31 Aug 2022 19:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=KroYBn34K+6IPJtG48KqQB05BBIR6Vj7x5xtnCrg9Fg=;
        b=gnvjcA9DHc9pt4Z0/Ob0C1C0SIcolbiussATC3LO8sqnoXYHemdh4iMd31d3Iy7Okv
         woacFuZluiomXIRm6Hk/J04VrgIdt82/MfVG3/5ybyiNYSbHfg8V93dPSLIcHsiyGIv8
         LQDS87Zp9NHj/qeow6WXotXauwQlAMGzQujKfzPwfgTkeo+5i8d2PDBluNbnz0J2Oe/E
         NKsuoMCHj9zjIiP9GTU+Jm0cPescpz6jIR69nXB5kD9DQLijmQFTFuUO7RCooS/VliVg
         BIRYOm6VHXfIaGg9Cy9erA5SwnpGJYN3zsa042UB0St4rtLaHjU7OwSlUqpHDknYnB2e
         DS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KroYBn34K+6IPJtG48KqQB05BBIR6Vj7x5xtnCrg9Fg=;
        b=OxDsc83F+f0eXsM0cq7vE6nw7rDl+DX2JNxwyIcdUB6bnyJaYbHEQB6thZRVM9VCpg
         +0e2LCA/Aup7hCeQHPTjqEp869Vq1fE2hHFSMse6GrfDeZ8Ur1GJgw6v0qUaMGI8eI7H
         DGw8WbP44gYe5smkRxYqpFyDvz9En3W4eiAUtHQDUwOtzG6pNrBC9EWaMm/27iqxPx8r
         dt0Zz2A5bHa/BbVSaN6fY5nrpLCCVU3q8Hlt3x3RBonNKUrbY0ytkm10IPvrndWPnGoU
         TIegPaA02FfEnGyIh4Zj4a2h/lVnrAmbZqfAOkEoTHOz1j1576MVw6741FOZbxJhYFri
         fbzQ==
X-Gm-Message-State: ACgBeo2UEQtxv0YT1jfKpijBSEtr6gVllfyQ4QWMCuCvOZ2W8r3LUbEF
        l4lzefLZ4qbW2RzX0iABdU7VSKm1PEerbEWkCq4lkvlIdkwTl8ti
X-Google-Smtp-Source: AA6agR7fYwlvcv87NG8oEAGqYd1R7EKZ3yRI/H1W1IFd2oowQGu+fVTNbwv8utKENrM/0o7Cj7ggNQNaTbzC4KkKDwk=
X-Received: by 2002:a67:e207:0:b0:390:f3f6:a2fc with SMTP id
 g7-20020a67e207000000b00390f3f6a2fcmr4562818vsa.42.1661998303578; Wed, 31 Aug
 2022 19:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAB7eexLO88g6ZQzyoDHhE_bW8FAYvS+-U31rOQXo3Ldrtphggw@mail.gmail.com>
In-Reply-To: <CAB7eexLO88g6ZQzyoDHhE_bW8FAYvS+-U31rOQXo3Ldrtphggw@mail.gmail.com>
From:   Rondreis <linhaoguo86@gmail.com>
Date:   Thu, 1 Sep 2022 10:11:32 +0800
Message-ID: <CAB7eexKDC9ozBc5Nf5xqvLdyGznRP=Q9ZbFtNBo0EKZ-B7o4CQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in free_netdev
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry forget to sent to LKML earlier

Rondreis <linhaoguo86@gmail.com> =E4=BA=8E2022=E5=B9=B48=E6=9C=8831=E6=97=
=A5=E5=91=A8=E4=B8=89 16:10=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> When fuzzing the Linux kernel driver v5.18.0, the following crash was tri=
ggered.
>
> HEAD commit: 4b0986a3613c92f4ec1bdc7f60ec66fea135991f
> git tree: upstream
>
> kernel config: https://pastebin.com/h9YFR4Vq
> C reproducer: https://pastebin.com/fdusnCsb
> console output: https://pastebin.com/HcL6UmE1
>
> Basically, in the c reproducer, we use the gadget module to emulate
> the process of attaching a usb device (vendor id: 0xbb4, product id:
> 0xa79, with function: @phonet).
> To reproduce this crash, we utilize a third-party library to emulate
> the attaching process: https://github.com/linux-usb-gadgets/libusbgx.
> Just clone this repository, make install it, and compile the c
> reproducer with ``` gcc crash.c -lusbgx -lconfig -o crash ``` will do
> the trick.
>
> It would be so appreciate if you have any ideal how to solve this bug.
>
> The crash report is as follow:
>
> ```
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in free_netdev+0x4d9/0x5a0 net/core/dev.c:1059=
9
> Read of size 1 at addr ffff88802a5485c8 by task syz-executor.0/11237
>
> CPU: 2 PID: 11237 Comm: syz-executor.0 Not tainted 5.18.0 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:313 [inline]
> print_report.cold+0xe5/0x659 mm/kasan/report.c:429
> kasan_report+0x8a/0x1b0 mm/kasan/report.c:491
> free_netdev+0x4d9/0x5a0 net/core/dev.c:10599
> phonet_free_inst+0x92/0xb0 drivers/usb/gadget/function/f_phonet.c:618
> usb_put_function_instance+0x7f/0xb0 drivers/usb/gadget/functions.c:77
> config_item_cleanup fs/configfs/item.c:128 [inline]
> config_item_release+0x11d/0x2f0 fs/configfs/item.c:137
> kref_put include/linux/kref.h:65 [inline]
> config_item_put+0x7c/0xa0 fs/configfs/item.c:149
> configfs_rmdir+0x69f/0xa70 fs/configfs/dir.c:1538
> vfs_rmdir fs/namei.c:4017 [inline]
> vfs_rmdir+0x2a0/0x640 fs/namei.c:3994
> do_rmdir+0x328/0x390 fs/namei.c:4078
> __do_sys_rmdir fs/namei.c:4097 [inline]
> __se_sys_rmdir fs/namei.c:4095 [inline]
> __x64_sys_rmdir+0x3e/0x50 fs/namei.c:4095
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f84aa0a69cb
> Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66
> 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 54 00 00 00 0f 05 <48> 3d
> 01 f0 ff ff8
> RSP: 002b:00007f84aa7cda88 EFLAGS: 00000293 ORIG_RAX: 0000000000000054
> RAX: ffffffffffffffda RBX: 00007f84a4001c10 RCX: 00007f84aa0a69cb
> RDX: 00007f84a40021c0 RSI: 00007f84aa114825 RDI: 00007f84aa7cda90
> RBP: 00007f84aa7cda90 R08: 00007f84aa114825 R09: 00007f84aa7cd910
> R10: 00000000fffffff4 R11: 0000000000000293 R12: 0000000000000000
> R13: 0000000000000001 R14: 00007f84a4001b70 R15: 00007f84aa198020
> </TASK>
>
> Allocated by task 11185:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> kasan_set_track mm/kasan/common.c:45 [inline]
> set_alloc_info mm/kasan/common.c:436 [inline]
> ____kasan_kmalloc mm/kasan/common.c:515 [inline]
> ____kasan_kmalloc mm/kasan/common.c:474 [inline]
> __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
> kasan_kmalloc include/linux/kasan.h:234 [inline]
> __kmalloc_node+0x1fc/0x450 mm/slub.c:4462
> kmalloc_node include/linux/slab.h:604 [inline]
> kvmalloc_node+0x3e/0x190 mm/util.c:580
> kvmalloc include/linux/slab.h:731 [inline]
> kvzalloc include/linux/slab.h:739 [inline]
> alloc_netdev_mqs+0x9d/0x11b0 net/core/dev.c:10491
> gphonet_setup_default+0x34/0x80 drivers/usb/gadget/function/f_phonet.c:69=
7
> phonet_alloc_inst+0x80/0x130 drivers/usb/gadget/function/f_phonet.c:631
> try_get_usb_function_instance+0x122/0x1e0 drivers/usb/gadget/functions.c:=
28
> usb_get_function_instance+0x13/0xa0 drivers/usb/gadget/functions.c:44
> function_make+0x105/0x3e0 drivers/usb/gadget/configfs.c:605
> configfs_mkdir+0x46a/0xb90 fs/configfs/dir.c:1327
> vfs_mkdir+0x620/0x980 fs/namei.c:3931
> do_mkdirat+0x242/0x2b0 fs/namei.c:3957
> __do_sys_mkdir fs/namei.c:3977 [inline]
> __se_sys_mkdir fs/namei.c:3975 [inline]
> __x64_sys_mkdir+0x61/0x80 fs/namei.c:3975
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Freed by task 11185:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> kasan_set_track+0x21/0x30 mm/kasan/common.c:45
> kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
> ____kasan_slab_free mm/kasan/common.c:366 [inline]
> ____kasan_slab_free mm/kasan/common.c:328 [inline]
> __kasan_slab_free+0x11d/0x190 mm/kasan/common.c:374
> kasan_slab_free include/linux/kasan.h:200 [inline]
> slab_free_hook mm/slub.c:1728 [inline]
> slab_free_freelist_hook mm/slub.c:1754 [inline]
> slab_free mm/slub.c:3510 [inline]
> kfree+0xec/0x4b0 mm/slub.c:4552
> kvfree+0x42/0x50 mm/util.c:622
> netdev_freemem net/core/dev.c:10445 [inline]
> free_netdev+0x46b/0x5a0 net/core/dev.c:10628
> gphonet_register_netdev drivers/usb/gadget/function/f_phonet.c:720 [inlin=
e]
> pn_bind+0x4cb/0x590 drivers/usb/gadget/function/f_phonet.c:502
> usb_add_function+0x217/0x930 drivers/usb/gadget/composite.c:337
> configfs_composite_bind+0x8b6/0x11b0 drivers/usb/gadget/configfs.c:1392
> udc_bind_to_driver+0x1f4/0x7b0 drivers/usb/gadget/udc/core.c:1504
> usb_gadget_probe_driver+0x335/0x410 drivers/usb/gadget/udc/core.c:1571
> gadget_dev_desc_UDC_store+0x17b/0x220 drivers/usb/gadget/configfs.c:287
> flush_write_buffer fs/configfs/file.c:207 [inline]
> configfs_write_iter+0x2ea/0x480 fs/configfs/file.c:229
> call_write_iter include/linux/fs.h:2050 [inline]
> new_sync_write+0x393/0x570 fs/read_write.c:504
> vfs_write+0x7c4/0xab0 fs/read_write.c:591
> ksys_write+0x127/0x250 fs/read_write.c:644
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff88802a548000
> which belongs to the cache kmalloc-cg-4k of size 4096
> The buggy address is located 1480 bytes inside of
> 4096-byte region [ffff88802a548000, ffff88802a549000)
>
> The buggy address belongs to the physical page:
> page:ffffea0000a95200 refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x2a548
> head:ffffea0000a95200 order:3 compound_mapcount:0 compound_pincount:0
> memcg:ffff88801aa7a841
> flags: 0xfff00000010200(slab|head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000001 ffff88801184c140
> raw: 0000000000000000 0000000000040004 00000001ffffffff ffff88801aa7a841
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask
> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOM=
EMALLOC),
> pid7
> set_page_owner include/linux/page_owner.h:31 [inline]
> post_alloc_hook mm/page_alloc.c:2434 [inline]
> prep_new_page+0x297/0x330 mm/page_alloc.c:2441
> get_page_from_freelist+0x210e/0x3ab0 mm/page_alloc.c:4182
> __alloc_pages+0x30c/0x6e0 mm/page_alloc.c:5408
> alloc_pages+0x119/0x250 mm/mempolicy.c:2272
> alloc_slab_page mm/slub.c:1799 [inline]
> allocate_slab mm/slub.c:1944 [inline]
> new_slab+0x2a9/0x3f0 mm/slub.c:2004
> ___slab_alloc+0xc62/0x1080 mm/slub.c:3005
> __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3092
> slab_alloc_node mm/slub.c:3183 [inline]
> __kmalloc_node+0x340/0x450 mm/slub.c:4458
> kmalloc_node include/linux/slab.h:604 [inline]
> kvmalloc_node+0x3e/0x190 mm/util.c:580
> kvmalloc include/linux/slab.h:731 [inline]
> seq_buf_alloc fs/seq_file.c:38 [inline]
> seq_read_iter+0x800/0x11e0 fs/seq_file.c:210
> kernfs_fop_read_iter+0x446/0x5f0 fs/kernfs/file.c:236
> call_read_iter include/linux/fs.h:2044 [inline]
> new_sync_read+0x38d/0x600 fs/read_write.c:401
> vfs_read+0x495/0x5d0 fs/read_write.c:482
> ksys_read+0x127/0x250 fs/read_write.c:620
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> page last free stack trace:
> reset_page_owner include/linux/page_owner.h:24 [inline]
> free_pages_prepare mm/page_alloc.c:1356 [inline]
> free_pcp_prepare+0x51f/0xd00 mm/page_alloc.c:1406
> free_unref_page_prepare mm/page_alloc.c:3328 [inline]
> free_unref_page+0x19/0x5b0 mm/page_alloc.c:3423
> __unfreeze_partials+0x3d2/0x3f0 mm/slub.c:2523
> do_slab_free mm/slub.c:3498 [inline]
> ___cache_free+0x12c/0x140 mm/slub.c:3517
> qlink_free mm/kasan/quarantine.c:157 [inline]
> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
> kasan_quarantine_reduce+0x13d/0x180 mm/kasan/quarantine.c:283
> __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
> kasan_slab_alloc include/linux/kasan.h:224 [inline]
> slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:749
> slab_alloc_node mm/slub.c:3217 [inline]
> slab_alloc mm/slub.c:3225 [inline]
> __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
> kmem_cache_alloc+0x1be/0x460 mm/slub.c:3242
> kmem_cache_zalloc include/linux/slab.h:704 [inline]
> __kernfs_new_node+0xd4/0x8b0 fs/kernfs/dir.c:585
> kernfs_new_node+0x93/0x120 fs/kernfs/dir.c:647
> kernfs_create_dir_ns+0x48/0x150 fs/kernfs/dir.c:1003
> internal_create_group+0x7ab/0xba0 fs/sysfs/group.c:136
> netdev_queue_add_kobject net/core/net-sysfs.c:1659 [inline]
> netdev_queue_update_kobjects+0x398/0x4d0 net/core/net-sysfs.c:1705
> register_queue_kobjects net/core/net-sysfs.c:1766 [inline]
> netdev_register_kobject+0x35d/0x430 net/core/net-sysfs.c:2012
> register_netdevice+0xb60/0x1290 net/core/dev.c:9961
>
> Memory state around the buggy address:
> ffff88802a548480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88802a548500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88802a548580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ^
> ffff88802a548600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88802a548680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> ```
