Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1165D4EDAFC
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiCaN76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbiCaN74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:59:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8D1217945;
        Thu, 31 Mar 2022 06:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gY1zMwxro6mbaKEjMG0DDxTlJFq+OJEhJI4P+rPB87PqrSkCkh4AsUK25H47iZTR//YuTlolWUMa4AemcAH5T+w8nMNXcBR9N6fAsfMSioaH3itVjtdYjxPKJtPWIf9Ys8qbtf6kiXArYHYaHRpF9HQou5dp6rOsftfoBdG/hJznc4Gi3MV5SqcvOm+IOpXiW0z/xHBxkTAwBpfprGfKbG88j2cyPFDXZkJLoCtAPrOR1BFoE6moYfmZOgEwGkokIPTJbPdBI+gq75gYXYjYkFoVeLqPMAhTdJhponf9CfOv+Z4knTSnCVa4zV9hBp2zHYKcSYJQqiBnLnHjdYVDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9H+JFloXMIDm2qgTuTmCrzUFFj81+0H6Nj5bXGhRA8=;
 b=TASqA4F7IbOYiE4YAc2nKhVpzt6PiMfZCd/muY6lcOYwCXkDLHr4gyjRYH9zyDIV7gKU/AjqcGcubKilcBbDUwjVgDFLrrLC8I1NTCYkA9ppkoAaNjQjWYpuMIRySDwUkK7DJ7xK3Q29DJKRZbRXSFEK3wJRR1iWD2nHUgsTui6HOJOT4DI7YzXxrv4l+z8ijsqycjmGPzw+vA4BiJ3W99CZrZSnODowGGljiTZF+jeVxXIdYeCYDARegfKeMs8NaVFV6QStPJ2/uKnjky1tQTIh+F3l6qENb+QMMr5DesQMgMOR6zgx6lTYU/O71++F70QrmwFSdpJ8t96iW7cFsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9H+JFloXMIDm2qgTuTmCrzUFFj81+0H6Nj5bXGhRA8=;
 b=RrFC7hLxxYS4NSnbXX1wMHBxKWOBYkdo+Lehp2osQVnZlzQTsX1grPAWXxeoKIrHnHgIVVdWlzCtWgB7r8HysOvrq/qL2wBQR2EJL9SgqsRoTqM617cmbkjTcH34Dj8k7Kfp7V+lUEuCzO86Kj3uCMpDvOKpUBl6qOZr4p0CAeZhwjN8n4K6AmfVLpZK6mIa3CO6HfkwaEw+FWje3F/tswu3WvQg4EIBmrMgUA+x+U4NM3a2bAnAKL/wuAmcdO85ePgE5IiWtamfePr+MFLm9vyH70jwrvzz5T7ETpedH1ijfMMNwo1q9SZ6Nqt53RvaqXQP9zAjM2078Li83msnww==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 13:58:06 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f%8]) with mapi id 15.20.5123.023; Thu, 31 Mar 2022
 13:58:06 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Arthur Fabre <afabre@cloudflare.com>
CC:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH bpf v4] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Topic: [PATCH bpf v4] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Index: AQHYQ3Euk6HGugX2SUWPkZPK+3Dq/KzZh0tA
Date:   Thu, 31 Mar 2022 13:58:06 +0000
Message-ID: <DM4PR12MB515029CA094EB7BE80D423F6DCE19@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220329133001.2283509-1-maximmi@nvidia.com>
In-Reply-To: <20220329133001.2283509-1-maximmi@nvidia.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af05a730-48ad-433d-8061-08da131e7b5e
x-ms-traffictypediagnostic: BL1PR12MB5191:EE_
x-microsoft-antispam-prvs: <BL1PR12MB51910F05AF1D5EDFA1A33580DCE19@BL1PR12MB5191.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kywlj4oYnqAFSvMguL/HOkBreVuUxpjDTFS38yX1ZnRb2DaqyIqdTpX/2z65zQjybakStWkxcoOmHeAae1msEGpfHuCo9mKxaug+XzOuutk+s+xe6A45H7n0OwbSU8CiI/KFmcp9sHlyVq4aNUWHAl9X1HWK5YYs3J+n1TEZ8wPThMbBv2Cp88/R4+ZTTkBmZVBVKfkiNWVeT2F9wGKaex5FSMJ9CAZGkaxawm2t855ZxOMD1vAcwAf+N8vraHrGxWR/J1ge6W2Rsl0ZAGY/87JIESEjEACmkyy7N93Fp4e7zD233kxjsx66OVUsQLhWfnGz5n8aveBg/V3Rt3ftkOSCnwRwJdrkR6GRlYoOj7rlTEvGMsJQDrS9fq3FaNYx35xIOmDr1B6PvYsAGgDjXk4HSj/TXga/xPa9H722B9bHbDR3We7kqKIiFqSQGLAnu8vZa4I/q5rctKU2JC8EPH/0o1G2XCLrMQ0RwsOAMltyuGaMlBBfJdtTyYFBLhJZFFFP9gPEgNumMwN2XNqfD7G9IwmspJkY3O7vHd5MUAvbO2abFaD2XfYY4SJ//6W82qvsraKPEkLmYtPrbcFGs+tKIVw4GIYHrdtenWg8C0CZIOoCb1sWCE3KVbzH6MB3HYPf9trqs9YmBovnJZljl+JOqgOeDIoEsHSoA/3jzQou8qI/JRdjlzBM+DWW7+Hb56nTH1h1u3TBzmpMlU+6tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(7416002)(316002)(110136005)(26005)(54906003)(66476007)(66556008)(38100700002)(5660300002)(86362001)(52536014)(8676002)(186003)(4326008)(66446008)(64756008)(122000001)(83380400001)(2906002)(9686003)(76116006)(508600001)(71200400001)(6506007)(7696005)(66946007)(107886003)(38070700005)(55016003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iGzokRNsSGcfZ2x804HtJ0aPMVcG6nsMYEqnMFQpj5DhbM27mRSryOrADjVU?=
 =?us-ascii?Q?iSr7YRBt/+zP9vsJH5Id6+Y3QhIf9ADa3nvkYvIxr0Q7REdqQ4IxmynVg37z?=
 =?us-ascii?Q?Iu9vZfCRAbVngKZm1dxW+V/sqmpFUu2LAfME8xp8SoUmFpbmA7AMKT5EyZCh?=
 =?us-ascii?Q?KpEY0DIPVgqqi9nWPBkX6PUlLSnHvzIAkf6Wx+4eY7AXT71iJM3y0nrjACls?=
 =?us-ascii?Q?avAt74TA8LoFDAvJ7wY52CppEcmHvo/YHSIp51Q2W47wKzgjwfB/A2UBo3bK?=
 =?us-ascii?Q?lMVSnix+6gZB+J393blGPF/xTlF1GdFUUzbmFUluu2RpQmcDtzgPeoxEYwXQ?=
 =?us-ascii?Q?eX0M3UvCxn1rlLmJ3uc9EHqfXY3kSboDut3jOhYO0juhpomWLcyoVkMAzZqF?=
 =?us-ascii?Q?Dk5Vw0K/m9wk7Rj1+hjjRHp4E6f435781TtIFXK1S2rw5sBetU9O+fWUyWzF?=
 =?us-ascii?Q?gtC9dRNVYUxVfHT0OCgYD6yuqkhMUUwawGHUrRGbK/k0o/sF/qxtM/JpIuT0?=
 =?us-ascii?Q?NkN5rgOERVR3EPVKti6/11RqVLmKkMII0EShgz1njHWQFqbSF3v72bpb+uWK?=
 =?us-ascii?Q?OOhLpSYzeLlNmaupWYmFdLb5pVh6NFD8mnNSilIJBtFOqN6m1Bg2gyjMM5tn?=
 =?us-ascii?Q?4grc/7dWNHKmznprTYWBLOvLA5aOzaXeLJF3UvTWBa9LPZs7/8ZpBfVM04GV?=
 =?us-ascii?Q?rDJ1b3o+xifbTQe0WTdK34vexn/MokQoO+JpHqii5l2mVDhEFjCqoFLOrjpR?=
 =?us-ascii?Q?tSfpHDTXjii02nJTbOlDGuqIbJa0pBeymmcDplE8Rte7OXvJ2Pn+cSbq4v4d?=
 =?us-ascii?Q?fsyD/PESqtWq0hgYMfJyzLqzz5nc/72CwQjZ3zVSzlvLgxevCcUYjR1V22Rp?=
 =?us-ascii?Q?3Yk9kU21UCZb04DXP352xOoPIltwY0g9Rc7QyTwp0UJ3RV9j1fwIua037/KG?=
 =?us-ascii?Q?vEc0/EK0daCTjtzJrVMVB85qIAEvt9o0O+PfVYocOXt6Q+iBHCmj5CQJQ1dV?=
 =?us-ascii?Q?DHGd0KsheGLClbO9XQDV+vJqi+8Z/JpIzf+Tx8DwcECdBRVwOY+wEA4puS/Q?=
 =?us-ascii?Q?IS5SzXlhDbgUqbKSZ9aWEQw+2nY6d8veLZilZOapootnj235enIdhW2nsUMp?=
 =?us-ascii?Q?wvWJMl/yJnK5MOnz8f0wiIO3BOuepZxvO3bJFvi0J7CPJ9EJlhakGZWDk9v7?=
 =?us-ascii?Q?s6lLwDQ6+1jbenMYO6Xz7yswjEJZ2f2VIGrqS8td4jLFC4rfIIl+o/m6t1ag?=
 =?us-ascii?Q?qLeJKVS5rRXi5jizIIRxOzjbcJ/59k7E5WsCCtO8CFyB2TYSY14WQEJQTMyu?=
 =?us-ascii?Q?C9u4um9GnzScOUDEoXdC2My1oLH2jevn8//EtTQ5PB8D/UoC86ovRaWQv6ur?=
 =?us-ascii?Q?44locDEzsZl35JRmzucxJayl+XP5bGohANXktyRLRiKLZYb402XSVNc8bnzv?=
 =?us-ascii?Q?rjtxDr+V/y0pbHJnLWKW1YwNJNI4hCGF9p9qjnK/nXic/a6/sjZ1Ta8Be6sg?=
 =?us-ascii?Q?4Dn57m/MTcOtq1dr/FBFDlQ4n9xP7dc+Sa2tv1Cv+SWW7eaeKnOdU77b25Nl?=
 =?us-ascii?Q?KltlW/6BM4Lcl7kfUOoszkYO/PDFejAkHbROlh1S8uvpFcGm8Jt49o+Th7zC?=
 =?us-ascii?Q?7LdW7J9wZLPs+bFDRSgkpVSINQ+WrIY87EYTOtDm/VqITUetp5vKKgGCPgC9?=
 =?us-ascii?Q?2aBWPxEHLB6fvIrCpdPAoPsNE83Ipgd8WCTHs3FMO2l23j1AzyeGeIldfuwE?=
 =?us-ascii?Q?3HalFdIGvw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af05a730-48ad-433d-8061-08da131e7b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 13:58:06.4834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RzrWolbXL858AHdaZsIkAymyLIZandAw0CWvYSJxdS4I5KyD8RW9HHBJPYXNVOAqDoXbzPCjw6WiXcceKRIm/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, Arthur, could you review and ACK the patch?

> -----Original Message-----
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
>=20
> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
> validates the address family of the socket. It supports IPv4 packets in
> AF_INET6 dual-stack sockets.
>=20
> On the other hand, bpf_tcp_check_syncookie looks only at the address
> family of the socket, ignoring the real IP version in headers, and
> validates only the packet size. This implementation has some drawbacks:
>=20
> 1. Packets are not validated properly, allowing a BPF program to trick
>    bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
>    socket.
>=20
> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>    up receiving a SYNACK with the cookie, but the following ACK gets
>    dropped.
>=20
> This patch fixes these issues by changing the checks in
> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
> version from the header is taken into account, and it is validated
> properly with address family.
>=20
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c                             | 17 +++-
>  .../bpf/test_tcp_check_syncookie_user.c       | 78 ++++++++++++++-----
>  2 files changed, 72 insertions(+), 23 deletions(-)
>=20
> v2 changes: moved from bpf-next to bpf.
>=20
> v3 changes: added a selftest.
>=20
> v4 changes: none, CCed Jakub and Arthur from Cloudflare.
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a7044e98765e..64470a727ef7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7016,24 +7016,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *=
,
> sk, void *, iph, u32, iph_len
>  	if (!th->ack || th->rst || th->syn)
>  		return -ENOENT;
>=20
> +	if (unlikely(iph_len < sizeof(struct iphdr)))
> +		return -EINVAL;
> +
>  	if (tcp_synq_no_recent_overflow(sk))
>  		return -ENOENT;
>=20
>  	cookie =3D ntohl(th->ack_seq) - 1;
>=20
> -	switch (sk->sk_family) {
> -	case AF_INET:
> -		if (unlikely(iph_len < sizeof(struct iphdr)))
> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> +	 * same offset so we can cast to the shorter header (struct iphdr).
> +	 */
> +	switch (((struct iphdr *)iph)->version) {
> +	case 4:
> +		if (sk->sk_family =3D=3D AF_INET6 && ipv6_only_sock(sk))
>  			return -EINVAL;
>=20
>  		ret =3D __cookie_v4_check((struct iphdr *)iph, th, cookie);
>  		break;
>=20
>  #if IS_BUILTIN(CONFIG_IPV6)
> -	case AF_INET6:
> +	case 6:
>  		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
>  			return -EINVAL;
>=20
> +		if (sk->sk_family !=3D AF_INET6)
> +			return -EINVAL;
> +
>  		ret =3D __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
>  		break;
>  #endif /* CONFIG_IPV6 */
> diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> index b9e991d43155..e7775d3bbe08 100644
> --- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> +++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> @@ -18,8 +18,9 @@
>  #include "bpf_rlimit.h"
>  #include "cgroup_helpers.h"
>=20
> -static int start_server(const struct sockaddr *addr, socklen_t len)
> +static int start_server(const struct sockaddr *addr, socklen_t len, bool
> dual)
>  {
> +	int mode =3D !dual;
>  	int fd;
>=20
>  	fd =3D socket(addr->sa_family, SOCK_STREAM, 0);
> @@ -28,6 +29,14 @@ static int start_server(const struct sockaddr *addr,
> socklen_t len)
>  		goto out;
>  	}
>=20
> +	if (addr->sa_family =3D=3D AF_INET6) {
> +		if (setsockopt(fd, IPPROTO_IPV6, IPV6_V6ONLY, (char *)&mode,
> +			       sizeof(mode)) =3D=3D -1) {
> +			log_err("Failed to set the dual-stack mode");
> +			goto close_out;
> +		}
> +	}
> +
>  	if (bind(fd, addr, len) =3D=3D -1) {
>  		log_err("Failed to bind server socket");
>  		goto close_out;
> @@ -47,24 +56,17 @@ static int start_server(const struct sockaddr *addr,
> socklen_t len)
>  	return fd;
>  }
>=20
> -static int connect_to_server(int server_fd)
> +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
>  {
> -	struct sockaddr_storage addr;
> -	socklen_t len =3D sizeof(addr);
>  	int fd =3D -1;
>=20
> -	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> -		log_err("Failed to get server addr");
> -		goto out;
> -	}
> -
> -	fd =3D socket(addr.ss_family, SOCK_STREAM, 0);
> +	fd =3D socket(addr->sa_family, SOCK_STREAM, 0);
>  	if (fd =3D=3D -1) {
>  		log_err("Failed to create client socket");
>  		goto out;
>  	}
>=20
> -	if (connect(fd, (const struct sockaddr *)&addr, len) =3D=3D -1) {
> +	if (connect(fd, (const struct sockaddr *)addr, len) =3D=3D -1) {
>  		log_err("Fail to connect to server");
>  		goto close_out;
>  	}
> @@ -116,7 +118,8 @@ static int get_map_fd_by_prog_id(int prog_id, bool *x=
dp)
>  	return map_fd;
>  }
>=20
> -static int run_test(int server_fd, int results_fd, bool xdp)
> +static int run_test(int server_fd, int results_fd, bool xdp,
> +		    const struct sockaddr *addr, socklen_t len)
>  {
>  	int client =3D -1, srv_client =3D -1;
>  	int ret =3D 0;
> @@ -142,7 +145,7 @@ static int run_test(int server_fd, int results_fd, bo=
ol
> xdp)
>  		goto err;
>  	}
>=20
> -	client =3D connect_to_server(server_fd);
> +	client =3D connect_to_server(addr, len);
>  	if (client =3D=3D -1)
>  		goto err;
>=20
> @@ -199,12 +202,30 @@ static int run_test(int server_fd, int results_fd,
> bool xdp)
>  	return ret;
>  }
>=20
> +static bool get_port(int server_fd, in_port_t *port)
> +{
> +	struct sockaddr_in addr;
> +	socklen_t len =3D sizeof(addr);
> +
> +	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> +		log_err("Failed to get server addr");
> +		return false;
> +	}
> +
> +	/* sin_port and sin6_port are located at the same offset. */
> +	*port =3D addr.sin_port;
> +	return true;
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct sockaddr_in addr4;
>  	struct sockaddr_in6 addr6;
> +	struct sockaddr_in addr4dual;
> +	struct sockaddr_in6 addr6dual;
>  	int server =3D -1;
>  	int server_v6 =3D -1;
> +	int server_dual =3D -1;
>  	int results =3D -1;
>  	int err =3D 0;
>  	bool xdp;
> @@ -224,25 +245,43 @@ int main(int argc, char **argv)
>  	addr4.sin_family =3D AF_INET;
>  	addr4.sin_addr.s_addr =3D htonl(INADDR_LOOPBACK);
>  	addr4.sin_port =3D 0;
> +	memcpy(&addr4dual, &addr4, sizeof(addr4dual));
>=20
>  	memset(&addr6, 0, sizeof(addr6));
>  	addr6.sin6_family =3D AF_INET6;
>  	addr6.sin6_addr =3D in6addr_loopback;
>  	addr6.sin6_port =3D 0;
>=20
> -	server =3D start_server((const struct sockaddr *)&addr4, sizeof(addr4))=
;
> -	if (server =3D=3D -1)
> +	memset(&addr6dual, 0, sizeof(addr6dual));
> +	addr6dual.sin6_family =3D AF_INET6;
> +	addr6dual.sin6_addr =3D in6addr_any;
> +	addr6dual.sin6_port =3D 0;
> +
> +	server =3D start_server((const struct sockaddr *)&addr4, sizeof(addr4),
> +			      false);
> +	if (server =3D=3D -1 || !get_port(server, &addr4.sin_port))
>  		goto err;
>=20
>  	server_v6 =3D start_server((const struct sockaddr *)&addr6,
> -				 sizeof(addr6));
> -	if (server_v6 =3D=3D -1)
> +				 sizeof(addr6), false);
> +	if (server_v6 =3D=3D -1 || !get_port(server_v6, &addr6.sin6_port))
> +		goto err;
> +
> +	server_dual =3D start_server((const struct sockaddr *)&addr6dual,
> +				   sizeof(addr6dual), true);
> +	if (server_dual =3D=3D -1 || !get_port(server_dual, &addr4dual.sin_port=
))
> +		goto err;
> +
> +	if (run_test(server, results, xdp,
> +		     (const struct sockaddr *)&addr4, sizeof(addr4)))
>  		goto err;
>=20
> -	if (run_test(server, results, xdp))
> +	if (run_test(server_v6, results, xdp,
> +		     (const struct sockaddr *)&addr6, sizeof(addr6)))
>  		goto err;
>=20
> -	if (run_test(server_v6, results, xdp))
> +	if (run_test(server_dual, results, xdp,
> +		     (const struct sockaddr *)&addr4dual, sizeof(addr4dual)))
>  		goto err;
>=20
>  	printf("ok\n");
> @@ -252,6 +291,7 @@ int main(int argc, char **argv)
>  out:
>  	close(server);
>  	close(server_v6);
> +	close(server_dual);
>  	close(results);
>  	return err;
>  }
> --
> 2.30.2

