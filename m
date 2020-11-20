Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9532BA154
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKTDuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:50:39 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:61535 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKTDui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 22:50:38 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb73d0d0001>; Fri, 20 Nov 2020 11:50:37 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 03:50:36 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 20 Nov 2020 03:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtHC2aThlAG3+okth7T3a3A6c1liW7bgPfdS8r+2j0Bc0inAdJCqAX1qtTsNKB1i+YVlaA5x4ir3CuyezfUYzNUfHu02l43jAR6h0+Xk/uS+QjLq9R4ZU7Q1tBk2NNZrUgpMpxWxPd0X8OXi8X8e9NmLCL9VPzKFusDjGKneLYamJzUPNQCg+DOgTdo792+q2vAxgqr8qofvrDu8FeQ4VCiPa/q9CFlchIExZQy7cKHGwmTPzW5ZFMX8bBEuQmroII7LQ0GxZ4kifqzJH53sIbj1hfvXOlGRZJfSXeVmMqxe8iPmy9PVuejpBAizTPc/fuQgUIo2Tgs+WXsrWJEe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmXp6UY52LUgQ+YPne6vwogLT+ac1GGAZxTuP/ektzY=;
 b=FKkbYcebx6OEjiU/IgSLnFmzo3lBjgE4Nxj0DLZhCE9CFRZD2Y2PLIs99JLf6Ffwh9yo/9gcF8HJkypGPmx3ukcnforifw3XqxEE+y5HS4yXM0YiT7Xx/fkOifHM9NcSBd32vz+C0aSmYkF9841gqVxSD0E14ZOry40nsq12NWmY6HOpT6fSS3pOi/OeRIX/XzqGMCsnq9QFUm7NGpWGbaGhQxRq4nFV0BRXWGE0yBVtmRBXEMkl9BwSWXKZWJaU5FrvcV68KECOime1X5tkd5CY8d8dgGUiciOg8U/P7BP0hIsJAO8bYG50xd9srmHxwEgQ9wkXryjkGRYJI4+C0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Fri, 20 Nov
 2020 03:50:34 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 03:50:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQgADolgCAAAJs8IACKiKAgABC7YCAAH/OgIAA48AAgAAA47A=
Date:   Fri, 20 Nov 2020 03:50:34 +0000
Message-ID: <BY5PR12MB4322FD44A4CF021627A9E841DCFF0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
        <20201119140017.GN244516@ziepe.ca>
 <20201119193526.014b968b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119193526.014b968b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [171.61.125.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bce7a384-fc6b-4ad4-7a28-08d88d076f60
x-ms-traffictypediagnostic: BY5PR12MB4228:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4228D0F80F9A3A6D2F5F4016DCFF0@BY5PR12MB4228.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XOQen6zQWBftMZXVp2wN7OPFjFMu5R555heuES/ffKvRzGZxAeCZVKjADv6w9cW/Ij2bAi7WYByaYUroILhZ8ruquKNPKpwTg5lD+Erk30HPWHQiA0KKUvqIOqUg+XmFNvNA0TqVYAAKBbmYiwgwFwTElvMkbvlODt0nIOKCYmCAeoWf0DLCWrcDgb6krPWMMdQlczkhIKwJJAKVPXyfMJ2u3VvSXIJmAQjiEh55gBB80apzCyY7f2VFJHf+6ffTKJN7FJr+57+GYFxQtsQPYIOuhhOXQ/VBvc1VLE1Cn89tjl+4FuO/+0y7ka7+NmTfHN2PPMxNkphqleVVUjxBMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(6636002)(9686003)(2906002)(83380400001)(8936002)(7696005)(86362001)(26005)(6506007)(33656002)(8676002)(316002)(186003)(54906003)(110136005)(66946007)(55016002)(478600001)(5660300002)(52536014)(4326008)(71200400001)(66556008)(66446008)(66476007)(64756008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ihChb6ieR8+4y5ebK8t8liW6RKypzJbR8f+Ke8zL7ylZ8CxoXYODzt3Pbfo/9UwCXi+p9vw/VO0/TPWcP7NKFYYpgg/1K839NRWNYc7irs6heJFVbjHxN5BtUS5RhoanIXXUzUwyICBRwwOGT4DZdR2NaiNFHHuxqo+8Gly4jbFBdS5Uw5LtCgP3xY+uQENDA38r2GAAfyXdcv2aJbUSSezShvGcr33Wl07eNXe76otPDSOs1ZA2+6avRzis9WZFLgliXzcJY91eruZBir+pypizIY2N5c8U28n752mQt+R0/ImC1Zb9OTGa72xRPNEDY2I2BFXGkM//zpZO5HqXnxFqqSnYvr2gGBRLs/XIZnGznrYeYAJP3jVNrcaaqbAJls+hIjw8M1ANipXimck8r9ZTa9DVoSr2EhidcjAe5QH+jnjJugQ+oX+uMMBva04AHNK6Ybf6p2fWHV4Z8F7CP3xriCjfkoRnTRx/FBFU3lyKL8AnYpkdxGgzOpnrlQ/gdFgNosuvMhJ1p8v41+sVCBKtDVUVS2tKYYXuYZ1GoNotkudg+XLflEIqj4A3zt1UGss6cFxO6kNs9iJM/Epb5oEzvC6vn5S8DZ7Z5cLtC5qTJ73oZE8dNqkuPvOYHryS7HFXOTlFn0ApEoFpMyUdtg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce7a384-fc6b-4ad4-7a28-08d88d076f60
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 03:50:34.5218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19IwsD7z7M16HMsPKcmS2iagaI9RwRkztohTmy+7JbInGQqc7nhskEVeS7OfKizvPP3wduDQ5wW+q489S6B7dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605844237; bh=xmXp6UY52LUgQ+YPne6vwogLT+ac1GGAZxTuP/ektzY=;
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
        b=CfaZynZxEYKxPoIkcU/xgPB9eW0o1ZDDJ3ccxRV/eXwphgrKdwGTLQzkW/mK0YQdO
         bZXT5Vrzb30Sc7p4FWQ3CxFObqvTpFsOqFr7cpUjIG8EF/W7fJGTMCjDriLpOuvlqD
         cjD3d8gekORbRBmrrRoD2TB7v0oIqodv0N53P+qweYdZ3bjph+kLhN2H1Ds+gHDR3Z
         YpcyCJ//BpQ9Dc5dHEfJyqxl5mU1g3FujkZeZC21q9VKHewsi9pEvdwzkQdRBNm1Bw
         ivZegrdzxcHXFMLzCngUsAL2gkZ9/mRojDAzOAtUunLHQ+dIhmYz4bzuMjlJZtqvNM
         lns2qB6fnfIiQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, November 20, 2020 9:05 AM
>=20
> On Thu, 19 Nov 2020 10:00:17 -0400 Jason Gunthorpe wrote:
> > Finally, in the mlx5 model VDPA is just an "application". It asks the
> > device to create a 'RDMA' raw ethernet packet QP that is uses rings
> > formed in the virtio-net specification. We can create it in the kernel
> > using mlx5_vdpa, and we can create it in userspace through the RDMA
> > subsystem. Like any "RDMA" application it is contained by the security
> > boundary of the PF/VF/SF the mlx5_core is running on.
>=20
> Thanks for the write up!
>=20
> The SF part is pretty clear to me, it is what it is. DPDK camp has been p=
retty
> excited about ADI/PASID for a while now.
>=20
>=20
> The part that's blurry to me is VDPA.
>=20
> I was under the impression that for VDPA the device is supposed to suppor=
t
> native virtio 2.0 (or whatever the "HW friendly" spec was).
>=20
> I believe that's what the early patches from Intel did.
>=20
> You're saying it's a client application like any other - do I understand =
it right that
> the hypervisor driver will be translating descriptors between virtio and =
device-
> native then?
>
mlx5 device support virtio descriptors natively. So no need of translation.
=20
> The vdpa parent is in the hypervisor correct?
>=20
Yep.=20

> Can a VDPA device have multiple children of the same type?
>
I guess, you mean VDPA parentdev? If so, yes, however at present we see onl=
y one_to_one mapping of vdpa device and parent dev.
=20
> Why do we have a representor for a SF, if the interface is actually VDPA?
Because vdpa is just one client out of multiple.
At the moment there is one to one relation of vdpa device to a SF/VF.

> Block and net traffic can't reasonably be treated the same by the switch.
>=20
> Also I'm confused how block device can bind to mlx5_core - in that case I=
'm
> assuming the QP is bound 1:1 with a QP on the SmartNIC side, and that QP =
is
> plugged into an appropriate backend?
So far there isn't mlx5_vdpa.ko or plan to do block. But yes, in future for=
 block, it needs to bind to a QP in backend in smartnic.
