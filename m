Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6F2F1713
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388350AbhAKOBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:01:10 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15694 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388036AbhAKOBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:01:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc59f60001>; Mon, 11 Jan 2021 06:00:22 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 14:00:22 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 11 Jan 2021 14:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Er1Zc7rXCtzycVwB8DskX47EBqaPJr2jRH0L96bHKwg+onLwBCwGnpRkSOIuHm3j7LAoIOScpJ29dJEiU/iV3GJIYCmX0Yd2Rkx1I5sVCcFgpRY33jbGnODqTEhU3JbiCduWNJ87cM1SiIVNR3H9tUAUXIQjQ8kAJKkKDAVl5L9oA5r9FwDIwHws0mUxTygHJTZsSxWnoIa5yFDe38L0gFU8RtJh0TQ/Gix6Vwczag2V1/OiRH4rXZFABqjfd3+Qkf4yyXu9wRihJ/hOHNo7r2rTSdR96GmDmmk26U4enDIQ2KxmATrEolZNMd4rTSKvaD9ifTnbs1mZlnV6Ir3M8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZIDdajcelj86s1yI0GaPz7rnVim6PoTghvKiCJT5OA=;
 b=n76MvIuP3D51Cz4HLTRX4qvoJwlScYiWZUWEUa3MWcQtElN8av8nE1+dmIDfbB/wjGFsMcYz9slLVc4ayVAZO3Wt0iuyUX5939RjH1YDswFN0kcKYGBCAcY1SP/4AxTL0Cd3ywThtC/g4BgEbw79fGkpbkHeRQGJujyW54aeThqDshprA0VaQgN71fd8Xs73T36Yy6+JmxWkVOn5YCyvnKYjHibklw5olwHODhUTrlWRvKgkt2ZNmQHZr3+NQVFX9mjpm3zDRsDs9xUR1njD47jTdDPRwITswaST+URlH3CtsW2H8NgjfqTFT93m5gTVl2X7RNLKA9RBVowzXCYHuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR1201MB2472.namprd12.prod.outlook.com (2603:10b6:3:e1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 14:00:20 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 14:00:20 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Danielle Ratson <danieller@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next repost v2 1/7] ethtool: Extend link modes
 settings uAPI with lanes
Thread-Topic: [PATCH net-next repost v2 1/7] ethtool: Extend link modes
 settings uAPI with lanes
Thread-Index: AQHW5CzazWi1/vPv40CAHrkEfmJuiaoc49wAgAWXvVA=
Date:   Mon, 11 Jan 2021 14:00:20 +0000
Message-ID: <DM6PR12MB451691B3A3E6EE51B87AD75FD8AB0@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-2-danieller@mellanox.com>
 <20210107163504.55018c73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107163504.55018c73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3cd2f28-4f3b-4b69-c19d-08d8b6393bf0
x-ms-traffictypediagnostic: DM5PR1201MB2472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB247246711DE83B3732AFF637D8AB0@DM5PR1201MB2472.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TGYmHM/abzKFDZKNj5kNPna/labfUjMUtPfKRrSuIUfp08NNaH/Q+5++dMY0qQjhwpwnO/ZiDUgIXyWhmidm76tA5Y1Xh33t43IPXdO78n0hInxinAUJH1F9AcxFXtBqogFTTt0zwslgci6xwJn53LNayT9BiEofVeWCUo1E8rAcAYEquTUD145pwIq9KMw/8F0qiZnllZff+ety97m40oZdh3MT6sL9ZuiBcq8L3zqhMTYeCGCJ8MzSUlKMaELGdGG/Iluzs0UjxZa0j0qYZGuLhMe+slb7SxsQPprprOBRCJBO3cRJk5zSypuSIUvKwOVjhVV754RSROTIL9SFXF7ru6trL11MsUlkhN4HrwPuWvwPe4A7zYt5YHE5egLL08DhpY9jx5beAfCjhmgoLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(6506007)(53546011)(8936002)(478600001)(71200400001)(9686003)(186003)(2906002)(4326008)(86362001)(26005)(316002)(83380400001)(66946007)(54906003)(66476007)(8676002)(64756008)(33656002)(66556008)(76116006)(66446008)(52536014)(55016002)(7696005)(107886003)(110136005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QjnFVSTCXHLgVX+J3KydMva6CSOS5LrzJK6Ttyr+wGC2We5LnZppSiDf2aGw?=
 =?us-ascii?Q?ZRjn+a8poR3GvVmaI+QN9w6CbnY4hG6pTzBPXFsPdJxQj809Bf+l9BLVH4Oi?=
 =?us-ascii?Q?R1OfptRh/p8fBt5IZF9DY8JlXirZ9GrB9xgn1Y4g2GHiZK68ZgsRCF4nYp3P?=
 =?us-ascii?Q?ni1K4d7rB6x2p3e7XCBnPKP30bMdalqJVe+x31F7tlNm6xuw2epSkU0yFZ7h?=
 =?us-ascii?Q?5uWejGxeYcc+lXCgMuTxY5fYO9tsFwN40xoeUWcEjbnw+0izAt0ahD1W87eE?=
 =?us-ascii?Q?PRJ1D5STXuG+OJmMmsA8rPsp+gz2e5FXnUxiX3hupzFPmEAH5W9GYysaPsf9?=
 =?us-ascii?Q?69gkh3ZBD9eiodLUDnCDjn2Ex6lMN7B5q0om1TRNo364WEZU85svcBGVe1P/?=
 =?us-ascii?Q?xTWbGQMacMmUZQFfiZVLasUTyBIrk0Xu2CYMCI0l+ueEyzbnez6dfa4K3mkK?=
 =?us-ascii?Q?v5JXN/F0iffGOg0xkQE0bYr+DOTAaP2rdJfWtjuFMOJhO9BczKeW1NdkAsCr?=
 =?us-ascii?Q?MWLQtsACiltRKOMNWOcPkWJuFPJyPYoLDaWfkR58f9kImJyY7uQ6Dokn35Yl?=
 =?us-ascii?Q?XyYqSPEOsQp9n1EXRlFKRWKj8+sYTuYe0FJ7SlD73VaZ3FYwv75AKfQEnUQG?=
 =?us-ascii?Q?QHejkWfjdOpIFJ4dFjpp4Ym62or3TXZ4cW3I36tsKvxXozaeZ7+enLskGoFP?=
 =?us-ascii?Q?C4cQMjSLwNFcj+8PyxeDwnvxBmxKeqwLzuHCtbgUYES+Mbx0CQRn2xlcNuP4?=
 =?us-ascii?Q?fp8I+tnXZWDwVwylurmZi8GKrnFyYbNtlo93tlR6tYaIXJ0VuzYEYTEe0miX?=
 =?us-ascii?Q?WvuKLij3w0SWXfW6TT8qyWlyoVg6ocL7HGBeKwpbk/AvIDgF3M5j8Q5DXB/j?=
 =?us-ascii?Q?58qQxUUDFgozabb6sl1mkEmLGs02CycalSxS0UwbrDXREcj6PHd1wt0T5Cj2?=
 =?us-ascii?Q?V69Ity30Y7S6OEYZw8vaMdwW1g6OM22VKwHkbbMQ0RU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cd2f28-4f3b-4b69-c19d-08d8b6393bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 14:00:20.6347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jNeAyoqyInVwfOafD/vmqfe7nyXrtAD56R3g+LPkVmu7rWFoaD1D14XhcIr5tpCx9xVpG429ky6dEWP+gWUezQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2472
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610373622; bh=LZIDdajcelj86s1yI0GaPz7rnVim6PoTghvKiCJT5OA=;
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
        b=Ryq1CKiT9Umf9LYeZ2nma4+yKEObxbYG+QASDX/NGvmEwom045iUwWcS2Ce3FSIT0
         jHsKyky8CXs4Txow6z51Mbln5389RV3pvbK7wAnmdv2Rv2AuKp13oLuTiuqFjJbLOI
         oK7l86fbZnmFsAbuvf4IVj2I9FTISmz/i1uoZALThXkP5avWJWGDWIIms0S1d/3p2z
         N0B5G683ZYpWJWgT0Xf5Ckyr+Kmvm+iKRkl3cGVa2oMjn1ZLN0ihX1955+TaruD7aw
         ft16nAPrJvKkvjWn20aqX1ZzgSPfR3BqWFhJgL8Db8th7X9ZszGLEzMD3MQlP/XVEQ
         Y1UZ3EgV6xdrA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, January 8, 2021 2:35 AM
> To: Danielle Ratson <danieller@mellanox.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko <jiri@nvidia.=
com>; andrew@lunn.ch; f.fainelli@gmail.com;
> mkubecek@suse.cz; mlxsw <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.c=
om>; Danielle Ratson <danieller@nvidia.com>
> Subject: Re: [PATCH net-next repost v2 1/7] ethtool: Extend link modes se=
ttings uAPI with lanes
>=20
> On Wed,  6 Jan 2021 15:06:16 +0200 Danielle Ratson wrote:
> > From: Danielle Ratson <danieller@nvidia.com>
> >
> > Currently, when auto negotiation is on, the user can advertise all the
> > linkmodes which correspond to a specific speed, but does not have a
> > similar selector for the number of lanes. This is significant when a
> > specific speed can be achieved using different number of lanes.  For
> > example, 2x50 or 4x25.
> >
> > Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
> > ethtool_link_settings' with lanes field in order to implement a new
> > lanes-selector that will enable the user to advertise a specific
> > number of lanes as well.
> >
> > When auto negotiation is off, lanes parameter can be forced only if
> > the driver supports it. Add a capability bit in 'struct ethtool_ops'
> > that allows ethtool know if the driver can handle the lanes parameter
> > when auto negotiation is off, so if it does not, an error message will
> > be returned when trying to set lanes.
>=20
> > @@ -420,6 +423,7 @@ struct ethtool_pause_stats {
> >   * of the generic netdev features interface.
> >   */
> >  struct ethtool_ops {
> > +	u32     capabilities;
>=20
> An appropriately named bitfield seems better. Alternatively maybe let the=
 driver specify which lane counts it can accept?

Not sure what did you mean, can you please explain?
Thanks!

>=20
> And please remember to add the kdoc.
>=20
> >  	u32	supported_coalesce_params;
> >  	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
> >  	int	(*get_regs_len)(struct net_device *);
>=20
> > @@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_polic=
y[] =3D {
> >  	[ETHTOOL_A_LINKMODES_SPEED]		=3D { .type =3D NLA_U32 },
> >  	[ETHTOOL_A_LINKMODES_DUPLEX]		=3D { .type =3D NLA_U8 },
> >  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	=3D { .type =3D NLA_U8 },
> > +	[ETHTOOL_A_LINKMODES_LANES]		=3D { .type =3D NLA_U32 },
>=20
> Please set the min and max for the policy, so userspace can at least see =
that part.
>=20
> > +static bool ethnl_validate_lanes_cfg(u32 cfg) {
> > +	switch (cfg) {
> > +	case 1:
> > +	case 2:
> > +	case 4:
> > +	case 8:
> > +		return true;
>=20
> And with the policy checking min and max this can be turned into a simple=
 is_power_of_2() call.
>=20
> > +	}
> > +
> > +	return false;
> > +}
