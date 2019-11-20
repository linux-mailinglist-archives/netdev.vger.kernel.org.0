Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035811046A9
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfKTWjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:39:20 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:45285
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbfKTWjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:39:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jsg505b0ztZKQJpB+3mXKkSMCUHZqdqf9o8+PoTsft2NYNM3piX+rJpNQloYGr+29/wH9M34COJnIHzyw6xeeLpYXfGLJ0u9NyIXsuGdL7IETI11siaZJvcTuaIXWfoWydTBJ7p28yvVLK3pRmjHkpgZS6KABe30YAwvUPUogpfRkqg27jtVOxNu94jYWuX/sC8z9N56mYujf7/fReJIdk9pcNJ8bEJGrIcgMfZHW3zY3PL8t8rgR9j9wXswmOLPPqfilmmK2DtoWBHGBkDTtuMLlHokFo8ZOvu4RuwFgozeRF8cEG/cBzeDDlmQ5elRauOIGYAr3VanHMxnO3PFRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGIk8gTd5ViMoAcw4p/WsLt7obdUlzNG0mpUj3XcJ4o=;
 b=VgQnUogR2xNAS9yEzDFtjIbppMi2KqQ05KSxL+VTSfZnbR6U8SaZgo8CBTMZVUpJBti+RYQnhFdy2UBi/EiTZL5jqGihEqLTC1nOdf+yq2e1nuEzf1251CsqTEgN/ig0vgFWEsy4H75flHA2XgFoC/+W3r2vmAJi34qymT/xDwcaJw/M4dNMgmgR/BzqXdJcVxExosrN1IVGrmIgHimSD0otV+tZzmuFgK+GU9iNRWY58jodRJqC0f6Kffc5roy7wO8eebm3tHh64+9fp9FrElY0O3gM13crW13MxVlM58HlVCoVv0lc6TRwQVS/BxT2XuGgkaLyhCLVCZcMsOy7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGIk8gTd5ViMoAcw4p/WsLt7obdUlzNG0mpUj3XcJ4o=;
 b=rODFYtyGishjyqJWFzVmA+JbNgPH4mDMUf15R3vuXP5420ckq3Ilf6AZj8LgR1KWtVjygH4MeUP3vIALooFYUxMQ80Vj3vUfMmI5gkVpaaHTy78gpjqKyqSbdjNKgEswoMvZISiXGJqtcpzmwLjbmKyXR1iO4NJqpj0bNP8rz5A=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5650.eurprd05.prod.outlook.com (20.178.115.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 22:39:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 22:39:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0IAAJnyAgAAC1aCAAAnmgIAAmYYAgAAk7gCAAATGgIAAJoYAgAAbBYCAABJvgIAAGUuAgAAlAgCAAKHXgIAAQFwAgAALygCAAEINAIAABO/w
Date:   Wed, 20 Nov 2019 22:39:02 +0000
Message-ID: <AM0PR05MB48663ADB0A470C78694F6B8DD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191119164632.GA4991@ziepe.ca>
        <20191119134822-mutt-send-email-mst@kernel.org>
        <20191119191547.GL4991@ziepe.ca>
        <20191119163147-mutt-send-email-mst@kernel.org>
        <20191119231023.GN4991@ziepe.ca>
        <20191119191053-mutt-send-email-mst@kernel.org>
        <20191120014653.GR4991@ziepe.ca>
        <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
        <20191120133835.GC22515@ziepe.ca>       <20191120102856.7e01e2e2@x1.home>
        <20191120181108.GJ22515@ziepe.ca> <20191120150732.2fffa141@x1.home>
In-Reply-To: <20191120150732.2fffa141@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81f1233f-2522-4d75-6b38-08d76e0a711a
x-ms-traffictypediagnostic: AM0PR05MB5650:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <AM0PR05MB5650447EED21D70A3FDE7CECD14F0@AM0PR05MB5650.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(189003)(199004)(26005)(6306002)(55016002)(9686003)(5024004)(186003)(486006)(110136005)(4326008)(256004)(33656002)(99286004)(71190400001)(8676002)(54906003)(6436002)(71200400001)(6506007)(7696005)(25786009)(102836004)(478600001)(81166006)(966005)(81156014)(66066001)(86362001)(3846002)(76176011)(316002)(6116002)(229853002)(66446008)(66556008)(8936002)(5660300002)(66946007)(64756008)(66476007)(6246003)(14454004)(476003)(2906002)(52536014)(76116006)(7736002)(446003)(11346002)(305945005)(74316002)(561944003)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5650;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8/L6TV9lEBetwZu2pgaDkqGFrenFNR4YgqjancpZ5q3RZF1cfTTbHifJjwfL5aT+DMsAZLoZRrdymIEGFSQh/pmF7+ilErhP1aKRK+9xCFXMR7KoVReLU99yPZClgOmzgCzD8F/XgRpigS04QfhyJDPSI0Ede4Fk5p5vTE5gA1RL9y7zeG32hCeqJd9cID07rl+kh3KM2EKoF+ZU+tqy7NaOokrAb2mYt3YeByAs4KI6hurIjNeekxpz29EgbGIpWd0DX+gGYczU6eIhOjv6sVGyGRR+qzdGYoleP5/g+Tg0nQLJj3tAa/RGNhZAMUE4Ih4GCWXhHzFDT5y9Cf+SD3W/j03fwzOqnQQ3lKrocsFGNUS5/MLYeKOLQTc5ykNaTmUJd/YxqUk9tplemkhKemjKKcklKB1R8Qzql8x2qEr/+++wMv1i2X2XWvknSp+f+QGZ+cEtudG23NmmH/barwQDj+y4ieiKgQw4Z9rafs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f1233f-2522-4d75-6b38-08d76e0a711a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:39:02.0950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REoNIB2Lb6FuKSQhK6zln9GVKt8bTVKG4+eUtGzP3wroVAG6jH//uJkmWVNk86lmv1WGyNdEBUB/BkBe4jQ0mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, November 20, 2019 4:08 PM
>=20
> On Wed, 20 Nov 2019 14:11:08 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > I feel like mdev is suffering from mission creep. I see people
> > proposing to use mdev for many wild things, the Mellanox SF stuff in
> > the other thread and this 'virtio subsystem' being the two that have
> > come up publicly this month.
>=20
> Tell me about it... ;)
>=20
Initial Mellanox sub function proposal was done using dedicated non-mdev su=
bdev bus in [1] because mdev looked very vfio-ish.

Along the way mdev proposal was suggested at [2] by mdev maintainers to use=
.
The bus existed that detached two drivers (mdev and vfio_mdev), there was s=
ome motivation to attach other drivers.

After that we continued discussion and mdev extension using alias to have p=
ersistent naming in [3].

So far so good, but when we want to have actual use of mdev driver, it does=
n't look right. :-)

> > Putting some boundaries on mdev usage would really help people know
> > when to use it. My top two from this discussion would be:
> >
> > - mdev devices should only bind to vfio. It is not a general kernel
> >   driver matcher mechanism. It is not 'virtual-bus'.
>=20
So yes, we must define the scope of mdev and have right documentation to ca=
pture that.

If mdev is not supposed to be extended beyond vfio, why do you even need a =
bus? For iommu attachment?

[1] https://lkml.org/lkml/2019/3/1/19
[2] https://lkml.org/lkml/2019/3/7/696
[3] https://lkml.org/lkml/2019/8/26/854
