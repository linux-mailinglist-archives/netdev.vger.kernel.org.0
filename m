Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B774E20A
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFUIj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:39:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40746 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfFUIjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:39:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so5687545wre.7;
        Fri, 21 Jun 2019 01:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2X/Vwx/s3L58Q0MZKkvfHIkdcQDmB8vSD9+Ww3/y5uE=;
        b=S0Et/q1t0biciguO86myWT/3NPmNceQfQ18CV87GLOFA1Nyo2Ym+Cw7Vlif7b8qIYL
         FOFEYunTwMydKR5m1ADtUv178hEFiQFGDtvB29ew4rEwqPLOM/8cU7N3eSAuJ9LAF33k
         8ytoU7RjrvOGbRTI3NbLh+0wQiOdQa9Fnd7qP0KkzOyh7mAdaLpN6UDyI+fKJpWCJ5E6
         VCAI6pjEl5kLnsRSA0rmKt2+aqe+qgzmwisxS3k2PdROAWO3Ei2ibGs4T+TgennAqaJZ
         /uZzaNwrbKXwzOrAiTZti1xhcMpgM5NiV1HcoRT2ErJ6gsLQLbBNNlwDVli+Gat+PVze
         gWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2X/Vwx/s3L58Q0MZKkvfHIkdcQDmB8vSD9+Ww3/y5uE=;
        b=krswhUVPbnZPJeZ3QpplEiSwwtBsoK9P0p/agyCP3C4IvvhoTgqvWpzREkfGXRGHa0
         LxzdmKpPQPVy+Nlx4oBhm48y5b7tkPFZEOykdPCn+Yy/UsERVDq+1ZOEY7FipAabHzey
         sWhIMAQgjD3uleMg/HgWec0uU30zr0GuweC5seyB6gMrLqOaSsog/caKYxkJexU9NMph
         1nAX+pjh1hCn8e8rX8iI5HonjMelUoppfQQrrHxTxYii6tA3L2NlNjsSean7+VDhpdU9
         s0hKCLr0GZVmv0kLd8xRCJbTYWYofM6NEQvyO6ZfQ0Qi+Zsj8ly3WbvurTXKOJBbqpaw
         +1qQ==
X-Gm-Message-State: APjAAAW4daNh8+xfQqC8w1aoZwaFxaa76vbzxem6wGsL7rKhj0wzeWCP
        cMo4yshhLCOfro8WCWgZ9l9fJZqQ/CuAzofs7lc=
X-Google-Smtp-Source: APXvYqyGLGIFTq7u7gwpiI+A54k0uzIdZ4ailEEMxv4AKJL0dxlWlocnsA70jg8tDyTk0FvxLkgIVLM+u1ZPPfpATbY=
X-Received: by 2002:adf:fb81:: with SMTP id a1mr10750363wrr.329.1561106362613;
 Fri, 21 Jun 2019 01:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000045db72058baf24f7@google.com>
In-Reply-To: <00000000000045db72058baf24f7@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 21 Jun 2019 16:39:11 +0800
Message-ID: <CADvbK_dzcTTRpZVssQZEGhHGJMqPnv+-my8_wdobEUfvbVTEyg@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in tipc_nl_compat_bearer_disable
To:     syzbot <syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 11:48 PM syzbot
<syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
> git tree:       kmsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d0a6fea00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
> dashboard link: https://syzkaller.appspot.com/bug?extid=30eaa8bf392f7fafffaf
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b4a95aa00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162fc761a00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
>
> IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
> 8021q: adding VLAN 0 to HW filter on device batadv0
> ==================================================================
> BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
> CPU: 0 PID: 12554 Comm: syz-executor731 Not tainted 5.1.0+ #1
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
>   __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
>   memchr+0xce/0x110 lib/string.c:981
>   string_is_valid net/tipc/netlink_compat.c:176 [inline]
>   tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
TLV_GET_DATA_LEN(msg->req) may return a negtive value, which will be
used as size_t (a big unsigned long) passed into  memchr(),
triggered this issue.

@@ -446,7 +446,7 @@ static int tipc_nl_compat_bearer_disable(struct
tipc_nl_compat_cmd_doit *cmd,
  return -EMSGSIZE;

  len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_BEARER_NAME);
- if (!string_is_valid(name, len))
+ if (len <=0 || !string_is_valid(name, len))
  return -EINVAL;

The same fix is needed for some other places, and I will give a fix-ups.

>   __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
>   tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
>   tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
>   tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281
>   genl_family_rcv_msg net/netlink/genetlink.c:602 [inline]
>   genl_rcv_msg+0x185a/0x1a40 net/netlink/genetlink.c:627
>   netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2486
>   genl_rcv+0x63/0x80 net/netlink/genetlink.c:638
>   netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
>   netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1337
>   netlink_sendmsg+0x127e/0x12f0 net/netlink/af_netlink.c:1926
>   sock_sendmsg_nosec net/socket.c:651 [inline]
>   sock_sendmsg net/socket.c:661 [inline]
>   ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
>   __sys_sendmsg net/socket.c:2298 [inline]
>   __do_sys_sendmsg net/socket.c:2307 [inline]
>   __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
>   __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
>   do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> RIP: 0033:0x442639
> Code: 41 02 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 fb 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00000000007efea8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442639
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 00000000007eff00 R08: 0000000000000003 R09: 0000000000000003
> R10: 00000000bb1414ac R11: 0000000000000246 R12: 0000000000000003
> R13: 0000000000403c50 R14: 0000000000000000 R15: 0000000000000000
>
> Uninit was created at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:208 [inline]
>   kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:162
>   kmsan_kmalloc+0xa4/0x130 mm/kmsan/kmsan_hooks.c:175
>   kmsan_slab_alloc+0xe/0x10 mm/kmsan/kmsan_hooks.c:184
>   slab_post_alloc_hook mm/slab.h:442 [inline]
>   slab_alloc_node mm/slub.c:2771 [inline]
>   __kmalloc_node_track_caller+0xcba/0xf30 mm/slub.c:4399
>   __kmalloc_reserve net/core/skbuff.c:140 [inline]
>   __alloc_skb+0x306/0xa10 net/core/skbuff.c:208
>   alloc_skb include/linux/skbuff.h:1059 [inline]
>   netlink_alloc_large_skb net/netlink/af_netlink.c:1183 [inline]
>   netlink_sendmsg+0xb81/0x12f0 net/netlink/af_netlink.c:1901
>   sock_sendmsg_nosec net/socket.c:651 [inline]
>   sock_sendmsg net/socket.c:661 [inline]
>   ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
>   __sys_sendmsg net/socket.c:2298 [inline]
>   __do_sys_sendmsg net/socket.c:2307 [inline]
>   __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
>   __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
>   do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
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
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
