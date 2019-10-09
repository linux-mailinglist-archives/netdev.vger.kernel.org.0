Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF1CD0546
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfJIBf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:35:59 -0400
Received: from mail.disavowed.jp ([45.32.17.113]:57180 "EHLO mail.disavowed.jp"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbfJIBf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 21:35:59 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2019 21:35:57 EDT
Received: from basementcat.disavowed.pw (localhost [IPv6:::1])
        by mail.disavowed.jp (Postfix) with ESMTP id C9053129133;
        Wed,  9 Oct 2019 10:26:26 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=disavowed.jp;
        s=disavowed_jp; t=1570584386;
        bh=jDhbKlgzNR0C7L7LQxaLyDcNYD9G2tDQqT6uGp6uFAk=;
        h=Date:From:To:Cc:Subject;
        b=yH7oqB2RF/3WoQ6XY8Que7vXZl/Fi84AS9uoZq3cTGNojxCWEWGcG6obIMow2VPv4
         A5cMR4QDahR1cn3G7BuSs3XlBKPdlPi9CAcdvYtPGvzwYoBq3XbZtFoshCFlbKkf66
         Tu3XKkbOiC6MDliczQE1VmVLuKXGIuMryWeIASmU=
Date:   Wed, 9 Oct 2019 10:26:30 +0900
From:   Christopher KOBAYASHI <chris@disavowed.jp>
To:     netdev@vger.kernel.org
Cc:     trivial@kernel.org
Subject: [PATCH] net/appletalk: restore success case for atalk_proc_init()
Message-ID: <20191009012630.GA106292@basementcat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: =?utf-8?B?0JLQsNGBINGN0YLQviDQvdC1INC60LA=?=
 =?utf-8?B?0YHQsNC10YLRgdGP?= 
X-PGP-Key: https://www.disavowed.jp/keys/chris.disavowed.jp.asc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit e2bcd8b0ce6ee3410665765db0d44dd8b7e3b348 to
net/appletalk/atalk_proc.c removed the success case, rendering
appletalk.ko inoperable.  This one-liner restores correct operation.

Signed-off-by: Christopher KOBAYASHI <chris@disavowed.jp>
---
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 550c6ca007cc..9c1241292d1d 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
 				     sizeof(struct aarp_iter_state), NULL))
 		goto out;
=20
+	return 0;
+
 out:
 	remove_proc_subtree("atalk", init_net.proc_net);
 	return -ENOMEM;

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEpYIbsm5ySb/UuiW05Aw3+RmcaWQFAl2dN0IACgkQ5Aw3+Rmc
aWSXnA/+NTJ2LBAcxPV24Ts06zZr/IBtVbgweiPQKWFnvH9R41KVkdl8mIDvKE8N
wmdhZO7LVs9fuWV5yy7fWQPhdT7xMUXP02tR81K+RzGHtgHlDvBAGWOldwucfpKZ
OCVBakEkLiJwcHZDDG2hXlu45Ufl8zMrqbb0rYSA3fUMuYvucuOmsXWWJQn1lgsn
+NsltEsV7DF9swYOqMwtP28mp/W3Zbgay91/m9G8HeCvGec8X3Uw81ozKOE1AxSX
r3q1MGu2hpM41GZ1NIYFO8vy5M67p07pjG6XR1i6x0RjrpBJj2l0Ar6lyae2xW8P
DlfYjzp1hTjnjVdTescL07r3EBBWnQpz6nh/ilaIG6HratZ8dUDteyRLsYHY9jUg
Kbzp+WW95AkszKGry3cNkqCSZgCfU1sDrpJIE5M3BQYVDzS0qUUczi6CNo0anBbJ
EiwJnDl2M0iXl5gmrS+AnJsC7d4JktsSuhIWNEGHVgeGQkgARUTqdYoVSmEY8Fxt
Y6aHvQFVNQx1jaNVh0QLfGeJXo2VN9z+b5OXW8DmwP9sKyQXXRYSnG2bGliEj+rE
tITSYJiOCIdgBdgAyWMt2gEmHW4IfvgcsJrUjR5kraAsMfrEcYX2Wn+NQupZPGxw
ZvOzFqu7TQizwu2McCET0CTaUZVdIq6bc7+GetADwi72GceL7tA=
=ic5I
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
