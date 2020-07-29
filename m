Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FBC231D57
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgG2L10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:27:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57065 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgG2L1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 07:27:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BGrqb1j6jz9sRK;
        Wed, 29 Jul 2020 21:27:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596022043;
        bh=3B1l9zsxDWHUUR26XQYf02znLLnavQzwvvwX89Hy1rc=;
        h=Date:From:To:Cc:Subject:From;
        b=NNfs3ifhLeqzO8x99kAQO0VXMYlyV1DmDUm5+wk0NzTwPx7k/FB1ctwECY+eswCj2
         t/aNGzL7o75rnrbQVSjvt54Fl7Xm2KFbhDWngcpzehBOFifAgOr1evu4zhkItlYPJn
         mDnGC8rJwJnDNawRr5yydtPQtfgv1cTEkrcUVzMtIKdEvl6XvjjtBFbgQ9FHl4o3Di
         5LNfRj3dyArcwPZzMgOOY1ITfp2a+4e0OrNl69ECFdNmOc3y+37dWf5wQrJnJ61etf
         aRHr8HxvX20hCDWSkjrQiFV0Op514bWKsySbsaEyFzk5AOUCOh8N7Dsfr+RS9DgnNG
         VYw7YrC4Uxu7w==
Date:   Wed, 29 Jul 2020 21:27:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200729212721.1ee4eef8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/w/x_VlSZc+ml8x648uLVh5w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/w/x_VlSZc+ml8x648uLVh5w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (i386 defconfig)
failed like this:

x86_64-linux-gnu-ld: net/core/fib_rules.o: in function `fib_rules_lookup':
fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to `fib=
6_rule_match'
x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to `fib=
6_rule_action'
x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to `fib=
6_rule_action'
x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to `fib=
6_rule_suppress'
x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to `fib=
6_rule_suppress'

Caused by commit

  b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rul=
es_ops")

# CONFIG_IPV6_MULTIPLE_TABLES is not set

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/w/x_VlSZc+ml8x648uLVh5w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8hXRkACgkQAVBC80lX
0Gwl4wf/a7UQAOA7rptHNQF+m0JcGAIWdcRBnTPxuMhF7/scEaGuBmLDeHvp6xU7
Noe09vWdXZmm0nszSz56b1FUg7VBMMw71UeY4Dbm9FdR6cwA1mqlSjNza75d1txp
Kl+8x4OEPTHf8CNr614LQxBE+ZaEzpGlx4Fp9wQKxvWQ/t/Mnc+fsm0BB2tmuJ47
ubn7/l6mCCAdp569m7lWF0gliY8GwGTGYcBOF6ib9/j/sNVnwyw5EdCnNfVaSrwI
C5YYEg28M8VwSwz9mA8nkJ/CrbafsY7f+6mhMPRJjm5PSTS/6bfzMU2xQRY8SHS5
GVB4TOHGqEkkH1Y1bPLCxR8vXuRqgQ==
=qzAe
-----END PGP SIGNATURE-----

--Sig_/w/x_VlSZc+ml8x648uLVh5w--
