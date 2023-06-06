Return-Path: <netdev+bounces-8385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AE6723DBD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CF3528157D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6F3294E2;
	Tue,  6 Jun 2023 09:35:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B384125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:35:35 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on0721.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::721])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3CD126
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:35:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW9ztsE0/HErPR6BUIRTvncaceK5rwOVT74YPPe/mx6IwKTtlzIDtD3c9btBD2VAtX3pTQCc9JXuAh+u1FkWtHdb1pcVTBOT4XgCo+MMaq+DkjEnsJj60PWbRfRxWNgUkZPOj/PyojFPyLQ4CHww3JcEcVo7ADSi0hezy88X9OWYxhSIQ0KCs58tQZmXmQlVsiZBf702u2Oxoj+9ergMedXYdXe0YUdEpDVbE8rKNG4PE6EupNOOfsFrAx5vYLfOUjE2ZV64qD2mRv7W1xT0di0KHU613uSr+CQuH21HXnwMx8eE8IohWB/keJb5cAcT25MS1N6CtDpSc54Z6GYbTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Gl6GL28dVN+ExbdXXi1rU9ZPEX46q30BFQ7Pqo6DrE=;
 b=oe6iLRZVPPmNg34vgjqdmHElE1SAGiU9/T3GQjpy+JgPyuT60GACpt6rYnJ7dSvHeTVpGRtBLM0DRaaT6kMO83yyD/8+ZLVSM7UUNRw3UqCaZ6rJs5H+rJHCqjsNdV5B6Cr57ktBtrkGWds8ZIbG9lJUwdi2EJocisPwVzQZMn8gkQteLZrc2Cm/jJGW8EapH0h4iwkHOf1DFNwa4lE/i4iexqUUpvAj2YW3Vc6g6jAe7s5gTYZ/zXCBTcBjmzjex0h+NcxHOCtGhH+DXk4n+2B5VX5VumgpEbIgFg23T/HjrhB7qbG9ww7QdqMoFAtYCynnBRgMJV4moNorqUpbSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Gl6GL28dVN+ExbdXXi1rU9ZPEX46q30BFQ7Pqo6DrE=;
 b=O0YjjPWqsTOTRiRKFTJEgHIJ9N02+zIQuJp/F77fTFSzmIrLYe2URXz5x9MvZf1sTB1Ay1kVCAC1PZ4Aal+LgQqGfxhxbX+7Gw67it8HpmmQWUbjuKyu0o8y/HnFOK1EMFwAA05xJYuBsTeqOoRWo4DwLAXcYrfsfWcdbE4pkFY=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by VE1PR05MB7488.eurprd05.prod.outlook.com (2603:10a6:800:1aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:35:27 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:35:27 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: RE: [PATCH net-next] tipc: replace open-code bearer rcu_dereference
 access in bearer.c
Thread-Topic: [PATCH net-next] tipc: replace open-code bearer rcu_dereference
 access in bearer.c
Thread-Index: AQHZl7u5E1FWjZeUk0qr3XUaqpEC5a99hLfA
Date: Tue, 6 Jun 2023 09:35:27 +0000
Message-ID:
 <DB9PR05MB9078509738F92193703C464E8852A@DB9PR05MB9078.eurprd05.prod.outlook.com>
References:
 <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
In-Reply-To:
 <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|VE1PR05MB7488:EE_
x-ms-office365-filtering-correlation-id: 1604b385-334f-4794-d3ff-08db66715cb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4hxQJa8vVfNJQ5HvYUXH0hnGImljnyyPw9Ral4CWtb3e9aQudM4eeq6QzTXmbVZUumj/C+foo0yBxm3bHMHr4LHB/4di/kWhcvSdm7FhFtYnkPLQyi3ijXhGga2qkmrg+IgyjKhnS6ivUiR/ku4CDNPZik3rtEJYkGg3K3LjTUG16umcWQLhLXkwJ+mF9W/5eFCGuYoOVFMtVf0+WUE8ooSjYqRKm4sQsgVuNHPj8r1tvec5Isny9t3Z52qQHuFxbhNlaPhYNaHGUoDArFn/o8XdXZmlbQdXPLs/1EftavnQvpa9r3vtKSYDtnCZ+aNeOD3UgtjuXPqKQnOOLvX5+plQK7PBz1WGfYqusFISezCVarN43Og1kIMhkC6eION7ITBa2eqbSeWuzyI7MGXn8Og8JLL0Gs/ibmfB5CBQxvP+BCEsoAvvs3O/HdVehv6AtsFY9nUVPrxRUj4k4YSMCfB+oZp6wiRabcXPtSadnn2jQjDMn1RaYQekE8zdKN2dO4oPYFR4Om7kGxR8CYIxXtp61TNrx2Zl9APbBxmB28o9ax1kIU0a5KS9pTpyTZLfm/EGw6/BWrh9MrL5cw9yyH4OHSbDru+65r3Lx0Qcs3Qe3/6FLpF13acJmcc6K6O5
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(451199021)(8676002)(8936002)(7696005)(478600001)(110136005)(54906003)(55016003)(41300700001)(52536014)(6506007)(5660300002)(316002)(66446008)(26005)(4326008)(64756008)(66556008)(66476007)(71200400001)(76116006)(66946007)(9686003)(186003)(83380400001)(2906002)(122000001)(38100700002)(86362001)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?pvdIAGK59uxertXFx4D6iTvTHjm40TrMHqcLFvpUWHPONyG6auLZ+GGZ0vV+?=
 =?us-ascii?Q?rat01SKy1b+6SlxfcA/JyHj/xkyVKSkyAK4zNPPfTkFJmBps1vpBT9V93bF1?=
 =?us-ascii?Q?5fH/x6r9STd1kuRy+uQOkivlBVTo1R1Rel1bWKI2SOPcm5fFPhcnmTu1w95y?=
 =?us-ascii?Q?DQ8rFQrQpgNm6Y0J02k3m8jw7XBpRjrjYHtA2JpfkW0Y3taiTQeNpEy8aJtw?=
 =?us-ascii?Q?S27Y8rRWc13bmQm4olbmUAolMo9VUp4sJsRTtJiCm446Rzl66qDonMFbWV+y?=
 =?us-ascii?Q?J1ZEK5JIHTYuf80Sc936154XIwYiBIwo5seRPbeGaParNR7WQ0Cc83n+/4QL?=
 =?us-ascii?Q?KAagw5pWY7FSlQ8I+UsxGhCTxuYTxXgzZZvEbBUdp4ZVyexDCMrBlMux17R+?=
 =?us-ascii?Q?e4e/L1pw+Mh+NGu6pb+iS+mYKjVfm5yRQwF7TplYFnZ6rHBy2yROocxry5S9?=
 =?us-ascii?Q?fQAUexDJKz12sylqGBoGOwdS3GR0bosi3we1riXi52DFBYmaQaTb5lKhnYce?=
 =?us-ascii?Q?VH6dIRjq6s/P2lkjwunbCh8SEqSEPqO7/RGDQnm4oQxbapLjNd6ODT+fCMrl?=
 =?us-ascii?Q?SZlY693ZqfBFMwZ2p4ZMCJu5/bUW/8Omq7yJlLh7BvkUhYJcl5YTbcr2pjW6?=
 =?us-ascii?Q?rmkucuiMCZhPxBd5sRiQe2VEEjd7QEonkuK72zmGxKIioI996vAG1QObBOf7?=
 =?us-ascii?Q?LgA2PSZD73/CuCDF967E27jldklcompKcdxopgyHxn540DdXmjuU6KGD1/PV?=
 =?us-ascii?Q?CRn6YihkW3MX2kQEI3O29Xh+kMwHyflKmF4dpIm7lsONK7xMOWrLf0vZWgi+?=
 =?us-ascii?Q?GRyFhbB21+jtn5FtGTdL23PtMrBbZ0B5HA4XTKUmoqYKjhuLpuObEPoUPE/+?=
 =?us-ascii?Q?T07MXSpXEsCCqUHundo24WJx4ZO3L3wUnpRdiY86M1W8+CRzoGvljLyWL/aZ?=
 =?us-ascii?Q?LAj1edueSRZ0dhlANNq4G9zK+Aufj177Npcys7WJVkKfEtuEYv2I1+RZiaDF?=
 =?us-ascii?Q?rPdr39QCR0G1RcrbAi7gExE8HRiVutFhr9ShH9BbkjeLPpt+F26NACb1l2ZK?=
 =?us-ascii?Q?f5Nv7RD1YvRa5QfMocszj9qn7dUv+hXxL0Rvf53POj1oIcnL4iNhBt8dO4eU?=
 =?us-ascii?Q?JilImiOumE69nnA/rlUWsWfucwrZpQDSra9gt9HGaa86VKkHggRftuRmeKGq?=
 =?us-ascii?Q?W0Fh8/1tJy3brphwlDqnfNFKXSIqVlLV7s7SqQJo2ut7+0wap7/2+fBaFqio?=
 =?us-ascii?Q?Zh9NVjfgnxb1EFPZR5nezJi8bhCs5DIDPTcUD9HEyJ02FF0PGG76qtIgV6ur?=
 =?us-ascii?Q?1QyNHRT2kUgobZ5OgG+ppVhle+yt60LSvAmqN7RHPIdK1wB/a3f2Y8IJ+il8?=
 =?us-ascii?Q?tPXZquPeVM0dgxl1cKOOd+mEsp5dGBM5Kg3BIkpx64DRrbolexethf16ETnL?=
 =?us-ascii?Q?Emb7eTOXHAV2GGv/vq9NUDCTlFGTV1cIw6LP/Hd6d1Nbf4cjdoWF9h4co1J5?=
 =?us-ascii?Q?DXX6ca6D500rOZO7/yatbo0AMtM37RWBMx8AlrS2oYIl2S0UGCGjQ8fFtrki?=
 =?us-ascii?Q?e6Lsk165C5OZRe3Q15WFnikK1i4fKzvnhmSIw1bV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1604b385-334f-4794-d3ff-08db66715cb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 09:35:27.5759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+yJNzMszWxopgKOiGPlD/VBpqGVO4QZ1ZyZuZu9gg4jAcu8fS1RfNv7tT3CQA6owqFHSWV6d0qVzqmF4r1J/5HW5I1awCcaodqK05gdEWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7488
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Subject: [PATCH net-next] tipc: replace open-code bearer rcu_dereference a=
ccess in bearer.c
>
>Replace these open-code bearer rcu_dereference access with bearer_get(),
>like other places in bearer.c. While at it, also use tipc_net() instead
>of net_generic(net, tipc_net_id) to get "tn" in bearer.c.
>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>
>---
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>

> net/tipc/bearer.c | 14 ++++++--------
> 1 file changed, 6 insertions(+), 8 deletions(-)
>
>diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
>index 114140c49108..1d5d3677bdaf 100644
>--- a/net/tipc/bearer.c
>+++ b/net/tipc/bearer.c
>@@ -176,7 +176,7 @@ static int bearer_name_validate(const char *name,
>  */
> struct tipc_bearer *tipc_bearer_find(struct net *net, const char *name)
> {
>-	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
>+	struct tipc_net *tn =3D tipc_net(net);
> 	struct tipc_bearer *b;
> 	u32 i;
>
>@@ -211,11 +211,10 @@ int tipc_bearer_get_name(struct net *net, char *name=
, u32 bearer_id)
>
> void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
> {
>-	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
> 	struct tipc_bearer *b;
>
> 	rcu_read_lock();
>-	b =3D rcu_dereference(tn->bearer_list[bearer_id]);
>+	b =3D bearer_get(net, bearer_id);
> 	if (b)
> 		tipc_disc_add_dest(b->disc);
> 	rcu_read_unlock();
>@@ -223,11 +222,10 @@ void tipc_bearer_add_dest(struct net *net, u32 beare=
r_id, u32 dest)
>
> void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
> {
>-	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
> 	struct tipc_bearer *b;
>
> 	rcu_read_lock();
>-	b =3D rcu_dereference(tn->bearer_list[bearer_id]);
>+	b =3D bearer_get(net, bearer_id);
> 	if (b)
> 		tipc_disc_remove_dest(b->disc);
> 	rcu_read_unlock();
>@@ -534,7 +532,7 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
> 	struct tipc_bearer *b;
>
> 	rcu_read_lock();
>-	b =3D rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
>+	b =3D bearer_get(net, bearer_id);
> 	if (b)
> 		mtu =3D b->mtu;
> 	rcu_read_unlock();
>@@ -745,7 +743,7 @@ void tipc_bearer_cleanup(void)
>
> void tipc_bearer_stop(struct net *net)
> {
>-	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
>+	struct tipc_net *tn =3D tipc_net(net);
> 	struct tipc_bearer *b;
> 	u32 i;
>
>@@ -881,7 +879,7 @@ int tipc_nl_bearer_dump(struct sk_buff *skb, struct ne=
tlink_callback *cb)
> 	struct tipc_bearer *bearer;
> 	struct tipc_nl_msg msg;
> 	struct net *net =3D sock_net(skb->sk);
>-	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
>+	struct tipc_net *tn =3D tipc_net(net);
>
> 	if (i =3D=3D MAX_BEARERS)
> 		return 0;
>--
>2.39.1


