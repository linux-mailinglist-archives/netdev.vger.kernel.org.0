Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D58218EC6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgGHRq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728576AbgGHRq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594230385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZkaID9R3Jhc4tsMAVwPHjs/XB1tI9aBrCq6liU7gBk8=;
        b=YRWbqEEuqo50zy6XA/2QPQd9L42WyZIQpqvUTyS8MSwHU+sX4BeDXAQCzZG2G1vmeUOHhR
        6fGviMfsW/kvoCQ1KrXQFOnkHb3Vg/SyL57bd9KfqC8RlZwcj6zkKdBJWz4H3Pr9pmF9c/
        NMPIcPhGP2ZH280wsvmM1eFwo0S5vvo=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-77j9YFmNPASWwmo3gDbxUA-1; Wed, 08 Jul 2020 13:46:18 -0400
X-MC-Unique: 77j9YFmNPASWwmo3gDbxUA-1
Received: by mail-ot1-f72.google.com with SMTP id r12so5039384otd.17
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 10:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZkaID9R3Jhc4tsMAVwPHjs/XB1tI9aBrCq6liU7gBk8=;
        b=fhZFFoEVHzcAqVo4urjmH0IzaNu3tK8lpbC2H7sXl0/9AEFO3iRTyxnxOqOq9YOEc5
         mYxf6xoLOobJlndM+VpytXIR4RpErVT2BPk9z5oHA1pi9fnpnhCyPl7wddZtab1i16UE
         wYHsvzqlknK3FcZozMx5gXmdxsrB2CWRn93HyJhqdm6HWmr3oKQLaIFULDN7cvULd9bA
         IadeRPmZuIk8iqmvi9k1xnnoiYmMfVEzCv4BPGTW+r5FakK/auS9KdpczwPyHNH46/GO
         SGqAdZ51vWVJvgEntSn7JSYwoyEiSmmVzNZsy69IpyrALblBBAnEJnPvjk07zu5KPOo3
         9u9A==
X-Gm-Message-State: AOAM533z7NfRu4XZ5EZJSGFmIPyKfxf4RZBtnXEgDemtFY6cWESCvabV
        jzUg/bpM9Vj1o+l8zSV4XMHQtU/wPcHGFnIVCKU6IgDKezTj1/1pLcEOH94O4hxs2rzLNpOiobb
        7jhe0nqVFlyGeFeyK3aKzYCJ+/2Nd3Cuv
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr7845679oih.92.1594230377646;
        Wed, 08 Jul 2020 10:46:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBvnBE7vG7SYjJlNlw8BxUfO77iK66DtTfRnuh/WddAXOJxgxj9SwafZ44RoN1GuiRH4m4WrcdoV7b09jm+5A=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr7845656oih.92.1594230377328;
 Wed, 08 Jul 2020 10:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b164d505a9c7b802@google.com>
In-Reply-To: <000000000000b164d505a9c7b802@google.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 8 Jul 2020 13:46:06 -0400
Message-ID: <CAKfmpSdmC1QEmht7BbrDM5FMqyZfwxJXTTt+OJB3qyy5bzucTA@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage in bond_ipsec_add_sa
To:     syzbot <syzbot+582c98032903dcc04816@syzkaller.appspotmail.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, j.vosburgh@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Veaceslav Falico <vfalico@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 11:44 AM syzbot
<syzbot+582c98032903dcc04816@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e44f65fd xen-netfront: remove redundant assignment to vari..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16148f87100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
> dashboard link: https://syzkaller.appspot.com/bug?extid=582c98032903dcc04816
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+582c98032903dcc04816@syzkaller.appspotmail.com
>
> =============================
> WARNING: suspicious RCU usage
> 5.8.0-rc2-syzkaller #0 Not tainted
> -----------------------------
> drivers/net/bonding/bond_main.c:387 suspicious rcu_dereference_protected() usage!

Hm. Access to curr_active_slave in the bonding driver is kind of all
over the place, between rtnl_dereference, rcu_deference,
rcu_access_pointer and just reading it without any protections. It
does look like this is a case where bond_ipsec_add_sa() gets called
without RTNL being held, so perhaps we should be using rcu_dereference
here, since we do need to dereference the acquired pointer, but
probably don't need to be holding RTNL here.


> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syz-executor.0/5186:
>  #0: ffff888089791a28 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3}, at: xfrm_netlink_rcv+0x5c/0x90 net/xfrm/xfrm_user.c:2687
>
> stack backtrace:
> CPU: 1 PID: 5186 Comm: syz-executor.0 Not tainted 5.8.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  bond_ipsec_add_sa+0x1c8/0x220 drivers/net/bonding/bond_main.c:387
>  xfrm_dev_state_add+0x2da/0x7b0 net/xfrm/xfrm_device.c:268
>  xfrm_state_construct net/xfrm/xfrm_user.c:655 [inline]
>  xfrm_add_sa+0x2166/0x34f0 net/xfrm/xfrm_user.c:684
>  xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2680
>  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
>  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2688
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45cb29
> Code: Bad RIP value.
> RSP: 002b:00007ff7e9a92c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000005027e0 RCX: 000000000045cb29
> RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
> RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000a45 R14: 00000000004cd2c9 R15: 00007ff7e9a936d4
> bond0: (slave bond_slave_0): Slave does not support ipsec offload
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>


-- 
Jarod Wilson
jarod@redhat.com

