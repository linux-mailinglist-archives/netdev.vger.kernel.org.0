Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97B1397382
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhFAMuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:50:08 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:25312
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233162AbhFAMuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 08:50:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlUWhWG2iy0L45PCRCKM/EdYwUUkO6KuKDpAWTZTxIghNzFSk6yg7T2XqQccPdPwqwFR8XCS/ycGedEu4Cd3qIP/nKByElWVfmbOtTkR2ZUBtXu4fVF8XgyFiUqwD6Duont4kwOaJZQ0E2B+aWwF5B5KtSpDV9hp1ApE+LE6MFaihNwK7dsOoaB4VZFSwGWubwqsBGaFO9T0w7MLxCQgEIsOmUEjRUxFzarvPDUpg2bc68SqX2EHzhVa2yINe/92c9tnJGx9YgG3yAYIExtUrbPV2VSJRNRdniSd1pVIU/3SBBXpwkJFsGwrmROHUVQCzVdXTcfm8AgxL5zQw2S7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbMxncmKHlg1v7w+UWITnF8mggdnilhEQINAsoOwwOQ=;
 b=FukmoY9vmCw6KLJLt+DKBR+ul04HhCmxby6XPYHppuudVWcPSL8Watq+aphv/5GBGpRR/rPGteVIY/saul+Xh1J2Zz0vPlmbFabID7G9iiGawIG6fUpftEv9uM2+9imqONnBe9gNDQiyCSEhfIftcfeVL8cfzSeW5s5xgCjgUlXJw/ycLcGkrW/o2BVpZoa2+qXEc7dEEm1BvaO8m3SR9CUq2bD8i/Zo2v+01uYRM9AO8NgOfhv4fgBD3h5KyG1k9SgsMnZMUx5jwaOh+SrgnExSVXZKJsDmyS+wjE6dPTt1CavbL1c3E/hOXqriVcB0c+Fe+/yqnblpOW/ZRw6fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbMxncmKHlg1v7w+UWITnF8mggdnilhEQINAsoOwwOQ=;
 b=peTs6oldvCWetw4UjnyrbCTXFLWZLiIigM0U4mOMkPccOfgULe1SJtlgQGbgsyKpa0GtRvq4h5sZnvj/DZJtHkzqGmHRJubixqhiyf7r0KQxrBHvQsYDC6GOIeGos29rgHjUW9sC7pC5PCtShb6heqHt+dU7545g9FLj2mG3s5RMw9dCcFDZCg+tVLITytBXLuw+9ZlY5a2BSOC1GR138TiZHhgyNfh8OsCZHqXn9HHtZ/O4IV6Hz0Ms14iNLR+ZgXvGuxPY5rA9+9Jg15uRRErTga0vAqSaHGrHI6R9wE+t4g5mQMU4xxkx2aXUMq4IxMpCoBtSUywk4qaqH//utQ==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 12:48:25 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::e51c:46ee:c7d8:4e6c]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::e51c:46ee:c7d8:4e6c%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 12:48:25 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <davthompson@nvidia.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXU/jmp/fRtKenoEC8aevprhzFk6r5mV0AgAWFx2A=
Date:   Tue, 1 Jun 2021 12:48:25 +0000
Message-ID: <CH2PR12MB3895FA4354E69D830F39CDC8D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210528193719.6132-1-davthompson@nvidia.com>
 <YLGJLv7y0NLPFR28@lunn.ch>
In-Reply-To: <YLGJLv7y0NLPFR28@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4796fdd9-2347-4b7e-a19f-08d924fb8c22
x-ms-traffictypediagnostic: CH2PR12MB4069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4069B0D8C52A06CC19B528B9D73E9@CH2PR12MB4069.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IncQOzBdXyS4B6kVb1hCHJb8FcY54CefKiCrLEExE8qDAxg6BdsB4XH3ubg0XH42obedxmO++h0L0XtcwDM4/d7omp8mmR+3+EGNnr6izJj5vGb+7R3LpZc4UwlcLP+wher4PUETI//mAz1slam7vOlcKUndTgSE4EvJHUBbjzDkLq3dKj/hvmUOgS4t5AwChwC6GydjOGYL54dWgnYzaIVogAKZ7CBNcIO6wNITon225fJx2UwH09zqRHDLUfYjGYhtGbUjSfnJFKjpSjdilc7IObGA3uQEZxzdjMHi4DZ9c9gRkYysLe1C0hA4F7BUTC3GfWGqKiGAmUBAowZWo3pDGU7qLBkNHcEPG/h4VrDs76JhTTOsXF235tOoJmbayU4irwfnNW2WIANY8wtd+kFIrpngq+DAcyqa3LWhfT2du9k6izB7E5tSDZW3769hnz4WeCokVo2zKhNc5/y4GySAwoRL4QfvK70nin7TkYpoVwlo/YHg6TjFUBJ2QysK+h2J4L4hIN+EMxlkCndB8VIBomNZSE/lkF3HGKzFyC/NPqfdliVrmkr3AmlqwYZzaFUDFIML+8iu7ZyOP2NjT/WfO/7Jvv+imgk9HnX0KhU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(186003)(8676002)(4326008)(8936002)(9686003)(26005)(7696005)(83380400001)(5660300002)(53546011)(6506007)(55016002)(110136005)(107886003)(86362001)(66446008)(2906002)(33656002)(52536014)(71200400001)(316002)(76116006)(66946007)(66476007)(66556008)(64756008)(54906003)(122000001)(478600001)(6636002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JeVWFyzW5aRgirZGlj9FwHUQbjQtyPVy1yiAMFbbdgnpRnN7LUC6l78YtNul?=
 =?us-ascii?Q?gCug3NX9XJMcSQM+1bc377bs1aJPt/bnqOp8vbPheI3e1k+002C7luhnmQX8?=
 =?us-ascii?Q?WCxizf6ELGthsm9n6golHpEMgkYJcmbiZYF6X70ZzUXD2srweNNLIntWYkzu?=
 =?us-ascii?Q?gUKW0g9VkvpqjiMPL01z9yfDjnOkxN0nvNbUVPnWnR11/ZrPkWBwjKNcajsX?=
 =?us-ascii?Q?75V3u1HaPdebwCVO0BzysReGJekipieE698kXm8gwUKodUDZrTrGk+RYsZx1?=
 =?us-ascii?Q?VU7rSJFVXbRB6m9oA86V91NQopKTIa0yiFRApEevG0fZPJSBRNOInPCzf1KA?=
 =?us-ascii?Q?/ALDZ3qhvKrT4LeLRcKPUKhargTvwoTNGqh/0ItKuuak4AUrwe97GFHqUDDU?=
 =?us-ascii?Q?lizeexa6b6YSctWU39iR/6qW2AQTPL773u7gu0KF2dhM4rkSdiSVM0aC+umI?=
 =?us-ascii?Q?AA+Y8M5tTohm6wT0mPDyG+rW61rHr1+eJW1Id2jDR5x/MKfnfoWMNRnY/uIp?=
 =?us-ascii?Q?DnF5QaCuzXXe3/ribBrJA7lBzdtHCksIh2aliESdoGadZXfJrhVpWo2Ez+sK?=
 =?us-ascii?Q?dVtnrSCb1HMrEj6a9w/KB35vFcasam1PUVdUVShWTO9VrVQUKlFHa9IB/fq1?=
 =?us-ascii?Q?2Wm7PpU6Tt33vas5GtN3TMNE+Mzri7Nk1V5ptRoXNBdMh8kaiWbmEVMbjEBT?=
 =?us-ascii?Q?Bp9K7ZnA48G4MAiEzt4LvrugquhNi6V9PwI5xpjs5opnzhd34Jy7As/kFJka?=
 =?us-ascii?Q?HNPo9Xn8Nz9jJIAlisqpJvGfvFhtuc8ACmB5IO053c3Hjg27DDHzl3CMzqsz?=
 =?us-ascii?Q?oTK3URNq23csSqJHIhb9u8nqZ6H5LH7U03S4+9lllsvcSci2/yHn6rwCQOTz?=
 =?us-ascii?Q?KjY7gmYrTPuu+hEDoK4HqqJVeBuOTtsJw2FuFtMGSxB+nvl1X+n4JdlV+S1w?=
 =?us-ascii?Q?wJV+mTLPwmAol6FTisKdcJy4ret+qGt5+h3QFdMTiVHypRCAV2tnfi9VpcbC?=
 =?us-ascii?Q?kw+/JLaCHRiEPxrRJVW6mdXWKWAX0978plu2fzBzYKwl5qbkfjfJjWI3MiI5?=
 =?us-ascii?Q?FM2eAmwzP4bC2SW1Fzrj1MqvnmZacunM7WhzBD6OuyE4QwTE3jM/3XFqBLnQ?=
 =?us-ascii?Q?lznrmw6sT+rKrlqwXLdFOyxL/RhpFfoh/s6Z+luizHufJKnsi2C+drRyr2aL?=
 =?us-ascii?Q?uQbmujr/G0eGu+l76aVWsjYlH50o4JdNYKpgsaW6tq3KPJkd7+azDvOfICAH?=
 =?us-ascii?Q?TIjMuJ/LwRjG3Qlmh73je1Y5nMTm67osFJ2RuRSIPxzzvnvHCFp8Qf6f6z94?=
 =?us-ascii?Q?U5z8HJQySqOoFkr2/0j/AyC4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4796fdd9-2347-4b7e-a19f-08d924fb8c22
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 12:48:25.5217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5rae5s+8DPl3HqgMk2B9DWqT9/aQSfddRMZYO4V1c7NAtJvR9bEjc86gZv6CNiS7zkR9qfDBIt+8MRlhC8Q0tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for your feedback.

Our Hardware only supports a single configuration: symmetric flow control, =
nothing else. This is why we have to enforce this, and there is not adjustm=
ent to do.
The only reason we set priv->rx_pause and priv->tx_pause here is for ethtoo=
l purposes.

Thanks.
Asmaa
-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Friday, May 28, 2021 8:22 PM
To: David Thompson <davthompson@nvidia.com>
Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org; Liming Su=
n <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet dr=
iver

> +static void mlxbf_gige_adjust_link (struct net_device *netdev) {
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	struct phy_device *phydev =3D netdev->phydev;
> +
> +	if (phydev->link) {
> +		priv->rx_pause =3D phydev->pause;
> +		priv->tx_pause =3D phydev->pause;
> +	}

...

> +	/* MAC supports symmetric flow control */
> +	phy_support_sym_pause(phydev);

What i don't see anywhere is you acting on the results of the pause negotia=
tion. It could be, mlxbf_gige_adjust_link() tells you the peer does not sup=
port pause, and you need to disable it in this MAC as well. It is a negotia=
tion, after all.

	Andrew
