Return-Path: <netdev+bounces-62-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8D76F4F2D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2693C1C209F0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4FBA21;
	Wed,  3 May 2023 03:37:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5FF7F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:37:22 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2100.outbound.protection.outlook.com [40.107.20.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524D9268C
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AE1x1grlOogXkK8q1O3IGOBoFNNr+d6cVNs7md6AbxURyjpdXB/OtfZKxNVSXnLxJhBQEwHoFlA4Iy+sJFvbtGzu1VpMEDl14uoLS73aa0zXXOdYIpWmgzRF0NspR666Wo4X4z9sJCqiCAL+6eOOseKirD7h3pn5lrZ1XY8t3YpK9JQvD1uZqRAiTVuDiT6kRHqbdkILe7f8ODrnQLnYUrG5PNLq1RFt2bVPc0EmeUBQWc0FZ/eBtzKPjCizkl9im7BJ22cM1YCea2BOypq1pPfsk/mJ6ymDNzoEwEaoNSAtuXTUiLo+TDSQHDLljSWFAL1doZa5VnENQ/9Dp8VNyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPE0SoL9qKKgXHnb/YJVnGzt4ODNhNg3fsgKw1FWl1I=;
 b=T04XmcnTx/zGAUCajQUWWp/32WTKQHZrKlIS7l+C7fUilab2jqUK/fo2KyoEp1AEyjvTbO4++SyA+Fr0f0xh1OkhxUqYVwBrTCYdrGE1fTGgANvsl+PbngrtfIXkLgNANUZ3bZpkSydHHqIGQC6bBnDvZxbGgCVYq5tOO509NJg4OsungNBhoqIgtOOcndw73bFo+lBSh05svrfSBbb0zbV88+L2uNWO+VnZ2xqvdSIKFSOXPZfO9ulxNGg9tdj00D5AKymEChbdfSPEhjogGgekFWITpZDlLTAjbf761JEdm4nj61GSTQxyjgUNNDm5+tD7ARb0WBvAtTauod0r8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPE0SoL9qKKgXHnb/YJVnGzt4ODNhNg3fsgKw1FWl1I=;
 b=ZNQRq4n55F7CGGUdxzEgTSRbWW6tyPI9T3y4d5QmlksCvV6BM2F/+ajhQwCsUfLJSq6p36HR+dQyRyRWBvccHSWZbM2JamVcLKFsTD+BfCsvmS29YxK7InIodt9Q1WHgBKAS3VppJPN7p7D5CZGQzL2PepD94wh94KfjRJTXHkM=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS2PR05MB10770.eurprd05.prod.outlook.com (2603:10a6:20b:644::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 03:37:18 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6363.021; Wed, 3 May 2023
 03:37:18 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: RE: [PATCHv2 net 1/3] tipc: add tipc_bearer_min_mtu to calculate min
 mtu
Thread-Topic: [PATCHv2 net 1/3] tipc: add tipc_bearer_min_mtu to calculate min
 mtu
Thread-Index: AQHZfUNOCng1REB9sECXjE/GnkdoHa9H5RNA
Date: Wed, 3 May 2023 03:37:17 +0000
Message-ID:
 <DB9PR05MB9078E51851B2C67489B2BC02886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
 <8e3827ffaf71c0636541c01f76ff3a65868433ea.1683065352.git.lucien.xin@gmail.com>
In-Reply-To:
 <8e3827ffaf71c0636541c01f76ff3a65868433ea.1683065352.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|AS2PR05MB10770:EE_
x-ms-office365-filtering-correlation-id: 06c6be2f-562a-4ead-aab0-08db4b87b1e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 9F7D0KYCiklXXUUA6jm4rhXmD1BV3uPOhGcGlMfQLVzuo+JpB6MN7wKplcZ8jG33htoJPpGUL1Eud6AX5n6UcxFkfPdwcxCxGeNcigbLYq3E3JIJ5aaKCGtDGxb+m0S9H4NQrKBZXzKYnQYiWa0cThG8pN35hJ+zAe/vBE8GguOSp44ZWzgt+VSPehWY9VmCeAlSZmzywtGcVR41aGH+BcxuStSUB/2zLVwak4EMXe8Ignq0hsJmsBwBLgEgqLBetnHwLnTqzmt5pb+smEEH9JdmKmodp51JHOCfQ0TdaLcS5eYVSXkJcn1VlH83TG8lZTM4S2DaulDmIGM8OQO0+q9cr0/kd4lj0zKmIUmChw49Ktd8+1SVh0llYQKodU7o7jZL/a7aklUEGF01GH5TZvTBaWPzuYE4BspF/dkmfY1UE55ortCQs7llgIA/71UOTelWrXJtjBW5v0CmJrFYswLLe79e9ZaH0NEDIShBGBv8CiDWjRSVwtHjIAfq0k7OA2xpcqsKVHPpgNeitnvupr9LS1Z4Kw40ILC24EXRRf4NBfRMxKaj5vh3m4ylKaXQfwphPsap3P+ZNlHdhWuRoFehzyRWPKLiFp9EmRzvWBSJUhCyYehqMugMvEDHZvPw
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199021)(5660300002)(52536014)(8676002)(8936002)(41300700001)(316002)(38070700005)(86362001)(33656002)(2906002)(38100700002)(122000001)(55016003)(186003)(76116006)(478600001)(83380400001)(7696005)(9686003)(26005)(71200400001)(6506007)(4326008)(54906003)(66946007)(110136005)(66446008)(66556008)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GL5xH2ZXKbH0/2CGIddag4yC+K2HQkyZZk+H/fg/oCvc6MVQpRgaJH4Ze3o1?=
 =?us-ascii?Q?QoHqZr4IFXi2nkhpZZCaRmyC8tqHtUeyFKrnHpCwMh6kcRcqzk7WEym0nQin?=
 =?us-ascii?Q?4Rj+72yVH/9Xm1ZpSBw1zps6wKpZDpbThv/LeMf92uv2ZwrtK0mnkMC3vN29?=
 =?us-ascii?Q?tCHVX8aT83urmHtgIdrKIpyk7ACYabeuz+zkWyJK6AfjCOG1UynSS/CjhTj1?=
 =?us-ascii?Q?7xnLllwgI5FzBx/3PiLOAGdqXbv0taImxmFp8geOuKPioXccpokJeE39uTmW?=
 =?us-ascii?Q?h6X8LnTU26SQ4kVBfkxns+5omPgEjW359ZwV9E28HLzg5EsmoiU64Z6KpUTO?=
 =?us-ascii?Q?u7AR7q5tbKqnDZcA9kxaPR+ey/dHpiowWs/fMTQZyKGfwQqfc7wh+9ZYAQUj?=
 =?us-ascii?Q?vy9ltfuXFJEQqWI2WA7YAIMgE0MTjdb52z/c/E9k62VA32z4zeQFp0KMTwfM?=
 =?us-ascii?Q?0cjP1T4uokALGj5QzAVVQaK33RDHAPJe1k2ZOXR4lr10zVWClVHoqWsb46lq?=
 =?us-ascii?Q?54XDzXcYIDRjGzdty9pzvyzaDCN90KtJasxEzunBbsd8jW9TgKSlpJO1xlPv?=
 =?us-ascii?Q?6/L+eZd1xtDfD3ZIFklD0shxCGJz+nXi6gzPAz3FcSWME0yL8cSWpaWyJeGE?=
 =?us-ascii?Q?sDe92CpgEvQ70kVpZaoT8ji3A8YvB/nxnenOSOqiy06NAitJNzr3SN+lb1KJ?=
 =?us-ascii?Q?iJeyEV9bMNy+PzC8iPOukkrgfqjnqdkKe2aagyjN9oGVkPUradQjCkCxsABg?=
 =?us-ascii?Q?DiXuIkGJ88Vwv/zcsf3CFsklcR7DzWgxYHU6S83QkipkNPVYbossWDfa1F0Y?=
 =?us-ascii?Q?NvPQ31y/4m0+fzsEHxCa1rmM2BDaOiCaWPM6mf6yBMhz2r50SJgdaCUbQ2Y7?=
 =?us-ascii?Q?ffy5yU7pas8QTQRhDtwfGH9SuPuVNFJUDQGJB1pgyolN/TQd5GL+9vAmG+OQ?=
 =?us-ascii?Q?ayja/QbNZzJuQHDu3mLndBe0eKpFphVN5ZC4W+XofHCAX3Ks6GaD0TbSWk3h?=
 =?us-ascii?Q?rHVm5kimHE96OPJoLd5Vx2l2KUod7hDgqq8bcgxS+TN1AlgLMUkx0dUtHhHy?=
 =?us-ascii?Q?Tt9NRDr5hF3/xyxRusgap9bAEpuiSzOvA4BBP4GFDl7KEQWMdVUoh08rMDdO?=
 =?us-ascii?Q?8vu5A0dKq5oO82Hrb/a7+Jks5pJbDr8yMJGEop0S0mzWXYv8/w0nD7KQfRw7?=
 =?us-ascii?Q?56Z5vT7CgbDD7QfdgtbXY42nDZguldzWvPZ3OaTzzO1YKCFtaG1hXDdJtDiF?=
 =?us-ascii?Q?Tp2Ay32gurldwtE3tupGw0QzD7+wYHhGrVvyIwe5W6pi/AFzL4it4aZDhJrA?=
 =?us-ascii?Q?WbxIGY7Wj+iYxgVqEiUS1Ludr3h54Yxw1W6AAD7929aa61RSHVSlQgVPAwWz?=
 =?us-ascii?Q?c0nogqSk6nN6YqeLdSlbikrnMElTooSuol3GYhM38BNcISpX6dPe5jTz0uN6?=
 =?us-ascii?Q?M2YqfD5PEvO57vtSEhCxTc7OGB/JFO9ug7Kjo6KtsmxU2hl/iVmGW6666I5C?=
 =?us-ascii?Q?oZpS7Pg73cAmgnZ+mfWmmzTG3GXt9Mm/xqwP5NEkzXlLMigABqfnKilkIGit?=
 =?us-ascii?Q?V+Cc07AAqipsU92mszeddA5SdSILEZfqLzfO05Kb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c6be2f-562a-4ead-aab0-08db4b87b1e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 03:37:17.9950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z+G7uVV1ATsELX2mNsOQusuU/3jybnxABd19+TcXGNTW4diO2vkJy7MURa7GH6GWHw68EiiV+oiPCGB//wUdP2Lr46aiDJsTO22HY0JDJlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR05MB10770
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>As different media may requires different min mtu, and even the
>same media with different net family requires different min mtu,
>add tipc_bearer_min_mtu() to calculate min mtu accordingly.
>
>This API will be used to check the new mtu when doing the link
>mtu negotiation in the next patch.
>
>v1->v2:
> - use bearer_get() to avoid the open code.
This version change comment does not seem right. Please correct it to avoid=
 confusion and put it after "---".
>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>
>---
> net/tipc/bearer.c    | 13 +++++++++++++
> net/tipc/bearer.h    |  3 +++
> net/tipc/udp_media.c |  5 +++--
> 3 files changed, 19 insertions(+), 2 deletions(-)
>
>diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
>index 35cac7733fd3..0e9a29e1536b 100644
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
>+	b =3D bearer_get(net, bearer_id);
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
I agree that calling tipc_mtu_bad() is not necessary for UDP bearer enablin=
g. You can remove it in this patch.
> 			err =3D -EINVAL;
> 			goto err;
> 		}
>@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct tip=
c_bearer *b,
> 		else
> 			udp_conf.local_ip6 =3D local.ipv6;
> 		ub->ifindex =3D dev->ifindex;
>+		b->encap_hlen =3D sizeof(struct ipv6hdr) + sizeof(struct udphdr);
> 		b->mtu =3D 1280;
> #endif
> 	} else {
>--
>2.39.1


