Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1234FE53
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhCaKus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 06:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234981AbhCaKuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 06:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617187839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K86fwwRt3x+/sobik8nvlY4HBVdEdJ4URAAUvyRr474=;
        b=JAtwFhprctDUyzqVH4ke66wz9jFA7yiQi5a6aQJd2PvBeIw9avoMcSeyuuJOsD8lCdS79Y
        QSASOGS99D910ru/UP11mwOow7fI6CslnCi4hV7eDdhh2xn5ek1QIcRoA/QT2bJARlZSOS
        jgrKuFSTSdjPbanmddFv/O04WSc7KJs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-HpbTNKENPqCWgtOSxYQR8A-1; Wed, 31 Mar 2021 06:50:36 -0400
X-MC-Unique: HpbTNKENPqCWgtOSxYQR8A-1
Received: by mail-wm1-f72.google.com with SMTP id b20-20020a7bc2540000b029010f7732a35fso1692289wmj.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 03:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K86fwwRt3x+/sobik8nvlY4HBVdEdJ4URAAUvyRr474=;
        b=NzKQBy1IvjjeZwcVuetpgpPoPgTktxNt/gXmjHM1sjl9RJgdRHptRGGTJi1xIRIIs2
         XV8dBk851denS2aH2VdoogZmEEFfVZyEtWCVmfl4EY0LFgVA6kdShb/liWRcJslP6ffD
         Y8IXNl7IFpl+AXBN/wpVwTNBDL7YPwk0TfJQ67/pIM2nAcsXZaaq/wuDeB7/zaFmXwV+
         iYLYw6/j6Pu3ndB0D94gJJ0rcpeK/GUqmjXRgbLwf8tG894SLbCCS245omSMjY4Brd8I
         fpOo4wH9z/071GVkfDIORP1WnFFs5Zz/WwtzrYqKx6/C7QVtPfFVIDki0T5AQYXlcwhG
         tc0Q==
X-Gm-Message-State: AOAM530xPoJF6odFMARbom4h1a1Tv5qk8UEgEvTbQ3YpJj9d0LTSEvWu
        +tEzCPOjizY6g4G4NHWAftByJ7OwpSzTmtnNR+R050nz38n2zP4FnlxXS1aI8hocFBaMaZ764RX
        B0SYVd30h4S7mtEfV
X-Received: by 2002:adf:f3cf:: with SMTP id g15mr2983917wrp.57.1617187835283;
        Wed, 31 Mar 2021 03:50:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIC8/Tr16sPK/2ZAP1ZkJs01IWqyNA+wZvds0fSxxtRjJOG5bN9sU4mEiY6qpT7l8bVZX1Gg==
X-Received: by 2002:adf:f3cf:: with SMTP id g15mr2983871wrp.57.1617187834744;
        Wed, 31 Mar 2021 03:50:34 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id a13sm3588406wrp.31.2021.03.31.03.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 03:50:34 -0700 (PDT)
Date:   Wed, 31 Mar 2021 12:50:31 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        syzbot <syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com>
Subject: Re: memory leak in virtio_transport_send_pkt_info
Message-ID: <20210331105031.ewh4cq2xfe3pcn2v@steredhat>
References: <00000000000069a2e905bad5d02e@google.com>
 <YGQ7EhQ+hlSUdf1C@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YGQ7EhQ+hlSUdf1C@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:04:18AM +0100, Stefan Hajnoczi wrote:
>On Mon, Feb 08, 2021 at 08:39:30AM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    9f29bd8b Merge tag 'fs_for_v5.11-rc5' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11e435af500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=162a0109d6ff731f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=24452624fc4c571eedd9
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135dd494d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128787e7500000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com
>
>Hi Stefano,
>Looks like tx packets are still queued when the syzkaller leak check
>runs. I don't see a fix for this in linux.git. Have you already looked
>at this?

I missed this report.
Looking at the reproducer it seems to happen when we send a message to a 
socket not yet accept()ed.

I'll take a closer look over the next few days, thanks for bringing it 
up.

Stefano

>
>Stefan
>
>>
>> executing program
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d380 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d280 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d200 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811477d180 (size 96):
>>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>>   backtrace:
>>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vsock/virtio_transport_common.c:51
>>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/vmw_vsock/virtio_transport_common.c:209
>>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vmw_vsock/virtio_transport_common.c:674
>>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/af_vsock.c:1800
>>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> executing program
>> executing program
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>


