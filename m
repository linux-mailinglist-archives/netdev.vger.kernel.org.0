Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF202139DA1
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgAMXqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:46:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728802AbgAMXqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:46:05 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DNjxvX023956;
        Mon, 13 Jan 2020 15:46:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oq3OOuolIl6K0g8unnwGHah5ztZ74L29UWEr64hf2pw=;
 b=hRUIM6bT4aFTgl6yDu8UrBsmNn5tL1+sD1wKS1pbHc76SPrbiTJMWcHZWTvumaoLblny
 b7P3JbJAmA6BlLDpHJYIjJWRZ1qjiSg8vGc3ST7MQk6N31AFZjKTNliRbuvHC1LPTeQ9
 uH38GLwfC4a6xW5tV3yzeGpmh14CjchM+hc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xgw2ehqk3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 15:46:01 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 13 Jan 2020 15:45:46 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Jan 2020 15:45:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LntWAXYXzNu91wKhcQWsBQi/jTL7/kjPj5rOotS9b/i8wAZp6hYwJ0yVhM2ktV4GYUd3/LSYBYHwHEce4vq7/kLkQ4jltzBfYjqw+VRnOg5leoxy7fxEJhLgmLrtvXUUX8XM0uGh7pO+QAne2JbpdTei4rcEVCwAC5kE+DdT/UjUSiy8A6LA+SCmnniCo6Hq8KKiQHZycpiz5/6v9DFq/AeMajXBSDO8+MgptXe8VEjaJaW+upEIqCQ4mAHS8Bb57MbFrdbKZ/IrQzJ1HW2qU8whu2SA3XBaQMnfeowX9BVkek2NJlEPzhBWlswjg2llV5PAw4ndnZ/B+V653nuXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq3OOuolIl6K0g8unnwGHah5ztZ74L29UWEr64hf2pw=;
 b=g0fuEL8WAC4i1zkXlSMg/rb7oTMtElqGG2TvkPB/bZjp1uvlky4s/mpMGweMXRreSXmGw/5bVlvRKIaRLobM2pTiA730nn3iGLwYdkT2c4jfPkq8WVZf8RmTy4VS+XAeitiUDoLB/BxX9jqCnEAyWqYxr4wlVNGrkfCIbOljFyIvDtSD2FoWgB+5xfGZiGiisOcWW/5le+SQpAQ9Anz4WJSYgau1xK8yq76HSOgs28LgOC3Um0AMd8PkSFsANyhSfqE5mAPikBPb2NvIIg+STOlY5bWkf++IyIShxoqHIPRdfsLVzOLl7tmRz1M0/nGXSlEhjMhvrHX0kS6+2SgqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq3OOuolIl6K0g8unnwGHah5ztZ74L29UWEr64hf2pw=;
 b=PgveCcyHpy/te2TEBt8wDk0uIP3QDar2SKG8y+Ezi6aCufRIh+Uyq54R6VCrbPvtpBSz3I6+2pnEwtwQCYJmZqbCkNadZM0176po92uaJjFxPG5UjZcH0IBZqqZDH6V+NO1LOVUIQ6mWX21PJjhqr4E6Dx3oq7/N4vR7jGZlKy4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3582.namprd15.prod.outlook.com (52.132.172.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 23:45:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 23:45:45 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by MWHPR22CA0054.namprd22.prod.outlook.com (2603:10b6:300:12a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.12 via Frontend Transport; Mon, 13 Jan 2020 23:45:43 +0000
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
Thread-Index: AQHVx6PVd82VY188JESkqJ2VmIzUOKfpR9mA
Date:   Mon, 13 Jan 2020 23:45:45 +0000
Message-ID: <20200113234541.sru7domciovzijnx@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-10-jakub@cloudflare.com>
In-Reply-To: <20200110105027.257877-10-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0054.namprd22.prod.outlook.com
 (2603:10b6:300:12a::16) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afe9ee87-5d4c-4f44-808a-08d79882b51f
x-ms-traffictypediagnostic: MN2PR15MB3582:
x-microsoft-antispam-prvs: <MN2PR15MB3582891BFC73EB1D9DFC7ABED5350@MN2PR15MB3582.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(376002)(346002)(396003)(189003)(199004)(8936002)(9686003)(6506007)(52116002)(7696005)(55016002)(86362001)(186003)(16526019)(5660300002)(81166006)(81156014)(8676002)(4326008)(54906003)(71200400001)(64756008)(66556008)(66946007)(66446008)(6916009)(316002)(2906002)(478600001)(66476007)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3582;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DxvpZpboE7dw8hjw8afFhQalTE50XsdWZc+IDD/0a3AhlwutRyTwE7ChdsncF+P1oLssTHp3gSutc0Lqi0VP5pOvwjFP2oReNS29kCnUSMWV962hOW87Gi01FensR8hFzt68NE+0V0hzfoIuZJmTC6Rd79ymlS1/ZSw0V2teteecQPT7DNIummmS7sYu9em4Byr++luVEsKGjH62aTStpGX3mz8T6Z+KyTFhtZ1ufpaZWM7INhlsbnkUFrQuPGyur0hsaeI7xmOD5X2x+YSWREkv69ywgxYnm8iZfl7LUaNSLk9qaLNub2eRRTwlRmEdokta+hOPhRtTI2WZB79PF55UsZAsuQ43mpz4NtyAoXh9stVEwLpaYmOZWegXeSciBsscwb9BWswYBUSYlqkQKZCPBRbb0z8YL5gWCOCsZVZKiwvhglcgiN3fW8IE7b05
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A04F2F5A053E447BBD8DE52924573BC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: afe9ee87-5d4c-4f44-808a-08d79882b51f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 23:45:45.0564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 79QkKqfe599ub8xPOg8PhPHYvZlYiH1snIwvaRG58ryWN8YSY9SzJw4DZYlSTbQE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_08:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130189
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
>  	struct sock_reuseport *reuse;
>  	struct sock *selected_sk;
> =20
> @@ -8685,12 +8686,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reusepo=
rt_kern *, reuse_kern,
>  		return -ENOENT;
> =20
>  	reuse =3D rcu_dereference(selected_sk->sk_reuseport_cb);
> -	if (!reuse)
> -		/* selected_sk is unhashed (e.g. by close()) after the
> -		 * above map_lookup_elem().  Treat selected_sk has already
> -		 * been removed from the map.
> +	if (!reuse) {
> +		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
> +		 * The only (!reuse) case here is - the sk has already been
> +		 * unhashed (e.g. by close()), so treat it as -ENOENT.
> +		 *
> +		 * Other maps (e.g. sock_map) do not provide this guarantee and
> +		 * the sk may never be in the reuseport group to begin with.
>  		 */
> -		return -ENOENT;
> +		return is_sockarray ? -ENOENT : -EINVAL;
> +	}
> =20
>  	if (unlikely(reuse->reuseport_id !=3D reuse_kern->reuseport_id)) {
I guess the later testing patch passed is because reuseport_id is init to 0=
.

Note that in reuseport_array, reuseport_get_id() is called at update_elem()=
 to
init the reuse->reuseport_id.  It was done there because reuseport_array
was the only one requiring reuseport_id.  It is to ensure the bpf_prog
cannot accidentally use a sk from another reuseport-group.

The same has to be done in patch 5 or may be considering to
move it to reuseport_alloc() itself.
