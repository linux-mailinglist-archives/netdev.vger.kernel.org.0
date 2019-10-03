Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1639C96C7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 04:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfJCCn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 22:43:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39070 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfJCCn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 22:43:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id s17so765081plp.6;
        Wed, 02 Oct 2019 19:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UIfKc4S1vpUsL7U+6flTO0/inBbMt93SCWSv6HECScM=;
        b=FrvnO9XJ8vh53Dd+AzjhHhud3zG3DcToJdYbtA8QhoIFmgWuJYPL2P5Bez0fv5Yjgw
         MC7fs5+fd6huHna8L1Iu3EuCpoQk0yof/KvlI9dTNErbjiVPBfo8NirUiJTeuqPcYeTp
         YyZQahUTdixQR8CfL03wmmhHJspBWrsk9l3ZV8+mmbHOzeMXWTHq0BQFZlkrJtIah0y2
         zTV0SOQtdEIyiOiUJnayYXNZD4egjoqaYtALWT0oFV8i5s1vK8ulvAv5xmJ+lPp+Vk7G
         9ikOuhAGuzI+YkO78j6piMEwE45+e7opDhPW+whtesxv8I+bl1TfDKXXHL6IJvW9LhMX
         P1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UIfKc4S1vpUsL7U+6flTO0/inBbMt93SCWSv6HECScM=;
        b=Oq90BujuPCSRptxIgyQ9wxrDU88DhC3bTEVezrIYobDZcqJuVZ9wVAjfAInSZGWNn+
         X8rOcOilyxJ8gBAfVQ73ZM6Jaos5QWZ/GGWAptURA1iXr8Zf9Xk1qn/TXM3CJf/Ah6FY
         QKZqQNaZvO+MhxHlUWLxNJ5B4GCEs1b4TxW2qV+mo3DQ/Dt+xNfBOMUGIPJxxN1t9TfM
         bwATzvkrO6ggEEkCnxziKAlXK703VEfkOa0sNJ6MVSSyYpzvfkN21LtWNAiH1aYPssTI
         ws1HFP8XGSryY5cwKxc4p8+EM0ZhcGux7MYzcfl8KH52UAd09SaVTXYjzpU6S1YprXZt
         0tbQ==
X-Gm-Message-State: APjAAAUsmf256EjqQeAsz1fAO1qc+4cdnN39qtDkPxfWLXURcHevQof7
        x3l4b0VfpD8UIG3zIBYRiGk=
X-Google-Smtp-Source: APXvYqzKCFh6daqQ5QWKXP4U8FeVAh5qeWcyJvvzHc2AohTeGubK5tt9kLx5Oda0RrYmGYsSyFalvQ==
X-Received: by 2002:a17:902:467:: with SMTP id 94mr7006178ple.208.1570070606409;
        Wed, 02 Oct 2019 19:43:26 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 20sm40755pgo.27.2019.10.02.19.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 19:43:25 -0700 (PDT)
Subject: Re: general protection fault in veth_get_stats64
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        syzbot <syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com>
Cc:     airlied@linux.ie, andriy.shevchenko@linux.intel.com,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        bskeggs@redhat.com, daniel@ffwll.ch,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        dri-devel@lists.freedesktop.org, David Ahern <dsahern@gmail.com>,
        f.fainelli@gmail.com, guoren@kernel.org, hawk@kernel.org,
        idosch@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>, jwi@linux.ibm.com,
        Martin Lau <kafai@fb.com>, kimbrownkd@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        nouveau@lists.freedesktop.org, petrm@mellanox.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        wanghai26@huawei.com, Yonghong Song <yhs@fb.com>,
        yuehaibing@huawei.com, jiri@mellanox.com
References: <00000000000051e9280593f2dc9f@google.com>
 <CA+FuTSedj9+UJKLfuER+FuEmQvWNqsDfO5i+Z6vit0OoLv=NLA@mail.gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <350e633a-1e05-b909-ea9c-4f726e5dcf25@gmail.com>
Date:   Thu, 3 Oct 2019 11:43:16 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSedj9+UJKLfuER+FuEmQvWNqsDfO5i+Z6vit0OoLv=NLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/03 5:59, Willem de Bruijn wrote:
> On Wed, Oct 2, 2019 at 3:56 PM syzbot
> <syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    a32db7e1 Add linux-next specific files for 20191002
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=175ab7cd600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=599cf05035799eef
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3f3e5e77d793c7a6fe6c
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f8b943600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16981a25600000
>>
>> The bug was bisected to:
>>
>> commit 84da111de0b4be15bd500deff773f5116f39f7be
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sat Sep 21 17:07:42 2019 +0000
>>
>>       Merge tag 'for-linus-hmm' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c55847600000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14255847600000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10255847600000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+3f3e5e77d793c7a6fe6c@syzkaller.appspotmail.com
>> Fixes: 84da111de0b4 ("Merge tag 'for-linus-hmm' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma")
>>
>> RSP: 002b:00007fff0ba6c998 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004424a9
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
>> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
>> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
>> kasan: CONFIG_KASAN_INLINE enabled
>> kasan: GPF could be caused by NULL-ptr deref or user memory access
>> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 8605 Comm: syz-executor330 Not tainted 5.4.0-rc1-next-20191002
>> #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> RIP: 0010:veth_stats_rx drivers/net/veth.c:322 [inline]
>> RIP: 0010:veth_get_stats64+0x523/0x900 drivers/net/veth.c:356
>> Code: 89 85 60 ff ff ff e8 6c 74 31 fd 49 63 c7 48 69 c0 c0 02 00 00 48 03
>> 85 60 ff ff ff 48 8d b8 a0 01 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00
>> 0f 85 c9 02 00 00 48 8d b8 a8 01 00 00 48 8b 90 a0
>> RSP: 0018:ffff88809996ed00 EFLAGS: 00010202
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff84418daf
>> RDX: 0000000000000034 RSI: ffffffff84418e04 RDI: 00000000000001a0
>> RBP: ffff88809996ede0 R08: ffff888093182180 R09: ffffed1013202d6a
>> R10: ffffed1013202d69 R11: ffff888099016b4f R12: 0000000000000000
>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>> FS:  0000000001f4a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000020000140 CR3: 000000009a80b000 CR4: 00000000001406e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>    dev_get_stats+0x8e/0x280 net/core/dev.c:9220
>>    rtnl_fill_stats+0x4d/0xac0 net/core/rtnetlink.c:1191
>>    rtnl_fill_ifinfo+0x10ad/0x3af0 net/core/rtnetlink.c:1717
>>    rtmsg_ifinfo_build_skb+0xc9/0x1a0 net/core/rtnetlink.c:3635
>>    rtmsg_ifinfo_event.part.0+0x43/0xe0 net/core/rtnetlink.c:3667
>>    rtmsg_ifinfo_event net/core/rtnetlink.c:3678 [inline]
>>    rtmsg_ifinfo+0x8d/0xa0 net/core/rtnetlink.c:3676
>>    __dev_notify_flags+0x235/0x2c0 net/core/dev.c:7757
>>    rtnl_configure_link+0x175/0x250 net/core/rtnetlink.c:2968
>>    __rtnl_newlink+0x10c4/0x16d0 net/core/rtnetlink.c:3285
>>    rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3325
>>    rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5386
>>    netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>>    rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5404
>>    netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>>    netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>>    netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
>>    sock_sendmsg_nosec net/socket.c:638 [inline]
>>    sock_sendmsg+0xd7/0x130 net/socket.c:658
>>    ___sys_sendmsg+0x803/0x920 net/socket.c:2312
>>    __sys_sendmsg+0x105/0x1d0 net/socket.c:2357
>>    __do_sys_sendmsg net/socket.c:2366 [inline]
>>    __se_sys_sendmsg net/socket.c:2364 [inline]
>>    __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2364
>>    do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x4424a9
>> Code: e8 9c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007fff0ba6c998 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004424a9
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
>> RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
>> R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
>> Modules linked in:
>> ---[ end trace cc6dec8a4962bfff ]---
>> RIP: 0010:veth_stats_rx drivers/net/veth.c:322 [inline]
>> RIP: 0010:veth_get_stats64+0x523/0x900 drivers/net/veth.c:356
>> Code: 89 85 60 ff ff ff e8 6c 74 31 fd 49 63 c7 48 69 c0 c0 02 00 00 48 03
>> 85 60 ff ff ff 48 8d b8 a0 01 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00
>> 0f 85 c9 02 00 00 48 8d b8 a8 01 00 00 48 8b 90 a0
>> RSP: 0018:ffff88809996ed00 EFLAGS: 00010202
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff84418daf
>> RDX: 0000000000000034 RSI: ffffffff84418e04 RDI: 00000000000001a0
>> RBP: ffff88809996ede0 R08: ffff888093182180 R09: ffffed1013202d6a
>> R10: ffffed1013202d69 R11: ffff888099016b4f R12: 0000000000000000
>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>> FS:  0000000001f4a880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000020000140 CR3: 000000009a80b000 CR4: 00000000001406e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> Syzbot CC:ed a lot of people directly on this report. Perhaps because
> of the bisection?
> 
> Specific to the report: I think this may be introduced with the
> alternative names for network interfaces patchset.

Agree.

 From commit ff92741270bf ("net: introduce name_node struct to be used in hashlist")

@@ -8706,6 +8761,10 @@ int register_netdevice(struct net_device *dev)
  	if (ret < 0)
  		goto out;
  
+	dev->name_node = netdev_name_node_head_alloc(dev);
+	if (!dev->name_node)
+		goto out;

This returns 0 when name_node allocation failed. This allows for creating
veth devices without calling ndo_init, thus skips rx queues allocation.

Probably need "ret = -ENOMEM" before "goto out".

> 
> The reproducer
> 
> fails on      76c9ac0ee878 net: rtnetlink: add possibility to use
> alternative names as message handle
> passes on be2644aac3e1 tcp: add ipv6_addr_v4mapped_loopback() helper
> 
> Leaving
> 
> 76c9ac0ee878 net: rtnetlink: add possibility to use alternative names
> as message handle
> cc6090e985d7 net: rtnetlink: introduce helper to get net_device
> instance by ifname
> 7af12cba4ef0 net: rtnetlink: unify the code in __rtnl_newlink get dev
> with the rest
> 88f4fb0c7496 net: rtnetlink: put alternative names to getlink message
> 36fbf1e52bd3 net: rtnetlink: add linkprop commands to add and delete
> alternative ifnames
> ff92741270bf net: introduce name_node struct to be used in hashlist
> 6958c97a488c net: procfs: use index hashlist instead of name hashlist
> be2
> 

Toshiaki Makita
