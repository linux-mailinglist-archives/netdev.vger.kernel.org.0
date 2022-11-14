Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096B26273C6
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 01:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiKNAOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 19:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbiKNAN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 19:13:58 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F32646F;
        Sun, 13 Nov 2022 16:13:54 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9VCg6MJbz4xZZ;
        Mon, 14 Nov 2022 11:13:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668384833;
        bh=Kq3rIqNnjTbwPvCVfeypwzk4t2Zo4Bj/jWddcEHyC34=;
        h=Date:From:To:Cc:Subject:From;
        b=dytkC7GtwvdEy7lcHhAt2+okb23UtIJSC8juNJqUTbk9eopjiFJhOVxxgnjhVPZGh
         Z62t+DTXIiY2FUc2uBbcEaWPou8L1fpOJUkWtae6IkQ5CDtS6S7mGnMpd682zfksKP
         yndO+6t6tzR3gRu7rycm3oQMbdOyPR/3QgmqRrybOt3K1KO6VKM4kmhnJaFkGRf/in
         Ok9JSDuIXCaWKRKNUKyCCwfmptE+F87ZddZlyTZ+1ZEQW+Cznv5H/UOFZmssTe/mAW
         cEE9fvCaWbxDfUGGvYuKQ0dNjYvIUwftOqBXDLvu7DdAMYJ3kwn1NgMh0B5byMwveV
         Tc76WLThzH/hw==
Date:   Mon, 14 Nov 2022 11:13:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the modules tree
Message-ID: <20221114111350.38e44eec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_EbMjKLCXVnmEIU8KzwD3Tz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_EbMjKLCXVnmEIU8KzwD3Tz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the modules tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/trace/ftrace.c: In function 'ftrace_lookup_symbols':
kernel/trace/ftrace.c:8316:52: error: passing argument 1 of 'module_kallsym=
s_on_each_symbol' from incompatible pointer type [-Werror=3Dincompatible-po=
inter-types]
 8316 |         found_all =3D module_kallsyms_on_each_symbol(kallsyms_callb=
ack, &args);
      |                                                    ^~~~~~~~~~~~~~~~~
      |                                                    |
      |                                                    int (*)(void *, =
const char *, long unsigned int)
In file included from include/linux/device/driver.h:21,
                 from include/linux/device.h:32,
                 from include/linux/node.h:18,
                 from include/linux/cpu.h:17,
                 from include/linux/stop_machine.h:5,
                 from kernel/trace/ftrace.c:17:
include/linux/module.h:882:48: note: expected 'const char *' but argument i=
s of type 'int (*)(void *, const char *, long unsigned int)'
  882 | int module_kallsyms_on_each_symbol(const char *modname,
      |                                    ~~~~~~~~~~~~^~~~~~~
kernel/trace/ftrace.c:8316:71: error: passing argument 2 of 'module_kallsym=
s_on_each_symbol' from incompatible pointer type [-Werror=3Dincompatible-po=
inter-types]
 8316 |         found_all =3D module_kallsyms_on_each_symbol(kallsyms_callb=
ack, &args);
      |                                                                    =
   ^~~~~
      |                                                                    =
   |
      |                                                                    =
   struct kallsyms_data *
include/linux/module.h:883:42: note: expected 'int (*)(void *, const char *=
, long unsigned int)' but argument is of type 'struct kallsyms_data *'
  883 |                                    int (*fn)(void *, const char *, =
unsigned long),
      |                                    ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
kernel/trace/ftrace.c:8316:21: error: too few arguments to function 'module=
_kallsyms_on_each_symbol'
 8316 |         found_all =3D module_kallsyms_on_each_symbol(kallsyms_callb=
ack, &args);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/module.h:882:5: note: declared here
  882 | int module_kallsyms_on_each_symbol(const char *modname,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  90de88426f3c ("livepatch: Improve the search performance of module_kallsy=
ms_on_each_symbol()")

from the modules tree interatcing with commit

  3640bf8584f4 ("ftrace: Add support to resolve module symbols in ftrace_lo=
okup_symbols")

from the next-next tree.

I have no idea how to easily fix this up, so I have used the modules
tree from next-20221111 for today in the hope someone will send me a fix.

--=20
Cheers,
Stephen Rothwell

--Sig_/_EbMjKLCXVnmEIU8KzwD3Tz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNxiD4ACgkQAVBC80lX
0Gz4RQgAitUafx9IDvg9FoBe4sa2DKcAmBAllc6mvMMRiK8sZLDF71xWQDvDsU1B
sgN73SCbrAcYrb21XgSbbRgrqk3cTJaKePJZgXjbCtF97/5fFuSqus2L3l33l9jn
zYPFFJIWe4S+L6GEGn+1hSz6I9bL5tTFGm/wQyBR5I+bYIht9VVzJrj1v6pRXrw/
UH+J1jP3LsuApt5NDo8afC9+6zzhb4A4Xwi09LuJ+9Ls+FAf6M2DWSrwfEuL8zkw
9OXeVxgnwoxx2D1asdzuLchfZ5/kFMRy67GwwhxNoM7Y1ZX8IDXmmOsr3K/MEq+8
q5Ezj/0waDN+BsvjH8JbNeOUhz5+pQ==
=gwjH
-----END PGP SIGNATURE-----

--Sig_/_EbMjKLCXVnmEIU8KzwD3Tz--
