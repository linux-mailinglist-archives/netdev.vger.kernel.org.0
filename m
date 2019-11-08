Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89108F4FB0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKHPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:30:08 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:28415
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfKHPaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:30:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6wuJioAtcSbg5Teoz2AjIrnIvCY6sbPoqsa9UHHJeL18O3uNpVmomq1FX/bZ7GMDVwJLfg5KI3eIL5GG1qp0SPN9TeAd/CIT0X1mlSe5PnN/TLTGj5xr5d41HDZVllczLCTkAMAg/osXtabObqXLnqzJ9CcOGP9S+z1XNMqhfHsu+LbJZH59vEKVTUjQe3QhWbfuHLASqj+3GqllYAp90bMtiiJdaVOKtCF2/wZu/IsLgehYa5GC41Gk/3LS9yDEIlUnmoEt4zKyGs2ShcUAQpsOM+f2HzvPOvUogpohC+lI6f22QFp3wbcKFkxg67+9sKsNwNAKY7T/GYU48R4yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoL3U2ihPj91G5dqSG3kG/QaeMskBDCAMQ5S2ULm8hw=;
 b=L6BHI6Qdzpt7X87d7yQ8p3vkee2soMsWnDpkvoF03d16cXs46SDaiFxkHsUROB9dMfh13L6WUdObLDFhyX0W0sBUSJLjmYeBGS6TsNENoj6S5eikN+ReotacnpYYVt0AhAqNuORL4uXqlxfkPqU2Itw/5E3k5RPyC4/kCQTvY/fDNfaCl6sRAh4VOwdWPliH8Pe6cQj9pTo6SLb2qhZPW1dlIQ/+lrRy/V10zMHJmw34PSTcXdqFf9f8XyAwj6nszsK7Pvl4VTf5R9ZSJ0YIEzv00ZKM0bZ8gWHSbEY+bh9JLoVcCsjB3RTrjxjsHA0w5LGiYThSqfraoj1UD3gqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoL3U2ihPj91G5dqSG3kG/QaeMskBDCAMQ5S2ULm8hw=;
 b=HBpwINVZw8FIJIC5RXrRMwn+kdP2VUA1HZugt2pt7B6uJh6qwQHNUheqz2tYaqyDAjrbCy3jE2HXaDFkS0AbAA+pL7uQJdu+zS3ee0K3SXWthSlSnmeR2eFcnnLKRq6Q2+9gC5PoezJMO4ZPjmml/u/9OxoP8NvtAjZ7DTwzAN0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6452.eurprd05.prod.outlook.com (20.179.34.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 15:29:24 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:29:24 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Christoph Hellwig <hch@infradead.org>
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
Thread-Index: AQHVlYXHkdSYLcgDMEK1TOINymJcnaeA0vKAgACQ6rA=
Date:   Fri, 8 Nov 2019 15:29:24 +0000
Message-ID: <AM0PR05MB48665E3E5F74EEF847E2F1E8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-16-parav@mellanox.com>
 <20191108063731.GA24679@infradead.org>
In-Reply-To: <20191108063731.GA24679@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14d85c3a-6776-4c67-1ecd-08d764606f3f
x-ms-traffictypediagnostic: AM0PR05MB6452:|AM0PR05MB6452:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB64520141C01AC4BABFDFB9A4D17B0@AM0PR05MB6452.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(199004)(189003)(13464003)(14444005)(316002)(52536014)(33656002)(8676002)(54906003)(6506007)(53546011)(476003)(486006)(7736002)(7696005)(81166006)(305945005)(5660300002)(9686003)(76176011)(8936002)(66446008)(66946007)(64756008)(76116006)(66556008)(74316002)(55016002)(4326008)(6246003)(6436002)(6916009)(71200400001)(81156014)(71190400001)(99286004)(86362001)(66476007)(25786009)(229853002)(256004)(14454004)(2906002)(186003)(46003)(478600001)(11346002)(102836004)(446003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6452;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u4T+JqPqlPbq/XvUCsIIYCKSJpNZ9UGxfrzK6cBDMiBtnLE8JHIV/DXugRBfmrzzTnOehPmMm8qsLZgJghd0UGtCQiMmeQO1kiOt4YpSXImuWyBDkbvr6SYXOEXcpTvQjyLlpO8EKl3HjvITU9zxti16bAdpn8e/7hvt6t9P2cO1eS+9Imymmv3Or9VjcDg6WNoyLdwmcOBJ7c8AIUNZ6QS1WYg0rRjx2xEqDBh5KoO3EcCiEVN34C6ksH4LB1jboMJ9L2VXz9JtWtkDRlSzQ27M0WHo6xgeeeRdhV+ZXv2xNJvwpbpD1z2u3PYScZSpOyTjJd+fcbuhusccugjjYbQSIC9XOfc3rg3hOD3h6CUEkZzNoUywD0r1fve9KgIBEkg3Bhqth/SE0zhIg5Cw1WsG8cr0we/ycl//jX61ojoIhKaJGy6G280qpzeEax6s
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d85c3a-6776-4c67-1ecd-08d764606f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:29:24.0821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xe21SpBiP1JORTfUvqapIZLhvInPMoK/0j6T4skoGYxqNLHteVhezZN0xpR/y2cmBhxNymrP4L+OzZ8YCpbqmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6452
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Friday, November 8, 2019 12:38 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.or=20
> Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and
> params for mediated device
>=20
> On Thu, Nov 07, 2019 at 10:08:31AM -0600, Parav Pandit wrote:
> > Implement dma ops wrapper to divert dma ops to its parent PCI device
> > because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.
>=20
> Yikes.  I've been trying hard to get rid of pointless dma_map_ops instanc=
e.
> What upper layers use these child devices, and why can't they just use th=
e
> parent device for dma mapping directly?

I certainly like to get rid of the dma_ops. Please let me know, if there is=
 better way. More details below.

Few upper layers that I know of are (a) NVME because this child devices are=
 rdma and (b) TCP as child device s netdevice.
Without dma ops setup, ULPs on top of RDMA device will be able to make use =
of it.

Modifying any non RDMA ULPs to refer to the parent because this child devic=
e is mdev will be obviously non-starter.
On netdev side, mlx5_core driver can always do dma mapping to the parent PC=
I device.

However, I wanted to avoid such implementation in mlx5_core driver.
Specially when it is taken care when iommu is disabled.
When IOMMU is enabled, find_domain() fails during dma_alloc_coherent() thro=
ugh intel_alloc_coherent() for the child devices.
Couldn't figure out what did I miss in device setup that leads to this fail=
ure.
dev.archdata.iommu is null for device on mdev device.
Further code reading hints IOMMU branches on dev_pci().
Until that is fixed,=20
1. we can get rid of dma ops, let mlx5_core refer to parent pci,
2. rdma will anyway refer to parent and ulps are ok
Or you have any inputs on how to debug this futher?
