Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D930339B5E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 08:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfFHGQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 02:16:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbfFHGQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 02:16:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5863iWv010706;
        Fri, 7 Jun 2019 23:16:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S7dTzgQATvy8DgGOqWtrhT5UUcOUwUh1fbaCRhLT6sI=;
 b=kjXNBdP7fY4OF6lBVoynPXHaBupUZSaJk6BCXhwmb89STcAzNxrVWozOGx9/29D65sSq
 tMG6MKHwkwziNtfppkMqC7FoH2jHaMm53tngywNYPTeQ3MB9dO9TNoVq/qOwRw+VhmVA
 F9oj5ieuDQIEz26vkP2zgw083C81LLTNMjA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2t01ws8pae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Jun 2019 23:16:08 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 7 Jun 2019 23:16:07 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 7 Jun 2019 23:16:07 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Jun 2019 23:16:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7dTzgQATvy8DgGOqWtrhT5UUcOUwUh1fbaCRhLT6sI=;
 b=svR41XILiJAkoilVV5w39p7GAca19Wq9yCNREMvRrgOxZJ52V4QgBi0nmfdvU6pEAMi1VOjGuUYhIMUSPnYzF9wkjl5/r9/iZrP+8kRrCfwJYJQPOY6w85FtUxu536BxfrvBn/ydEO1llYdj6IgYtyy9FAxREXjMDo2b4VwiqmY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1472.namprd15.prod.outlook.com (10.173.235.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Sat, 8 Jun 2019 06:15:51 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Sat, 8 Jun 2019
 06:15:51 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        "Wei Wang" <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net v2 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHNb1gS9D7wV39kmdoxONV0xAvKaRSYwA
Date:   Sat, 8 Jun 2019 06:15:51 +0000
Message-ID: <20190608061548.yhy3xkunxllnjrsr@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559872578.git.sbrivio@redhat.com>
 <3bf118a6a3870e72011b6105b63fa0d012094394.1559872578.git.sbrivio@redhat.com>
In-Reply-To: <3bf118a6a3870e72011b6105b63fa0d012094394.1559872578.git.sbrivio@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:301:3b::24) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:14ab]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4594e508-a807-4d1d-b7a6-08d6ebd8c17a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1472;
x-ms-traffictypediagnostic: MWHPR15MB1472:
x-microsoft-antispam-prvs: <MWHPR15MB1472CE5E65720D7745A87667D5110@MWHPR15MB1472.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39860400002)(136003)(199004)(189003)(76176011)(66446008)(476003)(6486002)(6506007)(386003)(66476007)(66946007)(86362001)(1076003)(64756008)(66556008)(11346002)(14454004)(73956011)(6436002)(102836004)(5660300002)(478600001)(71200400001)(71190400001)(6512007)(9686003)(446003)(68736007)(52116002)(46003)(486006)(229853002)(256004)(25786009)(53936002)(14444005)(305945005)(99286004)(6246003)(7736002)(4326008)(316002)(6116002)(81156014)(8676002)(81166006)(186003)(6916009)(54906003)(2906002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1472;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bEEzHThKJvOMqPGLwj1ABhLI485mlSFpewshEsfZPt03/AlRyq8rHhA9tBntmqKsj4QWpIB25HX6/VxpFG/VBekJF9VUsMdcis5OZ9NgOPkR7TUUE86jdE3A6/YnPPAZc4cZS3gHkdPeGoVYEnWlVAawA1oC9uh3I9S3sHZIfC3ts4MN8svhP3nmQrTRypfC62P2Wgdf8lDd3i1uJaVGAh3HR4orrKj9kniSJpp7ppNEGEdWx3tHetzZSG13HEKOxmvJpWGhcvDJ2H5YN/x1RIxsHV/0Y4pxP9eXfa9ZHk/c2lQjE6mhTf4kVPrKOPTvC2jPiaPmDygC4vqU3xAhYm1yWTBez9NqOgcXYpaO/ar1/pGhTtXYAPUbPSvr2kfnlnQtbgzGrhx+EEPMBflq9qEnzFoNPnRumU8N3go0T2c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7B640D95FB7FA459A1BBA0288225A58@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4594e508-a807-4d1d-b7a6-08d6ebd8c17a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2019 06:15:51.4395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1472
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 04:14:56AM +0200, Stefano Brivio wrote:
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
> We might be unable to dump all the entries for a given node in a single
> message, so keep track of how many entries were handled for the current
> node in fib6_walker, and skip that amount in case we start from the same
> partially dumped node.
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
> v2: Add tracking of number of entries to be skipped in current node after
>     a partial dump. As we restart from the same node, if not all the
>     exceptions for a given node fit in a single message, the dump will
>     not terminate, as suggested by Martin Lau. This is a concrete
>     possibility, setting up a big number of exceptions for the same route
>     actually causes the issue, suggested by David Ahern.
>=20
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This will cause a non-trivial conflict with commit cc5c073a693f
> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> an equivalent patch against net-next, if it helps.
>=20
>  include/net/ip6_fib.h   |  1 +
>  include/net/ip6_route.h |  2 +-
>  net/ipv6/ip6_fib.c      | 24 ++++++++++-----
>  net/ipv6/route.c        | 65 +++++++++++++++++++++++++++++++++++++----
>  4 files changed, 78 insertions(+), 14 deletions(-)
>=20
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index d6d936cbf6b3..fcac02a8ba74 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -316,6 +316,7 @@ struct fib6_walker {
>  	enum fib6_walk_state state;
>  	unsigned int skip;
>  	unsigned int count;
> +	unsigned int skip_in_node;
>  	int (*func)(struct fib6_walker *);
>  	void *args;
>  };
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 4790beaa86e0..b66c4aac56ab 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -178,7 +178,7 @@ struct rt6_rtnl_dump_arg {
>  	struct fib_dump_filter filter;
>  };
> =20
> -int rt6_dump_route(struct fib6_info *f6i, void *p_arg);
> +int rt6_dump_route(struct fib6_info *f6i, void *p_arg, unsigned int skip=
);
>  void rt6_mtu_change(struct net_device *dev, unsigned int mtu);
>  void rt6_remove_prefsrc(struct inet6_ifaddr *ifp);
>  void rt6_clean_tohost(struct net *net, struct in6_addr *gateway);
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 008421b550c6..f468fa9b5da6 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -473,12 +473,22 @@ static int fib6_dump_node(struct fib6_walker *w)
>  	struct fib6_info *rt;
> =20
>  	for_each_fib6_walker_rt(w) {
> -		res =3D rt6_dump_route(rt, w->args);
> -		if (res < 0) {
> +		res =3D rt6_dump_route(rt, w->args, w->skip_in_node);
> +		if (res) {
>  			/* Frame is full, suspend walking */
>  			w->leaf =3D rt;
> +
> +			/* We'll restart from this node, so if some routes were
> +			 * already dumped, skip them next time.
> +			 */
> +			if (res > 0)
> +				w->skip_in_node +=3D res;
> +			else
> +				w->skip_in_node =3D 0;
I am likely missing something.  It is not obvious to me why skip_in_node
can go backward to 0 here when res < 0.
Should skip_in_node be strictly increasing to ensure forward progress?

Would it be more intuitive to change the return value of
rt6_dump_route() such that
-1: done with this node
>=3D0: number of routes filled in this round but still some more to be done=
?

then:
if (res >=3D 0) {
	w->leaf =3D rt;
	w->skip_in_node +=3D res;
	return 1;
}

> +
>  			return 1;
>  		}
> +		w->skip_in_node =3D 0;
> =20
>  		/* Multipath routes are dumped in one route with the
>  		 * RTA_MULTIPATH attribute. Jump 'rt' to point to the
> @@ -530,6 +540,7 @@ static int fib6_dump_table(struct fib6_table *table, =
struct sk_buff *skb,
>  	if (cb->args[4] =3D=3D 0) {
>  		w->count =3D 0;
>  		w->skip =3D 0;
> +		w->skip_in_node =3D 0;
> =20
>  		spin_lock_bh(&table->tb6_lock);
>  		res =3D fib6_walk(net, w);
> @@ -545,6 +556,7 @@ static int fib6_dump_table(struct fib6_table *table, =
struct sk_buff *skb,
>  			w->state =3D FWS_INIT;
>  			w->node =3D w->root;
>  			w->skip =3D w->count;
> +			w->skip_in_node =3D 0;
>  		} else
>  			w->skip =3D 0;
> =20
> @@ -581,13 +593,10 @@ static int inet6_dump_fib(struct sk_buff *skb, stru=
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
> @@ -2045,6 +2054,7 @@ static void fib6_clean_tree(struct net *net, struct=
 fib6_node *root,
>  	c.w.func =3D fib6_clean_node;
>  	c.w.count =3D 0;
>  	c.w.skip =3D 0;
> +	c.w.skip_in_node =3D 0;
>  	c.func =3D func;
>  	c.sernum =3D sernum;
>  	c.arg =3D arg;
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 848e944f07df..554f88bd64f3 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4858,12 +4858,16 @@ static bool fib6_info_uses_dev(const struct fib6_=
info *f6i,
>  	return false;
>  }
> =20
> -int rt6_dump_route(struct fib6_info *rt, void *p_arg)
> +/* Return count of handled routes on failure, -1 if all failed, 0 on suc=
cess */
> +int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
>  {
>  	struct rt6_rtnl_dump_arg *arg =3D (struct rt6_rtnl_dump_arg *) p_arg;
>  	struct fib_dump_filter *filter =3D &arg->filter;
> +	struct rt6_exception_bucket *bucket;
>  	unsigned int flags =3D NLM_F_MULTI;
> +	struct rt6_exception *rt6_ex;
>  	struct net *net =3D arg->net;
> +	int i, count =3D 0;
> =20
>  	if (rt =3D=3D net->ipv6.fib6_null_entry)
>  		return 0;
> @@ -4871,20 +4875,69 @@ int rt6_dump_route(struct fib6_info *rt, void *p_=
arg)
>  	if ((filter->flags & RTM_F_PREFIX) &&
>  	    !(rt->fib6_flags & RTF_PREFIX_RT)) {
>  		/* success since this is not a prefix route */
> -		return 1;
> +		return 0;
>  	}
>  	if (filter->filter_set) {
>  		if ((filter->rt_type && rt->fib6_type !=3D filter->rt_type) ||
>  		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
>  		    (filter->protocol && rt->fib6_protocol !=3D filter->protocol)) {
> -			return 1;
> +			return 0;
>  		}
>  		flags |=3D NLM_F_DUMP_FILTERED;
>  	}
> =20
> -	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> -			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
> -			     arg->cb->nlh->nlmsg_seq, flags);
> +	if (!(filter->flags & RTM_F_CLONED)) {
> +		if (skip) {
> +			skip--;
> +		} else if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
> +					 0, RTM_NEWROUTE,
> +					 NETLINK_CB(arg->cb->skb).portid,
> +					 arg->cb->nlh->nlmsg_seq, flags)) {
> +			return -1;
> +		} else {
If the v1 email thread will be concluded to dump exceptions only when clone=
d
flag is set, it may need some changes in this function.

> +			count++;
> +		}
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
> +			if (skip) {
> +				skip--;
> +				continue;
> +			}
> +
> +			/* Expiration of entries doesn't bump sernum, insertion
> +			 * does. Removal is triggered by insertion.
> +			 *
> +			 * Count expired entries we go through as handled
> +			 * entries that we'll skip next time, in case of partial
> +			 * node dump. Otherwise, if entries expire between two
> +			 * partial dumps, we'll skip the wrong amount.
> +			 */
> +			if (rt6_check_expired(rt6_ex->rt6i)) {
> +				count++;
> +				continue;
> +			}
> +
> +			if (rt6_fill_node(net, arg->skb, rt, &rt6_ex->rt6i->dst,
> +					  NULL, NULL, 0, RTM_NEWROUTE,
> +					  NETLINK_CB(arg->cb->skb).portid,
> +					  arg->cb->nlh->nlmsg_seq, flags)) {
> +				return count ? : -1;
> +			}
> +
> +			count++;
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
