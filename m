Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D274B332A3F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhCIPVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhCIPUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:20:44 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9673C06174A;
        Tue,  9 Mar 2021 07:20:43 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u16so16364062wrt.1;
        Tue, 09 Mar 2021 07:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/r7ZmZA+cEjsm6dlp5jWq81qcZWGBjuwv110MvxvB/Y=;
        b=fzpUThiDYvJfgJs/AJaF7es7Qwg8P1fe2mpgnmrj6ATvmLFbmzDzBG9/3cqlwJXBCJ
         uFM+z8FIa2mv7iq/6zcyz+6wz7XvSlRXrjaz7eiMUv8ccsPya39FqTUG2bHIOcMH/zAO
         zLpr+DGsHDMVFWgB14P/cZpxnHAHU1o4d+JyhHJnpB9D/WZmADKeOPrCeYxV3ucR89LB
         W0/lwLBMtEuqIPFEmdkDNWcoI0KjdUNz983QxVS2m1velrvisOGs+bkRV9FzTqmBgsJO
         vYDtjBq+24HFgTj0Uf3E+bd2nVwvCXG6VeKfGgBmlfz/QoXv6vIQ738GLjmaftjb2QyS
         ONSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/r7ZmZA+cEjsm6dlp5jWq81qcZWGBjuwv110MvxvB/Y=;
        b=GGulfTWPhZyIs0J9Tc6eDDqB2McbJWMs1l+UwU4KBNcfV4vH2htE3GU0mlOTEosMHR
         HakYazq+jfaKVmj7F2OGrIhATJllcql8HQWc/r3Nt5WfHQykqzp9hTnBHsISKvY+QrYn
         B2kRjGkAJqUGWdZqsfGrkPcV9Q8z1Yyvbecbsd1D0jNlLH4tr+N8B5udNCFnSoA4LoaW
         jmVRkufATCH0XU+7hAXTJ/QbMavxHtdRV824cPhe1I4+k0r7cZvcWe3XTwzM/K5TAJbU
         j8RQN1SD9iPETgsGBRABO6wvYfhDG4YigTWkDtTsikACJZipRaRKfNjp1UAxACDIQmNz
         E5ug==
X-Gm-Message-State: AOAM531rSXkpdmv+lDO7MlSg+K6TaMld9LHdPEtm3ekgoDCHHN0gf5/N
        4LZ9oEwnw9bYtoJ1us+M0LaUqiV8a5Q=
X-Google-Smtp-Source: ABdhPJxp4TQBTzwg7eU0TbVDlTb4SMvw5fmaL2dvFEKxtGqA/J2aXaSirXz03YmaXS0Zv6k+icyJEw==
X-Received: by 2002:adf:83c2:: with SMTP id 60mr28549374wre.386.1615303242469;
        Tue, 09 Mar 2021 07:20:42 -0800 (PST)
Received: from [192.168.1.101] ([37.165.49.26])
        by smtp.gmail.com with ESMTPSA id r26sm4578637wmn.28.2021.03.09.07.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 07:20:42 -0800 (PST)
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 htb_select_queue
To:     syzbot <syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        maximmi@mellanox.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tariqt@nvidia.com,
        xiyou.wangcong@gmail.com
References: <000000000000c0510605bd1bfd39@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <21985b6f-a13b-2208-790a-bfe42e1b1985@gmail.com>
Date:   Tue, 9 Mar 2021 16:20:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <000000000000c0510605bd1bfd39@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/21 4:13 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    38b5133a octeontx2-pf: Fix otx2_get_fecparam()
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=166288a8d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
> dashboard link: https://syzkaller.appspot.com/bug?extid=b53a709f04722ca12a3c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119454ccd00000
> 
> The issue was bisected to:
> 
> commit d03b195b5aa015f6c11988b86a3625f8d5dbac52
> Author: Maxim Mikityanskiy <maximmi@mellanox.com>
> Date:   Tue Jan 19 12:08:13 2021 +0000
> 
>     sch_htb: Hierarchical QoS hardware offload
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ab12ecd00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=106b12ecd00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ab12ecd00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 183fe067 P4D 183fe067 PUD 21aef067 PMD 0 
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 10125 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
> FS:  00007f73f9698700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  htb_offload net/sched/sch_htb.c:1011 [inline]
>  htb_select_queue+0x17f/0x2c0 net/sched/sch_htb.c:1349
>  tc_modify_qdisc+0x44a/0x1a50 net/sched/sch_api.c:1657
>  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x466019
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f73f9698188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466019
> RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
> RBP: 00000000004bd067 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
> R13: 00007fffefccc11f R14: 00007f73f9698300 R15: 0000000000022000
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace e1544e8206616773 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
> FS:  00007f73f9698700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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


Hmm... what about this :

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a1404edcfd17a792321758cd4bdd173..680afb5bfe2294a5531c7aaeed698b95ea3ab20c 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1651,15 +1651,16 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
                        err = -ENOENT;
                }
        } else {
-               struct netdev_queue *dev_queue;
+               struct netdev_queue *dev_queue = NULL;
 
                if (p && p->ops->cl_ops && p->ops->cl_ops->select_queue)
                        dev_queue = p->ops->cl_ops->select_queue(p, tcm);
-               else if (p)
-                       dev_queue = p->dev_queue;
-               else
-                       dev_queue = netdev_get_tx_queue(dev, 0);
-
+               if (!dev_queue) {
+                       if (p)
+                               dev_queue = p->dev_queue;
+                       else
+                               dev_queue = netdev_get_tx_queue(dev, 0);
+               }
                q = qdisc_create(dev, dev_queue, p,
                                 tcm->tcm_parent, tcm->tcm_handle,
                                 tca, &err, extack);
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index dff3adf5a9156c2412c64a10ad1b2ce9e1367433..cc6eccd688701ae00255f07e32fb4b0efbaf45ce 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1008,6 +1008,8 @@ static void htb_set_lockdep_class_child(struct Qdisc *q)
 
 static int htb_offload(struct net_device *dev, struct tc_htb_qopt_offload *opt)
 {
+       if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+               return -EOPNOTSUPP;
        return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_HTB, opt);
 }
 

