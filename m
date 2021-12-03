Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F12466E5F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhLCASx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhLCASu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:18:50 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03275C06174A;
        Thu,  2 Dec 2021 16:15:19 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J4td20mpMz4xZ4;
        Fri,  3 Dec 2021 11:15:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638490518;
        bh=MpVMBw9H1sDbcQJnxKdIN+V8pRD1fEVLC6dEr0fpgAA=;
        h=Date:From:To:Cc:Subject:From;
        b=TPm2o3ayYQVJASgIPbu63tca+bJK+dxorLNRNccIbOcXAJPKW64wEgv/5eIwImhm9
         Vne3Ho61th5BJpbV1z+wM2ah4dNeMYay7Mt5YGr9Xsn+CDxBku0zmTL+QB/m6b2w8C
         6hubdg25vvXIDzU+EJt2suAUeXVRpsANJ+vn00n4Bngx745HSRPTMGAci0/h+3jZ7P
         IzrGBxIukoluaUiyomNXMKdgc7HHtotxLbQHt0G4qqEbaJTqSExvqwCQNNzuc25KbL
         y412XMudpf4VgM0wY9gjr+iQH70qUmqSpn6PPEaV3/eVyj0oiLRhgNz6VH1niSyUmN
         P5r1whRd1wBSg==
Date:   Fri, 3 Dec 2021 11:15:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20211203111516.3f22aa95@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KmNnKRBrIaMX/2EzgPiwUoA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KmNnKRBrIaMX/2EzgPiwUoA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (native perf)
failed like this:

tests/bpf.c: In function 'check_env':
tests/bpf.c:299:2: error: 'bpf_load_program' is deprecated: libbpf v0.7+: u=
se bpf_prog_load() instead [-Werror=3Ddeprecated-declarations]
  299 |  err =3D bpf_load_program(BPF_PROG_TYPE_KPROBE, insns,
      |  ^~~
In file included from tests/bpf.c:28:
tools/lib/bpf/bpf.h:204:16: note: declared here
  204 | LIBBPF_API int bpf_load_program(enum bpf_prog_type type,
      |                ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
util/bpf-loader.c: In function 'bpf__clear':
util/bpf-loader.c:115:2: error: 'bpf_object__next' is deprecated: libbpf v0=
.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-de=
clarations]
  115 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:115:2: error: 'bpf_object__next' is deprecated: libbpf v0=
.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-de=
clarations]
  115 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:115:2: error: 'bpf_object__next' is deprecated: libbpf v0=
.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-de=
clarations]
  115 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c: In function 'hook_load_preprocessor':
util/bpf-loader.c:621:2: error: 'bpf_program__set_prep' is deprecated: libb=
pf v0.7+: use bpf_program__insns() for getting bpf_program instructions [-W=
error=3Ddeprecated-declarations]
  621 |  err =3D bpf_program__set_prep(prog, priv->nr_types,
      |  ^~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:467:16: note: declared here
  467 | LIBBPF_API int bpf_program__set_prep(struct bpf_program *prog, int =
nr_instance,
      |                ^~~~~~~~~~~~~~~~~~~~~
util/bpf-loader.c: In function 'bpf__foreach_event':
util/bpf-loader.c:776:5: error: 'bpf_program__nth_fd' is deprecated: libbpf=
 v0.7+: multi-instance bpf_program support is deprecated [-Werror=3Ddepreca=
ted-declarations]
  776 |     fd =3D bpf_program__nth_fd(prog, type);
      |     ^~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:471:16: note: declared here
  471 | LIBBPF_API int bpf_program__nth_fd(const struct bpf_program *prog, =
int n);
      |                ^~~~~~~~~~~~~~~~~~~
util/bpf-loader.c: In function 'bpf__apply_obj_config':
util/bpf-loader.c:1501:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1501 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1501:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1501 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1501:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1501 |  bpf_object__for_each_safe(obj, tmp) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c: In function 'bpf__setup_output_event':
util/bpf-loader.c:1529:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1529 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1529:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1529 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1529:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1529 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1565:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1565 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1565:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1565 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
util/bpf-loader.c:1565:2: error: 'bpf_object__next' is deprecated: libbpf v=
0.7+: track bpf_objects in application code instead [-Werror=3Ddeprecated-d=
eclarations]
 1565 |  bpf__for_each_map_named(map, obj, tmp, name) {
      |  ^~~~~~~~~~~~~~~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:176:20: note: declared here
  176 | struct bpf_object *bpf_object__next(struct bpf_object *prev);
      |                    ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

I am not sure what caused this, but I have just used the bpf-next tree
from next-20211202 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/KmNnKRBrIaMX/2EzgPiwUoA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGpYZQACgkQAVBC80lX
0GxT1AgAn37c09ci5LxrwKVewgxdKFgU66BwND4c8dUpMZ7enT6IrmmK2wfSyOdL
9DFZXM8NPGbfDxUN3b5JhRg3zvcTEDx7edHY3du7NDZ5Pion5cduvkenpmwcf5QK
VTH+Y6KLI4Y/yInJ+biDjhBzEujo2ZK24vO1NguyDkKjEyhxjx855GABp8CkeRT9
h4cAZ3qMwWcRMWRac3RFbgry1Ai8P3yqVGAlF0QBG33cWt0OgpjehrgTga33eR1+
b99STtlHMDZj9C1OJHaTZplqyMjmvcrxNChf82sS/wlrHEuQHmVHH7iK/ZhryI68
aZTx9YELDNlVmQBre5l4lzC8uNytWQ==
=RZbd
-----END PGP SIGNATURE-----

--Sig_/KmNnKRBrIaMX/2EzgPiwUoA--
