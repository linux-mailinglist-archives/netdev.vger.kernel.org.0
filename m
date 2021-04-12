Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8CD35B9B4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 07:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhDLFEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 01:04:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55631 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhDLFEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 01:04:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FJc8y2m09z9sW4;
        Mon, 12 Apr 2021 15:04:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618203860;
        bh=5hVi9qFIM67UmidOl5isHFu5Ch7v3+INwd/WQfgg7KE=;
        h=Date:From:To:Cc:Subject:From;
        b=MsCjWdgS1Q2lYCqsbLIMVaWVev8mO1RCHEsBraXiL8D3r6pRQltyDR8wPmRUnJUCb
         /ks8olLSHcoUrZfApVjRne3mODLYH0rrz8F7RcFL0gZ0g/i8yWL16nDIgXfnEFOBWf
         q//hxW4idGWKfy7iIxkzCnV8FFlwQHNFJXUNhJIF9VLZ6P9jPhbV1UUL0SYI80S/js
         J72GsyLeH+4mTnE00VZGn7rCDWHCkIBdU0RiD5lcyRU0l1xv7Q1teq98q4X3ac/Oqn
         SjD3X4PgteOdYQEEW9PbEljSu9OgUFD00tRKKnCLkcCJE8ZIRsy8hnV8rsS+OwhG3H
         H3kzcOH9NCmBw==
Date:   Mon, 12 Apr 2021 15:04:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210412150416.4465b518@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TXz.GGD74wQdWEOLErXNG9w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TXz.GGD74wQdWEOLErXNG9w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/asm-generic/bug.h:20,
                 from arch/x86/include/asm/bug.h:93,
                 from include/linux/bug.h:5,
                 from include/linux/mmdebug.h:5,
                 from include/linux/gfp.h:5,
                 from include/linux/umh.h:4,
                 from include/linux/kmod.h:9,
                 from net/bridge/netfilter/ebtables.c:14:
net/bridge/netfilter/ebtables.c: In function '__ebt_find_table':
net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no me=
mber named 'tables'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |                                 ^
include/linux/kernel.h:708:26: note: in definition of macro 'container_of'
  708 |  void *__mptr =3D (void *)(ptr);     \
      |                          ^~~
include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
  522 |  list_entry((ptr)->next, type, member)
      |  ^~~~~~~~~~
include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
  628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
      |             ^~~~~~~~~~~~~~~~
net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list_f=
or_each_entry'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |  ^~~~~~~~~~~~~~~~~~~
In file included from <command-line>:
net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no me=
mber named 'tables'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |                                 ^
include/linux/compiler_types.h:300:9: note: in definition of macro '__compi=
letime_assert'
  300 |   if (!(condition))     \
      |         ^~~~~~~~~
include/linux/compiler_types.h:320:2: note: in expansion of macro '_compile=
time_assert'
  320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNT=
ER__)
      |  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_a=
ssert'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
      |  ^~~~~~~~~~~~~~~~
include/linux/kernel.h:709:20: note: in expansion of macro '__same_type'
  709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
      |                    ^~~~~~~~~~~
include/linux/list.h:511:2: note: in expansion of macro 'container_of'
  511 |  container_of(ptr, type, member)
      |  ^~~~~~~~~~~~
include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
  522 |  list_entry((ptr)->next, type, member)
      |  ^~~~~~~~~~
include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
  628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
      |             ^~~~~~~~~~~~~~~~
net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list_f=
or_each_entry'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |  ^~~~~~~~~~~~~~~~~~~
net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no me=
mber named 'tables'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |                                 ^
include/linux/compiler_types.h:300:9: note: in definition of macro '__compi=
letime_assert'
  300 |   if (!(condition))     \
      |         ^~~~~~~~~
include/linux/compiler_types.h:320:2: note: in expansion of macro '_compile=
time_assert'
  320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNT=
ER__)
      |  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_a=
ssert'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
      |  ^~~~~~~~~~~~~~~~
include/linux/kernel.h:710:6: note: in expansion of macro '__same_type'
  710 |     !__same_type(*(ptr), void),   \
      |      ^~~~~~~~~~~
include/linux/list.h:511:2: note: in expansion of macro 'container_of'
  511 |  container_of(ptr, type, member)
      |  ^~~~~~~~~~~~
include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
  522 |  list_entry((ptr)->next, type, member)
      |  ^~~~~~~~~~
include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
  628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
      |             ^~~~~~~~~~~~~~~~
net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list_f=
or_each_entry'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |  ^~~~~~~~~~~~~~~~~~~
In file included from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:51,
                 from include/linux/mmzone.h:8,
                 from include/linux/gfp.h:6,
                 from include/linux/umh.h:4,
                 from include/linux/kmod.h:9,
                 from net/bridge/netfilter/ebtables.c:14:
net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no me=
mber named 'tables'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |                                 ^
include/linux/list.h:619:20: note: in definition of macro 'list_entry_is_he=
ad'
  619 |  (&pos->member =3D=3D (head))
      |                    ^~~~
net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list_f=
or_each_entry'
 1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
      |  ^~~~~~~~~~~~~~~~~~~

Caused by commit

  5b53951cfc85 ("netfilter: ebtables: use net_generic infra")

interacting with commit

  7ee3c61dcd28 ("netfilter: bridge: add pre_exit hooks for ebtable unregist=
ration")

from the netfilter tree.

I have applied the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Apr 2021 14:58:20 +1000
Subject: [PATCH] merger fix for "netfilter: bridge: add pre_exit hooks for
 ebtable unregistration"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/bridge/netfilter/ebtables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtable=
s.c
index bbc46149bbb2..96d789c8d1c7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1241,11 +1241,12 @@ int ebt_register_table(struct net *net, const struc=
t ebt_table *input_table,
=20
 static struct ebt_table *__ebt_find_table(struct net *net, const char *nam=
e)
 {
+	struct ebt_pernet *ebt_net =3D net_generic(net, ebt_pernet_id);
 	struct ebt_table *t;
=20
 	mutex_lock(&ebt_mutex);
=20
-	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
+	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, name) =3D=3D 0) {
 			mutex_unlock(&ebt_mutex);
 			return t;
--=20
2.30.2

--=20
Cheers,
Stephen Rothwell

--Sig_/TXz.GGD74wQdWEOLErXNG9w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBz1NAACgkQAVBC80lX
0GyxUggAhBKyYEuQ89d3efsEPx/d6lWPsQn7a21W0dgasGSS+LJsSCE1kFIDpdZa
dC+O5bvcY5AS4owLVE43+KqLa1bZWlRcgE2DJ/O6zM1BhVFtCZSly3yhDIm+e0GJ
dfNYhYu0+nNHdmtm1sLdVlZiCfSz11FgIwh9EauN8nUwfTYqsXhKKydahubC5nIF
tCDIY8E9XsRXwTDKZU53xdQdz6RWBKp1pUE96+8UBP+I6dMMKUQHm0ZdZls9mRMY
y/77X5cHzwHP0kX2nIpLs8NbYL0awF8SDXuDOcOhSZ3U3IoWouZlClisDCddJek2
CQwMJcUMpvbaTQSR4ZUzpVPQydUDyQ==
=N5HB
-----END PGP SIGNATURE-----

--Sig_/TXz.GGD74wQdWEOLErXNG9w--
