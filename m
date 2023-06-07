Return-Path: <netdev+bounces-9092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E4C72738C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF7B31C20E44
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EE01DCAD;
	Wed,  7 Jun 2023 23:57:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55551DCA2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:57:15 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2139.outbound.protection.outlook.com [40.107.113.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970FA8E;
	Wed,  7 Jun 2023 16:57:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+TjoTFC3TKOyVwD8tne6XMRT/GnXaiKu9ak0YuN/WY5jQTBdcEDUHjnT5J9oRLB04xo7Asd0YGtsYNm65ItLsZ5txON7CFZbYB6Mhm9VFBez7L7nByI8iBnhNu+2/rKfDuB3CxyLiuPtyLT1s6UFlewGP9IIdwj2p45KWAuB4Q0X3o8Vtaw732qVfWlOXmBhwGO3fbu1EocmtsuHKpyimEPHbd8hJT5l1SAbXFXRvzLmE4UQQ++TU5g1aQLS89yrb//UIA630uwmYGZdLy3ttBoljXbOTTUnxFzLkakG7oiAbVPxGcVyMuO/FhC6bIOoZiR88Oyg/1gTRrxYQlU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccbVUHjEf6QnpZabsWY+4cESiSQ4/cMRmFXLa0WBR5Y=;
 b=AOShWf911xcNnVbfXvFl3WgB3XgJaqwsS4p9g0ZNy/TkUv0add5IkHjur3e2+V0sQv/FYS+Az6qZv1Q4SLdNrPQx3eNMSFVaXS5G54Kb/CuCvS/urNzyrahHmLTmZ2bTdigdYguH0jxXFWUFqsF/sGyWsMhJFWPzqDTfCuuT2yo/nXur/WYpLUydWN49tFeG82m8SkDf5UVYOPPm/+nz/CMD1axYoVA3RyqhEGmhriA86y4KQNGld+FZTGDUHJ/O7sBNe3LG9enGAj+60sGBTYSR+MHnRjKbJZSlC5p96JjWMktMiij61025Qo5/JHMgPicfREO/MtmmNmYJlMby/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccbVUHjEf6QnpZabsWY+4cESiSQ4/cMRmFXLa0WBR5Y=;
 b=etIKTV2s16RKz6zpqkctqsGfxtJwNRgZBLZeQZKDkPmBqqAOjjjMlzh0RK+hwL0IKfGJwIMcTJZ1WXuI5PMutliIquZR81b779pLEMz7yb6vK7m6EA8iUZTNU6Tl4MyFhMAB/KtqNwpQHGKS+x5XAD9eIzWwmgTm3ECSBN2fc8s=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9525.jpnprd01.prod.outlook.com
 (2603:1096:400:19a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 23:57:08 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 23:57:12 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/2] net: renesas: rswitch: Use hardware pause
 features
Thread-Topic: [PATCH net-next v3 2/2] net: renesas: rswitch: Use hardware
 pause features
Thread-Index: AQHZmONUUcyXQd79KUq12V/R1T8l0a9/dmCAgACPGCA=
Date: Wed, 7 Jun 2023 23:57:12 +0000
Message-ID:
 <TYBPR01MB5341C785A741C9A2B07857ADD853A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230607015641.1724057-1-yoshihiro.shimoda.uh@renesas.com>
 <20230607015641.1724057-3-yoshihiro.shimoda.uh@renesas.com>
 <ZIChDe2LHcP1Ux+O@corigine.com>
In-Reply-To: <ZIChDe2LHcP1Ux+O@corigine.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9525:EE_
x-ms-office365-filtering-correlation-id: fa221e1b-2d88-41ba-6613-08db67b2e971
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 /dmj9sth/FCfVlKQrdTlyOLsGQ2jWrjszQoDaoaHIsKq0bXebqrRbqu3x1E39bUXIN+2GAiga5x1+MRUItFdGoMXbG/7dpKsLRpQCURE+FIdAsrPKWl6n7Hejcjtyz3F2YzhQms0BUZHBYvnyFNeNESd5OzdW+Wx2HfaGS5nodYE7Yrh+GLRLSvj/9uYs6fuU46TagV/BAEhg3qzTY7tqrVoecCJLoQN5HiTQYZJT3wZEYA5xinmsrtHhpP9RMBvGK0AzO4odoPutUwbmC5BZXjM2O+ANRiDaYvLc0vJevuvuSnCZNLBU1e/pmTLnYtl5X3ZXiRM8gsRXuKpvDkEQGQAVVftFR5zuKZNM1frfBh9p2dmF3BznTM4aWAhl+SF/dL5ZogtUm3d9+q/sSWUV8vtHnkuGmAbWep6TWz65CZ/PfJRDc2foDeRYr0sadR2WPkux5e7qRF0bfAFSKkrNp15wdr4u1t2niE9bQO4nqt+QumWTDXmgaDJw17cC5N4JirhQwwqqbglQJhNSNIk/HFmnMInG25Ps8Ajd7i17U4KiwEsi7VGvacLTu78wJDrHQNj94oJI9TIWRefOvkf187ivX+Xw4p6WlLhdU8QzAqkBU4HN6sT7Qnux8OuTXyW
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(55016003)(86362001)(4326008)(64756008)(4744005)(2906002)(54906003)(41300700001)(52536014)(38100700002)(33656002)(8676002)(5660300002)(316002)(122000001)(66556008)(66446008)(66476007)(6916009)(76116006)(66946007)(7696005)(71200400001)(478600001)(38070700005)(186003)(83380400001)(8936002)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WAlbfLovdBrmBvCx62TOYBPD45sjmYBinw2zTb/j8Km4m5CCgdsre7mAaPXX?=
 =?us-ascii?Q?6IRiw8GzlDc4ek0sJU+x/na6HmLXyGpZWcpPuD99H/MYOHX560y4b066cj3k?=
 =?us-ascii?Q?mjvUmqC8WABJkX8xVK2hdQUBXi4FPDd1vI9bzdaUk97Z69QGKbl+zUHNcKrE?=
 =?us-ascii?Q?b2836lyf5f2z0qsRtjnkoiQmsiPsMGVPGxSyMmns5M1dk16Jj8MVuWF1Rux5?=
 =?us-ascii?Q?G0h1yn6JZ5CdK05M9MMyjkfXeHePcF7gs0PtBAPyyfSyOTGfn3F0ebgw5bUV?=
 =?us-ascii?Q?/tsMrse09IvqYDaZKiofPsTY3+CmV0kwkFnXWkKljdQGMnEG05I0UCNI2nBK?=
 =?us-ascii?Q?RnakqZcbh5+4REB6Yz3fEurR4S249xp+//sCtMucRTACM0dQQmABea7vg8dH?=
 =?us-ascii?Q?/k74SoAX5aCxThQ+ho0N96Y79bTwT3OZyioQ3UlN+e6/3KrJGVKiuNXQl1df?=
 =?us-ascii?Q?soMGrVNBBy8veGgtt4r1F5kwkshd+4tsM4YEDTnUfDzzBADwZOeRhnYfIVrd?=
 =?us-ascii?Q?Y1F+5BTn/j+AwMH7HAiu8vqTGfr9Qt1h2rNQLMb4+u16tLxqaSKzVNu+BLac?=
 =?us-ascii?Q?Ip2nrWXQt8Kwxl1L+Pwwr76uosF5voMtPXBXgmr/zt9AKfArOdfnV8B26RI/?=
 =?us-ascii?Q?2j+M0PSnU6om1ciWfxkHRjw2rQzd/Z8/cVv8gbWXodIXcEu1nKf9xrOOS0AI?=
 =?us-ascii?Q?YTkjjw0nnOcqqbO+k1plnct9jIBwe92zJkg150SE5Qz4qrDVzrTbZm9bl+52?=
 =?us-ascii?Q?OxR3BylCe5dw/0WTSGH0AD8TbqAbnfgZbYDQuTEKk3vi9/v8yD6rdK2KrsAP?=
 =?us-ascii?Q?QW0+bjuDenXpDsV/UHekfM/RKwsb0SxuViChBbaT33Omn3oI/eSwFh0iT/5W?=
 =?us-ascii?Q?o2j2EciO50jDsUoBc95WQzblCWEOm+KoWFtttG0ITskWeH/YkDcRVeaCYljS?=
 =?us-ascii?Q?mE1qe9cZbViHLE8aBmpMh6Xn1ZaX89T0iqm2mIvO19e/3xj3addjVP1+2Rzq?=
 =?us-ascii?Q?6Pp0/ZP79GHpCjFgYpFaICi3cr4YhEdB1//2s+6B2oaMAdKmFODeihPnb2M3?=
 =?us-ascii?Q?aNWjy9UcdonIwcrq/HOu07XMZpGSswHM2QsrlRtrQC6rBCLweQwl8atCrCjs?=
 =?us-ascii?Q?BNubrsBX4kbVKHqQC+WljzZhPEqCtQSU5q1ukknpjdHB9jbX0uA9X59QuYHW?=
 =?us-ascii?Q?gL14n8m9XJSEyR5c8sup4Dzzlhu/ezkGbPsiHo/BlWEUghYW9cTzFX/zdhee?=
 =?us-ascii?Q?ssfT6iJnLQnJSqB9U7wS/AcnSg6jbfFx+MHNP/wjj5a10roIF86ANbshzsLw?=
 =?us-ascii?Q?rd5p08u77kI4h8Xcm+LEihe93D9vZ2UDH29mxo/75z63cayrZaI6ENSvTXaP?=
 =?us-ascii?Q?Jiy6jV72VFtjlCKPqD1EYS3KRR/T7zqU1rJ3LSUssAfPVVMgI/yCpzW+CQ7U?=
 =?us-ascii?Q?j9CeBcDl0XmihZQK7YVR5seY/RN2Mc1mth8HPldiNn6e8TzwH2fABcTgBtCg?=
 =?us-ascii?Q?aV8xbvw0VYvuJJnulwFmP2MVXFm2/MQ4myD6skmzB8op+dQyNGe2QWV/o49D?=
 =?us-ascii?Q?TXQRWnYtma9cv55RHwPTze9Tnl0hpZTcX6WZQoHu63JytyWQYUbpSNXwfBN0?=
 =?us-ascii?Q?a9DpKWIVbnRkCwFDAKKrI3SpGO1vffd0NQDBawm9OPLYCp35VyZO2jbDj1oN?=
 =?us-ascii?Q?/wlYrA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fa221e1b-2d88-41ba-6613-08db67b2e971
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 23:57:12.0866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NC/u7z9vNJp/x1Fd0h+kphWFCamg0cqkpnkW37znEFJX8EyzdSitLE3dmQDIIJzYr9D1ib+MPV245JYsu9JumUXtFWSTYn00lJtIP42spIL9ioxUjfyXjryivJP0hyWn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9525
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon-san,

> From: Simon Horman, Sent: Thursday, June 8, 2023 12:24 AM
>=20
> On Wed, Jun 07, 2023 at 10:56:41AM +0900, Yoshihiro Shimoda wrote:
> > Since this driver used the "global rate limiter" feature of GWCA,
> > the TX perfromance of each port was reduced when multiple ports
>=20
> Hi Shimoda-san,
>=20
> a very minor nit, in case you have to do a v4 for some other reason:
>=20
>         perfromance -> performance

Thank you for your review! I'll fix it on v4.

> > transmitted frames simultaneously. To improve perfromance, remove
>=20
> Here too.

I'll fix this too.

Best regards,
Yoshihiro Shimoda

> > the use of the "global rate limiter" feature and use "hardware pause"
> > features of the following:
> >  - "per priority pause" of GWCA
> >  - "global pause" of COMA
> >
> > Note that these features are not related to the ethernet PAUSE frame.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>=20
> ...

