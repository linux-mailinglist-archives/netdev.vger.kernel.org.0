Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E94678AEE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjAWWoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjAWWoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:44:09 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05571F493;
        Mon, 23 Jan 2023 14:44:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P14sJ5x6qz4xyF;
        Tue, 24 Jan 2023 09:44:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674513845;
        bh=QM4QdgfuJW7UXJbWh+zoZm88/mDrwRvfSuQuw+d9jh4=;
        h=Date:From:To:Cc:Subject:From;
        b=p/JEuT4kBpBASXaN2kEIdkFXaMHpIs9yH6OYFMszJ3lU3n8WUKyDKSHLm8fN9X/o2
         1ydsDtbuQbrYUofoCcaGPfkZ0vlutrCOAat8V8XHe9iV9uXdA2lefHhH4F2sJKH5Xa
         utezgVwreb11HF1LrW2JyvU7x2XKmwlvz5gtZqAlU/OoPsGGM78ovrtQzDc5WUw82c
         WXpCWd9WSmEHBZWsM51FMinHiYsN/My7yGzmxfJdvAsYlJXcIo6DkWFAkBrHWZv//4
         iJeTXZMncesn288eyzo1TgMeh4fDvo7fzWJqH9nlpP7b0o1O6e4DTpgPpWNtCgksSK
         icRboD0szaA3Q==
Date:   Tue, 24 Jan 2023 09:44:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20230124094403.76e0011f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wU/SZ3C0D7Tba.FNsSjjQSl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wU/SZ3C0D7Tba.FNsSjjQSl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  kernel/bpf/offload.c

between commit:

  ef01f4e25c17 ("bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and =
PERF_BPF_EVENT_PROG_UNLOAD")

from Linus' tree and commit:

  89bbc53a4dbb ("bpf: Reshuffle some parts of bpf/offload.c")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/offload.c
index 190d9f9dc987,e87cab2ed710..000000000000
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@@ -75,20 -74,124 +74,121 @@@ bpf_offload_find_netdev(struct net_devi
  	return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
  }
 =20
- int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
+ static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offd=
ev,
+ 					     struct net_device *netdev)
  {
  	struct bpf_offload_netdev *ondev;
- 	struct bpf_prog_offload *offload;
  	int err;
 =20
- 	if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
- 	    attr->prog_type !=3D BPF_PROG_TYPE_XDP)
- 		return -EINVAL;
+ 	ondev =3D kzalloc(sizeof(*ondev), GFP_KERNEL);
+ 	if (!ondev)
+ 		return -ENOMEM;
 =20
- 	if (attr->prog_flags)
- 		return -EINVAL;
+ 	ondev->netdev =3D netdev;
+ 	ondev->offdev =3D offdev;
+ 	INIT_LIST_HEAD(&ondev->progs);
+ 	INIT_LIST_HEAD(&ondev->maps);
+=20
+ 	err =3D rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
+ 	if (err) {
+ 		netdev_warn(netdev, "failed to register for BPF offload\n");
+ 		goto err_free;
+ 	}
+=20
+ 	if (offdev)
+ 		list_add(&ondev->offdev_netdevs, &offdev->netdevs);
+ 	return 0;
+=20
+ err_free:
+ 	kfree(ondev);
+ 	return err;
+ }
+=20
+ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
+ {
+ 	struct bpf_prog_offload *offload =3D prog->aux->offload;
+=20
+ 	if (offload->dev_state)
+ 		offload->offdev->ops->destroy(prog);
+=20
 -	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
 -	bpf_prog_free_id(prog, true);
 -
+ 	list_del_init(&offload->offloads);
+ 	kfree(offload);
+ 	prog->aux->offload =3D NULL;
+ }
+=20
+ static int bpf_map_offload_ndo(struct bpf_offloaded_map *offmap,
+ 			       enum bpf_netdev_command cmd)
+ {
+ 	struct netdev_bpf data =3D {};
+ 	struct net_device *netdev;
+=20
+ 	ASSERT_RTNL();
+=20
+ 	data.command =3D cmd;
+ 	data.offmap =3D offmap;
+ 	/* Caller must make sure netdev is valid */
+ 	netdev =3D offmap->netdev;
+=20
+ 	return netdev->netdev_ops->ndo_bpf(netdev, &data);
+ }
+=20
+ static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
+ {
+ 	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
+ 	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
+ 	bpf_map_free_id(&offmap->map, true);
+ 	list_del_init(&offmap->offloads);
+ 	offmap->netdev =3D NULL;
+ }
+=20
+ static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *o=
ffdev,
+ 						struct net_device *netdev)
+ {
+ 	struct bpf_offload_netdev *ondev, *altdev =3D NULL;
+ 	struct bpf_offloaded_map *offmap, *mtmp;
+ 	struct bpf_prog_offload *offload, *ptmp;
+=20
+ 	ASSERT_RTNL();
+=20
+ 	ondev =3D rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
+ 	if (WARN_ON(!ondev))
+ 		return;
+=20
+ 	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
+=20
+ 	/* Try to move the objects to another netdev of the device */
+ 	if (offdev) {
+ 		list_del(&ondev->offdev_netdevs);
+ 		altdev =3D list_first_entry_or_null(&offdev->netdevs,
+ 						  struct bpf_offload_netdev,
+ 						  offdev_netdevs);
+ 	}
+=20
+ 	if (altdev) {
+ 		list_for_each_entry(offload, &ondev->progs, offloads)
+ 			offload->netdev =3D altdev->netdev;
+ 		list_splice_init(&ondev->progs, &altdev->progs);
+=20
+ 		list_for_each_entry(offmap, &ondev->maps, offloads)
+ 			offmap->netdev =3D altdev->netdev;
+ 		list_splice_init(&ondev->maps, &altdev->maps);
+ 	} else {
+ 		list_for_each_entry_safe(offload, ptmp, &ondev->progs, offloads)
+ 			__bpf_prog_offload_destroy(offload->prog);
+ 		list_for_each_entry_safe(offmap, mtmp, &ondev->maps, offloads)
+ 			__bpf_map_offload_destroy(offmap);
+ 	}
+=20
+ 	WARN_ON(!list_empty(&ondev->progs));
+ 	WARN_ON(!list_empty(&ondev->maps));
+ 	kfree(ondev);
+ }
+=20
+ static int __bpf_prog_dev_bound_init(struct bpf_prog *prog, struct net_de=
vice *netdev)
+ {
+ 	struct bpf_offload_netdev *ondev;
+ 	struct bpf_prog_offload *offload;
+ 	int err;
 =20
  	offload =3D kzalloc(sizeof(*offload), GFP_USER);
  	if (!offload)

--Sig_/wU/SZ3C0D7Tba.FNsSjjQSl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPPDbMACgkQAVBC80lX
0GxwqQf4mJ5cPkCVXH7D/OMIcltw4EyHo/bfrz/QfXnpieqRkn3QkH/h9VFe8GXS
hVvfLP9f9p7sPo1iP1q6OrKWrh/vWy2vL54zffjmnU8KgZAQExYSUp7UBUNDvbUn
0ZckTv//jsdTjD1ocMKrytCxHHL3gUWHqaQIRD5m1ayu77fCn2aL4L6E4fjG3n73
kgTuUgTnD15veQ+M0pRFkbMTb/w8D5J+AHSlFRVXa0iLz/rNraU2T8tMup1ANat6
cVH0GVWccZtUD0MPP57+ycvTHHE5djvtwspJSB6diwsBgRNugSwVjGgqq8QA17x3
Y3kbszRhFn9/ji/pby11ruPs5w/n
=W1wp
-----END PGP SIGNATURE-----

--Sig_/wU/SZ3C0D7Tba.FNsSjjQSl--
