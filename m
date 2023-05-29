Return-Path: <netdev+bounces-6185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C932715263
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF4EA1C20AD0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 23:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C6A1118C;
	Mon, 29 May 2023 23:42:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3247C8DC
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:42:03 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2090.outbound.protection.outlook.com [40.107.114.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A539BE;
	Mon, 29 May 2023 16:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7sdpxq7NjV0SvSZoGUE4hiATL5x0x70KGmtWnJhRN6+Alz2ocLdYRENOIc2Dh+rzkhKHDMpcQYGdq589/Ir5+cjY2WsB4IqycOtZi9ZKW8n/Cz5p+GoVSztSswwz/0pB592krKrL+9KEtlinqji8fI/C4zdbtPummqnmTtosXCl1RloxKeOi+s84R8ggwu9SK8j0tPsRfJ7JY0GZF4D7OWQswwk6J5c/R1UJdGq4nlj6orJHneG/9Misc0Q62BtrWlk+WpiMVpMNzQHrd0Y/vNtKzXfYq9EmWDVYKA/uwyYsM/v1NgvgGfemN4BS5eNX2ZxTCy+hKZeg/3Efqmnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCkGcTwAQ9EP1b2KjLyssxJdytFcPV7ur0tqUG/utz0=;
 b=bWIxfb2rPe2JZS9R0Na4OXVyP7/mKjAAhHyTqwxWWZrYpijFNqfk1IcGlxkN9LEIdTiob3Kpq0bBVs0ahQjgmmavi+Allr/M9u++e9YoQCNUQf1Lc057N6FQwc6GnIr0eUuM5gAY0tawbKNUrX0x4OfSDWZjYdDeNyz5XTlzuK5hH1xiFa/o/xlhMqM4j0R5zaHxreX5Gbi54lUcGOobbtUCfJlgqkth/1ytGoIzFQjmkPX4MRFlLclEMwDch/RMDrXomLGCy1GQss7xJrK2ze9ZuA10WSuJYxH65g1d0Ey4m+y04RVVdpD+QNIC+6HA+tBWMR+3ST2UQrHFxZKvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCkGcTwAQ9EP1b2KjLyssxJdytFcPV7ur0tqUG/utz0=;
 b=V93yXNGxHViE1/pgB2xn/AnbZjFuTBLl3NZnV36U4RxRmCVGx0kmtw0uI999sfW3TFOVv+NGe+M41oIAAD2FEMWCoC67JSfdlcrTYX01entg2eQPIQpQPhCnwxWreQ/1XDgqBa8MwhUA5n1zWBoYyoh4zh/s6peIRPxUxI7Br2M=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYVPR01MB11358.jpnprd01.prod.outlook.com
 (2603:1096:400:366::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 23:41:57 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003%6]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 23:41:57 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 0/5] net: renesas: rswitch: Improve performance
 of TX
Thread-Topic: [PATCH net-next 0/5] net: renesas: rswitch: Improve performance
 of TX
Thread-Index: AQHZkgTNMorIrPLDk0OhAM55NFvA7K9xb4iAgAB6hXA=
Date: Mon, 29 May 2023 23:41:57 +0000
Message-ID:
 <TYBPR01MB534186213A583356F53F07E7D84A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <a181cce3-c553-4635-a039-021be50f2a51@lunn.ch>
In-Reply-To: <a181cce3-c553-4635-a039-021be50f2a51@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYVPR01MB11358:EE_
x-ms-office365-filtering-correlation-id: 5e940b15-75df-41bd-3750-08db609e4aaf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 EYYPSEJpJNBfbaM510/6ze1BJ8H4vfEBDZkul2zzp7zvEaewCk3ReOTzeNlIVlDcLWRfIhCNOY+YIfUgbPZ3EeKKW8P0LSZ8g26Vin+rR1NCrIJVs/K4MjBwaJiBT5CYdB1vP9wwBUtLiohaM17GeNNjmHyE6ZPSrG6QVcXnXgZBNIMNrKN7QWTcLNXwnlkFQLf646e3zhZZvY42gSt/a6BDsVwGlsZSLF5CdIiYvZ++zlYKdMt1D1OR+BbQ+YyS7lxcgfmBzO1jqlnR7OMOGo+gzXDRT8ivI4rJ1uoxWEbgSXSRDj8p+ibTMNet9yOlahjFa82lLJvcbS56Y4el1xLfhyBa9JSQlgSziiv7LPGYJz67L45IXAjWnKO6dT603XxFsHLxYTfM9B35uYaBfndlM1iWSx7utMp4b402QSHNsPtwzkV3LaSvE24Vh4dvgyO4kZ9NiJI9pJEixE0YFSHFeY70oEYlazrgrCtMDlwXX98Ay1vCMa91r1k7PpOlaecrXazzxExdsNpoD5UApRVISGl/xwM180kak+W9MWwjSEtlKpbN4LM5NiTBGan0HkCZ8NPG1eGpOG0vh8aer25NM1oFJQVqPBhgBPI2u9Mv1v1Hlr2q5NKpwTrPDimS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(2906002)(4744005)(186003)(38070700005)(122000001)(38100700002)(55016003)(8936002)(8676002)(52536014)(7416002)(5660300002)(86362001)(478600001)(66476007)(66446008)(66556008)(66946007)(6916009)(4326008)(64756008)(76116006)(41300700001)(7696005)(71200400001)(316002)(9686003)(6506007)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uswRSSMvY1ezVi9ojpJr6Nxb2zXH3g/igSQFpHRolv5x2R5Eb63hl516ZFUt?=
 =?us-ascii?Q?at4htadmIuB0kR+yBgTQYIIpIesbQsUQV65gXCsOC9ZKbZHE2uuPEfLUwvNr?=
 =?us-ascii?Q?lq/yy0ALk96XeazpWacvV33zXobUaFmLJwHHrogj3xTvPxUdIGG03IftdtwB?=
 =?us-ascii?Q?Sz8o0WD5NPnBazcvJ0fsnyWeyCQG/Gu7ElSyvD/DGNud+FmhL6YGP3E13hCO?=
 =?us-ascii?Q?DErYulxF7Y9s3eP7s2GHB2R+x5OVkpTXxfSsEzr+4QEEi2TCeBPplC7FhTmI?=
 =?us-ascii?Q?kbP/ElsyTAE2Zmk+PCL7R3rPfl5iAGYkk9ToP5s1bNtcvC1hFeiA3796tDsx?=
 =?us-ascii?Q?ZjAENEbEvFv0jHPifUPwj/wl2nlQ0NloZfcs8768foKbE4cld5TVFjAP/Pz9?=
 =?us-ascii?Q?OMBj/8EHp879/OkSHoXsF+Jyagc+Wj3qwLHnChRXz34/EIHGmPoItiY9IwTN?=
 =?us-ascii?Q?jp3FGk3pvfhwH/X8NexzXgxvF0FY6e2wsuXYmpZSmTQ5AZ2ngDEfsJ9eMdp0?=
 =?us-ascii?Q?XVvCn+iLLrnjmY1SgbAiubNPTdJ15gGjFaUc8uD/q2r6Rj4GHe5APzIGeWG/?=
 =?us-ascii?Q?fQ27ldyG4lynCBFxfCwOtQEN+tybFF0j/R3bpZQKmhQpce3yom0TyneFu8+a?=
 =?us-ascii?Q?7C1WQTXKwLmmn3wkiv0Qg7oE0z+P2nRrY8pPrBV3seRhxVgdhip75UIN1EXh?=
 =?us-ascii?Q?GsF2NYy6GjrUhl7E85uQLZ/dhNt3selAY2Eu0Qx93OXkLRAVHoZwepkfnKLJ?=
 =?us-ascii?Q?zA0Br6wVd1WOmir1xhflViX4KrPSEnUcd3fq23/sUShsS8UEIxxgIJOdQv+4?=
 =?us-ascii?Q?2BT+25VxdD6ayIkIcn22niWpEBtV4sx8FgaGnOnhipIUyygmD5JGqZatYka7?=
 =?us-ascii?Q?7mQ4jV87zAW8iY6s2LfMQHqITD0QT2blGz+kDUD/EgqhRucjhTrwaJ/f27iq?=
 =?us-ascii?Q?ht7zC9gzUByba01pF3Oc5XBenWiEZtzuHfzYkPAkL0A1AZMTMRf8RuTTWABj?=
 =?us-ascii?Q?6KlJcjCCKT+mHDJ+QOglLveuQuJO4lhoKfqFpdo5T1CmGlfzA9/vgRVtyzMZ?=
 =?us-ascii?Q?owyWMmoH2d+rbrED7X4Iv5mMOYOGQEVDFSfbv3+EJ3Kws8tcE7bq+pQ+J0PK?=
 =?us-ascii?Q?UACettPvLHq92H/Hdq07tWHMrzTOpwrLDeBey1h/5547SBmhdUsTtOrFX41U?=
 =?us-ascii?Q?c6OuzUcQ2A4gV39/ID2eLO6yhTH68C4VEOCznPlonMaslvDrWZhXbKSklIZS?=
 =?us-ascii?Q?3hjYrnfARCuTwdhaZlJst1x7+iuQ1weWsMtkWKv2ScH6T+DVozd1Q7PcK0Y6?=
 =?us-ascii?Q?uevmORI3BPH2XB2e6a+HD1ZcybCnyQpkjWKBR+H7zTiaiDuB5GfsH+fOKrSP?=
 =?us-ascii?Q?Jm/jqOiq3oXDWOvcCs9I1F6OK8ndX/sUtUXtMYsBvhKbqnd3z7jwoqxLtvP8?=
 =?us-ascii?Q?7L1TA0GsWIxViy6Znpcc3edVrg7h5QDAxrYVWlhO2InvCDvGdVwRWmGDqyxK?=
 =?us-ascii?Q?FFkLnLHWyI2fuz3YoQ94lq0GmK+6SW4b4JdP6vDqmmBFY/Q6Nb4UgKroF+D5?=
 =?us-ascii?Q?avrAR2yeyh/jtFXQhPsqZxoV3LcNMUpIiVLSqk9IZ23Ay82aovc7OX7ZlJCl?=
 =?us-ascii?Q?TbYI+F+6F0A8gxyVPygnnBY5G128xIgGYy97luIn0ULB5UDMr2t8IvcdJilF?=
 =?us-ascii?Q?du7zYw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e940b15-75df-41bd-3750-08db609e4aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2023 23:41:57.6671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MRtYU6ssWj6n96kwTcu6TXnDEsMkSAumzAu+D4EhdCQu31BR8MQQCvZGzTNATgF9OuWamXlKlFwAzNEdmNW5rQd2ykpDvln1W5JeTlhdM5u+J6c2FDx88M99Wo3SXJZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11358
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

> From: Andrew Lunn, Sent: Tuesday, May 30, 2023 1:23 AM
>=20
> On Mon, May 29, 2023 at 05:08:35PM +0900, Yoshihiro Shimoda wrote:
> > This patch series is based on next-20230525.
>=20
> Hi Yoshihiro
>=20
> Patches for networking should be based on the HEAD of net-next/main.

Oops. I got it. I'll rebase on the HEAD of net-next/main.

Best regards,
Yoshihiro Shimoda

> 	Andrew

