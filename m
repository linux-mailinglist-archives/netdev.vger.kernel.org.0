Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE8A1474D9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 00:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgAWXfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 18:35:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40434 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729288AbgAWXfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 18:35:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id k25so29737pgt.7;
        Thu, 23 Jan 2020 15:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VPDDXVEU0dwrWI7DBcg16+dHfx0v0bI7OWA8gFnpEIg=;
        b=sF9q4qCRJxW0AAMaXVs73kvqeDhUwmR1umcn5CXdTZ/BM5ZqQOyMGG2D7KVy0701L8
         LzokhRXLUCxUh6kzyJroKM3D9dEpczs0xyrQS80medE8nojj1/Mx71NFYCQpnwVdeFA6
         /LgIE2ldzsLFwGm14/UAsA5dVsSHwnnZDyHLAN5VBildgmrRNJLIGEhs+EI4TIdVCt4F
         f2P/8w8yA+Aq9/NTUFIl7QxaO4t0egEfJdIgHSOqG4KX2fnq93U5LbuXlHECnOyIqsyF
         MVsZZPyHoQftDsuTV0SM3Lzcjfq+cwKR6sDdP5acIb+w+tePxSzGq6c7inzfuYcDY418
         KJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPDDXVEU0dwrWI7DBcg16+dHfx0v0bI7OWA8gFnpEIg=;
        b=D4EYaWxp/kzJcJQFA2PWJZCSRd7SNFpRgqpK2sawhUnLkVZQ3PsWi+8+wdSQwlXpsD
         dJe2jF12PcHiWhiKTbVEozanYFLZLmi2gd5XLt2HsrJ/ECRRv7S80DOcXl0WobsUqrTQ
         bxEsnBZBkTTHeKVzazp7DZ0dO/qGslsnqWlu2c/ceT4EOypS8ipupvAVw6YAo87wXrVc
         5/rbTvtkzgZMiHbGwXgUyjTO7x9T8kFhHDYrosY3+akj0G0VCVDTwRV+grU2eehpbFGF
         X9359OG7QjBiGOkpkzBW+ijkRKih8L5Chh/qoTlRoP87t1CZoNz0A2dVkJFJ5bpRpKqM
         z62w==
X-Gm-Message-State: APjAAAXT2B1imW//8J8HqIN8llu+y2okFDomQ5/e6LzsmNGWmVZ2hk1O
        mTULJbYBdFU0yXGRRhyZqG4=
X-Google-Smtp-Source: APXvYqzQIPYeykH7QvlzIwyCSa2LYzjW4uJK6CNnHujPc0uMSTCAbFSVpfQXe8z82FFJyEUHTfTX9w==
X-Received: by 2002:a65:55cd:: with SMTP id k13mr846747pgs.197.1579822522092;
        Thu, 23 Jan 2020 15:35:22 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w131sm3948125pfc.16.2020.01.23.15.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 15:35:20 -0800 (PST)
Subject: Re: KASAN: slab-out-of-bounds Read in tcf_exts_destroy
To:     syzbot <syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com>,
        adobriyan@gmail.com, davem@davemloft.net, dsahern@gmail.com,
        ja@ssi.bg, jhs@mojatatu.com, jiri@resnulli.us,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tgraf@suug.ch, xiyou.wangcong@gmail.com
References: <000000000000dd5dba059cd6facc@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5c98ae4d-b162-c878-33a1-cad4e8d25d4b@gmail.com>
Date:   Thu, 23 Jan 2020 15:35:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <000000000000dd5dba059cd6facc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/20 3:27 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    569aad4f net: ag71xx: fix mdio subnode support
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1591b415600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6ffbfa7e4a36190f
> dashboard link: https://syzkaller.appspot.com/bug?extid=35d4dea36c387813ed31
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120c47f5600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d58ceb600000
> 
> The bug was bisected to:
> 
> commit 6e237d099fac1f73a7b6d7287bb9191f29585a4e
> Author: David Ahern <dsahern@gmail.com>
> Date:   Thu Dec 7 04:09:12 2017 +0000
> 
>     netlink: Relax attr validation for fixed length types
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f5e43600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f5e43600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132f5e43600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
> Fixes: 6e237d099fac ("netlink: Relax attr validation for fixed length types")
> 
> netlink: 'syz-executor879': attribute type 2 has an invalid length.
> netlink: 'syz-executor879': attribute type 2 has an invalid length.
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in tcf_exts_destroy+0xb3/0xd0 net/sched/cls_api.c:2897
> Read of size 8 at addr ffff8880a1463790 by task syz-executor879/9050
> 
> CPU: 0 PID: 9050 Comm: syz-executor879 Not tainted 5.3.0+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
>  kasan_report+0x12/0x20 mm/kasan/common.c:634
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>  tcf_exts_destroy+0xb3/0xd0 net/sched/cls_api.c:2897
>  tcindex_free_perfect_hash.isra.0+0xb3/0x150 net/sched/cls_tcindex.c:273
>  tcindex_set_parms+0x1107/0x1e50 net/sched/cls_tcindex.c:484
>  tcindex_change+0x230/0x320 net/sched/cls_tcindex.c:519
>  tc_new_tfilter+0xa4b/0x1c70 net/sched/cls_api.c:2019
>  rtnetlink_rcv_msg+0x838/0xb00 net/core/rtnetlink.c:5214
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:637 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:657
>  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
>  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
>  __do_sys_sendmmsg net/socket.c:2442 [inline]
>  __se_sys_sendmmsg net/socket.c:2439 [inline]
>  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
>  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x443299
> Code: e8 9c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffde8f54e48 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443299
> RDX: 0000000000000332 RSI: 0000000020000140 RDI: 0000000000000008
> RBP: 000000000000000c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0030766461746162
> R13: 00000000004041f0 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 9050:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  __kasan_kmalloc mm/kasan/common.c:510 [inline]
>  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
>  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
>  __do_kmalloc mm/slab.c:3655 [inline]
>  __kmalloc+0x163/0x770 mm/slab.c:3664
>  kmalloc_array include/linux/slab.h:614 [inline]
>  kcalloc include/linux/slab.h:625 [inline]
>  tcindex_alloc_perfect_hash+0x5a/0x320 net/sched/cls_tcindex.c:281
>  tcindex_set_parms+0x454/0x1e50 net/sched/cls_tcindex.c:339
>  tcindex_change+0x230/0x320 net/sched/cls_tcindex.c:519
>  tc_new_tfilter+0xa4b/0x1c70 net/sched/cls_api.c:2019
>  rtnetlink_rcv_msg+0x838/0xb00 net/core/rtnetlink.c:5214
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:637 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:657
>  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
>  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
>  __do_sys_sendmmsg net/socket.c:2442 [inline]
>  __se_sys_sendmmsg net/socket.c:2439 [inline]
>  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
>  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 2660:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  kasan_set_free_info mm/kasan/common.c:332 [inline]
>  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
>  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
>  __cache_free mm/slab.c:3425 [inline]
>  kfree+0x10a/0x2c0 mm/slab.c:3756
>  call_usermodehelper_freeinfo kernel/umh.c:48 [inline]
>  umh_complete kernel/umh.c:62 [inline]
>  umh_complete+0x8d/0xa0 kernel/umh.c:51
>  call_usermodehelper_exec_async+0x46c/0x730 kernel/umh.c:122
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> 
> The buggy address belongs to the object at ffff8880a1463700
>  which belongs to the cache kmalloc-192 of size 192
> The buggy address is located 144 bytes inside of
>  192-byte region [ffff8880a1463700, ffff8880a14637c0)
> The buggy address belongs to the page:
> page:ffffea00028518c0 refcount:1 mapcount:0 mapping:ffff8880aa400000 index:0x0
> flags: 0x1fffc0000000200(slab)
> raw: 01fffc0000000200 ffffea000287e608 ffffea000286ff48 ffff8880aa400000
> raw: 0000000000000000 ffff8880a1463000 0000000100000010 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8880a1463680: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff8880a1463700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff8880a1463780: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                          ^
>  ffff8880a1463800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880a1463880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 


tcindex_set_parms() seems buggy :

After

if (tcindex_alloc_perfect_hash(net, cp) < 0) // line 339

it can overwrite cp->hash : 

if (tb[TCA_TCINDEX_HASH])
    cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);

Meaning that out-of-bounds might happen later.



