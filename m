Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE4F136021
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388482AbgAISYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:24:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34978 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730924AbgAISYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:24:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009INSHm004291;
        Thu, 9 Jan 2020 10:23:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SAgpDlm7p2DSxMVGzvsogbe+eAwoSRC/ZWVbKOYbDlE=;
 b=pPh+gZ65PguBsXBEMotXkEZILWEQMtGcGiZUC48HP47Q+oVQ2WnJ5anq8oH6kGJlMqUN
 iGKYdigJX3ka8A1YRuUxll1T/1AssszTZmeL6mFsT6ZXm+GCTSCeWUeAAnlGemfGXeQ8
 RxGwuVdKD1csRYjXscrxA2JL/qiRQdRG5j8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdrj8mv1y-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Jan 2020 10:23:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 9 Jan 2020 10:23:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSxiNNunp9ke6FI6QJ6jXBFw7tjSU7Yh5U0safI7LY7xzl7ghlgdgrH2SBMjUBrcU0RwkSCz4GnG4Bu2OV3yxGaNU0rm20Pg0CSowZbntO74GgVr5/ful+QMNo6CcLOjU6WTEC7ekVlDC/+fIyameuguJxKUu9XjwM4Uehi9+DZkdetnU60y75iciWkSOzoSCV6DqLumgBPylFtFcOimrl0aWXcGjIkX4lhB6BlBbPNQwvr/UF4jO6yNpWwkZeO0DovnVpnfzz79fSTS7EBVM2x0tsdaZBOaoRFKquN0Zoz6ZvaP2KSL8nlrcHIBLQpPuoGK5GyKnNoicTCPy8Yo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAgpDlm7p2DSxMVGzvsogbe+eAwoSRC/ZWVbKOYbDlE=;
 b=ZCna0LwENllldUpQ/z24oTu0GoGEm3dRVgdAdL4dJTSSoMWUSEf/aWjkFa5SmGmHXwKmLdi6qGJviSmLkbN8CMbvFz6uWj0JQD2fHefkVxDWnTw8BcjcSSoyV+4qWWTzbpopkLJFl1whS4A+SYsUNif7Vxl8/ZpKwfg8/vTIcdcR2uTXK4/bkM1GClckrLnY1OEy3OO47392vqH+eBXvJeAr9OBDmr2BMA52ag+COSODud3qysL24xOV8VXgcVuUQztB3YuKIRTlfLnrF7eFbacxBZfj7CBGsFfPF+UteGrFiV6E/V1z/zDGjmDf0zGB3peUE5ogV8bNS6F3l7Kryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAgpDlm7p2DSxMVGzvsogbe+eAwoSRC/ZWVbKOYbDlE=;
 b=H05DaeKLuXukld5S1Mphx6+1Mjif+6TqM5sQ6ESCz13iD9PJnGBVFrrE3k/FvSNdTOQQlarjCLiz68fq5aB2xHvct6Fx3O/gS0kyF2fdrJl8+nV4eI4JLfxQqJUu7IO0QQFciIJ9GHcI2m6DHiS1Y1Ju41B2W0+siVIa0lzFdZI=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2672.namprd15.prod.outlook.com (20.179.145.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 18:23:43 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.011; Thu, 9 Jan 2020
 18:23:43 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:f006) by MWHPR1401CA0020.namprd14.prod.outlook.com (2603:10b6:301:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 18:23:42 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@isovalent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH bpf 1/1] net: bpf: don't leak time wait and request
 sockets
Thread-Topic: [PATCH bpf 1/1] net: bpf: don't leak time wait and request
 sockets
Thread-Index: AQHVxuQpbYb7rSAgA0egZ1v2EYm9DqfipgaA
Date:   Thu, 9 Jan 2020 18:23:43 +0000
Message-ID: <20200109182335.um72tp73krvvubnl@kafai-mbp.dhcp.thefacebook.com>
References: <20200109115749.12283-1-lmb@cloudflare.com>
 <20200109115749.12283-2-lmb@cloudflare.com>
In-Reply-To: <20200109115749.12283-2-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0020.namprd14.prod.outlook.com
 (2603:10b6:301:4b::30) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f006]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 705e8ce4-b115-4f67-ffb9-08d795310eed
x-ms-traffictypediagnostic: MN2PR15MB2672:
x-microsoft-antispam-prvs: <MN2PR15MB26723206BD7259DB55CA8626D5390@MN2PR15MB2672.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(51914003)(8676002)(81166006)(81156014)(86362001)(316002)(7696005)(6916009)(5660300002)(4326008)(6506007)(7416002)(1076003)(66946007)(186003)(52116002)(8936002)(16526019)(2906002)(66556008)(64756008)(66446008)(54906003)(478600001)(66476007)(71200400001)(55016002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2672;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hTBusLA8VCTBV0YzD/Iex34Ab+nbWrrlm84584iUkutl2gkNwWqbzuRXbyRzaM5t5RZkxbPKcAFpeqSQRAO4YOawe+nsHDiX3bZkeCSK8Qemf04hoVpc/WFR8zsMg8caWxZDKy4Apir31r+9usoxT7h6gRFGIropVgXL/NR+7skjx4sRY28A1n0U+W/Jz99S1XjlkNL8+w2+A4d8bqAnfAHmckpP3FHzN0vh956J9sA3+UqwrZPJiVAyHIqZcT/ebprljGAFqLn5xBJ451PBSiLmv7OTkxEcwLj9NQphfwEAyTTTnM3vC8K6wIqNEcadHJEcvU+qJFDLf5vt0A0rxYgm2zkUZn6EavArmk4tZlr1QdDjmLNASsoc5fz2HWCjSkL8ctWjUglO2+dvJurJjAyWORBbZEigjK8UzsCKC7x3n2sPdSRjU+aZ+qvo04+Qnm9jQnhTtiVu6pxeV2XoOJo7J3hg4eECRDFfXPnK40o/jbSWlUALhd95jgjEjNAz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9A8B39E549285845877F2A261FD20EE5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 705e8ce4-b115-4f67-ffb9-08d795310eed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 18:23:43.4338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7mltBreaZu5TReU/IVjkAG9ey9D6eikYV848Tc2z/UxriMYaTpzkC40ZuJrKN1x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2672
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=946 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 11:57:48AM +0000, Lorenz Bauer wrote:
> It's possible to leak time wait and request sockets via the following
> BPF pseudo code:
> =A0
>   sk =3D bpf_skc_lookup_tcp(...)
>   if (sk)
>     bpf_sk_release(sk)
>=20
> If sk->sk_state is TCP_NEW_SYN_RECV or TCP_TIME_WAIT the refcount taken
> by bpf_skc_lookup_tcp is not undone by bpf_sk_release. This is because
> sk_flags is re-used for other data in both kinds of sockets. The check
Thanks for the report.

>=20
>   !sock_flag(sk, SOCK_RCU_FREE)
>=20
> therefore returns a bogus result.
>=20
> Introduce a helper to account for this complication, and call it from
> the necessary places.
>=20
> Fixes: edbf8c01de5a ("bpf: add skc_lookup_tcp helper")
> Fixes: f7355a6c0497 ("bpf: Check sk_fullsock() before returning from bpf_=
sk_lookup()")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/core/filter.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 42fd17c48c5f..d98dc4526d82 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5266,6 +5266,14 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_s=
ock_tuple *tuple, u32 len,
>  	return sk;
>  }
> =20
> +static void __bpf_sk_release(struct sock *sk)
> +{
> +	/* time wait and request socks don't have sk_flags. */
> +	if (sk->sk_state =3D=3D TCP_TIME_WAIT || sk->sk_state =3D=3D TCP_NEW_SY=
N_RECV ||
> +	    !sock_flag(sk, SOCK_RCU_FREE))
Would this work too?
	if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))

> +		sock_gen_put(sk);
> +}
> +
>  static struct sock *
>  __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 l=
en,
>  		struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> @@ -5277,8 +5285,7 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_soc=
k_tuple *tuple, u32 len,
>  	if (sk) {
>  		sk =3D sk_to_full_sk(sk);
>  		if (!sk_fullsock(sk)) {
> -			if (!sock_flag(sk, SOCK_RCU_FREE))
> -				sock_gen_put(sk);
> +			__bpf_sk_release(sk);
>  			return NULL;
>  		}
>  	}
> @@ -5315,8 +5322,7 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_=
tuple *tuple, u32 len,
>  	if (sk) {
>  		sk =3D sk_to_full_sk(sk);
>  		if (!sk_fullsock(sk)) {
> -			if (!sock_flag(sk, SOCK_RCU_FREE))
> -				sock_gen_put(sk);
> +			__bpf_sk_release(sk);
>  			return NULL;
>  		}
>  	}
> @@ -5383,8 +5389,7 @@ static const struct bpf_func_proto bpf_sk_lookup_ud=
p_proto =3D {
> =20
>  BPF_CALL_1(bpf_sk_release, struct sock *, sk)
>  {
> -	if (!sock_flag(sk, SOCK_RCU_FREE))
> -		sock_gen_put(sk);
> +	__bpf_sk_release(sk);
>  	return 0;
>  }
> =20
> --=20
> 2.20.1
>=20
