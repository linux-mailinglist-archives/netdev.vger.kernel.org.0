Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C474CE09
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbfFTMxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:53:54 -0400
Received: from mail-eopbgr700073.outbound.protection.outlook.com ([40.107.70.73]:32192
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726569AbfFTMxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sDCGNmZUECGsr3nVdfuQiGkdHI94DvBf23hSyYSvto=;
 b=mx1C4gtceMjGWWMlxlZBGnxuE6o47kHdgfO1gIqDeoVMQ/dp+lHGn49iLspRSgVUeHi2GVm32eOJELd9mDHs25Q15K7dFG4hvbOmdLsKQMUbECSl1IdwRDL2jOo8uBFg7ifmRPaqv67bWIMv5RE4b1QlpGYhQAaHfc1Y49VeKyI=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (52.132.228.77) by
 CH2PR15MB3718.namprd15.prod.outlook.com (52.132.230.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 20 Jun 2019 12:53:47 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::8d6a:e759:6fd:5ee0]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::8d6a:e759:6fd:5ee0%7]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 12:53:47 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Ying Xue <ying.xue@windriver.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH net] tipc: add dst_cache support for udp media
Thread-Topic: [PATCH net] tipc: add dst_cache support for udp media
Thread-Index: AQHVJ1fdyQpCetQ/80yiS387zwmpZqakf6Bw
Date:   Thu, 20 Jun 2019 12:53:47 +0000
Message-ID: <CH2PR15MB357599BE22BDF91442D5E5469AE40@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <0ea2e8519f14d5c9e7bb7ba82a5be371bd4cb9ab.1561028621.git.lucien.xin@gmail.com>
In-Reply-To: <0ea2e8519f14d5c9e7bb7ba82a5be371bd4cb9ab.1561028621.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [198.24.6.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea87bf2e-ee2d-4819-e195-08d6f57e5626
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3718;
x-ms-traffictypediagnostic: CH2PR15MB3718:
x-microsoft-antispam-prvs: <CH2PR15MB3718E5D3348A42206CBA7E6C9AE40@CH2PR15MB3718.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39850400004)(346002)(396003)(376002)(199004)(189003)(13464003)(256004)(64756008)(66066001)(305945005)(74316002)(86362001)(66946007)(33656002)(7736002)(71200400001)(55016002)(68736007)(25786009)(2906002)(6436002)(53936002)(54906003)(9686003)(26005)(3846002)(229853002)(6506007)(6116002)(8936002)(53546011)(14444005)(4326008)(8676002)(71190400001)(316002)(14454004)(99286004)(6246003)(76176011)(7696005)(102836004)(81156014)(476003)(44832011)(81166006)(52536014)(5660300002)(66556008)(478600001)(486006)(186003)(110136005)(446003)(66476007)(11346002)(76116006)(66446008)(73956011)(237434003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3718;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XKUrB1BRCSFdiQV74c0YSa0BrApKMsdFDtVtCc2hAefl1tdm4dn1wwuc+ofH0VrEldhEry4zipY4awgY/3fJUgOQtRucXDOpM5qKkGhsyG48BYxjyOsSNUJCLhbTgSgpHE9siY2PptG3ilzop4iJE7mnvyba7if+zNxiAin7py0XyAokLooIlyttVEZONUPkvNmtfZEWTtxQ0XSZIcSBm6FXt5sMh06IJCT/ORP9UfabA0nfzA5VaxJuaaZmG4R0QJ5EhSfYVvDd1FrUNSPU9NYGGS9fSXbSm6ylv5QiB+ly93HxfQ1rGhXHv2gIFLweKN4jidY5SGCi280A/P3x/Cytxew6x+lj1/nPJ66PtoJfT1CDGM0oCqmsQao5wW4h27kXjRYiYqG99u+OI6e0BKZfUvz98XmiFIE8XDGEOEk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea87bf2e-ee2d-4819-e195-08d6f57e5626
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 12:53:47.7937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Jon Maloy <jon.maloy@ericsson.com>

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Xin Long
> Sent: 20-Jun-19 07:04
> To: network dev <netdev@vger.kernel.org>
> Cc: davem@davemloft.net; Jon Maloy <jon.maloy@ericsson.com>; Ying Xue
> <ying.xue@windriver.com>; tipc-discussion@lists.sourceforge.net; Paolo
> Abeni <pabeni@redhat.com>
> Subject: [PATCH net] tipc: add dst_cache support for udp media
>=20
> As other udp/ip tunnels do, tipc udp media should also have a lockless
> dst_cache supported on its tx path.
>=20
> Here we add dst_cache into udp_replicast to support dst cache for both
> rmcast and rcast, and rmcast uses ub->rcast and each rcast uses its own n=
ode
> in ub->rcast.list.
>=20
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/tipc/udp_media.c | 72 ++++++++++++++++++++++++++++++++++-------
> -----------
>  1 file changed, 47 insertions(+), 25 deletions(-)
>=20
> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c index
> 1405ccc..b8962df 100644
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -76,6 +76,7 @@ struct udp_media_addr {
>  /* struct udp_replicast - container for UDP remote addresses */  struct
> udp_replicast {
>  	struct udp_media_addr addr;
> +	struct dst_cache dst_cache;
>  	struct rcu_head rcu;
>  	struct list_head list;
>  };
> @@ -158,22 +159,27 @@ static int tipc_udp_addr2msg(char *msg, struct
> tipc_media_addr *a)
>  /* tipc_send_msg - enqueue a send request */  static int tipc_udp_xmit(s=
truct
> net *net, struct sk_buff *skb,
>  			 struct udp_bearer *ub, struct udp_media_addr *src,
> -			 struct udp_media_addr *dst)
> +			 struct udp_media_addr *dst, struct dst_cache *cache)
>  {
> +	struct dst_entry *ndst =3D dst_cache_get(cache);
>  	int ttl, err =3D 0;
> -	struct rtable *rt;
>=20
>  	if (dst->proto =3D=3D htons(ETH_P_IP)) {
> -		struct flowi4 fl =3D {
> -			.daddr =3D dst->ipv4.s_addr,
> -			.saddr =3D src->ipv4.s_addr,
> -			.flowi4_mark =3D skb->mark,
> -			.flowi4_proto =3D IPPROTO_UDP
> -		};
> -		rt =3D ip_route_output_key(net, &fl);
> -		if (IS_ERR(rt)) {
> -			err =3D PTR_ERR(rt);
> -			goto tx_error;
> +		struct rtable *rt =3D (struct rtable *)ndst;
> +
> +		if (!rt) {
> +			struct flowi4 fl =3D {
> +				.daddr =3D dst->ipv4.s_addr,
> +				.saddr =3D src->ipv4.s_addr,
> +				.flowi4_mark =3D skb->mark,
> +				.flowi4_proto =3D IPPROTO_UDP
> +			};
> +			rt =3D ip_route_output_key(net, &fl);
> +			if (IS_ERR(rt)) {
> +				err =3D PTR_ERR(rt);
> +				goto tx_error;
> +			}
> +			dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
>  		}
>=20
>  		ttl =3D ip4_dst_hoplimit(&rt->dst);
> @@ -182,17 +188,19 @@ static int tipc_udp_xmit(struct net *net, struct
> sk_buff *skb,
>  				    dst->port, false, true);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	} else {
> -		struct dst_entry *ndst;
> -		struct flowi6 fl6 =3D {
> -			.flowi6_oif =3D ub->ifindex,
> -			.daddr =3D dst->ipv6,
> -			.saddr =3D src->ipv6,
> -			.flowi6_proto =3D IPPROTO_UDP
> -		};
> -		err =3D ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk, &ndst,
> -						 &fl6);
> -		if (err)
> -			goto tx_error;
> +		if (!ndst) {
> +			struct flowi6 fl6 =3D {
> +				.flowi6_oif =3D ub->ifindex,
> +				.daddr =3D dst->ipv6,
> +				.saddr =3D src->ipv6,
> +				.flowi6_proto =3D IPPROTO_UDP
> +			};
> +			err =3D ipv6_stub->ipv6_dst_lookup(net, ub->ubsock->sk,
> +							 &ndst, &fl6);
> +			if (err)
> +				goto tx_error;
> +			dst_cache_set_ip6(cache, ndst, &fl6.saddr);
> +		}
>  		ttl =3D ip6_dst_hoplimit(ndst);
>  		err =3D udp_tunnel6_xmit_skb(ndst, ub->ubsock->sk, skb, NULL,
>  					   &src->ipv6, &dst->ipv6, 0, ttl, 0, @@ -230,7
> +238,8 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *s=
kb,
>  	}
>=20
>  	if (addr->broadcast !=3D TIPC_REPLICAST_SUPPORT)
> -		return tipc_udp_xmit(net, skb, ub, src, dst);
> +		return tipc_udp_xmit(net, skb, ub, src, dst,
> +				     &ub->rcast.dst_cache);
>=20
>  	/* Replicast, send an skb to each configured IP address */
>  	list_for_each_entry_rcu(rcast, &ub->rcast.list, list) { @@ -242,7 +251,=
8
> @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
>  			goto out;
>  		}
>=20
> -		err =3D tipc_udp_xmit(net, _skb, ub, src, &rcast->addr);
> +		err =3D tipc_udp_xmit(net, _skb, ub, src, &rcast->addr,
> +				    &rcast->dst_cache);
>  		if (err)
>  			goto out;
>  	}
> @@ -286,6 +296,11 @@ static int tipc_udp_rcast_add(struct tipc_bearer *b,
>  	if (!rcast)
>  		return -ENOMEM;
>=20
> +	if (dst_cache_init(&rcast->dst_cache, GFP_ATOMIC)) {
> +		kfree(rcast);
> +		return -ENOMEM;
> +	}
> +
>  	memcpy(&rcast->addr, addr, sizeof(struct udp_media_addr));
>=20
>  	if (ntohs(addr->proto) =3D=3D ETH_P_IP)
> @@ -742,6 +757,10 @@ static int tipc_udp_enable(struct net *net, struct
> tipc_bearer *b,
>  	tuncfg.encap_destroy =3D NULL;
>  	setup_udp_tunnel_sock(net, ub->ubsock, &tuncfg);
>=20
> +	err =3D dst_cache_init(&ub->rcast.dst_cache, GFP_ATOMIC);
> +	if (err)
> +		goto err;
> +
>  	/**
>  	 * The bcast media address port is used for all peers and the ip
>  	 * is used if it's a multicast address.
> @@ -756,6 +775,7 @@ static int tipc_udp_enable(struct net *net, struct
> tipc_bearer *b,
>=20
>  	return 0;
>  err:
> +	dst_cache_destroy(&ub->rcast.dst_cache);
>  	if (ub->ubsock)
>  		udp_tunnel_sock_release(ub->ubsock);
>  	kfree(ub);
> @@ -769,10 +789,12 @@ static void cleanup_bearer(struct work_struct
> *work)
>  	struct udp_replicast *rcast, *tmp;
>=20
>  	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
> +		dst_cache_destroy(&rcast->dst_cache);
>  		list_del_rcu(&rcast->list);
>  		kfree_rcu(rcast, rcu);
>  	}
>=20
> +	dst_cache_destroy(&ub->rcast.dst_cache);
>  	if (ub->ubsock)
>  		udp_tunnel_sock_release(ub->ubsock);
>  	synchronize_net();
> --
> 2.1.0

