Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7904D6671
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350376AbiCKQhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345690AbiCKQhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:37:17 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18B81BD9AB;
        Fri, 11 Mar 2022 08:36:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFZSw0ofIgCcydLCqjtnIcRjWPd/kG9QutN7yyLkJgWsoX+yY4OQ1RdcSw0oUK/LMoAyA+KisIh79aTbs5QJEiTLj2OTSR3BuboglIeNLhHSgRFqanxrsdLEIcsCCZimWoZi5iLnlXMag2kuH8MaHvBo58Pi7232cKZP3ZJLbY8wm8dmUo9JW/PCUn+ubWd5pDSCALmxxAanHDGYl9s/FqzjAeEniOoGcOzZNIeL9wdRClfY3alDpMD8GN52YfT7cvC8K6YAAEr8cgUXd30vJS/74eUqb8fWM8ziuw+wdS/uSbohnuh3/x1FphYQMQqDoDPXO8HD7rc6ttoNZjdD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00iDXEC1bhpCIcWAf7Xk52Al7zOTBKkrDtEJJQTSD7w=;
 b=Bw803YBOrLsw8VFThwJ33ZaMZJ2lZa0tUy94OuM6iY00bwAC+q2g1uNYC89AXNivUbWryhaTZeE03yNmwlGlghKaIFF6++yqZtm0c9/VaKlTV1he5VB3eXUPofAo9tQ8l2uMS35joOpGGmGs2nXRBVJN9WCGpzwIyJxZjt4RCHDZgYB4yZe8ZoDy065QZkuQ4kfL/bmfqGTMz2BdtBypyLObyutWT0gqOv/8GMCk7RXNBeIgdu5yLTOtjNr3Cnf6bWUkCqxxBu99GM9eqGBQ31vC6Zo15YCxHbty5M7Hxbn/QD4cqx9j+QEZAuPqjH9vllzeCs39WsO13g1OHev5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00iDXEC1bhpCIcWAf7Xk52Al7zOTBKkrDtEJJQTSD7w=;
 b=jJa6qhNZVEARPORlRcu8YAkvwZHKgGC612TyjDi6tLIhZI/Sxe7eYqnLzJiRnR86abGVQNTMq6/j16TAhFs4lBT7dJJBj7fI3YR6EA5B/HWiPa0LTI8m5/iKMR4bAxUgylQGr3Ss/UMQ+hR6uaFYg7dzpVauzAYZ3dPy8G/ON4BRg583UvXxmBhy1KTeNgc2SxRCiwAIAuLTmja5cdsu+X6LIAumcXaihTaQedOXKAtGJO0C4pab0e9ODos0ItfqUaoO0Ju6Mt6LtoXVVWfn9cjXh3Lv4ALBjRiEAa6XOvFoISOMVYedzhZaV/91ZXxYIFjmfdDFWjXAwzSe28FUPg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB3073.namprd12.prod.outlook.com (2603:10b6:408:66::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 16:36:10 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f%6]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 16:36:10 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: RE: [PATCH bpf v3] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Topic: [PATCH bpf v3] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Index: AQHYJ9pCDnVWuEd8LkySywqQH+5pgKy6esCg
Date:   Fri, 11 Mar 2022 16:36:10 +0000
Message-ID: <DM4PR12MB51508BFFCFACA26C79D4AEB9DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220222105156.231344-1-maximmi@nvidia.com>
In-Reply-To: <20220222105156.231344-1-maximmi@nvidia.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d164c31d-686f-4078-aaa4-08da037d4007
x-ms-traffictypediagnostic: BN8PR12MB3073:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3073324FF4CB1E5263EF626ADC0C9@BN8PR12MB3073.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUNac3AnsuG1YUmKha+fxF9yNlSZbjD2MbFwMq/UruJjY3mmeFpwXwDMXZ7KbtNvu8+mmeHsCPFQAT8J90ealmGT845BV1mZ8xkNbtMkPL9IP/GvY83rtXb2Kn13KH+QPe0b86Xjgot1fPGj0hfU2+1AzkI9f+T84gWcs0wiypKD0KbbsKUY4Dz4wc+AVZo+rjLVLZD4gbXNCVi4tbkY6deF65S3S8zXhyD6iHW3mO64ge1d3H8uKWIvhXyKTRSNl6yg1c3Lfa6eKjyXtJ7OkWDX/m9ZtLVBoi4oCdiF6hMpkl9m/pPCKD6F6+z9eR19bjPvmTtH/6ILypqzBAO1+nnHK6k9Cx5McYxoH6i9Qg/a2NV69VLBW7ur/8fxMweczRDv3NnQ2Ef3N858RmfbaI+6ZXontKTzsyiQvO12LI1nPFUOmpT6Fz0iHkf6i4WG7zIZtqQrWdDjOZ3TLlpBvH0TylH3DQVOqWr0C54dx6JIPhBPryzgTDs5/XzRx7Pb8KLWMTZ/H5rGpKBcX+p8J4M8t+57BI0Oz7LPkzJyBCwT0HIhsbJomBvSnkpZr/gZIH76l/UcmwLfMf+fFtOfSCKrTRY6kNcuq3SJP1haAdfZU4MauWtq7SCOJxBvDy3A15j1yRkXyjGlxnhXvyMTRRFij/xxK6ZEabgrcUVSW+WOsbi+VUdbvn+FspYHXQD5DuXLITLnXmh0LI2wNxiINg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(76116006)(54906003)(110136005)(508600001)(9686003)(38100700002)(6506007)(316002)(71200400001)(38070700005)(7416002)(122000001)(64756008)(66446008)(66476007)(5660300002)(26005)(186003)(55016003)(66556008)(66946007)(8676002)(52536014)(33656002)(83380400001)(86362001)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aYgcLdjD5uraY2BWB5ZLUf/fcETZXv06YSouninSBwKKRzOTeRei/1FNfuOl?=
 =?us-ascii?Q?jqJQfa0wnc/AoxD2FFLoXFvR9qwbhk9vUxxxL46cD30Tv8latyBA0u6teZiO?=
 =?us-ascii?Q?ToYhVscvAiAw3rERvF+mhfWj5Iv7XPMtIE4H/j9HUO0qJWFqa3WVTaygJiq7?=
 =?us-ascii?Q?kWwyeYIb1xlaXFHfxtV+f+xdDBOKm7Mre4cxEkO4ckaiHF8y/Jd2hlwf15xm?=
 =?us-ascii?Q?Ij/2X+9iVgS6OlDwLGzmK7hILWp/+QGfcwsqmeljpBKBXaGc3AxvxHTeT1nE?=
 =?us-ascii?Q?0c4dQqY3pIMkjXu0vhgF8zH9iomYAMnoE9dIEUV2jjRzHLcNYmjwcatS14zb?=
 =?us-ascii?Q?VWI6sSr1Lna6Mu1eq903hY5wan1F2nH08zuMg1kbTNSlJMiW4in/ZmdHU7cp?=
 =?us-ascii?Q?QYpdm3Yfooj2Vgon+vAXjUDulS3To6XjtJeyWLS2p2sWbPGKrzACLPnjXQvv?=
 =?us-ascii?Q?i/FbBDJ6jRVxoRc2FXD9PHRdg8FcDJWAqe1afu3NtAEWqH4KiBTYCNmR9RDn?=
 =?us-ascii?Q?CztPormxPzhN2N+riNAn88kIdcekscbSukiUjArVOya4tcerR+TPuRlHRaac?=
 =?us-ascii?Q?39wzl5QDFasq1w2sGDpvC3Z++c0zvxKxC3IX7JcQbQ1eeDifgUG4Ikhyg8zp?=
 =?us-ascii?Q?KW6Rha7zO8ddCiSGVxoa5Mt8lurGNkILuDSjF/1/8QZXUVdQyBQU4GsLfBGi?=
 =?us-ascii?Q?B7aXlTQ8cgSA/yQVZZNpGMvxDakrOcfPqxhSKf3r8bpqdXxASaq98/OWFjqL?=
 =?us-ascii?Q?m6cnl1/Od6emk3m0uXDgN21sMAozM8/wtvqwqqaLBmzC8+2TY03zVQrN/RQd?=
 =?us-ascii?Q?LQXjL3VE483hsXtEZ+dJh4e9wHA6yhFVbvrRI9aE8BM7czqkoRwBxcYiGI8p?=
 =?us-ascii?Q?Qjuqwgakz64r4pliEiWbIOvvf2Qo+fJZytOmGcv2ubE9TgD9kcfwFkgnGCtu?=
 =?us-ascii?Q?SpHINfVqznlVseEhW0o41JLYBGuH22NB57BV0Z5bN2YFDqjyfP8bxmKtQrEj?=
 =?us-ascii?Q?3kM+iYAgY7jNq06z49ss6W5Ib/CT0NN62PADS7TKG3QGohtXhdWJ3z/KyfVX?=
 =?us-ascii?Q?EjEsVtFMRsIEmcbrPemdmek9HZlU+qU/Q5EMl1dq3xPmSsz01mxVnXa7fZuk?=
 =?us-ascii?Q?zIFqV0YeHVRCakmE9+ygq97J61/51jSUmDh5UB9KwnxF6Wf5Y9uKKpyOVx8I?=
 =?us-ascii?Q?L0V31xG2OngyIq6ae1oRmNJXGrOWDJM3rUtbpvnwElRwcQjYbupnB7XuopwM?=
 =?us-ascii?Q?mlqrDPjaHbhit9qtr6IVtEHYpPSJ5ihh2y+toijmC5BUIBjUWlYfO+d1NNgO?=
 =?us-ascii?Q?7Umpj8tzGo0K7LOO+kOTCEtFp+vaIrJAJwib4ctZvlSDvDC77kSpzGuBUKaR?=
 =?us-ascii?Q?3fX+8ObtTNFkPTNWKkFTqkY2ZdQRXPghF7GES+QROQE3nriaaeBsNasXfVjp?=
 =?us-ascii?Q?MJRJJB+zrOWzoaFxUaHwEzlik9brqOHA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d164c31d-686f-4078-aaa4-08da037d4007
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 16:36:10.5605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dj3Rbq4F91caFCEvsSLOmIMl/I9842JxhLRYy4KpnxnX8dxylgmS7zP+tBme4sG0pln1fl9rnR589Et8svZgeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3073
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch was submitted more than two weeks ago, and there were no new
comments. Can it be accepted?

> -----Original Message-----
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> Sent: 22 February, 2022 12:52
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
> v3 changes: Added a selftest.
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9eb785842258..d1914c5c171c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6777,24 +6777,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *=
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

