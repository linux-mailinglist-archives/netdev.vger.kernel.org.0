Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C343BD4A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 00:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhJZWhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 18:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhJZWhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 18:37:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B508C061570;
        Tue, 26 Oct 2021 15:34:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d9so830551pfl.6;
        Tue, 26 Oct 2021 15:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+n/JKUZQLzNla4uxKbYMrF40sz88TNTZr9gR/5PzdUo=;
        b=op0EXOShN2Juo3m0enqsk7dvB5ivcZ95ERhYuv2tZlELdIyi0R4mbmxKE9WKQl6jYb
         XYpTk6aho43740KVjq5tuhbp0I8Oybr73KdgE7EbEdgbpwZkaCCFZSJh7HLUXwxjXYgg
         5pGlmrPpHq7zi/3E8ADyjrAhcx1lmQTS3ZXt2qSvK2cIWX3m6nOYGOFUrLmOLVmdEPC5
         Tu8YI0o2VLZoqkfxAVHAnhdxB3jleLbAnpHkCS/nldaF9BChN/SSt2SxezgyJVjWw+Wv
         B4cgkj7oWk5ChEummG7UUe66RvyE7ehueQMFiz84+SaQM++jdtvTQdm0Cw3qnCsShsc7
         evbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+n/JKUZQLzNla4uxKbYMrF40sz88TNTZr9gR/5PzdUo=;
        b=d3CFcRncPTKhDYAw+WZhjzXPbxbxWtZhlWx2ILMBbSM8D1Hjp3ZElAxgIF1vGiqnyX
         Sg6nkrd7pZy8l2jQ8wj/3MkQqplVVJf0FWhmZRg9R5kLPIiR0LM9ZO+6Obt8ucT1CpVc
         TKuAVOYvW1Vo+NFjmo/46+b3tSJwrMe1NJ7RVdnrrFdQ5L219CPvVAqm/Y6qcsf3QS5P
         sIDqKNryYQ+5Suc2rSBwXdz3mbnYOiF3o9S47FaOBKqRjVTOIyFGGz0D7NL5aonQuAwH
         27NOvYEx1vaizZqyiYNriVGigXmURHW+YJqK0ltoaq1drKdEEcf3cTQd2ozw1Ct2Pm8Q
         3zVg==
X-Gm-Message-State: AOAM533IWothcQXX41hr7W7uWAlU5ilDj8Jxi3O+o9zZlHxBNjNxwzyw
        OxGS8YgaRr3DKa5IoyQIm9I=
X-Google-Smtp-Source: ABdhPJxlrERwRMKSOWKNTxSxUK6H6Wd23KkVGrl8HXGSNIxawz3Y9mITwgv2J1rsI/+76YhBxAlOoA==
X-Received: by 2002:a63:7b42:: with SMTP id k2mr16056139pgn.268.1635287677823;
        Tue, 26 Oct 2021 15:34:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id pc18sm2015243pjb.0.2021.10.26.15.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 15:34:37 -0700 (PDT)
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
To:     syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvivier@redhat.com, mpm@selenic.com,
        mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <000000000000a4cd2105cf441e76@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b6d96f08-78df-cf34-5e58-572b3fd4b566@gmail.com>
Date:   Tue, 26 Oct 2021 15:34:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <000000000000a4cd2105cf441e76@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 9:39 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> 
> The issue was bisected to:
> 
> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> Author: Leon Romanovsky <leonro@nvidia.com>
> Date:   Thu Oct 21 14:16:14 2021 +0000
> 
>     devlink: Remove not-executed trap policer notifications

More likely this came with

caaf2874ba27b92bca6f0298bf88bad94067ec37 hwrng: virtio - don't waste entropy

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
> Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
> BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
> Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
> 
> CPU: 1 PID: 6542 Comm: syz-executor989 Not tainted 5.15.0-rc6-next-20211025-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
>  __kasan_report mm/kasan/report.c:433 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
>  memcpy+0x20/0x60 mm/kasan/shadow.c:65
>  memcpy include/linux/fortify-string.h:225 [inline]
>  copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
>  virtio_read+0x1e0/0x230 drivers/char/hw_random/virtio-rng.c:90
>  rng_get_data drivers/char/hw_random/core.c:192 [inline]
>  rng_dev_read+0x400/0x660 drivers/char/hw_random/core.c:229
>  vfs_read+0x1b5/0x600 fs/read_write.c:483
>  ksys_read+0x12d/0x250 fs/read_write.c:623
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f05696617e9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd06461948 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 000000000001294d RCX: 00007f05696617e9
> RDX: 00000000fffffff1 RSI: 0000000020000180 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 00007ffd064619b0 R09: 00007ffd064619b0
> R10: 00007ffd064613d0 R11: 0000000000000246 R12: 00007ffd0646197c
> R13: 00007ffd064619b0 R14: 00007ffd06461990 R15: 0000000000000002
>  </TASK>
> 
> Allocated by task 1:
>  kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:472 [inline]
>  __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
>  kmalloc include/linux/slab.h:590 [inline]
>  kzalloc include/linux/slab.h:724 [inline]
>  probe_common+0xaa/0x5b0 drivers/char/hw_random/virtio-rng.c:132
>  virtio_dev_probe+0x44e/0x760 drivers/virtio/virtio.c:273
>  call_driver_probe drivers/base/dd.c:517 [inline]
>  really_probe+0x245/0xcc0 drivers/base/dd.c:596
>  __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
>  __driver_attach+0x22d/0x4e0 drivers/base/dd.c:1140
>  bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
>  bus_add_driver+0x41d/0x630 drivers/base/bus.c:618
>  driver_register+0x220/0x3a0 drivers/base/driver.c:171
>  do_one_initcall+0x103/0x650 init/main.c:1303
>  do_initcall_level init/main.c:1378 [inline]
>  do_initcalls init/main.c:1394 [inline]
>  do_basic_setup init/main.c:1413 [inline]
>  kernel_init_freeable+0x6b1/0x73a init/main.c:1618
>  kernel_init+0x1a/0x1d0 init/main.c:1507
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> The buggy address belongs to the object at ffff88801a7a1400
>  which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 384 bytes inside of
>  512-byte region [ffff88801a7a1400, ffff88801a7a1600)
> The buggy address belongs to the page:
> page:ffffea000069e800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a7a0
> head:ffffea000069e800 order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c41c80
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, ts 7709676886, free_ts 0
>  prep_new_page mm/page_alloc.c:2418 [inline]
>  get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
>  alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2036
>  alloc_pages+0x29f/0x300 mm/mempolicy.c:2186
>  alloc_slab_page mm/slub.c:1793 [inline]
>  allocate_slab mm/slub.c:1930 [inline]
>  new_slab+0x32d/0x4a0 mm/slub.c:1993
>  ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
>  slab_alloc_node mm/slub.c:3200 [inline]
>  slab_alloc mm/slub.c:3242 [inline]
>  kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3259
>  kmalloc include/linux/slab.h:590 [inline]
>  kzalloc include/linux/slab.h:724 [inline]
>  device_private_init drivers/base/core.c:3238 [inline]
>  device_add+0x11a7/0x1ee0 drivers/base/core.c:3288
>  device_create_groups_vargs+0x203/0x280 drivers/base/core.c:4052
>  device_create_with_groups+0xe3/0x120 drivers/base/core.c:4138
>  misc_register+0x20a/0x690 drivers/char/misc.c:206
>  register_miscdev drivers/char/hw_random/core.c:422 [inline]
>  hwrng_modinit+0xd0/0x109 drivers/char/hw_random/core.c:621
>  do_one_initcall+0x103/0x650 init/main.c:1303
>  do_initcall_level init/main.c:1378 [inline]
>  do_initcalls init/main.c:1394 [inline]
>  do_basic_setup init/main.c:1413 [inline]
>  kernel_init_freeable+0x6b1/0x73a init/main.c:1618
>  kernel_init+0x1a/0x1d0 init/main.c:1507
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>  ffff88801a7a1480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88801a7a1500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff88801a7a1580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff88801a7a1600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88801a7a1680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
