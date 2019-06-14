Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA4456DB
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfFNH7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:59:00 -0400
Received: from kadath.azazel.net ([81.187.231.250]:37526 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfFNH67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G0kG6tqXXsRGIiO+BHcEtfpdFD2+yHGBJ6x5btZuxkA=; b=MvtV+EL3y940ymGGuOgSbcqr9G
        kWmqZgj+RVG52zJpxNLvpASYK91l/pZPjyaRJKZ8gmulUwbkc96+v/Y3f8pcACZtbmAcrEkyPfmzj
        +AF3DdZwZZal7wuKknrxWgnuWgI9dr1S1DdHvkdTXC5ulV+8gZwKxTLKaKMGgpkmVPrnFNn2sNQR4
        n6CgI7c6q5ylvS9WiiibsXaUCeBCE7SBBBvAQsz5MT79+syCQmzKZ0tTFhsIhiHXI6yC2kzS7naSP
        t/EBFrBKI1XUa2pswCGBzSodZA/OFsVixCOxd62s53RqKr5Oldky3picc/JNFMdCSIUwQqByoqJ4m
        boLAhlMg==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hbh6A-0001e9-VN; Fri, 14 Jun 2019 08:58:11 +0100
Date:   Fri, 14 Jun 2019 08:58:09 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     syzbot <syzbot+0789f0c7e45efd7bb643@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dvyukov@google.com, hawk@kernel.org,
        hdanton@sina.com, jakub.kicinski@netronome.com,
        jasowang@redhat.com, john.fastabend@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        xdp-newbies@vger.kernel.org
Subject: Re: memory leak in vhost_net_ioctl
Message-ID: <20190614075809.32gnqqpzgl25gxmz@azazel.net>
References: <20190614024519.6224-1-hdanton@sina.com>
 <000000000000f9d056058b3fe507@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mv67wdquhvqcpoxi"
Content-Disposition: inline
In-Reply-To: <000000000000f9d056058b3fe507@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mv67wdquhvqcpoxi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-06-13, at 20:04:01 -0700, syzbot wrote:
> syzbot has tested the proposed patch but the reproducer still
> triggered crash: memory leak in batadv_tvlv_handler_register

There's already a fix for this batman leak:

  https://lore.kernel.org/netdev/00000000000017d64c058965f966@google.com/
  https://www.open-mesh.org/issues/378

>   484.626788][  T156] bond0 (unregistering): Releasing backup
>   interface bond_slave_1
> Warning: Permanently added '10.128.0.87' (ECDSA) to the list of known
> hosts.
> BUG: memory leak
> unreferenced object 0xffff88811d25c4c0 (size 64):
>   comm "softirq", pid 0, jiffies 4294943668 (age 434.830s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 e0 fc 5b 20 81 88 ff ff  ..........[ ....
>     00 00 00 00 00 00 00 00 20 91 15 83 ff ff ff ff  ........ .......
>   backtrace:
>     [<000000000045bc9d>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
>     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280
> mm/slab.c:3553
>     [<00000000197d773e>] kmalloc include/linux/slab.h:547 [inline]
>     [<00000000197d773e>] kzalloc include/linux/slab.h:742 [inline]
>     [<00000000197d773e>] batadv_tvlv_handler_register+0xae/0x140
> net/batman-adv/tvlv.c:529
>     [<00000000fa9f11af>] batadv_tt_init+0x78/0x180
> net/batman-adv/translation-table.c:4411
>     [<000000008c50839d>] batadv_mesh_init+0x196/0x230
> net/batman-adv/main.c:208
>     [<000000001c5a74a3>] batadv_softif_init_late+0x1ca/0x220
> net/batman-adv/soft-interface.c:861
>     [<000000004e676cd1>] register_netdevice+0xbf/0x600
> net/core/dev.c:8635
>     [<000000005601497b>] __rtnl_newlink+0xaca/0xb30
> net/core/rtnetlink.c:3199
>     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80
> net/core/rtnetlink.c:3245
>     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0
> net/core/rtnetlink.c:5214
>     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170
> net/netlink/af_netlink.c:2482
>     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30
> net/core/rtnetlink.c:5232
>     [<000000000d47c000>] netlink_unicast_kernel
> net/netlink/af_netlink.c:1307 [inline]
>     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0
> net/netlink/af_netlink.c:1333
>     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480
> net/netlink/af_netlink.c:1922
>     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
>     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
>     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
>     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
>     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
>     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966
>
> BUG: memory leak
> unreferenced object 0xffff8881024a3340 (size 64):
>   comm "softirq", pid 0, jiffies 4294943678 (age 434.730s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 e0 2c 66 04 81 88 ff ff  .........,f.....
>     00 00 00 00 00 00 00 00 20 91 15 83 ff ff ff ff  ........ .......
>   backtrace:
>     [<000000000045bc9d>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
>     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280
> mm/slab.c:3553
>     [<00000000197d773e>] kmalloc include/linux/slab.h:547 [inline]
>     [<00000000197d773e>] kzalloc include/linux/slab.h:742 [inline]
>     [<00000000197d773e>] batadv_tvlv_handler_register+0xae/0x140
> net/batman-adv/tvlv.c:529
>     [<00000000fa9f11af>] batadv_tt_init+0x78/0x180
> net/batman-adv/translation-table.c:4411
>     [<000000008c50839d>] batadv_mesh_init+0x196/0x230
> net/batman-adv/main.c:208
>     [<000000001c5a74a3>] batadv_softif_init_late+0x1ca/0x220
> net/batman-adv/soft-interface.c:861
>     [<000000004e676cd1>] register_netdevice+0xbf/0x600
> net/core/dev.c:8635
>     [<000000005601497b>] __rtnl_newlink+0xaca/0xb30
> net/core/rtnetlink.c:3199
>     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80
> net/core/rtnetlink.c:3245
>     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0
> net/core/rtnetlink.c:5214
>     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170
> net/netlink/af_netlink.c:2482
>     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30
> net/core/rtnetlink.c:5232
>     [<000000000d47c000>] netlink_unicast_kernel
> net/netlink/af_netlink.c:1307 [inline]
>     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0
> net/netlink/af_netlink.c:1333
>     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480
> net/netlink/af_netlink.c:1922
>     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
>     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
>     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
>     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
>     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
>     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966
>
> BUG: memory leak
> unreferenced object 0xffff888108a71b80 (size 128):
>   comm "syz-executor.3", pid 7367, jiffies 4294943696 (age 434.550s)
>   hex dump (first 32 bytes):
>     f0 f8 bf 02 81 88 ff ff f0 f8 bf 02 81 88 ff ff  ................
>     1a dc 77 da 54 a0 be 41 64 20 e9 56 ff ff ff ff  ..w.T..Ad .V....
>   backtrace:
>     [<000000000045bc9d>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
>     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280
> mm/slab.c:3553
>     [<00000000cc6863ae>] kmalloc include/linux/slab.h:547 [inline]
>     [<00000000cc6863ae>] hsr_create_self_node+0x42/0x150
> net/hsr/hsr_framereg.c:84
>     [<000000000e2bb6b0>] hsr_dev_finalize+0xa4/0x233
> net/hsr/hsr_device.c:441
>     [<000000003b100a4a>] hsr_newlink+0xf3/0x140
> net/hsr/hsr_netlink.c:69
>     [<00000000b5efb0eb>] __rtnl_newlink+0x892/0xb30
> net/core/rtnetlink.c:3187
>     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80
> net/core/rtnetlink.c:3245
>     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0
> net/core/rtnetlink.c:5214
>     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170
> net/netlink/af_netlink.c:2482
>     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30
> net/core/rtnetlink.c:5232
>     [<000000000d47c000>] netlink_unicast_kernel
> net/netlink/af_netlink.c:1307 [inline]
>     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0
> net/netlink/af_netlink.c:1333
>     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480
> net/netlink/af_netlink.c:1922
>     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
>     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
>     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
>     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
>     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
>     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966
>     [<000000003ba31db7>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>     [<0000000075c8daad>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Tested on:
>
> commit:         c11fb13a Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c8f3b6a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=12477101a00000

J.

--mv67wdquhvqcpoxi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0DU4oACgkQ0Z7UzfnX
9sMn7g/8DSm3sIrrshWDSyy7szl4gf7yrszSZ+Dusy9+UNL7QnfrgTAgzFEESeBH
D+mzA5Jnv/xZH6nBWwdo+hvOzVpOxJrK2vF1iLOC+6q0frEWN+626UUxjVN3q2dU
lEpXnIsEY1j/G8fDXcWtvDuX40rCKbSYbCs0YHf/RxJRiCG4qHcISfwViOlvUryu
9O+13yT82OwYjf8zg3Czgll3f67/tLMhcIXAztccMGJmzoIiqi9wu7VCLHO9WjaH
OgqRYXow09VwBdm1SeX6RaiU0NKikPx0Cay59EHBUu4eVUs7dk2hHh2e8n5CRC8e
fMx8zEDmc9/fU0t+iwekfjX5y4U3VvOks1i+EdzheClV8mLy3x4F9k0+3el3TgJF
qmCV8SSjlmQJ11FCacd4HCJ+4miUF+Fz/G7ii5QiU+j/vsUEzBEIKDKAT5qsYUwL
j7n1HsgRxX8GXA/7MqDo4+EwCZxWRXqTNqwG5FOfAoLq/eJk5y1DCRqWGFVPvTN8
lskd/oo+fQ2sDf1YtI3Hm1ZppzbQYjwSUIQmEmA9PuWVR1QM85d2Jqwf+plFyKn6
zJ+mFFv80h/k9o35VQaBOsHema+/lTVvOSaWwoys6njDMU2saYvtY9pRWkn0mNE4
EbnPJb3JIj+0B/Lq/XgMoNIWutlwyeH5YOgnGGO4dcBuPMoiuBA=
=QX3O
-----END PGP SIGNATURE-----

--mv67wdquhvqcpoxi--
