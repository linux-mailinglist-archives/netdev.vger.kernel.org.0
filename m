Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01A1FC71
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 23:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfEOVvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 17:51:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726381AbfEOVvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 17:51:05 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4FLE0hL028215;
        Wed, 15 May 2019 14:50:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=b93T8rxNO+6JjKyy6JPXinuKZ525CLYCkOYLGJwvOJA=;
 b=F3otlSozyTAnUh1ygosxpIhe/C1PpaBiDg2QN1P35391nPl9ZxEYQRrukA+SQn3wToSk
 YzXolzuiQh15v30B8PGXEMt8jzA7AF3jv3wtEw84+PP2z7wrQp+dBsz0xSRgrLV7uXNL
 LgogXK6h2vMxCMAoXYyxEXOQPB7PPnzdkQM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sgtfeg40d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 May 2019 14:50:57 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 14:50:56 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 15 May 2019 14:50:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b93T8rxNO+6JjKyy6JPXinuKZ525CLYCkOYLGJwvOJA=;
 b=O3YnkEnkAoNGY0iNqFZTIwcu9YDQfT5xypU4QLm2QJA2f/tatHaZABOG4bEJgwKRZWG1QKVe5GiTp2bhgsyRChJVHZEnX+bFT3x3rRzUHloGHLaMsg5vmuLUAQHbhn6G03ydKHorDMwpNILiPLovKzyH5GmwTv39/gGjt3VATXo=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1277.namprd15.prod.outlook.com (10.175.3.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 21:50:55 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 21:50:55 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <tracywwnj@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
Thread-Topic: [PATCH net] ipv6: fix src addr routing with the exception table
Thread-Index: AQHVCrex/r1lP5xDgk+ii1tsEqeq96ZsuxgA
Date:   Wed, 15 May 2019 21:50:54 +0000
Message-ID: <20190515215052.vqku4gohestbkldj@kafai-mbp>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
In-Reply-To: <20190515004610.102519-1-tracywwnj@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:300:ae::24) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:5597]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6de8785d-0bb3-4c4d-0d38-08d6d97f676e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1277;
x-ms-traffictypediagnostic: MWHPR15MB1277:
x-microsoft-antispam-prvs: <MWHPR15MB1277AA5E1955C8D31A7C6D56D5090@MWHPR15MB1277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(376002)(396003)(136003)(39860400002)(366004)(199004)(189003)(6246003)(81166006)(8676002)(81156014)(8936002)(4326008)(53936002)(25786009)(229853002)(2906002)(14454004)(478600001)(6486002)(9686003)(6512007)(6436002)(316002)(86362001)(71190400001)(71200400001)(68736007)(5660300002)(66946007)(66476007)(52116002)(64756008)(66556008)(76176011)(66446008)(54906003)(6916009)(6116002)(73956011)(256004)(14444005)(11346002)(1076003)(476003)(446003)(486006)(305945005)(7736002)(6506007)(386003)(102836004)(46003)(99286004)(186003)(1411001)(33716001)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1277;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3UKW0ZOO85KPEBDo7BTr4iVoLmgYJ5ORpJ7aMkxw6NcFa+fGQLDC9QYKW9GFPmq5AJiZ0qy1tU2PjlyfoVzjcxDoNWbnHceovfmLQYsolQh9gO8hfh262KsQdVkQ6/dInXzCue6b3yna8IqHSGq76QqWGY3SBvAJayzykdroI3KRA6tuOFBEo8uRxKEmgsJRp64Zf24mZeeOgvnQo9sIyuw2fh2APfPEtFirPjAu1OBZky54T7e/NCTAI0vx6tKAPT1omQlAvRuqFD7203nHrQHL7MAFNxvpcsz/X1rwlvuhjsuweYGMSdepgRMaQU6k1mZ3zKe19sL3GgxdZDvLje7sNiUqJhujuRBq+MU4flOHaGZ4LeKIPztFi4OZlfwUuQKyhPdDAK/lxerwWkyO5C5L+CmRVOMIlX+oq/afQ14=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2F3E0D9B19F8E4484B7DE8A69345FA5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de8785d-0bb3-4c4d-0d38-08d6d97f676e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 21:50:54.9672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 05:46:10PM -0700, Wei Wang wrote:
> From: Wei Wang <weiwan@google.com>
>=20
> When inserting route cache into the exception table, the key is
> generated with both src_addr and dest_addr with src addr routing.
> However, current logic always assumes the src_addr used to generate the
> key is a /128 host address. This is not true in the following scenarios:
> 1. When the route is a gateway route or does not have next hop.
>    (rt6_is_gw_or_nonexthop() =3D=3D false)
> 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> This means, when looking for a route cache in the exception table, we
> have to do the lookup twice: first time with the passed in /128 host
> address, second time with the src_addr stored in fib6_info.
>=20
> This solves the pmtu discovery issue reported by Mikael Magnusson where
> a route cache with a lower mtu info is created for a gateway route with
> src addr. However, the lookup code is not able to find this route cache.
>=20
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> Bisected-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/route.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 23a20d62daac..c36900a07a78 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1574,23 +1574,36 @@ static struct rt6_info *rt6_find_cached_rt(const =
struct fib6_result *res,
>  	struct rt6_exception *rt6_ex;
>  	struct rt6_info *ret =3D NULL;
> =20
> -	bucket =3D rcu_dereference(res->f6i->rt6i_exception_bucket);
> -
>  #ifdef CONFIG_IPV6_SUBTREES
>  	/* fib6i_src.plen !=3D 0 indicates f6i is in subtree
>  	 * and exception table is indexed by a hash of
>  	 * both fib6_dst and fib6_src.
> -	 * Otherwise, the exception table is indexed by
> -	 * a hash of only fib6_dst.
> +	 * However, the src addr used to create the hash
> +	 * might not be exactly the passed in saddr which
> +	 * is a /128 addr from the flow.
> +	 * So we need to use f6i->fib6_src to redo lookup
> +	 * if the passed in saddr does not find anything.
> +	 * (See the logic in ip6_rt_cache_alloc() on how
> +	 * rt->rt6i_src is updated.)
>  	 */
>  	if (res->f6i->fib6_src.plen)
>  		src_key =3D saddr;
> +find_ex:
>  #endif
> +	bucket =3D rcu_dereference(res->f6i->rt6i_exception_bucket);
>  	rt6_ex =3D __rt6_find_exception_rcu(&bucket, daddr, src_key);
> =20
>  	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
>  		ret =3D rt6_ex->rt6i;
> =20
> +#ifdef CONFIG_IPV6_SUBTREES
> +	/* Use fib6_src as src_key and redo lookup */
> +	if (!ret && src_key =3D=3D saddr) {
> +		src_key =3D &res->f6i->fib6_src.addr;
> +		goto find_ex;
> +	}
> +#endif
> +
>  	return ret;
>  }
> =20
> @@ -2683,12 +2696,22 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *r=
es,
>  #ifdef CONFIG_IPV6_SUBTREES
>  	if (f6i->fib6_src.plen)
>  		src_key =3D saddr;
> +find_ex:
>  #endif
> -
>  	bucket =3D rcu_dereference(f6i->rt6i_exception_bucket);
>  	rt6_ex =3D __rt6_find_exception_rcu(&bucket, daddr, src_key);
>  	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
>  		mtu =3D dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
> +#ifdef CONFIG_IPV6_SUBTREES
> +	/* Similar logic as in rt6_find_cached_rt().
> +	 * We need to use f6i->fib6_src to redo lookup in exception
> +	 * table if saddr did not yield any result.
> +	 */
> +	else if (src_key =3D=3D saddr) {
> +		src_key =3D &f6i->fib6_src.addr;
> +		goto find_ex;
> +	}
> +#endif
Nit.
Instead of repeating this retry logic,
can it be consolidated into __rt6_find_exception_xxx()
by passing fib6_src.addr as a secondary matching
saddr?

> =20
>  	if (likely(!mtu)) {
>  		struct net_device *dev =3D nh->fib_nh_dev;
> --=20
> 2.21.0.1020.gf2820cf01a-goog
>=20
