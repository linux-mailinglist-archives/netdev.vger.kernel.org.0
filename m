Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7616B3EB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgBXW1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:27:45 -0500
Received: from ozlabs.org ([203.11.71.1]:33343 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbgBXW1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:27:44 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48RGsV4DcHz9sP7;
        Tue, 25 Feb 2020 09:27:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582583262;
        bh=xPvYHtYI0Ar9OJJYLNuvPxm0wk2iyr/Kbk4V2trfZnI=;
        h=Date:From:To:Cc:Subject:From;
        b=shVGkxZ+LGNl5/aV6HWvo0H7GXlQ8KcgB67d4JnLdMUAIaimZFpcrfAY8GAr2AuMe
         MC9lelBHZKF8awq34LeJD2q+hOACk4gCUNB/PCyd51fZbHt+rGrklZjAecrx/6wC3t
         UAXhOl4OBy5AeNJPmyMEwi42OZI/h3K+upSZFX2kwZUop8Lj4VXDyt3f/sQJ1YjTbU
         MbsElSmvxLgShvQmFtgFDxw9oeTHjqQLX4LBmFNwFlF8EQS7M91wHQTvaWl+dxCZ7w
         B5Vd3MuDTwTBQsQpzlB0wuQVeFb6IFMrsav+UAx+rxbpfy8mZbEeT+oS7iAB6drt6x
         WYX5B64bT6tzQ==
Date:   Tue, 25 Feb 2020 09:27:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200225092736.137df206@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6vh+/9WabVSBbtEZ1oB_=hR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6vh+/9WabVSBbtEZ1oB_=hR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/net/bareudp.c: In function 'bareudp_xmit_skb':
drivers/net/bareudp.c:346:9: warning: 'err' may be used uninitialized in th=
is function [-Wmaybe-uninitialized]
  346 |  return err;
      |         ^~~
drivers/net/bareudp.c: In function 'bareudp6_xmit_skb':
drivers/net/bareudp.c:407:9: warning: 'err' may be used uninitialized in th=
is function [-Wmaybe-uninitialized]
  407 |  return err;
      |         ^~~

Introduced by commit

  571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling differ=
ent protocols like MPLS, IP, NSH etc.")

These are not false positives.

--=20
Cheers,
Stephen Rothwell

--Sig_/6vh+/9WabVSBbtEZ1oB_=hR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5UTdgACgkQAVBC80lX
0GyJPQf+KK6g1iCvkKU39Bt46t5/5hYnFG9FQzgRrin8Vycdi+jxLHOJZQpY5BM8
kQPRqt1xmRDlhXfj9w2HxMTf8ooQk4QNgRgECW0Ij+yOpJvA4ecjJiaKvBhzTInx
jmwSp+67igI8GyR15p5JHD21os3zjMY9YvObZ44gyRm/is+Zw9yXngAGeEATnLYK
XDkP7+wUVMPwXBmxBHMXD1B7i6qG6vTaEWj9N+eK/BcngKi/GhGaMNPCXurqW8sP
/YOh5akETPHpxfNQcKfCtMe9D4VSmil08ezeS5TO21pjzQWHewgXcJieyV0s8UZw
Ql7VX7TN+8J3NYhD+Un4YIuHnOs0Qg==
=/ZVr
-----END PGP SIGNATURE-----

--Sig_/6vh+/9WabVSBbtEZ1oB_=hR--
