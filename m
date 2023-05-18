Return-Path: <netdev+bounces-3697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF00A70859E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CDDA2818F4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB6923D48;
	Thu, 18 May 2023 16:08:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0C53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:08:05 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2087.outbound.protection.outlook.com [40.107.241.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E71E5F;
	Thu, 18 May 2023 09:07:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4foMgQ3n5wUzHxcRXIVen3B+1qFr03WMwjWDQ5VH3eNbmc7AvRn+XEtjJBgodEi8J81nHaDxxty6SJY6wS9PyUVUcyGgWvWUUlTyHc1ojBfCz826xkqilvw1QlydxjMmiOMwvHdhg7idQPk6oGHummdi545MZEn7j3nC8yK56th2wgsbAbCjz4aWHmPwAPs9L7xgf1PlPy6apXX4jJW2UQlsaHfOr5N7hrIeB9m5m+jmUbRyeInmWCpK0oDOGas/8wQSeNSzWUoE8xzJttWDABboqDWzjJr6vjIsgDCTX8Dzq47jAfHoYXe1frjIqB7CVAKcNpoG/e4v2WZKztKOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y28VatYotYGysRf04a8jYkt4+LZ3pp+5Ty6DtHEGsKY=;
 b=SM64rVOftoAJF3f8eEWGP4iPJZC38QKSq6WbXL7DL+B3QeJeKVJAXI1TflrxV846Wx3a9rwzpk4TsmQgnPxcN6ui+Mb5HUFrn+hO/3+IIQCiyONoAmytFQqe8NZMxsxvtcxySd/S4kxyoLtzFT7kF2vDayrHL1vI1gMa9zPKBDMpkfldQ9yVGqZF+r9/qtbBvCBkP5CKLGX7QEL0dHX9czKgJQaCCzTbIXNQEpJaBSkS1N03mSpnZwptkAjueOvwnkWdtSmau3aGIDr1IaipdecAMWRlqWQZWUNDpW/1OEC9wd0YNJpcP5qbsiba8ZCg1GgXThYXDiahFGpF9xzYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y28VatYotYGysRf04a8jYkt4+LZ3pp+5Ty6DtHEGsKY=;
 b=iDUE+OOYINjT+mELN08zIDK+Wkd77L0N7kJoCEb3MYamVoLrqFO2fNUxAj/z5ua5Atu1W23Bf0HbR+IzVTh7p+R6IdhDeoAsR4Mli0RBfW1YXa/kgRUkTNk9xPis5aFyR9qAQGlf9ldTaISn47HxR+nazS1hdi5r4JDJD7nSplU=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.18; Thu, 18 May
 2023 16:07:41 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::357e:1303:2081:eb22]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::357e:1303:2081:eb22%4]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 16:07:41 +0000
From: Claudiu Manoil <claudiu.manoil@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
Thread-Topic: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
Thread-Index: AQHZiZ9Mn1H3wq0ZdUiQU+C+AaERHK9gMdXg
Date: Thu, 18 May 2023 16:07:41 +0000
Message-ID:
 <AM9PR04MB8397A8C3D0EAD6B39908CFC3967F9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20230518154146.856687-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230518154146.856687-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|DB9PR04MB8106:EE_
x-ms-office365-filtering-correlation-id: 85894496-5662-4dc9-fba5-08db57ba0219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 LTA7AUXf+CAH32h4tVz9t0YJ9p8GR7d14bn+W1dzG0tz3CKSJ8Zuqa3BGi/1v+ZsqS4R/A9UOKRmgV13yXQG2aYFZFhNFzvgislXQf8V2OVRxz0NMDyULL4r1XQYbF8LiWO84PvNTV/t6GwXxrxnkqLr5D7RBwPPyXSD2FCCIUiiBWQJPBm0G6XiO/ZKTiTCC61PC54v9P8EaJDSBbY0GxsyBE42nGYnIlivAQSjgrV6fr9EBaB02yn/iT2JClFfAHwHcgtUqrhOTcJ76u5xqB5B/1s0ZVRktI/rhdQQFisJ25GXFkR9mo+qYJmupx0wmScHtQsoO2MYWK9rbV7yZjXPmJfGuLvGHskVvtMNisC4cP/nBAUBWwJe2sWmcaAy6hIw74G0sdK38tG5C+RlGUYEx6k79usJhXH+krEM9VAN87zJrxR0bfJNL//yaRSTRrX1AgBUKG0WOAi5tTCPpTHmaiWQATyHjZd3p1w40iZ4i8HRs9W1MHodLmRVtWevJ1wWpRqPXd2/WmEHgcnONMBaohUDVbH0IPuAFO/Ik9U42QBECZk58YHvJWcSQRB6Xocsbu9pSQ+RIwnf05MvdWBWQ3IkUv15i3/KksJstSjeqRVtIPfFcC4dq+x6anbG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(4326008)(478600001)(66476007)(66946007)(316002)(76116006)(66446008)(66556008)(64756008)(54906003)(110136005)(86362001)(7696005)(33656002)(38070700005)(83380400001)(6506007)(26005)(53546011)(186003)(9686003)(44832011)(52536014)(5660300002)(71200400001)(8676002)(41300700001)(4744005)(55016003)(8936002)(122000001)(2906002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?k7lT3BXxQC/080cf7lltS5eomwkxMweDfnp6OBI0CU1Ib8HaTnV/8+5Y7RA0?=
 =?us-ascii?Q?3k5a2m19/ty7blTANRvg8bV/VpbLhMMr4Sg5v65uCxc6MalyvWnUgqX0ncAB?=
 =?us-ascii?Q?1iI1427YuO4ULzE19IvQ29HBxj3pSTPDOGblVwi4Fs3Zkz5nhoqE4m4U/zQi?=
 =?us-ascii?Q?XfphNm4uhaeItP+n1JDULF1FNiDQV5jkKRNXW88srwoQWfYbo6MZ9ywBOIaS?=
 =?us-ascii?Q?v6tSJ9VK/ieykyO10cT8QGScfXnw0r1UvLh03cBB/xE2GHiDO+GdMf7sBrGn?=
 =?us-ascii?Q?b3fpyFrGqPT0rLYie6Q/SotMqDqrrhNgh+5VBGopfx77uSvRTNQXEq9vOR1h?=
 =?us-ascii?Q?Ukec35YAOYYmp5Rrop/BZmU0Lu1M1jjv06cO+rQG2CPy3QvoATRHb5dmU9Wf?=
 =?us-ascii?Q?o65c8vVB22mmOPORAX8ubAYenlRmD/ATHf6PgAXEI6HF8u+bJJqPMBjp57AQ?=
 =?us-ascii?Q?YS3vvRFZWnLfdHamDOyfBqj5GtIKCuMuA/tNxqwzGp/SA8eGZcm0ZpBTDF2k?=
 =?us-ascii?Q?tN0aW13NpHaFKDgokxaEpc1zUIihab0yHCAP43B+o0/aQoKXqpOAO3Iu4ArW?=
 =?us-ascii?Q?7krrs2xNNhbU7Qpa1lmjxh1eoEe68uX8zQr/IWCKTEXXPKUB/ex7V9jEeZaT?=
 =?us-ascii?Q?dW9CDrPQ7jaA8Kef213ZRs3h9YFiQ8HOXFLnGauFlF0FOFfy3fwyusWGoYDZ?=
 =?us-ascii?Q?oeWAGfcAKtgnz/ohlzKKJpQNASZxtX4afuX3Tg+8SES/N4tHVKNn+z18yNmu?=
 =?us-ascii?Q?4kvgStnx+/Rgz8S0GRATKvfpPbyk1yFXB+wKEJyIVHBhjJlaQ5ix6pgoTP4U?=
 =?us-ascii?Q?wmb0zMQwn+iMcjCh4vBH6yYVTgq5OYPfRRdNbcX/THE+XtioixZDQL2B5BuQ?=
 =?us-ascii?Q?ysabaTy9lN2S4/LrWubg6p0xovqQXa9h8GsI5i1uRt3cayH9v3fdECb3rV7g?=
 =?us-ascii?Q?fJWumtJDHLDQ4C/CVNjYZFBoe2U4qBwdht096okZ5RAwwtfjArDm4vjZSoCW?=
 =?us-ascii?Q?1UFL7NEhdAbR2ziqR1RuguxSWm9HEAOdavHP+lUzsVAftec1Tuds7zOzdp/U?=
 =?us-ascii?Q?PpJjO4cuIR1TmBWc7qa+zDH/p7jFs/9JE4FTaIUdjogxSeV3IXAlMIP2XflL?=
 =?us-ascii?Q?X8SA4QbOfwFisOzfCEpifKzY1jza8IfxxwjyVn0VCe4gIEjdSxJO5liH9JKh?=
 =?us-ascii?Q?7uhKMcXJ9GHIYhYMVJMZypWa8QfDKXVp8rgZioHVP6Kcz2NKAUrbJOuvrJLm?=
 =?us-ascii?Q?z72lyRLonIbgaJe5B+niX+sjZJMsnNN8nY9B6Aa1aj/+baE/bWICpr4AMi2T?=
 =?us-ascii?Q?q7uBIw0S0J/VCT+NTUa8fwEOf5uwloFKoJvHww+skSHZhSS0oGnIXPDUhevq?=
 =?us-ascii?Q?70i1zQIdYsFS1hqk6r3jiAAYmBYE7B4tlFtxDuMWHgLOZxmQm1mxmNSXDRSw?=
 =?us-ascii?Q?RvTeJC7CzJ7xkh+2LBjUtT5sxG5ahvMs0it22hWfeUKVjSjPf0PD1ENA2G6h?=
 =?us-ascii?Q?cKFZVjW9iCf7G8Q9USiZqzPMa/qhkWAb5BM0u5hXNiTb9yeVRsB9zpW75km2?=
 =?us-ascii?Q?nANGO88lQGnAI/mkrjwKAuh+exY2a4Glb0N5mreX?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85894496-5662-4dc9-fba5-08db57ba0219
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 16:07:41.3837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 36Xav9x7jlGMR6juOWGxTeyhuST4eTT9SM8xKXszIv1E6NKBgmh762pRfwfrXEI7oJmkelXyFrEB7tg27u0bVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Thursday, May 18, 2023 6:42 PM
> To: netdev@vger.kernel.org
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Claudiu Manoil <claudiu.manoil@nxp.com>; linux-
> kernel@vger.kernel.org
> Subject: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
>=20
> I would like to be copied on new patches submitted on this driver.
> I am relatively familiar with the code, having practically maintained it =
for a
> while.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>

