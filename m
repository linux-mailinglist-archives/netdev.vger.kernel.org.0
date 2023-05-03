Return-Path: <netdev+bounces-157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 833D26F5836
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1E22815B8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBC1D51F;
	Wed,  3 May 2023 12:54:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE12BA48
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:54:15 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2069.outbound.protection.outlook.com [40.107.20.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3818A5B8E;
	Wed,  3 May 2023 05:54:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7UZ5izzcMVwQlkdPsyEx7uKALNf5r3pWJpbQAFEKV5t91srspbno07nu+B7yAcoTmqJ5z956sQcN3aHYJQvdThvF5UksxwQRAudrF1qI07/e9YjYBfQ7YGH8BjGJS/EPQSGKehe5i21Uc8DVkbl9ypkh6XW+msCk9r/0GciEuy5gULKaVJZjHjzCTzTpfaaa6F6chTMfmiNBXnhQpcHPl9ffBB3xRK2XZXHDswV0Lk/GUA/IiIewVrWHuu495c2Boh+Fr+Hhd/R2+nEyhLv+X/WlsgZIrrENd8VphANTQo5K8aooDkeFNSpKRMG/BcChVQHCxE3p8JlMVYYrCmdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1pegviFNKEfEYzKVHDkWuINnzcTFT4C4zjTceQhmVw=;
 b=MjHRvBjirbxy1H5z0Y0PTEVcqkK0AGRTDpC883A3luQypSSXf1bhfzPk8pGwpU3UaunUGGV8vRYfZ4JeM2Bc7t93tTz5gHrh6VlsMyyDE3ThSdd2E6at2n0HeyeUO9hAev1Y+m87Qou7X0uWFSk3KQPSq/2Bey6ecU5d4bANB8/UIXukX6BfJ45d1OiUDfexspe9rDholyqr2mdWga/egnwusaZLSGby5CPv3IVel85i+RiFhBJp/oyuJi5JefD51EXIuzuTswgPCYJGHbwDC7cH99H5GIti/g8Kfy+JNbf8tlZp0k0bTmTUCixdKNJ/fGL/rayvDqf3e667vqv0xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1pegviFNKEfEYzKVHDkWuINnzcTFT4C4zjTceQhmVw=;
 b=KPec+naJHq32pPEgvaXGC0rB1ThvnkJIbJceSILIgOZJ/F8AE/5EWiWmoqhfpq4UJbPn1btHbwnazU//qfKprqUo/RMtCd6KU9f80UDkmOXfM0SMk9DYhckxjHtfbIaxDiLiGS7MXmleUgj7sI54bA0UdGDCKLVJbsyCFzYvON8=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS5PR04MB9998.eurprd04.prod.outlook.com (2603:10a6:20b:67e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 12:53:57 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 12:53:57 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Clark Wang <xiaoning.wang@nxp.com>, dl-linux-imx
	<linux-imx@nxp.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Topic: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Index: AQHZfUKo4ZwVUtEG3EOjLFQNjL7Wpa9HnlQAgADiOCA=
Date: Wed, 3 May 2023 12:53:57 +0000
Message-ID:
 <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
 <20230502220818.691444-2-shenwei.wang@nxp.com>
 <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
In-Reply-To: <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS5PR04MB9998:EE_
x-ms-office365-filtering-correlation-id: 1c7f7222-0086-4257-ff4d-08db4bd57551
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 NK5eUnc3NDeJdzED0JjyVcdLmfJNn8JaTzJHumsM2Xxrh5EBFQQj0YiO63KatzyeKtMg4/8hx8s4vwL3Q3yEqZC3iNohO/3TBnFeVh8sUkeXT4dMJZ8kbhUYeZuzugP5LWKP19JqwQVO6UxSPYCeU3u488M8iWZ3k5C+BshF7jwLZbjvDV2M4JCsQ4ejyDJvezZzxRmUF9EpP5zuX/v9X3RoRxs73oU7mqy6b+9L/dENA1Pp1POgLQHGC/DJ/TJA0WdytJ7f0yss+m7fmiCm0rtFzJKFOKc0kEvg9IWw3VFRZzb1qj+L8tQcZKTevhzqyYByF76xVWI9SK7XwiPQ6adxkfatToEKU7XgwAirSAhyEAbM752aOwH9BwRbNiZvZBusYKGJBgxnSdpQmzGWMWa9ZzXuJPUhvbi1FbTjdmEkD+iWYa9uBXutwngn9m4viAOXBsLgRslpUpp9ThfYXQiAREYi1G9/A3lkErT5E57cJWjA41ktH7wxexhkMD3hch8ifvMjnA+0a0UMwrOqECU+kmD5ioroc6X9EOo9tjRt/h3I1DB9Mrpz9STosRf1LxfOGDXEKMQ5PnVBfJzS3ptAjxijaczu62zkQzuNBFoO96kdvYwBUVxCjmLP9/AL
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(122000001)(8936002)(66476007)(76116006)(66946007)(33656002)(186003)(5660300002)(316002)(8676002)(4326008)(55016003)(6916009)(64756008)(66446008)(2906002)(66556008)(9686003)(53546011)(38100700002)(55236004)(52536014)(41300700001)(26005)(44832011)(6506007)(7416002)(478600001)(38070700005)(54906003)(83380400001)(86362001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jn2VxE1MgBcVsYfoLFXZ489C/gxCdrRgJTmgXJ9r1HMblrU8BTtCaHtOy2XU?=
 =?us-ascii?Q?ziJcuxZzwiqstisYo6UrbzwQRSIAPVZk3SFK8qUqiWVELyjA0+muFk+eY4XG?=
 =?us-ascii?Q?49JmJasyZqaNrZcyz0DEnss8D2La6ymeTPyp/gda5uIzNuMOU2RRHMTuBBDe?=
 =?us-ascii?Q?EhVVqJNsYfBoClaC5EYHqmbaqq1CG+Jwh7b/cTBM0UsTmw6V4b/BWLJLIeZN?=
 =?us-ascii?Q?8EIu5jfwXqazZTSfPKFeEQkrVAvKMreR5aXntfPCM/HkMJGAkiMCV8oQT15p?=
 =?us-ascii?Q?s0OfgGBit3lZRT1q7CcR/zQzpcAjP4C2Nq9sw+NlvsdBhGhNd09pV0hobe8/?=
 =?us-ascii?Q?YU3SOcDuhfg2BEO9WMexTyTk4cxljoEP9pPQL4cN5Bv9CffXWsMq1aHQpAAu?=
 =?us-ascii?Q?Y1DKDVaTq4gxUtazEKqVWtx6WOaAYifwRS3c2nO8ksm4PRg3kMAGCa2x0PyY?=
 =?us-ascii?Q?xNXiffXcVOBHvVLAXhR4JFGaJHr89rVO462wB0TzPxUNN6FKEdDg4isQ0fcj?=
 =?us-ascii?Q?wkOjKBwXztC6Xn72ZTy8xnL8VsIzfzRkl1whHATT+hCXhj0zdfKuqYKo2YSw?=
 =?us-ascii?Q?ScRnYrZpeDJVbPn7eA/Fcy534/CKUqWi+S0GmW56CRFFUX87V7ehVPN6wSsQ?=
 =?us-ascii?Q?gU2uBjPJWGD68CdYJCLqgS4gRm2fR6MZkzToShe2qkDv2o62CxD4iMQn5fW7?=
 =?us-ascii?Q?+QOAvlxSuuVxgTleCbb/TCyP8cQ5V59cPENhh2lqwZU3jJYswAeFRbm54i7X?=
 =?us-ascii?Q?xEiMHlcrzW5vkihxLT/dotsST1ZmP9Fpixyz493s2M2gZ6sDHvvLLl8K7fZQ?=
 =?us-ascii?Q?6NWIaUfx8slUbb379sT6/lVLsQjT0VsYAG02N9Ua8g6kl/z75HRFs38idVq8?=
 =?us-ascii?Q?7S2mGVPfbKph9VsjY9IG4nC3Q7NhKx4MI/TwcGuJC/puGcPk/4Ak0LQwG+Mu?=
 =?us-ascii?Q?wz6C0cBaLjJibR8IqbQS6YWsfUf+WUGbm390s3QL8wKa4pkV/TCt8Isgroj2?=
 =?us-ascii?Q?szy6OvMtiNPBcB7UGwnclhK2ddvuKB50P1MYLOYRfAs2FyQ8jxYRAu1dbYcy?=
 =?us-ascii?Q?nYSswr7nWLlFjsiaEWyw8voUxPjSBMM6xiOcWUt4EmyJIOnyQUAzZX8xx3cK?=
 =?us-ascii?Q?TMm04bCF/izysY75QzWxavDOzp8GuwaiVRUSxHLOznpHLP3UYyjbZ8CrsLka?=
 =?us-ascii?Q?FcvzzD8O8zGr5GSLNJmWcNF/tuIsrlYhHd6FmnbLXudHA4ussBqtk4l6gCMQ?=
 =?us-ascii?Q?X4JZOmrVHW8CmDJaqIw/ELVVvetjO1/yldy9S4OZguxMdRAJSl1eKeATNrSy?=
 =?us-ascii?Q?PgHv8BBezOg2aJ9lalr+7bFOBsGBLFCIVh7FtinrIncYWbpMxFcjZk1maoX3?=
 =?us-ascii?Q?kFHPfIXCg79cliMfZE3nz7VQlRrt/Yxo0FVcst0dQKqDcLO8MJ3nHQIagzMC?=
 =?us-ascii?Q?+vOJt3ZC/DQgsQ1EpC602rHlb+UvluW0RPHW1IWKWTYsRUlpm+VzwQKqU1iA?=
 =?us-ascii?Q?O4SwjpD4riW1zGLKIwPVlo1ZRqEMIbhqvECaQecwVx7CJvEQMt7p3zMVfaf2?=
 =?us-ascii?Q?CjbOfR9d54lOZv/PvLpukXQj2Sylx8R/9tRNfwxK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7f7222-0086-4257-ff4d-08db4bd57551
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 12:53:57.1304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FKcXd7ufU308xLFhr+YeGi+r7AxahnecrE0nTd/n/3KW0t+Exb5nvoUnBv5bR7+w1nTZmSxPsig5IZRAYTqrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9998
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, May 2, 2023 6:19 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Wei Fang <wei.fang@nxp.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Clark Wang <xiaoning.wang@nxp.com>; dl-
> linux-imx <linux-imx@nxp.com>; Alexei Starovoitov <ast@kernel.org>; Danie=
l
> Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; Alexander
> Lobakin <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the functio=
ns to
> avoid forward declarations
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>=20
>=20
> On Tue, May 02, 2023 at 05:08:18PM -0500, Shenwei Wang wrote:
> > The patch reorganizes functions related to XDP frame transmission,
> > moving them above the fec_enet_run_xdp implementation. This eliminates
> > the need for forward declarations of these functions.
>=20
> I'm confused. Are these two patches in the wrong order?
>=20
> The reason that i asked you to fix the forward declaration in net-next is=
 that it
> makes your fix two patches. Sometimes that is not obvious to people back
> porting patches, and one gets lost, causing build problems. So it is bett=
er to have
> a single patch which is maybe not 100% best practice merged to stable, an=
d then
> a cleanup patch merged to the head of development.
>=20

If that is the case, we should forgo the second patch. Its purpose was to r=
eorganize=20
function order such that the subsequent patch to net-next enabling XDP_TX w=
ould not=20
encounter forward declaration issues.

Thanks,
Shenwei

>    Andrew

