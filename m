Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8B39BA26
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFDNts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:49:48 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:33403
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230142AbhFDNtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 09:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLUsVokK8ibyDEzPeG6W6oEZfDMS9cQ+dT34z/ZC/Ti2apc3OZOuzQ54qoJCnqgBZLCGeHkWU0Sv48AhG6TYok8VthWPaUZZZdOUyz7bAgLGBesVPcUqxBNTdyCfueeRlvr6Yrw/SVLTjqKPO2kr2rhN6XGE8pdynS2lttLyT5OXjDeU5zliazU2NIobwsz4+UdPAzwY5gPRaLknFiI0FwyhWMSEL8812Q+2o9yd6kw6eHGlf3+zYW98gxMNO+DP40oQb8YhQ/j4UEc+plZoEZWmX1xbQsw+qLFk9Thgot+k0A8cksOtLZjH4mhBUH+nHfkDrNSpy8gZxjaW47xMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQOaj30J3JJEajIkxi/W+Wk1zChY42mQEoaSAMl9Y9M=;
 b=R2lTbLu7OciLexIuxgrXkWtjSBvTklfx5DQRaA8oeJ5LUe1Vnxl0cZFLvH4/t9OwRwsaVKX1KVX2gJ/0e2doRHDWC6vZSjgdeQrkxZJcPYPOtUj0zQKhwGObn4lfmIn5Z8n37WjStXCqPvrXIbAq75Z7U4oQTBKDbgQbbBN2FyJNT8uhauGRcLdrsEkiPgwmgUuM2lZU1VSx5k7GsIdVdKX1c7CPjvnTH8tAbDAZIYsDSZJiklDBtMPCUFlG8uT4JeHhC1TKQiKd6hGRRJ09RsEyLYYNmF2NNiU28/c/SOTa/nUYr6YKkUEptZteguKdEZjyg13mBOtRma64CWcY+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQOaj30J3JJEajIkxi/W+Wk1zChY42mQEoaSAMl9Y9M=;
 b=S4IK2Ju07LxCeNWhHNLuRUzf7LE2U2y6oqfK2+LCaHm37rHB/Xti3EiMcH0IWysTQk7jKTI3uJQAh3Zse/EChEsNkoSxdzPSR4WV7nWjWmvy81jwrCXYPuG9E8QEK4+13DOTylY6LR/rwcf8zd2lBsOQ8vD1yama5DI2uyzvR98=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM9PR04MB8383.eurprd04.prod.outlook.com (2603:10a6:20b:3ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 13:47:59 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::31a4:3d80:43de:e2bf]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::31a4:3d80:43de:e2bf%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 13:47:59 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next v2] net: enetc: use get/put_unaligned helpers for
 MAC address handling
Thread-Topic: [PATCH net-next v2] net: enetc: use get/put_unaligned helpers
 for MAC address handling
Thread-Index: AQHXWUdw9MQT4AMpvEGGFXriJCqitasD3VzA
Date:   Fri, 4 Jun 2021 13:47:59 +0000
Message-ID: <AM9PR04MB839795C23F7974DB44CC563F963B9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20210604134212.6982-1-michael@walle.cc>
In-Reply-To: <20210604134212.6982-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5decc801-9f94-4722-a91e-08d9275f5d6e
x-ms-traffictypediagnostic: AM9PR04MB8383:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB838391EFBB94BFFB59B59966963B9@AM9PR04MB8383.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VYPZLpl67YbSwrmTh73rDpB20XuqNw2EHwZecGKg2FOSPQ+Zmp8GmHss1Q9rPbcxxmkB1k/20Tn6zsi/T2gYuq+jZTb1OITCTyy6jpD8ODyG4q9mns9KoQmXkQLcGhdQhmWdGfopW3CaGLA9MbwrH7uQV2AqSNIH2qg/xSlkSVm5vv8cwZ2ljHmae7i/SJlaF6WMWyLpNOs5fMqTkiyLKafaiYzXvF1wrlBNXIqHyZS9d5GUnjCk4TfrPuWZ36ZPStupzTUvFu9ea9zBl9Dlr6dEr8MYxOpc0jdAL2EdPBiikG/dx7xZbIe5e+kHQmH96nMWL1FY9E5OD0rMDUaZMoKrXfvXJZsOmXUKU2nRRPcM4/OVglKCa2sgtr/pqH6e/wX+wwjTIrtJSLE17tL0JeQavqhM6JM0yz0/stXV4cL5UA492uCFLWB12DyxqXFbhkLV4zfJG4YX7ANJkAJ11SJBtGzrxHCr5PvisvqQIM7tz+LG4tj3GC0XE0d2Beu3w61ylNdYvm3LhUg+uP15RNnyMQWmCQIS8fqSXGGoVrKUuyBy4iPu2J70qCqm11OeS2pHOfmwUHHA5qKTGYYtOfUxWHhR+K5rbaqrewWtxOA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(316002)(2906002)(76116006)(4744005)(4326008)(64756008)(66556008)(66476007)(66446008)(26005)(33656002)(110136005)(54906003)(66946007)(186003)(83380400001)(71200400001)(55016002)(122000001)(52536014)(44832011)(53546011)(86362001)(5660300002)(38100700002)(7696005)(8676002)(478600001)(8936002)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?47Y5u+IJR1y16LjfhWv7AFZjdvwbRe0XT62kF8QHIFwVbzIBnEaztv6sDqrI?=
 =?us-ascii?Q?/dMq38+kndmGxZJ7AlJaPwtNSfkGbggx92YibDRlmOW5kGpREW3mxgO5qJFu?=
 =?us-ascii?Q?h6ud2CVkCWVve3rBqtKyLw2lni/zF/ioVDE84/wHV1Al/tuArI3DyXVmzgoh?=
 =?us-ascii?Q?uglUGq1HPETlhjLHFPKpZdGvpzP7ChQ3eTUD5eKwhPfyecaGxlvOg52udDWG?=
 =?us-ascii?Q?eFU+3pA/fWyvSf8cCmlLaGOAl0qJa7twk8HZfbdsrtHduywzxzvK6CfU4VZw?=
 =?us-ascii?Q?lVi1aZ1jdsLVbAIdA/hYnU4hPO2Mp9Pzvc2k1oB6ztVRH+tKWuqioU+jD4ER?=
 =?us-ascii?Q?PmDfEF7OFOYkjBqMh1v0olo43zM+2Uew71165adyeL98ZyOCDg6jCIoDp1mc?=
 =?us-ascii?Q?ljLc7ayb5P8YD99ENy0ot73t8iLdLZytYAcOJs6MiehD/CMB+qTYw9/xtZEQ?=
 =?us-ascii?Q?koMnrWpgn6vYoTMxWNb6FqLihJBRPDQFKdGQkiUSY8ElJt64EWb9PbPZjIPT?=
 =?us-ascii?Q?7uPjQCnsTQtE0Xfe6GgX+KoP+ZWWlDqeoOfjQCNCXCgS6i97d7P+q8KvA+uF?=
 =?us-ascii?Q?DeriLSet8oNwlT+Ln+FWXMtV19Y3eTD3QB1Qw7noIpxn4zI3a6I17L89nQzO?=
 =?us-ascii?Q?0T62b8FkYA6UpGGcVVg20VXO5+Z8OBa6anOWgIzoUJW9RgYGOWBprWsb56I/?=
 =?us-ascii?Q?qiAEtMAaTbYRsyqq1iYOw/KiojWVh8nU5/xRqhr2L0+msfeu1zt4YCXgHsUE?=
 =?us-ascii?Q?sExkIHscdb1ky9ZIPbsvs5mUXsBQlU4HCaw7gGuTcebX385DcomtrsQ9l70a?=
 =?us-ascii?Q?ZxhXsIaus1WK/DMOs6XYpZLMFkonSx5N443KPBCA0qNjLox9DlvBj0hm+JOb?=
 =?us-ascii?Q?MgvWA+vf1TfI43v6muyStPJHP68IyNZlWaZJQ8/BXpBsOmi+9THd79nXM3wT?=
 =?us-ascii?Q?u6iyM/KNE9zE/xSMUdZPSFapw+hmwRpsxu83PQgdOxwKvfIRJ/mV0tFe1dW5?=
 =?us-ascii?Q?1vfekxD9XIpTuIRIs8pBfZr04YmC4wN30ejrLGgG3LguRQNxrhG+hJ58JCA6?=
 =?us-ascii?Q?5k4RnFjvI4DG29+3MxBa17cDkFV1dM+vR70SBw6iVgO363CDvYqXPmdos7qm?=
 =?us-ascii?Q?67hstGWxPKdBEYR2+P+mAOIGvTrvEWw43RT2b3ow+LhnkW4guRI2nnYEBVYw?=
 =?us-ascii?Q?E9YsA7TvN/1/R+SuFYb7VhC3ONOhfHCGCdOcUR+2Zd2D9J2eeMPdi27TJvz7?=
 =?us-ascii?Q?1b7u3j4cqocKBWnirXIx4+CNC41xtiFs9NxpozpO5QjZ/FmWpDoSDQQIUisA?=
 =?us-ascii?Q?rN6Kt17VTLXmXYlfZM2RPmRo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5decc801-9f94-4722-a91e-08d9275f5d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 13:47:59.1619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ufFVdYm5jsC58AxT87S6pinjRVzIgIvqjE68LpIPfKMPFNx/Jid6r7Wcr5yZNYnV6jH+YyXarl53lb7wwp7h5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michael Walle <michael@walle.cc>
> Sent: Friday, June 4, 2021 4:42 PM
[...]
> Subject: [PATCH net-next v2] net: enetc: use get/put_unaligned helpers fo=
r
> MAC address handling
>=20
> The supplied buffer for the MAC address might not be aligned. Thus
> doing a 32bit (or 16bit) access could be on an unaligned address. For
> now, enetc is only used on aarch64 which can do unaligned accesses, thus
> there is no error. In any case, be correct and use the get/put_unaligned
> helpers.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
