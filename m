Return-Path: <netdev+bounces-1899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B116FF6F5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA1712817E7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1BD63A0;
	Thu, 11 May 2023 16:17:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69271613F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:17:26 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8DE70;
	Thu, 11 May 2023 09:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTDJS67XjZl6Bcr0IHXLVyxe0DP5K9y3isrkA4VE97zhHneOmEXHxaOUYDbZKhoqTtO2UYTXkCY2kV6+6wO5XAfmlAfd0BUlnb0cP45Iilsd+uVonpzKbIMNbqf8rNT8WsRZ+yWx/B9+hN/yf1UX2Rh8Q5F0+Mqt1tPjxg+YRJSEZlGio6ngLLzKhDGTUELU5q6J5UZV820852qBTQO8pop6jiw9ha+EsgVZkYab49oc24y7+7x5T1CLpZIbD2NVcK0eqY7G4Y6oAbv+lk7WZI4efAzi4xt0lbOvWr2ICyaUojXCnca6Ky6UDW197sAMEW9y1osBJVwNZOyODPgj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epgnWgH6tDtZJdNNcRVpfvYn0RY6pbORDkaUzmDDyQM=;
 b=CzIk4acaq916TRBZ8SXoOWeQYcmym5TL9rkol/zfMjX2I7Vm/6DDKZxJfLSYVrv3rLzRc+M2RRSpBb1xMyBVSbtorJ/vDJCNKSq7y25f1/G9/RxK8vOndbjH8q5SaZOQiiK8kidiV05mhH32In397oGrsgzTBjiFIVcT9lkeSOjH15CzSG7Mn+MGG3l7tAcjVoXoO8itqaQYeE66SOjE3vR9G49V0PKzL7UsiqtX9X7v07SbKza9bBjEivTch7Xm4hgqPsfFixiynDf+9SrA5jZZ+20gSWVXgzAQq4xlsC0BquWYgXLitdJWzQWWD0FGXSLTOESFf+KeMcuRQ6l+5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epgnWgH6tDtZJdNNcRVpfvYn0RY6pbORDkaUzmDDyQM=;
 b=Pr2Gh1A0bJPxopG3aBvDHEwJSoEkxBjEHlNSc7+ObfbyF+LdKBfaRnFeQdPA78oRnjNaCHXfx9TD91wXroXRHEFrYFvEOsDvaluOWXbtAumeh23fG81voJvpYgIrmgOljs5X8EwgvzbX+E/qWSpAi7syA01PXjtYB+iYDZ8yavs=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by PH7PR12MB7354.namprd12.prod.outlook.com (2603:10b6:510:20d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 16:17:21 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4efa:ce77:84f7:93b1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4efa:ce77:84f7:93b1%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 16:17:21 +0000
From: "Katakam, Harini" <harini.katakam@amd.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: "hkallweit1@gmail.com" <hkallweit1@gmail.com>, "linux@armlinux.org.uk"
	<linux@armlinux.org.uk>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
	"wsa+renesas@sang-engineering.com" <wsa+renesas@sang-engineering.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>, "mkl@pengutronix.de"
	<mkl@pengutronix.de>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>, "Simek,
 Michal" <michal.simek@amd.com>, "Pandey, Radhey Shyam"
	<radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v3 3/3] phy: mscc: Add support for VSC8531_02
Thread-Topic: [PATCH net-next v3 3/3] phy: mscc: Add support for VSC8531_02
Thread-Index: AQHZhAFVaEeZnn4aeEyZcvSiQUtANa9VHQcAgAAW1qA=
Date: Thu, 11 May 2023 16:17:21 +0000
Message-ID:
 <BYAPR12MB47731D5AAC7091F89C2CA9AC9E749@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230511120808.28646-1-harini.katakam@amd.com>
 <20230511120808.28646-4-harini.katakam@amd.com>
 <ed6cd234-1d75-47f4-a808-6a152a63af0b@lunn.ch>
In-Reply-To: <ed6cd234-1d75-47f4-a808-6a152a63af0b@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|PH7PR12MB7354:EE_
x-ms-office365-filtering-correlation-id: 0c0b64ed-27c5-4ac1-e8cd-08db523b32bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0wLkPdS0RabNYl6WZsQMVwklsN2zZce56h7orzRwVvsN81oi089quQRT8o4iXbAin8VcsoO1fmtcmMTT9ERS0swxyk/Dr8EVFAeif9CUzJBa3TVfL4WbGuMQ88ymgyqj4BSRti3NB2v/4GqW5SMHTrj2Bvxx8n0MYyAO36FD29Uac7Os6H4WhHU8f1c/Ov/Rig03D6ncsUe7lELklrq7YPLHku+DyW6yuXOKQTTVNW4p2K4oOFeZV8bz8CNuiSoqWKObpuQk37PVFj0mfaQ1tIEM7HfsVBTaO39oKfQFg2WXeShMaWU35KCZMZ8GqpuHQDQOBR6u/G7ggIBW1rlbEn1FRNmWH7amBY9woEXBUNHAGgjVJM09UZ+MlcHV5ZGvBxpL+9qTR7DVJLqH662e6EvufXxCSyYahFWEemB6wcqruFrR5zK9UfN8qLqPmtCgb1/Ime/Idi3NIDtmsN62cRdXChxIl6P9d9IgvJf+TUSaTuZ183PX4rPUnGEAkdL8HWUobACVi9pbFaRE0LoFn0bDkKExexmXt6icnakgpHNt3v0k5SUq7aj+iCpPF8oa0p5jZ/qII6QZFIMMP0gKmFcr7ajBQgm1vtnkGsAOhLM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(33656002)(38070700005)(86362001)(54906003)(316002)(66556008)(66446008)(6916009)(4326008)(66476007)(76116006)(66946007)(64756008)(966005)(7696005)(478600001)(55016003)(5660300002)(52536014)(71200400001)(8676002)(41300700001)(8936002)(2906002)(7416002)(38100700002)(122000001)(53546011)(6506007)(186003)(26005)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?e4otYyQeGKke/94dBoNDTo5lvGzMQG0ubcIDMAIT1UgHAvwdb80q51DYXKIa?=
 =?us-ascii?Q?j6VUOkvR4ixwuNYB6kwT3idqT/utOkbf/Ti+2OM9uVY2wk0nXG7WvQbJBlMc?=
 =?us-ascii?Q?OMNYZgAZX7DGCSG8asUSl731caALfObvvH6UjOBcgyoWklLp79qzaDhsxag6?=
 =?us-ascii?Q?8egYnhc4FXN7QdBSzJME0u/vOHZOeZI9uO5yhQ/Txs5s+mBSb+UUJYnkxj6j?=
 =?us-ascii?Q?CP4NhsOkY9TOz1jtZAYFVTgFXjgkBkRjGPTTx1ljGbpWkrMx/5Ge+PEmlefe?=
 =?us-ascii?Q?HM8efsPqvjVSDGyLyIfF9hKK5RskG74+v/r5pBIqhx594e8Uiy4uJ0h7JpHk?=
 =?us-ascii?Q?SKcvcShwC3KahuYQmQKVCgDkmrt6qq0JliEQA76owxIY6MlxS6qAGEfvHgYv?=
 =?us-ascii?Q?E3goOSIdsxu8nEymqnFJLDhxvxp8Z8+VmEFH/O3BrHGOoRs4C/pivke8OkAt?=
 =?us-ascii?Q?stzR5F5VoHpkPFLHUDhq6sBkX5uOI1O0Huas7clytpVOpaN1OeVJr08oyctq?=
 =?us-ascii?Q?o18+/909eenWsQ+VA/YuUs4EBAQOKsQl2cA4PjLFPyrq1NJQzIBUYPNJ56LA?=
 =?us-ascii?Q?uZEscdaSX3C/+m9XwJVCr0qk+NLlpVFB1MW4bIRcLeRl15KT0QKOdkEOx72P?=
 =?us-ascii?Q?o34yZB4uCb/dUpAyX+H6ywW9yAXrKN74YVZCWHLvIxy4t9gyYp77wF/Y4f/l?=
 =?us-ascii?Q?pSTglfY9QFbZhJoXE7KZgG5RZHK2ppqGlHZ7NwgIqa4F/4PYnn0dVVIaxPGP?=
 =?us-ascii?Q?U3jCb9iJaJvsVZY8YfSczcBPTqrgEGWNsWP59cUpNvbuyWQVtV2y61IO8XGk?=
 =?us-ascii?Q?oF93GVtBxI/oMdlJnsJr9n+Uom+bQRC+sExCImYjh75HIyl/mod9kUpsjrQB?=
 =?us-ascii?Q?x0m0nA+gZ5NVIhIAoXpuwNhvH3l9OWWd14w6a9u0oSh/TB1ettkY7TdWUpMa?=
 =?us-ascii?Q?zilqRaApz5pwK9nd0ZNV54mSOrxkGaptcPmgP9i14tjn42UANd7jO7MyTrBo?=
 =?us-ascii?Q?KGqwU0TT5kh8kn0kVNMlgLk9MTSeB0SjYBEhYJmTA8K7+tWV6Utt/cOcgTiD?=
 =?us-ascii?Q?KBHYmX6sha8hi5drepXclsH+A0JiXCdEC13ESgAXJ/iZSEsyPEqTCe3VWFIX?=
 =?us-ascii?Q?PdkBw0qWD1E1GE5u6GfwRyNrLh7hAJ8hjmnoexgSWiroKnCFU8LHA3nZgJco?=
 =?us-ascii?Q?i+IFsyQuJynQrcEUu+nguN9dLKNPZK+fvnMEvDBtCVlWhQQpwsUhjl735FVw?=
 =?us-ascii?Q?mE2Cp9AkkB50/FdDtygmwt3jQ8eiZYD98HCfjoKl4CfIsWm5x9cxBmKm6klo?=
 =?us-ascii?Q?3m32qtbXVIKpwVNQUQbvwznKGxjSqp2cveQL/EZ17EmTlPftF9qWfsQkot2X?=
 =?us-ascii?Q?mJ9ar1f+ndCExQzba2xkixD93Vw5mZG44NtHLikDsDpcIg7keG6l7BYcMyoh?=
 =?us-ascii?Q?t9GmLy4XYwQ4vtPOnVHpkWQjh5rUIExEcpSXMWYXP9GRSbVPVbwm2ibrAna9?=
 =?us-ascii?Q?yCEt3vvLdjWLKSUCyeIpCFBRdgrz4oZWeQ0oT2p9fVZPTMB3L/GuRZAyHTQ2?=
 =?us-ascii?Q?xS+XHR1TN9caCFMDaZI=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0b64ed-27c5-4ac1-e8cd-08db523b32bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 16:17:21.0815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+6uRrHLf9fHcqWbTtCUfwpTl/MeB3G9u8RUi7mAAwwIYf1J62O+lVTMsGZudrqP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7354
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, May 11, 2023 7:42 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> kuba@kernel.org; edumazet@google.com; pabeni@redhat.com;
> vladimir.oltean@nxp.com; wsa+renesas@sang-engineering.com;
> simon.horman@corigine.com; mkl@pengutronix.de;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v3 3/3] phy: mscc: Add support for VSC8531_0=
2
>=20
> On Thu, May 11, 2023 at 05:38:08PM +0530, Harini Katakam wrote:
> > Add support for VSC8531_02 (Rev 2) device. Use exact PHY ID match.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> > ---
> > v3 - Patch split
> >
> >  drivers/net/phy/mscc/mscc.h      |  1 +
> >  drivers/net/phy/mscc/mscc_main.c | 26 ++++++++++++++++++++++++--
> >  2 files changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > index ab6c0b7c2136..6a0521ff61d2 100644
> > --- a/drivers/net/phy/mscc/mscc.h
> > +++ b/drivers/net/phy/mscc/mscc.h
> > @@ -281,6 +281,7 @@ enum rgmii_clock_delay {
> >  #define PHY_ID_VSC8514			  0x00070670
> >  #define PHY_ID_VSC8530			  0x00070560
> >  #define PHY_ID_VSC8531			  0x00070570
> > +#define PHY_ID_VSC8531_02		  0x00070572
>=20
> Does PHY_ID_VSC8531_01 exist? The current code would support that,
> where as now i don't think any entry will match.

Yes, PHY_ID_VSC8531_01 exists:
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10494.pdf
And I'm sorry I realize now that this patch breaks that version.

Also considering your RC on the other thread,
" Just to make it clear why the existing PHY_ID_VSC853/0xfffffff0 is not su=
fficient."
Currently there is no difference in the phy driver structure between
VSC8531 and VSC8531_02. Let me double check the identification on
my board and skip this patch if possible. The RGMII delay support in
2/3 is generic anyway.

Regards,
Harini


