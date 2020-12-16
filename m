Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131662DBA5A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPFPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:15:53 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:15544 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPFPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 00:15:53 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd997df0000>; Wed, 16 Dec 2020 13:15:11 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:15:08 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:15:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cw5tqZj8QqxhOeD3XWo2/Lx8FxenNuydSKSzR/3hhkbCr2msUBvlKpJ9C+tEeUrR+n5RkPKNdMOB51dt/MVKgc7gyn7I4iDBWdW6WnnK9fsawwzgeMJiGYD8NwK4X1jNz3s3h9PhIonl9D+i50HPv7JhWyHraj7X/3GTZf0B6lCwXOVZaVOPQ4SJ7jXzDYhQ9/Keq/HggjonSgkrZwS75OOpabdavV7/R3Mo7X5TYVf6e70f7dXV6+VHaXWuxCKewDzk3OO9KXu+4pUYTsZIjYUdg/WhNRJ3+M1agqshfRoL68EM8vEu4tJGu54yjPBRgS7nciPhXiPsxcIUtT08zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EejUvS5CEoPgsPKxYcf9wHVxXrg7xtBrov3UtkgvdNw=;
 b=ZIGvETbcJtmdrGjITo1Od3T+3RlxCwK8TRZy4g8qFFFvBHZQ1rzCXihch7hPH31oK0mmQsWDruEOTEKe9rsT0ePSRCu35EDBIt1c/P4nHWT9BF6x4NO45H/JVjbFAyBdwx5v76H2LkbBkht0KzZgCRalHnPFWLBfzOt4SlIAejcdpmZ84If69O3ghGNBTzaGxAzb2lTpoge+XoP7Pg42viJapkBIIpmYM7wOacQQC6ySS9G96CxNLO5XgJz3zQ0rJIJkHgONJmy08HHq4f8LxUgdTbTImGv6kjXCFDEj0xJA12TdGupKbMwqEAStvw+G5MZ3rSAyLdO76NMCEQlwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4951.namprd12.prod.outlook.com (2603:10b6:a03:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Wed, 16 Dec
 2020 05:15:04 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:15:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Topic: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Index: AQHW0sFH91yNDr98FE67ntr+TvpO06n44deAgABLWyA=
Date:   Wed, 16 Dec 2020 05:15:04 +0000
Message-ID: <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
 <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1f8c435-e9ce-4d99-13dd-08d8a1818c0d
x-ms-traffictypediagnostic: BY5PR12MB4951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49510CBDEF22B91D655AA3D6DCC50@BY5PR12MB4951.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6PLaxNzC8GdSHGCoqdD6fTe71r9mfnyBIH3dBTobVuyxro5gE/E32ZaZmkVydGzNZ5uGfAXDzX0b+TmHMOjeHyv8VR71mTL2IteWt4Kuoj5U7DQdoo3rmQG1M7h/vKKq3hjjhTvBsAE3QYSM1WxSL43cJHwJm8PV4BRHwMkxJ/Dn9SsbRNf90tFj3+uXMj++DR1GnbNFPClpYyPk7R7OUv/JCX2lJ+7VSzp6sbNmrJNZs3eI1BnZVb98/d9o8YFOlRUnQwLqX6R9wkrlxt1LcK1frhX+VFAmdRF8pLKH5SUQEGYYpdHEb+ka96oUEiYVuw8RpdOmdBRyM9mQm79ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(366004)(376002)(66476007)(55236004)(76116006)(478600001)(7416002)(4326008)(186003)(110136005)(55016002)(64756008)(107886003)(66556008)(2906002)(316002)(66446008)(71200400001)(5660300002)(86362001)(9686003)(52536014)(7696005)(33656002)(54906003)(66946007)(26005)(8676002)(6506007)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4gVRkTjWnd4C3VwMU+CuVrzxLL6rXxS3ew/F0gvSlNILx2t/K+9EBs+lY6+b?=
 =?us-ascii?Q?hvhezFB78d1Wfe+DlI3g6aDvF5VmWW51Iyf3GFqRpKPY+/yGe9p7YYusmpDG?=
 =?us-ascii?Q?ioUE7QCkPofw2vN0CuZ6I5kbaWUbC3jSZoyqa5rTZKKgYDSt5KtU3XcyN6ns?=
 =?us-ascii?Q?owuHjSLUmaOue0JiVzFrN+2Kka92aI1Nr2QaH9lyV28qc9DeBLCuGE06yxts?=
 =?us-ascii?Q?scXHIMW5/J1CVPREFLu6kNkPHL7+UpPrE4QgO9bXBvO9JGG3OB07OCUoy7hR?=
 =?us-ascii?Q?zlvuuaRWXgwh90Go7rwaDN/NH0k9eDmQ2SIFlo5zez4nkVnt4QrtIOnN282G?=
 =?us-ascii?Q?NE68nNCVQSqmwxCscpIvn8Bn47te7SabDP8bMLvgcXof9dCAJt0VVY5T9TY8?=
 =?us-ascii?Q?mOJWpIoLiNQUdO3ukqpSF7w47YsEFGW3Z7imCs/3ogjum8IheLyLvZC5urZY?=
 =?us-ascii?Q?xYMXpfCaR1cnSxA9O7ogzg/+2KYGOsmtRptCMzmBkndJZ+wgjF/is75EvO1N?=
 =?us-ascii?Q?865HJJKHWPC8alLLJMPW+VgglKWDBRGHSDPo4SVs+2Zd86WBHdhz3hjGXg/O?=
 =?us-ascii?Q?eWjFjVeoy2uunHkeE6RGRDZcxB247wBBmTSJ9qiVlv9cvJnzjWshpqE5Ul1w?=
 =?us-ascii?Q?/Mm9mYX7HHgse0T3GNpntJMDg5zEOfFvNXTXD3BHOdEIWSLjrH9NR35KOwyM?=
 =?us-ascii?Q?l5/u0Yw8wUkhwlIVCFNulbK0r8KYNmz6stmi5tzm2Svc5B2UjOt4sJIL+kHe?=
 =?us-ascii?Q?P6/9YdPq7jxDFfUKZZ69jdDReyO35vmxm4Xz5T2wQvNw77t+AJnCFZD3njBq?=
 =?us-ascii?Q?N3+cA1GD/a3kDu1nyvcFS2lK1FwfCb1Fe/K5DcJU1HdeGWz/qpWoOR6mYukJ?=
 =?us-ascii?Q?UBLUn3q0OwC5eYojAQiXQM4Dfxjyu+tkA+1LYfn2Mf8gN9+TJLq8B/9MGeRL?=
 =?us-ascii?Q?KCAqQRbHkob7o+AkllTdZZpyBKEVboKQiEEAk78ix4k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f8c435-e9ce-4d99-13dd-08d8a1818c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:15:04.3723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXPVXA09Zq40M3rgJQhV6kRw5JePQC9R8F+1TFKMXlDKZoZC9Qr4Wp3MRES1VZLiUhhBP18RFZlBggR93jsXqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4951
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608095711; bh=EejUvS5CEoPgsPKxYcf9wHVxXrg7xtBrov3UtkgvdNw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=AxMmoRWjAzQ9q0Jq/5fyD1Yv4yrXT8OQtzgBYjBp/pAJ2O/W5n+6BkYFhW8MqKUA4
         M6uZ9nGshubtgC9OB9543xGxP1SMFOtWGtT4OmVv1Vq0WOUkFRuNi/fQg+c8771XZP
         knCQrPnbo59s6T6DLx7aA5ntHwO26aGTdeOPppk+JEtEUx0R5xqbcta0ZeRJ8YZpWW
         Jm2ylv7AptzqMHGXka4K2O7RU3BvN/RpWFLc2TH6RxnBnm2FcGRp63yHRJ2MWKmxwz
         I/Owqg2yJHOOHVUwNzWzeq91KYDMx6RBTW21GkC5Dd4+zKGYmLgFwvvye6s0HN0Ehu
         ZcQyhnUtDlU8Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:08 AM
>=20
> On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:
> > From: Parav Pandit <parav@nvidia.com>
> >
> > devlink port function can be in active or inactive state.
> > Allow users to get and set port function's state.
> >
> > When the port function it activated, its operational state may change
> > after a while when the device is created and driver binds to it.
> > Similarly on deactivation flow.
>=20
> So what's the flow device should implement?
>=20
> User requests deactivated, the device sends a notification to the driver
> bound to the device. What if the driver ignores it?
>
If driver ignores it, those devices are marked unusable for new allocation.
Device becomes usable only after it has act on the event.
=20
> > $ devlink port function set pci/0000:06:00.0/32768 hw_addr
> > 00:00:00:00:88:88 state active
>=20
> Is request to deactivate done by settings state to inactive?
>
Yes.
=20
> > + * enum devlink_port_function_opstate - indicates operational state
> > + of port function
> > + * @DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED: Driver is attached
> to the
> > + function of port,
>=20
> This name definitely needs to be shortened.
>
DEVLINK_PORT_FUNCTION_OPS_ATTACHED
Or
DEVLINK_PF_OPS_ATTACHED=20

PF - port function
=20
> > + *					    gracefufl tear down of the function,
> after
>=20
> gracefufl
>=20
> > + *					    inactivation of the port function,
> user should wait
> > + *					    for operational state to turn
> DETACHED.
>=20
> Why do you indent the comment by 40 characters and then go over 80
> chars?
>=20
Will fix it.

> > + * @DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED: Driver is detached
> from the function of port; it is
> > + *					    safe to delete the port.
> > + */
> > +enum devlink_port_function_opstate {
> > +	DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED,
>=20
> The port function must be some Mellanox speak - for the second time - I
> have no idea what it means. Please use meaningful names.
>
It is not a Mellanox term.
Port function object is the one that represents function behind this port.
It is not a new term. Port function already exists in devlink whose operati=
onal state attribute is defined here.
=20
> > devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct
> > devlink_port *por
> >
> >  	ops =3D devlink->ops;
> >  	err =3D devlink_port_function_hw_addr_fill(devlink, ops, port, msg,
> > extack, &msg_updated);
>=20
> Wrap your code, please.
>
Sure, will do.
