Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E262DBA51
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgLPFH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:07:27 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:56504 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPFH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 00:07:27 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd995e40000>; Wed, 16 Dec 2020 13:06:45 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:06:40 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:06:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0pD//lfHDrvR4QzwDVSV+37QBnFAQMPy5Ti8M1HSJB0TttLWCxG3IgMKRU31Y5xg2hOsdwq0ZO7f2+hNcngUEMn7vPZvyTVCsgrZHP7rnrXKgV1PlZ4nbDmPg0PCQpjFmTiimtnfVyme7A/D1JGuVhLAMJ3fT6ZK3cyIyUtdqJufS5uLRlyAnG9+99lMcYqnOX3AGip6V16sZ7pBvJOtCL2Nr08fKuUPRMSIQmpzlPGzCXr3krP4LvPy1U9fe4Nz+1juyqebUfbYfgiqSxtXPvN6OMz4lzjq/Qlta6at7M0ez8q7Ay/FLAZy8UhoAmOSFgsbdeJ2uFDpOXKD6Z1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilKBi8bKMdc4QPxLQDBhBtlZlArV8FeTB13nEdAYarY=;
 b=TjSeHv7V+g/UzEYjkXOmqiWrbqlQzGMK8jG/L3qu2u5cvdlSErMt+iprY8MYnnD6Gcoybyd2+sJ0YcegOTaQZX4/GZjm4AGzr0ketSOd9zkW3AiaNN/xqCwhohragcHHr3Fb80dl8PHnJsyTsWVNNfcRnNbZB91RXsmk160gO/VgKDoXUt8V/ZmIu4xptdtGYifzshNM4Q2VTjbLV002gi87GG193XwUYyGUpYFdTIfA0P3MxYmgHTnE0Uf+PQARb96AU69V8XxJyiQZIb3uqKxttMMIAS+R8Ij/CZ10jzjCAUUVRQnnrEJawtWYi+buhJuVlM54tOkVn33XSCdwUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3985.namprd12.prod.outlook.com (2603:10b6:a03:196::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Wed, 16 Dec
 2020 05:06:37 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:06:37 +0000
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
Subject: RE: [net-next v5 04/15] devlink: Support add and delete devlink port
Thread-Topic: [net-next v5 04/15] devlink: Support add and delete devlink port
Thread-Index: AQHW0sFQJuUIoyweqEChgdwBfoTE3an434EAgABMEpA=
Date:   Wed, 16 Dec 2020 05:06:37 +0000
Message-ID: <BY5PR12MB4322EDD8E272D34E263CBFA2DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-5-saeed@kernel.org>
 <20201215162926.0d7f3683@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215162926.0d7f3683@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16505b44-cb09-4a44-3719-08d8a1805dff
x-ms-traffictypediagnostic: BY5PR12MB3985:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3985781B846603FDEC94BBD0DCC50@BY5PR12MB3985.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +mmZOZsI9qU4f5xB44OiEAlKCDZAQCiNUqgqVQXDYYOk+dlWnm1j+l8E3iDOqCAO0F1MF4DND8Qj35WH+LcK60fJqYsbRgUzkvWjUjCtGKkI4mvGxTUyJzeH6pwV6EjnF+XmD37yZnVjWMXnuxcMijIBZJf60+c6snDOJvZOavHWPD2mV+DqZDE3GmplDUnnpiQL/O6mvG7eIlaSPcAJZi/kLvdrlZ+D+ZjCVT3Hs9um+ESFfDEimpIGQmScWuYr82NFQuYgncb7yboq0+nkMFmgGfF4vjsZfCrqxQONFgCNsr4KvXRFA7n2Zl4QBA/1yvbximkVPC1KImG9YMIz9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(376002)(396003)(346002)(64756008)(478600001)(7696005)(7416002)(316002)(66446008)(52536014)(66476007)(71200400001)(6506007)(33656002)(54906003)(5660300002)(76116006)(4326008)(83380400001)(26005)(110136005)(8676002)(9686003)(66946007)(55236004)(86362001)(107886003)(66556008)(2906002)(8936002)(55016002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6o7EUIIgapGB5axofbSaFQP2vMlt89kmwoGAf+tsZ1vmlIfXv4AKIt6feTlA?=
 =?us-ascii?Q?uv88OsymRcUVXzBb2Iik7E3xqMm1IZtNkdOqmFgPcHAf3RDzhNtwP6MVzxm5?=
 =?us-ascii?Q?C43iHMeYzQ3ZzaQDlY91of1a/Pd8eHGoEo4mo06JdL6fWO0msk2wAIdBeE/M?=
 =?us-ascii?Q?U+zdah4Y63SBzKOXZhn8iD4tq6pO2oC2PUZKFbXP+vRqi3WHKl0utDZfDsPC?=
 =?us-ascii?Q?nNVz6xpI/CjbzHZOjDFWD3qSO8F4dGiKQX/Wt1swNJzIqPvZRDTtSvdPm20n?=
 =?us-ascii?Q?tSBCDPyP8PqOBq2SnbIa/d0BUcmUtgiHpWFFnftOKe7CLfzKeW2xt1c2Q9yF?=
 =?us-ascii?Q?2e3LDk+mkwoOGvEvRCIKBfiVvcg+CqaOdj+pS4/CuU4b3bNHyi9Yt8A8KbWV?=
 =?us-ascii?Q?OCohS/sWMZDPAo/wjIxr0jS4E+89M+XpmA4MXfI886Njrz4fnY2J3oduo19S?=
 =?us-ascii?Q?v3i1VFJ3tzQ/j/nit7Bi/tK4Eeaqp4R9Lju9rsN0UhTbr3R0QbOJqbHSKv8E?=
 =?us-ascii?Q?s53hDAudrFHuyhAMQ1OUWa8/1BTXyFoEEwyCauZk5+To11mE42bHEMVq8Iw7?=
 =?us-ascii?Q?dDCd1TmLPC2NSc/dh8tVFlLEPVj/MQN4YgvVE0aEc4HotQZQ2c58Me0ZOsTR?=
 =?us-ascii?Q?iQHgrzMCW4/e30Lu3YggRO/Jt5GsW0gndzplWkLrpPnwF7IytJxElF42iUXu?=
 =?us-ascii?Q?z1TzioFI0JieVocdo5BZuKHOS0JDxIlHSFLb6NMEl72gZkJOfqSLW5cwlz9V?=
 =?us-ascii?Q?Rt5uNPk1Vs/VZ2OzN5n+uevIek0wuSqZWNTrg5i+LYm/lmoA3JRUbPptt7E+?=
 =?us-ascii?Q?DxqXB36ARibvvLhQ+ImOC3/Yxo64D+dqHLACVFijHZ05XkAQ0RiFF03k2jxU?=
 =?us-ascii?Q?Erl8rHn6o5DgaRvzyKFGkHWMKRdy7AqapAYQVrW82oXY/faBfJB8O2CAddLY?=
 =?us-ascii?Q?FneWTAVfRuufeV1GjgDDjJJX4DOfJVJAs6ARjSSPj/k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16505b44-cb09-4a44-3719-08d8a1805dff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:06:37.5806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9HBspPyVX92FyDPMbm70zjEZYAre1keRdPLxlhj/pkc1cRam+ux1QzEhcRGNBeNQ0OZ6wO0zgAcMfkwsQyqrFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3985
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608095205; bh=ilKBi8bKMdc4QPxLQDBhBtlZlArV8FeTB13nEdAYarY=;
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
        b=edNSXMd3ORsH38jkh7J1X5ryGE8lgkbYIEN2NLtF1FgflV7Yz/UGmO03WUldosMrI
         Tic/Z8uV+Cq7NSpOqYpouzCBaw7lX4aqN6dT1dg7U60OcLvMrejH4EUKEzvPbHDzpe
         DbwquCmzn4KmlpbUFQHvABXa6KoCsu9ZqOBeNC5mU0g0kUWZ1RWqZheFoMqjfIhyUd
         nkN7yv5flHVtpKoFA996l1HFDR9oVUMc4ZtKe2laNxdWuFJenQd8Mc0ngZNqPf+CDM
         LmMnSUD4IXtbnG0YrRr5Ew48JY0cBERN8lBeogouNyxFC35sSVI8LkKC7zLgrIYGxs
         FoVy9PgJ6sS0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 5:59 AM
>=20
> > +struct devlink_port_new_attrs {
> > +	enum devlink_port_flavour flavour;
> > +	unsigned int port_index;
> > +	u32 controller;
> > +	u32 sfnum;
> > +	u16 pfnum;
>=20
> Oh. So you had the structure which actually gets stored in memory for the
> lifetime of the device in patch 3 mispacked (u32 / u16 / u32 / u8).
> But this one with arguments is packed. Please be consistent.
>
Ok. I will change the packing in patch 3.
=20
> > +	u8 port_index_valid:1,
> > +	   controller_valid:1,
> > +	   sfnum_valid:1;
> > +};
> > +
> >  struct devlink_sb_pool_info {
> >  	enum devlink_sb_pool_type pool_type;
> >  	u32 size;
> > @@ -1363,6 +1374,34 @@ struct devlink_ops {
> >  	int (*port_function_hw_addr_set)(struct devlink *devlink, struct
> devlink_port *port,
> >  					 const u8 *hw_addr, int
> hw_addr_len,
> >  					 struct netlink_ext_ack *extack);
> > +	/**
> > +	 * @port_new: Port add function.
> > +	 *
> > +	 * Should be used by device driver to let caller add new port of a
> > +	 * specified flavour with optional attributes.
>=20
> Add a new port of a specified flavor with optional attributes.
>=20
> > +	 * Driver should return -EOPNOTSUPP if it doesn't support port
> > +addition
>=20
> s/should/must/
>
Ack.
=20
> > +	 * of a specified flavour or specified attributes. Driver should set
> > +	 * extack error message in case of fail to add the port. Devlink
> > +core
>=20
> s/fail to add the port/failure/
>=20
Ack.

> > +	 * does not hold a devlink instance lock when this callback is invoke=
d.
>=20
> Called without holding the devlink instance lock.
>
Ack.
=20
> > +	 * Driver must ensures synchronization when adding or deleting a
> port.
>=20
> s/ensures/ensure/ but really that's pretty obvious from the previous
> sentence.
>=20
It may be, but this extra clarity helps, so I am going to keep this explici=
t description.

> > +	 * Driver must register a port with devlink core.
>=20
> s/must/is expected to/
>
Ack.
=20
> Please make sure your comments and documentation are proof read by
> someone.
>=20
Ack.

> > +static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
> > +					struct genl_info *info)
> > +{
> > +	struct netlink_ext_ack *extack =3D info->extack;
> > +	struct devlink_port_new_attrs new_attrs =3D {};
> > +	struct devlink *devlink =3D info->user_ptr[0];
> > +
> > +	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
> > +	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are
> not specified");
> > +		return -EINVAL;
> > +	}
> > +	new_attrs.flavour =3D nla_get_u16(info-
> >attrs[DEVLINK_ATTR_PORT_FLAVOUR]);
> > +	new_attrs.pfnum =3D
> > +		nla_get_u16(info-
> >attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
> > +
> > +	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
> > +		new_attrs.port_index =3D
> > +			nla_get_u32(info-
> >attrs[DEVLINK_ATTR_PORT_INDEX]);
> > +		new_attrs.port_index_valid =3D true;
> > +	}
>=20
> This is the desired port index of the new port?
Yes.
> Let's make it abundantly clear since its a pass-thru argument for the dri=
ver to
> interpret.
>
Ok. Will add comment here.
=20
> > +	if (info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]) {
> > +		new_attrs.controller =3D
> > +			nla_get_u16(info-
> >attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]);
> > +		new_attrs.controller_valid =3D true;
> > +	}
> > +	if (info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]) {
> > +		new_attrs.sfnum =3D nla_get_u32(info-
> >attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]);
> > +		new_attrs.sfnum_valid =3D true;
> > +	}
> > +
> > +	if (!devlink->ops->port_new)
> > +		return -EOPNOTSUPP;
>=20
> Why is this check not at the beginning of the function?
Will move it up.

> Also should there be an extack on it?
>=20
Will check, and add if required.
> > +	return devlink->ops->port_new(devlink, &new_attrs, extack);
>=20
> This should return the identifier of the created port back to user space.
Ok. Will add.
