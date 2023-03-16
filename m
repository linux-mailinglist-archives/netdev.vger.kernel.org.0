Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC66BC77B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCPHll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCPHlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:41:39 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2081.outbound.protection.outlook.com [40.107.21.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA51C8B060;
        Thu, 16 Mar 2023 00:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OD0blXNhae6rYAhjay3IxGyHgvyQeDxHm36WuNzVf8t5Vrywas/forrdXbJ1FEzm0WiQOedL/dMulxuCtiL0isd6lafZ7L0axmL3ETVGA1cQWLDba36Mt1FijwUgKPqHEGETnrQYq/n9HTpCMUjW2d+d9zRjq1MnHt1Ybv1qSKvxMYwfo8F06T4xVbv9jv2K9yzWqUJ36S9TAitcNUXeDZYw+A65Z5WPMoxAwVmXeJHTlElQeORk6NpLy4jjUKyLwl45iFdhp7kzMDY3e0JvtCSJggLWl3N3gluYtyR/oCfhc6wGOm01vQSvXoLWg8N+eXoeV13LDY/BP4yFI+WtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=926PGXAwZhjo5Bui61WOJoOU9yT/sRsmJ4epfpXg+QE=;
 b=E8Fm4bUK1y4E/46nd1ESsLmSpjnWuGPfJwgNUUIcsusy3rWg/vUjjCNxlYTPFInSZEDMB7yd9bmC/KlGY9cy57EUF/vQD28YDvat3OCla9Nee4O4Ha7MFTZm0v/EHcPO9/1VAmoGVlHJ3/Anm6Q41hsmIAk7d7k+8NF4rGlHb1+b5wfYK+qUtzUXAa0YS3jPtEAcyX0xYd3KIhQn8ajmFfTU3bg7zD5JRuLphAV82vhlg4pWHJ+5pniU5YBSMVlrNnIjqfgyYqV8DL92GuiEYsfIRzHtbU7MEFU9+LVsAJbjl6yVExOiMtN99Ia8Ruswpw3MjAGu1ISSvH5gLtM84g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=926PGXAwZhjo5Bui61WOJoOU9yT/sRsmJ4epfpXg+QE=;
 b=sRijDo4yq7TkXgyFPc3vUoi9l+y6A6tLdcZ33qCHpxfznAuEzKj9wcXSpytY12v2WrgAww4XYNAg+Fa3Qob4lLyRZg/Yt2+M9TKE561A6Ee4/Hc8LWDaI8hbVrjtdy65VdIql1OFjmShAA7IV66GF8fn5RWksXVDaxyMXk3t3oA=
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by AM9PR04MB7539.eurprd04.prod.outlook.com (2603:10a6:20b:2da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 07:41:35 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%6]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 07:41:35 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     "gerrit@erg.abdn.ac.uk" <gerrit@erg.abdn.ac.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Vani Namala <vani.namala@nxp.com>
Subject: RE: [PATCH net-next] net: netfilter: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Topic: [PATCH net-next] net: netfilter: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Index: AQHZTbSXHQfRkdayhEKdipmUdtJKx679GGag
Date:   Thu, 16 Mar 2023 07:41:35 +0000
Message-ID: <DB9PR04MB964855E6E7E29C333282170EFCBC9@DB9PR04MB9648.eurprd04.prod.outlook.com>
References: <20230303094221.1501961-1-madhu.koriginja@nxp.com>
In-Reply-To: <20230303094221.1501961-1-madhu.koriginja@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB9648:EE_|AM9PR04MB7539:EE_
x-ms-office365-filtering-correlation-id: 4a9b6061-6c8f-44f7-7c7e-08db25f1de62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fJUTyAPfkeim+g3oYNV0mVDBE6YYoTk7RY/9VR4LKQyg69Z197osgHZZfB04syKuu1T347wEdZLZsOimre3a9hfyJtI6aJ7hmnBPWG/691oXFQnxaeVwm4C1BQfHUDF4kirXbkJbq7slOV/+SfFoE6MZg25GZU42RxJLbclwJv3t1qMHJNFv1SAROim5ZrURyiCne1+NeL/4FjPHMuPhOf+9/KvySVZflN864lXORpt3Cl014EiQnL/C5fQWfZAKUO714clSrtu8l3iaG+LdAhquV9jBzFErcHEDJOJe7dVFwZpZvPsE7fkKUtdcaWDF3JTYYDmgG3e+WU46ToT0JhIjp6FJIU5vXp1Z2/QmIMBRL61ZctCjmHvDv/ECoiOhIuC6g2NBDkC92nT4NW1XUCK2pLKUOHZoSHfqRPc1tJkvWedOktyiFeD771b3Rj3odAPLNqw0MIZM+Ub7+t806WNzfRIHuLd51LWklxlPtW1482vTtGZ4tdbXFewW8JeVjprjC2wH98UJPeFhY026BDTPJJnC+9aq7LKAiW5zx7g8hFxf4/UlvOi93EwYEryGi5KEn+MBcN9iX9naVnvCwsfvvqA1zkqHNWgVCWy7tFO9/zTtA4qdBaCjRPgyxfbV6jYjwqUDdqj10hpyRpmZ+hd/vvC8yqEpS0OhOWte2jJFTWgOqDyOGmaDnITKU0nDsNj423NUbXP2puXXwelgzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199018)(38070700005)(86362001)(33656002)(38100700002)(122000001)(2906002)(7696005)(44832011)(52536014)(5660300002)(8936002)(41300700001)(4326008)(55016003)(26005)(9686003)(6506007)(186003)(53546011)(83380400001)(316002)(296002)(110136005)(66946007)(66446008)(66476007)(8676002)(64756008)(76116006)(66556008)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XWK2QfW+Ifc2Fv1/epcyRllsXOw5RfHJAHxt/z0YMmUgVXCB7hzTVJrwTrTP?=
 =?us-ascii?Q?7W8WeMMFTmJZm0yh5iT2UjcXX11gd1KA8GawIyb9KOm1tFhiIKckn3dJwbeo?=
 =?us-ascii?Q?VC/1mT6p2I7KSn/etxYjNgJuptX1Nq/ChqM9CngmioVDrbfkY2YqEXE3B5l0?=
 =?us-ascii?Q?mTb9Gvt2o7DVYVnZH1+M+JjlOVgzzU66lQv1GbT8DjyInh5zL9DKiUzRKLS4?=
 =?us-ascii?Q?139qy0XUKtpnWH+UwYgYTD9q/pFWR4CukZ6EdPxoE6apv0nEaYvbqIwA/6lH?=
 =?us-ascii?Q?eI/xEmHgxyZE2SL3kXl4xnsVFCUnCFSmv2urtEiygkM6z0S+bGCwFoWdM2o1?=
 =?us-ascii?Q?EzCVqPcFOa9nFVSAWxVk8+MuyiUk/7U+NhSvk623dHoe1P7nAKT37tivr8BF?=
 =?us-ascii?Q?f/1O/YpeB7cYLHe7JxBBl6vfikToMh5/5SFoXQI3u1O3Vju7cyul+mCbvtTu?=
 =?us-ascii?Q?vEutWeHklZ2iX7jQPcdFYKw/39bRhnrCWpLcHNM43I9AsaXjeGle+JwJ/rBZ?=
 =?us-ascii?Q?x0pcc/0+IjbHW/t2+DxYC1lOTpD9/ooocyCfc7I4oLTKLtSMeq6GB6TrcfXq?=
 =?us-ascii?Q?Qdn7qGKG6dHx7oquI7UZWtYlORYU/0q+CsBaYDKv6QONgImlMPzQ2ZhCfpKS?=
 =?us-ascii?Q?D39GbCatKL+Oz0wGmmKrcwZISIVouwWtCcFc4lMUD/vNDvrgFMV9dPlPjy1Q?=
 =?us-ascii?Q?cQ9WbK9jR4sDIPNRajglFQJ2hd3CLAPf1oMWpZlmsPP3/rrNjYTldzQszOKb?=
 =?us-ascii?Q?U7vkawzp4PrI8B2i618QmbqX/pL83DfMGSeXl/o/HXzrSuG33fyhCu/drite?=
 =?us-ascii?Q?a8LRPEO4UfjOAJGLhkqOXmbN02/k5L8T8lpCuK9hhXwTI+BuwveWhgJEJgHD?=
 =?us-ascii?Q?9yfldjmqhGlqmOmZb5T6sCnA+izq6oovdo6Wja/gNR3osbXh4CgxJPr8db3c?=
 =?us-ascii?Q?noADyDLmIwBNRysfuCnmQg03x3nf17dGf7FA7pFTwxzvq4BwwIMbHoa1E90W?=
 =?us-ascii?Q?vtufujYLZy1vYvLTWAppLuGt+He+2bxdHXIj2iJ6WXc3ZJhkZ8qnnB71BSVs?=
 =?us-ascii?Q?tkiUUvxWINzuSkLLRyH1RFiyJ+fkTTPUCOYhQMNOaRtnfuA0YcdgHIfnND1J?=
 =?us-ascii?Q?59DG39Jap7cCjkXSsR3c0ioekE0RFzNqbWuGvziaidijovrzDx0M8DMW7aNV?=
 =?us-ascii?Q?PfDjebrfh1a35HIWrR6KYIElc9hYcUNiT1fHYDgeaRBfiqv+qzMwXtsjJloW?=
 =?us-ascii?Q?4fVgBCfkY0HtZinxEAQEFlSv/ErjUjZqttwnq+sG1HaxJUJ2nSqZBjpWZ82Q?=
 =?us-ascii?Q?pIFYiKfrg6+arlPYGgUbWnuhSv1T9TvE1hL3dER5+IqZNj0XIl598+ikhGln?=
 =?us-ascii?Q?ioE0thDhruR9zrrywOrphJYqiI6k+oMGUMd0o3AqYmyPk9SGD5WLYLyvNYcU?=
 =?us-ascii?Q?0xs8XfETscFsRhylrnC2DQgYAdrKznWxXbFTsVAkmTIuTg8X8ZuW34qqWgMl?=
 =?us-ascii?Q?mYhnWZ1nRIK0T4S3385qd+6SGrKcw8tnHhAHnprItbpMStLQwehMNNveck9C?=
 =?us-ascii?Q?lMwbXzriY2v45DnWQXi99DhS0mRMiXH80ImbWLRU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9b6061-6c8f-44f7-7c7e-08db25f1de62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 07:41:35.1243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YmFxatR9YAO4qQICWFBx0AxKrQQ8YuHmy6eaT6YTTZsI69O0tu4zaPlkXndybs5MF0AZd2f5niWBK/2EgiYTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
May I know the status of this patch, does this patch need any changes or it=
 is ready to go into Linux. Please let me know if it needs any changes.
This patch is already reviewed by Florian Westphal <fw@strlen.de>.
Thanks & Regards,
Madhu K

-----Original Message-----
From: Madhu Koriginja <madhu.koriginja@nxp.com>=20
Sent: Friday, March 3, 2023 3:12 PM
To: gerrit@erg.abdn.ac.uk; davem@davemloft.net; kuznet@ms2.inr.ac.ru; yoshf=
uji@linux-ipv6.org; edumazet@google.com; dccp@vger.kernel.org; netdev@vger.=
kernel.org; linux-kernel@vger.kernel.org
Cc: Vani Namala <vani.namala@nxp.com>; Madhu Koriginja <madhu.koriginja@nxp=
.com>
Subject: [PATCH net-next] net: netfilter: Keep conntrack reference until IP=
secv6 policy checks are done

Keep the conntrack reference until policy checks have been performed for IP=
sec V6 NAT support. The reference needs to be dropped before a packet is qu=
eued to avoid having the conntrack module unloadable.

Signed-off-by: Madhu Koriginja <madhu.koriginja@nxp.com>
	V1-V2: added missing () in ip6_input.c in below condition
	if (!(ipprot->flags & INET6_PROTO_NOPOLICY))
	V2-V3: replaced nf_reset with nf_reset_ct
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 12 +++++-------
 net/ipv6/raw.c       |  2 +-
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c index 1e5e08cc0..5a3104c7a 1=
00644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -771,6 +771,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
=20
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset_ct(skb);
=20
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c index 3d71c7d61..2=
5ff89d9f 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -378,10 +378,6 @@ void ip6_protocol_deliver_rcu(struct net *net, struct =
sk_buff *skb, int nexthdr,
 			/* Only do this once for first final protocol */
 			have_final =3D true;
=20
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset_ct(skb);
=20
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -402,10 +398,12 @@ void ip6_protocol_deliver_rcu(struct net *net, struct=
 sk_buff *skb, int nexthdr,
 			    !ipv6_is_mld(skb, nexthdr, skb_network_header_len(skb)))
 				goto discard;
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto discard;
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
+				goto discard;
=20
+			nf_reset_ct(skb);
+		}
 		ret =3D INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
 				      skb);
 		if (ret > 0) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c index dfe5e603f..c13b8e0c4 100=
644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -215,7 +215,6 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int n=
exthdr)
=20
 			/* Not releasing hash table! */
 			if (clone) {
-				nf_reset_ct(clone);
 				rawv6_rcv(sk, clone);
 			}
 		}
@@ -423,6 +422,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset_ct(skb);
=20
 	if (!rp->checksum)
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY; diff --git a/net/ipv6/tcp_ipv6.=
c b/net/ipv6/tcp_ipv6.c index b42fa41cf..820aa9767 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1586,6 +1586,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff=
 *skb)
 	if (tcp_v6_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
=20
+	nf_reset_ct(skb);
+
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th =3D (const struct tcphdr *)skb->data; diff --git a/net/ipv6/udp.c b/ne=
t/ipv6/udp.c index d56698517..2be1364d0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -604,6 +604,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, str=
uct sk_buff *skb)
=20
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
+	nf_reset_ct(skb);
=20
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb); @@ -920,6 +921,7=
 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
=20
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset_ct(skb);
=20
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
--
2.25.1

