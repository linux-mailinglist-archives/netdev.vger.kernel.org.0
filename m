Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACC22DBAA2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLPFcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:32:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16246 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgLPFcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 00:32:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd99ba70004>; Tue, 15 Dec 2020 21:31:19 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:31:17 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:31:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcBN8AmtMPF3EbkgMxX8Vuu9db0nqyFE29PAuZM8knsJJD0aOKfC/qLeyvRL9zRRJztpwdcZlLckb6yYwTeJeHnyH6782qZS01zHGSlpqMYuNkNEEA+rYbqsBP2DnbDgNAB2wVqNKQn2d8kn/BQDfzJB51qcNp9P7tPWADssJ7iBRhyS7Vz062ssRTy6H0fomL1wqDrn3Wcl3OZRtUZJyZwLr/WlgTGuuHGdpGJtmIGAHMDdqCReJXixoMSKSKfyloVhzRHbcBQtbf4hxcppHxlfbE5Ybslvqn6eBrtyIkLywaa27k1dYLNvajFDW64a+XK7rSThvJze3sbzoQ++BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/24++BJMrCKkZMRuIarcQnlytm3uSoYBGEkKZnm+SMI=;
 b=cE8rSVYRoLE01HNSzbYLueG7Ugbai+m4kdIy4JpiFtks5NXQvMpGTsjAcTJlXY3WVnsLJuAWuTUJCIYJk6CsMyaHgWiRDqVtfO7MB5P17JKpy6IKgL32lJSMC4XCR975RPdgSQZkmpjj9yEZsBVjAjFTCocWMLBRcp4giSfujoKaP6JgULFcjW5GmrNAVLBnLFuA/oP8LU3dqN9sQWjZBc/c+EYJclTeH057cCoQp5l9bV0a6J4WvOH+LM/cezV1hcNS3V4olGlaQ1JV7pfkct0Vd+cG44MJZXM6eQBIp7zbry2PHID9EhJoh83Op6sskzcme2x1oJLDVgu5sYJ7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3029.namprd12.prod.outlook.com (2603:10b6:a03:ab::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Wed, 16 Dec
 2020 05:31:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:31:15 +0000
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
Subject: RE: [net-next v5 11/15] net/mlx5: SF, Add port add delete
 functionality
Thread-Topic: [net-next v5 11/15] net/mlx5: SF, Add port add delete
 functionality
Thread-Index: AQHW0sFrtt6hjeokEESOEAfdyRxGJ6n45ZKAgABNdtA=
Date:   Wed, 16 Dec 2020 05:31:15 +0000
Message-ID: <BY5PR12MB4322526F90E73A5EB388CA9DDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-12-saeed@kernel.org>
 <20201215165109.27906764@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215165109.27906764@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98a159ce-6f4e-48d0-1b87-08d8a183cf03
x-ms-traffictypediagnostic: BYAPR12MB3029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB30293372BEA178EAC4DD28C5DCC50@BYAPR12MB3029.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tyKWkDim5M7P9rVL2hS8rkTRbT97nbivV/wnakSZ09k2pOJqUjfwGAhB5pStB9xb7BSxSDLCFCHuXmSR8BH6PtJRkjP8ie61a5GgwcFzGvsuF/kpAlz91FRWyaL7sQZoxFoOhgEWiao0U5EOlW/77iUO63obKIE4G4IRcGW1ZTUdHgiBxi4k21RzcuKrJJ+0m4ZQqLTyBdQMxbyVDwIJBebXw991K0CEb6vd4NoDzpS6OpmjLvKJvMAagytRtncpUsEHpHuT0QbtIwJIdsdF2S1pKHvaSJkDNbU4pMREwDT1YE39VXbD48bzS0PEYpg8cZ6CfYwOmbRHrTb7VuQYlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39850400004)(376002)(66446008)(55236004)(66946007)(64756008)(478600001)(26005)(83380400001)(66556008)(55016002)(7696005)(71200400001)(8936002)(4326008)(8676002)(33656002)(5660300002)(107886003)(52536014)(186003)(86362001)(9686003)(76116006)(316002)(54906003)(7416002)(2906002)(110136005)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4bxUZVq9zFzOnaJk71KS3Ns5Uk2VuvfqxEeR9WRBTfyADyGp6HqsNym581jY?=
 =?us-ascii?Q?lVdTvxNCE+ahSoLulC41rvetnMIy+1rMCGjFdCey0NBFnULLBCAgN2ebNCdl?=
 =?us-ascii?Q?8WCWmWUHEo8/g3YrNslEhNsmYy2MYvI8e1PRqGjcoWPkBmWD3E18sUOJbHj5?=
 =?us-ascii?Q?AVAh6233bl9DaidViALfEqtBslRg78mK6iPSknWo4W61YeLN0IekS/yeIEot?=
 =?us-ascii?Q?uZpb1v4G19EUdY4EzO2/GLG62Lt0J8exBvYMrAViYFdLWVTl7suE1T5Uisg9?=
 =?us-ascii?Q?lcXdI1bFX5B20XTjso6FWRrmxo5iJ/y0WS3VKnUFffBITAaf5+ovsarX4pxH?=
 =?us-ascii?Q?9P8XnRGHVc4Ax4hz3X+SkfqCYzYfpInLjbkponDDIFWmAm48rDh9cic6QRAx?=
 =?us-ascii?Q?xgV8JDbFyo8r0kwa66Og7HGfoF5jlJdrcxjWHAKVfIb0vwjXCvVccsOmtBTV?=
 =?us-ascii?Q?OoCN7daTDzh9bOwiXHnKYC87L7eWfF8pkKU2Zc8FCOd9UdiEw86ToVBVvHqg?=
 =?us-ascii?Q?zGW/HWOUPQ7/pcLBx8u28eVUZ8GVUBCL7KqZqzoWBvwYB9Liad+dURsTc57g?=
 =?us-ascii?Q?eTK62KwtMFw6QuSAs/WYN0doz79N8UrvlRi+zO8enIxrzEExpaUuP5rZ9jlg?=
 =?us-ascii?Q?yqYt7DRWs8EJ5zQ4fZygZ0dfXUrVZs+NVH8znkjfu/THcKzrAG8qYU+ZntbJ?=
 =?us-ascii?Q?rXiQZtC8CSjLOPLl1kgzmR+ZWW5w8lV0HAnQ6jc0rzPSC6hdpysCZj1jkFGf?=
 =?us-ascii?Q?HWcH5WTrFmbi8Gujojki4BEG5beoz+pNX0hIIbTdU+39/wtW3B+My8/1jjwm?=
 =?us-ascii?Q?ZWKFUOe2TZ/9iLymoplt0fk2FsflaFVFOTaLRPoDbHyeqckK1j0buIUTorsS?=
 =?us-ascii?Q?YUioqLDOI5UYoHQg7HBXGFhvNsMJOADTbMdhAd8EMLAtJuNIbSSD+8rv7S0U?=
 =?us-ascii?Q?XnmT95GiY35ijqR8DIL6rgdzV6zzWf4HYuuuuQa2eak=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a159ce-6f4e-48d0-1b87-08d8a183cf03
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:31:15.6938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qW+7GSuq+xD7Dwf/FfmQVE4D0Zq7vCYlEAxP9hBEN9BjudC/Cnaihkxp6krkVuFg/RmFCqzVroqPbdVzXhsaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3029
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608096679; bh=/24++BJMrCKkZMRuIarcQnlytm3uSoYBGEkKZnm+SMI=;
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
        b=GzpdAqO+wIZGQBik4fLsLm3b4u/L8l+krpFUPgwuZfUNrrkUtjmvNShaNUTe+isn/
         898xMZp60jHgdKHIuoK13YZr5LzTkyI09iYaoGfrWxoxKYtooOFxzR++JbYsiWFQ5h
         fZtvnTwIhS1pEzVmt2M3CIvR8Bi2/0Yjj1vH62ecs15IvW2jB6ChbWHjCdOKUsHWPX
         laS1srS9Z7OJibXC8D3BhCt/wARO2nJbudxwbQBnjiD+2W6NUBmTmqzgV5auzRjrrx
         U5X8PgDtT6egfs0AZ7S8yglUwlPHdo8CRQrgxslRy/w8OOo+B8CGc+q+90A/YwLTyj
         nzDZCKoUItUMA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:21 AM
>=20
> On Tue, 15 Dec 2020 01:03:54 -0800 Saeed Mahameed wrote:
> > To handle SF port management outside of the eswitch as independent
> > software layer, introduce eswitch notifier APIs so that upper layer
> > who wish to support sf port management in switchdev mode can perform
> > its
>=20
> Could you unpack this? What's the "upper layer" software in this context?
>
Upper layer in this context =3D sf management layer within the mlx5 driver =
which implements devlink port add/del callbacks and state handling.
=20
> > task whenever eswitch mode is set to switchdev or before eswitch is
> > disabled.
>=20
> How does SF work if eswich is disabled?
>=20
It doesn't.
when eswitch is disabled, all SF ports gets destroyed through the eswitch e=
vent notifier.

> > Initialize sf port table on such eswitch event.
> >
> > Add SF port add and delete functionality in switchdev mode.
> > Destroy all SF ports when eswitch is disabled.
> > Expose SF port add and delete to user via devlink commands.
