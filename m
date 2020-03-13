Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640EF184424
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCMJyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:54:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57499 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgCMJyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 05:54:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48f1Ht6Vddz9sRN;
        Fri, 13 Mar 2020 20:54:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1584093260;
        bh=F5IlTkk39IWDGQXRHNm9wo5PIlgf3hecyR/kHVYijRo=;
        h=Date:From:To:Cc:Subject:From;
        b=T3nJ0/V8OTTViHqS0mLFA9PYluXBlprdrRZjsFRq7yG6mkjXeQS20NxUw5MC7R+fL
         C7JKgiD+UF2Egc7f58QFaGXKoUR4j9d5h0ZRpivIIrXMBjKhAwSLg3DGKpGxiG/23+
         imLYgV/sf4HTG3uraT/qPTY9Z3c2+gGGpQ+hXIa0WVkyZzLgSQFQ7J05pnJsmkI7w3
         7EvDn8pBte+cBbr8I1McqvXXntjv+TrS6RWUfCKnw7HfNvNx+n4jT9RghsfsZfNmag
         vlbQnz+HJPlgPPS9hjPiGxhwGfkvNcdTCx73+tTenElvrBu5xilr/S+NSSa8vroij8
         5q763xQ4laBLA==
Date:   Fri, 13 Mar 2020 20:54:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Bersenev <bay@hackerdom.ru>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200313205415.021b7875@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3KNBiHufKXAROnO8L5EJBeW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3KNBiHufKXAROnO8L5EJBeW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

In file included from include/linux/byteorder/big_endian.h:5,
                 from arch/powerpc/include/uapi/asm/byteorder.h:14,
                 from include/asm-generic/bitops/le.h:6,
                 from arch/powerpc/include/asm/bitops.h:250,
                 from include/linux/bitops.h:29,
                 from include/linux/kernel.h:12,
                 from include/linux/list.h:9,
                 from include/linux/module.h:12,
                 from drivers/net/usb/cdc_ncm.c:41:
drivers/net/usb/cdc_ncm.c: In function 'cdc_ncm_ndp32':
include/uapi/linux/byteorder/big_endian.h:33:26: warning: conversion from '=
unsigned int' to '__le16' {aka 'short unsigned int'} changes value from '40=
2653184' to '0' [-Woverflow]
   33 | #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
      |                          ^
include/linux/byteorder/generic.h:88:21: note: in expansion of macro '__cpu=
_to_le32'
   88 | #define cpu_to_le32 __cpu_to_le32
      |                     ^~~~~~~~~~~~~
drivers/net/usb/cdc_ncm.c:1175:19: note: in expansion of macro 'cpu_to_le32'
 1175 |  ndp32->wLength =3D cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + =
sizeof(struct usb_cdc_ncm_dpe32));
      |                   ^~~~~~~~~~~

Introduced by commit

  0fa81b304a79 ("cdc_ncm: Implement the 32-bit version of NCM Transfer Bloc=
k")

--=20
Cheers,
Stephen Rothwell

--Sig_/3KNBiHufKXAROnO8L5EJBeW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5rWEcACgkQAVBC80lX
0GzATAf+JG6bIEFdkQXTzmfqkIiSFrbGZKNZgOnrKWxp9PIWUhk/fVl3L1ikJwD9
yYfw303c1qBkdBaHolIdVk5hpWhXO4L9TspaIukZ7sGCS6pE/LItUpnz+iaEPq01
XGrZt1hjTbiGsebrhUV99zSowk4JJuGAu5aL6fiqYG7ShjRwrrpmAcCTeSW/ZevN
PRbvOidkpc+S7KIBNprE7Wd9fp031mIsTTIMx22mq445vS+lJUP1aZox4s5x8NHL
kay2z8m+dgB+LiOYgh4PyI4bsdeZTRs312yrJ1IMqv7jR4GsYAQx+cAvO+ZszxvY
aJSJE4egr1eWxNmwM4Mcquxj3Tuixw==
=K044
-----END PGP SIGNATURE-----

--Sig_/3KNBiHufKXAROnO8L5EJBeW--
