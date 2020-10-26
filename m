Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C973C298FCB
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781943AbgJZOsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:48:01 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35516 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781923AbgJZOsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 10:48:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8825820573;
        Mon, 26 Oct 2020 15:47:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QeRxRbhz9O5j; Mon, 26 Oct 2020 15:47:59 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0C88620569;
        Mon, 26 Oct 2020 15:47:59 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 26 Oct 2020 15:47:58 +0100
Received: from [172.18.3.9] (172.18.3.9) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 26 Oct
 2020 15:47:58 +0100
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <borisp@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <kuba@kernel.org>
From:   Christian Langrock <christian.langrock@secunet.com>
Subject: Subject: [PATCH net] drivers: net: mlx5: Fix *_ipsec_offload_ok():
 Use, ip_hdr family
Autocrypt: addr=christian.langrock@secunet.com; prefer-encrypt=mutual;
 keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IEdudVBHIHYy
 CgptUUVOQkZlZTdqa0JDQUNrZU1JdXpadS9LQkExcTNrS0dyN2Q5aWlaR0Y1SXBKbklFOWRN
 aUszdWF6N3VNMjZWClNUSlZwNmpkR3VTR0dHbWI4MU9TTEVjSUVJc1lLWHZqYmxBS1VYMUE3
 NHQzV01SY2t5M013SmJtTjZBa044UWwKUDQ1bURkZHRQUmYxRWxCMlMzMmk5T3JFa3Z3OHhj
 dkhZUHdiYUhlblhpYzQvOGZIV0VoK3Z0ZC81LzVURFRJVQovYWc5dFFmUGVhMTNpeFhOMFB1
 Y2NNdWJGZVVNcHdGQ2czMjQrWjE5aUd2ZkRXV1ptUVFHbEJqYzNRNnowaFhPCmIvZGVXTC8r
 bFBTNHQrdFRncG1tWk80WGtJcysxOEtxeENWdWtDYm5xVjB5KzA0c2ozRzFHUS9EbEd2Wkh4
 d3kKd0JjZUFMN0J2bWRlWFFLQVMwS1JMNXpyZ2hJQkNnblV5dXREQUJFQkFBRzBNME5vY21s
 emRHbGhiaUJNWVc1bgpjbTlqYXlBOFkyaHlhWE4wYVdGdUxteGhibWR5YjJOclFITmxZM1Z1
 WlhRdVkyOXRQb2tCTndRVEFRZ0FJUVVDClY1N3VPUUliQXdVTENRZ0hBZ1lWQ0FrS0N3SUVG
 Z0lEQVFJZUFRSVhnQUFLQ1JDamVNZGZndXRyWHUza0NBQ0kKQng2VUhSZUJ0QmNpTlVQa1Az
 ZlJhR2VTT0FESXJxbDcyVktEOWZhTEFIVHQ2dzhrdnl6YjhDdHBhNzdqc3dKdAoyMWMzNDlt
 RjNtYVBscE50cHN3cUgyN2JUbFhZaE5jWHhjbUhQQ2JOdE4zeUdVeTBVdUlKZkJNWmM4UExx
 aXFZCm9ZNUdLRDN1aW1lVmJEWWpnTmhlYk8yZjFjVXZ3WTJ3VHdYNmIwdGdLVksweFlZVERw
 WEkxLzJNVkdzalhxYWsKN1BRb3FWcTBzRHUwZ0lBQWkxUU8wRmJiNmpJYUhqNkNFTTJocEJU
 Qms4cWJrUHMvTXFZR2RMbDRvWHZrV1RMZAp1UWptNmRNdGp4dkl0NldKV1pRYkxqVGVRSWZj
 MjFsdU5RS0RtZlQ2MjNwVlRQUE1NQWNpV2ZwZHc2M0ZibGZHCmNmQm5BS0NKOEpCajB6OVQ2
 L1BtdVFFTkJGZWU3amtCQ0FEUzdhbUpQYlkyZFdwZUd0RStJOXlMTDUzbFNyaVAKNEw2ckk5
 VW9Fd05NMU9ram5CN3dGbkg4ZG04TjY4SzJPSm9na0h3b1gyT256R2h4SjI4TkhSdUFoKysz
 aElZWQorZ1U0SE1MYVgzb25ESzFvcUFkWWN6aEo3ZjZVQ1BiWWFnaGt6SjZWZy9GRVdwQTh1
 NXZHL0JYNHkrRjMvWTk4Cmw2bXpBWDV3TG1UYXBSd2RmdVJDWFJBNmpsSUhJT3dQM05QS0s0
 UHoyRTd3aXRzaW1WMXVjTjR1WEZpWjM2Q1UKUEFpWFhsRVI5aVBablFVU3lDb2JxSk9KS200
 Qzd3VU5RMW5lZ0NYREJkM0tqU3l6VElhZncvb1lHNFJyV0d1bAppSTJpZy9xVFVDOGNaZEFK
 VE1CalVKUjZ1Z0phek1CMVJnMTdwMkdSRDBBelVPVjJxZHFZRnFRRkFCRUJBQUdKCkFSOEVH
 QUVJQUFrRkFsZWU3amtDR3d3QUNna1FvM2pIWDRMcmExN3Z0UWdBZzJnMEpFWFZUR1QzNkJE
 SmdWakkKVVkxZXZubTFmV3dUUHBjb2tQLzgvYU8ydWJtbHh0V1EyaFY1T1BmTDVuRGRheTJT
 NE5xNWoza3FRcStydlVyTwpSVm12VDRXeFlaTTFmcjJuaWJ1emFVYnNKdHhwaE5wamFocnNF
 Y0xMVHpCVzRDYkhUYUw0WVRUK1pEL0dEZUhvCnhBaDlKZk1rZE1CWEh5V1R1dytRU1AwcHA3
 V3ZOc0Rvc3VrS0Z5UTBydmU5UEgyZHJ5NkEwb0xQN1V4dEF6RUUKUlYyU2UwQnVlWlBRdVZu
 VTZDdmozWlN0SzI4SkRoTWp4SVBrWlBFNWtDVjhRTkY4T3Npd3ltQTNhb1BLZTVCdwowbE9j
 anV1Smt4UmE1YmF6eXV1Ylg5cElJZ1RlR3NlY2dwU2dwZkE5anNFSEtGcW9MdXhVQSs3N1ZR
 NWhTeWRWCmFRPT0KPU82RWEKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <6da2c3ac-ab44-e761-d5f0-97ad5abf589b@secunet.com>
Date:   Mon, 26 Oct 2020 15:47:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="pGpl0WUerYajEawdTlgBDaiQsLIwZUpPK"
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--pGpl0WUerYajEawdTlgBDaiQsLIwZUpPK
Content-Type: multipart/mixed; boundary="bVjC5xRfyUhmtQXfWO3wpjL2mzrrD08mG";
 protected-headers="v1"
From: Christian Langrock <christian.langrock@secunet.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
 borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, kuba@kernel.org
Message-ID: <6da2c3ac-ab44-e761-d5f0-97ad5abf589b@secunet.com>
Subject: Subject: [PATCH net] drivers: net: mlx5: Fix *_ipsec_offload_ok():
 Use, ip_hdr family

--bVjC5xRfyUhmtQXfWO3wpjL2mzrrD08mG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE

Xfrm_dev_offload_ok() is called with the unencrypted SKB. So in case of
interfamily ipsec traffic (IPv4-in-IPv6 and IPv6 in IPv4) the check
assumes the wrong family of the skb (IP family of the state).
With this patch the ip header of the SKB is used to determine the
family.

Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
---
=C2=A0drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3d45341e2216..0bab1ceb745c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -460,7 +460,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
=C2=A0
=C2=A0static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct
xfrm_state *x)
=C2=A0{
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (x->props.family =3D=3D AF_INET)=
 {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ip_hdr(skb)->version =3D=3D 4) =
{
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* Offload with IPv4 options is not supported yet */
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ip_hdr(skb)->ihl > 5)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return fa=
lse;
--=20
2.29.1.1.g2e673356ae

--=20
Dipl.-Inf.(FH) Christian Langrock
Senior Consultant
Network & Client Security
Division Public Authorities
secunet Security Networks AG=20


Phone: +49 201 5454-3833=20
E-Mail: christian.langrock@secunet.com

Ammonstra=C3=9Fe 74=20
01067 Dresden, Germany
www.secunet.com

______________________________________________________________________

Registered at: Kurfuerstenstrasse 58, 45138 Essen, Germany=20
Amtsgericht Essen HRB 13615
Management Board: Dr Rainer Baumgart (CEO), Thomas Pleines=20
Chairman of Supervisory Board: Ralf Wintergerst
______________________________________________________________________



--bVjC5xRfyUhmtQXfWO3wpjL2mzrrD08mG--

--pGpl0WUerYajEawdTlgBDaiQsLIwZUpPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJfluGdAAoJEKN4x1+C62teXMUIAKIV+wDCaNTbAu6KgM+qKYeb
E6NxTYX3JoPRSGwZ+TDxid3863oPKky7VKE2vevdRyqAActuHhn3yn7LJ2ouNvYN
qcpdjnNN20Rv+HhAdlP1YmP/jEb/3Ns6KW1tjCZjPeQ/JbPgu+SR592QnQ3xJ03d
05w2zMGJkBBNlRccz9y45ckE5+IkyMx8dA/eYBQwhNLv0gVdUrmQJvKspAX23LJv
zImycR6Az07gZUv6nBcTqCBYBnVwoEwR46NZdJpVcNCX4vvl8gOVewWFj3EnF+MJ
RSssB0hIt4COP7KlxOC3Dh33/Dc3mhmTDR+8cyKI8erMkYBQn12C/97QIEJaSp0=
=9NZZ
-----END PGP SIGNATURE-----

--pGpl0WUerYajEawdTlgBDaiQsLIwZUpPK--
