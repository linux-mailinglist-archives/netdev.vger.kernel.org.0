Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A558D6C836B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjCXReF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCXReE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:34:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E72CC65D
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:34:03 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pflIW-00082Y-4h; Fri, 24 Mar 2023 18:33:52 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AB03E19BAC0;
        Fri, 24 Mar 2023 17:33:48 +0000 (UTC)
Date:   Fri, 24 Mar 2023 18:33:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ivan Orlov <ivan.orlov0322@gmail.com>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        himadrispandya@gmail.com, skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
Message-ID: <20230324173347.qg2jwis44ssq3ynu@pengutronix.de>
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vlas6f6vayqzkrd6"
Content-Disposition: inline
In-Reply-To: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vlas6f6vayqzkrd6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.03.2023 16:04:45, Ivan Orlov wrote:
> Syzkaller reported the following issue:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in aio_rw_done fs/aio.c:1520 [inline]
> BUG: KMSAN: uninit-value in aio_write+0x899/0x950 fs/aio.c:1600
>  aio_rw_done fs/aio.c:1520 [inline]
>  aio_write+0x899/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>=20
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:766 [inline]
>  slab_alloc_node mm/slub.c:3452 [inline]
>  __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
>  __do_kmalloc_node mm/slab_common.c:967 [inline]
>  __kmalloc+0x11d/0x3b0 mm/slab_common.c:981
>  kmalloc_array include/linux/slab.h:636 [inline]
>  bcm_tx_setup+0x80e/0x29d0 net/can/bcm.c:930
>  bcm_sendmsg+0x3a2/0xce0 net/can/bcm.c:1351
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  sock_write_iter+0x495/0x5e0 net/socket.c:1108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>=20
> CPU: 1 PID: 5034 Comm: syz-executor350 Not tainted 6.2.0-rc6-syzkaller-80=
422-geda666ff2276 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/12/2023
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>=20
> We can follow the call chain and find that 'bcm_tx_setup' function calls =
'memcpy_from_msg'
> to copy some content to the newly allocated frame of 'op->frames'. After =
that the 'len'
> field of copied structure being compared with some constant value (64 or =
8). However, if
> 'memcpy_from_msg' returns an error, we will compare some uninitialized me=
mory. This triggers
> 'uninit-value' issue.
>=20
> This patch will add 'memcpy_from_msg' possible errors processing to avoid=
 uninit-value
> issue.
>=20
> Tested via syzkaller
>=20
> Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=3D47f897f8ad958bbde5790ebf389b=
5e7e0a345089
> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>

Applied to linux-can.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vlas6f6vayqzkrd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQd3vgACgkQvlAcSiqK
BOg64Qf/UaJ/7PhxUZ6s4IwMzefFbXJhXMcR6mc6PCDzjXPbf2VuUA63KA3FNHDu
wUFVX4rUBkcgMG9Y7P+Z6XHcXJGDA020r0o4jqdsbbFCUI9SyxDdX+OgHadnGzlM
IW1vhAwTh8jPm9t1hE4YwKb4dDMoWv+9rme1GEkUkulmIEOntALDwvUQf3Fz3HWC
ZxW/koIGS+sZvMnYmet6kse+8pFbN+awj2t47LG0oS7QwPnk2g9C1HJVNt7FfwU9
uBdYSknJ5JC/cmYRwG7hmdF0lHM4nFpIcDUpu3v3ybSq5kEm1NeAAh/IqbPHsg95
VWOOZI33PSezppaggbGPIjElLfU2kQ==
=DKzR
-----END PGP SIGNATURE-----

--vlas6f6vayqzkrd6--
