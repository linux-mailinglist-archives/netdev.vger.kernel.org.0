Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B7F28ADFE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgJLFyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJLFyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:54:11 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8854C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 22:54:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s7so16765111qkh.11
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 22:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0eX48cJRMbOt+//wYAh4tCC3YssGNtFM24NWRnNoMw=;
        b=BXhOXOiPDdI2rQMzJ20RpnDxKD5JOvvlyRy+u6/6IHdhVhCpXwVVh0Z2iTaas0Xhmh
         VcuJhrRUQ8kYe9k+5S3v81+TCA3MjgTg/Hp/d1W2WR9cazVWi2YMPWxkxiWhE86cLi0s
         EreVX7HrdCZHHkYtHm/erUtuZnKpDcRNyGS3LF00GNoGsp0cjS8ltCuxLGSXiFTmW+nm
         B8OeMIPeMSkh99l9Q05Kb4SQQacryeYRr7zT36rc4LXPRquIzsk4cFVpL5A4hhhC/itW
         Jl7xF94iG14iCnDrmt1nQX8QedftJ8LsE56FcA66662YeuKQcehGdgMuwJv/yq5mCe/I
         EFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0eX48cJRMbOt+//wYAh4tCC3YssGNtFM24NWRnNoMw=;
        b=KY8tZRT5uHPZzLiAH8XyHSFtuS8IObOHo4EXP9SdwMgFgYOQQsdpg2NLakICjyVo+f
         doWhL9eXhwN+dfPaRs9ohaH9f7QE1oaVLPU7YNzaGj1th1PR3XqJVHlRkpsiNZj5rJaS
         ucNBALfKd3v+bnhJ4zctksB6BKOetDnFCrRYJJb/0WRvWvczEb4URI2YQ0nach63Yt95
         gh2d4sOm2mPe609Hqm7TqweNogWw/Lh9o6NufKWesmDzVgyHCT+MLYR8ZQzCSw9pAglZ
         9CawXaWvUAohYtba5t4GNl5Cxi9QUCkON5NZ5l8fiV2IdZ4K/OozuLDGm/TGUL5MeAJS
         ZQXQ==
X-Gm-Message-State: AOAM5311fjWR0CT3SA6PyPXVr3Wl1kUTQa84OH7vA1/+zUfj6dj4FvKV
        yWlxF6EYxGzveujc1oL/xuO9zrG9HRt0sQU3brtH7A==
X-Google-Smtp-Source: ABdhPJxFHjhiyUCqPXcrz5b0EREWx7kCIv6gRxK1vXmBBZ2XV2mvEhNRXuLtVmxLDx+BlQ8083kTADtsNy+HheprWxU=
X-Received: by 2002:a37:b283:: with SMTP id b125mr7863412qkf.407.1602482050513;
 Sun, 11 Oct 2020 22:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000003f57e905b12a17b5@google.com>
In-Reply-To: <0000000000003f57e905b12a17b5@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 12 Oct 2020 07:53:59 +0200
Message-ID: <CACT4Y+arA=P52J1sQ8umSvT3ksgVB4asQU+EaSAwmUNdPamctg@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in strset_parse_request
To:     syzbot <syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com>
Cc:     andrew@lunn.ch, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 5:00 PM syzbot
<syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    9faebeb2 Merge branch 'ethtool-allow-dumping-policies-to-u..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f7dc00500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ad9ecfafd94317b
> dashboard link: https://syzkaller.appspot.com/bug?extid=9d1389df89299fa368dc
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9b94f900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105268bf900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com

#syz fix: ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY attr

> ==================================================================
> BUG: KASAN: slab-out-of-bounds in strset_parse_request+0x4dd/0x530 net/ethtool/strset.c:172
> Read of size 8 at addr ffff8880a120be18 by task syz-executor483/6874
>
> CPU: 1 PID: 6874 Comm: syz-executor483 Not tainted 5.9.0-rc8-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  strset_parse_request+0x4dd/0x530 net/ethtool/strset.c:172
>  ethnl_default_parse+0xda/0x130 net/ethtool/netlink.c:282
>  ethnl_default_start+0x21f/0x510 net/ethtool/netlink.c:501
>  genl_start+0x3cc/0x670 net/netlink/genetlink.c:604
>  __netlink_dump_start+0x585/0x900 net/netlink/af_netlink.c:2363
>  genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:697
>  genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
>  genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440979
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe892965e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440979
> RDX: 0000000000000000 RSI: 0000000020000780 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000401f60
> R13: 0000000000401ff0 R14: 0000000000000000 R15: 0000000000000000
>
> Allocated by task 6874:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
>  __do_kmalloc mm/slab.c:3659 [inline]
>  __kmalloc+0x1b0/0x360 mm/slab.c:3668
>  kmalloc_array include/linux/slab.h:594 [inline]
>  genl_family_rcv_msg_attrs_parse.constprop.0+0xd7/0x280 net/netlink/genetlink.c:543
>  genl_start+0x187/0x670 net/netlink/genetlink.c:584
>  __netlink_dump_start+0x585/0x900 net/netlink/af_netlink.c:2363
>  genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:697
>  genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
>  genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> The buggy address belongs to the object at ffff8880a120be00
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 24 bytes inside of
>  32-byte region [ffff8880a120be00, ffff8880a120be20)
> The buggy address belongs to the page:
> page:000000007938d980 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a120bfc1 pfn:0xa120b
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea0002848c08 ffffea00027e6b48 ffff8880aa040100
> raw: ffff8880a120bfc1 ffff8880a120b000 0000000100000011 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8880a120bd00: fb fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>  ffff8880a120bd80: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
> >ffff8880a120be00: 00 00 00 fc fc fc fc fc 00 01 fc fc fc fc fc fc
>                             ^
>  ffff8880a120be80: fa fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>  ffff8880a120bf00: 05 fc fc fc fc fc fc fc 05 fc fc fc fc fc fc fc
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
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000003f57e905b12a17b5%40google.com.
