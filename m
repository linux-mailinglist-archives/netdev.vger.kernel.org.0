Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35035305D7
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 02:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEaAfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 20:35:14 -0400
Received: from ozlabs.org ([203.11.71.1]:50461 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfEaAfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 20:35:13 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45FQT93dDjz9sB8;
        Fri, 31 May 2019 10:35:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559262910;
        bh=vmnfdHJwUM1HVyyOa3wxblirRR6+i4b48iUJQ32CBwU=;
        h=Date:From:To:Cc:Subject:From;
        b=jCIWjKq7ClNbTCzgsp5WvhuwAyqifAx8V/KS4CYaQWuRQMhYRbIIxOhzKN6MX3KQt
         EOUoncS8GkvmphMmA2RplWMKzqOZh8E27lMmdbU0y1UOwdWVdOVwoRyOTH2oW9yN/r
         VwImk8CTrD3IoD7SomPdJPrn9uC5GZpolfI1YJKY7oApHtC3Tlpi740gUMCQ3yotBy
         KfZqSHvHd2ntrOIJOnEO2Ui/VXFOXtZESsbs7m0RKjCbPsRiT+u5OEowGzLina0do9
         cC73G4hwfnHhMbjyZ5ci2gjekdxMbzDza6fqbKjLcvRBQzMaQ+icqMTeaT4uWCD2D0
         IB/p5lhfcF7kA==
Date:   Fri, 31 May 2019 10:35:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190531103508.1bfc06db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/W.Z4eGjR4oT3n1RNXpkMYJa"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/W.Z4eGjR4oT3n1RNXpkMYJa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from net/netfilter/utils.c:5:
include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of functi=
on 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=3Dimplicit-f=
unction-declaration]
  return nf_ct_frag6_gather(net, skb, user);
         ^~~~~~~~~~~~~~~~~~
         nf_ct_attach

Caused by commit

  764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")

CONFIG_IPV6 is not set for this build.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/W.Z4eGjR4oT3n1RNXpkMYJa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzwdrwACgkQAVBC80lX
0GymwQf/d4wXf91KoGIB7ydQiSpx7yRSRdw2moG9XUV0oidKP3RZF17p9wOjQXp7
kGWuPdykRUIsJNNVzWUfQXRSKaYthcMVG3bJRoj/63GQLKfKR7rhocfihPMPc2uI
YATaDoHCz1fAy5hOgOLY4fkpuW3Pynuo8eRMhcUVsHs0Dkw/r1iPRQ7Bc8vCYOod
SUflPO3jWNMiKPd4965BkDQDMBPz75B/d9UbXSKtA9esqFW5J7VET7y27zVXPc2n
DhM8j93WERysFLRJpn3ns9ZqLi0JBBSmdn3Kn7Xg8ORP7Ul4uynPA3gDWsn3EyMJ
f0bnj9l4G7XN14FXVFzULgih62VUeA==
=a/FF
-----END PGP SIGNATURE-----

--Sig_/W.Z4eGjR4oT3n1RNXpkMYJa--
