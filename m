Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713722DCBE0
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 06:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgLQFX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 00:23:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3541 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgLQFXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 00:23:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdaeb410001>; Wed, 16 Dec 2020 21:23:13 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Dec
 2020 05:23:12 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Dec 2020 05:23:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbHDaOjSfgJNVw1pzTQCXtomTCnxZP21gK+7B73TNqR41r5M3PMiFTV60F6wavJK2ftzbYu0AZ9E8Hg2p/PuEc5H8djee9atBthsC/X8jEnas/7UMKpuUzMVqd80VHset8p6LCByDcudhiZVPpn3fJH2D2gu61lGJ6F3JH6MRpQr4On38lKd3jSYJ1WEyVGVsNHElTxls+D6+QZRPX0Na1mJiolpKKAXezyox/mHoAr1b+bOh40t33MY9cK1rgEtQtaf4UZUiwS3+hgJYCRnlRaqLJA1Rz+3ldmB2sBrMgUDM0hR8IXX4VxehPnylHr7Q89LUr0uLEh/RY5euq0KEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4KD7h+x0LR2oDy4Dfm/2br0VM9m9wrS+2ojO4y7+CU=;
 b=LcaG+SrqITRQC3NXJAP366nVfpQI1CnlwLg7pPPt5SaXgl2WQ9cy1VlrHWeIYvNtoFXM4ta5iB0V3OvzI7cRQXBdYv0mQXamGQu6fAo/7F3KHlrEMPUX8ihBe/xYQYM9+p25tDL3JutA+gYbtomoE25KmHdb8cPlg1ZxxFyjPjZghSKvuvv0C3rf7M3GA6ScEAKg0gTXWPy03OJe/IjywJfeNwlyR4SsSjmgzB/nivUG+kLs3UxQcfsWjrA2/5utg+ACeST4m5BwS4YMLqnQehYJikJxw8SgCw8ruBpGlznIc/03j5KMyY9QKpi+Q1huENZLMVe+4BAnJaWXuloMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3667.namprd12.prod.outlook.com (2603:10b6:a03:1a2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 17 Dec
 2020 05:23:10 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Thu, 17 Dec 2020
 05:23:10 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Thread-Topic: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Thread-Index: AQHW0sFGdfLdaK71v0mpu6E47Gz62qn4432AgABL6kCAAT2JAIAAT0yg
Date:   Thu, 17 Dec 2020 05:23:10 +0000
Message-ID: <BY5PR12MB4322009AFF1E26F8BEF72C72DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
        <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8595442a-63f4-4dbd-8e5f-08d8a24bd852
x-ms-traffictypediagnostic: BY5PR12MB3667:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB366729AC0E310BE5578C68BBDCC40@BY5PR12MB3667.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDx5xpA2tIhUCUNUX4m1c2xWHLk35c1Z9QqdQLnx1ROvxsjMBWqExqmpaf133qyx6EHzLFmxmGzOqLw+wM5VsnrKOduxlSyeZOxm/5N+z0QPCmPLF3Do2VNALe6YPDs49W6aKziRZ47jcnW6wfuoi4nWgZaLuI7K7V5tvVl8/WZEZJdZWeqxQd/HFtqYMBv0p22CYtVcEfUj+jtuoJ388TlPNLXtJ4ehpLzaa3B6ON0kgW9kqd6L+H+DmrtXKy2cznyFEVKJlf8DVvbMhbZwlVdLIGrmtRwHtL25iLGP75Mvns7TEYMq1rHwFnlSqPaXUclJTp2g5XB1uNgmKFwSYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(86362001)(9686003)(55236004)(83380400001)(316002)(6916009)(76116006)(52536014)(4326008)(5660300002)(66946007)(7416002)(2906002)(54906003)(26005)(8676002)(478600001)(55016002)(186003)(8936002)(107886003)(71200400001)(66446008)(64756008)(6506007)(33656002)(66476007)(7696005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/3HYkzWbJvDeIVgRUiHbWBb1NdtPS4Xq8YH/lD4D9afhXabrVE4hd3uDwpYx?=
 =?us-ascii?Q?KcqtwMrCFsqBhKJtcYZHlmUY9ewEQmeCzrDW5qlUD+3ZauY9Uw9R3O1oM73i?=
 =?us-ascii?Q?13nOlbqs2Qqk5D7Gj4PrsgoL1S+R1f9RmriXlzANCzyVS92JAK8vbteypATn?=
 =?us-ascii?Q?bkNMTYwXECC+NWNnDy5AmOz87l895h2Op1TYH9DLVkz3cpAbXp90S7wlHsfw?=
 =?us-ascii?Q?QLV4MznZRj2ai+M3B66U4NyUpdGfpovvGyPvaTwK6nC36Blg/6hCvsw+A/YX?=
 =?us-ascii?Q?L+/kEh0gTvPVzHuHmGhtZKll7Ve9olH9SnX+/D5UlhG03EofMWgzrxHwE8Xw?=
 =?us-ascii?Q?OLwcea9SlUP6ITpZoS29vNRAbArHJAmaADEkjESV8j89Ciy9t+WsyGepORBH?=
 =?us-ascii?Q?L6nIv+uGAjPe1xU7GnPFuaWE8LH58nFj6sPYKoqhjxLe8aGxmfkZWXQUR3ps?=
 =?us-ascii?Q?/Ufc9HE+gKIGaUyH8vlMj0nUvyLHqYqT6YedGKbtxQs+eCDepImgoIx/zmxC?=
 =?us-ascii?Q?a+ZVifwPgzlBXtHGZ49GLYg+nMJU5S6DD2/9EtKVxkvyA9uIVPdcYEow00i3?=
 =?us-ascii?Q?ajWBLM1AO/jtmkHSsByYlKRlA6w9Azgd5aNpEo13TEzQ5EAuOassMqbAbXDJ?=
 =?us-ascii?Q?4FdJpbgkkxQCcv3HK22JC+mXBwycST46tUO517NSCLv4t5H4lcpw3D4b/uP2?=
 =?us-ascii?Q?eOHUtzCywrzriVGbFvSgLbZ5sJnSw2RJISskhGW64xhdxquiq5k5+gkDYKZy?=
 =?us-ascii?Q?mhiJdOpR679rGAh8ZeRn2kZsNdlYqBQ1+lJRSlrrtgX6JcUk8vNoHZ4qb9x5?=
 =?us-ascii?Q?QRFk1dh7HK2w+6KEqV364lGEh2KzFm7t5TgTlU2Qq8SZoJm0FuzDr3TqrvQe?=
 =?us-ascii?Q?J0LWCwVcHHM8icM1TIXh9ZISoAiR95M4nfAXCOQ4MmNYiUuM6KK/mbRL2Tph?=
 =?us-ascii?Q?ayCfAe70khxdJb0UOb7zY6fSPf44L9O+Ohq0oj7zjK0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8595442a-63f4-4dbd-8e5f-08d8a24bd852
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 05:23:10.6360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/ssSjvRz2C4TQJlIWNV/SFg9O8uSEgbZVoIi32IknSvaep2gZtCU13mQ0f+25G3JZ8qPI3acEt/h4LO//R8pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3667
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608182593; bh=h4KD7h+x0LR2oDy4Dfm/2br0VM9m9wrS+2ojO4y7+CU=;
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
        b=oegiVbUEt5b3u5FwjcNMjwGcWHkfHAc+/mIhNgb+2B0PcXm6jP45LzfG84O/6Ykpw
         V/gBxYoOyuSNiEnruicHRC+3aNZXv2DGvr6VT1KUKRfJVXYI0MYqkpUFZKc98jPLNi
         v2Nd7+t6pBe6tDjycPm6jup5V2L8CzjWXs+elTPN78JoOuGIB2a2dZEgqQehbaMBIn
         Mo3XyGMljLyL6cTV0fbBta68nn8q4UJD7+zXIxCcgn7Y+j5aZ2kIb5+ixUl9GjVyQz
         elp1tHwfWIWkgRXASO90IGpCinNiFz93mK9IAXxTBvamYZo05SMYd6IeXi6QdixgQO
         9iwWbyIPGshcw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 17, 2020 5:42 AM
>=20
> On Wed, 16 Dec 2020 05:19:15 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Wednesday, December 16, 2020 6:14 AM
> > >
> > > On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:
> > > > +static ssize_t sfnum_show(struct device *dev, struct
> > > > +device_attribute *attr, char *buf) {
> > > > +	struct auxiliary_device *adev =3D container_of(dev, struct
> > > auxiliary_device, dev);
> > > > +	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct
> > > > +mlx5_sf_dev, adev);
> > > > +
> > > > +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum); }
> > > > +static DEVICE_ATTR_RO(sfnum);
> > > > +
> > > > +static struct attribute *sf_device_attrs[] =3D {
> > > > +	&dev_attr_sfnum.attr,
> > > > +	NULL,
> > > > +};
> > > > +
> > > > +static const struct attribute_group sf_attr_group =3D {
> > > > +	.attrs =3D sf_device_attrs,
> > > > +};
> > > > +
> > > > +static const struct attribute_group *sf_attr_groups[2] =3D {
> > > > +	&sf_attr_group,
> > > > +	NULL
> > > > +};
> > >
> > > Why the sysfs attribute? Devlink should be able to report device
> > > name so there's no need for a tie in from the other end.
> > There isn't a need to enforce a devlink instance creation either,
>=20
> You mean there isn't a need for the SF to be spawned by devlink?
>
No. sorry for the confusion.
Let me list down the sequence and plumbing.
1. Devlink instance having eswitch spawns the SF port (port add, flavour =
=3D pcisf [..]).
2. This SF is either for local or external controller. Just like today's VF=
.
3. When SF port is activated (port function set state), SF auxiliary device=
 is spawned on the hosting PF.
4. This SF auxiliary device when attached to mlx5_core driver it registers =
devlink instance (auxiliary/mlx5_core.sf.4).
5. When netdev of SF dev is created, it register devlink port of virtual fl=
avour with link to its netdev.
/sys/class/net/<sf_netdev>/device points to the auxiliary device.
/sys/class/infiniband/<sf_rdma_dev>/device points to the auxiliary device.

6. SF auxiliary device has the sysfs file read by systemd/udev to rename ne=
tdev and rdma devices of SF.

Steps 4,5,6 are equivalent to an existing VF.
