Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA414917A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 23:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgAXW6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 17:58:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45486 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbgAXW6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 17:58:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1850841pgk.12;
        Fri, 24 Jan 2020 14:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=t39JTGNX1Yzdh4JGqIo59vMhFZ+cg3GQlNWADxR95/U=;
        b=m9ORxpjeevQCL17gBwN7N4HGjGipItXb70tWmUubOyHx4AceW9ME8tWnjBv7aNOD9G
         5Q5DQW0MSyV1K/WdPrGhPsMVrUTrjo9dcVE0kflxMEWbJNiPWHxkdfH885amCN69vh3F
         c0fj+B3x81kacf0r1DpQ2Qa9RZPJOH98Mj7drDDntFV2J0hA29dNpc7aWAsSmDNOJVOo
         yPdmhhRSDSCfS2DsqZlshU0UtRftf6g7+6gHpgZsTgHVpyNANpFN9+yuBRk/FIWH6nFa
         Xqi4lcWe8ynPIg21ir8YyGr9P2CY4QXE29GcDwYMUBNk9lKD4uEB4oj6Qo1x5K4U7wZJ
         fR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t39JTGNX1Yzdh4JGqIo59vMhFZ+cg3GQlNWADxR95/U=;
        b=T8sKGjKZM8DXdckwBQEtwNDRvcXSWd7VLaqUyiNULkIiXaGh0E9B+30O5WU5owu5fh
         igX5G354R/Jlg8BPdybsYNG+YNUUcTWm6IskuZUF2maKCYjPytuJRDG+e5t1Q1Z618X+
         SpbW1yBI617yemuuY5zqQuLo25meyHeDAPgFtTjZM8+QOW+14pYx/a7LbZFgwgDYsEUL
         0hSPSpSgDuIFiS2SW/+othsSnuGlEYZt07LMfwV+bCJlhZQIYplBHtx0pPB8oKW8vm68
         cUATjp8HShq29K4k5UNuH9g5mPRjdqD55dNMZti5UwUW7Sv0NfmUH6sji04LHILBQe53
         XfuA==
X-Gm-Message-State: APjAAAWkfnu+oDjRkTNjvmRLfxdOmIc0hAfcE5g8S7wGsS32dltzD5kp
        IoilRPAPFhY9tPGKThP6xxQ=
X-Google-Smtp-Source: APXvYqww4AnO5LunvjFqB+26WTK+6hnEJdzRQoKZnBwd50hY10JjFAZM7BWfx4bSpatn0d6+mGTFHg==
X-Received: by 2002:a63:a34b:: with SMTP id v11mr6406064pgn.229.1579906702909;
        Fri, 24 Jan 2020 14:58:22 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b8sm7547349pff.114.2020.01.24.14.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 14:58:22 -0800 (PST)
Subject: Re: memory leak in em_nbyte_change
To:     syzbot <syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
References: <000000000000ad33b8059cea8966@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <220c88d1-56ea-d4ef-4f0e-690d77ae2b0e@gmail.com>
Date:   Fri, 24 Jan 2020 14:58:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <000000000000ad33b8059cea8966@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/20 2:47 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1031e335e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=15478c61c836a72e
> dashboard link: https://syzkaller.appspot.com/bug?extid=03c4738ed29d5d366ddf
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1277ce01e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16681611e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff888121850a40 (size 32):
>   comm "syz-executor927", pid 7193, jiffies 4294941655 (age 19.840s)
>   hex dump (first 32 bytes):
>     00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
>     [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
>     [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
>     [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
>     [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
>     [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
>     [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
>     [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
>     [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
>     [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
>     [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
>     [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
>     [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
>     [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
>     [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>     [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
>     [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
>     [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
>     [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
>     [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
>     [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
>     [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
>     [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
>     [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
>     [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424
> 
> BUG: memory leak
> unreferenced object 0xffff888115438ea0 (size 32):
>   comm "syz-executor927", pid 7194, jiffies 4294942248 (age 13.910s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
>     [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
>     [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
>     [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
>     [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
>     [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
>     [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
>     [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
>     [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
>     [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
>     [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
>     [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
>     [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
>     [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
>     [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>     [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
>     [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
>     [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
>     [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
>     [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
>     [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
>     [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
>     [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
>     [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
>     [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424
> 
> BUG: memory leak
> unreferenced object 0xffff88811c962180 (size 32):
>   comm "syz-executor927", pid 7195, jiffies 4294942844 (age 7.950s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
>     [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
>     [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
>     [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
>     [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
>     [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
>     [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
>     [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
>     [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
>     [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
>     [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
>     [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
>     [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
>     [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
>     [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
>     [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>     [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
>     [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
>     [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
>     [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
>     [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
>     [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
>     [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
>     [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
>     [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
>     [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424
> 
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

Fixed in https://patchwork.ozlabs.org/patch/1229100/
