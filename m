Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8222DED17
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 05:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgLSEyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 23:54:33 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5883 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgLSEyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 23:54:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdd87600000>; Fri, 18 Dec 2020 20:53:52 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Dec
 2020 04:53:47 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.51) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Dec 2020 04:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgetsPeKs37ewZSvvdNP0bE5AZdRrvWhSlWCEgLfmFyKdcOXhvQjpLt56yIvXwb7C9Wn+CnkyOMxkxgGF0tYBgMVAJiyi8VPHfsvu3klEr73cTmqjCw4Em46zSn22fUvpnzcGbqe3vstIgbKMz+kKjd4qofFXOONBe+4U6j1gKDSscpkte7hgJDdibLLLYYMfHLCTsqXrc1I/otQsdYEd1caN3fDnNU9hgjsY6F+xfoj2tU+WyzHgSJcFMKrRLQXODqjhS2dcFgTVVi3VbhOTpCAIkNGMphWOmrsdLknEzNE7QMdgJzzL55agHFWWNzkDjbJo0L4N0VxDFdeM2CD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gflUobnR6AaOykzOiWiGu7pJOHtQ2Nc9+ksN4vMRGug=;
 b=cbuw9LRDbpE6QwDg5M/zHNbGj3Q28yr8TILVspk5o4s2eCO0sYAM93i1vT7Z4q6DbMUq6ZuGjLBYJQtPtUgcWFZgpLbXL8pHbwjxeyJ1i2tpLOUe0qveaK/Pos92Sh8KuNnuDFm5OvEd3S4IwcTdydo+/37GjKoGuIQzW7BLZ4j0qynqdMoiPS2/xUrtYk/wynOLvqyfu6ke5tcsRkZ8bCgM55GJN+qXzLEITudX8ZYYJKaSfWmAaRlyI1o67WQDnC2xL48guuy1zgGvYlD9JEsm8tHRTvha5az5GH5fV/6toFkj4cjWtXkXrfgSJ8oNw4cpTIYPE2mi2Hjaogej3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Sat, 19 Dec
 2020 04:53:46 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3676.029; Sat, 19 Dec 2020
 04:53:46 +0000
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
Thread-Index: AQHW0sFGdfLdaK71v0mpu6E47Gz62qn4432AgABL6kCAAT2JAIAAT0yggAKOlgCAAJKaMA==
Date:   Sat, 19 Dec 2020 04:53:45 +0000
Message-ID: <BY5PR12MB4322A0E514FD1B4FDCAB0735DCC20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
        <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322009AFF1E26F8BEF72C72DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201218115834.0f710e0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218115834.0f710e0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60fe9ca6-fe89-4175-3422-08d8a3da1138
x-ms-traffictypediagnostic: BY5PR12MB4243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB42431C3976049CD5E9CEFFC6DCC20@BY5PR12MB4243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ilh3EAFyt3cCVctNod79OntHgW6Do0MwJTDB2pM8i3ZvWNTW9BRwAxB1CIF5JEAjMNnIyESosa85D9UvtCCzqz24hRJMZk6ayqRFOX2LJ6Uh4/5i4CzmjlYj6CNf2vMThwp4DK0VyxuiKzJ1l5pGf6C1s7juLTq7vOqUZ3LYvROzbijDxUfoa4wMX13L/D3saoys1CaK0ot0Jee0t1hHAzsSzl4UVApod2qGDkunIdY+aXkDM2kYO5fsPlEKZarclK0OICB9wHEdcCucZT0RiKnSr1+r7EdCzt+KaRHs5XgldC0Tva46K0nFXUa6i6G/WkKJc4F+Ln4vRnb0Ws+P5BL6IXeHoK5I46BpmNxQzN3Jdkc3IK4zsv35LOMzUxsVR7AqG2fw2qk9dC0BJuKuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(316002)(66476007)(8676002)(66446008)(7416002)(4326008)(33656002)(7696005)(55016002)(76116006)(64756008)(6506007)(2906002)(71200400001)(8936002)(86362001)(66556008)(52536014)(55236004)(107886003)(186003)(5660300002)(54906003)(6916009)(66946007)(9686003)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?D76ul5cHFsUqLF4Ys8p9QtfzMfpFT4DBhAyz9A7WjX4UUJeBWBTVJS7eZtsN?=
 =?us-ascii?Q?ZK/rk30BAfuNVk3AAkjnZTjOPcFeoLySfaLiZ7ISDc2Cy0KE9Vk3i+CPf7Dr?=
 =?us-ascii?Q?tmpg8BBDZfXNtrXZKILTrE8k+zg41A88ASu/CcynOpr57Lg9NeXM5hg1CIew?=
 =?us-ascii?Q?g2eL8QaVmlmhbIk3FLa4f5121VOV2quw//lAKyOZIC/4SJFgB6XFmG7GB7aA?=
 =?us-ascii?Q?5lZdHOhjTXMj+FsreHZItRxnvzdKlgxPiFAgOzBbWrqD4NpRWN1PFl1SHEmW?=
 =?us-ascii?Q?9dAeIgAzcKk8CJQH9j/Setj7jINbGJi9XHkfvoyG1q4gujvjCNmJ4t5pqXUu?=
 =?us-ascii?Q?mMA6Jwnl9ziLcUqQ9attPWlwsIrkgO8jgn4sjOF/pjPR8SWznfexf4VybfAq?=
 =?us-ascii?Q?yqBV+ufvxn6AaQ4GVJl/GtdFb0ac4iuKUtFEGD1Ww39KyPvDh2hjbO9DDt8q?=
 =?us-ascii?Q?QFUEzBOE6UPW2MxaOhbqdATtw8Q9GgXllIVRNszJg6k6LWHjMtKtW/tKomep?=
 =?us-ascii?Q?4L4xZSqvWaNAa0Ww8bz35BxaovRgGPMtgfPNozZSDUMNfX/uLcFuOFOnbp/B?=
 =?us-ascii?Q?ypqIpoOpZPzaOWeXLVPk1PiMwCGStlmQlLUpo87oLWLMd2/qJDz+/CuR8OlP?=
 =?us-ascii?Q?Dpi9IBacz8YITUZwsJY+g53Ikw7MDGsxPVxpQTOFOO1yMQ2va5exhNUjlo5W?=
 =?us-ascii?Q?srDQooRNMlsanm58QFUz8veaN0gysh/G87fafz3NGSNKVP6LXv4dcvihopp3?=
 =?us-ascii?Q?bjMqxJ9gBdoKSuuCPD+t/joBOibWdOfrig5YG4sUEuJADfN8lXBJcCRT6knR?=
 =?us-ascii?Q?sof6ZRp0WhPYZqTKCTIbDjDr07FNfK14s0h0reVBf3FYJKG5VuHtzVFSjm+c?=
 =?us-ascii?Q?2gWt5uA21seMkmlxwo3rTTW3VAOvzprpb++9TIDSG+Sy2lY8rpW5RYNzemST?=
 =?us-ascii?Q?8r9OZyDWBK2RjBV4TxMM7c77tXUqhKh0LbUuvLJDzww=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fe9ca6-fe89-4175-3422-08d8a3da1138
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2020 04:53:45.7759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Re0ksYdZC5QaAUsBPQvJ8XnFSIKl8TKMa5KgGGlMtMRjjbW3HNLlrZ0Z5cxRbnrGpeu15f7t+vVxG4hR3iu8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608353632; bh=gflUobnR6AaOykzOiWiGu7pJOHtQ2Nc9+ksN4vMRGug=;
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
        b=p0silbzNKSbQI3xhu/dwg64PESFc+GP31Zv/w58mxJo1AGN1inMmslFIAVSLmUxWd
         sANTzLQYEV1kUuSMhJ0VwQs14NycEMco7JrjGSCxc8mPTCu51dqhOVZe1/eYvLkTXu
         CzW0FNMOA/rJ3d/ybihlTNSiin/9yKL+iFc2hyeZJ/BNXwMMIBSLL/cNNy0CNFUaT0
         nYRSDf+igl0N0qd7bbIrdKeWu9xAsOJ2uRmETZwJI+06p3yu9XNAN26kaGqvUyLVIf
         XwxpW8JPVZj+TXh9owKPuz+5QokJH2n/1QOhHPNWw8Htw9X6BpuwrvvaHMItzRCwWI
         XqZSQ4lPN1eSQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, December 19, 2020 1:29 AM
>=20
> On Thu, 17 Dec 2020 05:23:10 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Thursday, December 17, 2020 5:42 AM
> > >
> > > On Wed, 16 Dec 2020 05:19:15 +0000 Parav Pandit wrote:
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > > Sent: Wednesday, December 16, 2020 6:14 AM
> > > > >
> > > > > On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:
> > > > > > +static ssize_t sfnum_show(struct device *dev, struct
> > > > > > +device_attribute *attr, char *buf) {
> > > > > > +	struct auxiliary_device *adev =3D container_of(dev, struct
> > > > > auxiliary_device, dev);
> > > > > > +	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct
> > > > > > +mlx5_sf_dev, adev);
> > > > > > +
> > > > > > +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum); }
> > > > > > +static DEVICE_ATTR_RO(sfnum);
> > > > > > +
> > > > > > +static struct attribute *sf_device_attrs[] =3D {
> > > > > > +	&dev_attr_sfnum.attr,
> > > > > > +	NULL,
> > > > > > +};
> > > > > > +
> > > > > > +static const struct attribute_group sf_attr_group =3D {
> > > > > > +	.attrs =3D sf_device_attrs,
> > > > > > +};
> > > > > > +
> > > > > > +static const struct attribute_group *sf_attr_groups[2] =3D {
> > > > > > +	&sf_attr_group,
> > > > > > +	NULL
> > > > > > +};
> > > > >
> > > > > Why the sysfs attribute? Devlink should be able to report device
> > > > > name so there's no need for a tie in from the other end.
> > > > There isn't a need to enforce a devlink instance creation either,
> > >
> > > You mean there isn't a need for the SF to be spawned by devlink?
> > >
> > No. sorry for the confusion.
> > Let me list down the sequence and plumbing.
> > 1. Devlink instance having eswitch spawns the SF port (port add, flavou=
r =3D
> pcisf [..]).
> > 2. This SF is either for local or external controller. Just like today'=
s VF.
> > 3. When SF port is activated (port function set state), SF auxiliary de=
vice is
> spawned on the hosting PF.
> > 4. This SF auxiliary device when attached to mlx5_core driver it regist=
ers
> devlink instance (auxiliary/mlx5_core.sf.4).
> > 5. When netdev of SF dev is created, it register devlink port of virtua=
l
> flavour with link to its netdev.
> > /sys/class/net/<sf_netdev>/device points to the auxiliary device.
> > /sys/class/infiniband/<sf_rdma_dev>/device points to the auxiliary devi=
ce.
> >
> > 6. SF auxiliary device has the sysfs file read by systemd/udev to renam=
e
> netdev and rdma devices of SF.
>=20
> Why can't the SF ID match aux dev ID?=20
Auxiliary bus holds the SFs of multiple PFs.
SF ID can be same for SFs from multiple PFs. Encoding PCI address in SF aux=
iliary device name doesn't do good.
So SF ID attribute of device is more appropriate.

> You only register one aux dev per SF right?=20
Right.
> Or one for RDMA, one for netdev, etc?
>=20
These protocol/class specific auxiliary devices are on top of SF's auxiliar=
y devices which are only for matching service purpose.
I have covered this detail with actual example in diagram in documentation =
in patch15 under " Subfunction auxiliary device and class device hierarchy:=
:"
