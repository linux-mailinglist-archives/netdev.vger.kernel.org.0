Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D7419621
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbhI0OV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:21:27 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:1696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234730AbhI0OVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:21:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZhGggOXLTWVKvd7/qn+JxgN+LL62HDoSsMgm+Vwsb0lPLLLKTqUVUVYMnePAPdZ+izjDIzVP//Go8h9GdqZI0gnT9lqlc2/PjRPXsW5Bw6/fwBbl7OiRAwHW9p9xlAjVMY//SHE+BMnU9Y4YOtJFr+2VbwnOF7Zt1f12GsCmr8/dtZva0zoz+5E6ttrshpEN+PUbhREiNH6O3rxoBVppjy3TP5J/OMaKGcdODkmYRuN5rE+7QfAKoK+ER5wUTGsJwMUpX3YHRKWPNLSx/h+ziuJxe+ny1RqR+iYioSoifUsS4XbN08c1nLBUMdD3lEFnlHa1BaQQiCDBe0j4lFErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=d5Ku/1WfCSdGF7YtEL4jTwx/AdVMEm6H3CzgAh6oBK8=;
 b=OTiePgojUkWbbba2f4/59yp3ts1UuzsPUiiKMf2qZbIN9xL3gGCRdpPjmNyVgab7tgnrHTqwHGQw3jDbYwsbKf7MdKCjjC4FOBtgQhPhoZ24B31uqD7++5YqsY4lIMjx5SydxZofgrciGDugYcvotn1r+PVvWoIGc7ys2PKn2FsMTGl5nfZAA1pX4SKjyMTNiV2yAfM8ve9Tlo14+q6vBggD83ArHpsASm95kPYY0Tr/mDSceR2ci6jy7EuQrOF3yKenwQ46OmbWmmo6yYRLwcUViSiJtQBa6DOIQN2yzanZ8lg+kY9sYIrAqPvOCa39zSDn7FN64iACkOptrfVPOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5Ku/1WfCSdGF7YtEL4jTwx/AdVMEm6H3CzgAh6oBK8=;
 b=okTNrDiY7uKYRFobK6qXaPYhDEUptAE3bbRTbq24CTeeMMeIrDU07/EBFdh47RnP13ZHrvX3pOZwNIrLHEj50h+j/AZXHv3P4G+VZsCpW56gI+XbLaQr7nou2bwgRDYksjHtd+sHIcizUe1yIV4/VDFkdPAkRkmUHIK1fkuiZgNurtYsVaRNm4Rj8JQaoikDdmF6/XnvsVvtjTHpS7RC8bogmYzvCHvlXOEUuFZ/fbC/RAlzur55lzTbIGTu7ndWVLM5klsd2CgikBL+u1A9asH01+RmgoUDo6zHAERgKJFN9VTqMQX34ZV3aWQ+SwN3qRZPXl3bqpcjWEq36XFFJA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3703.namprd12.prod.outlook.com (2603:10b6:610:2d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 14:19:45 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::a46b:a8b7:59d:9142%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 14:19:45 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: RE: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Topic: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Thread-Index: AQHXsLi5/ezHFM2t80qMnoiP1wWjOauzEi0AgADJmACABBI7EIAAAriAgAACbtA=
Date:   Mon, 27 Sep 2021 14:19:45 +0000
Message-ID: <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com> <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
In-Reply-To: <YVHQQcv2M6soJR6u@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fca922bb-e05a-48d3-8e75-08d981c1db4e
x-ms-traffictypediagnostic: CH2PR12MB3703:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3703FEF09E144FFB40966B11D7A79@CH2PR12MB3703.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t+XyziTu2BJ1vzjzRXrtuPZpz77KS0LRF3NDPFFjXEDi2aOeGiEky6iRmip9fSb1tCV8hshL8LIosTSE6OIcUNUFlOrQGK+fv9neg5HOxOhEAnBKsyu6NrLnpdeJVtWroUcwV+OpYx6vo3K3P0duhjWwewmMDNTbdV+r9cx/JvXNlSL/iDfka6QCpEckMNYHPvwfT8zcwEPTTfRVY2yJ0gfFQe1PwZSs+MejDnr1faxtfKa3lgSYqYUl51MptDqKSAy6DQ/ZLbzqwr0GpH99h3c6z898S1NRslvutDl80KEkxzaJuTzxWRPFfd7nMoZ1juoqJiCoU5myWx3KM7ux1KcHROF8Xw5K1IabDo1A+DV8pE03J/OMit5gvl8Sp6TVn708RqzZ8nD/CezCLuZCDlEfMTuqtSphUjNWJrjCr06dvugcJvXqFpTdUMRC0emzBlcejW9IqjxRlXBaVixbql6Yx2nziatZfM/PSVcbcWshzo+lL6o/1vfSH3jQXFHBujZIBO2dbTa81tvfVyGukFZSPebHZ/NIm08ePVSYcF0s1BT7FSbdlbEeCEui9a7vXD930tPbKivkG1zcMubOCS51KB4gkPB0GO334L3DR6onXkpwX/ogbmLZinD/pqYYAVWxMhfq8N91yaHKQsNH99rH90KnDrSOaWOJz6jHVnkA3EAhC8owmXtxACIUOjw1nupWH7vgvGraOSOzHcQtkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(26005)(86362001)(38070700005)(33656002)(66446008)(71200400001)(107886003)(66476007)(9686003)(316002)(4744005)(6916009)(4326008)(54906003)(83380400001)(8676002)(7696005)(64756008)(5660300002)(7416002)(8936002)(66946007)(186003)(6506007)(38100700002)(508600001)(66556008)(52536014)(122000001)(76116006)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ze+H0nElZ9avIv3GQOBOlOZgvwV3g/dQVd9UtpSTUFHSKgk8DsuDq9A8++Bf?=
 =?us-ascii?Q?cepEcLtsyfmMiV2U3W5aObz6hqm9LvFwcHaxxaeP8TYUDaqgS4pBkrpUujNL?=
 =?us-ascii?Q?tP7kz50dlMqbec78haOy9GsgAkXuUg6vifkkYw1fuVxkHRpqMW1/UVT3/HUg?=
 =?us-ascii?Q?yJTP6dzJa5STn3CvIt5MtVW+HobkWJVis6um1C9B/GRZJ2CZmxEU00Qg6jAO?=
 =?us-ascii?Q?xs8wSq/LEZrxA0r5e8eFN8xAisQ/ZpdOgoxmyXyCiXUpH9F7nw+HZlJDCIUm?=
 =?us-ascii?Q?3kjSg4YozOSvdsVJWf7xXebYE/sTJNWIo8FkT+7g/awaVdYHxadJjtoKxA0Q?=
 =?us-ascii?Q?aNcYu9EsZfmTYQX5/JVDn1pC+XnII01whowTCOTM0ekfc8lcVTHWK72dDjOD?=
 =?us-ascii?Q?tGpsoDKmb74rz2+iVeSKtu5dQ7ac9iG/KC+CGbdsE5c8XHWHAOSUjbqNT4OC?=
 =?us-ascii?Q?Tq5n2lG1mY7x3j5JmhvXVYfdLUbd6mmzNcLmDekR3py9YiI2qOxZ/bXBt8Db?=
 =?us-ascii?Q?BGuZrulP6t5/k/5/LZHwPMRiOhek+6qrZHuvWCUPQn3K0n0tklJeYTwdxFjs?=
 =?us-ascii?Q?S0A4EcdTECXi54gf62gPtWpf+Gd3fsKLj7bYvJJM43mhGkQPPFYodtgDTnUz?=
 =?us-ascii?Q?rDTMSdyH5tmC9d3BQsyVgyOpqR6W0laNODwFhMGROrPUVYbeH4hvVrXsWswa?=
 =?us-ascii?Q?8TjmgPTx1p4MRrQN+vAUxIjnnGFafCUn84xLHG5V4Llj7pYlqp0wdZd8u7jY?=
 =?us-ascii?Q?e38LsDk1sMcSVRZHVjXawqJpYZF21q1VXq2pgghbUxboNuog1d09baq1ejFR?=
 =?us-ascii?Q?MNR96FzSpAByG1danAPNCA8E6z8wSeBoVevCrfqix5P8DJASwm+K77P1CmEl?=
 =?us-ascii?Q?guhBpIc9JleUsamEmus/pqTGALYcZjrV1HA+yN8mwgnnFGUtRZK6wL9q4Y/t?=
 =?us-ascii?Q?BKAZU4jlQ5jm0A5PHgRIoSdPbnOVyc/jGtl5XUj3rEilP79CIwBzbw/aU6DL?=
 =?us-ascii?Q?bnBdsDUDqIb4zhTyD+H4wZwGHw4CaCldSPTtWpGNQneufnCsY891aRACR+8Q?=
 =?us-ascii?Q?4ahOCC9yPioo7Slr5D9km67fy/hMCMIfnjhdrxzQVtPRL3Rc3XKA+TN5NH0H?=
 =?us-ascii?Q?IeqDJ0AscGAbnGidG0tYuNvICpRb7dNfuBiNugTjilhEQ5YQnSYL2ORV2iWv?=
 =?us-ascii?Q?2/H6nxf4CxMvc/JwyzNmrJB3AHGK2H0Dk9QGvfJodawEJaLA2jhBYm2zji+S?=
 =?us-ascii?Q?PP7RyQA65tsHdzl+oB+2qdgcMTTRb9k5ymU3n1RZNwaFg/fWDq7/h3wafOW1?=
 =?us-ascii?Q?2JPm3rsk1alK34mCZTYgO105?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca922bb-e05a-48d3-8e75-08d981c1db4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 14:19:45.6196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/0L7IxYVwnuSixZ/IZEbGspENAIuU+H3TwGDg1m0cAnbZsOgJSrpeEuIC91r6aO4lOcKZlkuEMMYhgoS06JRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> The BlueField GPIO HW only support Edge interrupts.

O.K. So please remove all level support from this driver,
and return -EINVAL if requested to do level.
This also means, you cannot use interrupts with the
Ethernet PHY. The PHY is using level interrupts.

Why not? The HW folks said it is alright because they
Do some internal conversion of PHY signal and we have tested
This extensively.
