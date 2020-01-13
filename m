Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8764C139DA4
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgAMXvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:51:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46440 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728802AbgAMXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:51:08 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DNjDX1013702;
        Mon, 13 Jan 2020 15:51:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OUA+2WLcDgzPgWArHp/vMLZSyesWr8mk2yywUFCgfoA=;
 b=fPAZ/kgXOKcUeUEUlWCmWFRTFKjJO90mOFoNhztbGMogPyVrX2AfF5LtYlDPPSWk5AG6
 Pdz2+6e9kATz7Wkttd3AD+o1U8ho5Ox3xRShFvBVxAdDMJ9s1MN1ufzzKEOaJWy2RpiA
 2R3PLgO9MBQ0I1Hp0NNx774tXPJ426jfZD8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfcyutk1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Jan 2020 15:51:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 15:51:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZFj9qEU9BILDctqVLwH8Lo5jcI0Ck3oJDx84egmmpXjF2Rk9mLKcj1VP2saSutpMr0RCF23x5+SS5o1/iJ/09vagVpEp0NmBOJ/UNFIb2DcVztmkz8ZFPKdXwIqjUGAx1hVAIm6aGoNGJb6vh0CEjzYX7Yz9IVxARziqR+uoXtn/aiQvd8P8MkKmUdBz3AHLHSVMTAqWAnre/9hF7i5E02V82i0Ck3tCeidvWYU5ry1huQlOUZhhCygTOvM5qVVsPiXDQKBq6lN5FNWiFB5Lqr6pcJ6mSLgDHkL9L2e59KVYaeiIZlJjQDn0XVpKtonwpL0FIXNbJOvYeBZMiXBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUA+2WLcDgzPgWArHp/vMLZSyesWr8mk2yywUFCgfoA=;
 b=k8dmC//UewNCxCPdbS7mqPQy5xVkB9ileejQ7A4iN6HZs6ofV3vd9XEaKhlmcNAD5fmy1GnXRSESLjOYNdLt6/mB87seYWdGae4MnXtilKgjD4sZA8GyOeXYR5XIob6ksUhJXwWZ2jasUh5nWEKSDGVl8QYs4icOwmSXP0z0LSsNOmI+GKs/obkluzNxTlzam/SUNRMg7lj4YC/WkfuCPRHtzaz38Jz4Gs5ixBX3U3URjP2VyaVmOyo/uZyV3scFp3a+QyExkksqalEIIqpVbDOwUg+2JiyTylt3LBfvQXnbCEhwtpQG2yoaoOHOCri2VfZ4ePh5SE6DJCCi12PeKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUA+2WLcDgzPgWArHp/vMLZSyesWr8mk2yywUFCgfoA=;
 b=hPRFoOPZTDZcCN2mHiw4VKVD6G7XyWwUl86adkFv6+09xWZrXfiUMmdbXveXGFk4i4PCCMZAVpAoaFd7296qTy1UXdLDDUf6Ubc072iUTdx9gOopbg38dYTwUofM8o5m2AGllfDlCFRS9N3MgBRmFlKNR091wkxg1EGZGTiAXS8=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3646.namprd15.prod.outlook.com (52.132.172.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 23:51:03 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 23:51:03 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by CO1PR15CA0060.namprd15.prod.outlook.com (2603:10b6:101:1f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Mon, 13 Jan 2020 23:51:02 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 09/11] bpf: Allow selecting reuseport socket
 from a SOCKMAP
Thread-Topic: [PATCH bpf-next v2 09/11] bpf: Allow selecting reuseport socket
 from a SOCKMAP
Thread-Index: AQHVx6PVd82VY188JESkqJ2VmIzUOKfpSVUA
Date:   Mon, 13 Jan 2020 23:51:03 +0000
Message-ID: <20200113235100.ewx2dviaolg6n6a2@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-10-jakub@cloudflare.com>
In-Reply-To: <20200110105027.257877-10-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:101:1f::28) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6b40f2a-5a4d-4a7e-87ff-08d7988372c4
x-ms-traffictypediagnostic: MN2PR15MB3646:
x-microsoft-antispam-prvs: <MN2PR15MB36460B9CE8E03723CC21E5D7D5350@MN2PR15MB3646.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(346002)(396003)(366004)(189003)(199004)(9686003)(64756008)(2906002)(186003)(66446008)(71200400001)(55016002)(6506007)(66476007)(86362001)(66556008)(66946007)(478600001)(1076003)(16526019)(8676002)(4326008)(6916009)(81166006)(81156014)(5660300002)(52116002)(7696005)(316002)(54906003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3646;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXWadAtchnirAangGMwdIqbrX/uDhsI0gYi3Gb39m8u4aBa3FF16DMCbqsg4G5m8sdHxfW4VZ9of3AQq1KacBU3/i60xPkjJI8Qv8lZz5tqmOgrGYetGGgsv8KPW74QHFUi2GY3f/rB+5JmX6JkSU6zIPdOusyZccJXwXBvp42c4wDP+7Iuozgw6Znjj84BKPsg+xAo4HWLaA+seFYxGIs1QkTnF2ce4OWh0Zxcbi1U2NIuU/kX7XLIUtaEmi96YJm93gjwmnp5sfxWY2lZ6sbiLghsalTnEjroh56hveoE5enOICVT3qtn3qxpjNHfVQ+HqqPo9y3Bk3E6um8GQaBf+7bNbbW2c/iWXCKJopzwDJtH/XK5IdurPBjzUog0RBUXq9m26PyRl09TR6xUqEOe6wDXqvmI6UupD1AFg1fEBQVe/rnhs3ldkvBHYlAld
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75D0A0CF84EA3B41BF8E4209542A2401@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b40f2a-5a4d-4a7e-87ff-08d7988372c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 23:51:03.1943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jMDKb9zxVpxIxVTlSEi54/P7n9j7nxjbrKwIHb1ZGbn06DzLQIWaD57ly49Yi17C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_08:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001130189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:50:25AM +0100, Jakub Sitnicki wrote:
> SOCKMAP now supports storing references to listening sockets. Nothing kee=
ps
> us from using it as an array of sockets to select from in SK_REUSEPORT
> programs.
>=20
> Whitelist the map type with the BPF helper for selecting socket.
>=20
> The restriction that the socket has to be a member of a reuseport group
> still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb s=
et
> is not a valid target and we signal it with -EINVAL.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  kernel/bpf/verifier.c |  6 ++++--
>  net/core/filter.c     | 15 ++++++++++-----
>  2 files changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f5af759a8a5f..0ee5f1594b5c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3697,7 +3697,8 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
>  		if (func_id !=3D BPF_FUNC_sk_redirect_map &&
>  		    func_id !=3D BPF_FUNC_sock_map_update &&
>  		    func_id !=3D BPF_FUNC_map_delete_elem &&
> -		    func_id !=3D BPF_FUNC_msg_redirect_map)
> +		    func_id !=3D BPF_FUNC_msg_redirect_map &&
> +		    func_id !=3D BPF_FUNC_sk_select_reuseport)
>  			goto error;
>  		break;
>  	case BPF_MAP_TYPE_SOCKHASH:
> @@ -3778,7 +3779,8 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
>  			goto error;
>  		break;
>  	case BPF_FUNC_sk_select_reuseport:
> -		if (map->map_type !=3D BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
> +		if (map->map_type !=3D BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
> +		    map->map_type !=3D BPF_MAP_TYPE_SOCKMAP)
>  			goto error;
>  		break;
>  	case BPF_FUNC_map_peek_elem:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a702761ef369..c79c62a54167 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8677,6 +8677,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuse=
port *reuse, struct sock *sk,
>  BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
>  	   struct bpf_map *, map, void *, key, u32, flags)
>  {
> +	bool is_sockarray =3D map->map_type =3D=3D BPF_MAP_TYPE_REUSEPORT_SOCKA=
RRAY;
A nit.
Since map_type is tested, reuseport_array_lookup_elem() or sock_map_lookup(=
)
can directly be called also.  mostly for consideration.  will not insist.


>  	struct sock_reuseport *reuse;
>  	struct sock *selected_sk;
> =20
