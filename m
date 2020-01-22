Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF3145D2F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAVUgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:36:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbgAVUgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:36:31 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MKa5SA016501;
        Wed, 22 Jan 2020 12:36:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RAGT54VHtmM/8jKHkUBjipZp2j+toX1pqGorQ6epoGo=;
 b=mCMdZlyMHcu6lEP8X4Km1ewJpl8Ir0XLxZ5okI+W4lLPtHI/MOJGbD/1FjhWYSNSwb7Y
 zyrm/znm+T/r1JczBPZm55lmfXjAi16GGCP4vYF6DHC1B1510+aiOwb/X1HJ/xyaaGaD
 Vk6H3uCjiJnLL3G2QGLT21cyHOUIT25YZHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xp7375spt-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 12:36:14 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 12:35:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGYF1+tUYzEObOZISsMoZgkOIKXrFHEfVPPdo8yiL+e8ma6kk9+6CYhuGmlc6YYOLRoajhcga9D/tS8Vpo+WCZmEbaEcYFqn6qjMaiOvkHfSAB0B3caF70u1LcErGJ0ruOBOd+MuVKyzjCSxisYLqdUpblmtjJRArxS5bqe38byIaeYQb8K0qgJBiLkMZf7snGaJHDfBWF+yLyoUBfgQ9oSwZSJ0i04Kg6WN7db5iAEjwS9aJNqABWaNYEP1IPcHtcSSdJC584dZpG3dHYYzGBl4jpl2Y8LjFj6bhkOr8LpdnAKbhBeEkr1c4yO3vzqU80jt4QU4ZKRu5F/D4lD5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAGT54VHtmM/8jKHkUBjipZp2j+toX1pqGorQ6epoGo=;
 b=ErCxIJ29OEA+9JA6pQQmdouI07NhMaDFGPBiLkC4t1A1d0MsjtBhFNiIDUw+ZwpFXE7LdYTvOXjw8Z7gSoQS7wKZ02mkiv+gcHENZlguFNKuO9KIkbvYO39g9rfo8+bwZBWdTKS7mMIEKudWc3rB19KBwEvfipSG5BvGb4M4xKlcxj7kkOo+lA3LT2UItH7AtwoEwKooCvTEBLgHrMacJ1OSF/+5y34Bklslhn3rnqsFtl1frFFk+Hq+RZRgTsKH+ML1jeScp3LcZov4DrxqPR4xBZ9FbHbh9GbNxI5LwnP6WTx1Sa/vc2xqr8bgTpIdUVsUsbWyDyxcX1/63lZmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAGT54VHtmM/8jKHkUBjipZp2j+toX1pqGorQ6epoGo=;
 b=cQ9XeRjWdQ/czN5/3x0wC7V/790Jg387VXgGSPbHGKY6PMDSZ/6US03AY46ppU/QSfGU0/CTTtGs7AzRO13gTlepvUdag1+J/f7XAnVYDOl0aLKr0W1vceSaSidgbsCCvjiGxkMicsdSs/z46mbgq/el1lP5w6kzRZqi52oP25c=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2861.namprd15.prod.outlook.com (20.178.252.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Wed, 22 Jan 2020 20:35:42 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 20:35:42 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MWHPR21CA0055.namprd21.prod.outlook.com (2603:10b6:300:db::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.10 via Frontend Transport; Wed, 22 Jan 2020 20:35:41 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 04/12] tcp_bpf: Don't let child socket inherit
 parent protocol ops on copy
Thread-Topic: [PATCH bpf-next v3 04/12] tcp_bpf: Don't let child socket
 inherit parent protocol ops on copy
Thread-Index: AQHV0SSzVvei0U2SmUOkYWUbN4Vfbaf3JLkA
Date:   Wed, 22 Jan 2020 20:35:42 +0000
Message-ID: <20200122203538.juspsqgwki7rn45q@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-5-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-5-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0055.namprd21.prod.outlook.com
 (2603:10b6:300:db::17) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81a1555c-b211-4923-f454-08d79f7aa66b
x-ms-traffictypediagnostic: MN2PR15MB2861:
x-microsoft-antispam-prvs: <MN2PR15MB2861527779DA824476288FEFD50C0@MN2PR15MB2861.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(346002)(376002)(136003)(189003)(199004)(81156014)(66556008)(81166006)(8676002)(64756008)(1076003)(66476007)(71200400001)(66946007)(2906002)(66446008)(316002)(478600001)(6916009)(86362001)(16526019)(54906003)(4326008)(6506007)(5660300002)(55016002)(8936002)(9686003)(7696005)(52116002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2861;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fy7DZWPyniHD5mZdMq9jf6BkBrB78VH/mkMkM6TcfqFPgCTjNhglqacrCo7fRWla1Kxt5XSZh+78kzNJ/n0yuondveXtMhLuh9eHy3fJX6zla0Fq8BquftEIYnqXxS0xunEthg131wLaRE8OrO4aU1qOYWHftLGGFmiIlnI20AikFiQDoiANvA+er/9qyamojG7wmD8puJeZxLJMq1Entn9hWecyD4gThxBVFMRHsuaRNT/SoQHUnZxMRLOefacVJ4dc7c+R90fQPQFC40RojetkbQR1qKuZKP1akabXX5CBkhMxvWaaNlcE4+SJVjF5q22dMb83BG2KFPxHOadJSzC6cQkPlYPVDGRtLcdts71T0EMCDf4+H3LmVSnxCqHzyWpuBzS6P4sc6IavRyKvS3ktKWLkw2anZKXFDInARZaKcry2KtAnRxd8MzyvAdGT
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C146817E5E88348BB093D451BD7EF20@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a1555c-b211-4923-f454-08d79f7aa66b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 20:35:42.5162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xQ2QrkHGtLjyK7RmnpfLdI2cU+G7kT+KXUnfxy++zInd9l8QZG+q/7FprkzttjH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2861
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=932
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 spamscore=0
 bulkscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001220175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:41PM +0100, Jakub Sitnicki wrote:
> Prepare for cloning listening sockets that have their protocol callbacks
> overridden by sk_msg. Child sockets must not inherit parent callbacks tha=
t
> access state stored in sk_user_data owned by the parent.
>=20
> Restore the child socket protocol callbacks before it gets hashed and any
> of the callbacks can get invoked.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/tcp.h        |  7 +++++++
>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
>  net/ipv4/tcp_minisocks.c |  2 ++
>  3 files changed, 22 insertions(+)
>=20
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 9dd975be7fdf..ac205d31e4ad 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2181,6 +2181,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr=
 *msg, size_t len,
>  		    int nonblock, int flags, int *addr_len);
>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>  		      struct msghdr *msg, int len, int flags);
> +#ifdef CONFIG_NET_SOCK_MSG
> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
nit.  "struct sock *child" vs ...

> +#else
> +static inline void tcp_bpf_clone(const struct sock *sk, struct sock *chi=
ld)
> +{
> +}
> +#endif
> =20
>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
>   * is < 0, then the BPF op failed (for example if the loaded BPF
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 4f25aba44ead..16060e0893a1 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -582,6 +582,19 @@ static void tcp_bpf_close(struct sock *sk, long time=
out)
>  	saved_close(sk, timeout);
>  }
> =20
> +/* If a child got cloned from a listening socket that had tcp_bpf
> + * protocol callbacks installed, we need to restore the callbacks to
> + * the default ones because the child does not inherit the psock state
> + * that tcp_bpf callbacks expect.
> + */
> +void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
"struct sock *newsk" here.

Could be a follow-up.

Other than that,
Acked-by: Martin KaFai Lau <kafai@fb.com>

> +{
> +	struct proto *prot =3D newsk->sk_prot;
> +
> +	if (prot->unhash =3D=3D tcp_bpf_unhash)
> +		newsk->sk_prot =3D sk->sk_prot_creator;
> +}
> +
