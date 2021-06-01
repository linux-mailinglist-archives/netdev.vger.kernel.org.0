Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A82397482
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhFANpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:45:42 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:25728
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233758AbhFANpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:45:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g38CAzAtRmq6fbHTNVms2OwQJ7qy9HT7yoP4AAH65bYZcWKSngrra3tLAOieXg4l6ww890aQzR1uMa+dR9219KUAx+B3ARgzUKEmx0mvVAjmadHnHXjedwJ0BhH6RFDF0XUONJLyAgQDtM8FhqvqxALGkUonF2iw10VNRvmpDY4mgqOFsztSUtR5GlEHp4i4SfxKdzNXwXHAYFBgPtz46Q2wAjcAk31wrLvz1/xlA7+E0UZ9585cFgftcclCpFGdcyvzXen6ul6z+P1g1qzliXNUmVqH6ZuyAxzoXP2NYqUe1I9Oo1gb0f1cs1XUsd59LbvVpl+8y4xMZKt/X7NexQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVTle092rMp3CNmzw7xfH50tlsSc2fC0/PoJHJVoE0E=;
 b=X/qRjOuGuoPCJjKTYbXj0TxKS3U3gBDS0c1Z7e86eYeasHpw9B7BgWybOU7U6t6Dvp3PQtKP62Irhhr2cBWsimXI5lqkzEOpfKCDtFbIbXc0ogmIYzrADEm2SaOFeIaMTNSP+NCAAFiCYyDbIXrec3AGJwQHHRKtLDsOQitoya/sjGLfn3bre/PMmk7UAhT2Jp48iBo/cP1Ttl1o+Qt16m0HHvBJLmWkpD0Qboi0bUL/gubcE1BiSFOy+x36UYz+XeVkpsCzkmrcoTXs5Pd2HS/vxCvNs788tXlxfkVKEwNWfJzDK6nZRSZHjZyu7tpBgz+T7h8OuSM3iwNztzpH/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVTle092rMp3CNmzw7xfH50tlsSc2fC0/PoJHJVoE0E=;
 b=T3Zj62YkNmdeswiQHgd4hIxwkQ9kf555e8NTDcA+9jwDu3ohs6Leo7QojOr/rX+5NBbTEmIj24HFb7mP9+CiKWXcYBI9392nUEX8/8H+vt4/7xc8pVdme4IyAwFiLiR8dgsHDtuMllVemQ8qC5hZcC1/C4dIhydaoBhOhdZWE3ukQmTG0yAmFufAXlqZQuHwUXftTTGSiYbH3kfES0afobtdObHoznppY/8m+j4OtuScosr1CRQWfeU4/5Xq+sTnG/GXRpNxeLqUCWjuNOeGJb4VIMZ3shwSlGTNMt62OFI5Xw0pKl5PlOHVd6eAX3bvm6Z5DO3xf+/QGodxIytxLg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3976.namprd12.prod.outlook.com (2603:10b6:610:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 13:43:58 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::e51c:46ee:c7d8:4e6c]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::e51c:46ee:c7d8:4e6c%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 13:43:58 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Thompson <davthompson@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXU/jmp/fRtKenoEC8aevprhzFk6r5mV0AgAWFx2CAAAqFgIAAAzHw
Date:   Tue, 1 Jun 2021 13:43:58 +0000
Message-ID: <CH2PR12MB38955E99161C89C165D70B76D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210528193719.6132-1-davthompson@nvidia.com>
 <YLGJLv7y0NLPFR28@lunn.ch>
 <CH2PR12MB3895FA4354E69D830F39CDC8D73E9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YLYz94yo0ge6CDh+@lunn.ch>
In-Reply-To: <YLYz94yo0ge6CDh+@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [65.96.160.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 081351fd-dda8-4c7e-9eba-08d925034eb4
x-ms-traffictypediagnostic: CH2PR12MB3976:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3976D34E2D591253D3C95C5ED73E9@CH2PR12MB3976.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rPjnZ0QFSdyMMIT3GGZnBikLjh4/d27sn6wObX7hha8tkocfQqtxhX2uIWMTMecIC8jhtUYUebD9dPRTrsPRpyo65kYjoRVADbbBmZO7B8OqqYx7p5b0vLmHiRc+cU4rrG8WUUWPSMXPqiQ89M/nIRV5X6+vvbyX0LQH6xTr0s7TkspB8U7IoNmJyWFLkNcsG2YULZ1u0lksaJUgcSD+559SVVPUC8CsTEQZU4BoP7SGhAWH6jHXV6S1R0sdQnNJcok1fsoQorwaeKRIJmYHpkpUU85nyg8et7kfr+Nml0o+vwwOF6RqM2TPnSHvn1bCC1TMDZI/SjRiZKoiPazqX0f2JvhvJ6f1q1GehqAqU+nJIGIxkD982/DHzqu5uX8qJNQRXfHJDQN8QHjwwQYMAzHroRT0rzJ1/+KiJWhBUAVR7J3dafBXePUFgLHRrLH7FwCZ5vnjNovXGYppfqS554/7w52J3bYL+//6XlklCvtyoUa9ao6j6Hjn7SLc8NieMHmUoJrVGGbtpxWOko6f+2OyEWzbiAoxoosGD1+N3Tu8QAwB1vbdXoT6iQE5DKFBvXZ0FBVBbLZpQpnqdeqXDDZaYxsJu4YJjGZWIQp+Irs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(2906002)(71200400001)(66946007)(76116006)(8936002)(4326008)(64756008)(66476007)(66446008)(66556008)(5660300002)(38100700002)(7696005)(186003)(26005)(316002)(6916009)(9686003)(86362001)(55016002)(54906003)(52536014)(33656002)(478600001)(83380400001)(6506007)(8676002)(122000001)(107886003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Wxoj/wCqNhDnwhKYQCdWE7I0PWBLB30uqMf7KZ1+zdpRhh6VKIEQUuazUddL?=
 =?us-ascii?Q?8wo8O2btXFmAcQAhr4bqeWNqzJFhprBJLkDHduPm1iJXy6GWRlnsfk6UzA2J?=
 =?us-ascii?Q?+LKrknc/5IdJH8UViHL5mvdajz3P9ikyulNmknYORlB2BF5q/c9jnZ0O2enW?=
 =?us-ascii?Q?cmTGXvynuMFZED4eoEpXRqmby9slWlaxRmbWPhk8gKw9l+AQ96JZDNvMFPuz?=
 =?us-ascii?Q?8QxD8/ctHzyOY43txD5/0TtfTQ+rR6udSDwBGfNMFJH5cYC6MRF0M6oWYG++?=
 =?us-ascii?Q?iNmBGkNxITi1JE/P3egKuMPFuzpuZzUdGrW1xcwhc7GAcoTSiX0F1qckp3mX?=
 =?us-ascii?Q?b2caU0KmDV9QVlkv6Q8duCWl2T75zxtha1bNZebjmbXtTGS5v+TFpkjzCh7U?=
 =?us-ascii?Q?4a1piHjHkcUseZuOy5la7XoDwNMu7DcBRsHpfhKFgxvh4rmp+jYIje5YP89f?=
 =?us-ascii?Q?4pqXSE4PzRcbD0uh0xNpaZqZjuUBSW7IjB8nv+a62gwAD68YvuV4corZf4RM?=
 =?us-ascii?Q?aOzWc+XkfWowiCq+s5kQ026HkOruvzH5ZeQv7SWV2MGEXgLHxv7fNZOu6VJv?=
 =?us-ascii?Q?UWL5DLt9toxv4UGZVqC/9HLBAE5HWLyJhBeNDJhuVxYTdDo6eiI/ihnyXPRR?=
 =?us-ascii?Q?4RBGcgiChJ9GZv7hTYv2kMUdPVVsR75nroknz/2BDnf5eK1GaBV7Eff7wUfU?=
 =?us-ascii?Q?oQ5czjREIgnChWAcdAU5DDIX0WaCXeVZ6scBoAjj2rOBGDFpjdisuB8MI5yK?=
 =?us-ascii?Q?oOqjyv8JIX1Hn6+6evAULB6rqzxJxmXgYSNW55FQ/Xz1oxscToBHfucLO+di?=
 =?us-ascii?Q?dJLfqu0fgX52BqXKqnRhtpTP7h+l82lswgJEIzOl57cB68vUrTmeJpSRyuqS?=
 =?us-ascii?Q?B+rLLj8mjiDdGEiXcaNvOD/5LmE+LfiztZhqRz+jb+XXZuFQcCvD3CCr4nEr?=
 =?us-ascii?Q?3w/aZWkYew+9uvDhv5IeTQAW60unCbMkChEpdruhGzzw8o0jZLv5IxD7liGu?=
 =?us-ascii?Q?5TJvZz8AR7ESGXcvqf6OHcAv40Y3Tp4gYw5nGjykcBPq7zryQtuedk45vMoZ?=
 =?us-ascii?Q?d+WbOaIqd0ePUXpyEO/hPBb15PzOSbyJxZ/uVtiMEVK8vGoqLdYWgqZnc7DM?=
 =?us-ascii?Q?6HFVYT9oGjAHVt2i4eN++XikWB2f/gQvvAl2y50LSTMw5fjx/HsIcPpcW6/R?=
 =?us-ascii?Q?ZVu3SqLutkzCo7ZnP8i28i6ZNUQ9E3JKo2MfF9E5C5MS/OiR/lcMlLu88Wlx?=
 =?us-ascii?Q?lQkgNc1J/YJXGnz+BWfNfbKqQkhH8L7y7kovaujZTQTDzSaAe5XQWrs5Bk0J?=
 =?us-ascii?Q?2zq6v2+b67w0nXsYrgcAr7cE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081351fd-dda8-4c7e-9eba-08d925034eb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 13:43:58.3946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fd0bi8l2nxfckpl7FydoesMug1Iv0+If9uSWS/cZsocrn5KtmYpsawxiXheTo+mt9OtYEGKM7L169usR7jq7kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3976
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Tuesday, June 1, 2021 9:20 AM
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: David Thompson <davthompson@nvidia.com>; davem@davemloft.net; kuba@kern=
el.org; netdev@vger.kernel.org; Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet dr=
iver

Please do not top post.

> Thanks.
> Asmaa
> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, May 28, 2021 8:22 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;=20
> Liming Sun <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit=20
> Ethernet driver
>=20
> > +static void mlxbf_gige_adjust_link (struct net_device *netdev) {
> > +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> > +	struct phy_device *phydev =3D netdev->phydev;
> > +
> > +	if (phydev->link) {
> > +		priv->rx_pause =3D phydev->pause;
> > +		priv->tx_pause =3D phydev->pause;
> > +	}
>=20
> ...
>=20
> > +	/* MAC supports symmetric flow control */
> > +	phy_support_sym_pause(phydev);
>=20

> What i don't see anywhere is you acting on the results of the pause=20
> negotiation. It could be, mlxbf_gige_adjust_link() tells you the peer=20
> does not support pause, and you need to disable it in this MAC as=20
> well. It is a negotiation, after all.

From what you are saying, this is all wrong. You don't negotiate at all. So=
 don't report negotiated values in ethtool, just report the fixed values, a=
nd do not set autoneg in ethtool_pauseparam because you have not negotiated=
 it.

You also should not be calling phy_support_sym_pause(), which means, i supp=
ort negotiated pause up to and including symmetric pause. You might also ne=
ed to clear the pause bits from phydev->advertising.

Asmaa>> Sounds good! We will update this in our next patch.
I guess I misunderstood. I thought 1G speed always requires autonegotiation=
. And phy_support_sym_pause would display that the only pause supported by =
this MAC is symmetric. But what you are saying is that we don't really "neg=
otiate" the pause since our MAC HW supports only symmetric pause?
/**
 * phy_support_sym_pause - Enable support of symmetrical pause
 * @phydev: target phy_device struct
 *
 * Description: Called by the MAC to indicate is supports symmetrical
 * Pause, but not asym pause.
 */
void phy_support_sym_pause(struct phy_device *phydev)

