Return-Path: <netdev+bounces-2465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB007021CC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 099611C20A00
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E875C139B;
	Mon, 15 May 2023 02:41:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AB8EA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:41:20 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2093.outbound.protection.outlook.com [40.107.6.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4715E120
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gfij8DXl3ltjmRJhb2vwdpLDvEJIic7Q3QASKduumWl0HOoGUNX5O0Kj+pwWAGOw/ji1sGKhhQQOTbAEd1DZOar417F6gloTpJvri2Hwezym0l3GlAFP0yNpiwKJ1MMBX2G7u8cY2GLcRlrZx+uN9G3bQ+d1i7ROnEP8giwbeh5y/M9GQlpTU2O2oYtQ/XHov9v5GjBdbjWYRQ0ugl/oOAeKoEv/h0m3UjLJUivPxyVg+iKe9HC3LgsnI7X95d98h6dBACIx99M+qYgjSYSlAaRuMr/29aIgEiQG1ujUyvq1xlFuHv0TJab7cWrlXMPRxaimVxGDd79eo6CV84G/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3trkVY7wnJtOmfV+bC7X/ydUK7fhQ3FHGVFoTA5YmE=;
 b=BxuxqJY0sJR2oebpUpBOE0789UZ9cr4YsRiK60w3wSRSsh6lzb3Fbu6F+1htNj595+PZ4QFb405mkvY+My9JXOi8YzjugCCmpWwMe44IhO2eFNr5OfkoMpGowA9PBVV5jpcK4e+C0qbpabfqc4KYcmQwndBl8nor12/QYuhAwxInytUufDFNoXyhotZu8R6bCcDBFWNwgY8ErgYUQ4GoubA+QD87LUpRczDKN06zRkJqyorBrtDYgHDl1562LKl9zTz+UtSADG7fsm32r3Tjg5tLvSI0pXS0yKvfUV80vwwDfkBaz5olBt7jw5ABw2bNWZc4KWIpP6Bc1QHmPY9xAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3trkVY7wnJtOmfV+bC7X/ydUK7fhQ3FHGVFoTA5YmE=;
 b=bqLyxu3WvZpILh9Kc3U6zpIDNaC8SHQl8Bit5Qx5m0ZBmqLMLgv/C8igZ+2hmNAvbmu+Ed+r20DUYENtiP1gbXoTlTjx1uUovi0SMhpt/VO/Gr4u8tUCnL7Cc4XzKwk+9Dyz/hbHcpfgDLljvD5YPHV3kHJL1SdlNlcBvkdFY2c=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by PAXPR05MB8207.eurprd05.prod.outlook.com (2603:10a6:102:12d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 02:41:13 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 02:41:13 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: RE: [PATCHv3 net 0/3] tipc: fix the mtu update in link mtu
 negotiation
Thread-Topic: [PATCHv3 net 0/3] tipc: fix the mtu update in link mtu
 negotiation
Thread-Index: AQHZhp2hXKwEAyOCgUqmXm7Tstc3Va9an82g
Date: Mon, 15 May 2023 02:41:13 +0000
Message-ID:
 <DB9PR05MB907845D6F1CF8AAC8140CB7A88789@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <cover.1684093873.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1684093873.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|PAXPR05MB8207:EE_
x-ms-office365-filtering-correlation-id: c75180a1-2765-42c5-979f-08db54edd965
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bbaRJHy49rK3P+lPZ1tP0oyahZAtCUn7Q6VRyMkqUZMtIFxTuoqyNti/lIFWsmN/ouVlGStFqzh1FylBTajObvml1MxrM5NbHhQkIn9Hd3TcobfWQf2A65Epn9O+f0HuP0cNKBsnMxWVqy/g3znUr3NpmqiklozyqhLLpTJj0lVgtNlKht4rewwN2oXt3A3pSCpKIYVZTLigClJ6X3GwVBk1SgDNqWV56hyLbkY78O/q88lBYHpAMfK/wsZGmIA06LzIvokngS/OdhwR4Ej/CWwZNJ+zzVRY3rJPwJxTBz4G+MDqeq0jxvcx+QwUqGMrKwNIYSIw7XRcR7Ge543b1I5sDy04TU1hbHHhxgEaG7EqbV40JDpaO7C8SWRcDD/lRZnmHrMp8Nv52VJ5dIVRj7L2k38FJekp3owF5G8urR8DVD4Na6H0JaI6dmfWtm7H/v5n4ynoa/uH+e24YRCWvf+LhHiFKnuPEs9gru8W/7V0YRJmtpuO2GaeBoB3X7HuC6OrTHcjoL+RCd9wAh1dRAv2Hii8YvRnfNMKo1+FiR5AW9Hp8MzYQGxK8aTso9KeuysGKRBAPuaZgPfXfCce7IxWs4dcglAXWzgLN9cMyCifjcJaAXe7DLvik8vj2/Zw
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39840400004)(376002)(346002)(451199021)(54906003)(478600001)(110136005)(86362001)(83380400001)(33656002)(6506007)(186003)(26005)(71200400001)(9686003)(38100700002)(122000001)(38070700005)(55016003)(7696005)(4744005)(66556008)(66446008)(66476007)(76116006)(66946007)(2906002)(64756008)(4326008)(316002)(52536014)(5660300002)(8936002)(8676002)(41300700001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zh9aHEtcDd0AOpQHeiibEbJIsJlKKQIs81C1jOLypQSJeGTc4yUcXopMS7AB?=
 =?us-ascii?Q?mhtOOUD2mFm0eZ79+R19kA79KxyFyAeODfhbPNFRX+ckuSto/bsiIbhoREZc?=
 =?us-ascii?Q?cJ+UK8gBxnjhbcxtiGSN4HETmDN9BepE+4hW9LBxA/xXYcBW5AgGXzZ1Zkdu?=
 =?us-ascii?Q?7QLoxqityMxNqbUwoOaDBN0HhlRhioSxKgrF2UiHNQFy9PZgsChVdnaz7KuU?=
 =?us-ascii?Q?34ycN1umOfKIVMzFo7AJ2N6KMCT9A/dStNG0asWJRCsgSOQqE8NtAeb3XW/a?=
 =?us-ascii?Q?ji4SFm8Dw0GgdcqnwVE7Qw4WQLO4eIn+LBWgT2h3BeJy1uF01Yr7MU9FHkkz?=
 =?us-ascii?Q?rapLCZw6YQzC/XD7i56QeFWfAfVQSYHf4VpsaJX4Ju5vUj0t7SDfdH1Oqo5G?=
 =?us-ascii?Q?lUC2cxFi/2Ykm+yBG0542UhJ/lb1wnKv6AgNNLUjNEDbMZON8yzrUXGykP88?=
 =?us-ascii?Q?V3P0kwRz6JYfYjZyjHzSrIH+imZuUfxcyfq/xtmYh/ViYbVkkequYXk50ibl?=
 =?us-ascii?Q?9/j0/noTUVUIuvY0JsbMLhWcaW4LWfKHsuVg46jH/1QteGpU03PlmG513AkE?=
 =?us-ascii?Q?twfbsb1MEYxaP+gBwxCpFJ4Xse05JHad2dwHBfwKoOBOj2+9tWDVoz3Ufpia?=
 =?us-ascii?Q?9B4DKItLPDsPmvT74QTkCat9hnWm9s1t6zKKZ1NvwmBYs7UUbeivyS7niJRV?=
 =?us-ascii?Q?iEPA6/zDd0txo75WzJaoVxC4tvuijkTRGVHsTu/Hxke0k/bujODucGlyFTwv?=
 =?us-ascii?Q?KloXGb0UhIh9LZ7GlXF7f58Taw9xQTm8+fI4+7Owqk2eWUejuwp6r3gUcBCQ?=
 =?us-ascii?Q?KD0uv7R0dnM5QEUHfcfTTJz/jTd+vP7uIhxyQQnrSRnOV32asunr4aAy/msC?=
 =?us-ascii?Q?zaJ++qWMURUVEdwcI/AhVcli/0lkusjj07OmZyFzhB2idZYUeWZWCE0GFhYd?=
 =?us-ascii?Q?soBRyDp/bHh78b4O38l0W/LgvWeySxzdb7z1c0sjIKx2IZS+jTlCC6qaz1Ji?=
 =?us-ascii?Q?Tes5cMC3IqU2uVRDZV5NUg4SFgDTFSefL+RiRANlY48rWsZRe8PLI8p3GHFO?=
 =?us-ascii?Q?wsoEn3InCGdhAgae2h1hYDA+mXYXE67M+BRsPWiRJ9F1S0kzMF6OMPFg1k4W?=
 =?us-ascii?Q?9UGsihanSFsKOJt4iyUk3miGFMRClOkwjyKmHTy7VxfcSFXIge9ODwePU6EK?=
 =?us-ascii?Q?8vfHu1nc7YUNZzqhlbcUGm36yWIQiiqOuOtLTJLtJ0SPqUFs3orf35yJUeBb?=
 =?us-ascii?Q?0PxqBeC3Bhp8pzqJHz4ZjLCCJJ+QwH5HYGfdtPAcsh/uj2pUL9kKk4obKFMD?=
 =?us-ascii?Q?Zbv4l5SO5bWocAHNnm4u07CCNmIseAjsXrzMRIqg8aja1AgITaf6Q1ABL+VQ?=
 =?us-ascii?Q?cSQ/CxxdLxRDRgB68N+RQWGTZcYDArmcLNnUrmVsTfBEBBqWQEm6zawoNIoN?=
 =?us-ascii?Q?R6nLZ1CX86pam8xXljJck4pQ34dQpcNVeNY0DN2YzlWUYIPDHJrLH9kiFOcv?=
 =?us-ascii?Q?188r9ZCXDWToSCVfi6iJXqiOZz8Fk4JQg9vWWNAJq5A+UBOVmzWcIYUGayYy?=
 =?us-ascii?Q?D+n5fUCmusgtctkdzJqRMxnQaw2m38nNvIkwQOs9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c75180a1-2765-42c5-979f-08db54edd965
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 02:41:13.4139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXM0yg7gBNpq5n2uLbf4Ytx2WgLl1ntfK5S/EXV/t8uTbrCHPi974JWu1eVjlZ+EpyNJMcuO5jtf4Q2fsJQ7/9MMsytobqUx2FMPAW+gH3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8207
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Subject: [PATCHv3 net 0/3] tipc: fix the mtu update in link mtu negotiatio=
n
>
>This patchset fixes a crash caused by a too small MTU carried in the
>activate msg. Note that as such malicious packet does not exist in
>the normal env, the fix won't break any application
>
>The 1st patch introduces a function to calculate the minimum MTU for
>the bearer, and the 2nd patch fixes the crash with this helper. While
>at it, the 3rd patch fixes the udp bearer mtu update by netlink with
>this helper.
>
>Xin Long (3):
>  tipc: add tipc_bearer_min_mtu to calculate min mtu
>  tipc: do not update mtu if msg_max is too small in mtu negotiation
>  tipc: check the bearer min mtu properly when setting it by netlink
>
> net/tipc/bearer.c    | 17 +++++++++++++++--
> net/tipc/bearer.h    |  3 +++
> net/tipc/link.c      |  9 ++++++---
> net/tipc/udp_media.c |  5 +++--
> 4 files changed, 27 insertions(+), 7 deletions(-)
>
>--
>2.39.1
For the whole series:
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>

