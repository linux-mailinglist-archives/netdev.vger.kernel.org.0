Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF52D920C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438313AbgLND0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:26:47 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:58650 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgLND0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 22:26:40 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd6db450000>; Mon, 14 Dec 2020 11:25:57 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Dec
 2020 03:25:55 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Dec 2020 03:25:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKDnTjLsMR7Ccuoi04qs5pyQmgwbeCdmsgQmtIjiXK8ywBZ+uvOyCQyP720jJZNXsOlSPk64mvon/FFfOaXIywDbbWSxh1O1VHojMyK9lEcwrZelItO+KcD17fO71f6vEILoUdSDrZUc1dhd8zuP79GkwaQ2KDVe1+Ej99Jwr3aYHT3j8UoBeZIV0ZEMCBnNJfph/rpyq4HqdWE5LHKLYUf0VyY1e2IZfew2p8IWYFB0IDGPFsLD6mM/pHuyWv37OykF227x47MBTd5FHLL4SGERwla9MXYv4fF1Q5657FgMZMd74ZfIYQE+/j83zP9UmhPEcOajiJNqDYHkjHk+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMDSG9PLqniBeIS7ZdvOBhAVW/80kFIJO178OWRRZZs=;
 b=Z+0Xky/GjcwyPdZtzvXWf9ZeklHw5UYCnK2S3Yf85QrwHNcmMRybepKAJwMv/sCCm8D6Q3CTIvdPgCz3b8pMD7E+U5O8TT+UxKEhxOLP1D9GrZxerCyDs93kOPTCZ5rG5cX/zn0a8L4YcDyiYeoGyYAOWkwLSsRGx80WyPxZgxnPIKZfXN1tUDZCDp5S7YdVzSDUrRGjm9isHL8J2FIpRM2Ftd/b0DatJ6y6tiQ9xCmKe0F8/d+npFgybBXhYpsu8tc19Uhgx4OzfE1ReQhaS991ggL4nPfs28U0xKDA9z56PTfy+bRT1A5Vs9mm+4LY0xKHEXR2UpGhpqCkBx4V3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3624.namprd12.prod.outlook.com (2603:10b6:a03:aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 03:25:52 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.032; Mon, 14 Dec 2020
 03:25:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [net-next v3 00/14] Add mlx5 subfunction support
Thread-Topic: [net-next v3 00/14] Add mlx5 subfunction support
Thread-Index: AQHW0E4pzMUDm5pMvECcoQphKnYAq6nz6TMAgAEHnQCAAP6fsA==
Date:   Mon, 14 Dec 2020 03:25:52 +0000
Message-ID: <BY5PR12MB43221E39769969BFD554BAADDCC70@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201212061225.617337-1-saeed@kernel.org>
 <20201212122518.1c09eefe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201213120848.GB5005@unreal>
In-Reply-To: <20201213120848.GB5005@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 286d42a7-f8ae-40d7-f582-08d89fdff5d3
x-ms-traffictypediagnostic: BYAPR12MB3624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3624A67C3861B12C0B1D3628DCC70@BYAPR12MB3624.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/bP8yIwky8cHQeDjS1LGh7K7XK7vptKzILHN1+9U257lV4cp1B/8ZbQPbVpv/5ShH4luk7rmL8ZFvaD8QVIuHlUDvrMvrL06QBwkgSbFkumCs7LsAHleXUInMG1KYbh2+PIylbAnK0/ZY7RTZYFPdpRijnlo+2lcTZU9CyY4/OiIjabZPXbjnXbyYcOZaSyM95QrLaSaUiHAvD9DTa68jNYxzZ5E/LMr1bgINnLxsD2TSH2rsMgpJ62WAkSHKpWIOJ32xyCv54jbcWDeeKbzI/MLO8qkaw4/c5jKtGGsNx/AiU1gxIba+9imdQaORs1LBahUkezBizROxrwrone+V6Y5hZ8r7H8tq2Y/n2fN+RmhT5LtcBgZsLH+N73UJXpkSxTdPJPRcFjcp4D1TOdrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(66446008)(83380400001)(5660300002)(64756008)(66556008)(86362001)(33656002)(966005)(66946007)(76116006)(110136005)(508600001)(54906003)(71200400001)(66476007)(52536014)(9686003)(7416002)(55016002)(8936002)(186003)(4326008)(8676002)(55236004)(6506007)(26005)(7696005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hUSCGHgdRYwS7E00kuoc7ilwnQaeYGknYGj1Fk/C9A+6fx8/3QuyvnqDaPT/?=
 =?us-ascii?Q?+980NWcCFBOoJTijyJ8iIdRCtAPPeJt+OMzt+oOKaVaEhHXwXwDstLl7nq9Q?=
 =?us-ascii?Q?xE2OMjjP1LI/71OmCS85/fYhx8VYUqs17rJcWCz+4Ysu7yt8eb+hCwyjEyCA?=
 =?us-ascii?Q?B2Xc6MfqlG8/4boPSTfsbDjz66sOS8GOqaj8iYM92+5IS1kUcnBNuJH5GJkv?=
 =?us-ascii?Q?ZPsNNCzSt+DTzsEbIXC4/dQugK4XYfIcse1II+EiiwKnq91zUmQVzja606sS?=
 =?us-ascii?Q?81jVkLeBQO3XRcEs0+AeI7qVBS+1tJusnaYFt37JJ9iALzs7w6esXobfBwAp?=
 =?us-ascii?Q?qKlNncbZZ52nN6tPh2lYZkHsZlyImujHJ3oB5G2dLVz7YPb4e/SjMIlGHWmn?=
 =?us-ascii?Q?Ai2izptxl9M/tG79mdJgVx3L/xMk0oYrVcVoqby7UUhp8I8jMBKRZda8JpuA?=
 =?us-ascii?Q?fja1T4rBqZP2sxUtXPCNCMyq2BQzOhi2SRNIn4b27KZcHYlpwplkoL4LOBva?=
 =?us-ascii?Q?IGIHwIrK5vEL+uISfHC/gKxOGnVVsxVsBgAhXlo0XsrlqoHWXbW8hJOw40BE?=
 =?us-ascii?Q?0DN9j6FmXWg8kTKB361ngXKvvUVMp47BqpiTS92bVrVllHg8hTF1Z0AuHkGv?=
 =?us-ascii?Q?w8AZh/BxUVAtUJnvyMjhgO3hKHvtmEYENok5CmXRHdo3bTGDFF2J4crOS6EB?=
 =?us-ascii?Q?LK72dVODuCKrLv/Q1xNx+RhkoCSdQ9JamRfv2uUgBIWkHx4X3FatWCqMrVOq?=
 =?us-ascii?Q?+f/6mt/fr0he56llxS667rp1and9tV6QOuNOEQW7M1pvnm7nT8EseLa1KJ0Z?=
 =?us-ascii?Q?42aMtn3SC5/2nCFmX4ZDSqc/wsTgerIbqos0K8QKgSe9Iw7JY8E8fdfygutN?=
 =?us-ascii?Q?6KiQoGYXMNNHVlJ2K37jyk9kSYVaJcho91B+shvDg41DZguitDvmvK+y+dGX?=
 =?us-ascii?Q?nK866sJWjoKHidNjKAMnN0D0H2FdDg4gFgx4svKI8t8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 286d42a7-f8ae-40d7-f582-08d89fdff5d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 03:25:52.2532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/ROblzzuKRtUEWpGRGT1UOiXjFPye0gOIdGeQpCjlZ6fTp7qZmzx+uKSfp32BMJndn/rog4zKmKmzDj60QLGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3624
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607916357; bh=cMDSG9PLqniBeIS7ZdvOBhAVW/80kFIJO178OWRRZZs=;
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
        b=ReJyeCRNfuwbi4JNu9GE5wszdbf0tlDTnnkJ1YcTRZJmVYVdhsp+vQZ1Zzz+JDiJJ
         QNN5HFYB3rJ4p/T7L9sFgvoFj7/GNJOrQ3KC+Ca1AFuP5iT51DIRj+ynDuHLRBjep1
         4DRtbAx9jGewXMMyWN2vp3wLaLudetADE4k1+6SYUkiFVOSYGmLSCZhpgTjwcHRwaq
         f0qp9PP45qBg52qhexDFh8M66RJ0rdJF/dkkv+9SQS68kJk6AxJo5sbhSghybNjP+Q
         K/4yqb/tydK/f8yZo/ugBxWby6Mnefj0qmCdMvqg8n5GOHv76NKYsZuaFI1U7PQXMn
         TMV8sARSdACLg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Leon Romanovsky <leonro@nvidia.com>
> Sent: Sunday, December 13, 2020 5:39 PM
>=20
> On Sat, Dec 12, 2020 at 12:25:18PM -0800, Jakub Kicinski wrote:
> > On Fri, 11 Dec 2020 22:12:11 -0800 Saeed Mahameed wrote:
> > > Hi Dave, Jakub, Jason,
> > >
> > > This series form Parav was the theme of this mlx5 release cycle,
> > > we've been waiting anxiously for the auxbus infrastructure to make
> > > it into the kernel, and now as the auxbus is in and all the stars
> > > are aligned, I can finally submit this V2 of the devlink and mlx5
> subfunction support.
> > >
> > > Subfunctions came to solve the scaling issue of virtualization and
> > > switchdev environments, where SRIOV failed to deliver and users ran
> > > out of VFs very quickly as SRIOV demands huge amount of physical
> > > resources in both of the servers and the NIC.
> > >
> > > Subfunction provide the same functionality as SRIOV but in a very
> > > lightweight manner, please see the thorough and detailed
> > > documentation from Parav below, in the commit messages and the
> > > Networking documentation patches at the end of this series.
> > >
> > > Sending V2/V3 as a continuation to V1 that was sent Last month [0],
> > > [0]
> > > https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidi
> > > a.com/
> >
> > This adds more and more instances of the 32 bit build warning.
> >
> > The warning was also reported separately on netdev after the recent
> > mlx5-next pull.
> >
> > Please address that first (or did you already do and I missed it
> > somehow?)
>=20
> Hi Jakub,
>=20
> I posted a fix from Parav,
> https://lore.kernel.org/netdev/20201213120641.216032-1-
> leon@kernel.org/T/#u
>=20
> Thanks

Hi Jakub,
This patchset is not added the original warning. Warning got added due to a=
 commit [1].
Its not related to subfunction.
It will be fixed regardless of this patchset as posted in [2].

[1] 2a2970891647 ("net/mlx5: Add sample offload hardware bits and structure=
s")
[2] https://lore.kernel.org/netdev/20201213123620.GC5005@unreal/
