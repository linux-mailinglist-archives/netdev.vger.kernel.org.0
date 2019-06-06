Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08537FCF
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfFFVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:45:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbfFFVp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:45:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56LeBJv006849;
        Thu, 6 Jun 2019 14:45:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=liCDJSVYUnZr5h3pJti5IdYG9MuCTujuzWgXllXSLTs=;
 b=razGbYhoFYpDoxymbB75WXC4Ibs4Y+iBVECm9EMvoztsAN7Ahl8DGjB2Jxf7leciJQdv
 5wOussqV8e0TkwTtH1q1cF7R6DVL+FUq8iC0qMtlSGriviJclSxKt8oiol+p6lGUC0Kv
 ADtVYY13hbe9djk8Z+w+sQp5liiqIjnk0hY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy5fh1f15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 14:45:02 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 14:45:01 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 14:45:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 14:45:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liCDJSVYUnZr5h3pJti5IdYG9MuCTujuzWgXllXSLTs=;
 b=mZVxA6Pfvo0Bi1xM5ttNWo2E28yzOZjrdBuuLFJsnG3oIHbTmwzdXs9/op9s7sk18IeFpa4tSkcpdPM6dgM4A3wg4T7Qy7t/6Yog7aU/G8W7YyFPElOTQw66VyNFweyN+tYCPwFBb0nR9FtygEVkNFeXUnd0rpyFH752yY582Js=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1118.namprd15.prod.outlook.com (10.175.2.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 21:44:59 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 21:44:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        "Wei Wang" <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPKOAA
Date:   Thu, 6 Jun 2019 21:44:58 +0000
Message-ID: <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
In-Reply-To: <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0068.namprd02.prod.outlook.com
 (2603:10b6:301:73::45) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::538e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44b2c2d5-0fb7-46b1-9b54-08d6eac83899
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1118;
x-ms-traffictypediagnostic: MWHPR15MB1118:
x-microsoft-antispam-prvs: <MWHPR15MB11188D3A4AF3E58EEE4B50D3D5170@MWHPR15MB1118.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(39860400002)(136003)(376002)(51914003)(199004)(189003)(73956011)(66946007)(14454004)(71190400001)(316002)(71200400001)(64756008)(66476007)(1076003)(14444005)(256004)(6116002)(6506007)(68736007)(386003)(54906003)(25786009)(6916009)(6486002)(476003)(305945005)(66556008)(66446008)(478600001)(5660300002)(2906002)(6512007)(6436002)(99286004)(9686003)(86362001)(486006)(229853002)(8936002)(81156014)(46003)(81166006)(102836004)(53936002)(76176011)(52116002)(4326008)(446003)(7736002)(186003)(8676002)(6246003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1118;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2ogMZPgcvGuGVMf88s/XpU9Dy6dLXHEamg+/EDkXNy4JTzVi0GVMT13Kyo2iGQuO7YDAZMfsvGE3lhhCgWBvprQgrLN0b16KmqYsggbbEZsDqtlK6Ubs3fFlzvxXY0+X0B0PGOnUMBKx/EsS5ozWM75O3O62Psby7OT43EFibsT3zMlysy9EW5TdinJrRbxPjqUYA/+fFAb6Jq2gUmXxLinpaz8IY4K5NOSTGcXHz0vXAhWnATZwrEHvFzkj0ixxVSqKQLQ9A6hJnVJA44gY5BVsCvHjQys+QH0DMfNPYUxu19aDW4RnmZXWOtMJhJa5u/wH/1zB9/8aFIHpRuDlTKb6gLw2/K5Go6TcqzLCeOfixYgszf87Eia24K/k8RLakIJxwQeqREcEqoYHc9cqFMIMxV9QtRt4A713s6sC3R8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08DA0299F7C78147BA54FA2AB00E7BAE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b2c2d5-0fb7-46b1-9b54-08d6eac83899
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 21:44:58.9228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:13:41PM +0200, Stefano Brivio wrote:
> Since commit 2b760fcf5cfb ("ipv6: hook up exception table to store dst
> cache"), route exceptions reside in a separate hash table, and won't be
> found by walking the FIB, so they won't be dumped to userspace on a
> RTM_GETROUTE message.
>=20
> This causes 'ip -6 route list cache' and 'ip -6 route flush cache' to
> have no function anymore:
>=20
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires =
539sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires =
536sec mtu 1500 pref medium
>  # ip -6 route list cache
>  # ip -6 route flush cache
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires =
520sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires =
519sec mtu 1500 pref medium
>=20
> because iproute2 lists cached routes using RTM_GETROUTE, and flushes them
> by listing all the routes, and deleting them with RTM_DELROUTE one by one=
.
>=20
> Look up exceptions in the hash table associated with the current fib6_inf=
o
> in rt6_dump_route(), and, if present and not expired, add them to the
> dump.
>=20
> Re-allow userspace to get FIB results by passing the RTM_F_CLONED flag as
> filter, by reverting commit 08e814c9e8eb ("net/ipv6: Bail early if user
> only wants cloned entries").
>=20
> As we do this, we also have to honour this flag while filtering routes in
> rt6_dump_route() and, if this filter effectively causes some results to b=
e
> discarded, by passing the NLM_F_DUMP_FILTERED flag back.
>=20
> To flush cached routes, a procfs entry could be introduced instead: that'=
s
> how it works for IPv4. We already have a rt6_flush_exception() function
> ready to be wired to it. However, this would not solve the issue for
> listing, and wouldn't fix the issue with current and previous versions of
> iproute2.
>=20
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This will cause a non-trivial conflict with commit cc5c073a693f
> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> an equivalent patch against net-next, if it helps.
>=20
>  net/ipv6/ip6_fib.c |  7 ++-----
>  net/ipv6/route.c   | 38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 37 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 008421b550c6..5be133565819 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -581,13 +581,10 @@ static int inet6_dump_fib(struct sk_buff *skb, stru=
ct netlink_callback *cb)
>  	} else if (nlmsg_len(nlh) >=3D sizeof(struct rtmsg)) {
>  		struct rtmsg *rtm =3D nlmsg_data(nlh);
> =20
> -		arg.filter.flags =3D rtm->rtm_flags & (RTM_F_PREFIX|RTM_F_CLONED);
> +		if (rtm->rtm_flags & RTM_F_PREFIX)
> +			arg.filter.flags =3D RTM_F_PREFIX;
>  	}
> =20
> -	/* fib entries are never clones */
> -	if (arg.filter.flags & RTM_F_CLONED)
> -		goto out;
> -
>  	w =3D (void *)cb->args[2];
>  	if (!w) {
>  		/* New dump:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 848e944f07df..51f923b3ad26 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4862,8 +4862,11 @@ int rt6_dump_route(struct fib6_info *rt, void *p_a=
rg)
>  {
>  	struct rt6_rtnl_dump_arg *arg =3D (struct rt6_rtnl_dump_arg *) p_arg;
>  	struct fib_dump_filter *filter =3D &arg->filter;
> +	struct rt6_exception_bucket *bucket;
>  	unsigned int flags =3D NLM_F_MULTI;
> +	struct rt6_exception *rt6_ex;
>  	struct net *net =3D arg->net;
> +	int i, err;
> =20
>  	if (rt =3D=3D net->ipv6.fib6_null_entry)
>  		return 0;
> @@ -4882,9 +4885,38 @@ int rt6_dump_route(struct fib6_info *rt, void *p_a=
rg)
>  		flags |=3D NLM_F_DUMP_FILTERED;
>  	}
> =20
> -	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> -			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
> -			     arg->cb->nlh->nlmsg_seq, flags);
> +	if (!(filter->flags & RTM_F_CLONED)) {
> +		err =3D rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> +				    RTM_NEWROUTE,
> +				    NETLINK_CB(arg->cb->skb).portid,
> +				    arg->cb->nlh->nlmsg_seq, flags);
> +		if (err)
> +			return err;
> +	} else {
> +		flags |=3D NLM_F_DUMP_FILTERED;
> +	}
> +
> +	bucket =3D rcu_dereference(rt->rt6i_exception_bucket);
> +	if (!bucket)
> +		return 0;
> +
> +	for (i =3D 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
> +		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
> +			if (rt6_check_expired(rt6_ex->rt6i))
> +				continue;
> +
> +			err =3D rt6_fill_node(net, arg->skb, rt,
> +					    &rt6_ex->rt6i->dst,
> +					    NULL, NULL, 0, RTM_NEWROUTE,
> +					    NETLINK_CB(arg->cb->skb).portid,
> +					    arg->cb->nlh->nlmsg_seq, flags);
Thanks for the patch.

A question on when rt6_fill_node() returns -EMSGSIZE while dumping the
exception bucket here.  Where will the next inet6_dump_fib() start?

> +			if (err)
> +				return err;
> +		}
> +		bucket++;
> +	}
> +
> +	return 0;
>  }
> =20
>  static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
> --=20
> 2.20.1
>=20
