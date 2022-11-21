Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40146632791
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiKUPO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiKUPOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:14:01 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC885CEB98
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 07:08:26 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-iKtxYwtPMqGI-8tYrZd3xw-1; Mon, 21 Nov 2022 10:08:22 -0500
X-MC-Unique: iKtxYwtPMqGI-8tYrZd3xw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 562AF85543A;
        Mon, 21 Nov 2022 15:08:21 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4757A4B400F;
        Mon, 21 Nov 2022 15:08:18 +0000 (UTC)
Date:   Mon, 21 Nov 2022 16:07:26 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     steffen.klassert@secunet.com,
        syzbot <syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] linux-next test error: general protection fault in
 xfrm_policy_lookup_bytype
Message-ID: <Y3uULqIZ31at0aIX@hog>
References: <000000000000706e6f05edfb4ce0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000706e6f05edfb4ce0@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-11-21, 05:47:38 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e4cd8d3ff7f9 Add linux-next specific files for 20221121
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1472370d880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a0ebedc6917bacc1
> dashboard link: https://syzkaller.appspot.com/bug?extid=bfb2bee01b9c01fff864
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b59eb967701d/disk-e4cd8d3f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/37a7b43e6e84/vmlinux-e4cd8d3f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ebfb0438e6a2/bzImage-e4cd8d3f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bfb2bee01b9c01fff864@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
> CPU: 0 PID: 5295 Comm: kworker/0:3 Not tainted 6.1.0-rc5-next-20221121-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:xfrm_policy_lookup_bytype.cold+0x1c/0x54 net/xfrm/xfrm_policy.c:2139

That's the printk at the end of the function, when
xfrm_policy_lookup_bytype returns NULL. It seems to have snuck into
commit c39f95aaf6d1 ("xfrm: Fix oops in __xfrm_state_delete()"), we
can just remove it:

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 3a203c59a11b..e392d8d05e0c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2135,9 +2135,6 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 fail:
 	rcu_read_unlock();
 
-	if (!IS_ERR(ret))
-		printk("xfrm_policy_lookup_bytype: policy if_id %d, wanted if_id  %d\n", ret->if_id, if_id);
-
 	return ret;
 }
 


> Code: 80 44 28 8e e8 9a 88 37 fa e9 28 e7 7b fe e8 c0 25 7a f7 49 8d bf cc 00 00 00 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1c 41
> RSP: 0018:ffffc90003cdf1e0 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000019 RSI: ffffffff8a068150 RDI: 00000000000000cc
> RBP: 0000000000000000 R08: 0000000000000007 R09: fffffffffffff000
> R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
> R13: ffff88802ae78000 R14: ffffed10055cf2ff R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb5cb893300 CR3: 00000000714fb000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  xfrm_policy_lookup net/xfrm/xfrm_policy.c:2151 [inline]
>  xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2958 [inline]
>  xfrm_lookup_with_ifid+0x39b/0x20f0 net/xfrm/xfrm_policy.c:3099
>  xfrmi_xmit2 net/xfrm/xfrm_interface.c:404 [inline]
>  xfrmi_xmit+0x3c7/0x1b90 net/xfrm/xfrm_interface.c:521
>  __netdev_start_xmit include/linux/netdevice.h:4859 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4873 [inline]
>  xmit_one net/core/dev.c:3583 [inline]
>  dev_hard_start_xmit+0x1c2/0x990 net/core/dev.c:3599
>  __dev_queue_xmit+0x2cdf/0x3ba0 net/core/dev.c:4249
>  dev_queue_xmit include/linux/netdevice.h:3029 [inline]
>  neigh_connected_output+0x3c4/0x520 net/core/neighbour.c:1600
>  neigh_output include/net/neighbour.h:546 [inline]
>  ip6_finish_output2+0x56c/0x1530 net/ipv6/ip6_output.c:134
>  __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
>  ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
>  NF_HOOK_COND include/linux/netfilter.h:291 [inline]
>  ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
>  dst_output include/net/dst.h:444 [inline]
>  NF_HOOK include/linux/netfilter.h:302 [inline]
>  ndisc_send_skb+0xa63/0x1740 net/ipv6/ndisc.c:508
>  ndisc_send_rs+0x132/0x6f0 net/ipv6/ndisc.c:718
>  addrconf_dad_completed+0x37a/0xda0 net/ipv6/addrconf.c:4248
>  addrconf_dad_begin net/ipv6/addrconf.c:4014 [inline]
>  addrconf_dad_work+0x820/0x12d0 net/ipv6/addrconf.c:4116
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>

-- 
Sabrina

