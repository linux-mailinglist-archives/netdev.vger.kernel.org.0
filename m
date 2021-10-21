Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FA0435E13
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhJUJjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:39:46 -0400
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:56324
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231475AbhJUJjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 05:39:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3GJhyGJU30zFOfMf9XpkRZno7DT8qCip75FXNoXwYXl/60eXPUF0YFXxRqfMvdI1syUds4HPjomeh0uvSvzW3VA4ByQiEroKGxiojc1d3KkZ5n3s30Y2el2LegtFL4kJJzfW2my7/8YmblqE94qW6SK++OhMTyblvUtdIcbQfpq2E9pqOEVu7uYa3l8ZdBO9J7HxLSVcu+iV35ZgwxFrC2JaEL0KS88Ty3OjCsWlwrkFFRdmUEnEgUlCoOVl4wJK8CfXP65mousNKFf/VjQCFHsq2LRRc3FMbpRZ569anYyiZVvjlqXgC/1UvZAec4LpSCTPK0yFfjeUL1i7qEuIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utzbYrvaMMZ3ui/6rIPs2qKVyrkKgfVOIc+5U7hyWWE=;
 b=JT+6pyQ7wPthN/oEdUSDTmuOt3KdvYn9gs1uxcfKk02g9RhOI6Dtt9Fm3wAjDnmnVAiePvJCrdxy/iGARrrf+b7IABArJwVnRVgLxl9XGVyBRdWCrCk6dEveQOxDqwl85Z14WgLoyqZKMEHsfHoRjMxzINmuBZtFiOqu7Ciy71SvLk9H99zQbOmu8hc5FdNTZcJLDQj+MPbrbLnnAYmoUR520ERok3LrFgh8okpyLQ1aKDN4haPgTj2K591D/d3BKEHO7wL/1eNNfP+9deE36Xu35guj7XhSvk44BtzhEjyfgTSmjnmNN9c5/e0bt9vA8iZKfGZgveqwW/yz7lnBwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utzbYrvaMMZ3ui/6rIPs2qKVyrkKgfVOIc+5U7hyWWE=;
 b=bQxrx5glTzi8S0z0ScWrRUbp7FY/AQzQKZyCtcGG+ZbhNUH52e/P6mVbSZsiUbkbRcPY9bnrLeuujg80ai5hWJBWeCdbok+0QmdUGECuqoxol+nGt/FXEEC5m01YTDzxAfNPm24c38po4iRQuJWgvLlbox/Gb9A1eeogi9pEUDk=
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com (2603:10a6:10:247::15)
 by DBAPR04MB7415.eurprd04.prod.outlook.com (2603:10a6:10:1aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 09:37:25 +0000
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e]) by DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e%7]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 09:37:25 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: RE: [PATCH net-next 0/2] enetc: trivial PTP one-step TX timestamping
 cleanups
Thread-Topic: [PATCH net-next 0/2] enetc: trivial PTP one-step TX timestamping
 cleanups
Thread-Index: AQHXxdnfRL02BmvfGU+65AxMaUQqJqvdMp1w
Date:   Thu, 21 Oct 2021 09:37:24 +0000
Message-ID: <DB9PR04MB8395E657BECCFCE7414DD96096BF9@DB9PR04MB8395.eurprd04.prod.outlook.com>
References: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d3f39b7-a525-4e38-906a-08d9947663bf
x-ms-traffictypediagnostic: DBAPR04MB7415:
x-microsoft-antispam-prvs: <DBAPR04MB741537FFAEE01C9E150DFB9596BF9@DBAPR04MB7415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjS9g0dwk0gK7Y57bydDQSAjb5dt5QoVe3HJjl+NuNEqmzXB255RLIJvFNbUx2C/CcxWQ/So6pB8oB6IvqnodZlBQOfaji59QH92KkkMbDJQ5vkP/C5B+tjAD8efS2ogn2yDSaBxQoLSt7CRiIY+ltuIWyawnOVmrkToync64GwGmUwRV0i/PNJA3tt9B0nI0Z4GrNgzkF8U7PBHFM7HZO2ihho5pGlsqmeeaT/kXPRX4DB7zwRs7GzePPcKaFMJ84PNSy5pMAmoYoffKyqWcvG7pLYgOIyCUjvtXqbrFeLQgyCZ6u0oRQklPWovq9lv7obsycVZ6LJfXn22FvCrh+KlpWoYNwxbcqVXhD+hzDqVgntk1u4i+wHkpyETtNsMN2cyp8GS2qH4H6WhjGGwjBeVjumT7gkV+ovoTg1FdasmHCZbhihQa8bSYouvL4qzCwuDywELx4hc+TLtSBhk8kOpEss3eI3hirQzQ67D0Y13TgZuhvCoeG7B5bIuVMkocbAHQ8vNzEuqRhRJ4EXput96yqipm866+wy9vskxniaivf3ayFR/OgXnJ/ngEWIuehRtO4rtmJ4l0647bjkjq1FC2qfwoTwV1fZ0TVVmXxt5wa7fwH/vvvceZnrOeHAoEMU4zIgDC+GbXi6Ceyq0fGcW0IEZPQBCfsF2tDpJcEs9N7I53Dslrw9xySeOlDHePUzBNwPCXykH+a3lLrlBAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(4326008)(55016002)(53546011)(8936002)(38100700002)(38070700005)(5660300002)(71200400001)(316002)(110136005)(2906002)(7696005)(4744005)(9686003)(33656002)(86362001)(64756008)(66556008)(66946007)(83380400001)(186003)(26005)(52536014)(76116006)(122000001)(44832011)(66476007)(8676002)(66446008)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PBjyNKA0Jj4aMKcLz6YRC4HB2tXyLIh6icixGyx1MGI/VLMhTYecUUzsU5JZ?=
 =?us-ascii?Q?+ABvXc8OTyKuAFxgdlnVobnOZaSscFHc0sW3GCm5sntxiy9n/ZSGT+Df/LsW?=
 =?us-ascii?Q?TtzhxMj0OCQEfYOXAAtHJucap0pVulV5K8LjKNJjrS0fiKeJJq8MAvq+8hSf?=
 =?us-ascii?Q?9bPbT3rrC7cCtukJLBc1Tz5hzbe/mphL1QcKbeFGEnfWfT91Xe2id8IEblbK?=
 =?us-ascii?Q?/lC2Ba7OifPwsA4YReTGv+k+XQp8Lqc27gt+EYdnAuwZXOXk5ITDPukSTRGJ?=
 =?us-ascii?Q?ARdf9Lj+wMzlnytKy/Tpe1PrDFRbaw2jP83t620rn774ydxf+NeAatnGYhPZ?=
 =?us-ascii?Q?unscD237WZSV0bk36sgg1o9IPaEDwkSk+DDYEjdYYEgISpmpXESxUW7GotjT?=
 =?us-ascii?Q?or6Nb7WeHIuHfzypjYSViwF+MWiq09qGpAbTkiiL932boIf1K0HfClixyMh0?=
 =?us-ascii?Q?OCUEzw2N+8Y60wjxX6g97mVs70S3M2UUf68ENcYRMY4D/2krx/yJNulJG+i0?=
 =?us-ascii?Q?2Ok7D24vo6eZIoVGhjNaLY1S62ax2Fk+1+PHjZLYYqE/Q4QBwiJa09Sp5sA6?=
 =?us-ascii?Q?+rKNp+Rm00GO0getlkVLVdmVMiaq0Wl8n+xCCsQ17CD+E57x6F4ZBo0G4iXW?=
 =?us-ascii?Q?nUzYQAZUTBlXHzjwIkWvpJjGEl1ZC2yMkX1m2xsNowiEFx8w4VSnhQU1ANSc?=
 =?us-ascii?Q?NkRT6rZgKfIWISm+XmxuvTLbTg9SH0bXoANnFmt9Uiwt8CmCLMb3D6WklrUH?=
 =?us-ascii?Q?YR34ZJ+5gd5ox5wt+kHssqDo8bYcKCiDi8OpuWjshwjWEx6oQ6m+r/jEva1l?=
 =?us-ascii?Q?RE4PkdAa++fvb20wrWLsHQg2996FBGgg5ih/pdVIsITv+CdxZNW1PMP+i6qS?=
 =?us-ascii?Q?2ATIRtF2x/lePhp4WmKSR7TbWWUnvPAQp6OUlM1DsNV64abwV937YxCbr1uw?=
 =?us-ascii?Q?o1ky8hTZHeaZ7oWGuBDwFpq8Y/CD0WCGylnr1gQLSf2zwsAdcWTC+tnkoEJc?=
 =?us-ascii?Q?PIYEqJHQOnGeR/87cje/kU7wi7lcDHwRunydxeX2KakMUj2MPveedM0KceGH?=
 =?us-ascii?Q?gHqOptHWGA8YugLH6vG6xFignvMytYR+IKNQtSKQmNUdA9PjVRkas4f6Yy90?=
 =?us-ascii?Q?deVRVpregyn9abLCAmR9UBS1XcWo4D1qn6+ClkvFIAAcZrBaRF2wkq8T7FfD?=
 =?us-ascii?Q?caAp2TlZq1mvJGv9FfB8cfqK8oUaEf2nx0qRwk/s1X/jLTK+fosErWWAadZ9?=
 =?us-ascii?Q?kvvCIfepKR9uoAPA8sU0U1qc6CukJ5YxkMSPtlYrI7RRRF30FQSiw17V126X?=
 =?us-ascii?Q?sGe3GSo7BhV1i9KXl92XaTuTL3kfRZ66EDqWHPSIvZH+zIgRzGI2rR7Fk7rn?=
 =?us-ascii?Q?4+PusJzd+qrguRg8tsJeWnm642fP4KG8t0evEE2zI17hHLh5HeV4XUTP96Kr?=
 =?us-ascii?Q?ow2ofxpqrBA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3f39b7-a525-4e38-906a-08d9947663bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 09:37:24.8274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7415
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, October 20, 2021 8:42 PM
[...]
> Subject: [PATCH net-next 0/2] enetc: trivial PTP one-step TX timestamping
> cleanups
>=20
> These are two cleanup patches for some inconsistencies I noticed in the
> driver's TX ring cleanup function.
>=20
> Vladimir Oltean (2):
>   net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
>   net: enetc: use the skb variable directly in enetc_clean_tx_ring()
>=20
>  drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> --

Reviewed-by: <Claudiu Manoil <claudiu.manoil@nxp.com>
