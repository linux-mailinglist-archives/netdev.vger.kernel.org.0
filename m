Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D1E2BA13C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKTDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:34:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3411 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKTDe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:34:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7394c0005>; Thu, 19 Nov 2020 19:34:36 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 03:34:25 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 20 Nov 2020 03:34:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bk8F49fbKZejzxkq7CFFBpvdcuerihlIth80jkS1WuVRGiIl8oSfDiTyVi7dxadJ6oQy+uX0V/Ud+yMVV4VL2Mzthcdwjhd9pxaypJBo8KC1Ysvwumh8/loL0ZCbm/XtdK7RgQ0JEgbc2CgotfMsiItLfDZA1Is/JTIbbipBSNNruUtUzB97x0r2L0cb7nhgcWFVUD8VUtUuEDTNeZMW3hRbl9q7XD/6goJvvKDc1bPuvCDzt7AepCKxkpy4k0HTZ/1IDW2P8zj8HZmsPBVU7je18O0QEufF/pMTakeqmJDqCeAJrBJSqewRxxOHnWa+q9HE9db4DW9puUtEdeR29w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXzY6zVX3kvyoltyF0Nw+KcYE45SFO8oj+OuBo0lO8k=;
 b=E0HAyxqRtMTRc6R2PuRHEGE6wfRYK+L7Gbc97z97pldyWNctat8LvgWzH9DUcffiGTmXiY/Hmw2lKoKaacMUDFarOPt4ThdOMt2QqdnD5pQDjWcTb6XXgwjXBgQnZsZ9AICd8HxayNLNDok00lr+1JWDI6g7vcK9fYygrU/gJrcO2GQktGqJ+MooHtn79GHTDfFhoTkSMJFI39dAl2JVjck+TsVS4JIJ2m6HmYpm275KJgqmGJK58APs7W889FnsgqY1gPPxbxWjmd7+eS/XQ2dDLgHoiC5EDzOt3WAZifI5WFNC0iaKKQBocc1PEP5vs17TaDFz1J3+BhBgrv8N5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4775.namprd12.prod.outlook.com (2603:10b6:a03:107::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 03:34:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 03:34:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQgADolgCAABuKAIACDoWAgABCfgCAAUTvgIAAH0Kw
Date:   Fri, 20 Nov 2020 03:34:24 +0000
Message-ID: <BY5PR12MB43226B04592F03E2D4E8A787DCFF0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201117184954.GV917484@nvidia.com>
        <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
 <20201119173521.204c4595@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119173521.204c4595@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [171.61.125.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc4fb5cc-e9e0-4001-02b3-08d88d052cf5
x-ms-traffictypediagnostic: BYAPR12MB4775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB477537791D28D41B9D2DE73DDCFF0@BYAPR12MB4775.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yg7f2PYLpWKRGwmtDNIH6HwAH9VCpqW5ghoI3GSWmTZ3oOohmH5ZtumCkQkfYYShjMBcfzeFB+WFUTlwd8GAg5VK6tR7sdiw0UvgQySvSFjKPZ0Aj7mWaalWWKrEDFKriYjNy2Np6ETLsQ6tcvb98uwjSwxQtvrm/T+qJEcQ4gC+Xv6KlooSK8WH1S76eI5VRMKkcTKyRLD5OMuq6P0DLi/HYEw8Fjy5bh1SrtZlt88RXq3Nh7+Is0e5GReT/xyXWde/RMpyi36LUMH2yewm3inX7HOtxlMmjEpdVbJI/BdofjZXLHpfJ4HdWQbCBtKYiLW94WYprTp5r2Lz6DId9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(52536014)(478600001)(2906002)(86362001)(55016002)(9686003)(4326008)(5660300002)(4744005)(71200400001)(66476007)(6506007)(33656002)(8936002)(7696005)(66946007)(26005)(316002)(186003)(66446008)(54906003)(76116006)(66556008)(8676002)(64756008)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: L0ua31N+iiMeDNynm9MCYEy4V9sbaT32C1jcirIFUVbXD7PrmL6zpyc6bqSrGY9wChMLPs0WdsnSMDA1zF3cBhzEJ3GV6YhAsIQUFzCHT+pyqLFq10kiICGkXqgg5qpkEAVFd3yQCeR8yzalgp/cfkT0ZKQ6TtRB5ZIOyHmI/HMzvOc6ozHKvtdy9U7Kedzcnc4bZuyp83vi/M6p97CB/Q3mMFaCu1tnPdQHW4r7ooxUB17T+cyo7DcB5/tjMIPz/HlkG2JT6DrgazR48baK3mxVwcY5l76/YZgiu6MSy3I32J+f6wGDWCl0K2y5i1WXv/Gky3P9AzqKTLrOD2O8CznN38dgVux3anQieYxeaa/JqCEEoVeIIVuwnQi7Fa9vtFvTT7K+bf13kov2fufgXb+6S7gCD5r306+IffF8GDDv4L9YTdBqCYSvSHBvUZAlsgKAuXFJau2Fzq3FZ6kqUWjKPEmLuJC2yZLDuDs5jaDhwUCH4LFYhsZAdt1Aj59Rx33A05ooRYYv+v8OCWdufxatVaJzD+3nTWeANcqZ38qqTWp32LkKTomBYPLUHkMk5XpQKwLymrUTnc3mI9r+Y5zODDIPV79ww1F+0kSdR28xvgf3GizlYkCMY93E/M2AUfRXdfLde/jugxITCyzRvw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4fb5cc-e9e0-4001-02b3-08d88d052cf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 03:34:24.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wyswg8mIMwCknisX7qSFQsEViSYIJv8JOahOE5xTrkHVl6NsRtMjRLXih0bTY4dUqv2YU2FUP5fJA1vmZruOdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4775
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605843276; bh=TXzY6zVX3kvyoltyF0Nw+KcYE45SFO8oj+OuBo0lO8k=;
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
        b=e/01MXMtWwIWxbIqaItPJKQTtt2I/vUTLmue9h6ChG373P0B9mOxacrArtgTkuwRC
         o3X26ZDh4HeV9Zn8hfsyRcYXsl3C5wUh9pLRTLilsA3xTSAfYv7AGw4ZdLnuKTwioU
         Zg422pFMAnAdmK68tgZ2PQh4X7ycuQYXYkwHi+QF8DzEe/mvCgSbblmHvI3J8akFee
         mTGEaUMrdBYR8DMBj3HyMtuGyGscJKjRELTRtjp1DM16+F4SV/TAK/XXJbm+G7zcrU
         zl6MJtqsU7zxTJDXL+Oel+5H2bJIIrj6H2u9A4C0nQVbiq/6rAUPgor9xPsHYJoZ3u
         cGQy41j+Br6AA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, November 20, 2020 7:05 AM
>=20
> On Wed, 18 Nov 2020 22:12:22 -0800 Saeed Mahameed wrote:
> > > Right, devices of other subsystems are fine, I don't care.
> >
> > But a netdev will be loaded on SF automatically just through the
> > current driver design and modularity, since SF =3D=3D VF and our netdev=
 is
> > abstract and doesn't know if it runs on a PF/VF/SF .. we literally
> > have to add code to not load a netdev on a SF. why ? :/
>=20
> A netdev is fine, but the examples so far don't make it clear (to me) if =
it's
> expected/supported to spawn _multiple_ netdevs from a single "vdpa
> parentdev".
We do not create Netdev from vdpa parentdev.
From vdpa parentdev, only vdpa device(s) are created which is 'struct devic=
e' residing in /sys/bus/vdpa/<device>.
Currently such vdpa device is already created on mlx5_vpa.ko driver load, h=
owever user has no way to inspect, stats, get/set features of this device, =
hence the vdpa tool.

