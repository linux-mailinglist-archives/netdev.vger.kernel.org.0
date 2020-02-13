Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4082115B9BF
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 07:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgBMGpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 01:45:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37673 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgBMGpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 01:45:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so5231699wru.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 22:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=96S6z9+E2Uq8uMEfbR+YRFoK7kp6AXSYJiHVcONIypc=;
        b=oEjvPXZ0s57JkJ0XAxtKskCtpeXa6eZWkHLZe61m2ev9hcHe9y1yxx5JpntEgiTxGd
         k2IOs+815erqS/ucAiFv6gCOkTL4XRVeJar87erwbp/gWyRLK0g1ROS7L33iS/zSwrjZ
         GsZdnsTW4m0mMKkNH3d0kn5uY56pFk5DNCdeESxUNz16joVHuMPD8GLjvg8c9vU4X7zd
         hh1n1x3qNIJ98erYgmyWcm7dqe+ftyGmI8aqs4ca0P+wRvyq/JRcPbncGfDwNW8feyua
         eQ2iWH5+oGme/8xah85FNdiT8cs2jU3N7KGgFjaPvoUzCUeQ+yDNOpQON6ta5TEUTyoV
         otsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=96S6z9+E2Uq8uMEfbR+YRFoK7kp6AXSYJiHVcONIypc=;
        b=ag5PVVHL3b0ckRlhO5pRjv6On3FkpqPb/Fr3xUxJZstqejxuh6mFz/qGGil9J7zUaY
         V3OuDwJcTeCrHMBNiq+LJW/7Bo8RICw2f62NcMe8MdVRjvEv4bSeEjRItvRNLbBj/xbQ
         5984vC+lnsZpyisNZU30JutIcpWnAbsfZMa0mUqcr9MK2Pf3abW6VFMpoW1qNr5D7wY9
         u4gaPRNaCb9ts3DhcLdeRtC8IXeKBG4krrYce6hnaCJz0buHSpiAkmPuiO7Mga6sv9LH
         YTIDvqls3VO1eX886MVuM60K97kvhm+AHlU+ZJb4uwMZVVPSmYXZDN1xLU0FuPx8V1Ie
         8vPg==
X-Gm-Message-State: APjAAAUHFksdQMfI6NhaH7s8BknxN1JKGHhsYxGO7juHb4C+jSCpVPNs
        oBvMpQQVENejSBBRBmhRhN5bppLLlaI=
X-Google-Smtp-Source: APXvYqxICdgO6+oiFYZ0hsIGA1+1pUo8Qw+FFZLgCtfcUi0e2BJkwJPuMJzAvyRupIeaOLG/0KTJ4A==
X-Received: by 2002:a5d:5345:: with SMTP id t5mr21385529wrv.0.1581576333416;
        Wed, 12 Feb 2020 22:45:33 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id y7sm12337702wmd.1.2020.02.12.22.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 22:45:32 -0800 (PST)
Date:   Thu, 13 Feb 2020 07:45:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: rtnetlink: fix bugs in rtnl_alt_ifname()
Message-ID: <20200213064532.GD22610@nanopsycho>
References: <20200213045826.181478-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213045826.181478-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 13, 2020 at 05:58:26AM CET, edumazet@google.com wrote:
>Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
>guarantee it is nul terminated.
>
>We should use nla_strdup() instead of kstrdup(), since this
>helper will make sure not accessing out-of-bounds data.
>
>BUG: KMSAN: uninit-value in strlen+0x5e/0xa0 lib/string.c:535
>CPU: 1 PID: 19157 Comm: syz-executor.5 Not tainted 5.5.0-rc5-syzkaller #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>Call Trace:
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x1c9/0x220 lib/dump_stack.c:118
> kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
> __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
> strlen+0x5e/0xa0 lib/string.c:535
> kstrdup+0x7f/0x1a0 mm/util.c:59
> rtnl_alt_ifname net/core/rtnetlink.c:3495 [inline]
> rtnl_linkprop+0x85d/0xc00 net/core/rtnetlink.c:3553
> rtnl_newlinkprop+0x9d/0xb0 net/core/rtnetlink.c:3568
> rtnetlink_rcv_msg+0x1153/0x1570 net/core/rtnetlink.c:5424
> netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
> rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
> netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
> netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
> sock_sendmsg_nosec net/socket.c:639 [inline]
> sock_sendmsg net/socket.c:659 [inline]
> ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
> ___sys_sendmsg net/socket.c:2384 [inline]
> __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
> __do_sys_sendmsg net/socket.c:2426 [inline]
> __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
> __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
> do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>RIP: 0033:0x45b3b9
>Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>RSP: 002b:00007ff1c7b1ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>RAX: ffffffffffffffda RBX: 00007ff1c7b1b6d4 RCX: 000000000045b3b9
>RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
>RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
>R13: 00000000000009cb R14: 00000000004cb3dd R15: 000000000075bf2c
>
>Uninit was created at:
> kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
> kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
> kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
> slab_alloc_node mm/slub.c:2774 [inline]
> __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
> __kmalloc_reserve net/core/skbuff.c:141 [inline]
> __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
> alloc_skb include/linux/skbuff.h:1049 [inline]
> netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
> netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1892
> sock_sendmsg_nosec net/socket.c:639 [inline]
> sock_sendmsg net/socket.c:659 [inline]
> ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
> ___sys_sendmsg net/socket.c:2384 [inline]
> __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
> __do_sys_sendmsg net/socket.c:2426 [inline]
> __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
> __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
> do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Reported-by: syzbot <syzkaller@googlegroups.com>
>---
> net/core/rtnetlink.c | 26 ++++++++++++--------------
> 1 file changed, 12 insertions(+), 14 deletions(-)
>
>diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>index 09c44bf2e1d28842d77b4ed442ef2c051a25ad21..e1152f4ffe33efb0a69f17a1f5940baa04942e5b 100644
>--- a/net/core/rtnetlink.c
>+++ b/net/core/rtnetlink.c
>@@ -3504,27 +3504,25 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
> 	if (err)
> 		return err;
> 
>-	alt_ifname = nla_data(attr);
>+	alt_ifname = nla_strdup(attr, GFP_KERNEL);
>+	if (!alt_ifname)
>+		return -ENOMEM;
>+
> 	if (cmd == RTM_NEWLINKPROP) {
>-		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
>-		if (!alt_ifname)
>-			return -ENOMEM;
> 		err = netdev_name_node_alt_create(dev, alt_ifname);
>-		if (err) {
>-			kfree(alt_ifname);
>-			return err;
>-		}
>+		if (!err)
>+			alt_ifname = NULL;
> 	} else if (cmd == RTM_DELLINKPROP) {
> 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
>-		if (err)
>-			return err;
> 	} else {


>-		WARN_ON(1);
>-		return 0;
>+		WARN_ON_ONCE(1);
>+		err = -EINVAL;

These 4 lines do not seem to be related to the rest of the patch. Should
it be a separate patch?

Otherwise, the patch looks fine to me.


> 	}
> 
>-	*changed = true;
>-	return 0;
>+	kfree(alt_ifname);
>+	if (!err)
>+		*changed = true;
>+	return err;
> }
> 
> static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
>-- 
>2.25.0.225.g125e21ebc7-goog
>
