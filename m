Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813E12DB9B4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 04:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPDnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 22:43:37 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16289 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPDnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 22:43:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd982410000>; Tue, 15 Dec 2020 19:42:57 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 03:42:53 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 03:42:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrXgbYVlKkHtXG7C9ExIHwB+BJ8YMTEzshh4+n0+p7LMfkzdksnNVfYpgLcxcqGr75bL6eg4lr/05YDpeVm0xLYg1Z1ui0vTq97lhr4RBjL39DMNQQMFc5vEYnOKfLfkq+dfaOf737ac9q+leMrUycgIIWEg9Gpj2+yTowD2kG3R7MXofnk5UZ4lcFkLNAaxPXU0S2kfXl0MJjJw807PDltm0rpG+csge/Qz5Y+sBfv8Mutr4gO+mtD6L6HiVuYGboAZCOcwukIjTK8Pl3PrIXLZVOVbmFJJYgANMdx2gs3CQ2ZGp+P6x+QgbLPnfdWJCN1MD1RXOpu7D3DbIUDJUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bIU8tXYhVX/k4S1rUYD1QgXwt7tQCj9pVix1qIXIBA=;
 b=E6TcDDDCb+falEolrMh2+Ua5LxZdM3WOOKcQ6fDRzxwtbTqYZpty+aA9mAS0goipmNAxXW8PQU6r1s+IOvbzkUqPdCEh4jVRuBxSPSF/rBk20ILcM/ZDx1ArdSpQkoJP3RU4WZVvANqtISy7RN3y27zyj5EFnNpV7F9UEDCQX5BA9iV2o8Z1xG1HxdUG5cntRFgbwuMewyqfOlMhbXV/v+5YX5y+4i1Gpd+8RPGLq9Vp1bYpKUJYac1bIBLp0cP1C0ZV+RlHMrbgyQ+AXP9tLywp5LrpT2pErRRk6dxTJs8hEe82VdOow62JsrGcOPAz8CHa672By9q7d+QnXG6xrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2935.namprd12.prod.outlook.com (2603:10b6:a03:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 03:42:52 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 03:42:52 +0000
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
Subject: RE: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Topic: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Index: AQHW0sFHdQ+yzn0pRUyP/4UDzcNU4Kn4zj8AgABFQ1A=
Date:   Wed, 16 Dec 2020 03:42:51 +0000
Message-ID: <BY5PR12MB432268C16D118BC435C0EF5CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-4-saeed@kernel.org>
 <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed3f61a2-b7c8-4213-c526-08d8a174aa77
x-ms-traffictypediagnostic: BYAPR12MB2935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB293595D76CBC5601E5F5747CDCC50@BYAPR12MB2935.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YvaEEcMpZclio4Ccmznr48sZCPokMLazw+iBPlZvE2QoAsswvABFlJRpBB6vX/cvKlK3LCDWpMJzBJo3u88xDq9PQama4vVbY04mvnOlHlM8K9vnnpZFnl3seV1rvI4AuU9ceC9vVaq2yvhjtBiR25zbJ1UKMVuHUoJvFesV2UmMXi8nZlHuRSq/PecJvuwvQ7FwRPkdnbjzn8m3VIPwi5pvLvDAXEUHpsltDVoXUIaWi90yeG6kYKBtngQ0XW9NHArTzuCZqFmlgP3/G2MmCABTzi4dEcIiEazh9iESPRew85JO0QwkHX8HjFOABX3Rw2Cu8e1zOJJURdpNF5DjHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(366004)(376002)(9686003)(316002)(33656002)(55236004)(7696005)(54906003)(71200400001)(26005)(186003)(86362001)(83380400001)(478600001)(5660300002)(7416002)(4326008)(66476007)(8676002)(64756008)(66446008)(66556008)(66946007)(2906002)(110136005)(107886003)(55016002)(76116006)(8936002)(52536014)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yza1Pt+K7ExuM51d7ex/PyW+vfDR0gAlAaJsqkK+7qDhostI5Y1bB4D+V8E1?=
 =?us-ascii?Q?Z5WYSxi5I+GI+BroA+3t9YUhow/0apERbOayM2h1kaM1BnVPwYq7sjJivTDD?=
 =?us-ascii?Q?fPEoLHh8NxfYlZLm2IKQUOnLeSdcV2h8tQOkdEGv05rDffEpJsHoFwFGEFoX?=
 =?us-ascii?Q?a3AsjTF3lw+kTrM66iVsqF87RGyIQD0DUQ+iF77/qECMpcv8U+BuS3dCPHG1?=
 =?us-ascii?Q?gL/IN5gIV0ktHsAjGg9n1qPH6EKFahh3+rXPOQwruNA2VRRR9w9bLS0QQPjh?=
 =?us-ascii?Q?xqKA0H7unZ9oAHembvPjOUEKixLfj5Sa/m61HsggWra2O+mbR63lBf2vCj/z?=
 =?us-ascii?Q?e5BXgRcrHchq+uyY6Eib6kKUA3mxKfFMkAy1hu47l8uAAm6hLvetXkons2LM?=
 =?us-ascii?Q?Pd9NMpl9m8dmp/b52KuJneD4K6zQmBgAH6oKQYwKNcjDJkKDxPyarb7SACJW?=
 =?us-ascii?Q?i8+UzbQEFbiePQ4L8wooXQcnhW5+akIUHigENo8VqXSvO48KRZdr/jC4D3VG?=
 =?us-ascii?Q?GVMk+8Fmyt0RtVNtkoYTypWz7iw7hqWyoYnqhzfWuwn9CVE6F7MR7rCB5zZH?=
 =?us-ascii?Q?QW7gS2T3NaUS80jEMsx7SS1JHOeY7mfDZPezVk5KumUqhZOIwPLIxaRu/U7k?=
 =?us-ascii?Q?FHH7jNdf52PPJxkoR4W9uaor23xRfnx/M+P4DiUONZV8F1i+JvykOWiO6oIw?=
 =?us-ascii?Q?nXXL0vN7VVk6qxp3V+HZAnktAQSCtJWO83QdC/5Rneq911Ool/tpGKRRAbkr?=
 =?us-ascii?Q?d8N3g7KlhV4i3nrijnr1grKTCuZ+BPUPNSjP6UMccx4CYBrikNNpW3MiB/5m?=
 =?us-ascii?Q?xaei3GaYFbWsD9vFBON5lylhMU3XeyPBib4QX5AjdsiLduOB4FYMMXuv9SZW?=
 =?us-ascii?Q?Z7ah5p4GKH1eq7AsJy+4TP9bzaaiLQpFgZ/X92zVZ0WN1HFeZfofOWOJfcBs?=
 =?us-ascii?Q?GDWZRulzMvAYyFfin1BkzhIuDho2S8BsFD8aAz6o7pA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3f61a2-b7c8-4213-c526-08d8a174aa77
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 03:42:51.9526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJhri96/HY5l9r0NKa/7BpuZ9iD7SmLrmDAS8pfHMC3btLYGUVb2gX62FPOXvLQz2+JHM/efsDHPkEC+Q3xg/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2935
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608090177; bh=5bIU8tXYhVX/k4S1rUYD1QgXwt7tQCj9pVix1qIXIBA=;
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
        b=QKTBGdy/cJxCQz9jLseSh+fR6nJIUUVh7eE0QxaAXeTZMG4ykqSSHui+A0A/i0+k3
         HrRzEfzFy1T8jxAR0k9e+5HoONC5gfmLBydOqef/JkAdQmONT0jRFNRjO+1b0OrjHf
         PxGkwIdJY8L3Jw7Rr52sweADJbkrqHHpRaMh9+Bkd4Om1rg3X3bN21VBZ0HPrjzSAr
         f4uQDezZH9jb3hiaKE9nokJg7MwyexT5HEDAG/vUG0eBZ9nswvR5Qk+PvV0pCb6mTc
         +ERBWEulHKCL4SKTOTAjP4mVZ4GQUGKX4712gbHjpHgb2mXQin7I9kHlIoSkCiTRiO
         GR/HImcYtbGcg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 4:58 AM
>=20
> On Tue, 15 Dec 2020 01:03:46 -0800 Saeed Mahameed wrote:
> > + *	devlink_port_attrs_pci_sf_set - Set PCI SF port attributes
> > + *
> > + *	@devlink_port: devlink port
> > + *	@controller: associated controller number for the devlink port
> instance
> > + *	@pf: associated PF for the devlink port instance
> > + *	@sf: associated SF of a PF for the devlink port instance
> > + *	@external: indicates if the port is for an external controller
> > + */
> > +void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, =
u32
> controller,
> > +				   u16 pf, u32 sf, bool external) {
> > +	struct devlink_port_attrs *attrs =3D &devlink_port->attrs;
> > +	int ret;
> > +
> > +	if (WARN_ON(devlink_port->registered))
> > +		return;
> > +	ret =3D __devlink_port_attrs_set(devlink_port,
> DEVLINK_PORT_FLAVOUR_PCI_SF);
> > +	if (ret)
> > +		return;
> > +	attrs->pci_sf.controller =3D controller;
> > +	attrs->pci_sf.pf =3D pf;
> > +	attrs->pci_sf.sf =3D sf;
> > +	attrs->pci_sf.external =3D external;
> > +}
> > +EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
>=20
> So subfunctions don't have a VF id but they may have a controller?
>
Right. SF can be on external controller.
=20
> Can you tell us more about the use cases and deployment models you're
> intending to support? Let's not add attributes and info which will go unu=
sed.
>=20
External will be used the same way how it is used for PF and VF.

> How are SFs supposed to be used with SmartNICs? Are you assuming single
> domain of control?
No. it is not assumed. SF can be deployed from smartnic to external host.
A user has to pass appropriate controller number, pf number attributes duri=
ng creation time.

> It seems that the way the industry is moving the major
> use case for SmartNICs is bare metal.
>=20
> I always assumed nested eswitches when thinking about SmartNICs, what
> are you intending to do?
>
Mlx5 doesn't support nested eswitch. SF can be deployed on the external con=
troller PCI function.
But this interface neither limited nor enforcing nested or flat eswitch.
=20
> What are your plans for enabling this feature in user space project?
Do you mean K8s plugin or iproute2? Can you please tell us what user space =
project?
If iproute2, will send the iproute2 patchset like other patchset pointing t=
o kernel uapi headers..

