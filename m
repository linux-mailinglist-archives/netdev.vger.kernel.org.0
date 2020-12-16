Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85892DBA5F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgLPFUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:20:03 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:18242 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgLPFUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 00:20:03 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd998d90000>; Wed, 16 Dec 2020 13:19:21 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:19:18 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:19:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNqnZJGmcEyTO/9vFa0V/jgsOuiq9M2COsvN514aUJGpndXVCskNjOuKfWvVq2bRUKqD3zWdIwyeLuoKbbYgnws18hdo5hnu1artxjR9b5BWD4GW90IwT/gWgLE7gEnnj1dQqgvWA2IzKYC46oaw5ZB63zHVlVfmmuV8Q+H0oV4cwtgCVVgsn8Nv7v00gxMjH9tWzH9lRzaTMHCKt3OVokkjy09z7o1EPgnejoA3u56OQ3CQMqsLMFIkgzFKloltQhlnlKBwkNqCApIwmnbJgQOZk33a/PxTxW1rtLD0XAU61kxSI6zCWfUJUBE2k1YcmwFn/I0ckwcZpXeguNmg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTJmK0A8DVxBsuVVc+jU+LB9/uBd17aN0pTUoFzf2zI=;
 b=ZSBNFQssmY19rrkB8LN2Q4A78yCEFzcVBzHLH4sH3klyVcumDCC/KTBeb1c5+ohxQWvHbr6y+97S3YU2rYTlp3OAV2BHVL/75KRr1e5a3nYtkYRuuxgnqaFM+dPZ+EPrjCYh11bCHSG/ztUCe5ZJ8P02cfWcc4XPMubgPIakA4PwrdAnOYfuhQFfjIRlJTcBP87QZxt5CtrrJqwtuVwJnvQj8uP/jMbYSIVO7diIbjEllxnj+52AYSUG1+64tkJzfa/Kwk1ayK/2KkQPvTat3dVHXTW0Ca/i1jXN4M1/C1/XK8tB++/C7/ZuhljseGB/6iVDu8zvLpJdAANkCVL2ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4951.namprd12.prod.outlook.com (2603:10b6:a03:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Wed, 16 Dec
 2020 05:19:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:19:15 +0000
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
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Thread-Topic: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Thread-Index: AQHW0sFGdfLdaK71v0mpu6E47Gz62qn4432AgABL6kA=
Date:   Wed, 16 Dec 2020 05:19:15 +0000
Message-ID: <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
 <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0baee4dd-3cd3-4581-675e-08d8a1822171
x-ms-traffictypediagnostic: BY5PR12MB4951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB495182326FC9F671EC7F0B44DCC50@BY5PR12MB4951.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xsKJofA4fse7cXk4mAWMuzkoCqHG+axG9IyJr0htX2iU1n+yaGhxY7q72XbVxkTv0P596QwPbAdI7ztw7hpYuD28iX/apfw99SfExlEoc6Ds4mVHLbPdvmI6uA4IqJhkO6QnOLpapD9gfJoaoZRhfIAJsQHm9edVv1XQRsGXnqUCSd75a/MMDk/jygalruQuzA7vWgJCRcpWrbY7dNn3IlQpeDizhhBkem/+WFXAJYhnPyXPrXSyIj3N9jsBoVFQ0Xa/2DcmzClBhZO5YJX2z06dqAreZSIw6xyUx5Qk8EPq+35OTZce42EUQDVo/3dv4/ykWuBSByoZ0ZPOP7UReA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(366004)(376002)(66476007)(55236004)(76116006)(478600001)(7416002)(4326008)(186003)(110136005)(55016002)(64756008)(107886003)(66556008)(2906002)(316002)(66446008)(71200400001)(5660300002)(86362001)(9686003)(52536014)(7696005)(33656002)(54906003)(66946007)(26005)(8676002)(6506007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uNgcQ/5ZP97vMbhe7CGiet75Jnm0+6PPDsu6bstNZrVE3G8M85Qe5wt4A28y?=
 =?us-ascii?Q?HQzqw0vuWSZ6nsuCiL3VnyN8jQU8MPm8P4wnXjbwcyaFfSaaTPPcnRp2zDXT?=
 =?us-ascii?Q?DzUFJ05CuuanUdOpdl3bXU/TzAROmAKwiZZwNUM58I7+JPPABhzbDtIGvkca?=
 =?us-ascii?Q?FHRJbVUfhYyIKa3Y2iq29ynKqCENgqEh4O6uipbPsXJikPfZPeHfkf0aUApv?=
 =?us-ascii?Q?WFUzMlWrfFs3/cw1MucI6LFdTKXnQ47flFn0rHvNNalo3LOPjhqIw9eZ4JkA?=
 =?us-ascii?Q?4WQ4mqUSg6N5FxevG5GfVEiyxszXDImbt7qxMWrC64XzYijoKIuLaBxGR5wS?=
 =?us-ascii?Q?3V5keHlHIOaelcKvF6vp+XLzaExqIHuwSxAgoXGQD9yvcMr4W3a0aujTbDan?=
 =?us-ascii?Q?xiYD65mdlcf5LuA5JGhGpWBaS3/XH/ya+TC9D7lIAuJfwblkZ677VK6RbvLC?=
 =?us-ascii?Q?4IBWerlctoALTrOkCoX0/K/rqe5G0Rv+/cxj0QMExii3gXxNozTB7HIEwTPx?=
 =?us-ascii?Q?fhUqZPU4UiBOsKe77MW9qKKMUwSwuSuG+Uti+ppdcGHhdsQUt9mrhc43ms+Z?=
 =?us-ascii?Q?eP0WLna3cGWvjA7KSujFAdZhmzeMmlOdv+kyFTqcKIwzHZLbYSJuIyKgRnLh?=
 =?us-ascii?Q?ZIIaroD7mKIPxlr1sQiY7nalqlaFAyX6EP+cSybLBF12Ja5/qT5UTNMibpu7?=
 =?us-ascii?Q?dXQ2wDcQ6XJQQlwj4ZUqYUlwxpgUajVEe84t4ASD7+Rn0VLL6dXG8NB9er1W?=
 =?us-ascii?Q?+dSAbvgjLhlroeFctouvlhk7JioYpFHd0a9XJ33p4jp+uAFagKXCmdG753Rw?=
 =?us-ascii?Q?47HwHjK/dacCssxLYmv72xLziM95cnw468EMmOypnA8mmd7l8xPLsxZLvk/N?=
 =?us-ascii?Q?+b+CmuCk3e9hHwiZ1XE5jfn7MvtabOdDYRMJdpjSq0DpF2aOKNpOX5KhwTI+?=
 =?us-ascii?Q?gk2H8NUJvf/+8NBB/0gB2aRe6rLHwv+27QG8jsL9RvI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baee4dd-3cd3-4581-675e-08d8a1822171
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:19:15.0491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npZbV/I4avHxBJr8Oq9WWB5aYldCs1Ak23LAjy0Rz2tu5We8V6WIUP/dSHS2V6slj2673zTCAyrlhLGoIydqFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4951
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608095961; bh=jTJmK0A8DVxBsuVVc+jU+LB9/uBd17aN0pTUoFzf2zI=;
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
        b=E7biKZBhOwFnW1vPM5L7wllKp641Pv060/Pp/E1P3PivhrUfdezOrppcpfDnMw+cm
         Ai0ccsy+AuThkkAcbXxYTnKPG2KCEjlY0Mcs36XTGdzSNKVJOmQtXwWnLyLagPvw+u
         34ezLqUHkJw0sMWFv758UcwKk9Q0WeLB9rSeeLvdbKNxoq8KLJdkaSlylIIZzRQDQX
         wYM1EhTNwyHzfeykPl0f+QsJeIzPDCqF9fxtTNZ3aZV+NwafqjmEKvOC3nHx7qJ/Z6
         8JqdUATHo6qiX0GlkQmk3BU8YXoCAAUGKKNBqAhla0PIMZoew5Y7VOwSPhw4ULNZT7
         zq7c2IvL/Ip8A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:14 AM
>=20
> On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:
> > +static ssize_t sfnum_show(struct device *dev, struct device_attribute
> > +*attr, char *buf) {
> > +	struct auxiliary_device *adev =3D container_of(dev, struct
> auxiliary_device, dev);
> > +	struct mlx5_sf_dev *sf_dev =3D container_of(adev, struct mlx5_sf_dev,
> > +adev);
> > +
> > +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum); } static
> > +DEVICE_ATTR_RO(sfnum);
> > +
> > +static struct attribute *sf_device_attrs[] =3D {
> > +	&dev_attr_sfnum.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group sf_attr_group =3D {
> > +	.attrs =3D sf_device_attrs,
> > +};
> > +
> > +static const struct attribute_group *sf_attr_groups[2] =3D {
> > +	&sf_attr_group,
> > +	NULL
> > +};
>=20
> Why the sysfs attribute? Devlink should be able to report device name so
> there's no need for a tie in from the other end.
There isn't a need to enforce a devlink instance creation either, those mlx=
5 driver does it.
systemd/udev looks after the sysfs attributes, so its parent device, simila=
r to how phys_port_name etc looked for representor side.
