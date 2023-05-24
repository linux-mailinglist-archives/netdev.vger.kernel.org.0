Return-Path: <netdev+bounces-4933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CA770F3EC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E1751C20A54
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A87C8FA;
	Wed, 24 May 2023 10:15:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDCDC8E2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:15:51 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BE7E62;
	Wed, 24 May 2023 03:15:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXLRibPU56MR/dkBjBe6PtG6F3TVn/xooJvrv/A5Pv7+m0HVcJQopWiyQW/IvRaAPsULOr+xBdENRFhWbKTBu50Ktz8aGgZPk1hutwm0RURGTt894saIyTU1sceKmUCdUd2baFQhT/gpbp9jIOWp5et9qYZsZU647ndALwat0+HGNIIDPcORqPYT1Llrtnf3J2VchOElWLDRM6QoZYD7p+LkwG39U0ubfBIhaf+OYL7mdcZFv5zPgBScMBiIZkGMQ4wd1kJ4vAGdRnZIrETEpMMdG8zBnU31IRQyIXP0+Vr7QmAnWxj4w7x0jnukdgCtPx6kIKLa+9M7AXpI1tAAZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxKuj3OVytYaAJIvJvvNVZh3N7V6SwMh1LXqqUUd6EE=;
 b=A9EveFdR7vH1WvD1KJuD+yrFAEzuvadjjUqStSIHWzsCHCxa3Z+gYp2DUcq0nGyN309Pfe4XVSc7vV6qWD21XAsyJ5KIcOjqZFwY+5pIIsTyCDSGLhoRHx5/TeNX4JXA/GS0uBp9NjUeCaIRKqysukubdsWbD23HDlcD/0haZGefv94UqaXYnsChu6deqBXw++CASHh8wkf9UAreSMI+xSgiXhUKytgvQR2u3k+LpKLuyVOnAeG2SPvvfu8IN+mLTuSen+FyGd23ArYjXupqtwqMKwXByDOl5JWlDXC7Q2WNltghPHlFe3sLMTIbAa3FCsPAzdso44RKFRzgOv/gXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxKuj3OVytYaAJIvJvvNVZh3N7V6SwMh1LXqqUUd6EE=;
 b=faDe+YK9Uh1bybNoOMcOUJiP95c2lwazVQeoDxo+HFJy9zI3ZlAkva/OU+4nLTx1jtBRO7Hy94QLUnZGx8JBKmth3vmXc6zkBem+Llo7DhC/JsphghmyDnD162Vt4+5EmoH7eaTz66ZY8CILC0vKASVglzdkB4zqo2lo/LrgNic=
Received: from MN2PR12MB4781.namprd12.prod.outlook.com (2603:10b6:208:38::24)
 by MN6PR12MB8515.namprd12.prod.outlook.com (2603:10b6:208:470::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 10:15:39 +0000
Received: from MN2PR12MB4781.namprd12.prod.outlook.com
 ([fe80::1768:40c5:be30:9251]) by MN2PR12MB4781.namprd12.prod.outlook.com
 ([fe80::1768:40c5:be30:9251%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 10:15:39 +0000
From: "Katakam, Harini" <harini.katakam@amd.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "wsa+renesas@sang-engineering.com"
	<wsa+renesas@sang-engineering.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "harinikatakamlinux@gmail.com"
	<harinikatakamlinux@gmail.com>, "Simek, Michal" <michal.simek@amd.com>,
	"Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v4 0/2] Add support for VSC85xx DT RGMII delays
Thread-Topic: [PATCH net-next v4 0/2] Add support for VSC85xx DT RGMII delays
Thread-Index: AQHZjKjyBL1w88/DS0eYmV608mmKE69pMsaAgAAFAAA=
Date: Wed, 24 May 2023 10:15:39 +0000
Message-ID:
 <MN2PR12MB4781511549A290E2A2F435B69E419@MN2PR12MB4781.namprd12.prod.outlook.com>
References: <20230522122829.24945-1-harini.katakam@amd.com>
 <20230524095645.5sveiut26vz7yv4x@skbuf>
In-Reply-To: <20230524095645.5sveiut26vz7yv4x@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4781:EE_|MN6PR12MB8515:EE_
x-ms-office365-filtering-correlation-id: a245f883-02f8-4b13-840c-08db5c3fd2bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 U6uGqSGcQv7FJqp8vyHAWr95xF4VDekmhEAe/ekgyoKfCpZYnUrsKMsibozFwDHMghb8jnQXCuKwo3/lNvVLhyqykpfhJXo8ydsSsh5pVdiROVqLn8IqZf0ixjmMmuQAxgsJSWGfxRTMAv9ami5aIaDkDegf89xXD+N3IuWs9NYmmEZxF1iApen/66DkOxFwGN1x6HhuuVyvsrkIL0ZhBDSFfg5VlWmRKNhPHmsZBd0CvSEGhjUzbOQDuU3QbK6AhHzQgKY+ERdY3YZqlMEgWHUh3pp0ibCHjhoWo4aKWPrsHcCsiO3Az4fmjFE7S+YonitiWxTSJIZuAo1/JOw2vSjd/IiPlwYQQ8Mi6KyiUTMWbTMpfCXRL5OhDpj6BjpPVlKjasJZP2Ld7LH3SaBxiXrxkTvOOyIf/lRe+PacfqVY9Ejp5klIK8t1MkzoVN5c3w8k9ICY8ot2i9lTnVFiweKoH1FUtOzyYyDlWnbPJkUQNHqHlp/j705ZTw2ng+wwinOXcg+tpETncCsnRusy9Yw54THcMTTXyoBDr7Qo079YBrXeyR6dVY1w0GC9pUQiDhky/YH6WwNRLV43tb2VcdhbYdZXOPcT0RnvcOwYnIQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4781.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199021)(76116006)(966005)(478600001)(66899021)(83380400001)(38070700005)(6916009)(66556008)(66446008)(66946007)(66476007)(64756008)(4326008)(38100700002)(122000001)(54906003)(71200400001)(316002)(7696005)(41300700001)(86362001)(5660300002)(2906002)(55016003)(8676002)(8936002)(26005)(6506007)(9686003)(53546011)(7416002)(186003)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?r8E6d9BD/yJckQjVhqSbb+SVkHvQeEdmh+2TDK1zYxqBoL2DlYtCOVb9EOqG?=
 =?us-ascii?Q?Ku70SOj7/aqBL+zm9AWb9HS84fITdeTK2U2NtHKyc27JCWBF+fMzmmP3pYiH?=
 =?us-ascii?Q?zc6Q7yuoNB5+E0NJb0b8+OTydFpWvEqsL+3clCK6OzKGaefzRG3rR1BGg6Gr?=
 =?us-ascii?Q?U7pVa1Znw3Maqoo/MR0ZW1PzLLU1Ike/56BYYmxy9JkVlm9mBvTUnrxEnfck?=
 =?us-ascii?Q?WOhs2O/wetbP4uKw8QsxUWjq+ZWfuHrDnLKJDxEpUKwni3NHJ2wta6n3REsT?=
 =?us-ascii?Q?cG+ulhYkVBuO40zHYf8R1mqJa8+xkW5uOgVtJB2CFcyz4FgNUKqd4+BLjDQv?=
 =?us-ascii?Q?D5hZD0F4oS/PZtCFq8XLdO2kW5CSRGNYamytHSUAJ5on2XWl2ciS00J9lyHy?=
 =?us-ascii?Q?OFA+p9exdbgC1twMg5oX9nPBjZND8yOQXVYef8pXqEldiY2OQweHxhgvq5gk?=
 =?us-ascii?Q?kOqO3yVyAuolLGtS46p/l5s4KQkqz2Cei1nkBodvX/AkC6S7pfnZ3Rixqf/s?=
 =?us-ascii?Q?AD/XEPsoT6Fb+o09UoWrexRKBM9EBu4G0viqMFJJDAlpxZ2W+//KYdD+pcw/?=
 =?us-ascii?Q?Srs9tkL0LuF+RcA5m7Rvl2xLFS0DLHBl2Ttz/8B8c/7mvPeSoi4kwDRoTtKJ?=
 =?us-ascii?Q?efwNqkCTRqKJvx2V0cIK7zw7YBILDA+xgPMccX9Ec/vHu2/VxzJguzXaPSrK?=
 =?us-ascii?Q?MNuAtKo1h0DxR8fpNFcVYYtQ7Vc8M0pP/pS1x9WTO45mZCI00e6/04iaIMsj?=
 =?us-ascii?Q?zL1/peYP1oRSBH1Cn99QJ7CD2ISM9YFx3Ycq/tQLh/781H/5WFr46rJ3BPET?=
 =?us-ascii?Q?aaR//8ZZOGcNFBhClM3oqS6FjWFTbG7puRGtKRvF9RTIV7khGI1P9X6WMNnt?=
 =?us-ascii?Q?RNQXEKPN17G4eSm+ftw1pg10k8nrL+bmVz0apUCHSppSUoqJDtM/6rp+VPiX?=
 =?us-ascii?Q?qu/tgy5KOxWkTS2fWtX0rlGVaGMYhuZle4GdT8G13Xc0D/LAZfcXmoJ7xNma?=
 =?us-ascii?Q?QtfBS3cSdBgGj+n5aqJXqFe8dl7r5i2YGEc0hKKUe5ntkCWC86ku+N2LtAYT?=
 =?us-ascii?Q?nLnrdsp0BGl4z8Ni09UwW+hvYvUojyxCtuSuuUZr+RJvoHnPqHGfR8Y2knea?=
 =?us-ascii?Q?7EVOBgtKVBH5HtDIDlsoA82CI9WzFox6Bytycmo+LaoaLXJXZigszduIxHjY?=
 =?us-ascii?Q?gKGNjMbFDcdmhxfDSe5N5X/X4KCAzG/0DLxN8MWRHF4dLDyS7Fwk3sEuEUax?=
 =?us-ascii?Q?e/NcT78nmLuEHK0vVsCW1OW2C9/S5/vrDHAGefritK+fZvpljfa3rKL6gGTV?=
 =?us-ascii?Q?fxzihW6HdNxnNZyzKO4+jNOz6M+O09u7XP7JzzrcZr2Iaug1FoxMKfLuTDQS?=
 =?us-ascii?Q?Ml2CWwyheP073AwDTzkz5/Yk48ZSAJfjPA/7TMjjsamwlfJr9J91/BpnoGP4?=
 =?us-ascii?Q?HKiY57+PE8XkEcY4trPBXHQdIHa76FSrpZB5KCW2h36ZmlV/DpPUXbYKjenJ?=
 =?us-ascii?Q?RlClNjNidKbozR9mQwOiYiOKDt3z3/rkXP3/SDJeoOc213i0qvYl8rEO9XwO?=
 =?us-ascii?Q?bxuFi6QALjjVrRBnK00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4781.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a245f883-02f8-4b13-840c-08db5c3fd2bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 10:15:39.0874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RmbXyhYazAOL2fFjQ0meTgwUSPMFRfuac1PKyh6qw2n+j6to8mTS0fUuwASSNJFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8515
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, May 24, 2023 3:27 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; edumazet@google.com;
> pabeni@redhat.com; wsa+renesas@sang-engineering.com;
> simon.horman@corigine.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; harinikatakamlinux@gmail.com; Simek, Michal
> <michal.simek@amd.com>; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v4 0/2] Add support for VSC85xx DT RGMII
> delays
>=20
> Hi Harini,
>=20
> On Mon, May 22, 2023 at 05:58:27PM +0530, Harini Katakam wrote:
> > Provide an option to change RGMII delay value via devicetree.
> >
> > v4:
> > - Remove VSC8531_02 support. Existing code will identify VSC8531_01/02
> > and there is no unique functionality to be added for either version.
> > - Correct type of rx/tx_delay to accept correct return value.
> > - Added Andrew's tag to patch 1
>=20
> Would you mind waiting until this patch set for "net" is merged first, th=
en
> rebasing your "net-next" work on top of it?
> https://patchwork.kernel.org/project/netdevbpf/cover/20230523153108.1854
> 8-1-david.epping@missinglinkelectronics.com/
>=20
> You should be able to resend your patch set tomorrow, after the net pull
> request and the subsequent net -> net-next merge.
>=20
> There are going to be merge conflicts if your series gets applied
> simultaneously, and they're ugly enough that I would prefer you to deal w=
ith
> them locally, before submitting, rather than leaving the netdev maintaine=
rs do
> it.

Ok sure, I'll wait and rebase after the above set is merged.

Regards,
Harini


