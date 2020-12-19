Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F672DED11
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 05:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgLSEnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 23:43:46 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4686 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLSEnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 23:43:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdd84d90003>; Fri, 18 Dec 2020 20:43:05 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Dec
 2020 04:43:02 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.58) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Dec 2020 04:43:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFYQgCqlzn630xY9fsG4An+QkavVYyRv++x6Md4QbfuE8QxV7FDSBRl7xMvwtNxws7mk4QpbdaxpOlG2vNbdjYaYSNJNfDoyIS+KnnERGSdz9tbbZHrCW2KP4QTktHGThvN8mFcoc3VjCGB0lgosJiQsRneXM5L7VSxVBpDkjRmzc0ij/M4nONaIcuXYaOjHCJEcgi9EdYLwhCYazO8sDfTjrt+cLLAsLtEhmbKNgTRcfVsvh/NL9xD5oECJuWUPzFYrV0PZWjPwKoWJY4xYV+cPD5+CFQTYtA/Uc/Kb+XaJMSl22JEg6JjJNa7mO4iHACIOaLVL9YMFOwHo5Bzk2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1mpwr7P2g8IfiknGJ0YWSDMwS8owEqVYVQEDQYSG68=;
 b=Ja/Cf76k/+cZnMpAOocuiRPjukjNXal9LU9RGAFkx7CVVpxosVUH57A7joZEqCZdRuh+DMsy4NV1B4GZPitjhEAdYc4eyudcD+/qzNoM8KZR/SyiQH3byW35HuYA+LfUU4IjrXZHp7qj1YFU6ZOBEEkZ9bxf4MaA4vtlryEVJi0kLOXaMVJkpkwLLckeOeVZ0W9RdUrNJWp56n/SEmWyufpaoR9M1QVMRbidYWAzlVD4eRP0+gr7gT1q7QdTCaZeuhjm8g6slxsmCtlyJ7rHt30NygkLNdiVHrw8C0thdz8aDsMw+H1tMD8LhTtjV5cPxDUKCjq5vvJwIBAttwH36g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3542.namprd12.prod.outlook.com (2603:10b6:a03:135::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Sat, 19 Dec
 2020 04:43:00 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3676.029; Sat, 19 Dec 2020
 04:43:00 +0000
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
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
Subject: RE: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Topic: [net-next v5 03/15] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Index: AQHW0sFHdQ+yzn0pRUyP/4UDzcNU4Kn4zj8AgABFQ1CAAVYJgIAAT4SAgAKO3QCAAJSRMA==
Date:   Sat, 19 Dec 2020 04:43:00 +0000
Message-ID: <BY5PR12MB432234DF4437C0FACBB26277DCC20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-4-saeed@kernel.org>
        <20201215152740.0b3ed376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432268C16D118BC435C0EF5CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216155945.63f07c80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ecc117632ffa36ae374fb05ed4806af2d7d55576.camel@kernel.org>
 <20201218114812.28db7084@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218114812.28db7084@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd310388-aae4-4f84-3cb2-08d8a3d890a1
x-ms-traffictypediagnostic: BYAPR12MB3542:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB35428961DD8FA104C925538DDCC20@BYAPR12MB3542.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jd5gWznn9PyE0gPxlfTnoPGULaMkz5RkeoC6pxVEq8T2O89Fcyvj9MYNvKytnwRANtl6Ki6aLPXL9m3zryOXacLaeLBlhOTnC3ZYfaaROF2lVmd9zurbznf+cFNVcuso/ePWMz2Fk0FYH6R355oXgiOOpjoCMGR1Xiz5eP8R0DA24ST+SAFRppVVPrw23bTvwX5Dbb0YZORDp1slI2b1m76JzoZzpHROjYBhfFF5GB5AVASgapkbPS2+qjzCL/wk6ng020H9MlzzVynMgiwiogH45jCFJ+kktFCrszkKJXcqq4xFi4lRoNKAo9OFQpLo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(316002)(76116006)(86362001)(54906003)(66446008)(110136005)(186003)(4326008)(7416002)(7696005)(9686003)(66946007)(8936002)(4744005)(55236004)(71200400001)(107886003)(26005)(5660300002)(64756008)(66476007)(8676002)(33656002)(478600001)(55016002)(52536014)(66556008)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cBH/p/5+tzp2YsU2aHq9u//771f4qZLSnTzYBmukQdtwvkAe1Z28Mw0wqhZR?=
 =?us-ascii?Q?t28dRTHSBDw+pqhMVhlbnvBhVUOPihngdZThVtMVuaUuFhhCMrkbeErWCdWM?=
 =?us-ascii?Q?b4BtDObLUbf4W1JTiuv1HVJ20wiM1bGRZcdfa0cf6V7+bH+CQoy1PlS5FL24?=
 =?us-ascii?Q?owFUzNZuUytPWo2fypKDGOzboY0KsNwcT0W4CFiK6dqKv3la6fxTuSNRgXnr?=
 =?us-ascii?Q?XKdKxVn370UKwt047PUzwXxxKIQDCXi58gvGmPK5gfnEtzPrpJqRYVw2JD12?=
 =?us-ascii?Q?s8Euld/0FZqNhSXi1QDVv7HRfi190AuxXI8zAvftfWRRHxxCOX08xBkkuDTf?=
 =?us-ascii?Q?1LuP0bKJQoIcn5Pn+BaUNH+55wh0Fptmjr6BtBWj1H8Qx7ozrULb2D0CM7z2?=
 =?us-ascii?Q?ACp7q+zRxWX6Pzwuof1x1xX78cOKhiAjQjIFzUyZMENN+CO53Trbst0XgMAi?=
 =?us-ascii?Q?g+zRx5hGDlVgSmRsB0LLEFZTyocUF0c2o8ddv+PW17Nsh0e6ogoQH0OVamgE?=
 =?us-ascii?Q?9/HEUCsyUbfxrQ1GAAWGGFkLWQctfRzYytq1ZaapLWX7WgFzXiXNxsg5mQmv?=
 =?us-ascii?Q?4K0dNspP4DSSlXiM4j5FeyYuw0tOToBC33Y0QcWKvJFjR+WFPGMEqXORUUww?=
 =?us-ascii?Q?S6/11GcGb4xBIs7fTL+tLFVXc1FdMtOpSLhUrasy5+3gmzM6TFqEgu3eexlP?=
 =?us-ascii?Q?XW5pEjUduaPc0TrGbUI5J2vlFVNIhoL6kmgMaWYa6idf/HeS7AnuUpBha8AG?=
 =?us-ascii?Q?lNT32BOSzBWmdKsBx8TnkHUp9ndFtZ4Xnt4CSaA0nB0BXt+rtvUmhTOjn3jp?=
 =?us-ascii?Q?9W3XwRc9mPdl+Xj5KZC9cKwfQ1ONGG5UsAYZsnkKsFQgWfNS7U2BI7i8lXbs?=
 =?us-ascii?Q?ZWtz0zE8qq5t/W1/ZB3r5DID31eDRD2OFhayfai78EdxoOXxfZP9J3SSv/Ox?=
 =?us-ascii?Q?jPgj1rSLSgGSh+YCKUffZg8ZuKFMT6nbur+sJ0GxrnY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd310388-aae4-4f84-3cb2-08d8a3d890a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2020 04:43:00.6071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9D6AYH3It8HhinAVU1iSYykgk11k5YFPSPsiN+Y1kGkUkMoHJLG6ib23h6vxT9T1GfDqp3zRzNN+w6I5pO+hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3542
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608352985; bh=b1mpwr7P2g8IfiknGJ0YWSDMwS8owEqVYVQEDQYSG68=;
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
        b=cq3b4yX8cCmR0/7O1DQD523V7ilIGFfqKGrmzMHWCa5GcN07AE0PdxSuFgVmo4zXW
         RG0miWZDT2HoR4Dt2sTFfGgN8MxJqpWSTDPv17/urZg+vFl2UhBU1oVRd8W+9CbWkJ
         rfuyQR5zRedsvdO0XAMjDqvkydA22uyZVacRLLo/3qP2+m2BHLx1G9bPXDA5OH4zFP
         2oOv/vyJGUoDDgbSdZoRGFC18v1HJ06uRG1oWeVRGRxfPlgVZZuGM1a4liHfd+hdf3
         DtEal/IO/f5StrfqWXiddgf74gl2K2iDCKhItWWNnVWLsEAcMXgUUEc2z+tn2/LdQ8
         yYdIlytfrdmag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, December 19, 2020 1:18 AM
> So the SF is always created from the eswitch controller side?
> How does the host side look?
>
Host side creates the auxiliary device for the SF.

$ ls -l /sys/bus/auxiliary/devices/
mlx5_core.sf.4 -> ../../../devices/pci0000:00/0000:00:03.0/0000:06:00.0/mlx=
5_core.sf.4
=20
> I really think that for ease of merging this we should leave the remote
> controller out at the beginning - only allow local creation.
>=20
Alright. I will drop remote controller attribute of SF in this patchset.
