Return-Path: <netdev+bounces-61-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 920886F4F28
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D02280D83
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE3081D;
	Wed,  3 May 2023 03:31:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520FB7F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:31:23 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2123.outbound.protection.outlook.com [40.107.20.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D3D2680
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaWaTXllOKROljhX3o8dFaBY3dnjY5e18wycRqpEjY5GoafqywGKrNrFVv/GJ4q9SL76HNAFH/McbN3ykCQpknxmudYZNXOHJL79aYo12QEiSNEbH99YkSDe0HmP36cohiNifozAzU/Ay8gKUQIvLzIa0ZNQ6QnG0omMD86eQDCueCXnoBsbBOLAznklc9NEf0U5RMradT6Jx4NxaliTjoeDgdIN4MaATYE6XMmFEp5x9ZhrN6XiMExJn6AGIZG2yHLNuzeNtStddmdxIUDBEEQCviCBFGZw+WD6gRRoSvL3E8l+d0tEQhivcehACyEC0e2/SXskSDQ1Pou8354QFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lY077B91XB995wtlDQbzx+vtyascXhXSc2tRZPQd/sM=;
 b=nkc9GUNbf2Z2fPGu1Covd3CWfBpwH25Y6X4ZjEOTHavwn/qoS28DNh06GeHgU+mb7DqWXgXF6hw1V0X4ExQ8RI0YlMv5j4LBFf9Po2c912ZB6p3Q+6bXVfoZxVQpQdbF3E8FAaJRZ++3YidAWtbh3oknVNcLh4Yy0AYpxpMsv0GTh76wOasbwyllDOZgdUQNudXoCsPgtrNsJxY2n1ANw+HFkUIo87t38gAVoTtfpDssOkcD7r1lMieCPLgjMoeqZemnw+K2j7HrHSXaMQWfyL4W8opkaJqDQSkBo4W+Mx115fHsWPIodAuKkRM5kWQ54YgkNsAipjUq9sGPAwhQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lY077B91XB995wtlDQbzx+vtyascXhXSc2tRZPQd/sM=;
 b=JKPC6Y5li6VnWvyQ5j2yEf6sDtfwp1CKeilogKIUmCmFb4dHE8ToBhQwyX0CP/QB6k/huACnQv4hIsR2kRItvAciudhQIYrttStT17gJDyBrHIbDKksvIEvGcK8SU5GHRJpyfPKPD3F9/kYr+E2Gh291JSR/tUfrtUo3b6HI2Lk=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS2PR05MB10770.eurprd05.prod.outlook.com (2603:10a6:20b:644::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 03:31:16 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6363.021; Wed, 3 May 2023
 03:31:16 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: RE: [PATCHv2 net 2/3] tipc: do not update mtu if msg_max is too small
 in mtu negotiation
Thread-Topic: [PATCHv2 net 2/3] tipc: do not update mtu if msg_max is too
 small in mtu negotiation
Thread-Index: AQHZfUNP9u7Vj8HHr0O9d7iukbE5Na9H5ACw
Date: Wed, 3 May 2023 03:31:15 +0000
Message-ID:
 <DB9PR05MB90784F5E870CF98996BD406A886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
 <0d328807d5087d0b6d03c3d2e5f355cd44ed576a.1683065352.git.lucien.xin@gmail.com>
In-Reply-To:
 <0d328807d5087d0b6d03c3d2e5f355cd44ed576a.1683065352.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|AS2PR05MB10770:EE_
x-ms-office365-filtering-correlation-id: b44e984d-0206-4c28-13fd-08db4b86da26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 GbVJrY0+PT/SGlMOuBaFNzY8IozQjopqOYwQX2GuwpqZ7BHKMm30yoQ5z52IQpgsHjpGQRWbqCHS8bYeDgqgS99JlwKz8OFw4eLhbKh3CeUWjfIe1HWL9IcPbA7OsEPiHlI9/UmXBdCgpDHP6eUw38mMEboKUY1n3U0/z2R4OihYgwCYqy7K7GUBAOE+6Nh7gIYGDT+1G9A57Dlg+YS2z7uBFNI55/l/F0xHoiUsSrTkWrsrWyZSfplB5Vsrvj/m6xFlBo5CtdF+Qao5bFliLBxWZcOsoCw06dsHAPG2TZuXmVCzqvBA5fr2PnuBGE6/KVqOV6310QYzaWuBCdj9X/oXeXxHdoDq0Lgmd1crgGvOrrwbFKH6ApNd/1Tv5/UjsGwbFPYJs5CGBWLNhbn/2Nv4pLS7qtPepaTsT+rZv87Nm5d5tL/Wj1qAW0QZG2HEiC/m4329XjocCjZhcGMFsGzgdocdNgsTyOO7CTjl8hlbFgf7dXFYkomfLfB01QqhnzLpz6SazPqq5iRR5FeBD3yIRGM6sOSNujtgdW18BCImF9L4NkhV9CPoChQNCbGxaPA3GlH6TTOKC6vW9Hyg2CS6B/LtZXkTFeSBFqd1BDyGhdFcDeh3TrmJLzwpa7AFO/GSMJ1HmQitz/CXo6B6Bb7Hapu8ahgex/XwjfrsIOs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199021)(5660300002)(52536014)(8676002)(8936002)(41300700001)(316002)(38070700005)(86362001)(33656002)(2906002)(38100700002)(122000001)(55016003)(186003)(76116006)(478600001)(83380400001)(7696005)(9686003)(26005)(71200400001)(6506007)(4326008)(54906003)(66946007)(110136005)(66446008)(66556008)(64756008)(66476007)(160913001)(15963001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TEkPB+oyu/zCy7TL+M+pgmHPKuLz9834JWKGWH85+ryN0pfU1Y0byRucEVY8?=
 =?us-ascii?Q?r7pL5CmGAKG7KDjUF7UQ71FWsBEPHM/iR+zujul6M7H2XxZhYNhbF7e4ksjJ?=
 =?us-ascii?Q?idmKopp/pXIxBjed3hDM3f/u2uSRxwH/PwipGvizHtFg+IWhK4V05e0DyIG8?=
 =?us-ascii?Q?sDs13rkWBodU0mc9ZjorvRoQfNOgc4d7ki0oGrDYNwWLmYrG2U7CpyskqQr7?=
 =?us-ascii?Q?gYIP2mOwJSqHHbSPvp7IcCAfVDlzUtJMVFMuv4uoY2Vo9grCD3oE5iaFgAOh?=
 =?us-ascii?Q?DUOzcq/ry4zHttAn12fDh/qOKakYTSTkjJoSmMYl24AKiYNt87DkdXqfqgCU?=
 =?us-ascii?Q?1zDVFSG13WF8FaKHQKFy/9pBNF6tyGo1to9OFM3Ne/Xt6aJ7rfHobwm/tmLm?=
 =?us-ascii?Q?6tWy2FrceuLsySZQhxz9vNPBDc8/Gra05fWp9YgpKEJ7NrqwOwadOnlHExvo?=
 =?us-ascii?Q?FJZQ5HE93M+ou0/HqClOeiMPqp7M7SMr83ufKNk13xz5tGzUvJZTaxbEm1NQ?=
 =?us-ascii?Q?7CHj7pYnPFCRUifMtZ3yI01OEZOS7fo4X2c2uH/ER4IshKAoPa1zVLQeVVL1?=
 =?us-ascii?Q?g5pODSTjtQqzTQxYi+gzxAdxEz2MLXfHM73RhV74QlMJwXtl7zZ5xz0QeA03?=
 =?us-ascii?Q?qH+I7FXvq8wUxOUF08HGVSdloBWuqBtk9ErjsXk2E1Asf0kNuZmvQky8wWss?=
 =?us-ascii?Q?hGIOqBXl4kd00KsR/nlRiknzGdmu4x7hdpTg+sGAyqK9LYFt/NlxyEINSJEC?=
 =?us-ascii?Q?tk3TO3LLWPjvvfkAdQQfbMrJRXI8ak15GudAmqf2sEAU95abYK2nna5r8p/s?=
 =?us-ascii?Q?9mGRtf3rfWyGa5c1+vNkg1eopM3LlKjASWX2cYNV3pD0IKhsWWiWriwNc3FZ?=
 =?us-ascii?Q?SnHb69V+CP/tmkDdtetM7e/3j+nuAQWvLkQDyruhJLc3AQhj2wQQYyHF+uG1?=
 =?us-ascii?Q?oCi1EVi1A2hlqVWQHGaUrCJhzhT4lojSLyK0+Ly7jia+jzbHMPpqnM4RpKQ5?=
 =?us-ascii?Q?cZ46HHkcz08TYRob52XtsMaa1zX7+ILxLeLWK1PJnwuNOJL6ZPQMOL9HpNre?=
 =?us-ascii?Q?o0ARCPP9lT2LEwVqHtm/RI0i881Ui01qXgMzTJhTIEIZ6BH5RHFKj15K4DQ0?=
 =?us-ascii?Q?anI6wqSk66jmFC7sfWa09VU/9AFEzn864P0XUBV0Rbh/bq3qGPTnNz0+ztH5?=
 =?us-ascii?Q?prBNFQ1Ag62VaJMC7/k+tXbNr9unLrqJfnkqwmufCuW5tHaewFrY6U9Ape5R?=
 =?us-ascii?Q?rgUhXiKeVaKHCZYcmzzWqoGE+WQsCAsTWV0QZmhHFosMh9J3mkY0oL2nBJqw?=
 =?us-ascii?Q?cpqbkgFfU9wELyI8bDBeBWMe2juUBC3o2scXHNiDyxEHIPF8v5yE5Pp3Bdgs?=
 =?us-ascii?Q?3olXwdZSSH1M8f4i9G0jzVAwmu6jRvsn/43HczNpzoxae9j9PH4jGADm2pba?=
 =?us-ascii?Q?mrWFVTDU3ADZwB4PzZafgny19u/AxEOonCXvB8Y4my8DDYGN6E0tLLg1a2fv?=
 =?us-ascii?Q?xY65Uq+z9mE0CsXxQObvsqcC2fIeTaysXz/fn3Wa0+26DwMlGEly3AEj5Tpm?=
 =?us-ascii?Q?IvXCuHT6KvtH3PcUupCmICda9nK11i8hEjLODTzQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b44e984d-0206-4c28-13fd-08db4b86da26
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 03:31:16.0073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RQIpnAja/mMzCxQ8jqJm+PFp2yoOaC9kb7SRqVhwQFfr1MGHDgd+qktTskoey5su/Eb3zzgnrvjCAWT4oy1EfIniGb4iegZLYnaFhWPDxzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR05MB10770
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>When doing link mtu negotiation, a malicious peer may send Activate msg
>with a very small mtu, e.g. 4 in Shuang's testing, without checking for
>the minimum mtu, l->mtu will be set to 4 in tipc_link_proto_rcv(), then
>n->links[bearer_id].mtu is set to 4294967228, which is a overflow of
>'4 - INT_H_SIZE - EMSG_OVERHEAD' in tipc_link_mss().
>
>With tipc_link.mtu =3D 4, tipc_link_xmit() kept printing the warning:
>
> tipc: Too large msg, purging xmit list 1 5 0 40 4!
> tipc: Too large msg, purging xmit list 1 15 0 60 4!
>
>And with tipc_link_entry.mtu 4294967228, a huge skb was allocated in
>named_distribute(), and when purging it in tipc_link_xmit(), a crash
>was even caused:
>
>  general protection fault, probably for non-canonical address 0x210000101=
1000dd: 0000 [#1] PREEMPT SMP PTI
>  CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.3.0.neta #19
>  RIP: 0010:kfree_skb_list_reason+0x7e/0x1f0
>  Call Trace:
>   <IRQ>
>   skb_release_data+0xf9/0x1d0
>   kfree_skb_reason+0x40/0x100
>   tipc_link_xmit+0x57a/0x740 [tipc]
>   tipc_node_xmit+0x16c/0x5c0 [tipc]
>   tipc_named_node_up+0x27f/0x2c0 [tipc]
>   tipc_node_write_unlock+0x149/0x170 [tipc]
>   tipc_rcv+0x608/0x740 [tipc]
>   tipc_udp_recv+0xdc/0x1f0 [tipc]
>   udp_queue_rcv_one_skb+0x33e/0x620
>   udp_unicast_rcv_skb.isra.72+0x75/0x90
>   __udp4_lib_rcv+0x56d/0xc20
>   ip_protocol_deliver_rcu+0x100/0x2d0
>
>This patch fixes it by checking the new mtu against tipc_bearer_min_mtu(),
>and not updating mtu if it is too small.
>
>v1->v2:
>  - do the msg_max check against the min MTU early, as Tung suggested.
Please move above version change comment to after "---".
>
>Fixes: ed193ece2649 ("tipc: simplify link mtu negotiation")
>Reported-by: Shuang Li <shuali@redhat.com>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>
>---
> net/tipc/link.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/net/tipc/link.c b/net/tipc/link.c
>index b3ce24823f50..2eff1c7949cb 100644
>--- a/net/tipc/link.c
>+++ b/net/tipc/link.c
>@@ -2200,7 +2200,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, =
struct sk_buff *skb,
> 	struct tipc_msg *hdr =3D buf_msg(skb);
> 	struct tipc_gap_ack_blks *ga =3D NULL;
> 	bool reply =3D msg_probe(hdr), retransmitted =3D false;
>-	u32 dlen =3D msg_data_sz(hdr), glen =3D 0;
>+	u32 dlen =3D msg_data_sz(hdr), glen =3D 0, msg_max;
> 	u16 peers_snd_nxt =3D  msg_next_sent(hdr);
> 	u16 peers_tol =3D msg_link_tolerance(hdr);
> 	u16 peers_prio =3D msg_linkprio(hdr);
>@@ -2239,6 +2239,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, =
struct sk_buff *skb,
> 	switch (mtyp) {
> 	case RESET_MSG:
> 	case ACTIVATE_MSG:
>+		msg_max =3D msg_max_pkt(hdr);
>+		if (msg_max < tipc_bearer_min_mtu(l->net, l->bearer_id))
>+			break;
> 		/* Complete own link name with peer's interface name */
> 		if_name =3D  strrchr(l->name, ':') + 1;
> 		if (sizeof(l->name) - (if_name - l->name) <=3D TIPC_MAX_IF_NAME)
>@@ -2283,8 +2286,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, =
struct sk_buff *skb,
> 		l->peer_session =3D msg_session(hdr);
> 		l->in_session =3D true;
> 		l->peer_bearer_id =3D msg_bearer_id(hdr);
>-		if (l->mtu > msg_max_pkt(hdr))
>-			l->mtu =3D msg_max_pkt(hdr);
>+		if (l->mtu > msg_max)
>+			l->mtu =3D msg_max;
> 		break;
>
> 	case STATE_MSG:
>--
>2.39.1


