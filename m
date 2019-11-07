Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979A1F3A8B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKGVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:30:48 -0500
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:43173
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfKGVar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 16:30:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0l96ssHOVukiKmfPkz0Bi1bkSvuN7SIQM+kJZoeB8I/jKi4H2v7bh91MEtpqjBYKD5nj+3mHXyAbIBodd1IdOIstHfRDEHPOtJmeqvG55rrWUmc26doTE0m9yBu9xqBixTqHla9Y5LzftBYpLhP/bzLcdl/OIv6vwkFdD1n0cjDoQxWqCbNMwesXtoKG4nM6NZ85Rc/cn8cHU8F4CDRGYaw5vN9yXwub+xq9K1JKlIclDyjcTmaSUXD+aXcaBBxdXVbXowU9vq48ex1CnbCU3mEqIELDONlsbpg/4LabYFBbSemFIZ7m8ipJF1f1wrpSXvdPQoBLtDCluIMx74lhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXbrmdEAqb3OZIiYWdCN68iy9WbAlX/G0ZbQ1MhKjrk=;
 b=fcDEfv2YzcbAlejMvO/Nzky+PvfVjGTqlPMrqLQBgaoWqDHLuvPqYjPC5gRUxOJCS8agUF3fybuRWpP2vpnNzDFBn/YGICB3U4Jw/AqMcO0lTjocO8djqxYdRZSQxZMRn4SmiUh30+Vdg+0oXnZMtOpuZZZ5ro+4wJxnQXn3XmrvnuHRk8JWDcC5IoT5LNTU8FayYEwuz/fiHuHhB9xk6PAmda2a/Rabb9wgcRjBRQgx5LzjwpXAt2v8Mt+pN+iCbDe+em43KXZtKUblWK2kDrilryMCMJxxsg87M8IX9vupso6OmuRcEDNuu96UE7uF/OZRAO7Qwt6s4vkuEJKJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXbrmdEAqb3OZIiYWdCN68iy9WbAlX/G0ZbQ1MhKjrk=;
 b=EyllDdOFhkZBMXkgxQV6HjT1AcQqE4NjqX9/w/Bn/fIJZWilpQdwsrR9+/cC0Wp+iS4kTLpzd2G618rCqyz8ctJwJACxeOEpTsD1ThJwzrl/IpG26VVPKMyB1erR8RDEjo+cylTv+v9+XLLyp1pMzbGGNaYAbBEWHgDJJF2Kacc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6322.eurprd05.prod.outlook.com (20.179.34.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 21:30:42 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 21:30:42 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params for
 mediated device
Thread-Topic: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params
 for mediated device
Thread-Index: AQHVlYXHkdSYLcgDMEK1TOINymJcnaeALNIAgAAGo5A=
Date:   Thu, 7 Nov 2019 21:30:41 +0000
Message-ID: <AM0PR05MB486634DCB2778C2DFDBF752FD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-16-parav@mellanox.com>
 <20191107154256.21629e5a@cakuba.netronome.com>
In-Reply-To: <20191107154256.21629e5a@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd15820f-7aad-417e-eb24-08d763c9bdd4
x-ms-traffictypediagnostic: AM0PR05MB6322:|AM0PR05MB6322:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB63226F1131D2A28034788B45D1780@AM0PR05MB6322.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(346002)(366004)(136003)(189003)(199004)(13464003)(8676002)(33656002)(476003)(486006)(53546011)(6506007)(6916009)(66066001)(7736002)(26005)(6436002)(102836004)(305945005)(9686003)(4326008)(76176011)(7696005)(8936002)(55016002)(74316002)(229853002)(81156014)(81166006)(256004)(11346002)(446003)(186003)(99286004)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(54906003)(25786009)(86362001)(316002)(2906002)(52536014)(6116002)(3846002)(5660300002)(6246003)(478600001)(14454004)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6322;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cgL2HYA2boK9D9czD3TR6+IqmZJKsdlkmEYKTnHY+0JAj09KMyRcOvkaO2sqd09hqQP64GiPmNSQNK+4o8rnZiXV3b26NNAcT4fpG4HWif3DKcll8pwaqPVarlSDqiDRpxCeIzCirF7ibEUwr9TOKDcSOLYhZuE8NJOv/ofkAfMVW3GZ6mIUPrRddHvXuw9nma4D/2nBTDs103ULXi+ERxCLS1nxrlF+n95JU/B1usK+fWOI34k8qNbMHy8Df5k2aDL4jsk9XxUY6R+/6Ho9RJkfTvuB0pEydaUyQXP6YLe1ZYA08ZRHQJF80G/l7esP29SOZSUQje7p9Ljyuo7aOHI62ug79XTA2tHiQE36P6cPzImXKushWI04pqVHZjgZfSAtF6H5Cbn3QC6gDxgkGH2vWKKsMnCnq+T9eg7CELfh2N8YZr3hPA6rElkRVwUv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd15820f-7aad-417e-eb24-08d763c9bdd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 21:30:41.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LvWV7zNBp6MUSUmgx7zTf5AcerSFA3vHXYCJE2dtbWafvI/j0TSYJb68yE2CdJv5jmEr3KTgo1tfp6Id8UB5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6322
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jakub Kicinski
> Sent: Thursday, November 7, 2019 2:43 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and param=
s
> for mediated device
>=20
> On Thu,  7 Nov 2019 10:08:31 -0600, Parav Pandit wrote:
> > Implement dma ops wrapper to divert dma ops to its parent PCI device
> > because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.
> >
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
>=20
> Isn't this supposed to use PASSID or whatnot? Could you explain a little?=
 This
> mdev stuff is pretty new to networking folks..

Currently series doesn't support PCI PASID.
While doing dma mapping, Intel IOMMU expects dma device to be PCI device in=
 few function traces like, find_or_alloc_domain(),=20
Since mdev bus is not a PCI bus, DMA mapping needs to go through its parent=
 PCI device.
Otherwise dma ops on mdev devices fails, as I think it fails to identify ho=
w to perform the translations.
(It doesn't seem to consult its parent device).
