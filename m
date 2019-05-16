Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F622025F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfEPJQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPJQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:16:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50EE9792CD;
        Thu, 16 May 2019 09:16:41 +0000 (UTC)
Received: from localhost (ovpn-117-183.ams2.redhat.com [10.36.117.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D367019936;
        Thu, 16 May 2019 09:16:40 +0000 (UTC)
Date:   Thu, 16 May 2019 10:16:39 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org,
        "Jorge E. Moreira" <jemoreira@google.com>
Subject: Re: [PATCH] vsock/virtio: Initialize core virtio vsock before
 registering the driver
Message-ID: <20190516091639.GP29507@stefanha-x1.localdomain>
References: <20190501003001.186239-1-jemoreira@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l7GkBbkEatsaRqBf"
Content-Disposition: inline
In-Reply-To: <20190501003001.186239-1-jemoreira@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 16 May 2019 09:16:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l7GkBbkEatsaRqBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2019 at 05:30:01PM -0700, Jorge E. Moreira wrote:
> Avoid a race in which static variables in net/vmw_vsock/af_vsock.c are
> accessed (while handling interrupts) before they are initialized.
>=20
> [    4.201410] BUG: unable to handle kernel paging request at fffffffffff=
fffe8
> [    4.207829] IP: vsock_addr_equals_addr+0x3/0x20
> [    4.211379] PGD 28210067 P4D 28210067 PUD 28212067 PMD 0
> [    4.211379] Oops: 0000 [#1] PREEMPT SMP PTI
> [    4.211379] Modules linked in:
> [    4.211379] CPU: 1 PID: 30 Comm: kworker/1:1 Not tainted 4.14.106-4192=
97-gd7e28cc1f241 #1
> [    4.211379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.10.2-1 04/01/2014
> [    4.211379] Workqueue: virtio_vsock virtio_transport_rx_work
> [    4.211379] task: ffffa3273d175280 task.stack: ffffaea1800e8000
> [    4.211379] RIP: 0010:vsock_addr_equals_addr+0x3/0x20
> [    4.211379] RSP: 0000:ffffaea1800ebd28 EFLAGS: 00010286
> [    4.211379] RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffffffffb=
94e42f0
> [    4.211379] RDX: 0000000000000400 RSI: ffffffffffffffe0 RDI: ffffaea18=
00ebdd0
> [    4.211379] RBP: ffffaea1800ebd58 R08: 0000000000000001 R09: 000000000=
0000001
> [    4.211379] R10: 0000000000000000 R11: ffffffffb89d5d60 R12: ffffaea18=
00ebdd0
> [    4.211379] R13: 00000000828cbfbf R14: 0000000000000000 R15: ffffaea18=
00ebdc0
> [    4.211379] FS:  0000000000000000(0000) GS:ffffa3273fd00000(0000) knlG=
S:0000000000000000
> [    4.211379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.211379] CR2: ffffffffffffffe8 CR3: 000000002820e001 CR4: 000000000=
01606e0
> [    4.211379] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [    4.211379] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [    4.211379] Call Trace:
> [    4.211379]  ? vsock_find_connected_socket+0x6c/0xe0
> [    4.211379]  virtio_transport_recv_pkt+0x15f/0x740
> [    4.211379]  ? detach_buf+0x1b5/0x210
> [    4.211379]  virtio_transport_rx_work+0xb7/0x140
> [    4.211379]  process_one_work+0x1ef/0x480
> [    4.211379]  worker_thread+0x312/0x460
> [    4.211379]  kthread+0x132/0x140
> [    4.211379]  ? process_one_work+0x480/0x480
> [    4.211379]  ? kthread_destroy_worker+0xd0/0xd0
> [    4.211379]  ret_from_fork+0x35/0x40
> [    4.211379] Code: c7 47 08 00 00 00 00 66 c7 07 28 00 c7 47 08 ff ff f=
f ff c7 47 04 ff ff ff ff c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 8b 47 0=
8 <3b> 46 08 75 0a 8b 47 04 3b 46 04 0f 94 c0 c3 31 c0 c3 90 66 2e
> [    4.211379] RIP: vsock_addr_equals_addr+0x3/0x20 RSP: ffffaea1800ebd28
> [    4.211379] CR2: ffffffffffffffe8
> [    4.211379] ---[ end trace f31cc4a2e6df3689 ]---
> [    4.211379] Kernel panic - not syncing: Fatal exception in interrupt
> [    4.211379] Kernel Offset: 0x37000000 from 0xffffffff81000000 (relocat=
ion range: 0xffffffff80000000-0xffffffffbfffffff)
> [    4.211379] Rebooting in 5 seconds..
>=20
> Fixes: 22b5c0b63f32 ("vsock/virtio: fix kernel panic after device hot-unp=
lug")
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org [4.9+]
> Signed-off-by: Jorge E. Moreira <jemoreira@google.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

This patch is good to go, I've posted my R-b downthread.

Stefan

--l7GkBbkEatsaRqBf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzdKncACgkQnKSrs4Gr
c8j9OwgAvc2/4f5xfLlbobymDJBg1CcNAUHQBHRVHoj4h+zCxvuHRO6TnZtDXtsl
MJ5ORu5AKDYS5OLvtMScWDrSXC329Uv1cqDKYtyIG7efL56ofYqiJmrIiq+Ju16n
Cec9A6+RMYwBDHNHK5iqzo7if6bh7m5BPeYlXO2YXj5x0IOlNPJxIhVzK1jEmo4O
6jjzRSGuHKdqsfNX7qXC8+ibzUX3IwGw0A4dZHJe/gFY4zp36fH23L89WmKbwyv8
6KgDGj1N6ByNkSeEUTIse8nxyI0KSgQcw12q61dS1wahgJJqePzwWP/gMxt3D5tM
5MEnPpeSB1ovsKDGnxqzUOiB7S8z3A==
=04Ga
-----END PGP SIGNATURE-----

--l7GkBbkEatsaRqBf--
