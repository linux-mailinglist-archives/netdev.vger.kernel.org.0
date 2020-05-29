Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A74B1E7388
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 05:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391804AbgE2DUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 23:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390172AbgE2DUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 23:20:03 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57EC08C5C6;
        Thu, 28 May 2020 20:20:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Y8vL26C2z9sSp;
        Fri, 29 May 2020 13:19:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590722399;
        bh=t+nJ7CMigvRhcZW8yph8cJ4B5U3R5RJSnHI/9BkCc4A=;
        h=Date:From:To:Cc:Subject:From;
        b=Rd469Ew21SoYjH9RkIdIDMK+dN4xxXZTVn75OBawfoJaxOM0mg8/FYTW/hNG8NySh
         444t3WVVkfr8MsTP+o2EaY2Uf37fWjyj+lVMiM3wNJEd/M8fADiCha1HAnC4SO/k8V
         ArJIhh5LbZRbD/6Oi/r5jml5bOhKoQD9170LyNpwq+rSbjuP/74IznjLT7tNCrnCkq
         /gUUxUbCm15QNlguck0FsDq6+1CVeoJiBH+Sra6V+ffScj8t5+nX+u3BOIrwg0tDqa
         KLpfMirbAPFwfIPxy0SINc+/MzSbaZ7YYdtg+qkmVTRXIjT5m1qbH4ENJ7clkdTN6r
         cfy9wSq8JfHsQ==
Date:   Fri, 29 May 2020 13:19:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: linux-next: manual merge of the net-next tree with the nfsd tree
Message-ID: <20200529131955.26c421db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/76C7r4V_+sloSbzv=9G8_3H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/76C7r4V_+sloSbzv=9G8_3H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/sunrpc/svcsock.c

between commits:

  11bbb0f76e99 ("SUNRPC: Trace a few more generic svc_xprt events")
  998024dee197 ("SUNRPC: Add more svcsock tracepoints")

from the nfsd tree and commits:

  9b115749acb2 ("ipv6: add ip6_sock_set_v6only")
  7d7207c2d570 ("ipv6: add ip6_sock_set_recvpktinfo")

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

diff --cc net/sunrpc/svcsock.c
index 97d2b6f8c791,e7a0037d9b56..000000000000
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@@ -1357,7 -1322,11 +1343,6 @@@ static struct svc_xprt *svc_create_sock
  	struct sockaddr *newsin =3D (struct sockaddr *)&addr;
  	int		newlen;
  	int		family;
- 	int		val;
 -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 -
 -	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
 -			serv->sv_program->pg_name, protocol,
 -			__svc_print_addr(sin, buf, sizeof(buf)));
 =20
  	if (protocol !=3D IPPROTO_UDP && protocol !=3D IPPROTO_TCP) {
  		printk(KERN_WARNING "svc: only UDP and TCP "

--Sig_/76C7r4V_+sloSbzv=9G8_3H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7Qf1sACgkQAVBC80lX
0Gz+0Qf/RNSrsI4JD2GYL6Gm4mJ4jWAe/qOnknPZ9V2AYfKl76IInasqq4tqm5b6
Gtpd6Ni4DH7JTAVRK3qSXcYcJkrYcXtybwz/eGaPyKgt0CVG/P7/fpSdDNNdFW6N
uEdz4AAYmXkMQqzm3t0oQQh7Z9mVhWf0W7BUBkjpvsJB417qQWY3+mKt+XCbm/6e
8OEAZz90iH0Z7ooyLCOc2wlpGWTJ558+SkClaepiVQ37QZ7/bs29iHSGsVg3wwHp
w+EouS7W4EQZgL1CfYcZigW4o90ra+cwVDFK7qZgLZCQIcU8y/F30TMbT+ZWxY6m
ipjoJRSzSGPJT0MvCsH4RWaCy9NYyA==
=K4c4
-----END PGP SIGNATURE-----

--Sig_/76C7r4V_+sloSbzv=9G8_3H--
