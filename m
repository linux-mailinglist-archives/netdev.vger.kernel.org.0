Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4020F1B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfEPTPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:15:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40336 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbfEPTPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:15:35 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GJDG5H022945;
        Thu, 16 May 2019 12:15:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lH+b8Vk4jhUMeZLgvBebKpeIcdIhJuZb3N6j+LPcAeY=;
 b=rVuw3ocr3nQxq2ZvRGjgXeLUg3qYYmb07t9E9mwNUNahNPgpPLD2Y8Sbr5iWANThTjvk
 BmKHfg3qBPqHnW/aog0GhSyHyac+v4Ca+GljBpDk2WhrPAZ3yHDgdiM5d2k3iyCu/7Ag
 nDYs9Rv3fGr75sJGHrP7jDhvKG2tfW2vAV8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2shaep8x14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 May 2019 12:15:21 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 16 May 2019 12:15:20 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 16 May 2019 12:15:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lH+b8Vk4jhUMeZLgvBebKpeIcdIhJuZb3N6j+LPcAeY=;
 b=Z2vCv+lHNB5/i9XlqKcTnFK/PrId7tyMI0CpKAzIGXc5Iw/0EDFiR7olY65xFGBT8dk9tqr05CtsVKMPJccXRU8kWKULpV29JLJE0ySmKsPKUOFWkDnlqlf0SXhzcqOI5K79lrf2Ri4aMCjfWSi/4/hC9edwpC9/DQsnuVYxI4U=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1853.namprd15.prod.outlook.com (10.174.255.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Thu, 16 May 2019 19:15:18 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 19:15:18 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <tracywwnj@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net] ipv6: fix src addr routing with the exception
 table
Thread-Topic: [PATCH v2 net] ipv6: fix src addr routing with the exception
 table
Thread-Index: AQHVDBOXl/78vo8UwkOB3wdsBVXxbaZuHzsA
Date:   Thu, 16 May 2019 19:15:18 +0000
Message-ID: <20190516191516.mceg7ufus5nzstie@kafai-mbp>
References: <20190516181620.126962-1-tracywwnj@gmail.com>
In-Reply-To: <20190516181620.126962-1-tracywwnj@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2b7dac2-ecb2-4d84-ed4e-08d6da32d4ed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1853;
x-ms-traffictypediagnostic: MWHPR15MB1853:
x-microsoft-antispam-prvs: <MWHPR15MB18530A3EDD3EDC6C717DE4E4D50A0@MWHPR15MB1853.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(51914003)(199004)(189003)(1076003)(446003)(11346002)(6486002)(8676002)(81156014)(81166006)(46003)(6116002)(71190400001)(71200400001)(229853002)(305945005)(73956011)(1411001)(7736002)(66946007)(66446008)(64756008)(66556008)(66476007)(99286004)(476003)(8936002)(6436002)(54906003)(68736007)(486006)(316002)(2906002)(9686003)(6512007)(25786009)(76176011)(386003)(6506007)(256004)(14444005)(5660300002)(52116002)(478600001)(186003)(6246003)(33716001)(102836004)(53936002)(6916009)(14454004)(86362001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1853;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aTE2WmsZ00Th3ReSUfqfVFKgD+upXB8Ih1IzFaAHgvSV8CWEKtba/OLY4sCdZPCVbIW0EbCsSHonv2Xuf+wSg8q9tz730Exnuyxp08/bSYvw9+ezu46hsQ0xnlWfNNtijW2Bj++WVkgzq7N618p9hwRdSFciYQc8nQpaA38FQy+WZy5knylyhezbreB/WchdwUJHLVOADdRvWrNyoxjH9MolxilPhTYKUHcRUxoEZ4d5ttanzaN+yETyYhI5amfPJLaBbuJtruBKuvsUYgtGCxvKFOxmBiCTwU2DQUcRkxaD3JSRKC0EAfjITkYvB15J9wfhIyadNR8dVBci+dOL25JyDCy72/+KIvzZpg1A9qxUf0UKhlyzcHFL3+UEE6GtBwlJ+2zpcEt1N+8Cp4cbE5Sma3xQOaO7fDRHCLHGn4c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D462043FF7687843BE3293428B3A05A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b7dac2-ecb2-4d84-ed4e-08d6da32d4ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 19:15:18.1011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_15:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 11:16:20AM -0700, Wei Wang wrote:
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
> Cc: Martin Lau <kafai@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
> Changes from v1:
> - restructure the code to only include the new logic in
>   rt6_find_cached_rt()
> ---
>  net/ipv6/route.c | 49 +++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 23 deletions(-)
>=20
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 23a20d62daac..35873b57c7f1 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -111,8 +111,8 @@ static int rt6_fill_node(struct net *net, struct sk_b=
uff *skb,
>  			 int iif, int type, u32 portid, u32 seq,
>  			 unsigned int flags);
>  static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res=
,
> -					   struct in6_addr *daddr,
> -					   struct in6_addr *saddr);
> +					   const struct in6_addr *daddr,
> +					   const struct in6_addr *saddr);
> =20
>  #ifdef CONFIG_IPV6_ROUTE_INFO
>  static struct fib6_info *rt6_add_route_info(struct net *net,
> @@ -1566,31 +1566,44 @@ void rt6_flush_exceptions(struct fib6_info *rt)
>   * Caller has to hold rcu_read_lock()
>   */
>  static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res=
,
> -					   struct in6_addr *daddr,
> -					   struct in6_addr *saddr)
> +					   const struct in6_addr *daddr,
> +					   const struct in6_addr *saddr)
>  {
>  	struct rt6_exception_bucket *bucket;
>  	struct in6_addr *src_key =3D NULL;
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
I am worry about the "src_key =3D=3D saddr" check.
e.g. what if "saddr =3D=3D &res->f6i->fib6_src.addr" in the future.

May be "!ret && src_key && src_key !=3D &res->f6i->fib6_src.addr"?

Other than that,
Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the v2.

> +		src_key =3D &res->f6i->fib6_src.addr;
> +		goto find_ex;
> +	}
> +#endif
> +
>  	return ret;
>  }
