Return-Path: <netdev+bounces-9094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D107273AA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F172D1C20DBB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C197C7EB;
	Thu,  8 Jun 2023 00:21:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7A7E9
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:21:16 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2110.outbound.protection.outlook.com [40.107.114.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF552128;
	Wed,  7 Jun 2023 17:21:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQeboEO1XjeVrWh3x7WVfai0a774Q7NHOMSB1mvZ/nqaq0MFENydPC0RSFSHAPRMRAiLOADAMUiz52Q0gVOI64P26fbQEM92WjjBl3MJNC3BV2WGMJ1ailTmh+lnDb5bxEKjSuarx5draXOQo2uQtTLN2ibWam7/7idWqUPW5OvsObgs3IL9trFq+LRem7FkclM4xD+5MRavpG318zntA+eeMRh13vD2er/7/n1IWVfYKabrtXtTxKkOSPFmNVV0zT5B4o0AD2scCTaPbzAC0v72xW8bLABs+UOT6R35T7UKU4QTi9xGu7Ht+q/dvOv92ZwBfRGqvF3q6l5jdXD+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMdLwPd6YGVZvBPMfjC2DfKD5BCZBLnS/W3xNdsnyvE=;
 b=i7xrI8CtTsbxY+J4zJlyX9i9Obg2YacbPyEcAHhD1jw08U+hUDMYdVsG73lvS1TiaV4jPkMwVCvjHhEYSLHW1nXArCZ9bhpXdoq3o0wrxd9H8UxCMMxvQ+LZ//SlQaZZNVZ0LGP2pAttExIVyePPLfTifqGrGQ1yrOO9I0AbqvXUQKB8hlxWbj3YmstSinZUj9tHibCBHZbM/RbJICIWFaEKuDHYzBrOvLrcAEEoH5kfSjs1xj/5alZLzNpiapEWmsnQiknQ1EyiAYQG773+BjEzTnlGVygOUHaHvuaNop27oF9UZDzUO3aorIlaQI/S1VpgOC61JH8i/CeBAgaYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMdLwPd6YGVZvBPMfjC2DfKD5BCZBLnS/W3xNdsnyvE=;
 b=nnAX88AE/3glI2cyxIQOvE5bUZPSrprnRWUx7wDACo4NUJxgzqMC6arqVxGUrhA7gBP0R5+rLSaIg0YuCSknvOFdPCjkYhwYj0iaphNu/c7L8kSPeOBMGL8bx8Jngdr029zW8Q2k4O72S2u9U2S+C4mJPZLUzWNRqE+mb/FU+vM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB10511.jpnprd01.prod.outlook.com
 (2603:1096:400:308::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Thu, 8 Jun
 2023 00:21:14 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 00:21:13 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: RE: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature after
 all descriptors are used
Thread-Topic: [PATCH net v2] net: renesas: rswitch: Fix timestamp feature
 after all descriptors are used
Thread-Index: AQHZmQ3u9rajBPpejkKoTwa3FiuSIK9/doeAgACVeBA=
Date: Thu, 8 Jun 2023 00:21:13 +0000
Message-ID:
 <TYBPR01MB53419CEF615E14B8ACD3ADC6D850A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com>
 <ZIChdcJ1e2cl5epK@corigine.com>
In-Reply-To: <ZIChdcJ1e2cl5epK@corigine.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB10511:EE_
x-ms-office365-filtering-correlation-id: 609d0ce1-f5ec-4581-5e8d-08db67b644ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 I8gEbEsyLlaJ8FoPP8aT0E9XCwnbGpfZlpBLfZujY7qUDj42rhng6Od+WGdhCsusecLDrsIIsEhAFxFZ/HU6+w1gwwfOgkTaddGvI4Z0Q6iyUIGDiN6TvEwlkAOqmPcTKtkwhFUYwxak8rQ35t74pk4Xmzr2ZNRJEu0jPzc9Aj2cUczf+Rym3lN2wTOxpYUciOKb4cuNbCoQ6CkBOJw4wsncsM13ua7XtjQY2crQop/9mMiyRKvkKCmXaEO7zKNJfvFEFEAsFjaGSSShJAlyccafZioHFd7ff4nBW+1qQTbnYsMzgjG7A72CSAjxeK/8nOwQpvvOm1N7UQ+s1k5Hk3u1bHn3BJJkthvg2l4hUM/fZsV3M6WnxrD7/y8GeSSeWPA/eAFY9+VCmYQxfgd2aKXxiiyptJ9T4WVldQCApmPwGSKaS5Y5glJSNABLfYeVmN3gBW5eIQGsz+vEzYNWFK4ddZkSN0Am38Vbd8mWOTI0boCemsOA+06GYEhE6a/uQnUgavuNO6Y4H+3NxA0LLSbMO8qpGAy/eSLv5UsfTHQeGuzigwNlFAGU0woo50VyQd3zLxzB4/7/ldq6USldu4I7FI1teyVx9ay/2EHLJobtG6JIJslUu07ifrzZoFZX
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(186003)(478600001)(71200400001)(38070700005)(6506007)(9686003)(55016003)(8936002)(86362001)(107886003)(4326008)(66556008)(316002)(6916009)(122000001)(66476007)(64756008)(76116006)(7696005)(66946007)(66446008)(5660300002)(4744005)(2906002)(33656002)(52536014)(41300700001)(8676002)(38100700002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TF+BSs3RpJEJDlPlUUi35KUmxNAlgfNq6Rn0ugg5/PUerRy07BZAaiCZNclE?=
 =?us-ascii?Q?XTWjQHqWgJhr5+uhZ5zed36576MvBVpxBehML2YGVyOeU7FXdVeDd5v6FtHC?=
 =?us-ascii?Q?imUBLPxBxuUzhPJGi9RLyc9YgEotq9WK5WEMt0JzopEQ2d81b9j0l/R4vxXE?=
 =?us-ascii?Q?QyBKyJq2JNZNHN4pb5bBIONNNb6U5p4yOIIVOssqgeltnYsaReGVdbOkaQaZ?=
 =?us-ascii?Q?48YdBi9waH90O4G8TbUuhX0K88XaPHFGGzqV+N9kUwWFu3iS+jDyP4jekRPe?=
 =?us-ascii?Q?mmlTVTwAFvrPIwTjV+mnOapwm2c2spTXLghQfK5fABL7daUbN75hsjH7ku8u?=
 =?us-ascii?Q?QTobyZ0IifGiN+d7vdyXmzzzA8VgRPHrhaC6yXPrSq4nLU/2HPxW721hFRCU?=
 =?us-ascii?Q?m7UzrVoVFqbcXfKbSnpLMMlmXEJka+9tG6UQbPbBjWREgA34SKDzXsDqb4XY?=
 =?us-ascii?Q?AfPfGl+ci8VmEVSbWk8Sjd/mk2JtTNkwU76kkrMATxHTy3Z8PQPkrVGXzebJ?=
 =?us-ascii?Q?D5bSzpFlqeQKnpt7ZyU2DZmv6zkp7IfxdAPZcH76SEAOg8xx6+TZ2XKmun0p?=
 =?us-ascii?Q?5Pc15nLMUQGkSd8ueXrcZDzFUtIS/AGgaaCZmjkHcIqAC4ct9hUBWlEQHIWi?=
 =?us-ascii?Q?5w2yOnERE71F1R2OrPliHiixb3aRCGYO0JAmMk5UMyALJdgP+oeii+Ggr5Aj?=
 =?us-ascii?Q?/jDKbTL9NO0gQek68feAkDKaR7v7Wk/N+/p/3iLudBEGCPFv2/PFy0PgyPnv?=
 =?us-ascii?Q?lWkFZvv689j6nY9qJq3wAkwJ2NiYio/W38zbS7/U5ymiagecw9IAsKPd9lkV?=
 =?us-ascii?Q?60qEhYCX8dyzvnQ1+Zo31dReZJqhwrRRdv/MhDShmKTesc/Eb7fvoCQpyKJz?=
 =?us-ascii?Q?7Nuv48k4tHCgm5jFYaIGot3iJv74+jwRlZlbHvy+zoi50PD7raEPY7UDbOed?=
 =?us-ascii?Q?74iosGe0taLNO/g03u8TkboOpXljCbnjMOvXwkpSNFIZDkzPS+j9jkNmnRkI?=
 =?us-ascii?Q?FUKaBEtZEeQpTrFpI1cFS9QklsqyvVmwPzpRi02nFJsr2UAeZax1NA9+BK1C?=
 =?us-ascii?Q?Z6kYYWrHfmtDVckFYYWwum6yMRklGSJ/2eV6VxzAQy7sBPzit/TVXfxlOo0h?=
 =?us-ascii?Q?HFX8HYBqgUIwYHyy1E+qFlZD9+zs3EhnNkO9p6Zfnmyy9qjSN3jnqlUhFKtx?=
 =?us-ascii?Q?bAY+2z/xf12/UK3X/wwDFSS9vyg4dr+vZsrDab4DsSD/SNtCdjp9fBdcnqZQ?=
 =?us-ascii?Q?2pVt3IKK3BVt/141uhiMQU614GBtG46Sj/OTEPu6Cas70zAFXuD455+v0SFK?=
 =?us-ascii?Q?kGDwsFcAu0O8mDc2eClsSC2RD/ssjw9aWcz7sMPpNMWr9xmcv+LfVpaEeeyw?=
 =?us-ascii?Q?HvjoHgJ4D07eL71xtfoepG+z3Ma6u0gA1R32UduC9sX9CNSm+tqcozx60fYD?=
 =?us-ascii?Q?Q9w4gcX1VlIdKVqKg4Et27RnpvZP18yg3Msecat7P3eLo3EYQmlT+pJmXH6S?=
 =?us-ascii?Q?Z3jlWNTTHtMRcdMaxOctq5fhchK0ko346u9CqrHJF6419im53L1nogDMj7Ws?=
 =?us-ascii?Q?uUFlwESgV7Yt0/drp/38gxGuqx69RalrLvALubWUwGzBK9XoUZekbRXeASTi?=
 =?us-ascii?Q?tW9c4PD38qUJfHCh0xpDFHZA+EMXIg9s1RbHwAdIW9RN3P/sDSgp1KMZ31pc?=
 =?us-ascii?Q?A2VQ2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609d0ce1-f5ec-4581-5e8d-08db67b644ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 00:21:13.8583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Be9Wf7tGmof2Lp5w7Fc3WDSehnL0NUUyLiI39uIf1sqpPhNTEQU+C3sPKA8yVZIX6ouwjnTci1jMVF1Y5FZFTjuwkxlizcMsyTxtsaVDXr6XDNByNtgVGa52CpB9wX4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10511
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon-san,

> From: Simon Horman, Sent: Thursday, June 8, 2023 12:26 AM
>=20
> On Wed, Jun 07, 2023 at 04:01:41PM +0900, Yoshihiro Shimoda wrote:
> > The timestamp descriptors were intended to act cyclically. Descriptors
> > from index 0 through gq->ring_size - 1 contain actual information, and
> > the last index (gq->ring_size) should have LINKFIX to indicate
> > the first index 0 descriptor. However, thie LINKFIX value is missing,
>=20
> Hi Shimoda-san,
>=20
> a very minor nit, in case you end up posting a v3 for some other reason:
>=20
> 	thie -> the

Thank you for your review! I'll fix this on v3.

Best regards,
Yoshihiro Shimoda

> > causing the timestamp feature to stop after all descriptors are used.
> > To resolve this issue, set the LINKFIX to the timestamp descritors.
> >
> > Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
> > Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accur=
acy")
>=20
> ...

