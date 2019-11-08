Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3613FF5082
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKHQEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:04:02 -0500
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:32743
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726970AbfKHQEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:04:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiFX1B28rdMsryOoYvejiERpaTOL8HywsAipvreITWn9qLyxV/gP7J5JptU2zyXzL4VqCO9vC8OeOLObFzwTzp/q5gElH2SEXNO4Pby08TIaphLQxjduGgzxv6cDQKqyTBkf0aSbnj4TmcAyRlun1OoBX6Id9prK6YiEWATm79yS0I7iVQ1besfIq3gf9+CW1GtCib6vTHJB+OD5hFBVYdl8nAS+sOHBwFWYtjBquK6nz6RXIncyxgzM3gozZYnT8mkdTz3oOUndpzumr2mppbEaw30FXw3DZRxGyF0wjKgoH2uy55c4wpC89whA9OO66kNuFpNB9MA/vl78DfGtkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/CvOimaG+zLYeZVXU3H8CwmfvD4qBReHkLsMKhThzw=;
 b=LnSRGChbVekr83y7dJmnnY42ll2BfADNTWp+bNawi/JKSfywyNmtT4aowSEuP51omCrTQn0MztIji3u2qm5HmK6Y3oB2cNpxuWFMQL+wjI3vtnJFLRp+zSmMGdgvyk6SKVkU6IPQkcAysLC72hJidPpU37RA9s1KEz5Wbx1CZ4fH21Blgf83RKOX97jKAUTvFI64Lgf2CG2Mu9/Qjxc44MQb7hDWAnoDs0+bLjDNI0F+b3czyfwelh4o2dyNnGKqxVyM1Fu7FRNUgqEExexg7DQqYeLFrc906uuxx+KbD28bMvLESQCBbVaw46bzfCz3TmlP2/RwK2Bq8I2KCKXY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/CvOimaG+zLYeZVXU3H8CwmfvD4qBReHkLsMKhThzw=;
 b=FKHrXwsiBiGcygEE2RJXXpoezvebzM8rgeijuJMuKauJs4mf5uEGdNdSmYLqeuDB8p1l0TBGrcJoT/5a4l8ZnDHevPGh0/xoyuWD+nHo9JKxmcSbYY4aV+PCHzRJmb8UMmNiLAVzP1Pz+ISyRKeqQ55VXnHunlVNAJEAiu5tc4Y=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4129.eurprd05.prod.outlook.com (52.134.125.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 16:03:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:03:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev
 alias
Thread-Index: AQHVlYW2T1JUwVGvlESLvW+hfB15XaeBHzcAgABR0mA=
Date:   Fri, 8 Nov 2019 16:03:58 +0000
Message-ID: <AM0PR05MB4866A2D97171BDE4AC451B42D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-7-parav@mellanox.com>
 <20191108121030.5466dd3e.cohuck@redhat.com>
In-Reply-To: <20191108121030.5466dd3e.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 547e32c0-513d-46b4-7547-08d7646543cc
x-ms-traffictypediagnostic: AM0PR05MB4129:|AM0PR05MB4129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4129AF4FF70DF27F9C136EE4D17B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(13464003)(71190400001)(52536014)(71200400001)(6916009)(14454004)(2906002)(25786009)(229853002)(316002)(99286004)(66446008)(54906003)(6436002)(66946007)(64756008)(66556008)(66476007)(76116006)(74316002)(8676002)(5660300002)(46003)(81156014)(476003)(81166006)(8936002)(6116002)(486006)(53546011)(55016002)(6246003)(6506007)(7736002)(33656002)(9686003)(76176011)(14444005)(102836004)(7696005)(305945005)(4326008)(86362001)(446003)(11346002)(256004)(186003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4129;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjqY1TIgNKSSGCwu1rBVaPGzuRvEpn4329ujwoocja6IcHKi47+Mql7FVdU1RqaFN+AKp8I6kJ57Rh8hM8z82omu+SptNzNfUYxhgR8qeCvrUBFFHc5M/+v904wy4EeC9wyR8q9R4W5tePeMxkuYBn1/EZk8WRJRqwlmovqYEAdG0bT4tr/EjrNTsz1FmOJbbaS/2rVdc2v9JCzKQx99SCtnvXovNsrAYMUgIVcQzV+c0a3IC/tDaTnakBDF+7x1Fg7pzsTCnoGijY5T3/rS0LbUFVDjBPUokqnmpycBuJ5MA3N7r8d9kaE+fzFdqsU0XYgXubRJUQReMgkG6UtJi3Vn/mRD6MiF5xXYjxZGyUeAZUBmagjqE7A3HBj8HwwG1WBhBJWsz98CirE8njPsRnW1gnQ4184hWcxokLcCRpJPJqdIEx5+GjS5soVXxfb3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547e32c0-513d-46b4-7547-08d7646543cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:03:58.7342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 86jMZbXmX+lwI8L/eX7IVMlpOTeDTLV8zmJWAuYxb4V/jl21C4palTdeLinNTplMCSD8eRfJT/nTdjnwvF+ifA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cornelia,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, November 8, 2019 5:11 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev
> alias
>=20
> On Thu,  7 Nov 2019 10:08:22 -0600
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Some vendor drivers want an identifier for an mdev device that is
> > shorter than the UUID, due to length restrictions in the consumers of
> > that identifier.
> >
> > Add a callback that allows a vendor driver to request an alias of a
> > specified length to be generated for an mdev device. If generated,
> > that alias is checked for collisions.
> >
> > It is an optional attribute.
> > mdev alias is generated using sha1 from the mdev name.
> >
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 123
> ++++++++++++++++++++++++++++++-
> >  drivers/vfio/mdev/mdev_private.h |   5 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> >  include/linux/mdev.h             |   4 +
> >  4 files changed, 135 insertions(+), 10 deletions(-)
>=20
> Is this (or any of the other mdev alias patches) different from what I
> reviewed in the past?

No. It is not. They are same as what you already reviewed.
