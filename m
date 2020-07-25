Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6122D793
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGYMqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 08:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGYMp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 08:45:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1CC0619E4
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 05:45:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l63so6867438pge.12
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 05:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VtoqIS+zgI6nyufN52Ah9gEj+z/4I1H8Qa1t04sn3Tk=;
        b=Pbc3RQ8ryfhXyi3ruEofGZZwrDXQBO4dwRl+LdXFgk/KMEQFIKOhPCt/jmd+zFDTuo
         uC0Oy38WzwnzAbiAT4h0IS6uQwq7rC5TE6Do59eqAiSpEpH0VMztb82Pcvh3vgHYqRlP
         YXc0SSfJzEKMDh6+8rV7ooD2kXqv8IoI26NXQ+bDIZ8Owqv048pyvpOGT7vjFqJ6Imjw
         /px1tIxuSLcmfq09CqyFpuJMuFLGbhvO/NLan8l0kHoBXL/RQEIZbb9ivj5umxZSuvnL
         YiO+4mBW1Z3Fnu+VE/48IcCkWiWv19XXZqEaK35dpni88UvrvklUGiDedp6VnDEjcoWl
         edeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VtoqIS+zgI6nyufN52Ah9gEj+z/4I1H8Qa1t04sn3Tk=;
        b=EiuQ3ebgQQHkT7tQGqUkTuXNBDzywL64Li/sG/jZ03kE+Dvunz1cRV7Pulgfz6g6mt
         9OGFhszaweLapR55RCdchLcnRGub/qlcSAfL5KNPrDqyhpk+2hWkGJhhrnYgPUD5VQWI
         fJgc8RRLM3yeAsx7JkCVukMQ3JwwUM5XPSuY6rj9u9uOht6GS0+LG+N2jth0mtQdwS4y
         kFYGyN6XnmSrdhZ2YDZKq0X52goh5crmxoGyh5VTsSpJVbpSmRw/+JL6qa3a3lYilVT7
         ZEoj9NSpt0rUHgyprx7eoz9mQFHk8Ta+YsddFSU3nEQk2mKbPRzVTBA6LobQ0cQEvwcP
         Ee7Q==
X-Gm-Message-State: AOAM532b0pixczGyTEfVUwCKzap9L2b0iwXyr8XqPTTDcy3RJV0WAXAH
        Ds7HbkPVNLDR7eA3ux6uTM6TRQ==
X-Google-Smtp-Source: ABdhPJyxcPXppFGVI0NVUo80a0krOh+wYNshMyG7EJBlSFyuk2QDCFURy3r1FIjjzNzI6e5SwXeU0w==
X-Received: by 2002:a63:ca11:: with SMTP id n17mr12240817pgi.439.1595681158939;
        Sat, 25 Jul 2020 05:45:58 -0700 (PDT)
Received: from localhost ([2406:7400:73:5836:d1f0:826d:1814:b78e])
        by smtp.gmail.com with ESMTPSA id f207sm9650057pfa.107.2020.07.25.05.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 05:45:57 -0700 (PDT)
Date:   Sat, 25 Jul 2020 18:15:53 +0530
From:   B K Karthik <bkkarthik@pesu.pes.edu>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] net: ipv6: fix slab-out-of-bounda Read in
 xfrm6_tunnel_alloc_spi
Message-ID: <20200725124553.zunta65rf3j23cth@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lhvcifgdqsnv7n3m"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lhvcifgdqsnv7n3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fix slab-out-of-bounds Read in xfrm6_tunnel_alloc_spi
by checking for existance of head for the list spi_byspi

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_t=
unnel.c:124 [inline]
BUG: KASAN: slab-out-of-bounds in xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ip=
v6/xfrm6_tunnel.c:174
Read of size 4 at addr ffff88809a3fe000 by task syz-executor597/6834
CPU: 1 PID: 6834 Comm: syz-executor597 Not tainted 5.8.0-rc5-next-20200716-=
syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:124 [inline]
 xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ipv6/xfrm6_tunnel.c:174
 ipcomp6_tunnel_create net/ipv6/ipcomp6.c:84 [inline]
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:124 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x2af/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2525
 pfkey_msg2xfrm_state net/key/af_key.c:1291 [inline]
 pfkey_add+0x1a10/0x2b70 net/key/af_key.c:1508
 pfkey_process+0x66d/0x7a0 net/key/af_key.c:2834
 pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3673
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440409
Code: Bad RIP value.
RSP: 002b:00007ffea3e50018 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440409
RDX: 0400000000000282 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401c10
R13: 0000000000401ca0 R14: 0000000000000000 R15: 0000000000000000
Allocated by task 6731:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:535 [inline]
 slab_alloc mm/slab.c:3312 [inline]
 kmem_cache_alloc+0x138/0x3a0 mm/slab.c:3482
 dup_fd+0x89/0xc90 fs/file.c:293
 copy_files kernel/fork.c:1459 [inline]
 copy_process+0x1dd0/0x6b70 kernel/fork.c:2064
 _do_fork+0xe8/0xb10 kernel/fork.c:2434
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2551
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
The buggy address belongs to the object at ffff88809a3fe0c0
 which belongs to the cache files_cache of size 832
The buggy address is located 192 bytes to the left of
 832-byte region [ffff88809a3fe0c0, ffff88809a3fe400)
The buggy address belongs to the page:
page:000000007671797d refcount:1 mapcount:0 mapping:0000000000000000 index:=
0xffff88809a3fec00 pfn:0x9a3fe
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027a5248 ffffea0002a3b648 ffff88821bc47600
raw: ffff88809a3fec00 ffff88809a3fe0c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88809a3fdf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809a3fdf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809a3fe000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88809a3fe080: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
 ffff88809a3fe100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Reported-and-testedby: syzbot+87b2b4484df1d40e7ece@syzkaller.appspotmail.com
Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
---
 net/ipv6/xfrm6_tunnel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fab..2d049244be81 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -121,8 +121,9 @@ static u32 __xfrm6_tunnel_alloc_spi(struct net *net, xf=
rm_address_t *saddr)
 	struct xfrm6_tunnel_spi *x6spi;
 	int index;
=20
-	if (xfrm6_tn->spi < XFRM6_TUNNEL_SPI_MIN ||
-	    xfrm6_tn->spi >=3D XFRM6_TUNNEL_SPI_MAX)
+	if ((xfrm6_tn->spi < XFRM6_TUNNEL_SPI_MIN ||
+	    xfrm6_tn->spi >=3D XFRM6_TUNNEL_SPI_MAX) &&
+		xfrm6_tn->spi_byspi)
 		xfrm6_tn->spi =3D XFRM6_TUNNEL_SPI_MIN;
 	else
 		xfrm6_tn->spi++;
--=20
2.20.1


--lhvcifgdqsnv7n3m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIF+jd5Z5uS7xKTfpQZdt+T1HgiEFAl8cKYAACgkQQZdt+T1H
giGjqgwAoMpTtsLtWp+AVfaoxVREC1SZSGjIBGIS8wZBDWGMloEL2ojsd7IOnqEB
L10Kvn/Q9kva0FAiblXgQamlj1lcPvaozuMB7bnxgjXAmzopRcBmUOXmKKRPTmoz
rjWNu5OP9FNxHSG6Ko1zgnnZZhMr/YpBR4QB/iaPgeKrXHd6KmgWYSJwk/05zOJ6
yvWGcXjFEl/O6ov94MNzklAEbu++GC0CdMjC01Io2ZEGaNGfJnQHwQAgoHobIA/R
muRmX9OV80YP6of81866hzA/2AOaVutjscoehIZpov8yabjpCOQp4gs4rdw1oyX+
qLS+C5425f7+VyqVNKqhdRHFP/tdRtrvEGOM51E66jYD8Yl9/mZDC0mT6fXGL1iG
DmqfGYz0a5GEb57WBezOIlEGRPxZ3TC7vupV/xcCwHj8rC74tBpS9DR6/gj/WG6Q
oRbvDUPh4h4o0jrlmfgDDPUEo33YUOR3pk6QG4SLmAq8gFxnuj+GDCMSiNA/YJND
fEsMPbMy
=To8M
-----END PGP SIGNATURE-----

--lhvcifgdqsnv7n3m--
