Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6432E27761
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfEWHrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:47:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44160 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWHrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:47:36 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hTiRn-0002m4-KK; Thu, 23 May 2019 07:47:31 +0000
Subject: Re: [PATCH AUTOSEL 5.1 011/375] ip6: fix skb leak in
 ip6frag_expire_frag_queue()
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-11-sashal@kernel.org>
From:   Stefan Bader <stefan.bader@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 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
 a/xox1VK9s1EK3Ny6Pj9DekR+8E=
Message-ID: <1036ddff-720f-ad5b-dbc0-2d4ad4de0392@canonical.com>
Date:   Thu, 23 May 2019 09:47:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522192115.22666-11-sashal@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Pl14T8IkRII9TvaRDjxuDGkWm2zUVG09L"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pl14T8IkRII9TvaRDjxuDGkWm2zUVG09L
Content-Type: multipart/mixed; boundary="cyCQS0NMoFcmXGdt8dMvnwH7K43uqVpVs";
 protected-headers="v1"
From: Stefan Bader <stefan.bader@canonical.com>
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Peter Oskolkov <posk@google.com>,
 Florian Westphal <fw@strlen.de>, "David S . Miller" <davem@davemloft.net>,
 netdev@vger.kernel.org
Message-ID: <1036ddff-720f-ad5b-dbc0-2d4ad4de0392@canonical.com>
Subject: Re: [PATCH AUTOSEL 5.1 011/375] ip6: fix skb leak in
 ip6frag_expire_frag_queue()
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-11-sashal@kernel.org>
In-Reply-To: <20190522192115.22666-11-sashal@kernel.org>

--cyCQS0NMoFcmXGdt8dMvnwH7K43uqVpVs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22.05.19 21:15, Sasha Levin wrote:
> From: Eric Dumazet <edumazet@google.com>
>=20
> [ Upstream commit 47d3d7fdb10a21c223036b58bd70ffdc24a472c4 ]
>=20
> Since ip6frag_expire_frag_queue() now pulls the head skb
> from frag queue, we should no longer use skb_get(), since
> this leads to an skb leak.
>=20
> Stefan Bader initially reported a problem in 4.4.stable [1] caused
> by the skb_get(), so this patch should also fix this issue.

Just to let everybody know, while changing this has fixed the BUG_ON prob=
lem
while sending (in 4.4) it now crashes when releasing just a little later.=

Still feels like the right direction but not complete, yet.

-Stefan

>=20
> 296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/s=
kbuff.c:1207!
> [296583.091734] Call Trace:
> [296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
> [296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
> [296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
> [296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
> [296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
> [296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
> [296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32=
/0xa0
> [296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 =
[ixgbe]
> [296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_de=
frag_ipv6]
> [296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
> [296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
> [296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_=
defrag_ipv6]
> [296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
> [296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_de=
frag_ipv6]
> [296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
> [296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
>=20
> Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Cc: Peter Oskolkov <posk@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/net/ipv6_frag.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
> index 28aa9b30aecea..1f77fb4dc79df 100644
> --- a/include/net/ipv6_frag.h
> +++ b/include/net/ipv6_frag.h
> @@ -94,7 +94,6 @@ ip6frag_expire_frag_queue(struct net *net, struct fra=
g_queue *fq)
>  		goto out;
> =20
>  	head->dev =3D dev;
> -	skb_get(head);
>  	spin_unlock(&fq->q.lock);
> =20
>  	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
>=20



--cyCQS0NMoFcmXGdt8dMvnwH7K43uqVpVs--

--Pl14T8IkRII9TvaRDjxuDGkWm2zUVG09L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAlzmUBIACgkQ6Gdd7svu
zqOTDxAAqMbqpiEUxfxOpEYQki0NMBmVcPFQfvrQyL6vfsoSzTzC/EGScuptkMiO
tKtKqvT3lJR7gvIihq3pOwl67gHgrObLvtS1YHXhSZCCTTiT3FPzQUWzw3foAp9M
AgM8lJHxwNl9fu9Gvn9tkSc/7E4fpJb/+Z4WQK3iAwGGbv9l6G4Kn4faj4r9Al7s
BJ3dXJ6e3MozzZUQM8mFbY72uQAC8FaJdWypFkrqkF5qqbSBkIAvyD+dZQrAq9QA
7IF813yws3AlqNEKcYYz4ts5r+LdPpFbgg6l8oXySPwnxtWNQgluuVDOemf2hIoF
7Bdn8p1bukyjZkQtJVqCIJ50fRtSBA4qOg1pxS40zpJYk7/8ONod/yHgbYKdmFeH
VmzfGKMpTY0THSLvxNx3CkBt+yVRG5ojTnyJ7CzvdK11SWtRGrg2rxk5l7VzNUlB
keU8yG4PfmXsqCKm25Qi/swMDx7xvQg4xId2xX0I27j4J19IH43O5+SwiFO/GmnC
hHWj35tcugmtiistT4EAY6vv6pPPOKP+whhWKN4SengPobm9CunnvjyDvwPADT3O
JfCrDVm+kGmfyRujBLnDwe7uM+S6Uj+mNMjM2TVddtid0COXoRmnH2WdEw9X55oM
K728soTURX5BUZHg3pMvejitsurJtCJuH3ZsE+jttE+NYXrBRJU=
=fsqn
-----END PGP SIGNATURE-----

--Pl14T8IkRII9TvaRDjxuDGkWm2zUVG09L--
