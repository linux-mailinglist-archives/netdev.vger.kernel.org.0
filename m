Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1958766889A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjAMAgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjAMAgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:36:48 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2EE18B3D;
        Thu, 12 Jan 2023 16:36:46 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NtMtN0Yjnz4x1R;
        Fri, 13 Jan 2023 11:36:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1673570204;
        bh=XUQvRQpyDENYtvUFcxm/gNeE046GNGYCUyfJaUM2ajA=;
        h=Date:From:To:Cc:Subject:From;
        b=X7cB0I/NjuUKqTCUwpyDlh3e0x289Q3FuYK6NgKrclCRcAyvahQKGd4oJI7+Yc5r9
         38X/AJKVjUnKsT0KGK2+gnx9k3jnmzy78H7tYw/kXF3tE1QScBtHzmkhPAvDOM1msS
         PASelMadhww48ctLR3cUsAWqC9PHdXW97CfMhCkGAgT/QPA3pz9vXxvOqf1dgmwGDM
         PDtl+jgXat7Zr6yLMpYPM9yqD7ZsG1w6ZYfYk4OrHuodymBecZatXA+0BpnxHkVK+l
         2p/odKAUhdboKpuxjaK7u9KgpddkWzxujWwsPYDco5+gN8mcsqrMKY7FW9WyjDz4k+
         6+OHQCSsKHfWg==
Date:   Fri, 13 Jan 2023 11:36:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230113113339.658c4723@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9qhutx.lCu63yAJj.ZYuH4u";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9qhutx.lCu63yAJj.ZYuH4u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/usb/r8152.c

between commit:

  be53771c87f4 ("r8152: add vendor/device ID pair for Microsoft Devkit")

from the net tree and commit:

  ec51fbd1b8a2 ("r8152: add USB device driver for config selection")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/usb/r8152.c
index 23da1d9dafd1,66e70b5f8417..000000000000
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@@ -9817,40 -9820,31 +9820,32 @@@ static void rtl8152_disconnect(struct u
  /* table of devices that work with this driver */
  static const struct usb_device_id rtl8152_table[] =3D {
  	/* Realtek */
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050),
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8053),
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152),
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153),
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8155),
- 	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8156),
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8050) },
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8053) },
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8152) },
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8153) },
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8155) },
+ 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8156) },
 =20
  	/* Microsoft */
- 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
- 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
- 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
- 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
- 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
- 	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
- 	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
- 	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
+ 	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab) },
+ 	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6) },
+ 	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927) },
++	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e) },
+ 	{ USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x304f) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3054) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x721e) },
+ 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0xa387) },
+ 	{ USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041) },
+ 	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
+ 	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
  	{}
  };
 =20

--Sig_/9qhutx.lCu63yAJj.ZYuH4u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPAp5oACgkQAVBC80lX
0Gwkqwf8CA9D0ibfAJABp7KBzVjqS8Q9fHMcb/29YK3Zdp7eIB26FpeJUcXeCe+y
j3l/OKExix8JMLjJoL1HADdD5bDwfIh9XkJfP3Nqcieg2d97ydDraG0LJzwmFYlf
k/sc0S/lfcaKobwojQK0uQB9013PYRlh37+BO8M6GCZWuXuJRL0uEMNTRodpONiP
zyeDs4BW1WqQKfhrXnDVmuKGkAROu5CJpybIbll1KCG7kMEOgRBbIeERm4vOvGEv
EJusOu+GGoqtXrUE+X+84ZN5z9S1ZANqop/qulhu+Qa7/7OXEMmLvWwtz02nGEq4
X2cydp0oA3punJck/UD19WnZXZVxlg==
=ameD
-----END PGP SIGNATURE-----

--Sig_/9qhutx.lCu63yAJj.ZYuH4u--
