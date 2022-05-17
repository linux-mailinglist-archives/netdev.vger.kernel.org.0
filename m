Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85484529D2F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiEQJDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiEQJDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:03:45 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427B53EF1C;
        Tue, 17 May 2022 02:03:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L2VXQ6sSBz4xLb;
        Tue, 17 May 2022 19:03:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652778216;
        bh=PvHKH9C7qcFJ1DB3vXvZC31uK1pYg4dsP3wXn6Ovzp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P51d5V9sgBiwjmwO1K5WJzcx62IPxOQ2S2JU0qSlIpKdEA/xzGCKUDJcT5skrUPxu
         dBlIMAMxSyfoYUhRgiUV/xvaTsuMf5uqwfXuOzRwel8ulOIbatPs+rWkJ0wHWJYwJG
         kwTVwK2GezuuChZT0WOoRlq8b+BD6GUugcQWNKktls4k2DtNLYzvm69kzO2OOxPNXg
         g5wlSTJFyNqK0DIIGqtv07THAZTdXqP9bYINi6tgRSbcxt426h6Rq6VYJH7rtlEavU
         xldVyJG/9Z/Z6Yce7s3skw8b7qG0hd93ktwzKgA0gyrpGlRoetKuQ/xeYzAQVLPs8P
         UgOS1J4oMjXkQ==
Date:   Tue, 17 May 2022 19:03:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220517190332.4506f7e8@canb.auug.org.au>
In-Reply-To: <20220517110303.723a7148@canb.auug.org.au>
References: <20220517110303.723a7148@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MVHAGlvNapLv1B+3dFq=KEu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MVHAGlvNapLv1B+3dFq=KEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 17 May 2022 11:03:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> net/netfilter/nf_conntrack_netlink.c:1717:12: warning: 'ctnetlink_dump_on=
e_entry' defined but not used [-Wunused-function]
>  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~
>=20
> Introduced by commit
>=20
>   8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list")

So for my i386 defconfig build this became on error, so I have applied
the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 17 May 2022 18:58:43 +1000
Subject: [PATCH] fix up for "netfilter: conntrack: remove unconfirmed list"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index e768f59741a6..722af5e309ba 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1714,6 +1714,7 @@ static int ctnetlink_done_list(struct netlink_callbac=
k *cb)
 	return 0;
 }
=20
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 				    struct netlink_callback *cb,
 				    struct nf_conn *ct,
@@ -1754,6 +1755,7 @@ static int ctnetlink_dump_one_entry(struct sk_buff *s=
kb,
=20
 	return res;
 }
+#endif
=20
 static int
 ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *c=
b)
--=20
2.35.1
--=20
Cheers,
Stephen Rothwell

--Sig_/MVHAGlvNapLv1B+3dFq=KEu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKDZOQACgkQAVBC80lX
0GwWtwf9Gym5VoAzMup2/OcuiIuikDIJdyDG8Nm8Y14zQRJLVgm2fMv8NnqwpTMJ
ojQMTM5JYY/2u+Tn4O1KqetkDN8mmHEtRmG/vpZZqU1QP1E2Ie7zrd+nf74Qa1en
Y4ECWgRK6LY1zSel3VgvSu0gippdWe7F3bmyztCbRkWhmeqg81TLQK6agf+Wzp9Y
6sCzF+f3/Y2BjP9a93ADeqnPtmAVIpWpO1iOzRr9SA4N+MrXsZ+qtb6nCA2vuDn5
3IUd56Jp1jPvPo74trHN1I6V923g0Ahs53afh3Nd1+sAo3lH3NANuFvAVzko1cbO
Cch90NdSTwmN/kSpNPQtltxkVRjT0Q==
=fni1
-----END PGP SIGNATURE-----

--Sig_/MVHAGlvNapLv1B+3dFq=KEu--
