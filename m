Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE4C34FC1D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhCaJEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234515AbhCaJEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617181471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oFnyCqVp+EXgH+zoavszk7CCQt6J1VVJYc4gCNFPlfU=;
        b=ZfO6RX6m2W7MqZ5fagdRSZ+5Q14OaedNDH+6/U8GXrQSdBBjVXN8PdLv/i5k5mRGZAVSjY
        ymXTFv3G6PXFmZzkgkB0T6DK7l0RzS8o8tUDDw2StONgOhEiyjAKao4yHlytT6G428hcFE
        RqDsVQGTchmAt6KS/icpXQDNqY/itsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-SWWCB-r3Mt-FwBxVV24kfQ-1; Wed, 31 Mar 2021 05:04:21 -0400
X-MC-Unique: SWWCB-r3Mt-FwBxVV24kfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3B9F1009E25;
        Wed, 31 Mar 2021 09:04:20 +0000 (UTC)
Received: from localhost (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C49A619C44;
        Wed, 31 Mar 2021 09:04:19 +0000 (UTC)
Date:   Wed, 31 Mar 2021 10:04:18 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     sgarzare@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sgarzare@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        syzbot <syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com>
Subject: Re: memory leak in virtio_transport_send_pkt_info
Message-ID: <YGQ7EhQ+hlSUdf1C@stefanha-x1.localdomain>
References: <00000000000069a2e905bad5d02e@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v4rJ/Oj+3HKafot9"
Content-Disposition: inline
In-Reply-To: <00000000000069a2e905bad5d02e@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--v4rJ/Oj+3HKafot9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2021 at 08:39:30AM -0800, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    9f29bd8b Merge tag 'fs_for_v5.11-rc5' of git://git.kernel=
=2E..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11e435af500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D162a0109d6ff7=
31f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D24452624fc4c571=
eedd9
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D135dd494d00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D128787e7500000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+24452624fc4c571eedd9@syzkaller.appspotmail.com

Hi Stefano,
Looks like tx packets are still queued when the syzkaller leak check
runs. I don't see a fix for this in linux.git. Have you already looked
at this?

Stefan

>=20
> executing program
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 26.670s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.040s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.100s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.160s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.230s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d380 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d280 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d200 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> BUG: memory leak
> unreferenced object 0xffff88811477d180 (size 96):
>   comm "syz-executor196", pid 8793, jiffies 4294968272 (age 29.290s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     ba 34 8c fe 00 00 00 00 00 00 01 00 01 00 05 00  .4..............
>   backtrace:
>     [<0000000051681be3>] kmalloc include/linux/slab.h:552 [inline]
>     [<0000000051681be3>] kzalloc include/linux/slab.h:682 [inline]
>     [<0000000051681be3>] virtio_transport_alloc_pkt+0x41/0x290 net/vmw_vs=
ock/virtio_transport_common.c:51
>     [<0000000036c2d6e6>] virtio_transport_send_pkt_info+0x105/0x1b0 net/v=
mw_vsock/virtio_transport_common.c:209
>     [<00000000dd27435f>] virtio_transport_stream_enqueue+0x58/0x80 net/vm=
w_vsock/virtio_transport_common.c:674
>     [<00000000d7e8274a>] vsock_stream_sendmsg+0x4f7/0x590 net/vmw_vsock/a=
f_vsock.c:1800
>     [<00000000d2b531e6>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000d2b531e6>] sock_sendmsg+0x56/0x80 net/socket.c:672
>     [<00000000803a63df>] ____sys_sendmsg+0x17a/0x390 net/socket.c:2345
>     [<000000009d42f642>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
>     [<000000000a37ed0e>] __sys_sendmmsg+0xed/0x290 net/socket.c:2489
>     [<00000000324c1c73>] __do_sys_sendmmsg net/socket.c:2518 [inline]
>     [<00000000324c1c73>] __se_sys_sendmmsg net/socket.c:2515 [inline]
>     [<00000000324c1c73>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2515
>     [<000000004e7b2960>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:=
46
>     [<000000002615f594>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> executing program
> executing program
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>=20

--v4rJ/Oj+3HKafot9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBkOxIACgkQnKSrs4Gr
c8guhQgAhNpKGNEIXYkCtDAP1kz36lsQoFPcGbWSsckfpzZCp0c4DRYsRYrcp50L
jqz0wGVbUOkfFGBfhijgKUMYWX63OlCdVFNb42V7dAASc1JdtyvyIGyyZX+sot/m
FwnD3xYxVqD6CdMbZeF3lc17t0Hb7mwg0Re2/difMhHjqeglpX5gxadXc9XX4Jo2
UvkgvU4zySWIdf4nKab0DEj4RLSypvXz1M25GUDZ+9tykPD/j/M/6TKkl2HJAwUs
RYswkNFAZF9JFWN2OTvyEDfPoO/f0+I/PuA9tLzdKiMVIm8lpzY9yR6kaeak2QG6
9eknVoURPmrcVkOaiBv0ooMWGr0q8A==
=Dm6J
-----END PGP SIGNATURE-----

--v4rJ/Oj+3HKafot9--

