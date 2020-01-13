Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DD3139C62
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 23:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgAMWXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 17:23:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726530AbgAMWXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 17:23:51 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00DMMiBU008357;
        Mon, 13 Jan 2020 14:23:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=u0uf6Kcpsd3WoyUY/L14RYcnhHINw8P+bxBId5WWScs=;
 b=V2g+pOQGv8fSFEKIQ+QUXg5pj3L7PcMndeBGC3bUPIucWdm1F+Fn/hLbHeizcFnrQ5Kj
 XNbmsEVZAA6eBpEk7KsWNzioDv76xbq6MVe7RcritgxTu1j+bTHnzytK7pOkU80iw8GV
 Sx+MEjjA4aEwh9RGPYF8ER0+U9PGzVC25xo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2xfar4aknc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:23:47 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 13 Jan 2020 14:23:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Jan 2020 14:23:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BybLNBxU8LFC/3uwm8yd+PDnoPFamiB1NDQluH/tH5z5LxXFx65bJoegOJ+oU7wSmn8uR0bFu+PhhDAasYrm7oX39biyDGQEmcc9mij1XcJasYv73BdSkbdKnFtSWwyBGwVxPGoqF8tQH19oyVPJlVf+f8FbWAtpPvHF/NQXSuFIZ9IoUPCKEe09KbE1uhhwCrtyzSW8IldjWMc/NfbDNDhfhQw3/mq9kN2rzNTHC0nf9jj64OkO8rYh6HajWQmP/OFvbFjDXJAA0+abhlI5JZyaUgHX+6a0CTNuIGpNqOtqt8tr47YyJ1L01BAptXWSrheOg9t0d7DaqK4nE3GhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0uf6Kcpsd3WoyUY/L14RYcnhHINw8P+bxBId5WWScs=;
 b=aorwiBL4NY23RWa0l6/B50Rn93v4N0+xKFGMtuy1Gbb45wTTSAEmCDbLiS73PfJADhn/CWVDj2MeZtNnzmSXFI5hqNsto4Z4XWE+bNz5ujDVNS6xNYL06rp6kWX5cKcyJonr8trEqxNEUKCoYQVRHgfHsnVkk2dOpOje2JbFmIVJGMutPwRaqLLITdtFfA0LQ/QY0n9JJg0xavFGnEy3KrTdWle3b7ClVn/kX2/Me8KAdLf2d/3D9095ainQnH6WVWLiIqCp176KDys4kxWlXO9f47otKY0IpVdcilREvMktHeM7q+aam4uckUSsfksyb8izOX5NUoAr9csFm3j/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0uf6Kcpsd3WoyUY/L14RYcnhHINw8P+bxBId5WWScs=;
 b=Zj3AMN9E2TE/FjQF8Vz+qSInag04Vwbl+/zgQYxFYnVcdI8MiLHSJs2ivLR/lODvbK+mwJ5uaVh7EdJMEOCzCFnnXIcn1m1omoZfUf0EH47ljYsD2nmKSFYuK3lgyC8OJS2mmJdFz4DmdLt6Ey6pB0kbH1Zzl2cRcIwqsca1R1Y=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2717.namprd15.prod.outlook.com (20.179.146.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 22:23:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 22:23:45 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by CO2PR04CA0007.namprd04.prod.outlook.com (2603:10b6:102:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Mon, 13 Jan 2020 22:23:44 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket inherit
 parent protocol ops on copy
Thread-Topic: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket
 inherit parent protocol ops on copy
Thread-Index: AQHVx6PcokuSwoBS/kqqpxf+r/8DbKfpMPEA
Date:   Mon, 13 Jan 2020 22:23:45 +0000
Message-ID: <20200113222342.suypc3rgib7xbkjl@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-5-jakub@cloudflare.com>
In-Reply-To: <20200110105027.257877-5-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:102:1::17) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3844f3b-c8da-413b-17d0-08d7987740c5
x-ms-traffictypediagnostic: MN2PR15MB2717:
x-microsoft-antispam-prvs: <MN2PR15MB27171DF8C2AFF220E7B4D703D5350@MN2PR15MB2717.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(39860400002)(396003)(136003)(189003)(199004)(66946007)(66476007)(64756008)(55016002)(9686003)(186003)(5660300002)(66556008)(71200400001)(4326008)(16526019)(7696005)(8936002)(52116002)(2906002)(81166006)(81156014)(8676002)(54906003)(316002)(86362001)(1076003)(66446008)(6916009)(6506007)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2717;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s0ioW/PJ+JwB3Ru25cxRW/v67WjUNT/XYiY2IIL6gaFXuafcYVGLNcrz8AKOevlZP8BCCR8qFhxAzutUR0A/M9IrW9WarnkWmsuRnTs4GczUOI1CoKIPVxoOYUXNg2m8QGn0oIoNHpN1GMVoBiUg2rDi/TUK4rbYk3ADHsmDGkqa7bPKglXNcCT9Tq2nt36IB3o1U9AZ27EG1wjY7tfMLa4+tlFItZOzVG/mxJAKTlEsD15aNSBmJxWi4PHSNnmLYLdwF6bmtwMYJZo0wOutDwNapnNX+o5SxQ5Gd+XhaB88U5qami9VY2+sAkQSkl+L42CBjn1Pc68+7hT1G53kdyZc81r6gc6sU9w2NiXw9D3aO68DhfZODQ7u23WAz8dnnYw6YaR7iTkvKE0cttdRJTb//nE7WjvfFBCXQupkR5fPTo1JWJD/EgH24HFhuFJs
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0FF015B3CC1C354180E09C66868F4C2B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f3844f3b-c8da-413b-17d0-08d7987740c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 22:23:45.3841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XiDMIhqpfDV2uEbnCnCWAHvpavPzpH/c49/fFplUWvwV60EKF1/Ce1cQoopgW250
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2717
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_07:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=753 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001130182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:50:20AM +0100, Jakub Sitnicki wrote:
> Prepare for cloning listening sockets that have their protocol callbacks
> overridden by sk_msg. Child sockets must not inherit parent callbacks tha=
t
> access state stored in sk_user_data owned by the parent.
>=20
> Restore the child socket protocol callbacks before the it gets hashed and
> any of the callbacks can get invoked.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/tcp.h        |  1 +
>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
>  net/ipv4/tcp_minisocks.c |  2 ++
>  3 files changed, 16 insertions(+)
>=20
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 9dd975be7fdf..7cbf9465bb10 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2181,6 +2181,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr =
*msg, size_t len,
>  		    int nonblock, int flags, int *addr_len);
>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>  		      struct msghdr *msg, int len, int flags);
> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
> =20
>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
>   * is < 0, then the BPF op failed (for example if the loaded BPF
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index f6c83747c71e..6f96320fb7cf 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -586,6 +586,19 @@ static void tcp_bpf_close(struct sock *sk, long time=
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
> +{
> +	struct proto *prot =3D newsk->sk_prot;
> +
> +	if (prot->recvmsg =3D=3D tcp_bpf_recvmsg)
A question not related to this patch (may be it is more for patch 6).

How tcp_bpf_recvmsg may be used for a listening sock (sk here)?

> +		newsk->sk_prot =3D sk->sk_prot_creator;
> +}
> +
