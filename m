Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC5922DB81
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 05:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgGZDJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 23:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgGZDJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 23:09:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07044C0619D4
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 20:09:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w126so7108814pfw.8
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 20:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=R0ZxfaIvZuIP7a1P2/lt5jKuwjtMwv891RsIp0cEjuk=;
        b=rxaWSunmOVR9KUxor0J3CuXVy11wDPBb9COsCp2anVFsbqvhMab+tbKxQtoeV/BHj/
         RUMsFPEGMaS9HmXQ2ah6B3fJYuQvn0HtKAQjsFpgLeIh2Ea/7anqOo9krwcref0J000f
         P8+rquRUpYz8Z6N67wcvq993BssxinmHyUXkgqokMfekp8SZQD9WPqOs/hKzW8A33YAk
         Jsn96CbvqDVqcN2OcxsBhLRfKwolmXHlnSVt1GY4ViZhR43HXnQbiUqlj7rkX1WLueXa
         qd6QJWz28xwnMFulgd9qWIcU0gaV//pUm4vHpFSgPjV0+62jU6aztovmkuPbqWvjwB2w
         8qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=R0ZxfaIvZuIP7a1P2/lt5jKuwjtMwv891RsIp0cEjuk=;
        b=c7IGFtAn7Sbg/yvugmQds1NT8h++No82QjIpv6awKjtu0pOTOqiEKTusM77gcHdPuv
         CcDrGRIStU02o3sxN9fJPBjo38OwhXwd4HoC6AMG6GU3aSrc44bmJ8m9VnndY3N5v9oB
         1hgPALMAxcBLX6XVIlZcXc68L+UD5aCAv3S9MIO2Zi1/5cHzRBftg0QaMWhmc7Y4obHo
         lI4OO0OL/J1PQODxN/IXQMxgQNaWHJfDz/BjlFGVXPh8arFylnpBxFF5rZdkKUxv+580
         hrIzAl7HzCTc1Q9ix8vtALY9+GTeCDsineQFstCVZA2/8qkXqBRqOEsdDjHsrtVma1Lr
         M0kQ==
X-Gm-Message-State: AOAM530FEEjptwd/ue+yTNGWHLeaz5qvp9+msPxPPcNhkQBmpH8K+tEF
        PJNyEVT3++3lwYWfcrejqJtgqQ==
X-Google-Smtp-Source: ABdhPJw47bQqM5H/L9zsOkyKQDH/bNbImoIEGpbxgofA+CdFbbUO8EFqxIpX41rM1ROtd/IIOGaHOQ==
X-Received: by 2002:a62:7644:: with SMTP id r65mr1446478pfc.271.1595732942287;
        Sat, 25 Jul 2020 20:09:02 -0700 (PDT)
Received: from localhost ([2406:7400:73:2b8a:d1f0:826d:1814:b78e])
        by smtp.gmail.com with ESMTPSA id n15sm10272926pjf.12.2020.07.25.20.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:09:01 -0700 (PDT)
Date:   Sun, 26 Jul 2020 08:38:55 +0530
From:   B K Karthik <bkkarthik@pesu.pes.edu>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2] net: ipv6: fix use-after-free Read in
 __xfrm6_tunnel_spi_lookup
Message-ID: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qbdxh6mq23batifp"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qbdxh6mq23batifp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

__xfrm_tunnel_spi_check used xfrm6_tunnel_spi_has_byspi
which returns spi % XFRM6_TUNNEL_SPI_BYSPI_HSIZE.
whereas xfrm6_tunnel_spi_hash_byaddr makes a call to
ipv6_addr_hash.

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv=
6/xfrm6_tunnel.c:79
Read of size 8 at addr ffff8880934578a8 by task syz-executor437/6811
CPU: 0 PID: 6811 Comm: syz-executor437 Not tainted 5.8.0-rc5-next-20200715-=
syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
 xfrm6_tunnel_spi_lookup+0x8a/0x1d0 net/ipv6/xfrm6_tunnel.c:95
 xfrmi6_rcv_tunnel+0xb9/0x100 net/xfrm/xfrm_interface.c:824
 tunnel6_rcv+0xef/0x2b0 net/ipv6/tunnel6.c:148
 ip6_protocol_deliver_rcu+0x2e8/0x1670 net/ipv6/ip6_input.c:433
 ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
 dst_input include/net/dst.h:449 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
 netif_receive_skb_internal net/core/dev.c:5503 [inline]
 netif_receive_skb+0x159/0x990 net/core/dev.c:5562
 tun_rx_batched.isra.0+0x460/0x720 drivers/net/tun.c:1518
 tun_get_user+0x23b2/0x35b0 drivers/net/tun.c:1972
 tun_chr_write_iter+0xba/0x151 drivers/net/tun.c:2001
 call_write_iter include/linux/fs.h:1879 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:515
 vfs_write+0x59d/0x6b0 fs/read_write.c:595
 ksys_write+0x12d/0x250 fs/read_write.c:648
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x403d50
Code: Bad RIP value.
RSP: 002b:00007ffe8fe93368 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000403d50
RDX: 000000000000005e RSI: 00000000200007c0 RDI: 00000000000000f0
RBP: 00007ffe8fe93390 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe8fe93380
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Allocated by task 6811:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3655 [inline]
 __kmalloc+0x1a8/0x320 mm/slab.c:3664
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 tomoyo_init_log+0x1335/0x1e50 security/tomoyo/audit.c:275
 tomoyo_supervisor+0x32f/0xeb0 security/tomoyo/common.c:2097
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x3ed/0x4d0 security/tomoyo/file.c:734
 security_file_ioctl+0x50/0xb0 security/security.c:1489
 ksys_ioctl+0x50/0x180 fs/ioctl.c:747
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
Freed by task 6811:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3756
 tomoyo_supervisor+0x350/0xeb0 security/tomoyo/common.c:2149
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x3ed/0x4d0 security/tomoyo/file.c:734
 security_file_ioctl+0x50/0xb0 security/security.c:1489
 ksys_ioctl+0x50/0x180 fs/ioctl.c:747
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
The buggy address belongs to the object at ffff888093457800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 168 bytes inside of
 512-byte region [ffff888093457800, ffff888093457a00)
The buggy address belongs to the page:
page:000000005c2b5911 refcount:1 mapcount:0 mapping:0000000000000000 index:=
0x0 pfn:0x93457
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028d4308 ffffea0002834c88 ffff8880aa000600
raw: 0000000000000000 ffff888093457000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff888093457780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888093457800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888093457880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888093457900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888093457980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Reported-and-tested-by: syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.c=
om
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
---

v1 -> v2:
	added cast in arguement from u32 to (const xfrm_address_t *)
	added Reported-by: kernel test robot <lkp@intel.com>
	removed Reported-by: syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com
	added Reported-and-tested-by: syzbot+72ff2fa98097767b5a27@syzkaller.appspo=
tmail.com

 net/ipv6/xfrm6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fab..a0e18be2145f 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, =
u32 spi)
 {
 	struct xfrm6_tunnel_net *xfrm6_tn =3D xfrm6_tunnel_pernet(net);
 	struct xfrm6_tunnel_spi *x6spi;
-	int index =3D xfrm6_tunnel_spi_hash_byspi(spi);
+	int index =3D xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
=20
 	hlist_for_each_entry(x6spi,
-			     &xfrm6_tn->spi_byspi[index],
+			     &xfrm6_tn->spi_byaddr[index],
 			     list_byspi) {
 		if (x6spi->spi =3D=3D spi)
 			return -1;
--=20
2.20.1


--qbdxh6mq23batifp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIF+jd5Z5uS7xKTfpQZdt+T1HgiEFAl8c88YACgkQQZdt+T1H
giGTFQv+IbR1CT2BfRT6jfttxhaZyRrMmrPv3xx28tudyisbX4jTEvv8cXoYyibW
g+J6N1EOV+jZo9t0jv3NtRbfAhgiXfaGtp/yWB+fMszVwuFKL4W9De8dV5Hq/sKI
2DrYIr60GgZrxGwaslUVpB7iucqSglUMtOAz5exWLYkjVlLDUe5AqP5/PAXuYYO3
Ly7Kjt2GwgTOChgd9v0TIIoiLyOn5Jo3EmoDFySR60ZQHc67vw/O8FnvVUAUcB0R
IqK89+o1+YVcgfhN3apdIDFwEeD9EtN0j9V60I68J7fnQisYHWnkK3Bht/dwS+7P
ubdKitleq28UtXydrKhBxgiJXH8dE7gIRgDom5eRF4nzF3g9Dh3RVI/sjgn2Ja6r
0UI82Ni0PAaDm5St6FGIbR6k+ifW720++NQ/DqZUjRCe9ETsg0FqrQENKGgsZxR5
//lZPrZPBD8lZEY+UmSUbJXdCXjLN17ocKE5MpgUwbfSkyXcD/di0eUUeQ0YARic
W3FkGYCY
=lcMy
-----END PGP SIGNATURE-----

--qbdxh6mq23batifp--
