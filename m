Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A966F2E98
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 07:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjEAFVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 01:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEAFVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 01:21:43 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2123.outbound.protection.outlook.com [40.107.20.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0EAA4
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 22:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtQsexeseW631cfRCe+cGKWFcUcVH14nyQ7CeKAxosALiIeYItRfY1Yi04uQxBUzCyxGdulfnWNx0nRS51Xyf956LwY5bIo9PUlKa9b0jH387Hz6gQ9s9wgJyjfKvI6JOss/ayj036acWCp60RBNlIQI8zA1n/D2Q+QBIprzbPNexJeYHvh52nFqWLzi8ZvkYb9HnF5c5SzHdkoh61WNnTK/1Yl1ALaMn046lJNrKJVVGGfJPxKGPf2v8Lx5qDGzhj+MXBWO2DyrF997z7lt3h8MvTzZF5PdRAJx1DYdSyITiqj8XG8ty3ISWEni2uC/ArSjvwHG7zRzSo+sV3hnnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlbBrxc6pqdeYHy7SnUTCM05qUz6kTnOAcLVKrdtgIE=;
 b=I0cR8pfP7ulhZ45ZU3LU2h8e8TjCEFrfcpkZ85jtI2ZmEJ5ucRR1lIPQW52zH8VAeDdQfR9l0Et1dFiuoh3ImM0wL10zkuQWXAw6rXEOLfb4dIcs9nlhqeA/70o0/+hPFm7FSJute8a0WApTNqK1Rs7P2IpFqSN0GwcpIVoLcknEyjkAic0Mz0jex/nc8swYR90nrd2jfEsrsd/U+HSv9WSy4SionfaaK10Vzgy3+/EXZj9xhDH7O3auKl4kHxrHHmO0bo/gyon/hZLlklTeK3jgA1FhNq3Bz9vOR3IMhAy05MNc5McPnzQFZkSFVKtAv0EQ4hd0WMTivt8zcPAXOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlbBrxc6pqdeYHy7SnUTCM05qUz6kTnOAcLVKrdtgIE=;
 b=SmoE0mBM2PMBd1ykX3BcL9+bquCr0qQXWVZw8Rlfl7wEga5DttLSMpELklZ5EGxgiYOTxr3EjLnKLXUX/Xa5CJrlD4OBHSmWmyVm1R9Kwed9RLpotBYhjabdtdTOF3AktAUK0HR/hvwEZ9HcjduCKmpbnH2EVlTTqmSTq9+uxdQ=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB9PR05MB9439.eurprd05.prod.outlook.com (2603:10a6:10:361::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Mon, 1 May
 2023 05:21:37 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6340.029; Mon, 1 May 2023
 05:21:37 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [tipc-discussion] [PATCH net 1/2] tipc: add tipc_bearer_min_mtu
 to calculate min mtu
Thread-Topic: [tipc-discussion] [PATCH net 1/2] tipc: add tipc_bearer_min_mtu
 to calculate min mtu
Thread-Index: AQHZeuuxa/Cccv5670GN5ajUWLjwnK9E4GaA
Date:   Mon, 1 May 2023 05:21:37 +0000
Message-ID: <DB9PR05MB9078A5939A8D21C278136820886E9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <cover.1682807958.git.lucien.xin@gmail.com>
 <b73c0deb97ca299207d2197db28f78d3992fbdbf.1682807958.git.lucien.xin@gmail.com>
In-Reply-To: <b73c0deb97ca299207d2197db28f78d3992fbdbf.1682807958.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|DB9PR05MB9439:EE_
x-ms-office365-filtering-correlation-id: bdebb583-8eac-4085-d1f7-08db4a03efc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tdbpwl5TNdgktBuIE8rl7Pt5Zo8C1D56vx7iseRQyd99opQ9U8S7/J+/+oXLC2EolrubrUEmaT7gIKuH6W84ki1FbiAzAtobDXcykRKzxLWYoBcc/dMOw7LF71tvfQ7XK8lLYbH7qnKn57YXXHVpSld0orTXi3sFxUPkB9pLR1t+Z5QXd3djuhaqg5A9k2HQeWWpaI0z6eEco0s3+nvZZHOwlP1iAlsvAc6JlsRtzg71zqkr1/bEWNq9UFseLo7nP2jMGUHP1VW6WlMfMqMZ9DJyJQpPqT4NnAlejwu7tT0v9lzv+t66tAjEkNGLxFBRfRI3W7icOImBvTobKdWiYV3W1OpXOHm0WDKfK4Z16TT7yBbqo40D7Ggzx3gejyPdBvwXZB/Lr8qN0CgUoCfa88Z9Jhg2U+nMyC6j60j8OkGhnye4pRiyxKZ9u295L7arhremMvMtwKrLkqp1R1SEaQAg8QkAWaH0iEE4BomlDbxALjl1UeDuSrnolPRifTkcU8kqqeGE5matm8YJK58ZIzLLWq5Npt2n5zPb58iCYFekWasxb0b/OqtzdnvyqGMDSqrw5VHrQHe+W6QVIbnipK6G9d9zwBszk1F1z0sTOCw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(451199021)(52536014)(8936002)(8676002)(5660300002)(41300700001)(316002)(38070700005)(86362001)(33656002)(2906002)(38100700002)(122000001)(55016003)(186003)(83380400001)(478600001)(7696005)(71200400001)(26005)(6506007)(9686003)(4326008)(54906003)(76116006)(110136005)(66476007)(66556008)(66446008)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8Dj2tMYFURQXQuH8nc/EVQl1wQ1BxS9jFxpp6YlRmn6UUSM72SwpB5dMZ8Xa?=
 =?us-ascii?Q?nF30SbgNfRmP1sx8MnxC3Xo9wgcZSkP6iXWyVrTkqEK6zRQiI880bpk63N+N?=
 =?us-ascii?Q?Gx4IDuWcmaV6E/BIvKeFPvyEUuKPLKIfn51OdwGSnYL9ChmwDMJrKCnoCbeG?=
 =?us-ascii?Q?0ByMRofOHxFSC4y8TnDXmRsEzWQ6GRKdlTMhF8B0w/GsYliaCpLxjlNSHOEQ?=
 =?us-ascii?Q?cgxyv6u62iz4o9xFRkhBLXTAWe1B4leO1gkmNHS9Yz2vPBwU7IZLVFosKVWt?=
 =?us-ascii?Q?tmb6C6qER6nCe1wLa5H4Ky072leKYLrvLeS+vtTVY1qCgZ7yuFQGrtlBMAqg?=
 =?us-ascii?Q?mWxrFRnE9/Alsdq3/ydqOR0As9w/wP3GvYL+/hMMfaN1WIwzzlyhITmE2Gd6?=
 =?us-ascii?Q?xDSnpieawyf4dywmEqsnPwphvftM25sQLEcSAAxgh15gVDqidvUdfxJJuB+B?=
 =?us-ascii?Q?frAgcfjjBM4P57TACHAHqY5G0dnoEWDpJb6BEV0y7Uk4J//GwiCYET/+qFGz?=
 =?us-ascii?Q?Pd6jKzLixYT4lJYsOTMY2PxfEYiasarupn4W0tvzXpuWcjehekvU+z3kpf56?=
 =?us-ascii?Q?u5DFE+HFywpZ8gDpJiwN4b3udL6ccYR2I7CW4ymh7mjrn3Z5qQnMTTvFEglS?=
 =?us-ascii?Q?0VRb94dVMYQ9XFoAzbWFzld1jbMm01nUXyfRoYIhUlkNsuKgrV4N7YNe18XX?=
 =?us-ascii?Q?LeVtlboe2nAP+3oa5jTlmsj60sgIymMlw18ckmsr+6rV0+f6C1IodoCve62a?=
 =?us-ascii?Q?7DvrpSGdbUBMFBisEuTRslLb5fgbDZO54qysWPjKZlEEBGXS79WqDOFblIF7?=
 =?us-ascii?Q?Lhg88xh/3ndyVXwUTp8wWGyrI7qbD5mxHFxgzUFF0uog35udJSPIPdtsmbCf?=
 =?us-ascii?Q?lxiKUh03hg08/CPV/BLZy8L071p/YRlvyVnOebI6UzmdpP8tIoLuvEh/8M5e?=
 =?us-ascii?Q?5F5ZU11Kd+UHbMeRyNtgTIUxxV3cYGGpBmtKiT646ZbL3Wi9eCAVSJhsJX1N?=
 =?us-ascii?Q?QvN+69K8C9Uml4GfTr/9ye+nkE34pCcDG/sflZNThwoW3FMm3Pg5d2DnxeCW?=
 =?us-ascii?Q?6hXKEXlwCe4FAhJKryMo1/mrZEkt+R7SK9oyYoj7T/4JdQ5+EFiUOvePeAHF?=
 =?us-ascii?Q?Jpq+H7zg/O313buHIonS/uVJRcEumWC2B+eflIcinLCo5HiezT/kilgp3CZ7?=
 =?us-ascii?Q?dUcEDuChbtTQga4ibbfd4y1AloV9k2xj29jLJQL+w/VNDu/nic7wpgEvf6bG?=
 =?us-ascii?Q?5uCekkhmZmmOCVwsXQEusQNP40qWOgBH6q2+zhQCRvKtj0fuh5Yi/JMswV8J?=
 =?us-ascii?Q?oQN4YjAmSQpE8IPAT0vyDk2bxlooG1CdLloo6nSNmWy47+fbG3YzOXW5UV8M?=
 =?us-ascii?Q?ktpsjvD29GdcyZq8KmwMxeOQTK32JfwP+Bv6PmL0KYSBXTxmjrOmp9Kr2tGs?=
 =?us-ascii?Q?psQGCvjrx3Jo3CYJhVbLhYbSwoXo6Tc57eTuQ7hY1geOm0UM4Nu5jC5PSa+t?=
 =?us-ascii?Q?E840UDM4Dy7WiX/mwcjWW4rj3E4BXT9bxMW3hNjGblL/1C2blALh1gBYQhD+?=
 =?us-ascii?Q?PQzBt/9T/MqxcV2LmRPOI7y5BtRRhGUNHvNk2GTZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdebb583-8eac-4085-d1f7-08db4a03efc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 05:21:37.0767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iEqTzYQMflFypymGsTcXqYwRis+RAraCgloWeIL0+A4MW4v5ARoASjc4TWU5o0lA86rljSp42VmhE504/z8Hn17hrMojb8GEm2gcpnflGvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Xin Long <lucien.xin@gmail.com>
>Sent: Sunday, April 30, 2023 5:41 AM
>To: network dev <netdev@vger.kernel.org>; tipc-discussion@lists.sourceforg=
e.net
>Cc: kuba@kernel.org; Eric Dumazet <edumazet@google.com>; Paolo Abeni <pabe=
ni@redhat.com>; davem@davemloft.net
>Subject: [tipc-discussion] [PATCH net 1/2] tipc: add tipc_bearer_min_mtu t=
o calculate min mtu
>
>As different media may requires different min mtu, and even the
>same media with different net family requires different min mtu,
>add tipc_bearer_min_mtu() to calculate min mtu accordingly.
>
>This API will be used to check the new mtu when doing the link
>mtu negotiation in the next patch.
>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>
>---
> net/tipc/bearer.c    | 13 +++++++++++++
> net/tipc/bearer.h    |  3 +++
> net/tipc/udp_media.c |  5 +++--
> 3 files changed, 19 insertions(+), 2 deletions(-)
>
>diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
>index 35cac7733fd3..c5d2e8c45f88 100644
>--- a/net/tipc/bearer.c
>+++ b/net/tipc/bearer.c
>@@ -541,6 +541,19 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
> 	return mtu;
> }
>
>+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id)
>+{
>+	int mtu =3D TIPC_MIN_BEARER_MTU;
>+	struct tipc_bearer *b;
>+
>+	rcu_read_lock();
>+	b =3D rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
>+	if (b)
>+		mtu +=3D b->encap_hlen;
>+	rcu_read_unlock();
>+	return mtu;
>+}
>+
> /* tipc_bearer_xmit_skb - sends buffer to destination over bearer
>  */
> void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
>diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
>index 490ad6e5f7a3..bd0cc5c287ef 100644
>--- a/net/tipc/bearer.h
>+++ b/net/tipc/bearer.h
>@@ -146,6 +146,7 @@ struct tipc_media {
>  * @identity: array index of this bearer within TIPC bearer array
>  * @disc: ptr to link setup request
>  * @net_plane: network plane ('A' through 'H') currently associated with =
bearer
>+ * @encap_hlen: encap headers length
>  * @up: bearer up flag (bit 0)
>  * @refcnt: tipc_bearer reference counter
>  *
>@@ -170,6 +171,7 @@ struct tipc_bearer {
> 	u32 identity;
> 	struct tipc_discoverer *disc;
> 	char net_plane;
>+	u16 encap_hlen;
> 	unsigned long up;
> 	refcount_t refcnt;
> };
>@@ -232,6 +234,7 @@ int tipc_bearer_setup(void);
> void tipc_bearer_cleanup(void);
> void tipc_bearer_stop(struct net *net);
> int tipc_bearer_mtu(struct net *net, u32 bearer_id);
>+int tipc_bearer_min_mtu(struct net *net, u32 bearer_id);
> bool tipc_bearer_bcast_support(struct net *net, u32 bearer_id);
> void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
> 			  struct sk_buff *skb,
>diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
>index c2bb818704c8..0a85244fd618 100644
>--- a/net/tipc/udp_media.c
>+++ b/net/tipc/udp_media.c
>@@ -738,8 +738,8 @@ static int tipc_udp_enable(struct net *net, struct tip=
c_bearer *b,
> 			udp_conf.local_ip.s_addr =3D local.ipv4.s_addr;
> 		udp_conf.use_udp_checksums =3D false;
> 		ub->ifindex =3D dev->ifindex;
>-		if (tipc_mtu_bad(dev, sizeof(struct iphdr) +
>-				      sizeof(struct udphdr))) {
>+		b->encap_hlen =3D sizeof(struct iphdr) + sizeof(struct udphdr);
>+		if (tipc_mtu_bad(dev, b->encap_hlen)) {
> 			err =3D -EINVAL;
> 			goto err;
> 		}
>@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct tip=
c_bearer *b,
> 		else
> 			udp_conf.local_ip6 =3D local.ipv6;
> 		ub->ifindex =3D dev->ifindex;
>+		b->encap_hlen =3D sizeof(struct ipv6hdr) + sizeof(struct udphdr);
tipc_mtu_bad() needs to be called here to check for the minimum required MT=
U like the way ipv4 UDP bearer does.
> 		b->mtu =3D 1280;
> #endif
> 	} else {
>--
>2.39.1
>
>
>
>_______________________________________________
>tipc-discussion mailing list
>tipc-discussion@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/tipc-discussion
