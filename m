Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023072DCC23
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 06:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgLQFrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 00:47:36 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:6255 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgLQFrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 00:47:35 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdaf0cd0004>; Thu, 17 Dec 2020 13:46:54 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Dec
 2020 05:46:48 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Dec 2020 05:46:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfY32WeQyBZfznt8vn5eLXERyVS0WDIcK6qR9IvzB+buXlVjvP13ce6+sD1/bm9X2dMwEXUkJF2rqVRoWK6nvq1pbpMwQsKMmhTKp7aXF3IK8ZzRp1ZPvF0VJc4eUdVE0eEJxya63wYeHv7h7n5uduQCljMdTSXvn5b23oOtYc8I1wFliSAOHodC/VUG2BIp3pDBeZjzEVS5pvBejJT/G89061BjqKGFB/fya8+RCsqo3nI+s8Kk2SOOTV2LaHd2k3tUxog5OqxVebSUj5Es7GwvVEU7CJXiOzF3CGYqhREpLX7zXu/EZYhq7P3Iy86r/JmuFFxDUzNGcRJNqtH5Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiP9jDiy9GDf7zjdYNyxqFEd00KHEGR/etR18dKpMH8=;
 b=CTLqGVeHBNFR0JRBnEbuqY0Ng81mhN1pe0LSnBCJUPA/dvp2wkIG7k4AaybzEiifcssaxBX9ohXaDVUBZrNqHgQ7Y4zh1i84x+Q6UvjGWE4d78EKYTcGN1afpoJug/j3ERFZzAv3Z1LU5N/7uImIgjqXW/griysdfntQbMez2leAWL0d4RZrWT1Xe5tOov5s+C1Iaigl9R+MfBYDYjQqBJMnkw3CZG+iYgkLFmQ2G6czXq7DpoeEi38M/g/mUm5LYlM4S5QiTtgHrhDpfCrbMBgOCLI8mdM2smzdiVIRTXexeODiHvhtvjiQoWHLCx8WLGIZD1/5rhfWSrmw6UCnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3624.namprd12.prod.outlook.com (2603:10b6:a03:aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 05:46:45 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Thu, 17 Dec 2020
 05:46:45 +0000
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
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Topic: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Index: AQHW0sFH91yNDr98FE67ntr+TvpO06n44deAgABLWyCAAT7jAIAAV/Vg
Date:   Thu, 17 Dec 2020 05:46:45 +0000
Message-ID: <BY5PR12MB43229F0FB38429E826DE1060DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
        <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201216160850.78223a1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216160850.78223a1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 992cf414-adad-4386-1996-08d8a24f23c8
x-ms-traffictypediagnostic: BYAPR12MB3624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB36244F8054EE85CAA0B408B3DCC40@BYAPR12MB3624.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RqdP2syTFFgFdbc6BDQ+lquM/eHlf1kK+J70i7jsBREKeZblVSsxzT3WR/qESoUYgjEd6GZ2m6ljNOKgcc2pOOsnc+PhRiUCFiGnfBYuAUKIq83M155EmFFJacVnRD+aAi6KhjjwbMjAoBPZTM9ESgUwRg1aSRPfL6hzwWA9X3yaG/ibD5V3zHSEcA5USNHHk/LNhf9hQXbPkxZaYQRQsDOOv3wa0oikFSzKqVaziMlwf6q9L2tCvc+3Rst6ikNN/+AisraDOkHgpXe4UxYRS8T7TtcCMkDfvb5LQd7+/6bvOUIF5Vme+ErYeopACZs43RjpPY4yDRmIfZECRostlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(71200400001)(52536014)(55236004)(7416002)(8936002)(66446008)(4326008)(9686003)(2906002)(55016002)(8676002)(66476007)(6506007)(86362001)(66946007)(5660300002)(186003)(64756008)(107886003)(7696005)(6916009)(54906003)(83380400001)(26005)(478600001)(66556008)(33656002)(76116006)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QkiedJEHNlWAQyfiwiPjATr0wQwZM+DU42LeHjj1vv8u2dWQwsFLmpTlIlOU?=
 =?us-ascii?Q?L2wopOCYajuX99AEvHIW2T8QN1p1HJ02oKI8fRn1uAEPZWsuEQ2vL5mIkPxA?=
 =?us-ascii?Q?sCcqmj+PxvivwcTJXExXVvNM0KUS504O9ZJ6x8miS0DDnXCPQKcolNLsAHD+?=
 =?us-ascii?Q?KbSaMTQ+NUH0s18d1oZpnzf+2T64HxgP3Pnq5NvTIr7li4E1AznTi5RDYOc9?=
 =?us-ascii?Q?qixA2Wb43aiYtDB0InB5pNybV4l8DQ8omMWNfkABiLZ4GCvUSM0yhC4Dp0UF?=
 =?us-ascii?Q?Jizp0ij/NidaTySDiN1ehSFlMN+LQzUfJFtubI5SZ9aTIcGkBxNB0GA/I/Q8?=
 =?us-ascii?Q?LrCv/JBSjj/1n7a3yNXcfTb2ZWMxTg7LCTVio1Mi5LS1uGh232fWSY+VjvSo?=
 =?us-ascii?Q?vKtUWkOUmh3gWQSj7ftPAkE/XD6lfE8mTrRhzvY4Evnt4Fndvq49A/HuchL9?=
 =?us-ascii?Q?PCJU44u1fdKxS2RZLNzsZqcLd3PUToQ4fGu80YlV/yXM3qxSTpuVIhBPsYfp?=
 =?us-ascii?Q?H0Qqa5h/UkT+DtzxOzUtvHEYjr3CBPGMW9/V/hL8iQaB2GIuxRLJBgcqCrdR?=
 =?us-ascii?Q?dXRHjR/oXiOyRWI8smwPqwHFjbvy3+6HFz9/7XXjgsS2C52e4vefkJmXLK6D?=
 =?us-ascii?Q?IwPgu42nRDLoSui4pZMHJfHL077T6J0y4lEyXLngKHbFWKsdGWNoXDMj/FCz?=
 =?us-ascii?Q?1bDaTyzd2EXOITOL9MFM2Mdpb2E9Q0ni82sc3PLItOly/sS109rRFqZW0ptv?=
 =?us-ascii?Q?GGC7MpO766k9prqKnZjXqJp8sm36OsK+I8s8MNQbNBeqMAoWCl36m+dVotd9?=
 =?us-ascii?Q?thSxo4YoNLs7JWdZIteNFo05GXfSXHZJPVnTRsGqIT6Ui7syrgi3VfTFYoiK?=
 =?us-ascii?Q?Kuyrlx65Uj3BR5M/itgojcpNh5VGO3FLSH+doCa3CjsfHyKFM/nQ45zpQLbT?=
 =?us-ascii?Q?vUq8GWZZvfoRf3kR7V4bBteNsGzxnSLpUhwtmbIlCzg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992cf414-adad-4386-1996-08d8a24f23c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 05:46:45.7774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bT1PDd3MCmbsqX7o+sXoksPLg3c3MyeU5Ni15VIv/m+6oWliEOZD34ef5GwpjWx6Vxlz9rkvwcFGZgwaoPUaXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3624
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608184014; bh=HiP9jDiy9GDf7zjdYNyxqFEd00KHEGR/etR18dKpMH8=;
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
        b=K+DQ45VWffY2ixihBJE8kJKCpM3HkIBuDRo6519MDhXaEglEX+eiiGuVVtE5gAHC7
         pW1PX79jf9bT2/NSwjjfz/3Tx0FJ0YDPGiL68PURT8w/1zMYUrldIW2fdkasYFMZx1
         uPo365+YIIUSDA8gMS65Fqu3Sz/J/yvdMPKhiP5Wxp+fd87YRyVVBfhFZk33+cB8VT
         nHZQQwPy06ZOUu1rSpZbZKEYZyrSNY6H4ut9IUrnjDQ7QvLoqQ4x/Nvo8dGoRUdSSv
         MDMmrGd9YmF5CC5rUyvjALGg0M7bg7xQyqBljDZdOKgNOXnZrhP4TTsLDHCAtKNPCH
         rzWUy4JSkA2rg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 17, 2020 5:39 AM
>=20
> On Wed, 16 Dec 2020 05:15:04 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Wednesday, December 16, 2020 6:08 AM
> > >
> > > On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:
> > > > From: Parav Pandit <parav@nvidia.com>
> > > >
> > > > devlink port function can be in active or inactive state.
> > > > Allow users to get and set port function's state.
> > > >
> > > > When the port function it activated, its operational state may
> > > > change after a while when the device is created and driver binds to=
 it.
> > > > Similarly on deactivation flow.
> > >
> > > So what's the flow device should implement?
> > >
> > > User requests deactivated, the device sends a notification to the
> > > driver bound to the device. What if the driver ignores it?
> > >
> > If driver ignores it, those devices are marked unusable for new allocat=
ion.
> > Device becomes usable only after it has act on the event.
>=20
> But the device remains fully operational?
>=20
> So if I'm an admin who wants to unplug a misbehaving "entity"[1] the
> deactivate is not gonna help me, it's just a graceful hint?
Right.
> Is there no need for a forceful shutdown?
In this patchset, no. I didn't add the knob for it. It is already at 15 pat=
ches.
But yes, forceful shutdown extension can be done by the admin in future pat=
chset as,

$ devlink port del pci/0000:06:00.0/<port_index> force true
                                                                           =
              ^^^^^^^^
Above will be the extension in control of the admin.

>=20
> [1] refer to earlier email, IDK what entity is supposed to use this
>=20
While I was replying, Saeed already answered it.
> > Port function object is the one that represents function behind this po=
rt.
> > It is not a new term. Port function already exists in devlink whose
> operational state attribute is defined here.
>=20
> I must have missed that in review. PCI functions can host multiple ports.=
=20
This is exactly why I had "multiple networking ports" above to differentiat=
e it from devlink port.
And you asked me to drop 'networking' because devlink is all networking por=
ts, that creates this confusion.

Anyways, I will rewrite the commit message as 'function', instead of 'port =
function' as below.

New commit message snippet _start:
A function can be in active or inactive state. Allow users to get and set f=
unction's state.

When the function it activated, its operational state may change after a wh=
ile when the device is created and driver binds to it.
Similarly on deactivation flow.

To clearly describe the state of the function and its device's operational =
state in the host system, define state and opstate attributes.
_end.

> So
> "port function" does not compute for me. Can we drop the "function"?
No. it is better to keep it. Because it clearly distinguishes the host faci=
ng function whose attribute (mac) and state are controlled.
But I shorten the names, enums etc in code from port_function to port_fn. S=
o it should be readable now.
